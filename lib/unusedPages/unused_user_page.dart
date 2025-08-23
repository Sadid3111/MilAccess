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
                SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green[800],
                      foregroundColor: Colors.white,
                      minimumSize: Size.fromHeight(50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () {
                      // Submit report logic
                      if (titleController.text.isEmpty ||
                          contentController.text.isEmpty ||
                          unitController.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Please fill in all required fields!',
                            ),
                            backgroundColor: Colors.red[600],
                          ),
                        );
                        return;
                      }

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Report submitted successfully to higher command!',
                          ),
                          backgroundColor: Colors.green[800],
                        ),
                      );

                      // Clear form or navigate back
                      Navigator.pop(context);
                    },
                    icon: Icon(Icons.send),
                    label: Text('Submit Report'),
                  ),
                ),
              ],
            ),

            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    titleController.dispose();
    contentController.dispose();
    unitController.dispose();
    commanderController.dispose();
    dateController.dispose();
    timeController.dispose();
    locationController.dispose();
    super.dispose();
  }
}
import 'package:flutter/material.dart';

class RequestLeavePage extends StatefulWidget {
  const RequestLeavePage({super.key});

  @override
  RequestLeavePageState createState() => RequestLeavePageState();
}

class RequestLeavePageState extends State<RequestLeavePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Form controllers
  final TextEditingController _reasonController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();
  final TextEditingController _emergencyContactController =
      TextEditingController();
  final TextEditingController _additionalNotesController =
      TextEditingController();

  // Form data
  String selectedLeaveType = 'Annual Leave';
  DateTime? startDate;
  DateTime? endDate;
  String selectedDuration = 'Full Day';
  String selectedPriority = 'Normal';
  bool isEmergencyLeave = false;

  // Sample data for existing requests
  List<LeaveRequest> leaveRequests = [
    LeaveRequest(
      id: '1',
      type: 'Annual Leave',
      startDate: DateTime.now().add(Duration(days: 10)),
      endDate: DateTime.now().add(Duration(days: 12)),
      reason: 'Family vacation',
      status: 'Pending',
      submittedDate: DateTime.now().subtract(Duration(days: 2)),
      duration: 'Full Day',
      priority: 'Normal',
    ),
    LeaveRequest(
      id: '2',
      type: 'Sick Leave',
      startDate: DateTime.now().subtract(Duration(days: 5)),
      endDate: DateTime.now().subtract(Duration(days: 3)),
      reason: 'Medical treatment',
      status: 'Approved',
      submittedDate: DateTime.now().subtract(Duration(days: 7)),
      duration: 'Full Day',
      priority: 'High',
    ),
    LeaveRequest(
      id: '3',
      type: 'Emergency Leave',
      startDate: DateTime.now().subtract(Duration(days: 15)),
      endDate: DateTime.now().subtract(Duration(days: 14)),
      reason: 'Family emergency',
      status: 'Approved',
      submittedDate: DateTime.now().subtract(Duration(days: 16)),
      duration: 'Full Day',
      priority: 'Urgent',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _reasonController.dispose();
    _contactController.dispose();
    _emergencyContactController.dispose();
    _additionalNotesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Request Leave',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
        backgroundColor: Color.fromARGB(255, 170, 242, 153),
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.black,
          unselectedLabelColor: Colors.black54,
          indicatorColor: Colors.green[800],
          tabs: [
            Tab(icon: Icon(Icons.add_circle_outline), text: 'New Request'),
            Tab(icon: Icon(Icons.list_alt), text: 'My Requests'),
            Tab(icon: Icon(Icons.info_outline), text: 'Leave Balance'),
          ],
        ),
      ),
      body: Container(
        color: Color.fromARGB(255, 170, 242, 153),
        child: TabBarView(
          controller: _tabController,
          children: [
            _buildNewRequestTab(),
            _buildMyRequestsTab(),
            _buildLeaveBalanceTab(),
          ],
        ),
      ),
    );
  }

  Widget _buildNewRequestTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Quick Leave Type Selection
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 6,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.schedule, color: Colors.green[800]),
                    SizedBox(width: 8),
                    Text(
                      'Quick Leave Types',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _buildQuickLeaveChip(
                      'Annual Leave',
                      Icons.beach_access,
                      Colors.blue,
                    ),
                    _buildQuickLeaveChip(
                      'Sick Leave',
                      Icons.local_hospital,
                      Colors.red,
                    ),
                    _buildQuickLeaveChip(
                      'Emergency Leave',
                      Icons.warning,
                      Colors.orange,
                    ),
                    _buildQuickLeaveChip(
                      'Maternity Leave',
                      Icons.child_care,
                      Colors.pink,
                    ),
                    _buildQuickLeaveChip(
                      'Training Leave',
                      Icons.school,
                      Colors.purple,
                    ),
                    _buildQuickLeaveChip(
                      'Casual Leave',
                      Icons.school,
                      Colors.green,
                    ),
                    _buildQuickLeaveChip(
                      'Other',
                      Icons.more_horiz,
                      Colors.grey,
                    ),
                  ],
                ),
              ],
            ),
          ),

          SizedBox(height: 16),

          // Main Form
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 6,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Leave Request Details',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.green[800],
                  ),
                ),
                SizedBox(height: 16),

                // Emergency Leave Toggle
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isEmergencyLeave ? Colors.red[50] : Colors.grey[50],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isEmergencyLeave ? Colors.red : Colors.grey[300]!,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.emergency,
                        color: isEmergencyLeave ? Colors.red : Colors.grey,
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Emergency Leave Request',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: isEmergencyLeave
                                ? Colors.red[800]
                                : Colors.grey[700],
                          ),
                        ),
                      ),
                      Switch(
                        value: isEmergencyLeave,
                        onChanged: (value) {
                          setState(() {
                            isEmergencyLeave = value;
                            if (value) {
                              selectedLeaveType = 'Emergency Leave';
                              selectedPriority = 'Urgent';
                            }
                          });
                        },
                        activeColor: Colors.red,
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 16),

                // Leave Type Dropdown
                DropdownButtonFormField<String>(
                  value: selectedLeaveType,
                  decoration: InputDecoration(
                    labelText: 'Leave Type',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    prefixIcon: Icon(Icons.category),
                  ),
                  items:
                      [
                            'Annual Leave',
                            'Sick Leave',
                            'Emergency Leave',
                            'Maternity Leave',
                            'Paternity Leave',
                            'Training Leave',
                            'Casual Leave',
                            'Compassionate Leave',
                            'Other',
                          ]
                          .map(
                            (type) => DropdownMenuItem(
                              value: type,
                              child: Text(type),
                            ),
                          )
                          .toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedLeaveType = value!;
                    });
                  },
                ),

                SizedBox(height: 16),

                // Date Selection
                Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () => _selectStartDate(context),
                        child: Container(
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey[400]!),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Start Date',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                ),
                              ),
                              SizedBox(height: 4),
                              Row(
                                children: [
                                  Icon(Icons.calendar_today, size: 18),
                                  SizedBox(width: 8),
                                  Text(
                                    startDate != null
                                        ? '${startDate!.day}/${startDate!.month}/${startDate!.year}'
                                        : 'Select Date',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: InkWell(
                        onTap: () => _selectEndDate(context),
                        child: Container(
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey[400]!),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'End Date',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                ),
                              ),
                              SizedBox(height: 4),
                              Row(
                                children: [
                                  Icon(Icons.calendar_today, size: 18),
                                  SizedBox(width: 8),
                                  Text(
                                    endDate != null
                                        ? '${endDate!.day}/${endDate!.month}/${endDate!.year}'
                                        : 'Select Date',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 16),

                // Duration and Priority
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: selectedDuration,
                        decoration: InputDecoration(
                          labelText: 'Duration',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          prefixIcon: Icon(Icons.access_time),
                        ),
                        items:
                            [
                                  'Full Day',
                                  'Half Day - Morning',
                                  'Half Day - Afternoon',
                                  'Custom Hours',
                                ]
                                .map(
                                  (duration) => DropdownMenuItem(
                                    value: duration,
                                    child: Text(duration),
                                  ),
                                )
                                .toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedDuration = value!;
                          });
                        },
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: selectedPriority,
                        decoration: InputDecoration(
                          labelText: 'Priority',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          prefixIcon: Icon(Icons.priority_high),
                        ),
                        items: ['Normal', 'High', 'Urgent']
                            .map(
                              (priority) => DropdownMenuItem(
                                value: priority,
                                child: Text(priority),
                              ),
                            )
                            .toList(),
                        onChanged: isEmergencyLeave
                            ? null
                            : (value) {
                                setState(() {
                                  selectedPriority = value!;
                                });
                              },
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 16),

                // Reason
                TextField(
                  controller: _reasonController,
                  decoration: InputDecoration(
                    labelText: 'Reason for Leave',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    prefixIcon: Icon(Icons.description),
                    hintText: 'Please provide a detailed reason...',
                  ),
                  maxLines: 3,
                ),

                SizedBox(height: 16),

                // Contact Information
                TextField(
                  controller: _contactController,
                  decoration: InputDecoration(
                    labelText: 'Contact Number During Leave',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    prefixIcon: Icon(Icons.phone),
                    hintText: '+880XXXXXXXXX',
                  ),
                  keyboardType: TextInputType.phone,
                ),

                SizedBox(height: 16),

                // Emergency Contact (if emergency leave)
                if (isEmergencyLeave)
                  Column(
                    children: [
                      TextField(
                        controller: _emergencyContactController,
                        decoration: InputDecoration(
                          labelText: 'Emergency Contact Person',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          prefixIcon: Icon(Icons.contact_emergency),
                          hintText: 'Name and contact details',
                        ),
                      ),
                      SizedBox(height: 16),
                    ],
                  ),

                // Additional Notes
                TextField(
                  controller: _additionalNotesController,
                  decoration: InputDecoration(
                    labelText: 'Additional Notes (Optional)',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    prefixIcon: Icon(Icons.note),
                    hintText: 'Any additional information...',
                  ),
                  maxLines: 2,
                ),

                SizedBox(height: 24),

                // Submit Button
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _submitLeaveRequest,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isEmergencyLeave
                          ? Colors.red[600]
                          : Colors.green[800],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          isEmergencyLeave ? Icons.emergency : Icons.send,
                          color: Colors.white,
                        ),
                        SizedBox(width: 8),
                        Text(
                          isEmergencyLeave
                              ? 'Submit Emergency Request'
                              : 'Submit Leave Request',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickLeaveChip(String type, IconData icon, Color color) {
    bool isSelected = selectedLeaveType == type;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedLeaveType = type;
          if (type == 'Emergency Leave') {
            isEmergencyLeave = true;
            selectedPriority = 'Urgent';
          }
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? color.withOpacity(0.2) : Colors.grey[100],
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? color : Colors.grey[300]!,
            width: 2,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: isSelected ? color : Colors.grey[600]),
            SizedBox(width: 6),
            Text(
              type,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: isSelected ? color : Colors.grey[700],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMyRequestsTab() {
    return ListView(
      padding: EdgeInsets.all(16),
      children: [
        // Summary Cards
        Row(
          children: [
            Expanded(
              child: _buildSummaryCard(
                'Pending',
                leaveRequests
                    .where((r) => r.status == 'Pending')
                    .length
                    .toString(),
                Icons.pending_actions,
                Colors.orange,
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: _buildSummaryCard(
                'Approved',
                leaveRequests
                    .where((r) => r.status == 'Approved')
                    .length
                    .toString(),
                Icons.check_circle,
                Colors.green,
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: _buildSummaryCard(
                'Rejected',
                leaveRequests
                    .where((r) => r.status == 'Rejected')
                    .length
                    .toString(),
                Icons.cancel,
                Colors.red,
              ),
            ),
          ],
        ),

        SizedBox(height: 16),

        // Requests List
        ...leaveRequests.map((request) => _buildRequestCard(request)).toList(),
      ],
    );
  }

  Widget _buildSummaryCard(
    String title,
    String count,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 6,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 28),
          SizedBox(height: 8),
          Text(
            count,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(title, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
        ],
      ),
    );
  }

  Widget _buildRequestCard(LeaveRequest request) {
    Color statusColor = _getStatusColor(request.status);

    return Container(
      margin: EdgeInsets.only(bottom: 12),
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border(left: BorderSide(color: statusColor, width: 4)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      request.type,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      request.status,
                      style: TextStyle(
                        fontSize: 10,
                        color: statusColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),
              Text(
                request.reason,
                style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 12),
              Row(
                children: [
                  Icon(Icons.calendar_today, size: 14, color: Colors.grey[600]),
                  SizedBox(width: 4),
                  Text(
                    '${_formatDate(request.startDate)} - ${_formatDate(request.endDate)}',
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                  Spacer(),
                  Icon(Icons.access_time, size: 14, color: Colors.grey[600]),
                  SizedBox(width: 4),
                  Text(
                    _calculateDays(request.startDate, request.endDate),
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                ],
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  Text(
                    'Submitted: ${_formatDate(request.submittedDate)}',
                    style: TextStyle(fontSize: 10, color: Colors.grey[500]),
                  ),
                  Spacer(),
                  if (request.status == 'Pending')
                    TextButton(
                      onPressed: () => _showCancelDialog(request),
                      child: Text(
                        'Cancel',
                        style: TextStyle(color: Colors.red, fontSize: 12),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLeaveBalanceTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          // Leave Balance Overview
          Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                Text(
                  'Annual Leave Balance',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.green[800],
                  ),
                ),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildBalanceItem('Total', '30', Colors.blue),
                    Container(width: 1, height: 40, color: Colors.grey[300]),
                    _buildBalanceItem('Used', '8', Colors.red),
                    Container(width: 1, height: 40, color: Colors.grey[300]),
                    _buildBalanceItem('Remaining', '22', Colors.green),
                  ],
                ),
              ],
            ),
          ),

          SizedBox(height: 16),

          // Leave Types Breakdown
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 6,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Leave Types & Entitlements',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 16),
                _buildLeaveTypeItem('Annual Leave', '22', '30', Colors.blue),
                _buildLeaveTypeItem('Sick Leave', '12', '15', Colors.red),
                _buildLeaveTypeItem('Emergency Leave', '3', '5', Colors.orange),
                _buildLeaveTypeItem('Training Leave', '5', '10', Colors.purple),
                _buildLeaveTypeItem('Casual Leave', '5', '10', Colors.green),
              ],
            ),
          ),

          SizedBox(height: 16),

          // Leave Policy Info
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blue[50],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.blue[200]!),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.info, color: Colors.blue[800]),
                    SizedBox(width: 8),
                    Text(
                      'Leave Policy Information',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue[800],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12),
                _buildPolicyItem(
                  '• Annual leave must be applied 7 days in advance',
                ),
                _buildPolicyItem(
                  '• Emergency leave can be applied retrospectively',
                ),
                _buildPolicyItem(
                  '• Medical certificates required for sick leave > 3 days',
                ),
                _buildPolicyItem(
                  '• Leave balance resets annually on January 1st',
                ),
                _buildPolicyItem(
                  '• Maximum 15 consecutive days without special approval',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBalanceItem(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
      ],
    );
  }

  Widget _buildLeaveTypeItem(
    String type,
    String remaining,
    String total,
    Color color,
  ) {
    double percentage = double.parse(remaining) / double.parse(total);

    return Container(
      margin: EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                type,
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
              Text(
                '$remaining/$total days',
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
            ],
          ),
          SizedBox(height: 4),
          LinearProgressIndicator(
            value: percentage,
            backgroundColor: Colors.grey[200],
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ],
      ),
    );
  }

  Widget _buildPolicyItem(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 4),
      child: Text(
        text,
        style: TextStyle(fontSize: 12, color: Colors.blue[700]),
      ),
    );
  }

  Future<void> _selectStartDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: startDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 365)),
    );
    if (picked != null && picked != startDate) {
      setState(() {
        startDate = picked;
        if (endDate != null && endDate!.isBefore(picked)) {
          endDate = null;
        }
      });
    }
  }

  Future<void> _selectEndDate(BuildContext context) async {
    if (startDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please select start date first'),
          backgroundColor: Colors.red[800],
        ),
      );
      return;
    }

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: endDate ?? startDate!.add(Duration(days: 1)),
      firstDate: startDate!,
      lastDate: DateTime.now().add(Duration(days: 365)),
    );
    if (picked != null && picked != endDate) {
      setState(() {
        endDate = picked;
      });
    }
  }

  void _submitLeaveRequest() {
    if (_validateForm()) {
      setState(() {
        leaveRequests.add(
          LeaveRequest(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            type: selectedLeaveType,
            startDate: startDate!,
            endDate: endDate!,
            reason: _reasonController.text,
            status: 'Pending',
            submittedDate: DateTime.now(),
            duration: selectedDuration,
            priority: selectedPriority,
          ),
        );
      });

      // Clear form
      _clearForm();

      // Show success message
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              Icon(
                isEmergencyLeave ? Icons.emergency : Icons.check_circle,
                color: isEmergencyLeave ? Colors.red : Colors.green,
              ),
              SizedBox(width: 8),
              Text('Request Submitted'),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                isEmergencyLeave
                    ? 'Your emergency leave request has been submitted and will be processed immediately.'
                    : 'Your leave request has been submitted successfully and is pending approval.',
              ),
              SizedBox(height: 12),
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Request Summary:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 4),
                    Text('Type: $selectedLeaveType'),
                    Text('Duration: ${_calculateDays(startDate!, endDate!)}'),
                    Text('Priority: $selectedPriority'),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _tabController.animateTo(1); // Switch to My Requests tab
              },
              child: Text('View Requests'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green[800],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  bool _validateForm() {
    if (startDate == null) {
      _showErrorMessage('Please select start date');
      return false;
    }
    if (endDate == null) {
      _showErrorMessage('Please select end date');
      return false;
    }
    if (_reasonController.text.trim().isEmpty) {
      _showErrorMessage('Please provide reason for leave');
      return false;
    }
    if (_contactController.text.trim().isEmpty) {
      _showErrorMessage('Please provide contact number');
      return false;
    }
    if (isEmergencyLeave && _emergencyContactController.text.trim().isEmpty) {
      _showErrorMessage('Please provide emergency contact for emergency leave');
      return false;
    }
    return true;
  }

  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.error, color: Colors.white),
            SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.red[800],
      ),
    );
  }

  void _clearForm() {
    setState(() {
      selectedLeaveType = 'Annual Leave';
      startDate = null;
      endDate = null;
      selectedDuration = 'Full Day';
      selectedPriority = 'Normal';
      isEmergencyLeave = false;
    });
    _reasonController.clear();
    _contactController.clear();
    _emergencyContactController.clear();
    _additionalNotesController.clear();
  }

  void _showCancelDialog(LeaveRequest request) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(Icons.cancel, color: Colors.red),
            SizedBox(width: 8),
            Text('Cancel Request'),
          ],
        ),
        content: Text('Are you sure you want to cancel this leave request?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('No'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                leaveRequests.removeWhere((r) => r.id == request.id);
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Leave request cancelled successfully'),
                  backgroundColor: Colors.green[800],
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red[800],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text('Yes, Cancel'),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Colors.orange;
      case 'approved':
        return Colors.green;
      case 'rejected':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  String _calculateDays(DateTime start, DateTime end) {
    int days = end.difference(start).inDays + 1;
    return days == 1 ? '1 day' : '$days days';
  }
}

