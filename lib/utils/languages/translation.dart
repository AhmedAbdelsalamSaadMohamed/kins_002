import 'package:get/get.dart';
import 'package:kins_v002/utils/Languages/ar.dart';
import 'package:kins_v002/utils/Languages/en.dart';

class Translation extends Translations {
  @override
  Map<String, Map<String, String>> get keys {
    return {'en': en, 'ar': ar};
  }
}
