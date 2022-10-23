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
            title: const Text('Export Database'),
            onTap: () {
              exportDatabase();
            },
          ),

          ListTile(
            title: const Text('Populate Sample Data'),
            onTap: () {
              var alert = AlertDialog(
                title: const Text('Populate Data Confirmation'),
                content: const Text('Do you want to populate sample data?'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () {
                      _populateSampleData();
                      Navigator.pop(context);
                    },
                    child: const Text('Populate'),
                  ),
              ],);

              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return alert;
                },
              );
            },
          ),

          ListTile(
            title: const Text('Delete All Data'),
            onTap: () {
              var alert = AlertDialog(
                title: const Text('Delete Confirmation'),
                content: const Text('Do you really want to delete all data?'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () {
                      _deleteAllData();
                      Navigator.pop(context);
                    },
                    child: const Text('Delete'),
                  ),
              ],);

              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return alert;
                },
              );

            },
          ),

          // ListTile(
          //   title: const Text('Import Containers to DB'),
          //   onTap: () {
          //     _pickFile("container");
          //   },
          // ),

          // ListTile(
          //   title: const Text('Import Indexes to DB'),
          //   onTap: () {
          //     _pickFile("index");
          //   },
          // ),

          // ListTile(
          //   title: const Text('Import Items to DB'),
          //   onTap: () {
          //     _pickFile("item");
          //   },
          // ),

          // ListTile(
          //   title: const Text('Import Locations to DB'),
          //   onTap: () {
          //     _pickFile("location");
          //   },
          // ),
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

  _populateSampleData()
  {
    var date = 'Oct 1, 2022';

    // places (c)
    const garageId = 'test0c00-47d0-4dc1-8023-5533eccb5c00';
    _importIndex(garageId, Differentiator.place.value);
    _importPlace(garageId, 'Garage', 'The garage', date);

    const bedroomClosetId = 'test0c01-47d0-4dc1-8023-5533eccb5c00';
    _importIndex(bedroomClosetId, Differentiator.place.value);
    _importPlace(bedroomClosetId, 'Bedroom Closet', 'The bedroom closet', date);

    // containers (b)

    const hatBoxId = 'test0b00-47d0-4dc1-8023-5533eccb5c00';
    _importIndex(hatBoxId, Differentiator.container.value);
    _importContainer(hatBoxId, 'Hat Box', 'The box where I keep my hats', date);
    _importLocation('test0d03-47d0-4dc1-8023-5533eccb5d00', hatBoxId, bedroomClosetId, date); // inside bedroom closet

    const toolBoxId = 'test0b01-47d0-4dc1-8023-5533eccb5c00';
    _importIndex(toolBoxId, Differentiator.container.value);
    _importContainer(toolBoxId, 'Tool Box', 'Box I keep tools in', date);
    _importLocation('test0d06-47d0-4dc1-8023-5533eccb5d00', toolBoxId, garageId, date); // inside garage

    // items (a)
    const bicycleId = 'test0a00-47d0-4dc1-8023-5533eccb5a00';
    _importIndex(bicycleId, Differentiator.item.value);
    _importItem(bicycleId, 'Bicycle', 'My red bicycle', date);
    _importLocation('test0d00-47d0-4dc1-8023-5533eccb5d00', bicycleId, garageId, date); // inside garage

    const hatRedId = 'test0a01-47d0-4dc1-8023-5533eccb5a00';
    _importIndex(hatRedId, Differentiator.item.value);
    _importItem(hatRedId, 'Red Hat', 'My red hat', date);
    _importLocation('test0d01-47d0-4dc1-8023-5533eccb5d00', hatRedId, hatBoxId, date); // inside hat box

    const hatGreenId = 'test0a02-47d0-4dc1-8023-5533eccb5a00';
    _importIndex(hatGreenId, Differentiator.item.value);
    _importItem(hatGreenId, 'Green Hat', 'My green hat', date);
    _importLocation('test0d02-47d0-4dc1-8023-5533eccb5d00', hatGreenId, hatBoxId, date); // inside hat box

    const trackShoesId = 'test0a03-47d0-4dc1-8023-5533eccb5a00';
    _importIndex(trackShoesId, Differentiator.item.value);
    _importItem(trackShoesId, 'Track Shoes', 'My track running shoes', date);
    _importLocation('test0d04-47d0-4dc1-8023-5533eccb5d00', trackShoesId, bedroomClosetId, date); // inside bedroom closet

    const suspendersId = 'test0a04-47d0-4dc1-8023-5533eccb5a00';
    _importIndex(suspendersId, Differentiator.item.value);
    _importItem(suspendersId, 'Suspenders', 'My red pair of pants suspenders', date);
    _importLocation('test0d05-47d0-4dc1-8023-5533eccb5d00', suspendersId, bedroomClosetId, date); // inside bedroom closet

    const hammerId = 'test0a05-47d0-4dc1-8023-5533eccb5a00';
    _importIndex(hammerId, Differentiator.item.value);
    _importItem(hammerId, 'Hammer', 'My claw hammer', date);
    _importLocation('test0d07-47d0-4dc1-8023-5533eccb5d00', hammerId, toolBoxId, date); // inside toolbox

    const screwdriverId = 'test0a06-47d0-4dc1-8023-5533eccb5a00';
    _importIndex(screwdriverId, Differentiator.item.value);
    _importItem(screwdriverId, 'Screwdriver', 'My flathead screwdriver', date);
    _importLocation('test0d08-47d0-4dc1-8023-5533eccb5d00', screwdriverId, toolBoxId, date); // inside toolbox

    // locations (d)
  }

  _importItem(String uniqueId, String title, String? description, String date)
  {
    appDatabase.importItem(DbItemCompanion(
      uniqueId: dr.Value(uniqueId),
      title: dr.Value(title),
      description: description == null ? dr.Value(null) : dr.Value(description),
      date: dr.Value(date),
    ));
  }

  _importContainer(String containerId, String containerTitle, String? containerDescription, String date)
  {
    appDatabase
      .importContainer(DbContainerCompanion(
        uniqueId: dr.Value(containerId),
        title: dr.Value(containerTitle),
        description: containerDescription == null ? dr.Value(null) : dr.Value(containerDescription),
        date: dr.Value(date),
        ));
  }

  _importIndex(String indexId, int type)
  {
    appDatabase
      .importIndex(DbIndexCompanion(
        uniqueId: dr.Value(indexId!),
        type: dr.Value(type),
        ));
  }

  _importPlace(String uniqueId, String title, String? description, String date)
  {
    appDatabase
      .importPlace(DbPlaceCompanion(
        uniqueId: dr.Value(uniqueId),
        title: dr.Value(title),
        description: description == null ? dr.Value(null) : dr.Value(description),
        date: dr.Value(date),
      ));
  }

  _importLocation(String uniqueId, String objectId, String insideId, String date)
  {
    appDatabase
      .importLocation(DbLocationCompanion(
        uniqueId: dr.Value(uniqueId),
        objectId: dr.Value(objectId),
        insideId: dr.Value(insideId),
        date: dr.Value(date),
        ));
  }

  _deleteAllData()
  {
    appDatabase.deleteAllData();
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
      .importIndex(DbIndexCompanion(
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
      print("User canceled file picker");
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