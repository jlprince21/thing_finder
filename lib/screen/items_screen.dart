import 'package:drift/drift.dart' as dr;
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:thing_finder/database/database.dart';
import 'package:thing_finder/screen/item_create_screen.dart';
import 'package:thing_finder/screen/item_detail_screen.dart';
import 'package:thing_finder/util/app_drawer.dart';

class ItemsScreen extends StatefulWidget {
  final String searchText;
  final String containerId;

  // TODO 2022-03-19 someday having an enum to get this more manageable with just one
  // search/filter string would simplify things
  const ItemsScreen({Key? key, required this.searchText, required this.containerId}) : super(key: key);

  @override
  _ItemsScreenState createState() => _ItemsScreenState();
}

class _ItemsScreenState extends State<ItemsScreen> {
  late AppDatabase database;
  int axisCount = 2;
  @override
  Widget build(BuildContext context) {
    database = Provider.of<AppDatabase>(context);
    return Scaffold(
      appBar: _getItemsAppBar(),
      drawer: AppDrawer(),
      body: FutureBuilder<List<DbItemData>>(
        future: _getItemsFromDatabase(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<DbItemData>? itemList = snapshot.data;
            if (itemList != null) {
              if (itemList.isEmpty) {
                return Center(
                  child: Text(
                    'No items found; click on add button to create one.',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                );
              } else {
                return itemListUI(itemList);
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
    );
  }

  Future<List<DbItemData>> _getItemsFromDatabase() async {
    if (widget.searchText.isEmpty == false && widget.containerId.isEmpty)
    {
      return await database.searchForItems(widget.searchText);
    }
    else if (widget.searchText.isEmpty && widget.containerId.isEmpty == false)
    {
      return await database.getContainerContents(widget.containerId);
    }
    else
    {
      return await database.getAllItems();
    }
  }

  Widget itemListUI(List<DbItemData> itemList) {
    return StaggeredGridView.countBuilder(
      itemCount: itemList.length,
      crossAxisCount: 4,
      staggeredTileBuilder: (index) => StaggeredTile.fit(axisCount),
      mainAxisSpacing: 8,
      crossAxisSpacing: 4,
      padding: EdgeInsets.only(top: 10),
      itemBuilder: (context, index) {
        DbItemData dbItemData = itemList[index];
        return InkWell(
          onTap: () {
            _navigateToDetail(
              DbItemCompanion(
                  uniqueId: dr.Value(dbItemData.uniqueId),
                  title: dr.Value(dbItemData.title),
                  description: dr.Value(dbItemData.description),
                  container: dr.Value(dbItemData.container)),
            );
          },
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 10),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                border: Border.all(color: Colors.black)),
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

  _navigateToDetail(DbItemCompanion dbItemCompanion) async {
    var res = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ItemDetailScreen(
          itemId: dbItemCompanion.uniqueId.value,
        ),
      ),
    );
    if (res != null && res == true) {
      setState(() {});
    }
  }

  _navigateToCreate() async {
    var res = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ItemCreateScreen(),
      ),
    );
    if (res != null && res == true) {
      setState(() {});
    }
  }

  _getItemsAppBar() {
    return AppBar(
      // backgroundColor: Colors.white,
      centerTitle: true,
      elevation: 0,
      title: Text(
        'Items',
        // style: Theme.of(context).textTheme.headline5,
      ),
      actions: [
        IconButton(
          onPressed: () {
            if (axisCount == 2) {
              axisCount = 4;
            } else {
              axisCount = 2;
            }
            setState(() {});
          },
          icon: Icon(
            axisCount == 4 ? Icons.grid_on : Icons.list,
            // color: Colors.black,
          ),
        )
      ],
    );
  }
}
