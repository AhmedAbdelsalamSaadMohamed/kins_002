import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';

//enum Gender { male, female }
class GenderRadioWidget extends StatefulWidget {
  GenderRadioWidget({Key? key, required this.onChange, this.gender = 'male'})
      : super(key: key);
  final Function(String value) onChange;
  String gender;

  @override
  State<GenderRadioWidget> createState() => _GenderRadioWidgetState();
}

class _GenderRadioWidgetState extends State<GenderRadioWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width * 0.4,
            child: RadioListTile<String>(
              title: Text('Male'.tr),
              value: 'male',
              groupValue: widget.gender,
              onChanged: (String? value) {
                setState(() {
                  widget.gender = value!;
                  widget.onChange(value.toString());
                });
              },
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.4,
            child: RadioListTile<String>(
              title: Text('Female'.tr),
              value: 'female',
              groupValue: widget.gender,
              onChanged: (String? value) {
                setState(() {
                  widget.gender = value!;
                  widget.onChange(value.toString());
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}
