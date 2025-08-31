import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/user_data.dart';
import 'package:intl/intl.dart'; // For date and time formatting
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';

// Data model for a Report from Firebase
class generatedReport {
  final String id;
  final String type;
  final String content;
  final String generatedBy;
  final String unitName;
  final DateTime timestamp;
  String? remarks;
  final String ownerId;

  generatedReport({
    required this.id,
    required this.type,
    required this.content,
    required this.generatedBy,
    required this.unitName,
    required this.timestamp,
    this.remarks,
    required this.ownerId,
  });

  factory generatedReport.fromMap(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return generatedReport(
      id: doc.id,
      type: data['type'] ?? 'Unknown Report',
      content: data['content'] ?? '',
      generatedBy: data['generatedBy'] ?? 'Unknown',
      unitName: data['unitName'] ?? 'Unknown Unit',
      timestamp: (data['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now(),
      remarks: data['remarks'],
      ownerId: data['ownerId'] ?? '',
    );
  }
}

class IncidentReportScreen extends StatefulWidget {
  final String role;
  const IncidentReportScreen({super.key, required this.role});

  @override
  State<IncidentReportScreen> createState() => _IncidentReportScreenState();
}

class _IncidentReportScreenState extends State<IncidentReportScreen> {
  List<generatedReport> _reports = [];
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    if (widget.role == 'ahq') {
      _fetchAllReports();
    } else {
      _fetchUserReports();
    }
  }

  Future<void> _fetchAllReports() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = '';
      });

      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('reports')
          .where('role', isEqualTo: 'Unit Admin')
          .where('ownerId', isNotEqualTo: UserData.uid)
          .orderBy('timestamp', descending: true)
          .get();

      List<generatedReport> fetchedReports = querySnapshot.docs
          .map((doc) => generatedReport.fromMap(doc))
          .toList();

      setState(() {
        _reports = fetchedReports;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Error fetching reports: $e';
      });
    }
  }

  Future<void> _fetchUserReports() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = '';
      });

      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('reports')
          .where('role', isEqualTo: 'User')
          .where('unitName', isEqualTo: UserData.unitName.trim())
          .where('ownerId', isNotEqualTo: UserData.uid)
          .orderBy('timestamp', descending: true)
          .get();
      List<generatedReport> fetchedReports = querySnapshot.docs
          .map((doc) => generatedReport.fromMap(doc))
          .toList();
      print(UserData.uid);
      setState(() {
        _reports = fetchedReports;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Error fetching reports: $e';
      });
    }
  }

  void _viewReportDetails(generatedReport report) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ReportPDFViewer(report: report)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reports'),
        backgroundColor: Colors.green[700],
      ),
      body: _isLoading
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text(
                    'Loading reports...',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ],
              ),
            )
          : _errorMessage.isNotEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
                  const SizedBox(height: 16),
                  Text(
                    _errorMessage,
                    style: const TextStyle(fontSize: 16, color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: widget.role == 'ahq'
                        ? _fetchAllReports
                        : _fetchUserReports,
                    child: const Text('Retry'),
                  ),
                ],
              ),
            )
          : _reports.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.description_outlined,
                    size: 64,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'No reports found.',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ],
              ),
            )
          : RefreshIndicator(
              onRefresh: widget.role == 'ahq'
                  ? _fetchAllReports
                  : _fetchUserReports,
              child: ListView.builder(
                padding: const EdgeInsets.all(16.0),
                itemCount: _reports.length,
                itemBuilder: (context, index) {
                  final report = _reports[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: ListTile(
                      leading: Icon(
                        _getReportIcon(report.type),
                        color: _getReportColor(report.type),
                      ),
                      title: Text(
                        report.type,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Generated by: ${report.generatedBy}',
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                          Text(
                            'Unit: ${report.unitName}',
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                          Text(
                            'Date: ${DateFormat('dd MMM yyyy hh:mm a').format(report.timestamp)}',
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                        ],
                      ),
                      trailing: const Icon(
                        Icons.arrow_forward_ios,
                        size: 16,
                        color: Colors.grey,
                      ),
                      onTap: () {
                        _viewReportDetails(report);
                      },
                    ),
                  );
                },
              ),
            ),
    );
  }

  IconData _getReportIcon(String reportType) {
    switch (reportType.toLowerCase()) {
      case 'sa firing report':
        return Icons.local_fire_department;
      case 'mov report':
        return Icons.directions_bus;
      case 'grenade firing report':
        return Icons.brightness_high;
      case 'patrolling report':
        return Icons.directions_walk;
      default:
        return Icons.description;
    }
  }

  Color _getReportColor(String reportType) {
    switch (reportType.toLowerCase()) {
      case 'sa firing report':
        return Colors.red[700]!;
      case 'mov report':
        return Colors.blue[700]!;
      case 'grenade firing report':
        return Colors.orange[700]!;
      case 'patrolling report':
        return Colors.green[700]!;
      default:
        return Colors.grey[700]!;
    }
  }
}

