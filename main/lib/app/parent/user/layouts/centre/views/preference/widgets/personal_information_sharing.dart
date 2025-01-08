import 'package:flutter/cupertino.dart';
import 'package:user/library.dart';
import 'package:flutter/material.dart';

class PersonalInformationSharing extends StatelessWidget {
  final bool isActivated;
  final Function(bool) onClicked;

  const PersonalInformationSharing({super.key, required this.isActivated, required this.onClicked});

  static void open({required bool isActivated, required Function(bool) onClicked}) => Navigate.bottomSheet(
    sheet: PersonalInformationSharing(isActivated: isActivated, onClicked: onClicked),
    route: "/centre/preference?notice=personal_information_sharing",
    isScrollable: true
  );

  @override
  Widget build(BuildContext context) {
    List<ButtonView> items = [
      ButtonView(
        icon: CupertinoIcons.lock_shield_fill,
        body: "Serch will alert you whenever you're about to share sensitive details like phone numbers, "
            "email addresses, passwords, and more in your chats."
      ),
      ButtonView(
        icon: CupertinoIcons.dot_square_fill,
        body: "This feature empowers you to make informed decisions, providing an added layer of protection "
            "while you chat. Stay in control of your conversations."
      )
    ];

    return CurvedBottomSheet(
      padding: EdgeInsets.zero,
      safeArea: true,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        spacing: 15,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            color: CommonUtility.lightenColor(CommonColors.freePlan, 60),
            width: MediaQuery.sizeOf(context).width,
            padding: EdgeInsets.all(12),
            child: Center(
              child: Image(
                image: AssetUtility.image(Media.commonPersonal),
                height: 220,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              spacing: 10,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SText(
                  text: "Protect your privacy, stay informed.",
                  size: Sizing.space(22),
                  weight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                ),
                Column(
                  spacing: 10,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SText(
                      text: "Your safety is our priority.",
                      size: Sizing.space(12),
                      color: Theme.of(context).primaryColor,
                      weight: FontWeight.bold,
                    ),
                    ...items.map((item) => Row(
                      spacing: 6,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(item.icon, color: Theme.of(context).primaryColor),
                        Expanded(
                          child: SText(
                            text: item.body,
                            size: Sizing.space(12),
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ],
                    )),
                  ],
                ),
                SizedBox(height: 30),
                LoadingButton(
                  text: isActivated ? "Don't warn me" : "Activate privacy check",
                  autoSize: false,
                  borderRadius: 24,
                  onClick: () => onClicked.call(!isActivated),
                  width: MediaQuery.sizeOf(context).width,
                  padding: EdgeInsets.all(12),
                  buttonColor: CommonColors.darkTheme,
                  textColor: CommonColors.lightTheme,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}