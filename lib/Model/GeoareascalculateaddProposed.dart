class GeoareascalculateaddProposed {
  String Acre;
  String Hectare;
  String Squaremeters;

  GeoareascalculateaddProposed(this.Acre, this.Hectare, this.Squaremeters);

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map["Acre"] = Acre;
    map["Hectare"] = Hectare;
    map["Squaremeters"] = Squaremeters;
    return map;
  }
}
