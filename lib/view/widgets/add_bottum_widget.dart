import 'package:flutter/material.dart';

import 'custom_elevation_button_widget.dart';

class AddButtonWidget extends StatelessWidget {
  const AddButtonWidget(
      {Key? key, required this.title, required this.onPressed})
      : super(key: key);
  final String title;
  final Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(15),
        child: CustomElevationButtonWidget(
          title: title,
          onPressed: () => onPressed(),
        ));
  }
}
