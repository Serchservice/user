import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:user/library.dart';

class AccountPickerLayout extends GetResponsiveView<AccountPickerController> {
  final bool isFullScreen;
  AccountPickerLayout({super.key, this.isFullScreen = true});

  static String get route => "/accounts/select";

  static void open({
    Function()? onUserSuccess,
    Function(Guest guest)? onGuestSuccess,
    Function(bool)? onGuestError,
    Function(bool)? onUserError,
    bool isLogin = false,
    bool shouldNavigate = false
  }) {
    Get.put(AccountPickerController(
      onUserSuccess: onUserSuccess,
      onGuestSuccess: onGuestSuccess,
      onGuestError: onGuestError,
      onUserError: onUserError,
      shouldNavigate: shouldNavigate,
      isLogin: isLogin,
    ));

    Navigate.bottomSheet(
      sheet: AccountPickerLayout(isFullScreen: false),
      route: "/accounts/select/pick",
      isScrollable: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    if(isFullScreen) {
      return _fullScreenBuild(context);
    } else {
      return _bottomSheetBuild(context);
    }
  }

  Widget _fullScreenBuild(BuildContext context) {
    return Obx(() {
      List<Account> accounts = controller.state.accounts;

      return MainLayout(
        appbar: AppBar(
          elevation: 0.5,
          title: SText.center(
            text: "Select the account you want to visit",
            size: Sizing.font(16),
            weight: FontWeight.bold,
            color: Theme.of(context).primaryColor
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            if(accounts.isNotEmpty) ...[
              if(controller.isLogin) ...[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SText(
                    text: "You can set the last logged in account as the default account for your next login. Do it here: "
                        "Centre -> Preferences",
                    size: Sizing.font(12),
                    weight: FontWeight.bold,
                    color: Theme.of(context).primaryColorLight
                  ),
                ),
                const SizedBox(height: 10),
              ],
              ...accounts.map((account) => _buildAccount(context, account))
            ],
            if(accounts.isEmpty) ...[
              LoadingShimmer(
                content: ListView.builder(
                  itemCount: 2,
                  padding: EdgeInsets.all(Sizing.space(10)),
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return Container(
                      width: MediaQuery.sizeOf(context).width,
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
    });
  }

  Widget _bottomSheetBuild(BuildContext context) {
    return Obx(() {
      List<Account> accounts = controller.state.accounts;

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
              if(controller.isLogin) ...[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SText(
                    text: "You can set the last logged in account as the default account for your next login. Do it here: "
                        "Centre -> Preferences",
                    size: Sizing.font(12),
                    weight: FontWeight.bold,
                    color: Theme.of(context).primaryColorLight
                  ),
                ),
                const SizedBox(height: 10),
              ],
              ...accounts.map((account) => _buildAccount(context, account))
            ],
            if(accounts.isEmpty) ...[
              LoadingShimmer(
                content: ListView.builder(
                  itemCount: 2,
                  padding: EdgeInsets.all(Sizing.space(10)),
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return Container(
                      width: MediaQuery.sizeOf(context).width,
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
    });
  }

  Widget _buildAccount(BuildContext context, Account account) {
    return Obx(() {
      bool active = controller.isActive(account);
      bool isLoading = controller.state.isLoading.value;
      String selected = controller.state.selected.value;

      return Material(
        color: active
            ? Theme.of(context).scaffoldBackgroundColor
            : Theme.of(context).appBarTheme.backgroundColor,
        child: InkWell(
          onTap: () {
            if(active && !controller.shouldNavigate) {
              return;
            } else if(active && controller.shouldNavigate) {
              if(account.isUser) {
                controller.switchToUser(account.id);
              } else {
                controller.switchToGuest(linkId: account.linkId, guestId: account.id);
              }
            } else {
              if(account.isUser) {
                controller.switchToUser(account.id);
              } else {
                controller.switchToGuest(linkId: account.linkId, guestId: account.id);
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
    });
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
