import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../../scanner_screen/view/scanner_view.dart';
import '../controller/home_controller.dart';

class HomeNoOrderScreen extends GetView<HomeScreenController> {
  const HomeNoOrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: EdgeInsets.only(left: 2.w, right: 2.w, bottom: 2.w),
        child: InkWell(
          onTap: () {
            Get.to(() => ScannerView());
          },
          child: Container(
            height: 7.h,
            width: 100.w,
            alignment: Alignment.center,
            decoration: BoxDecoration(
                border: Border.all(color: Colors.white),
                color: Colors.orange,
                borderRadius: BorderRadius.circular(12)),
            child: Text(
              "SCAN",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.sp),
            ),
          ),
        ),
      ),
    );
  }
}
