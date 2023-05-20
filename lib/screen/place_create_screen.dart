import 'package:drift/drift.dart' as dr;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:thing_finder/database/database.dart';
import 'package:thing_finder/screen/places_screen.dart';

import '../common/place_common.dart';

class PlaceCreateScreen extends StatelessWidget {
  late AppDatabase appDatabase;

  PlaceCreateScreen();

  @override
  Widget build(BuildContext context) {
    appDatabase = Provider.of<AppDatabase>(context);
    final controller = Get.put(PlaceScreensController());

    return Scaffold(
      appBar: _getDetailAppBar(controller),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Column(
          children:
            getCommonPlaceWidgets(controller),
        ),
      ),
    );
  }

  _getDetailAppBar(PlaceScreensController controller) {
    return AppBar(
      elevation: 0,
      leading: IconButton(
        onPressed: () {
          Get.off(PlacesScreen(searchText: ""));
        },
        icon: const Icon(
          Icons.chevron_left_outlined,
          // color: Colors.black,
        ),
      ),
      title: const Text(
        "Create Place",
        // style: const TextStyle(color: Colors.black),
      ),
      actions: [
        IconButton(
          onPressed: () {
            _saveToDb(controller.titleEditingController.text, controller.descriptionEditingController.text);
          },
          icon: const Icon(
            Icons.save,
            // color: Colors.black,
          ),
        ),
      ],
    );
  }

  void _saveToDb(String title, String description) {
    appDatabase
        .createPlace(
            title,
            description
            )
        .then((value) {
      Get.delete<PlaceScreensController>(); // important. resets controller so values aren't retained after creating a place and making another
      Get.offAll(PlacesScreen(searchText: ""));
    });
  }
}
