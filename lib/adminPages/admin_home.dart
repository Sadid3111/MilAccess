import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/adminPages/pending_requests_screen.dart';
import 'package:flutter_application_1/ahqPages/profile_page.dart';
import 'package:flutter_application_1/ahqPages/report_type.dart';
import 'package:flutter_application_1/models/search_item.dart';
import 'package:flutter_application_1/models/user_data.dart';
import 'package:flutter_application_1/userPages/contact_info_page.dart';
import 'package:flutter_application_1/userPages/quick_notes_page.dart';
import 'package:flutter_application_1/userPages/settings_page.dart';
import 'package:flutter_application_1/userPages/training_calender_page.dart';
import 'document_upload.dart';
import 'features/pending_leave_requests/pending_leave_requests_screen.dart';
import 'features/incident_report/incident_report_screen.dart';
import 'features/task_management/task_management.dart';
import 'features/quick_notes/quick_notes_screen.dart';

class AdminHomeScreen extends StatefulWidget {
  const AdminHomeScreen({super.key});

  @override
  _AdminHomeScreenState createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
  int notifCount = 0;
  List<Map<String, dynamic>> notifications = [];
  StreamSubscription<QuerySnapshot>? _notifListener;
  TextEditingController searchController = TextEditingController();
  FocusNode searchFocusNode = FocusNode();
  String searchQuery = '';
  bool isSearchActive = false;
  List<String> recentSearches = [
    'Report Generation',
    'Contact Info',
    'Settings',
  ];

