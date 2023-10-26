import 'package:equatable/equatable.dart';

import '../../../../domain/model/Location.dart';


abstract class LocationEvents extends Equatable {
  const LocationEvents();

  @override
  List<Object> get props => [];
}

class EventGetUserCredentials extends LocationEvents {
  const EventGetUserCredentials();
}

class EventGetSubscriptionToken extends LocationEvents {
  const EventGetSubscriptionToken();
}

class EventSaveLocation extends LocationEvents {
  final UserLocation location;

  const EventSaveLocation(this.location);
}

class EventUpdateDisplaySubsDialog extends LocationEvents {}
