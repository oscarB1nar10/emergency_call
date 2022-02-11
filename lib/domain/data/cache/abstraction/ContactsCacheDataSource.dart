
import '../../../model/FavoriteContact.dart';

class ContactsCacheDataSource {
  Future<dynamic> getFavoriteContacts() async {}

  Future<dynamic> removeFavoriteContact(int id) async {}

  Future<dynamic> addFavoriteContact(FavoriteContact contact) async {}
}
