class FarmerMaster {


  String? farmerId;
  String? farmerCode;
  String? fName;
  String? lName;
  String? samithiCode;
  String? villageId;
  String? villageName;
  String? blockId;
  String? blockName;
  String? procurementBalance;
  String? paymentBalance;
  String? distributionBalance;
  String? farmCount;
  String? cliName;
  String? proName;
  String? fCertType;
  String? certCategory;
  String? certStandard;
  String? inspecType;
  String? ICSstatus;
  String? certCatName;
  String? certStandName;
  String? insTypeName;
  String? ICSstatusName;
  String? principleAmount;
  String? interestAmtAccumulated;
  String? rateOfInterest;
  String? lastInterestCalDate;
  String? proPrincipleAmount;
  String? proInterestAmtAccumulate;
  String? proLastInterestCalDate;
  String? proRateOfInterest;
  String? traceId;
  String? fatherName;
  String? certifiedFarmer;
  String? surName;
  String? utzStatus;
  String? cooperative;
  String? farmerStatus;
  String? icsCode;
  String? icsCodeName;
  String? stateCode;
  String? districtCode;
  String? cityCode;
  String? panCode;
  String? mobileNo;
  String? frPhoto;
  String? idstatus;
  String? pltStatus;
  String? geoStatus;
  String? phoneNo;
  String? ctName;
  String? maritalStatus;
  String? farmerCertStatus_sym;
  String? dead;
  String? Inspection;
  String? trader;
  String? address;
  String? farmerIndicator;

  FarmerMaster(


      this.farmerId,
      this.farmerCode,
      this.fName,
      this.lName,
      this.samithiCode,
      this.villageId,
      this.villageName,
      this.blockId,
      this.blockName,
      this.procurementBalance,
      this.distributionBalance,
      this.farmCount,
      this.cliName,
      this.proName,
      this.fCertType,
      this.certCategory,
      this.certStandard,
      this.inspecType,
      this.ICSstatus,
      this.certCatName,
      this.certStandName,
      this.insTypeName,
      this.ICSstatusName,
      this.principleAmount,
      this.interestAmtAccumulated,
      this.rateOfInterest,
      this.lastInterestCalDate,
      this.proPrincipleAmount,
      this.proInterestAmtAccumulate,
      this.proLastInterestCalDate,
      this.proRateOfInterest,
      this.traceId,
      this.fatherName,
      this.certifiedFarmer,
      this.surName,
      this.utzStatus,
      this.cooperative,
      this.farmerStatus,
      this.icsCode,
      this.icsCodeName,
      this.stateCode,
      this.districtCode,
      this.cityCode,
      this.panCode,
      this.mobileNo,
      this.frPhoto,
      this.idstatus,
      this.pltStatus,
      this.geoStatus,
      this.phoneNo,
      this.ctName,
      this.maritalStatus,
      this.farmerCertStatus_sym,
      this.dead,
      this.Inspection,
      this.trader,
      this.address,
      this.farmerIndicator);

