class SowinginsertModel{
  String cropCategory;
  String cropSeason;
  String farmcrpIDT;
  String cropCode;
  String farmerId;
  String farmcodeRef;
  String cropArea;
  String production;
  String cropVariety;
  String seedSource;
  int _ID;
  String stableLengthMain;
  String seedusedMain;
  String seedcostMain;
  String interCropType;
  String interCropAcr;
  String interCropHarvest;
  String interCropGrossIncome;
  String cropType;
  String seedCost;
  String seedTreatment;
  String otherSeedTreatment;
  String dateOfSown;
  String riskBufferZone;
  String riskAssesment;
  String estHarvestDt;
  String cultivationType;
  String cultivationArea;
  String cropStatus;
  String cropEditStatus;

  SowinginsertModel(
      this.cropCategory,
      this.cropSeason,
      this.farmcrpIDT,
      this.cropCode,
      this.farmerId,
      this.farmcodeRef,
      this.cropArea,
      this.production,
      this.cropVariety,
      this.seedSource,
      this._ID,
      this.stableLengthMain,
      this.seedusedMain,
      this.seedcostMain,
      this.interCropType,
      this.interCropAcr,
      this.interCropHarvest,
      this.interCropGrossIncome,
      this.cropType,
      this.seedCost,
      this.seedTreatment,
      this.otherSeedTreatment,
      this.dateOfSown,
      this.riskBufferZone,
      this.riskAssesment,
      this.estHarvestDt,
      this.cultivationType,
      this.cultivationArea,
      this.cropStatus,
      this.cropEditStatus);

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map["cropCategory"]= cropCategory;
    map["cropSeason"]= cropSeason;
    map["farmcrpIDT"]= farmcrpIDT;
    map["cropCode"]= cropCode;
    map["farmerId"]= farmerId;
    map["farmcodeRef"]= farmcodeRef;
    map["cropArea"]= cropArea;
    map["production"]= production;
    map["cropVariety"]= cropVariety;
    map["seedSource"]= seedSource;
    map["_ID"]= _ID;
    map["stableLengthMain"]= stableLengthMain;
    map["seedusedMain"]= seedusedMain;
    map["seedcostMain"]= seedcostMain;
    map["interCropType"]= interCropType;
    map["interCropAcr"]= interCropAcr;
    map["interCropHarvest"]= interCropHarvest;
    map["interCropGrossIncome"]= interCropGrossIncome;
    map["cropType"]= cropType;
    map["seedCost"]= seedCost;
    map["seedTreatment"]= seedTreatment;
    map["otherSeedTreatment"]= otherSeedTreatment;
    map["dateOfSown"]= dateOfSown;
    map["riskBufferZone"]= riskBufferZone;
    map["riskAssesment"]= riskAssesment;
    map["estHarvestDt"]= estHarvestDt;
    map["cultivationType"]= cultivationType;
    map["cultivationArea"]= cultivationArea;
    map["cropStatus"]= cropStatus;
    map["cropEditStatus"]= cropEditStatus;
    return map;
  }
  }