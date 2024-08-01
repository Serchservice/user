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
    AuthRepository db = AuthRepository();
    return db.get();
  }

  static Future<AuthResponse> saveAuth(AuthResponse auth) {
    AuthRepository db = AuthRepository();
    return db.save(auth);
  }

  static SessionResponse get session {
    AuthRepository db = AuthRepository();
    return db.get().session;
  }

  static Future<AuthResponse> saveSession(SessionResponse session) {
    AuthRepository db = AuthRepository();
    return db.save(auth.copyWith(session: session));
  }

  static bool get isLoggedIn {
    return session.accessToken.isNotEmpty;
  }

  static bool get loginWithMFA {
    return auth.hasMfa && !preference.remember && (preference.isMFA || preference.isBoth || preference.isNone);
  }

  static bool get loginWithBiometrics {
    return preference.hasBiometrics && (preference.isBiometrics || preference.isBoth || preference.isNone);
  }

  static bool get isUserLoggedIn => preference.active == auth.id;

  /// DATABASE ACTIONS - PREFERENCE
  static Preference get preference {
    PreferenceRepository db = PreferenceRepository();
    return db.get();
  }

  static ThemeMode get themeMode => preference.theme == ThemeType.light
      ? ThemeMode.light
      : ThemeMode.dark;

  static Future<Preference> savePreference(Preference device) async {
    PreferenceRepository db = PreferenceRepository();
    return db.save(device);
  }

  /// DATABASE ACTIONS - DEVICE
  static Device get device {
    DeviceRepository db = DeviceRepository();
    return db.get();
  }

  static Future<Device> saveDevice(Device device) async {
    DeviceRepository db = DeviceRepository();
    return db.save(device);
  }

  /// DATABASE ACTIONS - ADDRESS
  static Address get address {
    AddressRepository db = AddressRepository();
    return db.get();
  }

  static Future<Address> saveAddress(Address address) async {
    AddressRepository db = AddressRepository();
    return db.save(address);
  }

  /// DATABASE ACTIONS - COUNTRY
  static List<Country> get countries {
    CountryRepository db = CountryRepository();
    return db.get();
  }

  static Future<List<Country>> saveCountries(List<Country> countries) async {
    CountryRepository db = CountryRepository();
    return db.save(countries);
  }

  /// DATABASE ACTIONS - LOCAL NOTIFIER
  static LocalNotifier get notifier {
    LocalNotifierRepository db = LocalNotifierRepository();
    return db.get();
  }

  static Future<LocalNotifier> saveNotifier(LocalNotifier notifier) async {
    LocalNotifierRepository db = LocalNotifierRepository();
    return db.save(notifier);
  }

  /// DATABASE ACTIONS - APP RATING
  static AppRating get rating {
    AppRatingRepository db = AppRatingRepository();
    return db.get();
  }

  static Future<AppRating> saveAppRating(AppRating rating) async {
    AppRatingRepository db = AppRatingRepository();
    return db.save(rating);
  }

  /// DATABASE ACTIONS - APP SETTING
  static AppSetting get setting {
    AppSettingRepository db = AppSettingRepository();
    return db.get();
  }

  static Future<AppSetting> saveAppSetting(AppSetting setting) async {
    AppSettingRepository db = AppSettingRepository();
    return db.save(setting);
  }

  /// DATABASE ACTIONS - ACCOUNT
  static List<Account> get accounts {
    AccountRepository db = AccountRepository();
    return db.get();
  }

  static Future<List<Account>> saveAccount(List<Account> accounts) async {
    AccountRepository db = AccountRepository();
    return db.save(accounts);
  }

  /// DATABASE ACTIONS - GUEST
  static Guest get guest {
    GuestRepository db = GuestRepository();
    return db.get();
  }

  static Future<Guest> saveGuest(Guest guest) async {
    GuestRepository db = GuestRepository();
    return db.save(guest);
  }
}