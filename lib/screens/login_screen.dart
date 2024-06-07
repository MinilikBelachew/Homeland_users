import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:users/main.dart';
import 'package:users/screens/main_screen.dart';
import 'package:users/screens/signup_screen.dart';
import 'package:users/widgets/progess_dialog.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'forgot_password.dart';

class LoginScreen extends StatefulWidget {
  static const String idScreen = "login";

  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailTextEditingController = TextEditingController();
  final TextEditingController passwordTextEditingController = TextEditingController();
  bool _isPasswordVisible = false;

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  int _loginAttempts = 0;
  bool _isLocked = false;
  Timer? _timer;
  int _remainingSeconds = 30;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void startCountdown() {
    setState(() {
      _isLocked = true;
      _remainingSeconds = 30;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        setState(() {
          _remainingSeconds--;
        });
      } else {
        timer.cancel();
        setState(() {
          _isLocked = false;
          _loginAttempts = 0;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
          body: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Colors.white, Colors.lightBlueAccent.shade100],
              ),
            ),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const Image(
                    image: AssetImage("images/home.png"),
                    width: 300,
                    height: 300,
                    color: Colors.teal,
                    alignment: Alignment.center,
                  ),
                  const SizedBox(height: 15),
                  const Text(
                    "Log in As A user",
                    style: TextStyle(
                      fontSize: 24,
                      fontFamily: "Brand Bold",
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        const SizedBox(height: 1),
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
                              borderSide: BorderSide(color: Colors.blue.shade200, width: 2.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide(color: Colors.blue, width: 2.0),
                            ),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
                          ),
                          style: const TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 10),
                        TextField(
                          controller: passwordTextEditingController,
                          obscureText: !_isPasswordVisible,
                          decoration: InputDecoration(
                            labelText: "Password",
                            labelStyle: TextStyle(
                              color: Colors.grey.shade400,
                              fontSize: 14,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide(color: Colors.blue.shade200, width: 2.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide(color: Colors.blue, width: 2.0),
                            ),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                              ),
                              onPressed: () {
                                setState(() {
                                  _isPasswordVisible = !_isPasswordVisible;
                                });
                              },
                            ),
                          ),
                          style: const TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 10),
                        _isLocked
                            ? Text(
                          "Too many attempts. Try again in $_remainingSeconds seconds.",
                          style: TextStyle(color: Colors.red),
                        )
                            : ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.black87,
                            backgroundColor: Colors.lightBlueAccent,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            minimumSize: const Size(double.infinity, 50),
                          ),
                          onPressed: () async {
                            if (!emailTextEditingController.text.contains("@")) {
                              displayToastMessage("Email Address Is not Valid", context);
                            } else if (passwordTextEditingController.text.isEmpty) {
                              displayToastMessage("Password cannot be empty", context);
                            } else {
                              await loginAndAuthenticationUser(context);
                            }
                          },
                          child: const Text(
                            "Login",
                            style: TextStyle(fontSize: 18, fontFamily: "Brand-Bold"),
                          ),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder:(context) => ForgotPasswordScreen()));
                    },
                    child: const Text(
                      "Forgot Password?",
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                  const SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Don't have An Account?",
                        style: TextStyle(color: Colors.grey, fontSize: 15),
                      ),
                      const SizedBox(width: 5),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamedAndRemoveUntil(
                            context, SignupScreen.idScreen, (route) => false,
                          );
                        },
                        child: const Text(
                          "Register",
                          style: TextStyle(fontSize: 15, color: Colors.lightBlue),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> loginAndAuthenticationUser(BuildContext context) async {
    if (_isLocked) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return ProgressDialog(message: "Authenticating, please wait...");
      },
    );

    var connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult == ConnectivityResult.none) {
      // Offline login logic
      await loginOffline(context);
    } else {
      // Online login logic
      await loginOnline(context);
    }

    //Navigator.pop(context);  // Close the progress dialog
  }

  Future<void> loginOnline(BuildContext context) async {
    try {
      final UserCredential userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: emailTextEditingController.text.trim(),
        password: passwordTextEditingController.text.trim(),
      );

      final User? user = userCredential.user;

      if (user != null) {
        // Save user credentials for offline login
        final prefs = await SharedPreferences.getInstance();
        prefs.setString('email', emailTextEditingController.text.trim());
        prefs.setString('password', passwordTextEditingController.text.trim());

        final snapshot = await useRref.child(user.uid).once();

        if (snapshot.snapshot.value != null) {
          Navigator.pushNamedAndRemoveUntil(
            context, MainScreen.idScreen, (route) => false,
          );
          displayToastMessage("You are logged in", context);
        } else {
          await _firebaseAuth.signOut();
          displayToastMessage("No record exists for this account. Please create a new Account", context);
        }
      } else {
        displayToastMessage("Error Occurred", context);
      }
    } catch (error) {
      _loginAttempts++;
      if (_loginAttempts >= 5) {
        startCountdown();
      }
      displayToastMessage("Error: Incorrect email or password. Please try again.", context);
    }
  }

  Future<void> loginOffline(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final savedEmail = prefs.getString('email');
    final savedPassword = prefs.getString('password');

    if (savedEmail == emailTextEditingController.text.trim() &&
        savedPassword == passwordTextEditingController.text.trim        ) {
      Navigator.pushNamedAndRemoveUntil(
        context, MainScreen.idScreen, (route) => false,
      );
      displayToastMessage("You are logged in offline", context);
    } else {
      _loginAttempts++;
      if (_loginAttempts >= 5) {
        startCountdown();
      }
      displayToastMessage("Incorrect email or password", context);
    }
  }
}

void displayToastMessaged(String message, BuildContext context) {
  Fluttertoast.showToast(
    msg: message,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
    backgroundColor: Colors.black,
    textColor: Colors.white,
    fontSize: 16.0,
  );
}

