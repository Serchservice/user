import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:user/library.dart';

class ConversationActionView extends StatelessWidget {
  static String get route => "/connect/chat/request";

  final String provider;
  final String name;
  final RequestSearch? search;
  const ConversationActionView({super.key, required this.provider, this.search, required this.name});

  static void open({required String provider, RequestSearch? search, required String name}) {
    Navigate.bottomSheet(
      sheet: ConversationActionView(provider: provider, search: search, name: name),
      route: route,
      isScrollable: true
    );
  }

  @override
  Widget build(BuildContext context) {
    return CurvedBottomSheet(
      borderRadius: BorderRadius.zero,
      padding: EdgeInsets.zero,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      child: GetBuilder<ConversationActionViewController>(
        init: ConversationActionViewController(provider: provider, search: search),
        builder: (controller) {
          return Obx(() {
            Address selectedAddress = controller.state.location.value;

            if(search != null) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Obx(() {
                    if(controller.state.amount.value.isEmpty) {
                      return Container();
                    } else {
                      return Center(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Theme.of(context).appBarTheme.backgroundColor
                          ),
                          padding: const EdgeInsets.all(8),
                          child: SText(
                            text: CommonUtility.getAmount(controller.state.amount.value),
                            size: Sizing.font(18),
                            weight: FontWeight.bold,
                            color: Theme.of(context).primaryColor
                          )
                        ),
                      );
                    }
                  }),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Field(
                      controller: controller.amount,
                      needLabel: false,
                      hintText: "State the amount for this scheduled trip",
                      labelColor: Theme.of(context).primaryColor,
                      keyboard: TextInputType.number,
                      inputAction: TextInputAction.next,
                    ),
                  ),
                  const SizedBox(height: 12),
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
                            onTap: controller.showButton ? () => controller.runSearch() : null,
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
              );
            } else {
              return SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.all(Sizing.space(8)),
                      color: Theme.of(context).appBarTheme.backgroundColor,
                      child: SteppingList(
                        steppings: [
                          Stepping(
                            icon: Icons.location_on,
                            content: Column(
                              children: [
                                SizedBox(
                                  height: 50,
                                  child: LocationSearchLayout.search(
                                    onSelect: (address) => controller.state.location.value = address,
                                    text: "Search city, street, state, etc",
                                    color: Theme.of(context).scaffoldBackgroundColor
                                  ),
                                ),
                                if(selectedAddress.latitude != 0.0) ...[
                                  Container(
                                    height: 60,
                                    margin: const EdgeInsets.symmetric(vertical: 10),
                                    child: LocationView(address: selectedAddress)
                                  )
                                ],
                              ],
                            )
                          )
                        ]
                      )
                    ),
                    const SizedBox(height: 20),
                    Obx(() {
                      if(controller.state.amount.value.isEmpty) {
                        return Container();
                      } else {
                        return Center(
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Theme.of(context).appBarTheme.backgroundColor
                            ),
                            padding: const EdgeInsets.all(8),
                            child: SText(
                              text: CommonUtility.getAmount(controller.state.amount.value),
                              size: Sizing.font(18),
                              weight: FontWeight.bold,
                              color: Theme.of(context).primaryColor
                            )
                          ),
                        );
                      }
                    }),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Field(
                        controller: controller.amount,
                        needLabel: false,
                        hintText: "State the amount for this scheduled trip",
                        labelColor: Theme.of(context).primaryColor,
                        keyboard: TextInputType.number,
                        inputAction: TextInputAction.next,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.all(Sizing.space(8)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: _buildExtraSteps(context, controller)
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      width: MediaQuery.of(context).size.width,
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
                              onTap: controller.showButton ? () => controller.runSearch() : null,
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
              );
            }
          });
        }
      ),
    );
  }

  List<Widget> _buildExtraSteps(BuildContext context, ConversationActionViewController controller) {
    return [
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 12.0),
            child: SText(
              text: "Record your problem or describe it with text",
              color: Theme.of(context).primaryColor,
              size: Sizing.font(14)
            ),
          ),
          const SizedBox(height: 6),
          Obx(() {
            if(controller.state.showRecorder.value) {
              return Container(
                padding: EdgeInsets.all(Sizing.space(6)),
                decoration: BoxDecoration(
                  color: Theme.of(context).appBarTheme.backgroundColor,
                  borderRadius: BorderRadius.circular(12)
                ),
                child: _buildRecording(context, controller)
              );
            } else {
              return Container();
            }
          }),
          const SizedBox(height: 10),
          Obx(() {
            if(controller.state.showKeyboard.value) {
              return Field(
                controller: controller.description,
                needLabel: false,
                hintText: "Describe what $name will do for you",
                labelColor: Theme.of(context).primaryColor,
                keyboard: TextInputType.text,
                inputAction: TextInputAction.next,
                isBig: true,
              );
            } else {
              return Container();
            }
          }),
        ],
      ),
    ];
  }

  Widget _buildRecording(BuildContext context, ConversationActionViewController controller) {
    return Obx(() {
      if(controller.state.isStoppedRecording.value && controller.state.media.value.path.isNotEmpty) {
        return Column(
          children: [
            Slider(
              value: controller.state.currentPosition.value,
              max: controller.state.totalDuration.value,
              onChanged: controller.seek,
              activeColor: Theme.of(context).primaryColorLight,
              inactiveColor: CommonColors.shimmerBase.withOpacity(.48),
              thumbColor: Theme.of(context).appBarTheme.backgroundColor,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(width: 10),
                SText(
                  text: controller.playingTime(),
                  color: Theme.of(context).primaryColor
                ),
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Obx(() => CircledButton(
                        icon: controller.state.isPlaying.value ? Icons.pause : Icons.play_arrow,
                        title: controller.state.isPlaying.value ? "Pause" : "Play",
                        iconColor: Theme.of(context).primaryColor,
                        onClick: controller.state.isPlaying.value ? controller.pauseAudio : controller.playAudio,
                      )),
                      const SizedBox(width: 10),
                      CircledButton(
                        title: "Delete",
                        icon: CupertinoIcons.trash,
                        iconColor: CommonColors.error,
                        onClick: () => controller.deleteAudio(),
                      )
                    ],
                  ),
                ),
              ],
            )
          ]
        );
      } else {
        return Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SText(
              text: controller.recordingTime(),
              color: Theme.of(context).primaryColor
            ),
            const Expanded(child: SizedBox(width: 20)),
            CircledButton(
              title: controller.recordingOptions().header,
              icon: controller.recordingOptions().icon,
              iconColor: controller.recordingOptions().color,
              onClick: controller.recordingOptions().onClick,
            ),
            if(controller.state.isRecording.value || controller.state.isPausedRecording.value) ...[
              const SizedBox(width: 10),
              CircledButton(
                title: "Stop",
                icon: CupertinoIcons.stop,
                iconColor: CommonColors.error,
                onClick: () => controller.stopRecording()
              ),
              const SizedBox(width: 10),
              CircledButton(
                title: "Delete",
                icon: CupertinoIcons.trash,
                iconColor: CommonColors.error,
                onClick: () => controller.deleteRecording()
              ),
            ]
          ],
        );
      }
    });
  }
}