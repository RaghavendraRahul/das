class ApprovalRequest {
  final int id;
  final String referenceType; // 'PROJECT', 'TASK'
  final int referenceId;
  final String approvalType; // 'CREATION', 'COMPLETION', 'MODIFICATION'
  final String status; // 'PENDING', 'APPROVED', 'REJECTED'
  final String requestedByEmail;
  final DateTime requestedAt;
  final Map<String, dynamic>? requestData;

  // Helper fields from API
  final String? projectName;
  final String? taskTitle;
  final String? description;

  ApprovalRequest({
    required this.id,
    required this.referenceType,
    required this.referenceId,
    required this.approvalType,
    required this.status,
    required this.requestedByEmail,
    required this.requestedAt,
    this.requestData,
    this.projectName,
    this.taskTitle,
    this.description,
  });

  factory ApprovalRequest.fromJson(Map<String, dynamic> json) {
    return ApprovalRequest(
      id: json['approval_id'] ?? json['id'],
      referenceType: json['reference_type'] ?? 'UNKNOWN',
      referenceId:
          json['reference_id'] ?? json['project_id'] ?? json['task_id'] ?? 0,
      approvalType: json['approval_type'] ?? 'UNKNOWN',
      status: json['status'] ?? 'PENDING',
      requestedByEmail: json['requested_by'] ?? '',
      requestedAt: DateTime.parse(json['requested_at'] ?? json['created_at']),
      requestData: json['request_data'],
      // Map flattened fields from custom endpoints
      projectName: json['project_name'] ?? json['project'],
      taskTitle: json['task_title'],
      description: json['description'],
    );
  }
}
