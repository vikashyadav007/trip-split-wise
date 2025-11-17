// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'balance_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BalanceModelImpl _$$BalanceModelImplFromJson(Map<String, dynamic> json) =>
    _$BalanceModelImpl(
      userId: json['userId'] as String,
      userName: json['userName'] as String,
      balance: (json['balance'] as num).toDouble(),
    );

Map<String, dynamic> _$$BalanceModelImplToJson(_$BalanceModelImpl instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'userName': instance.userName,
      'balance': instance.balance,
    };
