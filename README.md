# AyurSpace Flutter

A comprehensive **Digital Ayurveda Companion** mobile application built with Flutter.

![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)

## Features

### 🌿 Plant Encyclopedia
- 30+ Ayurvedic medicinal plants
- Detailed information with Hindi names
- Dosha compatibility indicators
- Uses, dosage, and precautions
- Growing tips and harvest times

### 🔬 Plant Scanner
- AI-powered plant identification
- Camera and gallery support
- Cloud and local recognition modes

### 💬 AI Chat Assistant
- Conversational AI for Ayurvedic guidance
- Context-aware responses
- Quick suggestion chips

### 🍃 Remedies Library
- 8+ traditional Ayurvedic remedies
- Bilingual content (English + Hindi)
- Step-by-step instructions
- Ingredient lists with substitutes

### 🧘 Wellness Hub
- Daily routine (Dinacharya)
- Dosha balance tips
- Yoga & meditation guides
- Seasonal wisdom (Ritucharya)

### 📊 Dosha Quiz
- 10-question personality assessment
- Determine your Vata/Pitta/Kapha balance
- Personalized recommendations

### 🌐 Multilingual
- English, Hindi, and Marathi support

## Tech Stack

- **Framework**: Flutter 3.x
- **State Management**: Riverpod
- **Navigation**: GoRouter
- **UI**: Material 3 with custom Ayurvedic theme
- **Images**: CachedNetworkImage
- **Storage**: SharedPreferences, Hive

## Getting Started

### Prerequisites
- Flutter SDK 3.0+
- Dart 3.0+
- Android Studio / VS Code

### Installation

```bash
# Clone the repository
git clone https://github.com/AyurSpace/ayurspace_flutter.git

# Navigate to project
cd ayurspace_flutter

# Install dependencies
flutter pub get

# Run the app
flutter run
```

## Project Structure

```
lib/
├── config/         # Colors, theme, router, design tokens
├── data/
│   ├── models/     # Plant, Remedy, Dosha, User, Chat
│   └── sources/    # Static data (plants, remedies, quiz)
├── l10n/           # Localization strings
├── providers/      # Riverpod state management
├── screens/        # App screens
└── widgets/        # Reusable components
```

## Screenshots

Coming soon...

## License

This project is licensed under the MIT License.

## Acknowledgments

- Sacred Ayurvedic Color Palette inspired by traditional Indian design
- Plant data sourced from authentic Ayurvedic texts
