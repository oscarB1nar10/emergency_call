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
    await prefs.setString(
        SharedPreferencesHelper.countryCodeKey, country.phoneCode);

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

  @override
  Future<void> saveSubscriptionToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(SharedPreferencesHelper.subscriptionToken, token);
  }

  @override
  Future getSubscriptionToken() async {
    final prefs = await SharedPreferences.getInstance();
    try {
      final subscriptionToken =
          prefs.getString(SharedPreferencesHelper.subscriptionToken);
      return subscriptionToken ?? "";
    } catch (e) {
      return "";
    }
  }

  @override
  Future<void> saveUserId(String id) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(SharedPreferencesHelper.userId, id);
  }

  @override
  Future getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    try {
      final userId = prefs.getString(SharedPreferencesHelper.userId);
      return userId ?? "";
    } catch (e) {
      return "";
    }
  }

  @override
  Future<void> saveFirstTimeLogin(bool isFirstTimeLogin) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(SharedPreferencesHelper.firstTimeLogin, isFirstTimeLogin);
  }

  @override
  Future getFirstTimeLogin() async {
    final prefs = await SharedPreferences.getInstance();
    try {
      final isFirstTimeLogin =
          prefs.getBool(SharedPreferencesHelper.firstTimeLogin);
      return isFirstTimeLogin ?? false;
    } catch (e) {
      return false;
    }
  }
}
