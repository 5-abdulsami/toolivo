import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/models/material_model.dart' as material_model;
import '../../../core/services/database_service.dart';
import 'package:uuid/uuid.dart';

class MaterialEntryController extends GetxController {
  final DatabaseService _db = Get.find<DatabaseService>();

  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();
  final Rx<material_model.MaterialType> selectedType =
      material_model.MaterialType.material.obs;
  final RxBool isLoading = false.obs;

  String? taskId;

  @override
  void onInit() {
    super.onInit();
    taskId = Get.arguments as String?;
  }

  @override
  void onClose() {
    descriptionController.dispose();
    quantityController.dispose();
    super.onClose();
  }

  Future<void> saveMaterial() async {
    if (taskId == null) {
      Get.snackbar('Error', 'No task selected');
      return;
    }

    if (descriptionController.text.isEmpty || quantityController.text.isEmpty) {
      Get.snackbar('Error', 'Please fill all fields');
      return;
    }

    try {
      isLoading.value = true;

      material_model.MaterialModel material = material_model.MaterialModel(
        id: const Uuid().v4(),
        taskId: taskId!,
        type: selectedType.value,
        description: descriptionController.text,
        quantity: double.parse(quantityController.text),
        createdAt: DateTime.now(),
      );

      await _db.database.insert('materials', material.toMap());

      Get.back();
      Get.snackbar('Success', 'Material added successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to save material: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  void scanBarcode() {
    // Placeholder for barcode scanning
    Get.snackbar('Info', 'Barcode scanner will be implemented');
  }
}
