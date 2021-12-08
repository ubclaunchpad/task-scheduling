import 'package:flutter/material.dart';
import 'package:src/task.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class InteractiveGroup extends StatefulWidget {
  InteractiveGroup({Key? key}) : super(key: key);

  @override
  _InteractiveGroupState createState() => _InteractiveGroupState();
}

class _InteractiveGroupState extends State<InteractiveGroup> {
  void addUserToGroup(String emailId, String groupId) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference users = firestore.collection('users');
    CollectionReference groups = firestore.collection('groups');
    QuerySnapshot querySnapshot = await firestore.collection('users').get();
    bool doesUserExist = querySnapshot.docs.any((doc) => {
      bool result = false;
      dynamic data = doc.data();
      if (data != null && data.email == emailId) {
        result = true;
      }
      return result;
      });
    querySnapshot.docs.forEach((dynamic doc) {
      if (emailId == doc.email) {
        users.add(emailId);
        groups.add(emailId);
      } else {
        groups.add(emailId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
            onPressed: () => addUserToGroup("emailIdTest", "groupIdTest"),
            child: const Text("Add a user to group"))
      ],
    );
  }
}
