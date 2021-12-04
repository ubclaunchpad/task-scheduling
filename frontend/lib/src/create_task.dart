import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CreateTask extends StatefulWidget {
  const CreateTask({
    Key? key,
  }) : super(key: key);

  @override
  State<CreateTask> createState() => _Task();
}

enum Priority { HIGH, MEDIUM, LOW }

class _Task extends State<CreateTask> {
  Priority? _priority = Priority.MEDIUM;
  String? _title;
  String? _description;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  DateTime? _dueDate;
  DateTime selectedDate = DateTime.now();
  String? _titleError;
  String? _descriptionError;
  addTask() async {
    if (_title == null || _description == null) {
      setState(() {
        _titleError = _title == null ? 'Title is required' : null;
        _descriptionError =
            _description == null ? 'Description is required' : null;
      });
      return;
    }
    var d = await firestore.collection("tasks").add({
      "title": _title,
      "description": _description,
      "assigned_date": DateTime.now(),
      "due_date": _dueDate,
      "priority": _priority.toString(),
      "assigned_to": "user2",
      "assigned_by": "user1",
    });
    Navigator.pop(context);
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create a Task'),
      ),
      body: Material(
        child: Center(
          child: FractionallySizedBox(
            widthFactor: MediaQuery.of(context).size.width > 600 ? 0.8 : 1,
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    onChanged: (value) {
                      setState(() {
                        _titleError = null;
                        _title = value;
                      });
                    },
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      labelText: 'Title',
                      errorText: _titleError,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    onChanged: (value) {
                      setState(() {
                        _descriptionError = null;
                        _description = value;
                      });
                    },
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      labelText: 'Description',
                      errorText: _descriptionError,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: RadioListTile<Priority>(
                    title: const Text('High'),
                    value: Priority.HIGH,
                    groupValue: _priority,
                    onChanged: (Priority? value) {
                      setState(() {
                        _priority = value;
                      });
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: RadioListTile<Priority>(
                    title: const Text('Medium'),
                    value: Priority.MEDIUM,
                    groupValue: _priority,
                    onChanged: (Priority? value) {
                      setState(() {
                        _priority = value;
                      });
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: RadioListTile<Priority>(
                    title: const Text('Low'),
                    value: Priority.LOW,
                    groupValue: _priority,
                    onChanged: (Priority? value) {
                      setState(() {
                        _priority = value;
                      });
                    },
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                        "${DateFormat('EEE, MMMM dd, yyyy').format(selectedDate)}"),
                    SizedBox(
                      height: 20.0,
                    ),
                    ElevatedButton(
                      onPressed: () => _selectDate(context),
                      child: Text('Select date'),
                    ),
                  ],
                ),
                Align(
                  alignment: AlignmentDirectional.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ButtonTheme.fromButtonThemeData(
                        data: Theme.of(context).buttonTheme.copyWith(
                              minWidth: 200.0,
                              height: 50.0,
                            ),
                        child: RaisedButton(
                          onPressed: () => addTask(),
                          child: Text('Create Task'),
                        )),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
