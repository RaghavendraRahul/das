// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'instruction_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TeamInstructionImpl _$$TeamInstructionImplFromJson(
        Map<String, dynamic> json) =>
    _$TeamInstructionImpl(
      id: (json['id'] as num).toInt(),
      project: (json['project'] as num?)?.toInt(),
      projectName: json['project_name'] as String,
      recipients: (json['recipients'] as List<dynamic>)
          .map((e) => (e as num).toInt())
          .toList(),
      recipientEmails: (json['recipient_emails'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      recipientCount: (json['recipient_count'] as num).toInt(),
      subject: json['subject'] as String,
      instructions: json['instructions'] as String,
      sentBy: (json['sent_by'] as num).toInt(),
      sentByEmail: json['sent_by_email'] as String,
      sentAt: DateTime.parse(json['sent_at'] as String),
    );

Map<String, dynamic> _$$TeamInstructionImplToJson(
        _$TeamInstructionImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'project': instance.project,
      'project_name': instance.projectName,
      'recipients': instance.recipients,
      'recipient_emails': instance.recipientEmails,
      'recipient_count': instance.recipientCount,
      'subject': instance.subject,
      'instructions': instance.instructions,
      'sent_by': instance.sentBy,
      'sent_by_email': instance.sentByEmail,
      'sent_at': instance.sentAt.toIso8601String(),
    };

_$CreateTeamInstructionRequestImpl _$$CreateTeamInstructionRequestImplFromJson(
        Map<String, dynamic> json) =>
    _$CreateTeamInstructionRequestImpl(
      project: (json['project'] as num?)?.toInt(),
      recipients: (json['recipients'] as List<dynamic>)
          .map((e) => (e as num).toInt())
          .toList(),
      subject: json['subject'] as String,
      instructions: json['instructions'] as String,
    );

Map<String, dynamic> _$$CreateTeamInstructionRequestImplToJson(
        _$CreateTeamInstructionRequestImpl instance) =>
    <String, dynamic>{
      'project': instance.project,
      'recipients': instance.recipients,
      'subject': instance.subject,
      'instructions': instance.instructions,
    };
