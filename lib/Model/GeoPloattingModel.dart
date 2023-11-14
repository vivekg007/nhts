class GeoPloattingModel {
  String latitude;
  String longitude;
  String state;
  int orderOfGps;

  GeoPloattingModel(this.latitude, this.longitude, this.state, this.orderOfGps);

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map["Latitude"] = latitude;
    map["Longitude"] = longitude;
    map["State"] = state;
    map["OrderofGps"] = orderOfGps.toString();
    return map;
  }
}
