import 'package:freezed_annotation/freezed_annotation.dart';

part 'expense_model.freezed.dart';
part 'expense_model.g.dart';

/// Expense model for tracking group expenses
@freezed
class ExpenseModel with _$ExpenseModel {
  const factory ExpenseModel({
    required String id,
    required String groupId,
    required String description,
    required double amount,
    required String paidBy,
    String? category,
    required DateTime date,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _ExpenseModel;

  factory ExpenseModel.fromJson(Map<String, dynamic> json) =>
      _$ExpenseModelFromJson(json);
}
