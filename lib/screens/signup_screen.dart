import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:users/main.dart';
import 'package:users/screens/login_screen.dart';
import 'package:users/screens/main_screen.dart';
import 'package:users/widgets/progess_dialog.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

class SignupScreen extends StatefulWidget {
  static const String idScreen = "register";

  const SignupScreen({Key? key}) : super(key: key);

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  TextEditingController nameTextEditingController = TextEditingController();
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController phoneTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();
  TextEditingController frontImageController = TextEditingController();
  TextEditingController backImageController = TextEditingController();
  String? frontImagePath;
  String? backImagePath;

  final FirebaseStorage _storage = FirebaseStorage.instance;


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              const Image(
                image: AssetImage("images/logistic.jpg"),
                width: 350,
                height: 350,
                alignment: Alignment.center,
              ),
              const SizedBox(
                height: 15,
              ),
              const Text(
                "Register as a user",
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
                    SizedBox(height: 10),
                    TextField(
                      controller: nameTextEditingController,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        labelText: "Name",
                        labelStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 10),
                    TextField(
                      controller: emailTextEditingController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: "Email",
                        labelStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 10),
                    IntlPhoneField(
                      initialCountryCode: "ET",
                      controller: phoneTextEditingController,
                      showCountryFlag: true,
                      dropdownIcon: Icon(
                        Icons.arrow_drop_down_circle_rounded,
                        color: Colors.black,
                      ),
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        labelText: "Phone Number",
                        labelStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 10),
                    TextField(
                      controller: passwordTextEditingController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: "Password",
                        labelStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 10),
                    TextField(
                      readOnly: true,
                      controller: frontImageController,
                      decoration: InputDecoration(
                        labelText: "Front ID Image",
                        labelStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        suffixIcon: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.camera_alt),
                              onPressed: _pickFrontImageCamera,
                            ),
                            IconButton(
                              icon: Icon(Icons.folder),
                              onPressed: _pickFrontImageGallery,
                            ),
                          ],
                        ),
                      ),
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 10),
                    TextField(
                      readOnly: true,
                      controller: backImageController,
                      decoration: InputDecoration(
                        labelText: "Back ID Image",
                        labelStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        suffixIcon: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.camera_alt),
                              onPressed: _pickBackImageCamera,
                            ),
                            IconButton(
                              icon: Icon(Icons.folder),
                              onPressed: _pickBackImageGallery,
                            ),
                          ],
                        ),
                      ),
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.black87,
                        backgroundColor: Colors.lightBlueAccent,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        minimumSize: Size(double.infinity, 50),
                      ),
                      onPressed: () async {
                        if (nameTextEditingController.text.length < 4) {
                          displayToastMessage(
                              "Name should be at least 4 characters", context);
                        } else if (!emailTextEditingController.text
                            .contains("@")) {
                          displayToastMessage(
                              "Email address is not valid", context);
                        } else if (phoneTextEditingController.text.isEmpty) {
                          displayToastMessage(
                              "Phone number is mandatory", context);
                        } else if (passwordTextEditingController.text.length <
                            7) {
                          displayToastMessage(
                              "Password must be at least 6 characters",
                              context);
                        } else {
                          registerNewUser(context);
                        }
                      },
                      child: Text(
                        "Sign Up",
                        style: TextStyle(
                          fontSize: 18,
                          fontFamily: "Signatra",
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  // Navigator.push(context, MaterialPageRoute(builder:(contex) => const ForgotPasswordScreen()));
                },
                child: const Text(
                  "Forgot Password?",
                  style: TextStyle(color: Colors.blue),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    " have An Account?",
                    style: TextStyle(color: Colors.grey, fontSize: 15),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamedAndRemoveUntil(
                          context, LoginScreen.idScreen, (route) => false);
                      // Navigator.push(context, MaterialPageRoute(builder:(contex) => const SignupScreen()));
                    },
                    child: const Text(
                      "Login",
                      style: TextStyle(fontSize: 15, color: Colors.lightBlue),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  void registerNewUser(BuildContext context) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return ProgressDialog(message: "Registering, please wait");
      },
    );

    final User? user = (await _firebaseAuth
            .createUserWithEmailAndPassword(
                email: emailTextEditingController.text,
                password: passwordTextEditingController.text)
            .catchError((errmsg) {
      Navigator.pop(context);
      displayToastMessage("Error$errmsg", context);
    }))
        .user;

    if (user != null) {
      await uploadImages(user.uid);

      Map<String, dynamic> userDataMap = {
        "name": nameTextEditingController.text.trim(),
        "email": emailTextEditingController.text.trim(),
        "phone": phoneTextEditingController.text.trim(),
        "password": passwordTextEditingController.text.trim(),
        "frontImage": frontImagePath ?? "",
        "backImage": backImagePath ?? "",
      };
      // Assuming `useRref` is your Firebase database reference
      useRref.child(user.uid).set(userDataMap);
      displayToastMessage("Your Account has been created", context);
      Navigator.pushNamedAndRemoveUntil(
          context, MainScreen.idScreen, (route) => false);
    } else {
      Navigator.pop(context);
      displayToastMessage("Account has not been created", context);
    }
  }


  Future<void> uploadImages(String userId) async {
    if (frontImagePath != null) {
      await _uploadImage(userId, "front_image.jpg", frontImagePath!);
    }

    if (backImagePath != null) {
      await _uploadImage(userId, "back_image.jpg", backImagePath!);
    }
  }

  Future<void> _uploadImage(String userId, String imageName, String imagePath) async {
    try {
      File imageFile = File(imagePath);
      TaskSnapshot snapshot = await _storage.ref("users/$userId/$imageName").putFile(imageFile);
      String downloadUrl = await snapshot.ref.getDownloadURL();

      if (imageName == "front_image.jpg") {
        frontImagePath = downloadUrl;
      } else if (imageName == "back_image.jpg") {
        backImagePath = downloadUrl;
      }
    } catch (e) {
      print("Error uploading image: $e");
    }
  }


  Future<void> _pickFrontImageCamera() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        frontImagePath = pickedFile.path;
        frontImageController.text = pickedFile.path ?? '';
      });
    }
  }

  Future<void> _pickBackImageCamera() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        backImagePath = pickedFile.path;
        backImageController.text = pickedFile.path ?? '';
      });
    }
  }

  Future<void> _pickFrontImageGallery() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        frontImagePath = pickedFile.path;
        frontImageController.text = pickedFile.path ?? '';
      });
    }
  }

  Future<void> _pickBackImageGallery() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        backImagePath = pickedFile.path;
        backImageController.text = pickedFile.path ?? '';
      });
    }
  }
}

