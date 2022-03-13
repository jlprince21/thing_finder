
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

class DatabaseToolsScreen extends StatefulWidget {
  const DatabaseToolsScreen({Key? key}) : super(key: key);

  @override
  _DatabaseToolsScreenState createState() => _DatabaseToolsScreenState();
}

class _DatabaseToolsScreenState extends State<DatabaseToolsScreen> {
  late AppDatabase appDatabase;

  @override
  Widget build(BuildContext context) {
    appDatabase = Provider.of<AppDatabase>(context);

    return Scaffold(
      appBar: _getMainMenuAppBar(),
      drawer: AppDrawer(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: <Widget>[
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    child: Text('Export DB'),
                    onPressed: () {
                      exportDatabase();
                    },
                  ),
                ),
              ),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    child: Text('Import Items to DB'),
                    onPressed: () {
                      _pickFile("item");
                    },
                  ),
                ),
              ),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    child: Text('Import Containers to DB'),
                    onPressed: () {
                      _pickFile("container");
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  ButtonStyle getButtonStyle() {
    return ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12), // <-- Radius
                    ));
  }

  _getMainMenuAppBar(){
    return AppBar(
      // backgroundColor: Colors.white,
      centerTitle: true,
      elevation: 0,
      title: Text(
        'Database Tools',
        // style: Theme.of(context).textTheme.headline5,
      ),
    );
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
    final containerId = values[1];
    final itemTitle = values[2];
    final itemDescription = values[3];
    final itemDate = values[4];

    appDatabase
      .createItem(DbItemCompanion(
        uniqueId: dr.Value(itemId!),
        title: dr.Value(itemTitle!),
        description: itemDescription == null ? dr.Value(null) : dr.Value(itemDescription),
        date: dr.Value(itemDate!),
        container: dr.Value(containerId)));
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
      .createContainer(DbContainerCompanion(
        uniqueId: dr.Value(containerId!),
        title: dr.Value(containerTitle!),
        description: containerDescription == null ? dr.Value(null) : dr.Value(containerDescription),
        date: dr.Value(containerDate!),
        ));
  }

  _pickFile(String itemOrContainer) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      File file = File(result.files.single.path!);
      print("path: " + file.path);

      if (itemOrContainer == "item")
      {
        new File(file.path)
          .openRead()
          .transform(utf8.decoder)
          .transform(new LineSplitter())
          .forEach((l) => _createItem(l));
      }
      else if (itemOrContainer == "container")
      {
        new File(file.path)
          .openRead()
          .transform(utf8.decoder)
          .transform(new LineSplitter())
          .forEach((l) => _createContainer(l));
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