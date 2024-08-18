import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:user/library.dart';

class CallInfoView extends StatelessWidget {
  final CallController controller;
  final bool showInvite;
  const CallInfoView({super.key, required this.controller, this.showInvite = false});

  static void open({required CallController controller, bool showInvite = false}) {
    Navigate.bottomSheet(
      sheet: CallInfoView(controller: controller, showInvite: showInvite),
      route: "/call/${controller.state.call.value.channel}/details",
      isScrollable: true,
      safeArea: false
    );
  }

  @override
  Widget build(BuildContext context) {
    return CurvedBottomSheet(
      safeArea: true,
      margin: const EdgeInsets.all(16),
      padding: EdgeInsets.zero,
      borderRadius: BorderRadius.circular(24),
      child: GetX<CallController>(
        builder: (controller) {
          bool showButton = controller.state.search.value.address.latitude != 0.0
              && controller.state.amount.value.isNotEmpty;

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  color: Theme.of(context).textSelectionTheme.selectionColor,
                  child: Column(
                    children: [
                      Center(
                        child: Container(
                          padding: EdgeInsets.all(Sizing.space(2)),
                          margin: EdgeInsets.all(Sizing.space(6)),
                          alignment: Alignment.center,
                          width: 60,
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColorLight,
                            borderRadius: BorderRadius.circular(16)
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: SText(
                                text: "Call #${controller.state.call.value.channel.toUpperCase()}",
                                size: Sizing.font(16),
                                weight: FontWeight.bold,
                                color: Theme.of(context).primaryColor,
                                flow: TextOverflow.ellipsis
                              ),
                            ),
                            const SizedBox(width: 30),
                            Image.asset(
                              controller.asset,
                              width: 30,
                              color: Theme.of(context).primaryColor,
                              height: 30
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SText(
                        text: "Provider Details",
                        size: Sizing.font(16),
                        weight: FontWeight.bold,
                        color: Theme.of(context).primaryColor
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Stack(
                            children: [
                              Avatar.medium(avatar: controller.state.call.value.avatar),
                              Positioned(
                                right: 0,
                                bottom: 0,
                                child: Avatar(radius: 10, avatar: controller.state.call.value.image)
                              ),
                            ],
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SText(
                                  text: controller.state.call.value.name,
                                  size: Sizing.font(16),
                                  weight: FontWeight.bold,
                                  color: Theme.of(context).primaryColor
                                ),
                                SText(
                                  text: controller.state.call.value.category,
                                  size: Sizing.font(14),
                                  color: Theme.of(context).primaryColorLight
                                ),
                              ],
                            )
                          )
                        ],
                      ),
                      const SizedBox(height: 10),
                      Divider(color: Theme.of(context).primaryColorLight),
                      const SizedBox(height: 20),
                      SText(
                        text: "Search Details",
                        size: Sizing.font(16),
                        weight: FontWeight.bold,
                        color: Theme.of(context).primaryColor
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        height: 50,
                        child: LocationSearchLayout.search(
                          onSelect: (address) => controller.state.search.value.copyWith(address: address),
                          text: "Search city, street, state, etc",
                          color: Theme.of(context).scaffoldBackgroundColor
                        ),
                      ),
                      if(controller.state.search.value.address.longitude != 0.0) ...[
                        Container(
                          height: 60,
                          margin: const EdgeInsets.symmetric(vertical: 10),
                          child: LocationView(address: controller.state.search.value.address)
                        ),
                        const SizedBox(height: 10),
                      ],
                      if(showInvite) ...[
                        const SizedBox(height: 10),
                        if(controller.state.amount.value.isNotEmpty) ...[
                          Center(
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Theme.of(context).scaffoldBackgroundColor
                              ),
                              padding: const EdgeInsets.all(8),
                              child: SText(
                                text: CommonUtility.getAmount(controller.state.amount.value),
                                size: Sizing.font(18),
                                weight: FontWeight.bold,
                                color: Theme.of(context).primaryColor
                              )
                            ),
                          ),
                          const SizedBox(height: 20),
                        ],
                        Field(
                          controller: controller.amount,
                          needLabel: false,
                          hintText: "State the amount for this scheduled trip",
                          labelColor: Theme.of(context).primaryColor,
                          keyboard: TextInputType.number,
                          inputAction: TextInputAction.next,
                        ),
                        const SizedBox(height: 30),
                        Opacity(
                          opacity: showButton ? 1.0 : 0.4,
                          child: LoadingButton(
                            text: "Start trip",
                            loading: controller.state.isInviting.value,
                            padding: EdgeInsets.all(Sizing.space(12)),
                            borderRadius: 24,
                            onClick: showButton ? controller.invite : null,
                            width: MediaQuery.of(context).size.width
                          ),
                        )
                      ],
                    ],
                  ),
                ),
              ],
            ),
          );
        }
      ),
    );
  }
}