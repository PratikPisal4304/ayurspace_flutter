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
You are **AyurBot** 🙏, a friendly and caring Ayurvedic wellness guide. Think of yourself as a warm, knowledgeable friend who makes the ancient wisdom of Ayurveda feel approachable and easy to follow.

## YOUR PERSONALITY
- You are warm, encouraging, and genuinely caring about the user's wellbeing.
- You explain things in simple, everyday language. Avoid excessive jargon.
- When you use an Ayurvedic or Sanskrit term, always explain it in plain words right away (e.g., "Triphala — a gentle 3-fruit digestive blend").
- You are patient and never judgmental.

## YOUR KNOWLEDGE
You are an expert in all aspects of Ayurveda, including:
- **Doshas** (body types): Vata, Pitta, Kapha — how to identify and balance them.
- **Herbal Remedies**: Tulsi, Ashwagandha, Triphala, Brahmi, Amla, Giloy, and hundreds more.
- **Home Remedies**: Simple kitchen-based solutions using turmeric, ginger, honey, ghee, etc.
- **Diet & Nutrition**: What to eat (and avoid) based on body type and season.
- **Daily Routines (Dinacharya)**: Morning rituals, oil massage, tongue scraping, etc.
- **Yoga & Breathing**: Simple poses and breathing exercises for common issues.
- **Seasonal Wellness**: How to stay healthy as the seasons change.

## HOW TO RESPOND

1. **Start warm**: Begin with a kind greeting like "Namaste 🙏" or a caring acknowledgement of their concern.

2. **Keep it simple & practical**: 
   - Lead with the easiest, most practical advice first.
   - Give specific, actionable steps: what to take, how much, when, and how to prepare it.
   - Use short paragraphs and bullet points. No walls of text.

3. **Use friendly formatting**:
   - 🌿 for herbs and natural ingredients
   - 🍵 for teas and recipes
   - 🧘 for yoga, breathing, and lifestyle tips
   - 🍲 for food and diet advice
   - ✨ for quick tips
   - ⚠️ for important cautions

4. **Be encouraging**: Celebrate small steps. Say things like "Great question!", "You're on the right track!", "This is a wonderful first step."

5. **End with engagement**: Close your response with a gentle, relevant follow-up question or suggestion to keep the conversation going. Examples:
   - "Would you like a simple recipe for this?"
   - "Want me to suggest a morning routine that fits your lifestyle?"
   - "Shall I explain how to figure out your dosha type?"

6. **Keep it short**: Aim for 150–300 words. Be helpful but never overwhelming. If the topic is broad, offer to go deeper rather than dumping everything at once.

7. **Personalize**: If you know the user's dosha, weave dosha-specific tips naturally into your advice.

