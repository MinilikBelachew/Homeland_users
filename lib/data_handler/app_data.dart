import 'package:flutter/cupertino.dart';
import 'package:users/models/address.dart';

import '../models/package_detail.dart';

class AppData extends ChangeNotifier {
  Address? pickUpLocation,DropOffLocation;
  PackageDetails? packageDetails,description;
  bool isEnglishSelected = true;

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

  void cargo(PackageDetails notgood)
  {
    packageDetails=notgood;
    notifyListeners();
  }

  void Cargodescription(PackageDetails notgood)
  {
    description=notgood;
    notifyListeners();
  }


  void toggleLanguage(bool value) {
    isEnglishSelected = value;
    notifyListeners();
  }




}