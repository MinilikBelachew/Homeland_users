import '../models/nearby_available_driver.dart';

class GeoFireAssistant
{
  static List<NearbyAvailabelDrivers> nearByAvailableDriversList=[];
  static void removeDriverFromList(String key)
  {
    int index =nearByAvailableDriversList.indexWhere((element) => element.key == key);
    nearByAvailableDriversList.removeAt(index);
  }
  static void updatDriverMearbyLocation(NearbyAvailabelDrivers drivers){
    int index =nearByAvailableDriversList.indexWhere((element) => element.key == drivers.key);
    nearByAvailableDriversList[index].latitude=drivers.latitude;
    nearByAvailableDriversList[index].longitude=drivers.longitude;
  }
}