import 'package:emergency_call/framework/data_source/remote/abstraction/SignInDataSource.dart';
import 'package:emergency_call/framework/data_source/remote/implementation/SignInDataSourceImpl.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../data/preferences/abstraction/SharedPreferencesDataSource.dart';
import '../data/preferences/implementation/SharedPreferencesDataSourceImpl.dart';

class GetUserCredentials {
  final SignInDataSource _signInDataSource = SignInDataSourceImpl();
  final SharedPreferencesDataSource _sharedPreferencesDataSource =
  SharedPreferencesDataSourceImpl();

  Future getUserCredentials() async {
    UserCredential userCredentials = await _signInDataSource.signInWithGoogle();
    await _sharedPreferencesDataSource.saveUserId(userCredentials.user?.uid ?? "");
    return userCredentials;
  }
}
