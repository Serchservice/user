/// For preferences in the platform
enum PreferenceOption {
  /// Represents a phone.
  phone("Phone"),

  /// Represents an inApp.
  inApp("In-App"),

  /// Represents none.
  none("None"),

  /// Represents an all.
  all("All");

  const PreferenceOption(this.type);
  final String type;
}

extension StringToPreferenceOption on String {
  /// Convert a string to a `PreferenceOption` enum.
  PreferenceOption toPreferenceOption() {
    switch (this) {
      case "Phone":
        return PreferenceOption.phone;
      case "In-App":
        return PreferenceOption.inApp;
      case "All":
        return PreferenceOption.all;
      case "None":
        return PreferenceOption.none;
      default:
        return PreferenceOption.all;
    }
  }
}