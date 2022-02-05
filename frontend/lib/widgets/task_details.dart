import 'package:flutter/material.dart';
import 'package:lp_task_scheduler/styles/font_styles.dart';

class TaskDetails extends StatefulWidget {
  TaskDetails({Key? key}) : super(key: key);

  @override
  State<TaskDetails> createState() => _TaskDetailsState();
}

class _TaskDetailsState extends State<TaskDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Task Details'),
      ),
      body: Center(
          child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text("Title", style: titleStyle),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text("Assignee"),
              Text("Due Date"),
            ],
          ),
          Center(
            child: Text("Points"),
          ),
          Center(
            child: Text("Description"),
          ),
          ElevatedButton(
              onPressed: () {
                print("hello");
              },
              child: Text("Mark as Completed"))
        ],
      )),
    );
  }
}
