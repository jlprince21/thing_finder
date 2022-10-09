import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:thing_finder/database/database.dart';
import 'package:thing_finder/screen/items_screen.dart';

class ItemCreateScreenController extends GetxController {
  var titleEditingController = TextEditingController();
  var descriptionEditingController = TextEditingController();
  String? selectedContainer;

  @override
  void dispose() {
    titleEditingController.dispose();
    descriptionEditingController.dispose();
    super.dispose();
  }
}

class ItemCreateScreen extends StatelessWidget {
  late AppDatabase appDatabase;

  @override
  Widget build(BuildContext context) {
    appDatabase = Provider.of<AppDatabase>(context);
    final controller = Get.put(ItemCreateScreenController());

    return Scaffold(
      appBar: _getDetailAppBar(controller),
      body: Container(
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
          ],
        ),
      ),
    );
  }

  Widget containerListPicker(
      List<DbContainerData> containerList, ItemCreateScreenController controller) {
    return DropdownButtonFormField<DbContainerData>(
      value: containerList[0],
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
                style: TextStyle(color: Colors.black),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  _getDetailAppBar(ItemCreateScreenController controller) {
    return AppBar(
      elevation: 0,
      leading: IconButton(
        onPressed: () {
          Get.off(ItemsScreen(searchText: "", containerId: ""));
        },
        icon: const Icon(
          Icons.chevron_left_outlined,
          // color: Colors.black,
        ),
      ),
      title: const Text(
        "Add Item",
        // style: const TextStyle(color: Colors.black),
      ),
      actions: [
        IconButton(
          onPressed: () {
            _saveToDb(controller.titleEditingController.text,
                controller.descriptionEditingController.text, controller.selectedContainer);
          },
          icon: const Icon(
            Icons.save,
            // color: Colors.black,
          ),
        ),
      ],
    );
  }

  Future<List<DbContainerData>> _getContainersFromDatabase() async {
    return await appDatabase.getAllContainers();
  }

  void _saveToDb(String title, String description, String? containerId) {
    appDatabase
        .createItem(
            title,
            description,
            containerId)
        .then((value) {
      Get.delete<ItemCreateScreenController>(); // important. resets controller so values aren't retained after creating an item and making another
      Get.offAll(ItemsScreen(searchText: "", containerId: ""));
    });
  }
}
