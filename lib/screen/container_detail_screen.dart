import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:thing_finder/database/database.dart';
import 'package:thing_finder/screen/containers_screen.dart';
import 'package:thing_finder/screen/items_screen.dart';
import 'package:thing_finder/screen/place_detail_screen.dart';

import '../common/container_common.dart';

class ContainerDetailScreen extends StatelessWidget {
  late AppDatabase appDatabase;
  String containerId;

  ContainerDetailScreen({required this.containerId});

  @override
  Widget build(BuildContext context) {
    appDatabase = Provider.of<AppDatabase>(context);
    final controller = Get.put(ContainerScreensController());

    return Scaffold(
      appBar: _getDetailAppBar(context, controller, containerId),
      body: FutureBuilder(
        future: appDatabase.getContainerDetails(containerId),
        builder: (context, AsyncSnapshot<ContainerMapped> snapshot) {
          if (snapshot.hasData) {
            var theContainer = snapshot.data;
            controller.titleEditingController.text = theContainer!.container.title;
            controller.descriptionEditingController.text = theContainer.container.description ?? "";

            return FutureBuilder(
                future: appDatabase.getPlace(theContainer.place?.uniqueId ?? ""),
                builder: (context, AsyncSnapshot<DbPlaceData> snapshot) {
                  if (snapshot.hasData) {
                    controller.currentPlace = snapshot.data;
                    controller.selectedPlace = snapshot.data!.uniqueId;
                  } else {
                    controller.currentPlace = null;
                  }

                  return Container(
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
                                  'Click on add button to create new container',
                                  style: Theme.of(context).textTheme.bodyText2,
                                ),
                              );
                            },
                          ),

                          Column(children: getCommonContainerWidgets(controller),),

                          if (controller.currentPlace != null) ...[
                            Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: Text("Inside place: " + controller.currentPlace!.title),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                Get.delete<ContainerDetailScreen>();
                                Get.to(PlaceDetailScreen(placeId: controller.currentPlace!.uniqueId)); // 2022-10-08 let route stack build
                              },
                              child: const Text('Go to Place'),
                            ),
                          ],

                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: ElevatedButton(
                              onPressed: () {
                                Get.delete<ContainerScreensController>(); // important. resets controller so values aren't retained
                                Get.to(ItemsScreen(searchText: "", containerId: containerId)); // 2022-10-08 let route stack build
                              },
                              child: const Text('View Contents'),
                            ),
                          ),
                        ],
                      ));
                });
          } else {
            return const Text('Something went wrong finding the container :(.');
          }
        },
      ),
    );
  }

  _getDetailAppBar(BuildContext context, ContainerScreensController controller, String containerId) {
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
        "Edit Container",
        // style: const TextStyle(color: Colors.black),
      ),
      actions: [
        IconButton(
          onPressed: () {
            _saveToDb(
                containerId,
                controller.selectedPlace == null ? "" : controller.selectedPlace!,
                controller.titleEditingController.text,
                controller.descriptionEditingController.text);
          },
          icon: const Icon(
            Icons.save,
            // color: Colors.black,
          ),
        ),
        IconButton(
          onPressed: () {
            _deleteContainer(context, containerId);
          },
          icon: const Icon(
            Icons.delete,
            // color: Colors.black,
          ),
        ),
      ],
    );
  }

  void _saveToDb(String containerId, String placeId, String title, String description) {
    appDatabase
        .updateContainer(DbContainerData(
            uniqueId: containerId,
            title: title,
            description: description.isEmpty ? null : description,
            date: DateFormat.yMMMd().format(DateTime.now())),
            placeId.isEmpty ? null : placeId)
        .then((value) {
      Get.delete<ContainerScreensController>(); // important. resets controller so values aren't retained
      Get.offAll(ContainersScreen(searchText: ""));
    });
  }

  void _deleteContainer(BuildContext theContext, String containerId) {
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
                appDatabase.deleteContainerById(containerId).then((value) {
                  Get.delete<ContainerScreensController>(); // important. resets controller so values aren't retained
                  Get.offAll(ContainersScreen(searchText: ""));
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
