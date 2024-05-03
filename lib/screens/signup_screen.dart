import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:users/main.dart';
import 'package:users/screens/login_screen.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:users/screens/main_screen.dart';

import '../widgets/progess_dialog.dart';

class SignupScreen extends StatelessWidget {
  static const String idScreen="register";

  TextEditingController nameTextEditingController=TextEditingController();
  TextEditingController emailTextEditingController=TextEditingController();
  TextEditingController phoneTextEditingController=TextEditingController();
  TextEditingController passwordTextEditingController=TextEditingController();

  SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child:
      Scaffold(
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
                "Register in As A user",
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
                    const SizedBox(
                      height: 1,
                    ),
                    TextField(
                      controller: nameTextEditingController,
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(
                          labelText: "Name",
                          labelStyle: TextStyle(
                            color: Colors.grey,
                            fontSize: 10,
                          )),
                      style: const TextStyle(fontSize: 14),
                    ),
                    TextField(
                      controller: emailTextEditingController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                          labelText: "Email",
                          labelStyle: TextStyle(
                            color: Colors.grey,
                            fontSize: 10,
                          )),
                      style: const TextStyle(fontSize: 14),
                    ),
                    const SizedBox(
                      height: 1,
                    ),
                    TextField(
                      controller: phoneTextEditingController,
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(
                          labelText: "Phone Number",
                          labelStyle: TextStyle(
                            color: Colors.grey,
                            fontSize: 10,
                          )),
                      style: const TextStyle(fontSize: 14),
                    ),
                    const SizedBox(
                      height: 1,
                    ),
                    TextField(
                      controller: passwordTextEditingController,
                      obscureText: true,
                      decoration: const InputDecoration(
                          labelText: "Password",
                          labelStyle: TextStyle(
                            color: Colors.grey,
                            fontSize: 10,
                          )),
                      style: const TextStyle(fontSize: 14),
                    ),
                    const SizedBox(height: 10,),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            foregroundColor:  Colors.black87 , backgroundColor:
                        Colors.lightBlueAccent,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            minimumSize: const Size(double.infinity, 50)),

                        onPressed: () {
                          if(nameTextEditingController.text.length < 4) {
                       displayToastMessage("Name should be at least 4 character", context);
                          }
                          else if(!emailTextEditingController.text.contains("@")) {
                            displayToastMessage("email address is not valid", context);


                          }
                          else if(phoneTextEditingController.text.isEmpty)
                            {
                              displayToastMessage("Phone number is Manadatory", context);
                            }
                          else if(passwordTextEditingController.text.length < 7)
                            {
                              displayToastMessage("password must be at least 6 characters.", context);
                            }
                          else {
                            registerNewUser(context);
                          }



                        },
                        child: const Text(
                          "Signup",
                          style: TextStyle(
                              fontSize: 18,
                              fontFamily: "Signatra"
                          ),
                        ))
                  ],
                ),
              ),
              GestureDetector(
                onTap: (){
                  // Navigator.push(context, MaterialPageRoute(builder:(contex) => const ForgotPasswordScreen()));


                },
                child: const Text("Forgot Password?",style: TextStyle(
                    color:  Colors.blue
                ),),
              ),
              const SizedBox(height: 30,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,

                children: [
                  const Text(" have An Account?",style: TextStyle(
                      color: Colors.grey,
                      fontSize: 15
                  ),),
                  const SizedBox(width: 5,),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamedAndRemoveUntil(context, LoginScreen.idScreen, (route) => false);
                      // Navigator.push(context, MaterialPageRoute(builder:(contex) => const SignupScreen()));


                    },
                    child: const Text("Login",style: TextStyle(
                        fontSize: 15,
                        color:  Colors.lightBlue
                    ),),

                  )
                ],
              )

            ],
          ),
        ),
      ),
    );
  }
final FirebaseAuth _firebaseAuth=FirebaseAuth.instance;
  void registerNewUser(BuildContext context) async{

    showDialog(context: context,
        barrierDismissible: false,
        builder: (BuildContext context)
        {
          return ProgressDialog(message: "Registering, please wait",);
        }
    );

    final User? user=(await _firebaseAuth.createUserWithEmailAndPassword(email: emailTextEditingController.text,
        password: passwordTextEditingController.text).catchError((errmsg){
          Navigator.pop(context);
          displayToastMessage("Error$errmsg", context);

    })).user;

    if(user != null)
      {
        Map userDataMap = {
          "name":nameTextEditingController.text.trim(),
          "email":emailTextEditingController.text.trim(),
          "phone":phoneTextEditingController.text.trim(),
          "password":passwordTextEditingController.text.trim()

        };
        useRref.child(user.uid).set(userDataMap);
        displayToastMessage("Your Account has been created", context);
Navigator.pushNamedAndRemoveUntil(context, MainScreen.idScreen, (route) => false);
      }
    else{
      Navigator.pop(context);
      displayToastMessage("Account has not been created", context);

    }


  }
 }

 displayToastMessage(String message,BuildContext context)
 {
   Fluttertoast.showToast(msg: message);
 }
