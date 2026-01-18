import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:go_router/go_router.dart';
import '../../config/colors.dart';
import '../../config/design_tokens.dart';
import '../../data/models/chat_message.dart';
import '../../providers/chat_provider.dart';
import '../../providers/chat_history_provider.dart';

/// Premium AyurBot Chat Screen - Full screen with history drawer
class ChatScreen extends ConsumerStatefulWidget {
  const ChatScreen({super.key});

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final _textController = TextEditingController();
  final _scrollController = ScrollController();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _focusNode = FocusNode();

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    _focusNode.dispose();
    super.dispose();
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

  void _handleSend() {
    final text = _textController.text;
    if (text.trim().isEmpty) return;

    // Haptic feedback
    HapticFeedback.lightImpact();
    
    ref.read(chatProvider.notifier).sendMessage(text);
    _textController.clear();
    _scrollToBottom();
    // Keep focus for continuous messaging
    _focusNode.requestFocus();
  }

  void _handleSuggestionTap(String suggestion) {
    ref.read(chatProvider.notifier).sendMessage(suggestion);
    _scrollToBottom();
  }

  void _openHistoryDrawer() {
    _scaffoldKey.currentState?.openEndDrawer();
  }

  void _clearChat() {
    // Confirm if there's an active conversation
    final messages = ref.read(chatProvider).messages;
    if (messages.length > 1) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Start New Chat?'),
          content: const Text('This will clear the current conversation.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
                ref.read(chatProvider.notifier).clearChat();
              },
              style: TextButton.styleFrom(foregroundColor: AppColors.primary),
              child: const Text('New Chat'),
            ),
          ],
        ),
      );
    } else {
      ref.read(chatProvider.notifier).clearChat();
    }
  }

  @override
  Widget build(BuildContext context) {
    final chatState = ref.watch(chatProvider);
    final historyState = ref.watch(chatHistoryProvider);
    final showSuggestions = ref.watch(showSuggestionsProvider);

    // Auto-scroll when messages change
    ref.listen<ChatState>(chatProvider, (previous, next) {
      if ((previous?.messages.length ?? 0) != next.messages.length) {
        _scrollToBottom();
      }
      // Show error snackbar
      if (next.error != null && previous?.error == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.error!),
            backgroundColor: AppColors.error,
            action: SnackBarAction(
              label: 'Dismiss',
              textColor: Colors.white,
              onPressed: () => ref.read(chatProvider.notifier).dismissError(),
            ),
          ),
        );
      }
    });

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppColors.background,
      resizeToAvoidBottomInset: false, // Critical: We handle bottom insets manually
      endDrawer: _ChatHistoryDrawer(
        onNewChat: () {
          Navigator.pop(context);
          _clearChat();
        },
      ),
      body: Column(
        children: [
          // Premium Header with back button and history
          AnnotatedRegion<SystemUiOverlayStyle>(
            value: SystemUiOverlayStyle.dark, // Force dark status bar icons
            child: SafeArea(
              bottom: false,
              child: _ChatHeader(
              isTyping: chatState.isTyping,
              onBack: () {
                if (context.canPop()) {
                  context.pop();
                } else {
                  context.go('/home');
                }
              },
                onHistory: _openHistoryDrawer,
                onClear: _clearChat,
              ),
            ),
          ),
            
            // Chat Messages or Loading
            Expanded(
              child: historyState.isLoading
                  ? const Center(
                      child: CircularProgressIndicator(color: AppColors.primary),
                    )
                  : _ChatMessageList(
                      messages: chatState.messages,
                      isTyping: chatState.isTyping,
                      scrollController: _scrollController,
                    ),
            ),

            // Suggestions (visible only at start)
            if (showSuggestions)
              _SuggestionChips(
                suggestions: ChatService.suggestions,
                onTap: _handleSuggestionTap,
              ),

          // Input Area
          // Remove wrapper SafeArea completely to check raw positioning
          // If this fixes it, we add a manual small padding later
          _ChatInputBar(
            controller: _textController,
            focusNode: _focusNode,
            onSend: _handleSend,
            isTyping: chatState.isTyping,
          ),
          // Add small manual padding (12px) + keyboard height
          SizedBox(
            height: MediaQuery.of(context).viewInsets.bottom + 12.0,
          ),
        ],
      ),
    );
  }
}

