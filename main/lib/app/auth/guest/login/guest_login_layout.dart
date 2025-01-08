import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:user/library.dart';

class GuestLoginLayout extends GetResponsiveView<GuestLoginController> {
  static const String route = "/auth/guest/login";

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

  GuestLoginLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      child: AuthLayout(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: controller.formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    LineHeader(
                      header: "Have a guest account?",
                      footer: "Login with your guest email address.",
                      color: Theme.of(context).primaryColor,
                    ),
                    const SizedBox(height: 30),
                    Field(
                      hintText: "Email Address",
                      enabled: true,
                      textSize: Sizing.font(15),
                      controller: controller.emailController,
                      inputAction: TextInputAction.next,
                      keyboard: TextInputType.emailAddress,
                      validate: (p1) {
                        if(p1 != null && !GetUtils.isEmail(p1)) {
                          return "Input a valid email address";
                        }
                        return null;
                      },
                    ),
                    Obx(() {
                      if(controller.hasLink) {
                        return Container();
                      } else {
                        return Column(
                          children: [
                            const SizedBox(height: 20),
                            Field(
                              hintText: "Shared Link",
                              enabled: true,
                              textSize: Sizing.font(15),
                              controller: controller.linkController,
                              inputAction: TextInputAction.done,
                              keyboard: TextInputType.url,
                              validate: (p1) {
                                if(p1 != null && !GetUtils.isURL(p1)) {
                                  return "Input a valid url address";
                                }
                                return null;
                              },
                            ),
                          ],
                        );
                      }
                    })
                  ],
                ),
              ),
            ),
            const SizedBox(height: 150),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Obx(() => LoadingButton(
                  text: "Login",
                  borderRadius: 24,
                  isCircular: false,
                  textSize: Sizing.font(14),
                  loading: controller.state.isVerifying.value,
                  onClick: () => controller.login(context),
                ))
              ],
            ),
          ],
        ),
      ),
    );
  }
}