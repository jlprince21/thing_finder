import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:uuid/uuid.dart';

part 'database.g.dart';

class DbContainer extends Table {
  TextColumn get uniqueId => text().references(DbIndex, #uniqueId)();
  TextColumn get title => text()();
  TextColumn get description => text().nullable().named('description')();
  TextColumn get date => text()();

  @override
  Set<Column> get primaryKey => {uniqueId};
}

// Using just an id you can look up what it refers to eg 0 = item, 1 = container, 2 = place etc
class DbIndex extends Table {
  TextColumn get uniqueId => text()();
  IntColumn get type => integer()();

  @override
  Set<Column> get primaryKey => {uniqueId};
}

class DbItem extends Table {
  TextColumn get uniqueId => text().references(DbIndex, #uniqueId)();
  TextColumn get title => text()();
  TextColumn get description => text().nullable().named('description')();
  TextColumn get date => text()();

  @override
  Set<Column> get primaryKey => {uniqueId};
}

class DbLocation extends Table {
  TextColumn get uniqueId => text()();
  TextColumn get objectId => text().nullable().references(DbIndex, #uniqueId)();
  TextColumn get insideId => text().nullable().references(DbIndex, #uniqueId)();
  TextColumn get date => text()();

  @override
  Set<Column> get primaryKey => {uniqueId};
}

class DbPlace extends Table {
  TextColumn get uniqueId => text().references(DbIndex, #uniqueId)();
  TextColumn get title => text()();
  TextColumn get description => text().nullable().named('description')();
  TextColumn get date => text()();

  @override
  Set<Column> get primaryKey => {uniqueId};
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    // create the database file, called db.sqlite here, in the documents folder
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db.sqlite'));
    return NativeDatabase(file);
  });
}

@DriftDatabase(tables: [DbContainer, DbIndex, DbItem, DbLocation, DbPlace])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      beforeOpen: (details) async {
        // sample Drift code
        // if (details.wasCreated) {
        // }

        // needed to activate foreign keys as sqlite3 doesn't have them by default
        await customStatement('PRAGMA foreign_keys = ON');
      },
      onCreate: (Migrator m) async {
        await m.createAll();
      },
      onUpgrade: (Migrator m, int from, int to) async {
        if (from < 2) {
          // add the Places table
          await m.createTable(dbPlace);
        }
      },
    );
  }

  /* ---------------------------------------------------------------------------
   * Containers
   * -------------------------------------------------------------------------*/

  // import container
  Future<int> importContainer(DbContainerCompanion dbContainerCompanion) async {
    return await into(dbContainer).insert(dbContainerCompanion);
  }

  // create new container
  Future<int> createContainer(String title, String? description, String? placeId) async {
    var uuid = const Uuid();
    var id = uuid.v4();
    var date = DateFormat.yMMMd().format(DateTime.now());

    // insert into type table
    await into(dbIndex).insert(DbIndexCompanion(uniqueId: Value(id), type: Value(1)));

    // insert into container table
    await into(dbContainer).insert(DbContainerCompanion(date: Value(date), description: Value(description), title: Value(title), uniqueId: Value(id)));

    // make mapping in location table
    // TODO 2022-05-18 probably need to check if container id exists and make sure a null gets put in map if none passed in
    return await into(dbLocation).insert(DbLocationCompanion(date: Value(date), objectId: Value(id), insideId: Value(placeId), uniqueId: Value(uuid.v4())));
  }

  // retrieve all containers
  Future<List<DbContainerData>> getAllContainers() async {
    return await (select(dbContainer)..orderBy([(t) => OrderingTerm(expression: t.title.collate(Collate.noCase))])).get();
  }

  // update container
  Future<bool> updateContainer(DbContainerData dbContainerData, String? placeId) async {
    await update(dbContainer).replace(dbContainerData);

    var theMap = await  (select(dbLocation)..where((t) => t.objectId.equals(dbContainerData.uniqueId))).getSingle();

    return await update(dbLocation).replace(DbLocationData(date: DateFormat.yMMMd().format(DateTime.now()), uniqueId: theMap.uniqueId, insideId: placeId, objectId: dbContainerData.uniqueId));
  }

  // delete container
  // Future<int> deleteContainer(DbContainerData dbContainerData) async {
  //   (update(dbItem)
  //     ..where((t) => t.container.equals(dbContainerData.uniqueId))
  //   ).write(DbItemCompanion(
  //     container: Value(null),
  //   ));

  //   return await delete(dbContainer).delete(dbContainerData);
  // }

