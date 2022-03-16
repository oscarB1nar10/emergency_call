
import 'package:emergency_call/domain/data/cache/abstraction/ContactsCacheDataSource.dart';
import 'package:emergency_call/domain/model/FavoriteContact.dart';

import '../../../../framework/data_source/cache/implementation/ContactsCacheImplementation.dart';

class ContactsCacheDataSourceImpl implements ContactsCacheDataSource {
  final ContactsCacheImplementation _contactsCacheImplementation =
      ContactsCacheImplementation();

  @override
  Future addFavoriteContact(FavoriteContact contact) {
    return _contactsCacheImplementation.addFavoriteContact(contact);
  }

  @override
  Future getFavoriteContacts() {
    return _contactsCacheImplementation.getFavoriteContacts();
  }

  @override
  Future deleteFavoriteContact(int id) {
    return _contactsCacheImplementation.deleteFavoriteContact(id);
  }
}
