import '../data/cache/implementation/ContactsCacheDataSourceImpl.dart';
import '../model/FavoriteContact.dart';

class AddFavoriteContact {
  final ContactsCacheDataSourceImpl _contactsCacheDataSourceImpl =
      ContactsCacheDataSourceImpl();

  Future<void> addFavoriteContact(FavoriteContact contact) async {
    return _contactsCacheDataSourceImpl.addFavoriteContact(contact);
  }
}
