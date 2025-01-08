import 'package:user/library.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GuestHomeLayout extends GetResponsiveView<GuestHomeController> {
  GuestHomeLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: MediaQuery.sizeOf(context).width,
          padding: EdgeInsets.all(Sizing.space(12)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () => Navigate.to(AppInformationLayout.route),
                child: Image.asset(
                  Media.serch,
                  width: 80,
                  color: Theme.of(context).primaryColor
                ),
              ),
              Spacer(),
              IconButton(
                onPressed: controller.openAccounts,
                tooltip: "View accounts",
                icon: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.account_circle_rounded,
                      color: Theme.of(context).primaryColor
                    ),
                    Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: Theme.of(context).primaryColor
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 30),
                  GuestConnect(data: GuestParentController.data.state.guest.value.link),
                  const SizedBox(height: 30),
                  SText(
                    text: "Go further with Serch",
                    size: Sizing.space(16),
                    weight: FontWeight.w700,
                    flow: TextOverflow.ellipsis,
                    color: Theme.of(context).primaryColor
                  ),
                  const SizedBox(height: 10),
                  ConstrainedBox(
                    constraints: BoxConstraints(maxHeight: controller.contentHeight),
                    child: ListView.separated(
                      itemCount: controller.goFurtherTips.length,
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      separatorBuilder: (context, index) {
                        return SizedBox(width: 12);
                      },
                      itemBuilder: (context, index) {
                        return MoreActionTipItem(
                          itemHeight: controller.contentHeight,
                          itemWidth: 330,
                          view: controller.goFurtherTips[index],
                          onTap: controller.onGoFurtherTap,
                          imageHeight: controller.contentHeight,
                          imageWidth: controller.contentWidth
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ),
      ]
    );
  }
}