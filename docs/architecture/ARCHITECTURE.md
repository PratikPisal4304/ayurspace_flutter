# AyurSpace Architecture Documentation

## Overview

AyurSpace is a sophisticated digital Ayurveda companion built with Flutter. It embraces a scalable, highly testable architecture patterns designed for feature-rich, high-performance applications. The architecture facilitates complex integrations such as real-time AI chatbots, image recognition, multi-language support, and cloud-based data synchronization.

## Technology Stack

- **Framework**: Flutter (Dart)
- **State Management**: Riverpod (`StateNotifier`, `AsyncNotifier` patterns)
- **Navigation**: `go_router` (incorporating `ShellRoute` for persistent bottom navigation)
- **Backend Infrastructure**: Firebase (Authentication, Cloud Firestore, Firebase Storage)
- **AI & ML Integrations**:
  - **Plant.id API**: For robust, AI-driven plant identification from images.
  - **Google Gemini API**: For powering **AyurBot**, generating rich contextual insights, Ayurvedic wellness recommendations, and dynamic chat responses.
- **Localization**: `gen_l10n` (ARB files) with support for English, Hindi, and Marathi.
- **Styling**: Custom foundational design systems (Tokens, Themes, Colors).

## Directory Structure

The project follows a feature-first, layered architectural approach inside `lib/`:

```
lib/
├── config/             # Global configurations
│   ├── colors.dart         # Core color palette
│   ├── design_tokens.dart  # Spacing, typography, radii, shadows
│   ├── route_names.dart    # Centralized route name definitions
│   ├── routes.dart         # go_router configurations and shell routes
│   └── theme.dart          # Global Material Theme definitions
├── data/               # Data layer (Models, Repositories, Data Sources)
│   ├── models/             # Domain entities (Plant, Remedy, User Profile, ChatMessage)
│   ├── repositories/       # Abstract repository interfaces and implementations
│   └── sources/            # Local data mocks, static assets, and remote endpoints mapping
├── l10n/               # Localization ARB files (app_en.arb, app_hi.arb, app_mr.arb)
├── providers/          # Riverpod state management providers
│   ├── auth_provider.dart
│   ├── chat_provider.dart        # AyurBot chat session state
│   ├── dosha_quiz_provider.dart  # Dosha assessment logic
│   ├── language_provider.dart    # App localization state
│   ├── scan_provider.dart        # Plant Scanner state and API coordination
│   └── wellness_provider.dart    # User health and remedy suggestions
├── screens/            # UI Layer, strictly organized by Feature
│   ├── auth/           # Login, Registration modules
│   ├── camera/         # Camera view for plant scanning
│   ├── chat/           # AyurBot conversation UI
│   ├── discover/       # Explore feed and search
│   ├── dosha_quiz/     # Interactive Ayurvedic body-type quiz
│   ├── home/           # Dashboard and daily insights
│   ├── plant_detail/   # Detailed view of Ayurvedic plants
│   ├── profile/        # User settings and personal info
│   ├── remedies/       # Curated health treatments
│   └── scan_result/    # AI analysis results from camera
├── services/           # External API & Infrastructure wrappers
│   ├── auth_service.dart       # Firebase Auth operations
│   ├── firestore_service.dart  # Cloud Firestore CRUD
│   ├── gemini_service.dart     # Google Gemini API integration
│   └── plant_id_service.dart   # Plant.id image processing
├── utils/              # Helper functions, formatters, and extensions
└── widgets/            # Reusable atomic UI components (Cards, Buttons, Inputs)
```

## Architecture & Data Flow

AyurSpace strictly decouples the UI from business logic and data fetching, enforcing a unidirectional data flow.

```text
UI Layer (ConsumerWidget)
      │
      │ listes to / watches
      ▼
State Management (StateNotifier / AsyncNotifier Providers)
      │
      │ reads / invalidates
      ▼
Repository Layer (e.g., ScanRepository, ChatRepository)
      │
      │ delegates tasks to
      ▼
Service Layer / Data Sources (Firebase, Gemini API, Plant.id API)
```

### Core Architecture Principles

1. **Repository Pattern**:
   All external data interactions (network calls, local database queries) are abstracted behind Repository interfaces. This ensures the app logic isn't tightly bound to specific services (like Firebase), allowing for easier mocks and refactoring.
   ```dart
   abstract class PlantsRepository {
     Future<List<Plant>> getPlants();
     Future<Plant> getPlantDetails(String id);
   }
   ```

2. **Immutable State Representation**:
   All state within Riverpod providers is strictly immutable. Changes are managed via `copyWith()` methods, preventing unintended side-effects and ensuring reliable UI rebuilds.
   ```dart
   state = state.copyWith(isLoading: true, scanError: null);
   ```

3. **Dependency Injection**:
   Services and dependencies are injected safely via Riverpod providers rather than singletons or Service Locators, drastically improving unit testability.
   ```dart
   final geminiServiceProvider = Provider((ref) => GeminiService());
   
   final chatProvider = StateNotifierProvider<ChatNotifier, ChatState>((ref) {
     return ChatNotifier(ref.watch(geminiServiceProvider));
   });
   ```

4. **Service Isolation (AI & ML)**:
   Integration with large external APIs (Gemini, Plant.id) are isolated inside dedicated `Service` classes. The UI never talks to Gemini directly; it calls a `Provider` action, which uses a `Repository`, which finally tasks the `GeminiService`.

## Key Features Under the Hood

- **Plant Identifying System**: The `scan_provider` coordinates the camera image capture, passes the image to the `plant_id_service` to identify the species, and then cascades context to the `gemini_service` to retrieve specific Ayurvedic uses for the identified plant.
- **AyurBot Chat Engine**: Powered by Google Gemini. Context from the user's current session or viewed plant can be seamlessly passed into the conversational prompt to create localized, relevant Ayurvedic advice.
- **Multilingual System**: The `language_provider` handles switching between English, Hindi, and Marathi dynamically, instantly rebuilding the UI loaded via Flutter's `gen_l10n`.
- **Dosha State Management**: User responses to the Dosha quiz are maintained in the `dosha_quiz_provider`, modifying the global `wellness_provider` state to tailor the home screen content to the user's specific Mind-Body constitution (Vata, Pitta, or Kapha).

## Testing

- **Repository Mocks**: Utilizing `mockito` or `mocktail` to inject mock repositories inside Provider tests.
- **Unit Testing**: Strong coverage focused on `test/models/` to ensure serialization integrity, and `test/providers/` to ensure predictable state transitions.
- **Running Tests**: Run via standard CLI `flutter test`.
