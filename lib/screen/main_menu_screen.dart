import 'package:flutter/material.dart';
import 'package:thing_finder/screen/items_screen.dart';
import 'package:thing_finder/screen/containers_screen.dart';

class MainMenuScreen extends StatefulWidget {
  const MainMenuScreen({Key? key}) : super(key: key);

  @override
  _MainMenuScreenState createState() => _MainMenuScreenState();
}

class _MainMenuScreenState extends State<MainMenuScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _getMainMenuAppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: <Widget>[
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    child: Text('Items'),
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => ItemsScreen()));
                    },
                  ),
                ),
              ),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    child: Text('Containers'),
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => ContainersScreen()));
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _getMainMenuAppBar(){
    return AppBar(
      backgroundColor: Colors.white,
      centerTitle: true,
      elevation: 0,
      title: Text(
        'Main Menu',
        style: Theme.of(context).textTheme.headline5,
      ),
    );
  }
}