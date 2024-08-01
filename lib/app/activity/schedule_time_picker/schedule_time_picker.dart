import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:user/library.dart';

class ScheduleTimePicker extends StatelessWidget {
  final String id;
  final String name;
  final Function(Schedule) onSchedule;
  const ScheduleTimePicker({
    super.key,
    required this.id,
    required this.name,
    required this.onSchedule
  });

  static void open({required String id, required String name, required Function(Schedule) onSchedule}) {
    Navigate.bottomSheet(
      sheet: ScheduleTimePicker(id: id, name: name, onSchedule: onSchedule),
      route: "/schedule/pick?provider=$id",
      isScrollable: true,
      safeArea: false
    );
  }

  @override
  Widget build(BuildContext context) {
    return CurvedBottomSheet(
      safeArea: true,
      margin: const EdgeInsets.all(16),
      borderRadius: BorderRadius.circular(24),
      child: GetBuilder<ScheduleTimePickerController>(
        init: ScheduleTimePickerController(
          context: context,
          id: id,
          onSchedule: onSchedule
        ),
        builder: (controller) {
          return SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
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
                Center(
                  child: SText.center(
                    text: "Schedule $name",
                    size: Sizing.font(16),
                    weight: FontWeight.bold,
                    color: Theme.of(context).primaryColor
                  ),
                ),
                const SizedBox(height: 10),
                Obx(() {
                  if(controller.state.isFetchingTimes.value) {
                    return SizedBox(
                      height: 150,
                      width: MediaQuery.of(context).size.width,
                      child: Center(child: Loading(color: Theme.of(context).primaryColor))
                    );
                  } else {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
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
                        const SizedBox(height: 30),
                        Obx(() {
                          if(controller.state.amount.value.isEmpty) {
                            return Container();
                          } else {
                            return Center(
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
                            );
                          }
                        }),
                        const SizedBox(height: 20),
                        Field(
                          controller: controller.amount,
                          needLabel: false,
                          hintText: "State the amount for this scheduled trip",
                          labelColor: Theme.of(context).primaryColor,
                          keyboard: TextInputType.number,
                          inputAction: TextInputAction.next,
                        ),
                        const SizedBox(height: 30),
                        SizedBox(
                          height: 250,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildList(context: context, controller: controller),
                              const SizedBox(width: 20),
                              Expanded(child: _buildTimeParts(context: context, controller: controller))
                            ],
                          ),
                        ),
                      ],
                    );
                  }
                })
              ],
            ),
          );
        }
      ),
    );
  }

  Widget _buildList({
    required BuildContext context,
    required ScheduleTimePickerController controller
  }) {
    return Container(
      constraints: BoxConstraints(
        maxWidth: Get.width * 0.35,
        minWidth: Get.width * 0.35,
      ),
      padding: EdgeInsets.all(Sizing.space(8)),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.circular(12)
      ),
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 4,
          mainAxisSpacing: 6,
          childAspectRatio: 1.91
        ),
        itemCount: controller.state.times.length,
        itemBuilder: (context, index) {
          final time = controller.state.times[index];
          return Obx(() {
            bool isSelected = controller.state.selected.value == time;
            return IconButton(
              splashRadius: 25,
              onPressed: () => controller.state.selected.value = time,
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.resolveWith((states) {
                  return isSelected ? CommonColors.darkTheme2 : Colors.transparent;
                }),
                shape: WidgetStateProperty.resolveWith((states) {
                  return RoundedRectangleBorder(borderRadius: BorderRadius.circular(50));
                }),
                overlayColor: WidgetStateProperty.resolveWith((states) {
                  return CommonColors.shimmerBase.withOpacity(.48);
                }),
              ),
              icon: SText(
                text: time.time,
                color: isSelected ? CommonColors.lightTheme : Theme.of(context).scaffoldBackgroundColor
              ),
            );
          });
        },
      )
    );
  }

  Widget _buildTimeParts({
    required BuildContext context,
    required ScheduleTimePickerController controller
  }) {
    List<String> timeStates = [
      "AM",
      "PM"
    ];

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: timeStates.asMap().entries.map((state) {
            return Obx(() {
              bool isSelected = controller.state.part.value == state.value;
              double opacity() {
                if(controller.state.selected.value.amTaken && state.key == 0) {
                  return 0.4;
                } else if(controller.state.selected.value.pmTaken && state.key == 1) {
                  return 0.4;
                } else {
                  return 1.0;
                }
              }

              return Opacity(
                opacity: opacity(),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    color: isSelected ? CommonColors.darkTheme2 : Colors.transparent,
                    border: Border.all(width: 1, color: CommonColors.darkTheme2),
                  ),
                  child: InkWell(
                    onTap: controller.state.selected.value.amTaken && state.key == 0
                      ? null
                      : controller.state.selected.value.pmTaken && state.key == 1
                      ? null
                      : () => controller.state.part.value = state.value,
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: SText(
                        text: state.value,
                        color: isSelected ? CommonColors.lightTheme : Theme.of(context).primaryColor,
                        size: Sizing.font(14)
                      ),
                    ),
                  )
                ),
              );
            });
          }).toList(),
        ),
        const Expanded(child: SizedBox()),
        SText(
          text: DateFormat('EEEE MMMM d, y').format(DateTime.now()),
          color: Theme.of(context).primaryColor,
          size: Sizing.font(14)
        ),
        const SizedBox(height: 15),
        Obx(() {
          bool showButton = controller.state.selected.value.time.isNotEmpty && controller.state.part.isNotEmpty
            && controller.state.location.value.latitude != 0.0 && controller.state.amount.value.isNotEmpty;
          return Opacity(
            opacity: showButton ? 1.0 : 0.4,
            child: LoadingButton(
              text: "Schedule ${controller.state.selected.value.time}${controller.state.part.value}",
              loading: controller.state.isScheduling.value,
              padding: EdgeInsets.all(Sizing.space(12)),
              borderRadius: 24,
              onClick: showButton ? controller.schedule : null,
              width: MediaQuery.of(context).size.width
            ),
          );
        })
      ],
    );
  }
}