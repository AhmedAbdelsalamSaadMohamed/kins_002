import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:kins_v002/model/user_model.dart';
import 'package:kins_v002/view/screens/main_screen.dart';
import 'package:kins_v002/view/widgets/add_bottum_widget.dart';
import 'package:kins_v002/view/widgets/custom_app_bar_widget.dart';
import 'package:kins_v002/view/widgets/custom_text.dart';
import 'package:kins_v002/view/widgets/custom_text_form_field_widget.dart';
import 'package:kins_v002/view/widgets/gender_radio_widget.dart';
import 'package:kins_v002/view_model/user_view_model.dart';

class CompleteSocialSignUp extends StatefulWidget {
  CompleteSocialSignUp({
    Key? key,
    required this.user,
    this.action = 'add',
  }) : super(key: key);

  String action;
  UserModel user;

  @override
  State<CompleteSocialSignUp> createState() => _CompleteSocialSignUpState();
}

class _CompleteSocialSignUpState extends State<CompleteSocialSignUp> {
  DateTime? birthdate;
  final UserViewModel userController = Get.find<UserViewModel>();

  @override
  Widget build(BuildContext context) {
    GlobalKey<FormState> _formKy = GlobalKey<FormState>();
    return Scaffold(
      appBar: CustomAppBarWidget.appBar(
          context: context, title: 'Complete Sign up'),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Form(
          key: _formKy,
          child: ListView(
            children: [
              CustomTextFormFieldWidget(
                hint: 'Name',
                value: widget.user.name,
                validator: Validator.name,
                onSaved: (newValue) {
                  widget.user.name = newValue!;
                },
              ),
              const SizedBox(height: 20),
              GenderRadioWidget(
                onChange: (value) {
                  widget.user.gender = value;
                },
              ),
              const SizedBox(height: 20),
              CustomTextFormFieldWidget(
                value: widget.user.token,
                validator: Validator.newUsername,
                hint: '@username',
                onSaved: (newValue) {
                  widget.user.token = newValue;
                },
              ),
              const SizedBox(height: 20),
              CustomTextFormFieldWidget(
                hint: 'Phone',
                validator: Validator.phone,
                value: widget.user.phone,
                onSaved: (newValue) {
                  widget.user.phone = newValue;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  pickDate(context);
                },
                child: CustomText(
                  text: birthdate == null
                      ? 'Birthday'
                      : DateFormat('MM/dd/yyyy').format(birthdate!),
                  color: Colors.black54,
                  size: 24,
                ),
                style: ButtonStyle(
                  alignment: Alignment.centerLeft,
                  backgroundColor: MaterialStateProperty.all(Colors.white),
                  elevation: MaterialStateProperty.all(0),
                  padding: MaterialStateProperty.all(EdgeInsets.zero),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomSheet: AddButtonWidget(
          title: 'DONE',
          onPressed: () {
            _formKy.currentState!.save();
            if (_formKy.currentState!.validate()) {
              userController.setUserToFirestore(widget.user);
              userController
                  .setUserToSharedPreferences(widget.user)
                  .then((value) {
                userController.reloadMe();
                Get.offAll(MainScreen());
              });
            }
          }),
    );
  }

  Future pickDate(BuildContext context) async {
    final initialDate = DateTime.now();
    final newDate = await showDatePicker(
      context: context,
      initialDate: birthdate ?? initialDate,
      firstDate: DateTime(DateTime.now().year - 100),
      lastDate: DateTime(DateTime.now().year + 1),
    );

    if (newDate == null) return;

    setState(() => birthdate = newDate);
  }
}
