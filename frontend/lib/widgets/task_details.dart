import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lp_task_scheduler/styles/font_styles.dart';
import 'package:lp_task_scheduler/widgets/new_task_panel.dart';

import 'assign_dropdown.dart';
import 'date_panel.dart';

class TaskDetails extends StatefulWidget {
  final DocumentSnapshot? ds;
  TaskDetails({this.ds, Key? key}) : super(key: key);
  @override
  State<TaskDetails> createState() => _TaskDetailsState();
}

class _TaskDetailsState extends State<TaskDetails> {
  ViewState _viewState = ViewState.standard;

  void setViewState(ViewState state) {
    setState(() {
      _viewState = state;
    });
  }

  void completeTask() {
    widget.ds!.reference.update({"status": "complete"});
  }

  @override
  Widget build(BuildContext context) {
    if (widget.ds == null || !widget.ds!.exists) {
      return Container();
    }
    dynamic data = widget.ds!.data();
    DateTime date = DateTime.parse(data["dueDate"].toDate().toString());
    print(data);
    return Scaffold(
      appBar: AppBar(
        title: Text('Task Details'),
      ),
      body: Center(
          child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(data["title"], style: titleStyle),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              AssignDropdown(
                  "ch3p51@gmail.com", (String n) {}, "Unassigned", null),
              TextButton.icon(
                icon: const Icon(Icons.calendar_today),
                label: Text('Due ${DateFormat('MMM dd yyyy').format(date)}'),
                onPressed: () {
                  setViewState(ViewState.date);
                },
              ),
            ],
          ),
          Center(
            child: Text(data["points"] != null
                ? "Points: ${data["points"]}"
                : "Points: ${1}"),
          ),
          Center(
            child: Text(data["description"] != null
                ? "Description: ${data["description"]}"
                : "Description: ${'Add a description'}"),
          ),
          ElevatedButton(
              onPressed: () {
                completeTask();
                print("completedTask");
              },
              child: Text("Mark as Completed"))
        ],
      )),
    );
  }
}
