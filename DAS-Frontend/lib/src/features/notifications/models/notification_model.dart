class NotificationModel {
  final int id;
  final String title;
  final String message;
  final String notificationType;
  final String referenceType;
  final int? referenceId;
  final bool isRead;
  final DateTime createdAt;
  final String timeAgo;

  NotificationModel({
    required this.id,
    required this.title,
    required this.message,
    required this.notificationType,
    this.referenceType = '',
    this.referenceId,
    this.isRead = false,
    required this.createdAt,
    this.timeAgo = '',
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'],
      title: json['title'],
      message: json['message'],
      notificationType: json['notification_type'],
      referenceType: json['reference_type'] ?? '',
      referenceId: json['reference_id'],
      isRead: json['is_read'] ?? false,
      createdAt: DateTime.parse(json['created_at']),
      timeAgo: json['time_ago'] ?? '',
    );
  }
  NotificationModel copyWith({
    int? id,
    String? title,
    String? message,
    String? notificationType,
    String? referenceType,
    int? referenceId,
    bool? isRead,
    DateTime? createdAt,
    String? timeAgo,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      title: title ?? this.title,
      message: message ?? this.message,
      notificationType: notificationType ?? this.notificationType,
      referenceType: referenceType ?? this.referenceType,
      referenceId: referenceId ?? this.referenceId,
      isRead: isRead ?? this.isRead,
      createdAt: createdAt ?? this.createdAt,
      timeAgo: timeAgo ?? this.timeAgo,
    );
  }
}
