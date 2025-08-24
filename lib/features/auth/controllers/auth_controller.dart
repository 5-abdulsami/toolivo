import 'package:get/get.dart';
import '../../../core/services/database_service.dart';
import '../../../core/services/storage_service.dart';
import '../../../core/routes/app_routes.dart';
import 'package:uuid/uuid.dart';

class AuthController extends GetxController {
  final DatabaseService _db = Get.find<DatabaseService>();
  final StorageService _storage = Get.find<StorageService>();

  final RxBool isLoading = false.obs;
  final RxBool rememberCredentials = false.obs;

  @override
  void onInit() {
    super.onInit();
    _loadSavedCredentials();
  }

  void _loadSavedCredentials() {
    String? username = _storage.getUsername();
    String? password = _storage.getPassword();

    if (username != null && password != null) {
      rememberCredentials.value = true;
    }
  }

  Future<void> login(String username, String password) async {
    try {
      isLoading.value = true;

      // Check local database first
      List<Map<String, dynamic>> users = await _db.database.query(
        'users',
        where: 'username = ? AND password = ?',
        whereArgs: [username, password],
      );

      if (users.isNotEmpty) {
        if (rememberCredentials.value) {
          await _storage.saveCredentials(username, password);
        }
        Get.offAllNamed(AppRoutes.home);
      } else {
        // Create new user for first time
        await _createUser(username, password);
        if (rememberCredentials.value) {
          await _storage.saveCredentials(username, password);
        }
        Get.offAllNamed(AppRoutes.home);
      }
    } catch (e) {
      Get.snackbar('Error', 'Login failed: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _createUser(String username, String password) async {
    await _db.database.insert('users', {
      'id': const Uuid().v4(),
      'username': username,
      'password': password,
      'created_at': DateTime.now().toIso8601String(),
    });
  }

  Future<void> logout() async {
    await _storage.clearCredentials();
    Get.offAllNamed(AppRoutes.login);
  }
}
