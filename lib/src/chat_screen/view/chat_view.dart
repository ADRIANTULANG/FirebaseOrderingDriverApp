import 'package:driverapp/src/chat_screen/controller/chat_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:intl/intl.dart';

class ChatScreenView extends GetView<ChatScreenController> {
  const ChatScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(ChatScreenController());
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          leading: InkWell(
            onTap: () {
              Get.back();
            },
            child: Icon(
              Icons.arrow_back_ios_new_outlined,
              size: 20.sp,
              color: Colors.black,
            ),
          ),
          title: Text("Customer"),
        ),
        body: Container(
          child: Column(
            children: [
              Expanded(
                child: Container(
                  child: Obx(
                    () => ListView.builder(
                      itemCount: controller.chatList.length,
                      shrinkWrap: true,
                      controller: controller.scrollController,
                      padding: EdgeInsets.only(top: 10, bottom: 10),
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            Container(
                              padding: EdgeInsets.only(
                                left: 14,
                                right: 14,
                                top: 10,
                              ),
                              child: Align(
                                alignment: (controller.chatList[index].sender ==
                                        "customer"
                                    ? Alignment.topLeft
                                    : Alignment.topRight),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: (controller.chatList[index].sender ==
                                            "customer"
                                        ? Colors.grey.shade200
                                        : Colors.orange[200]),
                                  ),
                                  padding: EdgeInsets.all(16),
                                  child: Text(
                                    controller.chatList[index].message,
                                    style: TextStyle(fontSize: 15),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                left: 7.w,
                                right: 7.w,
                              ),
                              child: Align(
                                  alignment:
                                      (controller.chatList[index].sender ==
                                              "customer"
                                          ? Alignment.topLeft
                                          : Alignment.topRight),
                                  child: Text(
                                    DateFormat('yMMMd').format(
                                            controller.chatList[index].date) +
                                        " " +
                                        DateFormat('jm').format(
                                            controller.chatList[index].date),
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        color: Colors.grey,
                                        fontSize: 9.sp),
                                  )),
                            )
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ),
              Container(
                height: 10.h,
                color: Colors.grey,
                padding: EdgeInsets.only(bottom: 2.h, left: 3.w, right: 3.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      height: 5.h,
                      width: 85.w,
                      child: TextField(
                        controller: controller.message,
                        decoration: InputDecoration(
                            fillColor: Colors.white,
                            filled: true,
                            contentPadding: EdgeInsets.only(left: 3.w),
                            alignLabelWithHint: false,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8)),
                            hintText: 'Type something..'),
                      ),
                    ),
                    InkWell(
                        onTap: () {
                          controller.sendMessage(chat: controller.message.text);
                        },
                        child: Icon(Icons.send))
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
