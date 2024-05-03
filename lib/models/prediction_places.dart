class PlacePredication {
  String? secondery_text;
  String? main_text;
  String? place_id;

  PlacePredication({
   this.place_id,
    this.secondery_text,
    this.main_text
});

  PlacePredication.fromJson(Map<String,dynamic> json)
  {
    place_id=json["place_id"];
    main_text=json["structured_formatting"]["main_text"];
    secondery_text=json["structured_formatting"]["secondary_text"];
  }

}