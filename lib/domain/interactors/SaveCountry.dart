import 'package:emergency_call/domain/data/preferences/abstraction/SharedPreferencesDataSource.dart';
import 'package:emergency_call/framework/presentation/utility/Countries.dart';

import '../data/preferences/implementation/SharedPreferencesDataSourceImpl.dart';

class SaveCountry {
  final SharedPreferencesDataSource _sharedPreferencesDataSource =
      SharedPreferencesDataSourceImpl();

  Future<void> saveCountryDialCode(Country country) async {
    _sharedPreferencesDataSource.saveCountry(country);
  }
}
