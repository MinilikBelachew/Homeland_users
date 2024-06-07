class PackageDetails {

  //final double weight;
  final String contentDescription;

  PackageDetails({

    //required this.weight,
    required this.contentDescription,
  });



  // String get formattedWeight {
  //   return "${weight.toStringAsFixed(2)} kg";
  // }

  @override
  String toString() {
    return 'PackageDetails( contentDescription: "$contentDescription")';
  }
}
