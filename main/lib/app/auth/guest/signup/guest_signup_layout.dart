import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:user/library.dart';

class GuestSignupLayout extends GetResponsiveView<GuestSignupController> {
  static const String route = "/auth/guest/signup";

  static void to({String link = "", String linkId = ""}) {
    Map<String, String> getParams() {
      Map<String, String> params = <String, String>{};

      if(link.isNotEmpty) {
        params.putIfAbsent("link", () => link);
      }
      if(linkId.isNotEmpty) {
        params.putIfAbsent("link_id", () => linkId);
      }

      return params;
    }

    Navigate.to(route, parameters: getParams());
  }

  GuestSignupLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      child: AuthLayout.scrollable(
        child: Container(
          padding: EdgeInsets.all(Sizing.space(16)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GoBack(icon: Icons.arrow_back_rounded, color: Theme.of(context).primaryColor),
                  Image.asset(
                    Media.logo,
                    width: 100,
                    color: Theme.of(context).primaryColor,
                  ),
                ],
              ),
              LineHeader(
                header: "Your Profile",
                footer: "Personalize your guest experience with your data",
                color: Theme.of(context).primaryColor,
              ),
              const SizedBox(height: 10),
              Form(
                key: controller.formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: MediaQuery.sizeOf(context).width,
                      padding: EdgeInsets.all(Sizing.space(12)),
                      decoration: BoxDecoration(
                        color: Theme.of(context).splashColor,
                        borderRadius: BorderRadius.circular(6)
                      ),
                      child: SText(
                        text: "In order to synchronize all your accounts, we advise that you "
                        "use the same email address for both guest and user accounts.",
                        color: Theme.of(context).primaryColor,
                        size: Sizing.font(9)
                      )
                    ),
                    const SizedBox(height: 20),
                    Avatar.large(avatar: controller.state.avatar.value),
                    const SizedBox(height: 10),
                    LoadingButton(
                      onClick: () => controller.changeAvatar(),
                      padding: EdgeInsets.all(Sizing.space(5)),
                      text: "Upload picture"
                    ),
                    const SizedBox(height: 20),
                    Field(
                      noEnabledColor: true,
                      needLabel: true,
                      labelColor: Theme.of(context).primaryColor,
                      hintText: "First Name",
                      keyboard: TextInputType.name,
                      controller: controller.firstNameController,
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
                      controller: controller.lastNameController,
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
                    Field(
                      noEnabledColor: true,
                      needLabel: true,
                      labelColor: Theme.of(context).primaryColor,
                      hintText: "Email Address",
                      keyboard: TextInputType.emailAddress,
                      controller: controller.emailAddressController,
                      validate: (p1) {
                        if(p1 != null && !GetUtils.isEmail(p1)) {
                          return "Email address is not properly formatted";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    SText(
                      text: "Phone Number",
                      size: Sizing.font(11),
                      color: CommonColors.lightTheme,
                    ),
                    const SizedBox(height: 2),
                    PhoneField(
                      controller: controller.phoneNumberController,
                      onChanged: (value) {
                        log(value);
                      },
                      onCountryChanged: (value) {
                        log(value);
                      },
                    ),
                    const SizedBox(height: 20),
                    SText(
                      text: "Gender",
                      size: Sizing.font(14),
                      color: Theme.of(context).primaryColor
                    ),
                    const SizedBox(height: 10),
                    Obx(() => Wrap(
                      runAlignment: WrapAlignment.spaceBetween,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: 5,
                      runSpacing: 5,
                      children: Gender.values.map((gender) {
                        if(gender == Gender.none) {
                          return Container();
                        }
                        return ButtonSelector(
                          text: gender.value,
                          onTap: (value) => controller.pickGender(gender.key),
                          padding: EdgeInsets.all(Sizing.space(14)),
                          textSize: Sizing.font(12),
                          index: 0,
                          selected: controller.state.gender.value == gender.key,
                          selectedBgColor: Theme.of(context).primaryColorDark,
                          unSelectedBgColor: Theme.of(context).scaffoldBackgroundColor,
                        );
                      }).toList(),
                    )),
                    const SizedBox(height: 60),
                    Center(
                      child: Obx(() => LoadingButton(
                        text: "Create",
                        borderRadius: 24,
                        width: MediaQuery.sizeOf(context).width,
                        textSize: Sizing.font(14),
                        buttonColor: Theme.of(context).primaryColorDark,
                        textColor: Theme.of(context).scaffoldBackgroundColor,
                        onClick: () => controller.save(context),
                        loading: controller.state.isSaving.value
                      )),
                    )
                  ]
                ),
              )
            ],
          ),
        ),
      )
    );
  }
}