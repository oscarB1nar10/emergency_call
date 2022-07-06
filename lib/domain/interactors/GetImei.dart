import 'package:emergency_call/domain/data/preferences/abstraction/SharedPreferencesDataSource.dart';
import 'package:emergency_call/domain/data/preferences/implementation/SharedPreferencesDataSourceImpl.dart';

class GetImei {
  final SharedPreferencesDataSource _sharedPreferencesDataSource =
      SharedPreferencesDataSourceImpl();

  Future getImei() {
    return _sharedPreferencesDataSource.getImei();
  }
}
