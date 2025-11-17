// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'expense_split_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ExpenseSplitModelImpl _$$ExpenseSplitModelImplFromJson(
        Map<String, dynamic> json) =>
    _$ExpenseSplitModelImpl(
      id: json['id'] as String,
      expenseId: json['expenseId'] as String,
      userId: json['userId'] as String,
      amount: (json['amount'] as num).toDouble(),
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$ExpenseSplitModelImplToJson(
        _$ExpenseSplitModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'expenseId': instance.expenseId,
      'userId': instance.userId,
      'amount': instance.amount,
      'createdAt': instance.createdAt?.toIso8601String(),
    };
