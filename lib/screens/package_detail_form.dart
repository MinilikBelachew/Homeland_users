import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data_handler/app_data.dart';
import '../models/package_detail.dart';

class PackageDetailsForm extends StatefulWidget {


  const PackageDetailsForm({Key? key, })
      : super(key: key);

  @override
  State<PackageDetailsForm> createState() => _PackageDetailsFormState();
}

class _PackageDetailsFormState extends State<PackageDetailsForm> {
  TextEditingController weightTextEditingController = TextEditingController();
  TextEditingController descriptionTextEditingController =
  TextEditingController();

  final _formKey = GlobalKey<FormState>();
  double _weight = 0.0;
  String _contentDescription = "";

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Title with some spacing
              Text(
                "Package Details",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),

              // TextFields with rounded borders and some padding
              TextFormField(
                controller: weightTextEditingController,
                decoration: InputDecoration(
                  labelText: "Weight (kg)",
                  contentPadding: EdgeInsets.all(12.0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || double.tryParse(value) == null) {
                    return "Please enter a valid weight";
                  }
                  return null;
                },
                onSaved: (value) =>
                    setState(() => _weight = double.parse(value!)),
              ),
              SizedBox(height: 20),

              TextFormField(
                controller: descriptionTextEditingController,
                decoration: InputDecoration(
                  labelText: "Content Description",
                  contentPadding: EdgeInsets.all(12.0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Please enter a brief description";
                  }
                  return null;
                },
                onSaved: (value) =>
                    setState(() => _contentDescription = value!),
              ),
              SizedBox(height: 20),

              // Primary color button
              ElevatedButton(
                onPressed: ()
                {


                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();

                    // Save weight and description separately
                    PackageDetails packageDetails = PackageDetails(
                      weight: _weight,
                      contentDescription: _contentDescription,
                    );

                    // Call cargo and Cargodescription methods with the appropriate values
                    Provider.of<AppData>(context, listen: false).cargo(packageDetails);
                    Provider.of<AppData>(context, listen: false).Cargodescription(packageDetails);

                    Navigator.pop(context);
                  }
                },


                child: Text("Submit Package Details"),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Theme.of(context).primaryColor, // Text color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
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
