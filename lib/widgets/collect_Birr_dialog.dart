import 'package:users/assistant/assistant_methods.dart';
import 'package:flutter/material.dart';

class CollectBirrDialog extends StatelessWidget {
  final String paymentMethod;
  final int fareAmount;

  CollectBirrDialog({required this.fareAmount, required this.paymentMethod});

// CollectBirrDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
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
            Text("Cash Payment"),
            SizedBox(
              height: 22,
            ),
            Divider(height: 2,thickness: 2,),
            SizedBox(
              height: 16,
            ),
            Text(
              "\E\T\B$fareAmount",
              style: TextStyle(fontSize: 55, fontFamily: "Brand-Bold"),
            ),
            SizedBox(
              height: 16,
            ),
            SizedBox(
              height: 16,
            ),
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

                  Navigator.pop(context,"close");
                 // Navigator.pop(context);
                //  AssistantMethods.enableLiveLocationUpdate();

                },
                child: Padding(
                  padding: EdgeInsets.all(17),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Pay Cash",
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
    );
  }
}
