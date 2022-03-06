import 'package:drift/drift.dart' as dr;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:thing_finder/database/database.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class ContainerDetailScreen extends StatefulWidget {
  final String title;
  final DbContainerCompanion dbContainerCompanion;
  const ContainerDetailScreen({Key? key, required this.title, required this.dbContainerCompanion}): super(key: key);

  @override
  _ContainerDetailScreenState createState() => _ContainerDetailScreenState();
}

class _ContainerDetailScreenState extends State<ContainerDetailScreen> {
  late AppDatabase appDatabase;
  late TextEditingController titleEditingController;
  late TextEditingController descriptionEditingController;

  @override
  void initState() {
    titleEditingController = TextEditingController();
    descriptionEditingController = TextEditingController();
    titleEditingController.text = widget.dbContainerCompanion.title.value;
    descriptionEditingController.text = widget.dbContainerCompanion.description.value ?? "";
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
            TextFormField(
              controller: titleEditingController,
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  hintText: 'Container Title'),
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
                  hintText: 'Container Description'),
            ),
          ],
        ),
      ),
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
            _deleteContainer();
          },
          icon: const Icon(
            Icons.delete,
            color: Colors.black,
          ),
        ),
      ],
    );
  }

  void _saveToDb() {
    if (widget.dbContainerCompanion.uniqueId.present) {
      appDatabase
          .updateContainer(DbContainerData(
              uniqueId: widget.dbContainerCompanion.uniqueId.value,
              title: titleEditingController.text,
              description: descriptionEditingController.text.isEmpty ? null : descriptionEditingController.text,
              date: DateFormat.yMMMd().format(DateTime.now())))
          .then((value) {
        Navigator.pop(context, true);
      });
    } else {
      var uuid = Uuid();
      var id = uuid.v4();

      appDatabase
          .createContainer(DbContainerCompanion(
              uniqueId: dr.Value(id),
              title: dr.Value(titleEditingController.text),
              description: descriptionEditingController.text.isEmpty ? dr.Value(null) : dr.Value(descriptionEditingController.text),
              date: dr.Value(DateFormat.yMMMd().format(DateTime.now()))))
          .then((value) {
        Navigator.pop(context, true);
      });
    }
  }

  void _deleteContainer() {
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
                    .deleteContainer(DbContainerData(
                        uniqueId: widget.dbContainerCompanion.uniqueId.value,
                        title: widget.dbContainerCompanion.title.value,
                        description: widget.dbContainerCompanion.description.value,
                        date: DateFormat.yMMMd().format(DateTime.now())))
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
