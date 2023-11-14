class Download322 {
  Response? response;

  Download322({this.response});

  factory Download322.fromJson(Map<String, dynamic> json) {
    return Download322(
      response:
          json['Response'] != null ? Response.fromJson(json['Response']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.response != null) {
      data['Response'] = this.response!.toJson();
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

class Body {
  AgentLogin? agentLogin;
  Data1? data1;
  Data10? data10;
  Data2? data2;
  Data6? data6;
  Data8? data8;
  Data9? data9;
  Data11? data11;

  Body(
      {this.agentLogin,
      this.data1,
      this.data10,
      this.data2,
      this.data6,
      this.data8,
      this.data9,
      this.data11});

  factory Body.fromJson(Map<String, dynamic> json) {
    return Body(
      agentLogin: json['agentLogin'] != null
          ? AgentLogin.fromJson(json['agentLogin'])
          : null,
      data1: json['data1'] != null ? Data1.fromJson(json['data1']) : null,
      data10: json['data10'] != null ? Data10.fromJson(json['data10']) : null,
      data2: json['data2'] != null ? Data2.fromJson(json['data2']) : null,
      data6: json['data6'] != null ? Data6.fromJson(json['data6']) : null,
      data8: json['data8'] != null ? Data8.fromJson(json['data8']) : null,
      data9: json['data9'] != null ? Data9.fromJson(json['data9']) : null,
      data11: json['data11'] != null ? Data11.fromJson(json['data11']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.agentLogin != null) {
      data['agentLogin'] = this.agentLogin!.toJson();
    }
    if (this.data1 != null) {
      data['data1'] = this.data1!.toJson();
    }
    if (this.data10 != null) {
      data['data10'] = this.data10!.toJson();
    }
    if (this.data2 != null) {
      data['data2'] = this.data2!.toJson();
    }
    if (this.data6 != null) {
      data['data6'] = this.data6!.toJson();
    }
    if (this.data8 != null) {
      data['data8'] = this.data8!.toJson();
    }
    if (this.data9 != null) {
      data['data9'] = this.data9!.toJson();
    }
    if (this.data11 != null) {
      data['data11'] = this.data11!.toJson();
    }
    return data;
  }
}

class Data6 {
  String? procProdRevNo;
  List<Product>? products;

  Data6({this.procProdRevNo, this.products});

  factory Data6.fromJson(Map<String, dynamic> json) {
    return Data6(
      procProdRevNo: json['procProdRevNo'],
      products: json['products'] != null
          ? (json['products'] as List).map((i) => Product.fromJson(i)).toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['procProdRevNo'] = this.procProdRevNo;
    if (this.products != null) {
      data['products'] = this.products!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Product {
  String? ppCode;
  String? ppName;
  String? ppUnit;
  List<VrtLst>? vrtLst;

  Product({this.ppCode, this.ppName, this.ppUnit, this.vrtLst});

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      ppCode: json['ppCode'],
      ppName: json['ppName'],
      ppUnit: json['ppUnit'],
      vrtLst: json['vrtLst'] != null
          ? (json['vrtLst'] as List).map((i) => VrtLst.fromJson(i)).toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ppCode'] = this.ppCode;
    data['ppName'] = this.ppName;
    data['ppUnit'] = this.ppUnit;
    if (this.vrtLst != null) {
      data['vrtLst'] = this.vrtLst!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class VrtLst {
  List<GrdLst>? grdLst;
  List<Object>? lang;
  String? ppVarCode;
  String? ppVarName;
  List<SubvarLst>? subvarLst;

  VrtLst(
      {this.grdLst, this.lang, this.ppVarCode, this.ppVarName, this.subvarLst});

  factory VrtLst.fromJson(Map<String, dynamic> json) {
    return VrtLst(
      grdLst: json['grdLst'] != null
          ? (json['grdLst'] as List).map((i) => GrdLst.fromJson(i)).toList()
          : null,
      // lang: json['lang'] != null
      //     ? (json['lang'] as List).map((i) => LangXXX.fromJson(i)).toList()
      //     : null,
      ppVarCode: json['ppVarCode'],
      ppVarName: json['ppVarName'],
      subvarLst: json['subvarLst'] != null
          ? (json['subvarLst'] as List)
              .map((i) => SubvarLst.fromJson(i))
              .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ppVarCode'] = this.ppVarCode;
    data['ppVarName'] = this.ppVarName;
    if (this.grdLst != null) {
      data['grdLst'] = this.grdLst!.map((v) => v.toJson()).toList();
    }
    if (this.subvarLst != null) {
      data['vrtLst'] = this.subvarLst!.map((v) => v.toJson()).toList();
    }
    // if (this.lang != null) {
    //   data['lang'] = this.lang!.map((v) => v.toJson()).toList();
    // }
    return data;
  }
}

class GrdLst {
  List<Object>? lang;
  String? ppGraCode;
  String? ppGraName;
  String? ppGraPrice;

  GrdLst({this.lang, this.ppGraCode, this.ppGraName, this.ppGraPrice});

  factory GrdLst.fromJson(Map<String, dynamic> json) {
    return GrdLst(
      // lang: json['lang'] != null
      //     ? (json['lang'] as List).map((i) => LangXXX.fromJson(i)).toList()
      //     : null,
      ppGraCode: json['ppGraCode'],
      ppGraName: json['ppGraName'],
      ppGraPrice: json['ppGraPrice'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ppGraCode'] = this.ppGraCode;
    data['ppGraName'] = this.ppGraName;
    data['ppGraPrice'] = this.ppGraPrice;
    // if (this.lang != null) {
    //   data['lang'] = this.lang!.map((v) => v.toJson()).toList();
    // }
    return data;
  }
}

class SubvarLst {
  List<Object>? lang;
  String? ppSubVarCode;
  String? ppSubVarName;
  String? ppSubVarPrice;

  SubvarLst(
      {this.lang, this.ppSubVarCode, this.ppSubVarName, this.ppSubVarPrice});

  factory SubvarLst.fromJson(Map<String, dynamic> json) {
    return SubvarLst(
      // lang: json['lang'] != null
      //     ? (json['lang'] as List).map((i) => LangXXX.fromJson(i)).toList()
      //     : null,
      ppSubVarCode: json['ppSubVarCode'],
      ppSubVarName: json['ppSubVarName'],
      ppSubVarPrice: json['ppSubVarPrice'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ppSubVarCode'] = this.ppSubVarCode;
    data['ppSubVarName'] = this.ppSubVarName;
    data['ppSubVarPrice'] = this.ppSubVarPrice;
    // if (this.lang != null) {
    //   data['lang'] = this.lang!.map((v) => v.toJson()).toList();
    // }
    return data;
  }
}

class Data10 {
  List<BatchCreation>? batchCreationList;
  List<InputDemand>? inputDemandList;
  List<Transfer>? transferList;
  List<NurRegData>? nurRegListData;
  List<Purchase>? purchaseList;
  List<VcaRegData>? vcaRegListData;
  List<VcaData>? vcaData;
  List<InspReqData>? inspReqData;
  List<Reception>? receptionList;
  List<nurseryReg>? NurseryReg;
  // List<Stock> stocks;

  String? vwsRevNo;

  Data10(
      {this.inputDemandList,
      this.nurRegListData,
      this.purchaseList,
      this.vwsRevNo,
      this.transferList,
      this.vcaRegListData,
      this.vcaData,
      this.inspReqData,
      this.batchCreationList,
      this.receptionList,
      this.NurseryReg});

  factory Data10.fromJson(Map<String, dynamic> json) {
    return Data10(
      batchCreationList: json['batchCreationList'] != null
          ? (json['batchCreationList'] as List)
              .map((i) => BatchCreation.fromJson(i))
              .toList()
          : null,
      inputDemandList: json['inputDemandList'] != null
          ? (json['inputDemandList'] as List)
              .map((i) => InputDemand.fromJson(i))
              .toList()
          : null,
      nurRegListData: json['nurRegListData'] != null
          ? (json['nurRegListData'] as List)
              .map((i) => NurRegData.fromJson(i))
              .toList()
          : null,
      purchaseList: json['purchaseList'] != null
          ? (json['purchaseList'] as List)
              .map((i) => Purchase.fromJson(i))
              .toList()
          : null,
      receptionList: json['receptionList'] != null
          ? (json['receptionList'] as List)
              .map((i) => Reception.fromJson(i))
              .toList()
          : null,
      transferList: json['transferList'] != null
          ? (json['transferList'] as List)
              .map((i) => Transfer.fromJson(i))
              .toList()
          : null,
      vcaRegListData: json['vcaRegListData'] != null
          ? (json['vcaRegListData'] as List)
              .map((i) => VcaRegData.fromJson(i))
              .toList()
          : null,
      vcaData: json['vcaData'] != null
          ? (json['vcaData'] as List).map((i) => VcaData.fromJson(i)).toList()
          : null,
      inspReqData: json['inspReqData'] != null
          ? (json['inspReqData'] as List)
              .map((i) => InspReqData.fromJson(i))
              .toList()
          : null,
      NurseryReg: json['NurseryReg'] != null
          ? (json['NurseryReg'] as List)
              .map((i) => nurseryReg.fromJson(i))
              .toList()
          : null,
      vwsRevNo: json['vwsRevNo'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['vwsRevNo'] = this.vwsRevNo;
    if (this.inputDemandList != null) {
      data['inputDemandList'] =
          this.inputDemandList!.map((v) => v.toJson()).toList();
    }
    if (this.nurRegListData != null) {
      data['nurRegListData'] =
          this.nurRegListData!.map((v) => v.toJson()).toList();
    }
    if (this.purchaseList != null) {
      data['purchaseList'] = this.purchaseList!.map((v) => v.toJson()).toList();
    }
    if (this.inspReqData != null) {
      data['inspReqData'] = this.inspReqData!.map((v) => v.toJson()).toList();
    }

    if (this.vcaRegListData != null) {
      data['vcaRegListData'] =
          this.vcaRegListData!.map((v) => v.toJson()).toList();
    }
    if (this.vcaData != null) {
      data['vcaData'] = this.vcaData!.map((v) => v.toJson()).toList();
    }

    if (this.NurseryReg != null) {
      data['NurseryReg'] = this.NurseryReg!.map((v) => v.toJson()).toList();
    }

    return data;
  }
}

class nurseryReg {
  String? address;
  String? appliType;
  String? city;
  String? district;
  String? fullName;
  String? mail;
  String? mobileNum;
  String? nurId;
  String? opName;
  String? state;
  String? village;

  nurseryReg(
      {this.address,
      this.appliType,
      this.city,
      this.district,
      this.fullName,
      this.mail,
      this.mobileNum,
      this.nurId,
      this.opName,
      this.state,
      this.village});

  factory nurseryReg.fromJson(Map<String, dynamic> json) {
    return nurseryReg(
      address: json['address'],
      appliType: json['appliType'],
      city: json['city'],
      district: json['district'],
      fullName: json['fullName'],
      mail: json['mail'],
      mobileNum: json['mobileNum'],
      nurId: json['nurId'],
      opName: json['opName'],
      state: json['state'],
      village: json['village'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['address'] = this.address;
    data['appliType'] = this.appliType;
    data['city'] = this.city;
    data['district'] = this.district;
    data['fullName'] = this.fullName;
    data['mail'] = this.mail;
    data['mobileNum'] = this.mobileNum;
    data['nurId'] = this.nurId;
    data['opName'] = this.opName;
    data['state'] = this.state;
    data['village'] = this.village;
    return data;
  }
}

class Reception {
  String? agentId;
  String? bagsReceived;
  String? bagsTransferred;
  String? coffeeType;
  String? coffeeVariety;
  String? driverName;
  String? farm;
  String? farmerCode;
  String? grade;
  String? processType;
  String? purchaseReceiptNo;
  String? seasonCode;
  String? stockType;
  String? transferDate;
  String? transferReceiptNo;
  String? vehicleNo;
  String? weightReceived;
  String? weightTransferred;
  String? farmName;
  String? farmerName;

  Reception(
      {this.agentId,
      this.bagsReceived,
      this.bagsTransferred,
      this.coffeeType,
      this.coffeeVariety,
      this.driverName,
      this.farm,
      this.farmerCode,
      this.grade,
      this.processType,
      this.purchaseReceiptNo,
      this.seasonCode,
      this.stockType,
      this.transferDate,
      this.transferReceiptNo,
      this.vehicleNo,
      this.weightReceived,
      this.weightTransferred,
      this.farmerName,
      this.farmName});

  factory Reception.fromJson(Map<String, dynamic> json) {
    return Reception(
        agentId: json['agentId'],
        bagsReceived: json['bagsReceived'],
        bagsTransferred: json['bagsTransferred'],
        coffeeType: json['coffeeType'],
        coffeeVariety: json['coffeeVariety'],
        driverName: json['driverName'],
        farm: json['farm'],
        farmerCode: json['farmerCode'],
        grade: json['grade'],
        processType: json['processType'],
        purchaseReceiptNo: json['purchaseReceiptNo'],
        seasonCode: json['seasonCode'],
        stockType: json['stockType'],
        transferDate: json['transferDate'],
        transferReceiptNo: json['transferReceiptNo'],
        vehicleNo: json['vehicleNo'],
        weightReceived: json['weightReceived'],
        weightTransferred: json['weightTransferred'],
        farmerName: json['farmerName'],
        farmName: json['farmName']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['agentId'] = this.agentId;
    data['bagsReceived'] = this.bagsReceived;
    data['bagsTransferred'] = this.bagsTransferred;
    data['coffeeType'] = this.coffeeType;
    data['coffeeVariety'] = this.coffeeVariety;
    data['driverName'] = this.driverName;
    data['farm'] = this.farm;
    data['farmerCode'] = this.farmerCode;
    data['grade'] = this.grade;
    data['processType'] = this.processType;
    data['purchaseReceiptNo'] = this.purchaseReceiptNo;
    data['seasonCode'] = this.seasonCode;
    data['stockType'] = this.stockType;
    data['transferDate'] = this.transferDate;
    data['transferReceiptNo'] = this.transferReceiptNo;
    data['vehicleNo'] = this.vehicleNo;
    data['weightReceived'] = this.weightReceived;
    data['weightTransferred'] = this.weightTransferred;
    data['farmerName'] = this.farmerName;
    data['farmName'] = this.farmName;
    return data;
  }
}

class BatchCreation {
  String? batchNo;
  String? grade;
  String? noOfBag;
  String? stockType;
  String? weight;
  String? isDelete;

  BatchCreation(
      {this.batchNo,
      this.grade,
      this.noOfBag,
      this.stockType,
      this.weight,
      this.isDelete});

  factory BatchCreation.fromJson(Map<String, dynamic> json) {
    return BatchCreation(
        batchNo: json['batchNo'],
        grade: json['grade'],
        noOfBag: json['noOfBag'],
        stockType: json['stockType'],
        weight: json['weight'],
        isDelete: json['isDelete']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['batchNo'] = this.batchNo;
    data['grade'] = this.grade;
    data['noOfBag'] = this.noOfBag;
    data['stockType'] = this.stockType;
    data['weight'] = this.weight;
    data['isDelete'] = this.isDelete;
    return data;
  }
}

class InspReqData {
  String? insAppName;
  String? insCerNo;
  String? insDist;
  String? insId;
  String? insName;
  String? insParish;
  String? insSubCnt;
  String? insType;
  String? insVill;
  String? stockType;
  String? insUniqueId;
  String? capacity;

  InspReqData(
      {this.insAppName,
      this.insCerNo,
      this.insDist,
      this.insId,
      this.insName,
      this.insParish,
      this.insSubCnt,
      this.insType,
      this.insVill,
      this.stockType,
      this.insUniqueId,
      this.capacity});

  factory InspReqData.fromJson(Map<String, dynamic> json) {
    return InspReqData(
        insAppName: json['insAppName'],
        insCerNo: json['insCerNo'],
        insDist: json['insDist'],
        insId: json['insId'],
        insName: json['insName'],
        insParish: json['insParish'],
        insSubCnt: json['insSubCnt'],
        insType: json['insType'],
        insVill: json['insVill'],
        stockType: json['stockType'] ?? "",
        insUniqueId: json['insUniqueId'],
        capacity: json['capacity']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['insAppName'] = this.insAppName;
    data['insCerNo'] = this.insCerNo;
    data['insDist'] = this.insDist;
    data['insId'] = this.insId;
    data['insName'] = this.insName;
    data['insParish'] = this.insParish;
    data['insSubCnt'] = this.insSubCnt;
    data['insType'] = this.insType;
    data['insVill'] = this.insVill;
    data['stockType'] = this.stockType;
    data['insUniqueId'] = this.insUniqueId;
    data['capacity'] = this.capacity;
    return data;
  }
}

class VcaData {
  String? applicantName;
  String? applicantType;
  String? certNo;
  String? regNo;
  String? mobNo;
  String? stockType;
  String? vId;
  String? actCat;
  String? vilCode;
  String? vilName;

  VcaData(
      {this.applicantName,
      this.applicantType,
      this.certNo,
      this.regNo,
      this.mobNo,
      this.stockType,
      this.vId,
      this.actCat,
      this.vilCode,
      this.vilName});

  factory VcaData.fromJson(Map<String, dynamic> json) {
    return VcaData(
      applicantName: json['applicantName'],
      applicantType: json['applicantType'],
      certNo: json['certNo'],
      regNo: json['regNum'],
      mobNo: json['mobileNum'],
      stockType: json['stockType'],
      vId: json['vId'],
      actCat: json['actCat'],
      vilCode: json['vilCode'],
      vilName: json['vilName'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['applicantName'] = this.applicantName;
    data['applicantType'] = this.applicantType;
    data['certNo'] = this.certNo;
    data['regNum'] = this.regNo;
    data['mobileNum'] = this.mobNo;
    data['stockType'] = this.stockType;
    data['vId'] = this.vId;
    data['actCat'] = this.actCat;
    data['vilCode'] = this.vilCode;
    data['vilName'] = this.vilName;
    return data;
  }
}

class VcaRegData {
  String? vId;
  String? regNo;
  String? cerNo;
  String? applicantType;
  String? stockType;
  String? villName;
  String? villCode;
  String? applicantName;
  String? vcaCat;
  String? telePho;
  String? address;
  String? email;

  VcaRegData(
      {this.vId,
      this.vcaCat,
      this.applicantName,
      this.applicantType,
      this.cerNo,
      this.stockType,
      this.villName,
      this.villCode,
      this.regNo,
      this.telePho,
      this.address,
      this.email});

  factory VcaRegData.fromJson(Map<String, dynamic> json) {
    return VcaRegData(
        vId: json['vId'],
        vcaCat: json['vcaCat'],
        applicantName: json['applicantName'],
        applicantType: json['applicantType'],
        cerNo: json['cerNo'],
        stockType: json['stockType'],
        villName: json['vilName'],
        villCode: json['vilCode'],
        regNo: json['regNo'],
        telePho: json['telePho'],
        address: json['address'],
        email: json['email']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['vId'] = this.vId;
    data['vcaCat'] = this.vcaCat;
    data['applicantName'] = this.applicantName;
    data['applicantType'] = this.applicantType;
    data['cerNo'] = this.cerNo;
    data['stockType'] = this.stockType;
    data['vilName'] = this.villName;
    data['vilCode'] = this.villCode;
    data['regNo'] = this.regNo;
    data['telePho'] = this.telePho;
    data['address'] = this.address;
    data['email'] = this.email;
    return data;
  }
}

class Transfer {
  String? farmName;
  String? isTransfered;
  String? agentId;
  String? seasonCode;
  String? frmName;
  String? stockType;
  String? receiverName;
  String? coffVariety;
  String? totWtTransfd;
  String? coffGrade;
  String? farmerName;
  String? fCode;
  String? recptNo;
  String? senderId;
  String? senderName;
  String? receiverId;
  String? datetransfer;
  String? processType;
  String? noBags;
  String? coffType;
  String? trRecptNo;

  Transfer(
      {this.coffGrade,
      this.coffType,
      this.coffVariety,
      this.datetransfer,
      this.fCode,
      this.frmName,
      this.receiverId,
      this.receiverName,
      this.recptNo,
      this.seasonCode,
      this.senderId,
      this.senderName,
      this.stockType,
      this.trRecptNo,
      this.processType,
      this.isTransfered,
      this.farmerName,
      this.farmName,
      this.agentId,
      this.totWtTransfd,
      this.noBags});

  factory Transfer.fromJson(Map<String, dynamic> json) {
    return Transfer(
        coffGrade: json['coffGrade'],
        coffType: json['coffType'],
        coffVariety: json['coffVariety'],
        datetransfer: json['datetransfer'],
        fCode: json['fCode'],
        frmName: json['frmName'],
        receiverId: json['receiverId'],
        receiverName: json['receiverName'],
        recptNo: json['recptNo'],
        seasonCode: json['seasonCode'],
        senderId: json['senderId'],
        senderName: json['senderName'],
        stockType: json['stockType'],
        trRecptNo: json['trRecptNo'],
        processType: json['processType'],
        isTransfered: json['isTransfered'],
        farmerName: json['farmerName'],
        farmName: json['farmName'],
        agentId: json['agentId'],
        totWtTransfd: json['totWtTransfd'],
        noBags: json['noBags']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['coffGrade'] = this.coffGrade;
    data['coffType'] = this.coffType;
    data['coffVariety'] = this.coffVariety;
    data['datetransfer'] = this.datetransfer;
    data['fCode'] = this.fCode;
    data['frmName'] = this.frmName;
    data['noBags'] = this.noBags;
    data['receiverId'] = this.receiverId;
    data['receiverName'] = this.receiverName;
    data['recptNo'] = this.recptNo;
    data['seasonCode'] = this.seasonCode;
    data['senderId'] = this.senderId;
    data['senderName'] = this.senderName;
    data['stockType'] = this.stockType;
    data['totWtTransfd'] = this.totWtTransfd;
    data['trRecptNo'] = this.trRecptNo;
    data['agentId'] = this.agentId;
    data['processType'] = this.processType;
    data['isTransfered'] = this.isTransfered;
    data['farmerName'] = this.farmerName;
    data['farmName'] = this.farmName;
    return data;
  }
}

class Purchase {
  String? noOfBag;
  String? batchNo;
  String? buyingCenter;
  String? weight;
  String? status;

  Purchase(
      {this.noOfBag,
      this.batchNo,
      this.buyingCenter,
      this.weight,
      this.status});

  factory Purchase.fromJson(Map<String, dynamic> json) {
    return Purchase(
        noOfBag: json['noOfBag'],
        batchNo: json['batchNo'],
        buyingCenter: json['buyingCenter'],
        weight: json['weight'],
        status: json['status']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['noOfBag'] = this.noOfBag;
    data['batchNo'] = this.batchNo;
    data['buyingCenter'] = this.buyingCenter;
    data['weight'] = this.weight;
    data['status'] = this.status;

    return data;
  }
}

class NurRegData {
  String? applicantName;
  String? applicantType;
  String? capacity;
  String? mNo;
  String? natId;
  String? operatorName;
  String? regNo;
  String? stockType;
  String? tin;
  String? villName;

  NurRegData(
      {this.applicantName,
      this.applicantType,
      this.capacity,
      this.mNo,
      this.natId,
      this.operatorName,
      this.regNo,
      this.stockType,
      this.tin,
      this.villName});

  factory NurRegData.fromJson(Map<String, dynamic> json) {
    return NurRegData(
      applicantName: json['applicantName'],
      applicantType: json['applicantType'],
      capacity: json['capacity'],
      mNo: json['mNo'],
      natId: json['natId'],
      operatorName: json['operatorName'],
      regNo: json['regNo'],
      stockType: json['stockType'],
      tin: json['tin'],
      villName: json['villName'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['applicantName'] = this.applicantName;
    data['applicantType'] = this.applicantType;
    data['capacity'] = this.capacity;
    data['mNo'] = this.mNo;
    data['natId'] = this.natId;
    data['operatorName'] = this.operatorName;
    data['regNo'] = this.regNo;
    data['stockType'] = this.stockType;
    data['tin'] = this.tin;
    data['villName'] = this.villName;
    return data;
  }
}

class InputDemand {
  String? date;
  String? gender;
  String? seasonCode;
  String? stockType;
  String? fr_code;
  String? wareHouse;
  String? nin;
  String? productCode;
  String? input_Type;
  String? demandQty;
  String? receiptNo;
  String? contactNumber;
  String? village;
  String? age;
  String? dId;
  String? districtCode;

  InputDemand(
      {this.date,
      this.gender,
      this.seasonCode,
      this.stockType,
      this.fr_code,
      this.wareHouse,
      this.nin,
      this.productCode,
      this.input_Type,
      this.demandQty,
      this.receiptNo,
      this.contactNumber,
      this.village,
      this.age,
      this.dId,
      this.districtCode});

  factory InputDemand.fromJson(Map<String, dynamic> json) {
    return InputDemand(
        date: json['date'],
        gender: json['gender'],
        seasonCode: json['seasonCode'],
        stockType: json['stockType'],
        fr_code: json['fr_code'],
        wareHouse: json['wareHouse'],
        nin: json['nin'],
        productCode: json['productCode'],
        input_Type: json['input_Type'],
        demandQty: json['demandQty'],
        receiptNo: json['receiptNo'],
        contactNumber: json['contactNumber'],
        village: json['village'],
        age: json['age'],
        dId: json['dId'],
        districtCode: json['districtCode']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['date'] = this.date;
    data['nin'] = this.nin;
    data['productCode'] = this.productCode;
    data['gender'] = this.gender;
    data['demandQty'] = this.demandQty;
    data['input_Type'] = this.input_Type;
    data['contactNumber'] = this.contactNumber;
    data['village'] = this.village;
    data['fr_code'] = this.fr_code;
    data['age'] = this.age;
    data['wareHouse'] = this.wareHouse;
    data['districtCode'] = this.districtCode;
    return data;
  }
}

class Stock {
  String? batchNo;
  String? createdDate;
  String? grWt;
  String? pCode;
  String? pName;
  String? stType;
  String? troughNo;
  String? vCode;
  String? vName;
  String? wCode;
  String? wName;
  String? isClosed;

  Stock(
      {this.batchNo,
      this.createdDate,
      this.grWt,
      this.pCode,
      this.pName,
      this.stType,
      this.troughNo,
      this.vCode,
      this.vName,
      this.wCode,
      this.wName,
      this.isClosed});

  factory Stock.fromJson(Map<String, dynamic> json) {
    return Stock(
        batchNo: json['batchNo'],
        createdDate: json['createdDate'],
        grWt: json['grWt'],
        pCode: json['pCode'],
        pName: json['pName'],
        stType: json['stType'],
        troughNo: json['troughNo'],
        vCode: json['vCode'],
        vName: json['vName'],
        wCode: json['wCode'],
        wName: json['wName'],
        isClosed: json['isClosed']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['batchNo'] = this.batchNo;
    data['createdDate'] = this.createdDate;
    data['grWt'] = this.grWt;
    data['pCode'] = this.pCode;
    data['pName'] = this.pName;
    data['stType'] = this.stType;
    data['troughNo'] = this.troughNo;
    data['vCode'] = this.vCode;
    data['vName'] = this.vName;
    data['wCode'] = this.wCode;
    data['wName'] = this.wName;
    data['isClosed'] = this.isClosed;
    return data;
  }
}

class Data8 {
  List<Cat>? catList;
  String? catRevNo;

  Data8({this.catList, this.catRevNo});

  factory Data8.fromJson(Map<String, dynamic> json) {
    return Data8(
      catList: json['catList'] != null
          ? (json['catList'] as List).map((i) => Cat.fromJson(i)).toList()
          : null,
      catRevNo: json['catRevNo'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['catRevNo'] = this.catRevNo;
    if (this.catList != null) {
      data['catList'] = this.catList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Cat {
  String? catId;
  String? catName;
  int? catType;
  List<Object>? lang;
  String? pCatId;
  String? catHarvestInterval;
  int? seqNo;

  Cat(
      {this.catId,
      this.catName,
      this.catType,
      this.lang,
      this.pCatId,
      this.catHarvestInterval,
      this.seqNo});

  factory Cat.fromJson(Map<String, dynamic> json) {
    return Cat(
      catId: json['catId'],
      catName: json['catName'],
      catType: json['catType'],
      // lang: json['lang'] != null
      //     ? (json['lang'] as List).map((i) => Object.fromJson(i)).toList()
      //     : null,
      pCatId: json['pCatId'],
      catHarvestInterval: json['catHarvestInterval'],
      seqNo: json['seqNo'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['catId'] = this.catId;
    data['catName'] = this.catName;
    data['catType'] = this.catType;
    data['pCatId'] = this.pCatId;
    data['catHarvestInterval'] = this.catHarvestInterval;
    data['seqNo'] = this.seqNo;
    // if (this.lang != null) {
    //   data['lang'] = this.lang.map((v) => v.toJson()).toList();
    // }
    return data;
  }
}

class Data1 {
  String? seasonRevNo;
  List<Season>? seasons;

  Data1({this.seasonRevNo, this.seasons});

  factory Data1.fromJson(Map<String, dynamic> json) {
    return Data1(
      seasonRevNo: json['seasonRevNo'],
      seasons: json['seasons'] != null
          ? (json['seasons'] as List).map((i) => Season.fromJson(i)).toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['seasonRevNo'] = this.seasonRevNo;
    if (this.seasons != null) {
      data['seasons'] = this.seasons!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Season {
  List<Object>? lang;
  String? sCode;
  String? sName;

  Season({this.lang, this.sCode, this.sName});

  factory Season.fromJson(Map<String, dynamic> json) {
    return Season(
      // lang: json['lang'] != null
      //     ? (json['lang'] as List).map((i) => LangXXX.fromJson(i)).toList()
      //     : null,
      sCode: json['sCode'],
      sName: json['sName'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['sCode'] = this.sCode;
    data['sName'] = this.sName;
    // if (this.lang != null) {
    //   data['lang'] = this.lang!.map((v) => v.toJson()).toList();
    // }
    return data;
  }
}

class AgentLogin {
  String? currentSeasonCode;
  int? fCropRevNo;
  int? farmRevNo;
  int? farmerRevNo;
  int? fsRevNo;

  AgentLogin(
      {this.currentSeasonCode,
      this.fCropRevNo,
      this.farmRevNo,
      this.farmerRevNo,
      this.fsRevNo});

  factory AgentLogin.fromJson(Map<String, dynamic> json) {
    return AgentLogin(
      currentSeasonCode: json['currentSeasonCode'],
      fCropRevNo: json['fCropRevNo'],
      farmRevNo: json['farmRevNo'],
      farmerRevNo: json['farmerRevNo'],
      fsRevNo: json['fsRevNo'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['currentSeasonCode'] = this.currentSeasonCode;
    data['fCropRevNo'] = this.fCropRevNo;
    data['farmRevNo'] = this.farmRevNo;
    data['farmerRevNo'] = this.farmerRevNo;
    data['fsRevNo'] = this.fsRevNo;
    return data;
  }
}

class Data2 {
  List<Country>? countryList;
  String? lRevNo;

  Data2({this.countryList, this.lRevNo});

  factory Data2.fromJson(Map<String, dynamic> json) {
    return Data2(
      countryList: json['countryList'] != null
          ? (json['countryList'] as List)
              .map((i) => Country.fromJson(i))
              .toList()
          : null,
      lRevNo: json['lRevNo'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['lRevNo'] = this.lRevNo;
    if (this.countryList != null) {
      data['countryList'] = this.countryList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Country {
  String? countryCode;
  String? countryName;
  List<Object>? lang;
  List<States>? stateList;

  Country({this.countryCode, this.countryName, this.lang, this.stateList});

  factory Country.fromJson(Map<String, dynamic> json) {
    return Country(
      countryCode: json['countryCode'],
      countryName: json['countryName'],
      // lang: json['lang'] != null
      //     ? (json['lang'] as List).map((i) => Object.fromJson(i)).toList()
      //     : null,
      stateList: json['stateList'] != null
          ? (json['stateList'] as List).map((i) => States.fromJson(i)).toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['countryCode'] = this.countryCode;
    data['countryName'] = this.countryName;
    // if (this.lang != null) {
    //   data['lang'] = this.lang.map((v) => v.toJson()).toList();
    // }
    if (this.stateList != null) {
      data['stateList'] = this.stateList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class States {
  List<District>? districtList;
  List<Object>? lang;
  String? stateCode;
  String? stateName;

  States({this.districtList, this.lang, this.stateCode, this.stateName});

  factory States.fromJson(Map<String, dynamic> json) {
    return States(
      districtList: json['districtList'] != null
          ? (json['districtList'] as List)
              .map((i) => District.fromJson(i))
              .toList()
          : null,
      // lang: json['lang'] != null
      //     ? (json['lang'] as List).map((i) => Object.fromJson(i)).toList()
      //     : null,
      stateCode: json['stateCode'],
      stateName: json['stateName'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['stateCode'] = this.stateCode;
    data['stateName'] = this.stateName;
    if (this.districtList != null) {
      data['districtList'] = this.districtList!.map((v) => v.toJson()).toList();
    }
    // if (this.lang != null) {
    //   data['lang'] = this.lang.map((v) => v.toJson()).toList();
    // }
    return data;
  }
}

class District {
  List<City>? cityList;
  String? districtCode;
  String? districtName;
  List<Object>? lang;

  District({this.cityList, this.districtCode, this.districtName, this.lang});

  factory District.fromJson(Map<String, dynamic> json) {
    return District(
      cityList: json['cityList'] != null
          ? (json['cityList'] as List).map((i) => City.fromJson(i)).toList()
          : null,
      districtCode: json['districtCode'],
      districtName: json['districtName'],
      // lang: json['lang'] != null
      //     ? (json['lang'] as List).map((i) => Object.fromJson(i)).toList()
      //     : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['districtCode'] = this.districtCode;
    data['districtName'] = this.districtName;
    if (this.cityList != null) {
      data['cityList'] = this.cityList!.map((v) => v.toJson()).toList();
    }
    // if (this.lang != null) {
    //   data['lang'] = this.lang.map((v) => v.toJson()).toList();
    // }
    return data;
  }
}

class City {
  String? cityCode;
  String? cityName;
  List<Object>? lang;
  List<Village>? villageList;

  City({this.cityCode, this.cityName, this.lang, this.villageList});

  factory City.fromJson(Map<String, dynamic> json) {
    return City(
      cityCode: json['cityCode'],
      cityName: json['cityName'],
      // lang: json['lang'] != null
      //     ? (json['lang'] as List).map((i) => Object.fromJson(i)).toList()
      //     : null,
      villageList: json['villageList'] != null
          ? (json['villageList'] as List)
              .map((i) => Village.fromJson(i))
              .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['cityCode'] = this.cityCode;
    data['cityName'] = this.cityName;
    // if (this.lang != null) {
    //   data['lang'] = this.lang.map((v) => v.toJson()).toList();
    // }
    if (this.villageList != null) {
      data['villageList'] = this.villageList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Village {
  List<Object>? lang;
  String? villageCode;
  String? villageName;

  Village({this.lang, this.villageCode, this.villageName});

  factory Village.fromJson(Map<String, dynamic> json) {
    return Village(
      // lang: json['lang'] != null
      //     ? (json['lang'] as List).map((i) => Object.fromJson(i)).toList()
      //     : null,
      villageCode: json['villageCode'],
      villageName: json['villageName'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['villageCode'] = this.villageCode;
    data['villageName'] = this.villageName;
    // if (this.lang != null) {
    //   data['lang'] = this.lang.map((v) => v.toJson()).toList();
    // }
    return data;
  }
}

class Data11 {
  List<Productss>? products;
  Data11({this.products});
  factory Data11.fromJson(Map<String, dynamic> json) {
    return Data11(
      products: json['products'] != null
          ? (json['products'] as List)
              .map((i) => Productss.fromJson(i))
              .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.products != null) {
      data['products'] = this.products!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Productss {
  String? categoryCode;
  String? ingredient;
  String? categoryName;
  String? manufacture;
  String? manufactureId;
  String? price;
  String? productCode;
  String? productName;
  String? unit;

  Productss(
      {this.categoryCode,
      this.ingredient,
      this.manufacture,
      this.manufactureId,
      this.price,
      this.productCode,
      this.productName,
      this.unit,
      this.categoryName});

  factory Productss.fromJson(Map<String, dynamic> json) {
    return Productss(
        categoryCode: json['categoryCode'],
        ingredient: json['ingredient'],
        manufacture: json['manufacture'],
        manufactureId: json['manufactureId'],
        price: json['price'],
        productCode: json['productCode'],
        productName: json['productName'],
        unit: json['unit'],
        categoryName: json['categoryName']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['categoryCode'] = this.categoryCode;
    data['ingredient'] = this.ingredient;
    data['manufacture'] = this.manufacture;
    data['manufactureId'] = this.manufactureId;
    data['price'] = this.price;
    data['productCode'] = this.productCode;
    data['productName'] = this.productName;
    data['unit'] = this.unit;
    data['categoryName'] = this.categoryName;
    return data;
  }
}

class Data9 {
  List<CoOperative>? coOperatives;
  String? coRevNo;

  Data9({this.coOperatives, this.coRevNo});

  factory Data9.fromJson(Map<String, dynamic> json) {
    return Data9(
      coOperatives: json['coOperatives'] != null
          ? (json['coOperatives'] as List)
              .map((i) => CoOperative.fromJson(i))
              .toList()
          : null,
      coRevNo: json['coRevNo'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['coRevNo'] = this.coRevNo;
    if (this.coOperatives != null) {
      data['coOperatives'] = this.coOperatives!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CoOperative {
  String? coCode;
  String? coName;
  String? samTyp;
  String? address1;

  CoOperative({this.coCode, this.coName, this.samTyp, this.address1});

  factory CoOperative.fromJson(Map<String, dynamic> json) {
    return CoOperative(
      coCode: json['coCode'],
      coName: json['coName'],
      samTyp: json['samTyp'],
      address1: json['address1'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['coCode'] = this.coCode;
    data['coName'] = this.coName;
    data['samTyp'] = this.samTyp;
    data['address1'] = this.address1;

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
