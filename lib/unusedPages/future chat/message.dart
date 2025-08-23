enum MessageType {
  text,
  image,
  file,
  voice,
  location,
  system,
}

class Message {
  final String id;
  final String senderId;
  final String receiverId;
  final String content;
  final DateTime timestamp;
  final MessageType type;
  final bool isRead;
  final bool isGroupMessage;
  final String? senderName;
  final String? replyToMessageId;
  final List<String> reactions;
  final Map<String, dynamic>? metadata;

  const Message({
    required this.id,
    required this.senderId,
    required this.receiverId,
    required this.content,
    required this.timestamp,
    required this.type,
    this.isRead = false,
    this.isGroupMessage = false,
    this.senderName,
    this.replyToMessageId,
    this.reactions = const [],
    this.metadata,
  });

  Message copyWith({
    String? id,
    String? senderId,
    String? receiverId,
    String? content,
    DateTime? timestamp,
    MessageType? type,
    bool? isRead,
    bool? isGroupMessage,
    String? senderName,
    String? replyToMessageId,
    List<String>? reactions,
    Map<String, dynamic>? metadata,
  }) {
    return Message(
      id: id ?? this.id,
      senderId: senderId ?? this.senderId,
      receiverId: receiverId ?? this.receiverId,
      content: content ?? this.content,
      timestamp: timestamp ?? this.timestamp,
      type: type ?? this.type,
      isRead: isRead ?? this.isRead,
      isGroupMessage: isGroupMessage ?? this.isGroupMessage,
      senderName: senderName ?? this.senderName,
      replyToMessageId: replyToMessageId ?? this.replyToMessageId,
      reactions: reactions ?? this.reactions,
      metadata: metadata ?? this.metadata,
    );
  }

  bool get hasReactions => reactions.isNotEmpty;
  bool get isReply => replyToMessageId != null;
  
  String get displayContent {
    switch (type) {
      case MessageType.text:
        return content;
      case MessageType.image:
        return content.isEmpty ? '📷 Image' : content;
      case MessageType.file:
        return content.isEmpty ? '📎 File' : content;
      case MessageType.voice:
        return '🎤 Voice message';
      case MessageType.location:
        return content.isEmpty ? '📍 Location' : content;
      case MessageType.system:
        return content;
    }
  }
}

class Conversation {
  final String id;
  final String name;
  final String? unit;
  final String? avatar;
  final List<String> participantIds;
  final Message? lastMessage;
  final int unreadCount;
  final bool isGroup;
  final bool isPinned;
  final bool isMuted;
  final DateTime? lastActivity;

  const Conversation({
    required this.id,
    required this.name,
    this.unit,
    this.avatar,
    required this.participantIds,
    this.lastMessage,
    this.unreadCount = 0,
    this.isGroup = false,
    this.isPinned = false,
    this.isMuted = false,
    this.lastActivity,
  });

  String get lastMessagePreview {
    if (lastMessage == null) return 'No messages yet';
    
    final prefix = isGroup && lastMessage!.senderName != null 
        ? '${lastMessage!.senderName}: ' 
        : '';
    
    return '$prefix${lastMessage!.displayContent}';
  }

