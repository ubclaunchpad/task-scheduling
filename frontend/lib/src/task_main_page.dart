import 'dart:developer';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:flutter/material.dart';
import 'package:lp_task_scheduler/src/task.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lp_task_scheduler/widgets/interactive_task.dart';
import 'package:lp_task_scheduler/widgets/new_task_panel.dart';
import 'package:lp_task_scheduler/widgets/stream_task_list.dart';

class TaskPage extends StatefulWidget {
  const TaskPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<TaskPage> createState() => _MyTaskPageState();
}

class _MyTaskPageState extends State<TaskPage> {
  bool _initialized = false;
  bool _error = false;
  bool _toAdd = false;

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
    initializeFlutterFire();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference tasks = firestore.collection('testingTaskCollection');

    void addTask() {
      setState(() {
        _toAdd = !_toAdd;
      });
    }

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
    return SlidingUpPanel(
      minHeight: 80,
      borderRadius: radius,
      backdropEnabled: true,
      panel: NewTaskPanel(),
      collapsed: Scaffold(
          backgroundColor: Colors.transparent,
          body: Container(
            decoration: BoxDecoration(
                color: Colors.grey.shade400, borderRadius: radius),
            child: Center(
              child: Text(
                "Swipe up to create a task",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.bold),
              ),
            ),
          )),
      body: Scaffold(
          appBar: AppBar(
            elevation: 0,
            bottom: PreferredSize(
                child: Container(
                  color: Colors.grey,
                  height: 0.5,
                ),
                preferredSize: const Size.fromHeight(7.0)),

            titleSpacing: 10,
            // Here we take the value from the MyHomePage object that was created by
            // the App.build method, and use it to set our appbar title.
            title: const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Inbox",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                    color: Colors.black),
              ),
            ),
            backgroundColor: Colors.white,
          ),
          body: Stack(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 20),
                child: StreamTaskList(),
              )
            ],
          )),
    );
  }
}