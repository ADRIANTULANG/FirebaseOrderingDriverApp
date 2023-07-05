import 'dart:async';
import 'package:driverapp/services/location_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:driverapp/services/getstorage_services.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeScreenController extends GetxController {
  final Completer<GoogleMapController> googleMapController = Completer();
  PolylinePoints polylinePoints = PolylinePoints();
  Map<PolylineId, Polyline> polylines = {};
  List<LatLng> polylineCoordinates = [];
  GoogleMapController? camera_controller;

  RxList<Marker> marker = <Marker>[].obs;

  RxString status = ''.obs;

  RxString delivery_address = ''.obs;
  RxString order_id = ''.obs;
  RxDouble latitude = 0.0.obs;
  RxDouble longitude = 0.0.obs;
  RxString customer_name = ''.obs;
  RxString customer_contact = ''.obs;
  RxString customerid = ''.obs;
  RxDouble delivery_fee = 0.0.obs;
  RxDouble order_total = 0.0.obs;

  @override
  void onInit() {
    if (Get.find<StorageServices>().storage.read('status') == null) {
      status.value = 'No Order';
    } else {
      status.value = Get.find<StorageServices>().storage.read('status');
      getOrder(orderid: Get.find<StorageServices>().storage.read('orderid'));
    }
    super.onInit();
  }

  getOrder({required String orderid}) async {
    var order = await FirebaseFirestore.instance
        .collection('orders')
        .doc(orderid)
        .get();
    var customerDetails = await FirebaseFirestore.instance
        .collection('users')
        .doc(order.get('customer_id').id)
        .get();
    if (order.get('order_status') == "Checkout" ||
        order.get('order_status') == "On Delivery") {
      await FirebaseFirestore.instance
          .collection('orders')
          .doc(orderid)
          .update({
        "driver": Get.find<StorageServices>().storage.read('id'),
        "order_status": "On Delivery"
      });
      Get.find<StorageServices>()
          .setStatus(status: "Has Order", orderid: orderid);
      Get.find<HomeScreenController>().status.value = "Has Order";
      var firstname = customerDetails.get('firstname');
      var lastname = customerDetails.get('lastname');
      order_id.value = orderid;
      delivery_address.value = order.get('delivery_address');
      latitude.value = order.get('l')[0];
      longitude.value = order.get('l')[1];
      customer_name.value = firstname + " " + lastname;
      customerid.value = customerDetails.id;
      customer_contact.value = customerDetails.get('contactno');
      order_total.value = order.get('order_total');
      delivery_fee.value = order.get('delivery_fee');
      marker.clear();
      marker.add(Marker(
          position: LatLng(latitude.value, longitude.value),
          markerId: MarkerId(orderid),
          infoWindow: InfoWindow(title: delivery_address.value)));

      await Get.find<LocationServices>().getCurrentLocation();

      PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        'AIzaSyD7YYsXaAueQ9PxtjrsajOe5zi2DiPEp68',
        PointLatLng(Get.find<LocationServices>().locationData!.latitude!,
            Get.find<LocationServices>().locationData!.longitude!),
        PointLatLng(latitude.value, longitude.value),
        travelMode: TravelMode.driving,
      );
      print(result);
      if (result.points.isNotEmpty) {
        result.points.forEach((PointLatLng point) {
          polylineCoordinates.add(LatLng(point.latitude, point.longitude));
        });
      } else {
        print("ERROR: ${result.errorMessage}");
      }
      await addPolyLine(polylineCoordinates);
      await camera_controller!
          .animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: LatLng(Get.find<LocationServices>().locationData!.latitude!,
            Get.find<LocationServices>().locationData!.longitude!),
        zoom: 18.4746,
      )));
    } else {
      ScaffoldMessenger.of(Get.context!).showSnackBar(SnackBar(
        content: Text('Order is not ready to deliver'),
      ));
    }
  }

  addPolyLine(List<LatLng> polylineCoordinates) {
    PolylineId id = PolylineId("poly");
    Polyline polyline = Polyline(
      polylineId: id,
      color: Colors.orangeAccent,
      points: polylineCoordinates,
      width: 8,
    );
    polylines[id] = polyline;
  }

  onCameraMove(
      {required LatLng latlng, required CameraPosition position}) async {
    CompassEvent tmp = await FlutterCompass.events!.first;
    await Get.find<LocationServices>().getCurrentLocation();
    await camera_controller!
        .animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
      bearing: tmp.heading!,
      target: LatLng(Get.find<LocationServices>().locationData!.latitude!,
          Get.find<LocationServices>().locationData!.longitude!),
      zoom: 18.4746,
    )));
  }

  delivered_order() async {
    try {
      await FirebaseFirestore.instance
          .collection('orders')
          .doc(order_id.value)
          .update({"order_status": "Delivered"});
      Get.find<StorageServices>().resetDeliveryStatus();
      status.value = 'No Order';
      delivery_address.value = '';
      order_id.value = '';
      latitude.value = 0.0;
      longitude.value = 0.0;
      customer_name.value = '';
      customer_contact.value = '';
      delivery_fee.value = 0.0;
      order_total.value = 0.0;
      ScaffoldMessenger.of(Get.context!).showSnackBar(SnackBar(
        content: Text('Order Delivered'),
      ));
    } catch (e) {
      print(e);
    }
  }

  Future<void> callCustomer({required String phoneNumber}) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    await launchUrl(launchUri);
  }
}
