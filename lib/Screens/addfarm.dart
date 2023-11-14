// import 'dart:convert';
// import 'dart:core';
// import 'dart:math';
//
//
// import 'package:flutter/material.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:intl/intl.dart';
//
// import 'dart:io' show File;
//
// import 'package:rflutter_alert/rflutter_alert.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// import '../../../main.dart';
//
// import '../Database/Databasehelper.dart';
// import '../Database/Model/FarmerMaster.dart';
// import '../Model/Geoareascalculate.dart';
// import '../Model/Treelistmodel.dart';
// import '../Model/UIModel.dart';
// import '../Model/dynamicfields.dart';
// import '../Plugins/TxnExecutor.dart';
// import '../Utils/MandatoryDatas.dart';
// import 'geoploattingProposedLand.dart';
// import 'geoplottingaddfarm.dart';
// import 'navigation.dart';
//
// File? _imagefarmer, _image_farm;
//
// final Map<String, String> gpsmode = {
//   'option1': "Manual Mode GPS",
//   'option2': "MAP Mode GPS",
// };
//
// final Map<String, String> laserlevel = {
//   'option1': "Yes",
//   'option2': "No",
// };
//
// final Map<String, String> qualifylevel = {
//   'option1': "Yes",
//   'option2': "No",
// };
//
// class AddFarm extends StatefulWidget {
//   @override
//   State<StatefulWidget> createState() {
//     return _AddFarm();
//   }
// }
//
// class _AddFarm extends State<AddFarm> {
//   bool sameaddress = false;
//   List<FarmerMaster> farmermaster = [];
//   TextEditingController? farmnameController,
//       surveynocontroller,
//       farmaddcontroller,
//       totlandcontroller,
//       proposedcontroller,
//       totwaterController,
//       lastyryieldcontroller,
//       fulltimeController,
//       parttimeController,
//       seasonalController,
//       convenController,
//       falpasController,
//       concrpController,
//       insnmeController,
//       sanctionController,
//       landmrkController,
//       dursancController;
//   String slct_gpsmode = gpsmode.keys.first, farmerImg64 = "", farmImg64 = '';
//   String Lat = '0', Lng = '0', certtype = "1";
//   String selectedval = "option 1";
//   File? _imagefile;
//   File? _imagefilefarm;
//   var db = DatabaseHelper();
//   bool isirrigated = false;
//   final List<DropdownMenuItem> owneritems = [],
//       topographyitems = [],
//       soiltextureitems = [],
//       gradientitems = [],
//       approachroaditems = [],
//       irrigationitems = [],
//       irrigationtypitems = [];
//
//   String slct_owner = "", slct_topography = "", slct_irrigation = "";
//
//   String val_owner = "",
//       val_topography = "",
//       val_gradient = "",
//       val_approach = "",
//       val_irrigation = "";
//   /*Country Name Dropdown*/
//   List<DropdownMenuItem> countryNameDropDownLists = [];
//   String slctCountryName = '', valCountryName = '', slctCountryNameId = '';
//   List<UImodel> countryNameUIModel = [];
//   /*County Name Dropdown*/
//   bool stateLoaded = false;
//   List<DropdownMenuItem> stateitems = [];
//   String slctState = '', val_State = '';
//   List<UImodel> stateUIModel = [];
//   /*Sub-Country Name Dropdown*/
//   bool isSubCountryLoaded = false;
//   List<DropdownMenuItem> subCountryNameDropDownLists = [];
//   String slctSubCountryName = '',
//       valSubCountryName = '',
//       slctSubCountryNameId = '';
//   List<UImodel> subCountryNameUIModel = [];
//
//   /*Ward Name Dropdown*/
//   bool isWardLoaded = false;
//   List<DropdownMenuItem> wardNameDropDownLists = [];
//   String slctWardName = '', valWardName = '', slctWardNameId = '';
//   List<UImodel> wardNameUIModel = [];
//
//   /*Village Name Dropdown*/
//   bool isVillageLoaded = false;
//   List<DropdownMenuItem> villageNameDropDownLists = [];
//   String slctVillageName = '', valVillageName = '', slctVillageNameId = '';
//   List<UImodel> villageNameUIModel = [];
//
//   List<int> selectedgradient = [];
//   List<int> selectedapproach = [];
//   List<int> selectedirrigation = [];
//   List<int> selectedirrigationtyp = [];
//   List<int> selectedsoil = [];
//   List<int> selectedirmtd = [];
//   List<int> selectedsrc = [];
//   List<int> slct_soilText = [];
//   /*Same as Farmer Address?*/
//   bool sameFarmeraddress = false;
//   String isFarmerSameAddress = '0';
//
//   List<UImodel> ownerUIModel = [];
//   List<UImodel> topoUIModel = [];
//   List<UImodel> soilTextureUIModel = [];
//   List<UImodel> gradientUIModel = [];
//   List<UImodel> approachUIModel = [];
//   List<UImodel> irrigationUIModel = [];
//   List<UImodel> irrigationtypUIModel = [];
//
//   String? servicePointId;
//   String? seasoncode;
//
//   String villageCode = "";
//
//   bool quali = false;
//   bool farmdataadded = false;
//   bool landdataadded = false;
//   bool onlinefarmdata = false;
//   bool onlinelanddata = false;
//   List<Map>? agents;
//   String totArea = "";
//   String totMapArea = "";
//   String approchroads = "";
//   String irrTypes = "";
//   String irrigationTypes = "";
//   /*Group Name Dropdown*/
//   bool isGroupLoaded = false;
//   bool varietyLoaded = false;
//   List<DropdownMenuItem> groupNameDropDownLists = [];
//   String slctGroupName = '', valGroupName = '', slctGroupNameId = '';
//   List<UImodel> groupNameUIModel = [];
//   // String slct_soilText = "";
//   String val_soilText = "";
//
//   /*Land Ownership Dropdown*/
//   List<DropdownMenuItem> landOwnrshipDropDownLists = [];
//   List<DropdownMenuItem> SoilTypDropDownLists = [];
//   List<DropdownMenuItem> IrrigatTypDropDownLists = [];
//   List<DropdownMenuItem> CropTypDropDownLists = [];
//   List<DropdownMenuItem> VartyDropDownLists = [];
//   List<DropdownMenuItem> AgetreeDropDownLists = [];
//   String slctLandOwnrship = '', valLandOwnrship = '', slctLandOwnrshipId = '';
//   String slctSoiltyp = '', slctSoiltypId = '';
//   String slctIrrigattyp = '', slctIrrigattypId = '';
//   String slctCroptyp = '', slctCrptypId = '';
//   String slctVrtyp = '', slctVartypId = '';
//   String slctAgetreetyp = '', slctAgetreetypId = '';
//   List<UImodel> landOwnrshipUIModel = [];
//   List<UImodel> IrrigatUIModel = [];
//   List<UImodel> cropUIModel = [];
//   List<UImodel> vartyUIModel = [];
//   List<UImodel> SoiltypUIModel = [];
//   List<UImodel> agetreeUIModel = [];
//   Geoareascalculate? totalArea, proposedtotalArea;
//
//   List<UImodel> villagelistUIModel = [];
//   List<UImodel2> farmerlistUIModel = [];
//   List<UImodel> certlistUIModel = [];
//   List<UImodel> statuslistUIModel = [];
//   List<UImodel> soillistUIModel = [];
//   List<UImodel> fertlistUIModel = [];
//   List<UImodel> irmtdlistUIModel = [];
//   List<UImodel> srclistUIModel = [];
//   /*Number of matured trees*/
//   TextEditingController noOfMaturdTreesController = new TextEditingController();
//
//   /*Number of young trees*/
//   TextEditingController noOfYoungTreesController = new TextEditingController();
//   /*Farm Name*/
//   TextEditingController farmNameController = new TextEditingController();
//   /*Address*/
//   TextEditingController addressController = new TextEditingController();
//   TextEditingController totalLndSizeAcreController =
//       new TextEditingController();
//   List<Treelistmodel> TreeModelList = [];
//   List<DropdownMenuItem> certitems = [],
//       statusitems = [],
//       soilitems = [],
//       fertitems = [],
//       irmtditems = [],
//       srcitems = [];
//   String slct_village = "",
//       slct_farmer = "",
//       slct_cert = "",
//       slct_status = "",
//       slct_soil = "",
//       slct_fert = "",
//       val_fert = "";
//   String val_village = "",
//       val_farmer = "",
//       farmerId = "",
//       farmerAddress = "",
//       ffarmerId = "";
//
//   /*Type of Production Dropdown*/
//   List<DropdownMenuItem> prodTypeDropDownLists = [];
//   String slctProdType = '', valProdType = '', slctProdTypeId = '';
//   List<UImodel> prodTypeUIModel = [];
//   bool ishavefarmercode = false;
//   String lastdate = 'Last Date of Chemical Appliction';
//   String insdate = 'Date of Inspection';
//   final Map<String, String> borewells = {
//     'option1': "NO",
//     'option2': "YES",
//   };
//   String _selectedBore = "2";
//   String SELCTEDBore = "option1";
//   bool farmerloaded = false;
//
//   List<DropdownModel> farmeritems = [];
//   DropdownModel? slctFarmers;
//
//   List<DropdownModel> villageitems = [];
//   DropdownModel? slctvillages;
//
//   List<DropdownModel> landitems = [];
//   DropdownModel? slctlands;
//
//   List<DropdownModel> soilTypitems = [];
//   DropdownModel? slctsoilTyps;
//
//   List<DropdownModel> irrigationMitems = [];
//   DropdownModel? slctirrigationMs;
//
//   List<DropdownModel> cropitems = [];
//   DropdownModel? slctcrops;
//
//   List<DropdownModel> varietyitems = [];
//   DropdownModel? slctvarietys;
//
//   List<DropdownModel> treeitems = [];
//   DropdownModel? slcttrees;
//
//   List<DropdownModel> productionitems = [];
//   DropdownModel? slctproductions;
//
//   String cancel = 'Cancel';
//   String rusurecancel = 'Are you sure want to cancel?';
//   String yes = 'Yes';
//   String no = 'No';
//   String gpslocation = 'GPS Location not enabled';
//   String ok = 'OK';
//   String info = 'Information';
//   String addfarm = 'Add Farm';
//   String village = 'Village';
//   String VillageHint = 'Select the Village';
//   String farmer = 'Farmer';
//   String farmerHint = 'Select for Farmer';
//   String submit = 'Submit';
//   String infofarmer = 'Farmer should not be empty';
//   String infovillage = 'Village should not be empty';
//   String farmname = 'Farm Name';
//   String farmphoto = 'Farm Photo';
//   String chse = 'Choose';
//   String galry = 'Gallery';
//   String pickimg = 'Pick Image';
//   String Camera = 'Camera';
//   String samefarmeraddress = 'Same as Farmer Address';
//   String farmaddress = 'Farm Address';
//   String totallandsize = 'Total Land Size (Ha)';
//   String landowner = 'Land Ownership';
//   String landownerHint = 'Select the Land Ownership';
//   String nomaturetrees = 'No. of Trees';
//   String productiontype = 'Type of Production';
//   String productionHint = 'Select the type of production';
//   String soiltype = "Soil Type";
//   String soiltypeHint = 'Select the Soil Type';
//   String irrigation = 'Irrigation';
//   String irrigationHint = 'Select the Irrigation';
//   String maincrop = 'Main Crop';
//   String maincropHint = 'Select the Main Crop';
//   String variety = 'Variety';
//   String varietyHint = 'Select the Variety';
//   String ageoftrees = 'Age of Trees';
//   String ageoftreesHint = 'Select the Age of Trees';
//   String delete = 'Delete';
//   String farmnamealert = 'Farm Name should not be empty';
//   String farmphotoalert = 'Farm Photo should not be empty';
//   String varietyexistalert = 'Variety already exist.';
//   String farmaddressalert = 'Farm Address should not be empty';
//   String totallandsizealert = 'Total Land Size(Ha) should not be empty';
//   String landowneralert = 'Land Ownership should not be empty';
//   String ageoftreesalert = 'Age of Trees should not be empty';
//   String maturedtreesalert = 'No. of Trees should not be empty';
//   String productiontypealert = 'Type of Production should not be empty';
//
//   String valsoilType = 'Soil Type should not be empty';
//   String valirrigationType = 'Irrigation should not be empty';
//   String valatleastCrp = 'Add at least a Crop';
//
//   String conformation = 'Confirmation';
//   String proceed = 'Are you sure you want to Proceed?';
//   String pickimage = 'Pick Image';
//   String choose = 'Choose';
//   String add = 'Add';
//   String gallery = 'Gallery';
//   String camera = 'Camera';
//   String deny = 'deny';
//   String onlytym = 'only this time';
//   String whiluseapp = 'While using the app ';
//   String Allowtakepic = 'Allow IronKettle to take picture and record video?';
//   String transactionsuccesfull = 'Transaction Successful';
//   String farmsuccess = 'Farm Successful';
//   String receiptid = 'Your Receipt ID is :';
//
//   @override
//   void initState() {
//     super.initState();
//     initvalues();
//     getClientData();
//     farmnameController = new TextEditingController();
//     surveynocontroller = new TextEditingController();
//     //farmregnocontroller = new TextEditingController();
//     farmaddcontroller = new TextEditingController();
//     totlandcontroller = new TextEditingController();
//     proposedcontroller = new TextEditingController();
//     totwaterController = new TextEditingController();
//     lastyryieldcontroller = new TextEditingController();
//     fulltimeController = new TextEditingController();
//     parttimeController = new TextEditingController();
//     seasonalController = new TextEditingController();
//     convenController = new TextEditingController();
//     falpasController = new TextEditingController();
//     concrpController = new TextEditingController();
//     insnmeController = new TextEditingController();
//     sanctionController = new TextEditingController();
//     landmrkController = new TextEditingController();
//     dursancController = new TextEditingController();
//     getLocation();
//     initdata();
//     translate();
//   }
//
//   void getLocation() async {
//     bool isLocationEnabled = await Geolocator.isLocationServiceEnabled();
//     if (isLocationEnabled) {
//       Position position = await Geolocator.getCurrentPosition(
//           desiredAccuracy: LocationAccuracy.high);
//
//       print("latitude :" +
//           position.latitude.toString() +
//           " longitude: " +
//           position.longitude.toString());
//       setState(() {
//         Lat = position.latitude.toString();
//         Lng = position.longitude.toString();
//       });
//     } else {
//       Alert(context: context, title: info, desc: gpslocation, buttons: [
//         DialogButton(
//           child: Text(
//             ok,
//             style: TextStyle(color: Colors.white, fontSize: 18),
//           ),
//           onPressed: () {
//             Navigator.pop(context);
//             Navigator.pop(context);
//           },
//           color: Colors.green,
//         )
//       ]).show();
//     }
//   }
//
//   void translate() async {
//     try {
//       String? Lang = '';
//       try {
//         SharedPreferences prefs = await SharedPreferences.getInstance();
//         Lang = prefs.getString("langCode");
//       } catch (e) {
//         Lang = 'en';
//       }
//
//       String qry =
//           'select * from labelNamechange where tenantID =  \'cediam\' and lang = \'' +
//               Lang! +
//               '\'';
//
//       print('Lanquery' + qry);
//       List transList = await db.RawQuery(qry);
//       print('translist:' + transList.toString());
//       for (int i = 0; i < transList.length; i++) {
//         String classname = transList[i]['className'];
//         String labelName = transList[i]['labelName'];
//         switch (classname) {
//           case 'cancel':
//             setState(() {
//               cancel = labelName;
//             });
//             break;
//           case 'rusurecancel':
//             setState(() {
//               rusurecancel = labelName;
//             });
//             break;
//           case "gallery":
//             setState(() {
//               galry = labelName;
//             });
//             break;
//           case "pickimage":
//             setState(() {
//               pickimg = labelName;
//             });
//             break;
//           case "choose":
//             setState(() {
//               chse = labelName;
//             });
//             break;
//           case "camera":
//             setState(() {
//               Camera = labelName;
//             });
//             break;
//           case 'yes':
//             setState(() {
//               yes = labelName;
//             });
//             break;
//           case 'no':
//             setState(() {
//               no = labelName;
//             });
//             break;
//           case 'gpslocation':
//             setState(() {
//               gpslocation = labelName;
//             });
//             break;
//           case 'ok':
//             setState(() {
//               ok = labelName;
//             });
//             break;
//           case 'info':
//             setState(() {
//               info = labelName;
//             });
//             break;
//           case 'addfarm':
//             setState(() {
//               addfarm = labelName;
//             });
//             break;
//           case 'village':
//             setState(() {
//               village = labelName;
//             });
//             break;
//           case 'VillageHint':
//             setState(() {
//               VillageHint = labelName;
//             });
//             break;
//           case 'farmer':
//             setState(() {
//               farmer = labelName;
//             });
//             break;
//           case 'farmerHint':
//             setState(() {
//               farmerHint = labelName;
//             });
//             break;
//           case 'submit':
//             setState(() {
//               submit = labelName;
//             });
//             break;
//           case 'infofarmer':
//             setState(() {
//               infofarmer = labelName;
//             });
//             break;
//           case 'infovillage':
//             setState(() {
//               infovillage = labelName;
//             });
//             break;
//           case 'farmname':
//             setState(() {
//               farmname = labelName;
//             });
//             break;
//           case 'farmphoto':
//             setState(() {
//               farmphoto = labelName;
//             });
//             break;
//           case 'samefarmeraddress':
//             setState(() {
//               samefarmeraddress = labelName;
//             });
//             break;
//           case 'farmaddress':
//             setState(() {
//               farmaddress = labelName;
//             });
//             break;
//           case 'totallandsize':
//             setState(() {
//               totallandsize = labelName;
//             });
//             break;
//           case 'landowner':
//             setState(() {
//               landowner = labelName;
//             });
//             break;
//           case 'landownerHint':
//             setState(() {
//               landownerHint = labelName;
//             });
//             break;
//           case 'nomaturetrees':
//             setState(() {
//               nomaturetrees = labelName;
//             });
//             break;
//           case 'productiontype':
//             setState(() {
//               productiontype = labelName;
//             });
//             break;
//           case 'productionHint':
//             setState(() {
//               productionHint = labelName;
//             });
//             break;
//           case 'soiltype':
//             setState(() {
//               soiltype = labelName;
//             });
//             break;
//           case 'soiltypeHint':
//             setState(() {
//               soiltypeHint = labelName;
//             });
//             break;
//           case 'irrigation':
//             setState(() {
//               irrigation = labelName;
//             });
//             break;
//           case 'irrigationHint':
//             setState(() {
//               irrigationHint = labelName;
//             });
//             break;
//           case 'maincrop':
//             setState(() {
//               maincrop = labelName;
//             });
//             break;
//           case 'maincropHint':
//             setState(() {
//               maincropHint = labelName;
//             });
//             break;
//           case 'variety':
//             setState(() {
//               variety = labelName;
//             });
//             break;
//           case 'varietyHint':
//             setState(() {
//               varietyHint = labelName;
//             });
//             break;
//           case 'ageoftrees':
//             setState(() {
//               ageoftrees = labelName;
//             });
//             break;
//           case 'ageoftreesHint':
//             setState(() {
//               ageoftreesHint = labelName;
//             });
//             break;
//           case 'delete':
//             setState(() {
//               delete = labelName;
//             });
//             break;
//           case 'farmnamealert':
//             setState(() {
//               farmnamealert = labelName;
//             });
//             break;
//           case 'farmphotoalert':
//             setState(() {
//               farmphotoalert = labelName;
//             });
//             break;
//           case 'farmaddressalert':
//             setState(() {
//               farmaddressalert = labelName;
//             });
//             break;
//           case 'totallandsizealert':
//             setState(() {
//               totallandsizealert = labelName;
//             });
//             break;
//           case 'landowneralert':
//             setState(() {
//               landowneralert = labelName;
//             });
//             break;
//           case 'ageoftreesalert':
//             setState(() {
//               ageoftreesalert = labelName;
//             });
//             break;
//           case 'maturedtreesalert':
//             setState(() {
//               maturedtreesalert = labelName;
//             });
//             break;
//           case 'productiontypealert':
//             setState(() {
//               productiontypealert = labelName;
//             });
//             break;
//           case 'confirm':
//             setState(() {
//               conformation = labelName;
//             });
//             break;
//           case 'ArewntPrcd':
//             setState(() {
//               proceed = labelName;
//             });
//             break;
//           case 'pickimage':
//             setState(() {
//               pickimage = labelName;
//             });
//             break;
//           case 'choose':
//             setState(() {
//               choose = labelName;
//             });
//             break;
//           case 'gallery':
//             setState(() {
//               gallery = labelName;
//             });
//             break;
//           case 'camera':
//             setState(() {
//               camera = labelName;
//             });
//             break;
//           case 'transactionsuccesfull':
//             setState(() {
//               transactionsuccesfull = labelName;
//             });
//             break;
//           case 'farmsuccess':
//             setState(() {
//               farmsuccess = labelName;
//             });
//             break;
//           case 'Allowtakepic':
//             setState(() {
//               Allowtakepic = labelName;
//             });
//             break;
//           case 'deny':
//             setState(() {
//               deny = labelName;
//             });
//             break;
//           case 'whiluseapp':
//             setState(() {
//               whiluseapp = labelName;
//             });
//             break;
//           case 'Vartyslcted':
//             setState(() {
//               varietyexistalert = labelName;
//             });
//             break;
//           case 'onlytym':
//             setState(() {
//               onlytym = labelName;
//             });
//             break;
//           case 'soiltypemp':
//             setState(() {
//               valsoilType = labelName;
//             });
//             break;
//           case 'irrigationTypemp':
//             setState(() {
//               valirrigationType = labelName;
//             });
//             break;
//           case 'addatlstcrp':
//             setState(() {
//               valatleastCrp = labelName;
//             });
//             break;
//         }
//       }
//     } catch (e) {
//       print('translation err' + e.toString());
//     }
//   }
//
//   /*initdata() Method*/
//   Future<void> initdata() async {
//     //Groups
//     List groups = await db.RawQuery(
//         'select distinct sam.samCode,sam.samName from samitee sam,agentSamiteeList agentsam,farmer_master frmr where agentsam.samCode=sam.samCode and frmr.samithiCode=agentsam.samCode');
//     print('groups ' + groups.toString());
//     groupNameUIModel = [];
//     //groupList.clear();
//     groupNameDropDownLists.clear();
//     for (int i = 0; i < groups.length; i++) {
//       String samName = groups[i]["samName"].toString();
//       String samCode = groups[i]["samCode"].toString();
//
//       var uimodel = new UImodel(samName, samCode);
//       groupNameUIModel.add(uimodel);
//       setState(() {
//         groupNameDropDownLists.add(DropdownMenuItem(
//           child: Text(samName),
//           value: samName,
//         ));
//         //groupList.add(samName);
//       });
//     }
//     /*Get Country Data From countryList Table - Country Data*/
//     String countryQry = 'select * from countryList';
//     List countryList = await db.RawQuery(countryQry);
//
//     countryNameDropDownLists = [];
//     countryNameUIModel.clear();
//
//     if (countryList.length > 0) {
//       for (int i = 0; i < countryList.length; i++) {
//         String countryCode = countryList[i]["countryCode"].toString();
//         String countryName = countryList[i]["countryName"].toString();
//
//         var uiModel = new UImodel(countryName, countryCode);
//         countryNameUIModel.add(uiModel);
//
//         setState(() {
//           countryNameDropDownLists.add(DropdownMenuItem(
//             child: Text(countryName),
//             value: countryName,
//           ));
//         });
//       }
//     } else {
//       print('There is no data from countryList table -- Country Name');
//     }
//
//     /*Land Ownership Dropdown*/
//     landOwnrshipUIModel = [];
//     landOwnrshipDropDownLists = [];
//     landitems.clear();
//     String ownershipQry =
//         'select * from animalCatalog where catalog_code =\'42\'';
//     List landOwnrshipList = await db.RawQuery(ownershipQry);
//     for (int i = 0; i < landOwnrshipList.length; i++) {
//       String DISP_SEQ = landOwnrshipList[i]["DISP_SEQ"].toString();
//       String property_value = landOwnrshipList[i]["property_value"].toString();
//       var uimodel = new UImodel(property_value, DISP_SEQ);
//       landOwnrshipUIModel.add(uimodel);
//       setState(() {
//         landitems.add(DropdownModel(
//           property_value,
//           DISP_SEQ,
//         ));
//         //prooflist.add(property_value);
//       });
//     }
//     /*soil type Dropdown*/
//     SoiltypUIModel = [];
//     SoilTypDropDownLists = [];
//     soilTypitems.clear();
//     String soiltypQry = 'select * from animalCatalog where catalog_code =\'8\'';
//     List soiltypList = await db.RawQuery(soiltypQry);
//     for (int i = 0; i < soiltypList.length; i++) {
//       String DISP_SEQ = soiltypList[i]["DISP_SEQ"].toString();
//       String property_value = soiltypList[i]["property_value"].toString();
//       var uimodel = new UImodel(property_value, DISP_SEQ);
//       SoiltypUIModel.add(uimodel);
//       setState(() {
//         soilTypitems.add(DropdownModel(
//           property_value,
//           DISP_SEQ,
//         ));
//         //prooflist.add(property_value);
//       });
//     }
//     /*Irrigation type Dropdown*/
//     IrrigatUIModel = [];
//     IrrigatTypDropDownLists = [];
//     irrigationMitems.clear();
//     String irritypQry =
//         'select * from animalCatalog where catalog_code =\'81\'';
//     List irritypList = await db.RawQuery(irritypQry);
//     for (int i = 0; i < irritypList.length; i++) {
//       String DISP_SEQ = irritypList[i]["DISP_SEQ"].toString();
//       String property_value = irritypList[i]["property_value"].toString();
//       var uimodel = new UImodel(property_value, DISP_SEQ);
//       IrrigatUIModel.add(uimodel);
//       setState(() {
//         irrigationMitems.add(DropdownModel(
//           property_value,
//           DISP_SEQ,
//         ));
//         //prooflist.add(property_value);
//       });
//     }
//     /*crop type Dropdown*/
//     cropUIModel = [];
//     CropTypDropDownLists = [];
//     cropitems.clear();
//     String croptypQry =
//         'SELECT c.fcode,c.fname,c.cropType from cropList as c inner join varietyList as v on c.fcode = v.prodId group by c.fcode order by c.fname asc';
//     List croptypList = await db.RawQuery(croptypQry);
//     for (int i = 0; i < croptypList.length; i++) {
//       String property_value = croptypList[i]["fname"].toString();
//       String DISP_SEQ = croptypList[i]["fcode"].toString();
//       slctCrptypId = croptypList[i]["fcode"].toString();
//       var uimodel = new UImodel(DISP_SEQ, property_value);
//       cropUIModel.add(uimodel);
//       setState(() {
//         cropitems.add(DropdownModel(
//           property_value,
//           DISP_SEQ,
//         ));
//         //prooflist.add(property_value);
//       });
//     }
//
//     /*Age tree Dropdown*/
//     agetreeUIModel = [];
//     AgetreeDropDownLists = [];
//     treeitems.clear();
//     String agetreeQry =
//         'select * from animalCatalog where catalog_code =\'165\'';
//     List agetreeList = await db.RawQuery(agetreeQry);
//     for (int i = 0; i < agetreeList.length; i++) {
//       String DISP_SEQ = agetreeList[i]["DISP_SEQ"].toString();
//       String property_value = agetreeList[i]["property_value"].toString();
//       var uimodel = new UImodel(property_value, DISP_SEQ);
//       agetreeUIModel.add(uimodel);
//       setState(() {
//         treeitems.add(DropdownModel(
//           property_value,
//           DISP_SEQ,
//         ));
//         //prooflist.add(property_value);
//       });
//     }
//
//     /*Type of Production Dropdown*/
//     prodTypeUIModel = [];
//     prodTypeDropDownLists = [];
//     productionitems.clear();
//     String typeprodQry =
//         'select * from animalCatalog where catalog_code =\'39\'';
//     List prodTypeList = await db.RawQuery(typeprodQry);
//     for (int i = 0; i < prodTypeList.length; i++) {
//       String property_value = prodTypeList[i]["property_value"].toString();
//       String DISP_SEQ = prodTypeList[i]["DISP_SEQ"].toString();
//       var uimodel = new UImodel(property_value, DISP_SEQ);
//       prodTypeUIModel.add(uimodel);
//       setState(() {
//         productionitems.add(DropdownModel(
//           property_value,
//           DISP_SEQ,
//         ));
//         //prooflist.add(property_value);
//       });
//     }
//   }
//
//   varietylaod(String slctCrptypId) async {
//     /*variety Dropdown*/
//     vartyUIModel = [];
//     VartyDropDownLists = [];
//     varietyitems.clear();
//     String vartypQry =
//         'select vCode,vName,days from varietyList where prodId=\'' +
//             slctCrptypId +
//             '\'';
//     List vartypList = await db.RawQuery(vartypQry);
//     for (int i = 0; i < vartypList.length; i++) {
//       String property_value = vartypList[i]["vName"].toString();
//       String DISP_SEQ = vartypList[i]["vCode"].toString();
//       var uimodel = new UImodel(DISP_SEQ, property_value);
//       vartyUIModel.add(uimodel);
//       setState(() {
//         varietyitems.add(DropdownModel(
//           property_value,
//           DISP_SEQ,
//         ));
//         //prooflist.add(property_value);
//       });
//     }
//     Future.delayed(Duration(milliseconds: 500), () {
//       setState(() {
//         if (vartypList.length > 0) {
//           varietyLoaded = true;
//           //slctVrtyp = '';
//         }
//       });
//     });
//   }
//
//   @override
//   void dispose() {
//     super.dispose();
//   }
//
//   getClientData() async {
//     agents = await db.RawQuery('SELECT * FROM agentMaster');
//     seasoncode = agents![0]['currentSeasonCode'];
//     servicePointId = agents![0]['servicePointId'];
//   }
//
//   Future<void> ChangeStates(String countrycode) async {
//     List statelist = await db.RawQuery(
//         'select * from stateList where countryCode =\'' + countrycode + '\'');
//     print('stateList ' + statelist.toString());
//     stateUIModel = [];
//     stateitems = [];
//     stateitems.clear();
//     for (int i = 0; i < statelist.length; i++) {
//       String countryCode = statelist[i]["countryCode"].toString();
//       String stateCode = statelist[i]["stateCode"].toString();
//       String stateName = statelist[i]["stateName"].toString();
//
//       var uimodel = new UImodel(stateName, stateCode);
//       stateUIModel.add(uimodel);
//       setState(() {
//         stateitems.add(DropdownMenuItem(
//           child: Text(stateName),
//           value: stateName,
//         ));
//         //stateList.add(stateName);
//       });
//
//       Future.delayed(Duration(milliseconds: 500), () {
//         print("State_delayfunction" + stateName);
//         setState(() {
//           if (statelist.length > 0) {
//             slctState = '';
//             stateLoaded = true;
//           }
//         });
//       });
//     }
//   }
//
//   /*getSubCountry(slctCountryNameId) Method*/
//   Future<void> getSubCountry(String slctCountryNameId) async {
//     /*Get Sub-Country Data From stateList(Temp) Table - Sub-Country Data*/
//     String subCountryQry = 'select * from stateList where countryCode =\'' +
//         slctCountryNameId +
//         '\'';
//     List subCountryList = await db.RawQuery(subCountryQry);
//
//     subCountryNameDropDownLists = [];
//     subCountryNameUIModel.clear();
//
//     if (subCountryList.length > 0) {
//       for (int i = 0; i < subCountryList.length; i++) {
//         String subCountryCode = subCountryList[i]["stateCode"].toString();
//         String subCountryName = subCountryList[i]["stateName"].toString();
//
//         var uiModel = new UImodel(subCountryName, subCountryCode);
//         subCountryNameUIModel.add(uiModel);
//
//         setState(() {
//           subCountryNameDropDownLists.add(DropdownMenuItem(
//             child: Text(subCountryName),
//             value: subCountryName,
//           ));
//         });
//
//         Future.delayed(Duration(milliseconds: 500), () {
//           setState(() {
//             /*Sub-Country*/
//             slctSubCountryName = '';
//             /*Load*/
//             isSubCountryLoaded = true;
//           });
//         });
//       }
//     } else {
//       print('There is no data from stateList(Temp) table -- Sub-Country Name');
//     }
//   }
//
//   /*getWard(slctSubCountryNameId) Method*/
//   Future<void> getWard(String slctSubCountryNameId) async {
//     /*Get Ward Data From districtList(Temp) Table - Ward Data*/
//     print("slctSubCountryNameId" + slctSubCountryNameId);
//     String wardQry = 'select * from districtList where stateCode =\'' +
//         slctSubCountryNameId +
//         '\'';
//     List wardList = await db.RawQuery(wardQry);
//
//     subCountryNameDropDownLists = [];
//     subCountryNameUIModel.clear();
//
//     if (wardList.length > 0) {
//       for (int i = 0; i < wardList.length; i++) {
//         String wardCode = wardList[i]["districtCode"].toString();
//         String wardName = wardList[i]["districtName"].toString();
//
//         var uiModel = new UImodel(wardName, wardCode);
//         subCountryNameUIModel.add(uiModel);
//
//         setState(() {
//           subCountryNameDropDownLists.add(DropdownMenuItem(
//             child: Text(wardName),
//             value: wardName,
//           ));
//         });
//
//         Future.delayed(Duration(milliseconds: 500), () {
//           setState(() {
//             /*Ward*/
//             slctSubCountryName = '';
//             /*Load*/
//             isSubCountryLoaded = true;
//           });
//         });
//       }
//     } else {
//       print('There is no data from districtList(Temp) table -- Ward Name');
//     }
//   }
//
//   /*getVillage(slctWardNameId) Method*/
//   Future<void> getVillage(String slctWardNameId) async {
//     /*Get Village Data From cityList(Temp) Table - Village Data*/
//     String villageQry =
//         'select * from cityList where districtCode =\'' + slctWardNameId + '\'';
//     List villageList = await db.RawQuery(villageQry);
//
//     wardNameDropDownLists = [];
//     wardNameUIModel.clear();
//
//     if (villageList.length > 0) {
//       for (int i = 0; i < villageList.length; i++) {
//         String villageCode = villageList[i]["cityCode"].toString();
//         String villageName = villageList[i]["cityName"].toString();
//
//         var uiModel = new UImodel(villageName, villageCode);
//         wardNameUIModel.add(uiModel);
//
//         setState(() {
//           wardNameDropDownLists.add(DropdownMenuItem(
//             child: Text(villageName),
//             value: villageName,
//           ));
//         });
//
//         Future.delayed(Duration(milliseconds: 500), () {
//           setState(() {
//             /*Village*/
//             slctVillageName = '';
//             /*Load*/
//             isWardLoaded = true;
//           });
//         });
//       }
//     } else {
//       print('There is no data from cityList(Temp) table -- Village Data');
//     }
//   }
//
//   /*getGroup(slctVillageNameId) Method*/
//   Future<void> getGroup(String slctVillageNameId) async {
//     /*Get Group Data From villageList(Temp) Table - Group Data*/
//     String groupQry =
//         'select * from villageList where gpCode =\'' + slctVillageNameId + '\'';
//     List groupList = await db.RawQuery(groupQry);
//
//     villageNameDropDownLists = [];
//     villageNameUIModel.clear();
//
//     if (groupList.length > 0) {
//       for (int i = 0; i < groupList.length; i++) {
//         String groupCode = groupList[i]["villCode"].toString();
//         String groupName = groupList[i]["villName"].toString();
//
//         var uiModel = new UImodel(groupName, groupCode);
//         villageNameUIModel.add(uiModel);
//
//         setState(() {
//           villageNameDropDownLists.add(DropdownMenuItem(
//             child: Text(groupName),
//             value: groupName,
//           ));
//         });
//
//         Future.delayed(Duration(milliseconds: 500), () {
//           setState(() {
//             /*Group*/
//             // slctGroupName = '';
//             /*Load*/
//             isVillageLoaded = true;
//           });
//         });
//       }
//     } else {
//       print('There is no data from villageList(Temp) Table - Group Data');
//     }
//   }
//
//   Future<void> initvalues() async {
//     String qry_villagelist =
//         'Select distinct v.villCode,v.villName from villageList as v inner join farmer_master as f on f.villageId =v.villCode';
//     //'select * from villageList';
//     print('Approach Query:  ' + qry_villagelist);
//     List villageslist = await db.RawQuery(qry_villagelist);
//     print('villageslist 1:  ' + villageslist.toString());
//     villageitems.clear();
//     villagelistUIModel = [];
//
//     for (int i = 0; i < villageslist.length; i++) {
//       String villName = villageslist[i]["villName"].toString();
//       String villCode = villageslist[i]["villCode"].toString();
//       var uimodel = new UImodel(villName, villCode);
//       villagelistUIModel.add(uimodel);
//       setState(() {
//         villageitems.add(DropdownModel(
//           villName,
//           villCode,
//         ));
//         //prooflist.add(property_value);
//       });
//     }
//     if (villageitems.length > 0) {
//       setState(() {
//         val_village = villageitems[0].value;
//       });
//     }
//
//     String villageCode = villagelistUIModel[0].value;
//
//     // String qry_farmerlist =
//     //     'select fName,farmerCode from farmer_master where villageId = \'' +
//     //         villageCode +
//     //         '\'';
//     String qry_farmerlist =
//         'select fName,farmerId,certifiedFarmer,address from farmer_master where villageId = \'' +
//             villageCode +
//             '\'';
//     print('Approach Query:  ' + qry_farmerlist);
//     List farmerslist = await db.RawQuery(qry_farmerlist);
//     print('farmerslist 2:  ' + farmerslist.toString());
//     farmeritems.clear();
//     farmerlistUIModel = [];
//
//     for (int i = 0; i < farmerslist.length; i++) {
//       String fName = farmerslist[i]["fName"].toString();
//       //String ffarmerCode = farmerslist[i]["farmerCode"].toString();
//       String ffarmerId = farmerslist[i]["farmerId"].toString();
//       String address = farmerslist[i]["address"].toString();
//       certtype = farmerslist[i]["certifiedFarmer"].toString();
//       // toast(certtype);
//       certtype =
//           "1"; // TEMP HAVE TO REMOVE------------------------------------------------------
//
//       var uimodel = new UImodel2(fName, ffarmerId, address);
//       farmerlistUIModel.add(uimodel);
//       setState(() {
//         farmeritems.add(DropdownModel(
//           fName,
//           ffarmerId,
//         ));
//         //prooflist.add(property_value);
//       });
//     }
//
//     String qry_approach =
//         'select * from animalCatalog where catalog_code = \'144\'';
//     print('Approach Query:  ' + qry_approach);
//     List approadlist = await db.RawQuery(qry_approach);
//     print('approadlist:  ' + approadlist.toString());
//     approachroaditems.clear();
//     approachUIModel = [];
//
//     for (int i = 0; i < approadlist.length; i++) {
//       String property_value = approadlist[i]["property_value"].toString();
//       String DISP_SEQ = approadlist[i]["DISP_SEQ"].toString();
//       var uimodel = new UImodel(property_value, DISP_SEQ);
//       approachUIModel.add(uimodel);
//       setState(() {
//         approachroaditems.add(DropdownMenuItem(
//           child: Text(property_value),
//           value: property_value,
//         ));
//       });
//     }
//
//     String qryowner =
//         'select * from animalCatalog where catalog_code = \'' + "42" + '\'';
//
//     print('Query Owner:  ' + qryowner);
//     List ownerlist = await db.RawQuery(qryowner);
//     print('Query Owner 1:  ' + ownerlist.toString());
//     owneritems.clear();
//     ownerUIModel = [];
//
//     for (int i = 0; i < ownerlist.length; i++) {
//       String property_value = ownerlist[i]["property_value"].toString();
//       String DISP_SEQ = ownerlist[i]["DISP_SEQ"].toString();
//       var uimodel = new UImodel(property_value, DISP_SEQ);
//       ownerUIModel.add(uimodel);
//       setState(() {
//         owneritems.add(DropdownMenuItem(
//           child: Text(property_value),
//           value: property_value,
//         ));
//       });
//     }
//
//     String qrytopo = 'select * from animalCatalog where catalog_code = \'39\'';
//     print('Approach Query:  ' + qrytopo);
//     List topolist = await db.RawQuery(qrytopo);
//     print('approadlist:  ' + topolist.toString());
//     topographyitems.clear();
//     topoUIModel = [];
//
//     for (int i = 0; i < topolist.length; i++) {
//       String property_value = topolist[i]["property_value"].toString();
//       String DISP_SEQ = topolist[i]["DISP_SEQ"].toString();
//       var uimodel = new UImodel(property_value, DISP_SEQ);
//       topoUIModel.add(uimodel);
//       setState(() {
//         topographyitems.add(DropdownMenuItem(
//           child: Text(property_value),
//           value: property_value,
//         ));
//       });
//     }
//
//     String soiltextQry =
//         'select * from animalCatalog where catalog_code = \'9\'';
//     print('Approach Query:  ' + soiltextQry);
//     List soiltextures = await db.RawQuery(soiltextQry);
//     print('approadlist:  ' + soiltextures.toString());
//     soiltextureitems.clear();
//     soilTextureUIModel = [];
//
//     for (int i = 0; i < soiltextures.length; i++) {
//       String property_value = soiltextures[i]["property_value"].toString();
//       String DISP_SEQ = soiltextures[i]["DISP_SEQ"].toString();
//       var uimodel = new UImodel(property_value, DISP_SEQ);
//       soilTextureUIModel.add(uimodel);
//       setState(() {
//         soiltextureitems.add(DropdownMenuItem(
//           child: Text(property_value),
//           value: property_value,
//         ));
//       });
//     }
//
//     String qrygradient =
//         'select * from animalCatalog where catalog_code = \'140\'';
//     print('Approach Query:  ' + qrygradient);
//     List gradientlist = await db.RawQuery(qrygradient);
//     print('gradientlist:  ' + gradientlist.toString());
//     gradientitems.clear();
//     gradientUIModel = [];
//
//     for (int i = 0; i < gradientlist.length; i++) {
//       String property_value = gradientlist[i]["property_value"].toString();
//       String DISP_SEQ = gradientlist[i]["DISP_SEQ"].toString();
//       var uimodel = new UImodel(property_value, DISP_SEQ);
//       gradientUIModel.add(uimodel);
//       setState(() {
//         gradientitems.add(DropdownMenuItem(
//           child: Text(property_value),
//           value: property_value,
//         ));
//       });
//     }
//
//     String qryirrigation =
//         'select * from dropdownValues where catalog_code = \'FAI\' and lang= \'en\'';
//     print('Approach Query dropdownValues:  ' + qryirrigation);
//     List irrigationlist = await db.RawQuery(qryirrigation);
//     print('irrigationlist:  ' + irrigationlist.toString());
//     irrigationitems.clear();
//     irrigationUIModel = [];
//
//     for (int i = 0; i < irrigationlist.length; i++) {
//       String property_value = irrigationlist[i]["property_value"].toString();
//       String DISP_SEQ = irrigationlist[i]["DISP_SEQ"].toString();
//       var uimodel = new UImodel(property_value, DISP_SEQ);
//       irrigationUIModel.add(uimodel);
//       setState(() {
//         irrigationitems.add(DropdownMenuItem(
//           child: Text(property_value),
//           value: property_value,
//         ));
//       });
//     }
//     // if (irrigationitems.length > 0) {
//     //   setState(() {
//     //     val_irrigation = irrigationitems[0].value;
//     //   });
//     // }
//     String qryirrigationtyp =
//         'select * from animalCatalog where catalog_code =\'81\'';
//     print('Approach_animal  ' + qryirrigationtyp);
//     List irrigationtyp = await db.RawQuery(qryirrigationtyp);
//     print('irrigationtyp:  ' + irrigationtyp.toString());
//     irrigationtypitems.clear();
//     irrigationtypUIModel = [];
//
//     for (int i = 0; i < irrigationtyp.length; i++) {
//       String property_value = irrigationtyp[i]["property_value"].toString();
//       String DISP_SEQ = irrigationtyp[i]["DISP_SEQ"].toString();
//       var uimodel = new UImodel(property_value, DISP_SEQ);
//       irrigationtypUIModel.add(uimodel);
//       setState(() {
//         irrigationtypitems.add(DropdownMenuItem(
//           child: Text(property_value),
//           value: property_value,
//         ));
//       });
//     }
//
//     String qrycertlist =
//         'select * from animalCatalog where catalog_code =\'119\'';
//     print('Approach_animal  ' + qrycertlist);
//     List certlist = await db.RawQuery(qrycertlist);
//     print('certlist:  ' + certlist.toString());
//     certitems.clear();
//     certlistUIModel = [];
//
//     for (int i = 0; i < certlist.length; i++) {
//       String property_value = certlist[i]["property_value"].toString();
//       String DISP_SEQ = certlist[i]["DISP_SEQ"].toString();
//       var uimodel = new UImodel(property_value, DISP_SEQ);
//       certlistUIModel.add(uimodel);
//       setState(() {
//         certitems.add(DropdownMenuItem(
//           child: Text(property_value),
//           value: property_value,
//         ));
//       });
//     }
//     String qrystatuslist = 'select * from catalog where catalog_code =\'FICS\'';
//     print('Approach_catalog  ' + qrystatuslist);
//     List statuslist = await db.RawQuery(qrystatuslist);
//     print('statuslist:  ' + statuslist.toString());
//     statusitems.clear();
//     statuslistUIModel = [];
//
//     for (int i = 0; i < statuslist.length; i++) {
//       String property_value = statuslist[i]["property_value"].toString();
//       String DISP_SEQ = statuslist[i]["DISP_SEQ"].toString();
//       var uimodel = new UImodel(property_value, DISP_SEQ);
//       statuslistUIModel.add(uimodel);
//       setState(() {
//         statusitems.add(DropdownMenuItem(
//           child: Text(property_value),
//           value: property_value,
//         ));
//       });
//     }
//
//     String qrysoillist =
//         'select * from animalCatalog where catalog_code =\'8\'';
//     print('Approach_catalogsoil  ' + qrysoillist);
//     List soillist = await db.RawQuery(qrysoillist);
//     print('soillist:  ' + soillist.toString());
//     soilitems.clear();
//     soillistUIModel = [];
//
//     for (int i = 0; i < soillist.length; i++) {
//       String property_value = soillist[i]["property_value"].toString();
//       String DISP_SEQ = soillist[i]["DISP_SEQ"].toString();
//       var uimodel = new UImodel(property_value, DISP_SEQ);
//       soillistUIModel.add(uimodel);
//       setState(() {
//         soilitems.add(DropdownMenuItem(
//           child: Text(property_value),
//           value: property_value,
//         ));
//       });
//     }
//
//     String qryfertlist = 'select * from catalog where catalog_code =\'FTS\'';
//     print('Approach_catalogfert  ' + qryfertlist);
//     List fertlist = await db.RawQuery(qryfertlist);
//     print('fertlist:  ' + fertlist.toString());
//     fertitems.clear();
//     fertlistUIModel = [];
//
//     for (int i = 0; i < fertlist.length; i++) {
//       String property_value = fertlist[i]["property_value"].toString();
//       String DISP_SEQ = fertlist[i]["DISP_SEQ"].toString();
//       var uimodel = new UImodel(property_value, DISP_SEQ);
//       fertlistUIModel.add(uimodel);
//       setState(() {
//         fertitems.add(DropdownMenuItem(
//           child: Text(property_value),
//           value: property_value,
//         ));
//       });
//     }
//
//     String qryirmtdlist =
//         'select * from animalCatalog where catalog_code =\'63\'';
//     print('Approach_catalogirmtd  ' + qryirmtdlist);
//     List irmtdlist = await db.RawQuery(qryirmtdlist);
//     print('irmtdlist:  ' + irmtdlist.toString());
//     irmtditems.clear();
//     irmtdlistUIModel = [];
//
//     for (int i = 0; i < irmtdlist.length; i++) {
//       String property_value = irmtdlist[i]["property_value"].toString();
//       String DISP_SEQ = irmtdlist[i]["DISP_SEQ"].toString();
//       var uimodel = new UImodel(property_value, DISP_SEQ);
//       irmtdlistUIModel.add(uimodel);
//       setState(() {
//         irmtditems.add(DropdownMenuItem(
//           child: Text(property_value),
//           value: property_value,
//         ));
//       });
//     }
//
//     String qrysrclist = 'select * from catalog where catalog_code =\'FAIO\'';
//     print('Approach_catalogsrc  ' + qrysrclist);
//     List srclist = await db.RawQuery(qrysrclist);
//     print('srclist:  ' + srclist.toString());
//     srcitems.clear();
//     srclistUIModel = [];
//
//     for (int i = 0; i < srclist.length; i++) {
//       String property_value = srclist[i]["property_value"].toString();
//       String DISP_SEQ = srclist[i]["DISP_SEQ"].toString();
//       var uimodel = new UImodel(property_value, DISP_SEQ);
//       srclistUIModel.add(uimodel);
//       setState(() {
//         srcitems.add(DropdownMenuItem(
//           child: Text(property_value),
//           value: property_value,
//         ));
//       });
//     }
//   }
//
//   typsearch() async {
//     String qryirrigationtyp =
//         'select * from animalCatalog where catalog_code =\'81\'';
//     print('Approach_animal  ' + qryirrigationtyp);
//     List irrigationtyp = await db.RawQuery(qryirrigationtyp);
//     print('irrigationtyp:  ' + irrigationtyp.toString());
//     irrigationtypitems.clear();
//     irrigationtypUIModel = [];
//
//     for (int i = 0; i < irrigationtyp.length; i++) {
//       String property_value = irrigationtyp[i]["property_value"].toString();
//       String DISP_SEQ = irrigationtyp[i]["DISP_SEQ"].toString();
//       var uimodel = new UImodel(property_value, DISP_SEQ);
//       irrigationtypUIModel.add(uimodel);
//       setState(() {
//         irrigationtypitems.add(DropdownMenuItem(
//           child: Text(property_value),
//           value: property_value,
//         ));
//       });
//     }
//   }
//
//   farmersearch() async {
//     // String qry_farmerlist =
//     //     'select fName,farmerCode from farmer_master where villageId = \'' +
//     //         villageCode +
//     //         '\'';
//
//     String qry_farmerlist =
//         'select fName,farmerId,certifiedFarmer,address from farmer_master where villageId = \'' +
//             villageCode +
//             '\'';
//     print('Approach Query:  ' + qry_farmerlist);
//     List farmerslist = await db.RawQuery(qry_farmerlist);
//     print('villageslist 2:  ' + farmerslist.toString());
//
//     farmeritems = [];
//     farmeritems.clear();
//     farmerlistUIModel = [];
//
//     if (farmerslist.length > 0) {
//       for (int i = 0; i < farmerslist.length; i++) {
//         String property_value = farmerslist[i]["fName"].toString();
//         // String property_value = farmerslist[i]["fName"].toString();
//         String DISP_SEQ = farmerslist[i]["farmerId"].toString();
//         String address = farmerslist[i]["address"].toString();
//         certtype = farmerslist[i]["certifiedFarmer"].toString();
//         certtype = "1";
//         var uimodel = new UImodel2(property_value, DISP_SEQ, address);
//         farmerlistUIModel.add(uimodel);
//         setState(() {
//           farmeritems.add(DropdownModel(
//             property_value,
//             DISP_SEQ,
//           ));
//           //prooflist.add(property_value);
//         });
//       }
//     }
//
//     Future.delayed(Duration(milliseconds: 500), () {
//       setState(() {
//         if (farmeritems.length > 0) {
//           slct_farmer = '';
//           farmerloaded = true;
//         }
//       });
//     });
//
//     if (farmeritems.length > 0) {
//       setState(() {
//         val_farmer = farmeritems[0].value;
//       });
//     }
//   }
//
//   Future<bool> _onBackPressed() async {
//     return (await Alert(
//           context: context,
//           type: AlertType.warning,
//           title: cancel,
//           desc: rusurecancel,
//           buttons: [
//             DialogButton(
//               child: Text(
//                 yes,
//                 style: TextStyle(color: Colors.white, fontSize: 20),
//               ),
//               onPressed: () {
//                 Navigator.pop(context);
//                 Navigator.pop(context);
//               },
//               width: 120,
//             ),
//             DialogButton(
//               child: Text(
//                 no,
//                 style: TextStyle(color: Colors.white, fontSize: 20),
//               ),
//               onPressed: () {
//                 Navigator.pop(context);
//               },
//               width: 120,
//             )
//           ],
//         ).show()) ??
//         false;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: WillPopScope(
//         onWillPop: _onBackPressed,
//         child: Scaffold(
//           resizeToAvoidBottomInset: false,
//           appBar: AppBar(
//             centerTitle: true,
//             leading: IconButton(
//                 icon: Icon(Icons.arrow_back, color: Colors.white),
//                 onPressed: () {
//                   _onBackPressed();
//                 }),
//             title: Text(
//               addfarm,
//               style: new TextStyle(
//                   color: Colors.white,
//                   fontSize: 18.0,
//                   fontWeight: FontWeight.w700),
//             ),
//             iconTheme: IconThemeData(color: Colors.white),
//             backgroundColor: Colors.green,
//             brightness: Brightness.light,
//           ),
//           body: Container(
//               child: Column(children: <Widget>[
//             Expanded(
//               child: ListView(
//                 padding: EdgeInsets.all(10.0),
//                 children: _getListings(
//                     context), // <<<<< Note this change for the return type
//               ),
//               flex: 8,
//             ),
//           ])),
//         ),
//       ),
//     );
//   }
//
//   // Future getImage(String isfrom) async {
//   //   var image = await ImagePicker.platform
//   //       .pickImage(source: ImageSource.camera, imageQuality: 50);
//   //   setState(() {
//   //     if (isfrom == "farmer") {
//   //       _imagefarmer = File(image.path);
//   //     } else {
//   //       _image_farm = File(image.path);
//   //     }
//   //   });
//   // }
//
//     List<Widget> _getListings(BuildContext context) {
//     List<Widget> listings = [];
//
//     if (!ishavefarmercode) {
//       listings.add(txt_label(village, Colors.black, 14.0, false));
//       /* listings.add(singlesearchDropdown(
//           itemlist: villageitems,
//           selecteditem: slct_village,
//           hint: VillageHint,
//           onClear: () {
//             setState(() {
//               slct_village = '';
//               slct_farmer = '';
//             });
//           },
//           onChanged: (value) {
//             setState(() {
//               slct_village = value!;
//               farmerloaded = false;
//               ishavefarmercode = false;
//               slct_farmer = '';
//               print("CHECK_VILLAGE_NAME: " + slct_village);
//               farmersearch();
//             });
//           }));  */
//
//       listings.add(DropDownWithModel(
//           itemlist: villageitems,
//           selecteditem: slctvillages,
//           hint: VillageHint,
//           onChanged: (value) {
//             setState(() {
//               slctvillages = value!;
//               //toast(slctFarmers!.value);
//               villageCode = slctvillages!.value;
//               slct_village = slctvillages!.name;
//               farmersearch();
//             });
//           },
//           onClear: () {
//             setState(() {
//               slct_farmer = '';
//               ishavefarmercode = false;
//             });
//           }));
//
//       listings.add(farmerloaded
//           ? txt_label(farmer, Colors.black, 14.0, false)
//           : Container());
//       /*  listings.add(singlesearchDropdown(
//             itemlist: farmeritems,
//             selecteditem: slct_farmer,
//             hint: farmerHint,
//             onClear: () {
//               setState(() {
//                 slct_farmer = '';
//                 ishavefarmercode = false;
//               });
//             },
//             onChanged: (value) {
//               setState(() {
//                 slct_farmer = value!;
//                 print('CHECK_FAARMER_CODE 1: ' + farmerlistUIModel[0].name);
//                 print('CHECK_FAARMER_CODE 2: ' + farmerlistUIModel[0].value);
//                 print('CHECK_FAARMER_CODE 3: ' + farmerId);
//                 print('CHECK_FAARMER_CODE 4: ' + slct_farmer);
//                 for (int i = 0; i < farmerlistUIModel.length; i++) {
//                   if (farmerlistUIModel[i].name == slct_farmer) {
//                     farmerId = farmerlistUIModel[i].value;
//                     farmerAddress = farmerlistUIModel[i].value2;
//                   }
//                 }
//                 print('CHECK_FAARMER_CODE 5: ' + farmerId);
//               });
//             }));  */
//
//       listings.add(farmerloaded
//           ? DropDownWithModel(
//               itemlist: farmeritems,
//               selecteditem: slctFarmers,
//               hint: farmerHint,
//               onChanged: (value) {
//                 setState(() {
//                   slctFarmers = value!;
//                   //toast(slctFarmers!.value);
//                   farmerId = slctFarmers!.value;
//                   slct_farmer = slctFarmers!.name;
//
//                   for (int i = 0; i < farmerlistUIModel.length; i++) {
//                     if (farmerlistUIModel[i].value == farmerId) {
//                       farmerAddress = farmerlistUIModel[i].value2;
//                     }
//                   }
//                 });
//               },
//               onClear: () {
//                 setState(() {
//                   slct_farmer = '';
//                   ishavefarmercode = false;
//                 });
//               })
//           : Container());
//
//       listings.add(btn_dynamic(
//           label: submit,
//           bgcolor: Colors.green,
//           txtcolor: Colors.white,
//           fontsize: 18.0,
//           centerRight: Alignment.centerRight,
//           margin: 10.0,
//           btnSubmit: () async {
//             setState(() {
//               if (slct_village != '' && slct_village.length > 0) {
//                 if (farmerId != '' && farmerId.length > 0) {
//                   ishavefarmercode = true;
//                 } else {
//                   ishavefarmercode = false;
//                   errordialog(context, info, infofarmer);
//                 }
//               } else {
//                 errordialog(context, info, infovillage);
//               }
//             });
//           }));
//     }
//
//     if (ishavefarmercode) {
//       /*Farm Name*/
//       /*Label*/
//       listings.add(txt_label_mandatory(farmname, Colors.black, 14.0, false));
//       /*Field*/
//       listings.add(txtfield_dynamic(farmname, farmNameController, true));
//
//       listings.add(txt_label(farmphoto, Colors.green, 18.0, true));
//
//       listings.add(txt_label_mandatory(farmphoto, Colors.black, 14.0, false));
//
//       /* listings.add(img_picker(
//           label: farmphoto,
//           onPressed: getImagefrm,
//           filename: _imagefilefarm,
//           ondelete: ondeletefrm));*/
//       listings.add(img_picker(
//           label: farmphoto,
//           onPressed: () {
//             imageDialog();
//           },
//           filename: _imagefilefarm,
//           ondelete: () {
//             ondelete();
//           }));
//
//       /*Same as Farmer Address? Check Box*/
//       listings.add(chkbox_dynamic(
//         label: samefarmeraddress,
//         checked: sameFarmeraddress,
//         onChange: (value) => setState(() {
//           sameFarmeraddress = value!;
//
//           if (sameFarmeraddress) {
//             isFarmerSameAddress = '1';
//             print('isFarmerSameAddress When True: ' + isFarmerSameAddress);
//           } else {
//             isFarmerSameAddress = '0';
//             print('isFarmerSameAddress When False: ' + isFarmerSameAddress);
//           }
//
//           /*Country Name Data*/
//           slctCountryName = '';
//           /*Sub-Country Name Data*/
//           isSubCountryLoaded = false;
//           slctSubCountryName = '';
//           subCountryNameDropDownLists = [];
//           /*Ward Name Data*/
//           isWardLoaded = false;
//           slctWardName = '';
//           wardNameDropDownLists = [];
//           /*Village Name Data*/
//           isVillageLoaded = false;
//           slctVillageName = '';
//           villageNameDropDownLists = [];
//           /*Group Name Data*/
//           isGroupLoaded = false;
//           // slctGroupName = '';
//           // groupNameDropDownLists = '';
//         }),
//       ));
//       if (!sameFarmeraddress) {
//         /*Label*/
//         listings
//             .add(txt_label_mandatory(farmaddress, Colors.black, 14.0, false));
//
//         /*Field*/
//         listings.add(txtfield_dynamic(farmaddress, addressController, true));
//       }
//
//       /*These fields will be displayed only if farm address is different from Residence Address*/
//       //if (!sameFarmeraddress) {
//       /*Country Name Dropdown*/
//       /*Label*/
//       /*  listings.add(txt_label_mandatory("Country", Colors.black, 14.0, false));
//         /*Dropdown*/
//         listings.add(singlesearchDropdown(
//             itemlist: countryNameDropDownLists,
//             hint: "Select the country",
//             selecteditem: slctCountryName,
//             onChanged: (value) {
//               setState(() {
//                 slctCountryName = value;
//                 stateLoaded = false;
//                 slctState = '';
//                 stateitems = '';
//                 /*Sub-Country Name Data*/
//                 isSubCountryLoaded = false;
//                 slctSubCountryName = '';
//                 subCountryNameDropDownLists = '';
//                 /*Ward Name Data*/
//                 isWardLoaded = false;
//                 slctWardName = '';
//                 wardNameDropDownLists = '';
//                 /*Village Name Data*/
//                 isVillageLoaded = false;
//                 slctVillageName = '';
//                 villageNameDropDownLists = '';
//                 /*Group Name Data*/
//                 isGroupLoaded = false;
//                // slctGroupName = '';
//                // groupNameDropDownLists = '';
//
//                 for (int i = 0; i < countryNameUIModel.length; i++) {
//                   if (slctCountryName == countryNameUIModel[i].name) {
//                     slctCountryNameId = countryNameUIModel[i].value;
//                     /*Get Sub-Country based on Country*/
//                     ChangeStates(slctCountryNameId);
//                     //getSubCountry(slctCountryNameId);
//                     print('slctCountryName: ' +
//                         slctCountryName +
//                         slctCountryNameId);
//                   }
//                 }
//               });
//             },
//             onClear: () {
//               setState(() {
//                 slctCountryName = '';
//                 slctSubCountryName = '';
//                 slctWardName = '';
//                 slctVillageName = '';
//               //  slctGroupName = '';
//               });
//             })); */
//
//       /* listings.add(stateLoaded
//             ? txt_label_mandatory("County", Colors.black, 14.0, false)
//             : Container());
//         listings.add(stateLoaded
//             ? singlesearchDropdown(
//             itemlist: stateitems,
//             selecteditem: stateLoaded ? slctState : "",
//             hint: "Select the County",
//             onChanged: (value) {
//               setState(() {
//                 slctState = value;
//                 isSubCountryLoaded = false;
//                 slctSubCountryName = '';
//                 subCountryNameDropDownLists = '';
//                 /*Ward Name Data*/
//                 isWardLoaded = false;
//                 slctWardName = '';
//                 wardNameDropDownLists = '';
//                 /*Village Name Data*/
//                 isVillageLoaded = false;
//                 slctVillageName = '';
//                 villageNameDropDownLists = '';
//                 /*Group Name Data*/
//                 isGroupLoaded = false;
//                // slctGroupName = '';
//
//                 for (int i = 0; i < stateUIModel.length; i++) {
//                   if (value == stateUIModel[i].name) {
//                     val_State = stateUIModel[i].value;
//                     getWard(val_State);
//                   }
//                 }
//               });
//             },
//             onClear: () {
//               slctState = '';
//               slctSubCountryName = '';
//               slctWardName = '';
//               slctVillageName = '';
//              // slctGroupName = '';
//             })
//             : Container()); */
//
//       // if (isSubCountryLoaded) {
//       /*Sub-Country Dropdown*/
//       /*Label*/
//       /* listings
//               .add(txt_label_mandatory("Sub-County", Colors.black, 14.0, false));
//           /*Dropdown*/
//           listings.add(singlesearchDropdown(
//               itemlist: subCountryNameDropDownLists,
//               hint: "Select the sub-county",
//               selecteditem: slctSubCountryName,
//               onChanged: (value) {
//                 setState(() {
//                   slctSubCountryName = value;
//
//                   /*Ward Name Data*/
//                   isWardLoaded = false;
//                   slctWardName = '';
//                   wardNameDropDownLists = '';
//                   /*Village Name Data*/
//                   isVillageLoaded = false;
//                   slctVillageName = '';
//                   villageNameDropDownLists = '';
//                   /*Group Name Data*/
//                   isGroupLoaded = false;
//                  // slctGroupName = '';
//                  // groupNameDropDownLists = '';
//
//                   for (int i = 0; i < subCountryNameUIModel.length; i++) {
//                     if (slctSubCountryName == subCountryNameUIModel[i].name) {
//                       slctSubCountryNameId = subCountryNameUIModel[i].value;
//                       /*Get Ward based on SubCountry*/
//                       getVillage(slctSubCountryNameId);
//                       print('slctSubCountryName: ' +
//                           slctSubCountryName +
//                           slctSubCountryNameId);
//                     }
//                   }
//                 });
//               },
//               onClear: () {
//                 setState(() {
//                   slctSubCountryName = '';
//                   slctWardName = '';
//                   slctVillageName = '';
//                  // slctGroupName = '';
//                 });
//               })); */
//
//       //if (isWardLoaded) {
//       /*Ward Name Dropdown*/
//       /*Label*/
//       // listings.add(txt_label_mandatory("Ward", Colors.black, 14.0, false));
//       /*Dropdown*/
//       /* listings.add(singlesearchDropdown(
//                 itemlist: wardNameDropDownLists,
//                 hint: "Select the ward",
//                 selecteditem: slctWardName,
//                 onChanged: (value) {
//                   setState(() {
//                     slctWardName = value;
//
//                     /*Village Name Data*/
//                     isVillageLoaded = false;
//                     slctVillageName = '';
//                     villageNameDropDownLists = '';
//                     /*Group Name Data*/
//                     isGroupLoaded = false;*/
//       // slctGroupName = '';
//       // groupNameDropDownLists = '';
//
//       /*  for (int i = 0; i < wardNameUIModel.length; i++) {
//                       if (slctWardName == wardNameUIModel[i].name) {
//                         slctWardNameId = wardNameUIModel[i].value;
//                         /*Get Village based on Ward*/
//                         getGroup(slctWardNameId);
//                         print('slctWardName: ' + slctWardName + slctWardNameId);
//                       }
//                     }
//                   });
//                 },
//                 onClear: () {
//                   setState(() {
//                     slctWardName = '';
//                     slctVillageName = '';*/
//       //  slctGroupName = '';
//       // });
//       // }));
//
//       //if (isVillageLoaded) {
//       /*Village Name Dropdown*/
//       /*Label*/
//       // listings.add(txt_label_mandatory("Village", Colors.black, 14.0, false));
//       /*Dropdown*/
//       /* listings.add(singlesearchDropdown(
//                   itemlist: villageNameDropDownLists,
//                   hint: "Select the village",
//                   selecteditem: slctVillageName,
//                   onChanged: (value) {
//                     setState(() {
//                       slctVillageName = value; */
//
//       /*Group Name Data*/
//       //isGroupLoaded = false;
//       // slctGroupName = '';
//       //  groupNameDropDownLists = '';
//
//       /*  for (int i = 0; i < villageNameUIModel.length; i++) {
//                         if (slctVillageName == villageNameUIModel[i].name) {
//                           slctVillageNameId = villageNameUIModel[i].value;
//                           /*Get Group based on Village*/
//                          // getGroup(slctVillageNameId);
//                           print('slctVillageName: ' +
//                               slctVillageName +
//                               slctVillageNameId);
//                         }
//                       }
//                     });
//                   },
//                   onClear: () {
//                     setState(() {
//                       slctVillageName = '';
//                     //  slctGroupName = '';
//                     });
//                   }));  */
//
//       // if (isGroupLoaded) {
//       /*Group Name Dropdown*/
//       /*Label*/
//       // listings
//       // .add(txt_label_mandatory("Group", Colors.black, 14.0, false));
//       /*Dropdown*/
//       /*  listings.add(singlesearchDropdown(
//                     itemlist: groupNameDropDownLists,
//                     hint: "Select the group",
//                     selecteditem: slctGroupName,
//                     onChanged: (value) {
//                       setState(() {
//                         slctGroupName = value;
//
//                         for (int i = 0; i < groupNameUIModel.length; i++) {
//                           if (slctGroupName == groupNameUIModel[i].name) {
//                             slctGroupNameId = groupNameUIModel[i].value;
//                             print('slctGroupName: ' +
//                                 slctGroupName +
//                                 slctGroupNameId);
//                           }
//                         }
//                       });
//                     },
//                     onClear: () {
//                       setState(() {
//                         slctGroupName = '';
//                       });
//                     }));
//               //}
//             }
//           }
//         }
//       } */
//
//       /*Total Land Size (Acres)*/
//       /*Label*/
//       listings
//           .add(txt_label_mandatory(totallandsize, Colors.black, 14.0, false));
//
//       /*Field*/
//       listings.add(
//           txtfield_digits(totallandsize, totalLndSizeAcreController, true));
//
//       /*Land Ownership Dropdown*/
//       /*Label*/
//       listings.add(txt_label_mandatory(landowner, Colors.black, 14.0, false));
//
//       /*Dropdown*/
//       /* listings.add(singlesearchDropdown(
//           itemlist: landOwnrshipDropDownLists,
//           hint: landownerHint,
//           selecteditem: slctLandOwnrship,
//           onChanged: (value) {
//             setState(() {
//               slctLandOwnrship = value!;
//
//               for (int i = 0; i < landOwnrshipUIModel.length; i++) {
//                 if (slctLandOwnrship == landOwnrshipUIModel[i].name) {
//                   slctLandOwnrshipId = landOwnrshipUIModel[i].value;
//                   print('slctLandOwnrship: ' +
//                       slctLandOwnrship +
//                       slctLandOwnrshipId);
//                 }
//               }
//             });
//           },
//           onClear: () {
//             setState(() {
//               slctLandOwnrship = '';
//             });
//           }));   */
//
//       listings.add(DropDownWithModel(
//           itemlist: landitems,
//           selecteditem: slctlands,
//           hint: landownerHint,
//           onChanged: (value) {
//             setState(() {
//               slctlands = value!;
//               slctLandOwnrshipId = slctlands!.value;
//               slctLandOwnrship = slctlands!.name;
//             });
//           },
//           onClear: () {
//             setState(() {
//               slctLandOwnrship = '';
//             });
//           }));
//
//       /*Soil Type Dropdown*/
//       /*Label*/
//       listings.add(txt_label_mandatory(soiltype, Colors.black, 14.0, false));
//       /*Dropdown*/
//       /*  listings.add(singlesearchDropdown(
//           itemlist: SoilTypDropDownLists,
//           hint: soiltypeHint,
//           selecteditem: slctSoiltyp,
//           onChanged: (value) {
//             setState(() {
//               slctSoiltyp = value!;
//
//               for (int i = 0; i < SoiltypUIModel.length; i++) {
//                 if (slctSoiltyp == SoiltypUIModel[i].name) {
//                   slctSoiltypId = SoiltypUIModel[i].value;
//                   print('slctLandOwnrship: ' + slctSoiltyp + slctSoiltypId);
//                 }
//               }
//             });
//           },
//           onClear: () {
//             setState(() {
//               slctSoiltyp = '';
//             });
//           }));  */
//
//       listings.add(DropDownWithModel(
//           itemlist: soilTypitems,
//           selecteditem: slctsoilTyps,
//           hint: soiltypeHint,
//           onChanged: (value) {
//             setState(() {
//               slctsoilTyps = value!;
//               slctSoiltypId = slctsoilTyps!.value;
//               slctSoiltyp = slctsoilTyps!.name;
//             });
//           },
//           onClear: () {
//             setState(() {
//               slctSoiltyp = '';
//             });
//           }));
//
//       /*Irrigation Dropdown*/
//       /*Label*/
//       listings.add(txt_label_mandatory(irrigation, Colors.black, 14.0, false));
//       /*Dropdown*/
//       /*  listings.add(singlesearchDropdown(
//           itemlist: IrrigatTypDropDownLists,
//           hint: irrigationHint,
//           selecteditem: slctIrrigattyp,
//           onChanged: (value) {
//             setState(() {
//               slctIrrigattyp = value!;
//
//               for (int i = 0; i < IrrigatUIModel.length; i++) {
//                 if (slctIrrigattyp == IrrigatUIModel[i].name) {
//                   slctIrrigattypId = IrrigatUIModel[i].value;
//                   print(
//                       'slctLandOwnrship: ' + slctIrrigattyp + slctIrrigattypId);
//                 }
//               }
//             });
//           },
//           onClear: () {
//             setState(() {
//               slctIrrigattyp = '';
//             });
//           }));  */
//
//       listings.add(DropDownWithModel(
//           itemlist: irrigationMitems,
//           selecteditem: slctirrigationMs,
//           hint: irrigationHint,
//           onChanged: (value) {
//             setState(() {
//               slctirrigationMs = value!;
//               slctIrrigattypId = slctirrigationMs!.value;
//               slctIrrigattyp = slctirrigationMs!.name;
//             });
//           },
//           onClear: () {
//             setState(() {
//               slctIrrigattyp = '';
//             });
//           }));
//
//       /*Main Crop Dropdown*/
//       /*Label*/
//       listings.add(txt_label_mandatory(maincrop, Colors.black, 14.0, false));
//       /*Dropdown*/
//       /* listings.add(singlesearchDropdown(
//           itemlist: CropTypDropDownLists,
//           hint: maincropHint,
//           selecteditem: slctCroptyp,
//           onChanged: (value) {
//             setState(() {
//               slctCroptyp = value!;
//               for (int i = 0; i < cropUIModel.length; i++) {
//                 if (slctCroptyp == cropUIModel[i].name) {
//                   slctCrptypId = cropUIModel[i].value;
//                   varietylaod(slctCrptypId);
//                   print('slctLandOwnrship: ' + slctCroptyp + slctCrptypId);
//                 }
//               }
//             });
//             if (TreeModelList[0].productId!=slctCrptypId) {
//               print('slctproduct: ' + TreeModelList[0].productId+ slctCrptypId);
//               TreeModelList.clear();
//             }
//
//           },
//           onClear: () {
//             setState(() {
//               slctCroptyp = '';
//               varietyLoaded = false;
//             });
//           }));  */
//
//       listings.add(DropDownWithModel(
//           itemlist: cropitems,
//           selecteditem: slctcrops,
//           hint: maincropHint,
//           onChanged: (value) {
//             setState(() {
//               slctcrops = value!;
//               slctCrptypId = slctcrops!.value;
//               slctCroptyp = slctcrops!.name;
//               varietylaod(slctCrptypId);
//               slctvarietys = null;
//               slcttrees = null;
//               slctproductions = null;
//               noOfMaturdTreesController.text = "";
//             });
//             print("Crop Type " + slctCrptypId);
//             if (TreeModelList[0].productId != slctCrptypId) {
//               print(
//                   'slctproduct: ' + TreeModelList[0].productId + slctCrptypId);
//               TreeModelList.clear();
//             }
//           },
//           onClear: () {
//             setState(() {
//               slctCroptyp = '';
//               varietyLoaded = false;
//             });
//           }));
//
//       /*Main Crop Dropdown*/
//       /*Label*/
//       listings.add(txt_label_mandatory(variety, Colors.black, 14.0, false));
//       /*Dropdown*/
//       /*Dropdown*/
//       /* listings.add(singlesearchDropdown(
//           itemlist: VartyDropDownLists,
//           hint: varietyHint,
//           selecteditem: slctVrtyp,
//           onChanged: (value) {
//             setState(() {
//               slctVrtyp = value!;
//               print("slctVart" + slctVrtyp);
//               for (int i = 0; i < vartyUIModel.length; i++) {
//                 if (slctVrtyp == vartyUIModel[i].name) {
//                   slctVartypId = vartyUIModel[i].value;
//                   print("slctVarty" + slctVartypId);
//                   print('slctLandOwnrship: ' + slctVrtyp + slctVartypId);
//                 }
//               }
//             });
//           },
//           onClear: () {
//             setState(() {
//               slctVrtyp = '';
//             });
//           }));  */
//
//       listings.add(DropDownWithModel(
//           itemlist: varietyitems,
//           selecteditem: slctvarietys,
//           hint: varietyHint,
//           onChanged: (value) {
//             setState(() {
//               slctvarietys = value!;
//               slctVartypId = slctvarietys!.value;
//               slctVrtyp = slctvarietys!.name;
//             });
//           },
//           onClear: () {
//             setState(() {
//               slctVrtyp = '';
//             });
//           }));
//
//       /*Main Crop Dropdown*/
//       /*Label*/
//       listings.add(txt_label_mandatory(ageoftrees, Colors.black, 14.0, false));
//       /*Dropdown*/
//       /*  listings.add(singlesearchDropdown(
//           itemlist: AgetreeDropDownLists,
//           hint: ageoftreesHint,
//           selecteditem: slctAgetreetyp,
//           onChanged: (value) {
//             setState(() {
//               slctAgetreetyp = value!;
//
//               for (int i = 0; i < agetreeUIModel.length; i++) {
//                 if (slctAgetreetyp == agetreeUIModel[i].name) {
//                   slctAgetreetypId = agetreeUIModel[i].value;
//                   print(
//                       'slctLandOwnrship: ' + slctAgetreetyp + slctAgetreetypId);
//                 }
//               }
//             });
//           },
//           onClear: () {
//             setState(() {
//               slctAgetreetyp = '';
//             });
//           }));  */
//
//       listings.add(DropDownWithModel(
//           itemlist: treeitems,
//           selecteditem: slcttrees,
//           hint: ageoftreesHint,
//           onChanged: (value) {
//             setState(() {
//               slcttrees = value!;
//               slctAgetreetypId = slcttrees!.value;
//               slctAgetreetyp = slcttrees!.name;
//             });
//           },
//           onClear: () {
//             setState(() {
//               slctAgetreetyp = '';
//             });
//           }));
//
//       /*Number of matured trees*/
//       /*Label*/
//       listings
//           .add(txt_label_mandatory(nomaturetrees, Colors.black, 14.0, false));
//
//       /*Field*/
//       listings
//           .add(txtfield_digits(nomaturetrees, noOfMaturdTreesController, true));
//
//       /*Type of Production Dropdown*/
//       /*Label*/
//       listings
//           .add(txt_label_mandatory(productiontype, Colors.black, 14.0, false));
//       /*Dropdown*/
//       /* listings.add(singlesearchDropdown(
//           itemlist: prodTypeDropDownLists,
//           hint: productionHint,
//           selecteditem: slctProdType,
//           onChanged: (value) {
//             setState(() {
//               slctProdType = value!;
//
//               for (int i = 0; i < prodTypeUIModel.length; i++) {
//                 if (slctProdType == prodTypeUIModel[i].name) {
//                   slctProdTypeId = prodTypeUIModel[i].value;
//                   print('slctProdType: ' + slctProdType + slctProdTypeId);
//                 }
//               }
//             });
//           },
//           onClear: () {
//             setState(() {
//               slctProdType = '';
//             });
//           })); */
//
//       listings.add(DropDownWithModel(
//           itemlist: productionitems,
//           selecteditem: slctproductions,
//           hint: productionHint,
//           onChanged: (value) {
//             setState(() {
//               slctproductions = value!;
//               slctProdTypeId = slctproductions!.value;
//               slctProdType = slctproductions!.name;
//             });
//           },
//           onClear: () {
//             setState(() {
//               slctProdType = '';
//             });
//           }));
//
//       listings.add(btn_dynamic(
//           label: add,
//           bgcolor: Colors.green,
//           txtcolor: Colors.white,
//           fontsize: 18.0,
//           centerRight: Alignment.centerRight,
//           margin: 20.0,
//           btnSubmit: () {
//             bool variety = false;
//             for (int i = 0; i < TreeModelList.length; i++) {
//               print("1st Variety" );
//               if (TreeModelList[i].varietyname == slctVrtyp) {
//                 variety = true;
//               }
//             }
//
//             if (slctVrtyp == '' || slctVrtyp.length == 0) {
//               AlertPopup(varietyHint);
//             } else if (variety == true) {
//               AlertPopup(varietyexistalert);
//             } else if (slctAgetreetypId == '' || slctAgetreetypId.length == 0) {
//               AlertPopup(ageoftreesalert);
//             } else if (noOfMaturdTreesController.text.length == 0) {
//               AlertPopup(maturedtreesalert);
//             } else if (slctProdType == '' || slctProdType.length == 0) {
//               AlertPopup(productiontypealert);
//             } else {
//               setState(() {
//                 var TreelistValues = new Treelistmodel(
//                   slctCrptypId,
//                   slctVartypId,
//                   slctVrtyp,
//                   slctAgetreetypId,
//                   slctAgetreetyp,
//                   noOfMaturdTreesController.text,
//                   slctProdType,
//                   slctProdTypeId,
//                 );
//                 //confirmationPopup();
//                 TreeModelList.add(TreelistValues);
//               });
//
//               slctvarietys = null;
//               slcttrees = null;
//               slctproductions = null;
//
//               slctVrtyp = "";
//               slctVartypId = "";
//               slctAgetreetypId = "";
//               slctAgetreetyp = "";
//               noOfMaturdTreesController.text = "";
//               slctProdType = "";
//               slctProdTypeId = "";
//             }
//           }));
//       if (TreeModelList != '' && TreeModelList.length > 0) {
//         listings.add(Datatabletree());
//       }
//       listings.add(Container(
//         child: Row(
//           children: [
//             Expanded(
//               flex: 1,
//               child: Container(
//                 padding: EdgeInsets.all(3),
//                 child: RaisedButton(
//                   child: Text(
//                     cancel,
//                     style: new TextStyle(color: Colors.white, fontSize: 18),
//                   ),
//                   onPressed: () {
//                     btncancel();
//                   },
//                   color: Colors.redAccent,
//                 ),
//               ),
//             ),
//             Expanded(
//               flex: 1,
//               child: Container(
//                 padding: EdgeInsets.all(3),
//                 child: RaisedButton(
//                   child: Text(
//                     submit,
//                     style: new TextStyle(color: Colors.white, fontSize: 18),
//                   ),
//                   onPressed: () {
//                     btnSubmit();
//                   },
//                   color: Colors.green,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ));
//     }
//     return listings;
//   }
//
//   Widget Datatabletree() {
//     // product[];
//     List<DataColumn> columns = [];
//     List<DataRow> rows = [];
//
//     /*Columns*/
//     //columns.add(DataColumn(label: Text('S.No')));
//     //columns.add(DataColumn(label: Text('Processing Centre/Warehouse')));
//     columns.add(DataColumn(label: Text(variety)));
//     columns.add(DataColumn(label: Text(ageoftrees)));
//     columns.add(DataColumn(label: Text(nomaturetrees)));
//     columns.add(DataColumn(label: Text(productiontype)));
//     columns.add(DataColumn(label: Text(delete)));
//
//     // columns.add(DataColumn(label: Text('Delete')));
//     /*Rows*/
//     for (int i = 0; i < TreeModelList.length; i++) {
//       int rowno = i + 1;
//       String Sno = rowno.toString();
//       List<DataCell> singlecell = [];
//
//       singlecell.add(DataCell(Text(TreeModelList[i].varietyname)));
//       singlecell.add(DataCell(Text(TreeModelList[i].Agetreename)));
//       singlecell.add(DataCell(Text(TreeModelList[i].Noftree)));
//       singlecell.add(DataCell(Text(TreeModelList[i].Typeprodname)));
//       singlecell.add(DataCell(InkWell(
//         onTap: () {
//           setState(() {
//             TreeModelList.removeAt(i);
//           });
//         },
//         child: Icon(
//           Icons.delete_forever,
//           color: Colors.red,
//         ),
//       )));
//       rows.add(DataRow(
//         cells: singlecell,
//       ));
//     }
//
//     Widget objWidget = datatable_dynamic(columns: columns, rows: rows);
//     return objWidget;
//   }
//
//   /*AlertPopUp*/
//   void AlertPopup(String message) {
//     Alert(
//       context: context,
//       type: AlertType.warning,
//       title: info,
//       desc: message,
//       buttons: [
//         DialogButton(
//           child: Text(
//             ok,
//             style: TextStyle(color: Colors.white, fontSize: 20),
//           ),
//           onPressed: () {
//             Navigator.pop(context);
//           },
//           width: 120,
//         )
//       ],
//     ).show();
//   }
//
//   /*btnSubmit Method*/
//   btnSubmit() {
//     /*Validation Process*/
//     print("_imagefilefarm" + _imagefilefarm.toString());
//     if (farmNameController.text.length == 0) {
//       AlertPopup(farmnamealert);
//     } else if ((_imagefilefarm == null || _imagefilefarm == "null") ||
//         (_imagefilefarm == "" || _imagefilefarm == '')) {
//       AlertPopup(farmphotoalert);
//     } else if ((!sameFarmeraddress) && (addressController.text.length) == 0) {
//       AlertPopup(farmaddressalert);
//     } else if (totalLndSizeAcreController.text.length == 0) {
//       AlertPopup(totallandsizealert);
//     } else if (slctLandOwnrship == '' || slctLandOwnrship.length == 0) {
//       AlertPopup(landowneralert);
//     } else if (slctCrptypId == '' || slctCrptypId.length == 0) {
//       AlertPopup(maincropHint);
//       /* } else if (slctAgetreetypId == '' || slctAgetreetypId.length == 0) {
//       AlertPopup(ageoftreesalert);
//     } else if (noOfMaturdTreesController.text.length == 0) {
//       AlertPopup(maturedtreesalert);
//     } else if (slctProdType == '' || slctProdType.length == 0) {
//       AlertPopup(productiontypealert); */
//     } else if (slctSoiltyp == '' || slctSoiltyp.length == 0) {
//       AlertPopup(valsoilType);
//     } else if (slctIrrigattyp == '' || slctIrrigattyp.length == 0) {
//       AlertPopup(valirrigationType);
//     } else if (TreeModelList.length == 0) {
//       AlertPopup(valatleastCrp);
//     } else {
//       confirmationPopup();
//     }
//   }
//
//   /*confirmationPopUp Method*/
//   void confirmationPopup() {
//     Alert(
//       context: context,
//       type: AlertType.warning,
//       title: conformation,
//       desc: proceed,
//       buttons: [
//         DialogButton(
//           child: Text(
//             yes,
//             style: TextStyle(color: Colors.white, fontSize: 20),
//           ),
//           onPressed: () {
//             saveFarmData();
//             Navigator.pop(context);
//           },
//           width: 120,
//         ),
//         DialogButton(
//           child: Text(
//             no,
//             style: TextStyle(color: Colors.white, fontSize: 20),
//           ),
//           onPressed: () {
//             Navigator.pop(context);
//           },
//           width: 120,
//         )
//       ],
//     ).show();
//   }
//
//   void btncancel() {
//     _onBackPressed();
//   }
//
//   Future getImage() async {
//     var image = await ImagePicker.platform
//         .pickImage(source: ImageSource.camera, imageQuality: 50);
//     setState(() {
//       _imagefilefarm = File(image!.path);
//     });
//   }
//
//   Future getImagefrm() async {
//     var image = await ImagePicker.platform
//         .pickImage(source: ImageSource.camera, imageQuality: 50);
//     setState(() {
//       _imagefilefarm = File(image!.path);
//     });
//   }
//
//   imageDialog() {
//     var alertStyle = AlertStyle(
//       animationType: AnimationType.grow,
//       overlayColor: Colors.black87,
//       isCloseButton: true,
//       isOverlayTapDismiss: true,
//       titleStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
//       descStyle: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
//       animationDuration: Duration(milliseconds: 400),
//     );
//
//     Alert(
//         context: context,
//         style: alertStyle,
//         title: pickimg,
//         desc: chse,
//         buttons: [
//           DialogButton(
//             child: Text(
//               galry,
//               style: TextStyle(color: Colors.white, fontSize: 18),
//             ),
//             //onPressed:btncancel ,
//             onPressed: () {
//               setState(() {
//                 getImageFromGallery();
//                 Navigator.pop(context);
//               });
//             },
//             color: Colors.deepOrange,
//           ),
//           DialogButton(
//             child: Text(
//               Camera,
//               style: TextStyle(color: Colors.white, fontSize: 18),
//             ),
//             //onPressed:btnok,
//             onPressed: () {
//               getImageFromCamera();
//               Navigator.pop(context);
//             },
//             color: Colors.green,
//           )
//         ]).show();
//   }
//
//   Future getImageFromCamera() async {
//     var image = await ImagePicker.platform
//         .pickImage(source: ImageSource.camera, imageQuality: 50);
//     setState(() {
//       _imagefilefarm = File(image!.path);
//     });
//   }
//
//   Future getImageFromGallery() async {
//     var image = await ImagePicker.platform
//         .pickImage(source: ImageSource.gallery, imageQuality: 50);
//     setState(() {
//       _imagefilefarm = File(image!.path);
//     });
//   }
//
//   imageDialog1() {
//     var alertStyle = AlertStyle(
//       animationType: AnimationType.grow,
//       overlayColor: Colors.black87,
//       isCloseButton: true,
//       isOverlayTapDismiss: true,
//       titleStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
//       descStyle: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
//       animationDuration: Duration(milliseconds: 400),
//     );
//
//     Alert(
//         context: context,
//         style: alertStyle,
//         title: pickimage,
//         desc: choose,
//         buttons: [
//           DialogButton(
//             child: Text(
//               gallery,
//               style: TextStyle(color: Colors.white, fontSize: 18),
//             ),
//             //onPressed:btncancel ,
//             onPressed: () {
//               setState(() {
//                 getImagefrmGallery();
//                 Navigator.pop(context);
//               });
//             },
//             color: Colors.deepOrange,
//           ),
//           DialogButton(
//             child: Text(
//               camera,
//               style: TextStyle(color: Colors.white, fontSize: 18),
//             ),
//             //onPressed:btnok,
//             onPressed: () {
//               getImagefrmCamera();
//               Navigator.pop(context);
//             },
//             color: Colors.green,
//           )
//         ]).show();
//   }
//
//   Future getImagefrmCamera() async {
//     var image = await ImagePicker.platform
//         .pickImage(source: ImageSource.camera, imageQuality: 50);
//     setState(() {
//       _imagefilefarm = File(image!.path);
//     });
//   }
//
//   Future getImagefrmGallery() async {
//     var image = await ImagePicker.platform
//         .pickImage(source: ImageSource.gallery, imageQuality: 50);
//     setState(() {
//       _imagefilefarm = File(image!.path);
//     });
//   }
//
//   void ondelete() {
//     if (_imagefilefarm != '' || _imagefilefarm != null) {
//       setState(() {
//         _imagefilefarm = null as File?;
//       });
//     }
//   }
//
//   void ondeletefrm() {
//     if (_imagefilefarm != null) {
//       setState(() {
//         _imagefilefarm = null;
//       });
//     }
//   }
//
//   /*confirmationPopup(dialogContext) {
//     var alertStyle = AlertStyle(
//       animationType: AnimationType.grow,
//       overlayColor: Colors.black87,
//       isCloseButton: true,
//       isOverlayTapDismiss: true,
//       titleStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
//       descStyle: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
//       animationDuration: Duration(milliseconds: 400),
//     );
//
//     Alert(
//         context: dialogContext,
//         style: alertStyle,
//         title: "Confirmation",
//         desc: "Do you want to reset the farmer details",
//         buttons: [
//           DialogButton(
//             child: Text(
//               "Cancel",
//               style: TextStyle(color: Colors.white, fontSize: 18),
//             ),
//             //onPressed:btncancel ,
//             onPressed: () {
//               setState(() {
//                 sameaddress = false;
//                 Navigator.pop(dialogContext);
//               });
//             },
//             color: Colors.deepOrange,
//           ),
//           DialogButton(
//             child: Text(
//               "OK",
//               style: TextStyle(color: Colors.white, fontSize: 18),
//             ),
//             onPressed: () {
//               setState(() {
//                 sameaddress = true;
//                 Navigator.pop(dialogContext);
//               });
//             },
//             color: Colors.green,
//           )
//         ]).show();
//   }  */
//
//   /*Save Farm Data*/
//   saveFarmData() async {
//     /*TxnHeader*/
//     final now = new DateTime.now();
//     String txntime = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
//     String msgNo = DateFormat('yyyyMMddHHmmss').format(now);
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     String? agentid = prefs.getString("agentId");
//     String? agentToken = prefs.getString("agentToken");
//
//     Random rnd = new Random();
//     int revNo = 100000 + rnd.nextInt(999999 - 100000);
//
//     String txnHeaderQuery =
//         'INSERT INTO "main"."txnHeader" ("isPrinted", "txnTime", "mode", "operType", "resentCount", "agentId", "agentToken", "msgNo", "servPointId", "txnRefId") VALUES ('
//                 '0,\'' +
//             txntime +
//             '\', '
//                 '\'02\', '
//                 '\'01\', '
//                 '\'0\',\'' +
//             agentid! +
//             '\', \'' +
//             agentToken! +
//             '\',\'' +
//             msgNo +
//             '\', \'' +
//             servicePointId! +
//             '\',\'' +
//             revNo.toString() +
//             '\')';
//     int txnRes = await db.RawInsert(txnHeaderQuery);
//     print('txnRes:' + txnRes.toString());
//
//     /*Saving Custom Transaction*/
//     AppDatas appDatas = new AppDatas();
//     await db.saveCustTransaction(
//         txntime, appDatas.txn_addFarm, revNo.toString(), '', '', '');
//
//     /*Values*/
//     String farmName = farmNameController.text;
//     String isFarmerSameAddressId = isFarmerSameAddress;
//     String countryNameId = slctCountryNameId;
//     String subCountryNameId = slctSubCountryNameId;
//     String CountryNameId = val_State;
//     String wardNameId = slctWardNameId;
//     String villageNameId = slctVillageNameId;
//     String groupNameId = slctGroupNameId;
//     String totalLandSize = totalLndSizeAcreController.text;
//     String landOwnrShipId = slctLandOwnrshipId;
//     String noOfYoungTrees = noOfYoungTreesController.text;
//     String address = addressController.text;
//     List<int> imageBytes = _imagefilefarm!.readAsBytesSync();
//     farmImg64 = base64Encode(imageBytes);
//
//     String farmPhotoPath = "";
//     if (_imagefilefarm != null) {
//       farmPhotoPath = _imagefilefarm!.path;
//     }
//
//     String farmCode = msgNo + farmerId;
//     print("farmCode" + farmCode);
//     for (int i = 0; i < TreeModelList.length; i++) {
//       String slctVrtyp = TreeModelList[i].variety;
//       String slctAgetreetyp = TreeModelList[i].Agetree;
//       String noOfMatrdTrees = TreeModelList[i].Noftree;
//       String prodTypeId = TreeModelList[i].Typeprod;
//       String treeins =
//           'INSERT INTO "main"."treeList" ("farmerId", "variety", "Agetree", "Noftree", "Typeprod") VALUES '
//                   '(\'' +
//               farmCode +
//               '\',\' ' +
//               slctVrtyp +
//               '\',\' ' +
//               slctAgetreetyp +
//               '\',\' ' +
//               noOfMatrdTrees +
//               '\',\' ' +
//               prodTypeId +
//               '\')';
//       print("treeinserting " + treeins);
//       db.RawQuery(treeins);
//     }
//
//     /*Saving values to Farm Table*/
//     String farmInsertQry =
//         'INSERT INTO "main"."farm" ("farmIrrigation","NC","convenYield","convenCrop","convenLand","fallowPastureLand","landICSstatus","surveyNo","nameInteralIns","dateInternalIns","beginofConver","chemicalAppLastDate","soilFert","soilTyp","irrigationMth","irrigationRes","areaIrrigation","farmOwned","seasonalWorkerCnt","fullTimeWorkerCnt","partTimeWorkerCnt","waterBodiesCnt","landMeasure","farmAddress","isSameFarmerAddress","timeStamp","longitude","latitude","image","farmIDT","farmArea","farmName","farmerId","prodLand","notProdLand","landProd","landNProd","isSynched","recptId","farmStatus","landOwner","landGradient","farmCrop","farmVariety","avgStorage","treeName","approachRoad","year","soilTexture","otherIrrigationRes","verifyStatus","labourDetails","seasonYear","landTopography","soilTest","testPhoto","otherLandOwn","farmRegNo","currentConversion","inspectionDate","nameInspector","qualify","reasonSanction","durationSanction","farmId","farmDistrict","farmTaluk","farmPanchayat","farmVillage","farmSamithee","farmFPOFG","farmLandDetails","tenantId","farmcertYear","farmPlatNo","waterHarvest","distProcessUnit","processAct","farmdeleteStatus","farmCertType","waterSource","locCroTree","numCroTrees","irrLand","ownLand","leaseLand","frPhoto","fieldName","fieldArea","fieldCrop","qtyApply","lstDtCheApp","inputsApp","inpSource","actCocFarm","presenceBanana","parallelProduction","organicUnit","hiredLabour","riskCategory","numCofTrees","vermiUnit","docIdNo","coffeeMac","pltStatus","totLand","insType","inspName","insDate","inspDetList","dynfield","geoStatus","landmark") VALUES ('
//                 'null' //farmIrrigation
//             +
//             ',null' //NC
//             +
//             ',null' //convenYield
//             +
//             ',null' // convenCrop
//             +
//             ',null' //convenLand
//             +
//             ',null' //fallowPastureLand
//             +
//             ',null' //landICSstatus
//             +
//             ',\'' +
//             landOwnrShipId //surveyNo
//             +
//             '\',null' //nameInteralIns
//             +
//             ',null' //dateInternalIns
//             +
//             ',null' //beginofConver
//             +
//             ',null' //chemicalAppLastDate
//             +
//             ',\'' +
//             totalLandSize + //soilFert
//             '\',\'' +
//             isFarmerSameAddressId //soilTyp
//             +
//             '\',\'' +
//             slctIrrigattypId //irrigationMth
//             +
//             "" +
//             '\',null' //irrigationRes
//             +
//             ',null' //areaIrrigation
//             +
//             ',\'' +
//             "" //farmOwned
//             +
//             '\',null' //seasonalWorkerCnt
//             +
//             ',null' //fullTimeWorkerCnt
//             +
//             ',null' //partTimeWorkerCnt
//             +
//             ',null' //waterBodiesCnt
//             +
//             ',null' //landMeasure
//             +
//             ',\'' +
//             address //farmAddress
//             +
//             '\',null' //isSameFarmerAddress
//             +
//             ',\'' +
//             txntime //timeStamp
//             +
//             '\',\'' +
//             Lng //longitude
//             +
//             '\',\'' +
//             Lat //Latitude
//             +
//             '\',\'' +
//             farmPhotoPath //image
//             +
//             '\',\'' +
//             farmCode //farmIDT
//             +
//             '\',null' //farmArea
//             +
//             ',\'' +
//             farmName //farmName
//             +
//             '\',\'' +
//             farmerId //farmerId
//             +
//             '\',\'' +
//             "" //prodLand
//             +
//             '\',null' //notProdLand
//             +
//             ',null' //landProd
//             +
//             ',null' //landNProd
//             +
//             ',\'' +
//             '1' //isSynched
//             +
//             '\'' +
//             ',\'' +
//             revNo.toString() +
//             '\'' //recptId
//             +
//             ',null' //farmStatus
//             +
//             ',null' //landOwner
//             +
//             ',\'' +
//             '' //landGradient
//             +
//             '\',\'' +
//             slctCrptypId //farmCrop
//             +
//             '\',\'' +
//             '' //farmVariety
//             +
//             '\',\'' +
//             '' //avgStorage
//             +
//             '\',\'' +
//             noOfMaturdTreesController.text //treeName
//             +
//             '\',\'' +
//             noOfYoungTrees //approachRoad
//             +
//             '\',null' //year
//             +
//             ',\'' +
//             slctSoiltypId //soilTexture
//             +
//             '\',null' //otherIrrigationRes
//             +
//             ',null' //verifyStatus
//             +
//             ',null' //labourDetails
//             +
//             ',null' //seasonYear
//             +
//             ',\'' +
//             '' //landTopography
//             +
//             '\',null' //soilTest
//             +
//             ',null' //testPhoto
//             +
//             ',null' //otherLandOwn
//             +
//             ',null' //farmRegNo
//             +
//             ',null' //currentConversion
//             +
//             ',null' //inspectionDate
//             +
//             ',null' //nameInspector
//             +
//             ',null' //qualify
//             +
//             ',null' //reasonSanction
//             +
//             ',null' //durationSanction
//             +
//             ',null' //farmId
//             +
//             ',null' +
//             ',\'' +
//             subCountryNameId +
//             '\',\'' +
//             CountryNameId +
//             '\',\'' +
//             villageNameId +
//             '\',\'' +
//             wardNameId +
//             '\',\'' +
//             groupNameId +
//             '\',null' +
//             ',null' //farmLandDetails
//             +
//             ',null' //tenantId
//             +
//             ',null' //farmcertYear
//             +
//             ',null' //farmPlatNo
//             +
//             ',null' //waterHarvest
//             +
//             ',null' //distProcessUnit
//             +
//             ',null' //processAct
//             +
//             ',null' //farmdeleteStatus
//             +
//             ',null' //farmCertType
//             +
//             ',null' //watersource
//             +
//             ',null' //locCroTree
//             +
//             ',null' //numCroTrees
//             +
//             ',null' //irrLand
//             +
//             ',null' //ownLand
//             +
//             ',null' //leaseLand
//             +
//             ',\'' +
//             '' //frPhoto
//             +
//             '\',null' //fieldName
//             +
//             ',null' //fieldArea
//             +
//             ',null' //fieldCrop
//             +
//             ',null' //qtyApply
//             +
//             ',null' //lstDtCheApp
//             +
//             ',null' //inputsApp
//             +
//             ',null' //inpSource
//             +
//             ',null' //actCocFarm
//             +
//             ',null' //presenceBanana
//             +
//             ',null' //parallelProduction
//             +
//             ',null' //organicUnit
//             +
//             ',null' //hiredLabour
//             +
//             ',null' //riskCategory
//             +
//             ',null' //numCofTrees
//             +
//             ',null' //vermiUnit
//             +
//             ',null' //docIdNo
//             +
//             ',\'' +
//             '' //coffeeMac
//             +
//             '\',null' //pltStatus
//             +
//             ',\'' +
//             '' //totLand
//             +
//             '\',\'' //insType
//             +
//             '' +
//             '\',null' //inspName
//             +
//             ',null' //insDate
//             +
//             ',null' //inspDetList
//             +
//             ',null,\'' +
//             '' +
//             '\');';
//
//     print("farmInsertQry:" + farmInsertQry);
//     int farmInsert = await db.RawInsert(farmInsertQry);
//     print("farmInsert:" + farmInsert.toString());
//     List<Map> farmDBList = await db.GetTableValues('farm');
//     print("farmDBList:" + farmDBList.toString());
//     int issync = await db.UpdateTableValue(
//         'farm', 'isSynched', '0', 'recptId', revNo.toString());
//     print('isSyncOnTable:' + issync.toString());
//
//     TxnExecutor txnExecutor = new TxnExecutor();
//     txnExecutor.CheckCustTrasactionTable();
//     /*Alert*/
//     Alert(
//       context: context,
//       type: AlertType.info,
//       title: transactionsuccesfull,
//       desc: farmsuccess + '\n' + receiptid + revNo.toString(),
//       buttons: [
//         DialogButton(
//           child: Text(
//             ok,
//             style: TextStyle(color: Colors.white, fontSize: 20),
//           ),
//           onPressed: () {
//             Navigator.of(context).pushReplacement(MaterialPageRoute(
//                 builder: (BuildContext context) => DashBoard("", "")));
//           },
//           width: 120,
//         ),
//       ],
//     ).show();
//   }
// }
