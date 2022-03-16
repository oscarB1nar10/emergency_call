import 'package:emergency_call/domain/data/preferences/abstraction/SharedPreferencesDataSource.dart';

import '../data/preferences/implementation/SharedPreferencesDataSourceImpl.dart';

class GetCountry {
  final SharedPreferencesDataSource _sharedPreferencesDataSource =
      SharedPreferencesDataSourceImpl();

  Future getCountryDialCode() {
    return _sharedPreferencesDataSource.getCountryDialCode();
  }
}
