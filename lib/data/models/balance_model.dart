import 'package:freezed_annotation/freezed_annotation.dart';

part 'balance_model.freezed.dart';
part 'balance_model.g.dart';

/// Balance model for tracking user balances in a group
@freezed
class BalanceModel with _$BalanceModel {
  const factory BalanceModel({
    required String userId,
    required String userName,
    required double balance,
  }) = _BalanceModel;

  factory BalanceModel.fromJson(Map<String, dynamic> json) =>
      _$BalanceModelFromJson(json);
}
