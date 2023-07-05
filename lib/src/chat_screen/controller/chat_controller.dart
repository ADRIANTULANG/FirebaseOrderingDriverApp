import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:driverapp/services/getstorage_services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../model/chat_model.dart';

class ChatScreenController extends GetxController {
  RxString order_id = ''.obs;
  RxString customer_id = ''.obs;
  Stream? streamChats;
  RxList<ChatDriverModel> chatList = <ChatDriverModel>[].obs;
  StreamSubscription<dynamic>? listener;

  TextEditingController message = TextEditingController();
  ScrollController scrollController = ScrollController();
  @override
  void onInit() async {
    await FirebaseFirestore.instance
        .collection('driver')
        .doc(Get.find<StorageServices>().storage.read("id"))
        .update({"online": true});
    order_id.value = await Get.arguments['order_id'];
    customer_id.value = await Get.arguments['customer_id'];
    print(order_id.value);
    print(customer_id.value);
    await listenToChanges();
    await getChat();
    super.onInit();
  }

  @override
  void onClose() async {
    await FirebaseFirestore.instance
        .collection('driver')
        .doc(Get.find<StorageServices>().storage.read("id"))
        .update({"online": false});
    listener!.cancel();
    super.onClose();
  }

  listenToChanges() async {
    var userDocumentReference = await FirebaseFirestore.instance
        .collection('users')
        .doc(customer_id.value);
    var driverDocumentReference = await FirebaseFirestore.instance
        .collection('driver')
        .doc(Get.find<StorageServices>().storage.read("id"));
    streamChats = await FirebaseFirestore.instance
        .collection("chattodriver")
        .where("customer", isEqualTo: userDocumentReference)
        .where("driver", isEqualTo: driverDocumentReference)
        .where("orderid", isEqualTo: order_id.value.toString())
        .limit(100)
        .snapshots();
  }

  getChat() async {
    try {
      listener = streamChats!.listen((event) async {
        List data = [];
        for (var chats in event.docs) {
          Map elementData = {
            "id": chats.id,
            "sender": chats['sender'],
            "message": chats['message'],
            "date": chats['date'].toDate().toString()
          };
          data.add(elementData);
        }
        var encodedData = await jsonEncode(data);
        chatList.assignAll(await chatDriverModelFromJson(encodedData));
        chatList.sort((a, b) => a.date.compareTo(b.date));
        Future.delayed(Duration(seconds: 1), () {
          scrollController.jumpTo(scrollController.position.maxScrollExtent);
        });
      });
    } catch (e) {
      print(e.toString() + " eRROR");
    }
  }

  sendMessage({required String chat}) async {
    try {
      var userDocumentReference = await FirebaseFirestore.instance
          .collection(customer_id.value)
          .doc(Get.find<StorageServices>().storage.read("id"));
      var driverDocumentReference = await FirebaseFirestore.instance
          .collection('driver')
          .doc(Get.find<StorageServices>().storage.read("id"));

      var customerDetails = await userDocumentReference.get();
      await FirebaseFirestore.instance.collection('chattodriver').add({
        "customer": userDocumentReference,
        "date": Timestamp.now(),
        "message": chat,
        "orderid": order_id.value.toString(),
        "sender": "driver",
        "driver": driverDocumentReference
      });
      message.clear();
      if (customerDetails.get('online') == false) {
        sendNotificationIfOffline(
            chat: chat,
            orderid: order_id.value.toString(),
            fcmToken: customerDetails.get('fcmToken'));
      }
      Future.delayed(Duration(seconds: 1), () {
        scrollController.jumpTo(scrollController.position.maxScrollExtent);
      });
    } catch (e) {}
  }

  sendNotificationIfOffline(
      {required String chat,
      required String orderid,
      required String fcmToken}) async {
    var body = jsonEncode({
      "to": "$fcmToken",
      "notification": {
        "body": chat,
        "title": 'Customer',
        "subtitle": "Tracking Order: $orderid",
      },
      "data": {"notif_from": "Chat", "value": "$orderid"},
    });
    await http.post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: {
          "Authorization":
              "key=AAAAFXgQldg:APA91bH0blj9KQykFmRZ1Pjub61SPwFyaq-YjvtH1vTvsOeNQ6PTWCYm5S7pOZIuB5zuc7hrFFYsRbuxEB8vF9N5nQoW9fZckjy4bwwltxf4ATPeBDH4L4VlZ1yyVBHF3OKr3yVZ_Ioy",
          "Content-Type": "application/json"
        },
        body: body);
  }
}
