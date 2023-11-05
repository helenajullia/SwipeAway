import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HelpFeedbackPage extends StatelessWidget {
  final String userEmail;

  HelpFeedbackPage({required this.userEmail});

  @override
  Widget build(BuildContext context) {
    String selectedIssue = "General Feedback";
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
                focusedBorder: OutlineInputBorder( // Add this
                  borderSide: BorderSide(color: Colors.black, width: 1.5),
                ),
              ),
              value: selectedIssue,
              onChanged: (String? newValue) {
                if (newValue != null) {
                  selectedIssue = newValue;
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
              style: ElevatedButton.styleFrom(backgroundColor: Colors.black), // Button color black
              child: Text('Send Feedback', style: GoogleFonts.roboto()),
              onPressed: () {
                // Implement the logic to send feedback (e.g., using email or a backend service)
              },
            ),
          ],
        ),
      ),
    );
  }
}