  // delete container by id
  Future<int> deleteContainerById(String containerId) async {
    await (delete(dbContainer)..where((t) => t.uniqueId.equals(containerId))).go();
    await (update(dbLocation)..where((t) => t.insideId.equals(containerId))).write(DbLocationCompanion(insideId: Value(null))); // item in container
    await (update(dbLocation)..where((t) => t.objectId.equals(containerId))).write(DbLocationCompanion(insideId: Value(null))); // container in a location (future plans) TODO should this be a delete instead?
    return await (delete(dbIndex)..where((t) => t.uniqueId.equals(containerId))).go();
  }

  // get specific container
  Future<DbContainerData> getContainer(String containerId) async {
    return await (select(dbContainer)..where((tbl) => tbl.uniqueId.equals(containerId))).getSingle();
  }

    // get specific container with enough data needed for the container details screen
  Future<ContainerMapped> getContainerDetails(String containerId) async {
    // TODO 2022-05-17 try Drift join syntax someday...
    var theContainer = await (select(dbContainer)..where((t) => t.uniqueId.equals(containerId))).getSingle();
    var theMap = await  (select(dbLocation)..where((t) => t.objectId.equals(containerId))).getSingle();

    DbPlaceData? thePlace;
    if (theMap != null && theMap.insideId != null)
    {
      thePlace = await  (select(dbPlace)..where((t) => t.uniqueId.equals(theMap.insideId!))).getSingle();
    }

    var results = ContainerMapped(theContainer, theMap, thePlace);
    return results;
  }

  // search for container
  Future<List<DbContainerData>> searchForContainers(String searchText) async {
    return await (select(dbContainer)..where((tbl) => tbl.title.like("%" + searchText + "%"))..orderBy([(t) => OrderingTerm(expression: t.title.collate(Collate.noCase))])).get();
  }

  /* ---------------------------------------------------------------------------
   * Items
   * -------------------------------------------------------------------------*/

  // import item
  Future<int> importItem(DbItemCompanion dbItemCompanion) async {
    return await into(dbItem).insert(dbItemCompanion);
  }

  // create new item
  Future<int> createItem(String title, String? description, String? containerId) async {
    var uuid = const Uuid();
    var id = uuid.v4();
    var date = DateFormat.yMMMd().format(DateTime.now());

    // insert into type table
    await into(dbIndex).insert(DbIndexCompanion(uniqueId: Value(id), type: Value(0)));

    // insert into item table
    await into(dbItem).insert(DbItemCompanion(date: Value(date), description: Value(description), title: Value(title), uniqueId: Value(id)));

    // make mapping in location table
    // TODO 2022-05-18 probably need to check if container id exists and make sure a null gets put in map if none passed in
    return await into(dbLocation).insert(DbLocationCompanion(date: Value(date), objectId: Value(id), insideId: Value(containerId), uniqueId: Value(uuid.v4())));
  }

  // retrieve all items
  Future<List<DbItemData>> getAllItems() async {
    return await (select(dbItem)..orderBy([(t) => OrderingTerm(expression: t.title.collate(Collate.noCase))])).get();
  }

  // update item
  // Future<bool> updateItem(DbItemData dbItemData) async {
  //   return await update(dbItem).replace(dbItemData);
  // }

  // update item
  Future<bool> updateItem(DbItemData dbItemData, String? containerId) async {
    await update(dbItem).replace(dbItemData);

    var theMap = await  (select(dbLocation)..where((t) => t.objectId.equals(dbItemData.uniqueId))).getSingle();

    return await update(dbLocation).replace(DbLocationData(date: DateFormat.yMMMd().format(DateTime.now()), uniqueId: theMap.uniqueId, insideId: containerId, objectId: dbItemData.uniqueId));
  }

  // delete item
  // Future<int> deleteItem(DbItemData dbItemData) async {
  //   return await delete(dbItem).delete(dbItemData);
  // }

  // delete item by id
  // Future<int> deleteItemById(String itemId) async {
  //   return await (delete(dbItem)..where((t) => t.uniqueId.equals(itemId))).go();
  // }

  // delete item by id
  Future<int> deleteItemById(String itemId) async {
    await (delete(dbItem)..where((t) => t.uniqueId.equals(itemId))).go();
    await (delete(dbLocation)..where((t) => t.objectId.equals(itemId))).go();
    return await (delete(dbIndex)..where((t) => t.uniqueId.equals(itemId))).go();
  }

  // search for items
  Future<List<DbItemData>> searchForItems(String searchText) async {
    return await (select(dbItem)..where((tbl) => tbl.title.like("%" + searchText + "%"))..orderBy([(t) => OrderingTerm(expression: t.title.collate(Collate.noCase))])).get();
  }

  // get specific item
  // Future<DbItemData> getItem(String itemId) async {
  //   print('get item');
  //   return await (select(dbItem)..where((t) => t.uniqueId.equals(itemId))).getSingle();
  // }

