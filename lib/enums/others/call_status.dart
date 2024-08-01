/// This enum represents different statuses for a call.
enum CallStatus {
  ringing("Ringing", "RINGING"),
  calling("Calling", "CALLING"),
  disconnected("Disconnected", "DISCONNECTED"),
  reconnecting("Reconnecting", "RECONNECTING"),
  closed("Closed", "CLOSED"),
  declined("Declined", "DECLINED"),
  onCall("On Call", "ON_CALL"),
  missed("Missed", "MISSED");

  const CallStatus(this.type, this.value);
  final String type;
  final String value;
}

extension ConvertCallStatus on String {
  /// Convert a string to a `CallStatus` enum.
  CallStatus toCallStatus() {
    switch (toLowerCase()) {
      case "ringing":
        return CallStatus.ringing;
      case "disconnected":
        return CallStatus.disconnected;
      case "calling":
        return CallStatus.calling;
      case "closed":
        return CallStatus.closed;
      case "reconnecting":
        return CallStatus.reconnecting;
      case "declined":
        return CallStatus.declined;
      case "on call":
        return CallStatus.onCall;
      case "on_call":
        return CallStatus.onCall;
      case "missed":
        return CallStatus.missed;
      default:
        return CallStatus.ringing;
    }
  }
}