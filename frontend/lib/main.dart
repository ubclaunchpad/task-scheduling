import 'package:flutter/material.dart';
import 'package:src/task.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: const MyHomePage(title: 'My Tasks'),
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
    CollectionReference tasks = firestore.collection('tasks');

    if (!_initialized) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("NOT CONNECTED TO FIREBASE"),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Column(children: [
        Container(
          child: const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Inbox",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
            ),
          ),
          padding: const EdgeInsets.all(12.0),
        ),
        FutureBuilder(
            future: tasks.get(),
            builder: (_, AsyncSnapshot snapshot) {
              return snapshot.hasData
                  ? Container(
                      height: MediaQuery.of(context).size.height * 0.6,
                      child: ListView.builder(
                          padding: const EdgeInsets.all(4.0),
                          itemCount: snapshot.data.docs.length,
                          reverse: false,
                          itemBuilder: (context, index) {
                            DocumentSnapshot ds = snapshot.data.docs[index];
                            return Task(
                                title: ds.data()["title"].toString(),
                                description:
                                    ds.data()["description"].toString(),
                                ds: ds);
                          }))
                  : const Text("NOT CONNECTED TO DATABASE");
            }),
        FloatingActionButton(
          onPressed: () {},
          child: const Icon(
            Icons.add,
            color: Colors.white,
            size: 44.0,
            semanticLabel: 'Text to announce in accessibility modes',
          ),
        ),
      ]),

      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
