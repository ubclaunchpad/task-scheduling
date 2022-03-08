import 'package:flutter/material.dart';
import 'package:lp_task_scheduler/styles/font_styles.dart';

class DetailDescription extends StatelessWidget {
  final String description;
  const DetailDescription({Key? key, this.description = ""}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text("Description", style: hintStyle),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(description),
                )
              ],
            ),
          ),
          Divider(),
        ],
      ),
    );
  }
}
