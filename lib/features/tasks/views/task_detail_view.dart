import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:toolivo/features/tasks/controllers/task_controller.dart';
import '../../../core/models/task_model.dart';
import '../../../core/models/material_model.dart' as material_model;
import 'package:intl/intl.dart';

class TaskDetailView extends StatelessWidget {
  const TaskDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    final TaskDetailController controller = Get.put(TaskDetailController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Task Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: controller.addMaterial,
          ),
        ],
      ),
      body: Obx(() {
        if (controller.task.value == null) {
          return const Center(child: Text('No task data'));
        }

        TaskModel task = controller.task.value!;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Task Info Card
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        task.name,
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      if (task.description != null) ...[
                        const SizedBox(height: 8),
                        Text(
                          task.description!,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                      if (task.propertyAddress != null) ...[
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            const Icon(Icons.location_on, size: 20),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                task.propertyAddress!,
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ),
                          ],
                        ),
                      ],
                      if (task.startDate != null) ...[
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            const Icon(Icons.schedule, size: 20),
                            const SizedBox(width: 8),
                            Text(
                              DateFormat(
                                'MMM dd, yyyy - HH:mm',
                              ).format(task.startDate!),
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      ],
                      const SizedBox(height: 16),

                      // Status Dropdown
                      DropdownButtonFormField<TaskStatus>(
                        value: task.status,
                        decoration: const InputDecoration(
                          labelText: 'Status',
                          border: OutlineInputBorder(),
                        ),
                        items:
                            TaskStatus.values.map((status) {
                              return DropdownMenuItem(
                                value: status,
                                child: Text(_getStatusText(status)),
                              );
                            }).toList(),
                        onChanged: (TaskStatus? newStatus) {
                          if (newStatus != null) {
                            controller.updateTaskStatus(newStatus);
                          }
                        },
                      ),

                      const SizedBox(height: 16),

                      // Work Verified Checkbox
                      CheckboxListTile(
                        title: const Text('Work Verified'),
                        value: task.workVerified,
                        onChanged: (_) => controller.toggleWorkVerified(),
                        controlAffinity: ListTileControlAffinity.leading,
                        contentPadding: EdgeInsets.zero,
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Materials Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Materials & Time',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: controller.addMaterial,
                    icon: const Icon(Icons.add),
                    label: const Text('Add'),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              Obx(() {
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (controller.materials.isEmpty) {
                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.all(32),
                      child: Center(
                        child: Column(
                          children: [
                            Icon(
                              Icons.inventory_2_outlined,
                              size: 48,
                              color: Colors.grey[400],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'No materials added yet',
                              style: Theme.of(context).textTheme.bodyLarge
                                  ?.copyWith(color: Colors.grey[600]),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }

                return Column(
                  children:
                      controller.materials.map((material) {
                        return _MaterialCard(material: material);
                      }).toList(),
                );
              }),
            ],
          ),
        );
      }),
    );
  }

  String _getStatusText(TaskStatus status) {
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

class _MaterialCard extends StatelessWidget {
  final material_model.MaterialModel material;

  const _MaterialCard({required this.material});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor:
              material.type == material_model.MaterialType.material
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.secondary,
          child: Icon(
            material.type == material_model.MaterialType.material
                ? Icons.inventory
                : Icons.schedule,
            color: Colors.white,
          ),
        ),
        title: Text(material.description),
        subtitle: Text(
          '${material.type == material_model.MaterialType.material ? 'Quantity' : 'Hours'}: ${material.quantity}',
        ),
        trailing: Text(
          DateFormat('MMM dd').format(material.createdAt),
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ),
    );
  }
}
