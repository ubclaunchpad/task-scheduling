import 'package:flutter/material.dart';

class Task extends StatelessWidget {
  Task({Key? key, required this.title, required this.description})
      : super(key: key);
  final String title;
  final String description;
  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(
        maxWidth: 30,
      ),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.black,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      margin: const EdgeInsets.all(5),
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(
            description,
            style: const TextStyle(fontStyle: FontStyle.italic),
          ),
        ],
      ),
    );
  }
}
