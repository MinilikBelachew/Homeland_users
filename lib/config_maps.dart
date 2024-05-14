import 'package:firebase_auth/firebase_auth.dart';

import 'models/all_user.dart';

String mapkey="";

User? firebaseUser;
Users? userCurrentInf;
String statusRide="";
String carDetailsDriver="";
String driverName="";
String rideStatus="driver is Comming";
String driverPhone="";
double startCounter=0;
String title="";
String carRideType="";




int driverRequestTimeOut=30;
String serverKey="key=AAAAs45Czzs:APA91bH8Ukpsaq0GBrcxYLaG_-h1IynTnLfvCyUmyHoQkpNZYQTr4I5Rv5GQrJ86x1o2z__NRHRHz7tKYNtapfbgy2tnnwuFh8N5C728_jn9rdeQAiGxNr4OJBPCwyiSdoM9Wj4uJK-Q";
