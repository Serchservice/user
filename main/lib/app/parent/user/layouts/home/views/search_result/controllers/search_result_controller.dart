import 'package:get/get.dart';
import 'package:user/library.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class SearchResultController extends GetxController {
  SearchResultController();
  final state = SearchResultState();

  final ConnectService _connect = Connect();

  final args = Get.arguments;

  final _pageSize = 20;
  final PagingController<int, SearchShopResponse> shopController = PagingController(firstPageKey: 0);
  final PagingController<int, SearchItem> searchController = PagingController(firstPageKey: 0);

  @override
  void onInit() {
    if(args != null) {
      state.search.value = args;
    }

    updateTitle();
    _fetch();

    super.onInit();
  }

  void updateTitle() {
    if(state.search.value.isSearch) {
      state.title.value = "Showing results for "
          "${state.search.value.special?.special} "
          "(${state.search.value.special?.category})";
    } else {
      state.title.value = "Showing results for ${state.search.value.category?.type}s";
    }

    AnalyticsEngine.logSearchResults(state.title.value, state.search.value.toJson());
  }

  String noResult() {
    if(state.search.value.isSearch) {
      return "No ${state.search.value.special?.special} (${state.search.value.special?.category}) found";
    } else if(state.search.value.isDrive) {
      return "No ${(state.search.value.category?.type ?? "").toLowerCase()} shops found";
    } else {
      return "No ${(state.search.value.category?.type ?? "").toLowerCase()}s found";
    }
  }

  bool get isRequest => !state.search.value.isSearch && !state.search.value.isDrive;

  void _fetch() {
    if(state.search.value.isSearch || isRequest) {
      searchController.addPageRequestListener((pageKey) {
        _search(pageKey);
      });
    } else {
      shopController.addPageRequestListener((pageKey) {
        _fetchShops(pageKey);
      });
    }
  }

  String _searchApi(int page) {
    String query = "${state.search.value.special?.special}${state.search.value.special?.category}";
    query = query.replaceAll(" ", "|");

    bool auto = Database.preference.autoConnectMeWithProvider;
    double lng = state.search.value.address.longitude;
    double lat = state.search.value.address.latitude;
    double radius = state.searchRadius.value;

    return "/active/search?q=$query&lng=$lng&lat=$lat&page=$page&size=$_pageSize&auto=$auto&radius=$radius";
  }

  String _activeApi(int page) {
    String query = state.search.value.category?.category ?? "";

    bool auto = Database.preference.autoConnectMeWithProvider;
    double lng = state.search.value.address.longitude;
    double lat = state.search.value.address.latitude;
    double radius = state.searchRadius.value;

    return "/active/search/category?c=$query&lng=$lng&lat=$lat&page=$page&size=$_pageSize&auto=$auto&radius=$radius";
  }

  void _search(int pageKey) async {
    String endpoint = state.search.value.isSearch ? _searchApi(pageKey) : _activeApi(pageKey);
    var response = await _connect.get(endpoint: endpoint);

    if(response.isOk) {
      List<SearchItem> items = _updateItemList(SearchResponse.fromJson(response.data));
      final isLastPage = items.length < _pageSize;

      if(isLastPage) {
        searchController.appendLastPage(items);
      } else {
        searchController.appendPage(items, CommonUtility.increment(pageKey));
      }

      _filter(state.filter.value);
    } else {
      searchController.error = response.message;
    }
  }

  List<SearchItem> _updateItemList(SearchResponse search) {
    List<SearchItem> items = List.from(search.shops.map((s) => SearchItem(shop: s)).toList());
    items.addAll(search.providers.map((s) => SearchItem(active: s)).toList());

    if(search.best != null) {
      state.best.value = search.best;
    }

    List<SearchItem> existing = List.from(state.items);
    existing.addAll(items);
    state.items.value = existing;

    return items;
  }

  String _shopApi(int page) {
    String query = state.search.value.category?.category ?? "";

    double lng = state.search.value.address.longitude;
    double lat = state.search.value.address.latitude;
    double radius = state.searchRadius.value;

    return "/shop/search?c=$query&lng=$lng&lat=$lat&page=$page&size=$_pageSize&radius=$radius";
  }

  void _fetchShops(int pageKey) async {
    if(state.search.value.isDrive) {
      var response = await _connect.get(endpoint: _shopApi(pageKey));

      if(response.isOk) {
        List<dynamic> result = response.data;
        List<SearchShopResponse> shops = result.map((data) => SearchShopResponse.fromJson(data)).toList();
        _updateShops(shops);
        final isLastPage = shops.length < _pageSize;

        if(isLastPage) {
          shopController.appendLastPage(shops);
        } else {
          shopController.appendPage(shops, CommonUtility.increment(pageKey));
        }

        _filter(state.filter.value);
      } else {
        shopController.error = response.message;
      }
    }
  }

  List<SearchShopResponse> _updateShops(List<SearchShopResponse> shops) {
    final existingShopIds = state.shops.map((shop) => shop.shop.id).toSet();
    final newShops = shops.where((shop) => !existingShopIds.contains(shop.shop.id)).toList();

    List<SearchShopResponse> updatedShops = List.from(state.shops)..addAll(newShops);
    state.shops.value = updatedShops;

    return updatedShops;
  }

  List<ButtonView> searchFilters = [
    ButtonView(header: "All", index: 0),
    ButtonView(header: "Shop", index: 1),
    ButtonView(header: "Provider", index: 2)
  ];

  List<ButtonView> shopFilters = [
    ButtonView(header: "All", index: 0),
    ButtonView(header: "Distance", index: 3),
    ButtonView(header: "Rating", index: 4)
  ];

  List<ButtonView> activeFilters = [
    ButtonView(header: "All", index: 0),
    ButtonView(header: "Distance", index: 3),
    ButtonView(header: "Rating", index: 4),
    ButtonView(header: "Verified", index: 5),
  ];

  List<ButtonView> get filters => state.search.value.isSearch ? searchFilters : isRequest ? activeFilters : shopFilters;

  void _filter(int index) {
    state.filter.value = index;
    if(index == 0) {
      _sortByAll();
    } else if(index == 1 || index == 2) {
      return;
    } else if(index == 3) {
      _sortByDistance();
    } else if(index == 4) {
      _sortByRating();
    } else if(index == 5) {
      _sortByVerified();
    }
  }

  void _sortByAll() {
    if(state.search.value.isSearch || isRequest) {
      searchController.itemList = state.items;
    } else {
      shopController.itemList = state.shops;
    }
  }

  void _sortByDistance() {
    if(state.search.value.isSearch) {
      return;
    } else if(state.search.value.isDrive) {
      List<SearchShopResponse> shops = List.from(state.shops);
      shops.sort((a, b) => a.distance.compareTo(b.distance));

      shopController.itemList = shops;
    } else {
      List<SearchItem> items = List.from(state.items);
      items.where((a) => a.active != null)
          .toList()
          .sort((a, b) => a.active!.distance.compareTo(b.active!.distance));

      searchController.itemList = items;
    }
  }

  void _sortByRating() {
    if(state.search.value.isSearch) {
      return;
    } else if(state.search.value.isDrive) {
      List<SearchShopResponse> shops = List.from(state.shops);
      shops.sort((a, b) => a.shop.rating.compareTo(b.shop.rating));

      shopController.itemList = shops;
    } else {
      List<SearchItem> items = List.from(state.items);
      items.where((a) => a.active != null)
          .toList()
          .sort((a, b) => a.active!.rating.compareTo(b.active!.rating));

      searchController.itemList = items;
    }
  }

  void _sortByVerified() {
    if(isRequest) {
      List<SearchItem> items = List.from(state.items);
      items = items.where((a) => a.active != null && a.active!.verificationStatus == "VERIFIED").toList();

      searchController.itemList = items;
    }
  }

  void updateSearch(double? radius, int? index) {
    if(radius != null) {
      state.searchRadius.value = radius;
      fetchUpdate();
    } else if(index != null) {
      _filter(index);
    }
  }

  void fetchUpdate() {
    if(state.search.value.isSearch || isRequest) {
      searchController.refresh();
    } else {
      shopController.refresh();
    }
  }

  @override
  void onClose() {
    searchController.dispose();
    shopController.dispose();

    super.onClose();
  }
}

class SearchItem {
  final Active? active;
  final SearchShopResponse? shop;

  SearchItem({this.active, this.shop});
}