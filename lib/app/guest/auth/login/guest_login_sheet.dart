import 'package:flutter/material.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:user/library.dart';

class GuestLoginSheet extends StatefulWidget {
  final String link;
  final String linkId;
  const GuestLoginSheet({super.key, required this.link, required this.linkId});

  @override
  State<GuestLoginSheet> createState() => _GuestLoginSheetState();

  static void open({String link = "", String linkId = ""}) => Navigate.bottomSheet(
    sheet: GuestLoginSheet(link: link, linkId: linkId),
    route: "/auth/guest/login",
    isScrollable: true
  );
}

class _GuestLoginSheetState extends State<GuestLoginSheet> {
  final ConnectService _connect = Connect(useToken: false);
  TextEditingController emailController = TextEditingController();
  String link = "";
  bool isLoading = false;

  void login() async {
    if(GetUtils.isEmail(emailController.text)) {
      setState(() => isLoading = true);
      var response = await _connect.post(endpoint: "/auth/guest/login", body: {
        "token": "",
        "link": widget.link,
        "link_id": widget.linkId,
        "email_address": emailController.text,
        "state": Database.address.state,
        "country": Database.address.country,
      });
      setState(() => isLoading = false);
      if(response.isOk) {
        Guest guest = Guest.fromJson(response.data);
        Database.saveGuest(guest);
        Database.savePreference(Database.preference.copyWith(active: widget.linkId));
        Navigate.all(GuestHomeLayout.route);
      } else {
        notify.error(message: response.message);
        return;
      }
    }
  }

  @override
  void initState() {
    link = widget.link;
    super.initState();
  }

  @override
  void dispose() {
    emailController.dispose();
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
                  text: "Login as Guest",
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
          Field(
            noEnabledColor: true,
            needLabel: true,
            hintText: "Guest EmailAddress",
            keyboard: TextInputType.emailAddress,
            controller: emailController,
            labelColor: Theme.of(context).primaryColor,
          ),
          const SizedBox(height: 15),
          LoadingButton(
            text: "Login",
            borderRadius: 24,
            width: MediaQuery.sizeOf(context).width,
            textSize: Sizing.font(12),
            buttonColor: Theme.of(context).primaryColorDark,
            textColor: Theme.of(context).scaffoldBackgroundColor,
            onClick: () => login(),
            loading: isLoading
          )
        ],
      )
    );
  }
}