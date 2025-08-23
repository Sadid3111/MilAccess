import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/calendar/calendar_screen.dart';
import 'report_type.dart';
import 'uploadrequests.dart';
import 'documents.dart';

// void main() {
//   runApp(const AHQHome());
// }

int _selectedIndex = 0;

// class AHQHome extends StatelessWidget {
//   const AHQHome({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'Admin Dashboard',
//       theme: ThemeData(
//         useMaterial3: true,
//         colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
//       ),
//       home: const AdminDashboard(),
//     );
//   }
// }

class AHQHome extends StatefulWidget {
  const AHQHome({super.key});

  @override
  State<AHQHome> createState() => _AHQHomeState();
}

class _AHQHomeState extends State<AHQHome> {
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFA8D5A2), // Light green background
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const Icon(Icons.menu, color: Colors.black),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: Icon(Icons.notifications_none, color: Colors.black),
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
                    builder: (context) => const CalendarScreen(),
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
}import 'package:flutter/material.dart';
import 'pdf_viewer.dart'; // Make sure this file exists

// void main() {
//   runApp(const UploadRequests());
// }

class UploadRequests extends StatelessWidget {
  const UploadRequests({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Pending Upload Requests - AHQ',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
      ),
      home: const AdminDashboard(),
    );
  }
}

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _openDocument(String title) {
    final sanitizedTitle = title.replaceAll(' ', '_');
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            PDFViewerScreen(pdfAssetPath: 'assets/$sanitizedTitle.pdf'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFA8D5A2),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const Icon(Icons.menu, color: Colors.black),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: Icon(Icons.notifications_none, color: Colors.black),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 24),
                  const Text(
                    'Pending Upload Requests',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  const _SearchBar(),
                  const SizedBox(height: 24),
                  ...[
                        'JSSDM Edition 2025',
                        'JSSDM Edition 2024',
                        'JSSDM Edition 2023',
                        'JSSDM Edition 2022',
                        'JSSDM Edition 2021',
                        'AR(R)',
                        'AR(I)',
                        'ADR',
                        'Signal Officers Handbook',
                        'ICIB',
                        'IPIB',
                        'MBML',
                        'Notes On MBML',
                      ]
                      .map(
                        (title) => DashboardCard(
                          title: title,
                          onAccept: _openDocument,
                        ),
                      )
                      .toList(),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ),
      // bottomNavigationBar: ClipRRect(
      //   borderRadius: BorderRadius.circular(24),
      //   child: BottomNavigationBar(
      //     currentIndex: _selectedIndex,
      //     onTap: _onItemTapped,
      //     selectedItemColor: const Color(0xFF006400),
      //     unselectedItemColor: Colors.grey,
      //     backgroundColor: Colors.transparent,
      //     type: BottomNavigationBarType.fixed,
      //     elevation: 0,
      //     selectedFontSize: 12,
      //     unselectedFontSize: 12,
      //     items: const [
      //       BottomNavigationBarItem(
      //         icon: Padding(
      //           padding: EdgeInsets.only(top: 6),
      //           child: Icon(Icons.home),
      //         ),
      //         label: 'Home',
      //       ),
      //       BottomNavigationBarItem(
      //         icon: Padding(
      //           padding: EdgeInsets.only(top: 6),
      //           child: Icon(Icons.contacts),
      //         ),
      //         label: 'Contacts',
      //       ),
      //       BottomNavigationBarItem(
      //         icon: Padding(
      //           padding: EdgeInsets.only(top: 6),
      //           child: Icon(Icons.pending_actions),
      //         ),
      //         label: 'Pending',
      //       ),
      //       BottomNavigationBarItem(
      //         icon: Padding(
      //           padding: EdgeInsets.only(top: 6),
      //           child: Icon(Icons.person),
      //         ),
      //         label: 'Profile',
      //       ),
      //     ],
      //   ),
      // ),
    );
  }
}

class _SearchBar extends StatelessWidget {
  const _SearchBar();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 26),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 5, offset: Offset(0, 2)),
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
    );
  }
}

class DashboardCard extends StatefulWidget {
  final String title;
  final void Function(String) onAccept;

  const DashboardCard({super.key, required this.title, required this.onAccept});

  @override
  State<DashboardCard> createState() => _DashboardCardState();
}

class _DashboardCardState extends State<DashboardCard> {
  bool _showOptions = false;

  void _toggleOptions() {
    setState(() {
      _showOptions = !_showOptions;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.only(bottom: 8),
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
              const CircleAvatar(
                backgroundColor: Color(0xFF006400),
                child: Icon(Icons.article, color: Colors.white),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  widget.title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              GestureDetector(
                onTap: _toggleOptions,
                child: const Icon(Icons.more_vert),
              ),
            ],
          ),
        ),
        if (_showOptions)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF006400),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  icon: const Icon(Icons.check),
                  label: const Text("Accept"),
                  onPressed: () {
                    widget.onAccept(widget.title);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Accepted: ${widget.title}')),
                    );
                  },
                ),
                const SizedBox(width: 8),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red[700],
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  icon: const Icon(Icons.close),
                  label: const Text("Decline"),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Declined: ${widget.title}')),
                    );
                  },
                ),
                const SizedBox(width: 8),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[700],
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  icon: const Icon(Icons.remove_red_eye_outlined),
                  label: const Text("View"),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Declined: ${widget.title}')),
                    );
                  },
                ),
              ],
            ),
          ),
      ],
    );
  }
}
import 'package:flutter/material.dart';
import 'ammunition_report.dart';// Rename your ammunition_report.dart to this
import 'convoy_report.dart';
import 'grenade_report.dart';
import 'patrolling_report.dart';



