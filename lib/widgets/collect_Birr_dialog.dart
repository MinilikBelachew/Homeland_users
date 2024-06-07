import 'package:users/assistant/assistant_methods.dart';
import 'package:flutter/material.dart';
import 'package:users/widgets/chapa_pay.dart';

class CollectBirrDialog extends StatelessWidget {
  final String paymentMethod;
  final int fareAmount;

  const CollectBirrDialog({required this.fareAmount, required this.paymentMethod});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      backgroundColor: Colors.transparent,
      child: Container(
        margin: EdgeInsets.all(20), // Increased margin for better spacing
        width: MediaQuery.of(context).size.width * 0.9,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12), // Increased corner radius
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              blurRadius: 10.0, // Add subtle shadow
              spreadRadius: 0.0,
              offset: Offset(0.0, 4.0), // Offset shadow slightly down
            )
          ],
        ),
        child: Padding(

          padding: const EdgeInsets.all(8.0),
          child: Column(

            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 20), // Adjusted spacing
              Text(
                "Payment",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              Divider(
                height: 2,
                thickness: 2,
              ),
              SizedBox(height: 16),
              Text(
                "\E\T\B${fareAmount.toStringAsFixed(2)}", // Display fareAmount with 2 decimal places
                style: TextStyle(
                  fontSize: 55,
                  fontFamily: "Brand-Bold",
                ),
              ),
              SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24), // Adjusted padding
                child: Text(
                  "This is the total amount to be payed to the driver.",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16),
                ),
              ),
              SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16), // Adjusted padding
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly, // Distribute buttons evenly
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () async {
                          Navigator.pop(context, "close");
                          // AssistantMethods.enableLiveLocationUpdate();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green, // Green for cash payment
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0), // Rounded corners
                          ),
                          minimumSize: Size(MediaQuery.of(context).size.width / 2.2, 50), // Set minimum button size
                        ),
                        child: Text(
                          "Pay Cash",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () async {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>  ChapaPayment(title: "Payment",fareAmount: fareAmount)));
                          print(fareAmount);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue, // Blue for Chapa payment
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0), // Rounded corners
                          ),
                          minimumSize: Size(MediaQuery.of(context).size.width / 2.2, 50), // Set minimum button size
                        ),
                        child: Text(
                          "Pay With Chapa",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
