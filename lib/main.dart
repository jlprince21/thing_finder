import 'package:flutter/material.dart';
import 'package:thing_finder/database/database.dart';
import 'package:provider/provider.dart';
import 'package:thing_finder/screen/main_menu_screen.dart';
import 'package:get/get.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Provider<AppDatabase>(
      create: (context) => AppDatabase(),
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Thing Finder',
        home: const MainMenuScreen()
      ),
      dispose: (context, db) => db.close(),
    );
  }
}