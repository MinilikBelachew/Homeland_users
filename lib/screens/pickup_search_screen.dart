import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:users/assistant/pickup_tile.dart';
import 'package:users/assistant/request_assistant.dart';
import 'package:users/config_maps.dart';
import 'package:users/data_handler/app_data.dart';
import 'package:users/widgets/divider.dart';

import '../assistant/place_predication_tile.dart';
import '../models/prediction_places.dart';

class PickupSearchScreen extends StatefulWidget {
  const PickupSearchScreen({super.key});

  @override
  State<PickupSearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<PickupSearchScreen> {
  TextEditingController pickupTextEdditingController = TextEditingController();

  List<PlacePredication> placePredicationListPickup = [];





  @override
  Widget build(BuildContext context) {
    // String placeAddress = Provider.of<AppData>(context).pickUpLocation != null
    //     ? Provider.of<AppData>(context).pickUpLocation!.placeName ?? ""
    //     : "";
    // pickupTextEdditingController.text = placeAddress;


    return SafeArea(
      child: Scaffold(
        body: Column(

          children: [
            Container(
              height: 215,
              decoration: const BoxDecoration(color: Colors.white, boxShadow: [
                BoxShadow(
                    color: Colors.black87,
                    blurRadius: 6,
                    spreadRadius: 0.5,
                    offset: Offset(0.7, 0.7))
              ]),
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 25, top: 20, right: 25, bottom: 20),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 30,
                    ),
                    Stack(
                      children: [
                        GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: const Icon(Icons.arrow_back)),
                        const Center(
                          child: Text(
                            "Set Pickup Location",
                            style: TextStyle(
                                fontSize: 18, fontFamily: "Brand-Bold"),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Row(
                      children: [



                        Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.grey[400],
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(3),
                                child: TextField(
                                  onChanged: (val) {
                                    findPlacePickUp(val);
                                  },
                                  controller: pickupTextEdditingController,
                                  decoration: InputDecoration(
                                      hintText: "Pick Up ",
                                      fillColor: Colors.grey[400],
                                      filled: true,
                                      border: InputBorder.none,
                                      isDense: true,
                                      contentPadding: const EdgeInsets.only(
                                          left: 11, top: 8, bottom: 8)),
                                ),
                              ),
                            ))
                      ],
                    ),
                    const SizedBox(
                      height: 16,
                    ),

                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),


            (placePredicationListPickup.isNotEmpty)
                ? Padding(
              padding:
              const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: ListView.separated(
                itemBuilder: (context, index) {
                  return PickupTile(
                      placePredication: placePredicationListPickup[index], );
                },
                separatorBuilder: (BuildContext context, int index) =>
                const DividerWidget(),
                itemCount: placePredicationListPickup.length,
                shrinkWrap: true,
                physics: const ClampingScrollPhysics(),
              ),
            )
                : Container()

          ],
        ),
      ),
    );
  }


  void findPlacePickUp(String placeNmae) async {
    if (placeNmae.length > 1) {
      // String urlAutoCompleteSearch = "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$placeNmae&key=$mapkey&components=country:ET";
      String urlAutoCompleteSearch =
          "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$placeNmae&key=$mapkey&components=country:ET&language=am";

      var res = await RequestAssistant.getRequest(urlAutoCompleteSearch);
      if (res == "failed") {
        return;
      }
      if (res["status"] == "OK") {
        var predications = res["predictions"];
        var placeList = (predications as List)
            .map((e) => PlacePredication.fromJson(e))
            .toList();
        setState(() {
          placePredicationListPickup= placeList;
        });

      }
    }
  }
}















// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:users/assistant/request_assistant.dart';
// import 'package:users/config_maps.dart';
// import 'package:users/data_handler/app_data.dart';
// import 'package:users/widgets/divider.dart';
//
// import '../assistant/place_predication_tile.dart';
// import '../models/prediction_places.dart';
//
// class SearchScreen extends StatefulWidget {
//   const SearchScreen({super.key});
//
//   @override
//   State<SearchScreen> createState() => _SearchScreenState();
// }
//
// class _SearchScreenState extends State<SearchScreen> {
//   TextEditingController pickupTextEdditingController = TextEditingController();
//   TextEditingController dropoffTextEdditingController = TextEditingController();
//   List<PlacePredication> placePredicationList = [];
//   @override
//   Widget build(BuildContext context) {
//     String placeAddress =
//         Provider.of<AppData>(context).pickUpLocation!.placeName ?? " ";
//     pickupTextEdditingController.text = placeAddress;
//
//     return SafeArea(
//       child: Scaffold(
//         body: Column(
//           children: [
//             Container(
//               height: 215,
//               decoration: const BoxDecoration(color: Colors.white, boxShadow: [
//                 BoxShadow(
//                     color: Colors.black87,
//                     blurRadius: 6,
//                     spreadRadius: 0.5,
//                     offset: Offset(0.7, 0.7))
//               ]),
//               child: Padding(
//                 padding: const EdgeInsets.only(
//                     left: 25, top: 20, right: 25, bottom: 20),
//                 child: Column(
//                   children: [
//                     const SizedBox(
//                       height: 5,
//                     ),
//                     Stack(
//                       children: [
//                         GestureDetector(
//                             onTap: () {
//                               Navigator.pop(context);
//                             },
//                             child: const Icon(Icons.arrow_back)),
//                         const Center(
//                           child: Text(
//                             "Set Drop Off",
//                             style: TextStyle(
//                                 fontSize: 18, fontFamily: "Brand-Bold"),
//                           ),
//                         )
//                       ],
//                     ),
//                     const SizedBox(
//                       height: 16,
//                     ),
//                     Row(
//                       children: [
//                         Image.asset(
//                           "images/pickicon.png",
//                           height: 16,
//                           width: 16,
//                         ),
//                         const SizedBox(
//                           width: 18,
//                         ),
//                         Expanded(
//                             child: Container(
//                           decoration: BoxDecoration(
//                             color: Colors.grey[400],
//                             borderRadius: BorderRadius.circular(5),
//                           ),
//                           child: Padding(
//                             padding: const EdgeInsets.all(3),
//                             child: TextField(
//                               controller: pickupTextEdditingController,
//                               decoration: InputDecoration(
//                                   hintText: "Pick Up ",
//                                   fillColor: Colors.grey[400],
//                                   filled: true,
//                                   border: InputBorder.none,
//                                   isDense: true,
//                                   contentPadding: const EdgeInsets.only(
//                                       left: 11, top: 8, bottom: 8)),
//                             ),
//                           ),
//                         ))
//                       ],
//                     ),
//                     const SizedBox(
//                       height: 16,
//                     ),
//                     Row(
//                       children: [
//                         Image.asset(
//                           "images/pickicon.png",
//                           height: 16,
//                           width: 16,
//                         ),
//                         const SizedBox(
//                           width: 18,
//                         ),
//                         Expanded(
//                           child: Container(
//                             decoration: BoxDecoration(
//                               color: Colors.grey[400],
//                               borderRadius: BorderRadius.circular(5),
//                             ),
//                             child: Padding(
//                               padding: const EdgeInsets.all(3),
//                               child: TextField(
//                                 onChanged: (val) {
//                                   findPlace(val);
//                                 },
//                                 controller: dropoffTextEdditingController,
//                                 decoration: InputDecoration(
//                                     hintText: "Where to",
//                                     fillColor: Colors.grey[400],
//                                     filled: true,
//                                     border: InputBorder.none,
//                                     isDense: true,
//                                     contentPadding: const EdgeInsets.only(
//                                         left: 11, top: 8, bottom: 8)),
//                               ),
//                             ),
//                           ),
//                         ),
//                       ],
//                     )
//                   ],
//                 ),
//               ),
//             ),
//             const SizedBox(
//               height: 10,
//             ),
//             (placePredicationList.isNotEmpty)
//                 ? Padding(
//                     padding:
//                         const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
//                     child: ListView.separated(
//                       itemBuilder: (context, index) {
//                         return PredicationTile(
//                             placePredication: placePredicationList[index]);
//                       },
//                       separatorBuilder: (BuildContext context, int index) =>
//                           const DividerWidget(),
//                       itemCount: placePredicationList.length,
//                       shrinkWrap: true,
//                       physics: const ClampingScrollPhysics(),
//                     ),
//                   )
//                 : Container()
//           ],
//         ),
//       ),
//     );
//   }
//
//   void findPlace(String placeNmae) async {
//     if (placeNmae.length > 1) {
//       // String urlAutoCompleteSearch = "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$placeNmae&key=$mapkey&components=country:ET";
//       String urlAutoCompleteSearch =
//           "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$placeNmae&key=$mapkey&components=country:ET&language=am";
//
//       var res = await RequestAssistant.getRequest(urlAutoCompleteSearch);
//       if (res == "failed") {
//         return;
//       }
//       if (res["status"] == "OK") {
//         var predications = res["predictions"];
//         var placeList = (predications as List)
//             .map((e) => PlacePredication.fromJson(e))
//             .toList();
//
//         setState(() {
//           placePredicationList = placeList;
//         });
//       }
//     }
//   }
// }
