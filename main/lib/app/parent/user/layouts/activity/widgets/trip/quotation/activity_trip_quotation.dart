import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:user/library.dart';

class ActivityTripQuotation extends StatelessWidget {
  final QuotationResponse quotation;
  final String trip;
  final VoidCallback onRemoved;
  final Function(TripResponse) onAccepted;
  final Function(TripResponse) onUpdated;

  const ActivityTripQuotation({
    super.key,
    required this.quotation,
    required this.trip,
    required this.onRemoved,
    required this.onAccepted,
    required this.onUpdated
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ActivityTripQuotationController>(
      init: ActivityTripQuotationController(
        quotation: quotation,
        onAccepted: onAccepted,
        onRemoved: onRemoved,
        trip: trip,
        onUpdated: onUpdated
      ),
      builder: (controller) {
        return Container(
          margin: EdgeInsets.symmetric(vertical: Sizing.space(6)),
          width: MediaQuery.sizeOf(context).width,
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
                  crossAxisCount: controller.buttons.length,
                  crossAxisSpacing: 10,
                  mainAxisExtent: 35
                ),
                itemCount: controller.buttons.length,
                shrinkWrap: true,
                itemBuilder: (context, index) => controller.buildButton(controller.buttons[index])
              )
            ],
          ),
        );
      }
    );
  }
}