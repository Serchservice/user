import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:user/library.dart';

class SkillSearchController extends GetxController {
  SkillSearchController();
  final state = SkillSearchState();

  final _pageSize = 20;
  final PagingController<int, Specialization> skillController = PagingController(firstPageKey: 0);

  final TextEditingController searchController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final ConnectService _connect = Connect();
  final args = Get.arguments;

  @override
  void onInit() {
    if(args != null) {
      state.category.value = args;
    }

    if(state.category.value.category.isNotEmpty) {
      searchController.text = "Am looking for ${CommonUtility.textWithAorAn(state.category.value.category.toLowerCase())}";
      state.query.value = state.category.value.category;

      skillController.refresh();
      AnalyticsEngine.serviceSearch(searchController.text);
    }

    skillController.itemList = [];
    skillController.addPageRequestListener((page) {
      _search(page);
    });


    super.onInit();
  }

  bool get hasCategory => state.category.value.category.isNotEmpty;

  @override
  void onReady() {
    searchController.addListener(() {
      if(searchController.text.isNotEmpty) {
        state.query.value = searchController.text;

        skillController.refresh();
        AnalyticsEngine.serviceSearch(searchController.text);
      }
    });
    super.onReady();
  }

  @override
  void onClose() {
    searchController.dispose();

    super.onClose();
  }

  void _search(int page) async {
    if(state.query.isNotEmpty) {
      String query = "query=${state.query.value}&page=$page&size=$_pageSize";
      var response = await _connect.get(endpoint: "/specialty/search?$query");

      if(response.isOk) {
        List<dynamic> result = response.data;
        List<Specialization> items = result.map((e) => Specialization.fromJson(e)).toList();
        bool isLast = items.length < _pageSize;

        if(isLast) {
          skillController.appendLastPage(items);
        } else {
          skillController.appendPage(items, CommonUtility.increment(page));
        }
      } else {
        skillController.error = response.message;
      }
    }
  }

  void pickSpecialization(Specialization specialization) {
    state.specialization.value = specialization;
    skillController.itemList = [];
    searchController.text = "";
  }

  void removeSpecialization() {
    state.specialization.value = Specialization.empty();
  }

  bool get showButton => state.specialization.value.category.isNotEmpty && state.location.value.place.isNotEmpty;

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

    SearchResultLayout.off(search);
  }
}