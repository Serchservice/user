import 'package:flutter/material.dart';
import 'package:user/library.dart';

class EditProfile extends StatefulWidget {
  final Profile profile;
  final AccountController controller;
  const EditProfile({
    super.key,
    required this.profile,
    required this.controller,
  });

  @override
  State<EditProfile> createState() => _EditProfileState();

  static void open({
    required Profile profile,
    required AccountController controller,
  }) => Navigate.bottomSheet(
    sheet: EditProfile(
      profile: profile,
      controller: controller,
    ),
    route: "/centre/account/edit/profile",
    background: Colors.transparent,
    isScrollable: true,
    safeArea: true
  );
}

class _EditProfileState extends State<EditProfile> {
  final ConnectService _connect = Connect();
  final HomeController home = HomeController.data;

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController firstName = TextEditingController();
  TextEditingController lastName = TextEditingController();
  TextEditingController phoneNumber = TextEditingController();

  String avatar = "";
  String countryCode = "";
  String isoCode = "";
  Gender gender = Gender.none;
  Country country = Country.primary();
  bool isLoading = false;
  SelectedMedia media = SelectedMedia(path: "");

  @override
  void initState() {
    firstName.text = widget.profile.firstName;
    lastName.text = widget.profile.lastName;
    phoneNumber.text = widget.profile.phoneInfo.phoneNumber;
    avatar = widget.profile.avatar;
    gender = (widget.profile.gender).toGender();
    isoCode = widget.profile.phoneInfo.isoCode;
    super.initState();
  }

  @override
  void dispose() {
    firstName.dispose();
    lastName.dispose();
    phoneNumber.dispose();
    super.dispose();
  }

  void update() async {
    setState(() {
      isLoading = true;
    });
    var response = await _connect.patch(endpoint: "/profile/update", body: {
      "phone": {
        "phone_number": phoneNumber.text.trim(),
        "country_code": countryCode,
        "iso_code": isoCode,
        "country": country.name
      },
      "first_name": firstName.text.trim(),
      "last_name": lastName.text.trim(),
      "gender": gender.key,
      "upload": {
        "path": media.path,
        "bytes": media.data,
        "media": media.media.type
      }
    });
    if(mounted) {
      setState(() {
        isLoading = false;
      });
    }
    if(response.isOk) {
      Profile profile = Profile.fromJson(response.data);
      Database.saveAuth(Database.auth.copyWith(avatar: profile.avatar, firstName: profile.firstName, lastName: profile.lastName));
      home.state.avatar.value = profile.avatar;
      home.state.name.value = profile.name;
      home.state.firstName.value = profile.firstName;
      widget.controller.updateProfile(profile);
      if(mounted) {
        Navigate.back();
      }
    } else {
      notify.error(message: response.message);
    }
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
      route: "/centre/account/update/avatar"
    );
  }

  void pickGender(Gender value) {
    setState(() {
      gender = value;
    });
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
              key: formKey,
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
                    controller: firstName,
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
                    labelColor: Theme.of(context).primaryColor,
                    needLabel: true,
                    hintText: "Last Name",
                    keyboard: TextInputType.name,
                    controller: lastName,
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
                    color: Theme.of(context).primaryColor,
                  ),
                  const SizedBox(height: 10),
                  PhoneField(
                    isoCode: isoCode,
                    controller: phoneNumber,
                    onChanged: (value) {
                      setState(() {
                        countryCode = value.countryCode;
                        isoCode = value.countryISOCode;
                      });
                    },
                    onCountryChanged: (value) {
                      setState(() {
                        country = value;
                      });
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
                        onTap: (index) => pickGender(value),
                        padding: EdgeInsets.all(Sizing.space(14)),
                        textSize: Sizing.font(12),
                        index: 0,
                        selected: gender.key == value.key,
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
                      onClick: () => update(),
                      loading: isLoading
                    ),
                  )
                ]
              ),
            )
          ],
        ),
      )
    );
  }
}