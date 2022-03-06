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
  late String? selectedContainer;
  late DbContainerData? currentContainer;

  @override
  void initState() {
    titleEditingController = TextEditingController();
    descriptionEditingController = TextEditingController();
    titleEditingController.text = widget.dbItemCompanion.title.value;
    descriptionEditingController.text = widget.dbItemCompanion.description.value ?? "";
    selectedContainer = null;
    currentContainer = null;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    appDatabase = Provider.of<AppDatabase>(context);

    if (widget.dbItemCompanion.container.value != null)
    {
      appDatabase
          .getContainer(widget.dbItemCompanion.container.value ?? "")
          .then((value) => setState(() {
                currentContainer = value;
              }));
    }

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
                    // TODO 2022-02-12 works when no containers are in DB but should investigate displaying a widget if snapshot data is null/fails to load
                    itemList.insert(0, DbContainerData(uniqueId: "no-container", title: "(No Container)", date: "2022-01-01", description: "(No Container)"));
                    return containerListPicker(itemList);
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
              Text("Inside container: " + currentContainer!.title)
            ]
          ],
        ),
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
        if (newValue?.uniqueId == "no-container")
        {
          selectedContainer = null;
        }
        else {
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

  Future<DbContainerData> _getContainerFromDatabase(String id) async {
    return await appDatabase.getContainer(id);
  }

  void _saveToDb() {
    if (widget.dbItemCompanion.uniqueId.present) {
      appDatabase
          .updateItem(DbItemData(
              uniqueId: widget.dbItemCompanion.uniqueId.value,
              title: titleEditingController.text,
              description: descriptionEditingController.text.isEmpty ? null : descriptionEditingController.text,
              date: DateFormat.yMMMd().format(DateTime.now()),
              container: selectedContainer))
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
            description: descriptionEditingController.text.isEmpty ? dr.Value(null) : dr.Value(descriptionEditingController.text),
            date: dr.Value(DateFormat.yMMMd().format(DateTime.now())),
            container: dr.Value(selectedContainer)))
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
                // TODO make delete work with just an id
                appDatabase
                    .deleteItem(DbItemData(
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
