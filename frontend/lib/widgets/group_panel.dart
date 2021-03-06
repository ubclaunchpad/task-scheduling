import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lp_task_scheduler/src/authentication_home_page.dart';
import 'package:lp_task_scheduler/src/create_group.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class GroupPanel extends StatefulWidget {
  const GroupPanel(
      {Key? key,
      required this.userid,
      required this.id,
      required this.change,
      required this.parent})
      : super(key: key);

  final String id;
  final String userid;
  final Function change;
  final BuildContext parent;
  @override
  State<GroupPanel> createState() => _GroupPanel();
}

class _GroupPanel extends State<GroupPanel> {
  CollectionReference refToGroups =
      FirebaseFirestore.instance.collection("groups");

  CollectionReference refToUsers =
      FirebaseFirestore.instance.collection("users");
  @override
  void dispose() {
    super.dispose();
  }

  void leaveGroup() async {
    // can't delete user's personal collection
    if (widget.id == widget.userid) {
      return;
    }
    // remove user email from group
    dynamic group = (await refToGroups.doc(widget.id).get()).data();
    List<dynamic> users = group["users"];
    users.remove(widget.userid);
    refToGroups.doc(widget.id).update({"users": users});
    // delete group if it has no users
    if (users.isEmpty) {
      refToGroups.doc(widget.id).delete();
    }

    // remove group from user info
    dynamic userDoc = (await refToUsers.doc(widget.userid).get()).data();
    Map<String, dynamic> groups = userDoc["groups"];
    groups.remove(widget.id);
    refToUsers.doc(widget.userid).update({"groups": groups});

    widget.change(widget.userid, widget.userid);
  }

  void signOut() {
    FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const LoginPage()));
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
      height: MediaQuery.of(context).size.height,
      padding: const EdgeInsets.only(bottom: 30),
      decoration: BoxDecoration(
        borderRadius: radius,
        color: const Color.fromRGBO(247, 227, 218, 1.0),
      ),
      child:
          Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
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
            FutureBuilder<DocumentSnapshot?>(
                future: getGroups(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData || snapshot.hasError) {
                    return const Text("Error getting groups from firebase");
                  } else {
                    dynamic data = snapshot.data!.data();
                    dynamic g = [];
                    data["groups"].forEach((k, v) {
                      g.add([k, v]);
                    });

                    return LimitedBox(
                      maxHeight: 300,
                      child: ListView.builder(
                          itemCount: g.length,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return Container(
                                decoration: const BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20)),
                                    color: Color.fromRGBO(255, 244, 208, 1.0)),
                                margin: const EdgeInsets.all(10),
                                width: MediaQuery.of(context).size.width,
                                child: Container(
                                  decoration: const BoxDecoration(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(20)),
                                      color:
                                          Color.fromRGBO(255, 244, 208, 1.0)),
                                  child: TextButton(
                                    child: Text(
                                      g[index][1],
                                      style: const TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    onPressed: () {
                                      widget.change(g[index][0], g[index][1]);
                                    },
                                  ),
                                ));
                          }),
                    );
                  }
                }),
          ],
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              actionButton(
                  "Create Group",
                  () => {
                        Navigator.push(
                            widget.parent,
                            MaterialPageRoute(
                                builder: (context) =>
                                    CreateGroup(id: widget.userid)))
                      }),
              widget.id == widget.userid
                  ? Container()
                  : actionButton("Leave Group", () => leaveGroup()),
              actionButton("Sign out", () => signOut()),
            ],
          ),
        ),
      ]),
    );
  }

  Widget actionButton(String title, Function onPressedFunction) {
    return Expanded(
      flex: 1,
      child: Container(
          decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              color: Color.fromRGBO(255, 244, 208, 1.0)),
          margin: const EdgeInsets.all(10),
          height: 50,
          child: Container(
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                color: Color.fromRGBO(255, 244, 208, 1.0)),
            child: TextButton(
              child: Text(
                title,
                style: const TextStyle(
                    color: Colors.black, fontWeight: FontWeight.bold),
              ),
              onPressed: () => {onPressedFunction()},
            ),
          )),
    );
  }
}
