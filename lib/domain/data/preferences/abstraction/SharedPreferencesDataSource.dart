

import '../../../../framework/presentation/utility/Countries.dart';

class SharedPreferencesDataSource {

  Future<dynamic> getCountryDialCode() async {}

  Future<dynamic> saveCountry(Country country) async {}
  Future<void> saveImei(String imei) async {}
  Future<dynamic> getImei() async {}
  Future<void> saveUserId(String id) async {}
  Future<dynamic> getUserId() async {}
  Future<void> saveSubscriptionToken(String token) async {}
  Future<dynamic> getSubscriptionToken() async {}
}