import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/message.dart';
import '../models/military_contact.dart';
import '../utils/app_theme.dart';
import 'military_avatar.dart';

class MessageBubble extends StatelessWidget {
  final Message message;
  final bool isFromCurrentUser;
  final MilitaryContact contact;
  final VoidCallback? onLongPress;
  final bool showSenderName;

  const MessageBubble({
    super.key,
    required this.message,
    required this.isFromCurrentUser,
    required this.contact,
    this.onLongPress,
    this.showSenderName = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: isFromCurrentUser 
            ? MainAxisAlignment.end 
            : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isFromCurrentUser) ...[
            MilitaryAvatar(
              contact: contact,
              size: 32,
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: GestureDetector(
              onLongPress: () {
                HapticFeedback.mediumImpact();
                onLongPress?.call();
              },
              child: Container(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.75,
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  gradient: isFromCurrentUser
                      ? const LinearGradient(
                          colors: [AppTheme.primaryGreen, AppTheme.lightGreen],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        )
                      : null,
                  color: isFromCurrentUser ? null : Colors.grey.shade100,
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(18),
                    topRight: const Radius.circular(18),
                    bottomLeft: isFromCurrentUser 
                        ? const Radius.circular(18) 
                        : const Radius.circular(4),
                    bottomRight: isFromCurrentUser 
                        ? const Radius.circular(4) 
                        : const Radius.circular(18),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: isFromCurrentUser 
                          ? AppTheme.primaryGreen.withOpacity(0.3)
                          : Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Sender name for group messages
                    if (showSenderName && !isFromCurrentUser) ...[
                      Text(
                        message.senderName ?? contact.fullTitle,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppTheme.primaryGreen,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                    ],
                    
                    // Message content
                    _buildMessageContent(context),
                    
                    const SizedBox(height: 4),
                    
                    // Timestamp and status
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          _formatTimestamp(message.timestamp),
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: isFromCurrentUser 
                                ? Colors.white.withOpacity(0.8)
                                : AppTheme.textMuted,
                            fontSize: 11,
                          ),
                        ),
                        if (isFromCurrentUser) ...[
                          const SizedBox(width: 4),
                          Icon(
                            message.isRead ? Icons.done_all : Icons.done,
                            size: 14,
                            color: message.isRead 
                                ? Colors.blue.shade300
                                : Colors.white.withOpacity(0.8),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (isFromCurrentUser) ...[
            const SizedBox(width: 8),
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppTheme.primaryGreen, AppTheme.lightGreen],
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.primaryGreen.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Icon(
                Icons.person,
                color: Colors.white,
                size: 18,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildMessageContent(BuildContext context) {
    switch (message.type) {
      case MessageType.text:
        return SelectableText(
          message.content,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: isFromCurrentUser ? Colors.white : AppTheme.textPrimary,
            height: 1.4,
          ),
          contextMenuBuilder: (context, editableTextState) {
            return AdaptiveTextSelectionToolbar.buttonItems(
              anchors: editableTextState.contextMenuAnchors,
              buttonItems: [
                ContextMenuButtonItem(
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: message.content));
                    ContextMenuController.removeAny();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Message copied to clipboard'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },
                  label: 'Copy',
                ),
                ContextMenuButtonItem(
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: message.content));
                    ContextMenuController.removeAny();
                    // Trigger reply action
                    onLongPress?.call();
                  },
                  label: 'Copy & Reply',
                ),
              ],
            );
          },
        );
      
      case MessageType.image:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              constraints: const BoxConstraints(
                maxWidth: 200,
                maxHeight: 200,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.grey.shade200,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: const Icon(
                  Icons.image,
                  size: 64,
                  color: AppTheme.textMuted,
                ),
              ),
            ),
            if (message.content.isNotEmpty) ...[
              const SizedBox(height: 8),
              SelectableText(
                message.content,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: isFromCurrentUser ? Colors.white : AppTheme.textPrimary,
                ),
              ),
            ],
          ],
        );
      
      case MessageType.file:
        return Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isFromCurrentUser 
                ? Colors.white.withOpacity(0.2)
                : Colors.grey.shade200,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.attach_file,
                color: isFromCurrentUser ? Colors.white : AppTheme.textSecondary,
                size: 20,
              ),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  message.content.isNotEmpty ? message.content : 'File attachment',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: isFromCurrentUser ? Colors.white : AppTheme.textPrimary,
                  ),
                ),
              ),
            ],
          ),
        );
      
      case MessageType.voice:
        return Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isFromCurrentUser 
                ? Colors.white.withOpacity(0.2)
                : Colors.grey.shade200,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.mic,
                color: isFromCurrentUser ? Colors.white : AppTheme.primaryGreen,
                size: 20,
              ),
              const SizedBox(width: 8),
              Container(
                width: 100,
                height: 20,
                decoration: BoxDecoration(
                  color: isFromCurrentUser 
                      ? Colors.white.withOpacity(0.3)
                      : AppTheme.primaryGreen.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text(
                    '0:${(DateTime.now().second % 60).toString().padLeft(2, '0')}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: isFromCurrentUser ? Colors.white : AppTheme.textSecondary,
                      fontSize: 10,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Icon(
                Icons.play_arrow,
                color: isFromCurrentUser ? Colors.white : AppTheme.primaryGreen,
                size: 20,
              ),
            ],
          ),
        );
      
      case MessageType.location:
        return Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isFromCurrentUser 
                ? Colors.white.withOpacity(0.2)
                : Colors.grey.shade200,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.location_on,
                    color: isFromCurrentUser ? Colors.white : Colors.red,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Location',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: isFromCurrentUser ? Colors.white : AppTheme.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              if (message.content.isNotEmpty) ...[
                const SizedBox(height: 4),
                Text(
                  message.content,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: isFromCurrentUser 
                        ? Colors.white.withOpacity(0.8)
                        : AppTheme.textSecondary,
                  ),
                ),
              ],
            ],
          ),
        );
      
      case MessageType.system:
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: AppTheme.primaryGreen.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.info_outline,
                color: AppTheme.primaryGreen,
                size: 16,
              ),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  message.content,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppTheme.primaryGreen,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            ],
          ),
        );
    }
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);
    
    if (difference.inDays > 0) {
      return '${difference.inDays}d';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m';
    } else {
      return 'now';
    }
  }
}

// Message Reaction Widget (for future implementation)
class MessageReactions extends StatelessWidget {
  final List<String> reactions;
  final Function(String) onReactionTap;

  const MessageReactions({
    super.key,
    required this.reactions,
    required this.onReactionTap,
  });

  @override
  Widget build(BuildContext context) {
    if (reactions.isEmpty) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.only(top: 4),
      child: Wrap(
        spacing: 4,
        children: reactions.map((reaction) {
          return GestureDetector(
            onTap: () => onReactionTap(reaction),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppTheme.primaryGreen.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppTheme.primaryGreen.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Text(
                reaction,
                style: const TextStyle(fontSize: 12),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

// Message Status Indicator
class MessageStatusIndicator extends StatelessWidget {
  final Message message;
  final bool isFromCurrentUser;

  const MessageStatusIndicator({
    super.key,
    required this.message,
    required this.isFromCurrentUser,
  });

  @override
  Widget build(BuildContext context) {
    if (!isFromCurrentUser) return const SizedBox.shrink();

    IconData icon;
    Color color;

    if (message.isRead) {
      icon = Icons.done_all;
      color = Colors.blue;
    } else {
      icon = Icons.done;
      color = Colors.grey;
    }

    return Icon(
      icon,
      size: 14,
      color: color,
    );
  }
}

