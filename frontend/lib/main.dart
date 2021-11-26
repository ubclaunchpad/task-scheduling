import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'src/home_page.dart';

void main () async {

  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();


  runApp(
    // since applicationState extends ChangeNotifier
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => LoginState()),
      ],
      builder: (context, _) => const TaskScheduler(),
    ),
  );
}

class TaskScheduler extends StatelessWidget {
  const TaskScheduler({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home: const MyHomePage(title: 'Authentication Demo Home Page'),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        title: Text(title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
        OutlinedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const LoginPage()),
            );
          },
          child:
            const Text(
            'Please Click to Login',
          )
        ),
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

TextStyle mainStyle = const TextStyle(
    fontFamily: 'SF Pro',
    color: Colors.black,
    fontSize: 14,
    height: 0.5,
    fontWeight: FontWeight.w400
);

TextStyle linkStyle = const TextStyle(
    fontFamily: 'SF Pro',
    color: Color.fromRGBO(29, 56, 80, 1.0),
    fontSize: 14,
    height: 0.5,
    fontWeight: FontWeight.w400
);

TextStyle boldStyle = const TextStyle(
    fontFamily: 'SF Pro',
    color: Colors.black,
    fontSize: 14,
    height: 0.5,
    fontWeight: FontWeight.w800
);
// Color(0x004b8ecb)