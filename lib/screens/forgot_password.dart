import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ForgotPasswordScreen extends StatefulWidget {
  static const String idScreen = "forgotPassword";

  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  TextEditingController emailTextEditingController = TextEditingController();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white,
                Colors.lightBlue.shade100,
                Colors.lightBlue.shade300,
              ],
            ),
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Image(
                  image: AssetImage("images/home.png"),
                  width: 300,
                  height: 300,
                  color: Colors.teal,
                  alignment: Alignment.center,
                ),
                SizedBox(height: 15),
                Text(
                  "Forgot Password",
                  style: TextStyle(
                    fontSize: 24,
                    fontFamily: "Brand Bold",
                  ),
                  textAlign: TextAlign.center,
                ),
                Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    children: [
                      SizedBox(height: 1),
                      TextField(
                        controller: emailTextEditingController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          labelText: "Email",
                          labelStyle: TextStyle(
                            color: Colors.grey.shade400,
                            fontSize: 14,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide(color: Colors.black, width: 1.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide(color: Colors.blue, width: 2.0),
                          ),
                        ),
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(height: 15),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.black87,
                          backgroundColor: Colors.lightBlueAccent,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          minimumSize: const Size(double.infinity, 50),
                        ),
                        onPressed: () {
                          if (!isValidEmail(emailTextEditingController.text)) {
                            displayToastMessage(
                                "Please enter a valid email address",
                                context);
                          } else {
                            resetPassword(context);
                          }
                        },
                        child: Text(
                          "Reset Password",
                          style: TextStyle(fontSize: 18, fontFamily: "Brand-Bold"),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool isValidEmail(String email) {
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    return emailRegex.hasMatch(email);
  }

  void displayToastMessage(String message, BuildContext context) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void resetPassword(BuildContext context) async {
    final String email = emailTextEditingController.text.trim();
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
      displayToastMessage(
          "Password reset link has been sent to your email", context);
      Navigator.pop(context);
    } catch (error) {
      print("Error: $error");
      handleFirebaseAuthError(error, context);
    }
  }

  void handleFirebaseAuthError(dynamic error, BuildContext context) {
    String message;
    if (error is FirebaseAuthException) {
      switch (error.code) {
        case 'invalid-email':
          message = "The email address is not valid.";
          break;
        case 'user-not-found':
          message = "No user found with this email. Please sign up.";
          break;
        default:
          message = "An unexpected error occurred. Please try again.";
      }
    } else {
      message = "An unexpected error occurred. Please try again.";
    }
    displayToastMessage(message, context);
  }
}
