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
//   Data11 data11;
//   Data2 data2;
//   Data6 data6;
//   Data8 data8;
//   Data9 data9;
//
//   Body(
//       {this.agentLogin,
//       this.data1,
//       this.data10,
//       this.data11,
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
//       data11: json['data11'] != null ? Data11.fromJson(json['data11']) : null,
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
//     if (this.data11 != null) {
//       data['data11'] = this.data11.toJson();
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
// class Data1 {
//   String seasonRevNo;
//   List<Season> seasons;
//
//   Data1({this.seasonRevNo, this.seasons});
//
//   factory Data1.fromJson(Map<String, dynamic> json) {
//     return Data1(
//       seasonRevNo: json['seasonRevNo'],
//       seasons: json['seasons'] != null
//           ? (json['seasons'] as List).map((i) => Season.fromJson(i)).toList()
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
//
// class Season {
//   String sCode;
//   String sName;
//
//   Season({this.sCode, this.sName});
//
//   factory Season.fromJson(Map<String, dynamic> json) {
//     return Season(
//       sCode: json['sCode'],
//       sName: json['sName'],
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['sCode'] = this.sCode;
//     data['sName'] = this.sName;
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
//   List<Product> products;
//
//   Data6({this.procProdRevNo, this.products});
//
//   factory Data6.fromJson(Map<String, dynamic> json) {
//     return Data6(
//       procProdRevNo: json['procProdRevNo'],
//       products: json['products'] != null
//           ? (json['products'] as List).map((i) => Product.fromJson(i)).toList()
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
// class Product {
//   String ppCode;
//   String ppName;
//   String ppUnit;
//   List<VrtLst> vrtLst;
//
//   Product({this.ppCode, this.ppName, this.ppUnit, this.vrtLst});
//
//   factory Product.fromJson(Map<String, dynamic> json) {
//     return Product(
//       ppCode: json['ppCode'],
//       ppName: json['ppName'],
//       ppUnit: json['ppUnit'],
//       vrtLst: json['vrtLst'] != null
//           ? (json['vrtLst'] as List).map((i) => VrtLst.fromJson(i)).toList()
//           : null,
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['ppCode'] = this.ppCode;
//     data['ppName'] = this.ppName;
//     data['ppUnit'] = this.ppUnit;
//     if (this.vrtLst != null) {
//       data['vrtLst'] = this.vrtLst.map((v) => v.toJson()).toList();
//     }
//     return data;
//   }
// }
//
// class VrtLst {
//   List<Object> grdLst;
//   List<Object> lang;
//   String ppVarCode;
//   String ppVarName;
//   List<Object> subvarLst;
//
//   VrtLst(
//       {this.grdLst, this.lang, this.ppVarCode, this.ppVarName, this.subvarLst});
//
//   factory VrtLst.fromJson(Map<String, dynamic> json) {
//     return VrtLst(
//       grdLst: json['grdLst'] != null
//           ? (json['grdLst'] as List).map((i) => Object.fromJson(i)).toList()
//           : null,
//       lang: json['lang'] != null
//           ? (json['lang'] as List).map((i) => Object.fromJson(i)).toList()
//           : null,
//       ppVarCode: json['ppVarCode'],
//       ppVarName: json['ppVarName'],
//       subvarLst: json['subvarLst'] != null
//           ? (json['subvarLst'] as List).map((i) => Object.fromJson(i)).toList()
//           : null,
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['ppVarCode'] = this.ppVarCode;
//     data['ppVarName'] = this.ppVarName;
//     if (this.grdLst != null) {
//       data['grdLst'] = this.grdLst.map((v) => v.toJson()).toList();
//     }
//     if (this.lang != null) {
//       data['lang'] = this.lang.map((v) => v.toJson()).toList();
//     }
//     if (this.subvarLst != null) {
//       data['subvarLst'] = this.subvarLst.map((v) => v.toJson()).toList();
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
//   String address1;
//   String coCode;
//   String coName;
//   String samTyp;
//
//   CoOperative({this.address1, this.coCode, this.coName, this.samTyp});
//
//   factory CoOperative.fromJson(Map<String, dynamic> json) {
//     return CoOperative(
//       address1: json['address1'],
//       coCode: json['coCode'],
//       coName: json['coName'],
//       samTyp: json['samTyp'],
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['address1'] = this.address1;
//     data['coCode'] = this.coCode;
//     data['coName'] = this.coName;
//     data['samTyp'] = this.samTyp;
//     return data;
//   }
// }
//
// class Data11 {
//   String prodRevNo;
//   List<ProductX> products;
//
//   Data11({this.prodRevNo, this.products});
//
//   factory Data11.fromJson(Map<String, dynamic> json) {
//     return Data11(
//       prodRevNo: json['prodRevNo'],
//       products: json['products'] != null
//           ? (json['products'] as List).map((i) => ProductX.fromJson(i)).toList()
//           : null,
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['prodRevNo'] = this.prodRevNo;
//     if (this.products != null) {
//       data['products'] = this.products.map((v) => v.toJson()).toList();
//     }
//     return data;
//   }
// }
//
// class ProductX {
//   String categoryCode;
//   String categoryName;
//   String ingredient;
//   String lang;
//   String langCat;
//   String manufacture;
//   String manufactureId;
//   String price;
//   String productCode;
//   String productName;
//   String unit;
//
//   ProductX(
//       {this.categoryCode,
//       this.categoryName,
//       this.ingredient,
//       this.lang,
//       this.langCat,
//       this.manufacture,
//       this.manufactureId,
//       this.price,
//       this.productCode,
//       this.productName,
//       this.unit});
//
//   factory ProductX.fromJson(Map<String, dynamic> json) {
//     return ProductX(
//       categoryCode: json['categoryCode'],
//       categoryName: json['categoryName'],
//       ingredient: json['ingredient'],
//       lang: json['lang'],
//       langCat: json['langCat'],
//       manufacture: json['manufacture'],
//       manufactureId: json['manufactureId'],
//       price: json['price'],
//       productCode: json['productCode'],
//       productName: json['productName'],
//       unit: json['unit'],
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['categoryCode'] = this.categoryCode;
//     data['categoryName'] = this.categoryName;
//     data['ingredient'] = this.ingredient;
//     data['lang'] = this.lang;
//     data['langCat'] = this.langCat;
//     data['manufacture'] = this.manufacture;
//     data['manufactureId'] = this.manufactureId;
//     data['price'] = this.price;
//     data['productCode'] = this.productCode;
//     data['productName'] = this.productName;
//     data['unit'] = this.unit;
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
//   String catHarvestInterval;
//   String catId;
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
//       catId: json['catId'],
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
//     data['catId'] = this.catId;
//     data['catName'] = this.catName;
//     data['catType'] = this.catType;
//     data['pCatId'] = this.pCatId;
//     data['seqNo'] = this.seqNo;
//     if (this.lang != null) {
//       data['lang'] = this.lang.map((v) => v.toJson()).toList();
//     }
//     return data;
//   }
// }
//
// class Data10 {
//   List<BatchCreation> batchCreationList;
//   List<InputDemand> inputDemandList;
//   List<InspReqData> inspReqData;
//   List<NurseryReg> nurseryReg;
//   List<Object> stocks;
//   List<Transfer> transferList;
//   List<VcaData> vcaData;
//   List<VcaRegData> vcaRegListData;
//   String vwsRevNo;
//
//   Data10(
//       {this.batchCreationList,
//       this.inputDemandList,
//       this.inspReqData,
//       this.nurseryReg,
//       this.stocks,
//       this.transferList,
//       this.vcaData,
//       this.vcaRegListData,
//       this.vwsRevNo});
//
//   factory Data10.fromJson(Map<String, dynamic> json) {
//     return Data10(
//       batchCreationList: json['batchCreationList'] != null
//           ? (json['batchCreationList'] as List)
//               .map((i) => BatchCreation.fromJson(i))
//               .toList()
//           : null,
//       inputDemandList: json['inputDemandList'] != null
//           ? (json['inputDemandList'] as List)
//               .map((i) => InputDemand.fromJson(i))
//               .toList()
//           : null,
//       inspReqData: json['inspReqData'] != null
//           ? (json['inspReqData'] as List)
//               .map((i) => InspReqData.fromJson(i))
//               .toList()
//           : null,
//       nurseryReg: json['nurseryReg'] != null
//           ? (json['nurseryReg'] as List)
//               .map((i) => NurseryReg.fromJson(i))
//               .toList()
//           : null,
//       stocks: json['stocks'] != null
//           ? (json['stocks'] as List).map((i) => Object.fromJson(i)).toList()
//           : null,
//       transferList: json['transferList'] != null
//           ? (json['transferList'] as List)
//               .map((i) => Transfer.fromJson(i))
//               .toList()
//           : null,
//       vcaData: json['vcaData'] != null
//           ? (json['vcaData'] as List).map((i) => VcaData.fromJson(i)).toList()
//           : null,
//       vcaRegListData: json['vcaRegListData'] != null
//           ? (json['vcaRegListData'] as List)
//               .map((i) => VcaRegData.fromJson(i))
//               .toList()
//           : null,
//       vwsRevNo: json['vwsRevNo'],
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['vwsRevNo'] = this.vwsRevNo;
//     if (this.batchCreationList != null) {
//       data['batchCreationList'] =
//           this.batchCreationList.map((v) => v.toJson()).toList();
//     }
//     if (this.inputDemandList != null) {
//       data['inputDemandList'] =
//           this.inputDemandList.map((v) => v.toJson()).toList();
//     }
//     if (this.inspReqData != null) {
//       data['inspReqData'] = this.inspReqData.map((v) => v.toJson()).toList();
//     }
//     if (this.nurseryReg != null) {
//       data['nurseryReg'] = this.nurseryReg.map((v) => v.toJson()).toList();
//     }
//     if (this.stocks != null) {
//       data['stocks'] = this.stocks.map((v) => v.toJson()).toList();
//     }
//     if (this.transferList != null) {
//       data['transferList'] = this.transferList.map((v) => v.toJson()).toList();
//     }
//     if (this.vcaData != null) {
//       data['vcaData'] = this.vcaData.map((v) => v.toJson()).toList();
//     }
//     if (this.vcaRegListData != null) {
//       data['vcaRegListData'] =
//           this.vcaRegListData.map((v) => v.toJson()).toList();
//     }
//     return data;
//   }
// }
//
// class Transfer {
//   String agentId;
//   String coffGrade;
//   String coffType;
//   String coffVariety;
//   String datetransfer;
//   String fCode;
//   String farmName;
//   String farmerName;
//   String frmName;
//   String isTransfered;
//   String noBags;
//   String processType;
//   String receiverId;
//   String receiverName;
//   String recptNo;
//   String seasonCode;
//   String senderId;
//   String senderName;
//   String stockType;
//   String totWtTransfd;
//   String trRecptNo;
//
//   Transfer(
//       {this.agentId,
//       this.coffGrade,
//       this.coffType,
//       this.coffVariety,
//       this.datetransfer,
//       this.fCode,
//       this.farmName,
//       this.farmerName,
//       this.frmName,
//       this.isTransfered,
//       this.noBags,
//       this.processType,
//       this.receiverId,
//       this.receiverName,
//       this.recptNo,
//       this.seasonCode,
//       this.senderId,
//       this.senderName,
//       this.stockType,
//       this.totWtTransfd,
//       this.trRecptNo});
//
//   factory Transfer.fromJson(Map<String, dynamic> json) {
//     return Transfer(
//       agentId: json['agentId'],
//       coffGrade: json['coffGrade'],
//       coffType: json['coffType'],
//       coffVariety: json['coffVariety'],
//       datetransfer: json['datetransfer'],
//       fCode: json['fCode'],
//       farmName: json['farmName'],
//       farmerName: json['farmerName'],
//       frmName: json['frmName'],
//       isTransfered: json['isTransfered'],
//       noBags: json['noBags'],
//       processType: json['processType'],
//       receiverId: json['receiverId'],
//       receiverName: json['receiverName'],
//       recptNo: json['recptNo'],
//       seasonCode: json['seasonCode'],
//       senderId: json['senderId'],
//       senderName: json['senderName'],
//       stockType: json['stockType'],
//       totWtTransfd: json['totWtTransfd'],
//       trRecptNo: json['trRecptNo'],
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['agentId'] = this.agentId;
//     data['coffGrade'] = this.coffGrade;
//     data['coffType'] = this.coffType;
//     data['coffVariety'] = this.coffVariety;
//     data['datetransfer'] = this.datetransfer;
//     data['fCode'] = this.fCode;
//     data['farmName'] = this.farmName;
//     data['farmerName'] = this.farmerName;
//     data['frmName'] = this.frmName;
//     data['isTransfered'] = this.isTransfered;
//     data['noBags'] = this.noBags;
//     data['processType'] = this.processType;
//     data['receiverId'] = this.receiverId;
//     data['receiverName'] = this.receiverName;
//     data['recptNo'] = this.recptNo;
//     data['seasonCode'] = this.seasonCode;
//     data['senderId'] = this.senderId;
//     data['senderName'] = this.senderName;
//     data['stockType'] = this.stockType;
//     data['totWtTransfd'] = this.totWtTransfd;
//     data['trRecptNo'] = this.trRecptNo;
//     return data;
//   }
// }
//
// class InputDemand {
//   String age;
//   String contactNumber;
//   String dId;
//   String date;
//   String demandQty;
//   String districtCode;
//   String fr_code;
//   String gender;
//   String input_Type;
//   String nin;
//   String productCode;
//   String receiptNo;
//   String seasonCode;
//   String village;
//   String wareHouse;
//
//   InputDemand(
//       {this.age,
//       this.contactNumber,
//       this.dId,
//       this.date,
//       this.demandQty,
//       this.districtCode,
//       this.fr_code,
//       this.gender,
//       this.input_Type,
//       this.nin,
//       this.productCode,
//       this.receiptNo,
//       this.seasonCode,
//       this.village,
//       this.wareHouse});
//
//   factory InputDemand.fromJson(Map<String, dynamic> json) {
//     return InputDemand(
//       age: json['age'],
//       contactNumber: json['contactNumber'],
//       dId: json['dId'],
//       date: json['date'],
//       demandQty: json['demandQty'],
//       districtCode: json['districtCode'],
//       fr_code: json['fr_code'],
//       gender: json['gender'],
//       input_Type: json['input_Type'],
//       nin: json['nin'],
//       productCode: json['productCode'],
//       receiptNo: json['receiptNo'],
//       seasonCode: json['seasonCode'],
//       village: json['village'],
//       wareHouse: json['wareHouse'],
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['age'] = this.age;
//     data['contactNumber'] = this.contactNumber;
//     data['dId'] = this.dId;
//     data['date'] = this.date;
//     data['demandQty'] = this.demandQty;
//     data['districtCode'] = this.districtCode;
//     data['fr_code'] = this.fr_code;
//     data['gender'] = this.gender;
//     data['input_Type'] = this.input_Type;
//     data['nin'] = this.nin;
//     data['productCode'] = this.productCode;
//     data['receiptNo'] = this.receiptNo;
//     data['seasonCode'] = this.seasonCode;
//     data['village'] = this.village;
//     data['wareHouse'] = this.wareHouse;
//     return data;
//   }
// }
//
// class BatchCreation {
//   String batchNo;
//   String grade;
//   String isDelete;
//   String noOfBag;
//   String stockType;
//   String weight;
//
//   BatchCreation(
//       {this.batchNo,
//       this.grade,
//       this.isDelete,
//       this.noOfBag,
//       this.stockType,
//       this.weight});
//
//   factory BatchCreation.fromJson(Map<String, dynamic> json) {
//     return BatchCreation(
//       batchNo: json['batchNo'],
//       grade: json['grade'],
//       isDelete: json['isDelete'],
//       noOfBag: json['noOfBag'],
//       stockType: json['stockType'],
//       weight: json['weight'],
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['batchNo'] = this.batchNo;
//     data['grade'] = this.grade;
//     data['isDelete'] = this.isDelete;
//     data['noOfBag'] = this.noOfBag;
//     data['stockType'] = this.stockType;
//     data['weight'] = this.weight;
//     return data;
//   }
// }
//
// class InspReqData {
//   String address;
//   String capacity;
//   String email;
//   String insAppName;
//   String insCerNo;
//   String insDist;
//   String insId;
//   String insName;
//   String insParish;
//   String insSubCnt;
//   String insType;
//   String insUniqueId;
//   String insVill;
//   String telePho;
//
//   InspReqData(
//       {this.address,
//       this.capacity,
//       this.email,
//       this.insAppName,
//       this.insCerNo,
//       this.insDist,
//       this.insId,
//       this.insName,
//       this.insParish,
//       this.insSubCnt,
//       this.insType,
//       this.insUniqueId,
//       this.insVill,
//       this.telePho});
//
//   factory InspReqData.fromJson(Map<String, dynamic> json) {
//     return InspReqData(
//       address: json['address'],
//       capacity: json['capacity'],
//       email: json['email'],
//       insAppName: json['insAppName'],
//       insCerNo: json['insCerNo'],
//       insDist: json['insDist'],
//       insId: json['insId'],
//       insName: json['insName'],
//       insParish: json['insParish'],
//       insSubCnt: json['insSubCnt'],
//       insType: json['insType'],
//       insUniqueId: json['insUniqueId'],
//       insVill: json['insVill'],
//       telePho: json['telePho'],
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['address'] = this.address;
//     data['capacity'] = this.capacity;
//     data['email'] = this.email;
//     data['insAppName'] = this.insAppName;
//     data['insCerNo'] = this.insCerNo;
//     data['insDist'] = this.insDist;
//     data['insId'] = this.insId;
//     data['insName'] = this.insName;
//     data['insParish'] = this.insParish;
//     data['insSubCnt'] = this.insSubCnt;
//     data['insType'] = this.insType;
//     data['insUniqueId'] = this.insUniqueId;
//     data['insVill'] = this.insVill;
//     data['telePho'] = this.telePho;
//     return data;
//   }
// }
//
// class VcaData {
//   String actCat;
//   String applicantName;
//   String applicantType;
//   String certNo;
//   String districtCode;
//   String mobileNum;
//   String regNum;
//   String vId;
//   String vilCode;
//   String vilName;
//
//   VcaData(
//       {this.actCat,
//       this.applicantName,
//       this.applicantType,
//       this.certNo,
//       this.districtCode,
//       this.mobileNum,
//       this.regNum,
//       this.vId,
//       this.vilCode,
//       this.vilName});
//
//   factory VcaData.fromJson(Map<String, dynamic> json) {
//     return VcaData(
//       actCat: json['actCat'],
//       applicantName: json['applicantName'],
//       applicantType: json['applicantType'],
//       certNo: json['certNo'],
//       districtCode: json['districtCode'],
//       mobileNum: json['mobileNum'],
//       regNum: json['regNum'],
//       vId: json['vId'],
//       vilCode: json['vilCode'],
//       vilName: json['vilName'],
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['actCat'] = this.actCat;
//     data['applicantName'] = this.applicantName;
//     data['applicantType'] = this.applicantType;
//     data['certNo'] = this.certNo;
//     data['districtCode'] = this.districtCode;
//     data['mobileNum'] = this.mobileNum;
//     data['regNum'] = this.regNum;
//     data['vId'] = this.vId;
//     data['vilCode'] = this.vilCode;
//     data['vilName'] = this.vilName;
//     return data;
//   }
// }
//
// class VcaRegData {
//   String address;
//   String applicantName;
//   String applicantType;
//   String cerNo;
//   String districtCode;
//   String email;
//   String regNo;
//   String telePho;
//   String vId;
//   String vcaCat;
//   String vilCode;
//   String vilName;
//
//   VcaRegData(
//       {this.address,
//       this.applicantName,
//       this.applicantType,
//       this.cerNo,
//       this.districtCode,
//       this.email,
//       this.regNo,
//       this.telePho,
//       this.vId,
//       this.vcaCat,
//       this.vilCode,
//       this.vilName});
//
//   factory VcaRegData.fromJson(Map<String, dynamic> json) {
//     return VcaRegData(
//       address: json['address'],
//       applicantName: json['applicantName'],
//       applicantType: json['applicantType'],
//       cerNo: json['cerNo'],
//       districtCode: json['districtCode'],
//       email: json['email'],
//       regNo: json['regNo'],
//       telePho: json['telePho'],
//       vId: json['vId'],
//       vcaCat: json['vcaCat'],
//       vilCode: json['vilCode'],
//       vilName: json['vilName'],
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['address'] = this.address;
//     data['applicantName'] = this.applicantName;
//     data['applicantType'] = this.applicantType;
//     data['cerNo'] = this.cerNo;
//     data['districtCode'] = this.districtCode;
//     data['email'] = this.email;
//     data['regNo'] = this.regNo;
//     data['telePho'] = this.telePho;
//     data['vId'] = this.vId;
//     data['vcaCat'] = this.vcaCat;
//     data['vilCode'] = this.vilCode;
//     data['vilName'] = this.vilName;
//     return data;
//   }
// }
//
// class NurseryReg {
//   String address;
//   String appliType;
//   String city;
//   String district;
//   String fullName;
//   String mail;
//   String mobileNum;
//   String nurId;
//   String opName;
//   String state;
//   String village;
//
//   NurseryReg(
//       {this.address,
//       this.appliType,
//       this.city,
//       this.district,
//       this.fullName,
//       this.mail,
//       this.mobileNum,
//       this.nurId,
//       this.opName,
//       this.state,
//       this.village});
//
//   factory NurseryReg.fromJson(Map<String, dynamic> json) {
//     return NurseryReg(
//       address: json['address'],
//       appliType: json['appliType'],
//       city: json['city'],
//       district: json['district'],
//       fullName: json['fullName'],
//       mail: json['mail'],
//       mobileNum: json['mobileNum'],
//       nurId: json['nurId'],
//       opName: json['opName'],
//       state: json['state'],
//       village: json['village'],
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['address'] = this.address;
//     data['appliType'] = this.appliType;
//     data['city'] = this.city;
//     data['district'] = this.district;
//     data['fullName'] = this.fullName;
//     data['mail'] = this.mail;
//     data['mobileNum'] = this.mobileNum;
//     data['nurId'] = this.nurId;
//     data['opName'] = this.opName;
//     data['state'] = this.state;
//     data['village'] = this.village;
//     return data;
//   }
// }