class LeaveRequest {
  final String id;
  final String type;
  final DateTime startDate;
  final DateTime endDate;
  final String reason;
  final String status;
  final DateTime submittedDate;
  final String duration;
  final String priority;

  LeaveRequest({
    required this.id,
    required this.type,
    required this.startDate,
    required this.endDate,
    required this.reason,
    required this.status,
    required this.submittedDate,
    required this.duration,
    required this.priority,
  });
}


    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          bookmarks.contains(currentPage)
              ? 'Page $currentPage bookmarked!'
              : 'Bookmark removed!',
        ),
        backgroundColor: Colors.green[800],
        duration: Duration(seconds: 1),
      ),
    );
  }

  void _showBookmarksList() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Bookmarks',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.green[800],
              ),
            ),
            SizedBox(height: 16),
            if (bookmarks.isEmpty)
              Center(
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Text(
                    'No bookmarks yet',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ),
              )
            else
              ...bookmarks.map(
                (page) => ListTile(
                  leading: Icon(Icons.bookmark, color: Colors.green[800]),
                  title: Text('Page $page'),
                  onTap: () {
                    pdfController?.setPage(page - 1);
                    Navigator.pop(context);
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _showTableOfContents() {
    // Sample table of contents - you can customize this based on your PDF
    List<Map<String, dynamic>> tableOfContents = [];

    if (widget.title.contains('JSSDM')) {
      tableOfContents = [
        {'title': 'Introduction', 'page': 1},
        {'title': 'Organization', 'page': 15},
        {'title': 'Command Structure', 'page': 30},
        {'title': 'Operations', 'page': 45},
        {'title': 'Logistics', 'page': 60},
        {'title': 'Communications', 'page': 75},
        {'title': 'Security', 'page': 90},
        {'title': 'Appendices', 'page': 105},
      ];
    } else if (widget.title.contains('Tactics')) {
      tableOfContents = [
        {'title': 'Basic Tactics', 'page': 1},
        {'title': 'Infantry Tactics', 'page': 20},
        {'title': 'Armored Operations', 'page': 40},
        {'title': 'Air Support', 'page': 60},
        {'title': 'Urban Warfare', 'page': 80},
        {'title': 'Special Operations', 'page': 100},
      ];
    } else {
      tableOfContents = [
        {'title': 'Chapter 1', 'page': 1},
        {'title': 'Chapter 2', 'page': 20},
        {'title': 'Chapter 3', 'page': 40},
        {'title': 'Chapter 4', 'page': 60},
        {'title': 'Chapter 5', 'page': 80},
      ];
    }

    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Table of Contents',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.green[800],
              ),
            ),
            SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: tableOfContents.length,
                itemBuilder: (context, index) {
                  final item = tableOfContents[index];
                  return ListTile(
                    leading: Icon(Icons.key, color: Colors.green[800]),
                    title: Text(item['title']),
                    trailing: Text('Page ${item['page']}'),
                    onTap: () {
                      pdfController?.setPage(item['page'] - 1);
                      Navigator.pop(context);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(widget.title, style: TextStyle(fontSize: 16)),
        backgroundColor: Colors.green[800],
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              setState(() {
                isSearchVisible = !isSearchVisible;
              });
            },
          ),
          IconButton(
            icon: Icon(
              bookmarks.contains(currentPage)
                  ? Icons.bookmark
                  : Icons.bookmark_border,
            ),
            onPressed: _toggleBookmark,
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              switch (value) {
                case 'bookmarks':
                  _showBookmarksList();
                  break;
                case 'contents':
                  _showTableOfContents();
                  break;
              }
            },
            itemBuilder: (BuildContext context) => [
              PopupMenuItem(
                value: 'contents',
                child: Row(
                  children: [
                    Icon(Icons.list, color: Colors.green[800]),
                    SizedBox(width: 8),
                    Text('Contents'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'bookmarks',
                child: Row(
                  children: [
                    Icon(Icons.bookmarks, color: Colors.green[800]),
                    SizedBox(width: 8),
                    Text('Bookmarks (${bookmarks.length})'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          // Search bar
          if (isSearchVisible)
            Container(
              padding: EdgeInsets.all(16),
              color: Colors.green[50],
              child: TextField(
                controller: searchController,
                decoration: InputDecoration(
                  hintText: 'Search in document...',
                  prefixIcon: Icon(Icons.search),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () {
                      setState(() {
                        isSearchVisible = false;
                        searchController.clear();
                      });
                    },
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
                onSubmitted: (query) {
                  // Implement search functionality here
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Search functionality coming soon!'),
                      backgroundColor: Colors.orange[700],
                    ),
                  );
                },
              ),
            ),

          // Progress bar
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: Colors.green[50],
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Page ${currentPage + 1} of $totalPages',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.green[800],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      'Progress: ${(readingProgress * 100).toInt()}%',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.green[800],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 4),
                LinearProgressIndicator(
                  value: readingProgress,
                  backgroundColor: Colors.grey[300],
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.green[800]!),
                ),
              ],
            ),
          ),

          // PDF Viewer
          Expanded(
            child: isLoading
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(color: Colors.green[800]),
                        SizedBox(height: 16),
                        Text(
                          'Loading PDF...',
                          style: TextStyle(color: Colors.green[800]),
                        ),
                      ],
                    ),
                  )
                : errorMessage.isNotEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: 64,
                          color: Colors.red[400],
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Error Loading PDF',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.red[700],
                          ),
                        ),
                        SizedBox(height: 8),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 32),
                          child: Text(
                            errorMessage,
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                        ),
                      ],
                    ),
                  )
                : PDFView(
                    filePath: localPath!,
                    enableSwipe: true,
                    swipeHorizontal: false,
                    autoSpacing: false,
                    pageFling: true,
                    pageSnap: true,
                    defaultPage: currentPage,
                    fitPolicy: FitPolicy.BOTH,
                    preventLinkNavigation: false,
                    onRender: (pages) {
                      setState(() {
                        totalPages = pages!;
                        isReady = true;
                      });
                    },
                    onError: (error) {
                      setState(() {
                        errorMessage = error.toString();
                      });
                    },
                    onPageError: (page, error) {
                      setState(() {
                        errorMessage = '$page: ${error.toString()}';
                      });
                    },
                    onViewCreated: (PDFViewController pdfViewController) {
                      pdfController = pdfViewController;
                    },
                    onLinkHandler: (String? uri) {
                      // Handle links in PDF
                    },
                    onPageChanged: (int? page, int? total) {
                      setState(() {
                        currentPage = page ?? 0;
                        readingProgress = totalPages > 0
                            ? (currentPage + 1) / totalPages
                            : 0.0;
                      });
                      _saveProgress();
                    },
                  ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              icon: Icon(Icons.first_page),
              onPressed: () => pdfController?.setPage(0),
              color: Colors.green[800],
            ),
            IconButton(
              icon: Icon(Icons.chevron_left),
              onPressed: currentPage > 0
                  ? () => pdfController?.setPage(currentPage - 1)
                  : null,
              color: Colors.green[800],
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.green[100],
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '${currentPage + 1}/$totalPages',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.green[800],
                ),
              ),
            ),
            IconButton(
              icon: Icon(Icons.chevron_right),
              onPressed: currentPage < totalPages - 1
                  ? () => pdfController?.setPage(currentPage + 1)
                  : null,
              color: Colors.green[800],
            ),
            IconButton(
              icon: Icon(Icons.last_page),
              onPressed: () => pdfController?.setPage(totalPages - 1),
              color: Colors.green[800],
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
}
// notification_settings_page.dart
import 'package:flutter/material.dart';

