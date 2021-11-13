import 'package:LP_TaskScheduler/src/dashboard_home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';



enum AuthState {
  loggedOut,
  loggedIn,
  loginWithGoogle,
  loginWithEmail,
  pending,
}

class LoginAuthentication extends StatelessWidget {
  // constructor
  // needs all these variables passed into it (comes from ApplicationState)
  // main application will be the consumer of the notifier and will
  // rebuild the Authentication widget
  const LoginAuthentication({
    required this.authState,
    required this.signInWithGoogle,
    required this.cancelLogin,
    required this.signOut,
    required this.userID,
    required this.userEmail,
    required this.displayName,
    required this.imageURL,
  });

  final AuthState authState;
  final String userID;
  final String userEmail;
  final String displayName;
  final String imageURL;
  // final void Function() startLoginFlow;


  final void Function() signInWithGoogle;
  final void Function() cancelLogin;

  // final void Function(
  //     String email,
  //     String password,
  //     void Function(Exception e) error,
  //     ) signInWithEmail;
  //

  // final void Function() startEmailLogin;

  // final void Function(
  //     String email,
  //     String displayName,
  //     String password,
  //     void Function(Exception e) error,
  //     ) registerAccount;

  final void Function() signOut;

  @override
  Widget build(BuildContext context) {
    switch(authState) {
      case AuthState.loggedOut:
        return(
          Column(
            children: <Widget>[
              SignInButton(
                Buttons.Google,
                text: "Sign up with Google",
                onPressed: () {
                  signInWithGoogle();
                  //signInWithGoogle(context);
                },
              ),
            ],
          )
        );
      case AuthState.loggedIn:
        return(
            OutlinedButton(
              onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) =>
                      Dashboard(userID: userID, displayName: displayName, userEmail:
                      userEmail, imageURL: imageURL)
                  )
                );
              },
              child:
                const Text(
                  'Proceed to Home Page'
                )

            )
        );
      // case AuthState.loginWithGoogle:
      // // TODO: Handle this case.
      //   break;
      // case AuthState.loginWithEmail:
      // // TODO: Handle this case.
      //   break;
      case AuthState.pending:
        return const CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(
              Colors.blue,
            )
        );
      default:
        return(
            const Text("Error : authState does not match "
            "any values")
        );
    }

  }

}