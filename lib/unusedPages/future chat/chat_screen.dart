import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/message.dart';
import '../models/military_contact.dart';
import '../utils/app_theme.dart';
import '../widgets/military_gradient_background.dart';
import '../widgets/military_avatar.dart';
import '../widgets/message_bubble.dart';
import '../widgets/typing_indicator.dart';
import '../services/call_service.dart';
import '../services/clipboard_service.dart';

class ChatScreen extends StatefulWidget {
  final MilitaryContact contact;

  const ChatScreen({
    super.key,
    required this.contact,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FocusNode _messageFocusNode = FocusNode();
  
  List<Message> _messages = [];
  bool _isTyping = false;
  bool _isOtherTyping = false;
  late AnimationController _typingAnimationController;

  @override
  void initState() {
    super.initState();
    _loadMessages();
    _typingAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();
    
    // Simulate other person typing occasionally
    _simulateTyping();
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    _messageFocusNode.dispose();
    _typingAnimationController.dispose();
    super.dispose();
  }

  void _loadMessages() {
    setState(() {
      _messages = MilitaryMessages.getMessagesForContact(widget.contact.id);
    });
    _scrollToBottom();
  }

  void _simulateTyping() {
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _isOtherTyping = true;
        });
        
        Future.delayed(const Duration(seconds: 2), () {
          if (mounted) {
            setState(() {
              _isOtherTyping = false;
            });
          }
        });
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
      receiverId: widget.contact.id,
      content: text,
      timestamp: DateTime.now(),
      type: MessageType.text,
      isRead: false,
    );

    setState(() {
      _messages.add(message);
      _messageController.clear();
      _isTyping = false;
    });

    // Haptic feedback
    HapticFeedback.lightImpact();
    
    _scrollToBottom();
    
    // Simulate response after a delay
    _simulateResponse();
  }

  void _simulateResponse() {
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        final responses = [
          'Roger that, ${widget.contact.rank}',
          'Copy, proceeding as instructed',
          'Understood, will comply',
          'Affirmative, standing by',
          'Message received and acknowledged',
        ];
        
        final response = Message(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          senderId: widget.contact.id,
          receiverId: 'current_user',
          content: responses[DateTime.now().millisecond % responses.length],
          timestamp: DateTime.now(),
          type: MessageType.text,
          isRead: false,
        );

        setState(() {
          _messages.add(response);
        });
        
        _scrollToBottom();
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

  void _initiateVoiceCall() {
    if (widget.contact.hasCallCapability) {
      CallService.initiateVoiceCall(widget.contact);
      _showCallDialog(isVideo: false);
    } else {
      _showCallUnavailableDialog();
    }
  }

  void _initiateVideoCall() {
    if (widget.contact.hasVideoCallCapability) {
      CallService.initiateVideoCall(widget.contact);
      _showCallDialog(isVideo: true);
    } else {
      _showCallUnavailableDialog();
    }
  }

  void _showCallDialog({required bool isVideo}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            MilitaryAvatar(
              contact: widget.contact,
              size: 80,
            ),
            const SizedBox(height: 16),
            Text(
              '${isVideo ? 'Video' : 'Voice'} calling...',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              widget.contact.fullTitle,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: AppTheme.textSecondary,
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
              ],
            ),
          ],
        ),
      ),
    );

    // Auto-dismiss after 10 seconds (simulate call timeout)
    Future.delayed(const Duration(seconds: 10), () {
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
          '${widget.contact.fullTitle} does not have calling capabilities enabled.',
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
                _messageController.text = 'Re: ${message.content}\n\n';
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

  @override
  Widget build(BuildContext context) {
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
                      MilitaryAvatar(contact: widget.contact),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.contact.fullTitle,
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              '${widget.contact.unit} • ${widget.contact.designation}',
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: AppTheme.textSecondary,
                              ),
                            ),
                            Text(
                              widget.contact.statusText,
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: widget.contact.isOnline 
                                    ? AppTheme.onlineIndicator 
                                    : AppTheme.textMuted,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Call buttons
                      if (widget.contact.hasCallCapability)
                        IconButton(
                          onPressed: _initiateVoiceCall,
                          icon: const Icon(Icons.call),
                          style: IconButton.styleFrom(
                            backgroundColor: AppTheme.primaryGreen.withOpacity(0.1),
                          ),
                        ),
                      const SizedBox(width: 8),
                      if (widget.contact.hasVideoCallCapability)
                        IconButton(
                          onPressed: _initiateVideoCall,
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
                          itemCount: _messages.length + (_isOtherTyping ? 1 : 0),
                          itemBuilder: (context, index) {
                            if (index == _messages.length && _isOtherTyping) {
                              return TypingIndicator(
                                contact: widget.contact,
                                animationController: _typingAnimationController,
                              );
                            }
                            
                            final message = _messages[index];
                            return MessageBubble(
                              message: message,
                              isFromCurrentUser: message.senderId == 'current_user',
                              contact: widget.contact,
                              onLongPress: () => _showMessageOptions(message),
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
                                  hintText: 'Type a message...',
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

