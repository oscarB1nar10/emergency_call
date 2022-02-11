import 'package:emergency_call/domain/model/FavoriteContact.dart';

class HomeState {
  final List<FavoriteContact> favoriteContactsDataSource;
  final List<FavoriteContact> favoriteContacts;

  HomeState(
      {this.favoriteContactsDataSource = const [],
      this.favoriteContacts = const []});

  @override
  List<Object?> get props => [favoriteContacts, favoriteContactsDataSource];
}
