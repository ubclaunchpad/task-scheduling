import 'package:flutter/material.dart';
import '../src/task.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class GroupPanel extends StatefulWidget {
  const GroupPanel(
      {Key? key, required this.userid, required this.id, required this.change})
      : super(key: key);

  final String id;
  final String userid;
  final Function change;
  @override
  State<GroupPanel> createState() => _GroupPanel();
}

class _GroupPanel extends State<GroupPanel> {
  // of the TextField.
  final myController = TextEditingController();
  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController.dispose();

    super.dispose();
  }

  Future<DocumentSnapshot> getGroups() {
    DocumentReference ref =
        FirebaseFirestore.instance.collection("users").doc(widget.userid);
    return ref.get();
  }

  @override
  Widget build(BuildContext context) {
    BorderRadiusGeometry radius = const BorderRadius.only(
      topLeft: Radius.circular(24.0),
      topRight: Radius.circular(24.0),
    );

    return Container(
      decoration: BoxDecoration(
        borderRadius: radius,
        color: const Color.fromRGBO(247, 227, 218, 1.0),
      ),
      child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
        Column(
          children: [
            Container(
              padding: const EdgeInsets.only(
                  top: 20.0, left: 20, right: 20, bottom: 10),
              child: const Text(
                "Choose Group",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
          ],
        ),
        FutureBuilder<DocumentSnapshot?>(
            future: getGroups(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) return Text("");

              if (snapshot.hasError)
                return Text("");
              else {
                dynamic data = snapshot.data!.data();
                dynamic g = [];
                data["groups"].forEach((k, v) {
                  g.add([k, v]);
                });

                return Container(
                    height: 200,
                    child: ListView.builder(
                        itemCount: g.length,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return Container(
                              decoration: const BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20)),
                                  color: Color.fromRGBO(255, 244, 208, 1.0)),
                              margin: EdgeInsets.all(10),
                              width: MediaQuery.of(context).size.width,
                              child: Container(
                                decoration: const BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20)),
                                    color: Color.fromRGBO(255, 244, 208, 1.0)),
                                child: TextButton(
                                  child: Text(
                                    g[index][1],
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  onPressed: () {
                                    widget.change(g[index][0], g[index][1]);
                                  },
                                ),
                              ));
                        }));
              }
            }),
        Container(
          width: MediaQuery.of(context).size.width,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                flex: 1,
                child: Container(
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        color: Color.fromRGBO(255, 244, 208, 1.0)),
                    margin: EdgeInsets.all(10),
                    height: 50,
                    child: Container(
                      decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          color: Color.fromRGBO(255, 244, 208, 1.0)),
                      child: TextButton.icon(
                        // style: TextButton.styleFrom(
                        //   minimumSize:
                        //       Size(MediaQuery.of(context).size.width, 100),
                        // ),
                        icon: Icon(Icons.add_outlined),
                        label: const Text(
                          "Create Group",
                          style: TextStyle(
                              color: Colors.black, fontWeight: FontWeight.bold),
                        ),
                        onPressed: () => {},
                      ),
                    )),
              ),
              Expanded(
                flex: 1,
                child: Container(
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        color: Color.fromRGBO(255, 244, 208, 1.0)),
                    margin: EdgeInsets.all(10),
                    height: 50,
                    child: Container(
                      decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          color: Color.fromRGBO(255, 244, 208, 1.0)),
                      child: TextButton.icon(
                        // style: TextButton.styleFrom(
                        //   minimumSize:
                        //       Size(MediaQuery.of(context).size.width, 100),
                        // ),
                        icon: Icon(Icons.delete_outline),
                        label: const Text(
                          "Leave Group",
                          style: TextStyle(
                              color: Colors.black, fontWeight: FontWeight.bold),
                        ),
                        onPressed: () => {},
                      ),
                    )),
              ),
              Expanded(
                flex: 1,
                child: Container(
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        color: Color.fromRGBO(255, 244, 208, 1.0)),
                    margin: EdgeInsets.all(10),
                    height: 50,
                    child: Container(
                      decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          color: Color.fromRGBO(255, 244, 208, 1.0)),
                      child: TextButton.icon(
                        // style: TextButton.styleFrom(
                        //   minimumSize:
                        //       Size(MediaQuery.of(context).size.width, 100),
                        // ),
                        icon: Icon(Icons.logout_outlined),
                        label: const Text(
                          "Sign Out",
                          style: TextStyle(
                              color: Colors.black, fontWeight: FontWeight.bold),
                        ),
                        onPressed: () => {},
                      ),
                    )),
              ),
            ],
          ),
        ),
      ]),
    );
  }
}
