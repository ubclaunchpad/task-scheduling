import 'package:flutter/material.dart';
import 'package:src/task.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:src/widgets/interactive_task.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const TaskScheduler());
}

class TaskScheduler extends StatelessWidget {
  const TaskScheduler({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tasks',
      theme: ThemeData(primarySwatch: Colors.pink),
      home: const MyHomePage(title: 'Tasks'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _initialized = false;
  bool _error = false;
  bool _toAdd = true;

  // Define an async function to initialize FlutterFire
  void initializeFlutterFire() async {
    try {
      // Wait for Firebase to initialize and set `_initialized` state to true
      await Firebase.initializeApp();

      setState(() {
        _initialized = true;
      });
    } catch (e) {
      setState(() {
        _error = true;
      });
    }
  }

  @override
  void initState() {
    initializeFlutterFire();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference tasks = firestore.collection('testingTaskCollection');

    void addTask() {
      setState(() {
        _toAdd = !_toAdd;
      });
    }

    if (!_initialized) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("NOT CONNECTED TO FIREBASE"),
          backgroundColor: Color(0xff885566),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        bottom: PreferredSize(
            child: Container(
              color: Colors.grey,
              height: 0.5,
            ),
            preferredSize: const Size.fromHeight(7.0)),

        titleSpacing: 10,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: const Align(
          alignment: Alignment.centerLeft,
          child: Text(
            "Inbox",
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 24, color: Colors.black),
          ),
        ),
        backgroundColor: Colors.white,
      ),
      body: Stack(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 20),
            child: Column(children: [
              FutureBuilder(
                  future: tasks.get(),
                  builder: (_, AsyncSnapshot snapshot) {
                    return snapshot.hasData
                        ? Column(children: [
                            Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.4,
                                child: ListView.builder(
                                    padding: const EdgeInsets.all(4.0),
                                    itemCount: snapshot.data.docs.length,
                                    reverse: false,
                                    itemBuilder: (context, index) {
                                      DocumentSnapshot ds =
                                          snapshot.data.docs[index];
                                      return InteractiveTask(ds: ds);
                                    })),
                          ])
                        : const Text("NOT CONNECTED TO DATABASE");
                  }),
            ]),
          ),

          if (_toAdd)
            Positioned.fill(
                child: Align(
                    alignment: Alignment.topCenter,
                    child: Container(
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      child: Task(title: "title", description: "description"),
                      color: Color.fromRGBO(173, 173, 173, 0.9),
                      padding: EdgeInsets.all(5),
                    ))),
          // if (_toAdd)
          //   Positioned(
          //     top: 30,
          //     child: Container(
          //       height: MediaQuery.of(context).size.height * 0.2,
          //       width: MediaQuery.of(context).size.width,
          //       color: Color(0xD4C3C3),
          //       padding: EdgeInsets.all(10),
          //       child: Task(title: "title", description: "descrription"),
          //     ),
          //   ),
          // Can be replaced with a custom  widget to add task
          // Positioned.fill(
          //   child: Align(
          //     alignment: Alignment.centerRight,
          //     child: Task(title: "title", description: "description"),
          //   ),
          // ),
          Positioned(
              right: 10,
              bottom: 10,
              child: FloatingActionButton(
                child: Icon(Icons.add),
                onPressed: () {
                  addTask();
                },
              ))
        ],
      ),
    );
  }

  Widget _buildPopupDialog(BuildContext context) {
    return new AlertDialog(
      content: new Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[Task(title: "title", description: "description")],
      ),
      actions: <Widget>[Text("add")],
    );
  }
}
