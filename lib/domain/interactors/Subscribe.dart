import 'package:emergency_call/domain/data/preferences/abstraction/SharedPreferencesDataSource.dart';
import 'package:emergency_call/domain/data/preferences/implementation/SharedPreferencesDataSourceImpl.dart';
import 'package:emergency_call/domain/data/remote/abstraction/SubscribeRemote.dart';
import 'package:emergency_call/domain/data/remote/implementation/SubscribeRemoteImpl.dart';
import 'package:emergency_call/domain/model/SubscriptionModel.dart';

class Subscribe {
  final SubscribeRemote _subscribePremiumRemote = SubscribeRemoteImpl();
  final SharedPreferencesDataSource _sharedPreferencesDataSource =
      SharedPreferencesDataSourceImpl();

  Future subscribe(SubscriptionModel subscriptionPremiumModel) async {
    var token = await _subscribePremiumRemote
        .subscribeToPremium(subscriptionPremiumModel);
    await _sharedPreferencesDataSource.saveSubscriptionToken(token);

    return token;
  }
}
