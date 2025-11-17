import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../data/models/group_model.dart';
import '../../../data/models/group_member_model.dart';
import '../../../data/repositories/group_repository.dart';
import '../../auth/providers/auth_provider.dart';

part 'groups_provider.g.dart';

/// Provider for user's groups stream
@riverpod
Stream<List<GroupModel>> userGroups(UserGroupsRef ref) {
  final currentUserAsync = ref.watch(currentUserProvider);

  return currentUserAsync.when(
    data: (user) {
      if (user == null) {
        return Stream.value([]);
      }
      final repo = ref.watch(groupRepositoryProvider);
      return repo.watchGroupsForUser(user.id);
    },
    loading: () => Stream.value([]),
    error: (_, __) => Stream.value([]),
  );
}

/// Provider for group members
@riverpod
Future<List<GroupMemberModel>> groupMembers(
    GroupMembersRef ref, String groupId) {
  final repo = ref.watch(groupRepositoryProvider);
  return repo.getGroupMembersWithInfo(groupId);
}

/// Create group controller
@riverpod
class CreateGroupController extends _$CreateGroupController {
  @override
  FutureOr<void> build() {}

  Future<GroupModel?> createGroup({
    required String name,
    required String createdBy,
    String? description,
  }) async {
    state = const AsyncLoading();

    final repo = ref.read(groupRepositoryProvider);

    GroupModel? createdGroup;
    state = await AsyncValue.guard(() async {
      createdGroup = await repo.createGroup(
        name: name,
        createdBy: createdBy,
        description: description,
      );

      // Invalidate groups list to refresh
      ref.invalidate(userGroupsProvider);
    });

    return createdGroup;
  }
}

/// Update group controller
@riverpod
class UpdateGroupController extends _$UpdateGroupController {
  @override
  FutureOr<void> build() {}

  Future<void> updateGroup({
    required String groupId,
    String? name,
    String? description,
  }) async {
    state = const AsyncLoading();

    final repo = ref.read(groupRepositoryProvider);

    state = await AsyncValue.guard(() async {
      await repo.updateGroup(
        groupId: groupId,
        name: name,
        description: description,
      );

      // Invalidate groups list to refresh
      ref.invalidate(userGroupsProvider);
    });
  }
}

/// Delete group controller
@riverpod
class DeleteGroupController extends _$DeleteGroupController {
  @override
  FutureOr<void> build() {}

  Future<void> deleteGroup(String groupId) async {
    state = const AsyncLoading();

    final repo = ref.read(groupRepositoryProvider);

    state = await AsyncValue.guard(() async {
      await repo.deleteGroup(groupId);

      // Invalidate groups list to refresh
      ref.invalidate(userGroupsProvider);
    });
  }
}

/// Add member controller
@riverpod
class AddGroupMemberController extends _$AddGroupMemberController {
  @override
  FutureOr<void> build() {}

  Future<void> addMember({
    required String groupId,
    required String userId,
  }) async {
    state = const AsyncLoading();

    final repo = ref.read(groupRepositoryProvider);

    state = await AsyncValue.guard(() async {
      await repo.addGroupMember(groupId: groupId, userId: userId);

      // Invalidate group members to refresh
      ref.invalidate(groupMembersProvider);
    });
  }
}

/// Remove member controller
@riverpod
class RemoveGroupMemberController extends _$RemoveGroupMemberController {
  @override
  FutureOr<void> build() {}

  Future<void> removeMember({
    required String groupId,
    required String userId,
  }) async {
    state = const AsyncLoading();

    final repo = ref.read(groupRepositoryProvider);

    state = await AsyncValue.guard(() async {
      await repo.removeGroupMember(groupId: groupId, userId: userId);

      // Invalidate group members to refresh
      ref.invalidate(groupMembersProvider);
    });
  }
}
