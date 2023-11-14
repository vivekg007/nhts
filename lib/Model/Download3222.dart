// class Download322 {
//   Response response;
//
//   Download322({this.response});
//
//   factory Download322.fromJson(Map<String, dynamic> json) {
//     return Download322(
//       response:
//           json['response'] != null ? Response.fromJson(json['response']) : null,
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     if (this.response != null) {
//       data['response'] = this.response.toJson();
//     }
//     return data;
//   }
// }
//
// class Response {
//   Body body;
//   Status status;
//
//   Response({this.body, this.status});
//
//   factory Response.fromJson(Map<String, dynamic> json) {
//     return Response(
//       body: json['body'] != null ? Body.fromJson(json['body']) : null,
//       status: json['status'] != null ? Status.fromJson(json['status']) : null,
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     if (this.body != null) {
//       data['body'] = this.body.toJson();
//     }
//     if (this.status != null) {
//       data['status'] = this.status.toJson();
//     }
//     return data;
//   }
// }
//
// class Status {
//   String code;
//   String message;
//
//   Status({this.code, this.message});
//
//   factory Status.fromJson(Map<String, dynamic> json) {
//     return Status(
//       code: json['code'],
//       message: json['message'],
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['code'] = this.code;
//     data['message'] = this.message;
//     return data;
//   }
// }
//
// class Body {
//   AgentLogin agentLogin;
//   Data1 data1;
//   Data10 data10;
//   Data2 data2;
//   Data6 data6;
//   Data8 data8;
//   Data9 data9;
//
//   Body(
//       {this.agentLogin,
//       this.data1,
//       this.data10,
//       this.data2,
//       this.data6,
//       this.data8,
//       this.data9});
//
//   factory Body.fromJson(Map<String, dynamic> json) {
//     return Body(
//       agentLogin: json['agentLogin'] != null
//           ? AgentLogin.fromJson(json['agentLogin'])
//           : null,
//       data1: json['data1'] != null ? Data1.fromJson(json['data1']) : null,
//       data10: json['data10'] != null ? Data10.fromJson(json['data10']) : null,
//       data2: json['data2'] != null ? Data2.fromJson(json['data2']) : null,
//       data6: json['data6'] != null ? Data6.fromJson(json['data6']) : null,
//       data8: json['data8'] != null ? Data8.fromJson(json['data8']) : null,
//       data9: json['data9'] != null ? Data9.fromJson(json['data9']) : null,
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     if (this.agentLogin != null) {
//       data['agentLogin'] = this.agentLogin.toJson();
//     }
//     if (this.data1 != null) {
//       data['data1'] = this.data1.toJson();
//     }
//     if (this.data10 != null) {
//       data['data10'] = this.data10.toJson();
//     }
//     if (this.data2 != null) {
//       data['data2'] = this.data2.toJson();
//     }
//     if (this.data6 != null) {
//       data['data6'] = this.data6.toJson();
//     }
//     if (this.data8 != null) {
//       data['data8'] = this.data8.toJson();
//     }
//     if (this.data9 != null) {
//       data['data9'] = this.data9.toJson();
//     }
//     return data;
//   }
// }
//
// class Data9 {
//   List<CoOperative> coOperatives;
//   String coRevNo;
//
//   Data9({this.coOperatives, this.coRevNo});
//
//   factory Data9.fromJson(Map<String, dynamic> json) {
//     return Data9(
//       coOperatives: json['coOperatives'] != null
//           ? (json['coOperatives'] as List)
//               .map((i) => CoOperative.fromJson(i))
//               .toList()
//           : null,
//       coRevNo: json['coRevNo'],
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['coRevNo'] = this.coRevNo;
//     if (this.coOperatives != null) {
//       data['coOperatives'] = this.coOperatives.map((v) => v.toJson()).toList();
//     }
//     return data;
//   }
// }
//
// class CoOperative {
//   String coCode;
//   String coName;
//   String samTyp;
//
//   CoOperative({this.coCode, this.coName, this.samTyp});
//
//   factory CoOperative.fromJson(Map<String, dynamic> json) {
//     return CoOperative(
//       coCode: json['coCode'],
//       coName: json['coName'],
//       samTyp: json['samTyp'],
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['coCode'] = this.coCode;
//     data['coName'] = this.coName;
//     data['samTyp'] = this.samTyp;
//     return data;
//   }
// }
//
// class Data10 {
//   List<Object> stocks;
//   String vwsRevNo;
//
//   Data10({this.stocks, this.vwsRevNo});
//
//   factory Data10.fromJson(Map<String, dynamic> json) {
//     return Data10(
//       stocks: json['stocks'] != null
//           ? (json['stocks'] as List).map((i) => Object.fromJson(i)).toList()
//           : null,
//       vwsRevNo: json['vwsRevNo'],
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['vwsRevNo'] = this.vwsRevNo;
//     if (this.stocks != null) {
//       data['stocks'] = this.stocks.map((v) => v.toJson()).toList();
//     }
//     return data;
//   }
// }
//
// class Data8 {
//   List<Cat> catList;
//   String catRevNo;
//
//   Data8({this.catList, this.catRevNo});
//
//   factory Data8.fromJson(Map<String, dynamic> json) {
//     return Data8(
//       catList: json['catList'] != null
//           ? (json['catList'] as List).map((i) => Cat.fromJson(i)).toList()
//           : null,
//       catRevNo: json['catRevNo'],
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['catRevNo'] = this.catRevNo;
//     if (this.catList != null) {
//       data['catList'] = this.catList.map((v) => v.toJson()).toList();
//     }
//     return data;
//   }
// }
//
// class Cat {
//   String? catHarvestInterval;
//   String? catId;
//   String catName;
//   int catType;
//   List<Object> lang;
//   String pCatId;
//   int seqNo;
//
//   Cat(
//       {this.catHarvestInterval,
//       this.catId,
//       this.catName,
//       this.catType,
//       this.lang,
//       this.pCatId,
//       this.seqNo});
//
//   factory Cat.fromJson(Map<String, dynamic> json) {
//     return Cat(
//       catHarvestInterval: json['catHarvestInterval'],
//       catId: json['catId'] != null ? String?.fromJson(json['catId']) : null,
//       catName: json['catName'],
//       catType: json['catType'],
//       lang: json['lang'] != null
//           ? (json['lang'] as List).map((i) => Object.fromJson(i)).toList()
//           : null,
//       pCatId: json['pCatId'],
//       seqNo: json['seqNo'],
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['catHarvestInterval'] = this.catHarvestInterval;
//     data['catName'] = this.catName;
//     data['catType'] = this.catType;
//     data['pCatId'] = this.pCatId;
//     data['seqNo'] = this.seqNo;
//     if (this.catId != null) {
//       data['catId'] = this.catId.toJson();
//     }
//     if (this.lang != null) {
//       data['lang'] = this.lang.map((v) => v.toJson()).toList();
//     }
//     return data;
//   }
// }
//
// class Data2 {
//   List<Country> countryList;
//   String lRevNo;
//
//   Data2({this.countryList, this.lRevNo});
//
//   factory Data2.fromJson(Map<String, dynamic> json) {
//     return Data2(
//       countryList: json['countryList'] != null
//           ? (json['countryList'] as List)
//               .map((i) => Country.fromJson(i))
//               .toList()
//           : null,
//       lRevNo: json['lRevNo'],
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['lRevNo'] = this.lRevNo;
//     if (this.countryList != null) {
//       data['countryList'] = this.countryList.map((v) => v.toJson()).toList();
//     }
//     return data;
//   }
// }
//
// class Country {
//   String countryCode;
//   String countryName;
//   List<Object> lang;
//   List<State> stateList;
//
//   Country({this.countryCode, this.countryName, this.lang, this.stateList});
//
//   factory Country.fromJson(Map<String, dynamic> json) {
//     return Country(
//       countryCode: json['countryCode'],
//       countryName: json['countryName'],
//       lang: json['lang'] != null
//           ? (json['lang'] as List).map((i) => Object.fromJson(i)).toList()
//           : null,
//       stateList: json['stateList'] != null
//           ? (json['stateList'] as List).map((i) => State.fromJson(i)).toList()
//           : null,
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['countryCode'] = this.countryCode;
//     data['countryName'] = this.countryName;
//     if (this.lang != null) {
//       data['lang'] = this.lang.map((v) => v.toJson()).toList();
//     }
//     if (this.stateList != null) {
//       data['stateList'] = this.stateList.map((v) => v.toJson()).toList();
//     }
//     return data;
//   }
// }
//
// class State {
//   List<District> districtList;
//   List<Object> lang;
//   String stateCode;
//   String stateName;
//
//   State({this.districtList, this.lang, this.stateCode, this.stateName});
//
//   factory State.fromJson(Map<String, dynamic> json) {
//     return State(
//       districtList: json['districtList'] != null
//           ? (json['districtList'] as List)
//               .map((i) => District.fromJson(i))
//               .toList()
//           : null,
//       lang: json['lang'] != null
//           ? (json['lang'] as List).map((i) => Object.fromJson(i)).toList()
//           : null,
//       stateCode: json['stateCode'],
//       stateName: json['stateName'],
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['stateCode'] = this.stateCode;
//     data['stateName'] = this.stateName;
//     if (this.districtList != null) {
//       data['districtList'] = this.districtList.map((v) => v.toJson()).toList();
//     }
//     if (this.lang != null) {
//       data['lang'] = this.lang.map((v) => v.toJson()).toList();
//     }
//     return data;
//   }
// }
//
// class District {
//   List<City> cityList;
//   String districtCode;
//   String districtName;
//   List<Object> lang;
//
//   District({this.cityList, this.districtCode, this.districtName, this.lang});
//
//   factory District.fromJson(Map<String, dynamic> json) {
//     return District(
//       cityList: json['cityList'] != null
//           ? (json['cityList'] as List).map((i) => City.fromJson(i)).toList()
//           : null,
//       districtCode: json['districtCode'],
//       districtName: json['districtName'],
//       lang: json['lang'] != null
//           ? (json['lang'] as List).map((i) => Object.fromJson(i)).toList()
//           : null,
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['districtCode'] = this.districtCode;
//     data['districtName'] = this.districtName;
//     if (this.cityList != null) {
//       data['cityList'] = this.cityList.map((v) => v.toJson()).toList();
//     }
//     if (this.lang != null) {
//       data['lang'] = this.lang.map((v) => v.toJson()).toList();
//     }
//     return data;
//   }
// }
//
// class City {
//   String cityCode;
//   String cityName;
//   List<Object> lang;
//   List<Village> villageList;
//
//   City({this.cityCode, this.cityName, this.lang, this.villageList});
//
//   factory City.fromJson(Map<String, dynamic> json) {
//     return City(
//       cityCode: json['cityCode'],
//       cityName: json['cityName'],
//       lang: json['lang'] != null
//           ? (json['lang'] as List).map((i) => Object.fromJson(i)).toList()
//           : null,
//       villageList: json['villageList'] != null
//           ? (json['villageList'] as List)
//               .map((i) => Village.fromJson(i))
//               .toList()
//           : null,
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['cityCode'] = this.cityCode;
//     data['cityName'] = this.cityName;
//     if (this.lang != null) {
//       data['lang'] = this.lang.map((v) => v.toJson()).toList();
//     }
//     if (this.villageList != null) {
//       data['villageList'] = this.villageList.map((v) => v.toJson()).toList();
//     }
//     return data;
//   }
// }
//
// class Village {
//   List<Object> lang;
//   String villageCode;
//   String villageName;
//
//   Village({this.lang, this.villageCode, this.villageName});
//
//   factory Village.fromJson(Map<String, dynamic> json) {
//     return Village(
//       lang: json['lang'] != null
//           ? (json['lang'] as List).map((i) => Object.fromJson(i)).toList()
//           : null,
//       villageCode: json['villageCode'],
//       villageName: json['villageName'],
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['villageCode'] = this.villageCode;
//     data['villageName'] = this.villageName;
//     if (this.lang != null) {
//       data['lang'] = this.lang.map((v) => v.toJson()).toList();
//     }
//     return data;
//   }
// }
//
// class AgentLogin {
//   String currentSeasonCode;
//   int fCropRevNo;
//   int farmRevNo;
//   int farmerRevNo;
//   int fsRevNo;
//
//   AgentLogin(
//       {this.currentSeasonCode,
//       this.fCropRevNo,
//       this.farmRevNo,
//       this.farmerRevNo,
//       this.fsRevNo});
//
//   factory AgentLogin.fromJson(Map<String, dynamic> json) {
//     return AgentLogin(
//       currentSeasonCode: json['currentSeasonCode'],
//       fCropRevNo: json['fCropRevNo'],
//       farmRevNo: json['farmRevNo'],
//       farmerRevNo: json['farmerRevNo'],
//       fsRevNo: json['fsRevNo'],
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['currentSeasonCode'] = this.currentSeasonCode;
//     data['fCropRevNo'] = this.fCropRevNo;
//     data['farmRevNo'] = this.farmRevNo;
//     data['farmerRevNo'] = this.farmerRevNo;
//     data['fsRevNo'] = this.fsRevNo;
//     return data;
//   }
// }
//
// class Data6 {
//   String procProdRevNo;
//   List<Object> products;
//
//   Data6({this.procProdRevNo, this.products});
//
//   factory Data6.fromJson(Map<String, dynamic> json) {
//     return Data6(
//       procProdRevNo: json['procProdRevNo'],
//       products: json['products'] != null
//           ? (json['products'] as List).map((i) => Object.fromJson(i)).toList()
//           : null,
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['procProdRevNo'] = this.procProdRevNo;
//     if (this.products != null) {
//       data['products'] = this.products.map((v) => v.toJson()).toList();
//     }
//     return data;
//   }
// }
//
// class Data1 {
//   String seasonRevNo;
//   List<Object> seasons;
//
//   Data1({this.seasonRevNo, this.seasons});
//
//   factory Data1.fromJson(Map<String, dynamic> json) {
//     return Data1(
//       seasonRevNo: json['seasonRevNo'],
//       seasons: json['seasons'] != null
//           ? (json['seasons'] as List).map((i) => Object.fromJson(i)).toList()
//           : null,
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['seasonRevNo'] = this.seasonRevNo;
//     if (this.seasons != null) {
//       data['seasons'] = this.seasons.map((v) => v.toJson()).toList();
//     }
//     return data;
//   }
// }
