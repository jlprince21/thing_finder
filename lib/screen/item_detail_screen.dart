import 'package:drift/drift.dart' as dr;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:thing_finder/database/database.dart';
import 'package:thing_finder/screen/container_detail_screen.dart';

class ItemDetailScreen extends StatefulWidget {
  final String? itemId;
  const ItemDetailScreen({Key? key, required this.itemId}) : super(key: key);

  @override
  _ItemDetailScreenState createState() => _ItemDetailScreenState();
}

class _ItemDetailScreenState extends State<ItemDetailScreen> {
  late AppDatabase appDatabase;
  late TextEditingController titleEditingController;
  late TextEditingController descriptionEditingController;
  late String? selectedContainer;
  late DbContainerData? currentContainer;
  late DbItemData? theItem;

  @override
  void initState() {
    titleEditingController = TextEditingController();
    descriptionEditingController = TextEditingController();

    selectedContainer = null;
    currentContainer = null;
    theItem = null;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    appDatabase = Provider.of<AppDatabase>(context);

    return Scaffold(
      appBar: _getDetailAppBar(),
      body: FutureBuilder(
        future: appDatabase.getItem(widget.itemId ?? ""),
        builder: (context, AsyncSnapshot<DbItemData> snapshot) {
          if (snapshot.hasData) {
            theItem = snapshot.data;

            titleEditingController.text = theItem!.title;
            descriptionEditingController.text = theItem!.description ?? "";

            return FutureBuilder(
                future: appDatabase.getContainer(theItem?.container ?? ""),
                builder: (context, AsyncSnapshot<DbContainerData> snapshot) {
                  if (snapshot.hasData) {
                    currentContainer = snapshot.data;
                  } else {
                    currentContainer = null;
                  }

                  return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      child: Column(
                        children: [
                          FutureBuilder<List<DbContainerData>>(
                            future: _getContainersFromDatabase(),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                List<DbContainerData>? containerList = snapshot.data;
                                if (containerList != null) {
                                  containerList.insert(
                                      0,
                                      DbContainerData(
                                          uniqueId: "no-container",
                                          title: "(No Container)",
                                          date: "2022-01-01",
                                          description: "(No Container)"));
                                  return containerListPicker(containerList);
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
                                  'Click on add button to create new item',
                                  style: Theme.of(context).textTheme.bodyText2,
                                ),
                              );
                            },
                          ),
                          TextFormField(
                            controller: titleEditingController,
                            decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                hintText: 'Item Title'),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          TextFormField(
                            controller: descriptionEditingController,
                            maxLength: 100,
                            minLines: 4,
                            maxLines: 6,
                            decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                hintText: 'Item Description'),
                          ),
                          if (currentContainer != null) ...[
                            Text("Inside container: " + currentContainer!.title),
                            ElevatedButton(
                              onPressed: () {
                                // TODO 2022-03-19 another great place demonstrating need to use container id instead lol
                                Get.to(ContainerDetailScreen(
                                    title: 'Edit Container',
                                    dbContainerCompanion: DbContainerCompanion(
                                        date: dr.Value(currentContainer!.date),
                                        description: dr.Value(currentContainer!.description),
                                        title: dr.Value(currentContainer!.title),
                                        uniqueId: dr.Value(currentContainer!.uniqueId))));
                              },
                              child: const Text('Go to Container'),
                            ),
                          ]
                        ],
                      ));
                });
          } else {
            return Text('Something went wrong finding the item :(.');
          }
        },
      ),
    );
  }

  Widget containerListPicker(List<DbContainerData> containerList) {
    return DropdownButtonFormField<DbContainerData>(
      value: currentContainer ?? containerList[0],
      decoration: const InputDecoration(
        icon: Icon(Icons.widgets),
        hintText: 'Select container',
        labelText: 'Container *',
      ),
      icon: Icon(Icons.arrow_downward),
      iconSize: 24,
      elevation: 16,
      style: TextStyle(color: Colors.deepPurple),
      onChanged: (DbContainerData? newValue) {
        if (newValue?.uniqueId == "no-container") {
          selectedContainer = null;
        } else {
          selectedContainer = newValue?.uniqueId;
        }
      },
      items: containerList.map((DbContainerData container) {
        return DropdownMenuItem<DbContainerData>(
          value: container,
          child: Row(
            children: <Widget>[
              SizedBox(
                width: 10,
              ),
              Text(
                container.title,
                style: TextStyle(color: Colors.black),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  _getDetailAppBar() {
    return AppBar(
      elevation: 0,
      leading: IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: const Icon(
          Icons.chevron_left_outlined,
          // color: Colors.black,
        ),
      ),
      title: Text(
        "Edit Item",
        // style: const TextStyle(color: Colors.black),
      ),
      actions: [
        IconButton(
          onPressed: () {
            _saveToDb();
          },
          icon: const Icon(
            Icons.save,
            // color: Colors.black,
          ),
        ),
        IconButton(
          onPressed: () {
            _deleteItem();
          },
          icon: const Icon(
            Icons.delete,
            // color: Colors.black,
          ),
        ),
      ],
    );
  }

  Future<List<DbContainerData>> _getContainersFromDatabase() async {
    return await appDatabase.getAllContainers();
  }

  void _saveToDb() {
    appDatabase
        .updateItem(DbItemData(
            uniqueId: theItem!.uniqueId,
            title: titleEditingController.text,
            description: descriptionEditingController.text.isEmpty
                ? null
                : descriptionEditingController.text,
            date: DateFormat.yMMMd().format(DateTime.now()),
            container: selectedContainer))
        .then((value) {
      Navigator.pop(context, true);
    });
  }

  void _deleteItem() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Delete Confirmation'),
          content: Text('Do you really want to delete this?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                appDatabase.deleteItemById(theItem!.uniqueId).then((value) {
                  Navigator.pop(context, true);
                });
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}
