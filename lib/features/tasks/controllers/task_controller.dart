import 'package:get/get.dart';
import '../../../core/models/task_model.dart';
import '../../../core/models/material_model.dart';
import '../../../core/services/database_service.dart';
import '../../../core/routes/app_routes.dart';

class TaskDetailController extends GetxController {
  final DatabaseService _db = Get.find<DatabaseService>();

  final Rx<TaskModel?> task = Rx<TaskModel?>(null);
  final RxList<MaterialModel> materials = <MaterialModel>[].obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    TaskModel? taskArg = Get.arguments as TaskModel?;
    if (taskArg != null) {
      task.value = taskArg;
      loadMaterials();
    }
  }

  Future<void> loadMaterials() async {
    if (task.value == null) return;

    try {
      isLoading.value = true;
      List<Map<String, dynamic>> materialMaps = await _db.database.query(
        'materials',
        where: 'task_id = ?',
        whereArgs: [task.value!.id],
        orderBy: 'created_at DESC',
      );

      materials.value =
          materialMaps.map((map) => MaterialModel.fromMap(map)).toList();
    } catch (e) {
      Get.snackbar('Error', 'Failed to load materials: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateTaskStatus(TaskStatus status) async {
    if (task.value == null) return;

    try {
      await _db.database.update(
        'tasks',
        {'status': status.name, 'updated_at': DateTime.now().toIso8601String()},
        where: 'id = ?',
        whereArgs: [task.value!.id],
      );

      task.value = TaskModel.fromMap({
        ...task.value!.toMap(),
        'status': status.name,
        'updated_at': DateTime.now().toIso8601String(),
      });

      Get.snackbar('Success', 'Task status updated');
    } catch (e) {
      Get.snackbar('Error', 'Failed to update task: ${e.toString()}');
    }
  }

  Future<void> toggleWorkVerified() async {
    if (task.value == null) return;

    try {
      bool newValue = !task.value!.workVerified;
      await _db.database.update(
        'tasks',
        {
          'work_verified': newValue ? 1 : 0,
          'updated_at': DateTime.now().toIso8601String(),
        },
        where: 'id = ?',
        whereArgs: [task.value!.id],
      );

      task.value = TaskModel.fromMap({
        ...task.value!.toMap(),
        'work_verified': newValue ? 1 : 0,
        'updated_at': DateTime.now().toIso8601String(),
      });

      Get.snackbar('Success', 'Work verification updated');
    } catch (e) {
      Get.snackbar('Error', 'Failed to update verification: ${e.toString()}');
    }
  }

  void addMaterial() {
    Get.toNamed(AppRoutes.materialEntry, arguments: task.value!.id)?.then((_) {
      loadMaterials();
    });
  }
}
