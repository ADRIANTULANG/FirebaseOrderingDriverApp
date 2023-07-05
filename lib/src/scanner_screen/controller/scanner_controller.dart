import 'package:driverapp/src/home_screen/controller/home_controller.dart';
import 'package:get/get.dart';

class ScannerController extends GetxController {
  @override
  void onInit() {
    super.onInit();
  }

  setOrder({required String orderid}) async {
    await Get.find<HomeScreenController>().getOrder(orderid: orderid);
    Get.back();
  }
}
