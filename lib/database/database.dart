import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

part 'database.g.dart';

class DbContainer extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get uniqueId => text()();
  TextColumn get title => text()();
  TextColumn get description => text().named('description')();
  TextColumn get date => text()();
}

class DbItem extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get uniqueId => text()();
  IntColumn get container => integer().nullable().references(DbContainer, #uniqueId)();
  TextColumn get title => text()();
  TextColumn get description => text().named('description')();
  TextColumn get date => text()();
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
    return await select(dbContainer).get();
  }

  // update container
  Future<bool> updateContainer(DbContainerData dbContainerData) async {
    return await update(dbContainer).replace(dbContainerData);
  }

  // delete container
  Future<int> deleteContainer(DbContainerData dbContainerData) async {
    return await delete(dbContainer).delete(dbContainerData);
  }

  Future<DbContainerData> getContainer(int containerId) async {
    return await (select(dbContainer)..where((tbl) => tbl.id.equals(containerId))).getSingle();
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
    return await select(dbItem).get();
  }

  // update item
  Future<bool> updateItem(DbItemData dbItemData) async {
    return await update(dbItem).replace(dbItemData);
  }

  // delete item
  Future<int> deleteItem(DbItemData dbItemData) async {
    return await delete(dbItem).delete(dbItemData);
  }
}
