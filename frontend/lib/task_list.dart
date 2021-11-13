import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:src/task.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_functions/cloud_functions.dart';

class TaskList extends StatefulWidget {
  const TaskList({Key? key}) : super(key: key);

  @override
  _TaskListState createState() => _TaskListState();
}

class _TaskListState extends State<TaskList> {
  // late Future<List<dynamic>> _tasks;
  // @override
  // void initState() async {
  //   super.initState();
  //   getAllTasks();
  // }

  Future<void> getAllTasks() async {
    // await Firebase.initializeApp();
    log("Starting GetAllTasks");
    log("Set local");
    try {
      HttpsCallable callable =
          FirebaseFunctions.instance.httpsCallable('listTasks');
      log("Set callable");
      try {
        final results = await callable();
        for (var task in results.data) {
          log(task.toString());
        }
      } catch (e) {
        log(e.toString());
      }
    } catch (e) {
      log(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    getAllTasks();
    return Center(
        child: Container(
      child: ListView.builder(
        itemBuilder: (_, index) => Task(
          title: "Item $index",
          description: "Item $index description",
        ),
        itemCount: 100,
        shrinkWrap: true,
      ),
      constraints: const BoxConstraints(maxWidth: 200),
    ));
  }
}
