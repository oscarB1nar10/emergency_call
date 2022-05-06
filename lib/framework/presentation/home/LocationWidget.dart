import 'package:background_location/background_location.dart';
import 'package:emergency_call/domain/model/Location.dart';
import 'package:emergency_call/framework/presentation/home/HomeBloc.dart';
import 'package:emergency_call/framework/presentation/home/HomeEvents.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';

class LocationWidget extends StatefulWidget {
  const LocationWidget({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _LocationWidget();
}

class _LocationWidget extends State<LocationWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(right: 16),
        child: GestureDetector(
          onTap: () {
            startBackgroundLocation();
          },
          child: const Icon(Icons.location_searching),
        ));
  }

  startBackgroundLocation() async {
    HomeBloc homeBloc = BlocProvider.of<HomeBloc>(context, listen: false);

    var locationPermissionStatus = await Permission.locationAlways.status;

    if (locationPermissionStatus.isDenied) {
      await BackgroundLocation.setAndroidNotification(
        title: 'Background service is running',
        message: 'Background location in progress',
        icon: '@mipmap/ic_launcher',
      );
    }

    //await BackgroundLocation.setAndroidConfiguration(1000);
    await BackgroundLocation.startLocationService(distanceFilter: 5);
    BackgroundLocation.startLocationService(forceAndroidLocationManager: true);

    BackgroundLocation.getLocationUpdates((location) {
      print("current Location: $location");
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("current Location"),
      ));

      // Save contact in localDB
      homeBloc.add(EventSaveLocation(UserLocation(
          latitude: location.latitude ?? 0.0,
          longitude: location.longitude ?? 0.0)));
    });
  }

  @override
  void dispose() {
    BackgroundLocation.stopLocationService();
    super.dispose();
  }
}
