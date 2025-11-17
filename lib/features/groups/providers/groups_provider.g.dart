// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'groups_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$userGroupsHash() => r'040eabc7ea09874261b4c828f0cc36e8f9d66f5f';

/// Provider for user's groups stream
///
/// Copied from [userGroups].
@ProviderFor(userGroups)
final userGroupsProvider = AutoDisposeStreamProvider<List<GroupModel>>.internal(
  userGroups,
  name: r'userGroupsProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$userGroupsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef UserGroupsRef = AutoDisposeStreamProviderRef<List<GroupModel>>;
String _$groupMembersHash() => r'551d4e92a5c73ecc13072300b0d9cad247364e57';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// Provider for group members
///
/// Copied from [groupMembers].
@ProviderFor(groupMembers)
const groupMembersProvider = GroupMembersFamily();

/// Provider for group members
///
/// Copied from [groupMembers].
class GroupMembersFamily extends Family<AsyncValue<List<GroupMemberModel>>> {
  /// Provider for group members
  ///
  /// Copied from [groupMembers].
  const GroupMembersFamily();

  /// Provider for group members
  ///
  /// Copied from [groupMembers].
  GroupMembersProvider call(
    String groupId,
  ) {
    return GroupMembersProvider(
      groupId,
    );
  }

  @override
  GroupMembersProvider getProviderOverride(
    covariant GroupMembersProvider provider,
  ) {
    return call(
      provider.groupId,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'groupMembersProvider';
}

/// Provider for group members
///
/// Copied from [groupMembers].
class GroupMembersProvider
    extends AutoDisposeFutureProvider<List<GroupMemberModel>> {
  /// Provider for group members
  ///
  /// Copied from [groupMembers].
  GroupMembersProvider(
    String groupId,
  ) : this._internal(
          (ref) => groupMembers(
            ref as GroupMembersRef,
            groupId,
          ),
          from: groupMembersProvider,
          name: r'groupMembersProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$groupMembersHash,
          dependencies: GroupMembersFamily._dependencies,
          allTransitiveDependencies:
              GroupMembersFamily._allTransitiveDependencies,
          groupId: groupId,
        );

  GroupMembersProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.groupId,
  }) : super.internal();

  final String groupId;

  @override
  Override overrideWith(
    FutureOr<List<GroupMemberModel>> Function(GroupMembersRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: GroupMembersProvider._internal(
        (ref) => create(ref as GroupMembersRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        groupId: groupId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<GroupMemberModel>> createElement() {
    return _GroupMembersProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is GroupMembersProvider && other.groupId == groupId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, groupId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin GroupMembersRef on AutoDisposeFutureProviderRef<List<GroupMemberModel>> {
  /// The parameter `groupId` of this provider.
  String get groupId;
}

class _GroupMembersProviderElement
    extends AutoDisposeFutureProviderElement<List<GroupMemberModel>>
    with GroupMembersRef {
  _GroupMembersProviderElement(super.provider);

  @override
  String get groupId => (origin as GroupMembersProvider).groupId;
}

String _$createGroupControllerHash() =>
    r'c1cfcc812d074a0c0a170673f3205d58e177fb38';

/// Create group controller
///
/// Copied from [CreateGroupController].
@ProviderFor(CreateGroupController)
final createGroupControllerProvider =
    AutoDisposeAsyncNotifierProvider<CreateGroupController, void>.internal(
  CreateGroupController.new,
  name: r'createGroupControllerProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$createGroupControllerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$CreateGroupController = AutoDisposeAsyncNotifier<void>;
String _$updateGroupControllerHash() =>
    r'dda644bb3b21799cd0f6a054ca8d34a26c7a734e';

/// Update group controller
///
/// Copied from [UpdateGroupController].
@ProviderFor(UpdateGroupController)
final updateGroupControllerProvider =
    AutoDisposeAsyncNotifierProvider<UpdateGroupController, void>.internal(
  UpdateGroupController.new,
  name: r'updateGroupControllerProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$updateGroupControllerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$UpdateGroupController = AutoDisposeAsyncNotifier<void>;
String _$deleteGroupControllerHash() =>
    r'daa7af40693f9b58588c19ab4759a8c7945d6390';

/// Delete group controller
///
/// Copied from [DeleteGroupController].
@ProviderFor(DeleteGroupController)
final deleteGroupControllerProvider =
    AutoDisposeAsyncNotifierProvider<DeleteGroupController, void>.internal(
  DeleteGroupController.new,
  name: r'deleteGroupControllerProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$deleteGroupControllerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$DeleteGroupController = AutoDisposeAsyncNotifier<void>;
String _$addGroupMemberControllerHash() =>
    r'bb0ac252fca79450eb076bd1356c6429dcff6677';

/// Add member controller
///
/// Copied from [AddGroupMemberController].
@ProviderFor(AddGroupMemberController)
final addGroupMemberControllerProvider =
    AutoDisposeAsyncNotifierProvider<AddGroupMemberController, void>.internal(
  AddGroupMemberController.new,
  name: r'addGroupMemberControllerProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$addGroupMemberControllerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$AddGroupMemberController = AutoDisposeAsyncNotifier<void>;
String _$removeGroupMemberControllerHash() =>
    r'ec3a8e695aa2f3202e977053d3af30dc23c08fe5';

/// Remove member controller
///
/// Copied from [RemoveGroupMemberController].
@ProviderFor(RemoveGroupMemberController)
final removeGroupMemberControllerProvider = AutoDisposeAsyncNotifierProvider<
    RemoveGroupMemberController, void>.internal(
  RemoveGroupMemberController.new,
  name: r'removeGroupMemberControllerProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$removeGroupMemberControllerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$RemoveGroupMemberController = AutoDisposeAsyncNotifier<void>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
