import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:thing_finder/database/database.dart';
import 'package:thing_finder/screen/container_detail_screen.dart';
import 'package:thing_finder/screen/items_screen.dart';
import 'package:thing_finder/screen/place_detail_screen.dart';

class ItemDetailScreenController extends GetxController {
  var titleEditingController = TextEditingController();
  var descriptionEditingController = TextEditingController();
  GenericItemContainerOrPlace? currentContainerOrPlace;
  String? selectedContainerOrPlace = null;

  @override
  void dispose() {
    titleEditingController.dispose();
    descriptionEditingController.dispose();
    super.dispose();
  }
}

class ItemDetailScreen extends StatelessWidget {
  late AppDatabase appDatabase;
  String itemId;

  ItemDetailScreen({required this.itemId});

  @override
  Widget build(BuildContext context) {
    appDatabase = Provider.of<AppDatabase>(context);
    final controller = Get.put(ItemDetailScreenController());

    return Scaffold(
      appBar: _getDetailAppBar(context, controller, itemId),
      body: FutureBuilder(
        future: appDatabase.getItemDetails(itemId),
        builder: (context, AsyncSnapshot<ItemMapped> snapshot) {
          if (snapshot.hasData) {
            var theItem = snapshot.data;
            controller.titleEditingController.text = theItem!.item.title;
            controller.descriptionEditingController.text = theItem.item.description ?? "";

            return FutureBuilder(
                future: appDatabase.getContainerOrPlace(theItem.containerOrPlace?.uniqueId ?? ""),
                builder: (context, AsyncSnapshot<GenericItemContainerOrPlace> snapshot) {
                  if (snapshot.hasData) {
                    controller.currentContainerOrPlace = snapshot.data;
                    controller.selectedContainerOrPlace = snapshot.data!.uniqueId;
                  } else {
                    controller.currentContainerOrPlace = null;
                  }

                  return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      child: Column(
                        children: [
                          FutureBuilder<ContainersAndPlaces>(
                            future: _getContainersAndPlacesFromDatabase(),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                List<DbContainerData>? containerList = snapshot.data!.containers;
                                List<DbPlaceData>? placeList = snapshot.data!.places;
                                if (containerList != null || placeList != null) {
                                  containerList.insert(
                                      0,
                                      DbContainerData(
                                          uniqueId: "no-container",
                                          title: "(No Container or Place)",
                                          date: "2022-01-01",
                                          description: "(No Container or Place)"));
                                  return containerListPicker(containerList, placeList, controller);
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
                                hintText: 'Item Title'),
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
                                hintText: 'Item Description'),
                          ),
                          if (controller.currentContainerOrPlace != null) ...[
                            Text('Inside ${controller.currentContainerOrPlace!.thingType == Differentiator.container ? "container" : "place"}: ${controller.currentContainerOrPlace!.title}'),
                            ElevatedButton(
                              onPressed: () {
                                Get.delete<ItemDetailScreen>();

                                if (controller.currentContainerOrPlace!.thingType == Differentiator.container)
                                {
                                  Get.to(ContainerDetailScreen(containerId: controller.currentContainerOrPlace!.uniqueId)); // 2022-10-08 let route stack build
                                }
                                else if (controller.currentContainerOrPlace!.thingType == Differentiator.place)
                                {
                                  Get.to(PlaceDetailScreen(placeId: controller.currentContainerOrPlace!.uniqueId)); // 2022-10-08 let route stack build
                                }
                              },
                              child: Text('Go to ${controller.currentContainerOrPlace!.thingType == Differentiator.container ? "Container" : "Place"}'),
                            ),
                          ]
                        ],
                      ));
                });
          } else {
            return const Text('Something went wrong finding the item :(.');
          }
        },
      ),
    );
  }

  Widget containerListPicker(List<DbContainerData> containerList, List<DbPlaceData> placeList, ItemDetailScreenController controller) {
    List<GenericItemContainerOrPlace> theList = [];

    for (var x in containerList) {
      theList.add(GenericItemContainerOrPlace(x.uniqueId, x.title, x.description, x.date, Differentiator.container));
    }

    for (var x in placeList) {
      theList.add(GenericItemContainerOrPlace(x.uniqueId, x.title, x.description, x.date, Differentiator.place));
    }

    var index = 0; // 2022-10-13 This feels like it isn't really needed, but it is. Would be nice if this could be gone one day.

    if (controller.currentContainerOrPlace != null && controller.currentContainerOrPlace!.uniqueId != null)
    {
      index = theList.indexWhere((element) => element.uniqueId == controller.currentContainerOrPlace!.uniqueId);
    }

    return DropdownButtonFormField<GenericItemContainerOrPlace>(
      value: theList[index],
      decoration: const InputDecoration(
        icon: Icon(Icons.widgets),
        hintText: 'Select container or place',
        labelText: 'Container or Place *',
      ),
      icon: const Icon(Icons.arrow_downward),
      iconSize: 24,
      elevation: 16,
      style: const TextStyle(color: Colors.deepPurple),
      onChanged: (GenericItemContainerOrPlace? newValue) {
        if (newValue?.uniqueId == "no-container") {
          controller.selectedContainerOrPlace = null;
        } else {
          controller.selectedContainerOrPlace = newValue?.uniqueId;
        }
      },
      items: theList.map((GenericItemContainerOrPlace container) {
        return DropdownMenuItem<GenericItemContainerOrPlace>(
          value: container,
          child: Row(
            children: <Widget>[
              const SizedBox(
                width: 10,
              ),
              Text(
                container.title,
                style: const TextStyle(color: Colors.black),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  _getDetailAppBar(BuildContext context, ItemDetailScreenController controller, String itemId) {
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
        "Edit Item",
        // style: const TextStyle(color: Colors.black),
      ),
      actions: [
        IconButton(
          onPressed: () {
            _saveToDb(
                itemId,
                controller.selectedContainerOrPlace == null ? "" : controller.selectedContainerOrPlace!,
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
            _deleteItem(context, itemId);
          },
          icon: const Icon(
            Icons.delete,
            // color: Colors.black,
          ),
        ),
      ],
    );
  }

  Future<ContainersAndPlaces> _getContainersAndPlacesFromDatabase() async {
    return await appDatabase.getAllContainersAndPlaces();
  }

  void _saveToDb(String itemId, String containerId, String title, String description) {
    appDatabase
        .updateItem(DbItemData(
            uniqueId: itemId,
            title: title,
            description: description.isEmpty ? null : description,
            date: DateFormat.yMMMd().format(DateTime.now())),
            containerId.isEmpty ? null : containerId)
        .then((value) {
      Get.delete<ItemDetailScreenController>(); // important. resets controller so values aren't retained
      Get.offAll(ItemsScreen(searchText: "", containerId: ""));
    },);
  }

  void _deleteItem(BuildContext theContext, String itemId) {
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
                Navigator.pop(context);
                appDatabase.deleteItemById(itemId).then((value) {
                  Get.delete<ItemDetailScreenController>(); // important. resets controller so values aren't retained
                  Get.offAll(ItemsScreen(searchText: "", containerId: ""));
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