  String get timeDisplay {
    if (lastMessage == null) return '';
    
    final now = DateTime.now();
    final messageTime = lastMessage!.timestamp;
    final difference = now.difference(messageTime);
    
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

  bool get hasUnreadMessages => unreadCount > 0;
}

// Sample Messages Data
class MilitaryMessages {
  static List<Message> getAllMessages() {
    return [
      // Lt Maruf Messages
      Message(
        id: '1',
        senderId: '1',
        receiverId: 'current_user',
        content: 'Roger that, proceeding with communication check. All systems operational.',
        timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
        type: MessageType.text,
        isRead: true,
        senderName: 'Lt Maruf',
      ),
      Message(
        id: '2',
        senderId: 'current_user',
        receiverId: '1',
        content: 'Copy, Lt Maruf. Standing by for further instructions.',
        timestamp: DateTime.now().subtract(const Duration(minutes: 3)),
        type: MessageType.text,
        isRead: false,
      ),
      Message(
        id: '3',
        senderId: '1',
        receiverId: 'current_user',
        content: 'Affirmative. Maintain current position and report any changes.',
        timestamp: DateTime.now().subtract(const Duration(minutes: 1)),
        type: MessageType.text,
        isRead: false,
        senderName: 'Lt Maruf',
      ),

      // Lt Zobaer Messages
      Message(
        id: '4',
        senderId: '2',
        receiverId: 'current_user',
        content: 'Communication systems check complete. All frequencies clear.',
        timestamp: DateTime.now().subtract(const Duration(hours: 1)),
        type: MessageType.text,
        isRead: true,
        senderName: 'Lt Zobaer',
      ),
      Message(
        id: '5',
        senderId: 'current_user',
        receiverId: '2',
        content: 'Understood, Lt Zobaer. Will monitor channel 7.',
        timestamp: DateTime.now().subtract(const Duration(minutes: 45)),
        type: MessageType.text,
        isRead: true,
      ),

      // CO Messages
      Message(
        id: '6',
        senderId: '3',
        receiverId: 'current_user',
        content: 'SITREP: All units report ready status. Proceed with planned operations.',
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
        type: MessageType.text,
        isRead: true,
        senderName: 'CO Rahman',
      ),
      Message(
        id: '7',
        senderId: 'current_user',
        receiverId: '3',
        content: 'Roger, CO. Unit ready and standing by.',
        timestamp: DateTime.now().subtract(const Duration(hours: 2, minutes: 2)),
        type: MessageType.text,
        isRead: true,
      ),

      // Company Commander Messages
      Message(
        id: '8',
        senderId: '4',
        receiverId: 'current_user',
        content: 'Company formation at 0800 hours. All personnel report to assembly area.',
        timestamp: DateTime.now().subtract(const Duration(hours: 3)),
        type: MessageType.text,
        isRead: true,
        senderName: 'Cpy Comd Ahmed',
      ),

      // 2IC Messages
      Message(
        id: '9',
        senderId: '5',
        receiverId: 'current_user',
        content: 'Equipment check scheduled for 1400 hours. Ensure all gear is serviceable.',
        timestamp: DateTime.now().subtract(const Duration(hours: 4)),
        type: MessageType.text,
        isRead: true,
        senderName: '2IC Hassan',
      ),

      // System Messages
      Message(
        id: '10',
        senderId: 'system',
        receiverId: 'current_user',
        content: 'Secure communication channel established',
        timestamp: DateTime.now().subtract(const Duration(hours: 6)),
        type: MessageType.system,
        isRead: true,
      ),
    ];
  }

  static List<Message> getMessagesForContact(String contactId) {
    return getAllMessages()
        .where((message) => 
            message.senderId == contactId || 
            message.receiverId == contactId)
        .toList()
      ..sort((a, b) => a.timestamp.compareTo(b.timestamp));
  }

  static List<Message> getGroupMessages(String groupId) {
    // Sample group messages
    return [
      Message(
        id: 'g1',
        senderId: '1',
        receiverId: groupId,
        content: 'All stations, this is Lt Maruf. Communication check, over.',
        timestamp: DateTime.now().subtract(const Duration(minutes: 10)),
        type: MessageType.text,
        isRead: true,
        isGroupMessage: true,
        senderName: 'Lt Maruf',
      ),
      Message(
        id: 'g2',
        senderId: '2',
        receiverId: groupId,
        content: 'Lt Zobaer here, loud and clear, over.',
        timestamp: DateTime.now().subtract(const Duration(minutes: 9)),
        type: MessageType.text,
        isRead: true,
        isGroupMessage: true,
        senderName: 'Lt Zobaer',
      ),
      Message(
        id: 'g3',
        senderId: '3',
        receiverId: groupId,
        content: 'CO acknowledges. All units maintain radio discipline.',
        timestamp: DateTime.now().subtract(const Duration(minutes: 8)),
        type: MessageType.text,
        isRead: true,
        isGroupMessage: true,
        senderName: 'CO Rahman',
      ),
      Message(
        id: 'g4',
        senderId: 'current_user',
        receiverId: groupId,
        content: 'Roger all. Standing by for further instructions.',
        timestamp: DateTime.now().subtract(const Duration(minutes: 7)),
        type: MessageType.text,
        isRead: false,
        isGroupMessage: true,
      ),
      Message(
        id: 'g5',
        senderId: '5',
        receiverId: groupId,
        content: 'OPREP: All sections report green status. Ready for operations.',
        timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
        type: MessageType.text,
        isRead: false,
        isGroupMessage: true,
        senderName: '2IC Hassan',
      ),
    ];
  }

