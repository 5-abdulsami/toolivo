import 'package:get/get.dart';
import '../../../core/services/storage_service.dart';

class SyncController extends GetxController {
  final StorageService _storage = Get.find<StorageService>();

  final RxBool isSyncing = false.obs;
  final Rx<DateTime?> lastSyncTime = Rx<DateTime?>(null);
  final RxInt pendingChanges = 0.obs;

  @override
  void onInit() {
    super.onInit();
    loadSyncStatus();
  }

  void loadSyncStatus() {
    lastSyncTime.value = _storage.getLastSyncTime();
    // In a real app, you would count pending changes from local database
    pendingChanges.value = 0;
  }

  Future<void> performSync() async {
    try {
      isSyncing.value = true;

      // Simulate sync process
      await Future.delayed(const Duration(seconds: 2));

      // Update last sync time
      DateTime now = DateTime.now();
      await _storage.setLastSyncTime(now);
      lastSyncTime.value = now;
      pendingChanges.value = 0;

      Get.snackbar('Success', 'Sync completed successfully');
    } catch (e) {
      Get.snackbar('Error', 'Sync failed: ${e.toString()}');
    } finally {
      isSyncing.value = false;
    }
  }
}
