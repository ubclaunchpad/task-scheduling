import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

typedef void StringCallback(String val);

class AssignDropdown extends StatefulWidget {
  String groupId = "";
  StringCallback setAssignee;
  String dropdownValue;
  AssignDropdown(
      String _groupId, this.setAssignee, this.dropdownValue, Key? key)
      : super(key: key) {
    groupId = _groupId;
  }

  @override
  State<AssignDropdown> createState() => _AssignDropdownState();
}

class _AssignDropdownState extends State<AssignDropdown> {
  @override
  Widget build(BuildContext context) {
    Stream<QuerySnapshot<Map<String, dynamic>>> _groupMembers =
        FirebaseFirestore.instance
            .collection("users")
            .where("groups", arrayContains: widget.groupId)
            .snapshots();
    return StreamBuilder<Object>(
        stream: _groupMembers,
        builder: (context, AsyncSnapshot<dynamic> snapshot) {
          if (!snapshot.hasData) {
            return DropdownButton<String>(
              value: widget.dropdownValue,
              iconEnabledColor: Colors.deepOrange,
              icon: const Padding(
                padding: EdgeInsets.only(left: 8.0),
                child: Icon(Icons.person),
              ),
              elevation: 16,
              underline: Container(
                height: 2,
              ),
              onChanged: (String? newValue) {
                setState(() {
                  widget.setAssignee(newValue!);
                });
              },
              style: const TextStyle(
                  color: Colors.deepOrange, fontWeight: FontWeight.bold),
              items: [
                DropdownMenuItem<String>(
                  value: widget.dropdownValue,
                  child: Text(widget.dropdownValue),
                ),
              ],
            );
          }
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              width: MediaQuery.of(context).size.width * 0.5,
              child: DropdownButton<String>(
                  isExpanded: true,
                  value: widget.dropdownValue,
                  iconEnabledColor: Colors.deepOrange,
                  icon: Icon(Icons.person),
                  elevation: 16,
                  underline: Container(
                    height: 2,
                  ),
                  onChanged: (String? newValue) {
                    setState(() {
                      widget.setAssignee(newValue!);
                    });
                  },
                  style: const TextStyle(
                      overflow: TextOverflow.ellipsis,
                      color: Colors.deepOrange,
                      fontWeight: FontWeight.bold),
                  items: [
                    const DropdownMenuItem<String>(
                      value: 'Unassigned',
                      child: Text('Unassigned'),
                    ),
                    ...snapshot.data?.docs.map<DropdownMenuItem<String>>(
                        (DocumentSnapshot document) {
                      dynamic user = document.data();
                      if (user["groupId"] == widget.groupId &&
                          user["email"] != null &&
                          user["name"] != null) {
                        return DropdownMenuItem<String>(
                          value: user["email"],
                          child: Text(user["name"]),
                        );
                      }
                      return DropdownMenuItem<String>(
                        value: user["email"],
                        child: Text(user["email"]),
                      );
                    }).toList(),
                  ]),
            ),
          );
        });
  }
}
