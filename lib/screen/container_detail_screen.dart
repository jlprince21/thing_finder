import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:thing_finder/database/database.dart';
import 'package:thing_finder/screen/containers_screen.dart';
import 'package:thing_finder/screen/items_screen.dart';

class ContainerDetailScreenController extends GetxController {
  var titleEditingController = TextEditingController();
  var descriptionEditingController = TextEditingController();

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
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: FutureBuilder<DbContainerData>(
          future: _getContainerFromDatabase(containerId),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(
                  child: Text(
                'Error: ' + snapshot.error.toString(),
                style: Theme.of(context).textTheme.bodyText2,
              ));
            } else if (snapshot.hasData) {
              controller.titleEditingController.text = snapshot.data!.title;
              controller.descriptionEditingController.text = snapshot.data!.description ?? "";
              return Column(children: getContainerDetailWidgets(controller));
            } else {
              return Center(child: Text('Error', style: Theme.of(context).textTheme.bodyText2));
            }
          },
        ),
      ),
    );
  }

  Future<DbContainerData> _getContainerFromDatabase(String containerId) async {
    return await appDatabase.getContainer(containerId);
  }

  getContainerDetailWidgets(ContainerDetailScreenController controller) {
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

    detailWidgets.add(
      ElevatedButton(
        onPressed: () {
          Get.delete<ContainerDetailScreenController>(); // important. resets controller so values aren't retained
          Get.to(ItemsScreen(searchText: "", containerId: containerId));
        },
        child: const Text('View Contents'),
      ),
    );

    return detailWidgets;
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
            _saveToDb(containerId, controller.titleEditingController.text,
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

  void _saveToDb(String containerId, String title, String description) {
    appDatabase
        .updateContainer(DbContainerData(
            uniqueId: containerId,
            title: title,
            description: description.isEmpty ? null : description,
            date: DateFormat.yMMMd().format(DateTime.now())))
        .then((value) {
      Get.delete<ContainerDetailScreenController>(); // important. resets controller so values aren't retained
      Get.to(ContainersScreen(searchText: ""));
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
                // Get.to(ContainersScreen(searchText: ""));
                appDatabase.deleteContainerById(containerId).then((value) {
                  Get.delete<ContainerDetailScreenController>(); // important. resets controller so values aren't retained
                  Get.to(ContainersScreen(searchText: ""));
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
