class FarmResponseModel {
  Response? response;

  FarmResponseModel({this.response});

  FarmResponseModel.fromJson(Map<String, dynamic> json) {
    response = json['Response'] != null
        ? new Response.fromJson(json['Response'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.response != null) {
      data['response'] = this.response!.toJson();
    }
    return data;
  }
}

class Response {
  Status? status;
  Body? body;

  Response({this.status, this.body});

  Response.fromJson(Map<String, dynamic> json) {
    status =
        json['status'] != null ? new Status.fromJson(json['status']) : null;
    body = json['body'] != null ? new Body.fromJson(json['body']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.status != null) {
      data['status'] = this.status!.toJson();
    }
    if (this.body != null) {
      data['body'] = this.body!.toJson();
    }
    return data;
  }
}

class Status {
  String? code;
  String? message;

  Status({this.code, this.message});

  Status.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['message'] = this.message;
    return data;
  }
}

class Body {
  List<FarmList>? farmList;
  String? farmRevNo;

  Body({this.farmList, this.farmRevNo});

  Body.fromJson(Map<String, dynamic> json) {
    if (json['farmList'] != null) {
      farmList = <FarmList>[];
      json['farmList'].forEach((v) {
        farmList!.add(new FarmList.fromJson(v));
      });
    }
    farmRevNo = json['farmRevNo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.farmList != null) {
      data['farmList'] = this.farmList!.map((v) => v.toJson()).toList();
    }
    data['farmRevNo'] = this.farmRevNo;
    return data;
  }
}

class FarmList {
  String? farmName;
  String? typTreeShade;
  String? unProdTree;
  String? dca;
  String? approval;
  String? avTreeAge;
  String? prodTree;
  String? fLon;
  String? coffeeType;
  String? farmerId;
  String? spacing;
  String? tca;
  String? yeildEstTree;
  String? fLat;
  String? treeShade;
  String? farmStatus;
  String? coffeeVariety;
  String? auditArea;
  String? farmCode;
  String? totNoTrees;

  FarmList(
      {this.farmName,
      this.typTreeShade,
      this.unProdTree,
      this.dca,
      this.approval,
      this.avTreeAge,
      this.prodTree,
      this.fLon,
      this.coffeeType,
      this.farmerId,
      this.spacing,
      this.tca,
      this.yeildEstTree,
      this.fLat,
      this.treeShade,
      this.farmStatus,
      this.coffeeVariety,
      this.auditArea,
      this.farmCode,
      this.totNoTrees});

  FarmList.fromJson(Map<String, dynamic> json) {
    farmName = json['farmName'];
    typTreeShade = json['typTreeShade'];
    unProdTree = json['unProdTree'];
    dca = json['dca'];
    approval = json['approval'];
    avTreeAge = json['avTreeAge'];
    prodTree = json['prodTree'];
    fLon = json['fLon'];
    coffeeType = json['coffeeType'];
    farmerId = json['farmerId'];
    spacing = json['spacing'];
    tca = json['tca'];
    yeildEstTree = json['yeildEstTree'];
    fLat = json['fLat'];
    treeShade = json['treeShade'];
    farmStatus = json['farmStatus'];
    coffeeVariety = json['coffeeVariety'];
    auditArea = json['auditArea'];
    farmCode = json['farmCode'];
    totNoTrees = json['totNoTrees'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['approval'] = this.approval;
    data['auditArea'] = this.auditArea;
    data['avTreeAge'] = this.avTreeAge;
    data['coffeeType'] = this.coffeeType;
    data['coffeeVariety'] = this.coffeeVariety;
    data['dca'] = this.dca;
    data['fLat'] = this.fLat;
    data['fLon'] = this.fLon;
    data['farmCode'] = this.farmCode;
    data['farmName'] = this.farmName;
    data['farmStatus'] = this.farmStatus;
    data['farmerId'] = this.farmerId;
    data['prodTree'] = this.prodTree;
    data['spacing'] = this.spacing;
    data['tca'] = this.tca;
    data['treeShade'] = this.treeShade;
    data['typTreeShade'] = this.typTreeShade;
    data['unProdTree'] = this.unProdTree;
    data['yeildEstTree'] = this.yeildEstTree;
    data['totNoTrees'] = this.totNoTrees;
    return data;
  }
}
