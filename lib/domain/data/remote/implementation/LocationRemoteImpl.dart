import 'package:emergency_call/domain/data/remote/abstraction/LocationRemote.dart';
import 'package:emergency_call/domain/model/Location.dart';
import 'package:emergency_call/framework/data_source/remote/abstraction/LocationRemoteDataSource.dart';

import '../../../../framework/data_source/remote/implementation/LocationRemoteDataSourceImpl.dart';

class LocationRemoteImpl implements LocationRemote {
  final LocationRemoteDataSource _locationRemoteDataSource =
      LocationRemoteDataSourceImpl();

  @override
  Future saveLocation(UserLocation location) {
    return _locationRemoteDataSource.saveLocation(location);
  }
}
