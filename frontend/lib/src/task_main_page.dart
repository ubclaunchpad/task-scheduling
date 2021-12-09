import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:lp_task_scheduler/widgets/group_panel.dart';
import 'package:lp_task_scheduler/widgets/invite_panel.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:flutter/material.dart';
import 'package:lp_task_scheduler/src/task.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lp_task_scheduler/widgets/interactive_task.dart';
import 'package:lp_task_scheduler/widgets/new_task_panel.dart';
import 'package:lp_task_scheduler/widgets/stream_task_list.dart';

enum PanelOptions { GROUPS, INVITE, DEFAULT }

class TaskPage extends StatefulWidget {
  const TaskPage(
      {Key? key, required this.title, required this.user, required this.id})
      : super(key: key);

  final String title;
  final User user;
  final String id;

  @override
  State<TaskPage> createState() => _MyTaskPageState();
}

class _MyTaskPageState extends State<TaskPage> {
  bool _initialized = false;
  bool _error = false;

  PanelOptions panelOption = PanelOptions.DEFAULT;
  final PanelController panelController = PanelController();
  String groupId = "";
  String name = "";
  // Define an async function to initialize FlutterFire
  void initializeFlutterFire() async {
    try {
      setState(() {
        _initialized = true;
      });
    } catch (e) {
      setState(() {
        _error = true;
      });
    }
  }

  @override
  void initState() {
    groupId = widget.id;
    name = widget.title;
    initializeFlutterFire();

    super.initState();
  }

  setId(String newId, String name) {
    setState(() {
      groupId = newId;
      if (name == widget.user.email) {
        this.name = "Personal";
      } else {
        this.name = name;
      }

      print(name);
    });
  }

  Widget panel(String id) {
    switch (panelOption) {
      case PanelOptions.GROUPS:
        return GroupPanel(id: id, userid: widget.user.email!, change: setId);
      case PanelOptions.INVITE:
        return InvitePanel(id: id);
      default:
        return NewTaskPanel(id: id);
    }
  }

  Future<String> findGroupName(DocumentReference ref) async {
    dynamic data = await ref.get();
    return data.data()["groupName"];
  }

  @override
  Widget build(BuildContext context) {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    String id = groupId;

    if (!_initialized) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("NOT CONNECTED TO FIREBASE"),
          backgroundColor: Color(0xff885566),
        ),
      );
    }

    BorderRadiusGeometry radius = const BorderRadius.only(
      topLeft: Radius.circular(24.0),
      topRight: Radius.circular(24.0),
    );
    return Scaffold(
      body: Container(
        child: SlidingUpPanel(
          onPanelClosed: () {
            setState(() {
              panelOption = PanelOptions.DEFAULT;
            });
          },
          controller: panelController,
          defaultPanelState: PanelState.CLOSED,
          renderPanelSheet: false,
          color: Colors.transparent,
          minHeight: 80,
          borderRadius: radius,
          backdropEnabled: false,
          panel: panel(id),
          collapsed: Scaffold(
              backgroundColor: Colors.transparent,
              body: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width > 500
                        ? 500
                        : MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(247, 227, 218, 1.0),
                      borderRadius: radius,
                    ),
                    child: const Center(
                      child: Text(
                        "Swipe up to create a task",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              )),
          body: Scaffold(
              appBar: AppBar(
                elevation: 0,
                bottom: PreferredSize(
                    child: Container(
                      color: Colors.grey,
                      height: 0.5,
                    ),
                    preferredSize: const Size.fromHeight(10.0)),

                // Here we take the value from the MyHomePage object that was created by
                // the App.build method, and use it to set our appbar title.
                title: Stack(
                  children: [
                    Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: EdgeInsets.only(left: 3, right: 3),
                              decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(10)),
                                  color: panelOption == PanelOptions.GROUPS
                                      ? Color.fromRGBO(255, 244, 208, 1.0)
                                      : Colors.transparent),
                              child: TextButton.icon(
                                onPressed: () {
                                  setState(() {
                                    if (panelOption != PanelOptions.GROUPS) {
                                      panelOption = PanelOptions.GROUPS;
                                      panelController.open();
                                    } else {
                                      panelOption = PanelOptions.DEFAULT;
                                      panelController.close();
                                    }
                                  });
                                },
                                label: Text(name,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 22,
                                        color: Colors.black)),
                                icon: Icon(Icons.switch_left_rounded),
                              ),
                              // FutureBuilder<String>(
                              //   future: findGroupName(firestore
                              //       .collection("groups")
                              //       .doc(
                              //           id)), // a Future<String> or null
                              //   builder: (BuildContext context,
                              //       AsyncSnapshot<String> snapshot) {
                              //     switch (snapshot.connectionState) {
                              //       case ConnectionState.none:
                              //         return new Text(
                              //             'Press button to start');
                              //       case ConnectionState.waiting:
                              //         return new Text(
                              //             'Awaiting result...');
                              //       default:
                              //         if (snapshot.hasError)
                              //           return new Text(
                              //               'Error: ${snapshot.error}');
                              //         else
                              //           return new TextButton.icon(
                              //             onPressed: () {
                              //               setState(() {
                              //                 if (panelOption !=
                              //                     PanelOptions.GROUPS) {
                              //                   panelOption =
                              //                       PanelOptions.GROUPS;
                              //                   panelController.open();
                              //                 } else {
                              //                   panelOption =
                              //                       PanelOptions
                              //                           .DEFAULT;
                              //                   panelController.close();
                              //                 }
                              //               });
                              //             },
                              //             label: Text(snapshot.data!,
                              //                 style: TextStyle(
                              //                     fontWeight:
                              //                         FontWeight.bold,
                              //                     fontSize: 22,
                              //                     color: Colors.black)),
                              //             icon: Icon(Icons
                              //                 .switch_left_rounded),
                              //           );
                              //     }
                              //   },
                              // )
                            ),
                            Container(
                              width: 60,
                              padding: EdgeInsets.zero,
                              decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(10)),
                                  color: panelOption == PanelOptions.INVITE
                                      ? Color.fromRGBO(255, 244, 208, 1.0)
                                      : Colors.transparent),
                              child: TextButton.icon(
                                  onPressed: () {
                                    setState(() {
                                      if (panelOption != PanelOptions.INVITE) {
                                        panelOption = PanelOptions.INVITE;
                                        panelController.open();
                                      } else {
                                        panelOption = PanelOptions.DEFAULT;
                                        panelController.close();
                                      }
                                    });
                                  },
                                  label: Text(""),
                                  icon: const Icon(
                                    Icons.group_add_outlined,
                                    size: 20,
                                  )),
                            ),
                          ],
                        ),
                      ],
                    )
                  ],
                ),

                backgroundColor: Colors.white,
              ),
              body: Stack(
                children: [
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width > 600
                              ? 600
                              : MediaQuery.of(context).size.width,
                          child: Stack(
                            children: [
                              Container(
                                margin: const EdgeInsets.only(top: 20),
                                child: StreamTaskList(id: id),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              )),
        ),
      ),
    );
  }
}
