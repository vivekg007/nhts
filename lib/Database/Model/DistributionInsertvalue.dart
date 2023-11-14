class DistributionInsertvalue{
  String pmtAmt;
  String samCode;
  String season;
  String city;
  String wareHouseCode;
  String distributionId;
  String recpNo;
  String val_Farmermobile;
  String village;
  String valfarmerName;
  String distributionDate;
  int isSynched;
  String isReg;
  String valmobilenumber;
  String freeDistribution;
  String tax;
  String paymentMode;
  String farmerCode;
  String latitude;
  String longitude;
  String photo1;
  String photo2;

  DistributionInsertvalue(
      this.pmtAmt,
      this.samCode,
      this.season,
      this.city,
      this.wareHouseCode,
      this.distributionId,
      this.recpNo,
      this.val_Farmermobile,
      this.village,
      this.valfarmerName,
      this.distributionDate,
      this.isSynched,
      this.isReg,
      this.valmobilenumber,
      this.freeDistribution,
      this.tax,
      this.paymentMode,
      this.farmerCode,
      this.latitude,
      this.longitude,
      this.photo1,
      this.photo2);

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map["pmtAmt"] = pmtAmt;
    map["samCode"] = samCode;
    map["season"] = season;
    map["city"] = city;
    map["wareHouseCode"] = wareHouseCode;
    map["distributionId"] = distributionId;
    map["recpNo"] = recpNo;
    map["farmerId"] = val_Farmermobile;
    map["village"] = village;
    map["farmerName"] = valfarmerName;
    map["distributionDate"] = distributionDate;
    map["isSynched"] = isSynched;
    map["isReg"] = isReg;
    map["mobileNo"] = valmobilenumber;
    map["freeDistribution"] = freeDistribution;
    map["tax"] = tax;
    map["paymentMode"] = paymentMode;
    map["farmerCode"] = farmerCode;
    map["latitude"] = latitude;
    map["longitude"] = longitude;
    map["photo1"] = photo1;
    map["photo2"] = photo2;
    return map;
  }
}