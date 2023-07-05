import 'dart:async';

import 'package:driverapp/services/getstorage_services.dart';
import 'package:driverapp/src/home_screen/view/home_view.dart';
import 'package:driverapp/src/login_screen/view/login_view.dart';
import 'package:get/get.dart';

class SplashScreenController extends GetxController {
  @override
  void onInit() {
    navigateTo();
    super.onInit();
  }

  navigateTo() async {
    Timer(Duration(seconds: 4), () {
      if (Get.find<StorageServices>().storage.read("id") != null) {
        Get.offAll(() => HomeScreenView());
      } else {
        Get.offAll(() => LoginScreenView());
      }
    });
  }
}
