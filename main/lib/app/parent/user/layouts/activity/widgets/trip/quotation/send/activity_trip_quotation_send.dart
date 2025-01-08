import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:user/library.dart';

class ActivityTripQuotationSend extends StatelessWidget {
  final String trip;
  final int? quotation;
  final Function(TripResponse) onSend;
  const ActivityTripQuotationSend({super.key, required this.trip, this.quotation, required this.onSend});

  static void open({required String trip, int? quotation, required Function(TripResponse) onSend}) {
    String route = "/activity/request/trip?id=$trip&quotation=$quotation";

    Navigate.bottomSheet(
      sheet: ActivityTripQuotationSend(trip: trip, quotation: quotation, onSend: onSend),
      route: Database.isUserActive ? route : "/guest$route",
      isScrollable: true
    );
  }

  @override
  Widget build(BuildContext context) {
    return CurvedBottomSheet(
      safeArea: true,
      child: GetBuilder<ActivityTripQuotationSendController>(
        init: ActivityTripQuotationSendController(trip: trip, onSend: onSend, quotation: quotation),
        builder: (controller) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  padding: EdgeInsets.all(Sizing.space(2)),
                  margin: EdgeInsets.all(Sizing.space(6)),
                  width: 60,
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColorLight,
                    borderRadius: BorderRadius.circular(16)
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Center(
                    child: Column(
                      children: [
                        SText(
                          text: "Enter amount you think is suitable",
                          size: Sizing.font(16),
                          weight: FontWeight.bold,
                          color: Theme.of(context).primaryColor
                        ),
                        SText(
                          text: "Note: This does not include any material or property expenses, but strictly workmanship fees.",
                          size: Sizing.font(12),
                          color: Theme.of(context).primaryColorLight
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Theme.of(context).scaffoldBackgroundColor
                    ),
                    padding: const EdgeInsets.all(8),
                    child: Obx(() => SText(
                      text: CommonUtility.getAmount(controller.state.amount.value),
                      size: Sizing.font(18),
                      weight: FontWeight.bold,
                      color: Theme.of(context).primaryColor
                    ))
                  ),
                  const SizedBox(height: 20),
                  Field(
                    padding: const EdgeInsets.all(8),
                    hintText: "Amount",
                    keyboard: TextInputType.number,
                    controller: controller.amountController,
                  ),
                  const SizedBox(height: 50),
                  Obx(() => LoadingButton(
                    text: "Send",
                    borderRadius: 24,
                    padding: EdgeInsets.all(Sizing.space(12)),
                    textSize: Sizing.font(14),
                    width: MediaQuery.sizeOf(context).width,
                    onClick: controller.send,
                    buttonColor: CommonColors.darkTheme2,
                    textColor: CommonColors.lightTheme,
                    loading: controller.state.isSending.value,
                  ))
                ],
              )
            ],
          );
        }
      )
    );
  }
}