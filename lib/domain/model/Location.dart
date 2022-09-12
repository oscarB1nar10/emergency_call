class UserLocation {
  final int id;
  final String userPhoneId;
  final double latitude;
  final double longitude;

  UserLocation(
      {this.id = 0,
      this.userPhoneId = "",
      this.latitude = 0.0,
      this.longitude = 0.0});
}
