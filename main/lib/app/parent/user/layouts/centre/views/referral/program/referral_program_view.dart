import 'package:user/library.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ReferralProgramView extends StatelessWidget {
  const ReferralProgramView({super.key});

  static void open() {
    Navigate.bottomSheet(
      sheet: ReferralProgramView(),
      route: "/centre/referral/program",
      isScrollable: true
    );
  }

  @override
  Widget build(BuildContext context) {
    return CurvedBottomSheet(
      padding: EdgeInsets.zero,
      child: GetX<ReferralProgramViewController>(
        init: ReferralProgramViewController(),
        builder: (controller) {
          bool isFetchingProgram = controller.state.isFetching.value;

          return SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    padding: EdgeInsets.all(Sizing.space(2)),
                    margin: EdgeInsets.all(Sizing.space(10)),
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
                    text: "Referral Program Information",
                    size: Sizing.font(16),
                    weight: FontWeight.bold,
                    color: Theme.of(context).primaryColor
                  ),
                ),
                const SizedBox(height: 10),
                if(isFetchingProgram) ...[
                  LoadingShimmer(
                    content: Container(
                      width: MediaQuery.sizeOf(context).width,
                      height: 200,
                      color: CommonColors.shimmerHigh,
                    )
                  )
                ] else ...[
                  Container(
                    width: MediaQuery.sizeOf(context).width,
                    padding: EdgeInsets.all(12),
                    color: CommonUtility.lightenColor(CommonColors.allday, 45),
                    child: Center(child: Image(image: AssetUtility.image(Media.commonReferralProgram), height: 220)),
                  )
                ],
                const SizedBox(height: 10),
                if(isFetchingProgram) ...[
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: LoadingShimmer(
                      content: Container(
                        width: MediaQuery.sizeOf(context).width,
                        height: 100,
                        decoration: BoxDecoration(
                          color: CommonColors.shimmerHigh,
                          borderRadius: BorderRadius.circular(16)
                        ),
                      )
                    ),
                  )
                ] else ...[
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 4,
                      children: [
                        SText(
                          text: "Hello ${controller.state.program.value.name},",
                          size: Sizing.font(16),
                          weight: FontWeight.bold,
                          color: Theme.of(context).primaryColor
                        ),
                        SText(
                          text: "It is worthy to note that as at this moment, our referral programs have limited timeframes. "
                              "This means that, when you exhaust your timeframe, you stop enjoying the benefit of referring.",
                          size: Sizing.font(14),
                          color: Theme.of(context).primaryColor
                        ),
                      ],
                    ),
                  ),
                ],
                if(isFetchingProgram) ...[
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: LoadingShimmer(
                      content: Row(
                        spacing: 12,
                        children: [
                          Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              color: CommonColors.shimmerHigh,
                              borderRadius: BorderRadius.circular(16)
                            ),
                          ),
                          Container(
                            width: 2,
                            height: 30,
                            decoration: BoxDecoration(
                              color: CommonColors.shimmerHigh,
                              borderRadius: BorderRadius.circular(16)
                            ),
                          ),
                          Expanded(
                            child: ConstrainedBox(
                              constraints: BoxConstraints(maxHeight: 60),
                              child: ListView.separated(
                                itemCount: 10,
                                shrinkWrap: true,
                                scrollDirection: Axis.horizontal,
                                separatorBuilder: (context, index) {
                                  return SizedBox(width: 12);
                                },
                                itemBuilder: (context, index) {
                                  return Container(
                                    width: 50,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      color: CommonColors.shimmerHigh,
                                      shape: BoxShape.circle
                                    ),
                                  );
                                },
                              ),
                            ),
                          )
                        ],
                      )
                    ),
                  )
                ] else ...[
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      spacing: 12,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Material(
                            color: Theme.of(context).scaffoldBackgroundColor,
                            child: InkWell(
                              onTap: controller.copyLink,
                              child: Padding(
                                padding: EdgeInsets.all(12),
                                child: Icon(
                                  CupertinoIcons.circle_grid_hex_fill,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Container(width: 2, height: 30, color: CommonColors.hint),
                        Expanded(
                          child: ConstrainedBox(
                            constraints: BoxConstraints(maxHeight: 60),
                            child: ListView.separated(
                              itemCount: ShareSheetButton.options.length,
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              separatorBuilder: (context, index) {
                                return SizedBox(width: 12);
                              },
                              itemBuilder: (context, index) {
                                return ShareSheetButton(
                                  share: ShareSheetButton.options[index],
                                  message: controller.message,
                                  data: controller.state.program.value.referralCode,
                                  withTitle: false,
                                );
                              },
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ],
            ),
          );
        }
      ),
    );
  }
}
