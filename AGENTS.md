# AGENTS.md — AyurSpace Flutter

## Project Overview

Flutter mobile app (Dart SDK ^3.5.0) for Ayurvedic wellness. Uses Riverpod for state management,
GoRouter for navigation, and Firebase (Auth, Firestore, Storage, Crashlytics) as backend.
AI features via Google Gemini API and Plant.id API. Supports English, Hindi, and Marathi (gen_l10n).

## Architecture

```
lib/
  config/         — App-wide config: theme, colors, design tokens, router, routes, API config
  data/
    models/       — Domain entities (Equatable, const constructors, fromJson/toJson/copyWith)
    repositories/ — Abstract interfaces + local/Firestore implementations
    sources/      — Static seed data
  l10n/           — Localization ARB files + generated delegates
  providers/      — Riverpod state management (StateNotifier pattern)
  screens/        — Feature screens, one directory per feature (e.g. screens/home/home_screen.dart)
  services/       — External API wrappers (auth, Firestore, Gemini, Plant.id)
  utils/          — Custom exceptions, helpers
  widgets/        — Reusable UI components with barrel export (widgets/widgets.dart)
```

## Build / Run / Test Commands

```bash
# Install dependencies
flutter pub get

# Run the app (debug)
flutter run

# Build
flutter build apk          # Android
flutter build ios           # iOS
flutter build web           # Web

# Static analysis (lint)
flutter analyze

# Format code (default 80-char line length)
dart format .

# Run ALL tests
flutter test

# Run a single test file
flutter test test/providers/plants_provider_test.dart

# Run a single test by name (substring match)
flutter test --name "should load plants successfully"

# Run tests in a directory
flutter test test/providers/

# Code generation (riverpod_generator / build_runner — not currently active)
dart run build_runner build --delete-conflicting-outputs

# Generate localization files
flutter gen-l10n
```

## Lint Rules (analysis_options.yaml)

Base: `package:flutter_lints/flutter.yaml` with these additional rules:

- `prefer_const_constructors: true` — use `const` for all immutable widget constructors
- `prefer_const_declarations: true` — prefer `const` for compile-time constant variables
- `avoid_print: true` — use `debugPrint()` instead of `print()`
- `always_declare_return_types: true` — every function/method must have an explicit return type
- `unawaited_futures: true` — `await` all Futures or explicitly use `unawaited()`
- `prefer_single_quotes: true` — use single quotes for strings

## Code Style Guidelines

### Formatting

- **Single quotes** everywhere (double quotes only inside interpolations or multi-line strings)
- **Trailing commas** on the last argument of multi-line calls and constructors
- **`const`** on all widget constructors, default state values, and compile-time constants
- **`super.key`** syntax (Dart 3) instead of the older `Key? key` pattern
- **Line length**: default `dart format` (80 characters)

### Naming Conventions

| Element             | Convention                      | Example                                  |
|---------------------|---------------------------------|------------------------------------------|
| Files               | `snake_case.dart`               | `plants_provider.dart`                   |
| Classes             | `UpperCamelCase`                | `PlantsNotifier`, `GeminiService`        |
| Enums               | `UpperCamelCase` / `lowerCamelCase` values | `enum ScanSource { local, aiGenerated }` |
| Variables / fields  | `lowerCamelCase`                | `plantName`, `isBookmarked`              |
| Private members     | `_lowerCamelCase`               | `_maxHistoryItems`, `_client`            |
| Riverpod providers  | `lowerCamelCaseProvider`        | `scanProvider`, `plantsRepositoryProvider`|
| Private widgets     | `_UpperCamelCase`               | `_WellnessCard`, `_DoshaBadge`           |
| Screens             | `<Feature>Screen` in `screens/<feature>/` | `HomeScreen` in `screens/home/`    |
| Utility classes     | Private constructor `ClassName._()` | `AppColors._()`, `DesignTokens._()`  |

### Imports

Order imports as: `dart:` core → `package:` third-party → relative project imports.
Use relative imports (`../providers/foo.dart`) for project files, not
`package:ayurspace_flutter/...` self-references (though some exist in the codebase).

### State Management (Riverpod)

- `StateNotifierProvider` + `StateNotifier<T>` for complex state with business logic
- `Provider` for dependency injection (repositories, services)
- `Provider.family` for parameterized lookups (e.g., `plantByIdProvider`)
- `StreamProvider` for reactive streams (e.g., `authStateProvider`)
- `StateProvider` for simple mutable values
- Screens use `ConsumerWidget`; pure UI widgets use `StatelessWidget`
- State classes use `copyWith()` for immutable updates

### Models

- Extend `Equatable` for value equality
- Use `const` constructors
- Include: `factory fromJson(Map<String, dynamic>)`, `Map<String, dynamic> toJson()`, `copyWith()`
- Nullable fields use `?` type annotation
- JSON keys are camelCase (matching Firestore document fields)

### Error Handling

- Custom exception hierarchy in `lib/utils/app_exceptions.dart`:
  `AppException` → `FirestoreException`, `AuthException`, `ApiException`
- Providers: `try/catch` with error propagated via `state.copyWith(error: '...')`
- Services: return response objects with `isError` flag for graceful degradation
- Auth layer: catch Firebase exceptions, remap via `AuthErrorMapper`, throw `AuthException`
- Use `debugPrint()` for debug logging (never `print()`)

### Widgets

- One public widget per file + private helper widgets (`_HelperName`) in the same file
- Interactive areas: wrap with `Material` + `InkWell` + `BorderRadius`
- Use `DesignTokens` constants for all spacing, radii, font sizes (never hardcoded values)
- Use `AppColors` for all colors
- Private widget constructors may omit `key` parameter

### Repository Pattern

- Abstract interface in `<entity>_repository.dart`
- Concrete implementations: `local_<entity>_repository.dart`, `firestore_<entity>_repository.dart`
- Swap implementation via Riverpod provider (currently using local implementations)

### Design System

- `AppColors` — color palette, dosha-specific colors, difficulty colors
- `DesignTokens` — spacing, typography scale, border radii, icon sizes, breakpoints, durations
- `AppTheme` — Material 3 ThemeData (light theme, Google Fonts "Outfit")
- All three use private constructors (`ClassName._()`) to prevent instantiation

### Testing Conventions

- Tests live in `test/` mirroring `lib/` structure (`test/providers/`, `test/screens/`, etc.)
- Manual `Fake`/`Mock` classes implementing repository interfaces (no mockito/mocktail)
- Use `flutter_riverpod` `ProviderContainer` with overrides for provider testing
- Use `network_image_mock` for widgets displaying network images
- Widget tests use `pumpWidget` with `MaterialApp` wrapper and `ProviderScope`

### Localization

- ARB files in `lib/l10n/` (English, Hindi, Marathi)
- Access strings via `AppLocalizations.of(context)!.keyName`
- Config in `l10n.yaml`; generate with `flutter gen-l10n`
