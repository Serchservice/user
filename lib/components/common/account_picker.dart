import 'package:flutter/material.dart';
import 'package:user/library.dart';

class AccountPicker extends StatefulWidget {
  final Function()? onUserSuccess;
  final Function(bool)? onUserError;
  final Function(Guest guest)? onGuestSuccess;
  final Function(bool)? onGuestError;
  final bool shouldNavigate;
  final bool isLogin;

  const AccountPicker({
    super.key,
    this.onUserSuccess,
    this.onGuestSuccess,
    this.onGuestError,
    this.onUserError,
    this.shouldNavigate = false,
    this.isLogin = false
  });

  static void open({
    Function()? onUserSuccess,
    Function(Guest guest)? onGuestSuccess,
    Function(bool)? onGuestError,
    Function(bool)? onUserError,
    bool isLogin = false,
    bool shouldNavigate = false
  }) => Navigate.bottomSheet(
    sheet: AccountPicker(
      onUserSuccess: onUserSuccess,
      onGuestSuccess: onGuestSuccess,
      onGuestError: onGuestError,
      onUserError: onUserError,
      shouldNavigate: shouldNavigate,
      isLogin: isLogin,
    ),
    route: "/accounts/select",
    isScrollable: true,
  );

  @override
  State<AccountPicker> createState() => _AccountPickerState();
}

class _AccountPickerState extends State<AccountPicker> {
  List<Account> accounts = Database.accounts;
  final AuthValidatorService _apiService = AuthValidator();
  bool isLoading = false;
  String selected = "";

  @override
  void initState() {
    fetchAccounts();
    super.initState();
  }

  void fetchAccounts() async {
    _apiService.fetchAccounts(
      onSuccess: (account) {
        if(mounted) {
          setState(() => accounts = account);
        }
      },
      onError: (error) {
        notify.error(message: error);
      }
    );
  }

  void switchToUser(String id) async {
    if(Database.preference.active == id || Database.preference.active == "user") {
      setState(() {
        isLoading = true;
        selected = id;
      });
      _apiService.validateSession(
        onSuccess: (result) {
          setState(() {
            isLoading = false;
            selected = "";
          });
          if(widget.isLogin) {
            widget.onUserSuccess?.call();
          } else {
            Navigate.all(HomeLayout.route);
          }
        },
        onError: (error) {
          setState(() {
            isLoading = false;
            selected = "";
          });
          if(widget.isLogin) {
            widget.onUserError?.call(false);
          } else {
            Navigate.all(EmailCheckerLayout.route);
          }
        }
      );
    } else {
      final ConnectService connect = Connect();
      setState(() {
        isLoading = true;
        selected = id;
      });
      var response = await connect.post(endpoint: "/switch/user", body: {
        "id": Database.guest.id,
        "device": Database.device.toJson(),
      });
      setState(() {
        isLoading = false;
        selected = "";
      });
      if(response.isOk) {
        AuthResponse auth = AuthResponse.fromJson(response.data);
        Database.saveAuth(auth);
        Database.savePreference(Database.preference.copyWith(active: id));
        widget.onUserSuccess?.call();
      } else {
        notify.error(message: response.message);
        widget.onUserError?.call(response.isGuestOnTrip);
      }
    }
  }

  void switchToGuest({required String linkId, required String guestId}) async {
    if(Database.preference.active == linkId) {
      widget.onGuestSuccess?.call(Database.guest);
    } else {
      final ConnectService connect = Connect(useToken: Database.isUserLoggedIn);
      setState(() {
        isLoading = true;
        selected = linkId;
      });
      var response = await connect.post(endpoint: "/switch", body: {
        "id": guestId,
        "link_id": linkId
      });
      setState(() {
        isLoading = false;
        selected = "";
      });
      if(response.isOk) {
        Guest auth = Guest.fromJson(response.data);
        Database.saveGuest(auth);
        Database.savePreference(Database.preference.copyWith(active: linkId));
        widget.onGuestSuccess?.call(auth);
      } else {
        notify.error(message: response.message);
        widget.onGuestError?.call(response.isGuestOnTrip);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return CurvedBottomSheet(
      padding: EdgeInsets.zero,
      safeArea: true,
      margin: const EdgeInsets.all(10),
      borderRadius: BorderRadius.circular(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Center(
            child: Container(
              padding: EdgeInsets.all(Sizing.space(2)),
              margin: EdgeInsets.all(Sizing.space(10)),
              width: 100,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColorLight,
                borderRadius: BorderRadius.circular(16)
              ),
            ),
          ),
          if(accounts.isNotEmpty) ...[
            ...accounts.map((account) {
              bool active = Database.preference.active.isEmpty
                ? account.category.toLowerCase() == "user"
                : (Database.preference.active == "user" && account.category.toLowerCase() == "user")
                || (Database.preference.active == account.id || Database.preference.active == account.linkId);

              return Material(
                color: active
                  ? Theme.of(context).scaffoldBackgroundColor
                  : Theme.of(context).appBarTheme.backgroundColor,
                child: InkWell(
                  onTap: () {
                    if(active && !widget.shouldNavigate) {
                      return;
                    } else if(active && widget.shouldNavigate) {
                      if(account.category.toLowerCase() == "user") {
                        switchToUser(account.id);
                      } else {
                        switchToGuest(
                          linkId: account.linkId,
                          guestId: account.id
                        );
                      }
                    } else {
                      if(account.category.toLowerCase() == "user") {
                        switchToUser(account.id);
                      } else {
                        switchToGuest(
                          linkId: account.linkId,
                          guestId: account.id
                        );
                      }
                    }
                  },
                  child: Padding(
                    padding: EdgeInsets.all(Sizing.space(10)),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Avatar.small(avatar: account.avatar),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SText(
                                text: account.name,
                                size: Sizing.font(15),
                                weight: FontWeight.bold,
                                color: Theme.of(context).primaryColor
                              ),
                              SText(
                                text: account.category.toLowerCase() == "user"
                                  ? account.emailAddress
                                  : account.linkId,
                                size: Sizing.font(9),
                                color: Theme.of(context).primaryColor
                              ),
                              SText(
                                text: account.category,
                                size: Sizing.font(12),
                                color: Theme.of(context).primaryColorLight
                              ),
                            ],
                          )
                        ),
                        _buildNotifier(
                          context: context,
                          isActive: active,
                          isLoading: (account.id == selected || account.linkId == selected) && isLoading
                        )
                      ],
                    ),
                  )
                )
              );
            })
          ],
          if(accounts.isEmpty) ...[
            LoadingShimmer(
              content: ListView.builder(
                itemCount: 2,
                padding: EdgeInsets.all(Sizing.space(10)),
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return Container(
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.only(bottom: Sizing.space(10)),
                    height: 50,
                    color: CommonColors.shimmerHigh,
                  );
                }
              )
            )
          ]
        ]
      )
    );
  }

  Widget _buildNotifier({
    required BuildContext context,
    required bool isActive,
    required bool isLoading
  }) {
    if(isLoading) {
      return Row(
        children: [
          const SizedBox(width: 10),
          Loading(),
        ],
      );
    } else if(isActive) {
      return Row(
        children: [
          const SizedBox(width: 10),
          Icon(
            Icons.playlist_add_check_circle_rounded,
            color: Theme.of(context).primaryColor
          ),
        ],
      );
    } else {
      return Container();
    }
  }
}