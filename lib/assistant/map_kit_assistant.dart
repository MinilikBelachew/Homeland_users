import 'package:maps_toolkit/maps_toolkit.dart' ;

class MapKitAssistant
{
  static double getMarkerRotation(sLat, sLng, dLat, dLng) {
    var rot = SphericalUtil.computeHeading(LatLng(sLat, sLng), LatLng(dLat, dLng)) as double;
    return rot;
  }

}
// import 'package:google_maps_flutter/google_maps_flutter.dart' as google_maps;
// import 'package:maps_toolkit/maps_toolkit.dart' as maps_toolkit;
//
// class MapKitAssistant {
//   static double getMarkerRotation(double sLat, double sLng, double dLat, double dLng) {
//     var googleMapsLatLng = google_maps.LatLng(sLat, sLng);
//     var mapsToolkitLatLng = maps_toolkit.LatLng(dLat, dLng);
//
//     var rot = maps_toolkit.SphericalUtil.computeHeading(_convertToMapsToolkitLatLng(googleMapsLatLng), mapsToolkitLatLng);
//     return rot.toDouble(); // Convert num to double explicitly
//   }
//
//   static maps_toolkit.LatLng _convertToMapsToolkitLatLng(google_maps.LatLng googleMapsLatLng) {
//     return maps_toolkit.LatLng(googleMapsLatLng.latitude, googleMapsLatLng.longitude);
//   }
// }


