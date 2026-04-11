class CatalogModel {
  final int id;
  final String userEmail;
  final String? projectName;
  final String? taskTitle;
  final String? instructorEmail;
  final String name;
  final String description;
  final String catalogType;
  final String estimatedHours;
  final int progressPercentage;
  final bool isActive;
  final String createdAt;
  final String updatedAt;
  final int? user;
  final int? project;
  final int? task;

  CatalogModel({
    required this.id,
    required this.userEmail,
    this.projectName,
    this.taskTitle,
    this.instructorEmail,
    required this.name,
    required this.description,
    required this.catalogType,
    required this.estimatedHours,
    required this.progressPercentage,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
    this.user,
    this.project,
    this.task,
  });

  factory CatalogModel.fromJson(Map<String, dynamic> json) {
    return CatalogModel(
      id: json['id'] as int,
      userEmail: json['user_email'] as String,
      projectName: json['project_name'] as String?,
      taskTitle: json['task_title'] as String?,
      instructorEmail: json['instructor_email'] as String?,
      name: json['name'] as String,
      description: json['description'] as String,
      catalogType: json['catalog_type'] as String,
      estimatedHours: json['estimated_hours'] as String,
      progressPercentage: json['progress_percentage'] as int,
      isActive: json['is_active'] as bool,
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
      user: json['user'] as int?,
      project: json['project'] as int?,
      task: json['task'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_email': userEmail,
      'project_name': projectName,
      'task_title': taskTitle,
      'instructor_email': instructorEmail,
      'name': name,
      'description': description,
      'catalog_type': catalogType,
      'estimated_hours': estimatedHours,
      'progress_percentage': progressPercentage,
      'is_active': isActive,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'user': user,
      'project': project,
      'task': task,
    };
  }
}
