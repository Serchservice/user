enum Gender {
  male("MALE", "Male"),
  female("FEMALE", "Female"),
  any("ANY", "Prefer not to say"),
  none("None", "");

  final String key;
  final String value;
  const Gender(this.key, this.value);
}

extension StringToGender on String {
  /// Convert a string to a `Gender` enum.
  Gender toGender() {
    switch (this) {
      case "MALE":
        return Gender.male;
      case "FEMALE":
        return Gender.female;
      case "ANY":
        return Gender.any;
      default:
        return Gender.none;
    }
  }
}