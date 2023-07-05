import 'package:driverapp/services/location_services.dart';
import 'package:driverapp/src/home_screen/widget/home_has_order.dart';
import 'package:driverapp/src/home_screen/widget/home_no_order_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../controller/home_controller.dart';

class HomeScreenView extends GetView<HomeScreenController> {
  const HomeScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(HomeScreenController());
    return SafeArea(
      child: Scaffold(
        body: Stack(
          alignment: AlignmentDirectional.bottomCenter,
          children: [
            Obx(
              () => GoogleMap(
                mapType: MapType.normal,
                initialCameraPosition: CameraPosition(
                  target: LatLng(
                      Get.find<LocationServices>().locationData!.latitude!,
                      Get.find<LocationServices>().locationData!.longitude!),
                  zoom: 14.4746,
                ),
                markers: controller.marker.toSet(),
                myLocationEnabled: true,
                onCameraMove: (position) {
                  if (controller.status.value == 'Has Order') {
                    controller.onCameraMove(
                        latlng: position.target, position: position);
                  }
                },
                polylines: Set<Polyline>.of(controller.polylines.values),
                onCameraMoveStarted: () {
                  print("camera started");
                },
                onMapCreated: (GoogleMapController g_controller) async {
                  if (controller.googleMapController.isCompleted) {
                  } else {
                    controller.googleMapController.complete(g_controller);
                  }
                  controller.camera_controller = await g_controller;
                },
              ),
            ),
            Obx(() => controller.status.value == 'No Order'
                ? HomeNoOrderScreen()
                : controller.status.value == 'Has Order'
                    ? HomeHasOrder()
                    : SizedBox())
          ],
        ),
      ),
    );
  }
}
