import 'package:firebase_database/firebase_database.dart';
import 'package:smooth_star_rating_null_safety/smooth_star_rating_null_safety.dart';
import 'package:flutter/material.dart';

class RatingScreen extends StatefulWidget {
  final String driverId;

  RatingScreen({required this.driverId});

  @override
  State<RatingScreen> createState() => _RatingScreenState();
}

class _RatingScreenState extends State<RatingScreen> {
  double startCounter = 0.0;
  String title = "Rate the driver";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black54,
      body: Center(
        child: Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          backgroundColor: Colors.transparent,
          child: Container(
            margin: EdgeInsets.all(5),
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    icon: Icon(Icons.close, color: Colors.red),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  "Rate Driver",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.blue),
                ),
                SizedBox(height: 22),
                Divider(height: 2, thickness: 2),
                SizedBox(height: 16),
                SmoothStarRating(
                  rating: startCounter,
                  color: Colors.green,
                  allowHalfRating: false,
                  starCount: 5,
                  size: 45,
                  onRatingChanged: (value) {
                    setState(() {
                      startCounter = value;
                      switch (startCounter.toInt()) {
                        case 1:
                          title = "Very Bad";
                          break;
                        case 2:
                          title = "Bad";
                          break;
                        case 3:
                          title = "Good";
                          break;
                        case 4:
                          title = "Very Good";
                          break;
                        case 5:
                          title = "Excellent";
                          break;
                        default:
                          title = "Rate the driver";
                      }
                    });
                  },
                ),
                SizedBox(height: 16),
                Text(
                  title,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    "This rating will help us improve the service.",
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: 30),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: ElevatedButton(
                    onPressed: () async {
                      DatabaseReference driverRatingRef = FirebaseDatabase.instance
                          .ref()
                          .child("drivers")
                          .child(widget.driverId)
                          .child("ratings");

                      driverRatingRef.once().then((DatabaseEvent event) {
                        DataSnapshot snap = event.snapshot;
                        if (snap.value != null) {
                          double oldRatings = double.parse(snap.value.toString());
                          double addRating = oldRatings + startCounter;
                          double averageRating = addRating / 2;

                          driverRatingRef.set(averageRating.toString()).then((_) {
                            print("Rating updated successfully!");
                            Navigator.pop(context);
                          }).catchError((error) {
                            print("Error updating rating: $error");
                          });
                        } else {
                          driverRatingRef.set(startCounter.toString()).then((_) {
                            print("Initial rating set successfully!");
                          }).catchError((error) {
                            print("Error setting initial rating: $error");
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
                                color: Colors.white),
                          ),
                          Icon(
                            Icons.star,
                            color: Colors.yellow,
                            size: 26,
                          )
                        ],
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
