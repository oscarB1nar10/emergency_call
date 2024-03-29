class UserLocation {
  final int id;
  final String token;
  final String userPhoneId;
  final double latitude;
  final double longitude;

  UserLocation(
      {this.id = 0,
      this.token = "",
      this.userPhoneId = "",
      this.latitude = 0.0,
      this.longitude = 0.0});

  Map<String, String> toJson() => {
        "id": "$id",
        "token": token,
        "userPhoneId": userPhoneId,
        "latitude": "$latitude",
        "longitude": "$longitude",
      };
}
