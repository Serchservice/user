class LocalNotifier {
  final bool showWelcome;
  final bool showSharedLinks;
  final bool showBookmark;
  final bool showRating;
  final bool showProfile;
  final bool showAccount;
  final bool showShop;

  LocalNotifier({
    this.showSharedLinks = true,
    this.showWelcome = true,
    this.showBookmark = true,
    this.showRating = true,
    this.showProfile = true,
    this.showAccount = true,
    this.showShop = true
  });

  factory LocalNotifier.fromJson(Map<String, dynamic> json) {
    return LocalNotifier(
      showSharedLinks: json["showSharedLinks"] ?? true,
      showWelcome: json["showWelcome"] ?? true,
      showBookmark: json["showBookmark"] ?? true,
      showRating: json["showRating"] ?? true,
      showProfile: json["showProfile"] ?? true,
      showAccount: json["showAccount"] ?? true,
      showShop: json["showShop"] ?? true,
    );
  }

  LocalNotifier copyWith({
    bool? showWelcome,
    bool? showSharedLinks,
    bool? showBookmark,
    bool? showRating,
    bool? showProfile,
    bool? showAccount,
    bool? showShop,
  }) {
    return LocalNotifier(
      showSharedLinks: showSharedLinks ?? this.showSharedLinks,
      showWelcome: showWelcome ?? this.showWelcome,
      showBookmark: showBookmark ?? this.showBookmark,
      showRating: showRating ?? this.showRating,
      showProfile: showProfile ?? this.showProfile,
      showAccount: showAccount ?? this.showAccount,
      showShop: showShop ?? this.showShop,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "showSharedLinks": showSharedLinks,
      "showWelcome": showWelcome,
      "showBookmark": showBookmark,
      "showRating": showRating,
      "showProfile": showProfile,
      "showAccount": showAccount,
      "showShop": showShop,
    };
  }
}