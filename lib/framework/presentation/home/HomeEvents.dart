import 'package:emergency_call/domain/model/FavoriteContact.dart';
import 'package:emergency_call/framework/presentation/utility/Countries.dart';
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

class EventSaveCountryDealCode extends HomeEvents {
  final Country country;

  const EventSaveCountryDealCode(this.country);
}

class EventGetCountryDealCode extends HomeEvents {
  const EventGetCountryDealCode();
}
