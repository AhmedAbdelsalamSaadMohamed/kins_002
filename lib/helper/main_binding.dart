import 'package:get/get.dart';
import 'package:kins_v002/view_model/auth_view_model.dart';
import 'package:kins_v002/view_model/main_view_model.dart';

class MainBinding extends Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.lazyPut<AuthViewModel>(() => AuthViewModel());
    Get.lazyPut<MainViewModel>(() => MainViewModel());
  }
}
