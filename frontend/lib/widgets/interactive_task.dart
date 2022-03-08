import 'package:flutter/material.dart';
import 'package:lp_task_scheduler/widgets/details/task_details.dart';
import 'package:lp_task_scheduler/widgets/touchable_opacity.dart';
import '../src/task.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class InteractiveTask<T> extends StatelessWidget {
  final DocumentSnapshot? ds;
  final String id;
  const InteractiveTask({
    this.ds,
    Key? key,
    required this.id,
  }) : super(key: key);

  void deleteTask() {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference tasks =
        firestore.collection('groups').doc(id).collection("Tasks");
    if (ds != null) {
      tasks.doc(ds?.id).delete();
    }
  }

  void completeTask() {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference tasks =
        firestore.collection('groups').doc(id).collection("Tasks");

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
    return TouchableOpacity(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => TaskDetails(
                      ds: ds,
                    )));
      },
      child: Dismissible(
        onDismissed: (direction) => dismissItem(direction),
        key: UniqueKey(),
        child: Task(
            title: data["title"].toString(),
            description: data["description"].toString(),
            ds: ds),
        background: buildSwipeActionLeft(),
        secondaryBackground: buildSwipeActionRight(),
      ),
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
