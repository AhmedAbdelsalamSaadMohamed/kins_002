import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kins_v002/constant/random_id.dart';
import 'package:kins_v002/model/user_model.dart';
import 'package:kins_v002/view/widgets/add_bottum_widget.dart';
import 'package:kins_v002/view/widgets/custom_app_bar_widget.dart';
import 'package:kins_v002/view/widgets/custom_text_form_field_widget.dart';
import 'package:kins_v002/view/widgets/profile_circle_avatar.dart';
import 'package:kins_v002/view_model/build_map_view_model.dart';
import 'package:kins_v002/view_model/user_view_model.dart';

class AddUserScreen extends StatelessWidget {
  AddUserScreen({
    Key? key,
    UserModel? user,
    required this.add,
  }) : super(key: key) {
    this.user = user ?? UserModel();
  }

  final String add;
  late UserModel user;

  @override
  Widget build(BuildContext context) {
    GlobalKey<FormState> _formKey = GlobalKey<FormState>();
    return Scaffold(
        appBar: CustomAppBarWidget.appBar(title: 'Add $add', context: context),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  ProfileCircleAvatar(
                      imageUrl: user.profile, radius: 70, gender: user.gender),
                  const SizedBox(height: 50),
                  CustomTextFormFieldWidget(
                    value: user.name,
                    validator: Validator.name,
                    hint: 'name',
                    onSaved: (newValue) {
                      user.name = newValue;
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
        bottomSheet: AddButtonWidget(
            title: 'ADD',
            onPressed: () {
              _formKey.currentState!.save();
              if (_formKey.currentState!.validate()) {
                UserViewModel userController = Get.find<UserViewModel>();
                user.id = user.id ?? RandomId().getId(25);
                userController.setUserToFirestore(user).then((value) {
                  //userController.allFamily.add(user);
                  // Get.find<TreeViewModel>(tag: userController.currentUser!.id!)
                  //     .reload();
                  Get.put<BuildMapViewModel>(BuildMapViewModel())
                      .getUserNodes();
                  Get.back();
                });
              }
            }));
  }
}
