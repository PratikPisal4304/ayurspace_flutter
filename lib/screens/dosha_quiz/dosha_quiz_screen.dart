import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../config/colors.dart';
import '../../config/design_tokens.dart';

import '../../providers/dosha_quiz_provider.dart';

class DoshaQuizScreen extends ConsumerWidget {
  const DoshaQuizScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final quizState = ref.watch(doshaQuizProvider);
    final quizNotifier = ref.read(doshaQuizProvider.notifier);

    // Handle quiz completion - navigate to result
    ref.listen<DoshaQuizState>(doshaQuizProvider, (previous, next) {
      if (next.isComplete && !(previous?.isComplete ?? false)) {
        context.pushReplacement('/dosha-profile');
      }
    });

    final currentQuestion = quizState.currentQuestion;
    if (currentQuestion == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dosha Quiz'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            quizNotifier.reset();
            context.pop();
          },
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(DesignTokens.spacingMd),
          child: Column(
            children: [
              // Progress indicator
              LinearProgressIndicator(
                value: quizState.progress,
                backgroundColor: AppColors.surfaceVariant,
                color: AppColors.primary,
              ),
              const SizedBox(height: DesignTokens.spacingXs),
              Text(
                'Question ${quizState.currentQuestionIndex + 1} of ${quizState.questions.length}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: DesignTokens.spacingXl),

              // Question text
              Text(
                currentQuestion.question,
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: DesignTokens.spacingLg),

              // Options
              ...currentQuestion.options.asMap().entries.map((entry) {
                final index = entry.key;
                final option = entry.value;
                final isSelected = quizState.currentAnswer == index;

                return Padding(
                  padding: const EdgeInsets.only(bottom: DesignTokens.spacingSm),
                  child: _QuizOptionCard(
                    text: option.text,
                    isSelected: isSelected,
                    onTap: () {
                      quizNotifier.selectAnswer(index, option.dosha);
                      // Auto-advance after a short delay
                      Future.delayed(const Duration(milliseconds: 300), () {
                        quizNotifier.nextQuestion();
                      });
                    },
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}

/// Card widget for quiz options
class _QuizOptionCard extends StatelessWidget {
  final String text;
  final bool isSelected;
  final VoidCallback onTap;

  const _QuizOptionCard({
    required this.text,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(DesignTokens.radiusMd),
      child: AnimatedContainer(
        duration: DesignTokens.animationFast,
        width: double.infinity,
        padding: const EdgeInsets.all(DesignTokens.spacingMd),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withValues(alpha: 0.2)
              : AppColors.surface,
          borderRadius: BorderRadius.circular(DesignTokens.radiusMd),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.border,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Text(
          text,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: isSelected ? AppColors.primary : null,
                fontWeight: isSelected ? FontWeight.w500 : null,
              ),
        ),
      ),
    );
  }
}
