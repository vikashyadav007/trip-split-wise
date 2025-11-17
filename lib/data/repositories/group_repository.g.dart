// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'group_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$groupRepositoryHash() => r'bf89d04afc9d50fcdfdf3038118e1133413496eb';

/// Provider for GroupRepository
///
/// Copied from [groupRepository].
@ProviderFor(groupRepository)
final groupRepositoryProvider = AutoDisposeProvider<GroupRepository>.internal(
  groupRepository,
  name: r'groupRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$groupRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef GroupRepositoryRef = AutoDisposeProviderRef<GroupRepository>;
String _$userGroupsHash() => r'91b4cb7ed80921fcff06ec247338506de8452015';

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

/// Provider for user's groups stream
///
/// Copied from [userGroups].
@ProviderFor(userGroups)
const userGroupsProvider = UserGroupsFamily();

/// Provider for user's groups stream
///
/// Copied from [userGroups].
class UserGroupsFamily extends Family<AsyncValue<List<GroupModel>>> {
  /// Provider for user's groups stream
  ///
  /// Copied from [userGroups].
  const UserGroupsFamily();

  /// Provider for user's groups stream
  ///
  /// Copied from [userGroups].
  UserGroupsProvider call(
    String userId,
  ) {
    return UserGroupsProvider(
      userId,
    );
  }

  @override
  UserGroupsProvider getProviderOverride(
    covariant UserGroupsProvider provider,
  ) {
    return call(
      provider.userId,
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
  String? get name => r'userGroupsProvider';
}

/// Provider for user's groups stream
///
/// Copied from [userGroups].
class UserGroupsProvider extends AutoDisposeStreamProvider<List<GroupModel>> {
  /// Provider for user's groups stream
  ///
  /// Copied from [userGroups].
  UserGroupsProvider(
    String userId,
  ) : this._internal(
          (ref) => userGroups(
            ref as UserGroupsRef,
            userId,
          ),
          from: userGroupsProvider,
          name: r'userGroupsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$userGroupsHash,
          dependencies: UserGroupsFamily._dependencies,
          allTransitiveDependencies:
              UserGroupsFamily._allTransitiveDependencies,
          userId: userId,
        );

  UserGroupsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.userId,
  }) : super.internal();

  final String userId;

  @override
  Override overrideWith(
    Stream<List<GroupModel>> Function(UserGroupsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: UserGroupsProvider._internal(
        (ref) => create(ref as UserGroupsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        userId: userId,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<List<GroupModel>> createElement() {
    return _UserGroupsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is UserGroupsProvider && other.userId == userId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, userId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin UserGroupsRef on AutoDisposeStreamProviderRef<List<GroupModel>> {
  /// The parameter `userId` of this provider.
  String get userId;
}

class _UserGroupsProviderElement
    extends AutoDisposeStreamProviderElement<List<GroupModel>>
    with UserGroupsRef {
  _UserGroupsProviderElement(super.provider);

  @override
  String get userId => (origin as UserGroupsProvider).userId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
