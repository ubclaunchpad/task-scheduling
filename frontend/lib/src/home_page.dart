import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import '../main.dart';
import 'dashboard_home.dart';
import 'home_page_authentication.dart';


class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
        ),// red to yellow
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              child: Column(
                children: <Widget>[
                  Text(
                    'batch',
                    style: boldStyle,
                  ),
                  Image.asset(
                    'lib/assets/icons/homelogo.png',
                    height: 145,
                    width: 145,
                  ),
                ]
              ),
              margin: const EdgeInsets.fromLTRB(0, 180, 0, 0),
            ),
            Container(
              child: Consumer<LoginState>(
            // appState will control authentication
              builder: (context, appState, _) => LoginAuthentication(
              signInWithGoogle: appState.signInWithGooglePopUp,
              cancelLogin: appState.cancelLogin,
              signOut: appState.signOut,
              authState: appState.authState,
              userID: appState.userID,
              userEmail: appState.userEmail,
              displayName: appState.displayName,
              imageURL: appState.imageURL,
            ),

          ),
              margin: const EdgeInsets.fromLTRB(65, 0, 65, 140),
              constraints: const BoxConstraints(
                maxWidth: 240,
              )

              )
          ]
        ),
    );
  }
}

// return Container(
// decoration: const BoxDecoration(
// gradient: LinearGradient(
// begin: Alignment.centerLeft,
// end: Alignment.centerRight,
// colors: <Color>[
// Color(0x00FDE3D7),
// Color(0x00FFF4D0),
// ],
// ),
// ),// red to yellow
// child: Scaffold(
// body: Center(
// child: Column(
// mainAxisAlignment: MainAxisAlignment.start,
// children: <Widget>[
// Container(
// child: Column(
// children: <Widget>[
// Text(
// 'batch',
// style: boldStyle,
// ),
// Image.asset(
// 'lib/assets/icons/homelogo.png',
// height: 145,
// width: 145,
// ),
// ]
// ),
// margin: const EdgeInsets.fromLTRB(0, 180, 0, 0),
// ),
// Container(
// child: Consumer<LoginState>(
// // appState will control authentication
// builder: (context, appState, _) => LoginAuthentication(
// signInWithGoogle: appState.signInWithGooglePopUp,
// cancelLogin: appState.cancelLogin,
// signOut: appState.signOut,
// authState: appState.authState,
// userID: appState.userID,
// userEmail: appState.userEmail,
// displayName: appState.displayName,
// imageURL: appState.imageURL,
// ),
//
// ),
// margin: const EdgeInsets.fromLTRB(65, 0, 65, 140),
// constraints: const BoxConstraints(
// maxWidth: 240,
// )
//
// )
// ]
// ),
// )
// )
// );

class LoginState extends ChangeNotifier {

  final FirebaseAuth _auth = FirebaseAuth.instance;

  AuthState _authState = AuthState.loggedOut;
  AuthState get authState => _authState;

  final googleSignIn = GoogleSignIn();
  GoogleSignInAccount? _user;
  GoogleSignInAccount get user => _user!;

  String _userID = "";
  String _userEmail = "";
  String _displayName = "";
  String _imageURL = "";

  String get userID => _userID;
  String get userEmail => _userEmail;
  String get displayName => _displayName;
  String get imageURL => _imageURL;


  LoginState();

  // equivalent to a promise
  Future<void> init() async {
    // initializes the Firebase library

    _auth.userChanges().listen((user) {
      if (user != null) {
        _authState = AuthState.loggedOut;
      } else {
        _authState = AuthState.loggedOut;
      }
      // this will re-render
      notifyListeners();
    });
  }



  Future signInWithGooglePopUp(BuildContext context) async {
    User? user;
    _authState = AuthState.pending;
    notifyListeners();

    GoogleAuthProvider authProvider = GoogleAuthProvider();

    try {
      final UserCredential userCredential = await _auth.signInWithPopup(authProvider);
      user = userCredential.user;
    } catch(e) {
      print(e);
    }

    if (user != null) {
      _userID = user.uid;
      _userEmail = user.email!;
      _displayName = user.displayName!;
      _imageURL = user.photoURL!;
      _authState = AuthState.loggedIn;
      Navigator.push(context, MaterialPageRoute(builder: (context) =>
          Dashboard(userID: userID, displayName: displayName, userEmail:
          userEmail, imageURL: imageURL)));
    } else {
      _authState = AuthState.loggedOut;

    }


    // notifyListeners();
    //print(user);
  }

  // Future signInWithGoogle() async {
  //   final googleUser = await googleSignIn.signIn();
  //   if (googleUser == null) return;
  //   _user = googleUser;
  //   // print(_user);
  //
  //   final googleAuth = await googleUser.authentication;
  //   final credential = GoogleAuthProvider.credential(
  //     accessToken: googleAuth.accessToken,
  //     idToken: googleAuth.idToken,
  //   );
  //   await FirebaseAuth.instance.signInWithCredential(credential);
  //   _authState = AuthState.loggedIn;
  //   notifyListeners();
  // }
  //
  // Future signInWithGoogleV2(BuildContext context) async {
  //   User? user;
  //
  //   final GoogleSignInAccount? googleSignInAccount =
  //   await googleSignIn.signIn();
  //
  //   if (googleSignInAccount != null) {
  //     final GoogleSignInAuthentication googleSignInAuthentication =
  //     await googleSignInAccount.authentication;
  //
  //     final AuthCredential credential = GoogleAuthProvider.credential(
  //       accessToken: googleSignInAuthentication.accessToken,
  //       idToken: googleSignInAuthentication.idToken,
  //     );
  //
  //     try {
  //       final UserCredential userCredential =
  //       await _auth.signInWithCredential(credential);
  //
  //       user = userCredential.user;
  //     } on FirebaseAuthException catch (e) {
  //       if (e.code == 'account-exists-with-different-credential') {
  //         // handle the error here
  //       }
  //       else if (e.code == 'invalid-credential') {
  //         // handle the error here
  //       }
  //     } catch (e) {
  //       // handle the error here
  //     }
  //   }
  //   print(user);
  // }

  void signInWithEmail(String email,
      String password,
      void Function(FirebaseAuthException e) errorCallback,) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      errorCallback(e);
    }
  }

  void startEmailLogin() {
    _authState = AuthState.loginWithEmail;
    notifyListeners();
  }

  void cancelLogin() {
    _authState = AuthState.loggedOut;
    notifyListeners();
  }

  void registerAccount(String email, String displayName, String password,
      void Function(FirebaseAuthException e) errorCallback) async {
    try {
      var credential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);
      await credential.user!.updateDisplayName(displayName);
    } on FirebaseAuthException catch (e) {
      errorCallback(e);
    }
  }

  void signOut() {
    _auth.signOut();
  }
}