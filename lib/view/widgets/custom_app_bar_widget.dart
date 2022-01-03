import 'package:flutter/material.dart';
import 'package:kins_v002/view/widgets/custom_text.dart';
import 'package:share/share.dart';

class CustomAppBarWidget {
  CustomAppBarWidget();

  static const double appBarHeight = 80;

  static AppBar appBar(
      {required String title,
      Widget? leadingWidget,
      Widget? actionWidget,
      PreferredSizeWidget? bottom,
      required BuildContext context}) {
    return AppBar(
      toolbarHeight: appBarHeight,
      leading: leadingWidget,
      actions: <Widget>[
        actionWidget ??
            IconButton(
                onPressed: () async {
                  final RenderBox box = context.findRenderObject() as RenderBox;

                  await Share.share('fffffffffff',
                      sharePositionOrigin:
                          box.localToGlobal(Offset.zero) & box.size);
                },
                icon: const Icon(
                  Icons.share,
                )),
      ],
      elevation: 0,
      title: CustomText(
        text: title,
        size: 30,
      ),
      bottom: bottom,
      centerTitle: true,
    );
  }
}
