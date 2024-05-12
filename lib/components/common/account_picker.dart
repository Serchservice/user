import 'package:flutter/material.dart';
import 'package:user/library.dart';

class AccountPicker extends StatefulWidget {
  final Function()? onUserSuccess;
  final Function()? onUserError;
  final Function()? onGuestSuccess;
  final Function()? onGuestError;
  final bool shouldNavigate;
  const AccountPicker({
    super.key,
    this.onUserSuccess,
    this.onGuestSuccess,
    this.onGuestError,
    this.onUserError,
    this.shouldNavigate = false
  });

  static void open({
    Function()? onUserSuccess,
    Function()? onGuestSuccess,
    Function()? onGuestError,
    Function()? onUserError,
    bool shouldNavigate = false
  }) => Navigate.bottomSheet(
    sheet: AccountPicker(
      onUserSuccess: onUserSuccess,
      onGuestSuccess: onGuestSuccess,
      onGuestError: onGuestError,
      onUserError: onUserError,
      shouldNavigate: shouldNavigate
    ),
    route: "/accounts/select",
    isScrollable: true,
  );

  @override
  State<AccountPicker> createState() => _AccountPickerState();
}

class _AccountPickerState extends State<AccountPicker> {
  List<Account> accounts = Database.accounts;
  final CommonApiService _apiService = CommonApi();
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
        SnackBars.top(message: error, type: Snackbar.error);
      }
    );
  }

  void switchToUser(String id) async {
    final Connect connect = Connect();
    try {
      setState(() {
        isLoading = true;
        selected = id;
      });
      var res = await connect.post(endpoint: "/switch/user", body: {
        "id": Database.guest.id,
        "device": Database.device.toJson(),
      });
      ApiResponse response = ApiResponse.fromJson(res.data);
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
        SnackBars.top(message: response.message, type: Snackbar.error);
        widget.onUserError?.call();
      }
    } on Exception catch(e) {
      setState(() {
        isLoading = false;
        selected = "";
      });
      Connect.showError(e);
      widget.onUserError?.call();
    }
  }

  void switchToGuest(String linkId) async {
    final Connect connect = Connect();
    setState(() {
      isLoading = true;
      selected = linkId;
    });
    try {
      var res = await connect.post(endpoint: "/switch", body: {
        "id": Database.guest.id,
        "link_id": linkId
      });
      ApiResponse response = ApiResponse.fromJson(res.data);
      setState(() {
        isLoading = false;
        selected = "";
      });
      if(response.isOk) {
        Guest auth = Guest.fromJson(response.data);
        Database.saveGuest(auth);
        Database.savePreference(Database.preference.copyWith(active: linkId));
        widget.onGuestSuccess?.call();
      } else {
        SnackBars.top(message: response.message, type: Snackbar.error);
        widget.onGuestError?.call();
      }
    } on Exception catch(e) {
      setState(() {
        isLoading = false;
        selected = "";
      });
      Connect.showError(e);
      widget.onGuestError?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    return CurvedBottomSheet(
      padding: EdgeInsets.zero,
      safeArea: true,
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
                : (Database.preference.active == account.id || Database.preference.active == account.linkId);

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
                        switchToGuest(account.linkId);
                      }
                    } else {
                      if(account.category.toLowerCase() == "user") {
                        switchToUser(account.id);
                      } else {
                        switchToGuest(account.linkId);
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
                        _buildNotification(
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

  Widget _buildNotification({
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