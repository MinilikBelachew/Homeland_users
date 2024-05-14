import 'package:firebase_database/firebase_database.dart';
import 'package:smooth_star_rating_null_safety/smooth_star_rating_null_safety.dart';
import 'package:users/assistant/assistant_methods.dart';
import 'package:flutter/material.dart';
import 'package:users/config_maps.dart';

class RatingScreen extends StatefulWidget {
  final String driverId;

  RatingScreen({
    required this.driverId
  });


  @override
  State<RatingScreen> createState() => _RatingScreenState();
}

class _RatingScreenState extends State<RatingScreen> {
// CollectBirrDialog({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        backgroundColor: Colors.transparent,
        child: Container(
          margin: EdgeInsets.all(5),
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(5),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 22,
              ),
              Text("Rate Driver",style: TextStyle(fontSize: 20,fontFamily: "Brand-Bold",color: Colors.blue),),
              SizedBox(
                height: 22,
              ),
              Divider(height: 2,thickness: 2,),
              SizedBox(
                height: 16,
              ),


              SmoothStarRating(
                rating: startCounter,
                color: Colors.green,
                allowHalfRating: false,
                starCount: 5,
                size: 45,
                onRatingChanged: (value) {


                  startCounter=value;
                  if(startCounter == 1)
                    {
                      setState(() {
                     title="Very Bad";
                      });
                    }
                  if(startCounter == 2)
                  {
                    setState(() {
                      title="Bad";
                    });
                  }
                  if(startCounter == 3)
                  {
                    setState(() {
                      title="Good";
                    });
                  }
                  if(startCounter == 4)
                  {
                    setState(() {
                      title="Very Good";
                    });
                  }
                  if(startCounter == 5)
                  {
                    setState(() {
                      title="Excellent";
                    });
                  }

                },              ),


              SizedBox(
                height: 16,
              ),

              Text(title,style: TextStyle(fontSize: 55,fontFamily: "Signatra",color: Colors.green),),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  "This Is total Amount,it has been to the rider",
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: ElevatedButton(
                  onPressed: () async {

                    DatabaseReference driverRatingRref = FirebaseDatabase.instance.ref().child("drivers").child(widget.driverId).child("ratings");

                    driverRatingRref.once().then((DatabaseEvent event) {
                      DataSnapshot snap = event.snapshot; // Extract the DataSnapshot from the DatabaseEvent

                      if (snap.value != null) {
                        double oldRatings = double.parse(snap.value.toString());
                        double addRating = oldRatings + startCounter;
                        double averageRating = addRating / 2;

                        // Update the rating with the calculated average
                        driverRatingRref.set(averageRating.toString()).then((_) {
                          print("Rating updated successfully!");
                          Navigator.pop(context);
                        }).catchError((error) {
                          print("Error updating rating: $error"); // Handle errors gracefully
                        });
                      } else {
                        // Set the rating to startCounter if it doesn't exist
                        driverRatingRref.set(startCounter.toString()).then((_) {
                          print("Initial rating set successfully!"); // Optional success message
                        }).catchError((error) {
                          print("Error setting initial rating: $error"); // Handle errors gracefully
                        });
                      }
                    });




                  },
                  child: Padding(
                    padding: EdgeInsets.all(17),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          "Rate",
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        ),
                        Icon(
                          Icons.attach_money,
                          color: Colors.blue,
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
    );
  }
}
