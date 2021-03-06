import 'package:shared_preferences/shared_preferences.dart';

import '../../../presentation/utility/Countries.dart';
import '../../../presentation/utility/SharedPreferencesHelper.dart';
import '../abstraction/Preferences.dart';

class PreferenceImplementation implements Preferences {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  @override
  Future<Country> getCountryDialCode() async {
    final _dialCode = await _prefs.then((SharedPreferences prefs) {
      return prefs.getString(SharedPreferencesHelper.countryCodeKey) ?? "";
    });

    final _isoCode = await _prefs.then((SharedPreferences prefs) {
      return prefs.getString(SharedPreferencesHelper.countryIsoCodeKey) ?? "";
    });

    return Country(
        isoCode: _isoCode, phoneCode: _dialCode, name: "", iso3Code: "");
  }

  @override
  Future<void> saveCountryDialCode(Country country) async {
    final SharedPreferences prefs = await _prefs;
    prefs.setString(SharedPreferencesHelper.countryIsoCodeKey, country.isoCode);
    prefs.setString(SharedPreferencesHelper.countryCodeKey, country.phoneCode);
  }
}
