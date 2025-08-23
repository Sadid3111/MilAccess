import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/functions/functions.dart';
import 'package:flutter_application_1/models/document_item.dart';

class UploadRequests extends StatefulWidget {
  const UploadRequests({super.key});

  @override
  State<UploadRequests> createState() => _UploadRequestsState();
}

class _UploadRequestsState extends State<UploadRequests> {
  List<Map<String, dynamic>> pendingFiles = [];

  Future<void> fetchPendingFiles() async {
    try {
      // Get a reference to the Firestore instance
      final firestore = FirebaseFirestore.instance;

      // Query the 'files' collection where the status is 'Pending'
      final querySnapshot = await firestore
          .collection('files')
          .where('status', isEqualTo: 'Pending')
          .get();

      // Process the fetched documents
      pendingFiles = querySnapshot.docs.map((doc) {
        return {'id': doc.id, ...doc.data()};
      }).toList();

      setState(() {});

      // Print or use the pending files
      print('Pending Files: $pendingFiles');
    } catch (e) {
      // Handle errors
      print('Error fetching pending files: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await fetchPendingFiles();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFA8D5A2),
      appBar: AppBar(backgroundColor: Colors.transparent),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: RefreshIndicator(
            onRefresh: fetchPendingFiles,
            child: ListView(
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
                ...pendingFiles.map((pendingFile) {
                  return DashboardCard(
                    document: DocumentItem(
                      id: pendingFile['id'],
                      title: pendingFile['title'],
                      ownerId: pendingFile['ownerId'],
                      url: pendingFile['url'],
                      status: pendingFile['status'],
                    ),
                  );
                }).toList(),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
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
  final DocumentItem document;

  const DashboardCard({super.key, required this.document});

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

  Future<String?> _showRemarksDialog(BuildContext context) async {
    TextEditingController remarksController = TextEditingController();
    return showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Remarks'),
          content: TextField(
            controller: remarksController,
            decoration: const InputDecoration(
              hintText: 'Enter remarks here...',
            ),
            maxLines: 3,
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(
                  context,
                ).pop(); // Close dialog without returning remarks
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(
                  context,
                ).pop(remarksController.text); // Return entered remarks
              },
              child: const Text('Submit'),
            ),
          ],
        );
      },
    );
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
              CircleAvatar(
                backgroundColor: const Color(0xFF006400),
                child: widget.document.status == 'Pending'
                    ? const Icon(Icons.article, color: Colors.white)
                    : (widget.document.status == 'Accepted'
                          ? const Icon(Icons.check_circle, color: Colors.green)
                          : const Icon(
                              Icons.cancel_outlined,
                              color: Colors.red,
                            )),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  widget.document.title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              widget.document.status == 'Pending'
                  ? GestureDetector(
                      onTap: _toggleOptions,
                      child: const Icon(Icons.more_vert),
                    )
                  : const SizedBox.shrink(),
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
                  onPressed: () async {
                    widget.document.status = 'Accepted';
                    setState(() {
                      _showOptions = false;
                    });
                    await changeStatus(
                      widget.document.id,
                      'Accepted',
                      null,
                      widget.document.ownerId,
                    );
                    if (!context.mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Accepted: ${widget.document.title}'),
                      ),
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
                  label: const Text("Reject"),
                  onPressed: () async {
                    final remarks = await _showRemarksDialog(context);
                    if (remarks != null && remarks.isNotEmpty) {
                      setState(() {
                        widget.document.status = 'Rejected';
                        _showOptions = false;
                      });
                      await changeStatus(
                        widget.document.id,
                        'Rejected',
                        remarks,
                        widget.document.ownerId,
                      );
                      if (!context.mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Rejected: ${widget.document.title}'),
                        ),
                      );
                    }
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
                  onPressed: () => viewDocument(widget.document, context),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
