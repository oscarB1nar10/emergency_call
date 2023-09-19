
import '../../../model/FavoriteContact.dart';

class ContactsCacheDataSource {
  Future<dynamic> getFavoriteContacts() async {}

  Future<dynamic> deleteFavoriteContact(String phone) async {}

  Future<dynamic> addFavoriteContact(FavoriteContact contact) async {}
}
