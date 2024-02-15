

import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:location/location.dart';

void initializeService() async {
  final service = FlutterBackgroundService();

  // Define the initialization of the service
  await service.configure(
    androidConfiguration: AndroidConfiguration(
      onStart: onStart,
      autoStart: true,
      isForegroundMode: true,
    ),
    iosConfiguration: IosConfiguration(),
  );

  // Start the service
  service.startService();
}

Future<void> onStart(ServiceInstance service) async {
  // Enable receiving messages sent from the main isolate
  service.on('start').listen((event) async {
    final location = Location();

    // Ensure the location service is enabled and permissions are granted
    bool serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    PermissionStatus permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    // Listen to location changes
    location.onLocationChanged.listen((LocationData currentLocation) {
      // Handle location update
      // Example: send location data to your server or log it
      print("Location: ${currentLocation.latitude}, ${currentLocation.longitude}");
    });
  });
}

