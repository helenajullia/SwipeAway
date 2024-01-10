import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChangePassword extends StatelessWidget {
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double formWidth = screenWidth > 500 ? 500 : screenWidth * 0.85; // Use 85% of screen width if screen is small

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.close, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Change Password',
          style: GoogleFonts.roboto(
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: Center(
      child: SingleChildScrollView(
      child: Container(
      width: formWidth,
      padding: EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Text(
            'Enter a new password:',
            textAlign: TextAlign.center,
            style: GoogleFonts.roboto(
              color: Colors.black,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 30),
          TextField(
            controller: passwordController,
            cursorColor: Colors.black,
            decoration: InputDecoration(
              labelText: 'Reset password',
              labelStyle: TextStyle(color: Colors.black),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.black, width: 1.5),
              ),
            ),
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
                primary: Colors.black,
                padding: EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                'UPDATE',
                style: GoogleFonts.roboto(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),
      ),
      ),
      ),
    );
  }
}