import 'package:flutter/material.dart';
import 'package:kins_v002/constant/const_colors.dart';

class BirthdayWidget extends StatefulWidget {
  BirthdayWidget({Key? key, required this.items, required this.onChanged})
      : super(key: key);
  final List<String> items;
  final Function(String newValue) onChanged;

  @override
  State<BirthdayWidget> createState() => _BirthdayWidgetState();
}

/// This is the private State class that goes with MyStatefulWidget.
class _BirthdayWidgetState extends State<BirthdayWidget> {
  String dropdownValue = '';

  @override
  Widget build(BuildContext context) {
    if (dropdownValue == '') {
      dropdownValue = widget.items[0];
    }
    return DropdownButton<String>(
      value: dropdownValue,
      icon: const Icon(Icons.arrow_drop_down_outlined),
      iconSize: 18,
      //menuMaxHeight: 300,

      // itemHeight: 50,
      style: const TextStyle(color: primaryColor, fontSize: 24),
      onChanged: (newValue) {
        setState(() {
          dropdownValue = newValue!;
          widget.onChanged(newValue);
        });
      },
      items: <String>[...widget.items]
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}
