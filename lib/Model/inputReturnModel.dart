class inputReturnsModel{
  String farmerId;
  String returnId;
  String returnDate;
  String samCode;
  String season;
  String village;
  String photo1;
  String photo2;
  String isSynched;

  inputReturnsModel(
  this.farmerId,
  this.returnId,
  this.returnDate,
  this.samCode,
  this.season,
  this.village,
  this.photo1,
  this.photo2,
  this.isSynched
  );
  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map["farmerId"]=farmerId;
    map["returnId"]=returnId;
    map["returnDate"]=returnDate;
    map["samCode"]=samCode;
    map["season"]=season;
    map["village"]=village;
    map["photo1"]=photo1;
    map["photo2"]=photo2;
    map["isSynched"]=isSynched;
    return map;
  }
}
