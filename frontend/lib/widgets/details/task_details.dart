import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lp_task_scheduler/styles/font_styles.dart';
import 'package:lp_task_scheduler/widgets/details/detail_description.dart';
import 'package:lp_task_scheduler/widgets/details/detail_row.dart';
import 'package:lp_task_scheduler/widgets/details/finish_button.dart';
import 'package:lp_task_scheduler/widgets/details/task_owner.dart';
import 'package:lp_task_scheduler/widgets/new_task_panel.dart';

import '../assign_dropdown.dart';
import '../date_panel.dart';

class TaskDetails extends StatefulWidget {
  final DocumentSnapshot? ds;
  TaskDetails({this.ds, Key? key}) : super(key: key);
  @override
  State<TaskDetails> createState() => _TaskDetailsState();
}

class _TaskDetailsState extends State<TaskDetails> {
  ViewState _viewState = ViewState.standard;
  DateFormat formatter = DateFormat('yyyy-MM-dd');

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
    print(data.toString());
    DateTime date = DateTime.parse(data["dueDate"].toDate().toString());
    print(data);
    return Scaffold(
      appBar: AppBar(
        title: Text('Task Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0, top: 8.0),
              child: Text(data["title"], style: titleStyle),
            ),
            Column(children: [
              DetailRow(
                  icon: Icons.person,
                  label: "Assigned To",
                  data: data["assignedTo"][0]),
              DetailRow(
                  icon: Icons.calendar_today,
                  label: "Due:",
                  data: formatter.format(date)),
              DetailRow(
                  icon: Icons.star_border_rounded,
                  label: "Points",
                  data: data["points"].toString()),
            ]),
            DetailDescription(
              description: data["description"],
            ),
            Center(child: FinishButton(
              onPressed: () {
                completeTask();
              },
            )),
            Spacer(),
            TaskOwner(
              owner: data["owner"] ?? "unknown",
            )
          ],
        ),
      ),
    );
  }
}
