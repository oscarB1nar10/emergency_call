class Strings {
  static const String emergencyCall = "Emergency call";
  static const messageSent = "Message sent";
  static const messageNotSent = "Message not sent";
  static const contacts = "Contacts";

  static String messageToSend(String contactName, String contactNumber) {
    String message =
        'Hello $contactName, this is a emergency from the Emergency Call.\nYou can find to me here: $contactNumber';
    return message;
  }
}
