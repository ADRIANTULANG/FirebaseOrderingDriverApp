import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../services/getstorage_services.dart';
import '../../../services/notification_services.dart';
import '../../home_screen/view/home_view.dart';
import '../alertdialog/login_alertdialog.dart';

class LoginController extends GetxController {
  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();
  @override
  void onInit() {
    super.onInit();
  }

  login({required String username, required String password}) async {
    List data = [];
    Map userData = {};
    try {
      await FirebaseFirestore.instance
          .collection('driver')
          .where('username', isEqualTo: username)
          .where('password', isEqualTo: password)
          .get()
          .then((querySnapshot) {
        querySnapshot.docs.forEach((element) {
          Map elementData = {
            "id": element.id,
            "firstname": element['firstname'],
            "lastname": element['lastname'],
            "username": element['username'],
            "password": element['password'],
            "contactno": element['contactno'],
            "storeid": element['storeid'].id,
          };
          userData = elementData;
          data.add(elementData);
        });
      });
      if (data.isNotEmpty || data.length != 0) {
        Get.find<StorageServices>().saveCredentials(
          storeid: userData['storeid'],
          contactno: userData['contactno'],
          id: userData['id'],
          username: userData['username'],
          password: userData['password'],
          firstname: userData['firstname'],
          lastname: userData['lastname'],
        );
        Get.to(() => HomeScreenView());
        Get.find<NotificationServices>().getToken();

        await FirebaseFirestore.instance
            .collection('driver')
            .doc(Get.find<StorageServices>().storage.read('id'))
            .update({"online": false});
        // storeList.assignAll(await storeModelFromJson(encodedData));
      } else {
        LoginAlertDialog.showAccountNotFound();
      }
    } on Exception catch (e) {
      print(e.toString());
    }
  }
}
