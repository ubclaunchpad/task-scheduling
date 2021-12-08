import 'package:flutter/material.dart';
import 'package:src/task.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:src/widgets/interactive_task.dart';

// Define a custom Form widget.
class NewTaskPanel extends StatefulWidget {
  const NewTaskPanel({Key? key}) : super(key: key);

  @override
  State<NewTaskPanel> createState() => _TaskPanel();
}

// Define a corresponding State class.
// This class holds the data related to the Form.
class _TaskPanel extends State<NewTaskPanel> {
  // Create a text controller and use it to retrieve the current value
  // of the TextField.
  final myController = TextEditingController();
  final description = TextEditingController();
  bool _showDate = true;
  DateTime selectedDate = DateTime.now();
  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController.dispose();
    description.dispose();
    super.dispose();
  }

  void newtask() {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference tasks = firestore.collection('testingTaskCollection');
    print("aaa   " + selectedDate.toString());
    if (myController.text != "") {
      tasks.add({
        "title": myController.text,
        "description": description.text,
        "status": "Inbox",
        "dueDate": Timestamp.fromDate(selectedDate),
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    BorderRadiusGeometry radius = const BorderRadius.only(
      topLeft: Radius.circular(24.0),
      topRight: Radius.circular(24.0),
    );

    void moveCalendar() {
      setState(() {
        _showDate = !_showDate;
      });
    }

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: new BoxDecoration(
          borderRadius: radius,
          color: Colors.grey.shade300,
        ),
        child: _showDate
            ? Column(
                children: [
                  Container(
                      decoration: BoxDecoration(
                        borderRadius: radius,
                        color: Colors.pink.shade100,
                      ),
                      width: MediaQuery.of(context).size.width,
                      height: 70,
                      child: TextButton.icon(
                        style: ButtonStyle(),
                        icon: Icon(Icons.calendar_today),
                        label: Text(
                          "Set Date",
                          style: TextStyle(
                              color: Colors.black, fontWeight: FontWeight.bold),
                        ),
                        onPressed: () => moveCalendar(),
                      )),
                  SfDateRangePicker(
                    onSelectionChanged:
                        (DateRangePickerSelectionChangedArgs args) {
                      selectedDate = args.value;
                    },
                    selectionMode: DateRangePickerSelectionMode.single,
                    initialSelectedDate: DateTime.now(),
                  ),
                ],
              )
            : Column(children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 70,
                  child: FloatingActionButton.extended(
                    enableFeedback: true,
                    tooltip: "ADD",
                    label: Text(
                      "Add task",
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                    hoverColor: Colors.grey.shade400,
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(24),
                            topRight: Radius.circular(24))),
                    elevation: 1,
                    onPressed: () {
                      newtask();
                    },
                    backgroundColor: Colors.grey.shade400,
                    icon: Icon(
                      Icons.add,
                      size: 40,
                      color: Colors.black,
                    ),
                  ),
                ),
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        TextButton.icon(
                          icon: Icon(Icons.calendar_today),
                          label: Text('Due Date'),
                          onPressed: () => moveCalendar(),
                        ),
                        TextButton.icon(
                          style: TextButton.styleFrom(
                            enableFeedback: false,
                            primary: Colors.grey,
                          ),
                          icon: Icon(Icons.person),
                          label: Text('Assign'),
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ],
                ),
              ]),

        // width: MediaQuery.of(context).size.width,
      ),
    );
  }
}
