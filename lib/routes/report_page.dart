import 'package:curve/services/colors_provider.dart';
import 'package:curve/services/db.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ReportPage extends StatefulWidget {
  const ReportPage({super.key});

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  String _selectedType = 'Bug';
  final List<String> _reportTypes = [
    'Bug',
    'Inappropriate Content',
    'Suggestion',
    'Other'
  ];

  bool _isSubmitting = false;

  Future<void> _submitReport() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    try {
      final userId = FirebaseAuth.instance.currentUser?.uid ?? 'anonymous';

      await DatabaseService().submitReport(
        type: _selectedType,
        subject: _subjectController.text.trim(),
        description: _descriptionController.text.trim(),
        userId: userId,
      );

      if (!mounted) return;

      // Show success dialog
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text("Report Received"),
          content: const Text(
              "Thank you for your report. We will investigate this issue shortly."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(ctx); // Close dialog
                Navigator.pop(context); // Go back to settings
              },
              child: const Text("OK"),
            )
          ],
        ),
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text("Error submitting report: $e"),
              backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  void dispose() {
    _subjectController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Report Issue")),
      body: Consumer<ColorsProvider>(builder: (context, color, _) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "What would you like to report?",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: color.placeHolders(),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _selectedType,
                      isExpanded: true,
                      dropdownColor: color.getScaffoldColor(),
                      items: _reportTypes.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value,
                              style: TextStyle(
                                  color: color.navBarIconActiveColor())),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        setState(() {
                          _selectedType = newValue!;
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _subjectController,
                  style: TextStyle(color: color.navBarIconActiveColor()),
                  decoration: InputDecoration(
                    labelText: "Subject",
                    labelStyle: TextStyle(
                        color: color.navBarIconActiveColor().withOpacity(0.7)),
                    filled: true,
                    fillColor: color.placeHolders(),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  validator: (val) => val == null || val.isEmpty
                      ? "Please enter a subject"
                      : null,
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _descriptionController,
                  style: TextStyle(color: color.navBarIconActiveColor()),
                  maxLines: 6,
                  decoration: InputDecoration(
                    labelText: "Description",
                    hintText: "Please describe the issue in detail...",
                    hintStyle: TextStyle(
                        color: color.navBarIconActiveColor().withOpacity(0.5)),
                    labelStyle: TextStyle(
                        color: color.navBarIconActiveColor().withOpacity(0.7)),
                    filled: true,
                    fillColor: color.placeHolders(),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  validator: (val) => val == null || val.isEmpty
                      ? "Please enter a description"
                      : null,
                ),
                const SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  child: CupertinoButton.filled(
                    onPressed: _isSubmitting ? null : _submitReport,
                    child: _isSubmitting
                        ? const CupertinoActivityIndicator(color: Colors.white)
                        : const Text("Submit Report"),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
