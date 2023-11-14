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
// class agregatorReg extends StatefulWidget {
//   @override
//   State<StatefulWidget> createState() {
//     return _agregatorReg();
//   }
// }
//
// class _agregatorReg extends State<agregatorReg> {
//   var db = DatabaseHelper();
//
//   String Latitude = '', Longitude = '';
//
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
//   List<UImodel> bankUIModel = [];
//
//   List<DropdownModel> aggregatorTypeitems = [];
//   DropdownModel? slctaggregatorTypes;
//   String slctaggregator = "" , val_aggregator = "";
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
//   List<DropdownModel> bankitems = [];
//   DropdownModel? slctgroupPoss;
//   String val_groupPos = '' , slctgroupPos = '';
//
//   DropdownModel? slctbank;
//   String val_bank='',slctbankname='';
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
//                          aggregatorNameController,
//                          fatherNameController,
//                          gfatherNameController,
//                          aggFullnameController,
//                          educationcontroller ,
//                          emailController,
//                          mobileController,
//                          accountnoController,
//                          agretrotherspecfyController,
//                          otherspecfyController,
//                          bankController,
//                          branchController,
//                          ageController,
//                          phoneController,
//                          amtLoanRecController;
//
//
//   String yuthalt = '';
//   int elegibleRegister = 0;
//
//   int aggregatorid = 0;
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
//   final Map<String, String> genderMap = {
//     'option1': "MALE",
//     'option2': "FEMALE",
//   };
//
//   final Map<String, String> groupmap = {
//     'option1': "YES",
//     'option2': "NO",
//   };
//
//   final Map<String, String> licensemap = {
//     'option1': "YES",
//     'option2': "NO",
//   };
//
//   final Map<String, String> loanmap = {
//     'option1': "YES",
//     'option2': "NO",
//   };
//
//   final Map<String, String> taxInvoice = {
//     'option1': "YES",
//     'option2': "NO",
//   };
//
//   String _selectedGender = "option1",
//          genderSelect = "",
//          groupSelect = "1";
//
//   String  group = "option1",  _selectedgroup = "1",
//           taxInv = "option1",  _selectedtaxInv = "1",
//           license = "option1" , _selectedLicense = "1",
//           loanSlct = "option1" , _selectedLoan = "1";
//
//   String enrollmentDate = "",
//          enrollmentFormatedDate = "",
//          dateofbirth = '',
//          dateofbirthFormatedDate = '',
//          dateofyear = "",loanRecp="Select the Year",loanRecpFormatedDate='';
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
//     genderSelect = "male";
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
//     agretrotherspecfyController = new TextEditingController();
//     otherspecfyController = new TextEditingController();
//     bankController = new TextEditingController();
//     branchController = new TextEditingController();
//     mobileController = new TextEditingController();
//     phoneController = new TextEditingController();
//     emailController = new TextEditingController();
//     amtLoanRecController = new TextEditingController();
//     getLocation();
//   }
//
//   void aggregatorIdGeneration() {
//     print("farmerIDgenearation");
//     String temp = agents[0]['curIdSeqAgg'];
//     int curId = int.parse(agents[0]['curIdSeqAgg']);
//     print("curId_curId" + curId.toString());
//     resId = int.parse(agents[0]['resIdSeqAgg']);
//     print("resId_resId" + resId.toString());
//     curIdLim = int.parse(agents[0]['curIdLimitAgg']);
//     print("curIdLim_curIdLim" + curIdLim.toString()); //45
//     int newIdGen = 0;
//     int incGenId = curId + 1;
//     print("incGenId_incGenId" + incGenId.toString());
//     curIdLimited = 0;
//     int MAX_Limit = 5;
//     if (incGenId <= curIdLim) {
//       newIdGen = incGenId;
//       print('farmer_id_lessthan ' + newIdGen.toString());
//       aggregatorid = newIdGen;
//     } else {
//       if (resId != 0) {
//         newIdGen = resId + 1;
//         curId = newIdGen;
//         curIdLimited = resId + MAX_Limit;
//         print('resId ' + resId.toString());
//         resId = 0;
//         print('farmer_id_notequal ' + newIdGen.toString());
//         aggregatorid = newIdGen;
//       } else {
//         print('farmer_id_else ' + newIdGen.toString());
//         aggregatorid = newIdGen;
//       }
//     }
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
//     String resIdd = agents[0]['resIdSeqAgg'];
//     print("resIdgetcliendata" + resIdd);
//     print("agendId_agendId" + agendId);
//     enrollingPersonController!.text=agents[0]['agentName'].toString();
//
//     aggregatorIdGeneration();
//     print("Aggregator Id" + aggregatorid.toString());
//   }
//
//   Future<void> initvalues() async {
//
//     /*IDPROOF */
//     List idprooflist = await db.RawQuery(
//         'select * from animalCatalog where catalog_code =\'2\'');
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
//         'select * from animalCatalog where catalog_code =\'4\'');
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
//     List bankquery = await db.RawQuery(
//         'select * from animalCatalog where catalog_code =\'7\'');
//     print('bank ' + bankquery.toString());
//     bankUIModel = [];
//     //groupList.clear();
//     bankitems.clear();
//     for (int i = 0; i < bankquery.length; i++) {
//       String property_value = bankquery[i]["property_value"].toString();
//       String DISP_SEQ = bankquery[i]["DISP_SEQ"].toString();
//
//       var uimodel = new UImodel(property_value, DISP_SEQ);
//       bankUIModel.add(uimodel);
//       setState(() {
//         bankitems.add(DropdownModel(
//           property_value,
//           DISP_SEQ,
//         ));
//         //prooflist.add(property_value);
//       });
//     }
//
//
//     List enrollPerson = await db.RawQuery(
//         'select * from animalCatalog where catalog_code =\'1\'');
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
//         'select * from animalCatalog where catalog_code =\'3\'');
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
//         'select * from animalCatalog where catalog_code =\'5\'');
//     print('villagelistFarmerEnrollment' + groupNamelist.toString());
//     groupNameModel = [];
//     groupNameitems = [];
//     groupNameitems.clear();
//     for (int i = 0; i < groupNamelist.length; i++) {
//       String property_value = groupNamelist[i]["property_value"].toString();
//       String DISP_SEQ = groupNamelist[i]["DISP_SEQ"].toString();
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
//     List countrylist = await db.RawQuery('select * from stateList ');
//     print(' ' + countrylist.toString());
//     countryUIModel = [];
//     countryitems.clear();
//     for (int i = 0; i < countrylist.length; i++) {
//       String countryCode = countrylist[i]["stateCode"].toString();
//       String countryName = countrylist[i]["stateName"].toString();
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
//   }
//
//
//
//   Future<void> changezone(String regioncode) async {
//     List zonelist = await db.RawQuery(
//         'select * from districtList where stateCode =\'' + regioncode + '\'');
//     print('circleList ' + zonelist.toString());
//     zoneUIModel = [];
//     zoneitems = [];
//     zoneitems.clear();
//     for (int i = 0; i < zonelist.length; i++) {
//       String regionCode = zonelist[i]["stateCode"].toString();
//       String zoneCode = zonelist[i]["districtCode"].toString();
//       String zoneName = zonelist[i]["districtName"].toString();
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
//         'select * from cityList where districtCode =\'' + circleCode + '\'');
//     print('' + woredalist.toString());
//     woredaUIModel = [];
//     woredaitems = [];
//     woredaitems.clear();
//     for (int i = 0; i < woredalist.length; i++) {
//       String circleName = woredalist[i]["districtCode"].toString();
//       String communeName = woredalist[i]["cityName"].toString();
//       String communeCode = woredalist[i]["cityCode"].toString();
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
//         'select * from villageList where gpCode =\'' + communeCode + '\'');
//     print('' + kebeleList.toString());
//     kebeleUIModel = [];
//     kebeleitems = [];
//     kebeleitems.clear();
//     for (int i = 0; i < kebeleList.length; i++) {
//       String chieftownName = kebeleList[i]["villName"].toString();
//       String chieftownCode = kebeleList[i]["villCode"].toString();
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
//            "No",
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
//               "Aggregator Registration",
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
//            listings.add(txt_label_mandatory("Enrollment Place", Colors.black, 14.0, false));
//
//            listings.add(DropDownWithModel(
//             itemlist: enrollPersonitems,
//             selecteditem: slctenrollPersons,
//             hint: "Select the Enrollment Place",
//             onChanged: (value) {
//               setState(() {
//                 slctenrollPersons = value!;
//
//                 val_enrollPerson = slctenrollPersons!.value;
//                 slctenrollPerson = slctenrollPersons!.name;
//
//               });
//             }));
//
//         listings.add(txt_label_mandatory("Enrollment Date", Colors.black, 14.0, false));
//         listings.add(selectDate(
//             context1: context,
//             slctdate: enrollmentDate,
//             onConfirm: (date) => setState(
//                   () {
//                     enrollmentDate = DateFormat('dd/MM/yyyy').format(date!);
//                     enrollmentFormatedDate =
//                         DateFormat('yyyyMMdd').format(date!);
//                   },
//                 )));
//
//         /* listings
//             .add(txt_label_mandatory("Aggregator Code", Colors.black, 14.0, false));
//
//          listings.add(txtfield_dynamic("Farmer Code", farmerCodeController!, true)); */
//            listings.add(txt_label_mandatory("Enrolling Person", Colors.black, 14.0, false));
//            listings.add(txtfield_dynamic("Enrolling Person", enrollingPersonController!, false, 25));
//
//
//         listings.add(txt_label("Personal Information", Colors.green, 18.0, true));
//
//         //First Name
//         listings.add(txt_label_mandatory("Aggregator Name", Colors.black, 14.0, false));
//         listings.add(txtfield_dynamic("Aggregator Name", aggregatorNameController!, true,25));
//
//         //Last Name
//         listings.add(txt_label_mandatory("Father Name", Colors.black, 14.0, false));
//         listings.add(txtfield_dynamic("Father Name", fatherNameController!, true,25));
//
//         //Farmer Code
//         listings.add(txt_label_mandatory("Grandfather Name", Colors.black, 14.0, false));
//         listings.add(txtfield_dynamic("Grandfather Name", gfatherNameController!, true,25));
//
//            listings.add(txt_label_mandatory("Gender", Colors.black, 14.0, false));
//
//            listings.add(radio_dynamic(
//                map: genderMap,
//                selectedKey: _selectedGender,
//                onChange: (value) {
//                  setState(() {
//                    _selectedGender = value!;
//                    if (value == 'option1') {
//                      genderSelect = "male";
//                    } else if (value == 'option2') {
//                      genderSelect = "female";
//                    }
//
//                    print("genderSelect_genderSelect" + genderSelect);
//                  });
//                }));
//
//         listings.add(txt_label_mandatory("Date of Birth", Colors.black, 14.0, false));
//         listings.add(selectDate(
//             context1: context,
//             slctdate: dateofbirth,
//             onConfirm: (date) => setState(
//                   () {
//                 dateofbirth = DateFormat('dd/MM/yyyy').format(date!);
//                 dateofbirthFormatedDate =
//                     DateFormat('yyyyMMdd').format(date!);
//
//                 dateofyear = DateFormat('yyyy').format(date!);
//                 //calAgeyr();
//               },
//             )));
//
//         /* Gender*/
//         listings.add(txt_label_mandatory("Type of Aggregator", Colors.black, 14.0, false));
//         listings.add(DropDownWithModel(
//             itemlist: aggregatorTypeitems,
//             selecteditem: slctaggregatorTypes,
//             hint: "Type of Aggregator",
//             onChanged: (value) {
//               setState(() {
//                 slctaggregatorTypes = value!;
//                 //toast(slctProofs!.value);
//                 val_aggregator = slctaggregatorTypes!.value;
//                 slctaggregator = slctaggregatorTypes!.name;
//                 //print('selectedvalue ' + slctProofs!.value);
//               });
//             }));
//
//         if(val_aggregator=="99"){
//           listings.add(txt_label_mandatory("Other Specify", Colors.black, 14.0, false));
//           listings.add(txtfield_dynamic("Other Specify", agretrotherspecfyController!, true,13));
//         }
//
//           listings.add(txt_label_mandatory("Main Aggregator Full name", Colors.black, 14.0, false));
//           listings.add(txtfield_dynamic("Main Aggregator Full name", aggFullnameController!, true));
//
//
//           // farmer photo
//         listings.add(txt_label_mandatory("Aggregator Photo", Colors.black, 14.0, false));
//         listings.add(img_picker(
//             label: "Aggregator Photo",
//             onPressed: () {
//               imageDialog("Aggregator");
//             },
//             filename: aggregatorImageFile,
//             ondelete: () {
//               ondelete("Aggregator");
//             }));
//
//          listings.add(txt_label("Education", Colors.black, 14.0, false));
//
//          listings.add(txtfield_dynamic("Education", educationcontroller!, true,25));
//
//
//            listings.add(txt_label_mandatory("Mobile Number", Colors.black, 14.0, false));
//            listings.add(txtfield_withcharacterdigits("Mobile Number", mobileController!, true, 13));
//
//         listings.add(txt_label("Email(if any)", Colors.black, 14.0, false));
//
//         listings.add(txtfield_dynamic("Email", emailController!, true,25));
//
//         listings.add(txt_label_mandatory("Country", Colors.black, 14.0, false));
//
//         listings.add(DropDownWithModel(
//             itemlist: countryitems,
//             selecteditem: slctcountrys,
//             hint: "Select the Country",
//             onChanged: (value) {
//               setState(() {
//                 slctcountrys = value!;
//                 zoneloaded = false;
//                 kebeleloaded = false;
//
//                 woredaloaded = false;
//                 slctkebeles = null;
//                 slctzones = null;
//                 slctworedas = null;
//
//                 val_country = slctcountrys!.value;
//                 slctcountry = slctcountrys!.name;
//                 changezone(val_country);
//
//               });
//               // print("Region Code" + val_region.toString());
//               // print("Region Name" + slctRegion.toString());
//             },
//             onClear: () {
//               setState(() {
//
//               });
//             }));
//
//         // circle
//         listings.add(zoneloaded
//             ? txt_label_mandatory("Zone", Colors.black, 14.0, false)
//             : Container());
//
//
//         listings.add(zoneloaded
//             ? DropDownWithModel(
//             itemlist: zoneitems,
//             selecteditem: slctzones,
//             hint: "Select the Zone",
//             onChanged: (value) {
//               setState(() {
//                 slctzones = value!;
//                 woredaloaded = false;
//                 kebeleloaded = false;
//
//                 slctkebeles = null;
//                 slctworedas = null;
//
//                 val_zone = slctzones!.value;
//                 slctzone = slctzones!.name;
//                 changeworeda(val_zone);
//               });
//               // print("Circle Code" + val_circle.toString());
//               // print("Circle Name" + slctCircle.toString());
//             },
//             onClear: () {
//               setState(() {
//
//               });
//             })
//             : Container());
//
//         //commune
//         listings.add(woredaloaded
//             ? txt_label_mandatory("Woreda", Colors.black, 14.0, false)
//             : Container());
//
//         listings.add(woredaloaded
//             ? DropDownWithModel(
//             itemlist: woredaitems,
//             selecteditem: slctworedas,
//             hint: "Select the Woreda",
//             onChanged: (value) {
//               setState(() {
//                 slctworedas = value!;
//                 kebeleloaded = false;
//
//                 slctkebeles = null;
//
//                 //toast(slctFarmers!.value);
//                 val_woreda = slctworedas!.value;
//                 slctworeda = slctworedas!.name;
//                 changekebele(val_woreda);
//               });
//               // print("Commune Code" + val_commune.toString());
//               // print("Commune Name" + slctCommune.toString());
//             },
//             onClear: () {
//
//             })
//             : Container());
//
//
//         //chieftown
//         listings.add(kebeleloaded
//             ? txt_label_mandatory("Kebele", Colors.black, 14.0, false)
//             : Container());
//
//         listings.add(kebeleloaded
//             ? DropDownWithModel(
//             itemlist: kebeleitems,
//             selecteditem: slctkebeles,
//             hint: "Select the Kebele",
//             onChanged: (value) {
//               setState(() {
//                 slctkebeles = value!;
//                 val_kebele = slctkebeles!.value;
//                 slctkebele = slctkebeles!.name;
//
//               });
//               // print("chiefTown Code" + val_chieftown.toString());
//               // print("chiefTown Name" + slctChieftown.toString());
//             },
//             onClear: () {
//               setState(() {
//
//               });
//             })
//             : Container());
//            listings.add(txt_label_mandatory("Appartenance to a group /Y/N", Colors.black, 14.0, false));
//
//            listings.add(radio_dynamic(
//                map: groupmap,
//                selectedKey: _selectedgroup,
//                onChange: (value) {
//                  setState(() {
//                    _selectedgroup = value!;
//                    if (value == 'option1') {
//                      groupSelect = "1";
//                    } else if (value == 'option2') {
//                      groupSelect = "2";
//                    }
//                  });
//                }));
//
//            if(groupSelect == "1") {
//              listings.add(txt_label_mandatory(
//                  "Type of Group", Colors.black, 14.0, false));
//
//
//              listings.add(DropDownWithModel(
//                itemlist: groupTypeitems,
//                selecteditem: slctgroupTypes,
//                hint: "Select the Group",
//                onChanged: (value) {
//                  setState(() {
//                    slctgroupTypes = value!;
//                    val_groupType = slctgroupTypes!.value;
//                    slctgroupType = slctgroupTypes!.name;
//                  });
//                },
//              ));
//              if(val_groupType=="99"){
//                listings.add(txt_label_mandatory("Other Specify", Colors.black, 14.0, false));
//
//                listings.add(txtfield_dynamic("Other Specify", otherspecfyController!, true,13));
//              }
//
//              listings.add(txt_label_mandatory(
//                  "Name of Group", Colors.black, 14.0, false));
//
//
//              listings.add(DropDownWithModel(
//                  itemlist: groupNameitems,
//                  selecteditem: slctgroupNames,
//                  hint: "Select the Group Name",
//                  onChanged: (value) {
//                    setState(() {
//                      slctgroupNames = value!;
//                      val_groupName = slctgroupNames!.value;
//                      slctgroupName = slctgroupNames!.name;
//                    });
//
//                  },));
//
//
//              listings.add(txt_label_mandatory("Position in the Group", Colors.black, 14.0, false));
//
//              listings.add(DropDownWithModel(
//                  itemlist: groupPositems,
//                  selecteditem: slctgroupPoss,
//                  hint: "Select the Position",
//                  onChanged: (value) {
//                    setState(() {
//                      slctgroupPoss = value!;
//
//                      val_groupPos = slctgroupPoss!.value;
//                      slctgroupPos = slctgroupPoss!.name;
//
//                    });
//                  }));
//            }
//
//            listings.add(txt_label("Bank Information", Colors.green, 18.0, true));
//
//         listings.add(txt_label_mandatory("Account No", Colors.black, 14.0, false));
//
//         listings.add(txtfield_dynamic("Account No", accountnoController!, true,13));
//
//         listings.add(txt_label_mandatory("Bank Name", Colors.black, 14.0, false));
//
//         //listings.add(txtfield_dynamic("Bank Name", bankController!, true,10));
//
//         listings.add(DropDownWithModel(
//             itemlist: bankitems,
//             selecteditem: slctbank,
//             hint: "Select the Bank Name",
//             onChanged: (value) {
//               setState(() {
//                 slctbank = value!;
//
//                 val_bank = slctbank!.value;
//                 slctbankname = slctbank!.name;
//
//               });
//             }));
//
//         listings.add(txt_label_mandatory("Branch Name", Colors.black, 14.0, false));
//
//         listings.add(txtfield_dynamic("Branch Name", branchController!, true,25));
//
//         listings.add(txt_label("Photo of Bank Account", Colors.black, 14.0, false));
//
//         listings.add(img_picker(
//                label: "Photo of Bank Account",
//                onPressed: () {
//                  imageDialog("Bank");
//                },
//                filename: bankImageFile,
//                ondelete: () {
//                  ondelete("Bank");
//                }));
//
//            listings.add(txt_label("Licenced", Colors.black, 14.0, false));
//         listings.add(radio_dynamic(
//                map: licensemap,
//                selectedKey: license,
//                onChange: (value) {
//                  license = value!;
//                  setState(() {
//                    if (value == "option1") {
//                      _selectedLicense = "1";
//                    } else {
//                      _selectedLicense = "2";
//                    }
//                  });
//                }));
//
//         if(_selectedLicense == "1") {
//
//           listings.add(
//               txt_label("Photo of License", Colors.black, 14.0, false));
//
//           listings.add(img_picker(
//               label: "Photo of License",
//               onPressed: () {
//                 imageDialog("License");
//               },
//               filename: licenseImageFile,
//               ondelete: () {
//                 ondelete("License");
//               }));
//         }
//
//            listings.add(txt_label("Turnover Tax Invoice Capacity", Colors.black, 14.0, false));
//            listings.add(radio_dynamic(
//                map: taxInvoice,
//                selectedKey: taxInv,
//                onChange: (value) {
//                  taxInv = value!;
//                  setState(() {
//                    if (value == "option1") {
//                      _selectedtaxInv = "1";
//                    } else {
//                      _selectedtaxInv = "2";
//                    }
//                  });
//                }));
//
//
//     listings.add(txt_label("Loan Information", Colors.green, 18.0, true));
//     listings.add(txt_label_mandatory("Loan", Colors.black, 14.0, false));
//     listings.add(radio_dynamic(
//         map: loanmap,
//         selectedKey: loanSlct,
//         onChange: (value) {
//           loanSlct = value!;
//           setState(() {
//             if (value == "option1") {
//               _selectedLoan = "1";
//             } else {
//               _selectedLoan = "2";
//             }
//           });
//         }));
//
//
//     if(_selectedLoan == "1") {
//
//       listings.add(txt_label_mandatory("Amount received(ETB)", Colors.black, 14.0, false));
//
//       listings.add(txtfield_digits("Amount received(ETB)", amtLoanRecController!, true,13));
//
//
//       listings.add(txt_label_mandatory("Year of reception", Colors.black, 14.0, false));
//       /*listings.add(selectYear(
//           context1: context,
//           slctyear: loanRecp,
//           onConfirm: (date) => setState(
//                 () {
//                   loanRecp = DateFormat('yyyy').format(date!);
//                   loanRecpFormatedDate =
//                   DateFormat('yyyy').format(date!);
//             },
//           )));*/
//
//       listings.add(YearSelector(context1: context,selectedDate: DateTime.now(),slctyear: loanRecp ,onConfirm: (yearDate){
//         setState(() {
//           var formatter = new DateFormat('yyyy');
//           loanRecp = formatter.format(yearDate!);
//         });
//         Navigator.pop(context);
//
//
//
//       }));
//     }
//
//
//         listings.add(Container(
//           child: Row(
//             children: [
//               Expanded(
//                 flex: 1,
//                 child: Container(
//                   padding: EdgeInsets.all(3),
//                   child: RaisedButton(
//                     child: Text(
//                       "Cancel",
//                       style: new TextStyle(color: Colors.white, fontSize: 18),
//                     ),
//                     onPressed: () {
//                       btncancel();
//                     },
//                     color: Colors.redAccent,
//                   ),
//                 ),
//               ),
//               Expanded(
//                 flex: 1,
//                 child: Container(
//                   padding: EdgeInsets.all(3),
//                   child: RaisedButton(
//                     child: Text(
//                       "Submit",
//                       style: new TextStyle(color: Colors.white, fontSize: 18),
//                     ),
//                     onPressed: () {
//                       btnSubmit();
//                     },
//                     color: Colors.green,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ));
//
//      // }
//     //}
//     return listings;
//   }
//
//   void ondelete(String photo) {
//     setState(() {
//       if (photo == "Aggregator") {
//
//           setState(() {
//             aggregatorImageFile = null;
//           });
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
//     print("val_aggregator:"+val_aggregator);
//     print("val_aggregator:"+agretrotherspecfyController!.value.text.length.toString());
//     print("val_aggregator:"+agretrotherspecfyController!.value.text.toString());
//     //  try {
//     if (slctenrollPerson.length > 0 && slctenrollPerson != '') {
//       if (enrollmentDate.length > 0) {
//         if (enrollingPersonController!.value.text.length > 0 &&
//             enrollingPersonController!.value.text != '') {
//           if (aggregatorNameController!.value.text.length > 0 &&
//               aggregatorNameController!.value.text != '') {
//             if (fatherNameController!.value.text.length > 0 &&
//                 fatherNameController!.value.text != '') {
//               if (gfatherNameController!.value.text.length > 0 &&
//                   gfatherNameController!.value.text != '') {
//                 if (dateofbirth.length > 0) {
//           if (slctaggregator.length > 0 && slctaggregator != '') {
//             if (val_aggregator == "99" &&
//                 agretrotherspecfyController!.value.text.length > 0 &&
//                 agretrotherspecfyController!.value.text != '') {
//               errordialog(
//                   context, "Information", "Other Specify should not be empty");
//             }else {
//
//
//             if (aggFullnameController!.value.text.length > 0 &&
//                 aggFullnameController!.value.text != '') {
//               if (aggregatorImage64 != '') {
//                 if (mobileController!.value.text.length > 0 &&
//                     mobileController!.value.text != '') {
//                   if (slctcountry.length > 0 && slctcountry != '') {
//                     if (slctzone.length > 0 && slctzone != '') {
//                       if (slctworeda.length > 0 && slctworeda != '') {
//                         if (slctkebele.length > 0 && slctkebele != '') {
//                           groupvalidation();
//                         } else {
//                           errordialog(
//                               context, "Information", "Select the  Kebele");
//                         }
//                       } else {
//                         errordialog(
//                             context, "Information", "Select the Woreda");
//                       }
//                     } else {
//                       errordialog(context, "Information", "Select the Zone");
//                     }
//                   } else {
//                     errordialog(context, "Information", "Select the Country");
//                   }
//                 }
//                 else {
//                   errordialog(context, "Information",
//                       "Mobile Number should not be empty");
//                 }
//               }
//               else {
//                 errordialog(context, "Information",
//                     "Aggregator Photo should not be empty");
//               }
//             }
//             else {
//               errordialog(context, "Information",
//                   "Main Aggregator Full Name should not be empty");
//             }
//           }
//           }
//           else {
//             errordialog(context, "Information", "Select the Aggregator Type");
//           }
//                 }
//                 else {
//                   errordialog(context, "Information", "Date of Birth should not be empty");
//                 }
//               }
//               else {
//                 errordialog(context, "Information", "Grandfather Name should not be empty");
//               }
//             }
//             else {
//               errordialog(context, "Information", "Father Name should not be empty");
//             }
//           }
//           else {
//             errordialog(context, "Information", "Aggregator Name should not be empty");
//           }
//         }
//         else {
//           errordialog(context, "Information", "Enrolling Person should not be empty");
//         }
//       }
//       else {
//         errordialog(context, "Information", "Enrollment Date should not be empty");
//       }
//           } else {
//       errordialog(context, "Information", "Select the Enrollment Place");
//     }
//
//     // } catch (e) {
//     //   toast(e.toString());
//     //   _progressHUD.state.dismiss();`
//     // }
//   }
//
//   groupvalidation () {
//     if(groupSelect== "1") {
//       if( slctgroupType.length > 0 && slctgroupType != '' ) {
//         if(val_groupType=="99" && otherspecfyController!.value.text.length > 0 && otherspecfyController!.text != '' ) {
//           errordialog(context, "Information", "other specify should not be empty");
//         }else{
//
//         if( slctgroupName.length > 0 && slctgroupName != '' ) {
//           if( slctgroupPos.length > 0 && slctgroupPos != '' ) {
//              //confirmation();
//             remainingValidation();
//           } else{
//             errordialog(context, "Information", "Select the Position in Group");
//           }
//         } else{
//           errordialog(context, "Information", "Select Name of Group");
//         }
//         }
//       } else{
//         errordialog(context, "Information", "Select the Type of Group");
//       }
//     }else {
//       //confirmation();
//       remainingValidation();
//     }
//   }
//
//
//   remainingValidation(){
//     if (accountnoController!.value.text.length > 0 &&
//         accountnoController!.value.text != '') {
//       /*if (bankController!.value.text.length > 0 && bankController!.value.text != '') {*/
//       if( slctbankname.length > 0 && slctbankname != '' ) {
//         if (branchController!.value.text.length > 0 &&
//             branchController!.value.text != '') {
//           if (amtLoanRecController!.value.text.length > 0 &&
//               amtLoanRecController!.value.text != '' && _selectedLoan=="1") {
//
//             if ((loanRecp.contains("Select the Year"))   && _selectedLoan=="1") {
//                 errordialog(context,"Information","Year should not be empty");
//             }else {
//               confirmation();
//             }
//           }else if(_selectedLoan=="2"){
//             if ((loanRecp.contains("Select the Year"))   && _selectedLoan=="1") {
//               errordialog(context,"Information","Year should not be empty");
//             }else {
//               confirmation();
//             }
//           }else {
//             errordialog(context,"Information","Amount received(ETB) should not be empty");
//           }
//         } else {
//           errordialog(context,"Information","Branch Name should not be empty");
//         }
//       } else {
//         errordialog(context,"Information", "Bank Name should not be empty");
//       }
//     } else {
//       errordialog(context, "Information", "Account No should not be empty");
//     }
//   }
//
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
//              "Camera",
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
//        licenseImageFile = File(image!.path);
//       }
//     });
//   }
//
//   saveAggregator() async {
//
//     Random rnd = new Random();
//     int recNo = 100000 + rnd.nextInt(999999 - 100000);
//     //String revNo = "CTB"+recNo.toString();
//     String revNo = "CTB"+aggregatorid.toString();
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
//         txntime, datas.txn_aggregator, revNo, '', '', '');
//     print('custTransaction : ' + custTransaction.toString());
//
//     val_country = 'C00001';
//
//     String aggphotoPath = "";
//     if (aggregatorImageFile != null) {
//       aggphotoPath = aggregatorImageFile!.path;
//     }
//
//     String bankPath = "";
//     if (bankImageFile != null) {
//       bankPath = bankImageFile!.path;
//     }
//
//     String licensePath = "";
//     if (licenseImageFile != null) {
//       licensePath = licenseImageFile!.path;
//     }
//
//     List<String> s = enrollmentDate.toString().split("/");
//     enrollmentDate = s[2]+"-"+s[1]+"-"+s[0];
//
//     List<String> sob = dateofbirth.toString().split("/");
//     dateofbirth = sob[2]+"-"+sob[1]+"-"+sob[0];
//
//     print("dateofbirth:"+dateofbirth);
//     int aggregatordb = await db.SaveAggregator(
//         val_enrollPerson,
//         enrollmentDate,
//         enrollingPersonController!.text,
//         aggregatorNameController!.text,
//         fatherNameController!.text,
//         gfatherNameController!.text,
//         genderSelect,
//         dateofbirth,
//         val_aggregator,
//         agretrotherspecfyController!.text,
//         aggFullnameController!.text,
//         aggphotoPath,
//         educationcontroller!.text,
//         mobileController!.text,
//         emailController!.text,
//         val_country,
//         val_zone,
//         val_woreda,
//         val_kebele,
//         groupSelect,
//         val_groupType,
//         otherspecfyController!.text,
//         val_groupName,
//         val_groupPos,
//         accountnoController!.text,
//         bankController!.text,
//         branchController!.text,
//         bankPath,
//         _selectedLicense,
//         licensePath,
//         _selectedtaxInv,
//         "1",
//         revNo,
//         Latitude,
//         Longitude,
//         _selectedLoan,
//         amtLoanRecController!.text,
//         loanRecp);
//
//     List<Map> aggregator = await db.GetTableValues('aggregator');
//
//     int issync = await db.UpdateTableValue(
//         'aggregator', 'isSynched', '0', 'recNo', revNo);
//
//     if (curIdLimited != 0) {
//       db.UpdateTableValue(
//           'agentMaster', 'curIdSeqAgg', aggregatorid.toString(), 'agentId', agendId);
//       db.UpdateTableValue(
//           'agentMaster', 'resIdSeqAgg', resId.toString(), 'agentId', agendId);
//       db.UpdateTableValue('agentMaster', 'curIdLimitAgg', curIdLimited.toString(),
//           'agentId', agendId);
//     } else {
//       db.UpdateTableValue(
//           'agentMaster', 'curIdSeqAgg', aggregatorid.toString(), 'agentId', agendId);
//     }
//
//     Alert(
//       context: context,
//       type: AlertType.info,
//       title: "Transaction Successful",
//       desc: "Aggregator Registration Successful",
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
//               saveAggregator();
//               Navigator.pop(context);
//             },
//             color: Colors.green,
//           )
//         ]).show();
//   }
//
// }
//
