import 'package:drift/drift.dart' as dr;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:thing_finder/database/database.dart';
import 'package:thing_finder/screen/containers_screen.dart';

class ContainerCreateScreenController extends GetxController {
  var titleEditingController = TextEditingController();
  var descriptionEditingController = TextEditingController();
  String? selectedPlace;

  @override
  void dispose() {
    titleEditingController.dispose();
    descriptionEditingController.dispose();
    super.dispose();
  }
}

class ContainerCreateScreen extends StatelessWidget {
  late AppDatabase appDatabase;

  ContainerCreateScreen();

  @override
  Widget build(BuildContext context) {
    appDatabase = Provider.of<AppDatabase>(context);
    final controller = Get.put(ContainerCreateScreenController());

    return Scaffold(
      appBar: _getDetailAppBar(controller),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Column(
          children: [
            FutureBuilder<List<DbPlaceData>>(
              future: _getPlacesFromDatabase(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List<DbPlaceData>? placeList = snapshot.data;
                  if (placeList != null) {
                    placeList.insert(
                        0,
                        DbPlaceData(
                            uniqueId: "no-place",
                            title: "(No Place)",
                            date: "2022-01-01",
                            description: "(No Place)"));
                    return placeListPicker(placeList, controller);
                  }
                } else if (snapshot.hasError) {
                  return Center(
                      child: Text(
                    snapshot.error.toString(),
                    style: Theme.of(context).textTheme.bodyText2,
                  ));
                }
                return Center(
                  child: Text(
                    'Click on add button to create new item',
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                );
              },
            ),
            TextFormField(
              controller: controller.titleEditingController,
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  hintText: 'Container Title'),
            ),
            const SizedBox(
              height: 20,
            ),
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
          ],
        ),
      ),
    );
  }

  Widget placeListPicker(
      List<DbPlaceData> placeList, ContainerCreateScreenController controller) {
    return DropdownButtonFormField<DbPlaceData>(
      value: placeList[0],
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
                style: TextStyle(color: Colors.black),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  _getDetailAppBar(ContainerCreateScreenController controller) {
    return AppBar(
      elevation: 0,
      leading: IconButton(
        onPressed: () {
          Get.off(ContainersScreen(searchText: ""));
        },
        icon: const Icon(
          Icons.chevron_left_outlined,
          // color: Colors.black,
        ),
      ),
      title: const Text(
        "Create Container",
        // style: const TextStyle(color: Colors.black),
      ),
      actions: [
        IconButton(
          onPressed: () {
            _saveToDb(controller.titleEditingController.text,
                      controller.descriptionEditingController.text,
                      controller.selectedPlace);
          },
          icon: const Icon(
            Icons.save,
            // color: Colors.black,
          ),
        ),
      ],
    );
  }

  Future<List<DbPlaceData>> _getPlacesFromDatabase() async {
    return await appDatabase.getAllPlaces();
  }

  void _saveToDb(String title, String description, String? placeId) {
    appDatabase
        .createContainer(
            title,
            description,
            placeId)
        .then((value) {
      Get.delete<ContainerCreateScreenController>(); // important. resets controller so values aren't retained after creating a container and making another
      Get.offAll(ContainersScreen(searchText: ""));
    });
  }
}
