import 'package:location/location.dart';

class Strings {
  static const String emergencyCall = "Emergency call";
  static const messageSent = "Message sent";
  static const messageNotSent = "Message not sent";
  static const contacts = "Contacts";
  static const countryPicker = "Country picker";
  static const mapLocationUrl = "https://www.google.com/maps/search/?api=1&query=";
  static const countryDialCode = "+57";
  static const isoCode = "CO";
  static const privacyPolicyUrl = "https://oscarivanramtin.wixsite.com/emergencycall/about-1";

  static String messageToSend(String contactName, String contactNumber) {
    String message =
        'Hello $contactName, this is a emergency from the Emergency Call.\nYou can find to me here: $contactNumber';
    return message;
  }

  static String getMapLocationUrl(LocationData location) {
    return "$mapLocationUrl${location.latitude},${location.longitude}";
  }

  static String getEmergencyDefaultMessage(contactName, urlLocation) {
    return "Hey! $contactName I need your help, this is my location: $urlLocation";
  }
}
