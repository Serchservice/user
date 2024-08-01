import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:user/library.dart';

class SkillSearchController extends GetxController {
  SkillSearchController();
  final state = SkillSearchState();

  final TextEditingController searchController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final ConnectService _connect = Connect();
  final args = Get.arguments;

  @override
  void onInit() {
    if(args != null && args is Map<String, dynamic>) {
      state.category.value = SerchCategory.fromJson(args);
      state.isSearching.value = true;
    }
    super.onInit();
  }

  @override
  void onReady() {
    if(state.category.value.category.isNotEmpty) {
      searchController.text = "Am looking for ${CommonUtility.textWithAorAn(state.category.value.category.toLowerCase())}";
      startSearching();
    }

    searchController.addListener(() {
      if(searchController.text.isNotEmpty) {
        startSearching();
      }
    });
    super.onReady();
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }

  void startSearching() async {
    state.isSearching.value = true;
    var response = await _connect.get(endpoint: "/specialty/search?query=${searchController.text.trim()}");
    state.isSearching.value = false;
    if(response.isOk) {
      List<dynamic> result = response.data;
      List<Specialization> specializations = result.map((e) => Specialization.fromJson(e)).toList();
      state.specializations.value = specializations;
    } else {
      notify.error(message: response.message);
    }
  }

  void pickSpecialization(Specialization specialization) {
    state.specialization.value = specialization;
    state.specializations.value = [];
    searchController.text = "";
  }

  void removeSpecialization() {
    state.specialization.value = Specialization.empty();
  }

  bool get showButton => state.specialization.value.category.isNotEmpty
      && state.location.value.place.isNotEmpty;

  void search() {
    if(state.location.value.longitude == 0.0) {
      notify.error(message: "Your location is needed");
      return;
    }

    if(state.specialization.value.special.isEmpty && searchController.text.isEmpty) {
      notify.info(message: "You haven't told us what to search for");
      return;
    }

    RequestSearch search = RequestSearch(
      address: state.location.value,
      special: state.specialization.value,
      category: state.category.value
    );

    Map<String, String> data = {
      "mode": "search",
      "longitude": "${state.location.value.longitude}",
      "latitude": "${state.location.value.latitude}"
    };
    Navigate.to(ActiveResultLayout.route, parameters: data, arguments: search.toJson());
  }
}