class NotificationSettingsPage extends StatefulWidget {
  const NotificationSettingsPage({super.key});

  @override
  State<NotificationSettingsPage> createState() =>
      _NotificationSettingsPageState();
}

class _NotificationSettingsPageState extends State<NotificationSettingsPage> {
  bool _pushNotifications = true;
  bool _emailNotifications = false;
  bool _smsNotifications = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notification Settings'),
        backgroundColor: Colors.green[800],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          const Text(
            'Manage Notifications',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),

          SwitchListTile(
            title: const Text('Push Notifications'),
            subtitle: const Text('Enable or disable push notifications'),
            value: _pushNotifications,
            onChanged: (bool value) {
              setState(() {
                _pushNotifications = value;
              });
            },
            activeColor: Colors.green,
          ),
          const Divider(),

          SwitchListTile(
            title: const Text('Email Notifications'),
            subtitle: const Text('Receive notifications via email'),
            value: _emailNotifications,
            onChanged: (bool value) {
              setState(() {
                _emailNotifications = value;
              });
            },
            activeColor: Colors.green,
          ),
          const Divider(),

          SwitchListTile(
            title: const Text('SMS Notifications'),
            subtitle: const Text('Receive notifications via SMS'),
            value: _smsNotifications,
            onChanged: (bool value) {
              setState(() {
                _smsNotifications = value;
              });
            },
            activeColor: Colors.green,
          ),
          const Divider(),

