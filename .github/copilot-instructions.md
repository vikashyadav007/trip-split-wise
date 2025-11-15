# Trip Split Wise - Copilot Instructions

## Project Overview
Flutter expense-splitting application for managing shared trip costs. Currently in initial setup phase with default Flutter template structure.

## Tech Stack
- **Framework**: Flutter SDK ^3.5.3
- **Language**: Dart
- **UI**: Material Design 3 (Material 3 enabled in theme)
- **State Management**: setState (default Flutter state)
- **Platforms**: Android, iOS, Web, Linux, macOS, Windows

## Development Workflow

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

### Widget Structure
- Use `const` constructors wherever possible (enforced by flutter_lints)
- StatelessWidget for static UI, StatefulWidget for dynamic UI
- Example from `main.dart`:
  ```dart
  class MyApp extends StatelessWidget {
    const MyApp({super.key});
    // ...
  }
  ```

### State Management Pattern
- Currently using `setState()` for local component state
- See `_MyHomePageState._incrementCounter()` in `lib/main.dart` for pattern

### Theme & Styling
- Material 3 enabled (`useMaterial3: true`)
- ColorScheme uses seed-based generation: `ColorScheme.fromSeed(seedColor: Colors.deepPurple)`
- Access theme colors via `Theme.of(context).colorScheme`

### File Organization
- `lib/` - Application source code
- `test/` - Widget and unit tests (mirror lib/ structure)
- Platform-specific code in `android/`, `ios/`, `web/`, etc.

## Project-Specific Notes

### Current State
- Boilerplate Flutter counter app - ready for feature implementation
- No custom architecture patterns established yet
- No state management library added (consider bloc, provider, riverpod for complex state)

### Testing Pattern
- Widget tests use `WidgetTester` from flutter_test
- Example: `await tester.pumpWidget(const MyApp())` to render widget tree
- Use `find.text()`, `find.byIcon()` for element selection
- `tester.pump()` to trigger frame after interactions

### Linting
- Uses `package:flutter_lints/flutter.yaml` for recommended lints
- Customize rules in `analysis_options.yaml` by uncommenting/adding under `linter.rules`

## Common Tasks

### Adding Dependencies
1. Add to `pubspec.yaml` under `dependencies:`
2. Run `flutter pub get`
3. Import in Dart files: `import 'package:package_name/package_name.dart';`

### Hot Reload vs Hot Restart
- Hot Reload (r): Preserves app state, injects updated code
- Hot Restart (R): Resets app state, full recompilation
- Use Hot Reload for UI changes, Hot Restart for logic/state changes
