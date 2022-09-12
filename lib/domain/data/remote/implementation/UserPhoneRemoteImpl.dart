import 'package:emergency_call/domain/data/remote/abstraction/UserPhoneRemote.dart';
import 'package:emergency_call/domain/model/UserPhone.dart';
import 'package:emergency_call/framework/data_source/remote/abstraction/UserPhoneRemoteDataSource.dart';
import 'package:emergency_call/framework/data_source/remote/implementation/UserPhoneRemoteDataSourceImpl.dart';

class UserPhoneRemoteImpl implements UserPhoneRemote{
  final UserPhoneRemoteDataSource _userPhoneRemoteDataSource =
      UserPhoneRemoteDataSourceImpl();

  @override
  Future saveUserPhone(UserPhone userPhone) {
    return _userPhoneRemoteDataSource.saveUserPhone(userPhone);
  }
}