class ReportTypeSelectorPage extends StatelessWidget {
  const ReportTypeSelectorPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> reportTypes = [
      {
        'title': 'SA Firing Report',
        'icon': Icons.local_fire_department,
        'page': const ReportGeneratorPage(),
      },
      {
        'title': 'Mov Report',
        'icon': Icons.directions_bus,
        'page': const ConvoyReportPage(),
      },
      {
        'title': 'Grenade Firing Report',
        'icon': Icons.brightness_high,
        'page': const GrenadeReportPage(),
      },
      {
        'title': 'Patrolling Report',
        'icon': Icons.directions_walk,
        'page': const PatrollingReportPage(),
      },
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFA8D5A2),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Select Report Type',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: reportTypes.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final report = reportTypes[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => report['page']),
              );
            },
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
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
                  Icon(report['icon'], color: const Color(0xFF006400), size: 32),
                  const SizedBox(width: 16),
                  Text(
                    report['title'],
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class PlaceholderPage extends StatelessWidget {
  final String title;
  const PlaceholderPage(this.title, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFA8D5A2),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(title, style: const TextStyle(color: Colors.black)),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'This form is coming soon!',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/user_data.dart';

// Global Profile Data Manager - This persists across page navigation
class ProfileDataManager {
  static final ProfileDataManager _instance = ProfileDataManager._internal();
  factory ProfileDataManager() => _instance;
  ProfileDataManager._internal();

  // //   // This data persists across the entire app session
  //   Map<String, String> savedData = {
  //     'name': 'Rafid Kabir',
  //     'phone': '+880 1769 XXXXX',
  //     'email': 'rafid.kabir@army.mil.bd',
  //     'location': 'Rangpur Cantonment',
  //     'rank': 'Lieutenant',
  //     'unit': '1 Signal Battalion',
  //     'serviceNumber': 'BA-12039',
  //     'emergencyContact': '+880 1700 XXXXX',
  //   };

  // Map<String, bool> starStatus = {
  //     'name': false,
  //     'phone': true,
  //     'email': false,
  //     'location': false,
  //     'rank': true,
  //     'unit': false,
  //     'serviceNumber': false,
  //     'emergencyContact': true,
  //   };

  Map<String, String> savedData = {
    'name': '',
    'phone': '',
    'email': '',
    'location': '',
    'rank': '',
    'unit': '',
    'serviceNumber': '',
    'emergencyContact': '',
  };

  Map<String, bool> starStatus = {
    'name': false,
    'phone': false,
    'email': false,
    'location': false,
    'rank': false,
    'unit': false,
    'serviceNumber': false,
    'emergencyContact': false,
  };

  void updateData(String key, String value) {
    savedData[key] = value;
  }

  void updateStarStatus(String key, bool status) {
    starStatus[key] = status;
    print(key);
    print(status);
  }

  void deleteField(String key) {
    savedData[key] = '';
    starStatus[key] = false;
  }
}

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  ProfilePageState createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage>
    with TickerProviderStateMixin {
  bool isEditing = false;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  // Get the global profile data manager
  final ProfileDataManager _profileManager = ProfileDataManager();
  // Controllers for editable fields
  late TextEditingController nameController;
  late TextEditingController phoneController;
  late TextEditingController emailController;
  late TextEditingController locationController;
  late TextEditingController rankController;
  late TextEditingController unitController;
  late TextEditingController serviceNumberController;
  late TextEditingController emergencyContactController;

  Future<void> updateStarStatus(String field) async {
    try {
      await FirebaseFirestore.instance.collection('user').doc(UserData.uid).set(
        {
          'stars': {field: _profileManager.starStatus[field]},
        },
        SetOptions(merge: true),
      );

      print('Profile updated successfully in Firebase.');
    } catch (e) {
      print('Error updating profile in Firebase: $e');
    }
  }

  Future<void> fetchProfileInfo(String userId) async {
    try {
      // Fetch the user's profile document from Firestore
      final DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('user')
          .doc(UserData.uid)
          .get();

      if (userDoc.exists) {
        final data = userDoc.data() as Map<String, dynamic>?;
        _profileManager.savedData = {
          'name': data?['name'] ?? '',
          'phone': data?['contact'] ?? '',
          'email': data?['email'] ?? '',
          'location': data?['location'] ?? '',
          'rank': data?['rank'] ?? '',
          'unit': data?['unitName'] ?? '',
          'serviceNumber': data?['idNumber'] ?? '',
          'emergencyContact': data?['contact'] ?? '',
        };

        final starStatusList = (data?['stars'] as Map?)
            ?.cast<String, dynamic>();
        print(starStatusList);

        setState(() {
          if (starStatusList != null && starStatusList.isNotEmpty) {
            starStatusList.forEach((key, value) {
              _profileManager.updateStarStatus(key, value);
            });
          }

          _initializeControllers();
        });
      } else {
        print('No profile found for userId: $userId');
      }
    } catch (e) {
      print('Error fetching profile info: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchProfileInfo(UserData.uid);
    });
    // Initialize controllers with saved data
    _initializeControllers();
  }

  void _initializeControllers() {
    // Load data from global profile manager
    nameController = TextEditingController(
      text: _profileManager.savedData['name']!,
    );
    phoneController = TextEditingController(
      text: _profileManager.savedData['phone']!,
    );
    emailController = TextEditingController(
      text: _profileManager.savedData['email']!,
    );
    locationController = TextEditingController(
      text: _profileManager.savedData['location']!,
    );
    rankController = TextEditingController(
      text: _profileManager.savedData['rank']!,
    );
    unitController = TextEditingController(
      text: _profileManager.savedData['unit']!,
    );
    serviceNumberController = TextEditingController(
      text: _profileManager.savedData['serviceNumber']!,
    );
    emergencyContactController = TextEditingController(
      text: _profileManager.savedData['emergencyContact']!,
    );
  }

  Future<void> updateProfile() async {
    try {
      await FirebaseFirestore.instance
          .collection('user')
          .doc(UserData.uid)
          .update({
            'name': nameController.text,
            'phone': phoneController.text,
            'email': emailController.text,
            'location': locationController.text,
            'rank': rankController.text,
            'unitName': unitController.text,
            'serviceNumber': serviceNumberController.text,
            'emergencyContact': emergencyContactController.text,
          });

      print('Profile updated successfully in Firebase.');
    } catch (e) {
      print('Error updating profile in Firebase: $e');
    }
  }

  void _saveChanges() async {
    _profileManager.updateData('name', nameController.text);
    _profileManager.updateData('phone', phoneController.text);
    _profileManager.updateData('email', emailController.text);
    _profileManager.updateData('location', locationController.text);
    _profileManager.updateData('rank', rankController.text);
    _profileManager.updateData('unit', unitController.text);
    _profileManager.updateData('serviceNumber', serviceNumberController.text);
    _profileManager.updateData(
      'emergencyContact',
      emergencyContactController.text,
    );

    await updateProfile();
  }

  void _discardChanges() {
    // Restore controllers to saved values from global manager
    nameController.text = _profileManager.savedData['name']!;
    phoneController.text = _profileManager.savedData['phone']!;
    emailController.text = _profileManager.savedData['email']!;
    locationController.text = _profileManager.savedData['location']!;
    rankController.text = _profileManager.savedData['rank']!;
    unitController.text = _profileManager.savedData['unit']!;
    serviceNumberController.text = _profileManager.savedData['serviceNumber']!;
    emergencyContactController.text =
        _profileManager.savedData['emergencyContact']!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _profileManager.savedData['unit']!,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFFA8D5A2),
        elevation: 0,
        automaticallyImplyLeading: false,
        actions: [
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: IconButton(
              key: ValueKey(isEditing),
              icon: Icon(isEditing ? Icons.save : Icons.edit),
              onPressed: () {
                if (isEditing) {
                  // Save changes when switching from edit to view mode
                  _saveChanges();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Row(
                        children: [
                          Icon(Icons.check_circle, color: Colors.white),
                          SizedBox(width: 8),
                          Text('Profile updated and saved successfully!'),
                        ],
                      ),
                      backgroundColor: Colors.green[600],
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  );
                }
                setState(() {
                  isEditing = !isEditing;
                });
              },
            ),
          ),
          if (isEditing)
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                // Discard changes and switch back to view mode
                _discardChanges();
                setState(() {
                  isEditing = false;
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Row(
                      children: [
                        Icon(Icons.cancel, color: Colors.white),
                        SizedBox(width: 8),
                        Text('Changes discarded'),
                      ],
                    ),
                    backgroundColor: Colors.orange[600],
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                );
              },
            ),
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () => _showMoreOptions(),
          ),
        ],
      ),
      backgroundColor: const Color(0xFFA8D5A2),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              // Modern Header Section
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.green[700], // Using your original green theme
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    // Profile Picture with Status
                    Stack(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 3),
                          ),
                          child: CircleAvatar(
                            radius: 50,
                            backgroundColor:
                                Colors.green, // Your original green avatar
                            // child: Icon(
                            //   Icons.security,
                            //   size: 50,
                            //   color: Colors.white, // Your original white icon
                            // ),
                            child: Image.network(
                              'https://cdn-icons-png.flaticon.com/512/5436/5436245.png',
                              height: 80,
                              width: 80,
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                              color: Colors.green,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.camera_alt,
                              size: 20,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      _profileManager
                          .savedData['name']!, // Display saved name from global manager
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      _profileManager
                          .savedData['rank']!, // Display saved rank from global manager
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Quick Stats Row
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _StatItem(
                            icon: Icons.star,
                            label: 'Starred',
                            value: '3',
                          ),
                          _StatItem(
                            icon: Icons.security,
                            label: 'Active',
                            value: '24/7',
                          ),
                          _StatItem(
                            icon: Icons.verified,
                            label: 'Verified',
                            value: '✓',
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),

              // Profile Information Cards
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionHeader('Personal Information'),
                    _buildModernProfileCard(
                      icon: Icons.person,
                      label: 'Full Name',
                      controller: nameController,
                      fieldKey: 'name',
                      color: Colors.blue,
                    ),
                    _buildModernProfileCard(
                      icon: Icons.military_tech,
                      label: 'Rank',
                      controller: rankController,
                      fieldKey: 'rank',
                      color: Colors.orange,
                    ),
                    _buildModernProfileCard(
                      icon: Icons.badge,
                      label: 'Service Number',
                      controller: serviceNumberController,
                      fieldKey: 'serviceNumber',
                      color: Colors.purple,
                    ),

                    const SizedBox(height: 20),
                    _buildSectionHeader('Contact Information'),
                    _buildModernProfileCard(
                      icon: Icons.phone,
                      label: 'Phone Number',
                      controller: phoneController,
                      fieldKey: 'phone',
                      color: Colors.green,
                    ),
                    _buildModernProfileCard(
                      icon: Icons.email,
                      label: 'Email Address',
                      controller: emailController,
                      fieldKey: 'email',
                      color: Colors.red,
                    ),
                    _buildModernProfileCard(
                      icon: Icons.emergency,
                      label: 'Emergency Contact',
                      controller: emergencyContactController,
                      fieldKey: 'emergencyContact',
                      color: Colors.deepOrange,
                    ),

                    const SizedBox(height: 20),
                    _buildSectionHeader('Unit Information'),
                    _buildModernProfileCard(
                      icon: Icons.group,
                      label: 'Unit',
                      controller: unitController,
                      fieldKey: 'unit',
                      color: Colors.indigo,
                    ),
                    _buildModernProfileCard(
                      icon: Icons.location_on,
                      label: 'Location',
                      controller: locationController,
                      fieldKey: 'location',
                      color: Colors.teal,
                    ),

                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, top: 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.grey[700],
        ),
      ),
    );
  }

  Widget _buildModernProfileCard({
    required IconData icon,
    required String label,
    required TextEditingController controller,
    required String fieldKey,
    required Color color,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        title: isEditing
            ? TextField(
                controller: controller,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
                decoration: InputDecoration(
                  labelText: label,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: color),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: color, width: 2),
                  ),
                  isDense: true,
                ),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    controller.text.isEmpty ? 'Not provided' : controller.text,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: controller.text.isEmpty
                          ? Colors.grey[400]
                          : Colors.black87,
                    ),
                  ),
                ],
              ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Star button with animation
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              child: IconButton(
                icon: Icon(
                  _profileManager.starStatus[fieldKey] == true
                      ? Icons.star
                      : Icons.star_border,
                  color: _profileManager.starStatus[fieldKey] == true
                      ? Colors.amber
                      : Colors.grey[400],
                  size: 22,
                ),
                onPressed: () async {
                  setState(() {
                    _profileManager.updateStarStatus(
                      fieldKey,
                      !_profileManager.starStatus[fieldKey]!,
                    );
                  });
                  await updateStarStatus(fieldKey);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Row(
                        children: [
                          Icon(
                            _profileManager.starStatus[fieldKey] == true
                                ? Icons.star
                                : Icons.star_border,
                            color: Colors.white,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            _profileManager.starStatus[fieldKey] == true
                                ? '$label marked as favorite'
                                : '$label removed from favorites',
                          ),
                        ],
                      ),
                      backgroundColor:
                          _profileManager.starStatus[fieldKey] == true
                          ? Colors.amber[700]
                          : Colors.grey[600],
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      duration: const Duration(seconds: 1),
                    ),
                  );
                },
              ),
            ),
            // Delete button
            IconButton(
              icon: Icon(
                Icons.delete_outline,
                color: Colors.red[400],
                size: 22,
              ),
              onPressed: () => _showDeleteDialog(label, fieldKey, controller),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteDialog(
    String label,
    String fieldKey,
    TextEditingController controller,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: Colors.orange[600]),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Delete $label',
                  overflow: TextOverflow.ellipsis, // Prevent title overflow
                ),
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: Text(
              'Are you sure you want to delete this $label information? This action cannot be undone.',
            ),
          ),
          actions: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal, // Prevent actions overflow
              child: Row(
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Cancel'),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      setState(() {
                        controller.clear();
                        _profileManager.deleteField(fieldKey);
                      });
                      await updateProfile();
                      Navigator.of(context).pop();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Row(
                            children: [
                              const Icon(Icons.delete, color: Colors.white),
                              const SizedBox(width: 8),
                              Text('$label deleted and saved permanently'),
                            ],
                          ),
                          backgroundColor: Colors.red[600],
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                    child: const Text(
                      'Delete',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  void _showMoreOptions() {
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
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            ListTile(
              leading: const Icon(Icons.backup, color: Colors.blue),
              title: const Text('Backup Profile'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Profile backed up successfully!'),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.share, color: Colors.green),
              title: const Text('Share Profile'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Profile shared!')),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.security, color: Colors.orange),
              title: const Text('Security Settings'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text('Sign Out'),
              onTap: () async {
                await FirebaseAuth.instance.signOut();
                UserData.reset();
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/welcome',
                  (route) => false,
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    nameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    locationController.dispose();
    rankController.dispose();
    unitController.dispose();
    serviceNumberController.dispose();
    emergencyContactController.dispose();
    super.dispose();
  }
}

class _StatItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _StatItem({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 24),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        Text(
          label,
          style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 12),
        ),
      ],
    );
  }
}
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/widgets/snackbar.dart';
import '../widgets/search_bar_widget.dart';

// Define a class for individual request items
class RequestItem {
  final String name;
  final String phone;
  String status; // 'pending', 'accepted', 'rejected'

  RequestItem({
    required this.name,
    required this.phone,
    this.status = 'pending',
  });
}

class PendingRequests extends StatefulWidget {
  const PendingRequests({super.key});

  @override
  State<PendingRequests> createState() => _PendingRequestsState();
}

class _PendingRequestsState extends State<PendingRequests> {
  List<Map<String, dynamic>> pendUserData = [];
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await fetchPendingReqs(context);
    });
  }

  Future<void> fetchPendingReqs(BuildContext context) async {
    try {
      final QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('user')
          .where('role', isEqualTo: 'Unit Admin')
          .where('status', isEqualTo: 'pending')
          .get();

      setState(() {
        pendUserData = snapshot.docs
            .map((doc) => doc.data() as Map<String, dynamic>)
            .toList();
      });
    } on FirebaseAuthException catch (e) {
      context.showErrorSnackBar(message: e.toString());
    } catch (e) {
      context.showErrorSnackBar(message: e.toString());
    }
  }

  // Using a List of RequestItem objects to manage state
  final List<RequestItem> _requests = [
    RequestItem(name: 'Lt Rafid', phone: '+880 1769 XXXXX', status: 'pending'),
    RequestItem(
      name: 'Lt Abdullah',
      phone: '+880 1769 XXXXX',
      status: 'pending',
    ),
    RequestItem(name: 'Capt Omar', phone: '+880 1769 XXXXX', status: 'pending'),
    RequestItem(
      name: 'Capt Saikat',
      phone: '+880 1769 XXXXX',
      status: 'pending',
    ),
    RequestItem(name: 'Lt Rohan', phone: '+880 1769 XXXXX', status: 'pending'),
    RequestItem(name: 'Lt Asif', phone: '+880 1769 XXXXX', status: 'pending'),
    RequestItem(
      name: 'Capt Titumir',
      phone: '+880 1769 XXXXX',
      status: 'pending',
    ),
    RequestItem(
      name: 'Capt Zainab',
      phone: '+880 1769 XXXXX',
      status: 'pending',
    ),
    RequestItem(name: 'Lt Tara', phone: '+880 1769 XXXXX', status: 'pending'),
    RequestItem(name: 'Lt Sara', phone: '+880 1769 XXXXX', status: 'pending'),
    RequestItem(
      name: 'Capt Oysik',
      phone: '+880 1769 XXXXX',
      status: 'pending',
    ),
    RequestItem(
      name: 'Capt Rahul',
      phone: '+880 1769 XXXXX',
      status: 'pending',
    ),
  ];

  void _acceptRequest(Map<String, dynamic> request) async {
    try {
      await FirebaseFirestore.instance
          .collection('user')
          .doc(request['uid']) // make sure 'uid' exists in the map
          .update({'status': 'accepted'});

      setState(() {
        request['status'] = 'accepted';
      });

      _showMessageBox(
        context,
        'Request Accepted',
        '${request['name']}\'s request has been accepted.',
      );
    } catch (e) {
      _showMessageBox(context, 'Error', 'Failed to accept request: $e');
    }
  }

  void _rejectRequest(Map<String, dynamic> request) async {
    try {
      await FirebaseFirestore.instance
          .collection('user')
          .doc(request['uid'])
          .update({'status': 'rejected'});

      setState(() {
        request['status'] = 'rejected';
      });

      _showMessageBox(
        context,
        'Request Rejected',
        '${request['name']}\'s request has been rejected.',
      );
    } catch (e) {
      _showMessageBox(context, 'Error', 'Failed to reject request: $e');
    }
  }

  void _showMessageBox(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  // Helper to get icon based on status
  IconData _getStatusIcon(String status) {
    switch (status) {
      case 'accepted':
        return Icons.check_circle;
      case 'rejected':
        return Icons.cancel;
      default:
        return Icons.pending_actions;
    }
  }

  // Helper to get color based on status
  Color _getStatusColor(String status) {
    switch (status) {
      case 'accepted':
        return Colors.green;
      case 'rejected':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFA8D5A2),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const Icon(Icons.menu, color: Colors.black),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: Icon(Icons.notifications_none, color: Colors.black),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Pending Requests',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: SearchBarWidget(hintText: 'Search...'),
            ),
            const SizedBox(height: 10),
            ListView.builder(
              shrinkWrap: true, // Important for nested ListView
              physics:
                  const NeverScrollableScrollPhysics(), // Disable inner scrolling
              itemCount: pendUserData.length,
              itemBuilder: (context, index) {
                final request = pendUserData[index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                    vertical: 8.0,
                    horizontal: 16.0,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  elevation: 3,
                  child: ListTile(
                    leading: Icon(
                      _getStatusIcon(request['status']),
                      color: _getStatusColor(request['status']),
                    ),
                    title: Text(
                      request['name'],
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        decoration: request['status'] == 'rejected'
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                        color: request['status'] == 'rejected'
                            ? Colors.grey
                            : Colors.black,
                      ),
                    ),
                    subtitle: Text(
                      request['contact'],
                      style: TextStyle(color: Colors.grey[600], fontSize: 13),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(
                            Icons.check_circle,
                            color: request['status'] == 'accepted'
                                ? Colors.green
                                : Colors.grey,
                          ),
                          onPressed: request['status'] == 'pending'
                              ? () => _acceptRequest(request)
                              : null, // Disable if already acted upon
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.cancel,
                            color: request['status'] == 'rejected'
                                ? Colors.red
                                : Colors.grey,
                          ),
                          onPressed: request['status'] == 'pending'
                              ? () => _rejectRequest(request)
                              : null, // Disable if already acted upon
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PDFViewerScreen extends StatelessWidget {
  final String pdfAssetPath;

  const PDFViewerScreen({super.key, required this.pdfAssetPath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PDF Viewer'),
        backgroundColor: const Color(0xFF006400),
        foregroundColor: Colors.white,
      ),
      body: SfPdfViewer.asset(pdfAssetPath),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';


class PatrollingReportPage extends StatefulWidget {
  const PatrollingReportPage({super.key});

  @override
  State<PatrollingReportPage> createState() => _PatrollingReportPageState();
}

class _PatrollingReportPageState extends State<PatrollingReportPage> {
  final _formKey = GlobalKey<FormState>();

  DateTime? selectedDate;
  final destinationController = TextEditingController();
  final purposeController = TextEditingController();
  final officerStrengthController = TextEditingController();
  final jcoStrengthController = TextEditingController();
  final ncoStrengthController = TextEditingController();
  final startTimeController = TextEditingController();
  final riflesController = TextEditingController();
  final lmgController = TextEditingController();
  final smgController = TextEditingController();
  final vehicleStateController = TextEditingController();
  final commanderRankController = TextEditingController();
  final commanderNameController = TextEditingController();

  List<TextEditingController> routeControllers = [];

  String generatedReport = '';

  void addRouteCheckpoint() {
    setState(() {
      routeControllers.add(TextEditingController());
    });
  }

  void generateReport() {
    if (_formKey.currentState!.validate()) {
      final formattedDate = selectedDate != null
          ? DateFormat('dd MMMM yyyy').format(selectedDate!)
          : 'Not selected';

      String routeText = routeControllers
          .where((c) => c.text.isNotEmpty)
          .map((c) => '• ${c.text}')
          .join('\n');

      setState(() {
        generatedReport = '''
Assalamu Alaikum sir, 

Date: $formattedDate  
Destination: ${destinationController.text}  
Purpose: ${purposeController.text}  
Total Strength: Officers - ${officerStrengthController.text}, JCOs - ${jcoStrengthController.text}, NCOs - ${ncoStrengthController.text}  
Rifles Carried: ${riflesController.text}  
LMG's Carried: ${lmgController.text}  
SMG's Carried: ${smgController.text}  
Vehicle State: ${vehicleStateController.text}  
Start Time: ${startTimeController.text}  
Route:
$routeText

After ptl, man and mat all correct, sir.  
For your kind info, sir.

Regards  
${commanderRankController.text} ${commanderNameController.text}
''';
      });
    }
  }

  @override
  void dispose() {
    destinationController.dispose();
    purposeController.dispose();
    officerStrengthController.dispose();
    jcoStrengthController.dispose();
    ncoStrengthController.dispose();
    startTimeController.dispose();
    riflesController.dispose();
    lmgController.dispose();
    smgController.dispose();
    vehicleStateController.dispose();
    commanderRankController.dispose();
    commanderNameController.dispose();
    for (final c in routeControllers) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFA8D5A2),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Patrolling Report',
            style: TextStyle(color: Colors.black)),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const Text(
                  'Patrolling Report',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),

                // Date field
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey.shade400),
                        ),
                        child: Text(
                          selectedDate != null
                              ? DateFormat('dd MMM yyyy').format(selectedDate!)
                              : 'Select date',
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () async {
                        final now = DateTime.now();
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: now,
                          firstDate: DateTime(2020),
                          lastDate: DateTime(now.year + 5),
                        );
                        if (picked != null) {
                          setState(() => selectedDate = picked);
                        }
                      },
                      icon: const Icon(Icons.calendar_today, color: Color(0xFF006400)),
                    ),
                  ],
                ),

                const SizedBox(height: 16),
                buildTextField('Destination', destinationController),
                buildTextField('Purpose', purposeController),
                buildTextField('Officers Strength', officerStrengthController,
                    keyboardType: TextInputType.number),
                buildTextField('JCOs Strength', jcoStrengthController,
                    keyboardType: TextInputType.number),
                buildTextField('NCOs Strength', ncoStrengthController,
                    keyboardType: TextInputType.number),
                buildTextField('Start Time', startTimeController),
                buildTextField('Rifles Carried', riflesController),
                buildTextField("LMG's Carried", lmgController),
                buildTextField("SMG's Carried", smgController),
                buildTextField('Vehicle State', vehicleStateController),
                buildTextField('Commander Rank', commanderRankController),
                buildTextField('Commander Name', commanderNameController),

                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Route Checkpoints',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600)),
                    IconButton(
                      onPressed: addRouteCheckpoint,
                      icon: const Icon(Icons.add_circle, color: Color(0xFF006400)),
                    ),
                  ],
                ),
                Column(
                  children: routeControllers
                      .asMap()
                      .entries
                      .map(
                        (entry) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: TextFormField(
                        controller: entry.value,
                        decoration: InputDecoration(
                          labelText: 'Checkpoint ${entry.key + 1}',
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                  )
                      .toList(),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: generateReport,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF006400),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Text(
                    'Generate Report',
                    style: TextStyle(color: Colors.white),
                  ),
                ),

                if (generatedReport.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () => Share.share(generatedReport),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    icon: const Icon(Icons.share, color: Colors.white),
                    label: const Text('Share', style: TextStyle(color: Colors.white)),
                  ),
                ],

                const SizedBox(height: 24),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Generated Report:',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 5,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: SelectableText(
                    generatedReport.isEmpty
                        ? 'No report yet.'
                        : generatedReport,
                    style: const TextStyle(fontSize: 15),
                  ),
                ),
                const SizedBox(height: 70),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildTextField(String label, TextEditingController controller,
      {TextInputType keyboardType = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
        validator: (value) => value!.isEmpty ? 'Required' : null,
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';


class GrenadeReportPage extends StatefulWidget {
  const GrenadeReportPage({super.key});

  @override
  State<GrenadeReportPage> createState() => _GrenadeReportPageState();
}

class _GrenadeReportPageState extends State<GrenadeReportPage> {
  final _formKey = GlobalKey<FormState>();

  DateTime? selectedDate;
  final unitController = TextEditingController();
  final officerStrengthController = TextEditingController();
  final jcoStrengthController = TextEditingController();
  final ncoStrengthController = TextEditingController();
  final startTimeController = TextEditingController();
  final endTimeController = TextEditingController();
  final grenadesCarriedController = TextEditingController();
  final grenadesFiredController = TextEditingController();
  final vehicleStateController = TextEditingController();
  final commanderRankController = TextEditingController();
  final commanderNameController = TextEditingController();

  String generatedReport = '';

  Future<void> pickDate() async {
    final now = DateTime.now();
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(2020),
      lastDate: DateTime(now.year + 5),
    );
    if (picked != null) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  void generateReport() {
    if (_formKey.currentState!.validate()) {
      final formattedDate = selectedDate != null
          ? DateFormat('dd MMMM yyyy').format(selectedDate!)
          : 'Not selected';

      setState(() {
        generatedReport = '''
Assalamu Alaikum sir, 

Date: $formattedDate  
Unit: ${unitController.text}  
Total Strength: Officers - ${officerStrengthController.text}, JCOs - ${jcoStrengthController.text}, NCOs - ${ncoStrengthController.text}  
Grenades Carried: ${grenadesCarriedController.text}  
Grenades Fired: ${grenadesFiredController.text}  
Vehicle State: ${vehicleStateController.text}  
Start Time: ${startTimeController.text}  
End Time: ${endTimeController.text}  

After gren firing, man and mat all correct, sir.  
For your kind info, sir.

Regards  
${commanderRankController.text} ${commanderNameController.text}
''';
      });
    }
  }

  @override
  void dispose() {
    unitController.dispose();
    officerStrengthController.dispose();
    jcoStrengthController.dispose();
    ncoStrengthController.dispose();
    startTimeController.dispose();
    endTimeController.dispose();
    grenadesCarriedController.dispose();
    grenadesFiredController.dispose();
    vehicleStateController.dispose();
    commanderRankController.dispose();
    commanderNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFA8D5A2),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Gren Firing Report',
            style: TextStyle(color: Colors.black)),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const Text(
                  'Generate Gren Firing Report',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),

                // Date
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey.shade400),
                        ),
                        child: Text(
                          selectedDate != null
                              ? DateFormat('dd MMM yyyy').format(selectedDate!)
                              : 'Select date',
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: pickDate,
                      icon: const Icon(Icons.calendar_today, color: Color(0xFF006400)),
                    ),
                  ],
                ),

                const SizedBox(height: 16),
                buildTextField('Unit Name', unitController),
                buildTextField('Officers Strength', officerStrengthController,
                    keyboardType: TextInputType.number),
                buildTextField('JCOs Strength', jcoStrengthController,
                    keyboardType: TextInputType.number),
                buildTextField('NCOs Strength', ncoStrengthController,
                    keyboardType: TextInputType.number),
                buildTextField('Start Time', startTimeController),
                buildTextField('End Time', endTimeController),
                buildTextField('Grenades Carried', grenadesCarriedController),
                buildTextField('Grenades Fired', grenadesFiredController),
                buildTextField('Vehicle State', vehicleStateController),
                buildTextField('Commander Rank', commanderRankController),
                buildTextField('Commander Name', commanderNameController),

                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: generateReport,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF006400),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Text(
                    'Generate Report',
                    style: TextStyle(color: Colors.white),
                  ),
                ),

                if (generatedReport.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () => Share.share(generatedReport),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    icon: const Icon(Icons.share, color: Colors.white),
                    label: const Text('Share', style: TextStyle(color: Colors.white)),
                  ),
                ],

                const SizedBox(height: 24),

                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Generated Report:',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 5,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: SelectableText(
                    generatedReport.isEmpty
                        ? 'No report yet.'
                        : generatedReport,
                    style: const TextStyle(fontSize: 15),
                  ),
                ),
                const SizedBox(height: 70),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildTextField(String label, TextEditingController controller,
      {TextInputType keyboardType = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
        validator: (value) => value!.isEmpty ? 'Required' : null,
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';


class GrenadeReportPage extends StatefulWidget {
  const GrenadeReportPage({super.key});

  @override
  State<GrenadeReportPage> createState() => _GrenadeReportPageState();
}

class _GrenadeReportPageState extends State<GrenadeReportPage> {
  final _formKey = GlobalKey<FormState>();

  DateTime? selectedDate;
  final unitController = TextEditingController();
  final officerStrengthController = TextEditingController();
  final jcoStrengthController = TextEditingController();
  final ncoStrengthController = TextEditingController();
  final startTimeController = TextEditingController();
  final endTimeController = TextEditingController();
  final grenadesCarriedController = TextEditingController();
  final grenadesFiredController = TextEditingController();
  final vehicleStateController = TextEditingController();
  final commanderRankController = TextEditingController();
  final commanderNameController = TextEditingController();

  String generatedReport = '';

  Future<void> pickDate() async {
    final now = DateTime.now();
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(2020),
      lastDate: DateTime(now.year + 5),
    );
    if (picked != null) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  void generateReport() {
    if (_formKey.currentState!.validate()) {
      final formattedDate = selectedDate != null
          ? DateFormat('dd MMMM yyyy').format(selectedDate!)
          : 'Not selected';

      setState(() {
        generatedReport = '''
Assalamu Alaikum sir, 

Date: $formattedDate  
Unit: ${unitController.text}  
Total Strength: Officers - ${officerStrengthController.text}, JCOs - ${jcoStrengthController.text}, NCOs - ${ncoStrengthController.text}  
Grenades Carried: ${grenadesCarriedController.text}  
Grenades Fired: ${grenadesFiredController.text}  
Vehicle State: ${vehicleStateController.text}  
Start Time: ${startTimeController.text}  
End Time: ${endTimeController.text}  

After gren firing, man and mat all correct, sir.  
For your kind info, sir.

Regards  
${commanderRankController.text} ${commanderNameController.text}
''';
      });
    }
  }

  @override
  void dispose() {
    unitController.dispose();
    officerStrengthController.dispose();
    jcoStrengthController.dispose();
    ncoStrengthController.dispose();
    startTimeController.dispose();
    endTimeController.dispose();
    grenadesCarriedController.dispose();
    grenadesFiredController.dispose();
    vehicleStateController.dispose();
    commanderRankController.dispose();
    commanderNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFA8D5A2),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Gren Firing Report',
            style: TextStyle(color: Colors.black)),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const Text(
                  'Generate Gren Firing Report',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),

                // Date
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey.shade400),
                        ),
                        child: Text(
                          selectedDate != null
                              ? DateFormat('dd MMM yyyy').format(selectedDate!)
                              : 'Select date',
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: pickDate,
                      icon: const Icon(Icons.calendar_today, color: Color(0xFF006400)),
                    ),
                  ],
                ),

                const SizedBox(height: 16),
                buildTextField('Unit Name', unitController),
                buildTextField('Officers Strength', officerStrengthController,
                    keyboardType: TextInputType.number),
                buildTextField('JCOs Strength', jcoStrengthController,
                    keyboardType: TextInputType.number),
                buildTextField('NCOs Strength', ncoStrengthController,
                    keyboardType: TextInputType.number),
                buildTextField('Start Time', startTimeController),
                buildTextField('End Time', endTimeController),
                buildTextField('Grenades Carried', grenadesCarriedController),
                buildTextField('Grenades Fired', grenadesFiredController),
                buildTextField('Vehicle State', vehicleStateController),
                buildTextField('Commander Rank', commanderRankController),
                buildTextField('Commander Name', commanderNameController),

                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: generateReport,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF006400),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Text(
                    'Generate Report',
                    style: TextStyle(color: Colors.white),
                  ),
                ),

                if (generatedReport.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () => Share.share(generatedReport),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    icon: const Icon(Icons.share, color: Colors.white),
                    label: const Text('Share', style: TextStyle(color: Colors.white)),
                  ),
                ],

                const SizedBox(height: 24),

                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Generated Report:',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 5,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: SelectableText(
                    generatedReport.isEmpty
                        ? 'No report yet.'
                        : generatedReport,
                    style: const TextStyle(fontSize: 15),
                  ),
                ),
                const SizedBox(height: 70),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildTextField(String label, TextEditingController controller,
      {TextInputType keyboardType = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
        validator: (value) => value!.isEmpty ? 'Required' : null,
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'pdf_viewer.dart';

class DocumentsPage extends StatefulWidget {
  const DocumentsPage({super.key});

  @override
  State<DocumentsPage> createState() => _DocumentsPageState();
}

class _DocumentsPageState extends State<DocumentsPage> {
  List<String> _savedDocuments = [];

  @override
  void initState() {
    super.initState();
    _loadSavedDocuments();
  }

  Future<void> _loadSavedDocuments() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _savedDocuments = prefs.getStringList('saved_documents') ?? [];
    });
  }

  void _openPDF(String path) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PDFViewerScreen(pdfAssetPath: path),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFA8D5A2),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Saved Documents'),
        iconTheme: const IconThemeData(color: Colors.black),
        titleTextStyle: const TextStyle(
          color: Colors.black,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView.builder(
          itemCount: _savedDocuments.length,
          itemBuilder: (context, index) {
            final doc = _savedDocuments[index];
            final title = doc.split('/').last.replaceAll('.pdf', '');
            return Container(
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
              child: ListTile(
                leading: const Icon(Icons.picture_as_pdf, color: Color(0xFF006400)),
                title: Text(title),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () => _openPDF(doc),
              ),
            );
          },
        ),
      ),
    );
  }

  static Future<void> saveDocument(String assetPath) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> saved = prefs.getStringList('saved_documents') ?? [];
    if (!saved.contains(assetPath)) {
      saved.add(assetPath);
      await prefs.setStringList('saved_documents', saved);
    }
  }
}
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';


