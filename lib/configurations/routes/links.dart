class Links {
  static String web(String link) {
    return "https://www.serchservice.com$link";
  }

  static String privacyUrl = web("/");
  static String privacyHeader = "Legal | Serch (Privacy Policy)";

  static String termsUrl = web("/");
  static String termsHeader = "Legal | Serch (Terms of Service)";
}