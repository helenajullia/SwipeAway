import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChangePassword extends StatelessWidget {
  // Create a TextEditingController for the password field
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.close, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text(
          'Change Password',
          style: GoogleFonts.roboto(
            color: Colors.white, // Ensure the title text is white for contrast
          ),
        ),
        // This ensures no title on the AppBar
        centerTitle: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              'Enter a new password:',
              style: GoogleFonts.roboto(
                color: Colors.black,
                fontSize: MediaQuery.of(context).size.width * 0.08,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 30),
            TextField(
              controller: passwordController, // Use the TextEditingController
              cursorColor: Colors.black,
              decoration: InputDecoration(
                labelText: 'Reset password',
                labelStyle: TextStyle(color: Colors.black),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide(color: Colors.black, width: 1.5),  // Change the color and width as you wish
                ),
              ),
              keyboardType: TextInputType.emailAddress,
              obscureText: true,
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () async {
                try {
                  // Fetch the email of the current user
                  final user = FirebaseAuth.instance.currentUser;
                  if (user != null) {
                    // Update password in Firestore
                    await FirebaseFirestore.instance.collection('users').doc(user.email).update({
                      'password': passwordController.text,
                    });

                    // Update password in Firebase Authentication
                    await user.updatePassword(passwordController.text);
                  }
                  // Show a success message
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Password updated successfully!')));

                  Navigator.pop(context);
                } catch (e) {
                  // Handle error
                  print('Error: $e');
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to update password. Try again.')));
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                padding: EdgeInsets.symmetric(horizontal: 100, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),

                ),
              ),
              child: Text(
                'UPDATE',
                style: GoogleFonts.roboto(
                  color: Colors.white,
                  fontSize: MediaQuery.of(context).size.width * 0.05,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
