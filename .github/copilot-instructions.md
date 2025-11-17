# Trip Split Wise - Copilot Instructions

## Project Overview

Flutter expense-splitting application (similar to Splitwise) for managing shared trip costs and group expenses. Features real-time synchronization, multiple split methods, and comprehensive balance tracking.

## Tech Stack

- **Framework**: Flutter SDK ^3.5.3
- **Language**: Dart
- **Backend**: Supabase (PostgreSQL + Real-time + Auth)
- **State Management**: Riverpod 2.x (Provider pattern)
- **UI**: Material Design 3
- **Platforms**: Android, iOS, Web

## Architecture & Folder Structure

### Repository Pattern with Riverpod

```
lib/
├── core/                    # Shared utilities, constants, config
│   ├── config/             # Supabase config, environment variables
│   ├── constants/          # App-wide constants
│   └── utils/              # Helper functions, extensions
├── data/                    # Data layer
│   ├── models/             # Data models (User, Group, Expense, etc.)
│   └── repositories/       # Repository implementations
│       ├── auth_repository.dart
│       ├── group_repository.dart
│       └── expense_repository.dart
├── features/                # Feature modules
│   ├── auth/               # Authentication (login, signup)
│   │   ├── providers/
│   │   └── screens/
│   ├── groups/             # Groups management
│   │   ├── providers/
│   │   ├── screens/
│   │   └── widgets/
│   └── expenses/           # Expenses CRUD
│       ├── providers/
│       ├── screens/
│       └── widgets/
└── main.dart
```

### Database Schema (Supabase/PostgreSQL)

- **users**: Synced with Supabase Auth, stores display_name, avatar_url
- **groups**: id, name, created_by, created_at
- **group_members**: group_id, user_id, joined_at (many-to-many)
- **expenses**: id, group_id, description, amount, paid_by, date, created_at
- **expense_splits**: expense_id, user_id, amount (tracks who owes what)

See `supabase/schema.sql` for full DDL with Row Level Security policies.

## Development Workflow

### Environment Setup

1. Create `.env` file with Supabase credentials (use `flutter_dotenv`)
2. Initialize Supabase client in `lib/core/config/supabase_config.dart`
3. Run database migrations from `supabase/schema.sql` in Supabase dashboard

### Running the App

```bash
flutter run                    # Run on connected device/emulator
flutter run -d chrome          # Run in Chrome browser
flutter run -d macos           # Run on macOS (if on Mac)
```

### Testing

```bash
flutter test                   # Run all tests
flutter test test/widget_test.dart  # Run specific test file
```

### Code Quality

```bash
flutter analyze                # Run static analysis (uses analysis_options.yaml)
flutter pub outdated           # Check for dependency updates
```

### Dependencies

```bash
flutter pub get                # Install dependencies after pubspec.yaml changes
flutter pub upgrade            # Upgrade dependencies
```

## Code Conventions

### Riverpod Provider Pattern

- Use `@riverpod` annotation with code generation (`riverpod_generator`)
- Repository providers: `@riverpod ExpenseRepository expenseRepository(ref) => ...`
- Stream providers for real-time: `@riverpod Stream<List<Expense>> expenses(ref, groupId) => ...`
- Example structure in `lib/features/expenses/providers/expense_providers.dart`

### Data Models

- Use `freezed` for immutable models with JSON serialization
- Example: `@freezed class Expense with _$Expense { factory Expense.fromJson(...) }`
- Models mirror Supabase table structure for seamless serialization

### Repository Pattern

- Each feature has its own repository (AuthRepository, GroupRepository, ExpenseRepository)
- Repositories handle all Supabase interactions (queries, inserts, real-time subscriptions)
- Return `Future<T>` for async operations, `Stream<T>` for real-time data
- Example: `Future<List<Group>> getGroups(String userId)` in `lib/data/repositories/group_repository.dart`

### Widget Structure

- Use `const` constructors wherever possible (enforced by flutter_lints)
- ConsumerWidget/ConsumerStatefulWidget for Riverpod integration
- Example: `class GroupList extends ConsumerWidget { @override Widget build(BuildContext context, WidgetRef ref) {...} }`

### State Management with Riverpod

- Use `ref.watch()` to rebuild on state changes
- Use `ref.read()` for one-time reads or callbacks
- Use `ref.listen()` for side effects (navigation, snackbars)
- Example: `final groups = ref.watch(groupsProvider(userId));`

### Theme & Styling

- Material 3 enabled (`useMaterial3: true`)
- ColorScheme uses seed-based generation: `ColorScheme.fromSeed(seedColor: Colors.deepPurple)`
- Access theme colors via `Theme.of(context).colorScheme`

### File Organization

- `lib/` - Application source code
- `test/` - Widget and unit tests (mirror lib/ structure)
- Platform-specific code in `android/`, `ios/`, `web/`, etc.

## Common Tasks

### Adding Dependencies

1. Add to `pubspec.yaml` under `dependencies:`
2. Run `flutter pub get`
3. Import in Dart files: `import 'package:package_name/package_name.dart';`

### Hot Reload vs Hot Restart

- Hot Reload (r): Preserves app state, injects updated code
- Hot Restart (R): Resets app state, full recompilation
- Use Hot Reload for UI changes, Hot Restart for logic/state changes
