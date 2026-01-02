# Ayurspace Flutter Architecture

## Overview

Ayurspace is a digital Ayurveda companion app built with Flutter, following modern architectural patterns for scalability and testability.

## Technology Stack

- **State Management**: Riverpod (StateNotifier pattern)
- **Navigation**: go_router with ShellRoute for persistent navigation
- **Backend**: Firebase (Auth, Firestore, Storage)
- **Styling**: Custom design system with tokens

## Directory Structure

```
lib/
├── config/           # App configuration
│   ├── colors.dart       # Color palette
│   ├── design_tokens.dart # Spacing, radius, shadows
│   ├── router.dart       # go_router configuration
│   └── theme.dart        # Material theme
├── data/
│   ├── models/           # Domain models (Plant, Remedy, etc.)
│   ├── repositories/     # Repository interfaces & implementations
│   └── sources/          # Static/local data sources
├── providers/        # Riverpod providers and state notifiers
├── screens/          # Feature screens (organized by feature)
├── services/         # Firebase and external services
└── widgets/          # Reusable UI components
```

## Data Flow

```
UI (ConsumerWidget)
    ↓ watches
Provider (StateNotifierProvider)
    ↓ uses
Repository (PlantsRepository)
    ↓ fetches from
Data Source (local/remote)
```

## Key Patterns

### Repository Pattern
All data access goes through repository interfaces:
```dart
abstract class PlantsRepository {
  Future<List<Plant>> getPlants();
}
```

### Immutable State
State objects are immutable with `copyWith()` methods:
```dart
state = state.copyWith(isLoading: true);
```

### Dependency Injection
Services injected via Riverpod providers:
```dart
final plantsProvider = StateNotifierProvider<PlantsNotifier, PlantsState>(
  (ref) => PlantsNotifier(ref.watch(plantsRepositoryProvider)),
);
```

## Testing

- **Unit tests**: `test/models/`, `test/providers/`
- **Mock repositories** for isolated provider testing
- Run tests: `flutter test`
