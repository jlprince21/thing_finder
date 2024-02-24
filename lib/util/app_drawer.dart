import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../screen/containers_screen.dart';
import '../screen/database_tools_screen.dart';
import '../screen/items_screen.dart';
import '../screen/main_menu_screen.dart';
import '../screen/places_screen.dart';
import '../screen/search_screen.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    List<Widget> drawerWidgets = <Widget>[];
    drawerWidgets.add(const DrawerHeader(
      decoration: BoxDecoration(
        color: Colors.blue,
      ),
      child: CircleAvatar(
        radius: 5,
        backgroundColor: Colors.green,
        child: Padding(
          padding: EdgeInsets.all(4), // Border radius
          child: ClipOval(child: Image(image: AssetImage('assets/icon/icon.png'))),
        ),
      ),
    ));
    drawerWidgets.addAll(getMenu(context, includeMainMenu: true));

    return Drawer(
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: drawerWidgets,
        ),
    );
  }

  static List<Widget> getMenu(BuildContext context, {required bool includeMainMenu})
  {
    List <Widget> menuEntries = <Widget>[];

    final ThemeData theme = Theme.of(context);
    final TextStyle textStyle = theme.textTheme.bodyMedium!;

    final List<Widget> aboutBoxChildren = <Widget>[
      const SizedBox(height: 24),
      RichText(
        text: TextSpan(
          children: <TextSpan>[
            TextSpan(
                style: textStyle,
                text: "Thing Finder helps you organize, store, and"
                    ' retrieve your... well... things!'),
            // TextSpan(text: '.'),
          ],
        ),
      ),
    ];

    if (includeMainMenu == true) {
      menuEntries.add(
        ListTile(
          title: const Text('Main Menu'),
          onTap: () {
            Get.to(MainMenuScreen()); // 2022-10-08 let route stack build
          },
        ),
      );
    }

    menuEntries.add(
      ListTile(
        title: const Text('Items'),
        onTap: () {
          // 2022-10-08 let route stack build
          Get.to(ItemsScreen(searchText: "", containerId: ""), preventDuplicates: false); // preventDuplicates allows us to return to items/containers page after search
        },
      ),
    );

    menuEntries.add(
      ListTile(
        title: const Text('Containers'),
        onTap: () {
          // 2022-10-08 let route stack build
          Get.to(ContainersScreen(searchText: ""), preventDuplicates: false); // preventDuplicates allows us to return to items/containers page after search
        },
      ),
    );

    menuEntries.add(
      ListTile(
        title: const Text('Places'),
        onTap: () {
          // 2022-10-08 let route stack build
          Get.to(PlacesScreen(searchText: ""), preventDuplicates: false); // preventDuplicates allows us to return to items/containers page after search
        },
      ),
    );

    menuEntries.add(
      ListTile(
        title: const Text('Search'),
        onTap: () {
          Get.to(const SearchScreen()); // 2022-10-08 let route stack build
        },
      ),
    );

    menuEntries.add(
      ListTile(
        title: const Text('Database Tools'),
        onTap: () {
          Get.to(DatabaseToolsScreen()); // 2022-10-08 let route stack build
        },
      ),
    );

    menuEntries.add(
      ListTile(
        title: const Text('About'),
        onTap: () {
          showAboutDialog(
            context: context,
            applicationIcon:
              const CircleAvatar(
                radius: 40,
                backgroundColor: Colors.green,
                child: Padding(
                  padding: EdgeInsets.all(4), // Border radius
                  child: ClipOval(child: Image(image: AssetImage('assets/icon/icon.png'))),
                ),
              ),
            applicationName: 'Thing Finder',
            applicationVersion: 'October 2022',
            applicationLegalese: '\u{a9} 2022 Magic Codex LLC',
            children: aboutBoxChildren,
          );
        },
      ),
    );

    return menuEntries;
  }
}