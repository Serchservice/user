import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:user/library.dart';

class AppInformationLayout extends GetResponsiveView<AppInformationController> {
  static const String route = "/centre/app";
  AppInformationLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      child: Obx(() {
        List<ButtonView> options = [
          ButtonView(
            header: "Rate the Serch App",
            body: "Tell us what you think about ${controller.state.appName.value}",
            icon: controller.state.rating.value == 5
              ? Icons.star_rounded
              : controller.state.rating.value > 0.9
              ? Icons.star_half_rounded
              : Icons.star_border_rounded,
            index: 0
          ),
          ButtonView(
            header: "Help",
            body: "Access the support you need whenever you want it",
            icon: Icons.help_rounded,
            index: 1,
            path: HelpLayout.route
          ),
          ButtonView(
            header: "Updates",
            body: "Learn about more ${controller.state.appName.value} updates",
            icon: Icons.update_rounded,
            index: 2,
            path: AppUpdatesLayout.route
          ),
          ButtonView(
            header: "Acknowledgements",
            body: "",
            icon: Icons.hail_rounded,
            index: 3
          ),
          ButtonView(
            header: "Legal",
            body: "",
            icon: Icons.house_siding_rounded,
            index: 4
          ),
          ButtonView(
            header: "Solution for service trips",
            body: "",
            icon: Icons.home_repair_service_rounded,
            index: 5
          ),
          ButtonView(
            header: "Careers in Serch",
            body: "",
            icon: Icons.workspaces_outlined,
            path: Links.web("/careers"),
            index: 6
          ),
        ];

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppInformationHeader(
              rating: controller.state.rating.value,
              isLoading: controller.state.isLoading.value
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ...options.map((tab) {
                      return CentreNavigator(
                        tab: tab,
                        needNotification: tab.index == 1 && controller.state.hasUnreadMessages.value,
                        onTap: () {
                          if(tab.index == 0) {
                            controller.openRating();
                          } else if(tab.index == 1 || tab.index == 2) {
                            Navigate.to(tab.path);
                          } else if(tab.index == 3) {
                            showLicensePage(
                              context: context,
                              applicationName: controller.state.appName.value,
                              applicationVersion: controller.state.appVersion.value,
                              applicationLegalese: "A requestSharing and provideSharing platform"
                            );
                          } else if(tab.index == 4) {
                            controller.openLegal();
                          } else if(tab.index == 5) {
                            controller.openSolution();
                          } else {
                            RouteNavigator.openWeb(header: tab.header, url: tab.path);
                          }
                        }
                      );
                    }),
                    Container(
                      padding: EdgeInsets.all(Sizing.space(16)),
                      margin: EdgeInsets.all(Sizing.space(16)),
                      width: MediaQuery.sizeOf(context).width,
                      decoration: BoxDecoration(
                        color: Theme.of(context).splashColor,
                        borderRadius: BorderRadius.circular(16)
                      ),
                      child: Column(
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SText(
                                text: controller.state.appName.value.toUpperCase(),
                                color: Theme.of(context).primaryColor,
                                size: Sizing.font(14.5),
                                weight: FontWeight.bold
                              ),
                              SText(
                                text: "v${controller.state.appVersion.value}+${controller.state.appBuildNumber.value}",
                                color: Theme.of(context).primaryColorDark,
                                size: Sizing.font(14),
                              ),
                            ],
                          ),
                          if(controller.state.isLoading.value) ...[
                            LoadingShimmer(
                              content: Container(
                                height: 30,
                                width: 200,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: CommonColors.shimmerHigh
                                ),
                              )
                            )
                          ],
                          if(controller.state.comment.value.isNotEmpty)...[
                            const SizedBox(height: 20),
                            SText.center(
                              text: '"${controller.state.comment.value}"',
                              color: Theme.of(context).primaryColor,
                              size: Sizing.font(14),
                              style: FontStyle.italic,
                              fontFamily: MainTheme.logoTheme.bodyLarge?.fontFamily,
                            ),
                          ]
                        ],
                      ),
                    )
                  ],
                )
              )
            )
          ],
        );
      }),
    );
  }
}