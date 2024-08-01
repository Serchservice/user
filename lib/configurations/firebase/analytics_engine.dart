import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:user/library.dart';

class AnalyticsEngine {
  static final _instance = FirebaseAnalytics.instance;

  static void userLogin(String method, String emailAddress, Device device, Address address) async  {
    return _instance.logLogin(
      loginMethod: method,
      parameters: {
        "email_address": emailAddress,
        "address": address.streetName,
        "ip_address": device.ipAddress
      },
    );
  }

  static void userSignup(String method, String emailAddress, Device device, Address address) async  {
    return _instance.logSignUp(
      signUpMethod: method,
      parameters: {
        "email_address": emailAddress,
        "device": device.name,
        "address": address.streetName,
        "ip_address": device.ipAddress
      },
    );
  }

  static void serviceSearch(String query) async  {
    return _instance.logSearch(searchTerm: query);
  }
}