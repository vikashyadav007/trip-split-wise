import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../data/models/group_model.dart';
import '../../../data/repositories/expense_repository.dart';
import '../../auth/providers/auth_provider.dart';
import '../../expenses/screens/add_expense_screen.dart';
import '../../expenses/screens/expense_detail_screen.dart';
import '../providers/groups_provider.dart';
import '../widgets/balance_summary_card.dart';
import '../widgets/member_list_tile.dart';

class GroupDetailScreen extends ConsumerStatefulWidget {
  final GroupModel group;

  const GroupDetailScreen({
    super.key,
    required this.group,
  });

  @override
  ConsumerState<GroupDetailScreen> createState() => _GroupDetailScreenState();
}

class _GroupDetailScreenState extends ConsumerState<GroupDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = ref.watch(currentUserProvider).value;
    final isCreator = currentUser?.id == widget.group.createdBy;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.group.name),
        actions: [
          if (isCreator)
            PopupMenuButton<String>(
              onSelected: (value) {
                switch (value) {
                  case 'edit':
                    _showEditDialog();
                    break;
                  case 'delete':
                    _confirmDelete();
                    break;
                }
              },
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'edit',
                  child: Row(
                    children: [
                      Icon(Icons.edit),
                      SizedBox(width: 8),
                      Text('Edit Group'),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: 'delete',
                  child: Row(
                    children: [
                      Icon(Icons.delete, color: Colors.red),
                      SizedBox(width: 8),
                      Text('Delete Group', style: TextStyle(color: Colors.red)),
                    ],
                  ),
                ),
              ],
            ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Expenses'),
            Tab(text: 'Members'),
            Tab(text: 'Balances'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _ExpensesTab(groupId: widget.group.id),
          _MembersTab(groupId: widget.group.id, isCreator: isCreator),
          _BalancesTab(groupId: widget.group.id),
        ],
      ),
      floatingActionButton: _tabController.index == 0
          ? FloatingActionButton.extended(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddExpenseScreen(group: widget.group),
                  ),
                );
              },
              icon: const Icon(Icons.add),
              label: const Text('Add Expense'),
            )
          : null,
    );
  }

  void _showEditDialog() {
    final nameController = TextEditingController(text: widget.group.name);
    final descController =
        TextEditingController(text: widget.group.description);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Group'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Group Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: descController,
              decoration: const InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () async {
              final controller =
                  ref.read(updateGroupControllerProvider.notifier);
              await controller.updateGroup(
                groupId: widget.group.id,
                name: nameController.text.trim(),
                description: descController.text.trim(),
              );
              if (context.mounted) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Group updated!')),
                );
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _confirmDelete() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Group'),
        content: Text(
          'Are you sure you want to delete "${widget.group.name}"? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            onPressed: () async {
              final controller =
                  ref.read(deleteGroupControllerProvider.notifier);
              await controller.deleteGroup(widget.group.id);
              if (context.mounted) {
                Navigator.pop(context); // Close dialog
                Navigator.pop(context); // Close detail screen
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Group deleted')),
                );
              }
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}

class _ExpensesTab extends ConsumerWidget {
  final String groupId;

  const _ExpensesTab({required this.groupId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final expensesAsync = ref.watch(groupExpensesProvider(groupId));

    return expensesAsync.when(
      data: (expenses) {
        if (expenses.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.receipt_long_outlined, size: 64, color: Colors.grey),
                SizedBox(height: 16),
                Text('No expenses yet'),
                SizedBox(height: 8),
                Text(
                  'Tap + to add your first expense',
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: expenses.length,
          itemBuilder: (context, index) {
            final expense = expenses[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: ListTile(
                leading: CircleAvatar(
                  child: Text('\$${expense.amount.toStringAsFixed(0)}'),
                ),
                title: Text(expense.description),
                subtitle: Text(
                  DateFormat('MMM d, y').format(expense.date),
                ),
                trailing: expense.category != null
                    ? Chip(label: Text(expense.category!))
                    : null,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ExpenseDetailScreen(
                        expense: expense,
                        groupId: groupId,
                      ),
                    ),
                  );
                },
              ),
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => Center(child: Text('Error: $error')),
    );
  }
}

class _MembersTab extends ConsumerWidget {
  final String groupId;
  final bool isCreator;

  const _MembersTab({
    required this.groupId,
    required this.isCreator,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final membersAsync = ref.watch(groupMembersProvider(groupId));

    return membersAsync.when(
      data: (members) {
        return Column(
          children: [
            if (isCreator)
              Padding(
                padding: const EdgeInsets.all(16),
                child: FilledButton.icon(
                  onPressed: () {
                    // TODO: Navigate to add members screen
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Add members feature coming soon!'),
                      ),
                    );
                  },
                  icon: const Icon(Icons.person_add),
                  label: const Text('Add Members'),
                ),
              ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: members.length,
                itemBuilder: (context, index) {
                  final member = members[index];
                  return MemberListTile(
                    member: member,
                    isCreator: isCreator,
                    groupId: groupId,
                  );
                },
              ),
            ),
          ],
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => Center(child: Text('Error: $error')),
    );
  }
}

class _BalancesTab extends ConsumerWidget {
  final String groupId;

  const _BalancesTab({required this.groupId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final balancesAsync = ref.watch(groupBalancesProvider(groupId));

    return balancesAsync.when(
      data: (balances) {
        if (balances.isEmpty) {
          return const Center(
            child: Text('No balance information yet'),
          );
        }

        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            BalanceSummaryCard(balances: balances),
            const SizedBox(height: 16),
            Text(
              'Individual Balances',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            ...balances.map((balance) {
              final isPositive = balance.balance > 0;
              final isZero = balance.balance.abs() < 0.01;

              return Card(
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: isZero
                        ? Colors.grey
                        : isPositive
                            ? Colors.green
                            : Colors.red,
                    child: Text(
                      balance.userName[0].toUpperCase(),
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  title: Text(balance.userName),
                  trailing: Text(
                    isZero
                        ? 'Settled'
                        : '\$${balance.balance.abs().toStringAsFixed(2)}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: isZero
                          ? Colors.grey
                          : isPositive
                              ? Colors.green
                              : Colors.red,
                    ),
                  ),
                  subtitle: Text(
                    isZero
                        ? 'All settled up'
                        : isPositive
                            ? 'Gets back'
                            : 'Owes',
                  ),
                ),
              );
            }),
          ],
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => Center(child: Text('Error: $error')),
    );
  }
}
