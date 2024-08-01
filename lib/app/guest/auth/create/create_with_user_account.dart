import 'package:flutter/material.dart';
import 'package:user/library.dart';

class CreateWithUserAccount extends StatefulWidget {
  final String link;
  const CreateWithUserAccount({super.key, required this.link});

  @override
  State<CreateWithUserAccount> createState() => _CreateWithUserAccountState();

  static void open({required String link}) => Navigate.bottomSheet(
    sheet: CreateWithUserAccount(link: link),
    route: "/auth/guest/create/existing/user",
    isScrollable: true
  );
}

class _CreateWithUserAccountState extends State<CreateWithUserAccount> {
  bool isVisible = false;
  bool isVerifying = false;
  SelectedMedia media = SelectedMedia(path: "");
  String avatar = "";

  final ConnectService _connect = Connect();

  TextEditingController passwordController = TextEditingController();
  GlobalKey<FormState> formkey = GlobalKey<FormState>();

  @override
  void initState() {
    if(widget.link.isEmpty) {
      notify.error(message: "Unformatted shared link");
      Future.delayed(const Duration(milliseconds: 500), () {
        Navigate.back();
      });
    }
    super.initState();
  }

  @override
  void dispose() {
    passwordController.dispose();
    super.dispose();
  }

  void toggle() {
    setState(() => isVisible = !isVisible);
  }

  void changeAvatar() {
    RouteNavigator.openMedia(
      onReceived: (result) {
        Navigate.back();
        setState(() {
          avatar = result.path;
          media = result;
        });
      },
      galleryParam: {
        "isVideo": "false",
        "title": "Pick your avatar"
      },
      route: "/auth/guest/create/user/avatar"
    );
  }

  void create(BuildContext context) async {
    CommonUtility.unfocus(context);

    if(formkey.currentState != null && formkey.currentState!.validate()) {
      setState(() => isVerifying = true);
      var response = await _connect.post(
        endpoint: "/auth/guest/create/existing",
        body: {
          "password": passwordController.text.trim(),
          "link": widget.link,
          "device": Database.device.toJson(),
          "state": Database.address.state,
          "country": Database.address.country,
          "upload": {
            "path": media.path,
            "bytes": media.data,
            "media": media.media.type
          },
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
              child: LineHeader(
                header: "Hello ${Database.auth.firstName}",
                footer: "Continue with your user account",
                color: Theme.of(context).primaryColor,
              ),
            ),
            const SizedBox(height: 10),
            if(Database.auth.avatar.isEmpty) ...[
              Row(
                children: [
                  Avatar.large(avatar: avatar),
                  const SizedBox(width: 20),
                  LoadingButton(
                    onClick: () => changeAvatar(),
                    padding: EdgeInsets.all(Sizing.space(5)),
                    text: "Upload picture"
                  )
                ],
              )
            ] else ...[
              Center(child: Avatar.large(avatar: Database.auth.avatar))
            ],
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: formkey,
                child: Field.password(
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
                    if(p1 == null) {
                      return "Password cannot be empty";
                    }
                    return null;
                  },
                )
              ),
            ),
            const SizedBox(height: 50),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                LoadingButton(
                  text: "Create",
                  borderRadius: 24,
                  isCircular: false,
                  textSize: Sizing.font(14),
                  loading: isVerifying,
                  onClick: () => create(context),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}