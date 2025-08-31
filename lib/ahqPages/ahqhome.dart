import 'package:flutter/material.dart';
import 'package:flutter_application_1/adminPages/features/incident_report/incident_report_screen.dart';
import 'package:flutter_application_1/ahqPages/pendingrequests.dart';
import 'package:flutter_application_1/ahqPages/profile_page.dart';
import 'package:flutter_application_1/models/user_data.dart';
import 'package:flutter_application_1/userPages/contact_info_page.dart';
import 'package:flutter_application_1/userPages/settings_page.dart';
import 'package:flutter_application_1/userPages/training_calender_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import 'report_type.dart';
import 'uploadrequests.dart';
import 'documents.dart';

class AHQHome extends StatefulWidget {
  const AHQHome({super.key});

  @override
  State<AHQHome> createState() => _AHQHomeState();
}

class _AHQHomeState extends State<AHQHome> {
  List<Map<String, dynamic>> notifications = [];
  StreamSubscription<QuerySnapshot>? _notificationSubscription;
  int notifCount = 0;

  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  // List of all available features/cards
  final List<Map<String, dynamic>> _allFeatures = [
    {
      'title': 'Incident Report',
      'icon': Icons.warning_amber,
      'keywords': ['incident', 'report', 'warning', 'emergency', 'alert'],
    },
    {
      'title': 'Pending Upload Requests',
      'icon': Icons.cloud_upload,
      'keywords': ['upload', 'pending', 'requests', 'documents', 'files'],
    },
    {
      'title': 'View Documents',
      'icon': Icons.article,
      'keywords': ['documents', 'files', 'view', 'browse', 'articles'],
    },
    {
      'title': 'Training Calendar',
      'icon': Icons.calendar_today,
      'keywords': ['training', 'calendar', 'schedule', 'events', 'dates'],
    },
  ];

  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text.toLowerCase();
      });
    });
    _setupNotificationListener();
  }

  void _setupNotificationListener() {
    _notificationSubscription = FirebaseFirestore.instance
        .collection('notifications')
        .where('targetId', isEqualTo: 'ahq')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .listen((snapshot) {
          setState(() {
            notifications = snapshot.docs.map((doc) {
              final data = doc.data();
              return {
                'id': doc.id,
                'content': data['content'] ?? '',
                'createdAt': data['createdAt'],
                'seen': data['seen'] ?? false,
              };
            }).toList();

            // Count unseen notifications
            notifCount = notifications.where((notif) => !notif['seen']).length;
          });
        });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _notificationSubscription?.cancel();
    super.dispose();
  }

  List<Map<String, dynamic>> _getFilteredFeatures() {
    if (_searchQuery.isEmpty) {
      return _allFeatures;
    }

    return _allFeatures.where((feature) {
      final title = feature['title'].toString().toLowerCase();
      final keywords = List<String>.from(feature['keywords']);

      return title.contains(_searchQuery) ||
          keywords.any((keyword) => keyword.contains(_searchQuery));
    }).toList();
  }

  void _navigateToFeature(String title) {
    switch (title) {
      case 'Incident Report':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const IncidentReportScreen(role: 'ahq'),
          ),
        );
        break;
      case 'Pending Upload Requests':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const UploadRequests()),
        );
        break;
      case 'View Documents':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const DocumentsPage()),
        );
        break;
      case 'Training Calendar':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const TrainingCalendarPage()),
        );
        break;
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<void> _markNotificationAsSeen(String notificationId) async {
    try {
      await FirebaseFirestore.instance
          .collection('notifications')
          .doc(notificationId)
          .update({'seen': true});
    } catch (e) {
      print('Error marking notification as seen: $e');
    }
  }

  Future<void> _markAllNotificationsAsSeen() async {
    try {
      // Get all unseen notifications for AHQ
      final batch = FirebaseFirestore.instance.batch();

      for (final notification in notifications) {
        if (!notification['seen']) {
          final docRef = FirebaseFirestore.instance
              .collection('notifications')
              .doc(notification['id']);
          batch.update(docRef, {'seen': true});
        }
      }

      await batch.commit();

      // Update local state immediately
      setState(() {
        notifCount = 0;
        for (var i = 0; i < notifications.length; i++) {
          notifications[i]['seen'] = true;
        }
      });
    } catch (e) {
      print('Error marking all notifications as seen: $e');
    }
  }

  String _formatTimestamp(Timestamp? timestamp) {
    if (timestamp == null) return '';
    final date = timestamp.toDate();
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 0) {
      return '${difference.inDays} days ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hours ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minutes ago';
    } else {
      return 'Just now';
    }
  }

  void showNotificationPanel(BuildContext context) {
    // Mark all unseen notifications as seen when panel opens
    _markAllNotificationsAsSeen();

    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Notifications",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const Divider(),
              Expanded(
                child: notifications.isEmpty
                    ? const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.notifications_none,
                              size: 64,
                              color: Colors.grey,
                            ),
                            SizedBox(height: 16),
                            Text(
                              'No notifications yet',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        itemCount: notifications.length,
                        itemBuilder: (context, index) {
                          final notification = notifications[index];
                          return ListTile(
                            title: Text(notification['content'] ?? ''),
                            leading: Icon(
                              Icons.notification_important,
                              color: notification['seen']
                                  ? Colors.grey
                                  : Colors.red,
                            ),
                            subtitle: notification['createdAt'] != null
                                ? Text(
                                    'Received: ${_formatTimestamp(notification['createdAt'])}',
                                    style: const TextStyle(fontSize: 12),
                                  )
                                : null,
                            onTap: () {
                              // Mark as seen when tapped
                              _markNotificationAsSeen(notification['id']);
                              print("Tapped on: ${notification['content']}");
                            },
                          );
                        },
                      ),
              ),
            ],
          ),
        );
      },
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
              decoration: const BoxDecoration(color: Color(0xFFA8D5A2)),
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
                  const SizedBox(height: 10),
                  Text(
                    'Welcome, ${UserData.name}!',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    UserData.email,
                    style: const TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Dashboard'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.contacts),
              title: const Text('Contacts'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ContactInfoPage(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.pending_actions),
              title: const Text('Pending Requests'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PendingRequests(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Profile'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ProfilePage()),
                );
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SettingsPage()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.help),
              title: const Text('Help & Support'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.info),
              title: const Text('About'),
              onTap: () => Navigator.pop(context),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text('Logout', style: TextStyle(color: Colors.red)),
              onTap: () => signOut(context),
            ),
          ],
        ),
      ),
      backgroundColor: const Color(0xFFA8D5A2), // Light green background
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: Stack(
              children: [
                const Icon(Icons.notifications, size: 30),
                if (notifCount > 0)
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 16,
                        minHeight: 16,
                      ),
                      child: Text(
                        notifCount.toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            ),
            onPressed: () {
              showNotificationPanel(context); // Open the modal bottom sheet
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.center, // Center all horizontally
            children: [
              const SizedBox(height: 24),
              const Text(
                'Welcome, AHQ!',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              // Search bar
              Container(
                width: double.infinity, // Stretch to full width if needed
                padding: const EdgeInsets.symmetric(horizontal: 26),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 5,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        decoration: const InputDecoration(
                          hintText: 'Search features...',
                          border: InputBorder.none,
                        ),
                        onChanged: (value) {
                          // The listener already handles this
                        },
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        if (_searchController.text.isNotEmpty) {
                          _searchController.clear();
                        }
                      },
                      child: Icon(
                        _searchController.text.isNotEmpty
                            ? Icons.clear
                            : Icons.search,
                        color: const Color(0xFF006400),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              // Dynamic Cards based on search
              ..._getFilteredFeatures()
                  .map(
                    (feature) => DashboardCard(
                      icon: feature['icon'],
                      title: feature['title'],
                      onTap: () => _navigateToFeature(feature['title']),
                    ),
                  )
                  .toList(),

              // Show "No results found" message when search has no matches
              if (_searchQuery.isNotEmpty && _getFilteredFeatures().isEmpty)
                Container(
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    children: [
                      Icon(Icons.search_off, size: 64, color: Colors.grey[400]),
                      const SizedBox(height: 16),
                      Text(
                        'No features found for "$_searchQuery"',
                        style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Try searching for: incident, upload, documents, training',
                        style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class DashboardCard extends StatelessWidget {
  final String title;
  final VoidCallback? onTap;
  final IconData icon;

  const DashboardCard({
    Key? key,
    required this.title,
    this.onTap,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              offset: Offset(1, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: const Color(0xFF006400),
              child: Icon(icon, color: Colors.white),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const Icon(Icons.more_vert),
          ],
        ),
      ),
    );
  }
}
