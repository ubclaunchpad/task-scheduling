import 'dart:developer';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';

// Import the firebase_core plugin
import 'package:firebase_core/firebase_core.dart';
import 'package:src/task_list.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(App());
}

class App extends StatefulWidget {
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  // Set default `_initialized` and `_error` state to false
  bool _initialized = false;
  bool _error = false;

  // Define an async function to initialize FlutterFire
  void initializeFlutterFire() async {
    try {
      // Wait for Firebase to initialize and set `_initialized` state to true
      await Firebase.initializeApp();
      // FirebaseFunctions.instance.useFunctionsEmulator('localhost', 5001);
      log("Successfully initialized Firebase App");
      setState(() {
        _initialized = true;
      });
    } catch (e) {
      log(e.toString());
      // Set `_error` state to true if Firebase initialization fails
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
    // Show error message if initialization failed
    if (_error) {
      return SomethingWentWrong();
    }

    // Show a loader until FlutterFire is initialized
    if (!_initialized) {
      return Loading();
    }

    return TaskSchedulerRoot(title: "Task Scheduler");
  }
}

Widget SomethingWentWrong() {
  return MaterialApp(
      home: Scaffold(
    appBar: AppBar(
      title: const Text('Something went wrong'),
    ),
    body: Center(
      child: Text('Something went wrong'),
    ),
  ));
}

Widget Loading() {
  return MaterialApp(
      home: Scaffold(
    appBar: AppBar(
      title: const Text('Loading...'),
    ),
    body: Center(
      child: CircularProgressIndicator(),
    ),
  ));
}

class TaskSchedulerRoot extends StatefulWidget {
  const TaskSchedulerRoot({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _TaskSchedulerRootState createState() => _TaskSchedulerRootState();
}

class _TaskSchedulerRootState extends State<TaskSchedulerRoot> {
  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(
              // Here we take the value from the MyHomePage object that was created by
              // the App.build method, and use it to set our appbar title.
              title: Text(widget.title),
            ),
            bottomNavigationBar:
                BottomNavigationBar(items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'Tab 1',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.people),
                label: 'Tab 2',
              ),
            ]),
            body: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.blueAccent, width: 10),
              ),
              child: TaskList(),
              constraints: const BoxConstraints.expand(),
            )));
  }
}
