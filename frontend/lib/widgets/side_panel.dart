import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lp_task_scheduler/src/create_group.dart';
import 'package:lp_task_scheduler/styles/theme.dart';
import 'package:lp_task_scheduler/widgets/button.dart';

class SidePanel extends StatefulWidget {
  const SidePanel(
      {Key? key,
      required this.user,
      required this.parent,
      required this.change})
      : super(key: key);

  final User user;
  final BuildContext parent;
  final Function change;
  @override
  State<SidePanel> createState() => _SidePanel();
}

class _SidePanel extends State<SidePanel> {
  CollectionReference refToGroups =
      FirebaseFirestore.instance.collection("groups");

  CollectionReference refToUsers =
      FirebaseFirestore.instance.collection("users");
  DocumentSnapshot? refToUser;
  dynamic userData;

  @override
  void initState() {
    refToUsers.doc(widget.user.email).get();
    getUser(widget.user.email!);

    super.initState();
  }

  getUser(String userEmail) async {
    refToUser = await refToUsers.doc(userEmail).get();
    userData = refToUser!.data();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.only(left: 20, right: 20),
      children: <Widget>[
        DrawerHeader(
          decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.grey))),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Stack(
                    alignment: AlignmentDirectional.center,
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            color: scheme.primary),
                      ),
                      const Text(
                        "👵",
                        style: TextStyle(
                          fontSize: 40,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.user.displayName!,
                        style: TextStyle(
                          fontSize: 24,
                        ),
                      ),
                      Text(
                        widget.user.email!,
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Button(label: "View Profile", onPressedF: () => {}),
            ],
          ),
        ),
        // panelList("My Groups", Icons.people_outline),

        Button(
            label: "ADD GROUP",
            onPressedF: () {
              Navigator.push(
                  widget.parent,
                  MaterialPageRoute(
                      builder: (context) =>
                          CreateGroup(id: widget.user.email!)));
            },
            iconData: Icons.add),
        groupList(context),
        panelList("Help", Icons.help_outline),
        panelList("Logout", Icons.logout_sharp),
      ],
    );
  }

  Widget panelList(String title, IconData icon) {
    return ListTile(
      leading: Icon(icon),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 15,
        ),
      ),
    );
  }

  Widget ggroups(Map<String, dynamic> groups) {
    dynamic g = [];
    groups.forEach((k, v) {
      g.add([k, v]);
    });
    return LimitedBox(
      maxHeight: 300,
      child: ListView.builder(
          itemCount: g.length,
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
                leading: Icon(Icons.arrow_right_alt),
                title: Text(
                  g[index][1],
                  style: TextStyle(fontSize: 12),
                ));
          }),
    );
  }

  Widget groupList(BuildContext context) {
    // CollectionReference users = FirebaseFirestore.instance.collection('users');

    return FutureBuilder<DocumentSnapshot>(
      future: refToUsers.doc(widget.user.email).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text("Something went wrong");
        }

        if (snapshot.hasData && !snapshot.data!.exists) {
          return Text("Document does not exist");
        }

        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;
          dynamic g = [];
          data["groups"].forEach((k, v) {
            g.add([k, v]);
          });
          print(g);

          return LimitedBox(
            maxHeight: 300,
            child: ListView.builder(
                itemCount: g.length,
                itemBuilder: (BuildContext context, int index) {
                  print(g[index][1]);
                  return ListTile(
                      onTap: () {
                        widget.change(g[index][0], g[index][1]);
                        Navigator.pop(context);
                      },
                      leading: Icon(Icons.arrow_right_alt),
                      title: Text(
                        g[index][1],
                        style: TextStyle(fontSize: 12),
                      ));
                }),
          );
        }

        return Text("loading");
      },
    );
  }
}
