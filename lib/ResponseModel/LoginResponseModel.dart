class LoginResponseModel {
  Response? response;

  LoginResponseModel({this.response});

  LoginResponseModel.fromJson(Map<String, dynamic> json) {
    response = json['Response'] != null
        ? new Response.fromJson(json['Response'])
        : null;
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
  AgentLogin? agentLogin;
  Data14? data14;

  Body({this.agentLogin, this.data14});

  factory Body.fromJson(Map<String, dynamic> json) {
    return Body(
      agentLogin: json['agentLogin'] != null
          ? AgentLogin.fromJson(json['agentLogin'])
          : null,
      data14: json['data14'] != null ? Data14.fromJson(json['data14']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.agentLogin != null) {
      data['agentLogin'] = this.agentLogin!.toJson();
    }
    if (this.data14 != null) {
      data['data14'] = this.data14!.toJson();
    }
    return data;
  }
}

class Data14 {
  int? dynLatestRevNo;
  List<Menulist>? menulist;

  Data14({this.dynLatestRevNo, this.menulist});

  factory Data14.fromJson(Map<String, dynamic> json) {
    return Data14(
      dynLatestRevNo: json['dynLatestRevNo'],
      menulist: json['menulist'] != null
          ? (json['menulist'] as List).map((i) => Menulist.fromJson(i)).toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['dynLatestRevNo'] = this.dynLatestRevNo;
    if (this.menulist != null) {
      data['menulist'] = this.menulist!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Menulist {
  String? agentType;
  String? entity;
  String? iconClass;
  List<dynamic>? lang;
  String? menuId;
  String? menuLabel;
  String? menuOrder;
  String? seasonFlag;
  List<Section>? sections;
  String? txnTypeId;
  String? is_survey;

  Menulist(
      {this.agentType,
      this.entity,
      this.iconClass,
      this.lang,
      this.menuId,
      this.menuLabel,
      this.menuOrder,
      this.seasonFlag,
      this.sections,
      this.txnTypeId,
      this.is_survey});

  factory Menulist.fromJson(Map<String, dynamic> json) {
    return Menulist(
      agentType: json['agentType'],
      entity: json['entity'],
      iconClass: json['iconClass'],
      lang: json['lang'],
      menuId: json['menuId'],
      menuLabel: json['menuLabel'],
      menuOrder: json['menuOrder'],
      seasonFlag: json['seasonFlag'],
      is_survey: json['is_survey'],
      sections: json['sections'] != null
          ? (json['sections'] as List).map((i) => Section.fromJson(i)).toList()
          : null,
      txnTypeId: json['txnTypeId'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['agentType'] = this.agentType;
    data['entity'] = this.entity;
    data['iconClass'] = this.iconClass;
    data['menuId'] = this.menuId;
    data['menuLabel'] = this.menuLabel;
    data['menuOrder'] = this.menuOrder;
    data['seasonFlag'] = this.seasonFlag;
    data['txnTypeId'] = this.txnTypeId;
    data['is_survey'] = this.is_survey;
    if (this.lang != null) {
      data['lang'] = this.lang;
    }
    if (this.sections != null) {
      data['sections'] = this.sections!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Section {
  String? afterInsert;
  String? beforeInsert;
  String? blockId;
  List<Field>? fieldList;
  List<Lists>? lists;
  String? secId;
  String? secName;
  String? district;
  String? month;
  String? txnTypeId;

  Section(
      {this.afterInsert,
      this.beforeInsert,
      this.blockId,
      this.fieldList,
      this.lists,
      this.secId,
      this.secName,
      this.district,
      this.month,
      this.txnTypeId});

  factory Section.fromJson(Map<String, dynamic> json) {
    return Section(
      afterInsert: json['afterInsert'],
      beforeInsert: json['beforeInsert'],
      blockId: json['blockId'],
      fieldList: json['fieldList'] != null
          ? (json['fieldList'] as List).map((i) => Field.fromJson(i)).toList()
          : null,
      lists: json['lists'] != null
          ? (json['lists'] as List).map((i) => Lists.fromJson(i)).toList()
          : null,
      secId: json['secId'],
      secName: json['secName'],
      district: json['district'],
      month: json['month'],
      txnTypeId: json['txnTypeId'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['afterInsert'] = this.afterInsert;
    data['beforeInsert'] = this.beforeInsert;
    data['blockId'] = this.blockId;
    data['secId'] = this.secId;
    data['secName'] = this.secName;
    data['district'] = this.district;
    data['month'] = this.month;
    data['txnTypeId'] = this.txnTypeId;
    if (this.fieldList != null) {
      data['fieldList'] = this.fieldList!.map((v) => v.toJson()).toList();
    }
    if (this.lists != null) {
      data['lists'] = this.lists!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Lists {
  String? listId;
  String? listName;

  Lists({this.listId, this.listName});

  factory Lists.fromJson(Map<String, dynamic> json) {
    return Lists(
      listId: json['listId'],
      listName: json['listName'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['listId'] = this.listId;
    data['listName'] = this.listName;
    return data;
  }
}

class Field {
  String? afterFld;
  String? beforeFld;
  String? blockId;
  String? catDepKey;
  String? catType;
  String? compoId;
  String? compoLabel;
  String? compoType;
  String? dataFormat;
  String? dependentField;
  String? formulaDependency;
  String? isOther;
  String? isRequired;
  // List<Object>? lang;
  String? listId;
  String? listMethodName;
  String? maxLength;
  String? minLength;
  String? order;
  String? parentDepend;
  String? parentField;
  String? secId;
  String? txnTypeId;
  String? validType;
  String? district;
  String? month;
  int? valueDependency;
  String? staticDepen;

  Field(
      {this.afterFld,
      this.beforeFld,
      this.blockId,
      this.catDepKey,
      this.catType,
      this.compoId,
      this.compoLabel,
      this.compoType,
      this.dataFormat,
      this.dependentField,
      this.formulaDependency,
      this.isOther,
      this.isRequired,
      // this.lang,
      this.listId,
      this.listMethodName,
      this.maxLength,
      this.minLength,
      this.order,
      this.parentDepend,
      this.parentField,
      this.secId,
      this.txnTypeId,
      this.validType,
      this.district,
      this.month,
      this.valueDependency,
      this.staticDepen});

  factory Field.fromJson(Map<String, dynamic> json) {
    return Field(
        afterFld: json['afterFld'],
        beforeFld: json['beforeFld'],
        blockId: json['blockId'],
        catDepKey: json['catDepKey'],
        catType: json['catType'],
        compoId: json['compoId'],
        compoLabel: json['compoLabel'],
        compoType: json['compoType'],
        dataFormat: json['dataFormat'],
        dependentField: json['dependentField'],
        formulaDependency: json['formulaDependency'],
        isOther: json['isOther'],
        isRequired: json['isRequired'],
        // lang: json['lang'],
        listId: json['listId'],
        listMethodName: json['listMethodName'],
        maxLength: json['maxLength'],
        minLength: json['minLength'],
        order: json['order'],
        parentDepend: json['parentDepend'],
        parentField: json['parentField'],
        secId: json['secId'],
        txnTypeId: json['txnTypeId'],
        validType: json['validType'],
        district: json['district'],
        month: json['month'],
        valueDependency: json['valueDependency'],
        staticDepen: json['staticDepen']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['afterFld'] = this.afterFld;
    data['beforeFld'] = this.beforeFld;
    data['blockId'] = this.blockId;
    data['catDepKey'] = this.catDepKey;
    data['catType'] = this.catType;
    data['compoId'] = this.compoId;
    data['compoLabel'] = this.compoLabel;
    data['compoType'] = this.compoType;
    data['dataFormat'] = this.dataFormat;
    data['dependentField'] = this.dependentField;
    data['formulaDependency'] = this.formulaDependency;
    data['isOther'] = this.isOther;
    data['isRequired'] = this.isRequired;
    data['listId'] = this.listId;
    data['listMethodName'] = this.listMethodName;
    data['maxLength'] = this.maxLength;
    data['minLength'] = this.minLength;
    data['order'] = this.order;
    data['parentDepend'] = this.parentDepend;
    data['parentField'] = this.parentField;
    data['secId'] = this.secId;
    data['txnTypeId'] = this.txnTypeId;
    data['validType'] = this.validType;
    data['district'] = this.district;
    data['month'] = this.month;
    data['valueDependency'] = this.valueDependency;
    data['staticDepen'] = this.staticDepen;
    /*  if (this.lang != null) {
      data['lang'] = this.lang;
    }*/
    return data;
  }
}

class AgentLogin {
  String? agentName;
  String? deviceId;
  String? syncTS;
  String? displayTSFormat;
  String? servPointId;
  String? servPointName;
  String? bal;
  String? clientIdSeq;
  String? agentType;
  String? tare;
  String? currentSeasonCode;
  String? dispDtFormat;
  String? genDateFormat;
  String? isGrampnchayat;
  String? isTracker;
  String? currency;
  String? areaType;
  List<Samithis>? samithis;
  List<Factory>? factory;
  int? farmerRevNo;
  int? farmRevNo;
  int? fCropRevNo;
  String? prodRevNo;
  String? seasonRevNo;
  String? lRevNo;
  String? wsRevNo;
  String? vwsRevNo;
  String? fobRevNo;
  String? procProdRevNo;
  String? catRevNo;
  String? coRevNo;
  String? dynLatestRevNo;
  int? fsRevNo;
  String? branchId;
  String? parentId;
  String? ftpPw;
  String? ftpUrl;
  String? ftpUs;
  String? ftpPath;
  String? distImgAvil;
  String? digitalSign;
  String? cropCalandar;
  String? warehouseSeason;
  String? stateCode;
  String? wCode;

  AgentLogin(
      {this.agentName,
      this.deviceId,
      this.syncTS,
      this.displayTSFormat,
      this.servPointId,
      this.servPointName,
      this.bal,
      this.clientIdSeq,
      this.agentType,
      this.tare,
      this.currentSeasonCode,
      this.dispDtFormat,
      this.genDateFormat,
      this.isGrampnchayat,
      this.isTracker,
      this.currency,
      this.areaType,
      this.samithis,
      this.factory,
      this.farmerRevNo,
      this.farmRevNo,
      this.fCropRevNo,
      this.prodRevNo,
      this.seasonRevNo,
      this.lRevNo,
      this.wsRevNo,
      this.vwsRevNo,
      this.fobRevNo,
      this.procProdRevNo,
      this.catRevNo,
      this.coRevNo,
      this.dynLatestRevNo,
      this.fsRevNo,
      this.branchId,
      this.parentId,
      this.ftpPw,
      this.ftpUrl,
      this.ftpUs,
      this.ftpPath,
      this.distImgAvil,
      this.digitalSign,
      this.cropCalandar,
      this.warehouseSeason,
      this.stateCode,
      this.wCode});

  AgentLogin.fromJson(Map<String, dynamic> json) {
    agentName = json['agentName'];
    deviceId = json['deviceId'];
    syncTS = json['syncTS'];
    displayTSFormat = json['displayTSFormat'];
    servPointId = json['servPointId'];
    servPointName = json['servPointName'];
    bal = json['bal'];
    clientIdSeq = json['clientIdSeq'];
    agentType = json['agentType'];
    tare = json['tare'];
    currentSeasonCode = json['currentSeasonCode'];
    dispDtFormat = json['dispDtFormat'];
    genDateFormat = json['genDateFormat'];
    isGrampnchayat = json['isGrampnchayat'];
    isTracker = json['isTracker'];
    currency = json['currency'];
    areaType = json['areaType'];

    if (json['samithis'] != null) {
      samithis = <Samithis>[];
      json['samithis'].forEach((v) {
        samithis!.add(new Samithis.fromJson(v));
      });
    }
    if (json['factory'] != null) {
      factory = <Factory>[];
      json['factory'].forEach((v) {
        factory!.add(new Factory.fromJson(v));
      });
    }
    farmerRevNo = json['farmerRevNo'];
    farmRevNo = json['farmRevNo'];
    fCropRevNo = json['fCropRevNo'];
    prodRevNo = json['prodRevNo'];
    seasonRevNo = json['seasonRevNo'];
    lRevNo = json['lRevNo'];
    wsRevNo = json['wsRevNo'];
    vwsRevNo = json['vwsRevNo'];
    fobRevNo = json['fobRevNo'];
    procProdRevNo = json['procProdRevNo'];
    catRevNo = json['catRevNo'];
    coRevNo = json['coRevNo'];
    dynLatestRevNo = json['dynLatestRevNo'];
    fsRevNo = json['fsRevNo'];
    branchId = json['branchId'];
    parentId = json['parentId'];
    ftpPw = json['ftpPw'];
    ftpUrl = json['ftpUrl'];
    ftpUs = json['ftpUs'];
    ftpPath = json['ftpPath'];
    distImgAvil = json['distImgAvil'];
    digitalSign = json['digitalSign'];
    cropCalandar = json['cropCalandar'];
    warehouseSeason = json['warehouseSeason'];
    stateCode = json['stateCode'];
    wCode = json['wCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['agentName'] = this.agentName;
    data['deviceId'] = this.deviceId;
    data['syncTS'] = this.syncTS;
    data['displayTSFormat'] = this.displayTSFormat;
    data['servPointId'] = this.servPointId;
    data['servPointName'] = this.servPointName;
    data['bal'] = this.bal;
    data['clientIdSeq'] = this.clientIdSeq;
    data['agentType'] = this.agentType;
    data['tare'] = this.tare;
    data['currentSeasonCode'] = this.currentSeasonCode;
    data['dispDtFormat'] = this.dispDtFormat;
    data['genDateFormat'] = this.genDateFormat;
    data['isGrampnchayat'] = this.isGrampnchayat;
    data['isTracker'] = this.isTracker;
    data['currency'] = this.currency;
    data['areaType'] = this.areaType;
    if (this.samithis != null) {
      data['samithis'] = this.samithis!.map((v) => v.toJson()).toList();
    }
    if (this.factory != null) {
      data['factory'] = this.factory!.map((v) => v.toJson()).toList();
    }
    data['farmerRevNo'] = this.farmerRevNo;
    data['farmRevNo'] = this.farmRevNo;
    data['fCropRevNo'] = this.fCropRevNo;
    data['prodRevNo'] = this.prodRevNo;
    data['seasonRevNo'] = this.seasonRevNo;
    data['lRevNo'] = this.lRevNo;
    data['wsRevNo'] = this.wsRevNo;
    data['vwsRevNo'] = this.vwsRevNo;
    data['fobRevNo'] = this.fobRevNo;
    data['procProdRevNo'] = this.procProdRevNo;
    data['catRevNo'] = this.catRevNo;
    data['coRevNo'] = this.coRevNo;
    data['dynLatestRevNo'] = this.dynLatestRevNo;
    data['fsRevNo'] = this.fsRevNo;
    data['branchId'] = this.branchId;
    data['parentId'] = this.parentId;
    data['ftpPw'] = this.ftpPw;
    data['ftpUrl'] = this.ftpUrl;
    data['ftpUs'] = this.ftpUs;
    data['ftpPath'] = this.ftpPath;
    data['distImgAvil'] = this.distImgAvil;
    data['digitalSign'] = this.digitalSign;
    data['cropCalandar'] = this.cropCalandar;
    data['warehouseSeason'] = this.warehouseSeason;
    data['stateCode'] = this.stateCode;
    data['wCode'] = this.wCode;
    return data;
  }
}

class Samithis {
  String? samName;
  String? samCode;

  Samithis({this.samName, this.samCode});

  Samithis.fromJson(Map<String, dynamic> json) {
    samName = json['samName'];
    samCode = json['samCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['samName'] = this.samName;
    data['samCode'] = this.samCode;
    return data;
  }
}

class Factory {
  String? samCode;
  String? samName;

  Factory({this.samCode, this.samName});

  factory Factory.fromJson(Map<String, dynamic> json) {
    return Factory(
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
