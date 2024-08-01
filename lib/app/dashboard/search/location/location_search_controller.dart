import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:user/library.dart';

class LocationSearchController extends GetxController {
  LocationSearchController();
  final state = LocationSearchState();

  final LocationService _locationService = LocationImplementation();
  final ConnectService _connect = Connect(useToken: false);
  
  final TextEditingController locationController = TextEditingController();

  @override
  void onReady() {
    locationController.addListener(() {
      if(locationController.text.isNotEmpty) {
        searchLocation();
      }
    });
    super.onReady();
  }

  @override
  void onClose() {
    locationController.dispose();
    super.onClose();
  }

  void searchLocation() async {
    state.isSearching.value = true;
    
    ApiResponse response = await _connect.get(endpoint: "/location/search?q=${locationController.text.trim()}");

    state.isSearching.value = false;
    if(response.isSuccessful) {
      List<dynamic> result = response.data;
      state.locations.value = result.map((location) => Address.fromJson(location)).toList();
    }
  }

  void pick(Function(Address) onPick, Address address) {
    onPick.call(address);
    Navigate.back();
  }

  void searchCurrentLocation(Function(Address) onSuccess) {
    state.isLocationSearching.value = true;
    _locationService.getAddress(
      onSuccess: (address, position) {
        state.location.value = address;
        state.isLocationSearching.value = false;
        pick(onSuccess, address);
      },
      onError: (error) {
        notify.error(message: error);
        state.isLocationSearching.value = false;
      }
    );
  }
}