/// Premium App Bar Header with back button and history
class _ChatHeader extends StatelessWidget {
  final bool isTyping;
  final VoidCallback onBack;
  final VoidCallback onHistory;
  final VoidCallback onClear;
  
  const _ChatHeader({
    required this.isTyping,
    required this.onBack,
    required this.onHistory,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: DesignTokens.spacingMd,
        vertical: DesignTokens.spacingMd, // Increased for better breathing room
      ),
      child: Row(
        children: [
          // Back button
          IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, size: 20),
            color: AppColors.textPrimary,
            onPressed: onBack,
          ),
          
          // Avatar with gradient
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.primary, AppColors.neemGreen],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(DesignTokens.radiusSm),
            ),
            child: const Icon(
              Icons.spa,
              color: Colors.white,
              size: 22,
            ),
          ),
          const SizedBox(width: DesignTokens.spacingSm),
          
          // Title and status
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'AyurBot',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: isTyping ? AppColors.saffron : AppColors.success,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      isTyping ? 'Thinking...' : 'Ayurveda Expert',
                      style: TextStyle(
                        fontSize: 12,
                        color: isTyping ? AppColors.saffron : AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          // New Chat button
          IconButton(
            icon: const Icon(Icons.add_comment_outlined, size: 22),
            color: AppColors.textSecondary,
            tooltip: 'New Chat',
            onPressed: onClear,
          ),
          
          // History button
          IconButton(
            icon: const Icon(Icons.history, size: 24),
            color: AppColors.primary,
            tooltip: 'Chat History',
            onPressed: onHistory,
          ),
        ],
      ),
    );
  }
}

/// Chat History Drawer - Uses real provider data
class _ChatHistoryDrawer extends ConsumerWidget {
  final VoidCallback onNewChat;

  const _ChatHistoryDrawer({required this.onNewChat});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sessions = ref.watch(chatSessionsProvider);
    final historyState = ref.watch(chatHistoryProvider);
    final activeSessionId = historyState.activeSessionId;

