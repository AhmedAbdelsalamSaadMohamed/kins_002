import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:intl/intl.dart';
import 'package:kins_v002/constant/const_colors.dart';
import 'package:kins_v002/model/user_model.dart';
import 'package:kins_v002/view/widgets/custom_elevation_button_widget.dart';
import 'package:kins_v002/view/widgets/custom_text.dart';
import 'package:kins_v002/view/widgets/custom_text_form_field_widget.dart';
import 'package:kins_v002/view/widgets/gender_radio_widget.dart';
import 'package:kins_v002/view_model/auth_view_model.dart';

class SignUpScreen extends StatelessWidget {
  SignUpScreen({Key? key}) : super(key: key);
  Rx<DateTime?> birthdate = DateTime(0).obs;
  String? email, password, name, phone, username, gender = 'male';
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  ///  logo
                  SizedBox(
                      height: 70,
                      child: Align(
                        child: Image.asset('assets/images/kins.png'),
                        alignment: Alignment.centerLeft,
                      )),
                  const SizedBox(height: 20),

                  /// name field
                  CustomTextFormFieldWidget(
                    hint: 'Your name'.tr,
                    validator: Validator.name,
                    onSaved: (value) {
                      name = value;
                    },
                  ),
                  const SizedBox(height: 20),

                  ///  gender
                  GenderRadioWidget(
                    onChange: (value) {
                      gender = value;
                    },
                  ),
                  const SizedBox(height: 20),

                  /// Email field
                  CustomTextFormFieldWidget(
                    hint: 'Email',
                    validator: Validator.newEmail,
                    onSaved: (value) {
                      email = value;
                    },
                  ),
                  const SizedBox(height: 20),

                  ///  username field
                  CustomTextFormFieldWidget(
                    hint: '@username'.tr,
                    validator: Validator.newUsername,
                    onSaved: (value) {
                      username = value;
                    },
                  ),
                  const SizedBox(height: 20),
                  CustomTextFormFieldWidget(
                    hint: 'PassWord'.tr,
                    isPassword: true,
                    validator: Validator.newPassword,
                    onSaved: (value) {
                      password = value;
                    },
                  ),
                  const SizedBox(height: 20),
                  CustomTextFormFieldWidget(
                      hint: 'Phone'.tr,
                      validator: Validator.phone,
                      onSaved: (value) {
                        phone = value;
                      }),
                  const SizedBox(height: 20),
                  Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(color: primaryColor),
                      ),
                      child: TextButton(
                        onPressed: () {
                          pickDate(context);
                        },
                        child: Obx(() => CustomText(
                              text: birthdate.value!.year == 0
                                  ? 'Birthday'.tr
                                  : DateFormat('dd - MMMM - yyyy ')
                                      .format(birthdate.value!),
                              size: 24,
                            )),
                      )),
                  const SizedBox(height: 20),
                  Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 70, vertical: 10),
                      width: double.infinity,
                      child: CustomElevationButtonWidget(
                          title: 'Sign Up'.tr,
                          onPressed: () {
                            _formKey.currentState!.save();
                            if (_formKey.currentState!.validate()) {
                              UserModel user = UserModel(
                                email: email,
                                phone: phone,
                                name: name,
                                token: username,
                                gender: gender,
                              );
                              AuthViewModel().registrationWithEmailAndPassword(
                                  user, password!);
                            }
                          })),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
        Obx(() => Get.find<AuthViewModel>().loading.value
            ? const Center(
                child: CircularProgressIndicator(
                  color: primaryColor,
                ),
              )
            : Container()),
      ],
    );
  }

  Future pickDate(BuildContext context) async {
    final initialDate = DateTime.now();
    final newDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(DateTime.now().year - 200),
      lastDate: DateTime(DateTime.now().year + 1),
    );

    if (newDate == null)
      return;
    else {
      birthdate.value = newDate;
      birthdate.obs;
    }
  }
}
