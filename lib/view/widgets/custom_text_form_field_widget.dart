import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:kins_v002/constant/const_colors.dart';
import 'package:kins_v002/view_model/auth_view_model.dart';

import 'custom_text.dart';

enum Validator {
  none,
  password,
  newPassword,
  newEmail,
  usernameOrEmail,
  newUsername,
  phone,
  name,
}

class CustomTextFormFieldWidget extends StatefulWidget {
  CustomTextFormFieldWidget(
      {Key? key,
      required this.hint,
      this.value,
      required this.onSaved,
      this.inputType,
      this.isPassword = false,
      this.validator = Validator.none})
      : super(key: key);
  final String hint;
  String? value;
  TextInputType? inputType;
  bool isPassword;
  Validator validator;

  final Function(String? newValue) onSaved;

  @override
  State<CustomTextFormFieldWidget> createState() =>
      _CustomTextFormFieldWidgetState();
}

class _CustomTextFormFieldWidgetState extends State<CustomTextFormFieldWidget> {
  String validationResult = '';

  bool _isExist = false;

  bool _passwordVisible = false;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autocorrect: !widget.isPassword,
      obscureText: widget.isPassword && !_passwordVisible,
      enableSuggestions: !widget.isPassword,
      keyboardType: _keyboard(),
      initialValue: widget.value,
      textCapitalization: widget.validator == Validator.name
          ? TextCapitalization.sentences
          : TextCapitalization.none,
      style: const TextStyle(
        fontSize: 24,
        // decorationColor: Colors.grey, //primaryColor,
      ),
      decoration: InputDecoration(
          //hintText: hint,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
          label: CustomText(
            text: widget.hint,
            size: 24,
          ),
          suffixIcon: widget.isPassword
              ? IconButton(
                  onPressed: () {
                    setState(() {
                      _passwordVisible = !_passwordVisible;
                    });
                  },
                  icon: _passwordVisible
                      ? const Icon(Icons.visibility)
                      : const Icon(Icons.visibility_off))
              : null),
      validator: (value) {
        validationResult = '';
        if (widget.validator == Validator.newPassword) {
          newPasswordValidator(value);
        } else if (widget.validator == Validator.newEmail) {
          newEmailValidator(value);
        } else if (widget.validator == Validator.newUsername) {
          newUsernameValidator(value);
        } else if (widget.validator == Validator.usernameOrEmail) {
          usernameOrEmailValidator(value);
        } else if (widget.validator == Validator.name) {
          nameValidator(value);
        }

        if (validationResult != '') {
          return validationResult;
        }
      },
      cursorColor: primaryColor,
      onSaved: widget.onSaved,
      onChanged: (value) async {
        if (widget.validator == Validator.newEmail) {
          _isExist = await AuthViewModel().emailIsExist(value);
        } else if (widget.validator == Validator.newUsername) {
          _isExist = await AuthViewModel().usernameIsExist(value);
        } else if (widget.validator == Validator.usernameOrEmail) {
          if (RegExp(r'^@').hasMatch(value)) {
            _isExist = await AuthViewModel().usernameIsExist(value);
          } else {
            _isExist = await AuthViewModel().emailIsExist(value);
          }
        }
      },
    );
  }

  nameValidator(String? value) {
    if (value == '' || value == null) {
      validationResult += 'Field is required\n'.tr;
    }
  }

  newEmailValidator(String? value) {
    if (value == '' || value == null) {
      validationResult += 'Field is required\n'.tr;
    } else {
      if (!RegExp(
              r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
          .hasMatch(value)) {
        validationResult += 'Enter valid email\n'.tr;
      } else if (_isExist) {
        validationResult += 'this Email is Exist\n'.tr;
      }
    }
  }

  newUsernameValidator(String? value) {
    if (value == '' || value == null) {
      validationResult += 'Field is required\n'.tr;
    } else if (!RegExp(r'^@').hasMatch(value)) {
      validationResult += 'Username Must Start by "@"\n'.tr;
    } else if (value.length < 5) {
      validationResult += 'username length at least 5\n'.tr;
    } else {
      if (_isExist) {
        validationResult += 'username is Exist\n'.tr;
      }
    }
  }

  newPasswordValidator(String? value) {
    if (value == '' || value == null) {
      validationResult += 'Field is required\n'.tr;
    } else if (value.length < 8) {
      validationResult += 'password length at least 8\n'.tr;
    } else {
      if (!value.contains(RegExp(r'[A-Z]'))) {
        validationResult += 'password must has capital litter\n'.tr;
      }
      if (!value.contains(RegExp(r'[a-z]'))) {
        validationResult += 'password must has small litter\n'.tr;
      }
      if (!value.contains(RegExp(r'[0-9]'))) {
        validationResult += 'password must has Numeric Number\n'.tr;
      }
      // if (!value.contains(
      //     RegExp(r'\.@#$!&*-+/\\?_-'))) {
      //   validationResult +=
      //       'Password must contain at least 1 spatial character ';
      // }
    }
  }

  usernameOrEmailValidator(String? value) {
    if (value == '' || value == null) {
      validationResult += 'Field is required\n'.tr;
    } else {
      if (RegExp(r'^@').hasMatch(value)) {
        // match username
        if (!_isExist) {
          validationResult += 'Username not Exist\n'.tr;
        }
      } else if (!RegExp(
              r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
          .hasMatch(value)) {
        validationResult +=
            'Username must Start with \'@\' Or Enter valid email\n'.tr;
      } else {
        // match email
        print(_isExist);
        if (!_isExist) {
          validationResult += 'Email  not Exist\n'.tr;
        }
      }
    }
  }

  TextInputType _keyboard() {
    if (widget.validator == Validator.usernameOrEmail ||
        widget.validator == Validator.newEmail ||
        widget.validator == Validator.newUsername) {
      return TextInputType.emailAddress;
    }
    if (widget.validator == Validator.phone) {
      return TextInputType.phone;
    }
    return TextInputType.name;
  }
}
