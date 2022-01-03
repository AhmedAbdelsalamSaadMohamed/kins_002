import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:kins_v002/constant/random_id.dart';
import 'package:kins_v002/controllers/local_tree_controller.dart';
import 'package:kins_v002/model/user_model.dart';
import 'package:kins_v002/view/screens/main_screen.dart';
import 'package:kins_v002/view/widgets/add_bottum_widget.dart';
import 'package:kins_v002/view/widgets/custom_text.dart';
import 'package:kins_v002/view/widgets/custom_text_form_field_widget.dart';

class UserFormWidget extends StatefulWidget {
  UserFormWidget({
    Key? key,
    UserModel? user,
    this.action = 'add',
  }) : super(key: key) {
    this.user = user ?? UserModel();
  }

  String action;
  late UserModel user;

  @override
  State<UserFormWidget> createState() => _UserFormWidgetState();
}

class _UserFormWidgetState extends State<UserFormWidget> {
  DateTime? birthdate;

  @override
  Widget build(BuildContext context) {
    GlobalKey<FormState> _formKy = GlobalKey<FormState>();
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Form(
          key: _formKy,
          child: ListView(
            children: [
              CustomTextFormFieldWidget(
                hint: 'Name',
                value: widget.user.name,
                onSaved: (newValue) {
                  widget.user.name = newValue!;
                },
              ),
              const SizedBox(height: 20),
              CustomTextFormFieldWidget(
                value: widget.user.email,
                hint: 'Email',
                onSaved: (newValue) {},
              ),
              const SizedBox(height: 20),
              CustomTextFormFieldWidget(
                hint: 'Phone',
                onSaved: (newValue) {},
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
          title: widget.action == 'add' ? 'ADD' : 'DONE',
          onPressed: () {
            print(
                'addddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd');

            _formKy.currentState!.save();
            UserModel newUser = UserModel(
              id: widget.user.id ?? RandomId().getId(25),
              gender: widget.user.gender,
              name: widget.user.name,
              mom: widget.user.mom,
              dad: widget.user.dad,
              email: widget.user.email,
              spouse: widget.user.spouse,
            );
            if (widget.action == 'add') {
              Get.find<LocalTreeController>().setUser(newUser).then((value) {
                Get.offAll(MainScreen());
              });
            } else {
              Get.find<LocalTreeController>().setUser(newUser).then((value) {
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
