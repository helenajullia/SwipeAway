import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HelpFeedbackPage extends StatelessWidget {
  final String userEmail; // User's email is passed to the constructor

  HelpFeedbackPage({required this.userEmail});

  @override
  Widget build(BuildContext context) {
    String selectedIssue = "General Feedback"; // Default issue type
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
                border: OutlineInputBorder(),
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
              maxLines: 6,
              decoration: InputDecoration(
                labelText: 'Your Message',
                hintText: 'Please enter your message here',
                border: OutlineInputBorder(),
              ),
              // Include form validation if needed
            ),
            SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(primary: Colors.black), // Button color black
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
