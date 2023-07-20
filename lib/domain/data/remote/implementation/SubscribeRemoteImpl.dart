import 'package:emergency_call/domain/model/SubscriptionModel.dart';
import 'package:emergency_call/framework/data_source/remote/implementation/SubscribeRemoteDataSourceImpl.dart';

import '../../../../framework/data_source/remote/abstraction/SubscribeRemoteDataSource.dart';
import '../abstraction/SubscribeRemote.dart';

class SubscribeRemoteImpl implements SubscribeRemote {
  final SubscribeRemoteDataSource _subscribePremiumRemoteDataSourceImpl =
      SubscribeRemoteDataSourceImpl();

  @override
  Future subscribeToPremium(SubscriptionModel subscriptionPremiumModel) {
    return _subscribePremiumRemoteDataSourceImpl
        .subscribeToPremium(subscriptionPremiumModel);
  }
}
