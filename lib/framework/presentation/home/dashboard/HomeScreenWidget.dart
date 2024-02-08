import 'dart:async';

import 'package:emergency_call/domain/model/FavoriteContact.dart';
import 'package:emergency_call/framework/presentation/home/ContactsPageWidget.dart';
import 'package:emergency_call/framework/presentation/home/DrawerListWidget.dart';
import 'package:emergency_call/framework/presentation/home/ErrorBanner.dart';
import 'package:emergency_call/framework/presentation/home/dashboard/HomeBloc.dart';
import 'package:emergency_call/framework/presentation/model/PersonalContact.dart';
import 'package:emergency_call/framework/presentation/utility/Countries.dart';
import 'package:emergency_call/framework/presentation/utility/NetworkConnection.dart';
import 'package:emergency_call/framework/presentation/utility/Strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_foreground_service/flutter_foreground_service.dart';
import 'package:flutter_intro/flutter_intro.dart';
import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart' as permissions;
import 'package:telephony/telephony.dart';
import 'package:unique_identifier/unique_identifier.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../utility/ErrorMessages.dart';
import '../country/CountryIconWidget.dart';
import '../location/LocationWidget.dart';
import 'HomeEvents.dart';
import 'HomeState.dart';

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
  var isFirstTimeLogin = false;
  bool isBlocLoading = false;
  bool showErrorBanner = false;
  String errorMessage = "";
  StreamSubscription<dynamic>? _streamSubscription;
  StreamSubscription<dynamic>? _errorSubscription;

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
    _onGetContactInfo();
    _onSendImei();
    _onGetUserCredentials();
    _onGetCountryDial();
    _onCheckIfFirstTimeLogin();
    _eventListener();
    _errorListener();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(Strings.emergencyCall),
        automaticallyImplyLeading: true,
        actions: <Widget>[const CountryIconWidget(), _introLocationWidget()],
        centerTitle: true,
      ),
      body: Stack(children: [
        Center(
          child: ConstrainedBox(
            constraints:
                BoxConstraints(minHeight: MediaQuery.of(context).size.height),
            child: SingleChildScrollView(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                  showContactInfo(homeBloc.state),
                  showEmergencyBell(homeBloc.state)
                ])),
          ),
        ),
        if (showErrorBanner) ErrorBanner(message: errorMessage),
        if (isBlocLoading) _buildProgressIndicator()
      ]),
      drawer: const Drawer(
        child: DrawerListWidget(),
      ),
      floatingActionButton: _introAddContacts(),
    );
  }

  Widget _introLocationWidget() {
    return IntroStepBuilder(
      order: 1,
      text: 'Tap here to start tracking your device location',
      padding: const EdgeInsets.symmetric(
        vertical: -5,
        horizontal: -5,
      ),
      borderRadius: const BorderRadius.all(Radius.circular(64)),
      //builder: (context, key) => LocationWidget(key: key),

      builder: (context, key) => GestureDetector(
        key: key,
        child: const LocationWidget(),
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return Positioned.fill(
      child: Container(
        color: Colors.black38, // semi-transparent overlay
        child: const Center(
          child:
              CircularProgressIndicator(), // progress indicator in the center
        ),
      ),
    );
  }

  Widget _introAddContacts() {
    return IntroStepBuilder(
      order: 2,
      text: 'Tap here to Add favorite contacts',
      padding: const EdgeInsets.symmetric(
        vertical: -5,
        horizontal: -5,
      ),
      borderRadius: const BorderRadius.all(Radius.circular(64)),
      builder: (context, key) => FloatingActionButton(
        key: key,
        onPressed: () {
          requestContactPermissions(context);
        },
        backgroundColor: Colors.red,
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> requestContactPermissions(BuildContext context) async {
    var statusContactsPermission =
        await permissions.Permission.contacts.request();
    var statusLocationPermission =
        await permissions.Permission.location.request();

    if (statusContactsPermission.isGranted) {
      _navigateContactsPage();
    } else if (statusContactsPermission ==
            permissions.PermissionStatus.denied ||
        statusContactsPermission ==
            permissions.PermissionStatus.permanentlyDenied) {
      _showPermissionExplanationDialog('Contacts');
    }

    // Location permissions
    if (statusLocationPermission.isGranted) {
      // TODO("Handle negation of permissions through an explanation")
    } else if (statusLocationPermission.isDenied) {
      _showPermissionExplanationDialog('Location');
    }
  }

  void _showPermissionExplanationDialog(String permissionName) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('$permissionName Permission Denied'),
          content: Text(
              'The $permissionName permission is required for this feature to work. Please grant the permission for a better experience.'),
          actions: [
            TextButton(
              child: const Text('Later'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Open Settings'),
              onPressed: () {
                // Redirect to app settings
                permissions.openAppSettings();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  // A method that launches the SelectionScreen and awaits the result from
// Navigator.pop.
  void _navigateContactsPage() async {
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

      // Construct the message including the Google Maps URL
      String message = Strings.getEmergencyDefaultMessage(
          favoriteContact.name, emergencyMessage);

      // Encode the entire message
      String encodedMessage = Uri.encodeComponent(message);

      // Construct the WhatsApp URL
      String whatsappURLAndroid =
          "whatsapp://send?phone=$phoneCode$number&text=$encodedMessage";

      if (await canLaunchUrl(Uri.parse(whatsappURLAndroid))) {
        await launchUrl(Uri.parse(whatsappURLAndroid));
      }
    }
  }

  _onGetContactInfo() {
    // Launch event to retrieve saved favorite contacts.
    homeBloc.add(const EventGetFavoriteContact());
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
  }

  _eventListener() {
    _streamSubscription?.cancel(); // Cancel any existing subscription

    _streamSubscription ??= homeBloc.stream.listen((state) {
      if (state.favoriteContacts.isNotEmpty && !state.hasShownContactInfo) {
        showContactInfo(homeBloc.state);
        homeBloc.add(EventUpdateShownContactInfo());
      }

      if (state.favoriteContacts.isNotEmpty && !state.hasShownEmergencyBell) {
        showEmergencyBell(homeBloc.state);
        homeBloc.add(EventUpdateShownEmergencyBell());
      }

      if (state.userCredentials != null &&
          (state.hasSavedUserPhone ||
              state.errorMessage == ErrorMessages.savePhoneError) &&
          state.isFirstTimeLogin) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Intro.of(context).start();
        });
      }

      setState(() {
        isFirstTimeLogin = state.isFirstTimeLogin;
        isBlocLoading = state.isLoading;
      });
    });
  }

  _errorListener() {
    _errorSubscription?.cancel(); // Cancel any existing subscription
    _errorSubscription = homeBloc.stream.listen((state) {
      if (state.errorMessage.isNotEmpty) {
        _showErrorBanner(state.errorMessage);
      }
    });
  }

  Widget showContactInfo(HomeState state) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        if (state.favoriteContacts.isNotEmpty)
          Center(
            child: ListView.builder(
              shrinkWrap: true,
              // Let the ListView know how many items it needs to build.
              itemCount: state.favoriteContacts.length,
              // Provide a builder function. This is where the magic happens.
              // Convert each item into a widget based on the type of item it is.
              itemBuilder: (context, index) {
                final item = state.favoriteContacts[index];

                return Dismissible(
                    key: UniqueKey(),
                    // Show a red background as the item is swiped away.
                    background: Container(
                      color: Colors.deepOrangeAccent,
                      child: const Padding(
                        padding: EdgeInsets.all(16),
                        child: Row(
                          children: [
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
  }

  Widget showEmergencyBell(HomeState state) {
    if (state.favoriteContacts.isNotEmpty) {
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
                    triggerEmergencySMS(state.favoriteContacts);
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

  _onGetCountryDial() {
    // Launch event to get the country dial code.
    homeBloc.add(const EventGetCountryDealCode());
  }

  _onCheckIfFirstTimeLogin() {
    homeBloc.add(const EventSaveFirstTimeLogin());
  }

  void _showErrorBanner(String errorMessage) {
    setState(() {
      showErrorBanner = true;
      this.errorMessage = errorMessage;
    });

    Future.delayed(const Duration(seconds: 5), () {
      if (mounted) {
        // Check if the widget is still active
        setState(() {
          showErrorBanner = false;
        });
      }
    });
  }

  @override
  void dispose() {
    ForegroundService().stop();
    _streamSubscription?.cancel();
    _errorSubscription?.cancel();
    super.dispose();
  }
}
