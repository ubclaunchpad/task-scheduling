import 'package:flutter/material.dart';
import 'package:lp_task_scheduler/styles/theme.dart';

class Button extends StatelessWidget {
  const Button(
      {Key? key,
      required this.label,
      required this.onPressedF,
      this.iconData,
      this.isPrimary})
      : super(key: key);
  final String label;
  final Function onPressedF;
  final IconData? iconData;
  final bool? isPrimary;

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.all(10),
        // width: MediaQuery.of(context).size.width * 0.8,
        padding: EdgeInsets.zero,
        child: iconData != null
            ? TextButton.icon(
                autofocus: true,
                style: primaryButtonStyle,
                onLongPress: () => onPressedF(),
                icon: Icon(
                  iconData,
                  color: Colors.black,
                ),
                label: Text(
                  label,
                  style: const TextStyle(color: Colors.black),
                ),
                onPressed: () => onPressedF())
            : TextButton(
                autofocus: true,
                style: primaryButtonStyle,
                onLongPress: () => {},
                child: Text(
                  label,
                  style: const TextStyle(color: Colors.black),
                ),
                onPressed: () => {onPressedF()}));
  }
}
