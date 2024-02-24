import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:thing_finder/database/database.dart';
import 'package:thing_finder/screen/containers_screen.dart';

import '../common/container_common.dart';

class ContainerCreateScreen extends StatelessWidget {
  late AppDatabase appDatabase;

  ContainerCreateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    appDatabase = Provider.of<AppDatabase>(context);
    final controller = Get.put(ContainerScreensController());

    return Scaffold(
      appBar: _getDetailAppBar(controller),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Column(
          children: [
            FutureBuilder<List<DbPlaceData>>(
              future: getPlacesFromDatabase(appDatabase),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List<DbPlaceData>? placeList = snapshot.data;
                  if (placeList != null) {
                    placeList.insert(
                        0,
                        const DbPlaceData(
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
                    style: Theme.of(context).textTheme.bodyMedium,
                  ));
                }
                return Center(
                  child: Text(
                    'Click on add button to create new item',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                );
              },
            ),

            Column(children: getCommonContainerWidgets(controller),),
          ],
        ),
      ),
    );
  }

  _getDetailAppBar(ContainerScreensController controller) {
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

  void _saveToDb(String title, String description, String? placeId) {
    appDatabase
        .createContainer(
            title,
            description,
            placeId)
        .then((value) {
      Get.delete<ContainerScreensController>(); // important. resets controller so values aren't retained after creating a container and making another
      Get.offAll(ContainersScreen(searchText: ""));
    });
  }
}
