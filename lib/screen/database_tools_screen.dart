import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart' as dr;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:thing_finder/database/database.dart';
import 'package:thing_finder/util/app_drawer.dart';

class DatabaseToolsScreen extends StatelessWidget {
  late AppDatabase appDatabase;

  DatabaseToolsScreen();

  @override
  Widget build(BuildContext context) {
    appDatabase = Provider.of<AppDatabase>(context);

    return Scaffold(
      appBar: _getAppBar(),
      drawer: AppDrawer(),
      body: ListView(
        children: [
          ListTile(
            title: const Text('Export DB'),
            onTap: () {
              exportDatabase();
            },
          ),

          ListTile(
            title: const Text('Import Containers to DB'),
            onTap: () {
              _pickFile("container");
            },
          ),

          ListTile(
            title: const Text('Import Indexes to DB'),
            onTap: () {
              _pickFile("index");
            },
          ),

          ListTile(
            title: const Text('Import Items to DB'),
            onTap: () {
              _pickFile("item");
            },
          ),

          ListTile(
            title: const Text('Import Locations to DB'),
            onTap: () {
              _pickFile("location");
            },
          ),
        ],
      ),
    );
  }

  ButtonStyle getButtonStyle() {
    return ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12), // <-- Radius
                    ));
  }

  _getAppBar(){
    return AppBar(
      // backgroundColor: Colors.white,
      centerTitle: true,
      elevation: 0,
      title: const Text(
        'Database Tools',
        // style: Theme.of(context).textTheme.headline5,
      ),
    );
  }

  _createContainer(String line) {
    // TODO using a CSV parser may make this easier
    final split = line.split('|');
    final Map<int, String> values = {
      for (int i = 0; i < split.length; i++)
        i: split[i]
    };
    print(values);

    final containerId = values[0];
    final containerTitle = values[1];
    final containerDescription = values[2];
    final containerDate = values[3];

    appDatabase
      .importContainer(DbContainerCompanion(
        uniqueId: dr.Value(containerId!),
        title: dr.Value(containerTitle!),
        description: containerDescription == null ? dr.Value(null) : dr.Value(containerDescription),
        date: dr.Value(containerDate!),
        ));
  }

  _createIndex(String line) {
    // TODO using a CSV parser may make this easier
    final split = line.split('|');
    final Map<int, String> values = {
      for (int i = 0; i < split.length; i++)
        i: split[i]
    };
    print(values);

    final indexId = values[0];
    final type = int.tryParse(values[1]!); // TODO 2022-05-21 risky code here

    appDatabase
      .importType(DbIndexCompanion(
        uniqueId: dr.Value(indexId!),
        type: dr.Value(type!),
        ));
  }

  _createItem(String line) {
    // TODO using a CSV parser may make this easier
    final split = line.split('|');
    final Map<int, String> values = {
      for (int i = 0; i < split.length; i++)
        i: split[i]
    };
    print(values);

    final itemId = values[0];
    final itemTitle = values[1];
    final itemDescription = values[2];
    final itemDate = values[3];

    appDatabase.importItem(DbItemCompanion(
      uniqueId: dr.Value(itemId!),
      title: dr.Value(itemTitle!),
      description: itemDescription == null ? dr.Value(null) : dr.Value(itemDescription),
      date: dr.Value(itemDate!),
    ));
  }

  _createLocation(String line) {
    // TODO using a CSV parser may make this easier
    final split = line.split('|');
    final Map<int, String> values = {
      for (int i = 0; i < split.length; i++)
        i: split[i]
    };
    print(values);

    final uniqueId = values[0];
    final objectId = values[1];
    final insideId = values[2];
    final date = values[3];

    appDatabase
      .importLocation(DbLocationCompanion(
        uniqueId: dr.Value(uniqueId!),
        objectId: dr.Value(objectId!),
        insideId: insideId == null ? dr.Value(null) : dr.Value(insideId),
        date: dr.Value(date!),
        ));
  }

  _pickFile(String importType) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      File file = File(result.files.single.path!);
      print("path: " + file.path);

      if (importType == "item")
      {
        new File(file.path)
          .openRead()
          .transform(utf8.decoder)
          .transform(new LineSplitter())
          .forEach((l) => _createItem(l));
      }
      else if (importType == "container")
      {
        new File(file.path)
          .openRead()
          .transform(utf8.decoder)
          .transform(new LineSplitter())
          .forEach((l) => _createContainer(l));
      }
      else if (importType == "location")
      {
        new File(file.path)
          .openRead()
          .transform(utf8.decoder)
          .transform(new LineSplitter())
          .forEach((l) => _createLocation(l));
      }
      else if (importType == "index")
      {
        new File(file.path)
          .openRead()
          .transform(utf8.decoder)
          .transform(new LineSplitter())
          .forEach((l) => _createIndex(l));
      }

    } else {
      // User canceled the picker
      print("Failed");
    }
  }

  static exportDatabase() async {
    // TODO this method may be more useful in database area
    var appDocumentsDirectory = await getApplicationDocumentsDirectory();
    var appDocumentsPath = appDocumentsDirectory.path;
    var filePath = '$appDocumentsPath/db.sqlite'; // TODO this path probably needs to be a constant somewhere
    Share.shareFiles([filePath]);
  }
}