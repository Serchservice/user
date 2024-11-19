import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:user/library.dart';

/// Parameter: {"type": "drive", "category": "Mechanic"}
///
/// Argument: [SerchCategory] in to Json
class RequestActionLayout extends GetResponsiveView<RequestActionController> {
  static String get route => "/dashboard/request";

  RequestActionLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      appbar: AppBar(
        title: Obx(() => SText(
          text: controller.title,
          size: Sizing.font(16),
          weight: FontWeight.bold,
          color: Theme.of(context).primaryColor
        ))
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(12),
              child: SText(
                text: "Pick a service of your choice",
                size: Sizing.font(16),
                color: Theme.of(context).primaryColor
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: SizedBox(
                height: 120,
                child: Obx(() {
                  if(controller.state.initial.value.category.isNotEmpty) {
                    return DashboardCategorySelector(
                      category: controller.state.initial.value,
                      onCategoryPick: (category) { },
                      selected: true,
                    );
                  } else if(controller.home.state.isFetchingCategories.value) {
                    return LoadingShimmer(
                      content: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: CommonUtility.generateList(4).map((index) {
                            bool isNotLast = index != CommonUtility.generateList(4).length - 1;

                            return Container(
                              height: 120,
                              width: 120,
                              margin: EdgeInsets.only(right: isNotLast ? 8 : 0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                color: CommonColors.shimmerHigh
                              ),
                            );
                          }).toList()
                        )
                      ),
                    );
                  } else {
                    controller.updateCategoryList();

                    return SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: controller.state.categories.map((category) {
                          bool isNotLast = controller.state.categories.indexOf(category) != controller.state.categories.length - 1;

                          return Padding(
                            padding: EdgeInsets.only(right: isNotLast ? 8 : 0),
                            child: Obx(() {
                              return DashboardCategorySelector(
                                category: category,
                                onCategoryPick: controller.selectCategory,
                                selected: category == controller.state.selected.value,
                              );
                            }),
                          );
                        }).toList()
                      )
                    );
                  }
                }),
              ),
            ),
            const SizedBox(height: 20),
            Container(
              width: MediaQuery.sizeOf(context).width,
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
                    )
                  )
                ]
              )
            ),
            const SizedBox(height: 20),
            Obx(() {
              bool showContent = controller.state.initial.value.category.isNotEmpty
                || controller.state.selected.value.category.isNotEmpty;
              bool isPersonalShopper = controller.state.initial.value.isPersonalShopper
                  || controller.state.selected.value.isPersonalShopper;
              SerchCategory category = controller.state.initial.value.category.isNotEmpty
                ? controller.state.initial.value : controller.state.selected.value;

              if(controller.state.category.value.isRequest && showContent) {
                if(isPersonalShopper) {
                  return _buildShopping(context);
                } else {
                  return Container(
                    width: MediaQuery.sizeOf(context).width,
                    padding: EdgeInsets.all(Sizing.space(8)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: _buildExtraSteps(context, category)
                    ),
                  );
                }
              } else {
                return Container();
              }
            }),
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
                    color: controller.showButton ? Theme.of(context).primaryColor : Theme.of(context).colorScheme.surface,
                    child: InkWell(
                      onTap: controller.showButton ? () => controller.search() : null,
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

  List<Widget> _buildExtraSteps(BuildContext context, SerchCategory category) {
    return [
      if(category.isMechanic) ...[
        Padding(
          padding: const EdgeInsets.only(top: 12.0),
          child: Field(
            controller: controller.car,
            needLabel: true,
            hintText: "Car make Eg: Corolla 2021",
            labelColor: Theme.of(context).primaryColor,
            keyboard: TextInputType.text,
            inputAction: TextInputAction.next,
          ),
        )
      ],
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
                child: _buildRecording(context)
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
                hintText: "Describe what the provider will do for you",
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

  Widget _buildRecording(BuildContext context) {
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
              thumbColor: Theme.of(context).appBarTheme.backgroundColor?.withOpacity(.18),
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

  Widget _buildShopping(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.all(Sizing.space(12)),
          width: MediaQuery.sizeOf(context).width,
          color: CommonColors.darkTheme2,
          child: Obx(() {
            if(controller.state.items.isEmpty) {
              return SText.center(
                text: "Shopping items you add will appear here",
                color: CommonColors.lightTheme,
                size: Sizing.font(9)
              );
            } else {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ...controller.state.items.map((item) => Padding(
                    padding: const EdgeInsets.only(bottom: 4.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SText(
                                text: item.item,
                                size: Sizing.font(14),
                                color: CommonColors.lightTheme
                              ),
                              SText(
                                text: CommonUtility.getAmount("${item.amount}"),
                                size: Sizing.font(12),
                                color: CommonColors.lightTheme
                              ),
                              if(item.address != null) ...[
                                SText(
                                  text: item.address!.place,
                                  size: Sizing.font(10),
                                  color: CommonColors.lightTheme2,
                                  flow: TextOverflow.ellipsis
                                ),
                              ]
                            ],
                          )
                        ),
                        IconButton(
                          onPressed: () => controller.removeItem(item),
                          tooltip: "Remove shopping item",
                          iconSize: Sizing.space(18),
                          icon: const Icon(
                            CupertinoIcons.trash,
                            color: CommonColors.error
                          )
                        )
                      ],
                    ),
                  )),
                  const Divider(color: CommonColors.lightTheme),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SText(
                        text: "Total Budget",
                        color: CommonColors.lightTheme,
                        size: Sizing.font(14)
                      ),
                      const Expanded(child: SizedBox()),
                      SText(
                        text: CommonUtility.getAmount("${controller.state.totalAmount.value}"),
                        color: CommonColors.lightTheme,
                        size: Sizing.font(14)
                      ),
                    ],
                  )
                ],
              );
            }
          }),
        ),
        const SizedBox(height: 20),
        Container(
          padding: EdgeInsets.all(Sizing.space(12)),
          width: MediaQuery.sizeOf(context).width,
          decoration: BoxDecoration(
            color: Theme.of(context).appBarTheme.backgroundColor,
            borderRadius: BorderRadius.circular(8)
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SText(
                text: "Create shopping item",
                color: Theme.of(context).primaryColor,
                size: Sizing.font(14)
              ),
              const SizedBox(height: 12),
              Field(
                controller: controller.item,
                needLabel: true,
                hintText: "Shopping Item",
                labelColor: Theme.of(context).primaryColor,
                keyboard: TextInputType.text,
                noEnabledColor: true,
                borderRadius: 0,
                inputAction: TextInputAction.done,
                padding: EdgeInsets.symmetric(
                  horizontal: Sizing.space(6),
                  vertical: Sizing.space(0)
                )
              ),
              const SizedBox(height: 10),
              LocationSearchLayout.search(
                onSelect: (address) => controller.state.shopAddress.value = address,
                color: Theme.of(context).scaffoldBackgroundColor,
                text: "Preferred shop location"
              ),
              Obx(() {
                if(controller.state.shopAddress.value.latitude != 0.0) {
                  return LocationView(
                    address: controller.state.location.value,
                    onSelect: (address) => controller.state.shopAddress.value = Address.empty(),
                  );
                } else {
                  return Container();
                }
              }),
              const SizedBox(height: 6),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: MediaQuery.sizeOf(context).width * 0.35,
                    child: Field(
                      controller: controller.amount,
                      needLabel: true,
                      hintText: "Budget",
                      labelColor: Theme.of(context).primaryColor,
                      keyboard: TextInputType.number,
                      noEnabledColor: true,
                      borderRadius: 0,
                      inputAction: TextInputAction.done,
                      padding: EdgeInsets.symmetric(
                        horizontal: Sizing.space(6),
                        vertical: Sizing.space(0)
                      )
                    ),
                  ),
                  const Expanded(child: SizedBox()),
                  SizedBox(
                    width: MediaQuery.sizeOf(context).width * 0.35,
                    child: Field(
                      controller: controller.quantity,
                      needLabel: true,
                      hintText: "Quantity",
                      labelColor: Theme.of(context).primaryColor,
                      keyboard: TextInputType.number,
                      noEnabledColor: true,
                      borderRadius: 0,
                      inputAction: TextInputAction.done,
                      padding: EdgeInsets.symmetric(
                        horizontal: Sizing.space(6),
                        vertical: Sizing.space(0)
                      )
                    ),
                  )
                ],
              ),
              const SizedBox(height: 6),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Material(
                    color: Theme.of(context).primaryColor,
                    child: InkWell(
                      onTap: () => controller.addItem(),
                      child: Padding(
                        padding: EdgeInsets.all(Sizing.space(9)),
                        child: Icon(
                          Icons.add,
                          size: Sizing.space(18),
                          color: Theme.of(context).scaffoldBackgroundColor
                        )
                      )
                    )
                  )
                ],
              ),
            ],
          ),
        )
      ],
    );
  }
}