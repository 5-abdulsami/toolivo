import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/models/task_model.dart';
import '../../../core/services/database_service.dart';
import 'package:intl/intl.dart';

class HomeController extends GetxController {
  final DatabaseService _db = Get.find<DatabaseService>();

  final RxList<TaskModel> todayTasks = <TaskModel>[].obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadTodayTasks();
  }

  Future<void> loadTodayTasks() async {
    try {
      isLoading.value = true;
      String today = DateFormat('yyyy-MM-dd').format(DateTime.now());

      List<Map<String, dynamic>> taskMaps = await _db.database.query(
        'tasks',
        where: 'DATE(start_date) = ? OR start_date IS NULL',
        whereArgs: [today],
        orderBy: 'created_at DESC',
      );

      todayTasks.value = taskMaps.map((map) => TaskModel.fromMap(map)).toList();
    } catch (e) {
      Get.snackbar('Error', 'Failed to load tasks: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateTaskStatus(String taskId, TaskStatus status) async {
    try {
      await _db.database.update(
        'tasks',
        {'status': status.name, 'updated_at': DateTime.now().toIso8601String()},
        where: 'id = ?',
        whereArgs: [taskId],
      );

      await loadTodayTasks();
      Get.snackbar('Success', 'Task status updated');
    } catch (e) {
      Get.snackbar('Error', 'Failed to update task: ${e.toString()}');
    }
  }

  Color getStatusColor(TaskStatus status) {
    switch (status) {
      case TaskStatus.newTask:
        return Get.theme.colorScheme.error;
      case TaskStatus.inWork:
        return const Color(0xFFF39C12);
      case TaskStatus.done:
        return const Color(0xFF27AE60);
    }
  }

  String getStatusText(TaskStatus status) {
    switch (status) {
      case TaskStatus.newTask:
        return 'New';
      case TaskStatus.inWork:
        return 'In Work';
      case TaskStatus.done:
        return 'Done';
    }
  }
}
