import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thing_finder/screen/containers_screen.dart';
import 'package:thing_finder/screen/items_screen.dart';
import 'package:thing_finder/screen/places_screen.dart';
import 'package:thing_finder/util/app_drawer.dart';

class SearchScreenController extends GetxController {
  var searchController = TextEditingController();
  var searchType = "item";

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void setValue(String value) {
    searchType = value;
    update();
  }
}

class SearchScreen extends StatelessWidget {
  SearchScreen();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SearchScreenController>(
      init: SearchScreenController(),
      builder: (controller) => Scaffold(
        appBar: _getSearchAppBar(),
        drawer: AppDrawer(),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: <Widget>[
                TextFormField(
                  controller: controller.searchController,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      hintText: 'Search Text'),
                ),
                ListTile(
                  title: const Text("Item"),
                  leading: Radio(
                      value: "item",
                      groupValue: controller.searchType,
                      onChanged: (value) {
                        controller.setValue(value.toString());
                      }),
                ),
                ListTile(
                  title: const Text("Container"),
                  leading: Radio(
                      value: "container",
                      groupValue: controller.searchType,
                      onChanged: (value) {
                        controller.setValue(value.toString());
                      }),
                ),
                ListTile(
                  title: const Text("Place"),
                  leading: Radio(
                      value: "place",
                      groupValue: controller.searchType,
                      onChanged: (value) {
                        controller.setValue(value.toString());
                      }),
                ),
                ElevatedButton(
                  child: const Text('Search'),
                  onPressed: () {
                    if (controller.searchType == "item") {
                      Get.delete<SearchScreenController>(); // important. resets controller so values aren't retained
                      Get.to(ItemsScreen(searchText: controller.searchController.text, containerId: "")); // 2022-10-08 let route stack build
                    }
                    else if (controller.searchType == "place") {
                      Get.delete<SearchScreenController>(); // important. resets controller so values aren't retained
                      Get.to(PlacesScreen(searchText: controller.searchController.text)); // 2022-10-08 let route stack build
                    }
                    else {
                      Get.delete<SearchScreenController>(); // important. resets controller so values aren't retained
                      Get.to(ContainersScreen(searchText: controller.searchController.text)); // 2022-10-08 let route stack build
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _getSearchAppBar() {
    return AppBar(
      // backgroundColor: Colors.white,
      centerTitle: true,
      elevation: 0,
      title: const Text(
        'Search',
        // style: Theme.of(context).textTheme.headline5,
      ),
    );
  }
}