import 'package:flutter/material.dart';
import 'package:lp_task_scheduler/widgets/new_task_panel.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class DatePanel extends StatefulWidget {
  Function onPressed;
  Function onSelectionChanged;
  DateTime? initialDate;
  DatePanel(this.onPressed, this.onSelectionChanged, this.initialDate, Key? key)
      : super(key: key) {}

  @override
  State<DatePanel> createState() => _DatePanelState();
}

class _DatePanelState extends State<DatePanel> {
  @override
  @override
  void initState() {
    super.initState();
  }

  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          margin: const EdgeInsets.all(30),
          child: SfDateRangePicker(
            initialDisplayDate: widget.initialDate,
            onSelectionChanged: (DateRangePickerSelectionChangedArgs args) {
              print("hello");
              widget.onSelectionChanged(args.value);
            },
            selectionMode: DateRangePickerSelectionMode.single,
            initialSelectedDate: DateTime.now(),
          ),
        ),
        Container(
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(20)),
                color: Color.fromRGBO(255, 244, 208, 1.0)),
            margin: const EdgeInsets.all(30),
            width: MediaQuery.of(context).size.width,
            height: 50,
            child: Container(
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  color: Color.fromRGBO(255, 244, 208, 1.0)),
              child: TextButton.icon(
                // style: TextButton.styleFrom(
                //   minimumSize:
                //       Size(MediaQuery.of(context).size.width, 70),
                // ),
                icon: const Icon(Icons.calendar_today),
                label: const Text(
                  "Set Date",
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                ),
                onPressed: () {
                  widget.onPressed();
                },
              ),
            ))
      ],
    );
  }
}
