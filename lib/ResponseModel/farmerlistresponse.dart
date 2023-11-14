class farmerlistresponsemodel {
  Response? response;

  farmerlistresponsemodel({this.response});

  factory farmerlistresponsemodel.fromJson(Map<String, dynamic> json) {
    return farmerlistresponsemodel(
      response:
          json['Response'] != null ? Response.fromJson(json['Response']) : null,
    );
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
  Body? body;
  Status? status;

  Response({this.body, this.status});

  factory Response.fromJson(Map<String, dynamic> json) {
    return Response(
      body: json['body'] != null ? Body.fromJson(json['body']) : null,
      status: json['status'] != null ? Status.fromJson(json['status']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.body != null) {
      data['body'] = this.body!.toJson();
    }
    if (this.status != null) {
      data['status'] = this.status!.toJson();
    }
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

class Body {
  List<Farmer>? farmerList;
  String? revNo;

  Body({this.farmerList, this.revNo});

  factory Body.fromJson(Map<String, dynamic> json) {
    return Body(
      farmerList: json['farmerList'] != null
          ? (json['farmerList'] as List).map((i) => Farmer.fromJson(i)).toList()
          : null,
      revNo: json['revNo'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['revNo'] = this.revNo;
    if (this.farmerList != null) {
      data['farmerList'] = this.farmerList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Farmer {
  String? otName;
  String? faddress;
  String? firstname;
  String? districtCode;
  String? idType;
  String? gender;
  String? fMobNo;
  String? approval;
  String? memOfOrg;
  String? NationalId;
  List<Samithi>? samithis;
  String? farmerCode;
  String? landOwnAdd;
  String? farmerId;
  String? dob;
  String? landOwnName;
  String? village;
  String? age;
  String? email;
  String? status;
  String? landType;
  String? farmCode;

  Farmer(
      {this.otName,
      this.faddress,
      this.firstname,
      this.districtCode,
      this.idType,
      this.gender,
      this.fMobNo,
      this.approval,
      this.memOfOrg,
      this.NationalId,
      this.samithis,
      this.farmerCode,
      this.landOwnAdd,
      this.farmerId,
      this.dob,
      this.landOwnName,
      this.village,
      this.age,
      this.email,
      this.status,
      this.landType,this.farmCode});

  factory Farmer.fromJson(Map<String, dynamic> json) {
    return Farmer(
        age: json['age'],
        approval: json['approval'],
        districtCode: json['districtCode'],
        dob: json['dob'],
        email: json['email'],
        fMobNo: json['fMobNo'],
        faddress: json['faddress'],
        farmerCode: json['farmerCode'],
        farmerId: json['farmerId'],
        firstname: json['firstname'],
        gender: json['gender'],
        idType: json['idType'],
        landOwnAdd: json['landOwnAdd'],
        landOwnName: json['landOwnName'],
        memOfOrg: json['memOfOrg'],
        NationalId: json['NationalId'],
        otName: json['otName'],
        samithis: json['samithis'] != null
            ? (json['samithis'] as List)
                .map((i) => Samithi.fromJson(i))
                .toList()
            : null,
        status: json['status'],
        village: json['village'],
        landType: json['landType'],
    farmCode: json['farmCode']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['age'] = this.age;
    data['approval'] = this.approval;
    data['districtCode'] = this.districtCode;
    data['dob'] = this.dob;
    data['email'] = this.email;
    data['fMobNo'] = this.fMobNo;
    data['faddress'] = this.faddress;
    data['farmerCode'] = this.farmerCode;
    data['farmerId'] = this.farmerId;
    data['firstname'] = this.firstname;
    data['gender'] = this.gender;
    data['idType'] = this.idType;
    data['landOwnAdd'] = this.landOwnAdd;
    data['landOwnName'] = this.landOwnName;
    data['memOfOrg'] = this.memOfOrg;
    data['NationalId'] = this.NationalId;
    data['otName'] = this.otName;
    data['status'] = this.status;
    data['village'] = this.village;
    data['landType'] = this.landType;
    data['farmCode'] = this.farmCode;
    if (this.samithis != null) {
      data['samithis'] = this.samithis!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Samithi {
  String? samCode;
  String? samName;

  Samithi({this.samCode, this.samName});

  factory Samithi.fromJson(Map<String, dynamic> json) {
    return Samithi(
      samCode: json['samCode'],
      samName: json['samName'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['samCode'] = this.samCode;
    data['samName'] = this.samName;
    return data;
  }
}
