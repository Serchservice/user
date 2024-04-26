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
}