// PDF-style Viewer for Reports
class ReportPDFViewer extends StatefulWidget {
  final generatedReport report;

  const ReportPDFViewer({super.key, required this.report});

  @override
  State<ReportPDFViewer> createState() => _ReportPDFViewerState();
}

class _ReportPDFViewerState extends State<ReportPDFViewer> {
  final TextEditingController remarksController = TextEditingController();

  @override
  void dispose() {
    remarksController.dispose();
    super.dispose();
  }

  Future<void> _createNotification(
    String targetUserId,
    String reportType,
    String reportId,
  ) async {
    try {
      await FirebaseFirestore.instance.collection('notifications').add({
        'targetId': targetUserId,
        'content':
            'A remark has been added to your ${reportType.toLowerCase()}: ${remarksController.text.trim()}',
        'createdAt': FieldValue.serverTimestamp(),
        'seen': false,
      });
    } catch (e) {
      print('Error creating notification: $e');
    }
  }

  Future<void> _updateRemarks(String reportId, String remarks) async {
    try {
      await FirebaseFirestore.instance
          .collection('reports')
          .doc(reportId)
          .update({'remarks': remarks});

      // Create notification for the report owner (but not if they're adding remarks to their own report)
      if (widget.report.ownerId != UserData.uid) {
        await _createNotification(
          widget.report.ownerId,
          widget.report.type,
          reportId,
        );
      }
      widget.report.remarks = remarksController.text;
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Remarks updated successfully'),
            backgroundColor: Colors.green,
          ),
        );

