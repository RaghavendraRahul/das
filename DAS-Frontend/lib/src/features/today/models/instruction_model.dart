import 'package:freezed_annotation/freezed_annotation.dart';

part 'instruction_model.freezed.dart';
part 'instruction_model.g.dart';

@freezed
class TeamInstruction with _$TeamInstruction {
  const factory TeamInstruction({
    required int id,
    int? project,
    @JsonKey(name: 'project_name') required String projectName,
    required List<int> recipients,
    @JsonKey(name: 'recipient_emails') required List<String> recipientEmails,
    @JsonKey(name: 'recipient_count') required int recipientCount,
    required String subject,
    required String instructions,
    @JsonKey(name: 'sent_by') required int sentBy,
    @JsonKey(name: 'sent_by_email') required String sentByEmail,
    @JsonKey(name: 'sent_at') required DateTime sentAt,
  }) = _TeamInstruction;

  factory TeamInstruction.fromJson(Map<String, dynamic> json) =>
      _$TeamInstructionFromJson(json);
}

@freezed
class CreateTeamInstructionRequest with _$CreateTeamInstructionRequest {
  const factory CreateTeamInstructionRequest({
    int? project,
    required List<int> recipients,
    required String subject,
    required String instructions,
  }) = _CreateTeamInstructionRequest;

  factory CreateTeamInstructionRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateTeamInstructionRequestFromJson(json);
}
