import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

part 'database.g.dart';

class DbContainer extends Table {
  TextColumn get uniqueId => text()();
  TextColumn get title => text()();
  TextColumn get description => text().nullable().named('description')();
  TextColumn get date => text()();

  // designates the primary key for the table
  @override
  Set<Column> get primaryKey => {uniqueId};
}

class DbItem extends Table {
  TextColumn get uniqueId => text()();
  TextColumn get container => text().nullable().references(DbContainer, #uniqueId)();
  TextColumn get title => text()();
  TextColumn get description => text().nullable().named('description')();
  TextColumn get date => text()();

  // designates the primary key for the table
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

@DriftDatabase(tables: [DbContainer, DbItem])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  /* ---------------------------------------------------------------------------
   * Containers
   * -------------------------------------------------------------------------*/

  // create new container
  Future<int> createContainer(DbContainerCompanion dbContainerCompanion) async {
    return await into(dbContainer).insert(dbContainerCompanion);
  }

  // retrieve all containers
  Future<List<DbContainerData>> getAllContainers() async {
    return await (select(dbContainer)..orderBy([(t) => OrderingTerm(expression: t.title.collate(Collate.noCase))])).get();
  }

  // update container
  Future<bool> updateContainer(DbContainerData dbContainerData) async {
    return await update(dbContainer).replace(dbContainerData);
  }

  // delete container
  Future<int> deleteContainer(DbContainerData dbContainerData) async {
    (update(dbItem)
      ..where((t) => t.container.equals(dbContainerData.uniqueId))
    ).write(DbItemCompanion(
      container: Value(null),
    ));

    return await delete(dbContainer).delete(dbContainerData);
  }

    // delete container by id
  Future<int> deleteContainerById(String containerId) async {
    return await (delete(dbContainer)..where((t) => t.uniqueId.equals(containerId))).go();
  }

  // get specific container
  Future<DbContainerData> getContainer(String containerId) async {
    return await (select(dbContainer)..where((tbl) => tbl.uniqueId.equals(containerId))).getSingle();
  }

  // search for container
  Future<List<DbContainerData>> searchForContainers(String searchText) async {
    return await (select(dbContainer)..where((tbl) => tbl.title.like("%" + searchText + "%"))..orderBy([(t) => OrderingTerm(expression: t.title.collate(Collate.noCase))])).get();
  }

  /* ---------------------------------------------------------------------------
   * Items
   * -------------------------------------------------------------------------*/

  // create new item
  Future<int> createItem(DbItemCompanion dbItemCompanion) async {
    return await into(dbItem).insert(dbItemCompanion);
  }

  // retrieve all items
  Future<List<DbItemData>> getAllItems() async {
    return await (select(dbItem)..orderBy([(t) => OrderingTerm(expression: t.title.collate(Collate.noCase))])).get();
  }

  // update item
  Future<bool> updateItem(DbItemData dbItemData) async {
    return await update(dbItem).replace(dbItemData);
  }

  // delete item
  Future<int> deleteItem(DbItemData dbItemData) async {
    return await delete(dbItem).delete(dbItemData);
  }

  // delete item by id
  Future<int> deleteItemById(String itemId) async {
    return await (delete(dbItem)..where((t) => t.uniqueId.equals(itemId))).go();
  }

  // search for items
  Future<List<DbItemData>> searchForItems(String searchText) async {
    return await (select(dbItem)..where((tbl) => tbl.title.like("%" + searchText + "%"))..orderBy([(t) => OrderingTerm(expression: t.title.collate(Collate.noCase))])).get();
  }

  // get specific item
  Future<DbItemData> getItem(String itemId) async {
    return await (select(dbItem)..where((t) => t.uniqueId.equals(itemId))).getSingle();
  }

  // get all items in a particular container
  Future<List<DbItemData>> getContainerContents(String containerId) async {
    return await (select(dbItem)..where((tbl) => tbl.container.like("%" + containerId + "%"))).get();
  }
}
