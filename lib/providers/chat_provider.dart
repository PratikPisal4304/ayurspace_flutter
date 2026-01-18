import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../data/models/chat_message.dart';
import '../services/gemini_service.dart';
import '../providers/user_provider.dart';
import '../providers/chat_history_provider.dart';

/// State for the Chat feature
class ChatState {
  final List<ChatMessage> messages;
  final bool isTyping;
  final String? error;

  const ChatState({
    this.messages = const [],
    this.isTyping = false,
    this.error,
  });

  ChatState copyWith({
    List<ChatMessage>? messages,
    bool? isTyping,
    String? error,
    bool clearError = false,
  }) {
    return ChatState(
      messages: messages ?? this.messages,
      isTyping: isTyping ?? this.isTyping,
      error: clearError ? null : (error ?? this.error),
    );
  }
}

/// Comprehensive Ayurveda Expert System Prompt
const String _ayurvedaSystemPrompt = '''
You are **AyurBot** 🙏, a highly knowledgeable Ayurvedic wellness consultant trained in the 5,000-year-old science of Ayurveda from the Vedic tradition of India.

## YOUR EXPERTISE

### 1. TRI-DOSHA THEORY (त्रिदोष)
You have deep understanding of the three fundamental bio-energies:
- **Vata (वात)** - Air + Space: Governs movement, creativity, flexibility. When imbalanced: anxiety, dry skin, constipation, insomnia.
- **Pitta (पित्त)** - Fire + Water: Governs digestion, metabolism, intellect. When imbalanced: inflammation, acidity, anger, skin rashes.
- **Kapha (कफ)** - Earth + Water: Governs structure, stability, immunity. When imbalanced: weight gain, congestion, lethargy, depression.

### 2. PRAKRITI & VIKRITI
- **Prakriti**: Birth constitution (unchanging dosha balance)
- **Vikriti**: Current state of imbalance
You can assess and advise based on constitution type.

### 3. AYURVEDIC HERBS & FORMULATIONS (औषधि)
You have encyclopedic knowledge of:
- **Adaptogenic Herbs**: Ashwagandha (अश्वगंधा), Shatavari (शतावरी), Brahmi (ब्राह्मी)
- **Immunity Boosters**: Giloy/Guduchi (गिलोय), Tulsi (तुलसी), Amla (आमला)
- **Digestive Herbs**: Triphala (त्रिफला), Ginger (अदरक), Cumin (जीरा)
- **Respiratory Herbs**: Vasaka (वासा), Licorice (मुलेठी), Pippali (पिप्पली)
- **Classical Formulations**: Chyawanprash, Triphala Churna, Dashamoola, Mahasudarshan, etc.

### 4. PANCHAKARMA (पंचकर्म)
The five purification therapies:
- Vamana (therapeutic vomiting)
- Virechana (purgation)
- Basti (medicated enema)
- Nasya (nasal administration)
- Raktamokshana (bloodletting)

### 5. DINACHARYA (दिनचर्या) & RITUCHARYA (ऋतुचर्या)
- Daily routines for optimal health
- Seasonal regimens for each Ritu (season)
- Oil pulling (Gandusha), tongue scraping, Abhyanga (oil massage)

### 6. AHARA (आहार) - DIETARY WISDOM
- Six tastes (Shad Rasa): Sweet, Sour, Salty, Pungent, Bitter, Astringent
- Dosha-specific diet recommendations
- Food combinations (Viruddha Ahara)
- Agni (digestive fire) optimization

### 7. YOGA & PRANAYAMA
- Dosha-balancing asanas
- Breathing techniques: Nadi Shodhana, Bhastrika, Sheetali
- Meditation practices

## RESPONSE GUIDELINES

1. **Be Warm & Respectful**: Start with "Namaste 🙏" when appropriate. Use Sanskrit terms with translations.

2. **Provide Actionable Advice**: Give specific herbs, doses, timing, and preparation methods.

3. **Format Clearly**: Use headers, bullet points, and emojis for readability:
   - 🌿 for herbs
   - 🧘 for practices
   - 🍲 for dietary advice
   - ⚠️ for warnings

4. **Include Safety Disclaimers**: For serious conditions, recommend consulting a qualified Vaidya (Ayurvedic doctor).

5. **Personalize When Possible**: If user's dosha is known, tailor advice accordingly.

6. **Keep Responses Focused**: Maximum 400 words. Be informative yet concise.

7. **Bridge Ancient & Modern**: Connect traditional wisdom to modern health concerns.

## MEDICAL DISCLAIMER
While you provide traditional Ayurvedic knowledge, remind users that:
- This is educational, not medical advice
- Pregnant/nursing women should consult doctors
- Those on medication should check herb-drug interactions
- Serious conditions require professional consultation
''';

/// Service for generating AI responses using Gemini
class ChatService {
  static const _uuid = Uuid();
  final GeminiService _geminiService;
  final String? _userDosha;

  ChatService(this._geminiService, {String? userDosha}) : _userDosha = userDosha;

