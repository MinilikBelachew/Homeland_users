import 'package:chapa_unofficial/chapa_unofficial.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ChapaPayment extends StatefulWidget {
  const ChapaPayment({super.key, required this.title, required this.fareAmount});
  static const String idScreen = "chapa";
  final String title;
  final int fareAmount;

  @override
  State<ChapaPayment> createState() => _ChapaPaymentState();
}

class _ChapaPaymentState extends State<ChapaPayment> {

  Future<void> verify() async {
    Map<String, dynamic> verificationResult =
    await Chapa.getInstance.verifyPayment(
      txRef: TxRefRandomGenerator.gettxRef,
    );
    if (kDebugMode) {
      print(verificationResult);
    }
  }

  Future<void> pay(String payAmount) async {
    try {
      String txRef = TxRefRandomGenerator.generate(prefix: 'linat');
      String storedTxRef = TxRefRandomGenerator.gettxRef;

      if (kDebugMode) {
        print('Generated TxRef: $txRef');
        print('Stored TxRef: $storedTxRef');
      }
      await Chapa.getInstance.startPayment(
        context: context,
        onInAppPaymentSuccess: (successMsg) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Payment Successful: $successMsg')),
          );
        },
        onInAppPaymentError: (errorMsg) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Payment Error: $errorMsg')),
          );
        },
        amount: payAmount,
        currency: 'ETB',
        txRef: storedTxRef,
      );
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Payment Exception: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.teal,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Pay with Chapa',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal,
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: () async {
                  await pay(widget.fareAmount.toString());
                },
                icon: Icon(Icons.payment),
                label: Text('Pay'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  textStyle: TextStyle(fontSize: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: () async {
                  await verify();
                },
                icon: Icon(Icons.verified),
                label: Text('Verify'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  textStyle: TextStyle(fontSize: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


// import 'package:chapa_unofficial/chapa_unofficial.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
//
// class chapaPayment extends StatefulWidget {
//   const chapaPayment({super.key, required this.title});
//   static const String idScreen = "chapa";
//   final String title;
//
//   @override
//   State<chapaPayment> createState() => _MyHomePageState();
// }
//
// class _MyHomePageState extends State<chapaPayment> {
//   // final int _counter = 0;
//
//   Future<void> verify() async {
//     Map<String, dynamic> verificationResult =
//     await Chapa.getInstance.verifyPayment(
//       txRef: TxRefRandomGenerator.gettxRef,
//     );
//     if (kDebugMode) {
//       print(verificationResult);
//     }
//   }
//
//   Future<void> pay() async {
//     try {
//       // Generate a random transaction reference with a custom prefix
//       String txRef = TxRefRandomGenerator.generate(prefix: 'linat');
//
//       // Access the generated transaction reference
//       String storedTxRef = TxRefRandomGenerator.gettxRef;
//
//       // Print the generated transaction reference and the stored transaction reference
//       if (kDebugMode) {
//         print('Generated TxRef: $txRef');
//         print('Stored TxRef: $storedTxRef');
//       }
//       await Chapa.getInstance.startPayment(
//         context: context,
//         onInAppPaymentSuccess: (successMsg) {
//           // Handle success events
//         },
//         onInAppPaymentError: (errorMsg) {
//           // Handle error
//         },
//         amount: '1000',
//         currency: 'ETB',
//         txRef: storedTxRef,
//       );
//     } catch (e) {
//       if (kDebugMode) {
//         print(e);
//       }
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(" payment"),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             const Text(
//               'pay to linat416',
//             ),
//             TextButton(
//                 onPressed: () async {
//                   await pay();
//                 },
//                 child: const Text("Pay")),
//             TextButton(
//                 onPressed: () async {
//                   await verify();
//                 },
//                 child: const Text("Verify")),
//           ],
//         ),
//       ),
//     );
//   }
// }