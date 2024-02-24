import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:thing_finder/database/database.dart';
import 'package:thing_finder/screen/places_screen.dart';

import '../common/place_common.dart';
import 'items_and_containers_screen.dart';

class PlaceDetailScreen extends StatelessWidget {
  late AppDatabase appDatabase;
  String placeId;

  PlaceDetailScreen({super.key, required this.placeId});

  @override
  Widget build(BuildContext context) {
    appDatabase = Provider.of<AppDatabase>(context);
    final controller = Get.put(PlaceScreensController());

    return Scaffold(
      appBar: _getDetailAppBar(context, controller, placeId),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Column(children: [
          FutureBuilder<DbPlaceData>(
            future: appDatabase.getPlace(placeId),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                controller.titleEditingController.text = snapshot.data!.title;
                controller.descriptionEditingController.text = snapshot.data!.description ?? "";

                var widgets = getCommonPlaceWidgets(controller);
                widgets.add(
                  ElevatedButton(
                    onPressed: () {
                      Get.delete<PlaceScreensController>(); // important. resets controller so values aren't retained
                      Get.to(ItemsAndContainersScreen(searchText: "", placeId: placeId)); // 2022-10-08 let route stack build
                    },
                    child: const Text('View Contents'),
                  ),
                );

                return Column(children: widgets);
              } else if (snapshot.hasError) {
                return Center(
                    child: Text('Error: ${snapshot.error}', style: Theme.of(context).textTheme.bodyMedium,
                ));
              } else {
                return Center(child: Text('Error', style: Theme.of(context).textTheme.bodyMedium));
              }
            },
          ),
        ]),
      ),
    );
  }

  _getDetailAppBar(BuildContext context, PlaceScreensController controller, String placeId) {
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
      Get.delete<PlaceScreensController>(); // important. resets controller so values aren't retained
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
                  Get.delete<PlaceScreensController>(); // important. resets controller so values aren't retained
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
