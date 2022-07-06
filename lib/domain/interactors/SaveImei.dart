

import 'package:emergency_call/domain/data/preferences/abstraction/SharedPreferencesDataSource.dart';
import 'package:emergency_call/domain/data/preferences/implementation/SharedPreferencesDataSourceImpl.dart';


class SaveImei {
  final SharedPreferencesDataSource _sharedPreferencesDataSource =
  SharedPreferencesDataSourceImpl();

  Future saveImei(String imei) {
    return _sharedPreferencesDataSource.saveImei(imei);
  }
}