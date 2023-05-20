import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thing_finder/database/database.dart';

class ContainerScreensController extends GetxController {
  var titleEditingController = TextEditingController();
  var descriptionEditingController = TextEditingController();
  DbPlaceData? currentPlace;
  String? selectedPlace = null;

  @override
  void dispose() {
    titleEditingController.dispose();
    descriptionEditingController.dispose();
    super.dispose();
  }
}

Widget placeListPicker(List<DbPlaceData> placeList, ContainerScreensController controller) {
  return DropdownButtonFormField<DbPlaceData>(
    value: controller.currentPlace ?? placeList[0], // 2022-10-23 Note: the container create screen version of this line only had placeList[0]. Rest of code was the same.
    decoration: const InputDecoration(
      icon: Icon(Icons.widgets),
      hintText: 'Select place',
      labelText: 'Place *',
    ),
    icon: const Icon(Icons.arrow_downward),
    iconSize: 24,
    elevation: 16,
    style: const TextStyle(color: Colors.deepPurple),
    onChanged: (DbPlaceData? newValue) {
      if (newValue?.uniqueId == "no-place") {
        controller.selectedPlace = null;
      } else {
        controller.selectedPlace = newValue?.uniqueId;
      }
    },
    items: placeList.map((DbPlaceData place) {
      return DropdownMenuItem<DbPlaceData>(
        value: place,
        child: Row(
          children: <Widget>[
            const SizedBox(
              width: 10,
            ),
            Text(
              place.title,
              style: const TextStyle(color: Colors.black),
            ),
          ],
        ),
      );
    }).toList(),
  );
}

Future<List<DbPlaceData>> getPlacesFromDatabase(AppDatabase appDatabase) async {
  return await appDatabase.getAllPlaces();
}

List<Widget> getCommonContainerWidgets(ContainerScreensController controller) {
  List<Widget> detailWidgets = <Widget>[];

  detailWidgets.add(
    TextFormField(
      controller: controller.titleEditingController,
      decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
          ),
          hintText: 'Container Title'),
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
          hintText: 'Container Description'),
    ),
  );

  return detailWidgets;
}