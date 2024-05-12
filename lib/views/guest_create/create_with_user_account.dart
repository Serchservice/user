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

  final Connect _connect = Connect();

  TextEditingController passwordController = TextEditingController();
  GlobalKey<FormState> formkey = GlobalKey<FormState>();

  @override
  void initState() {
    if(widget.link.isEmpty) {
      SnackBars.top(message: "Unformatted shared link", type: Snackbar.error);
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
      try {
        var response = await _connect.post(
          endpoint: "/auth/guest/create/existing",
          body: {
            "password": passwordController.text.trim(),
            "link": widget.link,
            "device": Database.device.toJson(),
            "upload": {
              "path": media.path,
              "bytes": media.data,
              "media": media.media.type
            },
          }
        );
        setState(() => isVerifying = false);
        ApiResponse apiResponse = ApiResponse.fromJson(response.data);
        if(apiResponse.isOk) {
          Guest guest = Guest.fromJson(apiResponse.data);
          Database.saveGuest(guest);
          Database.savePreference(Database.preference.copyWith(active: guest.link.linkId));
          Navigate.all(GuestHomeLayout.route);
        } else {
          SnackBars.top(message: apiResponse.message, type: Snackbar.error);
          return;
        }
      } on Exception catch (e) {
        setState(() => isVerifying = false);
        Connect.showError(e);
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
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            LineHeader(
              header: "Hello ${Database.auth.firstName}",
              footer: "Continue with your user account",
              color: Theme.of(context).primaryColor,
            ),
            const SizedBox(height: 10),
            Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.all(Sizing.space(12)),
              decoration: BoxDecoration(
                color: CommonColors.darkTheme2,
                borderRadius: BorderRadius.circular(6)
              ),
              child: SText(
                text: "Note that your profile picture will be replaced if you have an existing "
                "picture on your user account.",
                color: CommonColors.lightTheme,
                size: Sizing.font(9)
              )
            ),
            const SizedBox(height: 20),
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
            ),
            const SizedBox(height: 20),
            Form(
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