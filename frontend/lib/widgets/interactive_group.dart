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

    QuerySnapshot qr = await users.where('email', isEqualTo: emailId).get();
    dynamic data = (await groups.doc(groupId).get()).data();
    List<dynamic> allUsers = data["users"];
    print("aa");
    print(allUsers);
    print("bb");
    print(data);
    qr.docs.forEach((element) {
      print(element["email"]);
      bool exists = false;
      allUsers.forEach((dynamic doc) {
        print(doc.toString() + " " + emailId.toString());
        if (doc.toString() == emailId.toString()) exists = true;
      });

      if (!exists) {
        allUsers.add(emailId);
        groups.doc(groupId).update({"users": allUsers});
        print("not working");
      }
    });

    // bool doesUserExist = querySnapshot.docs.any((doc) => {
    //   dynamic data = doc.data();
    //   if (data != null && data.email == emailId) {
    //     result = true;
    //   }
    //   return result;
    //   });
    // querySnapshot.docs.forEach((dynamic doc) {
    //   if (emailId == doc.email) {
    //     users.add(emailId);
    //     groups.add(emailId);
    //   } else {
    //     groups.add(emailId);
    //   }
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
            onPressed: () => addUserToGroup(
                "alexander.lassooij@gmail.com", "LkiqvN1kOmr3gDYMYnFV"),
            child: const Text("Add a user to group"))
      ],
    );
  }
}