  // get specific item with enough data needed for the item details screen
  Future<ItemMapped> getItem(String itemId) async {
    // TODO 2022-05-17 try Drift join syntax someday...
    var theItem = await (select(dbItem)..where((t) => t.uniqueId.equals(itemId))).getSingle();
    var theMap = await  (select(dbLocation)..where((t) => t.objectId.equals(itemId))).getSingle();

    DbContainerData? theContainer;
    if (theMap != null && theMap.insideId != null)
    {
      theContainer = await  (select(dbContainer)..where((t) => t.uniqueId.equals(theMap.insideId!))).getSingle();
    }

    var results = ItemMapped(theItem, theMap, theContainer);
    return results;
  }

  /* ---------------------------------------------------------------------------
   * Locations
   * -------------------------------------------------------------------------*/

  // import location
  Future<int> importLocation(DbLocationCompanion dbLocationCompanion) async {
    return await into(dbLocation).insert(dbLocationCompanion);
  }

  /* ---------------------------------------------------------------------------
   * Places
   * -------------------------------------------------------------------------*/

  // retrieve all places
  Future<List<DbPlaceData>> getAllPlaces() async {
    return await (select(dbPlace)..orderBy([(t) => OrderingTerm(expression: t.title.collate(Collate.noCase))])).get();
  }

  // create new place
  Future<int> createPlace(String title, String? description) async {
    var uuid = const Uuid();
    var id = uuid.v4();
    var date = DateFormat.yMMMd().format(DateTime.now());

    // insert into type table
    await into(dbIndex).insert(DbIndexCompanion(uniqueId: Value(id), type: Value(2)));

    // insert into place table
    return await into(dbPlace).insert(DbPlaceCompanion(date: Value(date), description: Value(description), title: Value(title), uniqueId: Value(id)));
  }

  // delete place by id
  Future<int> deletePlaceById(String placeId) async {
    await (delete(dbPlace)..where((t) => t.uniqueId.equals(placeId))).go();
    await (update(dbLocation)..where((t) => t.insideId.equals(placeId))).write(DbLocationCompanion(insideId: Value(null))); // item or container in a place TODO should this be a delete instead?
    // await (update(dbLocation)..where((t) => t.objectId.equals(containerId))).write(DbLocationCompanion(insideId: Value(null))); // container in a location (future plans) TODO should this be a delete instead?
    return await (delete(dbIndex)..where((t) => t.uniqueId.equals(placeId))).go();
  }

  // get specific place
  Future<DbPlaceData> getPlace(String placeId) async {
    return await (select(dbPlace)..where((tbl) => tbl.uniqueId.equals(placeId))).getSingle();
  }

  // search for place
  Future<List<DbPlaceData>> searchForPlaces(String searchText) async {
    return await (select(dbPlace)..where((tbl) => tbl.title.like("%" + searchText + "%"))..orderBy([(t) => OrderingTerm(expression: t.title.collate(Collate.noCase))])).get();
  }

  // update place
  Future<bool> updatePlace(DbPlaceData dbPlaceData) async {
    return await update(dbPlace).replace(dbPlaceData);
  }

  /* ---------------------------------------------------------------------------
   * Types
   * -------------------------------------------------------------------------*/

  // import type
  Future<int> importType(DbIndexCompanion dbIndexCompanion) async {
    return await into(dbIndex).insert(dbIndexCompanion);
  }

  /* ---------------------------------------------------------------------------
   * Everything Else
   * -------------------------------------------------------------------------*/

  // get all items in a particular container
  // Future<List<DbItemData>> getContainerContents(String containerId) async {
  //   return await (select(dbItem)..where((tbl) => tbl.container.like("%" + containerId + "%"))).get();
  // }

  // get all items in a particular container
  Future<List<DbItemData>> getContainerContents(String containerId) async {
    // TODO 2022-05-18 a join would be really nice here too

    var maps = await (select(dbLocation)..where((tbl) => tbl.insideId.like("%" + containerId + "%"))).get();
    List<String> ids = [];

    maps.forEach((element) {
      ids.add(element.objectId ?? "");
    });

    // return await (select(dbItem)..where((tbl) => tbl.uniqueId.like("%" + containerId + "%"))).get();
    return await (select(dbItem)..where((tbl) => tbl.uniqueId.isIn(ids))).get();
  }


}

class ItemMapped {
  ItemMapped(this.item, this.mapping, this.container);

  final DbItemData item;
  final DbLocationData? mapping;
  final DbContainerData? container;
}

class ContainerMapped {
  ContainerMapped(this.container, this.mapping, this.place);

  final DbContainerData container;
  final DbLocationData? mapping;
  final DbPlaceData? place;
}