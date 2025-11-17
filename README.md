# Trip Split Wise

A Flutter expense-splitting application similar to Splitwise, for managing shared trip costs and group expenses.

## Features

- 🔐 **Authentication**: Google Sign-In + Email/Password via Supabase Auth
- 👥 **Groups**: Create groups, add members, manage group details
- 💰 **Expenses**: Add/edit/delete expenses with equal or custom splits
- 📊 **Balance Tracking**: Real-time balance calculations for each user
- ⚡ **Real-time Sync**: Live updates via Supabase Realtime
- 🎨 **Material Design 3**: Modern UI with Material You theming

## Tech Stack

- **Flutter SDK**: ^3.5.3
- **Backend**: Supabase (PostgreSQL + Real-time + Auth)
- **State Management**: Riverpod 2.x
- **Code Generation**: Freezed, JSON Serializable, Riverpod Generator
- **UI**: Material Design 3

## Project Structure

```
lib/
├── core/
│   ├── config/
│   │   └── supabase_config.dart       # Supabase initialization
│   ├── constants/
│   │   └── app_constants.dart         # App-wide constants
│   └── utils/
│       └── extensions.dart            # Utility extensions
├── data/
│   ├── models/                        # Freezed data models
│   │   ├── user_model.dart
│   │   ├── group_model.dart
│   │   ├── expense_model.dart
│   │   ├── expense_split_model.dart
│   │   └── balance_model.dart
│   └── repositories/                  # Supabase data layer
│       ├── auth_repository.dart
│       ├── group_repository.dart
│       └── expense_repository.dart
└── features/                          # Feature modules (to be implemented)
    ├── auth/
    ├── groups/
    └── expenses/

supabase/
└── schema.sql                         # Database schema with RLS policies
```

## Setup Instructions

### 1. Prerequisites

- Flutter SDK 3.5.3 or higher
- Dart 3.5.3 or higher
- Supabase account (free tier works)
- (Optional) Google Cloud project for Google Sign-In

### 2. Supabase Setup

1. Create a new project at [supabase.com](https://supabase.com)

2. Run the database migration:

   - Open the SQL Editor in your Supabase dashboard
   - Copy and paste the contents of `supabase/schema.sql`
   - Execute the script to create tables, indexes, RLS policies, and helper functions

3. Enable Realtime:

   - Go to Database > Replication
   - Enable replication for tables: `users`, `groups`, `group_members`, `expenses`, `expense_splits`

4. (Optional) Configure Google OAuth:
   - Go to Authentication > Providers
   - Enable Google provider
   - Add your Google Client ID and Secret

### 3. Environment Configuration

1. Copy `.env.example` to `.env`:

   ```bash
   cp .env.example .env
   ```

2. Edit `.env` with your Supabase credentials:

   ```env
   SUPABASE_URL=https://your-project.supabase.co
   SUPABASE_ANON_KEY=your-anon-key-here
   ```

   Find these values in: Supabase Dashboard > Settings > API

### 4. Install Dependencies

```bash
flutter pub get
```

### 5. Generate Code

Run code generation for Freezed, JSON Serializable, and Riverpod:

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

Or watch for changes during development:

```bash
flutter pub run build_runner watch --delete-conflicting-outputs
```

### 6. Run the App

```bash
# Run on default device
flutter run

# Run on specific device
flutter run -d chrome      # Web
flutter run -d macos       # macOS
flutter run -d <device-id> # Mobile (use flutter devices to list)
```

## Development Workflow

### Code Generation

This project uses code generation for:

- **Freezed**: Immutable models with copyWith, equality, and JSON serialization
- **JSON Serializable**: JSON serialization/deserialization
- **Riverpod Generator**: Type-safe providers

Always run code generation after creating/modifying:

- Model classes in `lib/data/models/`
- Repository classes in `lib/data/repositories/`
- Provider files in `lib/**/providers/`

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### Testing

```bash
# Run all tests
flutter test

# Run specific test file
flutter test test/widget_test.dart
```

### Code Quality

```bash
# Analyze code
flutter analyze

# Check for outdated dependencies
flutter pub outdated
```

## Database Schema

### Tables

- **users**: User profiles synced with Supabase Auth
- **groups**: Expense groups (trips, roommate groups, etc.)
- **group_members**: Many-to-many relationship between users and groups
- **expenses**: Individual expenses within groups
- **expense_splits**: How each expense is divided among members

### Row Level Security (RLS)

All tables have RLS policies configured:

- Users can only read/update their own profiles
- Users can only access groups they're members of
- Only group creators can modify group details
- Only expense creators can modify/delete their expenses

### Helper Functions

- `get_user_balance_in_group(user_id, group_id)`: Calculate user's balance in a group
- `get_group_balances(group_id)`: Get all balances for a group

## Next Steps

### Remaining Implementation

1. **Run Code Generation** (FIRST STEP!)

   ```bash
   flutter pub get
   flutter pub run build_runner build --delete-conflicting-outputs
   ```

2. **Authentication UI** (`lib/features/auth/`)

   - Login screen
   - Sign up screen
   - Auth state management

3. **Groups Feature** (`lib/features/groups/`)

   - Group list screen
   - Create/edit group screen
   - Add members screen
   - Group detail screen with balance summary

4. **Expenses Feature** (`lib/features/expenses/`)

   - Add expense screen with split options (equal/custom)
   - Edit expense screen
   - Expense list for group

5. **Main App Structure**
   - Update `lib/main.dart` to initialize Supabase
   - Set up routing
   - Create app shell with navigation

## Resources

- [Flutter Documentation](https://docs.flutter.dev/)
- [Supabase Documentation](https://supabase.com/docs)
- [Riverpod Documentation](https://riverpod.dev/)
- [Freezed Package](https://pub.dev/packages/freezed)
