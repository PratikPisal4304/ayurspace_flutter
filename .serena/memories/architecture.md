# Architecture & Code Structure

```
lib/
  config/         — Theme, AppColors, DesignTokens, GoRouter, route constants
  data/
    models/       — Domain entities (Equatable, const, fromJson/toJson/copyWith)
    repositories/ — Abstract interfaces + local/Firestore implementations
    sources/      — Static seed data
  providers/      — Riverpod StateNotifier providers
  screens/        — Feature screens, one folder per feature
  services/       — External API wrappers: AuthService, FirestoreService, GeminiService, PlantIdService
  utils/          — AppException hierarchy, helpers
  widgets/        — Reusable components; barrel export via widgets/widgets.dart
```

**Key patterns**:
- State: `StateNotifierProvider<Notifier, State>` for logic; `Provider` for DI; `StreamProvider` for auth
- Screens: `ConsumerWidget`; pure UI: `StatelessWidget`
- Repository: Abstract interface → local or Firestore impl via provider override (currently local)
- Routing: GoRouter with auth guards in `config/router.dart`; route name constants in `config/routes.dart`; bottom nav shell in `widgets/common/main_scaffold.dart`
- Design system: Always use `DesignTokens` for spacing/radii and `AppColors` for colors — never hardcode
- Error handling: `try/catch` in providers → `state.copyWith(error: '...')`; services return objects with `isError` flag; use `debugPrint()` not `print()`
- Localization: ARB files in `lib/l10n/`; access via `AppLocalizations.of(context)!.keyName`; run `flutter gen-l10n` after changes
