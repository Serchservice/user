import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:user/library.dart';

/// This class is the wrapper for the local database of the user.
///
/// It initializes and opens the local database.
class Database {
  static Future<void> initialize() async {
    await GetStorage.init().then((value) => Logger.log("Local Database running..."));
    await GetStorage.init(settingsDatabase).then((value) {
      Logger.log("Local $settingsDatabase Database running...$value");
    });
    await GetStorage.init(authDatabase).then((value) {
      Logger.log("Local $authDatabase Database running...$value");
    });
    await GetStorage.init(accountDatabase).then((value) {
      Logger.log("Local $accountDatabase Database running...$value");
    });
  }

  static Future<void> get clear async {
    await DatabaseImplementation(accountDatabase).erase();
    await DatabaseImplementation(settingsDatabase).erase();
    await DatabaseImplementation(authDatabase).erase();
  }

  /// DATABASE ACTIONS
  /// DATABASE ACTIONS - AUTH & SESSION

  static AuthResponse get auth {
    AuthDatabase db = AuthDatabase();
    return db.get();
  }

  static Future<AuthResponse> saveAuth(AuthResponse auth) {
    AuthDatabase db = AuthDatabase();
    return db.save(auth);
  }

  static Session get session {
    AuthDatabase db = AuthDatabase();
    return db.get().session;
  }

  static Future<AuthResponse> saveSession(Session session) {
    AuthDatabase db = AuthDatabase();
    return db.save(auth.copyWith(session: session));
  }

  static bool get isLoggedIn {
    return session.accessToken.isNotEmpty;
  }

  /// DATABASE ACTIONS - PREFERENCE
  static Preference get preference {
    PreferenceDatabase db = PreferenceDatabase();
    return db.get();
  }

  static ThemeMode get themeMode => preference.theme == ThemeType.light
    ? ThemeMode.light
    : ThemeMode.dark;

  static Future<Preference> savePreference(Preference device) async {
    PreferenceDatabase db = PreferenceDatabase();
    return db.save(device);
  }

  /// DATABASE ACTIONS - DEVICE
  static Device get device {
    DeviceDatabase db = DeviceDatabase();
    return db.get();
  }

  static Future<Device> saveDevice(Device device) async {
    DeviceDatabase db = DeviceDatabase();
    return db.save(device);
  }

  /// DATABASE ACTIONS - ADDRESS
  static Address get address {
    AddressDatabase db = AddressDatabase();
    return db.get();
  }

  static Future<Address> saveAddress(Address address) async {
    AddressDatabase db = AddressDatabase();
    return db.save(address);
  }

  /// DATABASE ACTIONS - COUNTRY
  static List<Country> get countries {
    CountryDatabase db = CountryDatabase();
    return db.get();
  }

  static Future<List<Country>> saveCountries(List<Country> countries) async {
    CountryDatabase db = CountryDatabase();
    return db.save(countries);
  }
}