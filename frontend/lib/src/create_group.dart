import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lp_task_scheduler/styles/theme.dart';
import 'package:lp_task_scheduler/widgets/button.dart';
import 'package:lp_task_scheduler/widgets/invite_panel.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          elevation: 0,
          bottom: PreferredSize(
              child: Container(
                color: Colors.grey,
                height: 0.5,
              ),
              preferredSize: const Size.fromHeight(10.0)),
          title: const Text("New Group")),
      body: Container(
        margin: const EdgeInsets.only(top: 30, bottom: 30),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Stack(
                alignment: AlignmentDirectional.center,
                children: [
                  Container(
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.black,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(100),
                        color: scheme.primary),
                  ),
                  const Icon(
                    Icons.groups_outlined,
                    size: 80,
                    color: Colors.black,
                  ),
                ],
              ),
              Container(
                padding: EdgeInsets.all(30),
                child: TextField(
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
              ),
              Column(
                children: [
                  Button(
                      label: "Create Group", onPressedF: () => createAGroup()),
                  Button(
                      label: "Invite Users",
                      onPressedF: () => _showCupertinoDialog()),
                ],
              ),
            ]),
      ),
    );
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

  _dismissDialog() {
    Navigator.pop(context);
  }

  void _showCupertinoDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return Center(
            child: Container(
                width: MediaQuery.of(context).size.width * 0.8,
                height: MediaQuery.of(context).size.height * 0.6,
                child: Scaffold(
                    backgroundColor: Colors.transparent,
                    body: Center(child: InvitePanel(id: "ss")))),
          );
        });
  }
}
