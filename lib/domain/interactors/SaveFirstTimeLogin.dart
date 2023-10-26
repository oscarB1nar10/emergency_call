import '../data/preferences/abstraction/SharedPreferencesDataSource.dart';
import '../data/preferences/implementation/SharedPreferencesDataSourceImpl.dart';

class SaveFirstTimeLogin {
  final SharedPreferencesDataSource _sharedPreferencesDataSource =
      SharedPreferencesDataSourceImpl();

  Future saveFirstTimeLogin(bool isFirstTimeLogin) {
    return _sharedPreferencesDataSource.saveFirstTimeLogin(isFirstTimeLogin);
  }
}
