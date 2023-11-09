import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HelpFeedbackPage extends StatefulWidget {
  final String userEmail;

  HelpFeedbackPage({required this.userEmail});

  @override
  _HelpFeedbackPageState createState() => _HelpFeedbackPageState();
}

class _HelpFeedbackPageState extends State<HelpFeedbackPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _messageController = TextEditingController();
  String selectedIssue = "General Feedback";

  @override
  Widget build(BuildContext context) {
    List<String> commonIssues = [
      "General Feedback",
      "App Crashes",
      "Login Problems",
      "Feature Request",
      "Other",
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('Help & Feedback', style: GoogleFonts.roboto()),
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: <Widget>[
            Text(
              'If you\'re experiencing issues or have suggestions for how we can improve, please let us know.',
              style: GoogleFonts.roboto(fontSize: 16),
            ),
            SizedBox(height: 20),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: 'Select an issue',
                labelStyle: TextStyle(color: Colors.black),
                border: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black, width: 1.5),
                ),
              ),
              value: selectedIssue,
              onChanged: (String? newValue) {
                if (newValue != null) {
                  setState(() {
                    selectedIssue = newValue;
                  });
                }
              },
              items: commonIssues.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: _messageController,
              cursorColor: Colors.black,
              maxLines: 6,
              decoration: InputDecoration(
                labelText: 'Your Message',
                labelStyle: TextStyle(color: Colors.black),
                hintText: 'Please enter your message here',
                floatingLabelBehavior: FloatingLabelBehavior.always,
                border: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black, width: 1.5),
                ),
              ),
              // Include form validation if needed
            ),
            SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
              child: Text('Send Feedback', style: GoogleFonts.roboto()),
              onPressed: () => _sendFeedback(),
            ),
          ],
        ),
      ),
    );
  }

  void _sendFeedback() async {
    final message = _messageController.text.trim();
    if (message.isNotEmpty) {
      try {
        await FirebaseFirestore.instance.collection('feedback').add({
          'email': widget.userEmail,
          'issue': selectedIssue,
          'message': message,
          'timestamp': FieldValue.serverTimestamp(),
        });

        _messageController.clear();

        // Show confirmation dialog
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Feedback Sent"),
              content: Text("Your feedback has been successfully sent. Thank you!"),
              actions: <Widget>[
                TextButton(
                  child: Text("OK"),
                  onPressed: () {
                    Navigator.of(context).pop(); // Dismiss the dialog
                  },
                ),
              ],
            );
          },
        );

      } catch (e) {
        // Handle any errors here
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Error"),
              content: Text("An error occurred while sending feedback. Please try again."),
              actions: <Widget>[
                TextButton(
                  child: Text("OK"),
                  onPressed: () {
                    Navigator.of(context).pop(); // Dismiss the dialog
                  },
                ),
              ],
            );
          },
        );
      }
    }
  }


  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }
}
