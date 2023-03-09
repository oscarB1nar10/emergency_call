import 'dart:async';

import 'package:emergency_call/domain/model/FavoriteContact.dart';
import 'package:emergency_call/domain/model/UserPhone.dart';
import 'package:emergency_call/framework/presentation/home/ContactsPageWidget.dart';
import 'package:emergency_call/framework/presentation/home/DrawerListWidget.dart';
import 'package:emergency_call/framework/presentation/home/HomeBloc.dart';
import 'package:emergency_call/framework/presentation/home/HomeEvents.dart';
import 'package:emergency_call/framework/presentation/model/PersonalContact.dart';
import 'package:emergency_call/framework/presentation/utility/Countries.dart';
import 'package:emergency_call/framework/presentation/utility/NetworkConnection.dart';
import 'package:emergency_call/framework/presentation/utility/Strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_foreground_service/flutter_foreground_service.dart';
import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart' as permissions;
import 'package:telephony/telephony.dart';
import 'package:unique_identifier/unique_identifier.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:whatsapp_unilink/whatsapp_unilink.dart';

import 'CountryIconWidget.dart';
import 'HomeState.dart';
import 'LocationWidget.dart';

class HomeScreenWidget extends StatefulWidget {
  const HomeScreenWidget({Key? key}) : super(key: key);

  @override
  _HomeScreenWidget createState() => _HomeScreenWidget();
}

class _HomeScreenWidget extends State<HomeScreenWidget> {
  late HomeBloc homeBloc;
  var personalContact = const PersonalContact();
  final telephony = Telephony.instance;
  final location = Location.instance;
  var showCountryCodeList = false;
  var imei = "";
  late StreamSubscription<dynamic> _streamSubscription;

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
  void initState() {
    super.initState();
    homeBloc = BlocProvider.of<HomeBloc>(context, listen: false);
    _onSendImei();
    _onGetUserCredentials();
    _onGetCountryDial();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(Strings.emergencyCall),
        automaticallyImplyLeading: true,
        actions: const <Widget>[CountryIconWidget(), LocationWidget()],
        centerTitle: true,
      ),
      body: SingleChildScrollView(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [showContactInfo(), showEmergencyBell()])),
      drawer: const Drawer(
        child: DrawerListWidget(),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          requestContactPermissions(context);
        },
        backgroundColor: Colors.red,
      ),
    );
  }

  Future<void> requestContactPermissions(BuildContext context) async {
    var statusContactsPermission =
        await permissions.Permission.contacts.request();
    var statusLocationPermission =
        await permissions.Permission.location.request();

    if (statusContactsPermission.isGranted) {
      _navigateContactsPage(context);
    } else if (statusContactsPermission ==
        permissions.PermissionStatus.denied) {
      // TODO("Handle negation of permissions through an explanation")
    } else if (statusContactsPermission ==
        permissions.PermissionStatus.permanentlyDenied) {
      // TODO("Handle negation of permissions through an explanation")
    }

    // Location permissions
    if (statusLocationPermission.isGranted) {
      // TODO("Handle negation of permissions through an explanation")
    } else if (statusLocationPermission.isDenied) {}
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

      // Save contact in localDB
      homeBloc.add(EventAddFavoriteContact(
          personalContact.fromPersonalToFavoriteContact()));
    });
  }

  Widget showContactInfo() {
    // Launch event to retrieve saved favorite contacts.
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
                      key: UniqueKey(),
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
                          margin: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
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
            Stack(
              children: [
                const Image(image: AssetImage('assets/help.png')),
                Positioned.fill(
                    child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      // Send SMS
                      triggerEmergencySMS(state.favoriteContactsDataSource);
                    },
                  ),
                ))
              ],
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

      final url = Strings.getMapLocationUrl(locationData);

      // Check internet connection to determine if send emergency message through
      // WhatsApp or Sms
      bool isConnectedToInternet =
          await NetworkConnection.isConnectedToInternet();
      if (isConnectedToInternet == true) {
        openWhatsApp(favoriteContacts, url);
      } else {
        // I am not connected
        sendSms(favoriteContacts, url);
      }
    }
  }

  sendSms(List<FavoriteContact> favoriteContacts, String emergencyMessage) {
    for (var favoriteContact in favoriteContacts) {
      telephony.sendSms(
          to: favoriteContact.phone,
          message:
              Strings.messageToSend(favoriteContact.name, emergencyMessage),
          statusListener: onSendStatus);
    }
  }

  openWhatsApp(
      List<FavoriteContact> favoriteContacts, String emergencyMessage) async {
    for (var favoriteContact in favoriteContacts) {
      // Remove +countryDialCode if exist
      Country country = homeBloc.state.country;
      var phoneCode = "";
      if (country.phoneCode.isEmpty) {
        phoneCode = Strings.countryDialCode;
      } else {
        phoneCode = country.phoneCode;
      }
      var number =
          CountryHelper.phoneNumberWithoutCountryCode(favoriteContact.phone);

      final link = WhatsAppUnilink(
        phoneNumber: '$phoneCode-$number',
        text: Strings.getEmergencyDefaultMessage(
            favoriteContact.name, emergencyMessage),
      );

      await launch('$link');
    }
  }

  _onSendImei() async {
    var serialImei = await UniqueIdentifier.serial;
    setState(() {
      imei = serialImei ?? "";
    });
    homeBloc.add(EventSaveImei(imei));
  }

  _onGetUserCredentials() async {
    // Get user credentials from Google account
    homeBloc.add(const EventGetUserCredentials());
    homeBloc.stream.listen((state) {
      if (state.userCredentials != null) {
        // Save UserPhone in server
        homeBloc.add(EventSaveUserPhone(UserPhone(
            id: state.userCredentials?.user?.uid ?? "",
            imei: imei ?? "",
            name: "")));
      }
    });
  }

  _onGetCountryDial() {
    // Launch event to get the country dial code.
    homeBloc.add(const EventGetCountryDealCode());
  }

  @override
  void dispose() {
    super.dispose();
    ForegroundService().stop();
    _streamSubscription.cancel();
  }
}
