import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../data/models/expense_split_model.dart';
import '../../../data/models/group_member_model.dart';
import '../../../data/models/group_model.dart';
import '../../auth/providers/auth_provider.dart';
import '../../groups/providers/groups_provider.dart';
import '../providers/expenses_provider.dart';

class AddExpenseScreen extends ConsumerStatefulWidget {
  final GroupModel group;

  const AddExpenseScreen({
    super.key,
    required this.group,
  });

  @override
  ConsumerState<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends ConsumerState<AddExpenseScreen> {
  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();
  final _amountController = TextEditingController();
  final _categoryController = TextEditingController();

  DateTime _selectedDate = DateTime.now();
  String? _paidBy;
  SplitMethod _splitMethod = SplitMethod.equal;
  final Map<String, double> _customSplits = {};
  bool _isLoading = false;

  @override
  void dispose() {
    _descriptionController.dispose();
    _amountController.dispose();
    _categoryController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  List<ExpenseSplitModel> _calculateSplits(
      List<GroupMemberModel> members, double amount) {
    if (_splitMethod == SplitMethod.equal) {
      final splitAmount = amount / members.length;
      return members
          .map((member) => ExpenseSplitModel(
                id: '', // Will be set by backend
                expenseId: '', // Will be set by backend
                userId: member.userId,
                amount: splitAmount,
              ))
          .toList();
    } else {
      // Custom splits
      return members
          .map((member) => ExpenseSplitModel(
                id: '', // Will be set by backend
                expenseId: '', // Will be set by backend
                userId: member.userId,
                amount: _customSplits[member.userId] ?? 0,
              ))
          .toList();
    }
  }

  Future<void> _addExpense() async {
    if (!_formKey.currentState!.validate()) return;

    if (_paidBy == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select who paid'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final membersAsync =
        await ref.read(groupMembersProvider(widget.group.id).future);
    final amount = double.parse(_amountController.text);

    // Validate custom splits
    if (_splitMethod == SplitMethod.custom) {
      final totalSplit =
          _customSplits.values.fold<double>(0, (sum, amt) => sum + amt);
      if ((totalSplit - amount).abs() > 0.01) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Split amounts (\$${totalSplit.toStringAsFixed(2)}) must equal total (\$${amount.toStringAsFixed(2)})',
            ),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }
    }

    setState(() => _isLoading = true);

    try {
      final splits = _calculateSplits(membersAsync, amount);
      final controller = ref.read(createExpenseControllerProvider.notifier);

      final expense = await controller.createExpense(
        groupId: widget.group.id,
        description: _descriptionController.text.trim(),
        amount: amount,
        paidBy: _paidBy!,
        splits: splits,
        category: _categoryController.text.trim().isEmpty
            ? null
            : _categoryController.text.trim(),
        date: _selectedDate,
      );

      if (mounted && expense != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Expense added successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to add expense: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = ref.watch(currentUserProvider).value;
    final membersAsync = ref.watch(groupMembersProvider(widget.group.id));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Expense'),
      ),
      body: membersAsync.when(
        data: (members) {
          // Set default payer to current user if not set
          if (_paidBy == null && currentUser != null) {
            _paidBy = currentUser.id;
            // Initialize custom splits to equal amounts
            final equalAmount = 0.0;
            for (var member in members) {
              _customSplits[member.userId] = equalAmount;
            }
          }

          return Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                TextFormField(
                  controller: _descriptionController,
                  textInputAction: TextInputAction.next,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    hintText: 'e.g., Dinner at restaurant',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.description),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter a description';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _amountController,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  textInputAction: TextInputAction.next,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                        RegExp(r'^\d+\.?\d{0,2}')),
                  ],
                  decoration: const InputDecoration(
                    labelText: 'Amount',
                    hintText: '0.00',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.attach_money),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter an amount';
                    }
                    final amount = double.tryParse(value);
                    if (amount == null || amount <= 0) {
                      return 'Please enter a valid amount';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    // Update custom splits when amount changes
                    if (_splitMethod == SplitMethod.equal) {
                      final amount = double.tryParse(value) ?? 0;
                      final splitAmount = amount / members.length;
                      setState(() {
                        for (var member in members) {
                          _customSplits[member.userId] = splitAmount;
                        }
                      });
                    }
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _categoryController,
                  textInputAction: TextInputAction.done,
                  textCapitalization: TextCapitalization.words,
                  decoration: const InputDecoration(
                    labelText: 'Category (Optional)',
                    hintText: 'e.g., Food, Transport, Accommodation',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.category),
                  ),
                ),
                const SizedBox(height: 16),
                Card(
                  child: ListTile(
                    leading: const Icon(Icons.calendar_today),
                    title: const Text('Date'),
                    subtitle:
                        Text(DateFormat('MMM d, y').format(_selectedDate)),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: _selectDate,
                  ),
                ),
                const SizedBox(height: 16),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Paid by',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 8),
                        ...members.map((member) => RadioListTile<String>(
                              title: Text(member.userName),
                              value: member.userId,
                              groupValue: _paidBy,
                              onChanged: (value) {
                                setState(() => _paidBy = value);
                              },
                            )),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Split method',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 8),
                        RadioListTile<SplitMethod>(
                          title: const Text('Split equally'),
                          subtitle: Text(
                            'Each person pays \$${(_amountController.text.isEmpty ? 0 : double.tryParse(_amountController.text)! / members.length).toStringAsFixed(2)}',
                          ),
                          value: SplitMethod.equal,
                          groupValue: _splitMethod,
                          onChanged: (value) {
                            setState(() {
                              _splitMethod = value!;
                              // Reset to equal splits
                              final amount =
                                  double.tryParse(_amountController.text) ?? 0;
                              final splitAmount = amount / members.length;
                              for (var member in members) {
                                _customSplits[member.userId] = splitAmount;
                              }
                            });
                          },
                        ),
                        RadioListTile<SplitMethod>(
                          title: const Text('Custom split'),
                          subtitle: const Text(
                              'Enter custom amounts for each person'),
                          value: SplitMethod.custom,
                          groupValue: _splitMethod,
                          onChanged: (value) {
                            setState(() => _splitMethod = value!);
                          },
                        ),
                        if (_splitMethod == SplitMethod.custom) ...[
                          const Divider(),
                          const SizedBox(height: 8),
                          Text(
                            'Enter amount for each person:',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          const SizedBox(height: 8),
                          ...members.map((member) => Padding(
                                padding: const EdgeInsets.only(bottom: 8),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(member.userName),
                                    ),
                                    SizedBox(
                                      width: 120,
                                      child: TextFormField(
                                        initialValue:
                                            _customSplits[member.userId]
                                                ?.toStringAsFixed(2),
                                        keyboardType: const TextInputType
                                            .numberWithOptions(decimal: true),
                                        inputFormatters: [
                                          FilteringTextInputFormatter.allow(
                                              RegExp(r'^\d+\.?\d{0,2}')),
                                        ],
                                        decoration: const InputDecoration(
                                          prefixText: '\$ ',
                                          border: OutlineInputBorder(),
                                          contentPadding: EdgeInsets.symmetric(
                                            horizontal: 12,
                                            vertical: 8,
                                          ),
                                        ),
                                        onChanged: (value) {
                                          setState(() {
                                            _customSplits[member.userId] =
                                                double.tryParse(value) ?? 0;
                                          });
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              )),
                          const Divider(),
                          Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Total split:',
                                  style: Theme.of(context).textTheme.titleSmall,
                                ),
                                Text(
                                  '\$${_customSplits.values.fold<double>(0, (sum, amt) => sum + amt).toStringAsFixed(2)}',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleSmall
                                      ?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                FilledButton.icon(
                  onPressed: _isLoading ? null : _addExpense,
                  icon: _isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.add),
                  label: Text(_isLoading ? 'Adding...' : 'Add Expense'),
                ),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Text('Error loading members: $error'),
        ),
      ),
    );
  }
}

enum SplitMethod {
  equal,
  custom,
}
