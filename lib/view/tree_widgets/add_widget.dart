import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AddWidget extends StatelessWidget {
  AddWidget(
      {Key? key,
      required this.text,
      required this.onTab /*required this.x, required this.y*/
      })
      : super(key: key);
  final String text;
  Function() onTab;

  // final double x, y;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.45,
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.background,
          border: Border.all(
              width: 1, color: Theme.of(context).colorScheme.secondary),
          borderRadius: BorderRadius.circular(5)),
      child: ListTile(
        onTap: onTab,
        contentPadding: EdgeInsets.zero,
        minVerticalPadding: 25,
        leading: const CircleAvatar(
          radius: 20,
          backgroundImage: AssetImage('assets/images/male.jpg'),
        ),

        title: Text(text),
        // trailing: IconButton(
        //   icon: Icon(Icons.add, color: primaryColor,), onPressed:(){_showPopUp(context);},),
      ),
    );
  }
}
