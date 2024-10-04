import 'package:flutter/material.dart';
import 'package:user/library.dart';

class GuestBecomeUser extends StatefulWidget {
  final String guestId;
  final String linkId;
  const GuestBecomeUser({super.key, required this.guestId, required this.linkId});

  @override
  State<GuestBecomeUser> createState() => _GuestBecomeUserState();

  static void open({required String guestId, required String linkId}) => Navigate.bottomSheet(
    sheet: GuestBecomeUser(guestId: guestId, linkId: linkId),
    route: "/auth/guest/switch?scope=become&role=user",
    isScrollable: true
  );
}

class _GuestBecomeUserState extends State<GuestBecomeUser> {
  final ConnectService _connect = Connect(useToken: false);

  TextEditingController passwordController = TextEditingController();
  GlobalKey<FormState> formkey = GlobalKey<FormState>();
  TextEditingController phoneController = TextEditingController();

  String countryCode = "";
  String isoCode = "";
  String country = "";
  bool isLoading = false;
  bool isVisible = false;

  void toggle() {
    setState(() => isVisible = !isVisible);
  }

  void becomeAUser(BuildContext context) async {
    CommonUtility.unfocus(context);

    if(formkey.currentState != null && formkey.currentState!.validate()) {
      setState(() => isLoading = true);
      var response = await _connect.post(
          endpoint: "/guest/user/become",
          body: {
            "password": passwordController.text.trim(),
            "link_id": widget.linkId,
            "guest_id": widget.guestId,
            "device": Database.device.toJson(),
            "phone_information": {
              "phone_number": phoneController.text.trim(),
              "country_code": countryCode,
              "iso_code": isoCode,
              "country": country
            },
          }
      );
      setState(() => isLoading = false);
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
  void initState() {
    if(Database.countries.isNotEmpty) {
      Country current = Database.countries.firstWhere((country) {
        return Database.address.country == country.name;
      },
        orElse: () => Database.countries.first
      );
      setState(() {
        isoCode = current.code;
        countryCode = current.dialCode;
        country = current.name;
      });
    }
    super.initState();
  }

  @override
  void dispose() {
    passwordController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CurvedBottomSheet(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              padding: EdgeInsets.all(Sizing.space(2)),
              width: 100,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColorLight,
                borderRadius: BorderRadius.circular(16)
              ),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: SText(
                  text: "Become a user",
                  color: Theme.of(context).primaryColor,
                  size: Sizing.font(24),
                  weight: FontWeight.bold,
                ),
              ),
              GoBack(
                color: Theme.of(context).primaryColor,
                icon: Icons.close
              )
            ],
          ),
          const Divider(),
          const SizedBox(height: 15),
          Form(
            key: formkey,
            child: Column(
              children: [
                SText(
                  text: "Phone Number",
                  size: Sizing.font(11),
                  color: Theme.of(context).scaffoldBackgroundColor,
                ),
                const SizedBox(height: 2),
                PhoneField(
                  controller: phoneController,
                  onChanged: (value) {
                    setState(() {
                      isoCode = value.countryISOCode;
                      countryCode = value.countryCode;
                    });
                  },
                  onCountryChanged: (value) {
                    setState(() {
                      country = value.name;
                    });
                  },
                ),
                const SizedBox(height: 20),
                Field.password(
                  hintText: "Password",
                  enabled: true,
                  textSize: Sizing.font(15),
                  controller: passwordController,
                  keyboard: TextInputType.visiblePassword,
                  inputAction: TextInputAction.done,
                  onPressed: () => toggle(),
                  icon: !isVisible
                    ? Icons.lock_rounded
                    : Icons.lock_open_rounded,
                  obscureText: !isVisible,
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
                ),
              ],
            )
          ),
          const SizedBox(height: 15),
          LoadingButton(
            text: "Continue",
            borderRadius: 24,
            width: MediaQuery.sizeOf(context).width,
            textSize: Sizing.font(12),
            buttonColor: Theme.of(context).primaryColorDark,
            textColor: Theme.of(context).scaffoldBackgroundColor,
            onClick: () => becomeAUser(context),
            loading: isLoading
          )
        ],
      )
    );
  }
}