import 'package:emergency_call/domain/model/Location.dart';
import 'package:emergency_call/framework/presentation/home/HomeBloc.dart';
import 'package:emergency_call/framework/presentation/home/HomeEvents.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:permission_handler/permission_handler.dart' as permissions;

class LocationWidget extends StatefulWidget {
  const LocationWidget({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _LocationWidget();
}

class _LocationWidget extends State<LocationWidget> {
  Geolocator geolocator = Geolocator();
  late HomeBloc homeBloc;
  var isLocationEnable = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(right: 16),
        child: GestureDetector(
          onTap: () {
            _onGetUserCredentials();
          },
          child: Icon(
            Icons.location_searching,
            color: isLocationEnable ? Colors.green : Colors.white70,
          ),
        ));
  }

  Future<void> requestLocationPermission(BuildContext context) async {
    var statusLocationPermission =
        await permissions.Permission.location.request();

    if (statusLocationPermission.isGranted) {
      startBackgroundLocation();
      isLocationEnable = !isLocationEnable;
    } else if (statusLocationPermission.isDenied) {
      // TODO("Handle negation of permissions through an explanation")
    }
  }

  startBackgroundLocation() async {
    var locationWhenInUsePermissionStatus =
        await Permission.locationWhenInUse.status;
    var locationAlwaysStatus = await Permission.locationAlways.status;

    if (locationWhenInUsePermissionStatus.isGranted ||
        locationAlwaysStatus.isGranted) {
      LocationSettings locationSettings = AndroidSettings(
          accuracy: LocationAccuracy.medium,
          distanceFilter: 2,
          forceLocationManager: true,
          intervalDuration: const Duration(seconds: 10),
          //(Optional) Set foreground notification config to keep the app alive
          //when going to the background
          foregroundNotificationConfig: const ForegroundNotificationConfig(
            notificationText:
                "emergency call app will continue to receive your location even when you aren't using it",
            notificationTitle: "Running in Background",
            enableWakeLock: true,
          ));

      Geolocator.getPositionStream(locationSettings: locationSettings)
          .listen((Position? position) {
        if (position != null) {
          homeBloc.add(EventSaveLocation(UserLocation(
              userPhoneId: homeBloc.state.userCredentials?.user?.uid ?? "",
              latitude: position.latitude,
              longitude: position.longitude)));

          ScaffoldMessenger.of(context)
            ..removeCurrentSnackBar()
            ..showSnackBar(SnackBar(
                content: Text(
                    "Location: ${position.latitude}, ${position.longitude}")));
        }
      });
    } else {}
  }

  _onGetUserCredentials() async {
    homeBloc = BlocProvider.of<HomeBloc>(context, listen: false);
    // Get user credentials from Google account
    homeBloc.add(const EventGetUserCredentials());
    homeBloc.stream.listen((state) {
      if (state.userCredentials != null) {
        requestLocationPermission(context);
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }
}
