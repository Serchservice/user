import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:user/library.dart';

class QuotationView extends StatelessWidget {
  final QuotationResponse quotation;
  final String trip;
  final VoidCallback onRemove;
  final Function(TripResponse) onAccept;
  final Function(TripResponse) onUpdate;

  const QuotationView({
    super.key,
    required this.quotation,
    required this.trip,
    required this.onRemove,
    required this.onAccept,
    required this.onUpdate
  });

  @override
  Widget build(BuildContext context) {
    List<ButtonView> buttons = [
      ButtonView(header: "Accept", color: CommonColors.success, index: 0),
      ButtonView(header: "Send quote", color: CommonColors.allday, index: 1),
      ButtonView(header: "Decline", color: CommonColors.error, index: 2),
    ];

    return GetBuilder<QuotationViewController>(
      init: QuotationViewController(
        quotation: quotation,
        onAccept: onAccept,
        onRemove: onRemove,
        trip: trip
      ),
      builder: (controller) {
        return Container(
          margin: EdgeInsets.symmetric(vertical: Sizing.space(6)),
          width: MediaQuery.of(context).size.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Avatar.small(avatar: quotation.avatar),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: SText(
                                text: quotation.name,
                                size: Sizing.font(14),
                                weight: FontWeight.bold,
                                flow: TextOverflow.ellipsis,
                                color: Theme.of(context).primaryColor
                              ),
                            ),
                            SText(
                              text: quotation.amount,
                              size: Sizing.font(14),
                              weight: FontWeight.bold,
                              color: Theme.of(context).primaryColor
                            ),
                          ],
                        ),
                        const SizedBox(height: 5),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: SText(
                                text: quotation.distance,
                                size: Sizing.font(14),
                                flow: TextOverflow.ellipsis,
                                color: Theme.of(context).primaryColor
                              ),
                            ),
                            RatingIcon(rating: quotation.rating)
                          ],
                        ),
                      ]
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: buttons.length,
                  crossAxisSpacing: 10,
                  mainAxisExtent: 35
                ),
                itemCount: buttons.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  ButtonView view = buttons[index];

                  if(view.index == 1) {
                    return LoadingButton(
                      text: view.header,
                      buttonColor: CommonColors.darkTheme,
                      textColor: CommonColors.lightTheme,
                      padding: EdgeInsets.zero,
                      loading: view.index == 0
                          ? controller.state.isAccepting.value
                          : view.index == 1
                          ? false
                          : controller.state.isDeclining.value,
                      onClick: () {
                        if(view.index == 0) {
                          controller.accept();
                        } else if(view.index == 1) {
                          QuotationSheet.open(trip: trip, quotation: quotation.id, onSend: onUpdate);
                        } else {
                          controller.decline();
                        }
                      }
                    );
                  } else {
                    return Obx(() => LoadingButton(
                      text: view.header,
                      buttonColor: CommonColors.darkTheme,
                      textColor: CommonColors.lightTheme,
                      padding: EdgeInsets.zero,
                      loading: view.index == 0
                          ? controller.state.isAccepting.value
                          : view.index == 1
                          ? false
                          : controller.state.isDeclining.value,
                      onClick: () {
                        if(view.index == 0) {
                          controller.accept();
                        } else if(view.index == 1) {
                          QuotationSheet.open(trip: trip, quotation: quotation.id, onSend: onUpdate);
                        } else {
                          controller.decline();
                        }
                      }
                    ));
                  }
                }
              )
            ],
          ),
        );
      }
    );
  }
}
