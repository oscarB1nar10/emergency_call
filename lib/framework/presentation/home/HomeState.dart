import 'package:emergency_call/domain/model/FavoriteContact.dart';

import '../utility/Countries.dart';

class HomeState {
  final List<FavoriteContact> favoriteContactsDataSource;
  final List<FavoriteContact> favoriteContacts;
  final Country country;

  HomeState(
      {this.favoriteContactsDataSource = const [],
      this.favoriteContacts = const [],
      this.country = const Country()});

  @override
  List<Object?> get props => [favoriteContacts, favoriteContactsDataSource];
}
