import 'package:emergency_call/domain/data/preferences/abstraction/SharedPreferencesDataSource.dart';
import 'package:emergency_call/domain/data/preferences/implementation/SharedPreferencesDataSourceImpl.dart';

class GetUserId {
  final SharedPreferencesDataSource _sharedPreferencesDataSource =
      SharedPreferencesDataSourceImpl();

  Future getUserId() {
    return _sharedPreferencesDataSource.getUserId();
  }
}