          const SizedBox(height: 30),
          ElevatedButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Notification settings saved!')),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green[800],
              minimumSize: const Size(double.infinity, 50),
            ),
            child: const Text('Save Settings'),
          ),
        ],
      ),
    );
  }
}
import 'package:flutter/material.dart';

class ExamModulePage extends StatefulWidget {
  const ExamModulePage({super.key});

  @override
  ExamModulePageState createState() => ExamModulePageState();
}

class ExamModulePageState extends State<ExamModulePage> {
  int selectedTabIndex = 0;

  final List<String> tabTitles = [
    'Promotion Exams',
    'Study Materials',
    'My Progress',
    'Test History',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text('Exam Module'),
        backgroundColor: Colors.green[800],
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Tab Bar
          Container(
            color: Colors.green[800],
            child: Row(
              children: tabTitles.asMap().entries.map((entry) {
                int index = entry.key;
                String title = entry.value;
                return Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => selectedTabIndex = index),
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: selectedTabIndex == index
                            ? Colors.white.withOpacity(0.2)
                            : Colors.transparent,
                        border: Border(
                          bottom: BorderSide(
                            color: selectedTabIndex == index
                                ? Colors.white
                                : Colors.transparent,
                            width: 2,
                          ),
                        ),
                      ),
                      child: Text(
                        title,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: selectedTabIndex == index
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),

          // Tab Content
          Expanded(child: _buildTabContent()),
        ],
      ),
    );
  }

  Widget _buildTabContent() {
    switch (selectedTabIndex) {
      case 0:
        return _buildPromotionExamsTab();
      case 1:
        return _buildStudyMaterialsTab();
      case 2:
        return _buildMyProgressTab();
      case 3:
        return _buildTestHistoryTab();
      default:
        return _buildPromotionExamsTab();
    }
  }

  Widget _buildPromotionExamsTab() {
    final promotionExams = [
      {
        'rank': 'Lt to Capt Promotion Exam',
        'nextExam': '15 Mar 2024',
        'eligibility': 'Eligible',
        'status': 'Not Registered',
        'icon': Icons.military_tech,
        'color': Colors.blue[700],
      },
      {
        'rank': 'Captain to Major Promotion Exam',
        'nextExam': '20 Jun 2024',
        'eligibility': '7 years pending',
        'status': 'Not Eligible',
        'icon': Icons.stars,
        'color': Colors.orange[700],
      },
      {
        'rank': 'DSCSC Entrance Exam',
        'nextExam': '10 Sep 2024',
        'eligibility': '15 years pending',
        'status': 'Not Eligible',
        'icon': Icons.emoji_events,
        'color': Colors.red[700],
      },
    ];

    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
            child: Row(
              children: [
                Icon(Icons.info, color: Colors.green[800], size: 24),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Promotion exams are conducted bi-annually. Check your eligibility and register for upcoming exams.',
                    style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 20),

          Text(
            'Available Exams',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.green[800],
            ),
          ),

          SizedBox(height: 16),

          ...promotionExams.map(
            (exam) => Container(
              margin: EdgeInsets.only(bottom: 12),
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
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Row(
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: exam['color'] as Color?,
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: Icon(
                        exam['icon'] as IconData,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),

                    SizedBox(width: 16),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            exam['rank'] as String,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          Text(
                            'Next Exam: ${exam['nextExam']}',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                          Text(
                            'Eligibility: ${exam['eligibility']}',
                            style: TextStyle(
                              fontSize: 12,
                              color: exam['eligibility'] == 'Eligible'
                                  ? Colors.green[700]
                                  : Colors.red[700],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),

                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: exam['eligibility'] == 'Eligible'
                            ? Colors.green[800]
                            : Colors.grey[400],
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: exam['eligibility'] == 'Eligible'
                          ? () {
                              _showRegistrationDialog(exam['rank'] as String);
                            }
                          : null,
                      child: Text(
                        exam['status'] == 'Not Registered'
                            ? 'Register'
                            : 'Registered',
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStudyMaterialsTab() {
    final studyMaterials = [
      {
        'title': 'JSSDM 2022',
        'subtitle': 'Joint Staff Services Defence Manual',
        'description':
            'Complete guide for joint staff operations and defence protocols',
        'icon': Icons.menu_book,
        'color': Colors.red[700],
        'chapters': 24,
        'progress': 0.3,
      },
      {
        'title': 'Tactics Manual',
        'subtitle': 'Military Tactics & Strategy',
        'description': 'Advanced tactical operations and strategic planning',
        'icon': Icons.psychology,
        'color': Colors.blue[700],
        'chapters': 18,
        'progress': 0.6,
      },
      {
        'title': 'Map Reading & Navigation',
        'subtitle': 'Land Navigation Guide',
        'description': 'Comprehensive map reading and navigation techniques',
        'icon': Icons.map,
        'color': Colors.green[700],
        'chapters': 12,
        'progress': 0.8,
      },
      {
        'title': 'Weapon Training Manual',
        'subtitle': 'Small Arms & Equipment',
        'description': 'Complete weapon handling and maintenance guide',
        'icon': Icons.gps_fixed,
        'color': Colors.orange[700],
        'chapters': 15,
        'progress': 0.4,
      },
      {
        'title': 'Leadership & Command',
        'subtitle': 'Military Leadership',
        'description': 'Leadership principles and command responsibilities',
        'icon': Icons.group,
        'color': Colors.purple[700],
        'chapters': 10,
        'progress': 0.2,
      },
      {
        'title': 'Military Law & Ethics',
        'subtitle': 'Armed Forces Act & Regulations',
        'description': 'Military legal framework and ethical guidelines',
        'icon': Icons.gavel,
        'color': Colors.indigo[700],
        'chapters': 16,
        'progress': 0.1,
      },
    ];

    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Study Materials',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.green[800],
            ),
          ),

          SizedBox(height: 16),

          ...studyMaterials.map(
            (material) => Container(
              margin: EdgeInsets.only(bottom: 16),
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
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: material['color'] as Color?,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            material['icon'] as IconData,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),

                        SizedBox(width: 16),

                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                material['title'] as String,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                              Text(
                                material['subtitle'] as String,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.green[700],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                '${material['chapters']} Chapters',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),

                        IconButton(
                          onPressed: () {
                            _showMaterialDetails(material);
                          },
                          icon: Icon(Icons.arrow_forward_ios, size: 16),
                        ),
                      ],
                    ),

                    SizedBox(height: 12),

                    Text(
                      material['description'] as String,
                      style: TextStyle(fontSize: 13, color: Colors.grey[700]),
                    ),

                    SizedBox(height: 12),

                    Row(
                      children: [
                        Text(
                          'Progress: ',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                        Expanded(
                          child: LinearProgressIndicator(
                            value: material['progress'] as double,
                            backgroundColor: Colors.grey[300],
                            valueColor: AlwaysStoppedAnimation<Color>(
                              material['color'] as Color,
                            ),
                          ),
                        ),
                        SizedBox(width: 8),
                        Text(
                          '${((material['progress'] as double) * 100).toInt()}%',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMyProgressTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'My Progress Overview',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.green[800],
            ),
          ),

          SizedBox(height: 16),

          // Overall Progress Card
          Container(
            padding: EdgeInsets.all(20),
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
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildProgressStat(
                      'Study Hours',
                      '45.5',
                      Icons.access_time,
                    ),
                    _buildProgressStat('Tests Taken', '12', Icons.quiz),
                    _buildProgressStat(
                      'Average Score',
                      '78%',
                      Icons.trending_up,
                    ),
                  ],
                ),

                SizedBox(height: 20),

                Row(
                  children: [
                    Icon(Icons.flag, color: Colors.green[800]),
                    SizedBox(width: 8),
                    Text(
                      'Current Goal: Lieutenant Promotion Exam',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.green[800],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          SizedBox(height: 20),

          Text(
            'Recent Activity',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.green[800],
            ),
          ),

          SizedBox(height: 12),

          // Recent Activity Items
          ...[
            {
              'activity': 'Completed JSSDM Chapter 5',
              'time': '2 hours ago',
              'icon': Icons.check_circle,
              'color': Colors.green,
            },
            {
              'activity': 'Scored 85% in Tactics Quiz',
              'time': '1 day ago',
              'icon': Icons.star,
              'color': Colors.orange,
            },
            {
              'activity': 'Started Map Reading Module',
              'time': '3 days ago',
              'icon': Icons.play_circle,
              'color': Colors.blue,
            },
            {
              'activity': 'Registered for Lt. Exam',
              'time': '5 days ago',
              'icon': Icons.assignment,
              'color': Colors.purple,
            },
          ].map(
            (activity) => Container(
              margin: EdgeInsets.only(bottom: 8),
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: Row(
                children: [
                  Icon(
                    activity['icon'] as IconData,
                    color: activity['color'] as Color,
                    size: 20,
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          activity['activity'] as String,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          activity['time'] as String,
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey[600],
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
    );
  }

  Widget _buildTestHistoryTab() {
    final testHistory = [
      {
        'test': 'JSSDM Mock Test 1',
        'score': '92%',
        'date': '20 Jan 2024',
        'status': 'Passed',
      },
      {
        'test': 'Tactics Assessment',
        'score': '78%',
        'date': '18 Jan 2024',
        'status': 'Passed',
      },
      {
        'test': 'Map Reading Quiz',
        'score': '85%',
        'date': '15 Jan 2024',
        'status': 'Passed',
      },
      {
        'test': 'Leadership Evaluation',
        'score': '68%',
        'date': '12 Jan 2024',
        'status': 'Needs Improvement',
      },
      {
        'test': 'Weapon Safety Test',
        'score': '95%',
        'date': '10 Jan 2024',
        'status': 'Excellent',
      },
    ];

    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Test History',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.green[800],
            ),
          ),

          SizedBox(height: 16),

          ...testHistory.map(
            (test) => Container(
              margin: EdgeInsets.only(bottom: 12),
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
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: _getStatusColor(test['status'] as String),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Icon(
                      _getStatusIcon(test['status'] as String),
                      color: Colors.white,
                      size: 20,
                    ),
                  ),

                  SizedBox(width: 16),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          test['test'] as String,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        Text(
                          'Date: ${test['date']}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        test['score'] as String,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: _getStatusColor(test['status'] as String),
                        ),
                      ),
                      Text(
                        test['status'] as String,
                        style: TextStyle(
                          fontSize: 11,
                          color: _getStatusColor(test['status'] as String),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressStat(String label, String value, IconData icon) {
    return Column(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: Colors.green[100],
            borderRadius: BorderRadius.circular(25),
          ),
          child: Icon(icon, color: Colors.green[800], size: 24),
        ),
        SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.green[800],
          ),
        ),
        Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
      ],
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Excellent':
        return Colors.green[700]!;
      case 'Passed':
        return Colors.green[600]!;
      case 'Needs Improvement':
        return Colors.orange[700]!;
      default:
        return Colors.grey[600]!;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status) {
      case 'Excellent':
        return Icons.stars;
      case 'Passed':
        return Icons.check_circle;
      case 'Needs Improvement':
        return Icons.warning;
      default:
        return Icons.help;
    }
  }

  void _showRegistrationDialog(String rank) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: Text('Register for $rank Promotion Exam'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'You are eligible to register for the $rank promotion exam.',
              ),
              SizedBox(height: 12),
              Text(
                'Requirements:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text('• Service eligibility met'),
              Text('• Required courses completed'),
              Text('• Performance evaluations up to date'),
              SizedBox(height: 12),
              Text(
                'Registration fee: ₹500',
                style: TextStyle(color: Colors.green[700]),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green[800],
              ),
              onPressed: () {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Successfully registered for $rank promotion exam!',
                    ),
                    backgroundColor: Colors.green[800],
                  ),
                );
              },
              child: Text('Register'),
            ),
          ],
        );
      },
    );
  }

  void _showMaterialDetails(Map<String, dynamic> material) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: Text(material['title']),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(material['description']),
              SizedBox(height: 12),
              Text('Chapters: ${material['chapters']}'),
              Text(
                'Progress: ${((material['progress'] as double) * 100).toInt()}%',
              ),
              SizedBox(height: 8),
              LinearProgressIndicator(
                value: material['progress'] as double,
                backgroundColor: Colors.grey[300],
                valueColor: AlwaysStoppedAnimation<Color>(
                  material['color'] as Color,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Close'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green[800],
              ),
              onPressed: () {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Opening ${material['title']}...'),
                    backgroundColor: Colors.green[800],
                  ),
                );
              },
              child: Text('Study Now'),
            ),
          ],
        );
      },
    );
  }
}
import 'package:flutter/material.dart';
import 'report_generation_page.dart';
import 'exam_module_page.dart';
import 'settings_page.dart';
import 'contact_info_page.dart';
import 'pending_requests_page.dart';
import 'chat_page.dart';
import 'profile_page.dart';
import 'archive_database_page.dart';
import 'todo_page.dart';
import 'training_calender_page.dart';
import 'report_incident_page.dart';
import 'quick_notes_page.dart';
import 'request_leave_page.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  DashboardPageState createState() => DashboardPageState();
}

