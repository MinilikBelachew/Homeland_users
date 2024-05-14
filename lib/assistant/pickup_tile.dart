import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:users/assistant/request_assistant.dart';
import 'package:users/config_maps.dart';
import 'package:users/data_handler/app_data.dart';
import 'package:users/models/address.dart';
import 'package:users/widgets/progess_dialog.dart';

import '../models/prediction_places.dart';

class PickupTile extends StatelessWidget {
  const PickupTile({Key? key, required this.placePredication})
      : super(key: key);

  final PlacePredication placePredication;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        getPlaceAddressDetailsPickup(placePredication.place_id!, context);
      },
      child: Container(
        child: Column(
          children: [
            const SizedBox(
              width: 10,
            ),
            Row(
              children: [
                const Icon(
                  Icons.location_on,
                  color: Colors.black,
                ),
                const SizedBox(
                  width: 14,
                ),
                Expanded(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      placePredication.main_text!,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 16, color: Colors.black),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      placePredication.secondery_text!,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    )
                  ],
                ))
              ],
            )
          ],
        ),
      ),
    );
  }

  void getPlaceAddressDetailsPickup(String placeId, context) async {
    String placeDetailsUrl =
        "https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$mapkey";

    var res = await RequestAssistant.getRequest(placeDetailsUrl);
     Navigator.pop(context);

    if (res == "failed") {
      return;
    }
    if (res["status"] == "OK") {
      Address address = Address();
      address.placeName = res["result"]["name"];
      address.placeId = placeId;
      address.latitude = res["result"]["geometry"]["location"]["lat"];
      address.longitude = res["result"]["geometry"]["location"]["lng"];

      Provider.of<AppData>(context, listen: false)
          .updatePickUpLocationAddress(address);



       //Navigator.pop(context, "obtainDirection");
    }
  }
}
