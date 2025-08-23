import 'package:flutter/material.dart';
import '../models/message.dart';
import '../models/military_contact.dart';
import '../utils/app_theme.dart';
import 'military_avatar.dart';

class ConversationTile extends StatelessWidget {
  final Conversation conversation;
  final VoidCallback onTap;

  const ConversationTile({
    super.key,
    required this.conversation,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: AppTheme.cardDecoration,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(15),
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Row(
              children: [
                // Avatar
                _buildAvatar(),
                const SizedBox(width: 15),
                
                // Conversation Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              conversation.displayName,
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                fontWeight: conversation.hasUnreadMessages 
                                    ? FontWeight.w600 
                                    : FontWeight.w500,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (conversation.isOperational)
                            Container(
                              margin: const EdgeInsets.only(left: 8),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: AppTheme.commandColor,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                'OPS',
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                        ],
                      ),
                      
                      if (conversation.unit != null) ...[
                        const SizedBox(height: 2),
                        Text(
                          conversation.unit!,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppTheme.primaryGreen,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                      
                      const SizedBox(height: 4),
                      
                      Row(
                        children: [
                          // Priority indicator
                          if (conversation.isHighPriority) ...[
                            Icon(
                              Icons.priority_high,
                              size: 14,
                              color: conversation.lastMessage?.priority == MessagePriority.flash
                                  ? Colors.red
                                  : Colors.orange,
                            ),
                            const SizedBox(width: 4),
                          ],
                          
                          // Message preview
                          Expanded(
                            child: Text(
                              conversation.subtitle,
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                fontWeight: conversation.hasUnreadMessages 
                                    ? FontWeight.w500 
                                    : FontWeight.w400,
                                color: conversation.hasUnreadMessages
                                    ? AppTheme.textPrimary
                                    : AppTheme.textSecondary,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ),
                        ],
                      ),
                      
                      if (conversation.isGroup) ...[
                        const SizedBox(height: 4),
                        Text(
                          _getParticipantInfo(),
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppTheme.textMuted,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                
                // Time and Status
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      _getTimeText(),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: conversation.hasUnreadMessages
                            ? AppTheme.primaryGreen
                            : AppTheme.textMuted,
                        fontWeight: conversation.hasUnreadMessages
                            ? FontWeight.w600
                            : FontWeight.w400,
                      ),
                    ),
                    
                    const SizedBox(height: 8),
                    
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Muted indicator
                        if (conversation.isMuted)
                          const Icon(
                            Icons.volume_off,
                            size: 16,
                            color: AppTheme.textMuted,
                          ),
                        
                        // Unread count badge
                        if (conversation.hasUnreadMessages) ...[
                          if (conversation.isMuted) const SizedBox(width: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: AppTheme.primaryGreen,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            constraints: const BoxConstraints(minWidth: 20),
                            child: Text(
                              conversation.unreadCount > 99 
                                  ? '99+' 
                                  : conversation.unreadCount.toString(),
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 11,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAvatar() {
    if (conversation.isGroup) {
      return _buildGroupAvatar();
    } else {
      final contact = MilitaryPersonnel.getById(conversation.participantIds.first);
      if (contact != null) {
        return MilitaryAvatar(
          contact: contact,
          size: 50,
          showOnlineIndicator: true,
        );
      }
    }
    
    return _buildDefaultAvatar();
  }

  Widget _buildGroupAvatar() {
    final group = MilitaryGroups.getById(conversation.id);
    if (group != null) {
      return Stack(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: conversation.isOperational
                    ? [AppTheme.commandColor, AppTheme.officerColor]
                    : [AppTheme.primaryGreen, AppTheme.lightGreen],
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
            child: Icon(
              conversation.isOperational ? Icons.security : Icons.group,
              color: Colors.white,
              size: 24,
            ),
          ),
          
          // Online members indicator
          if (group.onlineCount > 0)
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                decoration: BoxDecoration(
                  color: AppTheme.onlineIndicator,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.white, width: 2),
                ),
                child: Text(
                  group.onlineCount.toString(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
        ],
      );
    }
    
    return _buildDefaultAvatar();
  }

  Widget _buildDefaultAvatar() {
    return Container(
      width: 50,
      height: 50,
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
        size: 24,
      ),
    );
  }

  String _getTimeText() {
    if (conversation.lastMessage != null) {
      return conversation.lastMessage!.formattedTime;
    }
    return '';
  }

  String _getParticipantInfo() {
    final group = MilitaryGroups.getById(conversation.id);
    if (group != null) {
      final onlineText = group.onlineCount > 0 ? '${group.onlineCount} online' : '';
      return '${group.participantCount}${onlineText.isNotEmpty ? ' • $onlineText' : ''}';
    }
    return '';
  }
}