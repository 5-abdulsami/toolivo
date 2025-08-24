class TaskModel {
  final String id;
  final String name;
  final String? description;
  final String? customerId;
  final String? propertyAddress;
  final DateTime? startDate;
  final TaskStatus status;
  final bool workVerified;
  final DateTime createdAt;
  final DateTime updatedAt;

  TaskModel({
    required this.id,
    required this.name,
    this.description,
    this.customerId,
    this.propertyAddress,
    this.startDate,
    required this.status,
    this.workVerified = false,
    required this.createdAt,
    required this.updatedAt,
  });

  factory TaskModel.fromMap(Map<String, dynamic> map) {
    return TaskModel(
      id: map['id'],
      name: map['name'],
      description: map['description'],
      customerId: map['customer_id'],
      propertyAddress: map['property_address'],
      startDate:
          map['start_date'] != null ? DateTime.parse(map['start_date']) : null,
      status: TaskStatus.values.firstWhere((e) => e.name == map['status']),
      workVerified: map['work_verified'] == 1,
      createdAt: DateTime.parse(map['created_at']),
      updatedAt: DateTime.parse(map['updated_at']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'customer_id': customerId,
      'property_address': propertyAddress,
      'start_date': startDate?.toIso8601String(),
      'status': status.name,
      'work_verified': workVerified ? 1 : 0,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}

enum TaskStatus { newTask, inWork, done }
