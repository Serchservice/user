import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:user/library.dart';

class LocationImplementation implements LocationService {
  final AccessService _accessService = AccessImplementation();

  @override
  Future<void> getAddress({
    required Function(Address address, Position position) onSuccess,
    required Function(String error) onError
  }) async {
    if(await _accessService.hasLocation()) {
      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      try {
        List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
        String place = "";

        String country = placemarks.last.country.toString();
        String state = placemarks.last.administrativeArea.toString();
        String localGovernmentArea = placemarks.last.subAdministrativeArea.toString();
        String city = placemarks.last.locality.toString();
        String streetNumber = placemarks.last.subThoroughfare.toString();
        String streetName = placemarks.reversed.last.thoroughfare.toString();

        place = getPlaceAddress(
          country: country,
          state: state,
          lga: localGovernmentArea,
          city: city,
          streetName: streetName,
          streetNumber: streetNumber
        );

        final address = Address(
          latitude: position.latitude,
          longitude: position.longitude,
          place: place,
          country: country,
          city: city,
          state: state,
          localGovernmentArea: localGovernmentArea,
          streetNumber: streetNumber,
          streetName: streetName
        );
        onSuccess.call(address, position);
        return;
      } catch (e) {
        onError.call("Couldn't find your current location. Check your location settings.");
        return;
      }
    } else {
      onError.call("Location permission needs to be granted.");
      return;
    }
  }

  String getPlaceAddress({
    String country = "", String state = "",
    String lga = "", String city = "",
    String streetNumber = "", String streetName = ""
  }) {
    String newstreetNumber = "";
    if(streetNumber.isNotEmpty) {
      newstreetNumber = "$streetNumber, ";
    }

    String newstreetName = "";
    if(streetName.isNotEmpty) {
      newstreetName = "$streetName, ";
    }

    String newcity = "";
    if(city.isNotEmpty) {
      newcity = "$city, ";
    }

    String newlga = "";
    if(lga.isNotEmpty) {
      newlga = "$lga. ";
    }

    String newstate = "";
    if(state.isNotEmpty) {
      newstate = "$state. ";
    }

    String newcountry = "";
    if(country.isNotEmpty) {
      newcountry = "$country.";
    }

    return "$newstreetNumber$newstreetName$newcity$newlga$newstate$newcountry";
  }
}