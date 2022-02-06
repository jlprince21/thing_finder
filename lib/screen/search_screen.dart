import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:thing_finder/screen/containers_screen.dart';
import 'package:thing_finder/screen/items_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late TextEditingController searchController;

  String searchType = "item";

  @override
  void initState() {
    searchController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _getSearchAppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: searchController,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    hintText: 'Search Text'),
              ),
              ListTile(
                title: Text("Item"),
                leading: Radio(
                    value: "item",
                    groupValue: searchType,
                    onChanged: (value) {
                      setState(() {
                        searchType = value.toString();
                      });
                    }),
              ),
              ListTile(
                title: Text("Container"),
                leading: Radio(
                    value: "container",
                    groupValue: searchType,
                    onChanged: (value) {
                      setState(() {
                        searchType = value.toString();
                      });
                    }),
              ),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    child: Text('Search'),
                    onPressed: () {
                      if (searchType == "item")
                      {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => ItemsScreen(searchText: searchController.text)));
                      }
                      else
                      {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => ContainersScreen(searchText: searchController.text)));
                      }
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

  _getSearchAppBar(){
    return AppBar(
      backgroundColor: Colors.white,
      centerTitle: true,
      elevation: 0,
      title: Text(
        'Search',
        style: Theme.of(context).textTheme.headline5,
      ),
    );
  }
}