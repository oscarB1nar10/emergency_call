

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
  Future<void> saveCountry(Country country) async {
    _preferences.saveCountryDialCode(country);
  }

  @override
  Future<void> saveImei(String imei) async {
    _preferences.saveImei(imei);
  }

  @override
  Future<dynamic> getImei() async {
    return _preferences.getImei();
  }

}
