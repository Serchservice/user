import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:user/library.dart';

class ActiveResultController extends GetxController {
  ActiveResultController();
  final state = ActiveResultState();

  final ConnectService _connect = Connect();

  final args = Get.arguments;

  @override
  void onInit() {
    if(args != null && args is Map<String, dynamic>) {
      state.searchQuery.value = RequestSearch.fromJson(args);
    }

    updateTitle();
    super.onInit();
  }

  void updateTitle() {
    if(state.searchQuery.value.isSearch) {
      state.title.value = "Showing results for "
          "${state.searchQuery.value.special?.special} "
          "(${state.searchQuery.value.special?.category})";
    } else {
      state.title.value = "Showing results for ${state.searchQuery.value.category?.type}s";
    }
  }

  String noResult() {
    if(state.searchQuery.value.isSearch) {
      return "No ${state.searchQuery.value.special?.special} (${state.searchQuery.value.special?.category}) found";
    } else if(state.searchQuery.value.request != null && state.searchQuery.value.request!.isDrive) {
      return "No ${(state.searchQuery.value.category?.type ?? "").toLowerCase()} shops found";
    } else {
      return "No ${(state.searchQuery.value.category?.type ?? "").toLowerCase()}s found";
    }
  }

  List<ButtonView> requestButtons = [
    ButtonView(header: "Reserve", index: 0, icon: Icons.schedule_rounded),
    ButtonView(header: "Chat", index: 1, icon: Icons.chat_rounded),
    ButtonView(header: "Call", index: 2, icon: Icons.call_rounded)
  ];

  List<ButtonView> driveButtons = [
    ButtonView(header: "Drive", index: 3, icon: Icons.drive_eta_rounded),
    ButtonView(header: "Call", index: 2, icon: Icons.call_rounded)
  ];

  @override
  void onReady() {
    fetchData();
    super.onReady();
  }

  void fetchData({double? radius, bool showLoader = true}) {
    if(state.searchQuery.value.isSearch) {
      fetchSearchList(radius: radius, showLoader: showLoader);
    } else if(state.searchQuery.value.isSpeakTo) {
      fetchCategoryList(radius: radius, showLoader: showLoader);
    } else {
      fetchShopList(radius: radius, showLoader: showLoader);
    }

    if(state.filter.value != -1) {
      filter(state.filter.value);
    }
  }

  String _buildSearchApi({double? radius}) {
    String query = "${state.searchQuery.value.special?.special}${state.searchQuery.value.special?.category}";
    query = query.replaceAll(" ", "|");
    bool auto = Database.preference.autoConnectMeWithProvider;
    double longitude = state.searchQuery.value.address.longitude;
    double latitude = state.searchQuery.value.address.latitude;

    if(radius != null) {
      return "/active/search?q=$query&lng=$longitude&lat=$latitude&radius=$radius&auto=$auto";
    } else {
      return "/active/search?q=$query&lng=$longitude&lat=$latitude&auto=$auto";
    }
  }

  void fetchSearchList({double? radius, bool showLoader = true}) async {
    if(showLoader) {
      state.isSearching.value = true;
    }
    var response = await _connect.get(endpoint: _buildSearchApi(radius: radius));
    state.isSearching.value = false;
    if(response.isOk) {
      SearchResponse search = SearchResponse.fromJson(response.data);
      state.skillSearchList.clear();
      state.search.value = search;

      state.skillSearchList.addAll(search.shops);
      state.skillSearchList.addAll(search.providers);
      state.skillSearchList.shuffle();
      state.skillSearchList.sort((a, b) => a.distance.compareTo(b.distance));
    } else {
      notify.error(message: response.message);
      return;
    }
  }

  String _buildCategoryApi({double? radius}) {
    String query = state.searchQuery.value.category?.category ?? "";
    bool auto = Database.preference.autoConnectMeWithProvider;
    double longitude = state.searchQuery.value.address.longitude;
    double latitude = state.searchQuery.value.address.latitude;

    if(radius != null) {
      return "/active/search/category?c=$query&lng=$longitude&lat=$latitude&radius=$radius&auto=$auto";
    } else {
      return "/active/search/category?c=$query&lng=$longitude&lat=$latitude&auto=$auto";
    }
  }

