import 'package:flutter/material.dart';
import 'package:src/task.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:src/widgets/interactive_task.dart';
import 'package:date_format/date_format.dart';

class Task extends StatefulWidget {
  const Task(
      {Key? key, required this.title, required this.description, this.ds})
      : super(key: key);
  final String title;
  final String description;
  final DocumentSnapshot? ds;

  @override
  State<Task> createState() => _Task();
}

class _Task extends State<Task> {
  bool _done = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String due = "new";
    try {
      DateTime date =
          DateTime.parse(widget.ds!.data()["dueDate"].toDate().toString());
      due = "Due " + formatDate(date, [M, ' ', d]);
    } catch (e) {}
    if (!_done) {
      return Center(
        child: Container(
          margin: widget.ds != null
              ? const EdgeInsets.all(0.0)
              : const EdgeInsets.only(),
          padding: widget.ds != null
              ? const EdgeInsets.all(0.0)
              : const EdgeInsets.all(5.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: widget.ds != null ? Colors.white : Colors.white,
          ),
          width: MediaQuery.of(context).size.width,
          height: 100,
          child: Column(
            children: [
              status(),
              Stack(children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height * 0.05,
                      width: MediaQuery.of(context).size.width * 0.40,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          widget.title,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      ),
                      padding: const EdgeInsets.all(8.0),
                    ),
                  ],
                ),
                Positioned(
                  child: Text(
                    due,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                        color: Colors.grey),
                  ),
                  right: 2,
                )
              ]),
              Container(
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    widget.description,
                  ),
                ),
                padding: const EdgeInsets.all(5.0),
              ),
            ],
          ),
        ),
      );
    } else {
      return const Center();
    }
  }

  Widget status() {
    BorderRadiusGeometry radius = const BorderRadius.only(
        //bottomLeft: Radius.circular(10.0),
        // topRight: Radius.circular(50.0),
        //bottomRight: Radius.circular(10.0),
        );
    bool isComplete = widget.ds!.data()["status"].toString() == "complete";
    return Align(
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: radius,
              color: isComplete ? Colors.green.shade300 : Colors.grey.shade300,
            ),
            padding: const EdgeInsets.only(left: 20.0, right: 20.0),
            margin: const EdgeInsets.only(
              bottom: 2.0,
            ),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                widget.ds!.data()["status"].toString(),
                style:
                    const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}