import 'package:flutter/material.dart';
import 'package:lp_task_scheduler/styles/font_styles.dart';

typedef void OnPressed();

class FinishButton extends StatelessWidget {
  final OnPressed onPressed;
  const FinishButton({Key? key, required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: onPressed,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
        ),
        child: FractionallySizedBox(
          widthFactor: 1,
          child: Padding(
            padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: Colors.green,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Icon(Icons.check, color: Colors.white, size: 20),
                    )),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text("Mark Finished", style: largerStyle),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
