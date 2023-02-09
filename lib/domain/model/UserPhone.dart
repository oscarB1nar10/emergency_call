class UserPhone {
  final String id;
  final String name;

  UserPhone({this.id = "", this.name = ""});

  Map<String, String> toJson() => {
        "id": id,
        "name": name,
      };
}
