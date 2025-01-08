import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:user/library.dart';

class MultiFactorLayout extends GetResponsiveView<MultiFactorController> {
  static const String route = "/centre/privacy-and-security/multi-factor";
  MultiFactorLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      appbar: AppBar(
        elevation: 0.5,
        title: SText.center(
          text: "Two-Factor Authentication",
          size: Sizing.font(20),
          weight: FontWeight.bold,
          color: Theme.of(context).primaryColor
        ),
      ),
      child: Obx(() {
        if(controller.state.hasAuth.value) {
          return SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(Sizing.space(16)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      padding: EdgeInsets.all(Sizing.space(12)),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Theme.of(context).primaryColor
                      ),
                      child: Icon(
                        Icons.security_rounded,
                        size: 100,
                        color: Theme.of(context).appBarTheme.backgroundColor
                      )
                    )
                  ),
                  const SizedBox(height: 40),
                  SText(
                    text: "Recovery Code Metrics",
                    color: Theme.of(context).primaryColor,
                    size: Sizing.font(14),
                    weight: FontWeight.bold
                  ),
                  const SizedBox(height: 5),
                  if(controller.state.isFetchingUsage.value) ...[
                    LoadingShimmer(
                      content: Container(
                        height: 200,
                        width: MediaQuery.sizeOf(context).width,
                        decoration: BoxDecoration(
                          color: CommonColors.shimmerHigh,
                          borderRadius: BorderRadius.circular(24)
                        ),
                      )
                    ),
                  ],
                  if(!controller.state.isFetchingUsage.value) ...[
                    Container(
                      padding: EdgeInsets.all(Sizing.space(16)),
                      width: MediaQuery.sizeOf(context).width,
                      decoration: BoxDecoration(
                        color: Theme.of(context).appBarTheme.backgroundColor,
                        borderRadius: BorderRadius.circular(24)
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        spacing: 10,
                        children: [
                          MultiFactorCodeUsage(
                            header: "Total Codes",
                            value: "${controller.state.usage.value.total}"
                          ),
                          MultiFactorCodeUsage(
                            header: "Total Unused",
                            value: "${controller.state.usage.value.unused}"
                          ),
                          MultiFactorCodeUsage(
                            header: "Total Used",
                            value: "${controller.state.usage.value.used}"
                          ),
                        ],
                      ),
                    )
                  ],
                  const SizedBox(height: 40),
                  SText(
                    text: "Recovery Codes",
                    color: Theme.of(context).primaryColor,
                    size: Sizing.font(14),
                    weight: FontWeight.bold
                  ),
                  const SizedBox(height: 5),
                  if(controller.state.isFetchingCodes.value) ...[
                    LoadingShimmer(
                      content: Container(
                        height: 300,
                        width: MediaQuery.sizeOf(context).width,
                        decoration: BoxDecoration(
                          color: CommonColors.shimmerHigh,
                          borderRadius: BorderRadius.circular(24)
                        ),
                      )
                    ),
                  ],
                  if(!controller.state.isFetchingCodes.value) ...[
                    MultiFactorCodeView(controller: controller)
                  ],
                  const SizedBox(height: 40),
                  LoadingButton(
                    text: "Disable",
                    width: MediaQuery.sizeOf(context).width,
                    loading: controller.state.isDisabling.value,
                    onClick: () async {
                      dynamic result = await Navigate.to(MfaAuthLayout.disableRoute);
                      if(result != null && result is bool && result) {
                        controller.state.hasAuth.value = false;
                      }
                    },
                  )
                ],
              ),
            )
          );
        } else {
          return Padding(
            padding: EdgeInsets.all(Sizing.space(16)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(
                  child: Container(
                    padding: EdgeInsets.all(Sizing.space(12)),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Theme.of(context).primaryColor
                    ),
                    child: Icon(
                      Icons.security_rounded,
                      size: 100,
                      color: Theme.of(context).appBarTheme.backgroundColor
                    )
                  )
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: SText(
                    text: "Two-Factor authentication enables you to verify your identity whenever you"
                    " leave the platform. This adds an extra layer of security to your account, making it"
                    " private and secure.\n"
                    "REMEMBER: You are responsible for your account security, as we do our best to provide"
                    " all the tools you will need for it.",
                    color: Theme.of(context).primaryColor,
                    size: Sizing.font(14),
                  ),
                ),
                const SizedBox(height: 10),
                LoadingButton(
                  text: "Enable",
                  width: MediaQuery.sizeOf(context).width,
                  loading: controller.state.isFetching.value,
                  onClick: () => controller.init(
                    onSuccess: (mfa) => MultiFactorEnabler.open(
                      mfa: mfa,
                      onSuccess: () {
                        controller.state.hasAuth.value = true;
                        controller.fetchCodes();
                        controller.fetchUsage();
                      }
                    )
                  ),
                )
              ],
            ),
          );
        }
      })
    );
  }
}