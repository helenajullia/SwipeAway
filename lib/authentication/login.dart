import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:swipe_away/authentication/forgot_thePassword.dart';
import 'package:swipe_away/authentication/SignUp.dart';
import 'package:swipe_away/home/search_page.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import '../adminService/adminInterface.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}
class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> signInWithFacebook() async {
    try {
      // Trigger the Facebook Sign-In process
      final LoginResult result = await FacebookAuth.instance.login();

      // Check the status of the login process
      if (result.status == LoginStatus.success) {
        // User is logged in
        final AccessToken accessToken = result.accessToken!;

        // Here you can use accessToken as needed
        // For example, you can now sign in to Firebase with this token
        // or use it to fetch additional information from Facebook

        // Navigate to your desired page or handle the login success
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => SearchPage()));
      } else {
        // Handle different cases like cancellation, or error
        print(result.status);
        print(result.message);

        // Show a snackbar or any other UI to inform the user
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Facebook login failed: ${result.message}"),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      // General error handling
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("An error occurred: $e"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> signIn() async {
    try {
      final UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      final User? user = userCredential.user;
      if (user != null) {
        // Check if the user is the admin
        if (user.email == "adminswipeaway@yahoo.com") {
          // Redirect to the Admin Interface
          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => AdminInterface()));
          return; // Exit the function after handling admin user
        }

        // If not admin, proceed with normal user check
        final DocumentSnapshot userDoc = await _firestore.collection('users').doc(user.email).get();
        if (userDoc.exists) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Logged in successfully."),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => SearchPage()));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("You don't have an account."),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found' || e.code == 'wrong-password') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("The email or password are incorrect."),
            backgroundColor: Colors.red,
            action: SnackBarAction(
              label: "Resetting password.",
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => ForgotPassword()));
              },
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.message ?? "An error occurred"),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("An error occurred. Please try again later."),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double formWidth = screenWidth > 500 ? 500 : screenWidth * 0.85; // Use 85% of screen width if screen is small

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.close, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            width: formWidth,
            padding: EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Login',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.roboto(
                    color: Colors.black,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 30.0),
                TextField(
                  controller: emailController,
                  cursorColor: Colors.black,
                  decoration: InputDecoration(
                    hintText: 'Email',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(color: Colors.black, width: 1.5),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(color: Colors.black, width: 1.5),
                    ),
                  ),
                ),
                SizedBox(height: 15.0),
                TextField(
                  controller: passwordController,
                  cursorColor: Colors.black,
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: 'Password',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(color: Colors.black, width: 1.5),
                    ),
                  ),
                ),
                SizedBox(height: 30.0),
                ElevatedButton(
                  onPressed: signIn,
                  style: ElevatedButton.styleFrom(
                    primary: Colors.black,
                    padding: EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  child: Text(
                    'LOGIN',
                    style: GoogleFonts.roboto(
                      color: Colors.white,
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Center(
                  child: TextButton(
                    onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => ForgotPassword())),
                    child: Text(
                      'Forgot your password?',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ),
                SizedBox(height: 15.0),
                ElevatedButton(
                  onPressed: signInWithFacebook,
                  style: ElevatedButton.styleFrom(
                    primary: Colors.blue, // Facebook color
                    padding: EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  child: Text(
                    'Login with Facebook',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                SizedBox(height: 15.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Don\'t have an account? '),
                    TextButton(
                      onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => SignUp())),
                      child: Text(
                        'Sign Up',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}