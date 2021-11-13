import 'package:flutter/material.dart';

class Dashboard extends StatefulWidget {
  final String userID;
  final String displayName;
  final String userEmail;
  final String imageURL;

  const Dashboard ({
      Key? key,
      required this.userID,
      required this.displayName,
      required this.userEmail,
      required this.imageURL,
  }) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    return(
      Scaffold(
        appBar: AppBar(
          title: const Text("Dashboard"),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                "Name : ${widget.displayName}"
              ),
              Text(
                  "E-Mail : ${widget.userEmail}"
              ),
              Image.network(
                  widget.imageURL,
                  // loadingBuilder: (context, child, progress) {
                  //   return progress == null
                  //       ? child
                  //       : LinearProgressIndicator()
                  // }
                  height: 200,
                  width: 200,
              ),
            ]
          )
        )
      )
    );
  }
}