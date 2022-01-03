import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kins_v002/constant/const_colors.dart';
import 'package:kins_v002/view/screens/sign_up_screen.dart';
import 'package:kins_v002/view/widgets/custom_elevation_button_widget.dart';
import 'package:kins_v002/view/widgets/custom_text_form_field_widget.dart';
import 'package:kins_v002/view/widgets/sign_in_button_widget.dart';
import 'package:kins_v002/view_model/auth_view_model.dart';
import 'package:kins_v002/view_model/user_view_model.dart';

class SignInScreen extends StatelessWidget {
  SignInScreen({Key? key}) : super(key: key);
  final GlobalKey<FormState> _formKey2 = GlobalKey<FormState>();
  String? usernameOrEmail, password;
  UserViewModel userController = Get.find<UserViewModel>();

  @override
  Widget build(BuildContext context) {
    Get.put(UserViewModel(), permanent: true);
    return GetBuilder<AuthViewModel>(
        init: Get.put(AuthViewModel()),
        builder: (authController) {
          return Stack(
            children: [
              Scaffold(
                body: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: SafeArea(
                    child: ListView(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GetBuilder(
                                init: Get.find<UserViewModel>(),
                                builder: (controller) {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16),
                                    child: DropdownButton<String>(
                                        value: userController.language,
                                        onChanged: (value) {
                                          userController.setLanguage(value!);
                                        },
                                        items: [
                                          DropdownMenuItem(
                                            child: Text('English'),
                                            value: 'en',
                                          ),
                                          DropdownMenuItem(
                                            child: Text('العربيه'),
                                            value: 'ar',
                                          )
                                        ]),
                                  );
                                }),
                            GetBuilder(
                                init: Get.find<UserViewModel>(),
                                builder: (controller) {
                                  return SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width * 0.5,
                                    child: ListTile(
                                      title: Text('Dark Mode'.tr),
                                      trailing: Switch(
                                          value: userController.darkMode,
                                          onChanged: (value) {
                                            userController.setDarkMode(value);
                                          }),
                                    ),
                                  );
                                }),
                          ],
                        ),

                        ///  logo
                        SizedBox(
                            height: 70,
                            child: Align(
                              child: Image.asset('assets/images/kins.png'),
                              alignment: Alignment.centerLeft,
                            )),
                        Form(
                          key: _formKey2,
                          child: ListView(
                            shrinkWrap: true,
                            children: [
                              const SizedBox(height: 20),
                              CustomTextFormFieldWidget(
                                  validator: Validator.usernameOrEmail,
                                  hint: 'Email or @username'.tr,
                                  onSaved: (value) {
                                    usernameOrEmail = value;
                                  }),
                              const SizedBox(height: 20),
                              CustomTextFormFieldWidget(
                                  isPassword: true,
                                  validator: Validator.password,
                                  hint: 'PassWord'.tr,
                                  onSaved: (value) {
                                    password = value;
                                  }),
                              const SizedBox(height: 20),
                              CustomElevationButtonWidget(
                                  title: 'Sign In'.tr,
                                  onPressed: () {
                                    _formKey2.currentState!.save();
                                    if (_formKey2.currentState!.validate()) {
                                      if (usernameOrEmail!.startsWith('@')) {
                                        authController
                                            .signInWithUsernameAndPassword(
                                                usernameOrEmail!, password!);
                                      } else {
                                        authController
                                            .signInWithEmailAndPassword(
                                                usernameOrEmail!, password!);
                                      }
                                    }
                                  }),
                              const SizedBox(height: 20),
                              Align(
                                  alignment: Alignment.centerRight,
                                  child: InkWell(
                                    child: Text('Sign Up'.tr,
                                        style: TextStyle(
                                            decoration:
                                                TextDecoration.underline,
                                            color: Colors.blue)),
                                    onTap: () => Get.to(SignUpScreen()),
                                  )),
                              const SizedBox(height: 20),
                            ],
                          ),
                        ),
                        const Divider(height: 40, thickness: 2),
                        SignInButtonWidget(
                            title: 'Sign In By Google'.tr,
                            icon: Image.asset('assets/images/google.png'),
                            onPress: () {
                              authController.signInWithGoogle();
                            }),
                        const SizedBox(height: 20),
                        SignInButtonWidget(
                            title: 'Sign In By Facebook'.tr,
                            icon: Image.asset('assets/images/facebook.png'),
                            onPress: () {
                              authController.signInWithFacebook();
                            }),
                      ],
                    ),
                  ),
                ),
              ),
              Obx(() => authController.loading.value
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: primaryColor,
                      ),
                    )
                  : Container()),
            ],
          );
        });
  }
}
