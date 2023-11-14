// import 'dart:async';
// import 'dart:io' show File;
// import 'dart:math';
//
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:intl/intl.dart';
// import 'package:rflutter_alert/rflutter_alert.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// import '../Database/Databasehelper.dart';
// import '../Model/UIModel.dart';
// import '../Model/dynamicfields.dart';
// import '../Utils/MandatoryDatas.dart';
// import '../main.dart';
// import 'geoplottingaddfarm.dart';
// import 'navigation.dart';
//
// class sowingScreenNew extends StatefulWidget {
//   @override
//   State<StatefulWidget> createState() {
//     return _sowingScreenNew();
//   }
// }
//
// class _sowingScreenNew extends State<sowingScreenNew> {
//   var db = DatabaseHelper();
//
//   String Latitude = '', Longitude = '';
//   bool ishavefarmercode = false;
//   bool farmerloaded = false;
//   bool farmloaded = false;
//   List<UImodel> groupsModel = [];
//   List<UImodel> groupPosModel = [];
//
//   List<UImodel> groupNameModel = [];
//   List<UImodel> groupTypeModel = [];
//   List<UImodel> certificationTypeModel = [];
//   List<UImodel> countryUIModel = [];
//   List<UImodel> zoneUIModel = [];
//   List<UImodel> woredaUIModel = [];
//   List<UImodel> kebeleUIModel = [];
//
//   List<UImodel> cropNameModel = [];
//   List<UImodel> cultivatorModel = [];
//
//   List<DropdownModel> certificationItems = [];
//   DropdownModel? slctcertificationtype;
//   String slctcertification = "", val_certification = "";
//
//   List<DropdownModel> villageitems = [];
//   DropdownModel? slctvillages;
//   String slct_village = "", villageCode = "";
//
//   List<DropdownModel> farmeritems = [];
//   DropdownModel? slctFarmers;
//   String slct_farmer = "", farmerId = "", farmerAddress = "";
//   List<UImodel2> farmerlistUIModel = [];
//
//   List<DropdownModel> farmitems = [];
//   DropdownModel? slctFarm;
//   String slct_farm = "", farmId = "", farmAddress = "";
//   List<UImodel2> farmlistUIModel = [];
//
//   List<DropdownModel> countryitems = [];
//   DropdownModel? slctcountrys;
//   String val_country = '', slctcountry = '';
//
//   List<DropdownModel> zoneitems = [];
//   DropdownModel? slctzones;
//   String val_zone = '', slctzone = '';
//
//   List<DropdownModel> woredaitems = [];
//   DropdownModel? slctworedas;
//   String val_woreda = '', slctworeda = '';
//
//   List<DropdownModel> kebeleitems = [];
//   DropdownModel? slctkebeles;
//   String val_kebele = '', slctkebele = '';
//
//   List<DropdownModel> groupNameitems = [];
//   DropdownModel? slctgroupNames;
//   String val_groupName = '', slctgroupName = '';
//
//   List<DropdownModel> groupTypeitems = [];
//   DropdownModel? slctgroupTypes;
//   String val_groupType = '', slctgroupType = '';
//
//   List<DropdownModel> groupPositems = [];
//   DropdownModel? slctgroupPoss;
//   String val_groupPos = '', slctgroupPos = '';
//
//   List<DropdownModel> cropItems = [];
//   DropdownModel? slctcrop;
//   String val_crop = '', slct_crop = '';
//
//   List<DropdownModel> cultivatorItems = [];
//   DropdownModel? slctcultivator;
//   String val_cultivator = '', slct_cultivator = '';
//
//   bool farmdataadded = false;
//
//   List<Map> agents = [];
//
//   bool zoneloaded = false;
//   bool woredaloaded = false;
//   bool kebeleloaded = false;
//
//   TextEditingController gardenNameController = new TextEditingController();
//   TextEditingController bhigaController = new TextEditingController();
//   TextEditingController hectareController = new TextEditingController();
//   TextEditingController approximateController = new TextEditingController();
//   TextEditingController ikQtyController = new TextEditingController();
//
//   String yuthalt = '';
//   int elegibleRegister = 0;
//
//   int farmerid = 0;
//   bool isregistration = false;
//
//   String seasoncode = '';
//   String servicePointId = '';
//   String agendId = '';
//
//   String groupSelect = "";
//
//   String group = "option1",
//       _selectedgroup = "1",
//       license = "option1",
//       _selectedLicense = "1";
//
//   String enrollmentDate = "",
//       enrollmentFormatedDate = "",
//       dateofsowing = '',
//       dateofsowingFormatedDate = '',
//       dateofyear = "";
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
//     groupSelect = "1";
//
//     gardenNameController = new TextEditingController();
//     bhigaController = new TextEditingController();
//     hectareController = new TextEditingController();
//     approximateController = new TextEditingController();
//     ikQtyController = new TextEditingController();
//
//     bhigaController.addListener(() {
//       decimalanddigitval(bhigaController.text, bhigaController, 4);
//       setState(() {
//         if (bhigaController.text == "") {
//           setState(() {
//             hectareController.clear();
//           });
//         }
//         double value = double.parse(bhigaController.text.toString()) * 0.2508;
//         String v = ChangeDecimalFour(value.toString());
//         print("value hect:" + value.toString());
//         hectareController.text = v.toString();
//       });
//     });
//
//     getLocation();
//   }
//
//   decimalanddigitval(controllerval, controller, length) {
//     try {
//       String controllervalue = controllerval;
//       if (controllervalue.length > length) {
//         if (controllervalue.contains(".")) {
//           List<String> values = controllervalue.split(".");
//           print("controllervalue1" + controllervalue.substring(0, 2).trim());
//           if (values[0].length > length) {
//             Alert(
//               context: context,
//               type: AlertType.info,
//               title: 'Confirmation',
//               desc: 'Number must contain 4 digits before decimal',
//               buttons: [
//                 DialogButton(
//                   child: Text(
//                     "0k",
//                     style: TextStyle(color: Colors.white, fontSize: 20),
//                   ),
//                   onPressed: () {
//                     Navigator.pop(context);
//                     controller.clear();
//                   },
//                   width: 120,
//                 ),
//               ],
//             ).show();
//             // toast('Number must be two numbers');
//           }
//         } else {
//           Alert(
//             context: context,
//             type: AlertType.info,
//             title: 'Confirmation',
//             desc: 'Digits should not be more than 4 digits before decimal',
//             buttons: [
//               DialogButton(
//                 child: Text(
//                   "ok",
//                   style: TextStyle(color: Colors.white, fontSize: 20),
//                 ),
//                 onPressed: () {
//                   Navigator.pop(context);
//                   controller.clear();
//                 },
//                 width: 120,
//               ),
//             ],
//           ).show();
//           // toast('Invalid Format');
//         }
//       }
//     } catch (e) {}
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
//       Alert(
//           context: context,
//           title: "Information",
//           desc: "GPS location not enabled",
//           buttons: [
//             DialogButton(
//               child: Text(
//                 "OK",
//                 style: TextStyle(color: Colors.white, fontSize: 18),
//               ),
//               onPressed: () {
//                 Navigator.pop(context);
//                 Navigator.pop(context);
//               },
//               color: Colors.green,
//             )
//           ]).show();
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
//
//     List cropNameList = await db.RawQuery(
//         'SELECT distinct c.fcode,c.fname,c.cropType from cropList as c inner join varietyList as v on c.fcode = v.prodId group by c.fcode order by c.fname asc');
//     print('groups ' + cropNameList.toString());
//     cropNameModel = [];
//     //groupList.clear();
//     cropItems.clear();
//     for (int i = 0; i < cropNameList.length; i++) {
//       String property_value = cropNameList[i]["fname"].toString();
//       String DISP_SEQ = cropNameList[i]["fcode"].toString();
//
//       var uimodel = new UImodel(property_value, DISP_SEQ);
//       cropNameModel.add(uimodel);
//       setState(() {
//         cropItems.add(DropdownModel(
//           property_value,
//           DISP_SEQ,
//         ));
//         //prooflist.add(property_value);
//       });
//     }
//
//     //regionlist
//   }
//
//   loadCrop() async {
//     List cultivatorList = await db.RawQuery(
//         'select vCode,vName,days from varietyList where prodId=\'' +
//             val_crop +
//             '\'');
//     print('groups ' + cultivatorList.toString());
//     cultivatorModel = [];
//     //groupList.clear();
//     cultivatorItems.clear();
//     for (int i = 0; i < cultivatorList.length; i++) {
//       String property_value = cultivatorList[i]["vName"].toString();
//       String DISP_SEQ = cultivatorList[i]["vCode"].toString();
//
//       var uimodel = new UImodel(property_value, DISP_SEQ);
//       cultivatorModel.add(uimodel);
//       setState(() {
//         cultivatorItems.add(DropdownModel(
//           property_value,
//           DISP_SEQ,
//         ));
//         //prooflist.add(property_value);
//       });
//     }
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
//   }
//
//   loadfarm() async {
//     if (farmerId.length > 0) {
//       String qry_farm =
//           'select farmIDT,farmName, totLand  from farm where farmerId = \'' +
//               farmerId +
//               '\'';
//       print('CHECK_VILLAGE_NAME 8:  ' + qry_farm);
//       List farmlist = await db.RawQuery(qry_farm);
//       print('CHECK_VILLAGE_NAME 9:  ' + farmlist.toString());
//
//       farmitems = [];
//       farmitems.clear();
//       farmlistUIModel = [];
//
//       if (farmlist.length > 0) {
//         for (int i = 0; i < farmlist.length; i++) {
//           String farmIDT = farmlist[i]["farmIDT"].toString();
//           String farmName = farmlist[i]["farmName"].toString();
//           String Land = farmlist[i]["totLand"].toString();
//           var uimodel = new UImodel2(farmName, farmIDT, Land);
//           farmlistUIModel.add(uimodel);
//           setState(() {
//             farmitems.add(DropdownModel(farmName, farmIDT));
//           });
//         }
//       }
//       Future.delayed(Duration(milliseconds: 500), () {
//         setState(() {
//           if (farmlist.length > 0) {
//             slctFarm = null;
//             farmloaded = true;
//           }
//         });
//       });
//     }
//   }
//
//   farmsearch(String villageCode) async {
//     String qry_farmlist =
//         'select fName,farmerId,certifiedFarmer,address from farmer_master where villageId = \'' +
//             villageCode +
//             '\'';
//     List farmlist = await db.RawQuery(qry_farmlist);
//     print('qry_farmerlist:  ' + farmlist.toString());
//
//     farmitems = [];
//     farmitems.clear();
//     farmlistUIModel = [];
//
//     if (farmlist.length > 0) {
//       for (int i = 0; i < farmlist.length; i++) {
//         String fName = farmlist[i]["fName"].toString();
//         String farmerId = farmlist[i]["farmerId"].toString();
//         String address = farmlist[i]["address"].toString();
//         var uimodel = new UImodel2(fName, farmerId, address);
//         farmlistUIModel.add(uimodel);
//         setState(() {
//           farmitems.add(DropdownModel(
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
//           slct_farm = '';
//           farmloaded = true;
//         }
//       });
//     });
//   }
//
//   Future<bool> _onBackPressed() async {
//     return (await Alert(
//           context: context,
//           type: AlertType.warning,
//           title: "Cancel",
//           desc: "Are you sure you want to Cancel?",
//           buttons: [
//             DialogButton(
//               child: Text(
//                 "Yes",
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
//                 "No",
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
//               "Planting",
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
//                 Expanded(
//                   child: ListView(
//                     padding: EdgeInsets.all(10.0),
//                     children: _getListings(
//                         context), // <<<<< Note this change for the return type
//                   ),
//                   flex: 8,
//                 ),
//               ])),
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
//           hint: 'Select the Village',
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
//               itemlist: farmeritems,
//               selecteditem: slctFarmers,
//               hint: 'Select for Farmer',
//               onChanged: (value) {
//                 setState(() {
//                   slctFarmers = value!;
//                   farmerId = slctFarmers!.value;
//                   slct_farmer = slctFarmers!.name;
//                   loadfarm();
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
//       listings.add(farmerloaded
//           ? txt_label('Farm', Colors.black, 14.0, false)
//           : Container());
//
//       listings.add(farmerloaded
//           ? DropDownWithModel(
//               itemlist: farmitems,
//               selecteditem: slctFarm,
//               hint: 'Select for Farm',
//               onChanged: (value) {
//                 setState(() {
//                   slctFarm = value!;
//                   farmId = slctFarm!.value;
//                   slct_farm = slctFarm!.name;
//                   print("farm id:" + farmId);
//
//                   for (int i = 0; i < farmlistUIModel.length; i++) {
//                     if (farmlistUIModel[i].value == farmerId) {
//                       farmAddress = farmlistUIModel[i].value2;
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
//                   if (slct_farm != '' && slct_farm.length > 0) {
//                     ishavefarmercode = true;
//                   } else {
//                     ishavefarmercode = false;
//                     errordialog(
//                         context, 'Information', 'Farm should not be empty');
//                   }
//                 } else {
//                   errordialog(
//                       context, 'Information', 'Farmer should not be empty');
//                 }
//               } else {
//                 errordialog(
//                     context, 'Information', 'Village should not be empty');
//               }
//             });
//           }));
//     }
//     if (ishavefarmercode) {
//       listings.add(txt_label_mandatory("Crop name", Colors.black, 14.0, false));
//
//       listings.add(DropDownWithModel(
//           itemlist: cropItems,
//           selecteditem: slctcrop,
//           hint: "Select crop name",
//           onChanged: (value) {
//             setState(() {
//               slctcrop = value!;
//
//               val_crop = slctcrop!.value;
//               slct_crop = slctcrop!.name;
//               loadCrop();
//
//               print("valcrop:" + val_crop);
//             });
//           }));
//
//       listings.add(txt_label_mandatory("Cultivar", Colors.black, 14.0, false));
//
//       listings.add(DropDownWithModel(
//           itemlist: cultivatorItems,
//           selecteditem: slctcultivator,
//           hint: "Select the cultivar",
//           onChanged: (value) {
//             setState(() {
//               slctcultivator = value!;
//
//               val_cultivator = slctcultivator!.value;
//               slct_cultivator = slctcultivator!.name;
//             });
//           }));
//
//       listings
//           .add(txt_label_mandatory("Sowing Date", Colors.black, 14.0, false));
//       /*Date*/
//       listings.add(selectDate(
//         context1: context,
//         //future: false,
//         slctdate: dateofsowing,
//         onConfirm: (date) => setState(() {
//           dateofsowing = DateFormat('dd-MM-yyyy').format(date!);
//           dateofsowingFormatedDate = DateFormat('yyyy-MM-dd').format(date);
//         }),
//       ));
//
//       listings.add(txt_label_mandatory(
//           "Cultivation Area (Bhiga)", Colors.black, 14.0, false));
//       listings.add(txtfieldAllowTwoDecimal(
//           "Cultivation Area (Bhiga)", bhigaController, true, 10));
//
//       listings.add(btn_dynamic(
//           label: "area",
//           bgcolor: Colors.green,
//           txtcolor: Colors.white,
//           fontsize: 18.0,
//           centerRight: Alignment.centerRight,
//           margin: 10.0,
//           btnSubmit: () async {
//             farmdataadded = await Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                     builder: (context) => geoploattingaddFarm(1)));
//
//             double hectareValue = 0.2508;
//             double bhigaValue = 3.9536;
//             double c;
//
//             if (farmdataadded) {
//               setState(() {
//                 bhigaController.text = addFarmdata!.Hectare;
//                 double hectvalue = double.parse(bhigaController.text);
//                 double bhigaCalculation = (bhigaValue * hectvalue);
//                 double hectareCalculation = bhigaCalculation * hectareValue;
//                 bhigaController.text =
//                     ChangeDecimalFour(bhigaCalculation.toString());
//                 hectareController.text =
//                     ChangeDecimalFour(hectareCalculation.toString());
//               });
//             } else {
//               setState(() {
//                 bhigaController.text = hectareAre;
//                 double hectvalue = double.parse(bhigaController.text);
//                 double bhigaCalculation = (bhigaValue * hectvalue);
//                 double hectareCalculation = bhigaCalculation * hectareValue;
//                 bhigaController.text =
//                     ChangeDecimalFour(bhigaCalculation.toString());
//                 hectareController.text =
//                     ChangeDecimalFour(hectareCalculation.toString());
//               });
//             }
//           }));
//
//       // listings.add(btn_dynamic(
//       //     label: "area",
//       //     bgcolor: Colors.green,
//       //     txtcolor: Colors.white,
//       //     fontsize: 18.0,
//       //     centerRight: Alignment.centerRight,
//       //     margin: 10.0,
//       //     btnSubmit: () async {
//       //       setState(() async {
//       //         bool farmdataadded = await Navigator.push(
//       //             context,
//       //             MaterialPageRoute(
//       //                 builder: (context) => geoploattingaddFarm(1)));
//       //
//       //
//       //         if (farmdataadded) {
//       //
//       //           bhigaController.clear();
//       //           hectareController.clear();
//       //           // setState(() {
//       //           //   addFarmdata?.Hectare = "0.2";
//       //           // });
//       //           String? str = addFarmdata?.Hectare;
//       //
//       //           if(str == null){
//       //             setState(() {
//       //               str = "0";
//       //             });
//       //           }
//       //
//       //           double hectareValue = 0.404686;
//       //           double bhigaValue = 1.613;
//       //           double c;
//       //
//       //           if(str!=null){
//       //             print("length");
//       //             double hectvalue = double.parse(str!);
//       //             double bhigaCalculation = (bhigaValue*hectvalue);
//       //             double hectareCalculation = (hectareValue*hectvalue);
//       //             bhigaController.text = bhigaCalculation.toString();
//       //             hectareController.text = hectareCalculation.toString();
//       //           }else{
//       //             print("length1");
//       //             double h = 1.00;
//       //             c = (h*hectareValue);
//       //             print("value printed"+c.toString());
//       //           }
//       //         } else {
//       //           bhigaController.text = "";
//       //         }
//       //       });
//       //     }));
//
//       listings.add(txt_label_mandatory(
//           "Cultivation Area (Hectare)", Colors.black, 14.0, false));
//       listings.add(txtfield_digits(
//           "Cultivation Area (Hectare)", hectareController, false));
//
//       listings.add(SizedBox(
//         height: 50,
//       ));
//
//       listings.add(Container(
//         child: Row(
//           children: [
//             Expanded(
//               flex: 1,
//               child: Container(
//                 padding: EdgeInsets.all(3),
//                 child: RaisedButton(
//                   child: Text(
//                     "Cancel",
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
//                     "Submit",
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
//
//     return listings;
//   }
//
//   void btncancel() {
//     _onBackPressed();
//   }
//
//   void btnSubmit() {
//     // _progressHUD.state.show();
//
//     if (slct_crop.length > 0 && slct_crop != '') {
//       if (slct_cultivator.length > 0 && slct_cultivator != '') {
//         if (dateofsowing.length > 0 && dateofsowing != "") {
//           if (bhigaController.value.text.length > 0 &&
//               bhigaController.value.text != '') {
//             if (hectareController.value.text.length > 0 &&
//                 hectareController.value.text != '') {
//               confirmation();
//             } else {
//               errordialog(context, "information",
//                   "cultivation area (hectare) should not be empty");
//             }
//           } else {
//             errordialog(context, "information",
//                 "cultivation area (bhiga) should not be empty");
//           }
//         } else {
//           errordialog(
//               context, "information", "Sowing Date should not be empty");
//         }
//       } else {
//         errordialog(context, "information", "cultivar should not be empty");
//       }
//     } else {
//       errordialog(context, "information", "crop name should not be empty");
//     }
//   }
//
//   savesowing() async {
//     Random rnd = new Random();
//     int recNo = 100000 + rnd.nextInt(999999 - 100000);
//     String revNo = recNo.toString();
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
//                 '0,\'' +
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
//         txntime, datas.txnSowingscreen, revNo, '', '', '');
//     print('custTransaction : ' + custTransaction.toString());
//
//     String isSynched = "0";
//     String recId = revNo;
//     String farmerlatitude = Lat;
//     String farmerlongitude = Lng;
//     String farmertimeStamp = txntime;
//     String farmerphoto = "";
//     String farmlatitude = "";
//     String farmlongitude = "";
//     String farmtimeStamp = msgNo;
//     String farmphoto = "";
//     String farmArea = bhigaController.value.text;
//     String prodLand = hectareController.value.text;
//     String notProdLand = dateofsowing;
//     String farmIdd = farmId;
//     String voice = "";
//     String currentSeason = "";
//     String cropLifeInsurance = val_crop;
//     String crophealthInsurance = val_cultivator;
//     String cropInsuranceCrop = "";
//     String cropBank = "";
//     String cropMoneyVendor = "";
//     String pltStatus = "";
//     String geoStatus = "";
//     print("farmer id:" + farmIdd);
//
//     int sowingdata = await db.saveExistsFarmer(
//         isSynched,
//         recId,
//         farmerId,
//         farmerlatitude,
//         farmerlongitude,
//         farmertimeStamp,
//         farmerphoto,
//         farmlatitude,
//         farmlongitude,
//         farmtimeStamp,
//         farmphoto,
//         farmArea,
//         prodLand,
//         notProdLand,
//         farmIdd,
//         voice,
//         currentSeason,
//         cropLifeInsurance,
//         crophealthInsurance,
//         cropInsuranceCrop,
//         cropBank,
//         cropMoneyVendor,
//         pltStatus,
//         geoStatus,
//         villageCode);
//
//     if (Geoploattingaddfarmlist.length > 0) {
//       for (int i = 0; i < Geoploattingaddfarmlist.length; i++) {
//         print("geoplatinglistFarm" + Geoploattingaddfarmlist.toString());
//         int savefarmgpslocation = await db.saveFarmGPSLocationExists(
//           Geoploattingaddfarmlist[i].Latitude,
//           Geoploattingaddfarmlist[i].Longitude,
//           farmerId,
//           farmIdd,
//           Geoploattingaddfarmlist[i].orderofGps.toString(),
//           revNo.toString(),
//         );
//         print("savefarmgpslocation" + revNo.toString());
//       }
//     }
//
//     List<Map> Farmsflt = await db.GetTableValues('exists_farmer');
//
//     int issync = await db.UpdateTableValue(
//         'exists_farmer', 'isSynched', '0', 'recId', revNo);
//
//     Alert(
//       context: context,
//       type: AlertType.info,
//       title: "Transaction Successful",
//       desc: "Planting Successful",
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
//               savesowing();
//               Navigator.pop(context);
//             },
//             color: Colors.green,
//           )
//         ]).show();
//   }
// }
