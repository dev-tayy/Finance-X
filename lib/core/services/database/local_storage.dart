import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SharedPrefs {
  static final SharedPrefs _instance = SharedPrefs._internal();
  SharedPrefs._internal();

  factory SharedPrefs() {
    return _instance;
  }

  static Future<bool> setSignIn(bool value) async {
    SharedPreferences shared = await SharedPreferences.getInstance();
    return await shared.setBool('isSignedIn', value);
  }

  static Future<bool?> getSignIn() async {
    SharedPreferences shared = await SharedPreferences.getInstance();
    return shared.getBool('isSignedIn');
  }

  static Future<void> dispose() async {
    SharedPreferences shared = await SharedPreferences.getInstance();
    shared.remove('isSignedIn');
  }
}

class SecureStorage {
  static final SecureStorage _instance = SecureStorage._internal();
  SecureStorage._internal();

  factory SecureStorage() {
    return _instance;
  }

  static const String passwordKey = 'passKey';
  static const String emailKey = 'emailKey';

  static Future<void> saveEmail(String email) async {
    const FlutterSecureStorage secureStorage = FlutterSecureStorage();
    await secureStorage.write(key: emailKey, value: email);
  }

  static Future<String?> getEmail() async {
    const FlutterSecureStorage secureStorage = FlutterSecureStorage();
    return secureStorage.read(key: emailKey);
  }

  static Future<void> savePasskey(String password) async {
    const FlutterSecureStorage secureStorage = FlutterSecureStorage();
    await secureStorage.write(key: passwordKey, value: password);
  }

  static Future<String?> getPasskey() async {
    const FlutterSecureStorage secureStorage = FlutterSecureStorage();
    return secureStorage.read(key: passwordKey);
  }

  static Future<void> dispose() async {
    const FlutterSecureStorage secureStorage = FlutterSecureStorage();
    secureStorage.deleteAll();
  }
}
