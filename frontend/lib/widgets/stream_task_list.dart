import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'interactive_task.dart';

class StreamTaskList extends StatefulWidget {
  StreamTaskList({Key? key}) : super(key: key);

  @override
  _StreamTaskListState createState() => _StreamTaskListState();
}

// Refreshes task list whenever Task data changes
class _StreamTaskListState extends State<StreamTaskList> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('testingTaskCollection')
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Text('Something went wrong');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const FractionallySizedBox(
              child: Center(child: CircularProgressIndicator()),
              widthFactor: 1,
              heightFactor: 1,
            );
          }
          return ListView(
            padding: const EdgeInsets.all(4.0),
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              return InteractiveTask(
                ds: document,
              );
            }).toList(),
          );
        });
  }
}
