// import 'dart:ffi';
// import 'dart:math';
//
// import 'package:flutter/material.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:intl/intl.dart';
// import 'package:rflutter_alert/rflutter_alert.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// import '../Database/Databasehelper.dart';
// import '../Model/UIModel.dart';
// import '../Model/dynamicfields.dart';
// import '../Plugins/TxnExecutor.dart';
// import '../Utils/MandatoryDatas.dart';
//
//
//
//
// class MRLInspection extends StatefulWidget {
//   const MRLInspection({Key? key}) : super(key: key);
//
//   @override
//   State<MRLInspection> createState() => _MRLInspectionState();
// }
//
// class _MRLInspectionState extends State<MRLInspection> {
//
//   String cancel = 'Cancel';
//   String rusurecancel = 'Are you sure want to cancel?';
//   String yes = 'Yes';
//   String no = 'No';
//   String gpslocation = 'GPS Location not enabled';
//   String ok = 'OK';
//   String info = 'Information';
//   String submt = 'Submit';
//   String AresurCancl = 'Are you sure want to cancel?';
//   String AresurProcd = 'Are you sure want to proceed?';
//   String save = 'Save';
//   String Cnfm = 'Confirmation';
//
//   String? servicePointId;
//   String? seasoncode;
//   var db = DatabaseHelper();
//
//   List<Map>? agents;
//   String inspDate = "",sprayingDate ='',sprayingFrmtDate ='',
//       inspFormatedDate = "",certtype = "1";
//
//   String slct_village = "",
//       slct_farmer = "",
//       slct_cert = "",
//       slct_status = "",
//       slct_soil = "",
//       slct_fert = "",
//       slctFarm = "",
//       val_farm = "",
//       val_fert = "";
//
//   String val_village = "",
//       val_farmer = "",
//       farmerId = "",
//       latitude = "",
//       longitude = "",
//       farmerAddress = "",
//       ffarmerId = "";
//
//   String villageCode = "";
//   String catHarvestInterval = "";
//   bool isfarmloaded = false;
//   bool isChemicalLoaded = false;
//
//
//
//
//   List<DropdownModel> villageitems = [];
//   DropdownModel? slctvillages;
//   List<UImodel> villagelistUIModel = [];
//
//   List<DropdownModel> farmeritems = [];
//   DropdownModel? slctFarmers;
//   List<UImodel2> farmerlistUIModel = [];
//
//   List<DropdownModel> farmitems = [];
//   DropdownModel? selectFarm;
//   List<UImodel> FarmListUIModel = [];
//
//   List<DropdownModel> pestitems = [];
//   DropdownModel? selectPest;
//   List<UImodel> pestListUIModel = [];
//   String slctPest = '', valPest ='';
//
//
//   List<DropdownModel> categoryItems = [];
//   DropdownModel? selectCategory;
//   List<UImodel> categoryListUIModel = [];
//   String slctCategory = '', valCategory='';
//
//   List<DropdownModel1> chemicalItems = [];
//   DropdownModel1? selectChemical;
//   List<UImodel2> chemicalListUIModel = [];
//   String slctChemical = '', valChemical='';
//
//   String harvestIntDays ='';
//
//   bool farmerloaded = false;
//
//
//   @override
//   void initState(){
//     super.initState();
//     loadVillage();
//     loadPest();
//     loadCategory();
//     getClientData();
//     getLocation();
//
//   }
//   @override
//   void dispose() {
//     super.dispose();
//   }
//
//   void getLocation() async {
//     Position position = await Geolocator.getCurrentPosition(
//         desiredAccuracy: LocationAccuracy.high);
//     setState(() {
//       latitude = position.latitude.toString();
//       longitude = position.longitude.toString();
//     });
//   }
//
//   Future<void> loadVillage() async{
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
//   }
//
//   Future<void> loadPest() async{
//     String qry_pestlist =
//         'select * from animalCatalog where catalog_code =\'36\'';
//     //'select * from villageList';
//     print('Approach Query:  ' + qry_pestlist);
//     List pestlist = await db.RawQuery(qry_pestlist);
//     print('pestlist 1:  ' + pestlist.toString());
//     pestitems.clear();
//     pestListUIModel = [];
//
//     for (int i = 0; i < pestlist.length; i++) {
//       String property_value = pestlist[i]["property_value"].toString();
//       String DISP_SEQ = pestlist[i]["DISP_SEQ"].toString();
//       var uimodel = new UImodel(property_value, DISP_SEQ);
//       pestListUIModel.add(uimodel);
//       setState(() {
//         pestitems.add(DropdownModel(
//           property_value,
//           DISP_SEQ,
//         ));
//         //prooflist.add(property_value);
//       });
//     }
//   }
//   Future<void> loadCategory() async{
//     String qry_categorylist =
//         'select * from animalCatalog where catalog_code =\'35\'';
//     //'select * from villageList';
//     print('Approach Query:  ' + qry_categorylist);
//
//     List categorylist = await db.RawQuery(qry_categorylist);
//     print('categorylist 1:  ' + categorylist.toString());
//     categoryItems.clear();
//     categoryListUIModel = [];
//
//     for (int i = 0; i < categorylist.length; i++) {
//       String property_value = categorylist[i]["property_value"].toString();
//       String DISP_SEQ = categorylist[i]["DISP_SEQ"].toString();
//       var uimodel = new UImodel(property_value, DISP_SEQ);
//       categoryListUIModel.add(uimodel);
//       setState(() {
//         categoryItems.add(DropdownModel(
//           property_value,
//           DISP_SEQ,
//         ));
//
//         //prooflist.add(property_value);
//       });
//     }
//
//   }
//   Future<void> loadChemical(String catCode) async{
//     String qry_chemicallist =
//         'select * from animalCatalog where catalog_code =\'' +
//             '146' +
//             '\' and parentID =\'' +
//             catCode +
//             '\'';
//     //'select * from villageList';
//     print('Approach Query:  ' + qry_chemicallist);
//     List chemicallist = await db.RawQuery(qry_chemicallist);
//     print('chemicallist 1:  ' + chemicallist.toString());
//     chemicalItems.clear();
//     chemicalListUIModel = [];
//
//     for (int i = 0; i < chemicallist.length; i++) {
//       String property_value = chemicallist[i]["property_value"].toString();
//       String DISP_SEQ = chemicallist[i]["DISP_SEQ"].toString();
//        String catHarvestInterval = chemicallist[i]["catStatus"].toString();
//
//
//       var uimodel = new UImodel2(property_value, DISP_SEQ,catHarvestInterval);
//       chemicalListUIModel.add(uimodel);
//       setState(() {
//         chemicalItems.add(DropdownModel1(
//           property_value,
//           DISP_SEQ,
//             catHarvestInterval
//         ));
//         isChemicalLoaded = true;
//
//         //prooflist.add(property_value);
//       });
//     }
//     Future.delayed(Duration(milliseconds: 500), () {
//       // Do something
//       setState(() {
//         //slctFarm = null;
//         isChemicalLoaded = true;
//       });
//     });
//   }
//
//   getClientData() async {
//     agents = await db.RawQuery('SELECT * FROM agentMaster');
//     seasoncode = agents![0]['currentSeasonCode'];
//     servicePointId = agents![0]['servicePointId'];
//   }
//
//
//   Future<bool> _onBackPressed() async {
//     return (await Alert(
//       context: context,
//       type: AlertType.warning,
//       title: cancel,
//       desc: rusurecancel,
//       buttons: [
//         DialogButton(
//           child: Text(
//             yes,
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
//             no,
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
//           resizeToAvoidBottomInset: false,
//           appBar: AppBar(
//             centerTitle: true,
//             leading: IconButton(
//                 icon: Icon(Icons.arrow_back, color: Colors.white),
//                 onPressed: () {
//                   _onBackPressed();
//                 }),
//             title: Text(
//               'MRL Inspection',
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
//                 Expanded(
//                   child: ListView(
//                     padding: EdgeInsets.all(10.0),
//                     children: _getListings(
//                         context), // <<<<< Note this change for the return type
//                   ),
//                   flex: 8,
//                 ),
//               ])),
//         ),
//       ),
//     );
//   }
//
//   List<Widget> _getListings(BuildContext context) {
//     List<Widget> listings =[];
//     listings.add(txt_label_mandatory("Date", Colors.black, 14.0, false));
//     listings.add(selectDate(
//         context1: context,
//         slctdate: inspDate,
//         onConfirm: (date) => setState(
//               () {
//             inspDate = DateFormat('dd-MM-yyyy').format(date!);
//             inspFormatedDate =
//                 DateFormat('yyyyMMdd').format(date);
//           },
//         )));
//     listings.add(txt_label_mandatory('Village', Colors.black, 14.0, false));
//     listings.add(DropDownWithModel(
//         itemlist: villageitems,
//         selecteditem: slctvillages,
//         hint: 'Select Village',
//         onChanged: (value) {
//           setState(() {
//             farmerId='';
//             slct_farmer='';
//             slctFarm='';
//             val_farm='';
//             slctvillages = value!;
//             slctFarmers=null;
//             selectFarm = null;
//             isfarmloaded = false;
//             farmerloaded = false;
//
//             //toast(slctFarmers!.value);
//             villageCode = slctvillages!.value;
//             slct_village = slctvillages!.name;
//             farmersearch(villageCode);
//           });
//         },
//         // onClear: () {
//         //   setState(() {
//         //     farmerId='';
//         //     slct_farmer='';
//         //     slctFarm='';
//         //     val_farm='';
//         //   });
//         // }
//         ));
//
//     listings.add(farmerloaded
//         ? txt_label_mandatory('Farmer', Colors.black, 14.0, false)
//         : Container());
//     listings.add(farmerloaded
//         ? DropDownWithModel(
//         itemlist: farmeritems,
//         selecteditem: slctFarmers,
//         hint: 'Select farmer',
//         onChanged: (value) {
//           setState(() {
//             slctFarmers = value!;
//             //toast(slctFarmers!.value);
//             slctFarm='';
//             val_farm='';
//             selectFarm = null;
//             isfarmloaded = false;
//
//             farmerId = slctFarmers!.value;
//             slct_farmer = slctFarmers!.name;
//
//             for (int i = 0; i < farmerlistUIModel.length; i++) {
//               if (farmerlistUIModel[i].value == farmerId) {
//                 farmerAddress = farmerlistUIModel[i].value2;
//               }
//             }
//           });
//           loadFarm(farmerId);
//         },
//         // onClear: () {
//         //   setState(() {
//         //     slct_farmer = '';
//         //     slctFarm='';
//         //     val_farm='';
//         //     isfarmloaded = false;
//         //   });
//         // }
//         )
//         : Container());
//
//     if (isfarmloaded) {
//       listings.add(txt_label_mandatory('Farm', Colors.black, 14.0, false));
//       listings.add(DropDownWithModel(
//           itemlist: farmitems,
//           selecteditem: selectFarm,
//           hint: "Select the Farm",
//           onChanged: (value) {
//             setState(() {
//               selectFarm = value;
//               slctFarm = selectFarm!.name;
//               val_farm = selectFarm!.value;
//
//             });
//           },
//           // onClear: () {
//           //   setState(() {
//           //     slctFarm = '';
//           //     val_farm = '';
//           //   });
//           // }
//           ));
//     }
//     listings.add(txt_label_mandatory("Date of Spraying", Colors.black, 14.0, false));
//     listings.add(selectDate(
//         context1: context,
//         slctdate: sprayingDate,
//         onConfirm: (date) => setState(
//               () {
//                 sprayingDate = DateFormat('dd-MM-yyyy').format(date!);
//             sprayingFrmtDate =
//                 DateFormat('yyyyMMdd').format(date);
//
//               },
//         )));
//
//     listings.add(txt_label_mandatory('Name of Pest / Disease', Colors.black, 14.0, false));
//     listings.add(DropDownWithModel(
//         itemlist: pestitems,
//         selecteditem: selectPest,
//         hint: "Select Pest / Disease",
//         onChanged: (value) {
//           setState(() {
//             selectPest = value;
//             slctPest = selectPest!.name;
//             valPest = selectPest!.value;
//
//           });
//         },
//         onClear: () {
//           setState(() {
//             slctPest = '';
//             valPest = '';
//           });
//         }));
//
//     listings.add(txt_label_mandatory('Category', Colors.black, 14.0, false));
//     listings.add(DropDownWithModel(
//         itemlist: categoryItems,
//         selecteditem: selectCategory,
//         hint: "Select Category",
//         onChanged: (value) {
//           setState(() {
//             selectChemical = null;
//             slctChemical = '';
//             valChemical = '';
//             catHarvestInterval='';
//             isChemicalLoaded=false;
//             selectCategory = value;
//             slctCategory = selectCategory!.name;
//             valCategory = selectCategory!.value;
//
//             loadChemical(valCategory);
//
//           });
//         },
//         // onClear: () {
//         //   setState(() {
//         //     slctCategory = '';
//         //     valCategory = '';
//         //     selectChemical = null;
//         //     slctChemical = '';
//         //     valChemical = '';
//         //     isChemicalLoaded=false;
//         //     catHarvestInterval = '';
//         //   });
//         // }
//         ));
//
//     if(isChemicalLoaded){
//       listings.add(txt_label_mandatory('Chemical', Colors.black, 14.0, false));
//       listings.add(DropDownWithModel1(
//           itemlist: chemicalItems,
//           selecteditem: selectChemical,
//           hint: "Select Chemical",
//           onChanged: (value) {
//             setState(() {
//               selectChemical = value;
//               slctChemical = selectChemical!.name;
//               valChemical = selectChemical!.value;
//               catHarvestInterval = selectChemical!.value1;
//               setMrlInspectionDate(catHarvestInterval);
//             });
//           },
//           // onClear: () {
//           //   setState(() {
//           //     slctChemical = '';
//           //     valChemical = '';
//           //   });
//           // }
//           ));
//     }
//
//
//     listings.add(txt_label_mandatory('Harvest Interval', Colors.black, 14.0, false));
//     listings.add(cardlable_dynamic(catHarvestInterval));
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
//                   cancel,
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
//                   'Submit',
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
//
//     return listings;
//   }
//
//   Future<void> farmersearch(String villageCode) async {
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
//   Future<void> loadFarm(String farmerId) async{
//     String qry_farm =
//         'select farmIDT,farmName,farmArea, landProd,seasonYear  from farm where farmerId = \'' +
//             farmerId +
//             '\'';
//     print('CHECK_VILLAGE_NAME 8:  ' + qry_farm);
//     List farmlist = await db.RawQuery(qry_farm);
//     print('CHECK_VILLAGE_NAME 9:  ' + farmlist.toString());
//     farmitems = [];
//     farmitems.clear();
//     FarmListUIModel = [];
//
//     if (farmlist.length > 0) {
//       for (int i = 0; i < farmlist.length; i++) {
//         String DISP_SEQ = farmlist[i]["farmIDT"].toString();
//         String property_value = farmlist[i]["farmName"].toString();
//         //String farmName = farmlist[i]["farmName"].toString();
//         String Land = farmlist[i]["landProd"].toString();
//         String farmtotarea = farmlist[i]["farmArea"].toString();
//         String Cropcycle = farmlist[i]["seasonYear"].toString();
//         //(property_value +"-"+ Land, DISP_SEQ);
//         var uimodel =
//         new UImodel(property_value + "-" + farmtotarea, DISP_SEQ);
//         FarmListUIModel.add(uimodel);
//         setState(() {
//           farmitems.add(DropdownModel(
//             property_value,
//             DISP_SEQ,
//           ));
//           isfarmloaded = true;
//         });
//       }
//     }
//     Future.delayed(Duration(milliseconds: 500), () {
//       // Do something
//       setState(() {
//         //slctFarm = null;
//         isfarmloaded = true;
//       });
//     });
//   }
//
//   void btncancel() {
//     _onBackPressed();
//   }
//
//   void btnSubmit() {
//      if(inspDate.isEmpty){
//        errordialog(context, "Info",
//            "Date should not be empty");
//      }else if(slct_village.isEmpty){
//        errordialog(context, "Info",
//            "Village should not be empty");
//      }else if(slct_farmer.isEmpty){
//        errordialog(context, "Info",
//            "Farmer should not be empty");
//      }else if(slctFarm.isEmpty){
//        errordialog(context, "Info",
//            "Farm should not be empty");
//      } else if(sprayingDate.isEmpty){
//        errordialog(context, "Info",
//            "Date of Spraying should not be empty");
//      }else if(slctPest.isEmpty){
//        errordialog(context, "Info",
//            "Name of Pest / Disease should not be empty");
//      }else if(slctCategory.isEmpty){
//        errordialog(context, "Info",
//            "Category should not be empty");
//      }else if(slctChemical.isEmpty){
//        errordialog(context, "Info",
//            "Chemical should not be empty");
//      }else if(slct_village.isEmpty){
//        errordialog(context, "Info",
//            "Harvest Interval should not be empty");
//      }else{
//        confirmationPopup(context);
//      }
//   }
//
//   confirmationPopup(dialogContext) {
//     var alertStyle = AlertStyle(
//       animationType: AnimationType.grow,
//       overlayColor: Colors.black87,
//       isCloseButton: true,
//       isOverlayTapDismiss: true,
//       titleStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
//       descStyle: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
//       animationDuration: Duration(milliseconds: 400),
//     );
//     Alert(
//       context: dialogContext,
//       type: AlertType.info,
//       style: alertStyle,
//       title: Cnfm,
//       desc: AresurProcd,
//       buttons: [
//         DialogButton(
//           child: Text(
//             yes,
//             style: TextStyle(color: Colors.white, fontSize: 20),
//           ),
//           onPressed: () {
//             Navigator.pop(context);
//             saveMrlInspection();
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
//   Future<void> saveMrlInspection() async {
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
//             '0,\'' +
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
//
//     int succ = await db.RawInsert(txnHeaderQuery);
//     print(succ);
//
//     //Future<List<Map>> txnHeader = db.GetTableValues('txnHeader');
//
//     AppDatas datas = new AppDatas();
//     int custTransaction = await db.saveCustTransaction(
//         txntime, datas.txn_mrlInsp, revNo.toString(), '', '', '');
//
//     print('custTransaction : ' + custTransaction.toString());
//
//     String isSynched = "0";
//
//
//     int saveMrlInsp = await db.saveMrlInspection(
//         inspDate,
//         villageCode,
//        farmerId,
//         val_farm,
//         sprayingDate,
//         valPest,
//         valCategory,
//         valChemical,
//         catHarvestInterval,
//         longitude,
//         latitude,
//        isSynched,
//         msgNo,
//         revNo.toString(),
//         );
//
//     int issync = await db.UpdateTableValue(
//         'mrlInspection', 'isSynched', '0', 'recNo', revNo.toString());
//
//
//
//     Alert(
//       context: context,
//       type: AlertType.info,
//       title: "Transaction Successful",
//       desc: "MRL Inspection done Successfully",
//       buttons: [
//         DialogButton(
//           child: const Text(
//             "OK",
//             style: TextStyle(color: Colors.white, fontSize: 20),
//           ),
//           onPressed: () {
//             Navigator.pop(context);
//             Navigator.pop(context);
//           },
//           width: 120,
//         ),
//       ],
//       closeFunction: () {
//         Navigator.pop(context);
//         Navigator.pop(context);
//       },
//     ).show();
//
//
//
//   }
//
//   void setMrlInspectionDate(String catHarvestInterval) {
//
//     var parsedDate = DateTime.parse(sprayingFrmtDate);
//
//     var fiftyDaysFromNow = parsedDate.add(new Duration(days: int.parse(catHarvestInterval)));
//
//     harvestIntDays = DateFormat('dd/MM/yyyy').format(fiftyDaysFromNow);
//
//
//     print('harvestIntDays' + harvestIntDays.toString());
//
//
//
//   }
// }
//
