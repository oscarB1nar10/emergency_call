import 'package:emergency_call/domain/data/cache/implementation/ContactsCacheDataSourceImpl.dart';

class DeleteFavoriteContact {
  final ContactsCacheDataSourceImpl _contactsCacheDataSourceImpl =
      ContactsCacheDataSourceImpl();

  Future<dynamic> deleteFavoriteContacts(int id) async {
    return _contactsCacheDataSourceImpl.deleteFavoriteContact(id);
  }
}
