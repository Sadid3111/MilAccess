import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_1/models/user_data.dart';

class ReportGeneratorPage extends StatefulWidget {
  final String role;
  const ReportGeneratorPage({super.key, required this.role});

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
        generatedReport =
            '''
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

  Future<void> saveReportToFirebase() async {
    if (generatedReport.isEmpty) return;

    try {
      // Save the report
      await FirebaseFirestore.instance.collection('reports').add({
        'type': 'SA Firing Report',
        'content': generatedReport,
        'generatedBy': '${rankController.text} ${nameController.text}',
        'unitName': UserData.unitName,
        'timestamp': FieldValue.serverTimestamp(),
        'ownerId': UserData.uid,
        'role': UserData.role,
      });

      // Create notification based on role
      String targetId;
      String notificationContent;

      if (widget.role.toLowerCase() == 'user') {
        targetId =
            UserData.unitName; // Admin of the same unit gets notification
        notificationContent =
            'New SA Firing Report submitted by ${rankController.text} ${nameController.text}';
      } else {
        targetId = 'ahq'; // AHQ gets notification from admin
        notificationContent =
            'New SA Firing Report submitted by ${UserData.unitName} - ${rankController.text} ${nameController.text}';
      }

      // Save notification
      await FirebaseFirestore.instance.collection('notifications').add({
        'createdAt': FieldValue.serverTimestamp(),
        'content': notificationContent,
        'targetId': targetId,
        'seen': false,
      });

      setState(() {
        generatedReport = '';
        ammoController.clear();
        firedController.clear();
        misfireController.clear();
        collectedController.clear();
        lostController.clear();
        rankController.clear();
        nameController.clear();
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Report sent successfully!'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to send report: $e'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
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
                  nameController,
                ].asMap().entries.map((entry) {
                  final index = entry.key;
                  final controller = entry.value;
                  final labels = [
                    'Total Ammo',
                    'Fired Ammo',
                    'Misfires',
                    'Shells Collected',
                    'Lost Shells',
                    'Officer Rank',
                    'Officer Name',
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
                      horizontal: 24,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'Generate Report',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                if (generatedReport.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Clipboard.setData(
                              ClipboardData(text: generatedReport),
                            );
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Report copied to clipboard'),
                                duration: Duration(seconds: 2),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          icon: const Icon(Icons.copy, color: Colors.white),
                          label: const Text(
                            'Copy',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () async {
                            await saveReportToFirebase();
                            //Share.share(generatedReport);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          icon: const Icon(Icons.share, color: Colors.white),
                          label: const Text(
                            'Send',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
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
