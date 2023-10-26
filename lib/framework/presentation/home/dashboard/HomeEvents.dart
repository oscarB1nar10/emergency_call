import 'package:emergency_call/domain/model/FavoriteContact.dart';
import 'package:emergency_call/domain/model/UserPhone.dart';
import 'package:emergency_call/framework/presentation/utility/Countries.dart';
import 'package:equatable/equatable.dart';

import '../../../../domain/model/Location.dart';

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

class EventSaveLocation extends HomeEvents {
  final UserLocation location;

  const EventSaveLocation(this.location);
}

class EventSaveUserPhone extends HomeEvents {
  final UserPhone userPhone;

  const EventSaveUserPhone(this.userPhone);
}

class EventSaveImei extends HomeEvents {
  final String imei;

  const EventSaveImei(this.imei);
}

class EventGetImei extends HomeEvents {
  const EventGetImei();
}

class EventGetUserCredentials extends HomeEvents {
  const EventGetUserCredentials();
}

class EventGetSubscriptionToken extends HomeEvents {
  const EventGetSubscriptionToken();
}

class EventUpdateSaveUserPhone extends HomeEvents {}

class EventUpdateShownContactInfo extends HomeEvents {}

class EventUpdateShownEmergencyBell extends HomeEvents {}

class EventSaveFirstTimeLogin extends HomeEvents {
  const EventSaveFirstTimeLogin();
}

class EventShowSnackbarError extends HomeEvents {
  final String errorMessage;
  const EventShowSnackbarError(this.errorMessage);
}
