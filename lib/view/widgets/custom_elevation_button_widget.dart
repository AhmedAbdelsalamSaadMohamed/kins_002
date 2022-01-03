import 'package:flutter/material.dart';

import 'custom_text.dart';

class CustomElevationButtonWidget extends StatelessWidget {
  const CustomElevationButtonWidget(
      {Key? key, required this.title, required this.onPressed})
      : super(key: key);
  final String title;
  final Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        elevation: MaterialStateProperty.all(0),
        padding: MaterialStateProperty.all(EdgeInsets.all(8)),
      ),
      onPressed: onPressed,
      child: CustomText(
        text: title,
        size: 24,
        color: Theme.of(context).colorScheme.secondary,
        weight: FontWeight.bold,
      ),
    );
  }
}
