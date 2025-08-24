import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/home_controller.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/models/task_model.dart';
import '../../auth/controllers/auth_controller.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeController controller = Get.put(HomeController());
    final AuthController authController = Get.find<AuthController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Today\'s Tasks'),
        actions: [
          IconButton(
            icon: const Icon(Icons.sync),
            onPressed: () => Get.toNamed(AppRoutes.syncStatus),
          ),
          PopupMenuButton(
            itemBuilder:
                (context) => [
                  PopupMenuItem(
                    child: const Text('Customers'),
                    onTap: () => Get.toNamed(AppRoutes.customer),
                  ),
                  PopupMenuItem(
                    child: const Text('Logout'),
                    onTap: () => authController.logout(),
                  ),
                ],
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.todayTasks.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.task_alt, size: 64, color: Colors.grey[400]),
                const SizedBox(height: 16),
                Text(
                  'No tasks for today',
                  style: Theme.of(
                    context,
                  ).textTheme.headlineSmall?.copyWith(color: Colors.grey[600]),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: controller.loadTodayTasks,
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: controller.todayTasks.length,
            itemBuilder: (context, index) {
              TaskModel task = controller.todayTasks[index];
              return _TaskCard(task: task, controller: controller);
            },
          ),
        );
      }),
    );
  }
}

class _TaskCard extends StatelessWidget {
  final TaskModel task;
  final HomeController controller;

  const _TaskCard({required this.task, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () => Get.toNamed(AppRoutes.taskDetail, arguments: task),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      task.name,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: controller.getStatusColor(task.status),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      controller.getStatusText(task.status),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              if (task.description != null) ...[
                const SizedBox(height: 8),
                Text(
                  task.description!,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
                ),
              ],
              if (task.propertyAddress != null) ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.location_on, size: 16, color: Colors.grey[600]),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        task.propertyAddress!,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey[600],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
              const SizedBox(height: 12),
              Row(
                children: [
                  if (task.status == TaskStatus.newTask)
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed:
                            () => controller.updateTaskStatus(
                              task.id,
                              TaskStatus.inWork,
                            ),
                        icon: const Icon(Icons.play_arrow),
                        label: const Text('Start'),
                      ),
                    ),
                  if (task.status == TaskStatus.inWork) ...[
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed:
                            () => controller.updateTaskStatus(
                              task.id,
                              TaskStatus.done,
                            ),
                        icon: const Icon(Icons.check),
                        label: const Text('Complete'),
                      ),
                    ),
                  ],
                  const SizedBox(width: 8),
                  OutlinedButton(
                    onPressed:
                        () =>
                            Get.toNamed(AppRoutes.taskDetail, arguments: task),
                    child: const Text('Details'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
