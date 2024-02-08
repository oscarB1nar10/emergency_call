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
  bool isLocationTrackingEnable = false;
  bool hasTokenBeenHandled = false;
  bool locationDisclosureAccepted = false;
  Color iconColor = Colors.blue;

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
        padding: const EdgeInsets.all(8),
        child: GestureDetector(
          onTap: () {
            if (isLocationTrackingEnable) {
              _showStopTrackingDialog();
            } else {
              _showLocationDisclosure();
            }
          },
          child: Icon(Icons.location_searching, color: iconColor),
        ));
  }

  void _showStopTrackingDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Stop Tracking',
            style:
                Theme.of(context).textTheme.titleLarge, // Use themed text style
          ),
          content: Text(
            'Do you want to stop location tracking?',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          actions: [
            TextButton(
              child:
                  Text('Cancel', style: Theme.of(context).textTheme.labelLarge),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
            TextButton(
              child: Text('Stop Tracking',
                  style: Theme.of(context).textTheme.labelLarge),
              onPressed: () {
                // Add logic here to stop tracking
                isLocationTrackingEnable = false;
                _locationStreamSubscription?.cancel();
                setState(() {
                  iconColor = Theme.of(context).colorScheme.primary;
                });
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
          ],
        );
      },
    );
  }

  _showLocationDisclosure() async {
    if (locationDisclosureAccepted) {
      requestLocationPermission();
    }else {
      // Show prominent disclosure for location permission
      bool showDisclosure = await _showLocationPermissionDisclosure();
      if (showDisclosure) {
        requestLocationPermission();
      }
    }
  }

  Future<void> requestLocationPermission() async {
    var statusLocationPermission =
        await permissions.Permission.location.request();

    if (statusLocationPermission.isGranted) {
      startBackgroundLocation();
    } else if (statusLocationPermission.isDenied) {
      _showLocationPermissionDeniedDialog();
    }
  }

  Future<bool> _showLocationPermissionDisclosure() async {
    final theme = Theme.of(context);
    return await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Location Permission',
                  style: theme.textTheme.titleLarge),
              content: Text(
                'Under subscription this app collects location data to enable tracking it and can be query through a web platform, checking the last n locations, where n <= 100, even when the app is in the background, it still could send location data.',
                style: theme.textTheme.bodyMedium,
              ),
              actions: <Widget>[
                TextButton(
                  child: Text('Decline', style: theme.textTheme.labelLarge),
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                ),
                TextButton(
                  child: Text('Allow', style: theme.textTheme.labelLarge),
                  onPressed: () {
                    locationDisclosureAccepted = true;
                    Navigator.of(context).pop(true);
                  },
                ),
              ],
            );
          },
        ) ??
        false; // Assuming the user declines if null is returned
  }

  // Starts background location tracking
  startBackgroundLocation() async {
    // Check if location permissions are granted
    if (await _hasLocationPermissionGranted()) {
      // Ensure the token is available
      _checkSubscriptionToken();

      var locationSettings = _getLocationSettings();
      // Cancel any existing location stream subscription
      _cancelExistingLocationSubscription();

      // Start listening to location updates
      _locationStreamSubscription =
          Geolocator.getPositionStream(locationSettings: locationSettings)
              .listen(_handleLocationUpdate);
    } else {
      // Handle the case when location permissions are not granted
      _handlePermissionNotGranted();
    }
  }

  // Checks if location permissions are granted
  Future<bool> _hasLocationPermissionGranted() async {
    var locationWhenInUseStatus = await Permission.locationWhenInUse.status;
    var locationAlwaysStatus = await Permission.locationAlways.status;
    return locationWhenInUseStatus.isGranted || locationAlwaysStatus.isGranted;
  }

  // Cancels the existing location stream subscription
  void _cancelExistingLocationSubscription() {
    _locationStreamSubscription?.cancel();
  }

  // Handles each location update
  void _handleLocationUpdate(Position? position) {
    if (position != null && !isSubscriptionDialogOpen) {
      isLocationTrackingEnable = true;
      _sendLocation(position);
    }
  }

  void _sendLocation(Position position) {
    if (locationBloc.state.token.isEmpty) {
      _onGetSubscriptionToken();
    } else if (locationBloc.state.userCredentials == null) {
      _onGetUserCredentials();
    } else {
      locationBloc.add(location_events.EventSaveLocation(UserLocation(
          token: locationBloc.state.token,
          userPhoneId: locationBloc.state.userCredentials?.user?.uid ?? "",
          latitude: position.latitude,
          longitude: position.longitude)));

      ScaffoldMessenger.of(context)
        ..removeCurrentSnackBar()
        ..showSnackBar(SnackBar(
            content:
                Text("Location: ${position.latitude}, ${position.longitude}")));
    }
  }

  // Handle the case when permissions are not granted
  void _handlePermissionNotGranted() {
    _showLocationPermissionDeniedDialog();
  }

  void _showLocationPermissionDeniedDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Location Permission Denied',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          content: Text(
            'Without location access, certain features of the app may not work. Please grant permission from settings.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          actions: [
            TextButton(
              child: Text(
                'Later',
                style: Theme.of(context).textTheme.labelLarge,
              ),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
            TextButton(
              child: Text(
                'Open Settings',
                style: Theme.of(context).textTheme.labelLarge,
              ),
              onPressed: () {
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
          _showLocationDisclosure();
        }
      }

      // Check if the token has changed and update the icon color accordingly
      if (state.token.isNotEmpty &&
          iconColor != Colors.green[800] &&
          !state.displaySubscriptionDialog) {
        setState(() {
          iconColor =
              Colors.green[800] ?? Theme.of(context).colorScheme.onSecondary;
        });
      } else if (state.token.isEmpty &&
          iconColor != Theme.of(context).colorScheme.primary &&
          !state.displaySubscriptionDialog) {
        setState(() {
          iconColor = Theme.of(context).colorScheme.primary;
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
          title: Text(
            'Tracking Service Not Available',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          content: Text(
            'You have not acquired the tracking service in the subscription options. Would you like to subscribe?',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          actions: [
            TextButton(
              child: Text(
                'Not Now',
                style: Theme.of(context).textTheme.labelLarge,
              ),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                _locationStreamSubscription?.cancel();
                setState(() {
                  isSubscriptionDialogOpen = false;
                });
              },
            ),
            TextButton(
              child: Text(
                'Subscribe Now',
                style: Theme.of(context).textTheme.labelLarge,
              ),
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
