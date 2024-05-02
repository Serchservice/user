import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:user/library.dart';

class OnboardingLayout extends StatefulWidget {
  static String get route => "/auth/onboarding";

  const OnboardingLayout({super.key});

  @override
  State<OnboardingLayout> createState() => _OnboardingLayoutState();
}

class _OnboardingLayoutState extends State<OnboardingLayout> {
  final PageController _onboardPageController = PageController();

  @override
  void initState() {
    super.initState();
    _onboardPageController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _onboardPageController.dispose();
    super.dispose();
  }

  final Duration moveDuration = const Duration(seconds: 1);
  final Curve moveCurve = Curves.decelerate;

  @override
  Widget build(BuildContext context) {
    List<Widget> designViews = [
      OnboardingDesign1(
        onboardPageController: _onboardPageController,
        moveDuration: moveDuration,
        moveCurve: moveCurve
      ),
      OnboardingDesign2(
        onboardPageController: _onboardPageController,
        moveDuration: moveDuration,
        moveCurve: moveCurve
      )
    ];

    return ViewLayout(
      child: SizedBox(
        height: Get.height,
        width: Get.width,
        child: Padding(
          padding: EdgeInsets.all(Sizing.space(24)),
          child: Column(
            children: [
              Expanded(
                child: PageView.builder(
                  controller: _onboardPageController,
                  itemCount: designViews.length,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) => designViews[index],
                ),
              ),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: "Tap “Agree and continue” to accept Serchservice ",
                      style: TextStyle(
                        fontSize: Sizing.font(13),
                        color: Theme.of(context).primaryColor,
                        fontFamily: AppTheme.mainFont.fontFamily
                      ),
                    ),
                    TextSpan(
                      text: "Terms of Service",
                      style: TextStyle(
                        fontSize: Sizing.font(13),
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold,
                        fontFamily: AppTheme.mainFont.fontFamily,
                        decoration: TextDecoration.underline
                      ),
                      recognizer: TapGestureRecognizer()..onTap = () => NavigatorUtility.openWeb(
                        header: Links.termsHeader,
                        url: Links.termsUrl
                      ),
                    ),
                    TextSpan(
                      text: ", ",
                      style: TextStyle(
                        fontSize: Sizing.font(13),
                        color: Theme.of(context).primaryColor,
                        fontFamily: AppTheme.mainFont.fontFamily
                      ),
                    ),
                    TextSpan(
                      text: "privacy policy and others.",
                      style: TextStyle(
                        fontSize: Sizing.font(13),
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold,
                        fontFamily: AppTheme.mainFont.fontFamily,
                        decoration: TextDecoration.underline
                      ),
                      recognizer: TapGestureRecognizer()..onTap = () {
                        NavigatorUtility.openWeb(
                          header: Links.privacyHeader,
                          url: Links.privacyUrl
                        );
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: LoadingButton(
                  text: "Agree and continue",
                  borderRadius: 24,
                  textSize: Sizing.font(14),
                  onClick: () => Navigate.off(EmailCheckerLayout.route),
                )
              )
            ]
          ),
        ),
      ),
    );
  }
}