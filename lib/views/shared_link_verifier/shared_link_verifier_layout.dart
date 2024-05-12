import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:user/library.dart';

/// ?shared_by=
class SharedLinkVerifierLayout extends GetResponsiveView<SharedLinkVerifierController> {
  static String get route => "/request_serch_services";
  SharedLinkVerifierLayout({super.key});

  @override
  Widget build(BuildContext context) {
    List<ButtonView> buttons = [
      ButtonView(
        header: "Login as guest",
        index: 0,
      ),
      ButtonView(
        header: "Create a guest account",
        index: 1,
      ),
    ];
    return ViewLayout(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      child: Obx(() {
        if(controller.state.showLoading.value) {
          return Padding(
            padding: EdgeInsets.all(Sizing.space(16)),
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
                        Loading(color: Theme.of(context).primaryColor),
                        SizedBox(height: Sizing.space(10)),
                        SText(
                          text: controller.state.message.value,
                          color: Theme.of(context).primaryColor,
                          size: Sizing.font(18)
                        )
                      ],
                    ),
                  )
                )
              ]
            )
          );
        } else {
          return SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(Sizing.space(16)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  LineHeader(
                    header: "Connect with ${controller.state.data.value.provider.name}",
                    footer: "Created by ${controller.state.data.value.user.name}",
                    color: Theme.of(context).primaryColor,
                  ),
                  const SizedBox(height: 20),
                  Center(child: CategoryImage(image: controller.state.data.value.image)),
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
                    decoration: BoxDecoration(
                      color: Theme.of(context).bottomAppBarTheme.color,
                      borderRadius: BorderRadius.circular(16)
                    ),
                    child: Table(
                      columnWidths: const {
                        0: FixedColumnWidth(120)
                      },
                      children: [
                        _buildTile(
                          context: context,
                          key: "ID",
                          value: controller.state.data.value.linkId
                        ),
                        _buildTile(
                          context: context,
                          key: "Link",
                          value: controller.state.data.value.link
                        ),
                        _buildTile(
                          context: context,
                          key: "Amount Spent",
                          value: controller.state.data.value.amount
                        ),
                        _buildTile(
                          context: context,
                          key: "Created At",
                          value: controller.state.data.value.label
                        ),
                        _buildTile(
                          context: context,
                          key: "Current Status",
                          value: controller.state.data.value.status
                        ),
                        _buildTile(
                          context: context,
                          key: "Category",
                          value: controller.state.data.value.category
                        ),
                      ],
                    )
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: SText(
                      text: "Provider",
                      color: Theme.of(context).primaryColor,
                      size: Sizing.font(16),
                      weight: FontWeight.bold
                    ),
                  ),
                  const SizedBox(height: 5),
                  Container(
                    padding: EdgeInsets.all(Sizing.space(10)),
                    decoration: BoxDecoration(
                      color: Theme.of(context).bottomAppBarTheme.color,
                      borderRadius: BorderRadius.circular(16)
                    ),
                    child: _buildInformation(
                      context: context,
                      avatar: controller.state.data.value.provider.avatar,
                      name: controller.state.data.value.provider.name,
                      category: controller.state.data.value.provider.category,
                      rating: controller.state.data.value.provider.rating
                    )
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: SText(
                      text: "User",
                      color: Theme.of(context).primaryColor,
                      size: Sizing.font(16),
                      weight: FontWeight.bold
                    ),
                  ),
                  const SizedBox(height: 5),
                  Container(
                    padding: EdgeInsets.all(Sizing.space(10)),
                    decoration: BoxDecoration(
                      color: Theme.of(context).bottomAppBarTheme.color,
                      borderRadius: BorderRadius.circular(16)
                    ),
                    child: _buildInformation(
                      context: context,
                      avatar: controller.state.data.value.user.avatar,
                      name: controller.state.data.value.user.name,
                      category: controller.state.data.value.user.category,
                      rating: controller.state.data.value.user.rating
                    )
                  ),
                  const SizedBox(height: 40),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: buttons.map((button) => LoadingButton(
                      text: button.header,
                      buttonColor: button.index == 0
                        ? Theme.of(context).primaryColor
                        : Theme.of(context).primaryColorLight,
                      textColor: Theme.of(context).scaffoldBackgroundColor,
                      textSize: 12,
                      onClick: () {
                        if(button.index == 0) {
                          GuestLoginSheet.open(
                            link: controller.state.data.value.link,
                            linkId: controller.state.data.value.linkId,
                          );
                        } else {
                          Navigate.to(GuestCreateLayout.route, parameters: {
                            "link": controller.state.data.value.link,
                            "link_id": controller.state.data.value.linkId
                          });
                        }
                      }
                    )).toList()
                  ),
                  if(Database.isLoggedIn) ...[
                    const SizedBox(height: 20),
                    LoadingButton(
                      text: "Create with user account",
                      borderRadius: 24,
                      width: MediaQuery.of(context).size.width,
                      textSize: Sizing.font(14),
                      buttonColor: Theme.of(context).primaryColorDark,
                      textColor: Theme.of(context).scaffoldBackgroundColor,
                      onClick: () => CreateWithUserAccount.open(link: controller.state.data.value.link),
                    )
                  ],
                ]
              )
            ),
          );
        }
      })
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
          child: SText(
            autoSize: false,
            text: value,
            color: Theme.of(context).primaryColor,
            size: Sizing.font(12),
          ),
        ),
      ]
    );
  }

  Widget _buildInformation({
    required BuildContext context,
    required String avatar,
    required String name,
    required String category,
    double? rating,
    VoidCallback? onTap
  }) => Material(
    color: Colors.transparent,
    child: InkWell(
      onTap: onTap,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Avatar.small(avatar: avatar),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SText(
                  text: name,
                  size: Sizing.font(14),
                  color: Theme.of(context).primaryColor
                ),
                SText(
                  text: category,
                  size: Sizing.font(11),
                  color: Theme.of(context).primaryColor
                ),
              ],
            )
          ),
          if(rating != null) ...[
            RatingIcon(rating: rating)
          ]
        ],
      ),
    )
  );
}