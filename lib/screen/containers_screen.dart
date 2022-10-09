import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:thing_finder/database/database.dart';
import 'package:thing_finder/screen/container_create_screen.dart';
import 'package:thing_finder/screen/container_detail_screen.dart';
import 'package:thing_finder/util/app_drawer.dart';

class ContainersScreenController extends GetxController {
  String? searchText;
  var stuff = <DbContainerData>[].obs;

  var axisCount = 2.obs;

  ContainersScreenController(String theSearchText) {
    searchText = theSearchText;
  }

  void setContainers(List<DbContainerData> data) {
    stuff.assignAll(data);
  }
}

class ContainersScreen extends StatelessWidget {
  late AppDatabase database;
  final globalKey = GlobalKey<ScaffoldState>();
  String? searchText;

  ContainersScreen({@required this.searchText});

  @override
  Widget build(BuildContext context) {
    database = Provider.of<AppDatabase>(context);

    return GetBuilder<ContainersScreenController>(
      init: ContainersScreenController(""),
      builder: (controller) => Scaffold(
        appBar: _getContainersAppBar(context),
        drawer: AppDrawer(),
        key: globalKey, // TODO still need globalkey?
        body: Center(
          child: FutureBuilder<List<DbContainerData>>(
            future: _getContainersFromDatabase(searchText),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(
                  child: Text(
                    'Error: ' + snapshot.error.toString(),
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                );
              } else if (snapshot.hasData && snapshot.data!.length > 0) {
                controller.setContainers(snapshot.data!);
                return containerListUI(controller.stuff, controller.axisCount.value);
              } else {
                return Center(
                  child: Text(
                    'No containers found; click on add button to create one.',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                );
              }
            },
          ),
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

  Future<List<DbContainerData>> _getContainersFromDatabase(String? searchText) async {
    if (searchText == null || searchText.isEmpty) {
      return await database.getAllContainers();
    } else {
      return await database.searchForContainers(searchText);
    }
  }

  Widget containerListUI(List<DbContainerData> containerList, int axisCount) {
    return MasonryGridView.count(
      itemCount: containerList.length, // TODO may not be explicitly needed for MasonryGridView
      crossAxisCount: axisCount,
      mainAxisSpacing: 8,
      crossAxisSpacing: 4,
      padding: const EdgeInsets.only(top: 10, bottom: 16),
      itemBuilder: (context, index) {
        DbContainerData dbContainerData = containerList[index];
        return InkWell(
          onTap: () {
            _navigateToDetail(dbContainerData.uniqueId);
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

  _navigateToCreate() {
    Get.offAll(ContainerCreateScreen());
  }

  _navigateToDetail(String? containerId) async {
    Get.to(ContainerDetailScreen(containerId: containerId!)); // 2022-10-08 let route stack build
  }

  _getContainersAppBar(BuildContext context) {
    final ContainersScreenController _p = Get.put(ContainersScreenController(""));

    return AppBar(
      // backgroundColor: Colors.white,
      centerTitle: true,
      elevation: 0,
      title: const Text(
        'Containers',
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
