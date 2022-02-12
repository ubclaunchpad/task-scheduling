import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CreateGroup extends StatefulWidget {
  const CreateGroup({Key? key, required this.id}) : super(key: key);
  final String id;
  @override
  State<CreateGroup> createState() => _CreateGroup();
}

class _CreateGroup extends State<CreateGroup> {
  final myController = TextEditingController();
  DateTime selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    myController.dispose();
    super.dispose();
  }

  void createAGroup() async {
    CollectionReference ref = FirebaseFirestore.instance.collection("groups");
    ref.add({
      "groupName": myController.text,
      "users": [widget.id],
    }).then((value) async {
      CollectionReference users =
          FirebaseFirestore.instance.collection("users");
      DocumentSnapshot doc = await users.doc(widget.id).get();
      dynamic groups = doc.data();
      Map<String, dynamic> newGroups = groups["groups"];
      newGroups[value.id] = myController.text;

      users.doc(widget.id).update({"groups": newGroups});
      Navigator.pop(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create A New Group'),
      ),
      body: Container(
        margin: const EdgeInsets.only(bottom: 30),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Card(
                child: Padding(
                  padding: EdgeInsets.only(top: 20.0, bottom: 20.0),
                  child: ListTile(
                    leading: Icon(Icons.info_outlined),
                    subtitle: Text(
                        'After creating a group, you can find the group panel by clicking on the top left corner'),
                  ),
                ),
              ),
              Text(widget.id),
              TextField(
                controller: myController,
                decoration: const InputDecoration(
                  //border: InputBorder.none,
                  hintText: "Group name",
                  hintStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    decoration: TextDecoration.none,
                    color: Colors.black,
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 30),
                child: Column(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        createAGroup();
                        // Navigator.pop(context);
                      },
                      child: const Text('Create'),
                    ),
                  ],
                ),
                // width: MediaQuery.of(context).size.width,
              ),
            ]),
      ),
    );
  }
}
