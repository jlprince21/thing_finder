import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thing_finder/database/database.dart';
import 'package:thing_finder/util/app_drawer.dart';

class MainMenuScreen extends StatelessWidget {
  late AppDatabase appDatabase;

  MainMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    appDatabase = Provider.of<AppDatabase>(context);

    return Scaffold(
      appBar: _getMainMenuAppBar(),
      drawer: const AppDrawer(),
      body: ListView(
          // Important: Remove any padding from the ListView.
          // padding: EdgeInsets.zero,
          children: AppDrawer.getMenu(context, includeMainMenu: false)),
    );
  }

  ButtonStyle getButtonStyle() {
    return ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ));
  }

  _getMainMenuAppBar() {
    return AppBar(
      // backgroundColor: Colors.white,
      centerTitle: true,
      elevation: 0,
      title: const Text(
        'Main Menu',
        // style: Theme.of(context).textTheme.headline5,
      ),
    );
  }
}