enum SecurityType {
  biometrics("Biometrics"),
  mfa("Multi-Factor Authentication"),
  both("Biometrics and Multi-Factor Authentication"),
  none("None");

  final String type;
  const SecurityType(this.type);
}

extension StringToSecurityType on String {
  /// Convert a string to a `SecurityType` enum.
  SecurityType toSecurityType() {
    switch (this) {
      case "Biometrics":
        return SecurityType.biometrics;
      case "Multi-Factor Authentication":
        return SecurityType.mfa;
      case "Biometrics and Multi-Factor Authentication":
        return SecurityType.both;
      default:
        return SecurityType.none;
    }
  }
}