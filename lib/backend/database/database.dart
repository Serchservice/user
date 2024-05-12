import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:user/library.dart';

/// This class is the wrapper for the local database of the user.
///
/// It initializes and opens the local database.

const String accountDatabase = "ACCOUNT_DATABASE";
const String authDatabase = "AUTH_DATABASE";
const String settingsDatabase = "SETTINGS_DATABASE";
const String guestDatabase = "GUEST_DATABASE";
const String accountsDatabase = "ACCOUNTS_DATABASE";

class Database {
  static Future<void> initialize() async {
    await GetStorage.init();
    await GetStorage.init(settingsDatabase);
    await GetStorage.init(authDatabase);
    await GetStorage.init(accountDatabase);
    await GetStorage.init(accountsDatabase);
    await GetStorage.init(guestDatabase);
  }

  static Future<void> get clear async {
    await DatabaseImplementation(accountDatabase).erase();
    await DatabaseImplementation(settingsDatabase).erase();
    await DatabaseImplementation(authDatabase).erase();
  }

  static Future<void> get clearGuest async {
    await DatabaseImplementation(guestDatabase).erase();
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

  /// DATABASE ACTIONS - LOCAL NOTIFIER
  static LocalNotifier get notifier {
    LocalNotifierDatabase db = LocalNotifierDatabase();
    return db.get();
  }

  static Future<LocalNotifier> saveNotifier(LocalNotifier notifier) async {
    LocalNotifierDatabase db = LocalNotifierDatabase();
    return db.save(notifier);
  }

  /// DATABASE ACTIONS - APP RATING
  static AppRating get rating {
    AppRatingDatabase db = AppRatingDatabase();
    return db.get();
  }

  static Future<AppRating> saveAppRating(AppRating rating) async {
    AppRatingDatabase db = AppRatingDatabase();
    return db.save(rating);
  }

  /// DATABASE ACTIONS - APP SETTING
  static AppSetting get setting {
    AppSettingDatabase db = AppSettingDatabase();
    return db.get();
  }

  static Future<AppSetting> saveAppSetting(AppSetting setting) async {
    AppSettingDatabase db = AppSettingDatabase();
    return db.save(setting);
  }

  /// DATABASE ACTIONS - ACCOUNT
  static List<Account> get accounts {
    AccountDatabase db = AccountDatabase();
    return db.get();
  }

  static Future<List<Account>> saveAccount(List<Account> accounts) async {
    AccountDatabase db = AccountDatabase();
    return db.save(accounts);
  }

  /// DATABASE ACTIONS - GUEST
  static Guest get guest {
    GuestDatabase db = GuestDatabase();
    return db.get();
  }

  static Future<Guest> saveGuest(Guest guest) async {
    GuestDatabase db = GuestDatabase();
    return db.save(guest);
  }
}