import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'src/authentication_home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  runApp(TaskScheduler());
}

class TaskScheduler extends StatelessWidget {
  const TaskScheduler({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Index',
      theme: ThemeData(
          primaryColor: Color.fromRGBO(255, 244, 208, 1.0),
          primarySwatch: Colors.deepOrange),
      home: const LoginPage(),
    );
  }
}
