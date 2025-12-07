import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../config/colors.dart';
import '../../config/design_tokens.dart';
import '../../data/models/dosha.dart';
import '../../providers/user_provider.dart';

class DoshaQuizScreen extends ConsumerStatefulWidget {
  const DoshaQuizScreen({super.key});
  @override
  ConsumerState<DoshaQuizScreen> createState() => _DoshaQuizScreenState();
}

class _DoshaQuizScreenState extends ConsumerState<DoshaQuizScreen> {
  int _currentQuestion = 0;
  final Map<int, int> _answers = {};
  int _vataScore = 0, _pittaScore = 0, _kaphaScore = 0;

  final List<Map<String, dynamic>> _questions = [
    {'q': 'How is your body frame?', 'options': [
      {'t': 'Thin, light, hard to gain weight', 'd': 'vata'},
      {'t': 'Medium, muscular, athletic', 'd': 'pitta'},
      {'t': 'Large, solid, easy to gain weight', 'd': 'kapha'},
    ]},
    {'q': 'How is your skin?', 'options': [
      {'t': 'Dry, rough, cool', 'd': 'vata'},
      {'t': 'Warm, oily, prone to redness', 'd': 'pitta'},
      {'t': 'Thick, smooth, cool', 'd': 'kapha'},
    ]},
    {'q': 'How do you handle stress?', 'options': [
      {'t': 'Become anxious, worry', 'd': 'vata'},
      {'t': 'Get irritated, angry', 'd': 'pitta'},
      {'t': 'Become withdrawn, sad', 'd': 'kapha'},
    ]},
    {'q': 'How is your appetite?', 'options': [
      {'t': 'Variable, skipping meals is easy', 'd': 'vata'},
      {'t': 'Strong, get irritable if hungry', 'd': 'pitta'},
      {'t': 'Steady, can skip meals without issue', 'd': 'kapha'},
    ]},
    {'q': 'How is your sleep?', 'options': [
      {'t': 'Light, interrupted, hard to fall asleep', 'd': 'vata'},
      {'t': 'Moderate, wake refreshed', 'd': 'pitta'},
      {'t': 'Deep, heavy, hard to wake up', 'd': 'kapha'},
    ]},
  ];

  void _selectAnswer(int answerIndex, String dosha) {
    setState(() {
      _answers[_currentQuestion] = answerIndex;
      if (dosha == 'vata') _vataScore++;
      else if (dosha == 'pitta') _pittaScore++;
      else _kaphaScore++;
    });
    
    Future.delayed(const Duration(milliseconds: 300), () {
      if (_currentQuestion < _questions.length - 1) {
        setState(() => _currentQuestion++);
      } else {
        _showResults();
      }
    });
  }

  void _showResults() {
    final result = DoshaResult.calculate(
      vata: _vataScore.toDouble(),
      pitta: _pittaScore.toDouble(),
      kapha: _kaphaScore.toDouble(),
    );
    ref.read(userProvider.notifier).saveDoshaResult(result);
    context.pushReplacement('/dosha-profile');
  }

  @override
  Widget build(BuildContext context) {
    final q = _questions[_currentQuestion];
    final progress = (_currentQuestion + 1) / _questions.length;

    return Scaffold(
      appBar: AppBar(title: const Text('Dosha Quiz'), leading: IconButton(icon: const Icon(Icons.close), onPressed: () => context.pop())),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(DesignTokens.spacingMd),
          child: Column(
            children: [
              LinearProgressIndicator(value: progress, backgroundColor: AppColors.surfaceVariant, color: AppColors.primary),
              const SizedBox(height: DesignTokens.spacingXs),
              Text('Question ${_currentQuestion + 1} of ${_questions.length}', style: Theme.of(context).textTheme.bodySmall),
              const SizedBox(height: DesignTokens.spacingXl),
              
              Text(q['q'], style: Theme.of(context).textTheme.headlineSmall, textAlign: TextAlign.center),
              const SizedBox(height: DesignTokens.spacingLg),

              ...(q['options'] as List).asMap().entries.map((e) {
                final i = e.key;
                final opt = e.value as Map<String, dynamic>;
                final isSelected = _answers[_currentQuestion] == i;
                return Padding(
                  padding: const EdgeInsets.only(bottom: DesignTokens.spacingSm),
                  child: InkWell(
                    onTap: () => _selectAnswer(i, opt['d']),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(DesignTokens.spacingMd),
                      decoration: BoxDecoration(
                        color: isSelected ? AppColors.primary.withOpacity(0.1) : AppColors.surface,
                        borderRadius: BorderRadius.circular(DesignTokens.radiusMd),
                        border: Border.all(color: isSelected ? AppColors.primary : AppColors.border, width: isSelected ? 2 : 1),
                      ),
                      child: Text(opt['t'], style: Theme.of(context).textTheme.bodyLarge),
                    ),
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
