// import 'dart:async';
// import 'dart:convert';
// import 'dart:math';
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
// import 'package:cupertino_radio_choice/cupertino_radio_choice.dart';
// import 'package:dropdown_search/dropdown_search.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
//
//
// import 'dart:io' show File;
// import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:intl/intl.dart';
//
// import 'package:rflutter_alert/rflutter_alert.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// import 'addfarm.dart';
//
// class farm extends StatefulWidget {
//   @override
//   State<StatefulWidget> createState() {
//     return _farm();
//   }
// }
//
// class _farm extends State<farm> {
//   var db = DatabaseHelper();
//
//   String Latitude = '', Longitude = '';
//   bool ishavefarmercode = false;
//   bool farmerloaded = false;
//   List<UImodel> groupsModel = [];
//   List<UImodel> groupPosModel = [];
//   List<UImodel> enrollPlaceModel = [];
//   List<UImodel> groupNameModel = [];
//   List<UImodel> groupTypeModel = [];
//   List<UImodel> aggregatorTypeModel = [];
//   List<UImodel> countryUIModel = [];
//   List<UImodel> zoneUIModel = [];
//   List<UImodel> woredaUIModel = [];
//   List<UImodel> kebeleUIModel = [];
//   List<blocklistmodel> blockModelList = [];
//
//   List<DropdownModel> aggregatorTypeitems = [];
//   DropdownModel? slctaggregatorTypes;
//   String slctaggregator = "" , val_aggregator = "";
//
//   List<DropdownModel> villageitems = [];
//   DropdownModel? slctvillages;
//   String slct_village = "" , villageCode = "";
//
//   List<DropdownModel> farmeritems = [];
//   DropdownModel? slctFarmers;
//   String slct_farmer = "" , farmerId = "",farmerAddress="";
//   List<UImodel2> farmerlistUIModel = [];
//
//
//   List<DropdownModel> countryitems = [];
//   DropdownModel? slctcountrys;
//   String val_country = '' , slctcountry = '';
//
//   List<DropdownModel> zoneitems = [];
//   DropdownModel? slctzones;
//   String val_zone = '' , slctzone = '';
//
//   List<DropdownModel> woredaitems = [];
//   DropdownModel? slctworedas;
//   String val_woreda = '' , slctworeda = '';
//
//   List<DropdownModel> kebeleitems = [];
//   DropdownModel? slctkebeles;
//   String val_kebele = '' , slctkebele = '';
//
//   List<DropdownModel> groupNameitems = [];
//   DropdownModel? slctgroupNames;
//   String val_groupName = '' , slctgroupName = '';
//
//   List<DropdownModel> groupTypeitems = [];
//   DropdownModel? slctgroupTypes;
//   String val_groupType = '' , slctgroupType = '';
//
//   List<DropdownModel> groupPositems = [];
//   DropdownModel? slctgroupPoss;
//   String val_groupPos = '' , slctgroupPos = '';
//
//   List<DropdownModel> enrollPersonitems = [];
//   DropdownModel? slctenrollPersons;
//   String val_enrollPerson = '' , slctenrollPerson = '';
//
//
//   List<Map> agents = [];
//
//   bool zoneloaded = false;
//   bool woredaloaded = false;
//   bool kebeleloaded = false;
//
//   TextEditingController? enrollingPersonController,
//       aggregatorNameController,
//       fatherNameController,
//       gfatherNameController,
//       aggFullnameController,
//       educationcontroller ,
//       emailController,
//       mobileController,
//       accountnoController,
//       bankController,
//       branchController,
//       ageController,
//       phoneController;
//
//
//   String yuthalt = '';
//   int elegibleRegister = 0;
//
//   int farmerid = 0;
//   bool isregistration = false;
//
//
//   String seasoncode = '';
//   String servicePointId = '';
//   String agendId = '';
//
//   List<String> countryList = ['Loading'];
//   List<String> zoneList = ['Loading'];
//   List<String> woredaList = ['Loading'];
//   List<String> kebeleList = ['Loading'];
//
//
//   final Map<String, String> groupmap = {
//     'option1': "NO",
//     'option2': "YES",
//   };
//
//   final Map<String, String> licensemap = {
//     'option1': "NO",
//     'option2': "YES",
//   };
//
//   String groupSelect = "";
//
//   String  group = "option1",  _selectedgroup = "1",
//           license = "option1" , _selectedLicense = "1";
//
//   String enrollmentDate = "",
//          enrollmentFormatedDate = "",
//          dateofbirth = '',
//          dateofbirthFormatedDate = '',
//          dateofyear = "";
//
//   //Image files
//
//   String aggregatorImage64 = "";
//   String bankImage64 = "";
//   String licenseImage64 = "";
//
//   File? aggregatorImageFile;
//   File? bankImageFile;
//   File? licenseImageFile;
//
//
//   int curIdLim = 0;
//   int resId = 0;
//   int curIdLimited = 0;
//
//   @override
//   void initState() {
//     super.initState();
//
//     initvalues();
//     getClientData();
//
//
//     groupSelect = "1";
//
//     aggregatorNameController = new TextEditingController();
//     enrollingPersonController = new TextEditingController();
//     fatherNameController = new TextEditingController();
//     gfatherNameController = new TextEditingController();
//     aggFullnameController = new TextEditingController();
//     educationcontroller = new TextEditingController();
//     emailController = new TextEditingController();
//     accountnoController = new TextEditingController();
//     bankController = new TextEditingController();
//     branchController = new TextEditingController();
//     mobileController = new TextEditingController();
//     phoneController = new TextEditingController();
//     emailController = new TextEditingController();
//
//     getLocation();
//
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
//         Latitude = position.latitude.toString();
//         Longitude = position.longitude.toString();
//       });
//     } else {
//       Alert(context: context, title: "Information", desc: "GPS location not enabled", buttons: [
//         DialogButton(
//           child: Text(
//             "OK",
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
//   @override
//   void dispose() {
//     super.dispose();
//   }
//
//   getClientData() async {
//     agents = await db.RawQuery('SELECT * FROM agentMaster');
//
//     seasoncode = agents[0]['currentSeasonCode'];
//     servicePointId = agents[0]['servicePointId'];
//     agendId = agents[0]['agentId'];
//     String resIdd = agents[0]['resIdSeqF'];
//     print("resIdgetcliendata" + resIdd);
//     print("agendId_agendId" + agendId);
//   }
//
//   Future<void> initvalues() async {
//     String qry_villagelist =
//         'Select distinct v.villCode,v.villName from villageList as v inner join farmer_master as f on f.villageId =v.villCode';
//     print('qry_villagelist:  ' + qry_villagelist);
//     List villageslist = await db.RawQuery(qry_villagelist);
//     print('villageslist 1:  ' + villageslist.toString());
//     villageitems.clear();
//
//     for (int i = 0; i < villageslist.length; i++) {
//       String villName = villageslist[i]["villName"].toString();
//       String villCode = villageslist[i]["villCode"].toString();
//       setState(() {
//         villageitems.add(DropdownModel(
//           villName,
//           villCode,
//         ));
//       });
//     }
//     /*IDPROOF */
//     List idprooflist = await db.RawQuery(
//         'select * from animalCatalog where catalog_code =\'44\'');
//
//     List otherlist = await db.RawQuery(
//         'select distinct DISP_SEQ ,property_value from catalog where  DISP_SEQ=\'99\' and property_value =\'Others\' ');
//
//     List newList = idprooflist + otherlist;
//     print("newList_newList" + newList.toString());
//
//     aggregatorTypeModel = [];
//
//     aggregatorTypeitems.clear();
//     for (int i = 0; i < newList.length; i++) {
//       String property_value = newList[i]["property_value"].toString();
//       String DISP_SEQ = newList[i]["DISP_SEQ"].toString();
//       var uimodel = new UImodel(property_value, DISP_SEQ);
//       aggregatorTypeModel.add(uimodel);
//
//       setState(() {
//         aggregatorTypeitems.add(DropdownModel(
//           property_value,
//           DISP_SEQ,
//         ));
//         //prooflist.add(property_value);
//       });
//     }
//
//     List groupsPos = await db.RawQuery(
//         'select * from animalCatalog where catalog_code =\'10\'');
//     print('groups ' + groupsPos.toString());
//     groupPosModel = [];
//     //groupList.clear();
//     groupPositems.clear();
//     for (int i = 0; i < groupsPos.length; i++) {
//       String property_value = groupsPos[i]["property_value"].toString();
//       String DISP_SEQ = groupsPos[i]["DISP_SEQ"].toString();
//
//       var uimodel = new UImodel(property_value, DISP_SEQ);
//       groupPosModel.add(uimodel);
//       setState(() {
//         groupPositems.add(DropdownModel(
//           property_value,
//           DISP_SEQ,
//         ));
//         //prooflist.add(property_value);
//       });
//     }
//
//     List enrollPerson = await db.RawQuery(
//         'select * from animalCatalog where catalog_code =\'5\'');
//     print('groups ' + enrollPerson.toString());
//     enrollPlaceModel = [];
//     //groupList.clear();
//     enrollPersonitems.clear();
//     for (int i = 0; i < enrollPerson.length; i++) {
//       String property_value = enrollPerson[i]["property_value"].toString();
//       String DISP_SEQ = enrollPerson[i]["DISP_SEQ"].toString();
//
//       var uimodel = new UImodel(property_value, DISP_SEQ);
//       enrollPlaceModel.add(uimodel);
//       setState(() {
//         enrollPersonitems.add(DropdownModel(
//           property_value,
//           DISP_SEQ,
//         ));
//         //prooflist.add(property_value);
//       });
//     }
//
//     List grouptypelist = await db.RawQuery(
//         'select * from animalCatalog where catalog_code =\'1\'');
//     print('villagelistFarmerEnrollment' + grouptypelist.toString());
//     groupTypeModel = [];
//     groupTypeitems = [];
//     groupTypeitems.clear();
//     for (int i = 0; i < grouptypelist.length; i++) {
//       String property_value = grouptypelist[i]["property_value"].toString();
//       String DISP_SEQ = grouptypelist[i]["DISP_SEQ"].toString();
//
//       var uimodel = new UImodel(property_value, DISP_SEQ);
//       groupTypeModel.add(uimodel);
//       setState(() {
//         groupTypeitems.add(DropdownModel(
//           property_value,
//           DISP_SEQ,
//         ));
//         //prooflist.add(property_value);
//       });
//     }
//
//     List groupNamelist = await db.RawQuery(
//         'select * from animalCatalog where catalog_code =\'6\'');
//     print('villagelistFarmerEnrollment' + groupNamelist.toString());
//     groupNameModel = [];
//     groupNameitems = [];
//     groupNameitems.clear();
//     for (int i = 0; i < groupNamelist.length; i++) {
//       String property_value = enrollPerson[i]["property_value"].toString();
//       String DISP_SEQ = enrollPerson[i]["DISP_SEQ"].toString();
//
//       var uimodel = new UImodel(property_value, DISP_SEQ);
//       groupNameModel.add(uimodel);
//       setState(() {
//         groupNameitems.add(DropdownModel(
//           property_value,
//           DISP_SEQ,
//         ));
//         //prooflist.add(property_value);
//       });
//     }
//
//     //regionlist
//     List countrylist = await db.RawQuery('select * from countryList ');
//     print(' ' + countrylist.toString());
//     countryUIModel = [];
//     countryitems.clear();
//     for (int i = 0; i < countrylist.length; i++) {
//       String countryCode = countrylist[i]["countryCode"].toString();
//       String countryName = countrylist[i]["countryName"].toString();
//
//       var uimodel = new UImodel(countryName, countryCode);
//       countryUIModel.add(uimodel);
//       setState(() {
//         countryitems.add(DropdownModel(
//           countryName,
//           countryCode,
//         ));
//         //prooflist.add(property_value);
//       });
//     }
//     changezone();
//   }
//
//   farmersearch(String villageCode) async {
//     String qry_farmerlist =
//         'select fName,farmerId,certifiedFarmer,address from farmer_master where villageId = \'' +
//             villageCode +
//             '\'';
//     List farmerslist = await db.RawQuery(qry_farmerlist);
//     print('qry_farmerlist:  ' + farmerslist.toString());
//
//     farmeritems = [];
//     farmeritems.clear();
//     farmerlistUIModel = [];
//
//     if (farmerslist.length > 0) {
//       for (int i = 0; i < farmerslist.length; i++) {
//         String fName = farmerslist[i]["fName"].toString();
//         String farmerId = farmerslist[i]["farmerId"].toString();
//         String address = farmerslist[i]["address"].toString();
//         var uimodel = new UImodel2(fName, farmerId, address);
//         farmerlistUIModel.add(uimodel);
//         setState(() {
//           farmeritems.add(DropdownModel(
//             fName,
//             farmerId,
//           ));
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
//
//   }
//
//   Future<void> changezone() async {
//     List zonelist = await db.RawQuery('select * from stateList');
//     print('zonelist ' + zonelist.toString());
//     zoneUIModel = [];
//     zoneitems = [];
//     zoneitems.clear();
//     for (int i = 0; i < zonelist.length; i++) {
//       String regionCode = zonelist[i]["countryCode"].toString();
//       String zoneCode = zonelist[i]["stateCode"].toString();
//       String zoneName = zonelist[i]["stateName"].toString();
//
//       var uimodel = new UImodel(zoneName, zoneCode);
//       zoneUIModel.add(uimodel);
//       setState(() {
//         zoneitems.add(DropdownModel(
//           zoneName,
//           zoneCode,
//         ));
//         //prooflist.add(property_value);
//       });
//
//       Future.delayed(Duration(milliseconds: 500), () {
//         print("circle_delayfunction" + zoneName);
//         setState(() {
//           if (zonelist.length > 0) {
//
//             zoneloaded = true;
//           }
//         });
//       });
//     }
//   }
//
//   Future<void> changeworeda(String circleCode) async {
//     //communelist
//     List woredalist = await db.RawQuery(
//         'select * from districtList where stateCode =\'' + circleCode + '\'');
//     print('' + woredalist.toString());
//     woredaUIModel = [];
//     woredaitems = [];
//     woredaitems.clear();
//     for (int i = 0; i < woredalist.length; i++) {
//       String circleName = woredalist[i]["stateCode"].toString();
//       String communeName = woredalist[i]["districtName"].toString();
//       String communeCode = woredalist[i]["districtCode"].toString();
//
//       var uimodel = new UImodel(communeName, communeCode);
//       woredaUIModel.add(uimodel);
//       setState(() {
//         woredaitems.add(DropdownModel(
//           communeName,
//           communeCode,
//         ));
//         //prooflist.add(property_value);
//       });
//
//       Future.delayed(Duration(milliseconds: 500), () {
//         print("" + communeName);
//         setState(() {
//           if (woredalist.length > 0) {
//             woredaloaded = true;
//           }
//         });
//       });
//     }
//   }
//
//   Future<void> changekebele(String communeCode) async {
//     //chieftownList
//     List kebeleList = await db.RawQuery(
//         'select * from cityList where districtCode =\'' + communeCode + '\'');
//     print('' + kebeleList.toString());
//     kebeleUIModel = [];
//     kebeleitems = [];
//     kebeleitems.clear();
//     for (int i = 0; i < kebeleList.length; i++) {
//       String chieftownName = kebeleList[i]["cityName"].toString();
//       String chieftownCode = kebeleList[i]["cityCode"].toString();
//
//       var uimodel = new UImodel(chieftownName, chieftownCode);
//       kebeleUIModel.add(uimodel);
//       setState(() {
//         kebeleitems.add(DropdownModel(
//           chieftownName,
//           chieftownCode,
//         ));
//         //prooflist.add(property_value);
//       });
//
//       Future.delayed(Duration(milliseconds: 500), () {
//         print("" + chieftownName);
//         setState(() {
//           if (kebeleList.length > 0) {
//             kebeleloaded = true;
//
//           }
//         });
//       });
//     }
//   }
//
//
//   Future<bool> _onBackPressed() async {
//     return (await Alert(
//       context: context,
//       type: AlertType.warning,
//       title: "Cancel",
//       desc: "Are you sure you want to cancel?",
//       buttons: [
//         DialogButton(
//           child: Text(
//             "Yes",
//             style: TextStyle(color: Colors.white, fontSize: 20),
//           ),
//           onPressed: () {
//             Navigator.pop(context);
//             Navigator.pop(context);
//           },
//           width: 120,
//         ),
//         DialogButton(
//           child: Text(
//             "No",
//             style: TextStyle(color: Colors.white, fontSize: 20),
//           ),
//           onPressed: () {
//             Navigator.pop(context);
//           },
//           width: 120,
//         )
//       ],
//     ).show()) ??
//         false;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: WillPopScope(
//         onWillPop: _onBackPressed,
//         child: Scaffold(
//           appBar: AppBar(
//             centerTitle: true,
//             leading: IconButton(
//                 icon: Icon(Icons.arrow_back, color: Colors.white),
//                 onPressed: () {
//                   // Navigator.of(context).pop();
//
//                   _onBackPressed();
//                 }),
//             title: Text(
//               "Farm",
//               style: new TextStyle(
//                   color: Colors.white,
//                   fontSize: 18.0,
//                   fontWeight: FontWeight.w700),
//             ),
//             iconTheme: IconThemeData(color: Colors.white),
//             backgroundColor: Colors.green,
//             brightness: Brightness.light,
//           ),
//           body: Stack(
//             children: [
//               Container(
//                   child: Column(children: <Widget>[
//                     Expanded(
//                       child: ListView(
//                         padding: EdgeInsets.all(10.0),
//                         children: _getListings(
//                             context), // <<<<< Note this change for the return type
//                       ),
//                       flex: 8,
//                     ),
//                   ])),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   List<Widget> _getListings(BuildContext context) {
//     List<Widget> listings = [];
//     if (!ishavefarmercode) {
//       listings.add(txt_label('Village', Colors.black, 14.0, false));
//       listings.add(DropDownWithModel(
//           itemlist: villageitems,
//           selecteditem: slctvillages,
//           hint: 'Selet the Village',
//           onChanged: (value) {
//             setState(() {
//               slctvillages = value!;
//               villageCode = slctvillages!.value;
//               slct_village = slctvillages!.name;
//               farmersearch(villageCode);
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
//           ? txt_label('Farmer', Colors.black, 14.0, false)
//           : Container());
//
//       listings.add(farmerloaded
//           ? DropDownWithModel(
//           itemlist: farmeritems,
//           selecteditem: slctFarmers,
//           hint: 'Select for Farmer',
//           onChanged: (value) {
//             setState(() {
//               slctFarmers = value!;
//               farmerId = slctFarmers!.value;
//               slct_farmer = slctFarmers!.name;
//
//               for (int i = 0; i < farmerlistUIModel.length; i++) {
//                 if (farmerlistUIModel[i].value == farmerId) {
//                   farmerAddress = farmerlistUIModel[i].value2;
//                 }
//               }
//             });
//           },
//           onClear: () {
//             setState(() {
//               slct_farmer = '';
//               ishavefarmercode = false;
//             });
//           })
//           : Container());
//
//       listings.add(btn_dynamic(
//           label: 'Submit',
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
//                   errordialog(context, 'Information', 'Farmer should not be empty');
//                 }
//               } else {
//                 errordialog(context, 'Information', 'Village should not be empty');
//               }
//             });
//           }));
//     }
//     if (ishavefarmercode) {
//     listings.add(txt_label_mandatory("Date", Colors.black, 14.0, false));
//     listings.add(selectDate(
//         context1: context,
//         slctdate: enrollmentDate,
//         onConfirm: (date) =>
//             setState(
//                   () {
//                 enrollmentDate = DateFormat(
//                     'dd/MM/yyyy                                                                                                         ')
//                     .format(date!);
//                 enrollmentFormatedDate =
//                     DateFormat('yyyyMMdd').format(date!);
//               },
//             )));
//
//     listings.add(txt_label("General Information", Colors.green, 18.0, true));
//
//    /* listings.add(txt_label_mandatory("Country", Colors.black, 14.0, false));
//
//     listings.add(DropDownWithModel(
//         itemlist: countryitems,
//         selecteditem: slctcountrys,
//         hint: "Select the Country",
//         onChanged: (value) {
//           setState(() {
//             slctcountrys = value!;
//             zoneloaded = false;
//             kebeleloaded = false;
//
//             woredaloaded = false;
//             slctkebeles = null;
//             slctzones = null;
//             slctworedas = null;
//
//             val_country = slctcountrys!.value;
//             slctcountry = slctcountrys!.name;
//             changezone(val_country);
//           });
//           // print("Region Code" + val_region.toString());
//           // print("Region Name" + slctRegion.toString());
//         },
//         onClear: () {
//           setState(() {
//
//           });
//         }));*/
//
//     // circle
//     listings.add( txt_label_mandatory("Zone", Colors.black, 14.0, false));
//
//
//     listings.add(DropDownWithModel(
//         itemlist: zoneitems,
//         selecteditem: slctzones,
//         hint: "Select the Zone",
//         onChanged: (value) {
//           setState(() {
//             slctzones = value!;
//             woredaloaded = false;
//             kebeleloaded = false;
//
//             slctkebeles = null;
//             slctworedas = null;
//
//             val_zone = slctzones!.value;
//             slctzone = slctzones!.name;
//             changeworeda(val_zone);
//           });
//         },
//         onClear: () {
//           setState(() {
//
//           });
//         }));
//
//     //commune
//     listings.add(woredaloaded
//         ? txt_label_mandatory("Woreda", Colors.black, 14.0, false)
//         : Container());
//
//     listings.add(woredaloaded
//         ? DropDownWithModel(
//         itemlist: woredaitems,
//         selecteditem: slctworedas,
//         hint: "Select the Woreda",
//         onChanged: (value) {
//           setState(() {
//             slctworedas = value!;
//             kebeleloaded = false;
//
//             slctkebeles = null;
//
//             //toast(slctFarmers!.value);
//             val_woreda = slctworedas!.value;
//             slctworeda = slctworedas!.name;
//             changekebele(val_woreda);
//           });
//           // print("Commune Code" + val_commune.toString());
//           // print("Commune Name" + slctCommune.toString());
//         },
//         onClear: () {
//
//         })
//         : Container());
//
//     //chieftown
//     listings.add(kebeleloaded
//         ? txt_label_mandatory("Kebele", Colors.black, 14.0, false)
//         : Container());
//
//     listings.add(kebeleloaded
//         ? DropDownWithModel(
//         itemlist: kebeleitems,
//         selecteditem: slctkebeles,
//         hint: "Select the Kebele",
//         onChanged: (value) {
//           setState(() {
//             slctkebeles = value!;
//             val_kebele = slctkebeles!.value;
//             slctkebele = slctkebeles!.name;
//           });
//           // print("chiefTown Code" + val_chieftown.toString());
//           // print("chiefTown Name" + slctChieftown.toString());
//         },
//         onClear: () {
//           setState(() {
//
//           });
//         })
//         : Container());
//
//
//     listings.add(
//         txt_label_mandatory("Type of Farm", Colors.black, 14.0, false));
//
//     listings.add(DropDownWithModel(
//         itemlist: enrollPersonitems,
//         selecteditem: slctenrollPersons,
//         hint: "Select the Type of Farm",
//         onChanged: (value) {
//           setState(() {
//             slctenrollPersons = value!;
//
//             val_enrollPerson = slctenrollPersons!.value;
//             slctenrollPerson = slctenrollPersons!.name;
//           });
//         }));
//
//     listings.add(txt_label_mandatory("Farm Name", Colors.black, 14.0, false));
//
//     listings.add(
//         txtfield_dynamic("Farm Name", enrollingPersonController!, true, 27));
//
//     listings.add(txt_label_mandatory(
//         "Total Land Holding(Ha)", Colors.black, 14.0, false));
//     listings.add(txtfieldAllowTwoDecimal(
//         "Total Land Holding(Ha)", aggregatorNameController!, true, 8));
//
//     listings.add(
//         txt_label_mandatory("Hectare Owned", Colors.black, 14.0, false));
//     listings.add(txtfieldAllowTwoDecimal(
//         "Hectare Owned", fatherNameController!, true, 8));
//
//     listings.add(
//         txt_label_mandatory("Hectare Rented", Colors.black, 14.0, false));
//     listings.add(txtfieldAllowTwoDecimal(
//         "Hectare Rented", gfatherNameController!, true, 8));
//
//     listings.add(
//         txt_label_mandatory("Double Cropping", Colors.black, 14.0, false));
//     listings.add(DropDownWithModel(
//         itemlist: aggregatorTypeitems,
//         selecteditem: slctaggregatorTypes,
//         hint: "Select the Double Cropping",
//         onChanged: (value) {
//           setState(() {
//             slctaggregatorTypes = value!;
//             //toast(slctProofs!.value);
//             val_aggregator = slctaggregatorTypes!.value;
//             slctaggregator = slctaggregatorTypes!.name;
//             //print('selectedvalue ' + slctProofs!.value);
//           });
//         }));
//
//     listings.add(txt_label_mandatory(
//         "Usual number of Crops", Colors.black, 14.0, false));
//     listings.add(txtfield_digits(
//         "Usual number of Crops", aggFullnameController!, true, 2));
//
//
//     listings.add(txt_label_mandatory(
//         "3 Main crops cultivated(name + %)", Colors.black, 14.0, false));
//
//     listings.add(DropDownWithModel(
//       itemlist: groupNameitems,
//       selecteditem: slctgroupNames,
//       hint: "Select the 3 Main crops cultivated(name + %)",
//       onChanged: (value) {
//         setState(() {
//           slctgroupNames = value!;
//           val_groupName = slctgroupNames!.value;
//           slctgroupName = slctgroupNames!.name;
//         });
//       },));
//
//     listings.add(txt_label_mandatory(
//         "Possibility of mechanism for Soil preparation & Sowing", Colors.black,
//         14.0, false));
//
//     listings.add(radio_dynamic(
//         map: groupmap,
//         selectedKey: _selectedgroup,
//         onChange: (value) {
//           setState(() {
//             _selectedgroup = value!;
//             if (value == 'option1') {
//               groupSelect = "1";
//             } else if (value == 'option2') {
//               groupSelect = "2";
//             }
//           });
//         }));
//
//     listings.add(txt_label_mandatory(
//         "Possibility of Mechanization for Harvest", Colors.black, 14.0, false));
//
//     listings.add(radio_dynamic(
//         map: licensemap,
//         selectedKey: license,
//         onChange: (value) {
//           setState(() {
//             license = value!;
//             if (value == 'option1') {
//               _selectedLicense = "1";
//             } else if (value == 'option2') {
//               _selectedLicense = "2";
//             }
//           });
//         }));
//
//     listings.add(txt_label("Block Registration", Colors.green, 18.0, true));
//
//     listings.add(
//         txt_label_mandatory("Number of Blocks", Colors.black, 14.0, false));
//
//     listings.add(
//         txtfield_digits("Number of Blocks", educationcontroller!, true, 2));
//
//
//     listings.add(
//         txt_label_mandatory("Total Hectarage", Colors.black, 14.0, false));
//     listings.add(
//         txtfieldAllowTwoDecimal("Total Hectarage", mobileController!, true, 8));
//
//     listings.add(txt_label_mandatory("Block ID", Colors.black, 14.0, false));
//
//     listings.add(txtfield_dynamic("Block ID", emailController!, true, 5));
//
//     listings.add(txt_label_mandatory(
//         "Hectarage declared by Farmer", Colors.black, 14.0, false));
//
//     listings.add(txtfieldAllowTwoDecimal(
//         "Hectarage declared by Farmer", accountnoController!, true, 8));
//
//
//     listings.add(txt_label_mandatory(
//         "Seed Variety", Colors.black, 14.0, false));
//
//     listings.add(DropDownWithModel(
//       itemlist: groupTypeitems,
//       selecteditem: slctgroupTypes,
//       hint: "Select the Seed Variety",
//       onChanged: (value) {
//         setState(() {
//           slctgroupTypes = value!;
//           val_groupType = slctgroupTypes!.value;
//           slctgroupType = slctgroupTypes!.name;
//         });
//       },
//     ));
//
//     listings.add(btn_dynamic(
//         label: "Add",
//         bgcolor: Colors.green,
//         txtcolor: Colors.white,
//         fontsize: 18.0,
//         centerRight: Alignment.centerRight,
//         margin: 20.0,
//         btnSubmit: () {
//           bool variety = false;
//           for (int i = 0; i < blockModelList.length; i++) {
//             print("1st Variety");
//             if (blockModelList[i].seedVariety == slctgroupType) {
//               variety = true;
//             }
//           }
//
//           if (educationcontroller!.text.length == 0) {
//             errordialog(
//                 context, "Information", "Number of Blocks should not be empty");
//           } else if (mobileController!.text.length == 0) {
//             errordialog(
//                 context, "Information", "Total Hectarage should not be empty");
//           } else if (emailController!.text.length == 0) {
//             errordialog(context, "Information", "Block ID should not be empty");
//           } else if (accountnoController!.text.length == 0) {
//             errordialog(
//                 context, "Information", "Hectarage declared by Farmer should not be empty");
//           } else if (slctgroupType == '' || slctgroupType.length == 0) {
//             errordialog(context, "Information", "Select the Variety");
//           } else if (variety == true) {
//             errordialog(context, "Information", "Variety already exists");
//           }
//           else {
//             setState(() {
//               var blocklistValues = blocklistmodel(
//                 educationcontroller!.text,
//                 mobileController!.text,
//                 emailController!.text,
//                 accountnoController!.text,
//                 slctgroupType,
//               );
//               //confirmationPopup();
//               blockModelList.add(blocklistValues);
//             });
//
//             slctgroupTypes = null;
//             educationcontroller!.text = "";
//             mobileController!.text = "";
//             emailController!.text = "";
//             accountnoController!.text = "";
//           }
//         }));
//
//     if (blockModelList != '' && blockModelList.length > 0) {
//       listings.add(Datatableblock());
//     }
//
//
//     listings.add(Container(
//       child: Row(
//         children: [
//           Expanded(
//             flex: 1,
//             child: Container(
//               padding: EdgeInsets.all(3),
//               child: RaisedButton(
//                 child: Text(
//                   "Cancel",
//                   style: new TextStyle(color: Colors.white, fontSize: 18),
//                 ),
//                 onPressed: () {
//                   btncancel();
//                 },
//                 color: Colors.redAccent,
//               ),
//             ),
//           ),
//           Expanded(
//             flex: 1,
//             child: Container(
//               padding: EdgeInsets.all(3),
//               child: RaisedButton(
//                 child: Text(
//                   "Submit",
//                   style: new TextStyle(color: Colors.white, fontSize: 18),
//                 ),
//                 onPressed: () {
//                   btnSubmit();
//                 },
//                 color: Colors.green,
//               ),
//             ),
//           ),
//         ],
//       ),
//     ));
//   }
//
//     return listings;
//   }
//
//   void ondelete(String photo) {
//     setState(() {
//       if (photo == "Aggregator") {
//
//         setState(() {
//           aggregatorImageFile = null;
//         });
//
//       } else if (photo == "Bank") {
//         if (bankImageFile != null) {
//           setState(() {
//             bankImageFile = null;
//           });
//         }
//       }
//       else {
//         if (licenseImageFile != null) {
//           setState(() {
//             licenseImageFile = null;
//           });
//         }
//       }
//     });
//   }
//
//
//   Widget Datatableblock() {
//     // product[];
//     List<DataColumn> columns = [];
//     List<DataRow> rows = [];
//
//     /*Columns*/
//     columns.add(DataColumn(label: Text('S.No')));
//     //columns.add(DataColumn(label: Text('Processing Centre/Warehouse')));
//     columns.add(DataColumn(label: Text("Number of Blocks")));
//     columns.add(DataColumn(label: Text("Total Hectarage")));
//     columns.add(DataColumn(label: Text("Block ID")));
//     columns.add(DataColumn(label: Text("Farmer Hectarage")));
//     columns.add(DataColumn(label: Text("Seed Variety")));
//     columns.add(DataColumn(label: Text('Delete')));
//
//     /*Rows*/
//     for (int i = 0; i < blockModelList.length; i++) {
//       int rowno = i + 1;
//       String Sno = rowno.toString();
//       List<DataCell> singlecell = [];
//       singlecell.add(DataCell(Text(Sno)));
//       singlecell.add(DataCell(Text(blockModelList[i].numberOfblocks)));
//       singlecell.add(DataCell(Text(blockModelList[i].totalHectarage)));
//       singlecell.add(DataCell(Text(blockModelList[i].blockID)));
//       singlecell.add(DataCell(Text(blockModelList[i].farmerHectarage)));
//       singlecell.add(DataCell(Text(blockModelList[i].seedVariety)));
//       singlecell.add(DataCell(InkWell(
//         onTap: () {
//           setState(() {
//             blockModelList.removeAt(i);
//           });
//         },
//         child: const Icon(
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
//   void btncancel() {
//     _onBackPressed();
//   }
//
//   void btnSubmit() {
//     // _progressHUD.state.show();
//
//     if (aggregatorImageFile != null) {
//       List<int> imageBytes = aggregatorImageFile!.readAsBytesSync();
//       aggregatorImage64 = base64Encode(imageBytes);
//     }
//
//     if (bankImageFile != null) {
//       List<int> imageBytes = bankImageFile!.readAsBytesSync();
//       bankImage64 = base64Encode(imageBytes);
//     }
//
//     if (licenseImageFile != null) {
//       List<int> imageBytes = licenseImageFile!.readAsBytesSync();
//       licenseImage64 = base64Encode(imageBytes);
//     }
//
//     //  try {
//       if (enrollmentDate.length > 0) {
//         if (slctzone.length > 0 && slctzone != '') {
//           if (slctworeda.length > 0 && slctworeda != '') {
//             if (slctkebele.length > 0 && slctkebele != '') {
//         if (slctenrollPerson.length > 0 && slctenrollPerson != '') {
//         if (enrollingPersonController!.value.text.length > 0 &&
//             enrollingPersonController!.value.text != '') {
//           if (aggregatorNameController!.value.text.length > 0 &&
//               aggregatorNameController!.value.text != '') {
//             if (fatherNameController!.value.text.length > 0 &&
//                 fatherNameController!.value.text != '') {
//               if (gfatherNameController!.value.text.length > 0 &&
//                   gfatherNameController!.value.text != '') {
//                 if (slctaggregator.length > 0 && slctaggregator != '') {
//                       if (aggFullnameController!.value.text.length > 0 &&
//                           aggFullnameController!.value.text != '') {
//                       if (slctgroupName.length > 0 && slctgroupName != '') {
//
//                                         groupvalidation();
//                       }
//                       else {
//                         errordialog(context, "Information", "Select the 3 Main crops cultivated(name + %)");
//                       }
//
//                       }
//                       else {
//                         errordialog(context, "Information", "Usual number of Crop should not be empty");
//                       }
//
//                }    else {
//                   errordialog(context, "Information", "Double cropping should not be empty");
//                 }
//               }
//               else {
//                 errordialog(context, "Information", "Hectare rented should not be empty");
//               }
//             }
//             else {
//               errordialog(context, "Information", "Hectare owned should not be empty");
//             }
//           }
//           else {
//             errordialog(context, "Information", "Total Land Holding  should not be empty");
//           }
//         }
//         else {
//           errordialog(context, "Information", "Farm Name should not be empty");
//         }
//       } else {
//         errordialog(context, "Information", "Select the Type of Farm");
//       }
//             } else {
//               errordialog(context, "Information","Select the  Kebele");
//             }
//           } else {
//             errordialog(context, "Information", "Select the Woreda");
//           }
//         } else {
//           errordialog(context, "Information", "Select the Zone");
//         }
//       }
//       else {
//         errordialog(context, "Information", "Date should not be empty");
//       }
//
//
//     // } catch (e) {
//     //   toast(e.toString());
//     //   _progressHUD.state.dismiss();`
//     // }
//   }
//
//   groupvalidation () {
//     if(groupSelect== "2") {
//       if( slctgroupType.length > 0 && slctgroupType != '' ) {
//         if( slctgroupName.length > 0 && slctgroupName != '' ) {
//           if( slctgroupPos.length > 0 && slctgroupPos != '' ) {
//             confirmation();
//           } else{
//             errordialog(context, "Information", "Select the Position in Group");
//           }
//         } else{
//           errordialog(context, "Information", "Select Name of Group");
//         }
//       } else{
//         errordialog(context, "Information", "Select the Type of Group");
//       }
//     }else {
//       confirmation();
//     }
//   }
//
//   imageDialog(String photo) {
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
//         title: "Pick Image",
//         desc: "Choose",
//         buttons: [
//           DialogButton(
//             child: Text(
//               "Gallery",
//               style: TextStyle(color: Colors.white, fontSize: 18),
//             ),
//             //onPressed:btncancel ,
//             onPressed: () {
//               setState(() {
//                 getImageFromGallery(photo);
//                 Navigator.pop(context);
//               });
//             },
//             color: Colors.deepOrange,
//           ),
//           DialogButton(
//             child: Text(
//               "Camera",
//               style: TextStyle(color: Colors.white, fontSize: 18),
//             ),
//             //onPressed:btnok,
//             onPressed: () {
//               getImageFromCamera(photo);
//               Navigator.pop(context);
//             },
//             color: Colors.green,
//           )
//         ]).show();
//   }
//
//   Future getImageFromCamera(String photo) async {
//     var image = await ImagePicker.platform
//         .pickImage(source: ImageSource.camera, imageQuality: 30);
//     setState(() {
//       if (photo == "Aggregator") {
//         aggregatorImageFile = File(image!.path);
//       }else if(photo == "Bank" ) {
//         bankImageFile = File(image!.path);
//       }
//       else {
//         licenseImageFile = File(image!.path);
//       }
//     });
//   }
//
//   Future getImageFromGallery(String photo) async {
//     var image = await ImagePicker.platform
//         .pickImage(source: ImageSource.gallery, imageQuality: 30);
//     setState(() {
//       if (photo == "Aggregator") {
//         aggregatorImageFile = File(image!.path);
//       } else if (photo == "Bank" ) {
//         bankImageFile = File(image!.path);
//       }
//       else {
//         licenseImageFile = File(image!.path);
//       }
//     });
//   }
//
//   savefarmSoufflet() async {
//
//     Random rnd = new Random();
//     int recNo = 100000 + rnd.nextInt(999999 - 100000);
//     String revNo = recNo.toString();
//
//
//     final now = new DateTime.now();
//     String txntime = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
//     String msgNo = DateFormat('yyyyMMddHHmmss').format(now);
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     String? agentid = prefs.getString("agentId");
//     String? agentToken = prefs.getString("agentToken");
//
//     print('txnHeader ' + agentid! + "" + agentToken!);
//     String insqry =
//         'INSERT INTO "main"."txnHeader" ("isPrinted", "txnTime", "mode", "operType", "resentCount", "agentId", "agentToken", "msgNo", "servPointId", "txnRefId") VALUES ('
//             '0,\'' +
//             txntime +
//             '\', '
//                 '\'02\', '
//                 '\'01\', '
//                 '\'0\',\'' +
//             agentid +
//             '\', \'' +
//             agentToken +
//             '\',\'' +
//             msgNo +
//             '\', \'' +
//             servicePointId +
//             '\',\'' +
//             revNo +
//             '\')';
//     print('txnHeader ' + insqry);
//     int succ = await db.RawInsert(insqry);
//     print(succ);
//
//     //Future<List<Map>> txnHeader = db.GetTableValues('txnHeader');
//
//     AppDatas datas = new AppDatas();
//     int custTransaction = await db.saveCustTransaction(
//         txntime, datas.txn_farmSoufflet, revNo, '', '', '');
//     print('custTransaction : ' + custTransaction.toString());
//
//     val_country = 'C00001';
//
//     String aggphotoPath = "";
//     if (aggregatorImageFile != null) {
//       aggphotoPath = aggregatorImageFile!.path;
//     }
//
//    // String farmerId = "";
//     String farmCode = msgNo + farmerId;
//
//     for (int i = 0; i < blockModelList.length; i++) {
//       String numberOfblocks = blockModelList[i].numberOfblocks;
//       String totalHectarage = blockModelList[i].totalHectarage;
//       String blockID = blockModelList[i].blockID;
//       String farmerHectarage = blockModelList[i].farmerHectarage;
//       String seedVariety = blockModelList[i].seedVariety;
//       String blockins =
//           'INSERT INTO "main"."blockList" ("farmIDT", "numberOfblocks", "totalHectarage", "blockID", "farmerHectarage","seedVariety") VALUES '
//               '(\'' +
//               farmCode +
//               '\',\' ' +
//               numberOfblocks +
//               '\',\' ' +
//               totalHectarage +
//               '\',\' ' +
//               blockID +
//               '\',\' ' +
//               farmerHectarage +
//               '\',\' ' +
//               seedVariety +
//               '\')';
//       print("treeinserting " + blockins);
//       db.RawQuery(blockins);
//     }
//
//     int farmdb = await db.SaveFarmsflt(
//         farmCode,
//         enrollmentDate,
//         val_zone,
//         val_woreda,
//         val_kebele,
//         val_enrollPerson,
//         enrollingPersonController!.text,
//         aggregatorNameController!.text,
//         fatherNameController!.text,
//         gfatherNameController!.text,
//         val_aggregator,
//         aggFullnameController!.text,
//         val_groupName,
//         groupSelect,
//         _selectedLicense,
//         "1",
//         revNo,
//         Latitude,
//         Longitude);
//
//     List<Map> Farmsflt = await db.GetTableValues('farmSoufflet');
//
//     int issync = await db.UpdateTableValue(
//         'farmSoufflet', 'isSynched', '0', 'recNo', revNo);
//
//     Alert(
//       context: context,
//       type: AlertType.info,
//       title: "Transaction Successful",
//       desc: "Farm Registration Successful",
//       buttons: [
//         DialogButton(
//           child: Text(
//             "OK",
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
//     // Navigator.pop(context);
//   }
//
//   confirmation() {
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
//         title: "Confirmation",
//         desc: "Are you sure you want to proceed?",
//         buttons: [
//           DialogButton(
//             child: Text(
//               "No",
//               style: TextStyle(color: Colors.white, fontSize: 18),
//             ),
//             //onPressed:btncancel ,
//             onPressed: () {
//               setState(() {
//                 Navigator.pop(context);
//               });
//             },
//             color: Colors.deepOrange,
//           ),
//           DialogButton(
//             child: Text(
//               "Yes",
//               style: TextStyle(color: Colors.white, fontSize: 18),
//             ),
//             //onPressed:btnok,
//             onPressed: () {
//               savefarmSoufflet();
//               Navigator.pop(context);
//             },
//             color: Colors.green,
//           )
//         ]).show();
//   }
//
//
// }
//
// class blocklistmodel {
//   String numberOfblocks;
//   String totalHectarage;
//   String blockID;
//   String farmerHectarage;
//   String seedVariety;
//   blocklistmodel(
//       this.numberOfblocks,
//       this.totalHectarage,
//       this.blockID,
//       this.farmerHectarage,
//       this.seedVariety,) ;
// }
