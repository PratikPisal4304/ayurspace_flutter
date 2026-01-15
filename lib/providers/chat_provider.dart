import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../data/models/chat_message.dart';

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

/// Service for generating AI responses
/// This can be replaced with actual API calls in the future
class ChatService {
  static const _uuid = Uuid();

  /// Welcome message content
  static const String welcomeMessage =
      '🙏 Namaste! I\'m AyurBot, your Ayurvedic wellness assistant.\n\n'
      'I can help you with:\n'
      '• Understanding your dosha\n'
      '• Finding remedies for ailments\n'
      '• Learning about herbs and plants\n'
      '• Diet and lifestyle guidance\n\n'
      'How can I assist you today?';

  /// Suggested prompts for new users
  static const List<String> suggestions = [
    'What is my dosha type?',
    'Best herbs for immunity',
    'How to reduce stress naturally?',
    'Ayurvedic diet tips',
    'Herbs for better sleep',
  ];

  /// Generate an AI response based on the query
  Future<String> getResponse(String query) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 1200));

    final lowerQuery = query.toLowerCase();

    if (lowerQuery.contains('dosha')) {
      return 'In Ayurveda, there are three doshas: Vata (air + space), '
          'Pitta (fire + water), and Kapha (earth + water). Your unique '
          'combination determines your constitution.\n\n'
          'Would you like to take our dosha quiz to discover your type? 🌿';
    } else if (lowerQuery.contains('immunity') ||
        lowerQuery.contains('immune')) {
      return 'For boosting immunity, Ayurveda recommends:\n\n'
          '🌿 **Giloy (Guduchi)** - Known as "divine nectar"\n'
          '🌿 **Tulsi** - Sacred basil with antimicrobial properties\n'
          '🌿 **Amla** - Rich in Vitamin C\n'
          '🌿 **Ashwagandha** - Adaptogenic stress reliever\n\n'
          'Would you like to know more about any of these herbs?';
    } else if (lowerQuery.contains('stress') ||
        lowerQuery.contains('anxiety')) {
      return 'Ayurveda offers wonderful stress relief solutions:\n\n'
          '🧘 **Brahmi** - Calms the mind\n'
          '🧘 **Ashwagandha** - Reduces cortisol\n'
          '🧘 **Jatamansi** - Promotes restful sleep\n\n'
          '**Daily practices:**\n'
          '• Abhyanga (oil massage)\n'
          '• Pranayama (breathing exercises)\n'
          '• Meditation for 10-15 minutes\n\n'
          'Which approach interests you most?';
    } else if (lowerQuery.contains('sleep')) {
      return 'For better sleep, Ayurveda suggests:\n\n'
          '🌙 **Herbs:**\n'
          '• Ashwagandha with warm milk\n'
          '• Brahmi tea before bed\n'
          '• Jatamansi for deep rest\n\n'
          '🌙 **Practices:**\n'
          '• Avoid screens 1 hour before bed\n'
          '• Warm foot massage with sesame oil\n'
          '• Go to sleep by 10 PM\n\n'
          'Shall I share a specific sleep remedy?';
    } else if (lowerQuery.contains('diet') || lowerQuery.contains('food')) {
      return 'Ayurvedic diet principles:\n\n'
          '🍲 **Eat according to your dosha:**\n'
          '• Vata: Warm, moist, grounding foods\n'
          '• Pitta: Cool, refreshing foods\n'
          '• Kapha: Light, warming, spicy foods\n\n'
          '**General tips:**\n'
          '• Eat your largest meal at noon\n'
          '• Include all six tastes daily\n'
          '• Avoid cold water with meals\n\n'
          'Would you like specific dietary recommendations?';
    } else {
      return 'Thank you for your question! Based on Ayurvedic principles, '
          'maintaining balance in your daily routine (Dinacharya) is essential.\n\n'
          'Would you like me to:\n'
          '1. Suggest specific herbs for your concern\n'
          '2. Recommend lifestyle practices\n'
          '3. Share relevant remedies\n\n'
          'Please let me know how I can help further! 🙏';
    }
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
  static const _uuid = Uuid();

  ChatNotifier(this._chatService) : super(const ChatState()) {
    _addWelcomeMessage();
  }

  /// Add the welcome message
  void _addWelcomeMessage() {
    final welcomeMessage = ChatMessage(
      id: _uuid.v4(),
      role: ChatRole.assistant,
      content: ChatService.welcomeMessage,
      timestamp: DateTime.now(),
    );

    state = state.copyWith(messages: [welcomeMessage]);
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

    state = state.copyWith(
      messages: [...state.messages, userMessage],
      isTyping: true,
      clearError: true,
    );

    try {
      // Get AI response
      final response = await _chatService.getResponse(text);

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
    } catch (e) {
      state = state.copyWith(
        isTyping: false,
        error: 'Failed to get response. Please try again.',
      );
    }
  }

  /// Clear all messages and start fresh
  void clearChat() {
    state = const ChatState();
    _addWelcomeMessage();
  }

  /// Dismiss error
  void dismissError() {
    state = state.copyWith(clearError: true);
  }
}

/// Provider for ChatService
final chatServiceProvider = Provider<ChatService>((ref) {
  return ChatService();
});

/// Provider for Chat
final chatProvider = StateNotifierProvider<ChatNotifier, ChatState>((ref) {
  return ChatNotifier(ref.watch(chatServiceProvider));
});

/// Provider for checking if chat has messages beyond welcome
final hasActiveConversationProvider = Provider<bool>((ref) {
  return ref.watch(chatProvider).messages.length > 1;
});

/// Provider for suggestions (only show when conversation is short)
final showSuggestionsProvider = Provider<bool>((ref) {
  return ref.watch(chatProvider).messages.length <= 2;
});
