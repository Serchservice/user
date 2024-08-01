import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:user/library.dart';

/// ?email_address=:emailAddress&referral=:code
class SignupLayout extends GetResponsiveView<SignupController> {
  static const String route = "/auth/signup";
  SignupLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      goDark: true,
      backgroundColor: CommonColors.darkTheme,
      child: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(Sizing.space(16)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Image.asset(
                    Media.logo,
                    width: 100,
                    color: CommonColors.lightTheme,
                  ),
                ],
              ),
              const LineHeader(
                header: "Your Profile",
                footer: "Tell us a bit about yourself",
                color: CommonColors.lightTheme,
              ),
              const SizedBox(height: 30),
              Form(
                key: controller.formkey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    Field(
                      noEnabledColor: true,
                      needLabel: true,
                      labelColor: CommonColors.lightTheme,
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
                      labelColor: CommonColors.lightTheme,
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
                    Obx(() => Field(
                      noEnabledColor: true,
                      needLabel: true,
                      labelColor: CommonColors.lightTheme,
                      hintText: "Referral Code",
                      controller: controller.referralController,
                      enabled: controller.state.referral.isEmpty,
                    )),
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
                        controller.state.countryCode.value = value.countryCode;
                        controller.state.isoCode.value = value.countryISOCode;
                      },
                      onCountryChanged: (value) {
                        controller.state.country.value = value.name;
                      },
                    ),
                    const SizedBox(height: 20),
                    SText(
                      text: "Gender",
                      size: Sizing.font(11),
                      color: CommonColors.lightTheme
                    ),
                    const SizedBox(height: 2),
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
                          selectedBgColor: CommonColors.lightTheme,
                          unSelectedBgColor: CommonColors.darkTheme2,
                        );
                      }).toList(),
                    )),
                    const SizedBox(height: 20),
                    Obx(() => Field.password(
                      hintText: "Create your password",
                      noEnabledColor: true,
                      needLabel: true,
                      labelColor: CommonColors.lightTheme,
                      controller: controller.passwordController,
                      keyboard: TextInputType.visiblePassword,
                      onPressed: () => controller.toggle(),
                      isBig: false,
                      icon: controller.state.isVisible.value
                        ? Icons.lock_rounded
                        : Icons.lock_open_rounded,
                      obscureText: controller.state.isVisible.value,
                      validate: (p1) {
                        if(p1 != null && !p1.contains(RegExp(r'[A-Z]'))) {
                          return "Password must contain a capital letter";
                        }
                        if(p1 != null && !p1.contains(RegExp(r'[a-z]'))) {
                          return "Password must contain a small letter";
                        }
                        if(p1 != null && !p1.contains(RegExp(r'[0-9]'))) {
                          return "Password must contain a number";
                        }
                        if(p1 != null && !p1.contains(RegExp(r'[@-Z]'))) {
                          return "Password must contain a special character";
                        }
                        if(p1 != null && p1.length < 6) {
                          return "Password must be a minimum of 6 characters";
                        }
                        if(p1 == null) {
                          return "Password cannot be empty";
                        }
                        return null;
                      },
                    )),
                    const SizedBox(height: 60),
                    Center(
                      child: Obx(() => LoadingButton(
                        text: "Signup",
                        borderRadius: 24,
                        width: MediaQuery.of(context).size.width,
                        textSize: Sizing.font(14),
                        buttonColor: CommonColors.darkTheme2,
                        textColor: CommonColors.lightTheme,
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