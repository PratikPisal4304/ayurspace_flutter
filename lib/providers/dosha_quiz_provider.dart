import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/dosha.dart';
import '../data/sources/dosha_quiz_data.dart';
import 'user_provider.dart';

/// State for the Dosha Quiz
class DoshaQuizState {
  final List<DoshaQuizQuestion> questions;
  final int currentQuestionIndex;
  final Map<int, int> answers; // questionIndex -> selectedOptionIndex
  final int vataScore;
  final int pittaScore;
  final int kaphaScore;
  final bool isComplete;
  final DoshaResult? result;

  const DoshaQuizState({
    this.questions = const [],
    this.currentQuestionIndex = 0,
    this.answers = const {},
    this.vataScore = 0,
    this.pittaScore = 0,
    this.kaphaScore = 0,
    this.isComplete = false,
    this.result,
  });

  DoshaQuizState copyWith({
    List<DoshaQuizQuestion>? questions,
    int? currentQuestionIndex,
    Map<int, int>? answers,
    int? vataScore,
    int? pittaScore,
    int? kaphaScore,
    bool? isComplete,
    DoshaResult? result,
  }) {
    return DoshaQuizState(
      questions: questions ?? this.questions,
      currentQuestionIndex: currentQuestionIndex ?? this.currentQuestionIndex,
      answers: answers ?? this.answers,
      vataScore: vataScore ?? this.vataScore,
      pittaScore: pittaScore ?? this.pittaScore,
      kaphaScore: kaphaScore ?? this.kaphaScore,
      isComplete: isComplete ?? this.isComplete,
      result: result ?? this.result,
    );
  }

  /// Get current question
  DoshaQuizQuestion? get currentQuestion =>
      currentQuestionIndex < questions.length
          ? questions[currentQuestionIndex]
          : null;

  /// Check if this is the last question
  bool get isLastQuestion => currentQuestionIndex >= questions.length - 1;

  /// Get progress as a value between 0 and 1
  double get progress =>
      questions.isEmpty ? 0 : (currentQuestionIndex + 1) / questions.length;

  /// Get the selected option index for current question
  int? get currentAnswer => answers[currentQuestionIndex];
}

/// Notifier for managing Dosha Quiz state and logic
class DoshaQuizNotifier extends StateNotifier<DoshaQuizState> {
  final Ref _ref;

  DoshaQuizNotifier(this._ref) : super(const DoshaQuizState()) {
    _loadQuestions();
  }

  /// Load quiz questions from data source
  void _loadQuestions() {
    state = state.copyWith(questions: doshaQuizData);
  }

  /// Select an answer for the current question
  void selectAnswer(int optionIndex, DoshaType dosha) {
    // Update answers map
    final newAnswers = Map<int, int>.from(state.answers);
    newAnswers[state.currentQuestionIndex] = optionIndex;

    // Update dosha scores
    int newVata = state.vataScore;
    int newPitta = state.pittaScore;
    int newKapha = state.kaphaScore;

    switch (dosha) {
      case DoshaType.vata:
        newVata++;
        break;
      case DoshaType.pitta:
        newPitta++;
        break;
      case DoshaType.kapha:
        newKapha++;
        break;
    }

    state = state.copyWith(
      answers: newAnswers,
      vataScore: newVata,
      pittaScore: newPitta,
      kaphaScore: newKapha,
    );
  }

  /// Move to the next question
  void nextQuestion() {
    if (state.isLastQuestion) {
      _completeQuiz();
    } else {
      state = state.copyWith(
        currentQuestionIndex: state.currentQuestionIndex + 1,
      );
    }
  }

  /// Complete the quiz and calculate result
  void _completeQuiz() {
    final result = DoshaResult.calculate(
      vata: state.vataScore.toDouble(),
      pitta: state.pittaScore.toDouble(),
      kapha: state.kaphaScore.toDouble(),
    );

    state = state.copyWith(
      isComplete: true,
      result: result,
    );

    // Save result to user profile
    _ref.read(userProvider.notifier).saveDoshaResult(result);
  }

  /// Reset the quiz to start over
  void reset() {
    state = DoshaQuizState(questions: doshaQuizData);
  }

  /// Go to a specific question (for review purposes)
  void goToQuestion(int index) {
    if (index >= 0 && index < state.questions.length) {
      state = state.copyWith(currentQuestionIndex: index);
    }
  }
}

/// Provider for Dosha Quiz
final doshaQuizProvider =
    StateNotifierProvider<DoshaQuizNotifier, DoshaQuizState>(
  (ref) => DoshaQuizNotifier(ref),
);

/// Provider for current question
final currentQuestionProvider = Provider<DoshaQuizQuestion?>((ref) {
  return ref.watch(doshaQuizProvider).currentQuestion;
});

/// Provider for quiz progress
final quizProgressProvider = Provider<double>((ref) {
  return ref.watch(doshaQuizProvider).progress;
});
