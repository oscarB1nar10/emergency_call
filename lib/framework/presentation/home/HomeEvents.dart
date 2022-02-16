import 'package:emergency_call/domain/model/FavoriteContact.dart';
import 'package:equatable/equatable.dart';

abstract class HomeEvents extends Equatable {
  const HomeEvents();

  @override
  List<Object> get props => [];
}

class EventAddFavoriteContact extends HomeEvents {
  final FavoriteContact favoriteContact;

  const EventAddFavoriteContact(this.favoriteContact);

  @override
  List<Object> get props => [favoriteContact];

  @override
  String toString() =>
      'AddFavoriteContact { favoriteContact: $favoriteContact}';
}

class EventGetFavoriteContact extends HomeEvents {
  const EventGetFavoriteContact();
}

class EventDeleteFavoriteContact extends HomeEvents {
  final FavoriteContact favoriteContact;

  const EventDeleteFavoriteContact(this.favoriteContact);
}
