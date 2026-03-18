# Code Style & Conventions

- Single quotes, trailing commas, `const` everywhere possible, `super.key` syntax (Dart 3)
- Imports order: `dart:` → `package:` third-party → relative project imports
- Private widgets: `_UpperCamelCase`, defined in the same file as the public widget they support
- Riverpod providers named `lowerCamelCaseProvider`
- Testing: Manual `Fake`/`Mock` classes (no mockito); use `ProviderContainer` with overrides; widget tests use `pumpWidget` with `MaterialApp` + `ProviderScope`; `network_image_mock` for network images
