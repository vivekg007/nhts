class CroplistValues {
  Response? response;

  CroplistValues({this.response});

  factory CroplistValues.fromJson(Map<String, dynamic> json) {
    return CroplistValues(
      response:
          json['response'] != null ? Response.fromJson(json['response']) :null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.response != '') {
      data['response'] = this.response!.toJson();
    }
    return data;
  }
}

class Response {
  Body? body;
  Status? status;

  Response({this.body, this.status});

  factory Response.fromJson(Map<String, dynamic> json) {
    return Response(
      body: json['body'] != null? Body.fromJson(json['body']) : null,
      status: json['status'] != null? Status.fromJson(json['status']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.body != '') {
      data['body'] = this.body!.toJson();
    }
    if (this.status != '') {
      data['status'] = this.status!.toJson();
    }
    return data;
  }
}

class Body {
  List<Crop>? cropList;
  int? fCropRevNo;

  Body({this.cropList, this.fCropRevNo});

  factory Body.fromJson(Map<String, dynamic> json) {
    return Body(
      cropList: json['cropList'] != null
          ? (json['cropList'] as List).map((i) => Crop.fromJson(i)).toList()
          : null,
      fCropRevNo: json['fCropRevNo'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['fCropRevNo'] = this.fCropRevNo;
    if (this.cropList != '') {
      data['cropList'] = this.cropList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Crop {
  int? cc;
  String? cropId;
  int? cropStatus;
  int? crpEdtSt;
  String? cs;
  String? cultArea;
  String? cultTyp;
  String? estHarvDt;
  String? farmCodeRef;
  String? farmId;
  String? farmerCodeRef2;
  String? farmerId;
  String? fcode;
  int? fcropId;
  String? interAcres;
  String? interCropharvest;
  String? interGrossIncm;
  String? interType;
  String? othSeedTreat;
  String? pYear;
  String? riskAsses;
  String? riskBuf;
  int? sdCost;
  String? sdSur;
  int? sdUsd;
  String? seedTreat;
  String? sowDt;
  String? staLen;
  String? type;

  Crop(
      {this.cc,
      this.cropId,
      this.cropStatus,
      this.crpEdtSt,
      this.cs,
      this.cultArea,
      this.cultTyp,
      this.estHarvDt,
      this.farmCodeRef,
      this.farmId,
      this.farmerCodeRef2,
      this.farmerId,
      this.fcode,
      this.fcropId,
      this.interAcres,
      this.interCropharvest,
      this.interGrossIncm,
      this.interType,
      this.othSeedTreat,
      this.pYear,
      this.riskAsses,
      this.riskBuf,
      this.sdCost,
      this.sdSur,
      this.sdUsd,
      this.seedTreat,
      this.sowDt,
      this.staLen,
      this.type});

  factory Crop.fromJson(Map<String, dynamic> json) {
    return Crop(
      cc: json['cc'],
      cropId: json['cropId'],
      cropStatus: json['cropStatus'],
      crpEdtSt: json['crpEdtSt'],
      cs: json['cs'],
      cultArea: json['cultArea'],
      cultTyp: json['cultTyp'],
      estHarvDt: json['estHarvDt'],
      farmCodeRef: json['farmCodeRef'],
      farmId: json['farmId'],
      farmerCodeRef2: json['farmerCodeRef2'],
      farmerId: json['farmerId'],
      fcode: json['fcode'],
      fcropId: json['fcropId'],
      interAcres: json['interAcres'],
      interCropharvest: json['interCropharvest'],
      interGrossIncm: json['interGrossIncm'],
      interType: json['interType'],
      othSeedTreat: json['othSeedTreat'],
      pYear: json['pYear'].toString(),
      riskAsses: json['riskAsses'],
      riskBuf: json['riskBuf'],
      sdCost: json['sdCost'],
      sdSur: json['sdSur'],
      sdUsd: json['sdUsd'],
      seedTreat: json['seedTreat'],
      sowDt: json['sowDt'],
      staLen: json['staLen'],
      type: json['type'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['cc'] = this.cc;
    data['cropId'] = this.cropId;
    data['cropStatus'] = this.cropStatus;
    data['crpEdtSt'] = this.crpEdtSt;
    data['cs'] = this.cs;
    data['cultArea'] = this.cultArea;
    data['cultTyp'] = this.cultTyp;
    data['estHarvDt'] = this.estHarvDt;
    data['farmCodeRef'] = this.farmCodeRef;
    data['farmId'] = this.farmId;
    data['farmerCodeRef2'] = this.farmerCodeRef2;
    data['farmerId'] = this.farmerId;
    data['fcode'] = this.fcode;
    data['fcropId'] = this.fcropId;
    data['interAcres'] = this.interAcres;
    data['interCropharvest'] = this.interCropharvest;
    data['interGrossIncm'] = this.interGrossIncm;
    data['interType'] = this.interType;
    data['othSeedTreat'] = this.othSeedTreat;
    data['pYear'] = this.pYear;
    data['riskAsses'] = this.riskAsses;
    data['riskBuf'] = this.riskBuf;
    data['sdCost'] = this.sdCost;
    data['sdSur'] = this.sdSur;
    data['sdUsd'] = this.sdUsd;
    data['seedTreat'] = this.seedTreat;
    data['sowDt'] = this.sowDt;
    data['staLen'] = this.staLen;
    data['type'] = this.type;
    return data;
  }
}

class Status {
  String? code;
  String? message;

  Status({this.code, this.message});

  factory Status.fromJson(Map<String, dynamic> json) {
    return Status(
      code: json['code'],
      message: json['message'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['message'] = this.message;
    return data;
  }
}
