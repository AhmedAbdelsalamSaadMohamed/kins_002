import 'package:flutter/material.dart';
import 'package:kins_v002/model/user_model.dart';
import 'package:kins_v002/view/widgets/custom_app_bar_widget.dart';
import 'package:kins_v002/view/widgets/user_form_widget.dart';

class AddLocalUserScreen extends StatelessWidget {
  const AddLocalUserScreen({Key? key, required this.add, required this.user})
      : super(key: key);
  final String add;
  final UserModel user;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
<<<<<<< HEAD
      appBar: CustomAppBarWidget.appBar(
          title: 'Add Local $add', context: context),
      body: UserFormWidget(user: user,),
=======
      appBar:
          CustomAppBarWidget.appBar(title: 'Add Local $add', context: context),
      body: UserFormWidget(
        user: user,
      ),
>>>>>>> 2c5fbce (Initial commit)
    );
  }
}