class ConvoyReportPage extends StatefulWidget {
  const ConvoyReportPage({super.key});

  @override
  State<ConvoyReportPage> createState() => _ConvoyReportPageState();
}

class _ConvoyReportPageState extends State<ConvoyReportPage> {
  final _formKey = GlobalKey<FormState>();

  final destinationController = TextEditingController();
  final commanderNameController = TextEditingController();
  final contactNumberController = TextEditingController();
  final strengthController = TextEditingController();
  final itemsCarriedController = TextEditingController();
  final vehicleStateController = TextEditingController();
  final startTimeController = TextEditingController();
  final presentLocationController = TextEditingController();
  final commanderRankController = TextEditingController();
  final commanderDisplayNameController = TextEditingController();

  List<TextEditingController> routeControllers = [];

  String generatedReport = '';

  void addCheckpoint() {
    setState(() {
      routeControllers.add(TextEditingController());
    });
  }

  void generateReport() {
    if (_formKey.currentState!.validate()) {
      String route = routeControllers
          .where((c) => c.text.isNotEmpty)
          .map((c) => '• ${c.text}')
          .join('\n');

      setState(() {
        generatedReport = '''
Assalamu Alaikum sir, 

I, ${commanderRankController.text} ${commanderDisplayNameController.text}, have started for ${destinationController.text} at ${startTimeController.text} with fol under my disposal:

Total Strength: ${strengthController.text}  
Items Carried: ${itemsCarriedController.text}  
Vehicle State: ${vehicleStateController.text}  
Route:
$route
Present Location: ${presentLocationController.text}  

For your kind info, sir.

Regards  
${commanderRankController.text} ${commanderDisplayNameController.text}
''';
      });
    }
  }

