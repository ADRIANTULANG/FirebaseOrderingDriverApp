import 'package:get/get.dart';
import 'package:location/location.dart';

class LocationServices extends GetxController {
  Location location = new Location();

  bool? serviceEnabled;
  PermissionStatus? permissionGranted;
  LocationData? locationData;

  @override
  void onInit() {
    initLocation();
    super.onInit();
  }

  initLocation() async {
    serviceEnabled = await location.serviceEnabled();
    if (serviceEnabled!) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled!) {
        return;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    locationData = await location.getLocation();

    print(locationData!.latitude);
    print(locationData!.longitude);
  }

  getCurrentLocation() async {
    locationData = await location.getLocation();
  }
}
