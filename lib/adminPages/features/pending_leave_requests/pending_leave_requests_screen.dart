import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_1/models/user_data.dart';

// Firebase-integrated data model for leave requests
class PendingLeaveRequest {
  final String id;
  final String requestId; // User ID who made the request
  final String requesterName;
  final String requesterUnit;
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

  PendingLeaveRequest({
    required this.id,
    required this.requestId,
    required this.requesterName,
    required this.requesterUnit,
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

  factory PendingLeaveRequest.fromMap(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return PendingLeaveRequest(
      id: doc.id,
      requestId: data['requestId'] ?? '',
      requesterName: data['requesterName'] ?? '',
      requesterUnit: data['requesterUnit'] ?? '',
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

  String get applicantDetails => '$requesterName, $requesterUnit';

  String get requestDetails {
    String dates =
        '${DateFormat('dd MMM yyyy').format(startDate)} - ${DateFormat('dd MMM yyyy').format(endDate)}';
    int days = endDate.difference(startDate).inDays + 1;
    return '$type for $days day${days > 1 ? 's' : ''} ($dates) - $reason';
  }
}

class PendingLeaveRequestsScreen extends StatefulWidget {
  const PendingLeaveRequestsScreen({super.key});

  @override
  State<PendingLeaveRequestsScreen> createState() =>
      _PendingLeaveRequestsScreenState();
}

class _PendingLeaveRequestsScreenState
    extends State<PendingLeaveRequestsScreen> {
  List<PendingLeaveRequest> _pendingRequests = [];
  bool _isLoading = true;
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    _fetchPendingRequests();
  }

  Future<void> _fetchPendingRequests() async {
    setState(() {
      _isLoading = true;
    });

    try {
      print('Fetching pending leave requests...');
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('leave_requests')
          .where('status', isEqualTo: 'Pending')
          .orderBy('submittedDate', descending: true)
          .get();

      print('Found ${querySnapshot.docs.length} pending requests');

      List<PendingLeaveRequest> fetchedRequests = querySnapshot.docs
          .map((doc) => PendingLeaveRequest.fromMap(doc))
          .toList();

      if (mounted) {
        setState(() {
          _pendingRequests = fetchedRequests;
          _isLoading = false;
        });
      }

      print('Successfully loaded ${_pendingRequests.length} pending requests');
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
      print('Error fetching pending requests: $e');
      _showErrorMessage('Error loading requests: $e');
    }
  }

  Future<void> _approveRequest(PendingLeaveRequest request) async {
    if (_isProcessing) return;

    setState(() {
      _isProcessing = true;
    });

    try {
      print('Approving request: ${request.id}');

      // Update request status in Firebase
      await FirebaseFirestore.instance
          .collection('leave_requests')
          .doc(request.id)
          .update({
            'status': 'Approved',
            'approvedBy': UserData.uid,
            'approvedByName': UserData.name,
            'actionDate': FieldValue.serverTimestamp(),
          });

      // Create notification for the requester
      await _createApprovalNotification(request, true);

      // Refresh the list
      await _fetchPendingRequests();

      if (mounted) {
        setState(() {
          _isProcessing = false;
        });
        _showSuccessMessage(
          '✅ ${request.requesterName}\'s leave request has been approved',
        );
      }

      print('Request approved successfully');
    } catch (e) {
      if (mounted) {
        setState(() {
          _isProcessing = false;
        });
      }
      print('Error approving request: $e');
      _showErrorMessage('Error approving request: $e');
    }
  }

  Future<void> _disapproveRequest(PendingLeaveRequest request) async {
    if (_isProcessing) return;

    // Show reason dialog first
    String? reason = await _showReasonDialog(
      'Disapproval Reason',
      'Please provide a reason for disapproval:',
    );

    if (reason == null || reason.trim().isEmpty) {
      return; // User cancelled or didn't provide reason
    }

    setState(() {
      _isProcessing = true;
    });

    try {
      print('Disapproving request: ${request.id}');

      // Update request status in Firebase
      await FirebaseFirestore.instance
          .collection('leave_requests')
          .doc(request.id)
          .update({
            'status': 'Rejected',
            'rejectedBy': UserData.uid,
            'rejectedByName': UserData.name,
            'rejectionReason': reason.trim(),
            'actionDate': FieldValue.serverTimestamp(),
          });

      // Create notification for the requester
      await _createApprovalNotification(request, false, reason.trim());

      // Refresh the list
      await _fetchPendingRequests();

      if (mounted) {
        setState(() {
          _isProcessing = false;
        });
        _showSuccessMessage(
          '❌ ${request.requesterName}\'s leave request has been rejected',
        );
      }

      print('Request rejected successfully');
    } catch (e) {
      if (mounted) {
        setState(() {
          _isProcessing = false;
        });
      }
      print('Error rejecting request: $e');
      _showErrorMessage('Error rejecting request: $e');
    }
  }

  Future<void> _createApprovalNotification(
    PendingLeaveRequest request,
    bool isApproved, [
    String? reason,
  ]) async {
    try {
      String message = isApproved
          ? 'Your ${request.type.toLowerCase()} request has been approved by ${UserData.name}'
          : 'Your ${request.type.toLowerCase()} request has been rejected by ${UserData.name}${reason != null ? ": $reason" : ""}';

      await FirebaseFirestore.instance.collection('notifications').add({
        'targetId': request.requestId,
        'content': message,
        'type': 'leave_response',
        'requestId': request.id,
        'isApproved': isApproved,
        'approverName': UserData.name,
        'leaveType': request.type,
        'rejectionReason': reason,
        'createdAt': FieldValue.serverTimestamp(),
        'seen': false,
      });

      print('Notification created for user: ${request.requestId}');
    } catch (e) {
      print('Error creating notification: $e');
    }
  }

  Future<String?> _showReasonDialog(String title, String hint) async {
    TextEditingController reasonController = TextEditingController();

    return showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(title),
        content: TextField(
          controller: reasonController,
          decoration: InputDecoration(
            hintText: hint,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          ),
          maxLines: 3,
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, reasonController.text),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red[800],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Submit'),
          ),
        ],
      ),
    );
  }

  void _showSuccessMessage(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.check_circle, color: Colors.white),
              const SizedBox(width: 8),
              Expanded(child: Text(message)),
            ],
          ),
          backgroundColor: Colors.green[800],
          duration: const Duration(seconds: 3),
        ),
      );
    }
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
          duration: const Duration(seconds: 4),
        ),
      );
    }
  }

  void _showMessageBox(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Pending Leave Requests',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Colors.green[700],
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: _fetchPendingRequests,
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text(
                    'Loading pending requests...',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ],
              ),
            )
          : _pendingRequests.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.inbox_outlined, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'No pending leave requests found.',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'All caught up! 🎉',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
              ),
            )
          : RefreshIndicator(
              onRefresh: _fetchPendingRequests,
              child: ListView.builder(
                padding: const EdgeInsets.all(16.0),
                itemCount: _pendingRequests.length,
                itemBuilder: (context, index) {
                  final request = _pendingRequests[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15.0),
                            border: Border(
                              left: BorderSide(
                                color: request.isEmergencyLeave
                                    ? Colors.red
                                    : Colors.blue,
                                width: 4,
                              ),
                            ),
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(16),
                            leading: CircleAvatar(
                              backgroundColor: request.isEmergencyLeave
                                  ? Colors.red
                                  : Colors.blue,
                              child: Icon(
                                request.isEmergencyLeave
                                    ? Icons.emergency
                                    : Icons.person,
                                color: Colors.white,
                              ),
                            ),
                            title: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    request.requesterName,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                                if (request.isEmergencyLeave)
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.red.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(color: Colors.red),
                                    ),
                                    child: const Text(
                                      'EMERGENCY',
                                      style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.red,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 4),
                                Text(
                                  request.applicantDetails,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[600],
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  request.requestDetails,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.access_time,
                                      size: 12,
                                      color: Colors.grey[600],
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      'Submitted: ${DateFormat('dd MMM yyyy, HH:mm').format(request.submittedDate)}',
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: Colors.grey[500],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            trailing: _isProcessing
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  )
                                : const Icon(Icons.arrow_forward_ios, size: 16),
                            onTap: () {
                              _showMessageBox(
                                context,
                                'Leave Request Details',
                                'Applicant: ${request.requesterName}\n'
                                    'Unit: ${request.requesterUnit}\n'
                                    'Type: ${request.type}\n'
                                    'Dates: ${DateFormat('dd MMM yyyy').format(request.startDate)} - ${DateFormat('dd MMM yyyy').format(request.endDate)}\n'
                                    'Duration: ${request.duration}\n'
                                    'Priority: ${request.priority}\n'
                                    'Reason: ${request.reason}\n'
                                    'Contact: ${request.contactNumber}\n'
                                    '${request.emergencyContact != null ? 'Emergency Contact: ${request.emergencyContact}\n' : ''}'
                                    '${request.additionalNotes != null ? 'Notes: ${request.additionalNotes}\n' : ''}'
                                    'Submitted: ${DateFormat('dd MMM yyyy, HH:mm').format(request.submittedDate)}',
                              );
                            },
                          ),
                        ),
                        // Action buttons section
                        if (!_isProcessing)
                          Container(
                            padding: const EdgeInsets.all(16),
                            child: Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton.icon(
                                    onPressed: () =>
                                        _disapproveRequest(request),
                                    icon: const Icon(Icons.close, size: 18),
                                    label: const Text('Reject'),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.red[600],
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 12,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: ElevatedButton.icon(
                                    onPressed: () => _approveRequest(request),
                                    icon: const Icon(Icons.check, size: 18),
                                    label: const Text('Approve'),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.green[600],
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 12,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                  ),
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
    );
  }
}
