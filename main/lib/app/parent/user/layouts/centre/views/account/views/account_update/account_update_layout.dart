import 'package:user/library.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AccountUpdateLayout extends GetResponsiveView<AccountUpdateController> {
  static const String route = "/centre/account/update";

  AccountUpdateLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      appbar: AppBar(
        elevation: 0.5,
        title: SText.center(
          text: "Update account details",
          size: Sizing.font(18),
          weight: FontWeight.bold,
          color: Theme.of(context).primaryColor
        ),
      ),
      child: Obx(() {
        Gender selected = controller.state.gender.value;

        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Column(
                    spacing: 12,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: controller.changeAvatar,
                            child: Avatar(avatar: controller.state.avatar.value, radius: 100)
                          )
                        )
                      ),
                      Container(
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: Theme.of(context).appBarTheme.backgroundColor,
                          borderRadius: BorderRadius.circular(16)
                        ),
                        child: SText(
                          text: "Tap on the picture to change avatar.",
                          size: Sizing.font(12),
                          color: Theme.of(context).primaryColor
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Form(
                  key: controller.formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      Field(
                        noEnabledColor: true,
                        needLabel: true,
                        labelColor: Theme.of(context).primaryColor,
                        hintText: "First Name",
                        keyboard: TextInputType.name,
                        controller: controller.firstName,
                        validate: (p1) {
                          if(p1 != null && p1.length < 3) {
                            return "First name cannot be short";
                          }
                          if(p1 == null) {
                            return "First name cannot be empty";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      Field(
                        noEnabledColor: true,
                        needLabel: true,
                        labelColor: Theme.of(context).primaryColor,
                        hintText: "Last Name",
                        keyboard: TextInputType.name,
                        controller: controller.lastName,
                        validate: (p1) {
                          if(p1 != null && p1.length < 3) {
                            return "Last name cannot be short";
                          }
                          if(p1 == null) {
                            return "Last name cannot be empty";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      SText(
                        text: "Phone Number",
                        size: Sizing.font(14),
                        color: Theme.of(context).primaryColor
                      ),
                      const SizedBox(height: 10),
                      PhoneField(
                        isoCode: controller.state.isoCode.value,
                        controller: controller.phoneNumber,
                        onChanged: (value) {
                          controller.state.countryCode.value = value.countryCode;
                          controller.state.isoCode.value = value.countryISOCode;
                        },
                        onCountryChanged: (value) {
                          controller.state.country.value = value;
                        },
                      ),
                      const SizedBox(height: 20),
                      SText(
                        text: "Gender",
                        size: Sizing.font(14),
                        color: Theme.of(context).primaryColor
                      ),
                      const SizedBox(height: 10),
                      Wrap(
                        runAlignment: WrapAlignment.spaceBetween,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        spacing: 5,
                        runSpacing: 5,
                        children: Gender.values.map((value) {
                          if(value == Gender.none) {
                            return Container();
                          }

                          return ButtonSelector(
                            text: value.value,
                            onTap: (index) => controller.pickGender(value),
                            padding: EdgeInsets.all(Sizing.space(14)),
                            textSize: Sizing.font(12),
                            index: 0,
                            selected: selected.key == value.key,
                            selectedBgColor: Theme.of(context).primaryColor,
                            unSelectedBgColor: Theme.of(context).scaffoldBackgroundColor,
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 60),
                      Center(
                        child: LoadingButton(
                          text: "Update",
                          borderRadius: 24,
                          width: MediaQuery.sizeOf(context).width,
                          textSize: Sizing.font(14),
                          buttonColor: Theme.of(context).primaryColorDark,
                          textColor: Theme.of(context).scaffoldBackgroundColor,
                          onClick: () => controller.sendUpdate(),
                          loading: controller.state.isLoading.value
                        ),
                      )
                    ]
                  ),
                )
              ],
            ),
          ),
        );
      })
    );
  }
}
