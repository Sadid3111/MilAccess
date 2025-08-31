import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_1/models/user_data.dart';

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

  // Loading states
  bool _isLoading = false;
  bool _isSubmitting = false;
  bool _isLoadingBalance = false;

  // Leave requests data
  List<LeaveRequest> leaveRequests = [];

  // Leave balance data
  LeaveBalance? leaveBalance;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(_onTabChanged);

    // Debug: Check UserData
    print('Current User ID: ${UserData.uid}');
    print('Current User Name: ${UserData.name}');

    _fetchLeaveRequests();
    _fetchLeaveBalance();
  }

  void _onTabChanged() {
    // Refresh requests when switching to "My Requests" tab (index 1)
    if (_tabController.index == 1) {
      _fetchLeaveRequests();
    }
    // Refresh balance when switching to "Leave Balance" tab (index 2)
    if (_tabController.index == 2) {
      _fetchLeaveBalance();
    }
    // Rebuild to show/hide refresh button
    setState(() {});
  }

  Future<void> _createLeaveRequestNotification(
    String leaveType,
    bool isEmergency,
  ) async {
    try {
      // Create notification with the specific structure requested
      await FirebaseFirestore.instance.collection('notifications').add({
        'createdAt': FieldValue.serverTimestamp(),
        'content': isEmergency
            ? 'New emergency ${leaveType.toLowerCase()} request from ${UserData.name} (${UserData.unitName})'
            : 'New ${leaveType.toLowerCase()} request from ${UserData.name} (${UserData.unitName})',
        'targetId': UserData.unitName.trim(),
        // Additional fields for context
        'type': 'leave_request',
        'requesterId': UserData.uid,
        'requesterName': UserData.name,
        'isEmergency': isEmergency,
        'seen': false,
      });

      print('Notification created for unit: ${UserData.unitName}');
    } catch (e) {
      print('Error creating notification: $e');
    }
  }

  Future<void> _fetchLeaveRequests() async {
    setState(() {
      _isLoading = true;
    });

    try {
      print('Fetching leave requests for user: ${UserData.uid}');
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('leave_requests')
          .where('requestId', isEqualTo: UserData.uid)
          .orderBy('submittedDate', descending: true)
          .get();

      print('Found ${querySnapshot.docs.length} leave requests');

      List<LeaveRequest> fetchedRequests = querySnapshot.docs
          .map((doc) => LeaveRequest.fromMap(doc))
          .toList();

      if (mounted) {
        setState(() {
          leaveRequests = fetchedRequests;
          _isLoading = false;
        });
      }

      print('Successfully loaded ${leaveRequests.length} requests');
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
      print('Error fetching leave requests: $e');

      // Show error message to user
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading requests: $e'),
            backgroundColor: Colors.red[800],
          ),
        );
      }
    }
  }

  Future<void> _fetchLeaveBalance() async {
    if (!mounted) return;

    setState(() {
      _isLoadingBalance = true;
    });

    try {
      print('Fetching leave balance for user: ${UserData.uid}');

      // First, get or create the user's leave balance document
      DocumentSnapshot balanceDoc = await FirebaseFirestore.instance
          .collection('leave_balances')
          .doc(UserData.uid)
          .get();

      LeaveBalance balance;

      if (!balanceDoc.exists) {
        // Create default leave balance for new user
        balance = LeaveBalance.createDefault(UserData.uid);
        await FirebaseFirestore.instance
            .collection('leave_balances')
            .doc(UserData.uid)
            .set(balance.toMap());
        print('Created default leave balance for user: ${UserData.uid}');
      } else {
        balance = LeaveBalance.fromMap(balanceDoc);
        print('Found existing leave balance for user: ${UserData.uid}');
      }

      // Calculate used leave days from approved requests in current year
      DateTime currentYear = DateTime(DateTime.now().year, 1, 1);
      DateTime nextYear = DateTime(DateTime.now().year + 1, 1, 1);

      QuerySnapshot approvedRequests = await FirebaseFirestore.instance
          .collection('leave_requests')
          .where('requestId', isEqualTo: UserData.uid)
          .where('status', isEqualTo: 'Approved')
          .where(
            'startDate',
            isGreaterThanOrEqualTo: Timestamp.fromDate(currentYear),
          )
          .where('startDate', isLessThan: Timestamp.fromDate(nextYear))
          .get();

      // Calculate used days by leave type
      Map<String, int> usedDays = {
        'Annual Leave': 0,
        'Sick Leave': 0,
        'Emergency Leave': 0,
        'Training Leave': 0,
      };

      for (var doc in approvedRequests.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        String leaveType = data['type'] ?? '';
        DateTime startDate = (data['startDate'] as Timestamp).toDate();
        DateTime endDate = (data['endDate'] as Timestamp).toDate();

        int days = endDate.difference(startDate).inDays + 1;

        if (usedDays.containsKey(leaveType)) {
          usedDays[leaveType] = usedDays[leaveType]! + days;
        }
      }

      print('=== LEAVE BALANCE DEBUG ===');
      print('Used days calculated: $usedDays');
      print(
        'Original balance - sickLeaveTotal: ${balance.sickLeaveTotal}, sickLeaveUsed: ${balance.sickLeaveUsed}',
      );

      // Update balance with calculated used days
      balance = balance.copyWith(
        annualLeaveUsed: usedDays['Annual Leave']!,
        sickLeaveUsed: usedDays['Sick Leave']!,
        emergencyLeaveUsed: usedDays['Emergency Leave']!,
        trainingLeaveUsed: usedDays['Training Leave']!,
      );

      print(
        'Updated balance - sickLeaveTotal: ${balance.sickLeaveTotal}, sickLeaveUsed: ${balance.sickLeaveUsed}',
      );
      print(
        'Sick leave remaining: ${balance.sickLeaveTotal - balance.sickLeaveUsed}',
      );
      print('=== END DEBUG ===');

      if (mounted) {
        setState(() {
          leaveBalance = balance;
          _isLoadingBalance = false;
        });
      }

      print('Successfully loaded leave balance');
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoadingBalance = false;
        });
      }
      print('Error fetching leave balance: $e');

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading leave balance: $e'),
            backgroundColor: Colors.red[800],
          ),
        );
      }
    }
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

  String _formatLeaveBalance(int total, int used) {
    int remaining = total - used;
    if (remaining >= 0) {
      return remaining.toString();
    } else {
      // For negative balances, show absolute value with over-usage indicator
      return "0 (Over by ${remaining.abs()})";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Request Leave',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
        backgroundColor: const Color.fromARGB(255, 170, 242, 153),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        actions: [
          // Show refresh button only on "My Requests" tab
          if (_tabController.index == 1)
            IconButton(
              icon: const Icon(Icons.refresh, color: Colors.black),
              onPressed: _fetchLeaveRequests,
              tooltip: 'Refresh Requests',
            ),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.black,
          unselectedLabelColor: Colors.black54,
          indicatorColor: Colors.green[800],
          tabs: const [
            Tab(icon: Icon(Icons.add_circle_outline), text: 'New Request'),
            Tab(icon: Icon(Icons.list_alt), text: 'My Requests'),
            Tab(icon: Icon(Icons.info_outline), text: 'Leave Balance'),
          ],
        ),
      ),
      body: Container(
        color: const Color.fromARGB(255, 170, 242, 153),
        child: TabBarView(
          controller: _tabController,
          children: [
            _buildNewRequestTab(),
            _buildMyRequestsTab(),
            _buildLeaveBalanceTab(),
          ],
        ),
      ),
      floatingActionButton: _tabController.index == 1
          ? FloatingActionButton(
              onPressed: _fetchLeaveRequests,
              backgroundColor: Colors.green[800],
              child: const Icon(Icons.refresh, color: Colors.white),
            )
          : null,
    );
  }

  Widget _buildNewRequestTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Quick Leave Type Selection
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.schedule, color: Colors.green[800]),
                    const SizedBox(width: 8),
                    const Text(
                      'Quick Leave Types',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
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
                      'Other',
                      Icons.more_horiz,
                      Colors.grey,
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Main Form
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 6,
                  offset: const Offset(0, 3),
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
                const SizedBox(height: 16),

                // Emergency Leave Toggle
                Container(
                  padding: const EdgeInsets.all(12),
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
                      const SizedBox(width: 8),
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

                const SizedBox(height: 16),

                // Leave Type Dropdown
                DropdownButtonFormField<String>(
                  value: selectedLeaveType,
                  decoration: InputDecoration(
                    labelText: 'Leave Type',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    prefixIcon: const Icon(Icons.category),
                  ),
                  items:
                      [
                            'Annual Leave',
                            'Sick Leave',
                            'Emergency Leave',
                            'Maternity Leave',
                            'Paternity Leave',
                            'Training Leave',
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

                const SizedBox(height: 16),

                // Date Selection
                Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () => _selectStartDate(context),
                        child: Container(
                          padding: const EdgeInsets.all(12),
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
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  const Icon(Icons.calendar_today, size: 18),
                                  const SizedBox(width: 8),
                                  Text(
                                    startDate != null
                                        ? '${startDate!.day}/${startDate!.month}/${startDate!.year}'
                                        : 'Select Date',
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: InkWell(
                        onTap: () => _selectEndDate(context),
                        child: Container(
                          padding: const EdgeInsets.all(12),
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
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  const Icon(Icons.calendar_today, size: 18),
                                  const SizedBox(width: 8),
                                  Text(
                                    endDate != null
                                        ? '${endDate!.day}/${endDate!.month}/${endDate!.year}'
                                        : 'Select Date',
                                    style: const TextStyle(fontSize: 16),
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

                const SizedBox(height: 16),

                // Duration and Priority
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    DropdownButtonFormField<String>(
                      value: selectedDuration,
                      isExpanded: true, // 👈 makes sure text doesn’t overflow
                      decoration: InputDecoration(
                        labelText: 'Duration',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        prefixIcon: const Icon(Icons.access_time),
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
                                  child: Text(
                                    duration,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                                ),
                              )
                              .toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedDuration = value!;
                        });
                      },
                    ),
                    const SizedBox(height: 16), // spacing between dropdowns
                    DropdownButtonFormField<String>(
                      value: selectedPriority,
                      isExpanded: true,
                      decoration: InputDecoration(
                        labelText: 'Priority',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        prefixIcon: const Icon(Icons.priority_high),
                      ),
                      items: ['Normal', 'High', 'Urgent']
                          .map(
                            (priority) => DropdownMenuItem(
                              value: priority,
                              child: Text(
                                priority,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
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
                  ],
                ),

                const SizedBox(height: 16),

                // Reason
                TextField(
                  controller: _reasonController,
                  decoration: InputDecoration(
                    labelText: 'Reason for Leave',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    prefixIcon: const Icon(Icons.description),
                    hintText: 'Please provide a detailed reason...',
                  ),
                  maxLines: 3,
                ),

                const SizedBox(height: 16),

                // Contact Information
                TextField(
                  controller: _contactController,
                  decoration: InputDecoration(
                    labelText: 'Contact Number During Leave',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    prefixIcon: const Icon(Icons.phone),
                    hintText: '+880XXXXXXXXX',
                  ),
                  keyboardType: TextInputType.phone,
                ),

                const SizedBox(height: 16),

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
                          prefixIcon: const Icon(Icons.contact_emergency),
                          hintText: 'Name and contact details',
                        ),
                      ),
                      const SizedBox(height: 16),
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
                    prefixIcon: const Icon(Icons.note),
                    hintText: 'Any additional information...',
                  ),
                  maxLines: 2,
                ),

                const SizedBox(height: 24),

                // Submit Button
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _isSubmitting ? null : _submitLeaveRequest,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isEmergencyLeave
                          ? Colors.red[600]
                          : Colors.green[800],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: _isSubmitting
                        ? const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              ),
                              SizedBox(width: 8),
                              Text(
                                'Submitting...',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                isEmergencyLeave ? Icons.emergency : Icons.send,
                                color: Colors.white,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                isEmergencyLeave
                                    ? 'Submit Emergency Request'
                                    : 'Submit Leave Request',
                                style: const TextStyle(
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
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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
            const SizedBox(width: 6),
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
    if (_isLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text(
              'Loading your requests...',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _fetchLeaveRequests,
      child: ListView(
        padding: const EdgeInsets.all(16),
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
              const SizedBox(width: 12),
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
              const SizedBox(width: 12),
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

          const SizedBox(height: 16),

          // Requests List
          if (leaveRequests.isEmpty)
            Container(
              padding: const EdgeInsets.all(40),
              child: const Column(
                children: [
                  Icon(Icons.inbox_outlined, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'No leave requests found',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Submit your first leave request using the New Request tab',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            )
          else
            ...leaveRequests
                .map((request) => _buildRequestCard(request))
                .toList(),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(
    String title,
    String count,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 8),
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
      margin: const EdgeInsets.only(bottom: 12),
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Container(
          padding: const EdgeInsets.all(16),
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
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
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
              const SizedBox(height: 8),
              Text(
                request.reason,
                style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(Icons.calendar_today, size: 14, color: Colors.grey[600]),
                  const SizedBox(width: 4),
                  Text(
                    '${_formatDate(request.startDate)} - ${_formatDate(request.endDate)}',
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                  const Spacer(),
                  Icon(Icons.access_time, size: 14, color: Colors.grey[600]),
                  const SizedBox(width: 4),
                  Text(
                    _calculateDays(request.startDate, request.endDate),
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Text(
                    'Submitted: ${_formatDate(request.submittedDate)}',
                    style: TextStyle(fontSize: 10, color: Colors.grey[500]),
                  ),
                  const Spacer(),
                  if (request.status == 'Pending')
                    TextButton(
                      onPressed: () => _showCancelDialog(request),
                      child: const Text(
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
    if (_isLoadingBalance) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text(
              'Loading leave balance...',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
      );
    }

    if (leaveBalance == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'Unable to load leave balance',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: _fetchLeaveBalance,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    final balance = leaveBalance!;
    final totalAnnualUsed = balance.annualLeaveUsed;
    final totalAnnualRemaining = balance.annualLeaveTotal - totalAnnualUsed;

    return RefreshIndicator(
      onRefresh: _fetchLeaveBalance,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Leave Balance Overview
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
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
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildBalanceItem(
                        'Total',
                        balance.annualLeaveTotal.toString(),
                        Colors.blue,
                      ),
                      Container(width: 1, height: 40, color: Colors.grey[300]),
                      _buildBalanceItem(
                        'Used',
                        totalAnnualUsed.toString(),
                        Colors.red,
                      ),
                      Container(width: 1, height: 40, color: Colors.grey[300]),
                      _buildBalanceItem(
                        'Remaining',
                        totalAnnualRemaining.toString(),
                        Colors.green,
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Leave Types Breakdown
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Leave Types & Entitlements',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Year ${DateTime.now().year}',
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildLeaveTypeItem(
                    'Annual Leave',
                    _formatLeaveBalance(
                      balance.annualLeaveTotal,
                      balance.annualLeaveUsed,
                    ),
                    balance.annualLeaveTotal.toString(),
                    Colors.blue,
                    isOverUsed:
                        balance.annualLeaveUsed > balance.annualLeaveTotal,
                  ),
                  _buildLeaveTypeItem(
                    'Sick Leave',
                    _formatLeaveBalance(
                      balance.sickLeaveTotal,
                      balance.sickLeaveUsed,
                    ),
                    balance.sickLeaveTotal.toString(),
                    Colors.red,
                    isOverUsed: balance.sickLeaveUsed > balance.sickLeaveTotal,
                  ),
                  _buildLeaveTypeItem(
                    'Emergency Leave',
                    _formatLeaveBalance(
                      balance.emergencyLeaveTotal,
                      balance.emergencyLeaveUsed,
                    ),
                    balance.emergencyLeaveTotal.toString(),
                    Colors.orange,
                    isOverUsed:
                        balance.emergencyLeaveUsed >
                        balance.emergencyLeaveTotal,
                  ),
                  _buildLeaveTypeItem(
                    'Training Leave',
                    _formatLeaveBalance(
                      balance.trainingLeaveTotal,
                      balance.trainingLeaveUsed,
                    ),
                    balance.trainingLeaveTotal.toString(),
                    Colors.purple,
                    isOverUsed:
                        balance.trainingLeaveUsed > balance.trainingLeaveTotal,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Usage Statistics
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.analytics, color: Colors.blue[800]),
                      const SizedBox(width: 8),
                      const Text(
                        'Usage Statistics',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildUsageStatItem(
                    'Total Days Used This Year',
                    (balance.annualLeaveUsed +
                            balance.sickLeaveUsed +
                            balance.emergencyLeaveUsed +
                            balance.trainingLeaveUsed)
                        .toString(),
                    Icons.calendar_month,
                    Colors.blue,
                  ),
                  _buildUsageStatItem(
                    'Most Used Leave Type',
                    _getMostUsedLeaveType(balance),
                    Icons.trending_up,
                    Colors.green,
                  ),
                  _buildUsageStatItem(
                    'Next Reset Date',
                    'January 1, ${DateTime.now().year + 1}',
                    Icons.refresh,
                    Colors.orange,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Leave Policy Info
            Container(
              padding: const EdgeInsets.all(16),
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
                      const SizedBox(width: 8),
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
                  const SizedBox(height: 12),
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
    Color color, {
    bool isOverUsed = false,
  }) {
    // Parse the remaining to handle the "0 (Over by X)" format
    double percentage;

    if (remaining.contains("Over by")) {
      // Extract the over amount for visual indication
      percentage = 1.0; // Full bar to indicate over-usage
      color = Colors.red; // Override color to red for over-usage
    } else {
      percentage = double.parse(remaining) / double.parse(total);
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                type,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                remaining.contains("Over by")
                    ? remaining
                    : '$remaining/$total days',
                style: TextStyle(
                  fontSize: 12,
                  color: remaining.contains("Over by")
                      ? Colors.red[600]
                      : Colors.grey[600],
                  fontWeight: remaining.contains("Over by")
                      ? FontWeight.w600
                      : FontWeight.normal,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
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
      padding: const EdgeInsets.only(bottom: 4),
      child: Text(
        text,
        style: TextStyle(fontSize: 12, color: Colors.blue[700]),
      ),
    );
  }

  Widget _buildUsageStatItem(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  String _getMostUsedLeaveType(LeaveBalance balance) {
    Map<String, int> usageMap = {
      'Annual': balance.annualLeaveUsed,
      'Sick': balance.sickLeaveUsed,
      'Emergency': balance.emergencyLeaveUsed,
      'Training': balance.trainingLeaveUsed,
    };

    if (usageMap.values.every((value) => value == 0)) {
      return 'None';
    }

    String mostUsed = usageMap.entries
        .reduce((a, b) => a.value > b.value ? a : b)
        .key;

    return '$mostUsed Leave';
  }

  Future<void> _selectStartDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: startDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
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
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Please select start date first'),
            backgroundColor: Colors.red[800],
          ),
        );
      }
      return;
    }

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: endDate ?? startDate!.add(const Duration(days: 1)),
      firstDate: startDate!,
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null && picked != endDate) {
      setState(() {
        endDate = picked;
      });
    }
  }

  void _submitLeaveRequest() async {
    if (_validateForm()) {
      setState(() {
        _isSubmitting = true;
      });

      try {
        // Create leave request data
        final leaveRequestData = {
          'requestId': UserData.uid,
          'type': selectedLeaveType,
          'startDate': Timestamp.fromDate(startDate!),
          'endDate': Timestamp.fromDate(endDate!),
          'reason': _reasonController.text.trim(),
          'status': 'Pending',
          'submittedDate': Timestamp.fromDate(DateTime.now()),
          'duration': selectedDuration,
          'priority': selectedPriority,
          'contactNumber': _contactController.text.trim(),
          'emergencyContact': _emergencyContactController.text.trim().isNotEmpty
              ? _emergencyContactController.text.trim()
              : null,
          'additionalNotes': _additionalNotesController.text.trim().isNotEmpty
              ? _additionalNotesController.text.trim()
              : null,
          'isEmergencyLeave': isEmergencyLeave,
          'requesterName': UserData.name,
          'requesterUnit': UserData.unitName,
        };

        // Save to Firebase
        print('Saving leave request to Firebase for user: ${UserData.uid}');
        print('Request data: $leaveRequestData');

        DocumentReference docRef = await FirebaseFirestore.instance
            .collection('leave_requests')
            .add(leaveRequestData);

        print('Leave request saved with ID: ${docRef.id}');

        // Create notification for admins
        await _createLeaveRequestNotification(
          selectedLeaveType,
          isEmergencyLeave,
        );

        if (mounted) {
          setState(() {
            _isSubmitting = false;
          });
        }

        // Capture values before clearing form
        String requestType = selectedLeaveType;
        String requestPriority = selectedPriority;
        DateTime requestStartDate = startDate!;
        DateTime requestEndDate = endDate!;
        bool requestIsEmergency = isEmergencyLeave;

        // Clear form
        _clearForm();

        // Refresh the requests list
        _fetchLeaveRequests();

        // Show success message
        if (mounted) {
          _showSuccessDialog(
            requestType,
            requestPriority,
            requestStartDate,
            requestEndDate,
            requestIsEmergency,
          );
        }
      } catch (e) {
        if (mounted) {
          setState(() {
            _isSubmitting = false;
          });

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error submitting request: $e'),
              backgroundColor: Colors.red[800],
            ),
          );
        }
      }
    }
  }

  void _showSuccessDialog(
    String requestType,
    String requestPriority,
    DateTime requestStartDate,
    DateTime requestEndDate,
    bool requestIsEmergency,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(
              requestIsEmergency ? Icons.emergency : Icons.check_circle,
              color: requestIsEmergency ? Colors.red : Colors.green,
            ),
            const SizedBox(width: 8),
            const Text('Request Submitted'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              requestIsEmergency
                  ? 'Your emergency leave request has been submitted and will be processed immediately.'
                  : 'Your leave request has been submitted successfully and is pending approval.',
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Request Summary:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text('Type: $requestType'),
                  Text(
                    'Duration: ${_calculateDays(requestStartDate, requestEndDate)}',
                  ),
                  Text('Priority: $requestPriority'),
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
            child: const Text('View Requests'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green[800],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('OK'),
          ),
        ],
      ),
    );
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
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.error, color: Colors.white),
              const SizedBox(width: 8),
              Expanded(child: Text(message)),
            ],
          ),
          backgroundColor: Colors.red[800],
        ),
      );
    }
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
        title: const Row(
          children: [
            Icon(Icons.cancel, color: Colors.red),
            SizedBox(width: 8),
            Text('Cancel Request'),
          ],
        ),
        content: const Text(
          'Are you sure you want to cancel this leave request?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('No'),
          ),
          ElevatedButton(
            onPressed: () async {
              // Get the navigator and close dialog first
              Navigator.pop(context);

              try {
                // Delete from Firebase
                await FirebaseFirestore.instance
                    .collection('leave_requests')
                    .doc(request.id)
                    .delete();

                // Check if widget is still mounted before using context
                if (mounted) {
                  // Refresh the list
                  _fetchLeaveRequests();

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text(
                        'Leave request cancelled successfully',
                      ),
                      backgroundColor: Colors.green[800],
                    ),
                  );
                }
              } catch (e) {
                // Check if widget is still mounted before showing error
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Error cancelling request: $e'),
                      backgroundColor: Colors.red[800],
                    ),
                  );
                }
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red[800],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Yes, Cancel'),
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

class LeaveBalance {
  final String userId;
  final int annualLeaveTotal;
  final int annualLeaveUsed;
  final int sickLeaveTotal;
  final int sickLeaveUsed;
  final int emergencyLeaveTotal;
  final int emergencyLeaveUsed;
  final int trainingLeaveTotal;
  final int trainingLeaveUsed;
  final DateTime lastUpdated;

  LeaveBalance({
    required this.userId,
    required this.annualLeaveTotal,
    required this.annualLeaveUsed,
    required this.sickLeaveTotal,
    required this.sickLeaveUsed,
    required this.emergencyLeaveTotal,
    required this.emergencyLeaveUsed,
    required this.trainingLeaveTotal,
    required this.trainingLeaveUsed,
    required this.lastUpdated,
  });

  factory LeaveBalance.createDefault(String userId) {
    return LeaveBalance(
      userId: userId,
      annualLeaveTotal: 30,
      annualLeaveUsed: 0,
      sickLeaveTotal: 15,
      sickLeaveUsed: 0,
      emergencyLeaveTotal: 5,
      emergencyLeaveUsed: 0,
      trainingLeaveTotal: 10,
      trainingLeaveUsed: 0,
      lastUpdated: DateTime.now(),
    );
  }

  factory LeaveBalance.fromMap(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return LeaveBalance(
      userId: doc.id,
      annualLeaveTotal: data['annualLeaveTotal'] ?? 30,
      annualLeaveUsed: data['annualLeaveUsed'] ?? 0,
      sickLeaveTotal: data['sickLeaveTotal'] ?? 15,
      sickLeaveUsed: data['sickLeaveUsed'] ?? 0,
      emergencyLeaveTotal: data['emergencyLeaveTotal'] ?? 5,
      emergencyLeaveUsed: data['emergencyLeaveUsed'] ?? 0,
      trainingLeaveTotal: data['trainingLeaveTotal'] ?? 10,
      trainingLeaveUsed: data['trainingLeaveUsed'] ?? 0,
      lastUpdated: data['lastUpdated'] != null
          ? (data['lastUpdated'] as Timestamp).toDate()
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'annualLeaveTotal': annualLeaveTotal,
      'annualLeaveUsed': annualLeaveUsed,
      'sickLeaveTotal': sickLeaveTotal,
      'sickLeaveUsed': sickLeaveUsed,
      'emergencyLeaveTotal': emergencyLeaveTotal,
      'emergencyLeaveUsed': emergencyLeaveUsed,
      'trainingLeaveTotal': trainingLeaveTotal,
      'trainingLeaveUsed': trainingLeaveUsed,
      'lastUpdated': Timestamp.fromDate(lastUpdated),
    };
  }

  LeaveBalance copyWith({
    String? userId,
    int? annualLeaveTotal,
    int? annualLeaveUsed,
    int? sickLeaveTotal,
    int? sickLeaveUsed,
    int? emergencyLeaveTotal,
    int? emergencyLeaveUsed,
    int? trainingLeaveTotal,
    int? trainingLeaveUsed,
    DateTime? lastUpdated,
  }) {
    return LeaveBalance(
      userId: userId ?? this.userId,
      annualLeaveTotal: annualLeaveTotal ?? this.annualLeaveTotal,
      annualLeaveUsed: annualLeaveUsed ?? this.annualLeaveUsed,
      sickLeaveTotal: sickLeaveTotal ?? this.sickLeaveTotal,
      sickLeaveUsed: sickLeaveUsed ?? this.sickLeaveUsed,
      emergencyLeaveTotal: emergencyLeaveTotal ?? this.emergencyLeaveTotal,
      emergencyLeaveUsed: emergencyLeaveUsed ?? this.emergencyLeaveUsed,
      trainingLeaveTotal: trainingLeaveTotal ?? this.trainingLeaveTotal,
      trainingLeaveUsed: trainingLeaveUsed ?? this.trainingLeaveUsed,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }
}

class LeaveRequest {
  final String id;
  final String requestId; // UserData.uid
  final String type;
  final DateTime startDate;
  final DateTime endDate;
  final String reason;
  final String status;
  final DateTime submittedDate;
  final String duration;
  final String priority;
  final String contactNumber;
  final String? emergencyContact;
  final String? additionalNotes;
  final bool isEmergencyLeave;

  LeaveRequest({
    required this.id,
    required this.requestId,
    required this.type,
    required this.startDate,
    required this.endDate,
    required this.reason,
    required this.status,
    required this.submittedDate,
    required this.duration,
    required this.priority,
    required this.contactNumber,
    this.emergencyContact,
    this.additionalNotes,
    required this.isEmergencyLeave,
  });

  factory LeaveRequest.fromMap(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return LeaveRequest(
      id: doc.id,
      requestId: data['requestId'] ?? '',
      type: data['type'] ?? '',
      startDate: (data['startDate'] as Timestamp).toDate(),
      endDate: (data['endDate'] as Timestamp).toDate(),
      reason: data['reason'] ?? '',
      status: data['status'] ?? 'Pending',
      submittedDate: (data['submittedDate'] as Timestamp).toDate(),
      duration: data['duration'] ?? '',
      priority: data['priority'] ?? 'Normal',
      contactNumber: data['contactNumber'] ?? '',
      emergencyContact: data['emergencyContact'],
      additionalNotes: data['additionalNotes'],
      isEmergencyLeave: data['isEmergencyLeave'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'requestId': requestId,
      'type': type,
      'startDate': Timestamp.fromDate(startDate),
      'endDate': Timestamp.fromDate(endDate),
      'reason': reason,
      'status': status,
      'submittedDate': Timestamp.fromDate(submittedDate),
      'duration': duration,
      'priority': priority,
      'contactNumber': contactNumber,
      'emergencyContact': emergencyContact,
      'additionalNotes': additionalNotes,
      'isEmergencyLeave': isEmergencyLeave,
    };
  }
}
