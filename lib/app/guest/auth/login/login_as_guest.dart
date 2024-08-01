import 'package:flutter/material.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:user/library.dart';

class LoginAsGuest extends StatefulWidget {
  const LoginAsGuest({super.key});

  @override
  State<LoginAsGuest> createState() => _LoginAsGuestState();

  static void open() => Navigate.bottomSheet(
      sheet: const LoginAsGuest(),
      route: "/auth/guest/login",
      isScrollable: true
  );
}

class _LoginAsGuestState extends State<LoginAsGuest> {
  bool isVerifying = false;

  final ConnectService _connect = Connect(useToken: false);

  final TextEditingController emailController = TextEditingController();
  final TextEditingController linkController = TextEditingController();
  GlobalKey<FormState> formkey = GlobalKey<FormState>();

  @override
  void dispose() {
    linkController.dispose();
    emailController.dispose();
    super.dispose();
  }

  void login(BuildContext context) async {
    CommonUtility.unfocus(context);

    if(formkey.currentState != null && formkey.currentState!.validate()) {
      setState(() => isVerifying = true);
      var response = await _connect.post(
          endpoint: "/auth/guest/login",
          body: {
            "email_address": emailController.text.trim(),
            "link": linkController.text.trim(),
            "state": Database.address.state,
            "country": Database.address.country,
          }
      );
      setState(() => isVerifying = false);
      if(response.isOk) {
        Guest guest = Guest.fromJson(response.data);
        Database.saveGuest(guest);
        Database.savePreference(Database.preference.copyWith(active: guest.link.linkId));
        Navigate.all(GuestHomeLayout.route);
      } else {
        notify.error(message: response.message);
        return;
      }
    } else {
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return CurvedBottomSheet(
      safeArea: true,
      padding: EdgeInsets.zero,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: formkey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    LineHeader(
                      header: "Have a guest account?",
                      footer: "Login now!",
                      color: Theme.of(context).primaryColor,
                    ),
                    const SizedBox(height: 30),
                    Field(
                      hintText: "Email Address",
                      enabled: true,
                      textSize: Sizing.font(15),
                      controller: emailController,
                      inputAction: TextInputAction.next,
                      keyboard: TextInputType.emailAddress,
                      validate: (p1) {
                        if(p1 != null && !GetUtils.isEmail(p1)) {
                          return "Input a valid email address";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    Field(
                      hintText: "Shared Link",
                      enabled: true,
                      textSize: Sizing.font(15),
                      controller: linkController,
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
                ),
              ),
            ),
            const SizedBox(height: 50),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                LoadingButton(
                  text: "Login",
                  borderRadius: 24,
                  isCircular: false,
                  textSize: Sizing.font(14),
                  loading: isVerifying,
                  onClick: () => login(context),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}