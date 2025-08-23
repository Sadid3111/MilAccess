import 'package:flutter/material.dart';
import 'package:flutter_application_1/ahqPages/pendingrequests.dart';
import 'package:flutter_application_1/ahqPages/profile_page.dart';
import 'package:flutter_application_1/features/calendar/calendar_screen.dart';
import 'package:flutter_application_1/models/user_data.dart';
import 'package:flutter_application_1/userPages/contact_info_page.dart';
import 'package:flutter_application_1/userPages/settings_page.dart';
import 'package:flutter_application_1/userPages/training_calender_page.dart';
import 'report_type.dart';
import 'uploadrequests.dart';
import 'documents.dart';

class AHQHome extends StatefulWidget {
  const AHQHome({super.key});

  @override
  State<AHQHome> createState() => _AHQHomeState();
}

class _AHQHomeState extends State<AHQHome> {
  final List<String> notifications = [
    "New message from John",
    "Your order has been shipped",
    "Reminder: Meeting at 3 PM",
    "Update available for your app",
  ];
  int _selectedIndex = 0;
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void showNotificationPanel(BuildContext context) {
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
                child: ListView.builder(
                  itemCount: notifications.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(notifications[index]),
                      leading: const Icon(Icons.notification_important),
                      onTap: () {
                        // Handle notification tap
                        print("Tapped on: ${notifications[index]}");
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
            icon: const Icon(Icons.notifications),
            onPressed: () {
              showNotificationPanel(context); // Open the modal bottom sheet
            },
          ),
        ],
      ),
      body: Padding(
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
              child: const Row(
                children: [
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Search...',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  Icon(Icons.search, color: Color(0xFF006400)),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Cards
            DashboardCard(
              title: 'Report Generator',
              icon: Icons.assignment, // Custom icon
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ReportTypeSelectorPage(),
                  ),
                );
              },
            ),
            DashboardCard(
              title: 'Pending Upload Requests',
              icon: Icons.cloud_upload, // Custom icon
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const UploadRequests(),
                  ),
                );
              },
            ),
            DashboardCard(
              title: 'View Documents',
              icon: Icons.article, // Custom icon
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const DocumentsPage(),
                  ),
                );
              },
            ),
            DashboardCard(
              title: 'Training Calendar',
              icon: Icons.calendar_today,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const TrainingCalendarPage(),
                  ),
                );
              },
            ),
          ],
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
