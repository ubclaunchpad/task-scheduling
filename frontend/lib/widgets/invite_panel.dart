import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../src/task.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class InvitePanel extends StatefulWidget {
  const InvitePanel({Key? key, required this.id}) : super(key: key);
  final String id;
  @override
  State<InvitePanel> createState() => _InvitePanel();
}

class _InvitePanel extends State<InvitePanel> {
  void addUserToGroup(String emailId, String groupId) async {}

  // of the TextField.
  final myController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController.dispose();

    super.dispose();
  }

  Future<String> findGroupName(DocumentReference ref) async {
    dynamic data = await ref.get();
    return data.data()["groupName"];
  }

  @override
  Widget build(BuildContext context) {
    DocumentReference ref =
        FirebaseFirestore.instance.collection("groups").doc(widget.id);

    BorderRadiusGeometry radius = const BorderRadius.only(
      topLeft: Radius.circular(24.0),
      topRight: Radius.circular(24.0),
    );

    return Container(
      decoration: new BoxDecoration(
        borderRadius: radius,
        color: Color.fromRGBO(247, 227, 218, 1.0),
      ),
      child:
          Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Column(
          children: [
            Container(
              padding: const EdgeInsets.only(
                  top: 20.0, left: 20, right: 20, bottom: 10),
              child: Text(
                "Users",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
            Container(
              child: FutureBuilder<DocumentSnapshot?>(
                future: ref.get(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Text("s");
                  } else if (snapshot.hasError) {
                    return Text("ss");
                  } else {
                    dynamic data = snapshot.data!.data();

                    return Container(
                        height: 200,
                        child: ListView.builder(
                            itemCount: data["users"].length,
                            itemBuilder: (context, index) {
                              return Container(
                                  decoration: const BoxDecoration(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(20)),
                                      color:
                                          Color.fromRGBO(255, 244, 208, 1.0)),
                                  margin: const EdgeInsets.only(
                                      left: 20, right: 20, bottom: 5),
                                  width: MediaQuery.of(context).size.width,
                                  height: 40,
                                  child: Center(
                                    child: Text(
                                      data["users"][index],
                                      style: const TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ));
                            }));
                  }
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.only(
                  top: 1.0, left: 20, right: 20, bottom: 10),
              child: Text(
                "Invite by email",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              //color: Colors.red,

              padding: const EdgeInsets.only(
                  top: 5.0, left: 20, right: 20, bottom: 10),

              // height: MediaQuery.of(context).size.height * 0.09,
              child: Align(
                alignment: Alignment.centerLeft,
                child: TextField(
                  controller: myController,
                  decoration: const InputDecoration(
                    //border: InputBorder.none,
                    hintText: "name@email.com",
                    hintStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      decoration: TextDecoration.none,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        Container(
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(20)),
                color: Color.fromRGBO(255, 244, 208, 1.0)),
            margin: EdgeInsets.all(30),
            width: MediaQuery.of(context).size.width,
            height: 50,
            child: Container(
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  color: Color.fromRGBO(255, 244, 208, 1.0)),
              child: TextButton.icon(
                // style: TextButton.styleFrom(
                //   minimumSize:
                //       Size(MediaQuery.of(context).size.width, 100),
                // ),
                icon: Icon(Icons.add),
                label: const Text(
                  "Add email to group",
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                ),
                onPressed: () => {
                  addUserToGroup();
                },
              ),
            )),
      ]),
    );
  }
}