  FarmerMaster.map(dynamic obj) {

    this.farmerId=obj["farmerId"];
    this.farmerCode=obj["farmerCode"];
    this.fName=obj["fName"];
    this.lName=obj["lName"];
    this.samithiCode=obj["samithiCode"];
    this.villageId=obj["villageId"];
    this.villageName=obj["villageName"];
    this.blockId=obj["blockId"];
    this.blockName=obj["blockName"];
    this.procurementBalance=obj["procurementBalance"];
    this.distributionBalance=obj["distributionBalance"];
    this.farmCount=obj["farmCount"];
    this.cliName=obj["cliName"];
    this.proName=obj["proName"];
    this.fCertType=obj["fCertType"];
    this.certCategory=obj["certCategory"];
    this.certStandard=obj["certStandard"];
    this.inspecType=obj["inspecType"];
    this.ICSstatus=obj["ICSstatus"];
    this.certCatName=obj["certCatName"];
    this.certStandName=obj["certStandName"];
    this.insTypeName=obj["insTypeName"];
    this.ICSstatusName=obj["ICSstatusName"];
    this.principleAmount=obj["principleAmount"];
    this.interestAmtAccumulated=obj["interestAmtAccumulated"];
    this.rateOfInterest=obj["rateOfInterest"];
    this.lastInterestCalDate=obj["lastInterestCalDate"];
    this.proPrincipleAmount=obj["proPrincipleAmount"];
    this.proInterestAmtAccumulate=obj["proInterestAmtAccumulate"];
    this.proLastInterestCalDate=obj["proLastInterestCalDate"];
    this.proRateOfInterest=obj["proRateOfInterest"];
    this.traceId=obj["traceId"];
    this.fatherName=obj["fatherName"];
    this.certifiedFarmer=obj["certifiedFarmer"];
    this.surName=obj["surName"];
    this.utzStatus=obj["utzStatus"];
    this.cooperative=obj["cooperative"];
    this.farmerStatus=obj["farmerStatus"];
    this.icsCode=obj["icsCode"];
    this.icsCodeName=obj["icsCodeName"];
    this.stateCode=obj["stateCode"];
    this.districtCode=obj["districtCode"];
    this.cityCode=obj["cityCode"];
    this.panCode=obj["panCode"];
    this.mobileNo=obj["mobileNo"];
    this.frPhoto=obj["frPhoto"];
    this.idstatus=obj["idstatus"];
    this.pltStatus=obj["pltStatus"];
    this.geoStatus=obj["geoStatus"];
    this.phoneNo=obj["phoneNo"];
    this.ctName=obj["ctName"];
    this.maritalStatus=obj["maritalStatus"];
    this.farmerCertStatus_sym=obj["farmerCertStatus_sym"];
    this.dead=obj["dead"];
    this.Inspection=obj["Inspection"];
    this.trader=obj["trader"];
    this.address=obj["address"];
    this.farmerIndicator=obj["farmerIndicator"];
  }



  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();


    map["farmerId"]=farmerId;
    map["farmerCode"]=farmerCode;
    map["fName"]=fName;
    map["lName"]=lName;
    map["samithiCode"]=samithiCode;
    map["villageId"]=villageId;
    map["villageName"]=villageName;
    map["blockId"]=blockId;
    map["blockName"]=blockName;
    map["procurementBalance"]=procurementBalance;
    map["distributionBalance"]=distributionBalance;
    map["farmCount"]=farmCount;
    map["cliName"]=cliName;
    map["proName"]=proName;
    map["fCertType"]=fCertType;
    map["certCategory"]=certCategory;
    map["certStandard"]=certStandard;
    map["inspecType"]=inspecType;
    map["ICSstatus"]=ICSstatus;
    map["certCatName"]=certCatName;
    map["certStandName"]=certStandName;
    map["insTypeName"]=insTypeName;
    map["ICSstatusName"]=ICSstatusName;
    map["principleAmount"]=principleAmount;
    map["interestAmtAccumulated"]=interestAmtAccumulated;
    map["rateOfInterest"]=rateOfInterest;
    map["lastInterestCalDate"]=lastInterestCalDate;
    map["proPrincipleAmount"]=proPrincipleAmount;
    map["proInterestAmtAccumulate"]=proInterestAmtAccumulate;
    map["proLastInterestCalDate"]=proLastInterestCalDate;
    map["proRateOfInterest"]=proRateOfInterest;
    map["traceId"]=traceId;
    map["fatherName"]=fatherName;
    map["certifiedFarmer"]=certifiedFarmer;
    map["surName"]=surName;
    map["utzStatus"]=utzStatus;
    map["cooperative"]=cooperative;
    map["farmerStatus"]=farmerStatus;
    map["icsCode"]=icsCode;
    map["icsCodeName"]=icsCodeName;
    map["stateCode"]=stateCode;
    map["districtCode"]=districtCode;
    map["cityCode"]=cityCode;
    map["panCode"]=panCode;
    map["mobileNo"]=mobileNo;
    map["frPhoto"]=frPhoto;
    map["idstatus"]=idstatus;
    map["pltStatus"]=pltStatus;
    map["geoStatus"]=geoStatus;
    map["phoneNo"]=phoneNo;
    map["ctName"]=ctName;
    map["maritalStatus"]=maritalStatus;
    map["farmerCertStatus_sym"]=farmerCertStatus_sym;
    map["dead"]=dead;
    map["Inspection"]=Inspection;
    map["trader"]=trader;
    map["address"]=address;
    map["farmerIndicator"]=farmerIndicator;

    return map;
  }

}
