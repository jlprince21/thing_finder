import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../screen/containers_screen.dart';
import '../screen/database_tools_screen.dart';
import '../screen/items_screen.dart';
import '../screen/main_menu_screen.dart';
import '../screen/search_screen.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<Widget> drawerWidgets = <Widget>[];
    drawerWidgets.add(const DrawerHeader(
      decoration: BoxDecoration(
        color: Colors.blue,
      ),
      child: Text('Thing Finder!'),
    ));
    drawerWidgets.addAll(getMenu());

    return Drawer(
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: drawerWidgets,
        ),
    );
  }

  static List<Widget> getMenu()
  {
    List <Widget> menuEntries = <Widget>[];

    menuEntries.add(
      ListTile(
        title: const Text('Main Menu'),
        onTap: () {
          Get.to(MainMenuScreen());
        },
      ),
    );

    menuEntries.add(
      ListTile(
        title: const Text('Items'),
        onTap: () {
          Get.to(ItemsScreen(searchText: ""));
        },
      ),
    );

    menuEntries.add(
      ListTile(
        title: const Text('Containers'),
        onTap: () {
          Get.to(ContainersScreen(searchText: ""));
        },
      ),
    );

    menuEntries.add(
      ListTile(
        title: const Text('Search'),
        onTap: () {
          Get.to(SearchScreen());
        },
      ),
    );

    menuEntries.add(
      ListTile(
        title: const Text('Database Tools'),
        onTap: () {
          Get.to(DatabaseToolsScreen());
        },
      ),
    );

    return menuEntries;
  }
}