displayToastMessage(String message, BuildContext context) {
  Fluttertoast.showToast(msg: message);
}

//
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:users/main.dart';
// import 'package:users/screens/login_screen.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:users/screens/main_screen.dart';
// import 'package:intl_phone_field/intl_phone_field.dart';
// import 'package:users/screens/otp_screen.dart';
//
//
// import '../widgets/progess_dialog.dart';
//
// class SignupScreen extends StatelessWidget {
//   static const String idScreen="register";
//
//   TextEditingController nameTextEditingController=TextEditingController();
//   TextEditingController emailTextEditingController=TextEditingController();
//   TextEditingController phoneTextEditingController=TextEditingController();
//   TextEditingController passwordTextEditingController=TextEditingController();
//
//   SignupScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child:
//       Scaffold(
//         body: SingleChildScrollView(
//           child: Column(
//             children: [
//               const Image(
//                 image: AssetImage("images/logistic.jpg"),
//                 width: 350,
//                 height: 350,
//                 alignment: Alignment.center,
//               ),
//               const SizedBox(
//                 height: 15,
//               ),
//               const Text(
//                 "Register as a user",
//                 style: TextStyle(
//                   fontSize: 24,
//                   fontFamily: "Brand Bold",
//                 ),
//                 textAlign: TextAlign.center,
//               ),
//               Padding(
//                 padding: const EdgeInsets.all(20),
//                 child: Column(
//                   children: [
//                     SizedBox(height: 10),
//                     TextField(
//                       controller: nameTextEditingController,
//                       keyboardType: TextInputType.text,
//                       decoration: InputDecoration(
//                         labelText: "Name",
//                         labelStyle: TextStyle(
//                           color: Colors.grey,
//                           fontSize: 14,
//                         ),
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(10),
//                         ),
//                       ),
//                       style: TextStyle(fontSize: 16),
//                     ),
//                     SizedBox(height: 10),
//                     TextField(
//                       controller: emailTextEditingController,
//                       keyboardType: TextInputType.emailAddress,
//                       decoration: InputDecoration(
//                         labelText: "Email",
//                         labelStyle: TextStyle(
//                           color: Colors.grey,
//                           fontSize: 14,
//                         ),
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(10),
//                         ),
//                       ),
//                       style: TextStyle(fontSize: 16),
//                     ),
//                     SizedBox(height: 10),
//                     IntlPhoneField(
//                       initialCountryCode: "ET",
//                       controller: phoneTextEditingController,
//                       showCountryFlag: true,
//                       dropdownIcon: Icon(
//                         Icons.arrow_drop_down_circle_rounded,
//                         color: Colors.black,
//                       ),
//                       keyboardType: TextInputType.text,
//                       decoration: InputDecoration(
//                         labelText: "Phone Number",
//                         labelStyle: TextStyle(
//                           color: Colors.grey,
//                           fontSize: 14,
//                         ),
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(10),
//                         ),
//                       ),
//                       style: TextStyle(fontSize: 16),
//                     ),
//                     SizedBox(height: 10),
//                     TextField(
//                       controller: passwordTextEditingController,
//                       obscureText: true,
//                       decoration: InputDecoration(
//                         labelText: "Password",
//                         labelStyle: TextStyle(
//                           color: Colors.grey,
//                           fontSize: 14,
//                         ),
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(10),
//                         ),
//                       ),
//                       style: TextStyle(fontSize: 16),
//                     ),
//                     SizedBox(height: 20),
//                     ElevatedButton(
//                       style: ElevatedButton.styleFrom(
//                         foregroundColor: Colors.black87, backgroundColor: Colors.lightBlueAccent,
//                         elevation: 0,
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(10),
//                         ),
//                         minimumSize: Size(double.infinity, 50),
//                       ),
//                       onPressed: () async {
//                         if (nameTextEditingController.text.length < 4) {
//                           displayToastMessage("Name should be at least 4 characters", context);
//                         } else if (!emailTextEditingController.text.contains("@")) {
//                           displayToastMessage("Email address is not valid", context);
//                         } else if (phoneTextEditingController.text.isEmpty) {
//                           displayToastMessage("Phone number is mandatory", context);
//                         } else if (passwordTextEditingController.text.length < 7) {
//                           displayToastMessage("Password must be at least 6 characters", context);
//                         } else {
//                           registerNewUser(context);
//                         }
//                       },
//                       child: Text(
//                         "Sign Up",
//                         style: TextStyle(
//                           fontSize: 18,
//                           fontFamily: "Signatra",
//                         ),
//                       ),
//                     )
//                   ],
//                 ),
//               ),
//               GestureDetector(
//                 onTap: (){
//                   // Navigator.push(context, MaterialPageRoute(builder:(contex) => const ForgotPasswordScreen()));
//
//
//                 },
//                 child: const Text("Forgot Password?",style: TextStyle(
//                     color:  Colors.blue
//                 ),),
//               ),
//               const SizedBox(height: 30,),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//
//                 children: [
//                   const Text(" have An Account?",style: TextStyle(
//                       color: Colors.grey,
//                       fontSize: 15
//                   ),),
//                   const SizedBox(width: 5,),
//                   GestureDetector(
//                     onTap: () {
//                       Navigator.pushNamedAndRemoveUntil(context, LoginScreen.idScreen, (route) => false);
//                       // Navigator.push(context, MaterialPageRoute(builder:(contex) => const SignupScreen()));
//
//
//                     },
//                     child: const Text("Login",style: TextStyle(
//                         fontSize: 15,
//                         color:  Colors.lightBlue
//                     ),),
//
//                   )
//                 ],
//               )
//
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// final FirebaseAuth _firebaseAuth=FirebaseAuth.instance;
//   void registerNewUser(BuildContext context) async{
//
//     showDialog(context: context,
//         barrierDismissible: false,
//         builder: (BuildContext context)
//         {
//           return ProgressDialog(message: "Registering, please wait",);
//         }
//     );
//
//     final User? user=(await _firebaseAuth.createUserWithEmailAndPassword(email: emailTextEditingController.text,
//         password: passwordTextEditingController.text).catchError((errmsg){
//           Navigator.pop(context);
//           displayToastMessage("Error$errmsg", context);
//
//     })).user;
//
//     if(user != null)
//       {
//         Map userDataMap = {
//           "name":nameTextEditingController.text.trim(),
//           "email":emailTextEditingController.text.trim(),
//           "phone":phoneTextEditingController.text.trim(),
//           "password":passwordTextEditingController.text.trim()
//
//         };
//         useRref.child(user.uid).set(userDataMap);
//         displayToastMessage("Your Account has been created", context);
// Navigator.pushNamedAndRemoveUntil(context, MainScreen.idScreen, (route) => false);
//       }
//     else{
//       Navigator.pop(context);
//       displayToastMessage("Account has not been created", context);
//
//     }
//
//
//   }
//  }
//
//  displayToastMessage(String message,BuildContext context)
//  {
//    Fluttertoast.showToast(msg: message);
//  }
//
//
//
//
//
