
class SubscriptionModel {
  final String userId;
  final String subscriptionStatus;

  SubscriptionModel({this.userId = "", this.subscriptionStatus = ""});

  Map<String, String> toJson() => {
        "userId": userId,
        "subscriptionStatus": subscriptionStatus,
      };
}