  @override
  void dispose() {
    destinationController.dispose();
    commanderNameController.dispose();
    contactNumberController.dispose();
    strengthController.dispose();
    itemsCarriedController.dispose();
    vehicleStateController.dispose();
    startTimeController.dispose();
    presentLocationController.dispose();
    commanderRankController.dispose();
    commanderDisplayNameController.dispose();
    for (final controller in routeControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFA8D5A2),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Mov Report',
            style: TextStyle(color: Colors.black)),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const Text(
                  'Generate Mov Report',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),

                // Text fields
                buildTextField('Destination', destinationController),
                buildTextField("Commander's Name", commanderNameController),
                buildTextField('Contact Number', contactNumberController,
                    keyboardType: TextInputType.phone),
                buildTextField('Total Strength', strengthController),
                buildTextField('Items Carried', itemsCarriedController),
                buildTextField('Vehicle State', vehicleStateController),
                buildTextField('Start Time', startTimeController),
                buildTextField('Present Location', presentLocationController),
                buildTextField('Commander Rank', commanderRankController),
                buildTextField('Commander Display Name', commanderDisplayNameController),

                const SizedBox(height: 16),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Route Checkpoints',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600)),
                    IconButton(
                      onPressed: addCheckpoint,
                      icon: const Icon(Icons.add_circle, color: Color(0xFF006400)),
                    ),
                  ],
                ),
                Column(
                  children: routeControllers
                      .asMap()
                      .entries
                      .map(
                        (entry) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: TextFormField(
                        controller: entry.value,
                        decoration: InputDecoration(
                          labelText: 'Checkpoint ${entry.key + 1}',
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                  )
                      .toList(),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: generateReport,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF006400),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Text(
                    'Generate Report',
                    style: TextStyle(color: Colors.white),
                  ),
                ),

                if (generatedReport.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () => Share.share(generatedReport),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    icon: const Icon(Icons.share, color: Colors.white),
                    label: const Text('Share', style: TextStyle(color: Colors.white)),
                  ),
                ],

                const SizedBox(height: 24),

                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Generated Report:',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 5,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: SelectableText(
                    generatedReport.isEmpty
                        ? 'No report yet.'
                        : generatedReport,
                    style: const TextStyle(fontSize: 15),
                  ),
                ),
                const SizedBox(height: 70),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildTextField(String label, TextEditingController controller,
      {TextInputType keyboardType = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
        validator: (value) => value!.isEmpty ? 'Required' : null,
      ),
    );
  }
}
import 'package:flutter/material.dart';

