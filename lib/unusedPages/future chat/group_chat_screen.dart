import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/message.dart';
import '../models/military_contact.dart';
import '../utils/app_theme.dart';
import '../widgets/military_gradient_background.dart';
import '../widgets/military_avatar.dart';
import '../widgets/message_bubble.dart';
import '../widgets/typing_indicator.dart';
import '../widgets/group_avatar.dart';
import '../services/call_service.dart';
import '../services/clipboard_service.dart';

class GroupChatScreen extends StatefulWidget {
  final String groupId;
  final String groupName;

  const GroupChatScreen({
    super.key,
    required this.groupId,
    required this.groupName,
  });

  @override
  State<GroupChatScreen> createState() => _GroupChatScreenState();
}

class _GroupChatScreenState extends State<GroupChatScreen> with TickerProviderStateMixin {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FocusNode _messageFocusNode = FocusNode();
  
  List<Message> _messages = [];
  MilitaryGroup? _group;
  bool _isTyping = false;
  Map<String, bool> _membersTyping = {};
  late AnimationController _typingAnimationController;

  @override
  void initState() {
    super.initState();
    _loadGroup();
    _loadMessages();
    _typingAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();
    
    // Simulate members typing occasionally
    _simulateGroupTyping();
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    _messageFocusNode.dispose();
    _typingAnimationController.dispose();
    super.dispose();
  }

  void _loadGroup() {
    setState(() {
      _group = MilitaryGroups.getById(widget.groupId);
    });
  }

  void _loadMessages() {
    setState(() {
      _messages = MilitaryMessages.getGroupMessages(widget.groupId);
    });
    _scrollToBottom();
  }

  void _simulateGroupTyping() {
    Future.delayed(const Duration(seconds: 4), () {
      if (mounted && _group != null) {
        final members = _group!.members;
        if (members.isNotEmpty) {
          final randomMember = members[DateTime.now().millisecond % members.length];
          setState(() {
            _membersTyping[randomMember.id] = true;
          });
          
          Future.delayed(const Duration(seconds: 3), () {
            if (mounted) {
              setState(() {
                _membersTyping[randomMember.id] = false;
              });
            }
          });
        }
      }
    });
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

  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    final message = Message(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      senderId: 'current_user',
      receiverId: widget.groupId,
      content: text,
      timestamp: DateTime.now(),
      type: MessageType.text,
      isRead: false,
      isGroupMessage: true,
    );

    setState(() {
      _messages.add(message);
      _messageController.clear();
      _isTyping = false;
    });

    // Haptic feedback
    HapticFeedback.lightImpact();
    
    _scrollToBottom();
    
    // Simulate group responses
    _simulateGroupResponse();
  }

