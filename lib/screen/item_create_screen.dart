import 'package:drift/drift.dart' as dr;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:thing_finder/database/database.dart';
import 'package:uuid/uuid.dart';

class ItemCreateScreen extends StatefulWidget {
  const ItemCreateScreen({Key? key}) : super(key: key);

  @override
  _ItemCreateScreenState createState() => _ItemCreateScreenState();
}

class _ItemCreateScreenState extends State<ItemCreateScreen> {
  late AppDatabase appDatabase;
  late TextEditingController titleEditingController;
  late TextEditingController descriptionEditingController;
  late String? selectedContainer;

  @override
  void initState() {
    titleEditingController = TextEditingController();
    descriptionEditingController = TextEditingController();
    titleEditingController.text = "";
    descriptionEditingController.text = "";
    selectedContainer = null;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    appDatabase = Provider.of<AppDatabase>(context);

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
                  List<DbContainerData>? containerList = snapshot.data;
                  if (containerList != null) {
                    containerList.insert(0, DbContainerData(uniqueId: "no-container", title: "(No Container)", date: "2022-01-01", description: "(No Container)"));
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
          ],
        ),
      ),
    );
  }

  Widget containerListPicker(List<DbContainerData> containerList) {
    return DropdownButtonFormField<DbContainerData>(
      value: containerList[0],
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
          // color: Colors.black,
        ),
      ),
      title: Text(
        "Add Item",
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
      ],
    );
  }

  Future<List<DbContainerData>> _getContainersFromDatabase() async {
    return await appDatabase.getAllContainers();
  }

  void _saveToDb() {
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