  static List<Conversation> getAllConversations() {
    final messages = getAllMessages();
    
    return [
      Conversation(
        id: '1',
        name: 'Lt Maruf',
        unit: '9 Sig Bn',
        avatar: 'LM',
        participantIds: ['1'],
        lastMessage: messages.where((m) => m.senderId == '1' || m.receiverId == '1').last,
        unreadCount: 2,
        lastActivity: DateTime.now().subtract(const Duration(minutes: 1)),
      ),
      Conversation(
        id: '2',
        name: 'Lt Zobaer',
        unit: '9 Sig Bn',
        avatar: 'LZ',
        participantIds: ['2'],
        lastMessage: messages.where((m) => m.senderId == '2' || m.receiverId == '2').last,
        unreadCount: 0,
        lastActivity: DateTime.now().subtract(const Duration(minutes: 45)),
      ),
      Conversation(
        id: '3',
        name: 'CO Rahman',
        unit: '9 Sig Bn',
        avatar: 'CO',
        participantIds: ['3'],
        lastMessage: messages.where((m) => m.senderId == '3' || m.receiverId == '3').last,
        unreadCount: 0,
        lastActivity: DateTime.now().subtract(const Duration(hours: 2)),
      ),
      Conversation(
        id: '4',
        name: 'Cpy Comd Ahmed',
        unit: '109 BSC',
        avatar: 'CC',
        participantIds: ['4'],
        lastMessage: messages.where((m) => m.senderId == '4' || m.receiverId == '4').last,
        unreadCount: 0,
        lastActivity: DateTime.now().subtract(const Duration(hours: 3)),
      ),
      Conversation(
        id: '5',
        name: '2IC Hassan',
        unit: '9 Sig Bn',
        avatar: '2IC',
        participantIds: ['5'],
        lastMessage: messages.where((m) => m.senderId == '5' || m.receiverId == '5').last,
        unreadCount: 0,
        lastActivity: DateTime.now().subtract(const Duration(hours: 4)),
      ),
      
      // Group Conversations
      Conversation(
        id: 'ops_room',
        name: 'Operations Room',
        unit: '9 Sig Bn',
        avatar: 'OPS',
        participantIds: ['1', '2', '3', '5', '6'],
        lastMessage: Message(
          id: 'g_last_1',
          senderId: '5',
          receiverId: 'ops_room',
          content: 'OPREP: All sections report green status. Ready for operations.',
          timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
          type: MessageType.text,
          isRead: false,
          isGroupMessage: true,
          senderName: '2IC Hassan',
        ),
        unreadCount: 3,
        isGroup: true,
        isPinned: true,
        lastActivity: DateTime.now().subtract(const Duration(minutes: 5)),
      ),
      Conversation(
        id: 'signal_team',
        name: 'Signal Team',
        unit: '9 Sig Bn',
        avatar: 'SIG',
        participantIds: ['1', '2', '8'],
        lastMessage: Message(
          id: 'g_last_2',
          senderId: '2',
          receiverId: 'signal_team',
          content: 'Equipment maintenance scheduled for tomorrow 0900.',
          timestamp: DateTime.now().subtract(const Duration(hours: 1)),
          type: MessageType.text,
          isRead: true,
          isGroupMessage: true,
          senderName: 'Lt Zobaer',
        ),
        unreadCount: 0,
        isGroup: true,
        lastActivity: DateTime.now().subtract(const Duration(hours: 1)),
      ),
      Conversation(
        id: 'command_group',
        name: 'Command Group',
        unit: '9 Sig Bn',
        avatar: 'CMD',
        participantIds: ['3', '4', '5', '6'],
        lastMessage: Message(
          id: 'g_last_3',
          senderId: '3',
          receiverId: 'command_group',
          content: 'Weekly briefing scheduled for Friday 1000 hours.',
          timestamp: DateTime.now().subtract(const Duration(hours: 2)),
          type: MessageType.text,
          isRead: true,
          isGroupMessage: true,
          senderName: 'CO Rahman',
        ),
        unreadCount: 1,
        isGroup: true,
        lastActivity: DateTime.now().subtract(const Duration(hours: 2)),
      ),
    ];
  }

  static int getTotalUnreadCount() {
    return getAllConversations()
        .fold(0, (total, conversation) => total + conversation.unreadCount);
  }

  static List<Conversation> getPinnedConversations() {
    return getAllConversations()
        .where((conversation) => conversation.isPinned)
        .toList();
  }

  static List<Conversation> getRecentConversations({int limit = 10}) {
    final conversations = getAllConversations();
    conversations.sort((a, b) {
      final aTime = a.lastActivity ?? DateTime.fromMillisecondsSinceEpoch(0);
      final bTime = b.lastActivity ?? DateTime.fromMillisecondsSinceEpoch(0);
      return bTime.compareTo(aTime);
    });
    
    return conversations.take(limit).toList();
  }

  static void markConversationAsRead(String conversationId) {
    // In a real app, this would update the backend
    // For now, we'll just simulate the action
  }

  static void addMessage(Message message) {
    // In a real app, this would send the message to the backend
    // For now, we'll just simulate the action
  }

  static void deleteMessage(String messageId) {
    // In a real app, this would delete the message from the backend
    // For now, we'll just simulate the action
  }

  static void editMessage(String messageId, String newContent) {
    // In a real app, this would edit the message in the backend
    // For now, we'll just simulate the action
  }

  static void addReaction(String messageId, String reaction) {
    // In a real app, this would add a reaction to the message
    // For now, we'll just simulate the action
  }

  static void removeReaction(String messageId, String reaction) {
    // In a real app, this would remove a reaction from the message
    // For now, we'll just simulate the action
  }
}

