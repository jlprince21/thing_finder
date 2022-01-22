import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

part 'database.g.dart';

class DbContainer extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text()();
  TextColumn get description => text().named('description')();
  TextColumn get date => text()();
}

class DbItem extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get container => integer().nullable().references(DbContainer, #id)();
  TextColumn get title => text()();
  TextColumn get description => text().named('description')();
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
}
