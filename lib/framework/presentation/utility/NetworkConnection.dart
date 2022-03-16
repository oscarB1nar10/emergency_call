import 'dart:io';

class NetworkConnection {

  static Future<bool> isConnectedToInternet() async {
    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        // Connected
        return true;
      }
    } on SocketException catch (_) {
      print('not connected');
    }
    return false;
  }
}
