import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:thing_finder/database/database.dart';
import 'package:thing_finder/screen/containers_screen.dart';
import 'package:thing_finder/screen/items_screen.dart';
import 'package:thing_finder/screen/places_screen.dart';

import 'items_and_containers_screen.dart';

class PlaceDetailScreenController extends GetxController {
  var titleEditingController = TextEditingController();
  var descriptionEditingController = TextEditingController();

  @override
  void dispose() {
    titleEditingController.dispose();
    descriptionEditingController.dispose();
    super.dispose();
  }
}

class PlaceDetailScreen extends StatelessWidget {
  late AppDatabase appDatabase;
  String placeId;

  PlaceDetailScreen({required this.placeId});

  @override
  Widget build(BuildContext context) {
    appDatabase = Provider.of<AppDatabase>(context);
    final controller = Get.put(PlaceDetailScreenController());

    return Scaffold(
      appBar: _getDetailAppBar(context, controller, placeId),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: FutureBuilder<DbPlaceData>(
          future: _getPlaceFromDatabase(placeId),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(
                  child: Text(
                'Error: ' + snapshot.error.toString(),
                style: Theme.of(context).textTheme.bodyText2,
              ));
            } else if (snapshot.hasData) {
              controller.titleEditingController.text = snapshot.data!.title;
              controller.descriptionEditingController.text = snapshot.data!.description ?? "";
              return Column(children: getPlaceDetailWidgets(controller));
            } else {
              return Center(child: Text('Error', style: Theme.of(context).textTheme.bodyText2));
            }
          },
        ),
      ),
    );
  }

  Future<DbPlaceData> _getPlaceFromDatabase(String placeId) async {
    return await appDatabase.getPlace(placeId);
  }

  getPlaceDetailWidgets(PlaceDetailScreenController controller) {
    List<Widget> detailWidgets = <Widget>[];

    detailWidgets.add(
      TextFormField(
        controller: controller.titleEditingController,
        decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
            ),
            hintText: 'Place Title'),
      ),
    );

    detailWidgets.add(
      const SizedBox(
        height: 20,
      ),
    );

    detailWidgets.add(
      TextFormField(
        controller: controller.descriptionEditingController,
        maxLength: 100,
        minLines: 4,
        maxLines: 6,
        decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
            ),
            hintText: 'Place Description'),
      ),
    );

    detailWidgets.add(
      ElevatedButton(
        onPressed: () {
          Get.delete<PlaceDetailScreenController>(); // important. resets controller so values aren't retained
          Get.to(ItemsAndContainersScreen(searchText: "", placeId: placeId)); // 2022-10-08 let route stack build
        },
        child: const Text('View Contents'),
      ),
    );

    return detailWidgets;
  }

  _getDetailAppBar(BuildContext context, PlaceDetailScreenController controller, String placeId) {
    return AppBar(
      elevation: 0,
      leading: IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: const Icon(
          Icons.chevron_left_outlined,
          // color: Colors.black,
        ),
      ),
      title: const Text(
        "Edit Place",
        // style: const TextStyle(color: Colors.black),
      ),
      actions: [
        IconButton(
          onPressed: () {
            _saveToDb(placeId, controller.titleEditingController.text,
                controller.descriptionEditingController.text);
          },
          icon: const Icon(
            Icons.save,
            // color: Colors.black,
          ),
        ),
        IconButton(
          onPressed: () {
            _deletePlace(context, placeId);
          },
          icon: const Icon(
            Icons.delete,
            // color: Colors.black,
          ),
        ),
      ],
    );
  }

  void _saveToDb(String placeId, String title, String description) {
    appDatabase
        .updatePlace(DbPlaceData(
            uniqueId: placeId,
            title: title,
            description: description.isEmpty ? null : description,
            date: DateFormat.yMMMd().format(DateTime.now())))
        .then((value) {
      Get.delete<PlaceDetailScreenController>(); // important. resets controller so values aren't retained
      Get.offAll(PlacesScreen(searchText: ""));
    });
  }

  void _deletePlace(BuildContext theContext, String placeId) {
    showDialog(
      context: theContext,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Confirmation'),
          content: const Text('Do you really want to delete this?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                appDatabase.deletePlaceById(placeId).then((value) {
                  Get.delete<PlaceDetailScreenController>(); // important. resets controller so values aren't retained
                  Get.offAll(PlacesScreen(searchText: ""));
                });
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}
