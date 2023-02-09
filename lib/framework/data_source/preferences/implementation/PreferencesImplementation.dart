import 'package:shared_preferences/shared_preferences.dart';

import '../../../presentation/utility/Countries.dart';
import '../../../presentation/utility/SharedPreferencesHelper.dart';
import '../abstraction/Preferences.dart';

class PreferenceImplementation implements Preferences {

  @override
  Future<Country> getCountryDialCode() async {
    final prefs = await SharedPreferences.getInstance();
    final dialCode =
        prefs.getString(SharedPreferencesHelper.countryCodeKey) ?? "";

    final isoCode =
        prefs.getString(SharedPreferencesHelper.countryIsoCodeKey) ?? "";

    return Country(
        isoCode: isoCode, phoneCode: dialCode, name: "", iso3Code: "");
  }

  @override
  Future<bool> saveCountryDialCode(Country country) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
        SharedPreferencesHelper.countryIsoCodeKey, country.isoCode);
    await prefs.setString(SharedPreferencesHelper.countryCodeKey, country.phoneCode);

    return true;
  }

  @override
  Future<void> saveImei(String imei) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(SharedPreferencesHelper.imei, imei);
  }

  @override
  Future<String> getImei() async {
    final prefs = await SharedPreferences.getInstance();
    try {
      final imei = prefs.getString(SharedPreferencesHelper.imei);
      return imei ?? "";
    } catch (e) {
      return "";
    }
  }
}
