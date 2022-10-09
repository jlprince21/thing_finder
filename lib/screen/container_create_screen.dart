import 'package:drift/drift.dart' as dr;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:thing_finder/database/database.dart';
import 'package:thing_finder/screen/containers_screen.dart';

class ContainerCreateScreenController extends GetxController {
  var titleEditingController = TextEditingController();
  var descriptionEditingController = TextEditingController();

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
        .createContainer(
            title,
            description
            )
        .then((value) {
      Get.delete<ContainerCreateScreenController>(); // important. resets controller so values aren't retained after creating a container and making another
      Get.offAll(ContainersScreen(searchText: ""));
    });
  }
}