class DashboardPageState extends State<DashboardPage> {
  TextEditingController searchController = TextEditingController();
  FocusNode searchFocusNode = FocusNode();
  String searchQuery = '';
  bool isSearchActive = false;
  List<String> recentSearches = [
    'Report Generation',
    'Contact Info',
    'Settings',
  ];

  // Search data for different categories
  final List<SearchItem> allSearchItems = [
    // Features/Pages
    SearchItem(
      title: 'Generate Report',
      category: 'Features',
      keywords: ['report', 'generate', 'document'],
      icon: Icons.description,
      onTap: (context) => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ReportGenerationPage()),
      ),
    ),
    SearchItem(
      title: 'Exam Module',
      category: 'Features',
      keywords: ['exam', 'test', 'module', 'training'],
      icon: Icons.school,
      onTap: (context) => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ExamModulePage()),
      ),
    ),
    SearchItem(
      title: 'Settings',
      category: 'Features',
      keywords: ['settings', 'preferences', 'config'],
      icon: Icons.settings,
      onTap: (context) => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const SettingsPage()),
      ),
    ),
    SearchItem(
      title: 'Contact Info',
      category: 'Features',
      keywords: ['contact', 'phone', 'directory', 'people'],
      icon: Icons.contacts,
      onTap: (context) => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ContactInfoPage()),
      ),
    ),
    SearchItem(
      title: 'Pending Requests',
      category: 'Features',
      keywords: ['pending', 'requests', 'approval', 'leave'],
      icon: Icons.pending_actions,
      onTap: (context) => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => PendingRequestPage()),
      ),
    ),
    SearchItem(
      title: 'Chat',
      category: 'Features',
      keywords: ['chat', 'message', 'communication'],
      icon: Icons.chat,
      onTap: (context) => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ChatPage()),
      ),
    ),
    SearchItem(
      title: 'Profile',
      category: 'Features',
      keywords: ['profile', 'account', 'personal'],
      icon: Icons.person,
      onTap: (context) => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ProfilePage()),
      ),
    ),
    SearchItem(
      title: 'Archive Database',
      category: 'Features',
      keywords: ['archive', 'database', 'history', 'records'],
      icon: Icons.archive,
      onTap: (context) => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ArchiveDatabasePage()),
      ),
    ),
    SearchItem(
      title: 'To-Do List',
      category: 'Features',
      keywords: ['todo', 'task', 'checklist', 'list'],
      icon: Icons.check,
      onTap: (context) => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const TodoPage()),
      ),
    ),
    // Quick Actions
    SearchItem(
      title: 'Request Leave',
      category: 'Quick Actions',
      keywords: ['leave', 'request', 'vacation', 'time off'],
      icon: Icons.exit_to_app,
      onTap: (context) => _showComingSoon(context, 'Request Leave'),
    ),
    SearchItem(
      title: 'Report Incident',
      category: 'Quick Actions',
      keywords: ['incident', 'report', 'emergency', 'alert'],
      icon: Icons.warning,
      onTap: (context) => _showComingSoon(context, 'Report Incident'),
    ),
    SearchItem(
      title: 'Training Calendar',
      category: 'Quick Actions',
      keywords: ['training', 'calendar', 'schedule', 'events'],
      icon: Icons.calendar_today,
      onTap: (context) => _showComingSoon(context, 'Training Calendar'),
    ),
    SearchItem(
      title: 'Quick Notes',
      category: 'Quick Actions',
      keywords: ['notes', 'memo', 'reminder', 'write'],
      icon: Icons.note,
      onTap: (context) => _showComingSoon(context, 'Quick Notes'),
    ),
  ];

  static void _showComingSoon(BuildContext context, String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$feature - Coming Soon!'),
        backgroundColor: Colors.green[800],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    searchController.addListener(() {
      setState(() {
        searchQuery = searchController.text;
      });
    });

    searchFocusNode.addListener(() {
      setState(() {
        isSearchActive = searchFocusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    searchFocusNode.dispose();
    super.dispose();
  }

  List<SearchItem> get filteredSearchResults {
    if (searchQuery.isEmpty) return [];

    return allSearchItems.where((item) {
      return item.title.toLowerCase().contains(searchQuery.toLowerCase()) ||
          item.keywords.any(
            (keyword) =>
                keyword.toLowerCase().contains(searchQuery.toLowerCase()),
          );
    }).toList();
  }

  void _performSearch(String query) {
    if (query.isNotEmpty && !recentSearches.contains(query)) {
      setState(() {
        recentSearches.insert(0, query);
        if (recentSearches.length > 5) {
          recentSearches.removeLast();
        }
      });
    }
  }

  void _clearSearch() {
    setState(() {
      searchController.clear();
      searchQuery = '';
      searchFocusNode.unfocus();
    });
  }

  void _showNotificationPanel(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.7,
              maxWidth: MediaQuery.of(context).size.width * 0.9,
            ),
            child: SingleChildScrollView(
              padding: EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Icon(Icons.notifications, color: Colors.green[800]),
                      SizedBox(width: 8),
                      Text(
                        'Notifications',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  _buildNotificationItem(
                    'Pending Request',
                    'You have 3 pending leave requests to review',
                    Icons.pending_actions,
                    Colors.orange,
                  ),
                  _buildNotificationItem(
                    'Training Reminder',
                    'Safety training scheduled for tomorrow at 09:00',
                    Icons.school,
                    Colors.blue,
                  ),
                  _buildNotificationItem(
                    'System Alert',
                    'Monthly report submission deadline: 2 days left',
                    Icons.warning,
                    Colors.red,
                  ),
                  _buildNotificationItem(
                    'New Message',
                    'You have 5 unread messages in chat',
                    Icons.message,
                    Colors.green,
                  ),
                  _buildNotificationItem(
                    'Update Available',
                    'New app version available for download',
                    Icons.system_update,
                    Colors.purple,
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: Text('Close'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green[800],
                        ),
                        child: Text('View All'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildNotificationItem(
    String title,
    String description,
    IconData icon,
    Color color,
  ) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border(left: BorderSide(color: color, width: 4)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 24),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.green[800]),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.person,
                      size: 40,
                      color: Colors.green[800],
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Welcome, User!',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'user@military.gov',
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Dashboard'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: Icon(Icons.contacts),
              title: Text('Contacts'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ContactInfoPage()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.pending_actions),
              title: Text('Pending Requests'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PendingRequestPage()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.chat),
              title: Text('Chat'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ChatPage()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text('Profile'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProfilePage()),
                );
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SettingsPage()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.help),
              title: Text('Help & Support'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: Icon(Icons.info),
              title: Text('About'),
              onTap: () => Navigator.pop(context),
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.logout, color: Colors.red),
              title: Text('Logout', style: TextStyle(color: Colors.red)),
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
      body: Builder(
        builder: (BuildContext scaffoldContext) {
          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Theme.of(context).scaffoldBackgroundColor,
                  Theme.of(context).scaffoldBackgroundColor,
                ],
              ),
            ),
            child: SafeArea(
              child: Column(
                children: [
                  // Header
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Scaffold.of(scaffoldContext).openDrawer();
                          },
                          child: Icon(
                            Icons.menu,
                            color: Theme.of(context).iconTheme.color,
                            size: 28,
                          ),
                        ),
                        GestureDetector(
                          onTap: () => _showNotificationPanel(context),
                          child: Stack(
                            children: [
                              Icon(
                                Icons.notifications,
                                color: Theme.of(context).iconTheme.color,
                                size: 28,
                              ),
                              Positioned(
                                right: 0,
                                top: 0,
                                child: Container(
                                  padding: EdgeInsets.all(2),
                                  decoration: BoxDecoration(
                                    color: Colors.red,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  constraints: BoxConstraints(
                                    minWidth: 16,
                                    minHeight: 16,
                                  ),
                                  child: Text(
                                    '5',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Welcome Text
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20.0),
                    child: Text(
                      'Welcome, User!',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).textTheme.bodyLarge?.color,
                      ),
                    ),
                  ),

                  // Enhanced Search Bar
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Theme.of(context).cardColor,
                            borderRadius: BorderRadius.circular(25),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 10,
                                offset: Offset(0, 5),
                              ),
                            ],
                          ),
                          child: TextField(
                            controller: searchController,
                            focusNode: searchFocusNode,
                            onSubmitted: _performSearch,
                            decoration: InputDecoration(
                              hintText:
                                  'Search features, contacts, or actions...',
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 15,
                              ),
                              suffixIcon: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  if (searchQuery.isNotEmpty)
                                    IconButton(
                                      icon: Icon(
                                        Icons.clear,
                                        color: Colors.grey,
                                      ),
                                      onPressed: _clearSearch,
                                    ),
                                  AnimatedRotation(
                                    turns: isSearchActive ? 0.5 : 0.0,
                                    duration: Duration(milliseconds: 300),
                                    child: Icon(
                                      Icons.search,
                                      color: Colors.green,
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                ],
                              ),
                            ),
                          ),
                        ),

                        // Search Results or Recent Searches
                        if (isSearchActive)
                          Container(
                            margin: EdgeInsets.only(top: 8),
                            decoration: BoxDecoration(
                              color: Theme.of(context).cardColor,
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
                                if (searchQuery.isEmpty) ...[
                                  // Recent Searches
                                  if (recentSearches.isNotEmpty) ...[
                                    Padding(
                                      padding: EdgeInsets.all(16),
                                      child: Text(
                                        'Recent Searches',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey[600],
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                    ...recentSearches.map(
                                      (search) => ListTile(
                                        leading: Icon(
                                          Icons.history,
                                          color: Colors.grey,
                                        ),
                                        title: Text(search),
                                        onTap: () {
                                          searchController.text = search;
                                          setState(() {
                                            searchQuery = search;
                                          });
                                        },
                                      ),
                                    ),
                                  ],
                                ] else ...[
                                  // Search Results
                                  if (filteredSearchResults.isNotEmpty) ...[
                                    Padding(
                                      padding: EdgeInsets.all(16),
                                      child: Text(
                                        'Search Results (${filteredSearchResults.length})',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey[600],
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                    ...filteredSearchResults.map(
                                      (item) => ListTile(
                                        leading: Icon(
                                          item.icon,
                                          color: Colors.green[800],
                                        ),
                                        title: Text(item.title),
                                        subtitle: Text(item.category),
                                        trailing: Icon(
                                          Icons.arrow_forward_ios,
                                          size: 16,
                                        ),
                                        onTap: () async {
                                          _performSearch(searchQuery);
                                          searchController.clear();
                                          setState(() {
                                            searchQuery = '';
                                            isSearchActive = false;
                                          });
                                          searchFocusNode.unfocus();

                                          // Ensure navigation happens after UI update
                                          await Future.delayed(
                                            Duration(milliseconds: 50),
                                          );
                                          if (context.mounted) {
                                            item.onTap(context);
                                          }
                                        },
                                      ),
                                    ),
                                  ] else ...[
                                    Padding(
                                      padding: EdgeInsets.all(32),
                                      child: Column(
                                        children: [
                                          Icon(
                                            Icons.search_off,
                                            size: 48,
                                            color: Colors.grey,
                                          ),
                                          SizedBox(height: 16),
                                          Text(
                                            'No results found for "$searchQuery"',
                                            style: TextStyle(
                                              color: Colors.grey[600],
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ],
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),

                  SizedBox(height: 30),

                  // Grid of Cards (only show when search is not active)
                  if (!isSearchActive)
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: GridView.count(
                          crossAxisCount: 2,
                          crossAxisSpacing: 15,
                          mainAxisSpacing: 15,
                          childAspectRatio: 1.0,
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const ReportGenerationPage(),
                                  ),
                                );
                              },
                              child: _buildCardItem(
                                context,
                                Icons.description,
                                'Generate\nReport',
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const ExamModulePage(),
                                  ),
                                );
                              },
                              child: _buildCardItem(
                                context,
                                Icons.school,
                                'Exam\nModule',
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ArchiveDatabasePage(),
                                  ),
                                );
                              },
                              child: _buildCardItem(
                                context,
                                Icons.archive,
                                'Archive\nDatabase',
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const TrainingCalendarPage(),
                                  ),
                                );
                              },
                              child: _buildCardItem(
                                context,
                                Icons.calendar_today,
                                'Training\nCalendar',
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const ReportIncidentPage(),
                                  ),
                                );
                              },
                              child: _buildCardItem(
                                context,
                                Icons.warning,
                                'Report\nIncident',
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const TodoPage(),
                                  ),
                                );
                              },
                              child: _buildCardItem(
                                context,
                                Icons.check,
                                'To-Do\nList',
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const QuickNotesPage(),
                                  ),
                                );
                              },
                              child: _buildCardItem(
                                context,
                                Icons.note,
                                'Quick\nNotes',
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const RequestLeavePage(),
                                  ),
                                );
                              },
                              child: _buildCardItem(
                                context,
                                Icons.exit_to_app,
                                'Request\nLeave',
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const SettingsPage(),
                                  ),
                                );
                              },
                              child: _buildCardItem(
                                context,
                                Icons.settings,
                                'Settings',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                  SizedBox(height: 20),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCardItem(BuildContext context, IconData icon, String label) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.green[100],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: Colors.green[800], size: 30),
          ),
          SizedBox(height: 7),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}

