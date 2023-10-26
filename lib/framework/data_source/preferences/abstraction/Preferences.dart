
import '../../../presentation/utility/Countries.dart';

class Preferences {
  Future<dynamic> getCountryDialCode() async {}

  Future<dynamic> saveCountryDialCode(Country country) async {}
  Future<void> saveImei(String imei) async {}
  Future<dynamic> getImei() async {}
  Future<void> saveUserId(String id) async {}
  Future<dynamic> getUserId() async {}
  Future<void> saveSubscriptionToken(String token) async {}
  Future<dynamic> getSubscriptionToken() async {}
  Future<void> saveFirstTimeLogin(bool isFirstTimeLogin) async {}
  Future<dynamic> getFirstTimeLogin() async {}
}
