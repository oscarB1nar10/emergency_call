import 'package:emergency_call/domain/model/FavoriteContact.dart';

class ContactsCache {
  Future<dynamic> getFavoriteContacts() async {}

  Future<dynamic> deleteFavoriteContact(String phone) async {}

  Future<dynamic> addFavoriteContact(FavoriteContact contact) async {}
}