  void _simulateGroupResponse() {
    if (_group == null) return;
    
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        final members = _group!.members;
        if (members.isNotEmpty) {
          final randomMember = members[DateTime.now().millisecond % members.length];
          
          final responses = [
            'Copy that, proceeding with orders',
            'Roger, ${randomMember.rank} acknowledges',
            'Understood, will coordinate accordingly',
            'Affirmative, standing by for further instructions',
            'Message received, ${randomMember.unit} ready',
            'Acknowledged, maintaining position',
          ];
          
          final response = Message(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            senderId: randomMember.id,
            receiverId: widget.groupId,
            content: responses[DateTime.now().millisecond % responses.length],
            timestamp: DateTime.now(),
            type: MessageType.text,
            isRead: false,
            isGroupMessage: true,
            senderName: randomMember.fullTitle,
          );

          setState(() {
            _messages.add(response);
          });
          
          _scrollToBottom();
        }
      }
    });
  }

  void _onMessageChanged(String text) {
    final isCurrentlyTyping = text.isNotEmpty;
    if (isCurrentlyTyping != _isTyping) {
      setState(() {
        _isTyping = isCurrentlyTyping;
      });
    }
  }

  void _initiateGroupVoiceCall() {
    if (_group?.hasCallCapability == true) {
      CallService.initiateGroupVoiceCall(_group!);
      _showGroupCallDialog(isVideo: false);
    } else {
      _showCallUnavailableDialog();
    }
  }

  void _initiateGroupVideoCall() {
    if (_group?.hasVideoCallCapability == true) {
      CallService.initiateGroupVideoCall(_group!);
      _showGroupCallDialog(isVideo: true);
    } else {
      _showCallUnavailableDialog();
    }
  }

  void _showGroupCallDialog({required bool isVideo}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            GroupAvatar(
              group: _group!,
              size: 80,
            ),
            const SizedBox(height: 16),
            Text(
              '${isVideo ? 'Video' : 'Voice'} conference...',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              _group!.name,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: AppTheme.textSecondary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '${_group!.onlineCount} online • ${_group!.participantCount}',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppTheme.textMuted,
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    CallService.endCall();
                  },
                  icon: const Icon(Icons.call_end),
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.all(16),
                  ),
                ),
                if (isVideo)
                  IconButton(
                    onPressed: () {
                      // Toggle camera
                      HapticFeedback.lightImpact();
                    },
                    icon: const Icon(Icons.videocam_off),
                    style: IconButton.styleFrom(
                      backgroundColor: AppTheme.textMuted,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.all(16),
                    ),
                  ),
                IconButton(
                  onPressed: () {
                    // Toggle mute
                    HapticFeedback.lightImpact();
                  },
                  icon: const Icon(Icons.mic_off),
                  style: IconButton.styleFrom(
                    backgroundColor: AppTheme.textMuted,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.all(16),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    _showParticipants();
                  },
                  icon: const Icon(Icons.people),
                  style: IconButton.styleFrom(
                    backgroundColor: AppTheme.primaryGreen,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.all(16),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );

    // Auto-dismiss after 15 seconds (simulate call timeout)
    Future.delayed(const Duration(seconds: 15), () {
      if (mounted && Navigator.of(context).canPop()) {
        Navigator.of(context).pop();
        CallService.endCall();
      }
    });
  }

  void _showCallUnavailableDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Call Unavailable'),
        content: Text(
          '${_group?.name} does not have calling capabilities enabled.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showParticipants() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Participants (${_group?.members.length ?? 0})',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            if (_group != null)
              ...(_group!.members.map((member) => ListTile(
                leading: MilitaryAvatar(contact: member, size: 40),
                title: Text(member.fullTitle),
                subtitle: Text('${member.unit} • ${member.designation}'),
                trailing: Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: member.isOnline 
                        ? AppTheme.onlineIndicator 
                        : AppTheme.textMuted,
                    shape: BoxShape.circle,
                  ),
                ),
              ))),
          ],
        ),
      ),
    );
  }

  void _showGroupInfo() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                GroupAvatar(group: _group!, size: 60),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _group!.name,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      Text(
                        _group!.unit,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppTheme.textSecondary,
                        ),
                      ),
                      if (_group!.description != null)
                        Text(
                          _group!.description!,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppTheme.textMuted,
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Icon(
                  _group!.isOperational ? Icons.security : Icons.group,
                  color: _group!.isOperational 
                      ? Colors.red 
                      : AppTheme.primaryGreen,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  _group!.isOperational ? 'Operational Channel' : 'Standard Group',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: _group!.isOperational 
                        ? Colors.red 
                        : AppTheme.primaryGreen,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.people),
              title: const Text('View Participants'),
              onTap: () {
                Navigator.of(context).pop();
                _showParticipants();
              },
            ),
            ListTile(
              leading: const Icon(Icons.notifications),
              title: const Text('Notification Settings'),
              onTap: () {
                Navigator.of(context).pop();
                // TODO: Implement notification settings
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showMessageOptions(Message message) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.copy),
              title: const Text('Copy Message'),
              onTap: () {
                ClipboardService.copyToClipboard(message.content);
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Message copied to clipboard'),
                    duration: Duration(seconds: 2),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.reply),
              title: const Text('Reply'),
              onTap: () {
                Navigator.of(context).pop();
                final senderName = message.senderName ?? 'Unknown';
                _messageController.text = '@$senderName Re: ${message.content}\n\n';
                _messageFocusNode.requestFocus();
              },
            ),
            ListTile(
              leading: const Icon(Icons.info_outline),
              title: const Text('Message Info'),
              onTap: () {
                Navigator.of(context).pop();
                _showMessageInfo(message);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showMessageInfo(Message message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Message Info'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (message.senderName != null)
              Text('From: ${message.senderName}'),
            const SizedBox(height: 8),
            Text('Sent: ${_formatTimestamp(message.timestamp)}'),
            const SizedBox(height: 8),
            Text('Status: ${message.isRead ? 'Read' : 'Delivered'}'),
            const SizedBox(height: 8),
            Text('Type: ${message.type.name}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);
    
    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }

  List<MilitaryContact> _getTypingMembers() {
    if (_group == null) return [];
    
    return _group!.members
        .where((member) => _membersTyping[member.id] == true)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    if (_group == null) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    final typingMembers = _getTypingMembers();

    return Scaffold(
      body: MilitaryGradientBackground(
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Container(
                margin: const EdgeInsets.all(10),
                decoration: AppTheme.cardDecoration,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(Icons.arrow_back),
                        style: IconButton.styleFrom(
                          backgroundColor: AppTheme.primaryGreen.withOpacity(0.1),
                        ),
                      ),
                      const SizedBox(width: 12),
                      GestureDetector(
                        onTap: _showGroupInfo,
                        child: Row(
                          children: [
                            GroupAvatar(group: _group!),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _group!.name,
                                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  '${_group!.unit} • ${_group!.participantCount}',
                                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: AppTheme.textSecondary,
                                  ),
                                ),
                                Row(
                                  children: [
                                    Container(
                                      width: 8,
                                      height: 8,
                                      decoration: BoxDecoration(
                                        color: _group!.onlineCount > 0 
                                            ? AppTheme.onlineIndicator 
                                            : AppTheme.textMuted,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      '${_group!.onlineCount} online',
                                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                        color: AppTheme.textMuted,
                                      ),
                                    ),
                                    if (_group!.isOperational) ...[
                                      const SizedBox(width: 8),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 6,
                                          vertical: 2,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.red.withOpacity(0.1),
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: Text(
                                          'OPS',
                                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                            color: Colors.red,
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                          ),
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
                      const Spacer(),
                      // Call buttons
                      if (_group!.hasCallCapability)
                        IconButton(
                          onPressed: _initiateGroupVoiceCall,
                          icon: const Icon(Icons.call),
                          style: IconButton.styleFrom(
                            backgroundColor: AppTheme.primaryGreen.withOpacity(0.1),
                          ),
                        ),
                      const SizedBox(width: 8),
                      if (_group!.hasVideoCallCapability)
                        IconButton(
                          onPressed: _initiateGroupVideoCall,
                          icon: const Icon(Icons.videocam),
                          style: IconButton.styleFrom(
                            backgroundColor: AppTheme.primaryGreen.withOpacity(0.1),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              
              // Messages
              Expanded(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: AppTheme.cardDecoration,
                  child: Column(
                    children: [
                      Expanded(
                        child: ListView.builder(
                          controller: _scrollController,
                          padding: const EdgeInsets.all(16),
                          itemCount: _messages.length + (typingMembers.isNotEmpty ? 1 : 0),
                          itemBuilder: (context, index) {
                            if (index == _messages.length && typingMembers.isNotEmpty) {
                              return GroupTypingIndicator(
                                members: typingMembers,
                                animationController: _typingAnimationController,
                              );
                            }
                            
                            final message = _messages[index];
                            return MessageBubble(
                              message: message,
                              isFromCurrentUser: message.senderId == 'current_user',
                              contact: _group!.members.firstWhere(
                                (m) => m.id == message.senderId,
                                orElse: () => _group!.members.first,
                              ),
                              onLongPress: () => _showMessageOptions(message),
                              showSenderName: message.isGroupMessage,
                            );
                          },
                        ),
                      ),
                      
                      // Message Input
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade50,
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(25),
                            bottomRight: Radius.circular(25),
                          ),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _messageController,
                                focusNode: _messageFocusNode,
                                onChanged: _onMessageChanged,
                                onSubmitted: (_) => _sendMessage(),
                                decoration: InputDecoration(
                                  hintText: 'Type a message to ${_group!.name}...',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(25),
                                    borderSide: BorderSide.none,
                                  ),
                                  filled: true,
                                  fillColor: Colors.white,
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 12,
                                  ),
                                  suffixIcon: IconButton(
                                    onPressed: () {
                                      ClipboardService.pasteFromClipboard().then((text) {
                                        if (text != null) {
                                          _messageController.text += text;
                                        }
                                      });
                                    },
                                    icon: const Icon(Icons.content_paste),
                                    tooltip: 'Paste',
                                  ),
                                ),
                                maxLines: null,
                                textCapitalization: TextCapitalization.sentences,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [AppTheme.primaryGreen, AppTheme.lightGreen],
                                ),
                                borderRadius: BorderRadius.circular(25),
                              ),
                              child: IconButton(
                                onPressed: _sendMessage,
                                icon: const Icon(
                                  Icons.send,
                                  color: Colors.white,
                                ),
                                style: IconButton.styleFrom(
                                  backgroundColor: Colors.transparent,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
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

class GroupTypingIndicator extends StatelessWidget {
  final List<MilitaryContact> members;
  final AnimationController animationController;

  const GroupTypingIndicator({
    super.key,
    required this.members,
    required this.animationController,
  });

  @override
  Widget build(BuildContext context) {
    if (members.isEmpty) return const SizedBox.shrink();

    String typingText;
    if (members.length == 1) {
      typingText = '${members.first.rank} ${members.first.name} is typing...';
    } else if (members.length == 2) {
      typingText = '${members.first.rank} ${members.first.name} and ${members.last.rank} ${members.last.name} are typing...';
    } else {
      typingText = '${members.length} members are typing...';
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  typingText,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppTheme.textMuted,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                const SizedBox(width: 8),
                AnimatedBuilder(
                  animation: animationController,
                  builder: (context, child) {
                    return Row(
                      children: List.generate(3, (index) {
                        final delay = index * 0.2;
                        final animationValue = (animationController.value - delay).clamp(0.0, 1.0);
                        final opacity = (animationValue * 2).clamp(0.0, 1.0);
                        
                        return Container(
                          margin: const EdgeInsets.symmetric(horizontal: 1),
                          width: 4,
                          height: 4,
                          decoration: BoxDecoration(
                            color: AppTheme.textMuted.withOpacity(opacity),
                            shape: BoxShape.circle,
                          ),
                        );
                      }),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