// void main() {
//   runApp(const ContactBook());
// }

class ContactBook extends StatelessWidget {
  const ContactBook({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Contact Book',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF006400)),
      ),
      home: const AdminDashboard(),
    );
  }
}

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  final List<Map<String, dynamic>> allContacts = [
    {
      "title": "Dhaka Exchange",
      "contacts": [
        { "area": "Kishoreganj Sadar", "phone": "01769511141" },
        { "area": "Hossainpur", "phone": "01769511141" },
        { "area": "Katiadi", "phone": "01769511141" },
        { "area": "Pakundia", "phone": "01769511141" },
        { "area": "Bhairab", "phone": "01769202356" },
        { "area": "Bajitpur", "phone": "01679435672" },
        { "area": "Kuliarchar", "phone": "01679435672" },
        { "area": "Karimganj", "phone": "01769195023" },
        { "area": "Tarail", "phone": "01769195023" },
        { "area": "Nikli", "phone": "01769195023" },
        { "area": "Mithamain", "phone": "01769215104" },
        { "area": "Austagram", "phone": "01769215104" },
        { "area": "Itna", "phone": "01727969453" },
        { "area": "Tangail Sadar", "phone": "01789317327" },
        { "area": "Basail", "phone": "01769210041" },
        { "area": "Sakhipur", "phone": "01769210041" },
        { "area": "Kalihati", "phone": "01769210042" },
        { "area": "Bhuyapur", "phone": "01769212608" },
        { "area": "Gopalpur", "phone": "01769212608" },
        { "area": "Madhupur", "phone": "01769510926" },
        { "area": "Dhanbari", "phone": "01769510926" },
        { "area": "Mirzapur", "phone": "01769288784" },
        { "area": "Nagarpur", "phone": "01931301799" },
        { "area": "Delduar", "phone": "01931301799" },
        { "area": "Chowhali", "phone": "01931301799" },
        { "area": "Ghatail", "phone": "01769195030" },
        { "area": "Rajbari", "phone": "01769552380" },
        { "area": "Goalondo", "phone": "01769552380" },
        { "area": "Baliakandi", "phone": "01769552380" },
        { "area": "Kalukhali", "phone": "01769552380" },
        { "area": "Pangsha", "phone": "01769552380" },
        { "area": "Madaripur Sadar", "phone": "01769078424" },
        { "area": "Shibchar", "phone": "01769078425" },
        { "area": "Kalkini", "phone": "01769078426" },
        { "area": "Gopalganj Sadar", "phone": "01769552162" },
        { "area": "Kashiani", "phone": "01325789908" },
        { "area": "Muksudpur", "phone": "01769552166" },
        { "area": "Tungipara", "phone": "01769552166" },
        { "area": "Kotalipara", "phone": "01769552166" },
        { "area": "Gazipur", "phone": "01769095198" },
        { "area": "Tongi", "phone": "01769095198" },
        { "area": "Kaliakoir", "phone": "01769095198" },
        { "area": "Kashimpur", "phone": "01769095198" },
        { "area": "Pubail", "phone": "01769095198" },
        { "area": "Kapasia", "phone": "01769095198" },
        { "area": "Kaliganj (Gazipur)", "phone": "01769095198" },
        { "area": "Joydebpur", "phone": "01769095198" },
        { "area": "Narayanganj", "phone": "01769095198" },
        { "area": "Bandar", "phone": "01769095198" },
        { "area": "Fatullah", "phone": "01769095198" },
        { "area": "Siddhirganj", "phone": "01769095198" },
        { "area": "Araihazar", "phone": "01769095198" },
        { "area": "Sonargaon", "phone": "01769095198" },
        { "area": "Rupganj", "phone": "01769095198" },
        { "area": "Munshiganj", "phone": "01769095198" },
        { "area": "Manikganj", "phone": "01769095198" },
        { "area": "Narsingdi", "phone": "01769095198" },
        { "area": "Shariatpur", "phone": "01769095198" },
        { "area": "Faridpur", "phone": "01769095198" }
      ]
    },
    {
      "title": "Savar Exchange",
      "contacts": [
        { "area": "Savar", "phone": "01769095209" },
        { "area": "Ashulia", "phone": "01769095209" },
        { "area": "Hemayetpur", "phone": "01769095198" },
        { "area": "Keraniganj", "phone": "01769095250" },
        { "area": "Dohar", "phone": "01769095209" },
        { "area": "Bipail", "phone": "01769095250" },
        { "area": "Gazipur", "phone": "01769095198" },
        { "area": "Mouchak", "phone": "01769095198" },
        { "area": "Manikganj", "phone": "01769095198" }
      ]
    },
    {
      "title": "Bogura Exchange",
      "contacts": [
        { "area": "Bogura Sadar", "phone": "01769117963" },
        { "area": "Majhira", "phone": "01769117963" },
        { "area": "Dupchanchia", "phone": "01754930866" },
        { "area": "Sariakandi", "phone": "01759961210" },
        { "area": "Sariakandi (alternate)", "phone": "01754930694" }
      ]
    },
    {
      "title": "Cumilla Exchange",
      "contacts": [
        { "area": "Cumilla Sadar", "phone": "017693324440" },
        { "area": "Alekhar Char", "phone": "017693324448" },
        { "area": "Chandina", "phone": "01769331332" },
        { "area": "Chouddagram", "phone": "017693324446" },
        { "area": "Laksam", "phone": "01769332133" },
        { "area": "Nangalkot", "phone": "01769337655" },
        { "area": "Monohorgonj", "phone": "01769332255" },
        { "area": "Burichong", "phone": "01769338197" },
        { "area": "Debidwar", "phone": "01769331057" },
        { "area": "Homna", "phone": "01769330350" },
        { "area": "Daudkandi", "phone": "01769332299" },
        { "area": "Lalmai", "phone": "01811781257" }
      ]
    },
    {
      "title": "Sylhet Exchange",
      "contacts": [
        { "area": "Barlekha", "phone": "01769511081" },
        { "area": "Juri", "phone": "01769511081" },
        { "area": "Kulaura", "phone": "01769511081" },
        { "area": "Moulvibazar", "phone": "01769172386" },
        { "area": "Rajnagar", "phone": "01769172386" },
        { "area": "Sreemangal", "phone": "01769172386" },
        { "area": "Kamalganj", "phone": "01769172386" },
        { "area": "Sunamganj Sadar", "phone": "01769178755" },
        { "area": "Tahirpur", "phone": "01769178755" },
        { "area": "Madhyanagar", "phone": "01769178755" },
        { "area": "Bishwambarpur", "phone": "01769178755" },
        { "area": "Shantiganj", "phone": "01769178755" },
        { "area": "Dirai", "phone": "01769178755" },
        { "area": "Dharampasha", "phone": "01769178755" },
        { "area": "Shalla", "phone": "01769178755" },
        { "area": "Jamalganj", "phone": "01769178755" },
        { "area": "Chatak", "phone": "01575545395" },
        { "area": "Dowarabazar", "phone": "01575545395" },
        { "area": "Jagannathpur", "phone": "01575545395" },
        { "area": "Gowainghat", "phone": "01769177643" },
        { "area": "Jaintiapur", "phone": "01769177643" },
        { "area": "Kanaighat", "phone": "01769177643" },
        { "area": "Zakiganj", "phone": "01769177643" },
        { "area": "Golapganj", "phone": "01769172534" },
        { "area": "Beanibazar", "phone": "01769172534" },
        { "area": "Fenchuganj", "phone": "01769172534" },
        { "area": "Dakshin Surma", "phone": "01769172534" },
        { "area": "Moglabazar", "phone": "01769172534" },
        { "area": "Sylhet Sadar", "phone": "01769172556" },
        { "area": "Jalalabad", "phone": "01769172556" },
        { "area": "Kotwali", "phone": "01769172556" },
        { "area": "Shah Paran", "phone": "01769172556" },
        { "area": "Bimanbandar", "phone": "01769172556" },
        { "area": "Osmaninagar", "phone": "01774540450" },
        { "area": "Balaganj", "phone": "01774540450" },
        { "area": "Bishwanath", "phone": "01774540450" },
        { "area": "Habiganj Sadar", "phone": "01769172614" },
        { "area": "Bahubal", "phone": "01769172614" },
        { "area": "Rashidpur", "phone": "01769172614" },
        { "area": "Baniachong", "phone": "01769172616" },
        { "area": "Nabiganj", "phone": "01769172616" },
        { "area": "Ajmiriganj", "phone": "01769172616" },
        { "area": "Madhabpur", "phone": "01745776488" },
        { "area": "Shayestaganj", "phone": "01745776488" },
        { "area": "Chunarughat", "phone": "01745776488" }
      ]
    },
    {
      "title": "Chattogram Exchange",
      "contacts": [
        { "area": "Mirsharai", "phone": "01769245243" },
        { "area": "Sitakunda", "phone": "01769245243" },
        { "area": "Bayezid Bostami", "phone": "01769245243" },
        { "area": "Hathazari", "phone": "01769242617" },
        { "area": "Rangunia", "phone": "01769242617" },
        { "area": "Rauzan", "phone": "01769245243" },
        { "area": "Khulshi", "phone": "01769253649" },
        { "area": "Halishahar", "phone": "01769253649" },
        { "area": "Pahartali", "phone": "01769253649" },
        { "area": "EPZ", "phone": "01769253649" },
        { "area": "Bandar", "phone": "01769253649" },
        { "area": "Akborshah", "phone": "01769253649" },
        { "area": "Anwara", "phone": "01769244214" },
        { "area": "Karnaphuli", "phone": "01769244214" },
        { "area": "Boalkhali", "phone": "01769244214" },
        { "area": "Kotwali", "phone": "01769242617" },
        { "area": "Double Mooring", "phone": "01769242617" },
        { "area": "Chandgaon", "phone": "01769242617" },
        { "area": "Chawk Bazar", "phone": "01769242617" },
        { "area": "Panchlaish", "phone": "01769242617" },
        { "area": "Sadarghat", "phone": "01769242617" },
        { "area": "Patenga", "phone": "01769253649" },
        { "area": "Potia", "phone": "01336619425" },
        { "area": "Chandanaish", "phone": "01769102401" },
        { "area": "Satkania", "phone": "01858367937" },
        { "area": "Banshkhali", "phone": "01769102822" },
        { "area": "Lohagara", "phone": "01769104554" },
        { "area": "Cox's Bazar Sadar", "phone": "01831387796" },
        { "area": "Eidgaon", "phone": "01769102647" },
        { "area": "Ramu", "phone": "01769102646" },
        { "area": "Ukhia", "phone": "01826552075" },
        { "area": "Chakaria", "phone": "01769104617" },
        { "area": "Pekua", "phone": "01769107469" }
      ]
    },
    {
      "title": "Jashore Exchange",
      "contacts": [
        { "area": "Kushtia", "phone": "01769552362" },
        { "area": "Mirpur", "phone": "01769552362" },
        { "area": "Kumarkhali", "phone": "01769552362" },
        { "area": "Khoksa", "phone": "01769552362" },
        { "area": "Islamic University", "phone": "01769552362" },
        { "area": "Daulatpur", "phone": "01769552362" },
        { "area": "Veramara", "phone": "01769552362" },
        { "area": "Meherpur Sadar", "phone": "01769558450" },
        { "area": "Mujibnagar", "phone": "01769558450" },
        { "area": "Gangni", "phone": "01769558651" },
        { "area": "Jhenaidah", "phone": "01769552436" },
        { "area": "Kaliganj", "phone": "01769552442" },
        { "area": "Shailkupa", "phone": "01769552438" },
        { "area": "Harinakunda", "phone": "01769552436" },
        { "area": "Maheshpur", "phone": "01769552436" },
        { "area": "Kotchandpur", "phone": "01769552436" }
      ]
    },
    {
      "title": "Ramu Exchange",
      "contacts": [
        { "area": "Cox’s Bazar Sadar", "phone": "01831387796" },
        { "area": "Ramu", "phone": "01769102646" },
        { "area": "Eidgaon", "phone": "01769102647" },
        { "area": "Ukhia", "phone": "01826552075" },
        { "area": "Chakaria", "phone": "01769104617" },
        { "area": "Pekua", "phone": "01769107469" }
      ]
    },
      {
        "title": "Rajshahi Exchange",
        "contacts": [
          {"area": "Bogura Sadar", "phone": "01769117963"},
          {"area": "Majhira", "phone": "01754930866"},
          {"area": "Dupchanchia", "phone": "01754930694"},
          {"area": "Sariakandi", "phone": "01759961210"},
          {"area": "Naogaon Sadar", "phone": "01769122122"},
          {"area": "Patnitala", "phone": "01769122107"},
          {"area": "Niamatpur", "phone": "01769122109"},
          {"area": "Joypurhat", "phone": "01769112144"},
          {"area": "Kalai", "phone": "N/A"},
          {"area": "Khetlal", "phone": "N/A"},
          {"area": "Panchbibi", "phone": "N/A"},
          {"area": "Akkelpur", "phone": "N/A"},
          {"area": "Sirajganj Sadar", "phone": "01769126015"},
          {"area": "Belkuchi", "phone": "01769122449"},
          {"area": "Kazipur", "phone": "01769122419"},
          {"area": "Tarash", "phone": "01769122496"},
          {"area": "Ullapara", "phone": "01769122476"},
          {"area": "Natore Sadar", "phone": "01769112447"},
          {"area": "Lalpur", "phone": "01769112454"},
          {"area": "Singra", "phone": "01769112456"},
          {"area": "Rajshahi City", "phone": "01769112388"},
          {"area": "Durgapur", "phone": "01769118971"},
          {"area": "Mohonpur", "phone": "01769118972"},
          {"area": "Charghat", "phone": "01769118973"},
          {"area": "Pabna Sadar", "phone": "01339502710"},
          {"area": "Santhia", "phone": "N/A"},
          {"area": "Bhangura", "phone": "N/A"},
          {"area": "Chapai Nawabganj Sadar", "phone": "01769112372"},
          {"area": "Shibganj", "phone": "01769117392"}
        ]
      },
       {
        "title": "Khulna Exchange",
        "contacts": [
          {"area": "Kushtia Sadar", "phone": "01769552362"},
          {"area": "Mirpur", "phone": "01769558642"},
          {"area": "Kumarkhali", "phone": "N/A"},
          {"area": "Khoksha", "phone": "N/A"},
          {"area": "Islamic University", "phone": "N/A"},
          {"area": "Daulatpur", "phone": "N/A"},
          {"area": "Bheramara", "phone": "N/A"},
          {"area": "Meherpur Sadar", "phone": "01769558450"},
          {"area": "Mujibnagar", "phone": "N/A"},
          {"area": "Gangni", "phone": "01769558651"},
          {"area": "Jhenaidah Sadar", "phone": "01769552436"},
          {"area": "Kaliganj", "phone": "01769552442"},
          {"area": "Shailkupa", "phone": "01769552438"},
          {"area": "Harinakundu", "phone": "N/A"},
          {"area": "Maheshpur", "phone": "N/A"},
          {"area": "Kotchandpur", "phone": "N/A"},
          {"area": "Chuadanga Sadar", "phone": "01769556715"},
          {"area": "Damurhuda", "phone": "01769026006"},
          {"area": "Jibannagar", "phone": "N/A"},
          {"area": "Alamdanga", "phone": "N/A"},
          {"area": "Jashore Sadar", "phone": "01769558168"},
          {"area": "Chowgacha", "phone": "01769558167"},
          {"area": "Bagherpara", "phone": "01769558166"},
          {"area": "Jhikargachha", "phone": "N/A"},
          {"area": "Sharsha", "phone": "N/A"},
          {"area": "Abhaynagar", "phone": "N/A"},
          {"area": "Keshabpur", "phone": "N/A"},
          {"area": "Monirampur", "phone": "N/A"},
          {"area": "Narail Sadar", "phone": "01769554505"},
          {"area": "Lohagara", "phone": "01769558351"},
          {"area": "Naragati", "phone": "N/A"},
          {"area": "Kalia", "phone": "N/A"},
          {"area": "Magura Sadar", "phone": "01769554522"},
          {"area": "Sreepur", "phone": "01797470291"},
          {"area": "Mohammadpur", "phone": "N/A"},
          {"area": "Shalikha", "phone": "N/A"},
          {"area": "Khulna Sadar", "phone": "01334796395"},
          {"area": "Sonadanga", "phone": "01334796399"},
          {"area": "Rupsha", "phone": "01334796398"},
          {"area": "Phultala", "phone": "01334796397"},
          {"area": "Khalishpur", "phone": "01334796400"},
          {"area": "Batiaghata", "phone": "N/A"},
          {"area": "Paikgacha", "phone": "N/A"},
          {"area": "Satkhira", "phone": "01769558647"},
          {"area": "Kalaroa", "phone": "01769558648"},
          {"area": "Tala", "phone": "01769558649"},
          {"area": "Bagerhat Sadar", "phone": "01769078423"},
          {"area": "Moralganj", "phone": "01769078420"},
          {"area": "Mollahat", "phone": "01769078421"},
          {"area": "Chitalmari", "phone": "01769078422"},
          {"area": "Rampal", "phone": "01769078419"}
        ]
      },

      {
        "title": "Barishal Exchange",
        "contacts": [
          {"area": "Barishal Sadar", "phone": "01769078400"},
          {"area": "Hizla", "phone": "01769078403"},
          {"area": "Babuganj", "phone": "01769078404"},
          {"area": "Gournadi", "phone": "01769078405"},
          {"area": "Bakerganj", "phone": "01769078406"},
          {"area": "Bakerganj (2)", "phone": "01769078407"},
          {"area": "Patuakhali Sadar", "phone": "01769078409"},
          {"area": "Mirzaganj", "phone": "01769078408"},
          {"area": "Galachipa", "phone": "01769078410"},
          {"area": "Bauphal", "phone": "01769078411"},
          {"area": "Kalapara", "phone": "01769078412"},
          {"area": "Kalapara (2)", "phone": "01769078413"},
          {"area": "Jhalokathi Sadar", "phone": "01769078414"},
          {"area": "Kathalia", "phone": "01769078415"},
          {"area": "Pirojpur Sadar", "phone": "01769078416"},
          {"area": "Mathbaria", "phone": "01769078417"},
          {"area": "Nesarabad", "phone": "01769078418"}
        ]
      },
    {
      "title": "Mymensingh Exchange",
      "contacts": [
        {"area": "Netrokona Sadar", "phone": "01769202436"},
        {"area": "Atpara", "phone": "01769202436"},
        {"area": "Barhatta", "phone": "01769202436"},
        {"area": "Mohanganj", "phone": "01769202436"},
        {"area": "Madan", "phone": "01303121551"},
        {"area": "Kendua", "phone": "01303121551"},
        {"area": "Khaliajuri", "phone": "01303121551"},
        {"area": "Durgapur", "phone": "01769192096"},
        {"area": "Purbadhala", "phone": "01769192096"},
        {"area": "Mymensingh Sadar", "phone": "01769202516"},
        {"area": "Muktagacha", "phone": "01769202516"},
        {"area": "Fulbaria", "phone": "01769206013"},
        {"area": "Tarakanda", "phone": "01769202530"},
        {"area": "Phulpur", "phone": "01769202530"},
        {"area": "Haluaghat", "phone": "01769202530"},
        {"area": "Dobaura", "phone": "01769202530"},
        {"area": "Gouripur", "phone": "01769192112"},
        {"area": "Ishwarganj", "phone": "01769192112"},
        {"area": "Nandail", "phone": "01769192112"},
        {"area": "Valuka", "phone": "01769192174"},
        {"area": "Trishal", "phone": "01769192174"},
        {"area": "Gafargaon", "phone": "01769192173"},
        {"area": "Jamalpur Sadar", "phone": "01829554592"},
        {"area": "Melandaha", "phone": "01829554592"},
        {"area": "Madaripur", "phone": "01609251960"},
        {"area": "Sarishabari", "phone": "01747326719"},
        {"area": "Dewanganj", "phone": "01769192146"},
        {"area": "Bakshiganj", "phone": "01769192146"},
        {"area": "Islampur", "phone": "01769192146"},
        {"area": "Sherpur Sadar", "phone": "01769192520"},
        {"area": "Nakla", "phone": "01769556666"},
        {"area": "Nalitabari", "phone": "01769556666"},
        {"area": "Sreebardi", "phone": "01769510012"},
        {"area": "Jhenaigati", "phone": "01769510012"}
      ]
    },
    {
      "title": "Rangpur Exchange",
      "contacts": [
        {"area": "Rangpur", "phone": "01769662514"},
        {"area": "Rangpur Cadet College", "phone": "01769512088"},
        {"area": "Rangpur Sadar", "phone": "01769662221"},
        {"area": "Gangachara", "phone": "01769662514"},
        {"area": "Kaunia", "phone": "01769662514"},
        {"area": "Pirgacha", "phone": "01769662514"},
        {"area": "Mithapukur", "phone": "01769662514"},
        {"area": "Taraganj", "phone": "01769662514"},
        {"area": "Pirganj", "phone": "01769662514"},
        {"area": "Badarganj", "phone": "01769662514"},

        {"area": "Barapukuria Coal Mine", "phone": "01769682440"},
        {"area": "Barapukuria Power Plant", "phone": "01886536309"},
        {"area": "Madhyapara Rock Mine", "phone": "01824388574"},
        {"area": "Dinajpur Sadar", "phone": "01721468889"},
        {"area": "Parbatipur (Locomotive Workshop/Oil Refueling)", "phone": "01721468889"},
        {"area": "Birampur", "phone": "01721468889"},
        {"area": "Nawabganj", "phone": "01721468889"},
        {"area": "Hakimpur", "phone": "01721468889"},
        {"area": "Ghoraghat", "phone": "01721468889"},
        {"area": "Kaharole", "phone": "01721468889"},
        {"area": "Bochaganj", "phone": "01721468889"},
        {"area": "Khansama", "phone": "01721468889"},
        {"area": "Biral", "phone": "01721468889"},
        {"area": "Birganj", "phone": "01721468889"},
        {"area": "Chirirbandar", "phone": "01721468889"},
        {"area": "Fulbari", "phone": "01721468889"},

        {"area": "Panchagarh", "phone": "01769672598"},
        {"area": "Panchagarh Sadar", "phone": "01769676721"},
        {"area": "Tetulia", "phone": "01769675006"},
        {"area": "Atwari", "phone": "01769672598"},
        {"area": "Debiganj", "phone": "01769672598"},
        {"area": "Boda", "phone": "01769672598"},

        {"area": "Thakurgaon", "phone": "01769672616"},
        {"area": "Thakurgaon Airfield", "phone": "01769662626"},
        {"area": "Thakurgaon BTV & Radio Station", "phone": "01829675086"},
        {"area": "Thakurgaon Sadar", "phone": "01769672616"},
        {"area": "Baliadangi", "phone": "01769672616"},
        {"area": "Pirganj (Thakurgaon)", "phone": "01769672616"},
        {"area": "Haripur", "phone": "01769672616"},
        {"area": "Ranishankail", "phone": "01769672616"},

        {"area": "Nilphamari", "phone": "01769682388"},
        {"area": "Saidpur Airport", "phone": "01814753599"},
        {"area": "Nilphamari Sadar", "phone": "01769682388"},
        {"area": "Dimla", "phone": "01769682388"},
        {"area": "Jaldhaka", "phone": "01769682388"},
        {"area": "Kishoreganj (Nilphamari)", "phone": "01769682388"},
        {"area": "Domar", "phone": "01769682388"},
        {"area": "Saidpur", "phone": "01814753599"},

        {"area": "Lalmonirhat", "phone": "01769682360"},
        {"area": "Lalmonirhat Military Farm", "phone": "01769511740"},
        {"area": "Lalmonirhat Sadar", "phone": "01769682360"},
        {"area": "Kaliganj", "phone": "01769682360"},
        {"area": "Aditmari", "phone": "01769682360"},
        {"area": "Hatibandha", "phone": "01769682360"},
        {"area": "Patgram", "phone": "01769682366"},

        {"area": "Gaibandha", "phone": "01625462588"},
        {"area": "Gaibandha Sadar", "phone": "01625462588"},
        {"area": "Sundarganj", "phone": "01791468487"},
        {"area": "Palashbari", "phone": "01791468488"},
        {"area": "Sadullapur", "phone": "01791468488"},
        {"area": "Fulchhari", "phone": "01791468488"},
        {"area": "Saghata", "phone": "01791468488"},
        {"area": "Gobindaganj", "phone": "01791468488"},

        {"area": "Kurigram", "phone": "01769662546"},
        {"area": "Kurigram Sadar", "phone": "01769662546"},
        {"area": "Ulipur", "phone": "01769662546"},
        {"area": "Chilmari", "phone": "01769662546"},
        {"area": "Fulbari (Kurigram)", "phone": "01769662546"},
        {"area": "Nageshwari", "phone": "01769662546"},
        {"area": "Bhurungamari", "phone": "01769662546"},
        {"area": "Rajarhat", "phone": "01769662546"},
        {"area": "Roumari", "phone": "01769662546"},
        {"area": "Rajibpur", "phone": "01769662546"}
      ]
    }


  ];
    // Add more divisions here

  List<Map<String, dynamic>> get filteredDivisions {
    if (_searchQuery.isEmpty) {
      return allContacts;
    }
    return allContacts
        .where((division) => division['title']
        .toLowerCase()
        .contains(_searchQuery.toLowerCase()))
        .toList();
  }

  void navigateToContacts(BuildContext context, Map<String, dynamic> division) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DivisionContactsPage(
          divisionTitle: division['title'],
          contacts: division['contacts'],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFA8D5A2),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const Icon(Icons.menu, color: Colors.black),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: Icon(Icons.notifications_none, color: Colors.black),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 24),
                const Text(
                  'Contact Book',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                Container(
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
                            hintText: 'Search...',
                            border: InputBorder.none,
                          ),
                          onChanged: (value) {
                            setState(() {
                              _searchQuery = value;
                            });
                          },
                        ),
                      ),
                      const Icon(Icons.search, color: Color(0xFF006400)),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                ...filteredDivisions.map((division) => GestureDetector(
                  onTap: () => navigateToContacts(context, division),
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
                        const CircleAvatar(
                          backgroundColor: Color(0xFF006400),
                          child: Icon(Icons.call, color: Colors.white),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            division['title'],
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),
                        const Icon(Icons.arrow_forward_ios),
                      ],
                    ),
                  ),
                )),
                const SizedBox(height: 70),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class DivisionContactsPage extends StatelessWidget {
  final String divisionTitle;
  final List<Map<String, String>> contacts;

  const DivisionContactsPage({
    super.key,
    required this.divisionTitle,
    required this.contacts,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFA8D5A2),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          divisionTitle,
          style: const TextStyle(color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 120),  // 40 for bottom padding
        itemCount: contacts.length,
        itemBuilder: (context, index) {
          final contact = contacts[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 3,
                  offset: Offset(0, 1),
                ),
              ],
            ),
            child: Row(
              children: [
                const Icon(Icons.phone, color: Color(0xFF006400)),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    '${contact['area']} - ${contact['phone']}',
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';


class ReportGeneratorPage extends StatefulWidget {
  const ReportGeneratorPage({super.key});

  @override
  State<ReportGeneratorPage> createState() => _ReportGeneratorPageState();
}

class _ReportGeneratorPageState extends State<ReportGeneratorPage> {
  final _formKey = GlobalKey<FormState>();
  final ammoController = TextEditingController();
  final firedController = TextEditingController();
  final misfireController = TextEditingController();
  final collectedController = TextEditingController();
  final lostController = TextEditingController();
  final rankController = TextEditingController();
  final nameController = TextEditingController();

  String generatedReport = '';

  void generateReport() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        generatedReport = '''
Assalamu Alaikum sir,

Total Ammo: ${ammoController.text} rounds  
Total Fired Ammo: ${firedController.text} rounds  
Total Misfires: ${misfireController.text} rounds  
Shells Collected: ${collectedController.text}  
Lost Shells: ${lostController.text}  

After firing, on parade, all correct, Sir.  
For your kind info, Sir.  

Regards  
${rankController.text} ${nameController.text}
        ''';
      });
    }
  }

  @override
  void dispose() {
    ammoController.dispose();
    firedController.dispose();
    misfireController.dispose();
    collectedController.dispose();
    lostController.dispose();
    rankController.dispose();
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFA8D5A2),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'SA Firing Report',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 24),
                const Text(
                  'Generate Firing Report',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 24),

                // Text fields
                ...[
                  ammoController,
                  firedController,
                  misfireController,
                  collectedController,
                  lostController,
                  rankController,
                  nameController
                ]
                    .asMap()
                    .entries
                    .map((entry) {
                  final index = entry.key;
                  final controller = entry.value;
                  final labels = [
                    'Total Ammo',
                    'Fired Ammo',
                    'Misfires',
                    'Shells Collected',
                    'Lost Shells',
                    'Officer Rank',
                    'Officer Name'
                  ];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: TextFormField(
                      controller: controller,
                      keyboardType: index < 5
                          ? TextInputType.number
                          : TextInputType.text,
                      decoration: InputDecoration(
                        labelText: labels[index],
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      validator: (value) => value!.isEmpty ? 'Required' : null,
                    ),
                  );
                }),

                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: generateReport,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF006400),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Text(
                    'Generate Report',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                if (generatedReport.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () => Share.share(generatedReport),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    icon: const Icon(Icons.share, color: Colors.white),
                    label: const Text('Share', style: TextStyle(color: Colors.white)),
                  ),
                ],


                const SizedBox(height: 32),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Generated Report:',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
                const SizedBox(height: 8),

                // White box with rounded corners
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 6,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: SelectableText(
                    generatedReport.isEmpty
                        ? 'No report yet.'
                        : generatedReport,
                    style: const TextStyle(fontSize: 15),
                  ),
                ),
                const SizedBox(height: 70),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
