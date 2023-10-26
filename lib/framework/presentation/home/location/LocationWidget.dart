import 'dart:async';

import 'package:emergency_call/domain/model/ErrorType.dart';
import 'package:emergency_call/domain/model/Location.dart';
import 'package:emergency_call/framework/presentation/home/dashboard/HomeBloc.dart';
import 'package:emergency_call/framework/presentation/home/dashboard/HomeEvents.dart'
    as home_events;
import 'package:emergency_call/framework/presentation/home/location/LocationBloc.dart';
import 'package:emergency_call/framework/presentation/home/location/LocationEvents.dart'
    as location_events;
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
  StreamSubscription? _streamSubscription;
  StreamSubscription? _locationStreamSubscription;
  Geolocator geolocator = Geolocator();
  late HomeBloc homeBloc;
  late LocationBloc locationBloc;
  var isLocationEnable = false;
  var isSubscriptionDialogOpen = false;
  bool isBlocLoading = false;
  bool hasTokenBeenHandled = false;
  Color iconColor = Colors.white; // Default color when token is empty

  @override
  void initState() {
    super.initState();
    homeBloc = BlocProvider.of<HomeBloc>(context);
    locationBloc = BlocProvider.of<LocationBloc>(context, listen: false);
    _onRegisterBlocListener();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(right: 16),
        child: GestureDetector(
          onTap: () {
            requestLocationPermission(context);
          },
          child: Icon(Icons.location_searching, color: iconColor),
        ));
  }

  Future<void> requestLocationPermission(BuildContext context) async {
    var statusLocationPermission =
        await permissions.Permission.location.request();

    if (statusLocationPermission.isGranted) {
      startBackgroundLocation();
      isLocationEnable = !isLocationEnable;
    } else if (statusLocationPermission.isDenied) {
      _showLocationPermissionDeniedDialog();
    }
  }

  startBackgroundLocation() async {
    var locationWhenInUsePermissionStatus =
        await Permission.locationWhenInUse.status;
    var locationAlwaysStatus = await Permission.locationAlways.status;

    if (locationWhenInUsePermissionStatus.isGranted ||
        locationAlwaysStatus.isGranted) {
      _checkSubscriptionToken();
      var locationSettings = _getLocationSettings();
      // Cancel any existing subscription before starting a new one
      _locationStreamSubscription?.cancel();

      _locationStreamSubscription =
          Geolocator.getPositionStream(locationSettings: locationSettings)
              .listen((Position? position) {
        if (position != null && !isSubscriptionDialogOpen) {
          if (locationBloc.state.token.isEmpty) {
            _onGetSubscriptionToken();
          } else if (locationBloc.state.userCredentials == null) {
            _onGetUserCredentials();
          } else {
            locationBloc.add(location_events.EventSaveLocation(UserLocation(
                token: locationBloc.state.token,
                userPhoneId:
                    locationBloc.state.userCredentials?.user?.uid ?? "",
                latitude: position.latitude,
                longitude: position.longitude)));

            ScaffoldMessenger.of(context)
              ..removeCurrentSnackBar()
              ..showSnackBar(SnackBar(
                  content: Text(
                      "Location: ${position.latitude}, ${position.longitude}")));
          }
        }
      });
    } else {}
  }

  void _showLocationPermissionDeniedDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Location Permission Denied'),
          content: const Text(
              'Without location access, certain features of the app may not work. Please grant permission from settings.'),
          actions: [
            TextButton(
              child: const Text('Later'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
            TextButton(
              child: const Text('Open Settings'),
              onPressed: () {
                // Redirect to app settings
                openAppSettings();
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
          ],
        );
      },
    );
  }

  _checkSubscriptionToken() {
    if (!isSubscriptionDialogOpen) {
      if (locationBloc.state.token.isEmpty) {
        _onGetSubscriptionToken();
      }
    }
  }

  LocationSettings _getLocationSettings() {
    LocationSettings locationSettings = AndroidSettings(
        accuracy: LocationAccuracy.medium,
        distanceFilter: 0,
        forceLocationManager: true,
        intervalDuration: const Duration(seconds: 20),
        //(Optional) Set foreground notification config to keep the app alive
        //when going to the background
        foregroundNotificationConfig: const ForegroundNotificationConfig(
          notificationText:
              "emergency call app will continue to receive your location even when you aren't using it",
          notificationTitle: "Running in Background",
          enableWakeLock: true,
        ));
    return locationSettings;
  }

  _onGetUserCredentials() async {
    // Get user credentials from Google account
    locationBloc.add(const location_events.EventGetUserCredentials());
  }

  _onGetSubscriptionToken() async {
    // Get subscription token from preferences
    locationBloc.add(const location_events.EventGetSubscriptionToken());
  }

  _onRegisterBlocListener() async {
    // Cancel the  existing subscription if it exists
    _streamSubscription?.cancel();

    _streamSubscription = locationBloc.stream.listen((state) {
      if (state.userCredentials != null && !hasTokenBeenHandled) {
        if (state.token.isNotEmpty) {
          hasTokenBeenHandled = true;
          requestLocationPermission(context);
        }
      }

      // Check if the token has changed and update the icon color accordingly
      if (state.token.isNotEmpty &&
          iconColor != Colors.lightBlue &&
          !state.displaySubscriptionDialog) {
        setState(() {
          iconColor = Colors.lightBlue;
        });
      } else if (state.token.isEmpty &&
          iconColor != Colors.white &&
          !state.displaySubscriptionDialog) {
        setState(() {
          iconColor = Colors.white;
        });
      }

      if (state.saveLocationResponse?.errorType != null &&
          state.saveLocationResponse?.errorType is! None) {
        homeBloc.add(home_events.EventShowSnackbarError(
            state.saveLocationResponse?.errorType.message ?? ""));
      }

      if (state.displaySubscriptionDialog && !isSubscriptionDialogOpen) {
        _showSubscriptionDialog();
        locationBloc.add(location_events.EventUpdateDisplaySubsDialog());
      }

      setState(() {
        isBlocLoading = state.isLoading;
      });
    });
  }

  void _showSubscriptionDialog() {
    setState(() {
      isSubscriptionDialogOpen = true;
    });
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Tracking Service Not Available'),
          content: const Text(
              'You have not acquired the tracking service in the subscription options. Would you like to subscribe?'),
          actions: [
            TextButton(
              child: const Text('Not Now'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                _locationStreamSubscription?.cancel();
                setState(() {
                  isSubscriptionDialogOpen = false;
                });
              },
            ),
            TextButton(
              child: const Text('Subscribe Now'),
              onPressed: () {
                isSubscriptionDialogOpen = false;
                Navigator.of(context).pop(); // Close the dialog
                _navigateToSubscriptionsScreen();
              },
            ),
          ],
        );
      },
    );
  }

  void _navigateToSubscriptionsScreen() {
    Navigator.pushReplacementNamed(context, '/subscriptions');
  }

  @override
  void dispose() {
    _streamSubscription?.cancel();
    _locationStreamSubscription?.cancel();
    super.dispose();
  }
}
