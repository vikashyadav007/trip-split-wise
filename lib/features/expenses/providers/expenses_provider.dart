import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../data/models/expense_model.dart';
import '../../../data/models/expense_split_model.dart';
import '../../../data/repositories/expense_repository.dart';

part 'expenses_provider.g.dart';

/// Create expense controller
@riverpod
class CreateExpenseController extends _$CreateExpenseController {
  @override
  FutureOr<void> build() {}

  Future<ExpenseModel?> createExpense({
    required String groupId,
    required String description,
    required double amount,
    required String paidBy,
    required List<ExpenseSplitModel> splits,
    String? category,
    DateTime? date,
  }) async {
    state = const AsyncLoading();

    final repo = ref.read(expenseRepositoryProvider);

    ExpenseModel? createdExpense;
    state = await AsyncValue.guard(() async {
      createdExpense = await repo.createExpense(
        groupId: groupId,
        description: description,
        amount: amount,
        paidBy: paidBy,
        splits: splits,
        category: category,
        date: date,
      );

      // Invalidate expenses list to refresh
      ref.invalidate(groupExpensesProvider);
      ref.invalidate(groupBalancesProvider);
    });

    return createdExpense;
  }
}

/// Update expense controller
@riverpod
class UpdateExpenseController extends _$UpdateExpenseController {
  @override
  FutureOr<void> build() {}

  Future<void> updateExpense({
    required String expenseId,
    String? description,
    double? amount,
    String? category,
    DateTime? date,
  }) async {
    state = const AsyncLoading();

    final repo = ref.read(expenseRepositoryProvider);

    state = await AsyncValue.guard(() async {
      await repo.updateExpense(
        expenseId: expenseId,
        description: description,
        amount: amount,
        category: category,
        date: date,
      );

      // Invalidate to refresh
      ref.invalidate(groupExpensesProvider);
      ref.invalidate(groupBalancesProvider);
    });
  }
}

/// Delete expense controller
@riverpod
class DeleteExpenseController extends _$DeleteExpenseController {
  @override
  FutureOr<void> build() {}

  Future<void> deleteExpense(String expenseId) async {
    state = const AsyncLoading();

    final repo = ref.read(expenseRepositoryProvider);

    state = await AsyncValue.guard(() async {
      await repo.deleteExpense(expenseId);

      // Invalidate to refresh
      ref.invalidate(groupExpensesProvider);
      ref.invalidate(groupBalancesProvider);
    });
  }
}
