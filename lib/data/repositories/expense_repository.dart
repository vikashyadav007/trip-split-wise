import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../core/config/supabase_config.dart';
import '../../core/constants/app_constants.dart';
import '../models/expense_model.dart';
import '../models/expense_split_model.dart';
import '../models/balance_model.dart';

part 'expense_repository.g.dart';

/// Repository for expense operations
class ExpenseRepository {
  final _supabase = supabase;

  /// Get expenses for a group
  Future<List<ExpenseModel>> getGroupExpenses(String groupId) async {
    try {
      final response = await _supabase
          .from(TableNames.expenses)
          .select()
          .eq('group_id', groupId)
          .order('date', ascending: false);

      return (response as List)
          .map((json) => ExpenseModel.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to get expenses: $e');
    }
  }

  /// Watch expenses for a group (real-time)
  Stream<List<ExpenseModel>> watchGroupExpenses(String groupId) {
    return _supabase
        .from(TableNames.expenses)
        .stream(primaryKey: ['id'])
        .eq('group_id', groupId)
        .order('date', ascending: false)
        .map(
            (data) => data.map((json) => ExpenseModel.fromJson(json)).toList());
  }

  /// Create expense with splits
  Future<ExpenseModel> createExpense({
    required String groupId,
    required String description,
    required double amount,
    required String paidBy,
    required List<ExpenseSplitModel> splits,
    String? category,
    DateTime? date,
  }) async {
    try {
      // Validate splits total equals expense amount
      final splitsTotal = splits.fold<double>(
        0,
        (sum, split) => sum + split.amount,
      );

      if ((splitsTotal - amount).abs() > 0.01) {
        throw Exception('Splits total must equal expense amount');
      }

      // Create expense
      final expenseResponse = await _supabase
          .from(TableNames.expenses)
          .insert({
            'group_id': groupId,
            'description': description,
            'amount': amount,
            'paid_by': paidBy,
            if (category != null) 'category': category,
            'date': (date ?? DateTime.now()).toIso8601String().split('T')[0],
          })
          .select()
          .single();

      final expense = ExpenseModel.fromJson(expenseResponse);

      // Create splits
      await _supabase.from(TableNames.expenseSplits).insert(
            splits
                .map((split) => {
                      'expense_id': expense.id,
                      'user_id': split.userId,
                      'amount': split.amount,
                    })
                .toList(),
          );

      return expense;
    } catch (e) {
      throw Exception('Failed to create expense: $e');
    }
  }

  /// Update expense
  Future<ExpenseModel> updateExpense({
    required String expenseId,
    String? description,
    double? amount,
    String? category,
    DateTime? date,
    List<ExpenseSplitModel>? splits,
  }) async {
    try {
      // Update expense
      final expenseResponse = await _supabase
          .from(TableNames.expenses)
          .update({
            if (description != null) 'description': description,
            if (amount != null) 'amount': amount,
            if (category != null) 'category': category,
            if (date != null) 'date': date.toIso8601String().split('T')[0],
          })
          .eq('id', expenseId)
          .select()
          .single();

      final expense = ExpenseModel.fromJson(expenseResponse);

      // Update splits if provided
      if (splits != null) {
        // Validate splits total
        final splitsTotal = splits.fold<double>(
          0,
          (sum, split) => sum + split.amount,
        );

        final targetAmount = amount ?? expense.amount;
        if ((splitsTotal - targetAmount).abs() > 0.01) {
          throw Exception('Splits total must equal expense amount');
        }

        // Delete old splits
        await _supabase
            .from(TableNames.expenseSplits)
            .delete()
            .eq('expense_id', expenseId);

        // Insert new splits
        await _supabase.from(TableNames.expenseSplits).insert(
              splits
                  .map((split) => {
                        'expense_id': expenseId,
                        'user_id': split.userId,
                        'amount': split.amount,
                      })
                  .toList(),
            );
      }

      return expense;
    } catch (e) {
      throw Exception('Failed to update expense: $e');
    }
  }

  /// Delete expense
  Future<void> deleteExpense(String expenseId) async {
    try {
      await _supabase.from(TableNames.expenses).delete().eq('id', expenseId);
    } catch (e) {
      throw Exception('Failed to delete expense: $e');
    }
  }

  /// Get expense splits for an expense
  Future<List<ExpenseSplitModel>> getExpenseSplits(String expenseId) async {
    try {
      final response = await _supabase
          .from(TableNames.expenseSplits)
          .select()
          .eq('expense_id', expenseId);

      return (response as List)
          .map((json) => ExpenseSplitModel.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to get expense splits: $e');
    }
  }

  /// Get balance summary for a group
  Future<List<BalanceModel>> getGroupBalances(String groupId) async {
    try {
      final response = await _supabase.rpc(
        'get_group_balances',
        params: {'p_group_id': groupId},
      );

      return (response as List)
          .map((json) => BalanceModel.fromJson({
                'userId': json['user_id'],
                'userName': json['user_name'] ?? 'Unknown',
                'balance': (json['balance'] as num).toDouble(),
              }))
          .toList();
    } catch (e) {
      throw Exception('Failed to get group balances: $e');
    }
  }

  /// Get user balance in a group
  Future<double> getUserBalance({
    required String userId,
    required String groupId,
  }) async {
    try {
      final result = await _supabase.rpc(
        'get_user_balance_in_group',
        params: {
          'p_user_id': userId,
          'p_group_id': groupId,
        },
      );

      return (result as num).toDouble();
    } catch (e) {
      throw Exception('Failed to get user balance: $e');
    }
  }
}

/// Provider for ExpenseRepository
@riverpod
ExpenseRepository expenseRepository(ExpenseRepositoryRef ref) {
  return ExpenseRepository();
}

/// Provider for group expenses stream
@riverpod
Stream<List<ExpenseModel>> groupExpenses(
  GroupExpensesRef ref,
  String groupId,
) {
  final repo = ref.watch(expenseRepositoryProvider);
  return repo.watchGroupExpenses(groupId);
}

/// Provider for group balances
@riverpod
Future<List<BalanceModel>> groupBalances(
  GroupBalancesRef ref,
  String groupId,
) {
  final repo = ref.watch(expenseRepositoryProvider);
  return repo.getGroupBalances(groupId);
}

/// Provider for expense splits
@riverpod
Future<List<ExpenseSplitModel>> expenseSplits(
  ExpenseSplitsRef ref,
  String expenseId,
) {
  final repo = ref.watch(expenseRepositoryProvider);
  return repo.getExpenseSplits(expenseId);
}
