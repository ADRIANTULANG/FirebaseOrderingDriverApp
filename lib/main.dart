import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:driverapp/services/getstorage_services.dart';
import 'package:driverapp/services/location_services.dart';
import 'package:driverapp/services/notification_services.dart';
import 'package:driverapp/src/chat_screen/controller/chat_controller.dart';
import 'package:driverapp/src/splashscreen/view/splashscreen_view.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await Get.put(StorageServices());
  await Get.put(LocationServices());
  await Get.put(NotificationServices());
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  // This widget is the root of your application.

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.detached) {
      print("App is Detached");
    } else if (state == AppLifecycleState.paused) {
      print("App is Paused");
    } else if (state == AppLifecycleState.resumed) {
      print("App is Resumed");
      if (Get.isRegistered<ChatScreenController>() == true &&
          Get.find<StorageServices>().storage.read('id') != null) {
        await FirebaseFirestore.instance
            .collection('driver')
            .doc(Get.find<StorageServices>().storage.read('id'))
            .update({"online": true});
      }
    } else if (state == AppLifecycleState.inactive) {
      print("App is Inactive");
      if (Get.isRegistered<ChatScreenController>() == true &&
          Get.find<StorageServices>().storage.read('id') != null) {
        await FirebaseFirestore.instance
            .collection('driver')
            .doc(Get.find<StorageServices>().storage.read('id'))
            .update({"online": false});
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context, orientation, deviceType) {
      return GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Ordering App',
        theme: ThemeData(
          primarySwatch: Colors.amber,
        ),
        home: SplashScreenView(),
      );
    });
  }
}
