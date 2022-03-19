import 'package:flutter/material.dart';
import 'package:lp_task_scheduler/styles/font_styles.dart';

class DetailRow extends StatelessWidget {
  final IconData? icon;
  final String label;
  final String? data;
  final String? points;
  final double size;

  const DetailRow(
      {this.icon,
      required this.label,
      this.data,
      this.points,
      this.size = 30,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 8.0),
      child: Column(
        children: [
          Row(
            children: [
              MaterialButton(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(icon, size: size),
                ),
                onPressed: () {},
                shape: CircleBorder(side: BorderSide(color: Colors.deepOrange)),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(label, style: hintStyle),
                  Text(data ?? '', style: largerStyle),
                ],
              )
            ],
          ),
          Divider(),
        ],
      ),
    );
  }
}
