import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:users/assistant/assistant_methods.dart';
import 'package:users/assistant/geofire_asistant.dart';
import 'package:users/assistant/map_kit_assistant.dart';
import 'package:users/config_maps.dart';
import 'package:users/data_handler/app_data.dart';
import 'package:users/main.dart';
import 'package:users/models/direction_detail.dart';
import 'package:users/models/nearby_available_driver.dart';
import 'package:users/screens/about_page.dart';
import 'package:users/screens/login_screen.dart';
import 'package:users/screens/package_detail_form.dart';
import 'package:users/screens/pickup_search_screen.dart';
import 'package:users/screens/profile_Screen.dart';
import 'package:users/screens/rating_screen.dart';
import 'package:users/screens/search_screen.dart';
import 'package:users/screens/setting.dart';
import 'package:users/screens/signup_screen.dart';
import 'package:users/widgets/divider.dart';
import 'package:users/widgets/nodriver_available_dialog.dart';
import 'package:users/widgets/progess_dialog.dart';
import "package:firebase_auth/firebase_auth.dart";

import '../models/package_detail.dart';
import '../widgets/collect_Birr_dialog.dart';

class MainScreen extends StatefulWidget {
  static const String idScreen = "mainscreen";

  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with TickerProviderStateMixin {
  GlobalKey<ScaffoldState> scaffoldkey = GlobalKey<ScaffoldState>();

  DirectioDetail? directioDetail;

  List<LatLng> pLineCoordinates = [];
  Set<Polyline> polylineSet = {};

  LocationPermission? _locationPermission;
  late Position currentPosition;
  var geoLocator = Geolocator();
  double bottomPaddingOfMap = 0;



  Set<Marker> markerSet = Set<Marker>();
  Set<Circle> circleSet = Set<Circle>();

  Set<Marker> markersSet = {};
  double serachContainerHeight = 300;
  double requestRideContainerHeight = 0;
  double rideDetailsContainerHeight = 0;
  bool nearbyAvailableDriversKeysLoaded = false;

  Set<Circle> circlesSet = {};

  DatabaseReference? rideRequestRef;

  BitmapDescriptor? nearByIcon;
  BitmapDescriptor? animatingMarkerIcon;
  late GoogleMapController newRideGoogleMapController;
  double? driverLat;
  double? driverLng;

  List<NearbyAvailabelDrivers>? availableDrivers;
  String state = "normal";
  double driverDetailsContainerHeight = 0;
  StreamSubscription<DatabaseEvent>? rideStreamSubscription;
  StreamSubscription<Position>? rideStreamSubscriptiondriver;


  bool? isRequestingPositionDetails = false;

  void displayRideDetailsContainer() async {
    await getPlaceDirection();
    setState(() {
      serachContainerHeight = 0;
      rideDetailsContainerHeight = 400;
      bottomPaddingOfMap = 440;
    });
  }

  void displayRequestRideContainer() {
    setState(() {
      requestRideContainerHeight = 250;
      rideDetailsContainerHeight = 0;
      bottomPaddingOfMap = 230;
    });
    savedRideRequest();
  }

  void displaydriverDetailsContainerHeight() {
    setState(() {
      requestRideContainerHeight = 0;
      rideDetailsContainerHeight = 0;
      bottomPaddingOfMap = 300;
      driverDetailsContainerHeight = 320;
    });
  }

  String uName = '';

  void locateCurrentPosition() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    currentPosition = position;
    LatLng latLngPosition = LatLng(position.latitude, position.longitude);

    CameraPosition cameraPosition =
        CameraPosition(target: latLngPosition, zoom: 14);

    newGoogleMapController
        .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));

    String address =
        await AssistantMethods.searchCoordinateAddress(position, context);

    initGeoFireListner();
    uName = userCurrentInf!.name!;

  }

  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  late GoogleMapController newGoogleMapController;

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  checKLocationPermission() async {
    _locationPermission = await Geolocator.requestPermission();
    if (_locationPermission == LocationPermission.denied) {
      _locationPermission = await Geolocator.requestPermission();
    }
  }

  void cancelRideRequest() {
    rideRequestRef!.remove();
    setState(() {
      state = "normal";
    });
  }

  resetApp() {
    setState(() {
      serachContainerHeight = 300;
      rideDetailsContainerHeight = 0;
      requestRideContainerHeight = 0;
      bottomPaddingOfMap = 230;

      polylineSet.clear();
      markersSet.clear();
      circlesSet.clear();
      pLineCoordinates.clear();
      statusRide = "";
      driverName = "";
      driverPhone = "";
      carDetailsDriver = "";
      driverDetailsContainerHeight = 0;
    });
    locateCurrentPosition();
  }

  @override
  void initState() {
    super.initState();
    checKLocationPermission();
    AssistantMethods.getCurrentOnlineUserInfo();
  }

  void savedRideRequest() {
    rideRequestRef =
        FirebaseDatabase.instance.ref().child("Ride Request").push();
    PackageDetails? packageDetails =
        Provider.of<AppData>(context, listen: false).packageDetails;

    var pickUp = Provider.of<AppData>(context, listen: false).pickUpLocation;
    var dropoff = Provider.of<AppData>(context, listen: false).DropOffLocation;

    Map pickUpLocMap = {
      "latitude": pickUp!.latitude.toString(),
      "longitude": pickUp.longitude.toString()
    };
    Map dropOffLocMap = {
      "latitude": dropoff!.latitude.toString(),
      "longitude": dropoff.longitude.toString()
    };
  Map riderInfoMap = {
    "driver_id": "waiting",
    "payment_method": "cash",
    "pickup": pickUpLocMap,
    "dropoff": dropOffLocMap,
    "created_at": DateTime.now().toString(),
    "rider_name": userCurrentInf?.name,
    "rider_phone": userCurrentInf?.phone,
    "pickup_address": pickUp.placeName,
    "dropoff_address": dropoff.placeName,
    "weight": packageDetails!.weight, // Assuming packageDetails is available
    "package_description": packageDetails!.contentDescription,
  };
    rideRequestRef!.set(riderInfoMap);
    // rideStreamSubscription = rideRequestRef!.onValue.listen((event) {
    //   if (event.snapshot.value == null) {
    //     return;
    //   }
    //
    //   // Check if the value is a Map before accessing elements
    //   if (event.snapshot.value is Map) {
    //     final Map<String, dynamic> data = event.snapshot.value as Map<String, dynamic>;
    //     final status = data["status"]?.toString();
    //
    //     if (status == "accepted") {
    //       displaydriverDetailsContainerHeight();
    //     }
    //   } else {
    //     // Handle the case where the value is not a Map (optional)
    //     print("Unexpected data type in ride request snapshot");
    //   }
    // });

    rideStreamSubscription = rideRequestRef!.onValue.listen((event) async {
      if (event.snapshot.value == null || !(event.snapshot.value is Map)) {
        return;
      }

      var snapshotValue = event.snapshot.value as Map<Object?, Object?>;

      if (snapshotValue.containsKey("car_details") &&
          snapshotValue["car_details"] is String) {
        setState(() {
          carDetailsDriver = snapshotValue["car_details"]!.toString();
        });
      }

      if (snapshotValue.containsKey("driver_name") &&
          snapshotValue["driver_name"] is String) {
        setState(() {
          driverName = snapshotValue["driver_name"]!.toString();
        });
      }

      if (snapshotValue.containsKey("driver_phone") &&
          snapshotValue["driver_phone"] is String) {
        setState(() {
          driverPhone = snapshotValue["driver_phone"]!.toString();
        });
      }
      if (snapshotValue.containsKey("driver_location") &&
          snapshotValue["driver_location"] is Map) {
        var driverLocation = snapshotValue["driver_location"];

        if (driverLocation != null && driverLocation is Map) {
          var driverLocationMap = driverLocation.cast<String, dynamic>();

          if (driverLocationMap.containsKey("latitude") &&
              driverLocationMap.containsKey("longitude")) {
            driverLat = double.tryParse(driverLocation["latitude"].toString());
            driverLng = double.tryParse(driverLocation["longitude"].toString());
            // double? driverLat =
            //     double.tryParse(driverLocationMap["latitude"].toString());
            // double? driverLng =
            //     double.tryParse(driverLocationMap["longitude"].toString());

            if (driverLat != null && driverLng != null) {
              LatLng driverCurrentLocation = LatLng(driverLat!, driverLng!);
              // Now you can use driverCurrentLocation

              // if (snapshotValue.containsKey("driver_location") &&
              //     snapshotValue["driver_location"] is Map) {
              //   var driverLocation =
              //       snapshotValue["driver_location"] as Map<String, dynamic>;
              //
              //   if (driverLocation.containsKey("latitude") &&
              //       driverLocation.containsKey("longitude")) {
              //     double driverLat =
              //         double.parse(driverLocation["latitude"].toString());
              //     double driverLng =
              //         double.parse(driverLocation["longitude"].toString());
              //
              //     LatLng driverCurrentLocation = LatLng(driverLat, driverLng);

              if (statusRide == "accepted") {


                getLiveLocationUpdates(driverLat!, driverLng!);


                updateRideTimeToPickUpLoc(driverCurrentLocation);
              } else if (statusRide == "onride") {
                updateRideTimeDropOffLoc(driverCurrentLocation);
              } else if (statusRide == "arrived") {
                rideStatus = "Driver Has Arrived";
              }

              // Do something with driverCurrentLocation if needed.
            }
          }

          if (snapshotValue.containsKey("status") &&
              snapshotValue["status"] is String) {
            statusRide = snapshotValue["status"]!.toString();
          }

          if (statusRide == "accepted") {
            displaydriverDetailsContainerHeight();
            Geofire.stopListener();
            deleteGeofileMarkers();
          }

          if (statusRide == "ended") {
            if (snapshotValue["fares"] != null) {
              int fare = int.parse(snapshotValue["fares"].toString());

              var res = await showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (BuildContext context) => CollectBirrDialog(
                      paymentMethod: "cash", fareAmount: fare));

              String driverId = "";

              if (res == "close") {
                if (snapshotValue["driver_id"] != null) {
                  driverId = snapshotValue["driver_id"].toString();
                }

                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => RatingScreen(driverId: driverId)));

                rideRequestRef!.onDisconnect();
                rideRequestRef = null;
                rideStreamSubscription!.cancel();
                rideStreamSubscription = null;
                resetApp();
              }
            }

            //   if(snapshotValue[])
          }
        }
      }
    });
  }

  void deleteGeofileMarkers() {
    setState(() {
      markersSet
          .removeWhere((element) => element.markerId.value.contains("driver"));
    });
  }

  void updateRideTimeToPickUpLoc(LatLng driverCurrentLocation) async {
    if (isRequestingPositionDetails == false) {
      isRequestingPositionDetails = true;

      var positionUserLatLng =
          LatLng(currentPosition.latitude, currentPosition.longitude);
      var details = await AssistantMethods.obtainPlaceDirectionsDetails(
          driverCurrentLocation, positionUserLatLng);

      if (details == null) {
        return;
      }
      setState(() {
        rideStatus = "Driver is Coming-${details.durationText}";
      });

      isRequestingPositionDetails = false;
    }
  }

  void updateRideTimeDropOffLoc(LatLng driverCurrentLocation) async {
    if (isRequestingPositionDetails == false) {
      isRequestingPositionDetails = true;

      var dropOff =
          Provider.of<AppData>(context, listen: false).DropOffLocation;
      var dropOffUserLatLng = LatLng(dropOff!.latitude!, dropOff!.longitude!);

      var details = await AssistantMethods.obtainPlaceDirectionsDetails(
          driverCurrentLocation, dropOffUserLatLng);

      if (details == null) {
        return;
      }
      setState(() {
        rideStatus = "Going to Destination-${details.durationText}";
      });

      isRequestingPositionDetails = false;
    }
  }


  createIconMarkerLocationTracking() {
    if (animatingMarkerIcon == null) {
      ImageConfiguration imageConfiguration =
      createLocalImageConfiguration(context, size: Size(2, 2));
      BitmapDescriptor.fromAssetImage(imageConfiguration, "images/taxi.png")
          .then((value) {
        animatingMarkerIcon = value;
      });
    }
  }

  void getLiveLocationUpdates(double driverLat, double driverLng) {
    LatLng oldPos = LatLng(driverLat, driverLng); // Initialize with driver's initial position

    rideStreamSubscriptiondriver = Geolocator.getPositionStream().listen((Position position) {
      // Update the old position with the new position of the driver
      LatLng driverCurrentLocation = LatLng(driverLat, driverLng);

      var rot = MapKitAssistant.getMarkerRotation(oldPos.latitude,
          oldPos.longitude, driverCurrentLocation.latitude, driverCurrentLocation.longitude);

      Marker animatingMarker = Marker(
          markerId: MarkerId("animating"),
          position: driverCurrentLocation,
        // icon: animatingMarkerIcon!,
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),

          rotation: rot,
          infoWindow: InfoWindow(title: "CurrentLocation"));

      setState(() {
        CameraPosition cameraPosition =
        new CameraPosition(target: driverCurrentLocation, zoom: 17);
        newRideGoogleMapController
            .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));

        markerSet.removeWhere((marker) => marker.markerId.value == "animating");

        markerSet.add(animatingMarker);
      });
      oldPos = driverCurrentLocation; // Update old position with the driver's current location


      Map locMap = {
        "latitude": driverCurrentLocation.latitude.toString(),
        "longitude": driverCurrentLocation.longitude.toString()
      };
    });
  }







  @override
  Widget build(BuildContext context) {
    createIconMarker();
    AppData languageProvider = Provider.of<AppData>(context);
    var language = languageProvider.isEnglishSelected ;


    return Scaffold(
      key: scaffoldkey,
      appBar: AppBar(
        title:  Text(language? "Homeland":"ሀገር ቤት"),
        backgroundColor: Colors.tealAccent,
        actions: <Widget>[
          PopupMenuButton<String>(
            onSelected: (String choice) {
              // Handle menu item selection
              switch (choice) {
                case 'Settings':
                  // Handle settings option
                  break;
              }
            },
            itemBuilder: (BuildContext context) {
              return <PopupMenuEntry<String>>[
                 PopupMenuItem<String>(
                  value: 'Settings',
                  child: Column(children: [
                    GestureDetector(
                        onTap:(){
                          Navigator.push(context, MaterialPageRoute(builder: (context) =>  SettingPage()));


                        },
                        child: Text(language?"Settings":"ቅንብሮች")),



                  ],),
                ),
              ];
            },
          ),
        ],
      ),
      drawer: Container(
        color: Colors.black,
        width: 255,
        child: Drawer(
          child: ListView(
            children: [
              SizedBox(
                height: 165,

                child:
                DrawerHeader(
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    border: Border.all(color: Colors.greenAccent!),
                    borderRadius: BorderRadius.all(Radius.circular(50)), // Use BorderRadius.all
                  ),

                  child: Column(
                    children: [
                      Image.asset(
                        "images/user_icon.png",
                        height: 85,
                        width: 85,
                      ),
                      const SizedBox(
                        width: 16,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            uName,
                            style: TextStyle(
                                fontSize: 16, fontFamily: "Brand-Bold"),
                          ),
                          SizedBox(
                            height: 6,
                          ),
                          // GestureDetector(
                          //     onTap: () {
                          //       displayToastMessage(
                          //           "Under Development", context);
                          //     },
                          //     child: Text(language?"Visit Profile":"መገለጫን ጎብኝ"))
                        ],
                      )
                    ],
                  ),
                ),
              ),
              const DividerWidget(),
              const SizedBox(
                height: 12,
              ),
               ListTile(
                leading: Icon(Icons.history),
                title: Text( language?"History":"ታሪክ",
                  style: TextStyle(fontSize: 15),
                ),
              ),
              GestureDetector(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) =>  ProfilePage(userId: userCurrentInf!.id!)));


                },
                 child: ListTile(
                  leading: Icon(Icons.person_outline),
                  title: Text(language?
                    "Visit Profile":"መገለጫን ጎብኝ",
                    style: TextStyle(fontSize: 15),
                  ),
                               ),
               ),
              GestureDetector(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) =>  AboutPage()));


                },
                 child: ListTile(
                  leading: Icon(Icons.info_outline),
                  title: Text(language?
                    "About":"ስለ",
                    style: TextStyle(fontSize: 15),
                  ),
                               ),
               ),
              GestureDetector(
                onTap: () {
                  FirebaseAuth.instance.signOut();
                  Navigator.pushNamedAndRemoveUntil(
                      context, LoginScreen.idScreen, (route) => false);
                },
                child:  ListTile(
                  leading: Icon(Icons.logout),
                  title: Text(language?
                    "Logout":"ውጣ",
                    style: TextStyle(fontSize: 15, color: Colors.red),
                  ),
                ),
              ),


            ],
          ),
        ),
      ),
      body: Stack(
        children: [
          GoogleMap(
            padding: EdgeInsets.only(bottom: bottomPaddingOfMap),
            mapType: MapType.normal,
            myLocationEnabled: true,
            zoomGesturesEnabled: true,
            zoomControlsEnabled: true,
            polylines: polylineSet,
            markers: markersSet,
            circles: circlesSet,
            initialCameraPosition: _kGooglePlex,
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
              newGoogleMapController = controller;
              newRideGoogleMapController = controller;

              setState(() {
                bottomPaddingOfMap = 300;
              });
              locateCurrentPosition();


              getLiveLocationUpdates(driverLat!, driverLng!);
            },
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: AnimatedSize(
              curve: Curves.bounceIn,
              duration: const Duration(milliseconds: 200),
              child: Container(
                height: serachContainerHeight,
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(18),
                        topLeft: Radius.circular(18)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black,
                        blurRadius: 16,
                        offset: Offset(0.7, 0.7),
                      )
                    ]),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                       Text(
                        language ? "where to ?":"ወዴት",
                        style:
                            TextStyle(fontSize: 20, fontFamily: "Brand-Bold"),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      GestureDetector(
                        onTap: () async {
                          var res = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                  const PackageDetailsForm()));

                          if (res == "obtainDirection") {
                            displayRideDetailsContainer();
                          }
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(5),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black54,
                                  blurRadius: 16,
                                  offset: Offset(0.7, 0.7),
                                )
                              ]),
                          child: Padding(
                            padding: EdgeInsets.all(12.0),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.description,
                                  color: Colors.blueGrey,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(language?"freight detail":"የጭነት ዝርዝር አስገባ")
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 24,
                      ),
                      GestureDetector(
                        onTap: () async {
                          var res = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const PickupSearchScreen()));

                          if (res == "obtainDirection") {
                            displayRideDetailsContainer();
                          }
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(5),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black54,
                                  blurRadius: 16,
                                  offset: Offset(0.7, 0.7),
                                )
                              ]),
                          child: Padding(
                            padding: EdgeInsets.all(12.0),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.search,
                                  color: Colors.blueGrey,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(Provider.of<AppData>(context)
                                            .pickUpLocation !=
                                        null
                                    ? Provider.of<AppData>(context)
                                        .pickUpLocation!
                                        .placeName!
                                    : language?"Search pick up":"የመነሻ ቦታን ይፈልጉ",overflow: TextOverflow.ellipsis,)
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 24,
                      ),
                      GestureDetector(
                        onTap: () async {
                          var res = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const SearchScreen()));

                          if (res == "obtainDirection") {
                            displayRideDetailsContainer();
                          }
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(5),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black54,
                                  blurRadius: 16,
                                  offset: Offset(0.7, 0.7),
                                )
                              ]),
                          child: Padding(
                            padding: EdgeInsets.all(12.0),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.search,
                                  color: Colors.blueGrey,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(Provider.of<AppData>(context)
                                            .DropOffLocation !=
                                        null
                                    ? Provider.of<AppData>(context)
                                        .DropOffLocation!
                                        .placeName!
                                    : language?"Search destination location":"የመድረሻ ቦታን ይፈልጉ",overflow: TextOverflow.ellipsis)
                              ],
                            ),
                          ),
                        ),
                      ),

                      // Row(
                      //   children: [
                      //     const Icon(
                      //       Icons.home,
                      //       color: Colors.blueGrey,
                      //     ),
                      //     const SizedBox(
                      //       width: 12,
                      //     ),
                      //     Column(
                      //       crossAxisAlignment: CrossAxisAlignment.start,
                      //       children: [
                      //         Text(
                      //           Provider.of<AppData>(context).pickUpLocation !=
                      //                   null
                      //               ? Provider.of<AppData>(context)
                      //                   .pickUpLocation!
                      //                   .placeName!
                      //               : "Add home",
                      //         ),
                      //         const SizedBox(
                      //           height: 4,
                      //         ),
                      //         const Text(
                      //           "Your Living Address",
                      //           style: TextStyle(
                      //               color: Colors.black87, fontSize: 12),
                      //         )
                      //       ],
                      //     )
                      //   ],
                      // ),
                      // const SizedBox(
                      //   height: 10,
                      // ),
                      // const DividerWidget(),
                      // const SizedBox(
                      //   height: 10,
                      // ),
                      // const Row(
                      //   children: [
                      //     Icon(
                      //       Icons.work,
                      //       color: Colors.blueGrey,
                      //     ),
                      //     SizedBox(
                      //       width: 12,
                      //     ),
                      //     Column(
                      //       crossAxisAlignment: CrossAxisAlignment.start,
                      //       children: [
                      //         Text("Add Work"),
                      //         SizedBox(
                      //           height: 4,
                      //         ),
                      //         Text(
                      //           "Your Office Address",
                      //           style: TextStyle(
                      //               color: Colors.black54, fontSize: 12),
                      //         )
                      //       ],
                      //     )
                      //   ],
                      // ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: AnimatedSize(
                curve: Curves.bounceIn,
                duration: new Duration(milliseconds: 200),
                child: Container(
                  height: rideDetailsContainerHeight,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(16),
                        topRight: Radius.circular(16),
                      ),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black,
                            blurRadius: 16,
                            spreadRadius: 0.5,
                            offset: Offset(0.7, 0.7))
                      ]),
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Column(
                      children: [
                        Container(
                          width: double.infinity,
                          color: Colors.tealAccent,
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            child: Row(
                              children: [
                                Image.asset(
                                  "images/taxi.png",
                                  height: 70,
                                  width: 80,
                                ),
                                SizedBox(
                                  width: 16,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Car",
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontFamily: "Brand-Bold"),
                                    ),
                                    Text(
                                      ((directioDetail != null)
                                          ? directioDetail!.distanceText!
                                          : ' '),
                                      style: TextStyle(
                                          fontSize: 16, color: Colors.grey),
                                    )
                                  ],
                                ),
                                Expanded(child: Container()),
                                Text(
                                  ((directioDetail != null)
                                      ? '\$${AssistantMethods.caculatePrice(directioDetail!)}'
                                      : ""),
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey,
                                      fontFamily: "Brand-Bold"),
                                )
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: Row(
                            children: [
                              Icon(
                                FontAwesomeIcons.moneyCheckAlt,
                                size: 18,
                                color: Colors.black,
                              ),
                              SizedBox(
                                width: 16,
                              ),
                              Text("CASH"),
                              SizedBox(
                                width: 6,
                              ),
                              Icon(
                                Icons.keyboard_arrow_down,
                                color: Colors.black54,
                                size: 16,
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: ElevatedButton(
                            onPressed: () {
                              displayRequestRideContainer();
                                                   availableDrivers =
                                                       GeoFireAssistant.nearByAvailableDriversList;
                                                   searchNearestDaiver();
                            },
                            child: Padding(
                              padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Request",
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  Icon(
                                    FontAwesomeIcons.truck,
                                    color: Colors.black54,
                                    size: 26,
                                  )
                                ],
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              )),

          // Positioned(
          //     bottom: 0,
          //     left: 0,
          //     right: 0,
          //     child: AnimatedSize(
          //       curve: Curves.bounceIn,
          //       duration: const Duration(milliseconds: 200),
          //       child: Container(
          //         height: rideDetailsContainerHeight,
          //         decoration: const BoxDecoration(
          //             color: Colors.white,
          //             borderRadius: BorderRadius.only(
          //               topLeft: Radius.circular(16),
          //               topRight: Radius.circular(16),
          //             ),
          //             boxShadow: [
          //               BoxShadow(
          //                   color: Colors.black,
          //                   blurRadius: 16,
          //                   spreadRadius: 0.5,
          //                   offset: Offset(0.7, 0.7))
          //             ]),
          //         child: Padding(
          //           padding: const EdgeInsets.symmetric(vertical: 16),
          //           child: Column(
          //             children: [
          //               GestureDetector(
          //                 onTap: ()
          //                 {
          //                   setState(() {
          //                     state = "requesting";
          //                     carRideType="bike";
          //
          //                   });
          //
          //                   displayRequestRideContainer();
          //                   availableDrivers =
          //                       GeoFireAssistant.nearByAvailableDriversList;
          //                   searchNearestDaiver();
          //
          //                 },
          //                 child: Container(
          //                   width: double.infinity,
          //                   color: Colors.tealAccent,
          //                   child: Padding(
          //                     padding: const EdgeInsets.symmetric(horizontal: 16),
          //                     child: Row(
          //                       children: [
          //                         Image.asset(
          //                           "images/065 bike.png",
          //                           height: 70,
          //                           width: 80,
          //                         ),
          //                         const SizedBox(
          //                           width: 16,
          //                         ),
          //                         Column(
          //                           crossAxisAlignment: CrossAxisAlignment.start,
          //                           children: [
          //                             const Text(
          //                               "Bike",
          //                               style: TextStyle(
          //                                   fontSize: 18,
          //                                   fontFamily: "Brand-Bold"),
          //                             ),
          //                             Text(
          //                               ((directioDetail != null)
          //                                   ? directioDetail!.distanceText!
          //                                   : ' '),
          //                               style: const TextStyle(
          //                                   fontSize: 16, color: Colors.grey),
          //                             )
          //                           ],
          //                         ),
          //                         Expanded(child: Container()),
          //                         Text(
          //                           ((directioDetail != null)
          //                               ? '\$${(AssistantMethods.caculatePrice(directioDetail!)/2)}'
          //                               : ""),
          //                           style: const TextStyle(
          //                               fontSize: 16,
          //                               color: Colors.grey,
          //                               fontFamily: "Brand-Bold"),
          //                         )
          //                       ],
          //                     ),
          //                   ),
          //                 ),
          //               ),
          //               const SizedBox(
          //                 height: 10,
          //               ),
          //               Divider(height: 2,thickness: 2,),
          //               const SizedBox(
          //                 height: 10,
          //               ),
          //
          //               GestureDetector(
          //                 onTap: ()
          //                 {
          //                   setState(() {
          //                     state = "requesting";
          //                     carRideType="uber-go";
          //                   });
          //
          //                   displayRequestRideContainer();
          //                   availableDrivers =
          //                       GeoFireAssistant.nearByAvailableDriversList;
          //                   searchNearestDaiver();
          //
          //                 },
          //                 child: Container(
          //                   width: double.infinity,
          //                   color: Colors.tealAccent,
          //                   child: Padding(
          //                     padding: const EdgeInsets.symmetric(horizontal: 16),
          //                     child: Row(
          //                       children: [
          //                         Image.asset(
          //                           "images/065 ubergo.png",
          //                           height: 70,
          //                           width: 80,
          //                         ),
          //                         const SizedBox(
          //                           width: 16,
          //                         ),
          //                         Column(
          //                           crossAxisAlignment: CrossAxisAlignment.start,
          //                           children: [
          //                             const Text(
          //                               "Isuzu",
          //                               style: TextStyle(
          //                                   fontSize: 18,
          //                                   fontFamily: "Brand-Bold"),
          //                             ),
          //                             Text(
          //                               ((directioDetail != null)
          //                                   ? directioDetail!.distanceText!
          //                                   : ' '),
          //                               style: const TextStyle(
          //                                   fontSize: 16, color: Colors.grey),
          //                             )
          //                           ],
          //                         ),
          //                         Expanded(child: Container()),
          //                         Text(
          //                           ((directioDetail != null)
          //                               ? '\$${(AssistantMethods.caculatePrice(directioDetail!)) * 2}'
          //                               : ""),
          //                           style: const TextStyle(
          //                               fontSize: 16,
          //                               color: Colors.grey,
          //                               fontFamily: "Brand-Bold"),
          //                         )
          //                       ],
          //                     ),
          //                   ),
          //                 ),
          //               ),
          //               const SizedBox(
          //                 height: 10,
          //               ),
          //               Divider(height: 2,thickness: 2,),
          //               const SizedBox(
          //                 height: 10,
          //               ),
          //               GestureDetector(
          //                 onTap: ()
          //                 {
          //
          //                     setState(() {
          //                       state = "requesting";
          //                       carRideType="uber-x";
          //
          //                     });
          //
          //                     displayRequestRideContainer();
          //                     availableDrivers =
          //                         GeoFireAssistant.nearByAvailableDriversList;
          //                     searchNearestDaiver();
          //
          //
          //                 },
          //                 child: Container(
          //                   width: double.infinity,
          //                   color: Colors.tealAccent,
          //                   child: Padding(
          //                     padding: const EdgeInsets.symmetric(horizontal: 16),
          //                     child: Row(
          //                       children: [
          //                         Image.asset(
          //                           "images/065 uberx.png",
          //                           height: 70,
          //                           width: 80,
          //                         ),
          //                         const SizedBox(
          //                           width: 16,
          //                         ),
          //                         Column(
          //                           crossAxisAlignment: CrossAxisAlignment.start,
          //                           children: [
          //                             const Text(
          //                               "Car",
          //                               style: TextStyle(
          //                                   fontSize: 18,
          //                                   fontFamily: "Brand-Bold"),
          //                             ),
          //                             Text(
          //                               ((directioDetail != null)
          //                                   ? directioDetail!.distanceText!
          //                                   : ' '),
          //                               style: const TextStyle(
          //                                   fontSize: 16, color: Colors.grey),
          //                             )
          //                           ],
          //                         ),
          //                         Expanded(child: Container()),
          //                         Text(
          //                           ((directioDetail != null)
          //                               ? '\$${AssistantMethods.caculatePrice(directioDetail!)}'
          //                               : ""),
          //                           style: const TextStyle(
          //                               fontSize: 16,
          //                               color: Colors.grey,
          //                               fontFamily: "Brand-Bold"),
          //                         )
          //                       ],
          //                     ),
          //                   ),
          //                 ),
          //               ),
          //               const SizedBox(
          //                 height: 10,
          //               ),
          //               Divider(height: 2,thickness: 2,),
          //               const SizedBox(
          //                 height: 10,
          //               ),
          //
          //
          //               const Padding(
          //                 padding: EdgeInsets.symmetric(horizontal: 16),
          //                 child: Row(
          //                   children: [
          //                     Icon(
          //                       FontAwesomeIcons.moneyCheckAlt,
          //                       size: 18,
          //                       color: Colors.black,
          //                     ),
          //                     SizedBox(
          //                       width: 16,
          //                     ),
          //                     Text("CASH"),
          //                     SizedBox(
          //                       width: 6,
          //                     ),
          //                     Icon(
          //                       Icons.keyboard_arrow_down,
          //                       color: Colors.black54,
          //                       size: 16,
          //                     )
          //                   ],
          //                 ),
          //               ),
          //               const SizedBox(
          //                 height: 20,
          //               ),
          //               // Padding(
          //               //   padding: const EdgeInsets.symmetric(horizontal: 16),
          //               //   child: ElevatedButton(
          //               //
          //               //     child: const Padding(
          //               //       padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
          //               //       child: Row(
          //               //         mainAxisAlignment:
          //               //             MainAxisAlignment.spaceBetween,
          //               //         children: [
          //               //           Text(
          //               //             "Request",
          //               //             style: TextStyle(
          //               //               fontSize: 20,
          //               //               fontWeight: FontWeight.bold,
          //               //               color: Colors.black87,
          //               //             ),
          //               //           ),
          //               //           Icon(
          //               //             FontAwesomeIcons.truck,
          //               //             color: Colors.black54,
          //               //             size: 26,
          //               //           )
          //               //         ],
          //               //       ),
          //               //     ),
          //               //   ),
          //               // )
          //             ],
          //           ),
          //         ),
          //       ),
          //     )),

          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(16),
                    topLeft: Radius.circular(16),
                  ),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                        spreadRadius: 0.5,
                        blurRadius: 16,
                        color: Colors.black54,
                        offset: Offset(0.7, 0.7))
                  ]),
              height: requestRideContainerHeight,
              child: Padding(
                padding: const EdgeInsets.all(30.0),
                child: Column(
                  children: [
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: DefaultTextStyle(
                        style: const TextStyle(
                          fontSize: 60.0,
                          fontFamily: 'Signatra',
                          color: Colors.black54,
                        ),
                        child: AnimatedTextKit(
                          animatedTexts: [
                            TypewriterAnimatedText('Request a Ride'),
                            TypewriterAnimatedText('Please wait ...'),
                            TypewriterAnimatedText('Finding Driver'),
                          ],
                          onTap: () {
                            print("Tap Event");
                          },
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    GestureDetector(
                      onTap: () {
                        cancelRideRequest();
                        resetApp();
                      },
                      child: Container(
                        height: 60,
                        width: 60,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(26),
                            border: Border.all(width: 2, color: Colors.grey)),
                        child: const Icon(
                          Icons.close,
                          size: 26,
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: double.infinity,
                      child: Text(
                        "Cancle Request,",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 12),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(16),
                      topLeft: Radius.circular(16),
                    ),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                          spreadRadius: 0.5,
                          blurRadius: 16,
                          color: Colors.black54,
                          offset: Offset(0.7, 0.7))
                    ]),
                height: driverDetailsContainerHeight,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 6,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            rideStatus,
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 20, fontFamily: "Brand"),
                          ),
                          SizedBox(
                            height: 2,
                          ),
                          Divider(thickness: 2, height: 2),
                          Text(
                            carDetailsDriver,
                            style: TextStyle(color: Colors.grey),
                          ),
                          Text(
                            driverName,
                            style: TextStyle(fontSize: 23, color: Colors.black),
                          ),
                          SizedBox(
                            height: 22,
                          ),
                          Divider(
                            thickness: 2,
                            height: 2,
                          ),
                          SizedBox(
                            height: 22,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 25),
                                child: ElevatedButton(
                                  onPressed: () async {
                                    if (await canLaunch('tel://$driverPhone')) {
                                      await launch('tel://$driverPhone');
                                    } else {
                                      // Handle case where phone number can't be launched
                                    }
                                  },
                                  child: Padding(
                                    padding: EdgeInsets.all(17),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Text(
                                          "Call Driver",
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.green),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Icon(
                                          Icons.call,
                                          color: Colors.black,
                                          size: 26,
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              )

                              // Column(
                              //   mainAxisAlignment: MainAxisAlignment.start,
                              //   children: [
                              //     Container(
                              //       height: 55,
                              //       width: 55,
                              //       decoration: BoxDecoration(
                              //         borderRadius:
                              //             BorderRadius.all(Radius.circular(26)),
                              //         border: Border.all(
                              //             width: 2, color: Colors.grey),
                              //       ),
                              //       child: Icon(Icons.call),
                              //     ),
                              //     SizedBox(
                              //       height: 10,
                              //     ),
                              //     Text("Call"),
                              //   ],
                              // ),
                              // Column(
                              //   mainAxisAlignment: MainAxisAlignment.start,
                              //   children: [
                              //     Container(
                              //       height: 55,
                              //       width: 55,
                              //       decoration: BoxDecoration(
                              //         borderRadius:
                              //             BorderRadius.all(Radius.circular(26)),
                              //         border: Border.all(
                              //             width: 2, color: Colors.grey),
                              //       ),
                              //       child: Icon(Icons.call),
                              //     ),
                              //     SizedBox(
                              //       height: 10,
                              //     ),
                              //     Text("Details"),
                              //   ],
                              // ),
                              // Column(
                              //   mainAxisAlignment: MainAxisAlignment.start,
                              //   children: [
                              //     Container(
                              //       height: 55,
                              //       width: 55,
                              //       decoration: BoxDecoration(
                              //         borderRadius:
                              //             BorderRadius.all(Radius.circular(26)),
                              //         border: Border.all(
                              //             width: 2, color: Colors.grey),
                              //       ),
                              //       child: Icon(Icons.list),
                              //     ),
                              //     SizedBox(
                              //       height: 10,
                              //     ),
                              //     Text("Cancel"),
                              //   ],
                              // )
                            ],
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ))
        ],
      ),
    );
  }

  Future<void> getPlaceDirection() async {
    var initialPos =
        Provider.of<AppData>(context, listen: false).pickUpLocation;
    var finalPos = Provider.of<AppData>(context, listen: false).DropOffLocation;

    var pickUpLatLng = LatLng(initialPos!.latitude!, initialPos.longitude!);
    var dropOffLatLng = LatLng(finalPos!.latitude!, finalPos.longitude!);

    showDialog(
        context: context,
        builder: (BuildContext context) => ProgressDialog(
              message: "Please Wait",
            ));

    var details = await AssistantMethods.obtainPlaceDirectionsDetails(
        pickUpLatLng, dropOffLatLng);

    setState(() {
      directioDetail = details;
    });

    Navigator.pop(context);

    print(details.encodedPoints);

    PolylinePoints polylinePoints = PolylinePoints();
    List<PointLatLng> decodePolyLinePointsResult =
        polylinePoints.decodePolyline(details.encodedPoints!);
    pLineCoordinates.clear();

    if (decodePolyLinePointsResult.isNotEmpty) {
      for (var pointLatLng in decodePolyLinePointsResult) {
        pLineCoordinates
            .add(LatLng(pointLatLng.latitude, pointLatLng.longitude));
      }
    }

    setState(() {
      Polyline polyline = Polyline(
          color: Colors.red,
          polylineId: const PolylineId("PolylineID"),
          jointType: JointType.round,
          points: pLineCoordinates,
          width: 5,
          startCap: Cap.roundCap,
          endCap: Cap.roundCap,
          geodesic: true);
      polylineSet.add(polyline);
    });
    LatLngBounds latLngBounds;
    if (pickUpLatLng.latitude > dropOffLatLng.latitude &&
        pickUpLatLng.longitude > dropOffLatLng.longitude) {
      latLngBounds =
          LatLngBounds(southwest: dropOffLatLng, northeast: pickUpLatLng);
    } else if (pickUpLatLng.longitude > dropOffLatLng.longitude) {
      latLngBounds = LatLngBounds(
          southwest: LatLng(pickUpLatLng.latitude, dropOffLatLng.longitude),
          northeast: LatLng(dropOffLatLng.latitude, pickUpLatLng.longitude));
    } else if (pickUpLatLng.latitude > dropOffLatLng.latitude) {
      latLngBounds = LatLngBounds(
          southwest: LatLng(dropOffLatLng.latitude, pickUpLatLng.longitude),
          northeast: LatLng(pickUpLatLng.latitude, dropOffLatLng.longitude));
    } else {
      latLngBounds =
          LatLngBounds(southwest: pickUpLatLng, northeast: dropOffLatLng);
    }
    newGoogleMapController
        .animateCamera(CameraUpdate.newLatLngBounds(latLngBounds, 70));

    Marker pickUpLocMarker = Marker(
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        infoWindow:
            InfoWindow(title: finalPos.placeName, snippet: "Start Location"),
        position: pickUpLatLng,
        markerId: const MarkerId("pickupId"));

    Marker dropOffLocMarker = Marker(
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
        infoWindow:
            InfoWindow(title: finalPos.placeName, snippet: "DropOffLocation"),
        position: dropOffLatLng,
        markerId: const MarkerId("dropofId"));

    setState(() {
      markersSet.add(pickUpLocMarker);
      markersSet.add(dropOffLocMarker);
    });
    Circle pickupLockCircle = Circle(
        circleId: const CircleId("pickupId"),
        fillColor: Colors.green,
        center: pickUpLatLng,
        radius: 12,
        strokeWidth: 12,
        strokeColor: Colors.greenAccent);
    Circle dropOffLockCircle = Circle(
        circleId: const CircleId("dropofId"),
        fillColor: Colors.red,
        center: dropOffLatLng,
        radius: 12,
        strokeWidth: 12,
        strokeColor: Colors.redAccent);
    setState(() {
      circlesSet.add(pickupLockCircle);
      circlesSet.add(dropOffLockCircle);
    });
  }

  void initGeoFireListner() {
    Geofire.initialize("AvailabeDrivers");

    Geofire.queryAtLocation(
            currentPosition.latitude, currentPosition.longitude, 10)!
        .listen((map) {
      print(map);
      if (map != null) {
        var callBack = map['callBack'];

        switch (callBack) {
          case Geofire.onKeyEntered:
            NearbyAvailabelDrivers nearbyAvailabelDrivers =
                NearbyAvailabelDrivers();
            nearbyAvailabelDrivers.key = map['key'];
            nearbyAvailabelDrivers.latitude = map['latitude'];
            nearbyAvailabelDrivers.longitude = map['longitude'];
            GeoFireAssistant.nearByAvailableDriversList
                .add(nearbyAvailabelDrivers);
            if (nearbyAvailableDriversKeysLoaded == true) {
              updateAvailableDriverOnMap();
            }
            break;

          case Geofire.onKeyExited:
            GeoFireAssistant.removeDriverFromList(map['key']);
            updateAvailableDriverOnMap();
            break;

          case Geofire.onKeyMoved:
            NearbyAvailabelDrivers nearbyAvailabelDrivers =
                NearbyAvailabelDrivers();
            nearbyAvailabelDrivers.key = map['key'];
            nearbyAvailabelDrivers.latitude = map['latitude'];
            nearbyAvailabelDrivers.longitude = map['longitude'];
            GeoFireAssistant.updatDriverMearbyLocation(nearbyAvailabelDrivers);
            updateAvailableDriverOnMap();
            break;

          case Geofire.onGeoQueryReady:
            updateAvailableDriverOnMap();

            break;
        }
      }

      setState(() {});
    });
  }

  void updateAvailableDriverOnMap() {
    setState(() {
      markersSet.clear();
    });

    Set<Marker> tMakers = <Marker>{};
    for (NearbyAvailabelDrivers drivers
        in GeoFireAssistant.nearByAvailableDriversList) {
      LatLng driverAvailablePosition =
          LatLng(drivers.latitude!, drivers.longitude!);
      Marker marker = Marker(
          markerId: MarkerId('drivers${drivers.key}'),
          position: driverAvailablePosition,
          icon: nearByIcon!,
          // icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
          rotation: AssistantMethods.createRandomNumber(360));
      tMakers.add(marker);
    }
    setState(() {
      markersSet = tMakers;
    });
  }

  createIconMarker() {
    if (nearByIcon == null) {
      ImageConfiguration imageConfiguration =
          createLocalImageConfiguration(context, size: const Size(2, 2));
      BitmapDescriptor.fromAssetImage(imageConfiguration, "images/car_ios.png")
          .then((value) {
        nearByIcon = value;
      });
    }
  }

  void noDriverFound() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => const NoDriverAvailableDiaog());
  }

  void searchNearestDaiver() {
    if (availableDrivers!.isEmpty) {
      cancelRideRequest();
      resetApp();
      noDriverFound();
      return;
    }

    var driver = availableDrivers![0];

    notifyDriver(driver);
    availableDrivers!.removeAt(0);


    // driverRref
    //     .child(driver.key!)
    //     .child("car_details")
    //     .child("type")
    //     .once()
    //     .then((DatabaseEvent event) async {
    //   DataSnapshot snapshot = event.snapshot; // Access data from the event
    //   if (snapshot.value != null) {
    //     String carType = snapshot.value.toString();
    //     if (carType == carRideType) {
    //       notifyDriver(driver);
    //       availableDrivers!.removeAt(0);
    //     } else {
    //       displayToastMessage(carRideType + " driver Not available", context);
    //     }
    //   } else {
    //     displayToastMessage("NoCar Found", context);
    //   }
    // });
  }

  void notifyDriver(NearbyAvailabelDrivers drivers) async {
    final driverRef = driverRref.child(drivers.key!);
    await driverRef.child("newRide").set(rideRequestRef!.key);

    // Access DataSnapshot from DatabaseEvent
    final event = await driverRef.child("token").once();
    final tokenSnapshot = event.snapshot; // Get the DataSnapshot

    if (tokenSnapshot.exists) {
      final token = tokenSnapshot.value.toString();

      AssistantMethods.sendNotificationToDriver(
          token, context, rideRequestRef!.key!);

      // Use the token to send a notification
    } else {
      return;
      print("No token found for driver ${drivers.key}");
    }

    const oneSecondPassed = Duration(seconds: 1);

    var timer = Timer.periodic(oneSecondPassed, (timer) {
      if (state != "requesting") {
        driverRef.child(drivers.key!).child("newRide").set("cancelled");
        driverRef.child(drivers.key!).child("newRide").onDisconnect();
        driverRequestTimeOut = 30;
        timer.cancel();
      }

      driverRequestTimeOut = driverRequestTimeOut - 1;
      driverRef.child(drivers.key!).child("newRide").onValue.listen((event) {
        if (event.snapshot.value.toString() == "accepted") {
          driverRef.child(drivers.key!).child("newRide").onDisconnect();
          driverRequestTimeOut = 40;
          timer.cancel();
        }
      });

      if (driverRequestTimeOut == 0) {
        driverRef.child(drivers.key!).child("newRide").set("timeout");
        driverRef.child(drivers.key!).child("newRide").onDisconnect();
        driverRequestTimeOut = 30;
        timer.cancel();

        searchNearestDaiver();
      }
    });
  }
}
