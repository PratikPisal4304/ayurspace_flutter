# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project

AyurSpace — Flutter mobile app (Dart SDK ^3.5.0) for Ayurvedic wellness. Firebase backend, Riverpod state management, GoRouter navigation, Google Gemini AI + Plant.id API.

> Full developer reference: [AGENTS.md](AGENTS.md)

## Commands

```bash
flutter pub get                          # Install dependencies
flutter run                              # Run (debug)
flutter analyze                          # Lint
dart format .                            # Format (80-char lines)
flutter test                             # All tests
flutter test test/providers/plants_provider_test.dart  # Single file
flutter test --name "test name"          # Single test by name
flutter gen-l10n                         # Regenerate localization files
dart run build_runner build --delete-conflicting-outputs  # Code generation (inactive)
```

## Architecture

```
lib/
  config/         — Theme, colors (AppColors), design tokens (DesignTokens), GoRouter, route constants
  data/
    models/       — Domain entities (Equatable, const, fromJson/toJson/copyWith)
    repositories/ — Abstract interfaces + local/Firestore implementations
    sources/      — Static seed data
  providers/      — Riverpod StateNotifier providers
  screens/        — Feature screens, one folder per feature
  services/       — External API wrappers: AuthService, FirestoreService, GeminiService, PlantIdService
  utils/          — Custom exceptions (AppException hierarchy), helpers
  widgets/        — Reusable components; barrel export via widgets/widgets.dart
```

### Key patterns

**State management**: `StateNotifierProvider<Notifier, State>` for business logic; `Provider` for DI; `StreamProvider` for auth state. Screens are `ConsumerWidget`; pure UI is `StatelessWidget`.

**Repository pattern**: Abstract interface → swap between `local_*` and `firestore_*` implementations via provider override. Currently using local implementations.

**Routing**: GoRouter with auth guards in `config/router.dart`. Route name constants in `config/routes.dart`. Bottom nav shell route via `widgets/common/main_scaffold.dart`.

**Design system**: Always use `DesignTokens` for spacing/radii/sizes and `AppColors` for colors — never hardcode values. Font: Google Fonts "Outfit".

**Error handling**: `try/catch` in providers → `state.copyWith(error: '...')`. Services return response objects with `isError` flag. Use `debugPrint()`, never `print()`.

**Testing**: Manual `Fake`/`Mock` classes (no mockito). Use `ProviderContainer` with overrides. Widget tests use `pumpWidget` with `MaterialApp` + `ProviderScope`. `network_image_mock` for network images.

**Localization**: ARB files in `lib/l10n/`. Access via `AppLocalizations.of(context)!.keyName`. Run `flutter gen-l10n` after adding strings.

## Code Style

- Single quotes, trailing commas, `const` everywhere possible, `super.key` syntax (Dart 3)
- Imports: `dart:` → `package:` third-party → relative project imports
- Private widgets `_UpperCamelCase` defined in the same file as the public widget they support
- Riverpod providers named `lowerCamelCaseProvider`