class SearchItem {
  final String title;
  final String category;
  final List<String> keywords;
  final IconData icon;
  final Function(BuildContext) onTap;

  SearchItem({
    required this.title,
    required this.category,
    required this.keywords,
    required this.icon,
    required this.onTap,
  });
}
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactInfoPage extends StatefulWidget {
  const ContactInfoPage({super.key});

  @override
  ContactInfoPageState createState() => ContactInfoPageState();
}

class ContactInfoPageState extends State<ContactInfoPage> {
  String selectedCategory = 'All';
  String searchQuery = '';
  List<String> favorites = [];
  List<String> recentContacts = [];

  final List<String> categories = [
    'All',
    'Command Structure',
    'Emergency Contacts',
    'External Contacts',
    'Support Services',
  ];

  final List<ContactInfo> contacts = [
    // Command Structure
    ContactInfo(
      name: 'Lt. General Rahman',
      rank: 'Lieutenant General',
      position: 'PSO AFD',
      phone: '+880-1711-123456',
      email: 'ltgen.rahman@army.mil.bd',
      radio: 'ALPHA-01',
      office: 'HQ Building, Room 101',
      category: 'Command Structure',
      isOnDuty: true,
      priority: 'High',
    ),
    ContactInfo(
      name: 'Brigadier General Ahmed',
      rank: 'Brigadier',
      position: 'Chief of Staff',
      phone: '+880-1712-234567',
      email: 'brig.ahmed@army.mil.bd',
      radio: 'ALPHA-02',
      office: 'HQ Building, Room 102',
      category: 'Command Structure',
      isOnDuty: true,
      priority: 'High',
    ),
    ContactInfo(
      name: 'Colonel Khan',
      rank: 'Colonel',
      position: 'Operations Officer',
      phone: '+880-1713-345678',
      email: 'col.khan@army.mil.bd',
      radio: 'BRAVO-01',
      office: 'Operations Center',
      category: 'Command Structure',
      isOnDuty: false,
      priority: 'Medium',
    ),
    // Emergency Contacts
    ContactInfo(
      name: 'Medical Emergency',
      rank: 'N/A',
      position: 'Emergency Services',
      phone: '+880-1714-911911',
      email: 'medical@army.mil.bd',
      radio: 'MEDICAL-01',
      office: 'Medical Center',
      category: 'Emergency Contacts',
      isOnDuty: true,
      priority: 'Critical',
    ),
    ContactInfo(
      name: 'Security Control',
      rank: 'N/A',
      position: 'Base Security',
      phone: '+880-1715-999999',
      email: 'security@army.mil.bd',
      radio: 'SECURITY-01',
      office: 'Main Gate',
      category: 'Emergency Contacts',
      isOnDuty: true,
      priority: 'Critical',
    ),
    // External Contacts
    ContactInfo(
      name: 'Major Hasan',
      rank: 'Major',
      position: 'Liaison Officer',
      phone: '+880-1716-456789',
      email: 'maj.hasan@navy.mil.bd',
      radio: 'CHARLIE-01',
      office: 'Naval Base',
      category: 'External Contacts',
      isOnDuty: true,
      priority: 'Medium',
    ),
    // Support Services
    ContactInfo(
      name: 'IT Help Desk',
      rank: 'N/A',
      position: 'Technical Support',
      phone: '+880-1717-567890',
      email: 'ithelp@army.mil.bd',
      radio: 'TECH-01',
      office: 'IT Center',
      category: 'Support Services',
      isOnDuty: true,
      priority: 'Low',
    ),
    ContactInfo(
      name: 'Captain Uddin',
      rank: 'Captain',
      position: 'Logistics Officer',
      phone: '+880-1718-678901',
      email: 'capt.uddin@army.mil.bd',
      radio: 'DELTA-01',
      office: 'Supply Depot',
      category: 'Support Services',
      isOnDuty: false,
      priority: 'Medium',
    ),
  ];

