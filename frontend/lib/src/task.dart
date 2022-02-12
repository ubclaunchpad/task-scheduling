import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String due = "";
    int points = 1;
    dynamic data = widget.ds?.data();
    if (data == Null) return Container();
    try {
      DateTime date = DateTime.parse(data["dueDate"].toDate().toString());
      due = "Due " + formatDate(date, [M, ' ', d]);
      points = data["points"];
    } catch (e) {}

    return Center(
      child: Container(
        margin: const EdgeInsets.all(0.0),
        padding: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: widget.ds != null ? Colors.transparent : Colors.transparent,
        ),
        width: MediaQuery.of(context).size.width,
        height: 100,
        child: Column(
          children: [
            status(),
            Stack(children: [
              FractionallySizedBox(
                widthFactor: 1,
                child: Flex(
                  direction: Axis.horizontal,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            widget.title,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
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
              ),
            ]),
            Container(
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      widget.description,
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Points: $points",
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                          color: Colors.grey),
                    ),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(5.0),
            ),
          ],
        ),
      ),
    );
  }

  Widget status() {
    dynamic data = widget.ds?.data();
    String status = data["status"].toString();
    BorderRadiusGeometry radius = const BorderRadius.only(
        //bottomLeft: Radius.circular(10.0),
        // topRight: Radius.circular(50.0),
        //bottomRight: Radius.circular(10.0),
        );
    bool isComplete = status == "complete";
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
                status,
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
