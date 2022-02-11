import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lp_task_scheduler/src/task.dart';
import 'package:lp_task_scheduler/widgets/assign_dropdown.dart';
import 'package:lp_task_scheduler/widgets/date_panel.dart';
import 'package:lp_task_scheduler/widgets/point_button.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'interactive_task.dart';

// Define a custom Form widget.
class NewTaskPanel extends StatefulWidget {
  const NewTaskPanel({Key? key, required this.id}) : super(key: key);
  final String id;
  @override
  State<NewTaskPanel> createState() => _TaskPanel();
}

enum ViewState { date, standard }

// Define a corresponding State class.
// This class holds the data related to the Form.
class _TaskPanel extends State<NewTaskPanel> {
  // Create a text controller and use it to retrieve the current value
  // of the TextField.
  final myController = TextEditingController();
  final description = TextEditingController();
  ViewState _showState = ViewState.standard;
  String _assignee = "Unassigned";
  DateTime selectedDate = DateTime.now();
  int _points = 0;
  @override
  void initState() {
    super.initState();
    _assignee = "Unassigned";
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController.dispose();
    description.dispose();
    super.dispose();
  }

  void newtask() {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference tasks =
        firestore.collection('groups').doc(widget.id).collection("Tasks");
    if (myController.text != "") {
      tasks.add({
        "title": myController.text,
        "description": description.text,
        "status": "Inbox",
        "dueDate": Timestamp.fromDate(selectedDate),
        "assignedTo": [_assignee],
        "points": _points,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    BorderRadiusGeometry radius = const BorderRadius.only(
      topLeft: Radius.circular(24.0),
      topRight: Radius.circular(24.0),
    );

    void setViewState(ViewState state) {
      setState(() {
        _showState = state;
      });
    }

    void onDatePressed() {
      setState(() {
        _showState = ViewState.standard;
      });
    }

    void setSelectedDate(DateTime date) {
      setState(() {
        selectedDate = date;
      });
    }

    void setAssignee(String assignee) {
      setState(() {
        _assignee = assignee;
      });
    }

    void setValue(int value) {
      setState(() {
        _points = value;
      });
      print(_points);
    }

    Widget renderFromViewState() {
      switch (_showState) {
        case ViewState.date:
          return DatePanel(onDatePressed, setSelectedDate, null, null);
        case ViewState.standard:
        default:
          return Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      //color: Colors.red,
                      margin: const EdgeInsets.only(
                          top: 20.0, left: 10, right: 10, bottom: 10),
                      padding: const EdgeInsets.only(
                          top: 10.0, left: 20, right: 20, bottom: 10),

                      // height: MediaQuery.of(context).size.height * 0.09,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: TextField(
                          controller: myController,
                          decoration: const InputDecoration(
                            //border: InputBorder.none,
                            hintText: "Task name",
                            hintStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              decoration: TextDecoration.none,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      // height: MediaQuery.of(context).size.height * 0.05,
                      // width: MediaQuery.of(context).size.width,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: TextField(
                          controller: description,
                          decoration: const InputDecoration(
                            //border: InputBorder.none,
                            hintText: "Description",
                            hintStyle: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 12,
                              decoration: TextDecoration.none,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                      margin: const EdgeInsets.only(
                          top: 10.0, left: 10, right: 10, bottom: 10),
                      padding: const EdgeInsets.only(
                          top: 10.0, left: 20, right: 20, bottom: 10),
                    ),
                    Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TextButton.icon(
                              icon: const Icon(Icons.calendar_today),
                              label: Text(
                                  'Due ${DateFormat('MMM dd yyyy').format(selectedDate)}'),
                              onPressed: () => setViewState(ViewState.date),
                            ),
                            AssignDropdown(
                                widget.id, setAssignee, _assignee, null)
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [PointSelect(setValue, null)],
                        )
                      ],
                    ),
                  ],
                ),
                Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        color: Color.fromRGBO(255, 244, 208, 1.0)),
                    margin: EdgeInsets.all(30),
                    width: MediaQuery.of(context).size.width,
                    height: 50,
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          color: Color.fromRGBO(255, 244, 208, 1.0)),
                      child: TextButton.icon(
                        // style: TextButton.styleFrom(
                        //   minimumSize:
                        //       Size(MediaQuery.of(context).size.width, 100),
                        // ),
                        icon: Icon(Icons.add),
                        label: Text(
                          "Add task",
                          style: TextStyle(
                              color: Colors.black, fontWeight: FontWeight.bold),
                        ),
                        onPressed: () => newtask(),
                      ),
                    )),
              ]);
      }
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            borderRadius: kIsWeb ? BorderRadius.all(Radius.zero) : radius,
            color: const Color.fromRGBO(247, 227, 218, 1.0),
          ),
          child: renderFromViewState(),
          // width: MediaQuery.of(context).size.width,
        ),
      ],
    );
  }
}
