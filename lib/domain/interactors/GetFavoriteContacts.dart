import '../data/cache/implementation/ContactsCacheDataSourceImpl.dart';

class GetFavoriteContacts {
  final ContactsCacheDataSourceImpl _contactsCacheDataSourceImpl =
      ContactsCacheDataSourceImpl();

  Future<dynamic> getFavoriteContacts() async {
    return _contactsCacheDataSourceImpl.getFavoriteContacts();
  }
}
