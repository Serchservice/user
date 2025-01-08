import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:user/library.dart';

class RequestEntryLayout extends GetResponsiveView<RequestEntryController> {
  static const String route = "/request";

  static void request({SerchCategory? category, SharedUser? provider}) {
    _navigate(category: category, provider: provider);
  }

  static void drive({SerchCategory? category}) {
    _navigate(category: category, option: "drive");
  }

  static void speak({SerchCategory? category}) {
    _navigate(category: category, option: "speak");
  }

  static void _navigate({SerchCategory? category, SharedUser? provider, String? option}) {
    Map<String, String>? params = option != null ? {"c": option} : null;
    Map<String, dynamic> arguments = {};

    if(category != null) {
      arguments.putIfAbsent("category", () => category.toJson());
    }
    if(provider != null) {
      arguments.putIfAbsent("provider", () => provider.toJson());
    }

    Navigate.to(route, parameters: params, arguments: arguments);
  }

  RequestEntryLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      appbar: AppBar(
        title: Obx(() => SText(
          text: controller.title,
          size: Sizing.font(16),
          weight: FontWeight.bold,
          color: Theme.of(context).primaryColor
        )),
        actions: [
          Obx(() {
            if(controller.hasProvider) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: Image(
                    image: AssetUtility.image(controller.state.provider.value.avatar),
                    width: 40,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                ),
              );
            } else {
              return SizedBox.shrink();
            }
          })
        ],
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RequestEntryHeader(controller: controller),
            Container(
              width: MediaQuery.sizeOf(context).width,
              padding: EdgeInsets.all(Sizing.space(8)),
              color: Theme.of(context).appBarTheme.backgroundColor,
              child: Column(
                spacing: 6,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Obx(() {
                    if(controller.hasProvider) {
                      return SText(
                        text: controller.state.provider.value.category,
                        size: Sizing.font(12),
                        color: Theme.of(context).primaryColorLight
                      );
                    } else {
                      return SizedBox.shrink();
                    }
                  }),
                  SizedBox(
                    height: 50,
                    child: LocationSearchLayout.search(
                      onSelect: (address) => controller.state.location.value = address,
                      text: "Search city, street, state, etc",
                      color: Theme.of(context).scaffoldBackgroundColor
                    ),
                  ),
                  Obx(() {
                    if(controller.hasLocation) {
                      return Container(
                        height: 60,
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        child: LocationView(address: controller.state.location.value)
                      );
                    } else {
                      return Container();
                    }
                  }),
                ],
              )
            ),
            const SizedBox(height: 20),
            RequestEntryExtraSteps(controller: controller),
            const SizedBox(height: 20),
            Container(
              width: MediaQuery.sizeOf(context).width,
              padding: EdgeInsets.all(Sizing.space(10)),
              decoration: BoxDecoration(
                color: Theme.of(context).appBarTheme.backgroundColor,
                borderRadius: BorderRadius.circular(6)
              ),
              child: SText.justify(
                text: "WHY WE NEED YOUR DATA\n\n"
                    "To ease our service providers on making an informed decision on your request, "
                    "your data is important in making this possible.",
                color: Theme.of(context).primaryColor,
                size: Sizing.font(9)
              )
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Obx(() => Material(
                    color: controller.showButton
                        ? Theme.of(context).primaryColor
                        : Theme.of(context).colorScheme.surface,
                    child: InkWell(
                      onTap: controller.showButton ? controller.search  : null,
                      child: Padding(
                        padding: EdgeInsets.all(Sizing.space(9)),
                        child: Icon(
                          Icons.arrow_forward_rounded,
                          size: Sizing.space(24),
                          color: Theme.of(context).scaffoldBackgroundColor
                        )
                      )
                    )
                  ))
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}