  /// Welcome message content
  static const String welcomeMessage =
      '🙏 Namaste! I am **AyurBot**, your Ayurvedic wellness guide.\n\n'
      'I have deep knowledge of the 5,000-year-old science of Ayurveda and can help you with:\n\n'
      '🌿 **Herbs & Remedies** - Tulsi, Ashwagandha, Triphala & 100+ more\n'
      '⚖️ **Dosha Balancing** - Vata, Pitta, Kapha analysis\n'
      '🍲 **Diet & Nutrition** - Dosha-specific food guidance\n'
      '🧘 **Yoga & Lifestyle** - Pranayama, meditation, daily routines\n'
      '💊 **Natural Treatments** - Traditional remedies for common ailments\n\n'
      'How may I assist your wellness journey today?';

  /// Suggested prompts for new users
  static const List<String> suggestions = [
    'What is my dosha type?',
    'Best herbs for immunity',
    'How to reduce stress naturally?',
    'Ayurvedic diet for digestion',
    'Herbs for better sleep',
    'Morning routine (Dinacharya)',
  ];

  /// Build the full prompt with system context and conversation history
  String _buildPrompt(String userMessage, List<ChatMessage> history) {
    final buffer = StringBuffer();
    
    // System prompt
    buffer.writeln(_ayurvedaSystemPrompt);
    buffer.writeln();
    
    // User's dosha if known
    if (_userDosha != null && _userDosha.isNotEmpty) {
      buffer.writeln('## USER CONTEXT');
      buffer.writeln('The user\'s Prakriti (constitution) is: **$_userDosha**');
      buffer.writeln('Personalize your advice for this dosha type when relevant.');
      buffer.writeln();
    }
    
    // Conversation history (last 10 messages for context)
    final recentHistory = history.length > 10 
        ? history.sublist(history.length - 10) 
        : history;
    
    if (recentHistory.isNotEmpty) {
      buffer.writeln('## CONVERSATION HISTORY');
      for (final msg in recentHistory) {
        final role = msg.role == ChatRole.user ? 'User' : 'AyurBot';
        buffer.writeln('$role: ${msg.content}');
      }
      buffer.writeln();
    }
    
    // Current user message
    buffer.writeln('## CURRENT QUERY');
    buffer.writeln('User: $userMessage');
    buffer.writeln();
    buffer.writeln('Provide a helpful, knowledgeable Ayurvedic response:');
    
    return buffer.toString();
  }

  /// Generate an AI response based on the query
  Future<String> getResponse(String query, List<ChatMessage> history) async {
    final prompt = _buildPrompt(query, history);
    final response = await _geminiService.sendMessage(prompt);
    
    if (response.isError) {
      // Fall back to basic response on error
      return _getFallbackResponse(query);
    }
    
    return response.text;
  }

  /// Fallback response when API fails
  String _getFallbackResponse(String query) {
    final lowerQuery = query.toLowerCase();

    if (lowerQuery.contains('dosha')) {
      return '🙏 In Ayurveda, there are three doshas:\n\n'
          '• **Vata (वात)** - Air + Space: Creative, quick-thinking, prone to anxiety\n'
          '• **Pitta (पित्त)** - Fire + Water: Ambitious, sharp intellect, prone to inflammation\n'
          '• **Kapha (कफ)** - Earth + Water: Calm, stable, prone to lethargy\n\n'
          'Your unique Prakriti (constitution) is a combination of these. '
          'Would you like to take our Dosha Quiz to discover your type? 🌿';
    } else if (lowerQuery.contains('immunity') || lowerQuery.contains('immune')) {
      return '🌿 **Ayurvedic Immunity Boosters:**\n\n'
          '• **Giloy (Guduchi)** - "Amrita" (divine nectar) for immunity\n'
          '• **Tulsi** - Sacred basil with antimicrobial properties\n'
          '• **Amla** - Richest source of Vitamin C\n'
          '• **Ashwagandha** - Adaptogenic stress reliever\n'
          '• **Chyawanprash** - Classical immune tonic\n\n'
          '**Daily Practice:** Take 1 tsp Chyawanprash with warm milk each morning.\n\n'
          '⚠️ Consult a Vaidya for personalized dosing.';
    } else if (lowerQuery.contains('stress') || lowerQuery.contains('anxiety')) {
      return '🧘 **Ayurvedic Stress Relief:**\n\n'
          '**Herbs:**\n'
          '• Brahmi - Calms mind, enhances memory\n'
          '• Ashwagandha - Reduces cortisol\n'
          '• Jatamansi - Promotes restful sleep\n\n'
          '**Practices:**\n'
          '• Abhyanga (warm oil self-massage)\n'
          '• Nadi Shodhana (alternate nostril breathing)\n'
          '• Shirodhara (oil flow on forehead)\n\n'
          '**Tip:** 10 minutes of Pranayama daily can transform your stress response. 🙏';
    } else if (lowerQuery.contains('sleep') || lowerQuery.contains('insomnia')) {
      return '🌙 **Ayurvedic Sleep Solutions:**\n\n'
          '**Herbs:**\n'
          '• Ashwagandha with warm milk before bed\n'
          '• Brahmi tea for mental calmness\n'
          '• Jatamansi for deep rest\n\n'
          '**Practices:**\n'
          '• Warm foot massage with sesame oil\n'
          '• Avoid screens 1 hour before bed\n'
          '• Sleep by 10 PM (Kapha time)\n'
          '• Light dinner by 7 PM\n\n'
          '**Recipe:** Warm milk + 1/2 tsp Ashwagandha + pinch of nutmeg 🥛';
    }
    
    return '🙏 Thank you for your question! I\'m having trouble connecting to my knowledge base right now.\n\n'
        'Please try again, or ask about:\n'
        '• Dosha analysis\n'
        '• Herbal remedies\n'
        '• Diet recommendations\n'
        '• Stress relief practices\n\n'
        'I\'m here to guide your Ayurvedic wellness journey! 🌿';
  }

