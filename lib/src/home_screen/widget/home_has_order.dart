import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../../chat_screen/view/chat_view.dart';
import '../controller/home_controller.dart';

class HomeHasOrder extends GetView<HomeScreenController> {
  const HomeHasOrder({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: EdgeInsets.only(left: 2.w, right: 2.w, bottom: 2.w),
        child: Container(
          height: 40.h,
          width: 100.w,
          padding: EdgeInsets.only(left: 3.w, right: 3.w, top: 3.w),
          decoration: BoxDecoration(
              border: Border.all(color: Colors.black),
              color: Colors.white,
              borderRadius: BorderRadius.circular(12)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Obx(
                        () => Text(
                          controller.order_id.value,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 13.sp),
                        ),
                      ),
                      Obx(
                        () => Text(
                          "₱ " + controller.order_total.value.toString(),
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 13.sp),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 2.h,
                  ),
                  Obx(
                    () => Text(
                      controller.customer_name.value,
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 13.sp),
                    ),
                  ),
                  Obx(
                    () => Text(
                      controller.delivery_address.value,
                      style: TextStyle(
                          fontWeight: FontWeight.w400, fontSize: 13.sp),
                    ),
                  ),
                  SizedBox(
                    height: 2.h,
                  ),
                  Row(
                    children: [
                      Icon(Icons.motorcycle),
                      SizedBox(
                        width: 2.w,
                      ),
                      Obx(
                        () => Text(
                          "₱ " + controller.delivery_fee.value.toString(),
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 13.sp),
                        ),
                      ),
                    ],
                  )
                ],
              ),
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: () {
                          Get.to(() => ChatScreenView(), arguments: {
                            'order_id': controller.order_id.value,
                            'customer_id': controller.customerid.value
                          });
                        },
                        child: Container(
                            height: 7.h,
                            width: 40.w,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                color: Colors.amber[900],
                                border: Border.all(color: Colors.black),
                                borderRadius: BorderRadius.circular(8)),
                            child: Icon(
                              Icons.chat,
                              color: Colors.white,
                            )),
                      ),
                      InkWell(
                        onTap: () {
                          controller.callCustomer(
                              phoneNumber: controller.customer_contact.value);
                        },
                        child: Container(
                            height: 7.h,
                            width: 40.w,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                color: Colors.amber[900],
                                border: Border.all(color: Colors.black),
                                borderRadius: BorderRadius.circular(8)),
                            child: Icon(
                              Icons.call,
                              color: Colors.white,
                            )),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 1.h,
                  ),
                  InkWell(
                    onTap: () {
                      controller.delivered_order();
                    },
                    child: Container(
                      height: 7.h,
                      width: 100.w,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: Colors.amber[900],
                          border: Border.all(color: Colors.black),
                          borderRadius: BorderRadius.circular(8)),
                      child: Text(
                        "DELIVERED",
                        style: TextStyle(
                          letterSpacing: 2,
                          fontWeight: FontWeight.w600,
                          fontSize: 20.sp,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 2.h,
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
