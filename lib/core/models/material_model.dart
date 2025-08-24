class MaterialModel {
  final String id;
  final String taskId;
  final MaterialType type;
  final String description;
  final double quantity;
  final DateTime createdAt;

  MaterialModel({
    required this.id,
    required this.taskId,
    required this.type,
    required this.description,
    required this.quantity,
    required this.createdAt,
  });

  factory MaterialModel.fromMap(Map<String, dynamic> map) {
    return MaterialModel(
      id: map['id'],
      taskId: map['task_id'],
      type: MaterialType.values.firstWhere((e) => e.name == map['type']),
      description: map['description'],
      quantity: map['quantity'].toDouble(),
      createdAt: DateTime.parse(map['created_at']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'task_id': taskId,
      'type': type.name,
      'description': description,
      'quantity': quantity,
      'created_at': createdAt.toIso8601String(),
    };
  }
}

enum MaterialType { material, time }
