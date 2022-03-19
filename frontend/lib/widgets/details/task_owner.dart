import 'package:flutter/material.dart';
import 'package:lp_task_scheduler/styles/font_styles.dart';

class TaskOwner extends StatelessWidget {
  final String owner;
  final DateTime? date;
  const TaskOwner({Key? key, required this.owner, this.date}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 1,
              blurRadius: 5,
              offset: Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              // This is hacky, need help fixing
              decoration: BoxDecoration(
                color: Colors.blueGrey,
                borderRadius: BorderRadius.circular(30),
              ),
              child: const Padding(
                padding: EdgeInsets.only(top: 10),
                child: Image(
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                    image: AssetImage('lib/assets/icons/homelogo.png')),
              ),
              width: 50,
              height: 50,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(8.0, 16, 8, 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Task created by $owner", style: mainStyle),
                  Text("1 week ago", style: smallHintStyle),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