        // Update the local report data
        setState(() {
          // This will trigger a rebuild to reflect the updated remarks
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error updating remarks: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _showRemarksDialog(BuildContext context, generatedReport report) {
    remarksController.text = report.remarks ?? '';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add/Edit Remarks'),
          content: SizedBox(
            width: 300,
            child: TextField(
              controller: remarksController,
              decoration: const InputDecoration(
                hintText: 'Enter your remarks here...',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
              maxLength: 500,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                _updateRemarks(report.id, remarksController.text.trim());
                Navigator.of(context).pop();
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text('${widget.report.type} - PDF View'),
        backgroundColor: Colors.grey[800],
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.copy),
            onPressed: () {
              _copyReportContent(context);
            },
            tooltip: 'Copy Report',
          ),
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              _shareReport(context);
            },
            tooltip: 'Share Report',
          ),
          IconButton(
            icon: const Icon(Icons.comment_outlined),
            onPressed: () {
              _showRemarksDialog(context, widget.report);
            },
            tooltip: 'Add Remarks',
          ),
        ],
      ),
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          padding: const EdgeInsets.all(20),
          child: Center(
            child: Container(
              width: double.infinity,
              constraints: const BoxConstraints(maxWidth: 800),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(40),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header Section
                    _buildHeader(),
                    const SizedBox(height: 30),

                    // Report Title
                    Center(
                      child: Text(
                        widget.report.type.toUpperCase(),
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.5,
                          fontFamily: 'Times New Roman',
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),

                    // Report Information Section
                    _buildInfoSection(),
                    const SizedBox(height: 30),

                    // Report Content
                    _buildContentSection(),
                    const SizedBox(height: 30),

                    // Remarks Section
                    _buildRemarksSection(),
                    const SizedBox(height: 40),

                    // Footer
                    _buildFooter(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Row(
          children: [
            Icon(Icons.military_tech, size: 32, color: Colors.green[800]),
            const SizedBox(width: 12),
            const Expanded(
              child: Text(
                'MILITARY OPERATIONS REPORT',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                  fontFamily: 'Times New Roman',
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Container(height: 2, color: Colors.green[800]),
      ],
    );
  }

  Widget _buildInfoSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[400]!),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'REPORT INFORMATION',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
              fontFamily: 'Times New Roman',
            ),
          ),
          const SizedBox(height: 16),
          _buildInfoRow('Report Type:', widget.report.type),
          _buildInfoRow('Generated By:', widget.report.generatedBy),
          _buildInfoRow('Unit:', widget.report.unitName),
          _buildInfoRow(
            'Date & Time:',
            DateFormat('dd MMMM yyyy, hh:mm a').format(widget.report.timestamp),
          ),
          _buildInfoRow(
            'Report ID:',
            widget.report.id.substring(0, 8).toUpperCase(),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                fontFamily: 'Times New Roman',
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 12,
                fontFamily: 'Times New Roman',
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContentSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'REPORT CONTENT',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
            fontFamily: 'Times New Roman',
          ),
        ),
        const SizedBox(height: 16),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[400]!),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            widget.report.content,
            style: const TextStyle(
              fontSize: 12,
              height: 1.5,
              fontFamily: 'Times New Roman',
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRemarksSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'REMARKS',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
            fontFamily: 'Times New Roman',
          ),
        ),
        const SizedBox(height: 16),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[400]!),
            borderRadius: BorderRadius.circular(4),
            color: Colors.grey[50],
          ),
          child: Text(
            widget.report.remarks?.isNotEmpty == true
                ? widget.report.remarks!
                : 'No remarks added yet.',
            style: TextStyle(
              fontSize: 12,
              height: 1.5,
              fontFamily: 'Times New Roman',
              color: widget.report.remarks?.isNotEmpty == true
                  ? Colors.black
                  : Colors.grey[600],
              fontStyle: widget.report.remarks?.isNotEmpty == true
                  ? FontStyle.normal
                  : FontStyle.italic,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFooter() {
    return Column(
      children: [
        Container(height: 1, color: Colors.grey[400]),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Generated on: ${DateFormat('dd/MM/yyyy HH:mm').format(DateTime.now())}',
              style: TextStyle(
                fontSize: 10,
                color: Colors.grey[600],
                fontFamily: 'Times New Roman',
              ),
            ),
            Text(
              'Page 1 of 1',
              style: TextStyle(
                fontSize: 10,
                color: Colors.grey[600],
                fontFamily: 'Times New Roman',
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _copyReportContent(BuildContext context) {
    final formattedContent =
        '''
${widget.report.type.toUpperCase()}

REPORT INFORMATION:
Report Type: ${widget.report.type}
Generated By: ${widget.report.generatedBy}
Unit: ${widget.report.unitName}
Date & Time: ${DateFormat('dd MMMM yyyy, hh:mm a').format(widget.report.timestamp)}
Report ID: ${widget.report.id.substring(0, 8).toUpperCase()}

REPORT CONTENT:
${widget.report.content}

REMARKS:
${widget.report.remarks?.isNotEmpty == true ? widget.report.remarks! : 'No remarks added yet.'}

---
Generated on: ${DateFormat('dd/MM/yyyy HH:mm').format(DateTime.now())}
''';

    Clipboard.setData(ClipboardData(text: formattedContent));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Report copied to clipboard'),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _shareReport(BuildContext context) {
    // You can implement share functionality here
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Share functionality would be implemented here'),
        duration: Duration(seconds: 2),
      ),
    );
  }
}
