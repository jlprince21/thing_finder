import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:thing_finder/database/database.dart';
import 'package:thing_finder/screen/item_detail_screen.dart';
import 'package:thing_finder/util/app_drawer.dart';

import 'container_detail_screen.dart';

class ItemsAndContainersScreenController extends GetxController {
  String? searchText;
  var stuff = <GenericItemContainerOrPlace>[].obs;

  var axisCount = 2.obs;

  ItemsAndContainersScreenController(String theSearchText) {
    searchText = theSearchText;
  }

  void setItems(List<GenericItemContainerOrPlace> data) {
    stuff.assignAll(data);
  }
}

class ItemsAndContainersScreen extends StatelessWidget {
  late AppDatabase database;
  final globalKey = GlobalKey<ScaffoldState>();
  String? searchText;
  String? placeId;

  ItemsAndContainersScreen({super.key, @required this.searchText, @required this.placeId});

  @override
  Widget build(BuildContext context) {
    database = Provider.of<AppDatabase>(context);

    return GetBuilder<ItemsAndContainersScreenController>(
      init: ItemsAndContainersScreenController(""),
      builder: (controller) => Scaffold(
        appBar: _getItemsAndContainersAppBar(),
        drawer: const AppDrawer(),
        body: FutureBuilder<List<GenericItemContainerOrPlace>>(
          future: _getItemsAndContainersFromDatabase(searchText, placeId),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              controller.setItems(snapshot.data!);
              List<GenericItemContainerOrPlace>? itemList = controller.stuff;
              // TODO 2022-04-28 this null check *may* be able to be removed along with others like it
              if (itemList.isEmpty) {
                return Center(
                  child: Text(
                    'No items or containers found.',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                );
              } else {
                return itemOrContainerListUI(controller.stuff, controller.axisCount.value);
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
                'No items or containers found.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            );
          },
        ),
      ),
    );
  }

  Future<List<GenericItemContainerOrPlace>> _getItemsAndContainersFromDatabase(String? searchText, String? itemOrContainerId) async {
    return await database.getPlaceContents(itemOrContainerId!);

    // TODO 2022-10-13 some logic from other screens may be needed here someday

    // if (searchText != null && searchText.isEmpty == false) {
    //   // return await database.searchForItems(searchText);
    // } else if (itemOrContainerId != null && itemOrContainerId.isEmpty == false) {
    //   // return await database.getContainerContents(itemOrContainerId);
    //   return await database.getPlaceContents(itemOrContainerId);
    // } else {
    //   // return await database.getAllItems();
    // }
  }

  Widget itemOrContainerListUI(List<GenericItemContainerOrPlace> itemList, int axisCount) {
    return MasonryGridView.count(
      itemCount: itemList.length, // TODO may not be explicitly needed for MasonryGridView
      crossAxisCount: axisCount,
      mainAxisSpacing: 8,
      crossAxisSpacing: 4,
      padding: const EdgeInsets.only(top: 10, bottom: 16),
      itemBuilder: (context, index) {
        GenericItemContainerOrPlace itemOrContainerData = itemList[index];
        return InkWell(
          onTap: () {
            _navigateToDetail(itemOrContainerData);
          },
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 10),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), border: Border.all(color: Colors.black)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        itemOrContainerData.title,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    )
                  ],
                ),
                Text(
                  itemOrContainerData.description ?? "",
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      itemOrContainerData.date,
                      style: Theme.of(context).textTheme.titleSmall,
                    )
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }

  _navigateToDetail(GenericItemContainerOrPlace thing) async {
    if (thing.thingType == Differentiator.container)
    {
      Get.to(ContainerDetailScreen(containerId: thing.uniqueId)); // 2022-10-08 let route stack build
    }
    else
    {
      Get.to(ItemDetailScreen(itemId: thing.uniqueId)); // 2022-10-08 let route stack build
    }
  }

  _getItemsAndContainersAppBar() {
    final ItemsAndContainersScreenController p = Get.put(ItemsAndContainersScreenController(""));

    return AppBar(
      // backgroundColor: Colors.white,
      centerTitle: true,
      elevation: 0,
      title: const Text(
        'Items and Containers',
        // style: Theme.of(context).textTheme.headline5,
      ),
      actions: [
        IconButton(
          onPressed: () {
            if (p.axisCount.value == 1) {
              p.axisCount.value = 2;
            } else {
              p.axisCount.value = 1;
            }
            p.update();
          },
          icon: Icon(
            p.axisCount.value == 2 ? Icons.grid_on : Icons.list,
            // color: Colors.black,
          ),
        )
      ],
    );
  }
}