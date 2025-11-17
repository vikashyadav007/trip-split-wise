import 'package:intl/intl.dart';

/// Extension methods for DateTime
extension DateTimeExtensions on DateTime {
  /// Format date as 'MMM dd, yyyy' (e.g., 'Jan 15, 2025')
  String toFormattedString() {
    return DateFormat('MMM dd, yyyy').format(this);
  }

  /// Check if date is today
  bool get isToday {
    final now = DateTime.now();
    return year == now.year && month == now.month && day == now.day;
  }

  /// Check if date is yesterday
  bool get isYesterday {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return year == yesterday.year &&
        month == yesterday.month &&
        day == yesterday.day;
  }
}

/// Extension methods for double (currency formatting)
extension CurrencyExtensions on double {
  /// Format as currency (e.g., '$123.45')
  String toCurrency() {
    return NumberFormat.currency(symbol: '\$', decimalDigits: 2).format(this);
  }

  /// Format as compact currency (e.g., '$1.2K')
  String toCompactCurrency() {
    return NumberFormat.compactCurrency(symbol: '\$').format(this);
  }
}

/// Extension methods for String validation
extension StringValidation on String {
  /// Check if string is a valid email
  bool get isValidEmail {
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(this);
  }

  /// Check if string is a valid amount
  bool get isValidAmount {
    final amount = double.tryParse(this);
    return amount != null && amount > 0;
  }
}
