import 'package:emergency_call/framework/presentation/ContactsPageWidget.dart';
import 'package:emergency_call/framework/presentation/model/PersonalContact.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart' as permissions;
import 'package:telephony/telephony.dart';

class HomeScreenWidget extends StatefulWidget {
  const HomeScreenWidget({Key? key}) : super(key: key);

  @override
  _HomeScreenWidget createState() => _HomeScreenWidget();
}

class _HomeScreenWidget extends State<HomeScreenWidget> {
  PersonalContact personalContact = const PersonalContact("", "");
  final telephony = Telephony.instance;
  final location = Location.instance;

  onSendStatus(SendStatus status) {
    setState(() {
      if (status == SendStatus.SENT) {
        ScaffoldMessenger.of(context)
          ..removeCurrentSnackBar()
          ..showSnackBar(const SnackBar(content: Text("Message sent")));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Emergency call"),
          centerTitle: true,
        ),
        body: Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                showContactInfo(),
                Column(children: [
                  InkWell(
                    child: const Image(
                        image: AssetImage('assets/emergency_call.png')),
                    onTap: () {
                      requestContactsPermissions(context);
                    },
                  ),
                ]),
                showEmergencyBell()
              ]),
        ));
  }

  Future<void> requestContactsPermissions(BuildContext context) async {
    var statusContactsPermission =
        await permissions.Permission.contacts.request();
    var statusLocationPermission =
        await permissions.Permission.location.request();

    // Contacts permissions
    if (statusContactsPermission.isGranted) {
      _navigateContactsPage(context);
    } else if (statusContactsPermission ==
        permissions.PermissionStatus.denied) {
      print(
          'Denied. Show a dialog with a reason and again ask for the permission.');
    } else if (statusContactsPermission ==
        permissions.PermissionStatus.permanentlyDenied) {
      print('Take the user to the settings page.');
    }

    // Location permissions
    if (statusLocationPermission.isGranted) {
      print("Location permission granted");
    } else if (statusLocationPermission.isDenied) {
      print('Location permission granted denied');
    }
  }

  // A method that launches the SelectionScreen and awaits the result from
// Navigator.pop.
  void _navigateContactsPage(BuildContext context) async {
    // Navigator.push returns a Future that completes after calling
    // Navigator.pop on the Selection Screen.
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ContactsPage()),
    );

    PersonalContact personalContact = result as PersonalContact;

    // After the Selection Screen returns a result, hide any previous snackbars
    // and show the new result.
    ScaffoldMessenger.of(context)
      ..removeCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(personalContact.name)));

    setState(() {
      this.personalContact = personalContact;
    });
  }

  Widget showContactInfo() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [Text(personalContact.name), Text(personalContact.phone)],
    );
  }

  Widget showEmergencyBell() {
    if (personalContact.phone.isNotEmpty) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          InkWell(
            child: const Image(image: AssetImage('assets/help.png')),
            onTap: () {
              // Send SMS
              triggerEmergencySMS(personalContact.name, personalContact.phone);
            },
          )
        ],
      );
    } else {
      // Empty widget
      return const SizedBox.shrink();
    }
  }

  Future<void> triggerEmergencySMS(String name, String phone) async {
    bool permissionsGranted =
        await telephony.requestPhoneAndSmsPermissions ?? false;

    var hasPermissionGranted = await location.hasPermission();

    if (permissionsGranted &&
        hasPermissionGranted == PermissionStatus.granted) {
      var locationData = await location.getLocation();

      final url =
          'https://www.google.com/maps/search/?api=1&query=${locationData.latitude},${locationData.longitude}';

      telephony.sendSms(
          to: phone,
          message:
              "Hello $name, this is a emergency from the Emergency Call.\nYou can find to me here: $url",
          statusListener: onSendStatus);
    }
  }
}
