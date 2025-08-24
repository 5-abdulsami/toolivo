import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';

class StorageService extends GetxService {
  static SharedPreferences? _prefs;

  Future<StorageService> init() async {
    _prefs = await SharedPreferences.getInstance();
    return this;
  }

  SharedPreferences get prefs {
    if (_prefs != null) return _prefs!;
    throw Exception('Storage not initialized');
  }

  // User credentials
  Future<void> saveCredentials(String username, String password) async {
    await prefs.setString('username', username);
    await prefs.setString('password', password);
  }

  String? getUsername() => prefs.getString('username');
  String? getPassword() => prefs.getString('password');

  Future<void> clearCredentials() async {
    await prefs.remove('username');
    await prefs.remove('password');
  }

  // Sync status
  Future<void> setLastSyncTime(DateTime time) async {
    await prefs.setString('last_sync', time.toIso8601String());
  }

  DateTime? getLastSyncTime() {
    String? timeStr = prefs.getString('last_sync');
    return timeStr != null ? DateTime.parse(timeStr) : null;
  }
}
