// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'expense_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$expenseRepositoryHash() => r'0c0e6d8572ec7e1cd9823c9758305f21ea90efc0';

/// Provider for ExpenseRepository
///
/// Copied from [expenseRepository].
@ProviderFor(expenseRepository)
final expenseRepositoryProvider =
    AutoDisposeProvider<ExpenseRepository>.internal(
  expenseRepository,
  name: r'expenseRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$expenseRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ExpenseRepositoryRef = AutoDisposeProviderRef<ExpenseRepository>;
String _$groupExpensesHash() => r'22f94b0cf6520165a875ab1ba770ac408129f9b9';

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

/// Provider for group expenses stream
///
/// Copied from [groupExpenses].
@ProviderFor(groupExpenses)
const groupExpensesProvider = GroupExpensesFamily();

/// Provider for group expenses stream
///
/// Copied from [groupExpenses].
class GroupExpensesFamily extends Family<AsyncValue<List<ExpenseModel>>> {
  /// Provider for group expenses stream
  ///
  /// Copied from [groupExpenses].
  const GroupExpensesFamily();

  /// Provider for group expenses stream
  ///
  /// Copied from [groupExpenses].
  GroupExpensesProvider call(
    String groupId,
  ) {
    return GroupExpensesProvider(
      groupId,
    );
  }

  @override
  GroupExpensesProvider getProviderOverride(
    covariant GroupExpensesProvider provider,
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
  String? get name => r'groupExpensesProvider';
}

/// Provider for group expenses stream
///
/// Copied from [groupExpenses].
class GroupExpensesProvider
    extends AutoDisposeStreamProvider<List<ExpenseModel>> {
  /// Provider for group expenses stream
  ///
  /// Copied from [groupExpenses].
  GroupExpensesProvider(
    String groupId,
  ) : this._internal(
          (ref) => groupExpenses(
            ref as GroupExpensesRef,
            groupId,
          ),
          from: groupExpensesProvider,
          name: r'groupExpensesProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$groupExpensesHash,
          dependencies: GroupExpensesFamily._dependencies,
          allTransitiveDependencies:
              GroupExpensesFamily._allTransitiveDependencies,
          groupId: groupId,
        );

  GroupExpensesProvider._internal(
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
    Stream<List<ExpenseModel>> Function(GroupExpensesRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: GroupExpensesProvider._internal(
        (ref) => create(ref as GroupExpensesRef),
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
  AutoDisposeStreamProviderElement<List<ExpenseModel>> createElement() {
    return _GroupExpensesProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is GroupExpensesProvider && other.groupId == groupId;
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
mixin GroupExpensesRef on AutoDisposeStreamProviderRef<List<ExpenseModel>> {
  /// The parameter `groupId` of this provider.
  String get groupId;
}

class _GroupExpensesProviderElement
    extends AutoDisposeStreamProviderElement<List<ExpenseModel>>
    with GroupExpensesRef {
  _GroupExpensesProviderElement(super.provider);

  @override
  String get groupId => (origin as GroupExpensesProvider).groupId;
}

String _$groupBalancesHash() => r'0244bc27d35a0acfede9ea2aba2e85e0ccb6306d';

/// Provider for group balances
///
/// Copied from [groupBalances].
@ProviderFor(groupBalances)
const groupBalancesProvider = GroupBalancesFamily();

/// Provider for group balances
///
/// Copied from [groupBalances].
class GroupBalancesFamily extends Family<AsyncValue<List<BalanceModel>>> {
  /// Provider for group balances
  ///
  /// Copied from [groupBalances].
  const GroupBalancesFamily();

  /// Provider for group balances
  ///
  /// Copied from [groupBalances].
  GroupBalancesProvider call(
    String groupId,
  ) {
    return GroupBalancesProvider(
      groupId,
    );
  }

  @override
  GroupBalancesProvider getProviderOverride(
    covariant GroupBalancesProvider provider,
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
  String? get name => r'groupBalancesProvider';
}

/// Provider for group balances
///
/// Copied from [groupBalances].
class GroupBalancesProvider
    extends AutoDisposeFutureProvider<List<BalanceModel>> {
  /// Provider for group balances
  ///
  /// Copied from [groupBalances].
  GroupBalancesProvider(
    String groupId,
  ) : this._internal(
          (ref) => groupBalances(
            ref as GroupBalancesRef,
            groupId,
          ),
          from: groupBalancesProvider,
          name: r'groupBalancesProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$groupBalancesHash,
          dependencies: GroupBalancesFamily._dependencies,
          allTransitiveDependencies:
              GroupBalancesFamily._allTransitiveDependencies,
          groupId: groupId,
        );

  GroupBalancesProvider._internal(
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
    FutureOr<List<BalanceModel>> Function(GroupBalancesRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: GroupBalancesProvider._internal(
        (ref) => create(ref as GroupBalancesRef),
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
  AutoDisposeFutureProviderElement<List<BalanceModel>> createElement() {
    return _GroupBalancesProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is GroupBalancesProvider && other.groupId == groupId;
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
mixin GroupBalancesRef on AutoDisposeFutureProviderRef<List<BalanceModel>> {
  /// The parameter `groupId` of this provider.
  String get groupId;
}

class _GroupBalancesProviderElement
    extends AutoDisposeFutureProviderElement<List<BalanceModel>>
    with GroupBalancesRef {
  _GroupBalancesProviderElement(super.provider);

  @override
  String get groupId => (origin as GroupBalancesProvider).groupId;
}

String _$expenseSplitsHash() => r'e918a058b3a78ea826d24e463e5805f2be865603';

/// Provider for expense splits
///
/// Copied from [expenseSplits].
@ProviderFor(expenseSplits)
const expenseSplitsProvider = ExpenseSplitsFamily();

/// Provider for expense splits
///
/// Copied from [expenseSplits].
class ExpenseSplitsFamily extends Family<AsyncValue<List<ExpenseSplitModel>>> {
  /// Provider for expense splits
  ///
  /// Copied from [expenseSplits].
  const ExpenseSplitsFamily();

  /// Provider for expense splits
  ///
  /// Copied from [expenseSplits].
  ExpenseSplitsProvider call(
    String expenseId,
  ) {
    return ExpenseSplitsProvider(
      expenseId,
    );
  }

  @override
  ExpenseSplitsProvider getProviderOverride(
    covariant ExpenseSplitsProvider provider,
  ) {
    return call(
      provider.expenseId,
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
  String? get name => r'expenseSplitsProvider';
}

/// Provider for expense splits
///
/// Copied from [expenseSplits].
class ExpenseSplitsProvider
    extends AutoDisposeFutureProvider<List<ExpenseSplitModel>> {
  /// Provider for expense splits
  ///
  /// Copied from [expenseSplits].
  ExpenseSplitsProvider(
    String expenseId,
  ) : this._internal(
          (ref) => expenseSplits(
            ref as ExpenseSplitsRef,
            expenseId,
          ),
          from: expenseSplitsProvider,
          name: r'expenseSplitsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$expenseSplitsHash,
          dependencies: ExpenseSplitsFamily._dependencies,
          allTransitiveDependencies:
              ExpenseSplitsFamily._allTransitiveDependencies,
          expenseId: expenseId,
        );

  ExpenseSplitsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.expenseId,
  }) : super.internal();

  final String expenseId;

  @override
  Override overrideWith(
    FutureOr<List<ExpenseSplitModel>> Function(ExpenseSplitsRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ExpenseSplitsProvider._internal(
        (ref) => create(ref as ExpenseSplitsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        expenseId: expenseId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<ExpenseSplitModel>> createElement() {
    return _ExpenseSplitsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ExpenseSplitsProvider && other.expenseId == expenseId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, expenseId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ExpenseSplitsRef
    on AutoDisposeFutureProviderRef<List<ExpenseSplitModel>> {
  /// The parameter `expenseId` of this provider.
  String get expenseId;
}

class _ExpenseSplitsProviderElement
    extends AutoDisposeFutureProviderElement<List<ExpenseSplitModel>>
    with ExpenseSplitsRef {
  _ExpenseSplitsProviderElement(super.provider);

  @override
  String get expenseId => (origin as ExpenseSplitsProvider).expenseId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
