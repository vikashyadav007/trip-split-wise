import 'package:flutter/material.dart';

import '../../../data/models/balance_model.dart';

class BalanceSummaryCard extends StatelessWidget {
  final List<BalanceModel> balances;

  const BalanceSummaryCard({
    super.key,
    required this.balances,
  });

  @override
  Widget build(BuildContext context) {
    final totalOwed = balances
        .where((b) => b.balance < 0)
        .fold<double>(0, (sum, b) => sum + b.balance.abs());

    final totalOwedTo = balances
        .where((b) => b.balance > 0)
        .fold<double>(0, (sum, b) => sum + b.balance);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Group Balance Summary',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _BalanceIndicator(
                    label: 'Total Owed',
                    amount: totalOwed,
                    color: Colors.red,
                    icon: Icons.arrow_downward,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _BalanceIndicator(
                    label: 'Total Owed To You',
                    amount: totalOwedTo,
                    color: Colors.green,
                    icon: Icons.arrow_upward,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _BalanceIndicator extends StatelessWidget {
  final String label;
  final double amount;
  final Color color;
  final IconData icon;

  const _BalanceIndicator({
    required this.label,
    required this.amount,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: color),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  label,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: color,
                      ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            '\$${amount.toStringAsFixed(2)}',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
          ),
        ],
      ),
    );
  }
}