  /// Create a new message
  ChatMessage createMessage({
    required String content,
    required ChatRole role,
  }) {
    return ChatMessage(
      id: _uuid.v4(),
      role: role,
      content: content,
      timestamp: DateTime.now(),
    );
  }
}

/// Notifier for managing Chat state and logic
class ChatNotifier extends StateNotifier<ChatState> {
  final ChatService _chatService;
  final ChatHistoryNotifier _historyNotifier;
  static const _uuid = Uuid();

  ChatNotifier(this._chatService, this._historyNotifier) : super(const ChatState()) {
    _syncWithHistory();
  }

  /// Sync state with history provider
  void _syncWithHistory() {
    final messages = _historyNotifier.activeMessages;
    state = state.copyWith(messages: messages);
  }

  /// Send a message and get AI response
  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    // Add user message
    final userMessage = ChatMessage(
      id: _uuid.v4(),
      role: ChatRole.user,
      content: text.trim(),
      timestamp: DateTime.now(),
    );

    // Update local state immediately
    state = state.copyWith(
      messages: [...state.messages, userMessage],
      isTyping: true,
      clearError: true,
    );

    // Persist to history
    await _historyNotifier.addMessage(userMessage);

    try {
      // Get AI response with conversation history
      final response = await _chatService.getResponse(
        text, 
        state.messages.where((m) => m.id != userMessage.id).toList(),
      );

      final assistantMessage = ChatMessage(
        id: _uuid.v4(),
        role: ChatRole.assistant,
        content: response,
        timestamp: DateTime.now(),
      );

      state = state.copyWith(
        messages: [...state.messages, assistantMessage],
        isTyping: false,
      );

      // Persist AI response to history
      await _historyNotifier.addMessage(assistantMessage);
    } catch (e) {
      state = state.copyWith(
        isTyping: false,
        error: 'Failed to get response. Please try again.',
      );
    }
  }

  /// Switch to a different chat session
  void switchSession(String sessionId) {
    _historyNotifier.switchSession(sessionId);
    _syncWithHistory();
  }

  /// Create new chat session
  Future<void> createNewChat() async {
    await _historyNotifier.createNewSession();
    _syncWithHistory();
  }

  /// Clear current chat and start fresh (creates new session)
  Future<void> clearChat() async {
    await _historyNotifier.createNewSession();
    _syncWithHistory();
  }

  /// Delete a session
  Future<void> deleteSession(String sessionId) async {
    await _historyNotifier.deleteSession(sessionId);
    _syncWithHistory();
  }

  /// Dismiss error
  void dismissError() {
    state = state.copyWith(clearError: true);
  }
}

/// Provider for GeminiService
final geminiServiceProvider = Provider<GeminiService>((ref) {
  return GeminiService();
});

/// Provider for ChatService with user dosha context
final chatServiceProvider = Provider<ChatService>((ref) {
  final geminiService = ref.watch(geminiServiceProvider);
  final userProfile = ref.watch(userProfileProvider);
  
  // Get user's dosha if available
  String? userDosha;
  if (userProfile?.doshaResult != null) {
    userDosha = userProfile!.doshaResult!.dominant.displayName;
  }
  
  return ChatService(geminiService, userDosha: userDosha);
});

/// Provider for Chat (depends on history provider)
final chatProvider = StateNotifierProvider<ChatNotifier, ChatState>((ref) {
  final chatService = ref.watch(chatServiceProvider);
  final historyNotifier = ref.watch(chatHistoryProvider.notifier);
  return ChatNotifier(chatService, historyNotifier);
});

/// Provider for checking if chat has messages beyond welcome
final hasActiveConversationProvider = Provider<bool>((ref) {
  return ref.watch(chatProvider).messages.length > 1;
});

/// Provider for suggestions (only show when conversation is short)
final showSuggestionsProvider = Provider<bool>((ref) {
  return ref.watch(chatProvider).messages.length <= 2;
});
