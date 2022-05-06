import 'package:emergency_call/domain/data/remote/abstraction/LocationRemote.dart';
import 'package:emergency_call/domain/data/remote/implementation/LocationRemoteImpl.dart';

import '../model/Location.dart';

class SaveLocation {
  final LocationRemote _locationRemote = LocationRemoteImpl();

  Future saveLocation(UserLocation location) {
    return _locationRemote.saveLocation(location);
  }
}