    return Drawer(
      width: MediaQuery.of(context).size.width * 0.85,
      child: Container(
        color: AppColors.background,
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Container(
                padding: const EdgeInsets.all(DesignTokens.spacingMd),
                decoration: const BoxDecoration(
                  color: AppColors.surface,
                  border: Border(
                    bottom: BorderSide(color: AppColors.border, width: 1),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [AppColors.primary, AppColors.neemGreen],
                        ),
                        borderRadius: BorderRadius.circular(DesignTokens.radiusSm),
                      ),
                      child: const Icon(Icons.history, color: Colors.white, size: 22),
                    ),
                    const SizedBox(width: DesignTokens.spacingSm),
                    const Expanded(
                      child: Text(
                        'Chat History',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      color: AppColors.textSecondary,
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),

              // New Chat Button
              Padding(
                padding: const EdgeInsets.all(DesignTokens.spacingMd),
                child: Material(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(DesignTokens.radiusMd),
                  child: InkWell(
                    onTap: onNewChat,
                    borderRadius: BorderRadius.circular(DesignTokens.radiusMd),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: DesignTokens.spacingSm),
                      alignment: Alignment.center,
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.add, color: Colors.white, size: 20),
                          SizedBox(width: 8),
                          Text(
                            'Start New Chat',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // History Label
              const Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: DesignTokens.spacingMd,
                  vertical: DesignTokens.spacingXs,
                ),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Recent Conversations',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              ),

              // History List
              Expanded(
                child: sessions.isEmpty
                    ? const Center(
                        child: Text(
                          'No conversations yet',
                          style: TextStyle(color: AppColors.textTertiary),
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: DesignTokens.spacingSm),
                        itemCount: sessions.length,
                        itemBuilder: (context, index) {
                          final session = sessions[index];
                          final isActive = session.id == activeSessionId;
                          return _HistoryListTile(
                            session: session,
                            isActive: isActive,
                            onTap: () {
                              ref.read(chatProvider.notifier).switchSession(session.id);
                              Navigator.pop(context);
                            },
                            onDelete: () {
                              ref.read(chatProvider.notifier).deleteSession(session.id);
                            },
                          );
                        },
                      ),
              ),

              // Clear All button (only show if there are sessions)
              if (sessions.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: DesignTokens.spacingMd),
                  child: TextButton.icon(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: const Text('Clear All History'),
                          content: const Text('This will delete all your chat conversations. This action cannot be undone.'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(ctx),
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () {
                                ref.read(chatHistoryProvider.notifier).clearAllHistory();
                                Navigator.pop(ctx);
                              },
                              style: TextButton.styleFrom(foregroundColor: AppColors.error),
                              child: const Text('Delete All'),
                            ),
                          ],
                        ),
                      );
                    },
                    icon: const Icon(Icons.delete_sweep_outlined, size: 18),
                    label: const Text('Clear All History'),
                    style: TextButton.styleFrom(
                      foregroundColor: AppColors.error,
                    ),
                  ),
                ),

              // Footer hint
              Container(
                padding: const EdgeInsets.all(DesignTokens.spacingMd),
                child: const Text(
                  'Swipe left on a chat to delete it',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textTertiary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// History list tile
class _HistoryListTile extends StatelessWidget {
  final ChatSession session;
  final bool isActive;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const _HistoryListTile({
    required this.session,
    required this.isActive,
    required this.onTap,
    required this.onDelete,
  });

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final diff = now.difference(time);
    
    if (diff.inMinutes < 1) {
      return 'Just now';
    } else if (diff.inMinutes < 60) {
      return '${diff.inMinutes}m ago';
    } else if (diff.inHours < 24) {
      return '${diff.inHours}h ago';
    } else if (diff.inDays < 7) {
      return '${diff.inDays}d ago';
    } else {
      return '${time.day}/${time.month}';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(session.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: DesignTokens.spacingMd),
        decoration: BoxDecoration(
          color: AppColors.error,
          borderRadius: BorderRadius.circular(DesignTokens.radiusMd),
        ),
        child: const Icon(Icons.delete_outline, color: Colors.white),
      ),
      onDismissed: (_) => onDelete(),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        decoration: BoxDecoration(
          color: isActive ? AppColors.primary.withValues(alpha: 0.08) : AppColors.surface,
          borderRadius: BorderRadius.circular(DesignTokens.radiusMd),
          border: Border.all(
            color: isActive ? AppColors.primary.withValues(alpha: 0.3) : AppColors.border.withValues(alpha: 0.5),
          ),
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: DesignTokens.spacingMd,
            vertical: DesignTokens.spacingXs,
          ),
          leading: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: isActive 
                  ? AppColors.primary.withValues(alpha: 0.2) 
                  : AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(DesignTokens.radiusSm),
            ),
            child: Icon(
              isActive ? Icons.chat : Icons.chat_bubble_outline, 
              color: AppColors.primary, 
              size: 20,
            ),
          ),
          title: Text(
            session.title,
            style: TextStyle(
              fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
              fontSize: 14,
              color: AppColors.textPrimary,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              session.preview,
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          trailing: Text(
            _formatTime(session.updatedAt),
            style: const TextStyle(
              fontSize: 11,
              color: AppColors.textTertiary,
            ),
          ),
          onTap: onTap,
        ),
      ),
    );
  }
}

/// Chat Message List
class _ChatMessageList extends StatelessWidget {
  final List<ChatMessage> messages;
  final bool isTyping;
  final ScrollController scrollController;

  const _ChatMessageList({
    required this.messages,
    required this.isTyping,
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    // Empty state
    if (messages.isEmpty && !isTyping) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.spa, size: 64, color: AppColors.textTertiary),
            SizedBox(height: 16),
            Text(
              'Start a conversation',
              style: TextStyle(color: AppColors.textSecondary, fontSize: 16),
            ),
          ],
        ),
      );
    }

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => FocusScope.of(context).unfocus(),
      child: ListView.builder(
        controller: scrollController,
        padding: const EdgeInsets.only(
          left: DesignTokens.spacingMd,
          right: DesignTokens.spacingMd,
          bottom: DesignTokens.spacingSm,
          top: DesignTokens.spacingMd, // Added top padding to separate from header
        ),
        itemCount: messages.length + (isTyping ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == messages.length && isTyping) {
            return const _TypingIndicator();
          }
          return _MessageBubble(message: messages[index]);
        },
      ),
    );
  }
}