  final List<SearchItem> allSearchItems = [
    SearchItem(
      title: 'Upload Document',
      category: 'Admin Actions',
      keywords: ['upload', 'document', 'file', 'admin'],
      icon: Icons.upload_file,
      onTap: (context) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const DocumentUploadScreen()),
        );
      },
    ),
    SearchItem(
      title: 'Events Calendar',
      category: 'Admin Actions',
      keywords: ['events', 'calendar', 'schedule', 'training'],
      icon: Icons.calendar_today,
      onTap: (context) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const TrainingCalendarPage()),
        );
      },
    ),
    SearchItem(
      title: 'Pending Leave Requests',
      category: 'Admin Actions',
      keywords: ['leave', 'requests', 'pending', 'approval'],
      icon: Icons.assignment,
      onTap: (context) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const PendingLeaveRequestsScreen(),
          ),
        );
      },
    ),
    SearchItem(
      title: 'Incident Report',
      category: 'Admin Actions',
      keywords: ['incident', 'report', 'alert', 'warning'],
      icon: Icons.warning_amber,
      onTap: (context) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const IncidentReportScreen(role: 'admin'),
          ),
        );
      },
    ),
    SearchItem(
      title: 'Report Generator',
      category: 'Admin Actions',
      keywords: ['report', 'generator'],
      icon: Icons.pending_actions,
      onTap: (context) => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ReportTypeSelectorPage()),
      ),
    ),
    SearchItem(
      title: 'Task Management',
      category: 'Admin Actions',
      keywords: ['task', 'management', 'to-do', 'checklist'],
      icon: Icons.checklist,
      onTap: (context) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ToDoListScreen()),
        );
      },
    ),
    SearchItem(
      title: 'Quick Notes',
      category: 'Admin Actions',
      keywords: ['notes', 'quick', 'memo', 'add'],
      icon: Icons.note_add,
      onTap: (context) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const QuickNotesScreen()),
        );
      },
    ),
  ];

  Future<void> updateOnseen() async {
    try {
      // Get unseen notifications for both individual user and unit
      final userNotifRef = await FirebaseFirestore.instance
          .collection('notifications')
          .where('targetId', isEqualTo: UserData.uid)
          .where('seen', isEqualTo: false)
          .get();

      final unitNotifRef = await FirebaseFirestore.instance
          .collection('notifications')
          .where('targetId', isEqualTo: UserData.unitName)
          .where('seen', isEqualTo: false)
          .get();

      WriteBatch batch = FirebaseFirestore.instance.batch();

      // Mark user notifications as seen
      for (var doc in userNotifRef.docs) {
        batch.update(doc.reference, {'seen': true});
      }

      // Mark unit notifications as seen
      for (var doc in unitNotifRef.docs) {
        batch.update(doc.reference, {'seen': true});
      }

      await batch.commit();
    } catch (e) {
      print('error: $e');
    }
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
      // Get all unseen notifications for admin (both individual and unit-based)
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

  void showNotificationPanel(BuildContext context) async {
    // Mark all unseen notifications as seen when panel opens
    _markAllNotificationsAsSeen();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.6,
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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

  // Future<void> fetchOldNotification() async {
  //   notifications.clear();
  //   try {
  //     final notifRef = await FirebaseFirestore.instance
  //         .collection('notifications')
  //         .where('targetId', isEqualTo: UserData.uid)
  //         .orderBy('createdAt', descending: true)
  //         .get();

  //     notifications = notifRef.docs.map((doc) {
  //       if (!doc.data()['seen']) notifCount++;
  //       return doc.data();
  //     }).toList();
  //     setState(() {});
  //   } catch (e) {
  //     print('error: ' + e.toString());
  //   }
  // }

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
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _setupNotificationListener();
    });
  }

  void _setupNotificationListener() {
    // Listen for both individual notifications and unit-based notifications
    _notifListener = FirebaseFirestore.instance
        .collection('notifications')
        .where('targetId', whereIn: [UserData.uid, UserData.unitName])
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
    _notifListener!.cancel();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green[700],
        elevation: 0, // No shadow
        centerTitle: true,
        actions: [
          Stack(
            children: [
              IconButton(
                icon: const Icon(
                  Icons.notifications,
                  color: Colors.white,
                  size: 30,
                ),
                onPressed: () {
                  showNotificationPanel(context); // Open the modal bottom sheet
                },
              ),
              notifCount > 0
                  ? Positioned(
                      right: 8, // Adjust position of the badge
                      top: 8,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          notifCount
                              .toString(), // Replace with your dynamic notification count
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    )
                  : const SizedBox.shrink(),
            ],
          ),
        ],
        // Removed shape property from AppBar to allow seamless merge with the container below
      ),
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
                  const SizedBox(height: 10),
                  Expanded(
                    child: Text(
                      UserData.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      softWrap: true,
                      overflow: TextOverflow.ellipsis,
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
                    builder: (context) => const PendingRequestsScreen(),
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
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20.0),
                      child: Text(
                        'Welcome, ${UserData.name.trim()}!',
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
                                  offset: const Offset(0, 5),
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
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 15,
                                ),
                                suffixIcon: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    if (searchQuery.isNotEmpty)
                                      IconButton(
                                        icon: const Icon(
                                          Icons.clear,
                                          color: Colors.grey,
                                        ),
                                        onPressed: _clearSearch,
                                      ),
                                    AnimatedRotation(
                                      turns: isSearchActive ? 0.5 : 0.0,
                                      duration: const Duration(
                                        milliseconds: 300,
                                      ),
                                      child: const Icon(
                                        Icons.search,
                                        color: Colors.green,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                  ],
                                ),
                              ),
                            ),
                          ),

                          // Search Results or Recent Searches
                          if (isSearchActive)
                            Container(
                              margin: const EdgeInsets.only(top: 8),
                              decoration: BoxDecoration(
                                color: Theme.of(context).cardColor,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 8,
                                    offset: const Offset(0, 4),
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
                                        padding: const EdgeInsets.all(16),
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
                                          leading: const Icon(
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
                                        padding: const EdgeInsets.all(16),
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
                                          trailing: const Icon(
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
                                              const Duration(milliseconds: 50),
                                            );
                                            if (context.mounted) {
                                              item.onTap(context);
                                            }
                                          },
                                        ),
                                      ),
                                    ] else ...[
                                      Padding(
                                        padding: const EdgeInsets.all(32),
                                        child: Column(
                                          children: [
                                            const Icon(
                                              Icons.search_off,
                                              size: 48,
                                              color: Colors.grey,
                                            ),
                                            const SizedBox(height: 16),
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

                    const SizedBox(height: 30),

                    // Grid of Cards (only show when search is not active)
                    if (!isSearchActive)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: GridView.count(
                          crossAxisCount: 2,
                          crossAxisSpacing: 15,
                          mainAxisSpacing: 15,
                          childAspectRatio: 1.0,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          children: [
                            _buildGridItem(
                              context,
                              icon: Icons.upload_file,
                              label: 'Upload Document',
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const DocumentUploadScreen(),
                                  ),
                                );
                              },
                            ),
                            _buildGridItem(
                              context,
                              icon: Icons.calendar_today,
                              label: 'Events Calendar',
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const TrainingCalendarPage(),
                                  ),
                                );
                              },
                            ),
                            _buildGridItem(
                              context,
                              icon: Icons
                                  .assignment, // Icon for Pending Leave Requests
                              label: 'Pending Leave Requests',
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const PendingLeaveRequestsScreen(),
                                  ),
                                );
                              },
                            ),
                            _buildGridItem(
                              context,
                              label: 'Report Generator',
                              icon: Icons.assignment, // Custom icon
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const ReportTypeSelectorPage(),
                                  ),
                                );
                              },
                            ),
                            _buildGridItem(
                              context,
                              icon: Icons
                                  .warning_amber, // Icon for Incident Report
                              label: 'Incident Report',
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const IncidentReportScreen(
                                          role: 'admin',
                                        ),
                                  ),
                                );
                              },
                            ),
                            _buildGridItem(
                              context,
                              icon: Icons.checklist, // Icon for To Do List
                              label: 'Task Management',
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const ToDoListScreen(),
                                  ),
                                );
                              },
                            ),
                            _buildGridItem(
                              context,
                              icon: Icons.note_add, // Icon for Quick Notes
                              label: 'Quick Notes',
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const QuickNotesPage(),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),

                    const SizedBox(
                      height: 20,
                    ), // Bottom navigation bar will be handled by HomePage
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildGridItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    VoidCallback? onTap,
  }) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      elevation: 3,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                color: const Color(
                  0xFFDCEDC8,
                ), // Light green background for icon
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Icon(
                icon,
                color: const Color(0xFF4CAF50), // Darker green for icon
                size: 36,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}
