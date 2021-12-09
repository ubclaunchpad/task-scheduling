import 'package:flutter/material.dart';
import '../src/task.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class GroupPanel extends StatefulWidget {
  const GroupPanel({Key? key}) : super(key: key);

  @override
  State<GroupPanel> createState() => _GroupPanel();
}

class _GroupPanel extends State<GroupPanel> {
  // of the TextField.
  final myController = TextEditingController();
  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    BorderRadiusGeometry radius = const BorderRadius.only(
      topLeft: Radius.circular(24.0),
      topRight: Radius.circular(24.0),
    );

    return Container(
      decoration: BoxDecoration(
        borderRadius: radius,
        color: const Color.fromRGBO(247, 227, 218, 1.0),
      ),
      child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
        Column(
          children: [
            Container(
              padding: const EdgeInsets.only(
                  top: 20.0, left: 20, right: 20, bottom: 10),
              child: const Text(
                "Choose Group",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
          ],
        ),
        Container(
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(20)),
                color: Color.fromRGBO(255, 244, 208, 1.0)),
            margin: EdgeInsets.all(10),
            width: MediaQuery.of(context).size.width,
            height: 50,
            child: Container(
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  color: Color.fromRGBO(255, 244, 208, 1.0)),
              child: TextButton.icon(
                // style: TextButton.styleFrom(
                //   minimumSize:
                //       Size(MediaQuery.of(context).size.width, 100),
                // ),
                icon: const Icon(Icons.arrow_forward_outlined),
                label: const Text(
                  "Personal",
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                ),
                onPressed: () => {},
              ),
            )),
        Container(
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(20)),
                color: Color.fromRGBO(255, 244, 208, 1.0)),
            margin: EdgeInsets.all(10),
            width: MediaQuery.of(context).size.width,
            height: 50,
            child: Container(
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  color: Color.fromRGBO(255, 244, 208, 1.0)),
              child: TextButton.icon(
                // style: TextButton.styleFrom(
                //   minimumSize:
                //       Size(MediaQuery.of(context).size.width, 100),
                // ),
                icon: Icon(Icons.arrow_forward_outlined),
                label: const Text(
                  "Collab X",
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                ),
                onPressed: () => {},
              ),
            )),
        Container(
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(20)),
                color: Color.fromRGBO(255, 244, 208, 1.0)),
            margin: EdgeInsets.all(10),
            width: MediaQuery.of(context).size.width,
            height: 50,
            child: Container(
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  color: Color.fromRGBO(255, 244, 208, 1.0)),
              child: TextButton.icon(
                // style: TextButton.styleFrom(
                //   minimumSize:
                //       Size(MediaQuery.of(context).size.width, 100),
                // ),
                icon: Icon(Icons.add_circle_outline),
                label: const Text(
                  "",
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                ),
                onPressed: () => {},
              ),
            )),
      ]),
    );
  }
}
