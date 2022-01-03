import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomText extends StatelessWidget {
  CustomText(
      {Key? key,
      required this.text,
      this.size = 16,
      this.weight = FontWeight.normal,
      this.color})
      : super(key: key);
  final String text;
  double size;
  FontWeight weight;
  Color? color;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        color: color,
        fontWeight: weight,
        fontSize: size,
      ),
      textAlign: TextAlign.start,
      overflow: TextOverflow.fade,
    );
  }
}
