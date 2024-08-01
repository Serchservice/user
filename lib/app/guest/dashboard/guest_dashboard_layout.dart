import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:get/get.dart';
import 'package:user/library.dart';

class GuestDashboardLayout extends GetResponsiveView<GuestHomeController> {
  GuestDashboardLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DashboardHeader(
            name: controller.state.firstName.value,
            image: controller.state.image.value,
            onSerch: () => Navigate.to(AppInformationLayout.route),
            onAccounts: () => AccountPicker.open(
              onUserSuccess: () => Navigate.all(HomeLayout.route),
              onGuestSuccess: (guest) {
                controller.state.firstName.value = guest.firstName;
                controller.state.image.value = guest.avatar;
                controller.state.name.value = guest.name;
                controller.state.guest.value = guest;
                Navigate.back();
              }
            ),
          ),
          const SizedBox(height: 20),
          Center(
            child: Obx(() => CategoryImage(
              image: controller.state.guest.value.link.image
            ))
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: SText(
              text: "Link Details",
              color: Theme.of(context).primaryColor,
              size: Sizing.font(16),
              weight: FontWeight.bold
            ),
          ),
          const SizedBox(height: 5),
          Container(
            padding: EdgeInsets.all(Sizing.space(16)),
            color: Theme.of(context).bottomAppBarTheme.color,
            child: Obx(() => Table(
              columnWidths: const {
                0: FixedColumnWidth(120)
              },
              children: [
                _buildTile(
                  context: context,
                  key: "Link",
                  value: controller.state.guest.value.link.link
                ),
                _buildTile(
                  context: context,
                  key: "Amount Spent",
                  value: controller.state.guest.value.link.amount
                ),
                _buildTile(
                  context: context,
                  key: "Created At",
                  value: controller.state.guest.value.link.label
                ),
                _buildTile(
                  context: context,
                  key: "Current Status",
                  value: controller.state.guest.value.link.status
                ),
                _buildTile(
                  context: context,
                  key: "Category",
                  value: controller.state.guest.value.link.category
                ),
              ],
            ))
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: SText(
              text: "Created By",
              color: Theme.of(context).primaryColor,
              size: Sizing.font(16),
              weight: FontWeight.bold
            ),
          ),
          const SizedBox(height: 5),
          Container(
            padding: EdgeInsets.all(Sizing.space(6)),
            color: Theme.of(context).bottomAppBarTheme.color,
            child: Obx(() => SharedPersonInformation(
              avatar: controller.state.guest.value.link.user.avatar,
              name: controller.state.guest.value.link.user.name,
              category: controller.state.guest.value.link.user.category,
              rating: controller.state.guest.value.link.user.rating
            ))
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: SText(
              text: "Shared Provider",
              color: Theme.of(context).primaryColor,
              size: Sizing.font(16),
              weight: FontWeight.bold
            ),
          ),
          const SizedBox(height: 5),
          Container(
            padding: EdgeInsets.all(Sizing.space(6)),
            color: Theme.of(context).bottomAppBarTheme.color,
            child: Obx(() => SharedPersonInformation(
              avatar: controller.state.guest.value.link.provider.avatar,
              name: controller.state.guest.value.link.provider.name,
              category: controller.state.guest.value.link.provider.category,
              rating: controller.state.guest.value.link.provider.rating
            ))
          ),
          const SizedBox(height: 30),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: SText(
              text: "Your Link Events",
              color: Theme.of(context).primaryColor,
              size: Sizing.font(16),
              weight: FontWeight.bold
            ),
          ),
          const SizedBox(height: 5),
          Obx(() {
            if(controller.state.guest.value.statuses.isEmpty) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  Center(
                    child: SText(
                      text: "No events yet",
                      size: Sizing.font(15),
                      color: Theme.of(context).primaryColor
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              );
            } else {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: controller.state.guest.value.statuses.map((status) {
                  return GuestStatusView(status: status);
                }).toList(),
              );
            }
          })
        ]
      )
    );
  }

  TableRow _buildTile({required BuildContext context, required String key, required String value}) {
    return TableRow(
      children: [
        Padding(
          padding: EdgeInsets.only(bottom: Sizing.space(6)),
          child: SText(
            autoSize: false,
            text: key,
            color: Theme.of(context).primaryColor,
            size: Sizing.font(12),
            weight: FontWeight.bold
          ),
        ),
        Padding(
          padding: EdgeInsets.only(bottom: Sizing.space(6)),
          child: SelectableLinkify(
            options: const LinkifyOptions(humanize: false),
            text: value,
            style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontSize: Sizing.font(12),
            ),
            onOpen: (link) => RouteNavigator.openLink(url: link.url),
          )
        ),
      ]
    );
  }
}