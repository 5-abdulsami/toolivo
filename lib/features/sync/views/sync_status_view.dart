import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/sync_controller.dart';
import 'package:intl/intl.dart';

class SyncStatusView extends StatelessWidget {
  const SyncStatusView({super.key});

  @override
  Widget build(BuildContext context) {
    final SyncController controller = Get.put(SyncController());

    return Scaffold(
      appBar: AppBar(title: const Text('Sync Status')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Sync Status Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Sync Status',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Last Sync Time
                    Obx(
                      () => Row(
                        children: [
                          const Icon(Icons.schedule),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Last Sync'),
                                Text(
                                  controller.lastSyncTime.value != null
                                      ? DateFormat(
                                        'MMM dd, yyyy - HH:mm',
                                      ).format(controller.lastSyncTime.value!)
                                      : 'Never synced',
                                  style: Theme.of(context).textTheme.bodySmall
                                      ?.copyWith(color: Colors.grey[600]),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Pending Changes
                    Obx(
                      () => Row(
                        children: [
                          const Icon(Icons.pending_actions),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Pending Changes'),
                                Text(
                                  '${controller.pendingChanges.value} items',
                                  style: Theme.of(context).textTheme.bodySmall
                                      ?.copyWith(color: Colors.grey[600]),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Sync Button
            Obx(
              () => SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed:
                      controller.isSyncing.value
                          ? null
                          : controller.performSync,
                  icon:
                      controller.isSyncing.value
                          ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                          : const Icon(Icons.sync),
                  label: Text(
                    controller.isSyncing.value ? 'Syncing...' : 'Sync Now',
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Sync Info
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Sync Information',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      '• Data is automatically synced when internet is available\n'
                      '• All changes are saved locally and synced later\n'
                      '• Manual sync ensures latest data from server',
                      style: TextStyle(height: 1.5),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
