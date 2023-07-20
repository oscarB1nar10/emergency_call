import 'package:emergency_call/domain/data/preferences/abstraction/SharedPreferencesDataSource.dart';
import 'package:emergency_call/framework/data_source/preferences/abstraction/Preferences.dart';

import '../../../../framework/data_source/preferences/implementation/PreferencesImplementation.dart';
import '../../../../framework/presentation/utility/Countries.dart';

class SharedPreferencesDataSourceImpl implements SharedPreferencesDataSource {
  final Preferences _preferences = PreferenceImplementation();

  @override
  Future getCountryDialCode() {
    return _preferences.getCountryDialCode();
  }

  @override
  Future<dynamic> saveCountry(Country country) async {
    return _preferences.saveCountryDialCode(country);
  }

  @override
  Future<void> saveImei(String imei) async {
    _preferences.saveImei(imei);
  }

  @override
  Future<dynamic> getImei() async {
    return _preferences.getImei();
  }

  @override
  Future<void> saveSubscriptionToken(String token) async {
    _preferences.saveSubscriptionToken(token);
  }

  @override
  Future getSubscriptionToken() async {
    return _preferences.getSubscriptionToken();
  }

  @override
  Future<void> saveUserId(String id) async {
    _preferences.saveUserId(id);
  }

  @override
  Future<dynamic> getUserId() async {
    return _preferences.getUserId();
  }
}
