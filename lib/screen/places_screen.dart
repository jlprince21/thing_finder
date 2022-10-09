import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:thing_finder/database/database.dart';
import 'package:thing_finder/screen/place_create_screen.dart';
// import 'package:thing_finder/screen/place_detail_screen.dart';
import 'package:thing_finder/util/app_drawer.dart';

class PlacesScreenController extends GetxController {
  String? searchText;
  var stuff = <DbPlaceData>[].obs;

  var axisCount = 2.obs;

  PlacesScreenController(String theSearchText) {
    searchText = theSearchText;
  }

  void setPlaces(List<DbPlaceData> data) {
    stuff.assignAll(data);
  }
}

class PlacesScreen extends StatelessWidget {
  late AppDatabase database;
  final globalKey = GlobalKey<ScaffoldState>();
  String? searchText;

  PlacesScreen({@required this.searchText});

  @override
  Widget build(BuildContext context) {
    database = Provider.of<AppDatabase>(context);

    return GetBuilder<PlacesScreenController>(
      init: PlacesScreenController(""),
      builder: (controller) => Scaffold(
        appBar: _getPlacesAppBar(context),
        drawer: AppDrawer(),
        key: globalKey, // TODO still need globalkey?
        body: Center(
          child: FutureBuilder<List<DbPlaceData>>(
            future: _getPlacesFromDatabase(searchText),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(
                  child: Text(
                    'Error: ' + snapshot.error.toString(),
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                );
              } else if (snapshot.hasData && snapshot.data!.length > 0) {
                controller.setPlaces(snapshot.data!);
                return placeListUI(controller.stuff, controller.axisCount.value);
              } else {
                return Center(
                  child: Text(
                    'No places found; click on add button to create one.',
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

  Future<List<DbPlaceData>> _getPlacesFromDatabase(String? searchText) async {
    if (searchText == null || searchText.isEmpty) {
      return await database.getAllPlaces();
    } else {
      return await database.searchForPlaces(searchText);
    }
  }

  Widget placeListUI(List<DbPlaceData> placeList, int axisCount) {
    return MasonryGridView.count(
      itemCount: placeList.length, // TODO may not be explicitly needed for MasonryGridView
      crossAxisCount: axisCount,
      mainAxisSpacing: 8,
      crossAxisSpacing: 4,
      padding: const EdgeInsets.only(top: 10, bottom: 16),
      itemBuilder: (context, index) {
        DbPlaceData dbPlaceData = placeList[index];
        return InkWell(
          onTap: () {
            // _navigateToDetail(dbPlaceData.uniqueId);
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
                        dbPlaceData.title,
                        style: Theme.of(context).textTheme.bodyText2,
                      ),
                    )
                  ],
                ),
                Text(
                  dbPlaceData.description ?? "",
                  style: Theme.of(context).textTheme.bodyText1,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      dbPlaceData.date,
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
    Get.offAll(PlaceCreateScreen());
  }

  // _navigateToDetail(String? placeId) async {
  //   Get.to(PlaceDetailScreen(placeId: placeId!)); // 2022-10-08 let route stack build
  // }

  _getPlacesAppBar(BuildContext context) {
    final PlacesScreenController _p = Get.put(PlacesScreenController(""));

    return AppBar(
      // backgroundColor: Colors.white,
      centerTitle: true,
      elevation: 0,
      title: const Text(
        'Places',
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
