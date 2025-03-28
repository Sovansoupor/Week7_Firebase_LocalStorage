import '../../model/location/locations.dart';

abstract class LocationsRepository {
  List<Location> getLocations();
}
