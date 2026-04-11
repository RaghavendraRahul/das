class Milestone {
  final String id;
  final String name;
  final bool completed;
  final int weight;
  final String? completedBy;
  final String? completedByAvatar;
  final String? completedById;

  Milestone({
    required this.id,
    required this.name,
    required this.completed,
    required this.weight,
    this.completedBy,
    this.completedByAvatar,
    this.completedById,
  });

  factory Milestone.fromJson(Map<String, dynamic> json) {
    return Milestone(
      id: json['id'] as String,
      name: json['name'] as String,
      completed: json['completed'] as bool? ?? false,
      weight: json['weight'] as int? ?? 0,
      completedBy: json['completedBy'] as String?,
      completedByAvatar: json['completedByAvatar'] as String?,
      completedById: json['completedById']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'completed': completed,
      'weight': weight,
      'completedBy': completedBy,
      'completedByAvatar': completedByAvatar,
      'completedById': completedById,
    };
  }

  Milestone copyWith({
    String? id,
    String? name,
    bool? completed,
    int? weight,
    String? completedBy,
    String? completedByAvatar,
    String? completedById,
  }) {
    return Milestone(
      id: id ?? this.id,
      name: name ?? this.name,
      completed: completed ?? this.completed,
      weight: weight ?? this.weight,
      completedBy: completedBy ?? this.completedBy,
      completedByAvatar: completedByAvatar ?? this.completedByAvatar,
      completedById: completedById ?? this.completedById,
    );
  }
}