  void fetchCategoryList({double? radius, bool showLoader = true}) async {
    if(showLoader) {
      state.isSearching.value = true;
    }
    var response = await _connect.get(endpoint: _buildCategoryApi(radius: radius));
    state.isSearching.value = false;
    if(response.isOk) {
      SearchResponse search = SearchResponse.fromJson(response.data);
      state.search.value = search;
      state.shops.value = search.shops;
      state.sortedShops.value = search.shops;
      state.sortedProviders.value = search.providers;
    } else {
      notify.error(message: response.message);
      return;
    }
  }

  String shopEndpoint({double? radius}) {
    String query = state.searchQuery.value.category?.category ?? "";
    double longitude = state.searchQuery.value.address.longitude;
    double latitude = state.searchQuery.value.address.latitude;

    if(radius != null) {
      return "/shop/search?c=$query&lng=$longitude&lat=$latitude&radius=$radius";
    } else {
      return "/shop/search?c=$query&lng=$longitude&lat=$latitude";
    }
  }

  void fetchShopList({double? radius, bool showLoader = true}) async {
    if(showLoader) {
      state.isSearching.value = true;
    }
    var response = await _connect.get(endpoint: shopEndpoint(radius: radius));
    state.isSearching.value = false;
    if(response.isOk) {
      List<dynamic> result = response.data;
      List<SearchShopResponse> list = result.map((item) => SearchShopResponse.fromJson(item)).toList();
      state.shops.value = list;
      state.sortedShops.value = list;
    } else {
      notify.error(message: response.message);
      return;
    }
  }

  List<ButtonView> searchFilters = [
    ButtonView(header: "All", index: 0),
    ButtonView(header: "Shop", index: 1),
    ButtonView(header: "Provider", index: 2)
  ];

  List<ButtonView> driveFilters = [
    ButtonView(header: "All", index: 0),
    ButtonView(header: "Distance", index: 3),
    ButtonView(header: "Rating", index: 4)
  ];

  List<ButtonView> requestFilters = [
    ButtonView(header: "All", index: 0),
    ButtonView(header: "Distance", index: 3),
    ButtonView(header: "Rating", index: 4),
    ButtonView(header: "Verified", index: 5),
  ];

  void updateSearch(double? radius, int? index) {
    if(radius != null) {
      state.radius.value = radius;
      fetchData(radius: radius);
    } else if(index != null) {
      filter(index);
    }
  }

  void filter(int index) {
    state.filter.value = index;
    if(index == 0) {
      sortByAll();
    } else if(index == 1 || index == 2) {
      return;
    } else if(index == 3) {
      sortByDistance();
    } else if(index == 4) {
      sortByRating();
    } else if(index == 5) {
      sortByVerified();
    }
  }

  void sortByAll() {
    if(state.searchQuery.value.isSearch) {
      return;
    } else if(state.searchQuery.value.isSpeakTo) {
      state.sortedProviders.value = state.search.value.providers;
    } else {
      state.sortedShops.value = state.shops;
    }
  }

  void sortByDistance() {
    if(state.searchQuery.value.isSearch) {
      return;
    } else if(state.searchQuery.value.isSpeakTo) {
      state.sortedProviders.value = state.search.value.providers;
      state.sortedProviders.sort((a, b) => a.distance.compareTo(b.distance));
    } else {
      state.sortedShops.value = state.shops;
      state.sortedShops.sort((a, b) => a.distance.compareTo(b.distance));
    }
  }

  void sortByRating() {
    if(state.searchQuery.value.isSearch) {
      return;
    } else if(state.searchQuery.value.isSpeakTo) {
      state.sortedProviders.value = state.search.value.providers;
      state.sortedProviders.sort((a, b) => a.rating.compareTo(b.rating));
    } else {
      state.sortedShops.value = state.shops;
      state.sortedShops.sort((a, b) => a.shop.rating.compareTo(b.shop.rating));
    }
  }

  void sortByVerified() {
    if(state.searchQuery.value.isSearch) {
      return;
    } else if(state.searchQuery.value.isSpeakTo) {
      state.sortedProviders.value = state.search.value.providers;
      state.sortedProviders.value = state.sortedProviders.where((provider) => provider.verificationStatus == "VERIFIED").toList();
    } else {
      return;
    }
  }
}