/// Premium Message Bubble with timestamp
class _MessageBubble extends StatelessWidget {
  final ChatMessage message;

  const _MessageBubble({required this.message});

  String _formatMessageTime(DateTime time) {
    final hour = time.hour;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = hour >= 12 ? 'PM' : 'AM';
    final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
    return '$displayHour:$minute $period';
  }

  @override
  Widget build(BuildContext context) {
    final isUser = message.role == ChatRole.user;

    return Semantics(
      label: '${isUser ? "You" : "AyurBot"} said: ${message.content}',
      child: Padding(
        padding: const EdgeInsets.only(bottom: DesignTokens.spacingMd),
        child: Column(
          crossAxisAlignment: isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Bot avatar
                if (!isUser) ...[
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [AppColors.primary, AppColors.neemGreen],
                      ),
                      borderRadius: BorderRadius.circular(DesignTokens.radiusSm),
                    ),
                    child: const Icon(Icons.spa, color: Colors.white, size: 18),
                  ),
                  const SizedBox(width: DesignTokens.spacingXs),
                ],

                // Message bubble
                Flexible(
                  child: Container(
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.78,
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: DesignTokens.spacingMd,
                      vertical: DesignTokens.spacingSm,
                    ),
                    decoration: BoxDecoration(
                      color: isUser ? AppColors.primary : AppColors.surface,
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(DesignTokens.radiusMd),
                        topRight: const Radius.circular(DesignTokens.radiusMd),
                        bottomLeft: Radius.circular(isUser ? DesignTokens.radiusMd : 4),
                        bottomRight: Radius.circular(isUser ? 4 : DesignTokens.radiusMd),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: (isUser ? AppColors.primary : Colors.black).withValues(alpha: 0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: isUser
                        ? Text(
                            message.content,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              height: 1.4,
                            ),
                          )
                        : MarkdownBody(
                            data: message.content,
                            styleSheet: _buildMarkdownStyle(context),
                            shrinkWrap: true,
                            softLineBreak: true,
                          ),
                  ),
                ),

                // Spacer for user messages
                if (isUser) const SizedBox(width: 8),
              ],
            ),
            // Timestamp
            Padding(
              padding: EdgeInsets.only(
                top: 4,
                left: isUser ? 0 : 40,
                right: isUser ? 8 : 0,
              ),
              child: Text(
                _formatMessageTime(message.timestamp),
                style: const TextStyle(
                  fontSize: 10,
                  color: AppColors.textTertiary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  MarkdownStyleSheet _buildMarkdownStyle(BuildContext context) {
    return MarkdownStyleSheet(
      p: const TextStyle(
        color: AppColors.textPrimary,
        fontSize: 15,
        height: 1.5,
      ),
      strong: const TextStyle(
        color: AppColors.textPrimary,
        fontWeight: FontWeight.w600,
        fontSize: 15,
      ),
      h1: const TextStyle(
        color: AppColors.primary,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
      h2: const TextStyle(
        color: AppColors.primary,
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
      h3: const TextStyle(
        color: AppColors.primary,
        fontSize: 15,
        fontWeight: FontWeight.w600,
      ),
      listBullet: const TextStyle(
        color: AppColors.primary,
        fontSize: 14,
      ),
      blockSpacing: 8.0,
      listIndent: 16.0,
      blockquoteDecoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(8),
        border: const Border(
          left: BorderSide(color: AppColors.primary, width: 3),
        ),
      ),
      blockquotePadding: const EdgeInsets.all(12),
      codeblockDecoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }
}

/// Animated Typing Indicator
class _TypingIndicator extends StatefulWidget {
  const _TypingIndicator();

  @override
  State<_TypingIndicator> createState() => _TypingIndicatorState();
}

class _TypingIndicatorState extends State<_TypingIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: DesignTokens.spacingMd),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Bot avatar
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.primary, AppColors.neemGreen],
              ),
              borderRadius: BorderRadius.circular(DesignTokens.radiusSm),
            ),
            child: const Icon(Icons.spa, color: Colors.white, size: 18),
          ),
          const SizedBox(width: DesignTokens.spacingXs),
          
          // Typing bubble
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: DesignTokens.spacingMd,
              vertical: DesignTokens.spacingSm,
            ),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(DesignTokens.radiusMd),
                topRight: Radius.circular(DesignTokens.radiusMd),
                bottomRight: Radius.circular(DesignTokens.radiusMd),
                bottomLeft: Radius.circular(4),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(3, (index) {
                    final delay = index * 0.2;
                    final animValue = ((_controller.value + delay) % 1.0);
                    final scale = 0.5 + (0.5 * (1 - (2 * (animValue - 0.5)).abs()));
                    
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 3),
                      child: Transform.scale(
                        scale: scale,
                        child: Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.6),
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    );
                  }),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

