import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../controller/splashscreen_controller.dart';

class SplashScreenView extends GetView<SplashScreenController> {
  const SplashScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(SplashScreenController());
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(left: 3.w),
        height: 100.h,
        width: 100.w,
        decoration: BoxDecoration(
            color: Colors.white,
            image:
                DecorationImage(image: AssetImage("assets/images/logo.png"))),
      ),
    );
  }
}
