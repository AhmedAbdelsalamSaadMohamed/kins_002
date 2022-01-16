import 'package:flutter/material.dart';
import 'package:kins_v002/constant/const_colors.dart';

import 'custom_text.dart';

class SignInButtonWidget extends StatelessWidget {
  const SignInButtonWidget(
      {Key? key,
      required this.title,
      required this.onPress,
      required this.icon})
      : super(key: key);
  final String title;
  final Function() onPress;
  final Widget icon;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: () => onPress(),
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Colors.white),
          //elevation: MaterialStateProperty.all<double>(0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            children: [
              SizedBox(width: 30, height: 30, child: icon),
              const SizedBox(
                width: 20,
              ),
              FittedBox(
                fit: BoxFit.scaleDown,
                child: CustomText(
                  text: title,
                  size: 20,
                  color: primaryColor,
                ),
              ),
            ],
          ),
        ));
  }
}
