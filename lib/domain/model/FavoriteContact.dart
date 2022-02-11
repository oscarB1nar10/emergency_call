class FavoriteContact {
  final int id;
  final String name;
  final String phone;

  FavoriteContact({this.id = 0, this.name = '', this.phone = ''});

  //FavoriteContact({required this.id, required this.name, required this.phone});

  // Convert a FavoriteContact into a Map. The keys must correspond to the names of the
  // columns in the database.
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'phone': phone,
    };
  }

  // Implement toString to make it easier to see information about
  // each FavoriteContact when using the print statement.
  @override
  String toString() {
    return 'FavoriteContact{id: $id, name: $name, phone: $phone}';
  }
}
