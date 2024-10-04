import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';
import 'package:user/library.dart';

class LocationSearchLayout extends StatelessWidget {
  static String get route => "/dashboard/trip/search/location";
  const LocationSearchLayout({super.key, required this.onSelect});

  final Function(Address) onSelect;

  static Widget search({required Function(Address) onSelect, Color? color, String? text}) {
    return Animated(
      toWidget: LocationSearchLayout(onSelect: (address) => onSelect.call(address)),
      toRoute: RouteSettings(name: LocationSearchLayout.route),
      color: Colors.transparent,
      elevation: 0,
      child: FakeField(
        buttonText: "Search",
        searchText: text ?? "Enter your location",
        needPadding: false,
        color: color
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      appbar: AppBar(
        elevation: 0.5,
        title: SText.center(
          text: "Search Location",
          size: Sizing.font(20),
          weight: FontWeight.bold,
          color: Theme.of(context).primaryColor
        ),
      ),
      child: GetBuilder<LocationSearchController>(
        init: LocationSearchController(),
        builder: (controller) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: MediaQuery.sizeOf(context).width,
                padding: EdgeInsets.only(
                  bottom: Sizing.space(16),
                  left: Sizing.space(16),
                  right: Sizing.space(16)
                ),
                color: Theme.of(context).appBarTheme.backgroundColor,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SteppingList(
                      steppings: [
                        Stepping(
                          content: Column(
                            children: [
                              Field(
                                padding: const EdgeInsets.all(8),
                                hintText: "Enter your location",
                                controller: controller.locationController,
                              ),
                              Obx(() {
                                if(controller.state.location.value.latitude == 0.0) {
                                  return Container();
                                } else {
                                  return Container(
                                    height: 60,
                                    margin: const EdgeInsets.symmetric(vertical: 10),
                                    child: LocationView(address: controller.state.location.value)
                                  );
                                }
                              }),
                            ],
                          ),
                          icon: Icons.location_searching_rounded,
                        )
                      ]
                    ),
                    const SizedBox(height: 10),
                    Obx(() => LoadingButton(
                      text: "Use current location",
                      borderRadius: 24,
                      padding: EdgeInsets.all(Sizing.space(12)),
                      textSize: Sizing.font(11),
                      onClick: () => controller.searchCurrentLocation(onSelect),
                      buttonColor: CommonColors.darkTheme2,
                      textColor: CommonColors.lightTheme,
                      loading: controller.state.isLocationSearching.value,
                    )),
                  ],
                ),
              ),
              Obx(() {
                if(controller.state.isSearching.value) {
                  return Expanded(
                    child: LoadingShimmer(
                      content: ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: 8,
                        itemBuilder: (context, index) {
                          return Container(
                            height: 80,
                            margin: EdgeInsets.symmetric(vertical: Sizing.space(2)),
                            color: Theme.of(context).primaryColorLight,
                          );
                        },
                      ),
                    ),
                  );
                } else if(controller.state.locations.isNotEmpty) {
                  return Expanded(
                    child: ListView.builder(
                      itemCount: controller.state.locations.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        bool isLast = controller.state.locations.length - 1 == index;
                        bool isFirst = controller.state.locations.indexOf(controller.state.locations.first) == index;
                        Address address = controller.state.locations[index];

                        return Padding(
                          padding: EdgeInsets.only(
                            top: isFirst ? 0 : 8,
                            bottom: isLast ? 0 : 8,
                          ),
                          child: LocationView(
                            address: address,
                            withPadding: true,
                            fontSize: 14,
                            onSelect: (address) => controller.pick(onSelect, address),
                          )
                        );
                      },
                    ),
                  );
                } else {
                  return Container();
                }
              }),
            ],
          );
        }
      )
    );
  }
}