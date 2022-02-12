import 'package:flutter/material.dart';

typedef UpdateValue = void Function(int val);

class PointSelect extends StatefulWidget {
  final UpdateValue updateValue;
  const PointSelect(this.updateValue, Key? key) : super(key: key);

  @override
  State<PointSelect> createState() => _PointSelectState();
}

class _PointSelectState extends State<PointSelect> {
  int value = 1;
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: DropdownButton<int>(
          value: value,
          onChanged: (_value) {
            setState(() {
              value = _value!;
            });
            widget.updateValue(value);
          },
          items: const [
            DropdownMenuItem(
              value: 1,
              child: Text('1'),
            ),
            DropdownMenuItem(
              value: 2,
              child: Text('2'),
            ),
            DropdownMenuItem(
              value: 3,
              child: Text('3'),
            ),
            DropdownMenuItem(
              value: 5,
              child: Text('5'),
            ),
          ],
        ));
  }
}
