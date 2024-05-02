import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:user/library.dart';

class SharedLinkVerifierLayout extends GetResponsiveView<SharedLinkVerifierController> {
  static String get route => "/request_services";
  SharedLinkVerifierLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return ViewLayout(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      child: Padding(
        padding: EdgeInsets.all(Sizing.space(24)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            LineHeader(
              header: "Hey there,",
              footer: "Got a link? Wait a moment while Serch verifies it",
              color: Theme.of(context).primaryColor,
            ),
            const SizedBox(height: 50),
            Expanded(
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Obx(() {
                      if(controller.state.showLoading.value) {
                        return Loading(color: Theme.of(context).primaryColor);
                      } else {
                        return Container();
                      }
                    }),
                    Obx(() {
                      if(controller.state.showLoading.value) {
                        return SizedBox(height: Sizing.space(10));
                      } else {
                        return Container();
                      }
                    }),
                    Obx(() => SText(
                      text: controller.state.message.value,
                      color: Theme.of(context).primaryColor,
                      size: Sizing.font(18)
                    ))
                  ],
                ),
              )
            )
          ]
        ),
      )
    );
  }
}