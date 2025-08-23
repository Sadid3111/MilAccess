import 'package:flutter/material.dart';
// import 'package:milbot/features/task_management/task_management.dart';
import '../widgets/search_bar_widget.dart';
import '../features/calendar/calendar_screen.dart'; // Import for CalendarScreen
import '../features/document_upload/document_upload_screen.dart'; // Import for DocumentUploadScreen
import '../features/pending_leave_requests/pending_leave_requests_screen.dart'; // Import for PendingLeaveRequestsScreen
import '../features/incident_report/incident_report_screen.dart'; // Import for IncidentReportScreen
import '../features/task_management/task_management.dart'; // Import for ToDoListScreen
import '../features/quick_notes/quick_notes_screen.dart'; // New import for QuickNotesScreen

class AdminHomeScreen extends StatelessWidget {
  const AdminHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // The main AppBar for the screen
      appBar: AppBar(
        backgroundColor: Colors.green[700], // Consistent color
        elevation: 0, // No shadow
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.white),
          onPressed: () {
            // Handle menu tap (e.g., open drawer)
          },
        ),
        title: const Text(
          'Welcome, Admin!',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none, color: Colors.white),
            onPressed: () {
              // Handle notification tap
            },
          ),
        ],
        // Removed shape property from AppBar to allow seamless merge with the container below
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.center, // Center content horizontally
          children: [
            // This container now holds only the search bar and extends the AppBar's color
            Container(
              width: double.infinity, // Take full width
              // No borderRadius here, as the AppBar already defines the top shape
              decoration: BoxDecoration(
                color: Colors.green[700], // Consistent color
              ),
              child: const Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 10.0,
                ), // Added vertical padding
                child: SearchBarWidget(
                  hintText: '',
                ), // Your existing search bar
              ),
            ),
            const SizedBox(
              height: 20,
            ), // Space between top colored section and grid
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: GridView.count(
                shrinkWrap:
                    true, // Important to make GridView work inside SingleChildScrollView
                physics:
                    const NeverScrollableScrollPhysics(), // Disable GridView's own scrolling
                crossAxisCount: 2, // Two columns as per the image
                crossAxisSpacing: 16.0, // Spacing between columns
                mainAxisSpacing: 16.0, // Spacing between rows
                childAspectRatio: 0.9, // Adjust aspect ratio to fit content
                children: [
                  _buildGridItem(
                    context,
                    icon: Icons.upload_file,
                    label: 'Upload Document',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const DocumentUploadScreen(),
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
                          builder: (context) => const CalendarScreen(),
                        ),
                      );
                    },
                  ),
                  _buildGridItem(
                    context,
                    icon: Icons.assignment, // Icon for Pending Leave Requests
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
                    icon: Icons.warning_amber, // Icon for Incident Report
                    label: 'Incident Report',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const IncidentReportScreen(),
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
                          builder: (context) => const ToDoListScreen(),
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
                          builder: (context) => const QuickNotesScreen(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20), // Space at the bottom
          ],
        ),
      ),
      // Bottom navigation bar will be handled by HomePage
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
import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var listTile = const ListTile(
      leading: Icon(Icons.phone),
      title: Text('+880 1769 XXXXX'),
    );
    var listTile2 = listTile;
    var listTile22 = listTile2;
    return Scaffold(
      appBar: AppBar(
        title: const Text('1 Signal Battalion'),
        backgroundColor: Colors.green[700],
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              // Handle notification tap
            },
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const CircleAvatar(
                radius: 50,
                backgroundColor: Colors.green,
                child: Icon(Icons.security, size: 50, color: Colors.white),
              ),
              const SizedBox(height: 10),
              const Text('Unit Admin', style: TextStyle(fontSize: 20)),
              const SizedBox(height: 20),
              const Card(
                child: ListTile(
                  leading: Icon(Icons.email),
                  title: Text('1sigbn@army.mil.bd'),
                ),
              ),
              Card(child: listTile22),
              const Card(
                child: ListTile(
                  leading: Icon(Icons.location_on),
                  title: Text('Jashore Cantonment, Jashore'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import '../widgets/search_bar_widget.dart';

// --- Data Models ---
class Unit {
  final String name;
  final String coNumber;
  final String twoIcNumber;
  final String adjNumber;
  final String qmNumber;

  Unit({
    required this.name,
    required this.coNumber,
    required this.twoIcNumber,
    required this.adjNumber,
    required this.qmNumber,
  });
}

class Cantonment {
  final String name;
  final List<Unit> units;

  Cantonment({required this.name, required this.units});
}

class ContactDirectoryScreen extends StatefulWidget {
  const ContactDirectoryScreen({super.key});

  @override
  State<ContactDirectoryScreen> createState() => _ContactDirectoryScreenState();
}

class _ContactDirectoryScreenState extends State<ContactDirectoryScreen> {
  // --- Sample Data ---
  // This data structure now holds cantonments, and each cantonment holds its units
  final List<Cantonment> _cantonmentsData = [
    Cantonment(
      name: 'Dhaka Cantonment',
      units: [
        Unit(
          name: '1 Signal Battalion',
          coNumber: '01769XXXXXX',
          twoIcNumber: '01769XXXXXX',
          adjNumber: '01769XXXXXX',
          qmNumber: '01769XXXXXX',
        ),
        Unit(
          name: '2 Field Regiment Artillery',
          coNumber: '01769XXXXXX',
          twoIcNumber: '01769XXXXXX',
          adjNumber: '01769XXXXXX',
          qmNumber: '01769XXXXXX',
        ),
        Unit(
          name: '46 Independent Infantry Brigade',
          coNumber: '01769XXXXXX',
          twoIcNumber: '01769XXXXXX',
          adjNumber: '01769XXXXXX',
          qmNumber: '01769XXXXXX',
        ),
        Unit(
          name: 'Army Headquarters (AHQ)',
          coNumber: '01769XXXXXX',
          twoIcNumber: '01769XXXXXX',
          adjNumber: '01769XXXXXX',
          qmNumber: '01769XXXXXX',
        ),
        Unit(
          name: 'MIST (Military Institute of Science and Technology)',
          coNumber: '01769XXXXXX',
          twoIcNumber: '01769XXXXXX',
          adjNumber: '01769XXXXXX',
          qmNumber: '01769XXXXXX',
        ),
      ],
    ),
    Cantonment(
      name: 'Jashore Cantonment',
      units: [
        Unit(
          name: '3 East Bengal Regiment',
          coNumber: '01769XXXXXX',
          twoIcNumber: '01769XXXXXX',
          adjNumber: '01769XXXXXX',
          qmNumber: '01769XXXXXX',
        ),
        Unit(
          name: '10 Field Ambulance',
          coNumber: '01769XXXXXX',
          twoIcNumber: '01769XXXXXX',
          adjNumber: '01769XXXXXX',
          qmNumber: '01769XXXXXX',
        ),
      ],
    ),
    Cantonment(
      name: 'Savar Cantonment',
      units: [
        Unit(
          name: '9 Infantry Division',
          coNumber: '01769XXXXXX',
          twoIcNumber: '01769XXXXXX',
          adjNumber: '01769XXXXXX',
          qmNumber: '01769XXXXXX',
        ),
        Unit(
          name: 'Bangladesh Ordnance Factory',
          coNumber: '01769XXXXXX',
          twoIcNumber: '01769XXXXXX',
          adjNumber: '01769XXXXXX',
          qmNumber: '01769XXXXXX',
        ),
      ],
    ),
    Cantonment(
      name: 'Chattogram Cantonment',
      units: [
        Unit(
          name: '24 Infantry Division',
          coNumber: '01769XXXXXX',
          twoIcNumber: '01769XXXXXX',
          adjNumber: '01769XXXXXX',
          qmNumber: '01769XXXXXX',
        ),
        Unit(
          name: 'East Bengal Regimental Centre',
          coNumber: '01769XXXXXX',
          twoIcNumber: '01769XXXXXX',
          adjNumber: '01769XXXXXX',
          qmNumber: '01769XXXXXX',
        ),
      ],
    ),
    Cantonment(
      name: 'Comilla Cantonment',
      units: [
        Unit(
          name: '33 Infantry Division',
          coNumber: '01769XXXXXX',
          twoIcNumber: '01769XXXXXX',
          adjNumber: '01769XXXXXX',
          qmNumber: '01769XXXXXX',
        ),
      ],
    ),
    Cantonment(
      name: 'Rangpur Cantonment',
      units: [
        Unit(
          name: '66 Infantry Division',
          coNumber: '01769XXXXXX',
          twoIcNumber: '01769XXXXXX',
          adjNumber: '01769XXXXXX',
          qmNumber: '01769XXXXXX',
        ),
      ],
    ),
    Cantonment(
      name: 'Mymensingh Cantonment',
      units: [
        Unit(
          name: '19 Infantry Division',
          coNumber: '01769XXXXXX',
          twoIcNumber: '01769XXXXXX',
          adjNumber: '01769XXXXXX',
          qmNumber: '01769XXXXXX',
        ),
      ],
    ),
    Cantonment(
      name: 'Sylhet Cantonment',
      units: [
        Unit(
          name: '17 Infantry Division',
          coNumber: '01769XXXXXX',
          twoIcNumber: '01769XXXXXX',
          adjNumber: '01769XXXXXX',
          qmNumber: '01769XXXXXX',
        ),
      ],
    ),
    Cantonment(
      name: 'Khulna Cantonment',
      units: [
        Unit(
          name: 'Army Medical College Jessore',
          coNumber: '01769XXXXXX',
          twoIcNumber: '01769XXXXXX',
          adjNumber: '01769XXXXXX',
          qmNumber: '01769XXXXXX',
        ),
      ],
    ),
    Cantonment(
      name: 'Bogura Cantonment',
      units: [
        Unit(
          name: '11 Infantry Division',
          coNumber: '01769XXXXXX',
          twoIcNumber: '01769XXXXXX',
          adjNumber: '01769XXXXXX',
          qmNumber: '01769XXXXXX',
        ),
      ],
    ),
    Cantonment(
      name: 'Rajshahi Cantonment',
      units: [
        Unit(
          name:
              'Bangladesh Army University of Engineering & Technology (BAUET)',
          coNumber: '01769XXXXXX',
          twoIcNumber: '01769XXXXXX',
          adjNumber: '01769XXXXXX',
          qmNumber: '01769XXXXXX',
        ),
      ],
    ),
    Cantonment(
      name: 'Saidpur Cantonment',
      units: [
        Unit(
          name: '6 Infantry Brigade',
          coNumber: '01769XXXXXX',
          twoIcNumber: '01769XXXXXX',
          adjNumber: '01769XXXXXX',
          qmNumber: '01769XXXXXX',
        ),
      ],
    ),
    Cantonment(
      name: 'Ghatail Cantonment',
      units: [
        Unit(
          name: '19 Infantry Division (Ghatail)',
          coNumber: '01769XXXXXX',
          twoIcNumber: '01769XXXXXX',
          adjNumber: '01769XXXXXX',
          qmNumber: '01769XXXXXX',
        ),
      ],
    ),
    Cantonment(
      name: 'Jalalabad Cantonment',
      units: [
        Unit(
          name: 'Artillery Centre & School',
          coNumber: '01769XXXXXX',
          twoIcNumber: '01769XXXXXX',
          adjNumber: '01769XXXXXX',
          qmNumber: '01769XXXXXX',
        ),
      ],
    ),
    Cantonment(
      name: 'Kaptai Cantonment',
      units: [
        Unit(
          name: '203 Infantry Brigade',
          coNumber: '01769XXXXXX',
          twoIcNumber: '01769XXXXXX',
          adjNumber: '01769XXXXXX',
          qmNumber: '01769XXXXXX',
        ),
      ],
    ),
    Cantonment(
      name: 'Bandarban Cantonment',
      units: [
        Unit(
          name: '69 Infantry Brigade',
          coNumber: '01769XXXXXX',
          twoIcNumber: '01769XXXXXX',
          adjNumber: '01769XXXXXX',
          qmNumber: '01769XXXXXX',
        ),
      ],
    ),
    Cantonment(
      name: 'Cox\'s Bazar Cantonment',
      units: [
        Unit(
          name: '10 Infantry Division',
          coNumber: '01769XXXXXX',
          twoIcNumber: '01769XXXXXX',
          adjNumber: '01769XXXXXX',
          qmNumber: '01769XXXXXX',
        ),
      ],
    ),
    Cantonment(
      name: 'Bhairab Cantonment',
      units: [
        Unit(
          name: 'Army Service Corps Centre & School',
          coNumber: '01769XXXXXX',
          twoIcNumber: '01769XXXXXX',
          adjNumber: '01769XXXXXX',
          qmNumber: '01769XXXXXX',
        ),
      ],
    ),
    Cantonment(
      name: 'Rangamati Cantonment',
      units: [
        Unit(
          name: '305 Infantry Brigade',
          coNumber: '01769XXXXXX',
          twoIcNumber: '01769XXXXXX',
          adjNumber: '01769XXXXXX',
          qmNumber: '01769XXXXXX',
        ),
      ],
    ),
    Cantonment(
      name: 'Kishoreganj Cantonment',
      units: [
        Unit(
          name: 'Army Education Corps Centre & School',
          coNumber: '01769XXXXXX',
          twoIcNumber: '01769XXXXXX',
          adjNumber: '01769XXXXXX',
          qmNumber: '01769XXXXXX',
        ),
      ],
    ),
  ];

  // State variables for navigation
  Cantonment? _selectedCantonment;
  Unit? _selectedUnit;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _selectedUnit != null
              ? _selectedUnit!
                    .name // Display unit name if unit is selected
              : _selectedCantonment != null
              ? _selectedCantonment!
                    .name // Display cantonment name if cantonment is selected
              : 'Contact Directory', // Default title
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.green[700],
        leading: _selectedCantonment != null
            ? IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () {
                  setState(() {
                    if (_selectedUnit != null) {
                      _selectedUnit = null; // Go back to unit list
                    } else {
                      _selectedCantonment = null; // Go back to cantonment list
                    }
                  });
                },
              )
            : null, // No back button on the main cantonment list
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications, color: Colors.white),
            onPressed: () {
              // Handle notification tap
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SearchBarWidget(hintText: 'Search...'),
            const SizedBox(height: 20),
            // Conditionally render content based on navigation state
            if (_selectedUnit != null)
              _buildUnitDetails(_selectedUnit!)
            else if (_selectedCantonment != null)
              _buildUnitList(_selectedCantonment!)
            else
              _buildCantonmentList(),
          ],
        ),
      ),
    );
  }

  // --- View Builders ---

  Widget _buildCantonmentList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: _cantonmentsData.map((cantonment) {
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8.0),
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: ListTile(
            leading: const Icon(Icons.location_on, color: Color(0xFF4CAF50)),
            title: Text(
              cantonment.name,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            trailing: const Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Colors.grey,
            ),
            onTap: () {
              setState(() {
                _selectedCantonment = cantonment;
              });
            },
          ),
        );
      }).toList(),
    );
  }

  Widget _buildUnitList(Cantonment cantonment) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            'Units in ${cantonment.name}',
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        ...cantonment.units.map((unit) {
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8.0),
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: ListTile(
              leading: const Icon(
                Icons.military_tech,
                color: Color(0xFF4CAF50),
              ),
              title: Text(
                unit.name,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              trailing: const Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: Colors.grey,
              ),
              onTap: () {
                setState(() {
                  _selectedUnit = unit;
                });
              },
            ),
          );
        }),
      ],
    );
  }

  Widget _buildUnitDetails(Unit unit) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            'Contacts for ${unit.name}',
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        Card(
          margin: const EdgeInsets.symmetric(vertical: 8.0),
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                _buildContactRow(Icons.person, 'CO', unit.coNumber),
                const Divider(),
                _buildContactRow(Icons.group, '2IC', unit.twoIcNumber),
                const Divider(),
                _buildContactRow(Icons.assignment_ind, 'Adj', unit.adjNumber),
                const Divider(),
                _buildContactRow(Icons.warehouse, 'QM', unit.qmNumber),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildContactRow(IconData icon, String role, String number) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.green[700]),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(role, style: const TextStyle(fontWeight: FontWeight.bold)),
                Text(number),
              ],
            ),
          ),
          // Optionally add a call icon here
          IconButton(
            icon: Icon(Icons.phone, color: Colors.green[700]),
            onPressed: () {
              // Implement call functionality (e.g., using url_launcher package)
              _showMessageBox(context, 'Call', 'Initiating call to $number');
            },
          ),
        ],
      ),
    );
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

class PendingRequestsScreen extends StatefulWidget {
  const PendingRequestsScreen({super.key});

  @override
  State<PendingRequestsScreen> createState() => _PendingRequestsScreenState();
}

class _PendingRequestsScreenState extends State<PendingRequestsScreen> {
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
          .where('role', isEqualTo: 'User')
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
      appBar: AppBar(
        title: const Text('Pending Requests'),
        backgroundColor: Colors.green[700],
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications, color: Colors.white),
            onPressed: () {
              // Handle notification tap
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
