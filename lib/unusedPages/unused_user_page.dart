import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  ChatPageState createState() => ChatPageState();
}

class ChatPageState extends State<ChatPage> {
  // Sample chat data
  final List<ChatContact> _chatContacts = [
    ChatContact(
      name: "Col. Anderson",
      lastMessage: "Mission briefing at 0800 hours",
      time: "08:30",
      unreadCount: 2,
      isOnline: true,
    ),
    ChatContact(
      name: "Sgt. Williams",
      lastMessage: "Equipment check completed",
      time: "07:45",
      unreadCount: 0,
      isOnline: false,
    ),
    ChatContact(
      name: "Alpha Team",
      lastMessage: "Ready for deployment",
      time: "Yesterday",
      unreadCount: 5,
      isOnline: true,
    ),
    ChatContact(
      name: "Lt. Johnson",
      lastMessage: "Roger that, standing by",
      time: "Yesterday",
      unreadCount: 0,
      isOnline: true,
    ),
    ChatContact(
      name: "Command Center",
      lastMessage: "All units report status",
      time: "Monday",
      unreadCount: 1,
      isOnline: false,
    ),
  ];

  void _handleMenuSelection(String value) {
    switch (value) {
      case 'search':
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Search Conversations'),
            content: TextField(
              decoration: InputDecoration(
                hintText: 'Search messages...',
                prefixIcon: Icon(Icons.search),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Search'),
              ),
            ],
          ),
        );
        break;
      case 'new_group':
        _showNewGroupDialog();
        break;
      case 'security':
        _showSecuritySettings();
        break;
      case 'archive':
        _showArchivedChats();
        break;
      case 'export':
        _showExportDialog();
        break;
      case 'settings':
        _showSettings();
        break;
    }
  }

  void _showNewGroupDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Create New Group'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: InputDecoration(
                hintText: 'Group name (e.g., Bravo Squad)',
                prefixIcon: Icon(Icons.group),
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Select Members:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Create'),
          ),
        ],
      ),
    );
  }

  void _showSecuritySettings() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Security Settings'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              leading: Icon(Icons.lock),
              title: Text('End-to-End Encryption'),
              subtitle: Text('Enabled for all conversations'),
              trailing: Switch(value: true, onChanged: null),
            ),
            ListTile(
              leading: Icon(Icons.fingerprint),
              title: Text('Biometric Lock'),
              subtitle: Text('Require fingerprint to open'),
              trailing: Switch(value: false, onChanged: (val) {}),
            ),
            ListTile(
              leading: Icon(Icons.timer),
              title: Text('Auto-Delete Messages'),
              subtitle: Text('Delete after 24 hours'),
              trailing: Switch(value: false, onChanged: (val) {}),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showArchivedChats() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Archived Conversations'),
        content: Text('No archived conversations'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showExportDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Export Chat Logs'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Export conversations for official records'),
            SizedBox(height: 16),
            Row(
              children: [
                Icon(Icons.warning, color: Colors.orange),
                SizedBox(width: 8),
                Expanded(child: Text('Requires security clearance')),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Export'),
          ),
        ],
      ),
    );
  }

  void _showSettings() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Chat Settings'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.notifications),
              title: Text('Notifications'),
              trailing: Switch(value: true, onChanged: (val) {}),
            ),
            ListTile(
              leading: Icon(Icons.volume_up),
              title: Text('Sound'),
              trailing: Switch(value: true, onChanged: (val) {}),
            ),
            ListTile(
              leading: Icon(Icons.backup),
              title: Text('Backup Chats'),
              trailing: Switch(value: false, onChanged: (val) {}),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showNewChatDialog() {
    final List<String> availableContacts = [
      'Major Rodriguez',
      'Captain Thompson',
      'Sgt. Martinez',
      'Lt. Colonel Davis',
      'Corporal Wilson',
      'General Hayes',
      'Bravo Team',
      'Charlie Squad',
      'Delta Force',
    ];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Start New Conversation'),
        content: SizedBox(
          width: double.maxFinite,
          height: 300,
          child: Column(
            children: [
              TextField(
                decoration: InputDecoration(
                  hintText: 'Search personnel...',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              SizedBox(height: 16),
              Expanded(
                child: ListView.builder(
                  itemCount: availableContacts.length,
                  itemBuilder: (context, index) {
                    final contact = availableContacts[index];
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.grey[400],
                        child: Text(
                          contact.split(' ').map((e) => e[0]).take(2).join(),
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        ),
                      ),
                      title: Text(contact),
                      subtitle: Text(
                        contact.contains('Team') ||
                                contact.contains('Squad') ||
                                contact.contains('Force')
                            ? 'Group Chat'
                            : 'Individual',
                      ),
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                IndividualChatPage(contactName: contact),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Messages"),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              _handleMenuSelection('search');
            },
          ),
          PopupMenuButton<String>(
            icon: Icon(Icons.more_vert),
            onSelected: (String value) {
              _handleMenuSelection(value);
            },
            itemBuilder: (BuildContext context) => [
              PopupMenuItem(
                value: 'search',
                child: Row(
                  children: [
                    Icon(Icons.search, size: 20),
                    SizedBox(width: 8),
                    Text('Search Conversations'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'new_group',
                child: Row(
                  children: [
                    Icon(Icons.group_add, size: 20),
                    SizedBox(width: 8),
                    Text('New Group Chat'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'security',
                child: Row(
                  children: [
                    Icon(Icons.security, size: 20),
                    SizedBox(width: 8),
                    Text('Security Settings'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'archive',
                child: Row(
                  children: [
                    Icon(Icons.archive, size: 20),
                    SizedBox(width: 8),
                    Text('Archived Chats'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'export',
                child: Row(
                  children: [
                    Icon(Icons.download, size: 20),
                    SizedBox(width: 8),
                    Text('Export Logs'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'settings',
                child: Row(
                  children: [
                    Icon(Icons.settings, size: 20),
                    SizedBox(width: 8),
                    Text('Settings'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: _chatContacts.length,
        itemBuilder: (context, index) {
          final contact = _chatContacts[index];
          return _buildChatTile(contact);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showNewChatDialog();
        },
        backgroundColor: Colors.green,
        child: Icon(Icons.message, color: Colors.white),
      ),
    );
  }

  Widget _buildChatTile(ChatContact contact) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => IndividualChatPage(contactName: contact.name),
          ),
        );
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Colors.grey[200]!, width: 0.5),
          ),
        ),
        child: Row(
          children: [
            Stack(
              children: [
                CircleAvatar(
                  radius: 25,
                  backgroundColor: Colors.grey[400],
                  child: Text(
                    contact.name.split(' ').map((e) => e[0]).take(2).join(),
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                if (contact.isOnline)
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 14,
                      height: 14,
                      decoration: BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                    ),
                  ),
              ],
            ),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        contact.name,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        contact.time,
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                  SizedBox(height: 4),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          contact.lastMessage,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (contact.unreadCount > 0) ...[
                        SizedBox(width: 8),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            contact.unreadCount.toString(),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ChatContact {
  final String name;
  final String lastMessage;
  final String time;
  final int unreadCount;
  final bool isOnline;

  ChatContact({
    required this.name,
    required this.lastMessage,
    required this.time,
    required this.unreadCount,
    required this.isOnline,
  });
}

class IndividualChatPage extends StatefulWidget {
  final String contactName;

  const IndividualChatPage({required this.contactName, super.key});

  @override
  IndividualChatPageState createState() => IndividualChatPageState();
}

class IndividualChatPageState extends State<IndividualChatPage> {
  final TextEditingController _messageController = TextEditingController();
  late List<ChatMessage> _messages;

  @override
  void initState() {
    super.initState();
    _messages = _getMessagesForContact(widget.contactName);
  }

  List<ChatMessage> _getMessagesForContact(String contactName) {
    switch (contactName) {
      case "Col. Anderson":
        return [
          ChatMessage(
            text: "Good morning, Colonel",
            isMe: true,
            timestamp: DateTime.now().subtract(Duration(hours: 2)),
          ),
          ChatMessage(
            text: "Morning soldier. Mission briefing at 0800 hours",
            isMe: false,
            timestamp: DateTime.now().subtract(Duration(hours: 1, minutes: 30)),
          ),
          ChatMessage(
            text: "Understood sir, all units ready",
            isMe: true,
            timestamp: DateTime.now().subtract(Duration(hours: 1)),
          ),
        ];
      case "Sgt. Williams":
        return [
          ChatMessage(
            text: "Equipment check status?",
            isMe: false,
            timestamp: DateTime.now().subtract(Duration(hours: 3)),
          ),
          ChatMessage(
            text: "Equipment check completed",
            isMe: true,
            timestamp: DateTime.now().subtract(Duration(hours: 2, minutes: 45)),
          ),
          ChatMessage(
            text: "All systems operational",
            isMe: true,
            timestamp: DateTime.now().subtract(Duration(hours: 2, minutes: 30)),
          ),
        ];
      case "Alpha Team":
        return [
          ChatMessage(
            text: "Team Alpha, status report",
            isMe: false,
            timestamp: DateTime.now().subtract(Duration(days: 1, hours: 2)),
          ),
          ChatMessage(
            text: "Alpha 1 - Ready for deployment",
            isMe: false,
            timestamp: DateTime.now().subtract(Duration(days: 1, hours: 1)),
          ),
          ChatMessage(
            text: "Alpha 2 - Standing by",
            isMe: false,
            timestamp: DateTime.now().subtract(Duration(days: 1, minutes: 50)),
          ),
          ChatMessage(
            text: "Ready for deployment",
            isMe: true,
            timestamp: DateTime.now().subtract(Duration(days: 1, minutes: 30)),
          ),
        ];
      case "Lt. Johnson":
        return [
          ChatMessage(
            text: "Orders received and understood",
            isMe: false,
            timestamp: DateTime.now().subtract(Duration(days: 1, hours: 4)),
          ),
          ChatMessage(
            text: "Roger that, standing by",
            isMe: false,
            timestamp: DateTime.now().subtract(Duration(days: 1, hours: 3)),
          ),
          ChatMessage(
            text: "Maintain position until further notice",
            isMe: true,
            timestamp: DateTime.now().subtract(Duration(days: 1, hours: 2)),
          ),
        ];
      case "Command Center":
        return [
          ChatMessage(
            text: "All units report status",
            isMe: false,
            timestamp: DateTime.now().subtract(Duration(days: 2)),
          ),
          ChatMessage(
            text: "Unit 1 - Operational",
            isMe: true,
            timestamp: DateTime.now().subtract(Duration(days: 2, hours: 23)),
          ),
          ChatMessage(
            text: "Copy that. Maintain readiness",
            isMe: false,
            timestamp: DateTime.now().subtract(Duration(days: 2, hours: 22)),
          ),
        ];
      default:
        return [];
    }
  }

  void _sendMessage() {
    if (_messageController.text.trim().isNotEmpty) {
      setState(() {
        _messages.add(
          ChatMessage(
            text: _messageController.text.trim(),
            isMe: true,
            timestamp: DateTime.now(),
          ),
        );
      });
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              radius: 16,
              backgroundColor: Colors.grey[400],
              child: Text(
                widget.contactName.split(' ').map((e) => e[0]).take(2).join(),
                style: TextStyle(color: Colors.white, fontSize: 12),
              ),
            ),
            SizedBox(width: 8),
            Text(widget.contactName),
          ],
        ),
        actions: [
          IconButton(icon: Icon(Icons.call), onPressed: () {}),
          IconButton(icon: Icon(Icons.more_vert), onPressed: () {}),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: _messages.isEmpty
                ? Center(
                    child: Text(
                      "Start your conversation with ${widget.contactName}",
                      style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                    ),
                  )
                : ListView.builder(
                    reverse: true,
                    itemCount: _messages.length,
                    itemBuilder: (context, index) {
                      final message = _messages[_messages.length - 1 - index];
                      return _buildMessageBubble(message);
                    },
                  ),
          ),
          Container(
            padding: EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: Colors.grey[300]!)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Type a message...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.grey[100],
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                SizedBox(width: 8),
                CircleAvatar(
                  backgroundColor: Colors.green,
                  child: IconButton(
                    icon: Icon(Icons.send, color: Colors.white),
                    onPressed: _sendMessage,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage message) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Row(
        mainAxisAlignment: message.isMe
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        children: [
          Flexible(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: message.isMe ? Colors.green : Colors.grey[300],
                borderRadius: BorderRadius.circular(18),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    message.text,
                    style: TextStyle(
                      color: message.isMe ? Colors.white : Colors.black87,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    _formatTime(message.timestamp),
                    style: TextStyle(
                      color: message.isMe ? Colors.white70 : Colors.grey[600],
                      fontSize: 12,
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

  String _formatTime(DateTime timestamp) {
    return "${timestamp.hour.toString().padLeft(2, '0')}:${timestamp.minute.toString().padLeft(2, '0')}";
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }
}

class ChatMessage {
  final String text;
  final bool isMe;
  final DateTime timestamp;

  ChatMessage({
    required this.text,
    required this.isMe,
    required this.timestamp,
  });
}
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

// # MODELS
// =================================================================================================
class TodoItem {
  String id;
  String title;
  DateTime dueDate;
  TimeOfDay time;
  String category;
  String type;
  bool isDone;

  TodoItem({
    String? id,
    required this.title,
    required this.dueDate,
    required this.time,
    required this.category,
    required this.type,
    this.isDone = false,
  }) : id = id ?? DateTime.now().toIso8601String();

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'dueDate': dueDate.toIso8601String(),
    'timeHour': time.hour,
    'timeMinute': time.minute,
    'category': category,
    'type': type,
    'isDone': isDone,
  };

  static TodoItem fromJson(Map<String, dynamic> json) => TodoItem(
    id: json['id'],
    title: json['title'],
    dueDate: DateTime.parse(json['dueDate']),
    time: TimeOfDay(hour: json['timeHour'], minute: json['timeMinute']),
    category: json['category'],
    type: json['type'],
    isDone: json['isDone'],
  );
}

// # WIDGETS
// =================================================================================================
class TodoPage extends StatefulWidget {
  const TodoPage({Key? key}) : super(key: key);

  @override
  State<TodoPage> createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  List<TodoItem> tasks = [];

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final tasksJson = prefs.getString('tasks');
    if (tasksJson != null) {
      final List<dynamic> jsonList = jsonDecode(tasksJson);
      setState(() {
        tasks = jsonList.map((item) => TodoItem.fromJson(item)).toList();
      });
    }
  }

  Future<void> _saveTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final List<Map<String, dynamic>> jsonList = tasks
        .map((item) => item.toJson())
        .toList();
    await prefs.setString('tasks', jsonEncode(jsonList));
  }

  void _showTodoDialog({TodoItem? task}) {
    final isEditing = task != null;
    final titleController = TextEditingController(text: task?.title);
    DateTime? selectedDate = task?.dueDate;
    TimeOfDay? selectedTime = task?.time;
    String? selectedCategory = task?.category;
    String? selectedType = task?.type;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext ctx) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(ctx).viewInsets.bottom,
                left: 20,
                right: 20,
                top: 20,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      isEditing ? 'Edit Task' : 'Add Task',
                      style: Theme.of(context).textTheme.headlineLarge,
                    ),
                    SizedBox(height: 20),
                    TextField(
                      controller: titleController,
                      decoration: InputDecoration(labelText: 'Task Title'),
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            icon: Icon(Icons.calendar_today),
                            label: Text(
                              selectedDate == null
                                  ? 'Pick Due Date'
                                  : '${selectedDate!.toLocal()}'.split(' ')[0],
                            ),
                            onPressed: () async {
                              DateTime? picked = await showDatePicker(
                                context: context,
                                initialDate: selectedDate ?? DateTime.now(),
                                firstDate: DateTime(2020),
                                lastDate: DateTime(2100),
                              );
                              if (picked != null) {
                                setModalState(() => selectedDate = picked);
                              }
                            },
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: ElevatedButton.icon(
                            icon: Icon(Icons.access_time),
                            label: Text(
                              selectedTime == null
                                  ? 'Pick Time'
                                  : selectedTime!.format(context),
                            ),
                            onPressed: () async {
                              TimeOfDay? picked = await showTimePicker(
                                context: context,
                                initialTime: selectedTime ?? TimeOfDay.now(),
                              );
                              if (picked != null) {
                                setModalState(() => selectedTime = picked);
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    DropdownButtonFormField<String>(
                      value: selectedCategory,
                      decoration: InputDecoration(labelText: "Category"),
                      items: ['Training', 'Medical', 'Logistics', 'Admin']
                          .map(
                            (category) => DropdownMenuItem<String>(
                              value: category,
                              child: Text(category),
                            ),
                          )
                          .toList(),
                      onChanged: (value) =>
                          setModalState(() => selectedCategory = value),
                    ),
                    SizedBox(height: 10),
                    DropdownButtonFormField<String>(
                      value: selectedType,
                      decoration: InputDecoration(labelText: "Type"),
                      items: ['Urgent', 'Routine', 'Optional']
                          .map(
                            (type) => DropdownMenuItem<String>(
                              value: type,
                              child: Text(type),
                            ),
                          )
                          .toList(),
                      onChanged: (value) =>
                          setModalState(() => selectedType = value),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      child: Text(isEditing ? "Update Task" : "Save Task"),
                      onPressed: () {
                        if (titleController.text.isEmpty ||
                            selectedDate == null ||
                            selectedTime == null ||
                            selectedCategory == null ||
                            selectedType == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("Please fill all fields."),
                              backgroundColor: Colors.red,
                            ),
                          );
                          return;
                        }

                        if (isEditing) {
                          final index = tasks.indexWhere(
                            (element) => element.id == task.id,
                          );
                          if (index != -1) {
                            // Update the main page state, not modal state
                            setState(() {
                              tasks[index] = TodoItem(
                                id: task.id,
                                title: titleController.text,
                                dueDate: selectedDate!,
                                time: selectedTime!,
                                category: selectedCategory!,
                                type: selectedType!,
                                isDone: task.isDone,
                              );
                            });
                          }
                        } else {
                          final newTask = TodoItem(
                            title: titleController.text,
                            dueDate: selectedDate!,
                            time: selectedTime!,
                            category: selectedCategory!,
                            type: selectedType!,
                          );
                          // Update the main page state, not modal state
                          setState(() => tasks.add(newTask));
                        }

                        _saveTasks();
                        Navigator.of(ctx).pop();
                      },
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _deleteTask(String id) {
    setState(() {
      tasks.removeWhere((task) => task.id == id);
    });
    _saveTasks();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Task deleted."), backgroundColor: Colors.green),
    );
  }

  Widget _buildTaskCard(TodoItem item) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
      elevation: 3,
      child: ListTile(
        leading: Checkbox(
          value: item.isDone,
          onChanged: (value) {
            setState(() => item.isDone = value!);
            _saveTasks();
          },
        ),
        title: Text(
          item.title,
          style: TextStyle(
            decoration: item.isDone ? TextDecoration.lineThrough : null,
          ),
        ),
        subtitle: Text(
          'Due: ${item.dueDate.toLocal().toString().split(' ')[0]}, Time: ${item.time.format(context)}\nCategory: ${item.category} | Type: ${item.type}',
        ),
        isThreeLine: true,
        trailing: PopupMenuButton<String>(
          onSelected: (value) {
            if (value == 'edit') {
              _showTodoDialog(task: item);
            } else if (value == 'delete') {
              _deleteTask(item.id);
            }
          },
          itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
            const PopupMenuItem<String>(value: 'edit', child: Text('Edit')),
            const PopupMenuItem<String>(value: 'delete', child: Text('Delete')),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("To-Do List"), centerTitle: true),
      body: tasks.isEmpty
          ? Center(child: Text("No tasks added yet."))
          : ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (ctx, i) => _buildTaskCard(tasks[i]),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showTodoDialog(),
        child: Icon(Icons.add),
      ),
    );
  }
}
import 'package:flutter/material.dart';

class ReportGenerationPage extends StatefulWidget {
  const ReportGenerationPage({super.key});

  @override
  ReportGenerationPageState createState() => ReportGenerationPageState();
}

class ReportGenerationPageState extends State<ReportGenerationPage> {
  String selectedReportType = 'Parade State Report';
  final TextEditingController titleController = TextEditingController();
  final TextEditingController contentController = TextEditingController();

  // Additional controllers for specific report fields
  final TextEditingController unitController = TextEditingController();
  final TextEditingController commanderController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController timeController = TextEditingController();
  final TextEditingController locationController = TextEditingController();

  final List<String> reportTypes = [
    'Parade State Report',
    'Firing Report',
    'Medical Report',
    'Training Report',
    'Incident Report',
    'Equipment Status Report',
    'Duty Roster Report',
    'General Report',
  ];

  @override
  void initState() {
    super.initState();
    _updateReportTemplate();
  }

  void _updateReportTemplate() {
    setState(() {
      switch (selectedReportType) {
        case 'Parade State Report':
          titleController.text = 'Daily Parade State Report';
          contentController.text =
              '''UNIT: ${unitController.text}
DATE: ${dateController.text}
TIME: ${timeController.text}

STRENGTH:
- Officers Present: ___
- JCOs Present: ___
- ORs Present: ___
- Total Present: ___
- On Leave: ___
- Sick: ___
- Detachment: ___

REMARKS:
${contentController.text.isEmpty ? 'Enter additional remarks here...' : contentController.text}

SUBMITTED BY:
Name: ${commanderController.text}
Rank: ___
Signature: ___''';
          break;

        case 'Firing Report':
          titleController.text = 'Weapon Firing Report';
          contentController.text =
              '''UNIT: ${unitController.text}
DATE: ${dateController.text}
LOCATION: ${locationController.text}

FIRING DETAILS:
- Weapon Type: ___
- Ammunition Used: ___
- Rounds Fired: ___
- Target Distance: ___
- Weather Conditions: ___

PARTICIPANTS:
- Total Personnel: ___
- Qualified: ___
- Unqualified: ___

SAFETY MEASURES:
- Range Safety Officer: ___
- Medical Support: ___
- Ammunition Account: ___

REMARKS:
${contentController.text.isEmpty ? 'Enter firing results and observations...' : contentController.text}

SUBMITTED BY:
Name: ${commanderController.text}
Rank: ___
Signature: ___''';
          break;

        case 'Medical Report':
          titleController.text = 'Medical Status Report';
          contentController.text =
              '''UNIT: ${unitController.text}
DATE: ${dateController.text}
MEDICAL OFFICER: ${commanderController.text}

MEDICAL STATUS:
- Total Personnel: ___
- Fit for Duty: ___
- Sick in Quarter: ___
- Hospitalized: ___
- Medical Leave: ___

MEDICAL CASES:
- New Cases: ___
- Ongoing Treatment: ___
- RTU (Return to Unit): ___
- Referred to Hospital: ___

MEDICAL INSPECTIONS:
- Routine Check-ups: ___
- Vaccination Status: ___
- Health Education: ___

REMARKS:
${contentController.text.isEmpty ? 'Enter medical observations and recommendations...' : contentController.text}

SUBMITTED BY:
Medical Officer: ${commanderController.text}
Signature: ___''';
          break;

        case 'Training Report':
          titleController.text = 'Training Activity Report';
          contentController.text =
              '''UNIT: ${unitController.text}
DATE: ${dateController.text}
TRAINING LOCATION: ${locationController.text}

TRAINING DETAILS:
- Training Subject: ___
- Duration: ___
- Instructor: ___
- Participants: ___

TRAINING OBJECTIVES:
- Objective 1: ___
- Objective 2: ___
- Objective 3: ___

PERFORMANCE ASSESSMENT:
- Excellent: ___
- Good: ___
- Satisfactory: ___
- Needs Improvement: ___

RESOURCES UTILIZED:
- Equipment: ___
- Ammunition/Stores: ___
- Training Aids: ___

REMARKS:
${contentController.text.isEmpty ? 'Enter training outcomes and recommendations...' : contentController.text}

SUBMITTED BY:
Training Officer: ${commanderController.text}
Signature: ___''';
          break;

        case 'Incident Report':
          titleController.text = 'Incident Report';
          contentController.text =
              '''UNIT: ${unitController.text}
DATE: ${dateController.text}
TIME: ${timeController.text}
LOCATION: ${locationController.text}

INCIDENT DETAILS:
- Type of Incident: ___
- Personnel Involved: ___
- Witnesses: ___
- Injuries/Casualties: ___

SEQUENCE OF EVENTS:
${contentController.text.isEmpty ? 'Describe the incident chronologically...' : contentController.text}

IMMEDIATE ACTIONS TAKEN:
- First Aid/Medical: ___
- Security Measures: ___
- Notification: ___
- Investigation: ___

RECOMMENDATIONS:
- Preventive Measures: ___
- Policy Changes: ___
- Training Requirements: ___

SUBMITTED BY:
Investigating Officer: ${commanderController.text}
Signature: ___''';
          break;

        case 'Equipment Status Report':
          titleController.text = 'Equipment Status Report';
          contentController.text =
              '''UNIT: ${unitController.text}
DATE: ${dateController.text}
EQUIPMENT OFFICER: ${commanderController.text}

EQUIPMENT STATUS:
- Total Equipment: ___
- Serviceable: ___
- Unserviceable: ___
- Under Repair: ___
- Condemned: ___

MAJOR EQUIPMENT:
- Vehicles: ___
- Weapons: ___
- Communication Equipment: ___
- Medical Equipment: ___

MAINTENANCE STATUS:
- Daily Maintenance: ___
- Periodic Maintenance: ___
- Overdue Maintenance: ___

REQUIREMENTS:
- Spare Parts: ___
- Technical Support: ___
- Replacement Equipment: ___

REMARKS:
${contentController.text.isEmpty ? 'Enter equipment observations and requirements...' : contentController.text}

SUBMITTED BY:
Equipment Officer: ${commanderController.text}
Signature: ___''';
          break;

        case 'Duty Roster Report':
          titleController.text = 'Duty Roster Report';
          contentController.text =
              '''UNIT: ${unitController.text}
DATE: ${dateController.text}
DUTY OFFICER: ${commanderController.text}

DUTY ASSIGNMENTS:
- Guard Duty: ___
- Orderly Duty: ___
- Piquet Duty: ___
- Special Duty: ___

DUTY PERFORMANCE:
- All Duties Covered: ___
- Reliefs on Time: ___
- Equipment Checked: ___
- Log Maintained: ___

INCIDENTS DURING DUTY:
${contentController.text.isEmpty ? 'Report any incidents or observations during duty hours...' : contentController.text}

NEXT DAY PREPARATION:
- Duty Personnel Briefed: ___
- Equipment Ready: ___
- Special Instructions: ___

SUBMITTED BY:
Duty Officer: ${commanderController.text}
Signature: ___''';
          break;

        default:
          titleController.text = 'General Report';
          contentController.text = 'Enter your report content here...';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text('Generate Report'),
        backgroundColor: Colors.green[800],
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Report Type Selection
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Report Type',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.green[800],
                    ),
                  ),
                  SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    value: selectedReportType,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                    ),
                    items: reportTypes.map((String type) {
                      return DropdownMenuItem<String>(
                        value: type,
                        child: Text(type),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedReportType = newValue!;
                        _updateReportTemplate();
                      });
                    },
                  ),
                ],
              ),
            ),

            SizedBox(height: 16),

            // Unit Information
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Unit Information',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.green[800],
                    ),
                  ),
                  SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: unitController,
                          decoration: InputDecoration(
                            labelText: 'Unit',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                          ),
                          onChanged: (value) => _updateReportTemplate(),
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: TextField(
                          controller: commanderController,
                          decoration: InputDecoration(
                            labelText: 'Officer Name',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                          ),
                          onChanged: (value) => _updateReportTemplate(),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: dateController,
                          decoration: InputDecoration(
                            labelText: 'Date',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            suffixIcon: Icon(Icons.calendar_today),
                          ),
                          onTap: () async {
                            DateTime? picked = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(2000),
                              lastDate: DateTime(2101),
                            );
                            if (picked != null) {
                              dateController.text =
                                  "${picked.day}/${picked.month}/${picked.year}";
                              _updateReportTemplate();
                            }
                          },
                          readOnly: true,
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: TextField(
                          controller: timeController,
                          decoration: InputDecoration(
                            labelText: 'Time',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            suffixIcon: Icon(Icons.access_time),
                          ),
                          onTap: () async {
                            TimeOfDay? picked = await showTimePicker(
                              context: context,
                              initialTime: TimeOfDay.now(),
                            );
                            if (picked != null) {
                              timeController.text = picked.format(context);
                              _updateReportTemplate();
                            }
                          },
                          readOnly: true,
                        ),
                      ),
                    ],
                  ),
                  if (selectedReportType == 'Firing Report' ||
                      selectedReportType == 'Training Report' ||
                      selectedReportType == 'Incident Report') ...[
                    SizedBox(height: 12),
                    TextField(
                      controller: locationController,
                      decoration: InputDecoration(
                        labelText: 'Location',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                      ),
                      onChanged: (value) => _updateReportTemplate(),
                    ),
                  ],
                ],
              ),
            ),

            SizedBox(height: 16),

            // Report Title
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Report Title',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.green[800],
                    ),
                  ),
                  SizedBox(height: 8),
                  TextField(
                    controller: titleController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 16),

            // Report Content
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Report Content',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.green[800],
                    ),
                  ),
                  SizedBox(height: 8),
                  Container(
                    height: 300,
                    child: TextField(
                      controller: contentController,
                      maxLines: null,
                      expands: true,
                      textAlignVertical: TextAlignVertical.top,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        contentPadding: EdgeInsets.all(12),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 24),

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[600],
                      foregroundColor: Colors.white,
                      minimumSize: Size.fromHeight(50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () {
                      // Save as draft logic
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Report saved as draft!'),
                          backgroundColor: Colors.grey[700],
                        ),
                      );
                    },
                    icon: Icon(Icons.save),
                    label: Text('Save Draft'),
                  ),
                ),
                
