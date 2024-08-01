/// This enum represents different types for a call.
enum CallType {
  voice("Voice", "VOICE"),
  tip2fix("Tip2Fix", "T2F");

  const CallType(this.type, this.value);
  final String type;
  final String value;
}

extension ConvertCallType on String {
  /// Convert a string to a `CallType` enum.
  CallType toCallType() {
    switch (toLowerCase()) {
      case "voice":
        return CallType.voice;
      case "t2f":
        return CallType.tip2fix;
      default:
        return CallType.voice;
    }
  }
}