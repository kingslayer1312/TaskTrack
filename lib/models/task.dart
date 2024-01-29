final String tasksTable = 'tasks';

class TaskFields {

  static final List<String> values = [
    id, name, description, category, priority, deadline, status
  ];

  static final String id = '_id';
  static final String name = 'name';
  static final String description = 'description';
  static final String category = 'category';
  static final String priority = 'priority';
  static final String deadline = 'deadline';
  static final String status = 'status';
}

class Task {
  final int? id;
  final String name;
  final String description;
  final String category;
  final String priority;
  final DateTime deadline;
  final bool status;

  const Task({
    this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.priority,
    required this.deadline,
    required this.status,
  });

  Map<String, Object?> toJson() => {
    TaskFields.id: id,
    TaskFields.name: name,
    TaskFields.description: description,
    TaskFields.category: category,
    TaskFields.priority: priority,
    TaskFields.deadline: deadline.toIso8601String(),
    TaskFields.status: status ? 1 : 0,
  };

  static Task fromJson(Map<String, Object?> json) => Task(
    id: json[TaskFields.id] as int?,
    name: json[TaskFields.name] as String,
    description: json[TaskFields.description] as String,
    category: json[TaskFields.category] as String,
    priority: json[TaskFields.priority] as String,
    deadline: DateTime.parse(json[TaskFields.deadline] as String),
    status: json[TaskFields.status] == 1
  );

  Task createTaskCopy({
    int? id,
    String? name,
    String? description,
    String? category,
    String? priority,
    DateTime? deadline,
    bool? status
  }) => Task(
    id: id ?? this.id,
    name: name ?? this.name,
    description: description ?? this.description,
    category: category ?? this.category,
    priority: priority ?? this.priority,
    deadline: deadline ?? this.deadline,
    status: status ?? this.status
  );


}