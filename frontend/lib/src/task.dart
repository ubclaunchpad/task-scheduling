import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Task extends StatefulWidget {
  const Task(
      {Key? key,
      required this.title,
      required this.description,
      required this.ds})
      : super(key: key);
  final String title;
  final String description;
  final DocumentSnapshot ds;

  @override
  State<Task> createState() => _Task();
}

class _Task extends State<Task> {
  bool _done = false;

  @override
  Widget build(BuildContext context) {
    if (!_done) {
      return Center(
          child: Container(
              margin: const EdgeInsets.all(4.0),
              padding: const EdgeInsets.all(3.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: !_done ? Colors.white : Colors.green,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 2,
                    blurRadius: 6,
                    offset: const Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
              width: MediaQuery.of(context).size.width * 0.90,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            widget.title,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                        ),
                        padding: const EdgeInsets.all(8.0),
                      ),
                      IconButton(
                        icon: const Icon(Icons.check_rounded),
                        onPressed: () {
                          setState(() {
                            FirebaseFirestore firestore =
                                FirebaseFirestore.instance;
                            CollectionReference tasks =
                                firestore.collection('tasks');
                            tasks.doc(widget.ds.id).delete();
                            _done = !_done;
                          });
                        },
                      ),
                    ],
                  ),
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
              )));
    } else {
      return Center();
    }
  }
}
