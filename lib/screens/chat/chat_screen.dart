import 'package:flutter/material.dart';
import '../../config/colors.dart';
import '../../config/design_tokens.dart';
import '../../data/models/chat_message.dart';
import 'package:uuid/uuid.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _textController = TextEditingController();
  final _scrollController = ScrollController();
  final List<ChatMessage> _messages = [];
  bool _isTyping = false;

  final List<String> _suggestions = [
    'What is my dosha type?',
    'Best herbs for immunity',
    'How to reduce stress naturally?',
    'Ayurvedic diet tips',
    'Herbs for better sleep',
  ];

  @override
  void initState() {
    super.initState();
    _addWelcomeMessage();
  }

  void _addWelcomeMessage() {
    _messages.add(
      ChatMessage(
        id: const Uuid().v4(),
        role: ChatRole.assistant,
        content:
            '🙏 Namaste! I\'m AyurBot, your Ayurvedic wellness assistant.\n\nI can help you with:\n• Understanding your dosha\n• Finding remedies for ailments\n• Learning about herbs and plants\n• Diet and lifestyle guidance\n\nHow can I assist you today?',
        timestamp: DateTime.now(),
      ),
    );
  }

  void _sendMessage(String text) {
    if (text.trim().isEmpty) return;

    setState(() {
      _messages.add(
        ChatMessage(
          id: const Uuid().v4(),
          role: ChatRole.user,
          content: text,
          timestamp: DateTime.now(),
        ),
      );
      _isTyping = true;
    });

    _textController.clear();
    _scrollToBottom();

    // Simulate AI response
    Future.delayed(const Duration(milliseconds: 1500), () {
      setState(() {
        _isTyping = false;
        _messages.add(
          ChatMessage(
            id: const Uuid().v4(),
            role: ChatRole.assistant,
            content: _getAIResponse(text),
            timestamp: DateTime.now(),
          ),
        );
      });
      _scrollToBottom();
    });
  }

  String _getAIResponse(String query) {
    final lowerQuery = query.toLowerCase();

    if (lowerQuery.contains('dosha')) {
      return 'In Ayurveda, there are three doshas: Vata (air + space), Pitta (fire + water), and Kapha (earth + water). Your unique combination determines your constitution.\n\nWould you like to take our dosha quiz to discover your type? 🌿';
    } else if (lowerQuery.contains('immunity') ||
        lowerQuery.contains('immune')) {
      return 'For boosting immunity, Ayurveda recommends:\n\n🌿 **Giloy (Guduchi)** - Known as "divine nectar"\n🌿 **Tulsi** - Sacred basil with antimicrobial properties\n🌿 **Amla** - Rich in Vitamin C\n🌿 **Ashwagandha** - Adaptogenic stress reliever\n\nWould you like to know more about any of these herbs?';
    } else if (lowerQuery.contains('stress') ||
        lowerQuery.contains('anxiety')) {
      return 'Ayurveda offers wonderful stress relief solutions:\n\n🧘 **Brahmi** - Calms the mind\n🧘 **Ashwagandha** - Reduces cortisol\n🧘 **Jatamansi** - Promotes restful sleep\n\n**Daily practices:**\n• Abhyanga (oil massage)\n• Pranayama (breathing exercises)\n• Meditation for 10-15 minutes\n\nWhich approach interests you most?';
    } else if (lowerQuery.contains('sleep')) {
      return 'For better sleep, Ayurveda suggests:\n\n🌙 **Herbs:**\n• Ashwagandha with warm milk\n• Brahmi tea before bed\n• Jatamansi for deep rest\n\n🌙 **Practices:**\n• Avoid screens 1 hour before bed\n• Warm foot massage with sesame oil\n• Go to sleep by 10 PM\n\nShall I share a specific sleep remedy?';
    } else {
      return 'Thank you for your question! Based on Ayurvedic principles, maintaining balance in your daily routine (Dinacharya) is essential.\n\nWould you like me to:\n1. Suggest specific herbs for your concern\n2. Recommend lifestyle practices\n3. Share relevant remedies\n\nPlease let me know how I can help further! 🙏';
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.smart_toy,
                color: AppColors.primary,
                size: 20,
              ),
            ),
            const SizedBox(width: DesignTokens.spacingSm),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('AyurBot'),
                Text(
                  _isTyping ? 'typing...' : 'Online',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.success,
                      ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          // Messages
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(DesignTokens.spacingMd),
              itemCount: _messages.length + (_isTyping ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == _messages.length && _isTyping) {
                  return _TypingIndicator();
                }
                return _MessageBubble(message: _messages[index]);
              },
            ),
          ),

          // Suggestions
          if (_messages.length <= 2)
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(
                horizontal: DesignTokens.spacingMd,
              ),
              child: Row(
                children: _suggestions
                    .map((s) => Padding(
                          padding: const EdgeInsets.only(
                              right: DesignTokens.spacingXs),
                          child: ActionChip(
                            label: Text(s),
                            onPressed: () => _sendMessage(s),
                          ),
                        ))
                    .toList(),
              ),
            ),
          const SizedBox(height: DesignTokens.spacingXs),

          // Input
          Container(
            padding: const EdgeInsets.all(DesignTokens.spacingMd),
            decoration: const BoxDecoration(
              color: AppColors.surface,
              boxShadow: [
                BoxShadow(
                  color: AppColors.shadow,
                  blurRadius: DesignTokens.shadowBlurSm,
                  offset: Offset(0, -2),
                ),
              ],
            ),
            child: SafeArea(
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _textController,
                      decoration: const InputDecoration(
                        hintText: 'Ask me about Ayurveda...',
                        border: InputBorder.none,
                      ),
                      maxLines: null,
                      textInputAction: TextInputAction.send,
                      onSubmitted: _sendMessage,
                    ),
                  ),
                  const SizedBox(width: DesignTokens.spacingXs),
                  IconButton(
                    onPressed: () => _sendMessage(_textController.text),
                    icon: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: const BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.send,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  final ChatMessage message;

  const _MessageBubble({required this.message});

  @override
  Widget build(BuildContext context) {
    final isUser = message.role == ChatRole.user;

    return Padding(
      padding: const EdgeInsets.only(bottom: DesignTokens.spacingSm),
      child: Row(
        mainAxisAlignment:
            isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isUser) ...[
            CircleAvatar(
              radius: 16,
              backgroundColor: AppColors.primary.withValues(alpha: 0.1),
              child: const Icon(
                Icons.smart_toy,
                color: AppColors.primary,
                size: 16,
              ),
            ),
            const SizedBox(width: DesignTokens.spacingXs),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.all(DesignTokens.spacingSm),
              decoration: BoxDecoration(
                color: isUser ? AppColors.primary : AppColors.surface,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(DesignTokens.radiusMd),
                  topRight: const Radius.circular(DesignTokens.radiusMd),
                  bottomLeft: Radius.circular(
                      isUser ? DesignTokens.radiusMd : DesignTokens.radiusXs),
                  bottomRight: Radius.circular(
                      isUser ? DesignTokens.radiusXs : DesignTokens.radiusMd),
                ),
                boxShadow: const [
                  BoxShadow(
                    color: AppColors.shadow,
                    blurRadius: DesignTokens.shadowBlurSm,
                    offset: Offset(0, 1),
                  ),
                ],
              ),
              child: Text(
                message.content,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: isUser ? Colors.white : AppColors.textPrimary,
                    ),
              ),
            ),
          ),
          if (isUser) const SizedBox(width: DesignTokens.spacingXs),
        ],
      ),
    );
  }
}

class _TypingIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: DesignTokens.spacingSm),
      child: Row(
        children: [
          CircleAvatar(
            radius: 16,
            backgroundColor: AppColors.primary.withValues(alpha: 0.1),
            child: const Icon(
              Icons.smart_toy,
              color: AppColors.primary,
              size: 16,
            ),
          ),
          const SizedBox(width: DesignTokens.spacingXs),
          Container(
            padding: const EdgeInsets.all(DesignTokens.spacingSm),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(DesignTokens.radiusMd),
            ),
            child: Row(
              children: List.generate(
                3,
                (i) => Container(
                  margin: const EdgeInsets.symmetric(horizontal: 2),
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: AppColors.textTertiary.withValues(alpha: 0.5),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Fix: MainAxisAlignment_start should be MainAxisAlignment.start
extension on MainAxisAlignment {
  // ignore, this is autocomplete artifact
}
