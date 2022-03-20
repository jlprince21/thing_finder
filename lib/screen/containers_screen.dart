import 'package:drift/drift.dart' as dr;
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:thing_finder/database/database.dart';
import 'package:thing_finder/screen/container_detail_screen.dart';
import 'package:thing_finder/util/app_drawer.dart';

class ContainersScreen extends StatefulWidget {
  final String searchText;

  const ContainersScreen({Key? key, required this.searchText}) : super(key: key);

  @override
  _ContainersScreenState createState() => _ContainersScreenState();
}

class _ContainersScreenState extends State<ContainersScreen> {
  late AppDatabase database;
  int axisCount = 2;
  @override
  Widget build(BuildContext context) {
    database = Provider.of<AppDatabase>(context);
    return Scaffold(
      appBar: _getContainersAppBar(),
      drawer: AppDrawer(),
      body: FutureBuilder<List<DbContainerData>>(
        future: _getContainersFromDatabase(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<DbContainerData>? containerList = snapshot.data;
            if (containerList != null) {
              if (containerList.isEmpty) {
                return Center(
                  child: Text(
                    'No containers found; click on add button to create one.',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                );
              } else {
                return containerListUI(containerList);
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
              'Click on add button to create new container',
              style: Theme.of(context).textTheme.bodyText2,
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _navigateToDetail(
              'Add Container',
              const DbContainerCompanion(
                  title: dr.Value(''),
                  description: dr.Value('')));
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

  Future<List<DbContainerData>> _getContainersFromDatabase() async {
    if (widget.searchText.isEmpty)
    {
      return await database.getAllContainers();
    }
    else
    {
      return await database.searchForContainers(widget.searchText);
    }
  }

  Widget containerListUI(List<DbContainerData> containerList) {
    return StaggeredGridView.countBuilder(
      itemCount: containerList.length,
      crossAxisCount: 4,
      staggeredTileBuilder: (index) => StaggeredTile.fit(axisCount),
      mainAxisSpacing: 8,
      crossAxisSpacing: 4,
      padding: EdgeInsets.only(top: 10),
      itemBuilder: (context, index) {
        DbContainerData dbContainerData = containerList[index];
        return InkWell(
          onTap: () {
            _navigateToDetail(
              'Edit Container',
              DbContainerCompanion(
                  uniqueId: dr.Value(dbContainerData.uniqueId),
                  title: dr.Value(dbContainerData.title),
                  description: dr.Value(dbContainerData.description)),
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
                        dbContainerData.title,
                        style: Theme.of(context).textTheme.bodyText2,
                      ),
                    )
                  ],
                ),
                Text(
                  dbContainerData.description ?? "",
                  style: Theme.of(context).textTheme.bodyText1,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      dbContainerData.date,
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

  _navigateToDetail(String title, DbContainerCompanion dbContainerCompanion) async {
    // TODO 2022-03-20 this needs getx replacement but state doesn't work quite properly eg
    // deleted item will still appear on item screen. would be nice to have it properly
    // navigate *back* to item/container search with original parameters too
    var res = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ContainerDetailScreen(
          title: title,
          dbContainerCompanion: dbContainerCompanion,
        ),
      ),
    );
    if (res != null && res == true) {
      setState(() {});
    }
  }

  _getContainersAppBar() {
    return AppBar(
      // backgroundColor: Colors.white,
      centerTitle: true,
      elevation: 0,
      title: Text(
        'Containers',
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
