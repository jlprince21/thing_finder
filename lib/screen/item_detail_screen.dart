import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:thing_finder/database/database.dart';
import 'package:thing_finder/screen/container_detail_screen.dart';
import 'package:thing_finder/screen/items_screen.dart';

class ItemDetailScreenController extends GetxController {
  var titleEditingController = TextEditingController();
  var descriptionEditingController = TextEditingController();
  DbContainerData? currentContainer;
  String? selectedContainer = null;

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
        future: appDatabase.getItem(itemId),
        builder: (context, AsyncSnapshot<DbItemData> snapshot) {
          if (snapshot.hasData) {
            var theItem = snapshot.data;
            controller.titleEditingController.text = theItem!.title;
            controller.descriptionEditingController.text = theItem.description ?? "";

            return FutureBuilder(
                future: appDatabase.getContainer(theItem.container ?? ""),
                builder: (context, AsyncSnapshot<DbContainerData> snapshot) {
                  if (snapshot.hasData) {
                    controller.currentContainer = snapshot.data;
                  } else {
                    controller.currentContainer = null;
                  }

                  return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      child: Column(
                        children: [
                          FutureBuilder<List<DbContainerData>>(
                            future: _getContainersFromDatabase(),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                List<DbContainerData>? containerList = snapshot.data;
                                if (containerList != null) {
                                  containerList.insert(
                                      0,
                                      DbContainerData(
                                          uniqueId: "no-container",
                                          title: "(No Container)",
                                          date: "2022-01-01",
                                          description: "(No Container)"));
                                  return containerListPicker(containerList, controller);
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
                          if (controller.currentContainer != null) ...[
                            Text("Inside container: " + controller.currentContainer!.title),
                            ElevatedButton(
                              onPressed: () {
                                Get.delete<ItemDetailScreen>();
                                Get.to(ContainerDetailScreen(containerId: controller.currentContainer!.uniqueId));
                              },
                              child: const Text('Go to Container'),
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

  Widget containerListPicker(List<DbContainerData> containerList, ItemDetailScreenController controller) {
    return DropdownButtonFormField<DbContainerData>(
      value: controller.currentContainer ?? containerList[0],
      decoration: const InputDecoration(
        icon: Icon(Icons.widgets),
        hintText: 'Select container',
        labelText: 'Container *',
      ),
      icon: const Icon(Icons.arrow_downward),
      iconSize: 24,
      elevation: 16,
      style: const TextStyle(color: Colors.deepPurple),
      onChanged: (DbContainerData? newValue) {
        if (newValue?.uniqueId == "no-container") {
          controller.selectedContainer = null;
        } else {
          controller.selectedContainer = newValue?.uniqueId;
        }
      },
      items: containerList.map((DbContainerData container) {
        return DropdownMenuItem<DbContainerData>(
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
                controller.selectedContainer == null ? "" : controller.selectedContainer!,
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

  Future<List<DbContainerData>> _getContainersFromDatabase() async {
    return await appDatabase.getAllContainers();
  }

  void _saveToDb(String itemId, String containerId, String title, String description) {
    appDatabase
        .updateItem(DbItemData(
            uniqueId: itemId,
            title: title,
            description: description.isEmpty ? null : description,
            date: DateFormat.yMMMd().format(DateTime.now()),
            container: containerId.isEmpty ? null : containerId))
        .then((value) {
      Get.delete<ItemDetailScreenController>(); // important. resets controller so values aren't retained
      Get.to(ItemsScreen(searchText: "", containerId: ""));
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
                  Get.to(ItemsScreen(searchText: "", containerId: ""));
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
