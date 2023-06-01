import 'package:emergency_call/domain/model/FavoriteContact.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../utility/Countries.dart';

class HomeState {
  final List<FavoriteContact> favoriteContactsDataSource;
  final List<FavoriteContact> favoriteContacts;
  final Country country;
  final String imei;
  final UserCredential? userCredentials;

  HomeState(
      {this.favoriteContactsDataSource = const [],
      this.favoriteContacts = const [],
      this.country = const Country(),
      this.imei = "",
      this.userCredentials});

  @override
  List<Object?> get props => [favoriteContacts, favoriteContactsDataSource];
}
