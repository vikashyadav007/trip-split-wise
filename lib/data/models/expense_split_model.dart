import 'package:freezed_annotation/freezed_annotation.dart';

part 'expense_split_model.freezed.dart';
part 'expense_split_model.g.dart';

/// Expense split model for tracking how expenses are divided
@freezed
class ExpenseSplitModel with _$ExpenseSplitModel {
  const factory ExpenseSplitModel({
    required String id,
    required String expenseId,
    required String userId,
    required double amount,
    DateTime? createdAt,
  }) = _ExpenseSplitModel;

  factory ExpenseSplitModel.fromJson(Map<String, dynamic> json) =>
      _$ExpenseSplitModelFromJson(json);
}

/// Split type enum for UI
enum SplitType {
  equal,
  custom,
}
