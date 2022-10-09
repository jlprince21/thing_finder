import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:thing_finder/database/database.dart';
import 'package:thing_finder/screen/item_create_screen.dart';
import 'package:thing_finder/screen/item_detail_screen.dart';
import 'package:thing_finder/util/app_drawer.dart';

class ItemsScreenController extends GetxController {
  String? searchText;
  var stuff = <DbItemData>[].obs;

  var axisCount = 2.obs;

  ItemsScreenController(String theSearchText) {
    searchText = theSearchText;
  }

  void setItems(List<DbItemData> data) {
    stuff.assignAll(data);
  }
}

class ItemsScreen extends StatelessWidget {
  late AppDatabase database;
  final globalKey = GlobalKey<ScaffoldState>();
  String? searchText;
  String? containerId;

  ItemsScreen({@required this.searchText, @required this.containerId});

  @override
  Widget build(BuildContext context) {
    database = Provider.of<AppDatabase>(context);

    return GetBuilder<ItemsScreenController>(
      init: ItemsScreenController(""),
      builder: (controller) => Scaffold(
        appBar: _getItemsAppBar(),
        drawer: AppDrawer(),
        body: FutureBuilder<List<DbItemData>>(
          future: _getItemsFromDatabase(searchText, containerId),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              controller.setItems(snapshot.data!);
              List<DbItemData>? itemList = controller.stuff;
              if (itemList != null) { // TODO 2022-04-28 this null check *may* be able to be removed along with others like it
                if (itemList.isEmpty) {
                  return Center(
                    child: Text(
                      'No items found; click on add button to create one.',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyText2,
                    ),
                  );
                } else {
                  return itemListUI(controller.stuff, controller.axisCount.value);
                }
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
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _navigateToCreate();
          },
          shape: const CircleBorder(
            side: BorderSide(color: Colors.black, width: 2),
          ),
          backgroundColor: Colors.white,
          child: const Icon(
            Icons.add,
            color: Colors.black,
          ),
        ),
      ),
    );
  }

  Future<List<DbItemData>> _getItemsFromDatabase(String? searchText, String? containerId) async {
    if (searchText != null && searchText.isEmpty == false) {
      return await database.searchForItems(searchText);
    } else if (containerId != null && containerId.isEmpty == false) {
      return await database.getContainerContents(containerId);
    } else {
      return await database.getAllItems();
    }
  }

  Widget itemListUI(List<DbItemData> itemList, int axisCount) {
    return MasonryGridView.count(
      itemCount: itemList.length, // TODO may not be explicitly needed for MasonryGridView
      crossAxisCount: axisCount,
      mainAxisSpacing: 8,
      crossAxisSpacing: 4,
      padding: const EdgeInsets.only(top: 10, bottom: 16),
      itemBuilder: (context, index) {
        DbItemData dbItemData = itemList[index];
        return InkWell(
          onTap: () {
            _navigateToDetail(dbItemData.uniqueId);
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
                        dbItemData.title,
                        style: Theme.of(context).textTheme.bodyText2,
                      ),
                    )
                  ],
                ),
                Text(
                  dbItemData.description ?? "",
                  style: Theme.of(context).textTheme.bodyText1,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      dbItemData.date,
                      style: Theme.of(context).textTheme.subtitle2,
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

  _navigateToDetail(String itemId) async {
    Get.to(ItemDetailScreen(itemId: itemId)); // 2022-10-08 let route stack build
  }

  _navigateToCreate() async {
    Get.to(ItemCreateScreen()); // 2022-10-08 let route stack build
  }

  _getItemsAppBar() {
    final ItemsScreenController _p = Get.put(ItemsScreenController(""));

    return AppBar(
      // backgroundColor: Colors.white,
      centerTitle: true,
      elevation: 0,
      title: const Text(
        'Items',
        // style: Theme.of(context).textTheme.headline5,
      ),
      actions: [
        IconButton(
          onPressed: () {
            if (_p.axisCount.value == 1) {
              _p.axisCount.value = 2;
            } else {
              _p.axisCount.value = 1;
            }
            _p.update();
          },
          icon: Icon(
            _p.axisCount.value == 2 ? Icons.grid_on : Icons.list,
            // color: Colors.black,
          ),
        )
      ],
    );
  }
}