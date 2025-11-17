/// Database table names
class TableNames {
  static const String users = 'users';
  static const String groups = 'groups';
  static const String groupMembers = 'group_members';
  static const String expenses = 'expenses';
  static const String expenseSplits = 'expense_splits';
}

/// App-wide constants
class AppConstants {
  /// Minimum expense amount
  static const double minExpenseAmount = 0.01;

  /// Maximum expense amount
  static const double maxExpenseAmount = 999999.99;

  /// Date format for display
  static const String dateFormat = 'MMM dd, yyyy';

  /// Currency symbol
  static const String currencySymbol = '\$';
}

/// Error messages
class ErrorMessages {
  static const String networkError = 'Network error. Please try again.';
  static const String authError = 'Authentication failed. Please try again.';
  static const String unknownError = 'An unknown error occurred.';
  static const String invalidEmail = 'Please enter a valid email address.';
  static const String invalidAmount = 'Please enter a valid amount.';
  static const String emptyField = 'This field cannot be empty.';
}
