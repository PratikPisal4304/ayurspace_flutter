import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import '../data/models/chat_message.dart';

/// A single chat session
class ChatSession {
  final String id;
  final String title;
  final List<ChatMessage> messages;
  final DateTime createdAt;
  final DateTime updatedAt;

  const ChatSession({
    required this.id,
    required this.title,
    required this.messages,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Get preview text from last message
  String get preview {
    if (messages.isEmpty) return 'New conversation';
    final lastMsg = messages.last;
    final text = lastMsg.content;
    return text.length > 60 ? '${text.substring(0, 60)}...' : text;
  }

  /// Create a copy with updated fields
  ChatSession copyWith({
    String? id,
    String? title,
    List<ChatMessage>? messages,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ChatSession(
      id: id ?? this.id,
      title: title ?? this.title,
      messages: messages ?? this.messages,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  /// Convert to JSON for persistence
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'messages': messages.map((m) => m.toJson()).toList(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  /// Create from JSON
  factory ChatSession.fromJson(Map<String, dynamic> json) {
    return ChatSession(
      id: json['id'] as String,
      title: json['title'] as String,
      messages: (json['messages'] as List)
          .map((m) => ChatMessage.fromJson(m as Map<String, dynamic>))
          .toList(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }
}

/// State for chat history
class ChatHistoryState {
  final List<ChatSession> sessions;
  final String? activeSessionId;
  final bool isLoading;

  const ChatHistoryState({
    this.sessions = const [],
    this.activeSessionId,
    this.isLoading = false,
  });

  /// Get active session
  ChatSession? get activeSession {
    if (activeSessionId == null) return null;
    return sessions.firstWhere(
      (s) => s.id == activeSessionId,
      orElse: () => sessions.first,
    );
  }

  /// Get sessions sorted by updatedAt (newest first)
  List<ChatSession> get sortedSessions {
    final sorted = List<ChatSession>.from(sessions);
    sorted.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
    return sorted;
  }

  ChatHistoryState copyWith({
    List<ChatSession>? sessions,
    String? activeSessionId,
    bool? isLoading,
    bool clearActiveSession = false,
  }) {
    return ChatHistoryState(
      sessions: sessions ?? this.sessions,
      activeSessionId:
          clearActiveSession ? null : (activeSessionId ?? this.activeSessionId),
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

/// Chat history notifier with persistence
class ChatHistoryNotifier extends StateNotifier<ChatHistoryState> {
  static const _storageKey = 'chat_history';
  static const _uuid = Uuid();

  ChatHistoryNotifier() : super(const ChatHistoryState(isLoading: true)) {
    _loadHistory();
  }

  /// Load history from local storage
  Future<void> _loadHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString(_storageKey);

      if (jsonString != null) {
        final List<dynamic> jsonList = jsonDecode(jsonString);
        final sessions = jsonList
            .map((json) => ChatSession.fromJson(json as Map<String, dynamic>))
            .toList();

        state = state.copyWith(
          sessions: sessions,
          activeSessionId: sessions.isNotEmpty ? sessions.first.id : null,
          isLoading: false,
        );
      } else {
        // Create initial session if none exists
        await createNewSession();
      }
    } catch (e) {
      // If loading fails, start fresh
      await createNewSession();
    }
  }

  /// Save history to local storage
  Future<void> _saveHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonList = state.sessions.map((s) => s.toJson()).toList();
      await prefs.setString(_storageKey, jsonEncode(jsonList));
    } catch (e) {
      // Silent fail for persistence
    }
  }

  /// Create a new chat session
  Future<String> createNewSession() async {
    final sessionId = _uuid.v4();
    final now = DateTime.now();

    final welcomeMessage = ChatMessage(
      id: _uuid.v4(),
      role: ChatRole.assistant,
      content:
          '🙏 Namaste! I am **AyurBot**, your Ayurvedic wellness guide.\n\n'
          'I have deep knowledge of the 5,000-year-old science of Ayurveda and can help you with:\n\n'
          '🌿 **Herbs & Remedies** - Tulsi, Ashwagandha, Triphala & 100+ more\n'
          '⚖️ **Dosha Balancing** - Vata, Pitta, Kapha analysis\n'
          '🍲 **Diet & Nutrition** - Dosha-specific food guidance\n'
          '🧘 **Yoga & Lifestyle** - Pranayama, meditation, daily routines\n'
          '💊 **Natural Treatments** - Traditional remedies for common ailments\n\n'
          'How may I assist your wellness journey today?',
      timestamp: now,
    );

    final newSession = ChatSession(
      id: sessionId,
      title: 'New Chat',
      messages: [welcomeMessage],
      createdAt: now,
      updatedAt: now,
    );

    state = state.copyWith(
      sessions: [newSession, ...state.sessions],
      activeSessionId: sessionId,
      isLoading: false,
    );

    await _saveHistory();
    return sessionId;
  }

  /// Switch to a different session
  void switchSession(String sessionId) {
    if (state.sessions.any((s) => s.id == sessionId)) {
      state = state.copyWith(activeSessionId: sessionId);
    }
  }

  /// Add a message to the active session
  Future<void> addMessage(ChatMessage message) async {
    if (state.activeSessionId == null) return;

    final updatedSessions = state.sessions.map((session) {
      if (session.id == state.activeSessionId) {
        // Update title if this is the first user message
        String newTitle = session.title;
        if (message.role == ChatRole.user &&
            session.messages.where((m) => m.role == ChatRole.user).isEmpty) {
          // Use first user message as title
          newTitle = message.content.length > 40
              ? '${message.content.substring(0, 40)}...'
              : message.content;
        }

        return session.copyWith(
          title: newTitle,
          messages: [...session.messages, message],
          updatedAt: DateTime.now(),
        );
      }
      return session;
    }).toList();

    state = state.copyWith(sessions: updatedSessions);
    await _saveHistory();
  }

  /// Get messages for active session
  List<ChatMessage> get activeMessages {
    return state.activeSession?.messages ?? [];
  }

  /// Delete a session
  Future<void> deleteSession(String sessionId) async {
    final updatedSessions =
        state.sessions.where((s) => s.id != sessionId).toList();

    String? newActiveId = state.activeSessionId;
    if (state.activeSessionId == sessionId) {
      newActiveId =
          updatedSessions.isNotEmpty ? updatedSessions.first.id : null;
    }

    state = state.copyWith(
      sessions: updatedSessions,
      activeSessionId: newActiveId,
    );

    // Create new session if all were deleted
    if (updatedSessions.isEmpty) {
      await createNewSession();
    } else {
      await _saveHistory();
    }
  }

  /// Clear all history
  Future<void> clearAllHistory() async {
    state = const ChatHistoryState(sessions: []);
    await createNewSession();
  }
}

/// Provider for chat history
final chatHistoryProvider =
    StateNotifierProvider<ChatHistoryNotifier, ChatHistoryState>((ref) {
  return ChatHistoryNotifier();
});

/// Provider for active session messages
final activeMessagesProvider = Provider<List<ChatMessage>>((ref) {
  return ref.watch(chatHistoryProvider).activeSession?.messages ?? [];
});

/// Provider for sorted sessions (for history drawer)
final chatSessionsProvider = Provider<List<ChatSession>>((ref) {
  return ref.watch(chatHistoryProvider).sortedSessions;
});
