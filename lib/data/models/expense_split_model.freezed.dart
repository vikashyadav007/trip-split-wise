// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'expense_split_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ExpenseSplitModel _$ExpenseSplitModelFromJson(Map<String, dynamic> json) {
  return _ExpenseSplitModel.fromJson(json);
}

/// @nodoc
mixin _$ExpenseSplitModel {
  String get id => throw _privateConstructorUsedError;
  String get expenseId => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  double get amount => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;

  /// Serializes this ExpenseSplitModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ExpenseSplitModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ExpenseSplitModelCopyWith<ExpenseSplitModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ExpenseSplitModelCopyWith<$Res> {
  factory $ExpenseSplitModelCopyWith(
          ExpenseSplitModel value, $Res Function(ExpenseSplitModel) then) =
      _$ExpenseSplitModelCopyWithImpl<$Res, ExpenseSplitModel>;
  @useResult
  $Res call(
      {String id,
      String expenseId,
      String userId,
      double amount,
      DateTime? createdAt});
}

/// @nodoc
class _$ExpenseSplitModelCopyWithImpl<$Res, $Val extends ExpenseSplitModel>
    implements $ExpenseSplitModelCopyWith<$Res> {
  _$ExpenseSplitModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ExpenseSplitModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? expenseId = null,
    Object? userId = null,
    Object? amount = null,
    Object? createdAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      expenseId: null == expenseId
          ? _value.expenseId
          : expenseId // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ExpenseSplitModelImplCopyWith<$Res>
    implements $ExpenseSplitModelCopyWith<$Res> {
  factory _$$ExpenseSplitModelImplCopyWith(_$ExpenseSplitModelImpl value,
          $Res Function(_$ExpenseSplitModelImpl) then) =
      __$$ExpenseSplitModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String expenseId,
      String userId,
      double amount,
      DateTime? createdAt});
}

/// @nodoc
class __$$ExpenseSplitModelImplCopyWithImpl<$Res>
    extends _$ExpenseSplitModelCopyWithImpl<$Res, _$ExpenseSplitModelImpl>
    implements _$$ExpenseSplitModelImplCopyWith<$Res> {
  __$$ExpenseSplitModelImplCopyWithImpl(_$ExpenseSplitModelImpl _value,
      $Res Function(_$ExpenseSplitModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of ExpenseSplitModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? expenseId = null,
    Object? userId = null,
    Object? amount = null,
    Object? createdAt = freezed,
  }) {
    return _then(_$ExpenseSplitModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      expenseId: null == expenseId
          ? _value.expenseId
          : expenseId // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ExpenseSplitModelImpl implements _ExpenseSplitModel {
  const _$ExpenseSplitModelImpl(
      {required this.id,
      required this.expenseId,
      required this.userId,
      required this.amount,
      this.createdAt});

  factory _$ExpenseSplitModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ExpenseSplitModelImplFromJson(json);

  @override
  final String id;
  @override
  final String expenseId;
  @override
  final String userId;
  @override
  final double amount;
  @override
  final DateTime? createdAt;

  @override
  String toString() {
    return 'ExpenseSplitModel(id: $id, expenseId: $expenseId, userId: $userId, amount: $amount, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ExpenseSplitModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.expenseId, expenseId) ||
                other.expenseId == expenseId) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, expenseId, userId, amount, createdAt);

  /// Create a copy of ExpenseSplitModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ExpenseSplitModelImplCopyWith<_$ExpenseSplitModelImpl> get copyWith =>
      __$$ExpenseSplitModelImplCopyWithImpl<_$ExpenseSplitModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ExpenseSplitModelImplToJson(
      this,
    );
  }
}

abstract class _ExpenseSplitModel implements ExpenseSplitModel {
  const factory _ExpenseSplitModel(
      {required final String id,
      required final String expenseId,
      required final String userId,
      required final double amount,
      final DateTime? createdAt}) = _$ExpenseSplitModelImpl;

  factory _ExpenseSplitModel.fromJson(Map<String, dynamic> json) =
      _$ExpenseSplitModelImpl.fromJson;

  @override
  String get id;
  @override
  String get expenseId;
  @override
  String get userId;
  @override
  double get amount;
  @override
  DateTime? get createdAt;

  /// Create a copy of ExpenseSplitModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ExpenseSplitModelImplCopyWith<_$ExpenseSplitModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
