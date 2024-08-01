import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';
import 'package:user/library.dart';

/// Parameters: { "mode": "search" "longitude": "0.0", "latitude": "0.0" }
///
/// Arguments: [RequestSearch] in json
class ActiveResultLayout extends GetResponsiveView<ActiveResultController> {
  static String get route => "/dashboard/request/search/result";
  ActiveResultLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if(controller.state.searchQuery.value.isSearch) {
        return _buildSearchView(context);
      } else if(controller.state.searchQuery.value.isSpeakTo) {
        return _buildSpeakToView(context);
      } else {
        return _buildDriveToView(context);
      }
    });
  }

  Widget _buildSpeakToView(BuildContext context) {
    return MainLayout(
      appbar: AppBar(
        elevation: 0.5,
        title: Obx(() => SText.center(
          text: controller.state.title.value,
          size: Sizing.font(16),
          weight: FontWeight.bold,
          color: Theme.of(context).primaryColor
        )),
        actions: [
          IconButton(
            onPressed: () => ActiveResultFilterSheet.open(
              list: controller.requestFilters,
              selectedIndex: controller.state.filter.value,
              onUpdate: controller.updateSearch,
              radius: controller.state.radius.value
            ),
            icon: Icon(
              Icons.filter_list_rounded,
              color: Theme.of(context).primaryColor
            )
          )
        ]
      ),
      child: _buildBody(
        context: context,
        child: Obx(() {
          if(controller.state.search.value.providers.isEmpty) {
            return Center(
              child: SText(
                text: controller.noResult(),
                size: Sizing.font(16),
                color: Theme.of(context).primaryColor,
              )
            );
          } else if(controller.state.search.value.best != null) {
            return SingleChildScrollView(
              child: Column(
                children: [
                  ActiveResultView(
                    active: controller.state.search.value.best!,
                    buttons: controller.requestButtons,
                    isBest: true,
                    latitude: controller.state.searchQuery.value.address.latitude,
                    longitude: controller.state.searchQuery.value.address.longitude,
                  ),
                  const SizedBox(height: 20),
                  ListView.builder(
                    itemCount: controller.state.sortedProviders.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return ActiveResultView(
                        active: controller.state.sortedProviders[index],
                        buttons: controller.requestButtons,
                        latitude: controller.state.searchQuery.value.address.latitude,
                        longitude: controller.state.searchQuery.value.address.longitude,
                      );
                    }
                  )
                ],
              )
            );
          } else {
            return ListView.builder(
              itemCount: controller.state.sortedProviders.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return ActiveResultView(
                  active: controller.state.sortedProviders[index],
                  buttons: controller.requestButtons,
                  latitude: controller.state.searchQuery.value.address.latitude,
                  longitude: controller.state.searchQuery.value.address.longitude,
                );
              }
            );
          }
        })
      )
    );
  }

  Widget _buildDriveToView(BuildContext context) {
    return MainLayout(
      appbar: AppBar(
        elevation: 0.5,
        title: Obx(() => SText.center(
          text: controller.state.title.value,
          size: Sizing.font(16),
          weight: FontWeight.bold,
          color: Theme.of(context).primaryColor
        )),
        actions: [
          IconButton(
            onPressed: () => ActiveResultFilterSheet.open(
              list: controller.driveFilters,
              selectedIndex: controller.state.filter.value,
              onUpdate: controller.updateSearch,
              radius: controller.state.radius.value
            ),
            icon: Icon(
              Icons.filter_list_rounded,
              color: Theme.of(context).primaryColor
            )
          )
        ]
      ),
      child: _buildBody(
        context: context,
        child: Obx(() {
          if(controller.state.sortedShops.isEmpty) {
            return Center(
              child: SText(
                text: controller.noResult(),
                size: Sizing.font(16),
                color: Theme.of(context).primaryColor,
              )
            );
          } else {
            return ListView.builder(
              itemCount: controller.state.sortedShops.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return ActiveResultView(
                  shop: controller.state.sortedShops[index],
                  buttons: controller.driveButtons,
                  latitude: controller.state.searchQuery.value.address.latitude,
                  longitude: controller.state.searchQuery.value.address.longitude,
                );
              }
            );
          }
        })
      )
    );
  }

  Widget _buildSearchView(BuildContext context) {
    return MainLayout(
      appbar: AppBar(
        elevation: 0.5,
        title: Obx(() => SText.center(
          text: controller.state.title.value,
          size: Sizing.font(16),
          weight: FontWeight.bold,
          color: Theme.of(context).primaryColor
        )),
        actions: [
          IconButton(
            onPressed: () => ActiveResultFilterSheet.open(
              list: controller.searchFilters,
              selectedIndex: controller.state.filter.value,
              onUpdate: controller.updateSearch,
              radius: controller.state.radius.value
            ),
            icon: Icon(
              Icons.filter_list_rounded,
              color: Theme.of(context).primaryColor
            )
          )
        ]
      ),
      child: _buildBody(
        context: context,
        child: Obx(() {
          if(controller.state.skillSearchList.isEmpty) {
            return Center(
              child: SText(
                text: controller.noResult(),
                size: Sizing.font(16),
                color: Theme.of(context).primaryColor,
              )
            );
          } else if(controller.state.search.value.best != null) {
            return SingleChildScrollView(
              child: Column(
                children: [
                  ActiveResultView(
                    active: controller.state.search.value.best!,
                    buttons: controller.requestButtons,
                    isBest: true,
                    latitude: controller.state.searchQuery.value.address.latitude,
                    longitude: controller.state.searchQuery.value.address.longitude,
                  ),
                  const SizedBox(height: 20),
                  ListView.builder(
                    itemCount: controller.state.skillSearchList.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      final item = controller.state.skillSearchList[index];

                      if(item is Active && (controller.state.filter.value == 0 || controller.state.filter.value == 2)) {
                        return ActiveResultView(
                          active: item, buttons: controller.requestButtons,
                          latitude: controller.state.searchQuery.value.address.latitude,
                          longitude: controller.state.searchQuery.value.address.longitude,
                        );
                      } else if(item is SearchShopResponse && (controller.state.filter.value == 0 || controller.state.filter.value == 1)) {
                        return ActiveResultView(
                          shop: item, buttons: controller.driveButtons,
                          latitude: controller.state.searchQuery.value.address.latitude,
                          longitude: controller.state.searchQuery.value.address.longitude,
                        );
                      } else {
                        return Container();
                      }
                    }
                  )
                ],
              )
            );
          } else {
            return ListView.builder(
              itemCount: controller.state.skillSearchList.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                final item = controller.state.skillSearchList[index];

                if(item is Active && (controller.state.filter.value == 0 || controller.state.filter.value == 2)) {
                  return ActiveResultView(
                    active: item, buttons: controller.requestButtons,
                    latitude: controller.state.searchQuery.value.address.latitude,
                    longitude: controller.state.searchQuery.value.address.longitude,
                  );
                } else if(item is SearchShopResponse && (controller.state.filter.value == 0 || controller.state.filter.value == 1)) {
                  return ActiveResultView(
                    shop: item, buttons: controller.driveButtons,
                    latitude: controller.state.searchQuery.value.address.latitude,
                    longitude: controller.state.searchQuery.value.address.longitude,
                  );
                } else {
                  return Container();
                }
              }
            );
          }
        })
      )
    );
  }

  Obx _buildBody({required BuildContext context, required Widget child}) {
    return Obx(() {
      if(controller.state.isSearching.value) {
        return LoadingShimmer(
          content: Column(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.all(Sizing.space(10)),
                padding: EdgeInsets.all(Sizing.space(20)),
                decoration: BoxDecoration(
                  color: CommonColors.shimmerHigh,
                  borderRadius: BorderRadius.circular(6)
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: ListView.builder(
                  itemCount: 10,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return Container(
                      width: MediaQuery.of(context).size.width,
                      margin: EdgeInsets.only(bottom: Sizing.space(4)),
                      height: 90,
                      color: CommonColors.shimmerHigh,
                    );
                  }
                ),
              ),
            ],
          )
        );
      } else {
        return child;
      }
    });
  }
}