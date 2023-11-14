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
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'dart:io' show File;
// import 'package:geolocator/geolocator.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:intl/intl.dart';
// import 'package:rflutter_alert/rflutter_alert.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// class cleanedSeedWar extends StatefulWidget {
//   @override
//   State<StatefulWidget> createState() {
//     return _cleanedSeedWar();
//   }
// }
//
// class _cleanedSeedWar extends State<cleanedSeedWar> {
//   var db = DatabaseHelper();
//
//   String Latitude = '', Longitude = '';
//
//   List<UImodel> managerNameModel = [];
//   List<UImodel> lotRefModel = [];
//   List<UImodel> warehouseDefModel = [];
//   List<UImodel> centerNameModel = [];
//   List<UImodel> warehouseRefModel = [];
//   List<UImodel> stackIDModel = [];
//
//   double netWt = 0.00;
//   double gross = 0.00;
//   double tare = 0.00;
//   String finall= "";
//   String finall2= "";
//
//   String cleaningName = " ",
//   varietyName = " " ,
//   generation  = " ",
//   seedcoating = " ",
//   certified = " ";
//
//   List<DropdownModel> managerNameitems = [];
//   DropdownModel? slctmanagerNames;
//   String slctmanagerName = "" , val_managerName = "";
//
//   List<DropdownModel> lotRefitems = [];
//   DropdownModel? slctlotRefs;
//   String val_lotRef = '' , slctlotRef = '';
//
//   List<DropdownModel> warehouseDesitems = [];
//   DropdownModel? slctwarehouseDess;
//   String val_warehouseDes = '' , slctwarehouseDes = '';
//
//   List<DropdownModel> cleaningCenteritems = [];
//   DropdownModel? slctcleaningCenters;
//   String val_cleaningCenter= '' , slctcleaningCenter = '';
//
//   List<DropdownModel> warehouseRecsitems = [];
//   DropdownModel? slctwarehouseRecss;
//   String val_warehouseRecs = '' , slctwarehouseRecs = '';
//
//   List<DropdownModel> stackIDitems = [];
//   DropdownModel? slctstackIDs;
//   String val_stackID = '' , slctstackID = '';
//
//
//   List<Map> agents = [];
//
//   TextEditingController?
//       aggronomistController,
//       cleaningCenterController,
//       varietyNameController,
//       generationController,
//       seedCoatingController,
//       certifiedController,
//       netWeightController,
//       theoWeightController,
//       transfernController,
//       sivnController,
//       repNameController,
//       vehicleGrossController,
//       vehicleTareController,
//       noOfBagsDepController,
//       goodReturnController ,
//       transferOutController,
//       issuedByController,
//       varietalPurityController,
//       mmController,
//       admixtureController,
//       kernelWeightController,
//       qualityCheckController,
//       noOfBagsRecController;
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
//   String receptionDate = "",
//          receptionDateFormatedDate = "";
//
//   //Image files
//
//   String bridgeSlipImage64 = "";
//   File? bridgeSlipImageFile;
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
//     aggronomistController = new TextEditingController();
//     cleaningCenterController = new TextEditingController();
//     varietyNameController = new TextEditingController();
//     generationController = new TextEditingController();
//     seedCoatingController = new TextEditingController();
//     certifiedController = new TextEditingController();
//     netWeightController = new TextEditingController();
//     theoWeightController = new TextEditingController();
//     transfernController = new TextEditingController();
//     sivnController = new TextEditingController();
//     repNameController = new TextEditingController();
//     vehicleGrossController = new TextEditingController();
//     vehicleTareController = new TextEditingController();
//     noOfBagsDepController = new TextEditingController();
//     goodReturnController = new TextEditingController();
//     transferOutController = new TextEditingController();
//     issuedByController = new TextEditingController();
//     varietalPurityController = new TextEditingController();
//     mmController = new TextEditingController();
//     admixtureController = new TextEditingController();
//     kernelWeightController = new TextEditingController();
//     qualityCheckController = new TextEditingController();
//     noOfBagsRecController = new TextEditingController();
//
//     getLocation();
//   }
//
//   calnetwghtval(){
//     finall = "";
//     finall2 = "";
//     if (vehicleGrossController!.text.length > 0 &&
//         vehicleTareController!.text.length > 0) {
//       var vehclegrs,vehicletare;
//       vehclegrs=0;
//       vehicletare=0;
//       if(vehicleGrossController!.text.length > 0){
//         vehclegrs=num.parse(vehicleGrossController!.text);
//       }
//       if( vehicleTareController!.text.length > 0){
//         vehicletare=num.parse(vehicleTareController!.text);
//       }
//
//       setState(() {
//         var valcalcontroller = vehclegrs-vehicletare;
//         finall = valcalcontroller.toString();
//         var great = valcalcontroller * 50;
//         finall2 = great.toString();
//
//       });
//     }
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
//     aggronomistController!.text=agendId;
//     String resIdd = agents[0]['resIdSeqF'];
//     print("resIdgetcliendata" + resIdd);
//     print("agendId_agendId" + agendId);
//   }
//
//   Future<void> initvalues() async {
//     List managerName = await db.RawQuery(
//         'select * from animalCatalog where catalog_code =\'10\'');
//     print("newList_newList" + managerName.toString());
//
//     managerNameModel = [];
//
//     managerNameitems.clear();
//     for (int i = 0; i < managerName.length; i++) {
//       String property_value = managerName[i]["property_value"].toString();
//       String DISP_SEQ = managerName[i]["DISP_SEQ"].toString();
//       var uimodel = new UImodel(property_value, DISP_SEQ);
//       managerNameModel.add(uimodel);
//
//       setState(() {
//         managerNameitems.add(DropdownModel(
//           property_value,
//           DISP_SEQ,
//         ));
//         //prooflist.add(property_value);
//       });
//     }
//
//     List lotRef = await db.RawQuery(
//         'select * from animalCatalog where catalog_code =\'10\'');
//     print('groups ' + lotRef.toString());
//     lotRefModel = [];
//     //groupList.clear();
//     lotRefitems.clear();
//     for (int i = 0; i < lotRef.length; i++) {
//       String property_value = lotRef[i]["property_value"].toString();
//       String DISP_SEQ = lotRef[i]["DISP_SEQ"].toString();
//
//       var uimodel = new UImodel(property_value, DISP_SEQ);
//       lotRefModel.add(uimodel);
//       setState(() {
//         lotRefitems.add(DropdownModel(
//           property_value,
//           DISP_SEQ,
//         ));
//         //prooflist.add(property_value);
//       });
//     }
//
//     List warehouseDes = await db.RawQuery(
//         'select * from animalCatalog where catalog_code =\'5\'');
//     print('groups ' + warehouseDes.toString());
//     warehouseDefModel = [];
//     //groupList.clear();
//     warehouseDesitems.clear();
//     for (int i = 0; i < warehouseDes.length; i++) {
//       String property_value = warehouseDes[i]["property_value"].toString();
//       String DISP_SEQ = warehouseDes[i]["DISP_SEQ"].toString();
//
//       var uimodel = new UImodel(property_value, DISP_SEQ);
//       warehouseDefModel.add(uimodel);
//       setState(() {
//         warehouseDesitems.add(DropdownModel(
//           property_value,
//           DISP_SEQ,
//         ));
//         //prooflist.add(property_value);
//       });
//     }
//
//     List centerNamelist = await db.RawQuery('select * from coOperative where coType = \'' + "2" + '\'');
//     print('centerNamelist' + centerNamelist.toString());
//     centerNameModel = [];
//     cleaningCenteritems = [];
//     cleaningCenteritems.clear();
//     for (int i = 0; i < centerNamelist.length; i++) {
//       String property_value = centerNamelist[i]["coName"].toString();
//       String DISP_SEQ = centerNamelist[i]["coCode"].toString();
//
//       var uimodel = new UImodel(property_value, DISP_SEQ);
//       centerNameModel.add(uimodel);
//       setState(() {
//         cleaningCenteritems.add(DropdownModel(
//           property_value,
//           DISP_SEQ,
//         ));
//         //prooflist.add(property_value);
//       });
//     }
//
//     List warehouseReflist = await db.RawQuery(
//         'select * from animalCatalog where catalog_code =\'6\'');
//     print('villagelistFarmerEnrollment' + warehouseReflist.toString());
//     warehouseRefModel = [];
//     warehouseRecsitems = [];
//     warehouseRecsitems.clear();
//     for (int i = 0; i < warehouseReflist.length; i++) {
//       String property_value = warehouseReflist[i]["property_value"].toString();
//       String DISP_SEQ = warehouseReflist[i]["DISP_SEQ"].toString();
//
//       var uimodel = new UImodel(property_value, DISP_SEQ);
//       warehouseRefModel.add(uimodel);
//       setState(() {
//         warehouseRecsitems.add(DropdownModel(
//           property_value,
//           DISP_SEQ,
//         ));
//         //prooflist.add(property_value);
//       });
//     }
//
//     List stackIDList = await db.RawQuery(
//         'select * from animalCatalog where catalog_code =\'1\'');
//     print('' + stackIDList.toString());
//     stackIDModel = [];
//     stackIDitems = [];
//     stackIDitems.clear();
//     for (int i = 0; i < stackIDList.length; i++) {
//       String chieftownName = stackIDList[i]["property_value"].toString();
//       String chieftownCode = stackIDList[i]["DISP_SEQ"].toString();
//
//       var uimodel = new UImodel(chieftownName, chieftownCode);
//       stackIDModel.add(uimodel);
//       setState(() {
//         stackIDitems.add(DropdownModel(
//           chieftownName,
//           chieftownCode,
//         ));
//         //prooflist.add(property_value);
//       });
//     }
//
//     vehicleGrossController!.addListener(() {
//       calnetwghtval();
//     });
//     vehicleTareController!.addListener(() {
//       calnetwghtval();
//     });
//
//   }
//
//   seedvalues() async {
//     List seedvaluesList =await db.RawQuery(
//         'select * from dropdownValues where DISP_SEQ =\'99\'');
//     print("qrrFarm_qrrFarm" + seedvaluesList.toString());
//
//     // List sortingList = await db.RawQuery(sortingvaluesList);
//
//     for (int i = 0; i < seedvaluesList.length; i++) {
//       setState(() {
//         cleaningCenterController!.text = seedvaluesList[i]["DISP_SEQ"].toString();
//         varietyNameController!.text = seedvaluesList[i]["_ID"].toString();
//         generationController!.text = seedvaluesList[i]["catalog_code"].toString();
//         seedCoatingController!.text = seedvaluesList[i]["property_value"].toString();
//         certifiedController!.text = seedvaluesList[i]["lang"].toString();
//       });
//     }
//   }
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
//               "Cleaned Seed to Warehouse",
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
//     //Filfare image;
//     int i = 0;
//     for (i = 0; i < 5; i++) {
//       if (i == 0) {
//
//         listings.add(txt_label("Order Information", Colors.green, 18.0, true));
//
//         listings.add(txt_label_mandatory("Aggronomist Manager Name", Colors.black, 14.0, false));
//
//        /* listings.add(DropDownWithModel(
//             itemlist: managerNameitems,
//             selecteditem: slctmanagerNames,
//             hint: "Select the Aggronomist Manager Name",
//             onChanged: (value) {
//               setState(() {
//                 slctmanagerNames = value!;
//
//                 val_managerName = slctmanagerNames!.value;
//                 slctmanagerName = slctmanagerNames!.name;
//
//               });
//             }));*/
//
//         listings.add(txtfield_dynamic("Aggronomist Manager Name", aggronomistController!, false));
//
//         listings.add(txt_label_mandatory("Lot Reference", Colors.black, 14.0, false));
//
//         listings.add(DropDownWithModel(
//           itemlist: lotRefitems,
//           selecteditem: slctlotRefs,
//           hint: "Select the Lot Reference",
//           onChanged: (value) {
//             setState(() {
//               slctlotRefs = value!;
//               val_lotRef = slctlotRefs!.value;
//               slctlotRef = slctlotRefs!.name;
//             });
//             seedvalues();
//
//           },));
//
//         listings.add(txt_label_mandatory("Name of Cleaning Center", Colors.black, 14.0, false));
//
//         listings.add(txtfield_dynamic(cleaningName, cleaningCenterController!, false));
//
//         listings.add(txt_label_mandatory("Variety Name", Colors.black, 14.0, false));
//
//         listings.add(txtfield_dynamic(varietyName, varietyNameController!, false));
//
//         listings.add(txt_label_mandatory("Generation", Colors.black, 14.0, false));
//
//         listings.add(txtfield_dynamic(generation, generationController!, false));
//
//         listings.add(txt_label_mandatory("Seed Coating", Colors.black, 14.0, false));
//
//         listings.add(txtfield_dynamic(seedcoating, seedCoatingController!, false));
//
//         listings.add(txt_label_mandatory("Certified Status", Colors.black, 14.0, false));
//
//         listings.add(txtfield_dynamic(certified, certifiedController!, false));
//
//
//
//
//         listings.add(txt_label_mandatory("Warehouse of Destination", Colors.black, 14.0, false));
//
//         listings.add(DropDownWithModel(
//             itemlist: warehouseDesitems,
//             selecteditem: slctwarehouseDess,
//             hint: "Select the Warehouse of Destination",
//             onChanged: (value) {
//               setState(() {
//                 slctwarehouseDess = value!;
//
//                 val_warehouseDes = slctwarehouseDess!.value;
//                 slctwarehouseDes = slctwarehouseDess!.name;
//
//               });
//             }));
//
//         listings.add(txt_label("Shipment details at Departure", Colors.green, 18.0, true));
//
//         listings.add(txt_label_mandatory("Name of Cleaning Center", Colors.black, 14.0, false));
//         listings.add(DropDownWithModel(
//             itemlist: cleaningCenteritems,
//             selecteditem: slctcleaningCenters,
//             hint: "Select the Name of Cleaning Center",
//             onChanged: (value) {
//               setState(() {
//                 slctcleaningCenters = value!;
//                 //toast(slctProofs!.value);
//                 val_cleaningCenter = slctcleaningCenters!.value;
//                 slctcleaningCenter = slctcleaningCenters!.name;
//                 //print('selectedvalue ' + slctProofs!.value);
//               });
//             }));
//
//         listings.add(txt_label_mandatory("Date of Reception", Colors.black, 14.0, false));
//         listings.add(selectDate(
//             context1: context,
//             slctdate: receptionDate,
//             onConfirm: (date) => setState(
//                   () {
//                     receptionDate = DateFormat('dd/MM/yyyy                                                                                                         ').format(date!);
//                     receptionDateFormatedDate =
//                     DateFormat('yyyyMMdd').format(date!);
//               },
//             )));
//
//         listings.add(txt_label_mandatory("SIV N°", Colors.black, 14.0, false));
//
//         listings.add(txtfield_digits("SIV N°", sivnController!, true,4));
//
//         listings.add(txt_label_mandatory("Representative Name at reception", Colors.black, 14.0, false));
//         listings.add(txtfield_dynamic("Representative Name at reception", repNameController!, true,25));
//
//         listings.add(txt_label_mandatory("Vehicle Gross Weight(Kg)", Colors.black, 14.0, false));
//         listings.add(txtfieldAllowTwoDecimal("Vehicle Gross Weight(Kg)", vehicleGrossController!, true,9));
//
//         listings.add(txt_label_mandatory("Vehicle Tare(Kg)", Colors.black, 14.0, false));
//         listings.add(txtfieldAllowTwoDecimal("Vehicle Tare(Kg)", vehicleTareController!, true , 9));
//
//         listings.add(txt_label_mandatory("Net Weight", Colors.black, 14.0, false));
//
//         listings.add(cardlable_dynamic(finall));
//
//         listings.add(txt_label_mandatory("Number of Bags", Colors.black, 14.0, false));
//
//         listings.add(txtfield_digits("Number of Bags", noOfBagsDepController!, true,4));
//
//         listings.add(txt_label_mandatory("Theoretical Weight", Colors.black, 14.0, false));
//
//         listings.add(cardlable_dynamic(finall2));
//
//         listings.add(txt_label_mandatory("Photo of Weigh Bridge slip", Colors.black, 14.0, false));
//         listings.add(img_picker(
//             label: "BridgeSlip Photo",
//             onPressed: () {
//               imageDialog("bridgeSlip");
//             },
//             filename: bridgeSlipImageFile,
//             ondelete: () {
//               ondelete("bridgeSlip");
//             }));
//
//         listings.add(txt_label_mandatory("Good Return Note N°", Colors.black, 14.0, false));
//
//         listings.add(txtfield_digits("Good Return Note N°", goodReturnController!, true,4));
//
//         listings.add(txt_label_mandatory("Transfer out N°", Colors.black, 14.0, false));
//         listings.add(txtfield_digits("Transfer out N°", transferOutController!, true, 16,4));
//
//         listings.add(txt_label_mandatory("Issued By", Colors.black, 14.0, false));
//
//         listings.add(txtfield_dynamic("Issued By", issuedByController!, true,25));
//
//         listings.add(txt_label("Quality Details", Colors.green, 18.0, true));
//
//         listings.add(txt_label_mandatory("Varietal Purity", Colors.black, 14.0, false));
//
//         listings.add(txtfield_digits("Varietal Purity", varietalPurityController!, true,3));
//
//         listings.add(txt_label_mandatory("<2,2mm", Colors.black, 14.0, false));
//
//         listings.add(txtfieldAllowTwoDecimal("<2,2mm", mmController!, true,5));
//
//         listings.add(txt_label_mandatory("Admixture", Colors.black, 14.0, false));
//
//         listings.add(txtfieldAllowTwoDecimal("Admixture", admixtureController!, true,5));
//
//         listings.add(txt_label_mandatory("Thousand Kernel Weight", Colors.black, 14.0, false));
//
//         listings.add(txtfieldAllowTwoDecimal("Thousand Kernel Weight", kernelWeightController!, true,5));
//
//         listings.add(txt_label_mandatory("Quality checked by", Colors.black, 14.0, false));
//
//         listings.add(txtfield_dynamic("Quality checked by", qualityCheckController!, true,25));
//
//         listings.add(txt_label("Shipment details at Reception", Colors.green, 18.0, true));
//
//         listings.add(txt_label_mandatory("Warehouse of Reception", Colors.black, 14.0, false));
//
//         listings.add(DropDownWithModel(
//           itemlist: warehouseRecsitems,
//           selecteditem: slctwarehouseRecss,
//           hint: "Select the Warehouse of Reception",
//           onChanged: (value) {
//             setState(() {
//               slctwarehouseRecss = value!;
//               val_warehouseRecs = slctwarehouseRecss!.value;
//               slctwarehouseRecs = slctwarehouseRecss!.name;
//               transfernController!.text=slctwarehouseRecss!.value;
//
//             });
//             print("Gross"+gross.toString());
//             print("Tare"+tare.toString());
//           },
//         ));
//
//         listings.add(txt_label_mandatory("Transfer IN N°", Colors.black, 14.0, false));
//
//         listings.add(txtfield_dynamic("Transfer IN N°", transfernController!,false,4));
//
//         listings.add(txt_label_mandatory("Number of Bags", Colors.black, 14.0, false));
//
//         listings.add(txtfield_digits("Number of Bags", noOfBagsRecController!, true,4));
//
//
//           listings.add(txt_label_mandatory(
//               "Stack ID", Colors.black, 14.0, false));
//
//           listings.add(DropDownWithModel(
//             itemlist: stackIDitems,
//             selecteditem: slctstackIDs,
//             hint: "Select the Stack ID",
//             onChanged: (value) {
//               setState(() {
//                 slctstackIDs = value!;
//                 val_stackID = slctstackIDs!.value;
//                 slctstackID = slctstackIDs!.name;
//               });
//               print("Gross"+gross.toString());
//               print("Tare"+tare.toString());
//             },
//           ));
//
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
//       }
//     }
//     return listings;
//   }
//
//   void ondelete(String photo) {
//     setState(() {
//       if (photo == "bridgeSlip") {
//
//         setState(() {
//           bridgeSlipImageFile = null;
//         });
//
//       }});
//   }
//
//   void btncancel() {
//     _onBackPressed();
//   }
//
//   void btnSubmit() {
//     // _progressHUD.state.show();
//
//     if (bridgeSlipImageFile != null) {
//       List<int> imageBytes = bridgeSlipImageFile!.readAsBytesSync();
//       bridgeSlipImage64 = base64Encode(imageBytes);
//     }
//
//     //  try {
//     if (aggronomistController!.text.length > 0 && aggronomistController!.text!= '') {
//         if (slctlotRef.length > 0 && slctlotRef != '') {
//           if (slctwarehouseDes.length > 0 && slctwarehouseDes != '') {
//             if (slctcleaningCenter.length > 0 && slctcleaningCenter != '') {
//               if (receptionDate.length > 0) {
//                 if (sivnController!.value.text.length > 0 &&
//                     sivnController!.value.text != '') {
//                   if (repNameController!.value.text.length > 0 &&
//                       repNameController!.value.text != '') {
//                     if (vehicleGrossController!.value.text.length > 0 &&
//                         vehicleGrossController!.value.text != '') {
//                       if (vehicleTareController!.value.text.length > 0 &&
//                           vehicleTareController!.value.text != '') {
//                         if (noOfBagsDepController!.value.text.length > 0 &&
//                             noOfBagsDepController!.value.text != '')  {
//                           if (bridgeSlipImage64 != ''  ) {
//                             if (goodReturnController!.value.text.length > 0 &&
//                                 goodReturnController!.value.text != '') {
//                               if (transferOutController!.value.text.length > 0 &&
//                                   transferOutController!.value.text != '') {
//                                 if (issuedByController!.value.text.length > 0 &&
//                                     issuedByController!.value.text != '') {
//                                   if (varietalPurityController!.value.text.length > 0 &&
//                                       varietalPurityController!.value.text != '') {
//                                     if (mmController!.value.text.length > 0 &&
//                                         mmController!.value.text != '') {
//                                       if (admixtureController!.value.text.length > 0 &&
//                                           admixtureController!.value.text != '') {
//                                         if (kernelWeightController!.value.text.length > 0 &&
//                                             kernelWeightController!.value.text != '') {
//                                           if (qualityCheckController!.value.text.length > 0 &&
//                                               qualityCheckController!.value.text != '') {
//                                             if (slctwarehouseRecs.length > 0 && slctwarehouseRecs != '') {
//                                               if (transfernController!.text.length > 0 && transfernController!.text != '') {
//                                               if (noOfBagsRecController!.value.text.length > 0 &&
//                                                   noOfBagsRecController!.value.text != '') {
//                                                 if (slctstackID.length > 0 && slctstackID != '') {
//
//                                                   confirmation();
//
//                                                 } else {
//                                                   errordialog(context,"Information","Select the Stack ID");
//                                                 }
//                                               } else {
//                                                 errordialog(context,"Information","Number of Bags should not be empty");
//                                               }
//                                               } else {
//                                                 errordialog(context,"Information","Transfer IN N° should not be empty");
//                                               }
//                                             } else {
//                                               errordialog(context,"Information","Select the  Warehouse of Reception");
//                                             }
//                                           } else {
//                                             errordialog(context,"Information","Quality checked by should not be empty");
//                                           }
//                                         } else {
//                                           errordialog(context,"Information","Thousand Kernel Weight should not be empty");
//                                         }
//                                       } else {
//                                         errordialog(context,"Information", "Admixture should not be empty");
//                                       }
//                                     } else {
//                                       errordialog(context, "Information", "<2 , 2mm should not be empty");
//                                     }
//                                   } else {
//                                     errordialog(context, "Information","Varietal Purity should not be empty");
//                                   }
//                                 } else {
//                                   errordialog(context, "Information", "Issued By should not be empty");
//                                 }
//                               } else {
//                                 errordialog(context, "Information", "Transfer out N should not be empty");
//                               }
//                             } else {
//                               errordialog(context,"Information", "Good Return Note N should not be empty");
//                             }
//                           } else {
//                             errordialog(context, "Information", "Photo of Weigh Bridgeslip should not be empty");
//                           }
//                         } else {
//                           errordialog(context, "Information", "Number of Bags should not be empty");
//                         }
//                       } else {
//                         errordialog(context, "Information", "Vehicle Tare(Kg) should not be empty");
//                       }
//                     } else {
//                       errordialog(context, "Information", "Vehicle Gross Weight(Kg) should not be empty");
//                     }
//                   } else {
//                     errordialog(context, "Information", "Representative name should not be empty");
//                   }
//                 } else {
//                   errordialog(context, "Information", "Siv N should not be empty");
//                 }
//               } else {
//                 errordialog(context, "Information",
//                     "Date of Reception should not be empty");
//               }
//             } else {
//               errordialog(context, "Information", "Select the  Name of Cleaning Center");
//             }
//             } else {
//               errordialog(context, "Information", "Select the Warehouse of Destination");
//             }
//         }else {
//           errordialog(context, "Information", "Select the  Lot Reference");
//         }
//         }else {
//          errordialog(context, "Information", "Aggronomist Manager Name should not be empty");
//        }
//
//       }
//
//   imageDialog(String photo) {
//     var alertStyle = const AlertStyle(
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
//             child: const Text(
//               "Gallery",
//               style: TextStyle(color: Colors.white, fontSize: 18),
//             ),
//             onPressed: () {
//               setState(() {
//                 getImageFromGallery(photo);
//                 Navigator.pop(context);
//               });
//             },
//             color: Colors.deepOrange,
//           ),
//           DialogButton(
//             child: const Text(
//               "Camera",
//               style: TextStyle(color: Colors.white, fontSize: 18),
//             ),
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
//       if (photo == "bridgeSlip") {
//         bridgeSlipImageFile = File(image!.path);
//       }
//     });
//   }
//
//   Future getImageFromGallery(String photo) async {
//     var image = await ImagePicker.platform
//         .pickImage(source: ImageSource.gallery, imageQuality: 30);
//     setState(() {
//       if (photo == "bridgeSlip") {
//         bridgeSlipImageFile = File(image!.path);
//       }
//     });
//   }
//
//   saveSeedtoWarehouse() async {
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
//         txntime, datas.txn_seedTowarehouse, revNo, '', '', '');
//     print('custTransaction : ' + custTransaction.toString());
//
//     //val_country = 'C00001';
//
//     String bridgeSlipPath = "";
//     if (bridgeSlipImageFile != null) {
//       bridgeSlipPath = bridgeSlipImageFile!.path;
//     }
//
//     int seedWarehousedb = await db.SaveSeedtoWarehouse(
//         aggronomistController!.text,
//         val_lotRef,
//         val_warehouseDes,
//         val_cleaningCenter,
//         receptionDate,
//         sivnController!.text,
//         repNameController!.text,
//         vehicleGrossController!.text,
//         vehicleTareController!.text,
//         finall,
//         noOfBagsDepController!.text,
//         finall2,
//         bridgeSlipPath,
//         goodReturnController!.text,
//         transferOutController!.text,
//         issuedByController!.text,
//         varietalPurityController!.text,
//         mmController!.text,
//         admixtureController!.text,
//         kernelWeightController!.text,
//         qualityCheckController!.text,
//         val_warehouseRecs,
//         transfernController!.text,
//         noOfBagsRecController!.text,
//         val_stackID,
//         "1",
//         revNo,
//         Latitude,
//         Longitude);
//
//     List<Map> seedTowarehouse = await db.GetTableValues('seedTowarehouse');
//
//     int issync = await db.UpdateTableValue(
//         'seedTowarehouse', 'isSynched', '0', 'recNo', revNo);
//
//     Alert(
//       context: context,
//       type: AlertType.info,
//       title: "Transaction Successful",
//       desc: "Cleaned Seed to Warehouse Successful",
//       buttons: [
//         DialogButton(
//           child: const Text(
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
//     var alertStyle = const AlertStyle(
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
//             child: const Text(
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
//             child: const Text(
//               "Yes",
//               style: TextStyle(color: Colors.white, fontSize: 18),
//             ),
//             //onPressed:btnok,
//             onPressed: () {
//               saveSeedtoWarehouse();
//               Navigator.pop(context);
//             },
//             color: Colors.green,
//           )
//         ]).show();
//   }
//
// }
//
