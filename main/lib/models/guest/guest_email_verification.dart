class GuestEmailVerification {
  final String emailAddress;
  final String guestId;
  final String linkId;
  final String name;
  final bool becomeAUser;

  GuestEmailVerification({
    required this.emailAddress,
    this.guestId = "",
    this.linkId = "",
    required this.name,
    this.becomeAUser = false
  });

  factory GuestEmailVerification.empty() {
    return GuestEmailVerification(
      emailAddress: "",
      guestId: "",
      linkId: "",
      name: "",
      becomeAUser: false,
    );
  }

  factory GuestEmailVerification.fromJson(Map<String, String?> json) {
    return GuestEmailVerification(
      emailAddress: json["email_address"] ?? "",
      guestId: json["guest_id"] ?? "",
      linkId: json["link_id"] ?? "",
      name: json["name"] ?? "",
      becomeAUser: bool.tryParse(json["become_a_user"] ?? "false") ?? false,
    );
  }

  Map<String, String> toJson() {
    return {
      "email_address": emailAddress,
      "guest_id": guestId,
      "link_id": linkId,
      "name": name,
      "become_a_user": becomeAUser.toString()
    };
  }
}