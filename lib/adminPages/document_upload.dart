import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/functions/functions.dart';
import 'package:flutter_application_1/models/document_item.dart';
import 'package:flutter_application_1/models/user_data.dart';

// Define a class for document categories
class DocumentCategory {
  final String title;
  final List<DocumentItem> documents;

  DocumentCategory({required this.title, required this.documents});
}

class DocumentUploadScreen extends StatefulWidget {
  const DocumentUploadScreen({super.key});

  @override
  State<DocumentUploadScreen> createState() => _DocumentUploadScreenState();
}

class _DocumentUploadScreenState extends State<DocumentUploadScreen> {
  // Sample data for document categories and documents
  final List<DocumentCategory> _documentCategories = [
    DocumentCategory(
      title: 'Establishment and HR related',
      documents: [
        // DocumentItem(
        //   title: 'Establishment proposals (e.g. increase/decrease of manpower)',
        // ),
        // DocumentItem(title: 'Manning state adjustments'),
        // DocumentItem(title: 'Proposals for creating new appointments/posts'),
        // DocumentItem(title: 'Nominal rolls for specific selections'),
      ],
    ),
    DocumentCategory(
      title: 'Financial and procurement',
      documents: [
        // DocumentItem(
        //   title:
        //       'Procurement proposals exceeding unit’s financial power (Local Purchase above delegated limits)',
        // ),
        // DocumentItem(title: 'Annual procurement plan approvals'),
        // DocumentItem(
        //   title: 'Major repair/overhaul proposals for vehicles or equipment',
        // ),
        // DocumentItem(
        //   title: 'Bills requiring AHQ budget allocation or special sanction',
        // ),
      ],
    ),
    DocumentCategory(
      title: 'Infrastructure and construction',
      documents: [
        // DocumentItem(
        //   title: 'Construction or modification of permanent structures',
        // ),
        // DocumentItem(
        //   title:
        //       'Major maintenance proposals exceeding station HQ financial limits',
        // ),
        // DocumentItem(title: 'Land acquisition or allotment related proposals'),
      ],
    ),
    DocumentCategory(
      title: 'Training and operational plans',
      documents: [
        // DocumentItem(
        //   title:
        //       'Training exercise proposals involving multiple formations or strategic assets',
        // ),
        // DocumentItem(title: 'Live firing exercises requiring AHQ clearance'),
        // DocumentItem(
        //   title: 'Deployment proposals beyond unit operational area',
        // ),
      ],
    ),
    DocumentCategory(
      title: 'Welfare and ceremonial',
      documents: [
        // DocumentItem(
        //   title:
        //       'Major welfare project proposals (new unit canteen, mess extension, recreational facility)',
        // ),
        // DocumentItem(
        //   title:
        //       'Approval for significant ceremonial events involving external agencies or national protocol',
        // ),
      ],
    ),
    DocumentCategory(
      title: 'Discipline and legal',
      documents: [
        // DocumentItem(
        //   title:
        //       'Court martial proceedings requiring AHQ legal vetting or sanction',
        // ),
        // DocumentItem(
        //   title: 'Serious disciplinary cases forwarded to AHQ for decision',
        // ),
      ],
    ),
    DocumentCategory(
      title: 'Intelligence and security',
      documents: [
        // DocumentItem(
        //   title:
        //       'Intelligence summaries or threat reports that require upward dissemination',
        // ),
        // DocumentItem(
        //   title:
        //       'Security classification change proposals for unit premises or documents',
        // ),
      ],
    ),
  ];
  String? docId;
  String? selectedCategory;
  String? subtitle;
  String? selectedFilePath;
  bool isLoading = false;

  final List<String> categories = [
    'Establishment and HR related',
    'Financial and procurement',
    'Infrastructure and construction',
    'Training and operational plans',
    'Welfare and ceremonial',
    'Discipline and legal',
    'Intelligence and security',
  ];

  Future<String?> storeFile(String url) async {
    try {
      final docRef = await FirebaseFirestore.instance.collection('files').add({
        'ownerId': UserData.uid,
        'createdAt': FieldValue.serverTimestamp(),
        'category': selectedCategory,
        'title': subtitle,
        'url': url,
        'status': 'Forward',
      });

      return docRef.id;
    } catch (e) {
      print('Upload error: $e');
      return null;
    }
  }

