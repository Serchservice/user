import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:user/library.dart';

class RequestEntryShopping extends StatelessWidget {
  final RequestEntryController controller;

  const RequestEntryShopping({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
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
                          icon: Icon(CupertinoIcons.trash, color: CommonColors.error)
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
