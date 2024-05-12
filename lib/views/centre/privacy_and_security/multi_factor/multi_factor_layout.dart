import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:user/library.dart';

class MultiFactorLayout extends GetResponsiveView<MultiFactorController> {
  static const String route = "/centre/privacy-and-security/multi-factor";
  MultiFactorLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return ViewLayout(
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
                        width: MediaQuery.of(context).size.width,
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
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: Theme.of(context).appBarTheme.backgroundColor,
                        borderRadius: BorderRadius.circular(24)
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          UsageWidget(
                            header: "Total Codes",
                            value: "${controller.state.usage.value.total}"
                          ),
                          const SizedBox(width: 10),
                          UsageWidget(
                            header: "Total Unused",
                            value: "${controller.state.usage.value.unused}"
                          ),
                          const SizedBox(width: 10),
                          UsageWidget(
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
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          color: CommonColors.shimmerHigh,
                          borderRadius: BorderRadius.circular(24)
                        ),
                      )
                    ),
                  ],
                  if(!controller.state.isFetchingCodes.value) ...[
                    RecoveryCodeWidget(controller: controller)
                  ],
                  const SizedBox(height: 40),
                  LoadingButton(
                    text: "Disable",
                    width: MediaQuery.of(context).size.width,
                    loading: controller.state.isDisabling.value,
                    onClick: () => DisableMultiFactor.open(
                      onSuccess: () => controller.state.hasAuth.value = false
                    ),
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
                  width: MediaQuery.of(context).size.width,
                  loading: controller.state.isFetching.value,
                  onClick: () => controller.init(
                    onSuccess: (mfa) => EnableMultiFactor.open(
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

class UsageWidget extends StatelessWidget {
  const UsageWidget({
    super.key,
    required this.header,
    required this.value
  });

  final String header;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: Sizing.space(8),
          vertical: Sizing.space(16)
        ),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(10)
        ),
        child: Column(
          children: [
            SText(
              text: header,
              color: Theme.of(context).primaryColorLight,
              size: Sizing.font(12),
              weight: FontWeight.bold
            ),
            const SizedBox(height: 5),
            SText(
              text: value,
              color: Theme.of(context).primaryColorLight,
              size: Sizing.font(24),
              weight: FontWeight.bold
            ),
          ],
        )
      ),
    );
  }
}

class RecoveryCodeWidget extends StatelessWidget {
  const RecoveryCodeWidget({
    super.key,
    required this.controller,
  });

  final MultiFactorController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(Sizing.space(16)),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Theme.of(context).appBarTheme.backgroundColor,
        borderRadius: BorderRadius.circular(24)
      ),
      child: Column(
        children: [
          SText(
            text: "Tap on a code to copy",
            color: Theme.of(context).primaryColorLight,
            size: Sizing.font(12),
          ),
          const SizedBox(height: 20),
          GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              crossAxisSpacing: 8,
              mainAxisExtent: 40,
              mainAxisSpacing: 10
            ),
            shrinkWrap: true,
            itemCount: controller.state.codes.length,
            itemBuilder: (context, index) {
              final code = controller.state.codes[index];
              return CodeWidget(code: code);
            },
          ),
        ],
      ),
    );
  }
}

class CodeWidget extends StatelessWidget {
  const CodeWidget({super.key, required this.code});

  final MfaRecoveryCode code;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(6),
        child: Material(
          color: code.isUsed
            ? Theme.of(context).primaryColor
            : Theme.of(context).appBarTheme.backgroundColor,
          borderRadius: BorderRadius.circular(6),
          child: InkWell(
            onTap: () => CommonUtility.copy(code.code),
            child: Padding(
              padding: EdgeInsets.all(Sizing.space(4)),
              child: SText(
                text: code.code,
                decoration: code.isUsed
                  ? TextDecoration.lineThrough
                  : null,
                color: code.isUsed
                  ? Theme.of(context).scaffoldBackgroundColor
                  : Theme.of(context).primaryColorLight,
              )
            ),
          ),
        ),
      ),
    );
  }
}