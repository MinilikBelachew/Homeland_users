import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data_handler/app_data.dart';
import '../models/package_detail.dart';

class PackageDetailsForm extends StatefulWidget {
  const PackageDetailsForm({
    Key? key,
  }) : super(key: key);

  @override
  State<PackageDetailsForm> createState() => _PackageDetailsFormState();
}

class _PackageDetailsFormState extends State<PackageDetailsForm> {
  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Title with modern text style
                Text(
                  "Package Details",
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 20.0),

                // Description TextField with clean design
                TextFormField(
                  controller: _descriptionController,
                  decoration: InputDecoration(
                    labelText: "Content Description",
                    labelStyle: TextStyle(color: Colors.grey),
                    contentPadding: EdgeInsets.all(15.0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(color: Colors.grey[200]!),
                    ),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Please enter a brief description";
                    }
                    return null;
                  },
                  onSaved: (value) => setState(() => _descriptionController.text = value!),
                ),
                SizedBox(height: 20.0),

                // Primary color button with updated style
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();

                      PackageDetails packageDetails = PackageDetails(
                        contentDescription: _descriptionController.text,
                      );

                      Provider.of<AppData>(context, listen: false)
                          .cargo(packageDetails);

                      Navigator.pop(context);
                    }
                  },
                  child: Text("Submit Package Details"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
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









// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../data_handler/app_data.dart';
// import '../models/package_detail.dart';
//
// class PackageDetailsForm extends StatefulWidget {
//
//
//   const PackageDetailsForm({Key? key, })
//       : super(key: key);
//
//   @override
//   State<PackageDetailsForm> createState() => _PackageDetailsFormState();
// }
//
// class _PackageDetailsFormState extends State<PackageDetailsForm> {
//   TextEditingController weightTextEditingController = TextEditingController();
//   TextEditingController descriptionTextEditingController =
//   TextEditingController();
//
//   final _formKey = GlobalKey<FormState>();
//
//   String _contentDescription = "";
//
//   @override
//   Widget build(BuildContext context) {
//     return Material(
//       child: Form(
//         key: _formKey,
//         child: SingleChildScrollView(
//           padding: EdgeInsets.all(20.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: [
//               // Title with some spacing
//               Text(
//                 "Package Details",
//                 style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//               ),
//               SizedBox(height: 10),
//
//               // TextFields with rounded borders and some padding
//
//               TextFormField(
//                 controller: descriptionTextEditingController,
//                 decoration: InputDecoration(
//                   labelText: "Content Description",
//                   contentPadding: EdgeInsets.all(12.0),
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(10.0),
//                   ),
//                 ),
//                 validator: (value) {
//                   if (value!.isEmpty) {
//                     return "Please enter a brief description";
//                   }
//                   return null;
//                 },
//                 onSaved: (value) =>
//                     setState(() => _contentDescription = value!),
//               ),
//               SizedBox(height: 20),
//
//               // Primary color button
//               ElevatedButton(
//                 onPressed: ()
//                 {
//
//
//                   if (_formKey.currentState!.validate()) {
//                     _formKey.currentState!.save();
//
//                     // Save weight and description separately
//                     PackageDetails packageDetails = PackageDetails(
//
//                       contentDescription: _contentDescription,
//                     );
//
//                     // Call cargo and Cargodescription methods with the appropriate values
//                     Provider.of<AppData>(context, listen: false).cargo(packageDetails);
//                     //Provider.of<AppData>(context, listen: false).Cargodescription(packageDetails);
//
//                     Navigator.pop(context);
//                   }
//                 },
//
//
//                 child: Text("Submit Package Details"),
//                 style: ElevatedButton.styleFrom(
//                   foregroundColor: Colors.white,
//                   backgroundColor: Theme.of(context).primaryColor, // Text color
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(10.0),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//
//
// }
//
//
//







// mport 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../data_handler/app_data.dart';
// import '../models/package_detail.dart';
//
// class PackageDetailsForm extends StatefulWidget {
//   const PackageDetailsForm({Key? key}) : super(key: key);
//
//   @override
//   State<PackageDetailsForm> createState() => _PackageDetailsFormState();
// }
//
// class _PackageDetailsFormState extends State<PackageDetailsForm> {
//   TextEditingController descriptionTextEditingController = TextEditingController();
//
//   final _formKey = GlobalKey<FormState>();
//   String _contentDescription = "";// Make this nullable
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           "Package Details",
//           style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//         ),
//       ),
//       body: SingleChildScrollView(
//         padding: EdgeInsets.all(20.0),
//         child: Form( // Add Form widget to use _formKey
//           key: _formKey,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: [
//               // Text field for description with rounded borders and modern colors
//               TextFormField(
//                 controller: descriptionTextEditingController,
//                 decoration: InputDecoration(
//                   labelText: "Content Description",
//                   contentPadding: EdgeInsets.all(12.0),
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(10.0),
//                     borderSide: BorderSide(
//                       color: Colors.blueGrey[200]!, // Light border color
//                     ),
//                   ),
//                 ),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return "Please enter a brief description";
//                   }
//                   return null;
//                 },
//                 onSaved: (value) => setState(() => _contentDescription = value!),
//               ),
//               SizedBox(height: 20),
//
//               // Primary color button with slightly rounded corners
//               ElevatedButton(
//                 onPressed: () {
//                   if (_formKey.currentState!.validate()) {
//                     _formKey.currentState!.save();
//
//                     // Create PackageDetails with only description
//                     PackageDetails packageDetails = PackageDetails(
//                       contentDescription: _contentDescription ,
//                     );
//
//                     // Call Cargodescription method with the new PackageDetails
//                     Provider.of<AppData>(context, listen: false).Cargodescription(packageDetails);
//
//                     Navigator.pop(context);
//                   }
//                 },
//                 child: Text("Submit Package Details"),
//                 style: ElevatedButton.styleFrom(
//                   foregroundColor: Colors.white,
//                   backgroundColor: Theme.of(context).primaryColor, // Text color
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(10.0),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }



