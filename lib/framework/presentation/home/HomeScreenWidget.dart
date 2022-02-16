import 'package:emergency_call/domain/model/FavoriteContact.dart';
import 'package:emergency_call/framework/presentation/home/ContactsPageWidget.dart';
import 'package:emergency_call/framework/presentation/home/HomeBloc.dart';
import 'package:emergency_call/framework/presentation/home/HomeEvents.dart';
import 'package:emergency_call/framework/presentation/model/PersonalContact.dart';
import 'package:emergency_call/framework/presentation/utility/Strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart' as permissions;
import 'package:telephony/telephony.dart';

import 'HomeState.dart';

class HomeScreenWidget extends StatefulWidget {
  const HomeScreenWidget({Key? key}) : super(key: key);

  @override
  _HomeScreenWidget createState() => _HomeScreenWidget();
}

class _HomeScreenWidget extends State<HomeScreenWidget> {
  var personalContact = const PersonalContact();
  final telephony = Telephony.instance;
  final location = Location.instance;

  onSendStatus(SendStatus status) {
    setState(() {
      if (status == SendStatus.SENT) {
        ScaffoldMessenger.of(context)
          ..removeCurrentSnackBar()
          ..showSnackBar(const SnackBar(content: Text(Strings.messageSent)));
      } else {
        ScaffoldMessenger.of(context)
          ..removeCurrentSnackBar()
          ..showSnackBar(const SnackBar(content: Text(Strings.messageNotSent)));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(Strings.emergencyCall),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              showContactInfo(),
              showEmergencyBell()
            ]),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          requestContactsPermissions(context);
        },
        backgroundColor: Colors.red,
      ),
    );
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

      HomeBloc homeBloc = BlocProvider.of<HomeBloc>(context, listen: false);

      // Save contact in localDB
      homeBloc.add(EventAddFavoriteContact(
          personalContact.fromPersonalToFavoriteContact()));
    });
  }

  Widget showContactInfo() {
    // Launch event to retrieve saved favorite contacts.
    HomeBloc homeBloc = BlocProvider.of<HomeBloc>(context, listen: false);
    homeBloc.add(const EventGetFavoriteContact());

    return BlocBuilder<HomeBloc, HomeState>(builder: (context, state) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          if (state.favoriteContactsDataSource.isNotEmpty)
            Center(
              child: ListView.builder(
                shrinkWrap: true,
                // Let the ListView know how many items it needs to build.
                itemCount: state.favoriteContactsDataSource.length,
                // Provide a builder function. This is where the magic happens.
                // Convert each item into a widget based on the type of item it is.
                itemBuilder: (context, index) {
                  final item = state.favoriteContactsDataSource[index];

                  return Dismissible(
                      key: Key(index.toString()),
                      // Show a red background as the item is swiped away.
                      background: Container(
                        color: Colors.deepOrangeAccent,
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            children: const [
                              Icon(Icons.delete, color: Colors.white),
                              Text('Delete as emergency contact',
                                  style: TextStyle(color: Colors.white)),
                            ],
                          ),
                        ),
                      ),
                      // Provide a function that tells the app
                      // what to do after an item has been swiped away.
                      onDismissed: (direction) {
                        homeBloc.add(EventDeleteFavoriteContact(item));
                      },
                      child: Card(
                          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          child: ListTile(
                            leading: const Icon(Icons.account_box, size: 48),
                            title: Text(item.name),
                            subtitle: Text(item.phone),
                          )));
                },
              ),
            )
        ],
      );
    });
  }

  Widget showEmergencyBell() {
    return BlocBuilder<HomeBloc, HomeState>(builder: (context, state) {
      if (state.favoriteContactsDataSource.isNotEmpty) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            InkWell(
              child: const Image(image: AssetImage('assets/help.png')),
              onTap: () {
                // Send SMS
                triggerEmergencySMS(state.favoriteContactsDataSource);
              },
            )
          ],
        );
      } else {
        // Empty widget
        return const SizedBox.shrink();
      }
    });
  }

  Future<void> triggerEmergencySMS(
      List<FavoriteContact> favoriteContacts) async {
    bool permissionsGranted =
        await telephony.requestPhoneAndSmsPermissions ?? false;

    var hasPermissionGranted = await location.hasPermission();

    if (permissionsGranted &&
        hasPermissionGranted == PermissionStatus.granted) {
      var locationData = await location.getLocation();

      final url =
          'https://www.google.com/maps/search/?api=1&query=${locationData.latitude},${locationData.longitude}';

      for (var favoriteContact in favoriteContacts) {
        telephony.sendSms(
            to: favoriteContact.phone,
            message: Strings.messageToSend(favoriteContact.name, url),
            statusListener: onSendStatus);
      }
    }
  }
}
