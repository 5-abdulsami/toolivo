import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/material_entry_controller.dart';
import '../../../core/models/material_model.dart' as material_model;

class MaterialEntryView extends StatelessWidget {
  const MaterialEntryView({super.key});

  @override
  Widget build(BuildContext context) {
    final MaterialEntryController controller = Get.put(
      MaterialEntryController(),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Material'),
        actions: [
          IconButton(
            icon: const Icon(Icons.qr_code_scanner),
            onPressed: controller.scanBarcode,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Type Selection
                    Text(
                      'Type',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Obx(
                      () => Row(
                        children: [
                          Expanded(
                            child: RadioListTile<material_model.MaterialType>(
                              title: const Text('Material'),
                              value: material_model.MaterialType.material,
                              groupValue: controller.selectedType.value,
                              onChanged: (material_model.MaterialType? value) {
                                if (value != null) {
                                  controller.selectedType.value = value;
                                }
                              },
                            ),
                          ),
                          Expanded(
                            child: RadioListTile<material_model.MaterialType>(
                              title: const Text('Time'),
                              value: material_model.MaterialType.time,
                              groupValue: controller.selectedType.value,
                              onChanged: (material_model.MaterialType? value) {
                                if (value != null) {
                                  controller.selectedType.value = value;
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Description Field
                    TextField(
                      controller: controller.descriptionController,
                      decoration: const InputDecoration(
                        labelText: 'Description',
                        hintText: 'Enter material or work description',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 3,
                    ),

                    const SizedBox(height: 16),

                    // Quantity Field
                    Obx(
                      () => TextField(
                        controller: controller.quantityController,
                        decoration: InputDecoration(
                          labelText:
                              controller.selectedType.value ==
                                      material_model.MaterialType.material
                                  ? 'Quantity'
                                  : 'Hours',
                          hintText:
                              controller.selectedType.value ==
                                      material_model.MaterialType.material
                                  ? 'Enter quantity'
                                  : 'Enter hours worked',
                          border: const OutlineInputBorder(),
                        ),
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Barcode Scanner Card
                    Card(
                      child: InkWell(
                        onTap: controller.scanBarcode,
                        borderRadius: BorderRadius.circular(12),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            children: [
                              Icon(
                                Icons.qr_code_scanner,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                              const SizedBox(width: 12),
                              const Expanded(child: Text('Scan Barcode')),
                              const Icon(Icons.arrow_forward_ios, size: 16),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Save Button
            Obx(
              () => SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed:
                      controller.isLoading.value
                          ? null
                          : controller.saveMaterial,
                  child:
                      controller.isLoading.value
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text('Save Material'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
