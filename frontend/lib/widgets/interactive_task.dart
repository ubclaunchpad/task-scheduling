import 'package:flutter/material.dart';
import 'package:src/task.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class InteractiveTask<T> extends StatelessWidget {
  final DocumentSnapshot? ds;
  const InteractiveTask({
    this.ds,
    Key? key,
  }) : super(key: key);

  void deleteTask() {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference tasks = firestore.collection('testingTaskCollection');
    if (ds != null) {
      tasks.doc(ds?.id).delete();
    }
  }

  void completeTask() {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference tasks = firestore.collection('testingTaskCollection');

    ds!.reference.update({"status": "complete"});
  }

  void editTask() {}

  void dismissItem(DismissDirection direction) {
    if (direction == DismissDirection.startToEnd) {
      completeTask();
    } else {
      deleteTask();
    }
  }

  @override
  Widget build(BuildContext context) {
    dynamic data = ds!.data();
    return Dismissible(
      onDismissed: (direction) => dismissItem(direction),
      key: UniqueKey(),
      child: Task(
          title: data["title"].toString(),
          description: data["description"].toString(),
          ds: ds),
      background: buildSwipeActionLeft(),
      secondaryBackground: buildSwipeActionRight(),
    );
  }

  Widget buildSwipeActionLeft() {
    return Container(
      color: Colors.green,
      child: const Icon(
        Icons.done,
        color: Colors.white,
      ),
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.symmetric(horizontal: 20),
    );
  }

  Widget buildSwipeActionRight() {
    return Container(
      color: Colors.red,
      child: const Icon(
        Icons.delete,
        color: Colors.white,
      ),
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.symmetric(horizontal: 20),
    );
  }
}
