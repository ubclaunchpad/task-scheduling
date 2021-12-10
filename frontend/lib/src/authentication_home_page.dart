import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:lp_task_scheduler/src/task_main_page.dart';
import 'package:lp_task_scheduler/styles/font_styles.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    FirebaseAuth _auth = FirebaseAuth.instance;
    FirebaseFirestore _store = FirebaseFirestore.instance;


    Future<UserCredential> signInWithGoogle() async {
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;
      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );
      // Once signed in, return the UserCredential
      final ret = await FirebaseAuth.instance.signInWithCredential(credential);
      CollectionReference tasks = _store.collection(ret.user!.email!);

      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => TaskPage(
                  title: ret.user!.displayName!,
                  user: ret.user!,
                  id: tasks.id)));
      return ret;
    }



    Future<void> initUser(String userID, String
    userEmail, String displayName)
    async {
      var doc = await _store.collection('users').doc(userEmail).get();
      if (!doc.exists) {
        _store.collection('users').doc(userEmail).set(
            {
              'name': displayName,
              'email': userEmail,
              'id': userID,
              // use convention for id's e.g. PG (personal group) + personal
              // email as id
              'groups': ["PG" + userEmail],
            }
        );

        _store.collection('groups').doc("PG" + userEmail).set(
            {
              'users': userEmail,
              'groupName': displayName + "'s tasks",
              'createdAt': "",
            }
        );
      }
    }


    Future signInWithGooglePopUp() async {

      User? user;
      GoogleAuthProvider authProvider = GoogleAuthProvider();
      try {
        final UserCredential userCredential = await _auth.signInWithPopup(authProvider);
        user = userCredential.user;
      } catch(e) {
        print(e);
      }
      if (user != null) {
        CollectionReference tasks = _store.collection(user.email!);
        initUser(user.uid, user.email!, user.displayName!);

        Navigator.pushReplacement(context, MaterialPageRoute(builder:
            (context) =>
            TaskPage(
                title: user!.displayName!,
                user: user,
                id: tasks.id)
        )
        );
      }
    }


    _auth.userChanges().listen((user) {
      if (user != null) {
        CollectionReference tasks = _store.collection(user.email!);
        Navigator.pushReplacement(context, MaterialPageRoute(builder:
            (context) =>
            TaskPage(
                title: user.displayName!,
                user: user,
                id: tasks.id)
        )
        );
      }
    });

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: <Color>[
            Color.fromRGBO(247, 227, 218, 1.0),
            Color.fromRGBO(255, 244, 208, 1.0),
          ],
        ),
      ), // red to yellow
      child:
          Column(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
        Container(
          child: Column(children: <Widget>[
            Text(
              'batch',
              style: boldStyle,
            ),
            Image.asset(
              'lib/assets/icons/homelogo.png',
              height: 145,
              width: 145,
            ),
          ]),
          margin: const EdgeInsets.fromLTRB(0, 180, 0, 0),
        ),
        TextButton.icon(
          onPressed: () {
            signInWithGoogle();
          },
          icon: const Icon(Icons.login),
          label: const Text('Sign in with Google'),
          style: ButtonStyle(
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                      side: const BorderSide(color: Colors.grey)))),
        )
      ]),
    );
  }
}
