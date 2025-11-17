import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../core/config/supabase_config.dart';
import '../../core/constants/app_constants.dart';
import '../models/group_model.dart';
import '../models/group_member_model.dart';
import '../models/user_model.dart';

part 'group_repository.g.dart';

/// Repository for group operations
class GroupRepository {
  final _supabase = supabase;

  /// Get all groups for a user
  Future<List<GroupModel>> getUserGroups(String userId) async {
    try {
      final response = await _supabase
          .from(TableNames.groups)
          .select()
          .eq('created_by', userId)
          .order('created_at', ascending: false);

      return (response as List)
          .map((json) => GroupModel.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to get groups: $e');
    }
  }

  /// Get groups where user is a member (including created groups)
  Future<List<GroupModel>> getGroupsForUser(String userId) async {
    try {
      // Get group IDs where user is a member
      final memberResponse = await _supabase
          .from(TableNames.groupMembers)
          .select('group_id')
          .eq('user_id', userId);

      final groupIds = (memberResponse as List)
          .map((item) => item['group_id'] as String)
          .toList();

      if (groupIds.isEmpty) {
        return [];
      }

      // Get group details
      final groupsResponse = await _supabase
          .from(TableNames.groups)
          .select()
          .inFilter('id', groupIds)
          .order('created_at', ascending: false);

      return (groupsResponse as List)
          .map((json) => GroupModel.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to get groups for user: $e');
    }
  }

  /// Get groups for user as a stream (for real-time updates)
  Stream<List<GroupModel>> watchGroupsForUser(String userId) {
    return _supabase
        .from(TableNames.groupMembers)
        .stream(primaryKey: ['id'])
        .eq('user_id', userId)
        .asyncMap((memberData) async {
          final groupIds =
              memberData.map((item) => item['group_id'] as String).toList();

          if (groupIds.isEmpty) return <GroupModel>[];

          final groupsResponse = await _supabase
              .from(TableNames.groups)
              .select()
              .inFilter('id', groupIds)
              .order('created_at', ascending: false);

          return (groupsResponse as List)
              .map((json) => GroupModel.fromJson(json))
              .toList();
        });
  }

  /// Create a new group
  Future<GroupModel> createGroup({
    required String name,
    required String createdBy,
    String? description,
  }) async {
    try {
      // Create group
      final groupResponse = await _supabase
          .from(TableNames.groups)
          .insert({
            'name': name,
            'created_by': createdBy,
            if (description != null) 'description': description,
          })
          .select()
          .single();

      final group = GroupModel.fromJson(groupResponse);

      // Add creator as member
      await _supabase.from(TableNames.groupMembers).insert({
        'group_id': group.id,
        'user_id': createdBy,
      });

      return group;
    } catch (e) {
      throw Exception('Failed to create group: $e');
    }
  }

  /// Update group
  Future<GroupModel> updateGroup({
    required String groupId,
    String? name,
    String? description,
  }) async {
    try {
      final response = await _supabase
          .from(TableNames.groups)
          .update({
            if (name != null) 'name': name,
            if (description != null) 'description': description,
          })
          .eq('id', groupId)
          .select()
          .single();

      return GroupModel.fromJson(response);
    } catch (e) {
      throw Exception('Failed to update group: $e');
    }
  }

  /// Delete group
  Future<void> deleteGroup(String groupId) async {
    try {
      await _supabase.from(TableNames.groups).delete().eq('id', groupId);
    } catch (e) {
      throw Exception('Failed to delete group: $e');
    }
  }

  /// Get group members with their join info
  Future<List<GroupMemberModel>> getGroupMembersWithInfo(String groupId) async {
    try {
      final response = await _supabase
          .from(TableNames.groupMembers)
          .select('*, ${TableNames.users}(*)')
          .eq('group_id', groupId);

      return (response as List).map((item) {
        final user = UserModel.fromJson(item['users']);
        return GroupMemberModel(
          id: item['id'],
          groupId: item['group_id'],
          userId: user.id,
          userName: user.displayName ?? user.email,
          avatarUrl: user.avatarUrl,
          joinedAt: DateTime.parse(item['joined_at']),
        );
      }).toList();
    } catch (e) {
      throw Exception('Failed to get group members: $e');
    }
  }

  /// Get group members (legacy - returns UserModel only)
  Future<List<UserModel>> getGroupMembers(String groupId) async {
    try {
      final response = await _supabase
          .from(TableNames.groupMembers)
          .select('user_id, ${TableNames.users}(*)')
          .eq('group_id', groupId);

      return (response as List)
          .map((item) => UserModel.fromJson(item['users']))
          .toList();
    } catch (e) {
      throw Exception('Failed to get group members: $e');
    }
  }

  /// Add member to group
  Future<void> addGroupMember({
    required String groupId,
    required String userId,
  }) async {
    try {
      await _supabase.from(TableNames.groupMembers).insert({
        'group_id': groupId,
        'user_id': userId,
      });
    } catch (e) {
      throw Exception('Failed to add group member: $e');
    }
  }

  /// Remove member from group
  Future<void> removeGroupMember({
    required String groupId,
    required String userId,
  }) async {
    try {
      await _supabase
          .from(TableNames.groupMembers)
          .delete()
          .eq('group_id', groupId)
          .eq('user_id', userId);
    } catch (e) {
      throw Exception('Failed to remove group member: $e');
    }
  }

  /// Check if user is member of group
  Future<bool> isGroupMember({
    required String groupId,
    required String userId,
  }) async {
    try {
      final response = await _supabase
          .from(TableNames.groupMembers)
          .select()
          .eq('group_id', groupId)
          .eq('user_id', userId)
          .maybeSingle();

      return response != null;
    } catch (e) {
      throw Exception('Failed to check group membership: $e');
    }
  }
}

/// Provider for GroupRepository
@riverpod
GroupRepository groupRepository(GroupRepositoryRef ref) {
  return GroupRepository();
}

/// Provider for user's groups stream
@riverpod
Stream<List<GroupModel>> userGroups(UserGroupsRef ref, String userId) {
  final repo = ref.watch(groupRepositoryProvider);
  return repo.watchGroupsForUser(userId);
}
