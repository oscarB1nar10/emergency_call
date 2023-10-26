class UserPhone {
  final String id;
  final String imei;
  final String name;

  UserPhone({this.id = "", this.imei = "", this.name = ""});

  Map<String, String> toJson() => {
        "id": id,
        "imei": imei,
        "name": name,
      };
}
