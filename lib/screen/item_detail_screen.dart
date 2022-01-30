import 'package:drift/drift.dart' as dr;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:thing_finder/database/database.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class ItemDetailScreen extends StatefulWidget {
  final String title;
  final DbItemCompanion dbItemCompanion;
  const ItemDetailScreen({Key? key, required this.title, required this.dbItemCompanion})
      : super(key: key);

  @override
  _ItemDetailScreenState createState() => _ItemDetailScreenState();
}

class _ItemDetailScreenState extends State<ItemDetailScreen> {
  late AppDatabase appDatabase;
  late TextEditingController titleEditingController;
  late TextEditingController descriptionEditingController;
  late int? selectedContainer;
  late DbContainerData currentContainer;

  @override
  void initState() {
    titleEditingController = TextEditingController();
    descriptionEditingController = TextEditingController();
    titleEditingController.text = widget.dbItemCompanion.title.value;
    descriptionEditingController.text = widget.dbItemCompanion.description.value;
    currentContainer = new DbContainerData(id: 0, uniqueId: "", date: "2022-01-01", description: "placeholder description", title: "placeholder title");

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    appDatabase = Provider.of<AppDatabase>(context);

    // TODO this needs to handle nulls ie when an item isn't in a container
    appDatabase
        .getContainer(widget.dbItemCompanion.container.value ?? 0)
        .then((value) => setState(() {
              currentContainer = value;
            }));

    return Scaffold(
      appBar: _getDetailAppBar(),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Column(
          children: [
            FutureBuilder<List<DbContainerData>>(
              future: _getContainersFromDatabase(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List<DbContainerData>? itemList = snapshot.data;
                  if (itemList != null) {
                    if (itemList.isEmpty) {
                      return Center(
                        child: Text(
                          'No containers found; click on add button to create one.',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyText2,
                        ),
                      );
                    } else {
                      return containerListPicker(itemList);
                    }
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

            // TODO these need to conditionally render only to show on item detail
            Text("Current container title: " + currentContainer.title),
            Text("Current container id: " + currentContainer.id.toString()),
            Text("Current container uuid: " + currentContainer.uniqueId.toString()),
          ],
        ),
      ),
    );
  }

  Widget containerListPicker(List<DbContainerData> containerList) {
    return DropdownButtonFormField<DbContainerData>(
      decoration: const InputDecoration(
        icon: Icon(Icons.widgets),
        hintText: 'Select container',
        labelText: 'Container *',
      ),
      // value: selectedContainer,
      icon: Icon(Icons.arrow_downward),
      iconSize: 24,
      elevation: 16,
      style: TextStyle(color: Colors.deepPurple),
      onChanged: (DbContainerData? newValue) {
        // TODO make null work with item's selected container
        selectedContainer = newValue?.id ?? 0;
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
          color: Colors.black,
        ),
      ),
      title: Text(
        widget.title,
        style: const TextStyle(color: Colors.black),
      ),
      actions: [
        IconButton(
          onPressed: () {
            _saveToDb();
          },
          icon: const Icon(
            Icons.save,
            color: Colors.black,
          ),
        ),
        IconButton(
          onPressed: () {
            _deleteItem();
          },
          icon: const Icon(
            Icons.delete,
            color: Colors.black,
          ),
        ),
      ],
    );
  }

  Future<List<DbContainerData>> _getContainersFromDatabase() async {
    return await appDatabase.getAllContainers();
  }

  Future<DbContainerData> _getContainerFromDatabase(int id) async {
    return await appDatabase.getContainer(id);
  }

  void _saveToDb() {
    // TODO for container in either saves below need to allow nulls
    if (widget.dbItemCompanion.id.present) {
      appDatabase
          .updateItem(DbItemData(
              id: widget.dbItemCompanion.id.value,
              uniqueId: widget.dbItemCompanion.uniqueId.value,
              title: titleEditingController.text,
              description: descriptionEditingController.text,
              date: DateFormat.yMMMd().format(DateTime.now()),
              container: selectedContainer ?? 0))
          .then((value) {
        Navigator.pop(context, true);
      });
    } else {
      var uuid = Uuid();
      var id = uuid.v4();

      appDatabase
          .createItem(DbItemCompanion(
            uniqueId: dr.Value(id),
            title: dr.Value(titleEditingController.text),
            description: dr.Value(descriptionEditingController.text),
            date: dr.Value(DateFormat.yMMMd().format(DateTime.now())),
            container: dr.Value(selectedContainer),
      ))
          .then((value) {
        Navigator.pop(context, true);
      });
    }
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
                appDatabase
                    .deleteItem(DbItemData(
                        id: widget.dbItemCompanion.id.value,
                        uniqueId: widget.dbItemCompanion.uniqueId.value,
                        title: widget.dbItemCompanion.title.value,
                        description: widget.dbItemCompanion.description.value,
                        date: DateFormat.yMMMd().format(DateTime.now()),
                        container: widget.dbItemCompanion.container.value))
                    .then((value) {
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
