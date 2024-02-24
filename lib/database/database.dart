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

        // activate foreign keys as sqlite3 doesn't have them by default
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
    await into(dbIndex).insert(DbIndexCompanion(uniqueId: Value(id), type: Value(Differentiator.container.value)));

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

  // delete container by id
  Future<int> deleteContainerById(String containerId) async {
    await (delete(dbContainer)..where((t) => t.uniqueId.equals(containerId))).go();
    await (delete(dbLocation)..where((t) => t.insideId.equals(containerId))).go(); // item in container
    await (delete(dbLocation)..where((t) => t.objectId.equals(containerId))).go(); // container in a location (future plans)
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

    DbLocationData? theMap;

    try {
      theMap = await  (select(dbLocation)..where((t) => t.objectId.equals(containerId))).getSingleOrNull();
    }
    catch (e)
    {
      // 2022-10-15 TODO For old versions of code this removes duplicate rows
      // dedicated to a single item/container caused in previous query. It would
      // be nice to remove the need for this someday.
      await (delete(dbLocation)..where((t) => t.objectId.equals(containerId))).go();
    }

    DbPlaceData? thePlace;
    if (theMap != null && theMap.insideId != null)
    {
      thePlace = await  (select(dbPlace)..where((t) => t.uniqueId.equals(theMap!.insideId!))).getSingle();
    }
    else if (theMap == null)
    {
      // prevent missing row for Location table
      createLocationForObjectOnly(containerId);
    }

    var results = ContainerMapped(theContainer, theMap, thePlace);
    return results;
  }

  // search for container
  Future<List<DbContainerData>> searchForContainers(String searchText) async {
    return await (select(dbContainer)..where((tbl) => tbl.title.like("%$searchText%"))..orderBy([(t) => OrderingTerm(expression: t.title.collate(Collate.noCase))])).get();
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
    await into(dbIndex).insert(DbIndexCompanion(uniqueId: Value(id), type: Value(Differentiator.item.value)));

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
  Future<bool> updateItem(DbItemData dbItemData, String? containerId) async {
    await update(dbItem).replace(dbItemData);

    var theMap = await  (select(dbLocation)..where((t) => t.objectId.equals(dbItemData.uniqueId))).getSingle();

    return await update(dbLocation).replace(DbLocationData(date: DateFormat.yMMMd().format(DateTime.now()), uniqueId: theMap.uniqueId, insideId: containerId, objectId: dbItemData.uniqueId));
  }

  // delete item by id
  Future<int> deleteItemById(String itemId) async {
    await (delete(dbItem)..where((t) => t.uniqueId.equals(itemId))).go();
    await (delete(dbLocation)..where((t) => t.objectId.equals(itemId))).go();
    return await (delete(dbIndex)..where((t) => t.uniqueId.equals(itemId))).go();
  }

  // search for items
  Future<List<DbItemData>> searchForItems(String searchText) async {
    return await (select(dbItem)..where((tbl) => tbl.title.like("%$searchText%"))..orderBy([(t) => OrderingTerm(expression: t.title.collate(Collate.noCase))])).get();
  }

  // get specific item with enough data needed for the item details screen
  Future<ItemMapped> getItemDetails(String itemId) async {
    // TODO 2022-05-17 try Drift join syntax someday...
    var theItem = await (select(dbItem)..where((t) => t.uniqueId.equals(itemId))).getSingle();

    DbLocationData? theMap;

    try {
      theMap = await  (select(dbLocation)..where((t) => t.objectId.equals(itemId))).getSingleOrNull();
    }
    catch (e)
    {
      // 2022-10-15 TODO For old versions of code this removes duplicate rows
      // dedicated to a single item/container caused in previous query. It would
      // be nice to remove the need for this someday.
      await (delete(dbLocation)..where((t) => t.objectId.equals(itemId))).go();
    }

    GenericItemContainerOrPlace? theContainerOrPlace;
    if (theMap != null && theMap.insideId != null)
    {
      theContainerOrPlace = await getContainerOrPlace(theMap.insideId!);
    }
    else if (theMap == null)
    {
      // prevent missing row for Location table
      createLocationForObjectOnly(itemId);
    }

    var results = ItemMapped(theItem, theMap, theContainerOrPlace);
    return results;
  }

  /* ---------------------------------------------------------------------------
   * Locations
   * -------------------------------------------------------------------------*/

  // import location
  Future<int> importLocation(DbLocationCompanion dbLocationCompanion) async {
    return await into(dbLocation).insert(dbLocationCompanion);
  }

  Future<int> createLocationForObjectOnly(String objectId) async {
    // 2022-10-15 if a place or container has been deleted, it will have rows deleted
    // in Location table. Items and Containers will need empty rows re-created
    // from time to time and this method is a lazy alternative to iterating over
    // all of them each time one is deleted.
    var date = DateFormat.yMMMd().format(DateTime.now());
    var uuid = const Uuid();
    return await into(dbLocation).insert(DbLocationCompanion(date: Value(date), objectId: Value(objectId), insideId: const Value(null), uniqueId: Value(uuid.v4())));
  }

  /* ---------------------------------------------------------------------------
   * Places
   * -------------------------------------------------------------------------*/

  // import place
  Future<int> importPlace(DbPlaceCompanion dbPlaceCompanion) async {
    return await into(dbPlace).insert(dbPlaceCompanion);
  }

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
    await into(dbIndex).insert(DbIndexCompanion(uniqueId: Value(id), type: Value(Differentiator.place.value)));

    // insert into place table
    return await into(dbPlace).insert(DbPlaceCompanion(date: Value(date), description: Value(description), title: Value(title), uniqueId: Value(id)));
  }

  // delete place by id
  Future<int> deletePlaceById(String placeId) async {
    await (delete(dbPlace)..where((t) => t.uniqueId.equals(placeId))).go();
    await (delete(dbLocation)..where((t) => t.insideId.equals(placeId))).go(); // item or container in a place
    return await (delete(dbIndex)..where((t) => t.uniqueId.equals(placeId))).go();
  }

  // get specific place
  Future<DbPlaceData> getPlace(String placeId) async {
    return await (select(dbPlace)..where((tbl) => tbl.uniqueId.equals(placeId))).getSingle();
  }

  // search for place
  Future<List<DbPlaceData>> searchForPlaces(String searchText) async {
    return await (select(dbPlace)..where((tbl) => tbl.title.like("%$searchText%"))..orderBy([(t) => OrderingTerm(expression: t.title.collate(Collate.noCase))])).get();
  }

  // update place
  Future<bool> updatePlace(DbPlaceData dbPlaceData) async {
    return await update(dbPlace).replace(dbPlaceData);
  }

  /* ---------------------------------------------------------------------------
   * Types
   * -------------------------------------------------------------------------*/

  // import type
  Future<int> importIndex(DbIndexCompanion dbIndexCompanion) async {
    return await into(dbIndex).insert(dbIndexCompanion);
  }

  /* ---------------------------------------------------------------------------
   * Everything Else
   * -------------------------------------------------------------------------*/

  // get all items in a particular container
  Future<List<DbItemData>> getContainerContents(String containerId) async {
    // TODO 2022-05-18 a join would be really nice here too
    var maps = await (select(dbLocation)..where((tbl) => tbl.insideId.like("%$containerId%"))).get();
    List<String> ids = [];

    for (var element in maps) {
      ids.add(element.objectId ?? "");
    }

    return await (select(dbItem)..where((tbl) => tbl.uniqueId.isIn(ids))).get();
  }

  // retrieve all containers and places
  Future<ContainersAndPlaces> getAllContainersAndPlaces() async {
    var containers = await (select(dbContainer)..orderBy([(t) => OrderingTerm(expression: t.title.collate(Collate.noCase))])).get();
    var places = await (select(dbPlace)..orderBy([(t) => OrderingTerm(expression: t.title.collate(Collate.noCase))])).get();

    var results = ContainersAndPlaces(containers, places);
    return results;
  }

  // retrieve specific container or place
  Future<GenericItemContainerOrPlace> getContainerOrPlace(String containerOrPlaceId) async {
    var index = await (select(dbIndex)..where((tbl) => tbl.uniqueId.equals(containerOrPlaceId))).getSingle();

    if (index.type == Differentiator.container.value) // container
    {
      var container = await getContainer(index.uniqueId);
      return GenericItemContainerOrPlace(container.uniqueId, container.title, container.description, container.date, Differentiator.container);
    }
    else if (index.type ==  Differentiator.place.value) // place
    {
      var place = await getPlace(index.uniqueId);
      return GenericItemContainerOrPlace(place.uniqueId, place.title, place.description, place.date, Differentiator.place);
    }

    return GenericItemContainerOrPlace("", "", "", "", Differentiator.unknown);
  }

  // get all containers and items in a particular place
  Future<List<GenericItemContainerOrPlace>> getPlaceContents(String placeId) async {
    // TODO 2022-05-18 a join would be really nice here too
    var maps = await (select(dbLocation)..where((tbl) => tbl.insideId.like("%$placeId%"))).get();
    List<String> ids = [];

    for (var element in maps) {
      ids.add(element.objectId ?? "");
    }

    var items = await (select(dbItem)..where((tbl) => tbl.uniqueId.isIn(ids))..orderBy([(t) => OrderingTerm(expression: t.title.collate(Collate.noCase))])).get();
    var containers = await (select(dbContainer)..where((tbl) => tbl.uniqueId.isIn(ids))..orderBy([(t) => OrderingTerm(expression: t.title.collate(Collate.noCase))])).get();

    List<GenericItemContainerOrPlace> theList = [];

    for (var element in items) {
      theList.add(GenericItemContainerOrPlace(element.uniqueId, element.title, element.description, element.date, Differentiator.item));
    }

    for (var element in containers) {
      theList.add(GenericItemContainerOrPlace(element.uniqueId, element.title, element.description, element.date, Differentiator.container));
    }

    return theList;
  }

  deleteAllData()
  {
    delete(dbPlace).go();
    delete(dbItem).go();
    delete(dbContainer).go();
    delete(dbLocation).go();
    delete(dbIndex).go();
  }
}

class ContainersAndPlaces {
  ContainersAndPlaces(this.containers, this.places);

  final List<DbContainerData> containers;
  final List<DbPlaceData> places;
}

class ItemMapped {
  ItemMapped(this.item, this.mapping, this.containerOrPlace);

  final DbItemData item;
  final DbLocationData? mapping;
  final GenericItemContainerOrPlace? containerOrPlace;
}

class ContainerMapped {
  ContainerMapped(this.container, this.mapping, this.place);

  final DbContainerData container;
  final DbLocationData? mapping;
  final DbPlaceData? place;
}

class GenericItemContainerOrPlace {
  GenericItemContainerOrPlace(this.uniqueId, this.title, this.description, this.date, this.thingType);

  final String uniqueId;
  final String title;
  final String? description;
  final String date;

  final Differentiator thingType;
}

enum Differentiator {
  item(0),
  container(1),
  place(2),
  unknown(3);


  const Differentiator(this.value);
  final int value;
}