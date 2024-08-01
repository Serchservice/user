import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:user/library.dart';

class LocationCheckerLayout extends GetResponsiveView<LocationCheckerController> {
  static const String route = "/auth/location/check";
  LocationCheckerLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
      child: Column(
        children: [
          Expanded(
            child: Center(
              child: CircleAvatar(
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                radius: 120,
                child: Obx(() {
                  if(controller.state.isSearching.value) {
                    return Loading(color: Theme.of(context).primaryColor, size: 30);
                  } else {
                    String image = Country.countries.firstWhere((element) {
                      return element.matchesCountry(controller.state.country.value);
                    }, orElse: () => Country.primary()).image;
                    return Image(
                      image: AssetUtility.image(image),
                      height: 200,
                      color: image == Media.logo ? Theme.of(context).primaryColor : null,
                      filterQuality: FilterQuality.high,
                    );
                  }
                })
              ),
            )
          ),
          Obx(() {
            if(controller.state.isVerifying.value) {
              return Padding(
                padding: EdgeInsets.all(Sizing.space(12)),
                child: Loading(color: Theme.of(context).primaryColor, size: 15),
              );
            } else if(controller.state.retry.value) {
              return Padding(
                padding: EdgeInsets.all(Sizing.space(12)),
                child: LoadingButton(
                  text: "Check my location",
                  buttonColor: Theme.of(context).primaryColor,
                  textColor: Theme.of(context).scaffoldBackgroundColor,
                  padding: EdgeInsets.symmetric(
                    horizontal: Sizing.space(30),
                    vertical: Sizing.space(10)
                  ),
                  onClick: () {
                    controller.state.retry.value = false;
                    controller.state.isSearching.value = true;
                    controller.finishChecking();
                  },
                ),
              );
            } else if(controller.state.retryValidation.value) {
              return Padding(
                padding: EdgeInsets.all(Sizing.space(12)),
                child: LoadingButton(
                  text: "Verify my location",
                  buttonColor: Theme.of(context).primaryColor,
                  textColor: Theme.of(context).scaffoldBackgroundColor,
                  padding: EdgeInsets.symmetric(
                    horizontal: Sizing.space(30),
                    vertical: Sizing.space(10)
                  ),
                  onClick: () {
                    controller.state.retryValidation.value = false;
                    controller.state.isVerifying.value = true;
                    controller.verifyMyLocation();
                  },
                ),
              );
            } else {
              return Container();
            }
          })
        ],
      )
    );
  }
}