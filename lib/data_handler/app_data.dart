import 'package:flutter/cupertino.dart';
import 'package:users/models/address.dart';

class AppData extends ChangeNotifier {
  Address? pickUpLocation,DropOffLocation;
  //Address? DropOffLocation;


  void updatePickUpLocationAddress(Address pickUpAddress)
  {
    pickUpLocation=pickUpAddress;
    notifyListeners();
  }
  void updateDropOffLocationAddress(Address dropOffAddress)
  {
    DropOffLocation=dropOffAddress;
    notifyListeners();
  }


}