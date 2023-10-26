import 'package:emergency_call/domain/data/cache/implementation/ContactsCacheDataSourceImpl.dart';

class DeleteFavoriteContact {
  final ContactsCacheDataSourceImpl _contactsCacheDataSourceImpl =
      ContactsCacheDataSourceImpl();

  Future<dynamic> deleteFavoriteContacts(String phone) async {
    return _contactsCacheDataSourceImpl.deleteFavoriteContact(phone);
  }
}
