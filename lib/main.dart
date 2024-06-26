import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:users/data_handler/app_data.dart';
import 'package:users/screens/login_screen.dart';
import 'package:users/screens/main_screen.dart';
import 'package:users/screens/otp_screen.dart';
import 'package:users/screens/signup_screen.dart';
import "package:firebase_auth/firebase_auth.dart";
import 'package:flutter/foundation.dart';

import 'package:chapa_unofficial/chapa_unofficial.dart';

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyBJ0H1IflNFaMKt7Pnfu4uatPPQ4XvVnrA",
          appId: "1:771185889083:android:9f667313b7cf6bab12b11e",
          messagingSenderId: "771185889083",
          projectId: "homeland-95f19",
          databaseURL:"https://homeland-95f19-default-rtdb.firebaseio.com/",
         storageBucket: "homeland-95f19.appspot.com"

      )
  );
  Chapa.configure(privateKey: "CHASECK_TEST-xMHE3ZOi6SWCWdERIqabPLsRYwCTs9da");
  runApp(const MyApp());
}

DatabaseReference useRref=FirebaseDatabase.instance.ref().child("users");
DatabaseReference driverRref=FirebaseDatabase.instance.ref().child("drivers");


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) =>AppData(),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(

          colorScheme: ColorScheme.fromSeed(seedColor: Colors.black),
          primaryColor: Colors.blue,
          useMaterial3: true,
        ),
          //initialRoute: LoginScreen.idScreen,

          //initialRoute: FirebaseAuth.instance.currentUser == null ? LoginScreen.idScreen:LoginScreen.idScreen,
          initialRoute: LoginScreen.idScreen,
          routes: {
            LoginScreen.idScreen: (context) => const LoginScreen(),
            SignupScreen.idScreen: (context) => const SignupScreen(),
            MainScreen.idScreen: (context) => const MainScreen(),

          },

        debugShowCheckedModeBanner: false

      ),
    );
  }
}




