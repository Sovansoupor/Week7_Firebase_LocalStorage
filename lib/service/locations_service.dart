import '../model/location/locations.dart';
import '../repository/locations_repository.dart';

/// The location service is in charge of retrieving the list of locations
class LocationsService {
  // Static private instance
  static LocationsService? _instance;

  // Repository
  final LocationsRepository repository;

  /// Private constructor
  LocationsService._internal(this.repository);

  /// Initialize
  static void initialize(LocationsRepository repository) {
    if (_instance == null) {
      _instance = LocationsService._internal(repository);
    } else {
      throw Exception("Location Service is already initialized.");
    }
  }

  /// Singleton accessor
  static LocationsService get instance {
    if (_instance == null) {
      throw Exception(
          "Location service is not initialized. Call initialize() first.");
    }
    return _instance!;
  }

  List<Location> getLocations() {
    return repository.getLocations();
  }

  List<Location> getLocationsFor(String text) {
    return repository
        .getLocations()
        .where((location) =>
            location.name.toUpperCase().contains(text.toUpperCase()))
        .toList();
  }
}
