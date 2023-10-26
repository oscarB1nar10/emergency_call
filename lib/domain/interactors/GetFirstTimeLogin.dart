

import '../data/preferences/abstraction/SharedPreferencesDataSource.dart';
import '../data/preferences/implementation/SharedPreferencesDataSourceImpl.dart';

class GetFirstTimeLogin {
  final SharedPreferencesDataSource _sharedPreferencesDataSource =
  SharedPreferencesDataSourceImpl();

  Future getFirstTimeLogin() {
    return _sharedPreferencesDataSource.getFirstTimeLogin();
  }
}