import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:thing_finder/database/database.dart';
import 'package:thing_finder/screen/containers_screen.dart';
import 'package:thing_finder/screen/items_screen.dart';
import 'package:thing_finder/screen/place_detail_screen.dart';

class ContainerDetailScreenController extends GetxController {
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

class ContainerDetailScreen extends StatelessWidget {
  late AppDatabase appDatabase;
  String containerId;

  ContainerDetailScreen({required this.containerId});

  @override
  Widget build(BuildContext context) {
    appDatabase = Provider.of<AppDatabase>(context);
    final controller = Get.put(ContainerDetailScreenController());

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
                                  'Click on add button to create new container',
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
                          Column(children: getContainerDetailWidgets(controller),),
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

  getContainerDetailWidgets(ContainerDetailScreenController controller) {
    List<Widget> detailWidgets = <Widget>[];

    // TODO 2022-10-15 may change back to this instead of raft of widgets above,
    // keep for a while.

    // detailWidgets.add(
    //   TextFormField(
    //     controller: controller.titleEditingController,
    //     decoration: InputDecoration(
    //         border: OutlineInputBorder(
    //           borderRadius: BorderRadius.circular(5),
    //         ),
    //         hintText: 'Container Title'),
    //   ),
    // );

    // detailWidgets.add(
    //   const SizedBox(
    //     height: 20,
    //   ),
    // );

    // detailWidgets.add(
    //   TextFormField(
    //     controller: controller.descriptionEditingController,
    //     maxLength: 100,
    //     minLines: 4,
    //     maxLines: 6,
    //     decoration: InputDecoration(
    //         border: OutlineInputBorder(
    //           borderRadius: BorderRadius.circular(5),
    //         ),
    //         hintText: 'Container Description'),
    //   ),
    // );

    detailWidgets.add(
      Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: ElevatedButton(
          onPressed: () {
            Get.delete<ContainerDetailScreenController>(); // important. resets controller so values aren't retained
            Get.to(ItemsScreen(searchText: "", containerId: containerId)); // 2022-10-08 let route stack build
          },
          child: const Text('View Contents'),
        ),
      ),
    );

    return detailWidgets;
  }

  Widget placeListPicker(List<DbPlaceData> placeList, ContainerDetailScreenController controller) {
    return DropdownButtonFormField<DbPlaceData>(
      value: controller.currentPlace ?? placeList[0],
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

  _getDetailAppBar(BuildContext context, ContainerDetailScreenController controller, String containerId) {
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

  Future<List<DbPlaceData>> _getPlacesFromDatabase() async {
    return await appDatabase.getAllPlaces();
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
      Get.delete<ContainerDetailScreenController>(); // important. resets controller so values aren't retained
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
                  Get.delete<ContainerDetailScreenController>(); // important. resets controller so values aren't retained
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
