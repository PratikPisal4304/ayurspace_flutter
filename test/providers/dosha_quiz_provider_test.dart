import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:ayurspace_flutter/providers/dosha_quiz_provider.dart';
import 'package:ayurspace_flutter/providers/user_provider.dart';
import 'package:ayurspace_flutter/data/models/dosha.dart';
import 'package:ayurspace_flutter/data/models/user_profile.dart'; // UserSettings
import 'package:ayurspace_flutter/data/sources/dosha_quiz_data.dart';

// --- Mocks ---

class MockUserNotifier extends StateNotifier<UserState> implements UserNotifier {
  MockUserNotifier() : super(const UserState());

  // Using simple boolean flags/callback for verification instead of fully fledged mockito for StateNotifier
  bool saveDoshaResultCalled = false;
  DoshaResult? savedResult;

  @override
  Future<void> saveDoshaResult(DoshaResult result) async {
    saveDoshaResultCalled = true;
    savedResult = result;
  }
  
  @override
  void onAuthStateChanged(dynamic user) {}
  
  @override
  void loading() {}
  
  @override
  Future<void> updateName(String name) async {}
  
  @override
  Future<void> updateEmail(String email) async {}
  
  @override
  void updateSettings(UserSettings settings) {}
  
  @override
  Future<void> incrementPlantsScanned() async {}
  
  @override
  Future<void> incrementRemediesTried() async {}
  
  @override
  Future<void> toggleBookmark(String plantId) async {}
  
  @override
  Future<void> toggleFavoriteRemedy(String remedyId) async {}
}

void main() {
  late ProviderContainer container;
  late MockUserNotifier mockUserNotifier;

  setUp(() {
    mockUserNotifier = MockUserNotifier();
    container = ProviderContainer(
      overrides: [
        userProvider.overrideWith((ref) => mockUserNotifier),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  group('DoshaQuizNotifier Tests', () {
    test('Initial state loads questions', () {
      final state = container.read(doshaQuizProvider);
      
      expect(state.questions.length, greaterThan(0));
      expect(state.questions.length, doshaQuizData.length);
      expect(state.currentQuestionIndex, 0);
      expect(state.answers.isEmpty, true);
      expect(state.vataScore, 0);
    });

    test('selectAnswer updates answers and score', () {
      final notifier = container.read(doshaQuizProvider.notifier);
      
      // Select first option (assuming Vata based on implementation, 
      // but logic says selectAnswer(index, dosha))
      notifier.selectAnswer(0, DoshaType.vata);

      final state = container.read(doshaQuizProvider);
      expect(state.answers[0], 0);
      expect(state.vataScore, 1);
      expect(state.pittaScore, 0);
      expect(state.kaphaScore, 0);
    });

    test('nextQuestion increments index', () {
      final notifier = container.read(doshaQuizProvider.notifier);
      
      notifier.nextQuestion();
      
      final state = container.read(doshaQuizProvider);
      expect(state.currentQuestionIndex, 1);
    });

    test('Completing quiz calculates result and saves it', () async {
      final notifier = container.read(doshaQuizProvider.notifier);
      final questionsCount = doshaQuizData.length;

      // Answer all questions to reach the end
      // To simulate "mostly vata", we answer vata for all
      for (int i = 0; i < questionsCount; i++) {
        notifier.selectAnswer(0, DoshaType.vata);
        
        // Move next (if not last)
        if (i < questionsCount - 1) {
           notifier.nextQuestion();
        }
      }
      
      // Now at last question, call nextQuestion triggers complete
      notifier.nextQuestion();

      final state = container.read(doshaQuizProvider);
      expect(state.isComplete, true);
      expect(state.result?.dominant, DoshaType.vata);
      
      // Verify persistence
      expect(mockUserNotifier.saveDoshaResultCalled, true);
      expect(mockUserNotifier.savedResult?.dominant, DoshaType.vata);
    });

    test('reset clears state', () {
      final notifier = container.read(doshaQuizProvider.notifier);
      notifier.selectAnswer(0, DoshaType.vata);
      notifier.nextQuestion();
      
      notifier.reset();
      
      final state = container.read(doshaQuizProvider);
      expect(state.currentQuestionIndex, 0);
      expect(state.answers.isEmpty, true);
      expect(state.vataScore, 0);
      expect(state.isComplete, false);
    });
  });
}
