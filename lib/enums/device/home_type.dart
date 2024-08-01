enum HomeType {
  home,
  connect,
  activity,
  centre
}

extension StringToHomeType on String {
  /// Convert a string to a `HomeType` enum.
  HomeType toHomeType() {
    switch (this) {
      case "connect":
        return HomeType.connect;
      case "activity":
        return HomeType.activity;
      case "centre":
        return HomeType.centre;
      default:
        return HomeType.home;
    }
  }
}