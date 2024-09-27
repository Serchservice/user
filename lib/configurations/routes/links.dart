import 'package:user/library.dart';

class Links {
  static String web(String link) {
    return "https://www.serchservice.com$link";
  }

  static String privacyUrl = web(Constants.privacyPolicy);
  static String privacyHeader = "Legal | Serch (Privacy Policy)";

  static String termsUrl = web(Constants.termsAndConditions);
  static String termsHeader = "Legal | Serch (Terms of Service)";
}