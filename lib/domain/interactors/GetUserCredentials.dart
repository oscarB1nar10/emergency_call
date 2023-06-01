import 'package:emergency_call/framework/data_source/remote/abstraction/SignInDataSource.dart';
import 'package:emergency_call/framework/data_source/remote/implementation/SignInDataSourceImpl.dart';

class GetUserCredentials {
  final SignInDataSource _signInDataSource = SignInDataSourceImpl();

  Future getUserCredentials() {
    return _signInDataSource.signInWithGoogle();
  }
}
