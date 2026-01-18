import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:ayurspace_flutter/providers/chat_provider.dart';
import 'package:ayurspace_flutter/data/models/chat_message.dart';

// --- Fakes ---

class MockChatService extends Fake implements ChatService {
  bool shouldThrow = false;
  
  @override
  Future<String> getResponse(String query, List<ChatMessage> history) async {
    if (shouldThrow) {
      throw Exception('Network Error');
    }
    return 'Detailed response for $query';
  }
}

void main() {
  late ProviderContainer container;
  late MockChatService mockChatService;

  setUp(() {
    mockChatService = MockChatService();
    container = ProviderContainer(
      overrides: [
        chatServiceProvider.overrideWithValue(mockChatService),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  group('ChatNotifier Tests', () {
    test('Initial state has welcome message', () {
      final state = container.read(chatProvider);
      
      expect(state.messages.length, 1);
      expect(state.messages.first.role, ChatRole.assistant);
      expect(state.messages.first.content, contains('Namaste'));
      expect(state.isTyping, false);
    });

    test('sendMessage adds user message and gets response', () async {
      final notifier = container.read(chatProvider.notifier);
      
      final future = notifier.sendMessage('Hello');
      
      // Immediately check typing state
      expect(container.read(chatProvider).isTyping, true);
      expect(container.read(chatProvider).messages.last.role, ChatRole.user);
      
      await future;
      
      final state = container.read(chatProvider);
      expect(state.isTyping, false);
      expect(state.messages.length, 3); // Welcome + User + Response
      expect(state.messages.last.role, ChatRole.assistant);
      expect(state.messages.last.content, 'Detailed response for Hello');
    });

    test('sendMessage handles empty text', () async {
      final notifier = container.read(chatProvider.notifier);
      int initialCount = container.read(chatProvider).messages.length;
      
      await notifier.sendMessage('   ');
      
      expect(container.read(chatProvider).messages.length, initialCount);
    });

    test('sendMessage handles error', () async {
      mockChatService.shouldThrow = true;
      final notifier = container.read(chatProvider.notifier);
      
      await notifier.sendMessage('Error trigger');
      
      final state = container.read(chatProvider);
      expect(state.isTyping, false);
      expect(state.error, isNotNull);
      // Messages should contain user message but not assistant response (except welcome)
      // Welcome(1) + User(1) = 2
      expect(state.messages.length, 2);
    });

    test('clearChat resets state', () async {
      final notifier = container.read(chatProvider.notifier);
      await notifier.sendMessage('Test');
      
      notifier.clearChat();
      
      final state = container.read(chatProvider);
      expect(state.messages.length, 1); // Only welcome
      expect(state.messages.first.content, contains('Namaste'));
    });
  });
}