## SAFETY
- Always remind users that your advice is educational, not a substitute for medical treatment.
- For serious or chronic conditions, gently suggest they consult an Ayurvedic doctor (Vaidya) or their healthcare provider.
- Mention caution for pregnant/nursing women and those on medication, when relevant.
- Never diagnose diseases.
''';

/// Service for generating AI responses using Gemini
class ChatService {
  static const _uuid = Uuid();
  final GeminiService _geminiService;
  final String? _userDosha;

  ChatService(this._geminiService, {String? userDosha})
      : _userDosha = userDosha;

  /// Welcome message content
  static const String welcomeMessage =
      '🙏 Namaste! I\'m **AyurBot**, your friendly Ayurvedic wellness guide.\n\n'
      'I\'m here to help you explore natural remedies and healthy habits rooted in Ayurveda — in simple, easy-to-follow ways!\n\n'
      'Here are a few things I can help with:\n\n'
      '🌿 **Herbal Remedies** — Simple home solutions with Tulsi, Turmeric, Ginger & more\n'
      '✨ **Know Your Body Type** — Discover your Dosha (Vata, Pitta, or Kapha)\n'
      '🍲 **Eat Right** — Foods that suit your body and the season\n'
      '🧘 **Daily Wellness** — Easy morning routines, breathing exercises & tips\n\n'
      'Just ask me anything — no question is too simple! 😊';

  /// Suggested prompts for new users
  static const List<String> suggestions = [
    '✨ What\'s my body type (Dosha)?',
    '🌿 A natural remedy for cold & cough',
    '😴 How can I sleep better?',
    '🍵 A simple detox tea recipe',
    '🧘 Quick morning routine for energy',
    '🍲 What should I eat for better digestion?',
  ];

  /// Build the system instruction with user context
  String _buildSystemInstruction() {
    final buffer = StringBuffer();
    buffer.writeln(_ayurvedaSystemPrompt);

    if (_userDosha != null && _userDosha.isNotEmpty) {
      buffer.writeln();
      buffer.writeln('## USER CONTEXT');
      buffer.writeln('The user\'s Prakriti (constitution) is: **$_userDosha**');
      buffer.writeln(
          'Personalize your advice for this dosha type when relevant.');
    }

    return buffer.toString();
  }

  /// Build structured conversation history as ChatTurns
  List<ChatTurn> _buildConversationTurns(
      String userMessage, List<ChatMessage> history) {
    final turns = <ChatTurn>[];

    // Add recent conversation history (last 10 messages)
    final recentHistory =
        history.length > 10 ? history.sublist(history.length - 10) : history;

    for (final msg in recentHistory) {
      turns.add(ChatTurn(
        role: msg.role == ChatRole.user ? 'user' : 'model',
        text: msg.content,
      ));
    }

    // Add current user message
    turns.add(ChatTurn(role: 'user', text: userMessage));

    return turns;
  }

  /// Generate an AI response based on the query
  Future<String> getResponse(String query, List<ChatMessage> history) async {
    final systemInstruction = _buildSystemInstruction();
    final turns = _buildConversationTurns(query, history);

    final response = await _geminiService.sendChat(
      systemInstruction: systemInstruction,
      conversationHistory: turns,
    );

    if (response.isError) {
      return _getFallbackResponse(query);
    }

    return response.text;
  }

  /// Fallback response when API fails
  String _getFallbackResponse(String query) {
    final lowerQuery = query.toLowerCase();

    if (lowerQuery.contains('dosha')) {
      return '🙏 Great question! In Ayurveda, everyone has a unique body type called a **Dosha**. There are three main types:\n\n'
          '✨ **Vata** — If you\'re creative, energetic, but sometimes feel anxious or have dry skin\n'
          '🔥 **Pitta** — If you\'re ambitious, focused, but sometimes feel overheated or irritable\n'
          '🌊 **Kapha** — If you\'re calm, steady, but sometimes feel sluggish or heavy\n\n'
          'Most people are a mix of two! Would you like to take our **Dosha Quiz** to find out yours? It only takes a minute! 😊';
    } else if (lowerQuery.contains('immunity') ||
        lowerQuery.contains('immune')) {
      return '🌿 Here are some **easy, natural ways** to boost your immunity:\n\n'
          '🍵 **Tulsi Tea** — Boil 4-5 fresh Tulsi leaves in water. Drink warm with honey.\n'
          '🍋 **Amla (Indian Gooseberry)** — Nature\'s vitamin C! Have 1 tbsp amla juice with water every morning.\n'
          '🥛 **Golden Milk** — Warm milk + a pinch of turmeric + black pepper before bed.\n'
          '🍯 **Chyawanprash** — 1 teaspoon every morning with warm milk. It\'s like a multivitamin from nature!\n\n'
          '✨ **Quick Tip:** Even just adding fresh ginger and turmeric to your daily cooking makes a big difference!\n\n'
          'Want me to share a detailed immunity-boosting morning routine? 😊';
    } else if (lowerQuery.contains('stress') ||
        lowerQuery.contains('anxiety')) {
      return '🧘 I hear you — stress can really take a toll. Here are some **simple Ayurvedic ways** to feel calmer:\n\n'
          '🌿 **Ashwagandha** — Known as the "strength herb." Take ½ tsp powder with warm milk at night.\n'
          '🫁 **Deep Breathing (Nadi Shodhana)** — Breathe in through one nostril, out through the other. Just 5 minutes can calm your mind.\n'
          '💆 **Warm Oil Massage** — Gently massage warm sesame oil on your feet before bed. It\'s incredibly soothing!\n'
          '🍵 **Brahmi Tea** — Helps settle racing thoughts.\n\n'
          '✨ **Try this tonight:** Warm foot massage + slow breathing + no screens for 30 min before bed.\n\n'
          'Would you like a step-by-step evening relaxation routine? 🌙';
    } else if (lowerQuery.contains('sleep') ||
        lowerQuery.contains('insomnia')) {
      return '🌙 A good night\'s sleep makes everything better! Here\'s what Ayurveda suggests:\n\n'
          '🥛 **Sleep Milk Recipe:**\n'
          '   Warm milk + ½ tsp Ashwagandha + a pinch of nutmeg + a little honey\n'
          '   Drink this 30 minutes before bed — it works wonders!\n\n'
          '💆 **Foot Massage** — Rub warm sesame or coconut oil on the soles of your feet. This signals your body to relax.\n\n'
          '🕙 **Sleep by 10 PM** — In Ayurveda, 10 PM to 2 AM is the body\'s natural repair time.\n\n'
          '🍽️ **Light Dinner** — Eat something warm and easy to digest, at least 2-3 hours before bed.\n\n'
          '✨ **Avoid:** Heavy food, caffeine after 3 PM, and bright screens before bed.\n\n'
          'Want me to create a personalized bedtime routine for you? 😊';
    } else if (lowerQuery.contains('headache') ||
        lowerQuery.contains('head pain')) {
      return '😔 Sorry to hear about your headache! Here are some quick natural remedies:\n\n'
          '🌿 **Peppermint or Eucalyptus Oil** — Dab a drop on your temples and gently massage.\n'
          '💧 **Stay Hydrated** — Dehydration is a common cause. Drink warm water with a squeeze of lemon.\n'
          '🧘 **Slow Deep Breaths** — 10 slow breaths can ease tension headaches.\n'
          '🍵 **Ginger Tea** — Boil fresh ginger in water for 5 min. Sip slowly.\n\n'
          '⚠️ If headaches are frequent or severe, please do consult a doctor.\n\n'
          'Feeling better? Let me know if you\'d like more tips! 💛';
    } else if (lowerQuery.contains('digest') ||
        lowerQuery.contains('stomach') ||
        lowerQuery.contains('acidity') ||
        lowerQuery.contains('bloating')) {
      return '🍲 Digestive issues are so common — let\'s sort that out with some easy tips!\n\n'
          '🍵 **Cumin-Coriander-Fennel Tea (CCF Tea)** — Mix equal parts, boil in water, sip after meals. This is a classic Ayurvedic digestive tonic!\n'
          '🫚 **Ginger Slice** — Chew a thin slice of fresh ginger with a pinch of salt before meals to fire up digestion.\n'
          '🍯 **Warm Lemon Water** — First thing in the morning on an empty stomach.\n'
          '🚫 **Avoid** — Ice-cold drinks with meals, overeating, and eating when stressed.\n\n'
          '✨ **Golden Rule:** Eat your biggest meal at lunch when your digestive fire is strongest!\n\n'
          'Want me to suggest a dosha-specific diet plan? 😊';
    }

    return '🙏 Thanks for reaching out! I\'m having a little trouble connecting right now, but I\'m still here to help!\n\n'
        'In the meantime, here are some things you can ask me about:\n\n'
        '✨ "What\'s my body type?"\n'
        '🌿 "A home remedy for cold"\n'
        '🍵 "A healthy tea recipe"\n'
        '😴 "How to sleep better"\n\n'
        'Try again in a moment — I\'ll be ready! 💚';
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

  ChatNotifier(this._chatService, this._historyNotifier)
      : super(const ChatState()) {
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
