import 'package:emergency_call/domain/data/remote/abstraction/UserPhoneRemote.dart';
import 'package:emergency_call/domain/data/remote/implementation/UserPhoneRemoteImpl.dart';
import 'package:emergency_call/domain/model/UserPhone.dart';

import '../data/preferences/abstraction/SharedPreferencesDataSource.dart';
import '../data/preferences/implementation/SharedPreferencesDataSourceImpl.dart';

class SaveUserPhone {
  final UserPhoneRemote _userPhoneRemote = UserPhoneRemoteImpl();
  final SharedPreferencesDataSource _sharedPreferencesDataSource =
      SharedPreferencesDataSourceImpl();

  Future saveUserPhone(UserPhone userPhone) async {
    var token = await _userPhoneRemote.saveUserPhone(userPhone);
    if (token != null && token.isNotEmpty) {
      await _sharedPreferencesDataSource.saveSubscriptionToken(token);
    } else {
      await _sharedPreferencesDataSource.saveSubscriptionToken("");
    }
    return token;
  }
}
