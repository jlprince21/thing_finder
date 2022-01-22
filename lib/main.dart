import 'package:flutter/material.dart';

import 'package:thing_finder/database/database.dart';
import 'package:thing_finder/screen/containers_screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (context) => AppDatabase(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Thing Finder',
        home: const ContainersScreen(),
      ),
    );
  }
}