import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:user/library.dart';

class RequestEntryExtraSteps extends StatelessWidget {
  final RequestEntryController controller;

  const RequestEntryExtraSteps({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      bool showContent = controller.state.initial.value.category.isNotEmpty
          || controller.state.selected.value.category.isNotEmpty
          || (controller.hasProvider && Database.isGuestActive);
      bool isPersonalShopper = controller.state.initial.value.isPersonalShopper
          || controller.state.selected.value.isPersonalShopper
          || controller.state.provider.value.isPersonalShopper;
      bool isMechanic = controller.state.initial.value.isMechanic
          || controller.state.selected.value.isMechanic
          || controller.state.provider.value.isMechanic;

      if(controller.isRequest && showContent) {
        if(isPersonalShopper) {
          return RequestEntryShopping(controller: controller);
        } else {
          return Container(
            width: MediaQuery.sizeOf(context).width,
            padding: EdgeInsets.all(Sizing.space(8)),
            child: Column(
              children: [
                if(isMechanic) ...[
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
                    if(controller.state.showRecorder.value) ...[
                      Container(
                        padding: EdgeInsets.all(Sizing.space(6)),
                        decoration: BoxDecoration(
                          color: Theme.of(context).appBarTheme.backgroundColor,
                          borderRadius: BorderRadius.circular(12)
                        ),
                        child: RequestEntryRecording(controller: controller)
                      )
                    ],
                    const SizedBox(height: 10),
                    if(controller.state.showKeyboard.value) ...[
                      Field(
                        controller: controller.description,
                        needLabel: false,
                        hintText: "Describe what the provider will do for you",
                        labelColor: Theme.of(context).primaryColor,
                        keyboard: TextInputType.text,
                        inputAction: TextInputAction.next,
                        isBig: true,
                      )
                    ]
                  ],
                ),
              ],
            ),
          );
        }
      } else if(controller.hasProvider && Database.isUserActive) {
        String amount = controller.state.searchAmount.value.isEmpty
            ? "0.0"
            : controller.state.searchAmount.value;

        return Column(
          children: [
            Center(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Theme.of(context).appBarTheme.backgroundColor
                ),
                padding: const EdgeInsets.all(8),
                child: SText(
                  text: CommonUtility.getAmount(amount),
                  size: Sizing.font(18),
                  weight: FontWeight.bold,
                  color: Theme.of(context).primaryColor
                )
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Field(
                controller: controller.searchAmount,
                needLabel: false,
                hintText: "State the amount for this planned trip",
                labelColor: Theme.of(context).primaryColor,
                keyboard: TextInputType.number,
                inputAction: TextInputAction.next,
              ),
            ),
          ],
        );
      } else {
        return Container();
      }
    });
  }
}