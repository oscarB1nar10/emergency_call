import 'package:emergency_call/domain/data/remote/abstraction/UserPhoneRemote.dart';
import 'package:emergency_call/domain/data/remote/implementation/UserPhoneRemoteImpl.dart';
import 'package:emergency_call/domain/model/UserPhone.dart';

class SaveUserPhone {
  final UserPhoneRemote _userPhoneRemote = UserPhoneRemoteImpl();

  Future saveUserPhone(UserPhone userPhone) {
    return _userPhoneRemote.saveUserPhone(userPhone);
  }
}
