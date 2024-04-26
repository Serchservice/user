import 'package:geolocator/geolocator.dart';
import 'package:user/library.dart';

abstract class LocationService {
  /// Get current address of the user
  Future<void> getAddress({
    required Function(Address address, Position position) onSuccess,
    required Function(String error) onError,
  });
}