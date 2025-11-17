import 'package:freezed_annotation/freezed_annotation.dart';

part 'group_member_model.freezed.dart';
part 'group_member_model.g.dart';

/// Group member model for tracking group membership
@freezed
class GroupMemberModel with _$GroupMemberModel {
  const factory GroupMemberModel({
    required String id,
    required String groupId,
    required String userId,
    required String userName,
    String? avatarUrl,
    DateTime? joinedAt,
  }) = _GroupMemberModel;

  factory GroupMemberModel.fromJson(Map<String, dynamic> json) =>
      _$GroupMemberModelFromJson(json);
}