  List<ContactInfo> get filteredContacts {
    return contacts.where((contact) {
      final matchesCategory =
          selectedCategory == 'All' || contact.category == selectedCategory;
      final matchesSearch =
          contact.name.toLowerCase().contains(searchQuery.toLowerCase()) ||
          contact.rank.toLowerCase().contains(searchQuery.toLowerCase()) ||
          contact.position.toLowerCase().contains(searchQuery.toLowerCase());
      return matchesCategory && matchesSearch;
    }).toList();
  }

  void _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(scheme: 'tel', path: phoneNumber);
    await launchUrl(launchUri);
    _addToRecent(phoneNumber);
  }

  void _sendEmail(String email) async {
    final Uri launchUri = Uri(scheme: 'mailto', path: email);
    await launchUrl(launchUri);
    _addToRecent(email);
  }

  void _sendMessage(String phoneNumber) async {
    final Uri launchUri = Uri(scheme: 'sms', path: phoneNumber);
    await launchUrl(launchUri);
    _addToRecent(phoneNumber);
  }

  void _addToRecent(String contact) {
    setState(() {
      recentContacts.remove(contact);
      recentContacts.insert(0, contact);
      if (recentContacts.length > 5) {
        recentContacts.removeLast();
      }
    });
  }

  void _toggleFavorite(String contactName) {
    setState(() {
      if (favorites.contains(contactName)) {
        favorites.remove(contactName);
      } else {
        favorites.add(contactName);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Contact Info")),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              onChanged: (value) => setState(() => searchQuery = value),
              decoration: InputDecoration(
                hintText: 'Search contacts...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
          ),

          // Category Filter
          Container(
            height: 50,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                final isSelected = selectedCategory == category;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(category),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        selectedCategory = category;
                      });
                    },
                    backgroundColor: Colors.white,
                    selectedColor: Colors.green.shade200,
                  ),
                );
              },
            ),
          ),

          // Emergency Quick Access
          if (selectedCategory == 'All' ||
              selectedCategory == 'Emergency Contacts')
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.red.shade200),
              ),
              child: Row(
                children: [
                  Icon(Icons.emergency, color: Colors.red, size: 24),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Emergency Contacts',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.red.shade700,
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () => _makePhoneCall('+880-1714-911911'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                    ),
                    child: Text('EMERGENCY'),
                  ),
                ],
              ),
            ),

          // Contacts List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: filteredContacts.length,
              itemBuilder: (context, index) {
                final contact = filteredContacts[index];
                final isFavorite = favorites.contains(contact.name);

                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  elevation: 4,
                  child: ExpansionTile(
                    leading: CircleAvatar(
                      backgroundColor: _getPriorityColor(contact.priority),
                      child: Text(
                        contact.rank != 'N/A'
                            ? contact.rank.substring(0, 1)
                            : 'S',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    title: Row(
                      children: [
                        Expanded(
                          child: Text(
                            contact.name,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        if (contact.isOnDuty)
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              'ON DUTY',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                              ),
                            ),
                          ),
                        IconButton(
                          icon: Icon(
                            isFavorite ? Icons.favorite : Icons.favorite_border,
                            color: isFavorite ? Colors.red : Colors.grey,
                          ),
                          onPressed: () => _toggleFavorite(contact.name),
                        ),
                      ],
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('${contact.rank} - ${contact.position}'),
                        Text(
                          'Radio: ${contact.radio}',
                          style: TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildInfoRow(Icons.phone, 'Phone', contact.phone),
                            _buildInfoRow(Icons.email, 'Email', contact.email),
                            _buildInfoRow(Icons.radio, 'Radio', contact.radio),
                            _buildInfoRow(
                              Icons.location_on,
                              'Office',
                              contact.office,
                            ),
                            _buildInfoRow(
                              Icons.priority_high,
                              'Priority',
                              contact.priority,
                            ),

                            SizedBox(height: 16),

                            // Action Buttons
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                _buildActionButton(
                                  icon: Icons.phone,
                                  label: 'Call',
                                  color: Colors.green,
                                  onPressed: () =>
                                      _makePhoneCall(contact.phone),
                                ),
                                _buildActionButton(
                                  icon: Icons.email,
                                  label: 'Email',
                                  color: Colors.blue,
                                  onPressed: () => _sendEmail(contact.email),
                                ),
                                _buildActionButton(
                                  icon: Icons.message,
                                  label: 'Message',
                                  color: Colors.orange,
                                  onPressed: () => _sendMessage(contact.phone),
                                ),
                                _buildActionButton(
                                  icon: Icons.qr_code,
                                  label: 'QR',
                                  color: Colors.purple,
                                  onPressed: () => _showQRCode(contact),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.grey[600]),
          SizedBox(width: 8),
          Text('$label: ', style: TextStyle(fontWeight: FontWeight.bold)),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: color,
            foregroundColor: Colors.white,
            shape: CircleBorder(),
            padding: EdgeInsets.all(16),
          ),
          child: Icon(icon),
        ),
        SizedBox(height: 4),
        Text(label, style: TextStyle(fontSize: 12)),
      ],
    );
  }

  Color _getPriorityColor(String priority) {
    switch (priority) {
      case 'Critical':
        return Colors.red;
      case 'High':
        return Colors.orange;
      case 'Medium':
        return Colors.blue;
      case 'Low':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  void _showQRCode(ContactInfo contact) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Contact QR Code'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 200,
              height: 200,
              color: Colors.grey[300],
              child: Center(
                child: Text(
                  'QR Code\n${contact.name}',
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            SizedBox(height: 16),
            Text('Scan to save contact', style: TextStyle(fontSize: 12)),
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
}

class ContactInfo {
  final String name;
  final String rank;
  final String position;
  final String phone;
  final String email;
  final String radio;
  final String office;
  final String category;
  final bool isOnDuty;
  final String priority;

  ContactInfo({
    required this.name,
    required this.rank,
    required this.position,
    required this.phone,
    required this.email,
    required this.radio,
    required this.office,
    required this.category,
    required this.isOnDuty,
    required this.priority,
  });
}