/// Suggestion Chips
class _SuggestionChips extends StatelessWidget {
  final List<String> suggestions;
  final void Function(String) onTap;

  const _SuggestionChips({
    required this.suggestions,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: DesignTokens.spacingSm),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: DesignTokens.spacingMd),
        child: Row(
          children: suggestions.map((suggestion) {
            return Padding(
              padding: const EdgeInsets.only(right: DesignTokens.spacingXs),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => onTap(suggestion),
                  borderRadius: BorderRadius.circular(DesignTokens.radiusFull),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: DesignTokens.spacingMd,
                      vertical: DesignTokens.spacingXs,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(DesignTokens.radiusFull),
                      border: Border.all(
                        color: AppColors.primary.withValues(alpha: 0.2),
                      ),
                    ),
                    child: Text(
                      suggestion,
                      style: const TextStyle(
                        color: AppColors.primary,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

/// Premium Chat Input Bar
class _ChatInputBar extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final VoidCallback onSend;
  final bool isTyping;

  const _ChatInputBar({
    required this.controller,
    required this.focusNode,
    required this.onSend,
    required this.isTyping,
  });

  @override
  Widget build(BuildContext context) {
    // Only padding needed is horizontal and top, bottom handled by SafeArea
    return Container(
      padding: const EdgeInsets.only(
        left: DesignTokens.spacingMd,
        right: DesignTokens.spacingMd,
        top: DesignTokens.spacingSm,
        bottom: 0, // Explicitly zero
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // Text Input
          Expanded(
            child: Container(
              constraints: const BoxConstraints(maxHeight: 120),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(DesignTokens.radiusMd),
              ),
              child: TextField(
                controller: controller,
                focusNode: focusNode,
                maxLines: null,
                textInputAction: TextInputAction.send,
                textCapitalization: TextCapitalization.sentences,
                onSubmitted: (_) => onSend(),
                decoration: const InputDecoration(
                  hintText: 'Ask about Ayurveda...',
                  hintStyle: TextStyle(color: AppColors.textTertiary),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: DesignTokens.spacingMd,
                    vertical: DesignTokens.spacingSm,
                  ),
                ),
                style: const TextStyle(fontSize: 15),
              ),
            ),
          ),
          const SizedBox(width: DesignTokens.spacingSm),
          
          // Send Button with accessibility
          Semantics(
            label: isTyping ? 'Sending message, please wait' : 'Send message',
            button: true,
            enabled: !isTyping,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              child: Material(
                color: isTyping ? AppColors.textTertiary : AppColors.primary,
                borderRadius: BorderRadius.circular(DesignTokens.radiusMd),
                child: InkWell(
                  onTap: isTyping ? null : onSend,
                  borderRadius: BorderRadius.circular(DesignTokens.radiusMd),
                  child: Container(
                    width: 44,
                    height: 44,
                    alignment: Alignment.center,
                    child: const Icon(
                      Icons.send_rounded,
                      color: Colors.white,
                      size: 22,
                    ),
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
