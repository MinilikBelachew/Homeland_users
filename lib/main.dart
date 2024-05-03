import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:users/data_handler/app_data.dart';
import 'package:users/screens/login_screen.dart';
import 'package:users/screens/main_screen.dart';
import 'package:users/screens/signup_screen.dart';
import "package:firebase_auth/firebase_auth.dart";

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyBJ0H1IflNFaMKt7Pnfu4uatPPQ4XvVnrA",
          appId: "1:771185889083:android:9f667313b7cf6bab12b11e",
          messagingSenderId: "771185889083",
          projectId: "homeland-95f19",
          databaseURL:"https://homeland-95f19-default-rtdb.firebaseio.com/"
      )
  );
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
          useMaterial3: true,
        ),
        initialRoute: FirebaseAuth.instance.currentUser == null ? LoginScreen.idScreen:LoginScreen.idScreen,
        routes: {
         SignupScreen.idScreen:(context) => SignupScreen(),
          LoginScreen.idScreen:(context) => LoginScreen(),
          MainScreen.idScreen:(context)=> const MainScreen()
        },

        debugShowCheckedModeBanner: false

      ),
    );
  }
}