  Future<String?> uploadPdf(String? filepath) async {
    setState(() {
      isLoading = true;
    });
    File file = File(filepath!);
    final dio = Dio();
    final formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(file.path),
      'upload_preset': 'pdf_upload',
      'resource_type': 'auto',
    });

    try {
      final response = await dio.post(
        'https://api.cloudinary.com/v1_1/dnvaq8op8/upload',
        data: formData,
      );
      final url = response.data['secure_url'];
      docId = await storeFile(url);
      return url;
    } catch (e) {
      print('Upload error: $e');
      return null;
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> openModal() async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 16.0,
            right: 16.0,
            top: 16.0,
          ),
          child: StatefulBuilder(
            builder: (BuildContext context, StateSetter setModalState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Upload Document',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      labelText: 'Select Category',
                      border: OutlineInputBorder(),
                    ),
                    value: selectedCategory,
                    items: categories
                        .map(
                          (category) => DropdownMenuItem(
                            value: category,
                            child: Text(category),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      setModalState(() {
                        selectedCategory = value;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Subtitle',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      subtitle = value;
                    },
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () async {
                      FilePickerResult? result = await FilePicker.platform
                          .pickFiles(
                            type: FileType.custom,
                            allowedExtensions: ['pdf'],
                          );
                      if (result != null) {
                        setModalState(() {
                          selectedFilePath = result.files.single.path;
                        });
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                    ),
                    icon: const Icon(Icons.attach_file),
                    label: const Text(
                      'Select PDF File',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  if (selectedFilePath != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        'Selected File: ${selectedFilePath!.split('/').last}',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.green,
                        ),
                      ),
                    ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () async {
                      if (selectedCategory != null &&
                          subtitle != null &&
                          selectedFilePath != null) {
                        Navigator.pop(context);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Please fill all fields and select a file',
                            ),
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                    ),
                    icon: const Icon(Icons.upload),
                    label: const Text(
                      'Upload',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              );
            },
          ),
        );
      },
    );
  }

  Future<void> _forwardDocument(DocumentItem document) async {
    await changeStatus(document.id, "Pending");
    setState(() {
      document.status = 'Pending';
      document.isExpanded = false; // Collapse after action
    });
    _showMessageBox(
      context,
      'Document Forwarded',
      '${document.title} has been forwarded.',
    );
  }

  void _toggleDocumentExpansion(DocumentItem document) {
    setState(() {
      // Collapse other expanded documents in the same category
      for (var category in _documentCategories) {
        for (var doc in category.documents) {
          if (doc != document) {
            doc.isExpanded = false;
          }
        }
      }
      document.isExpanded = !document.isExpanded;
    });
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
      case 'Pending':
        return Icons.pending;
      case 'Accepted':
        return Icons.check_circle;
      case 'Rejected':
        return Icons.cancel;
      default:
        return Icons.file_copy_rounded;
    }
  }

  // Helper to get color based on status
  Color _getStatusColor(String status) {
    switch (status) {
      case 'Pending':
        return Colors.blue;
      case 'Accepted':
        return Colors.green;
      case 'Rejected':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  Future<void> fetchFiles() async {
    for (int i = 0; i < _documentCategories.length; ++i) {
      _documentCategories[i].documents.clear();
    }
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('files')
          .where('ownerId', isEqualTo: UserData.uid)
          .get();
      final docs = querySnapshot.docs.map((doc) {
        return {'id': doc.id, ...doc.data()};
      }).toList();
      for (var doc in docs) {
        final index = categories.indexOf(doc['category']);
        _documentCategories[index].documents.add(
          DocumentItem(
            id: doc['id'],
            title: doc['title'],
            url: doc['url'],
            status: doc['status'] ?? 'Pending',
            remarks: doc['remarks'] ?? '',
          ),
        );
      }
      setState(() {});
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await fetchFiles();
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4, // Number of tabs
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Upload Document'), // Changed title here
          backgroundColor: Colors.green[700],
          bottom: const TabBar(
            tabs: [
              Tab(text: 'All'),
              Tab(text: 'Pending'),
              Tab(text: 'Rejected'),
              Tab(text: 'Accepted'),
            ],
          ),
        ),
        body: isLoading
            ? const Center(child: CircularProgressIndicator())
            : TabBarView(
                children: [
                  RefreshIndicator(
                    onRefresh: () => fetchFiles(),
                    child: _buildDocumentList('All'),
                  ),
                  RefreshIndicator(
                    onRefresh: () => fetchFiles(),
                    child: _buildDocumentList('Pending'),
                  ),
                  RefreshIndicator(
                    onRefresh: () => fetchFiles(),
                    child: _buildDocumentList('Rejected'),
                  ),
                  RefreshIndicator(
                    onRefresh: () => fetchFiles(),
                    child: _buildDocumentList('Accepted'),
                  ),
                ],
              ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            setState(() {
              selectedFilePath = null;
              selectedCategory = null;
              subtitle = null;
            });
            await openModal();
            if (selectedFilePath != null) {
              final url = await uploadPdf(selectedFilePath);
              final index = categories.indexOf(selectedCategory!);
              setState(() {
                if (index != -1) {
                  _documentCategories[index].documents.add(
                    DocumentItem(
                      id: docId!,
                      title: subtitle ?? "",
                      url: url ?? '',
                    ),
                  );
                }
              });
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('File uploaded!')));
            }
          },
          backgroundColor: Colors.green,
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  Widget _buildDocumentList(String filter) {
    final filteredCategories = _documentCategories
        .map((category) {
          final filteredDocuments = category.documents.where((document) {
            if (filter == 'All') return true;
            return document.status == filter;
          }).toList();

          return DocumentCategory(
            title: category.title,
            documents: filteredDocuments,
          );
        })
        .where((category) => category.documents.isNotEmpty)
        .toList();

    return filteredCategories.isEmpty
        ? ListView(
            children: const [
              Center(
                heightFactor: 10, // Adjust to center the message vertically
                child: Text('Nothing to show'),
              ),
            ],
          )
        : ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: filteredCategories.length,
            itemBuilder: (context, categoryIndex) {
              final category = filteredCategories[categoryIndex];
              return category.documents.isEmpty
                  ? const SizedBox.shrink()
                  : Card(
                      margin: const EdgeInsets.only(bottom: 16.0),
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              category.title,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            const Divider(height: 20, thickness: 1),
                            ListView.builder(
                              shrinkWrap: true, // Important for nested ListView
                              physics:
                                  const NeverScrollableScrollPhysics(), // Disable inner scrolling
                              itemCount: category.documents.length,
                              itemBuilder: (context, documentIndex) {
                                final document =
                                    category.documents[documentIndex];
                                return Column(
                                  children: [
                                    ListTile(
                                      leading: Icon(
                                        _getStatusIcon(document.status),
                                        color: _getStatusColor(document.status),
                                      ),
                                      title: Text(
                                        document.title,
                                        style: TextStyle(
                                          decoration:
                                              document.status == 'Rejected'
                                              ? TextDecoration.lineThrough
                                              : TextDecoration.none,
                                          color: document.status == 'Rejected'
                                              ? Colors.grey
                                              : Colors.black,
                                        ),
                                      ),
                                      trailing: document.isExpanded
                                          ? Icon(
                                              Icons.keyboard_arrow_up,
                                              color: Colors.grey[700],
                                            )
                                          : Icon(
                                              Icons.keyboard_arrow_down,
                                              color: Colors.grey[700],
                                            ),
                                      onTap: () =>
                                          _toggleDocumentExpansion(document),
                                    ),
                                    // Expanded section with buttons
                                    if (document.isExpanded)
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 16.0,
                                          vertical: 8.0,
                                        ),
                                        child: Wrap(
                                          runSpacing: 30,
                                          children: [
                                            ElevatedButton.icon(
                                              onPressed:
                                                  document.status == 'Forward'
                                                  ? () async =>
                                                        await _forwardDocument(
                                                          document,
                                                        )
                                                  : () {},
                                              icon: Icon(
                                                _getStatusIcon(document.status),
                                                color: Colors.white,
                                                size: 20,
                                              ),
                                              label: Text(
                                                document.status,
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                ),
                                              ),
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    _getStatusColor(
                                                      document.status,
                                                    ),
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      vertical: 6,
                                                      horizontal: 6,
                                                    ),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                              ),
                                            ),

                                            // const SizedBox(width: 10),
                                            // Expanded(
                                            //   child: ElevatedButton.icon(
                                            //     onPressed:
                                            //         document.status ==
                                            //             'Pending'
                                            //         ? () => _rejectDocument(
                                            //             document,
                                            //           )
                                            //         : null,
                                            //     icon: const Icon(
                                            //       Icons.close,
                                            //       color: Colors.white,
                                            //     ),
                                            //     label: const Text(
                                            //       'Reject',
                                            //       style: TextStyle(
                                            //         color: Colors.white,
                                            //       ),
                                            //     ),
                                            //     style: ElevatedButton.styleFrom(
                                            //       backgroundColor:
                                            //           document.status ==
                                            //               'Rejected'
                                            //           ? Colors.grey
                                            //           : Colors.red,
                                            //       padding:
                                            //           const EdgeInsets.symmetric(
                                            //             vertical: 12,
                                            //           ),
                                            //       shape: RoundedRectangleBorder(
                                            //         borderRadius:
                                            //             BorderRadius.circular(
                                            //               8,
                                            //             ),
                                            //       ),
                                            //     ),
                                            //   ),
                                            // ),
                                            const SizedBox(width: 40),
                                            ElevatedButton.icon(
                                              onPressed: () => viewDocument(
                                                document,
                                                context,
                                              ),
                                              icon: const Icon(
                                                Icons.visibility,
                                                color: Colors.white,
                                              ),
                                              label: const Text(
                                                'View',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                ),
                                              ),
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    Colors.blueGrey,
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      vertical: 12,
                                                      horizontal: 12,
                                                    ),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                              ),
                                            ),

                                            const SizedBox(width: 10),

                                            document.status == 'Rejected'
                                                ? TextField(
                                                    controller:
                                                        TextEditingController(
                                                          text:
                                                              document.remarks,
                                                        ),
                                                    readOnly: true,
                                                    maxLines: 3,
                                                    decoration: const InputDecoration(
                                                      labelText:
                                                          'Remarks (Reason for Rejection)',
                                                      border:
                                                          OutlineInputBorder(),
                                                    ),
                                                  )
                                                : const SizedBox.shrink(),
                                          ],
                                        ),
                                      ),
                                    const Divider(
                                      height: 1,
                                      thickness: 0.5,
                                    ), // Separator between documents
                                  ],
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    );
            },
          );
  }
}
