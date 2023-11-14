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
// import '../main.dart';
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
// class CTC extends StatefulWidget {
//   @override
//   State<StatefulWidget> createState() {
//     return _CTCNew();
//   }
// }
//
// class _CTCNew extends State<CTC> {
//   var db = DatabaseHelper();
//
//   String Latitude = '', Longitude = '';
//   bool ishavefarmercode = false;
//
//
//
//
//   List<Map> agents = [];
//
//
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
//
//
//
//
//   String groupSelect = "";
//
//   String  group = "option1",  _selectedgroup = "1",
//       license = "option1" , _selectedLicense = "1";
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
//   List<UImodel> witheringUIModel = [];
//   List<DropdownModel> witheringItems = [];
//   DropdownModel? slctWithering;
//   String slctWitheringtyp = '', slctWitheringtypId = '';
//
//
//   int curIdLim = 0;
//   int resId = 0;
//   int curIdLimited = 0;
//
//
//   // 12/05/2022
//   TextEditingController rcvController = new TextEditingController();
//   TextEditingController ctc1Controller = new TextEditingController();
//   TextEditingController ctc2Controller = new TextEditingController();
//   TextEditingController ctc3Controller = new TextEditingController();
//   TextEditingController rvOutputController = new TextEditingController();
//   TextEditingController rvInputController = new TextEditingController();
//   TextEditingController availableStockController = new TextEditingController();
//
//   String labelCTCDate = "date";
//   String ctcdate = "";
//   int CTCBatchNo = 0;
//   double availableStock = 0.0;
//   String CTCBatchNoStr = '';
//
//   TimeOfDay selectedTime = TimeOfDay.now();
//   TimeOfDay selecteddesTime = TimeOfDay.now();
//
//
//
//   @override
//   void initState() {
//     super.initState();
//
//
//
//     initvalues();
//     getClientData();
//
//     groupSelect = "1";
//
//     rcvController = new TextEditingController();
//     ctc1Controller = new TextEditingController();
//     ctc2Controller = new TextEditingController();
//     ctc3Controller = new TextEditingController();
//     rvOutputController = new TextEditingController();
//
//
//     rvInputController.addListener(() {
//
//       try {
//         if(double.parse(rvInputController.text) >= double.parse(availableStockController.text)){
//           errordialog(context, "info", "RV Input should not be greater than available stock");
//           rvInputController.clear();
//         }else{
//         }
//
//       } catch (e) {}
//     });
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
//     generateCTCBatchNo();
//
//     /*Withering  Dropdown*/
//     witheringUIModel = [];
//     witheringItems.clear();
//     String witheringQry =
//         'select wBatchNo from witheringInput';
//     List irritypList = await db.RawQuery(witheringQry);
//     for (int i = 0; i < irritypList.length; i++) {
//       String DISP_SEQ = irritypList[i]["wBatchNo"].toString();
//       String property_value = irritypList[i]["wBatchNo"].toString();
//
//       var uimodel = new UImodel(property_value, DISP_SEQ);
//       witheringUIModel.add(uimodel);
//       setState(() {
//         witheringItems.add(DropdownModel(
//           property_value,
//           DISP_SEQ,
//         ));
//         //prooflist.add(property_value);
//       });
//     }
//
//
//   }
//
//   loadAvailableStock(String witheringBatchNo)async{
//
//     List AvailableStockList = await db.RawQuery(
//         'select inputQty from witheringInput where wBatchNo =\'' + witheringBatchNo + '\'');
//
//     print('batchList ' + AvailableStockList.toString());
//
//     if(AvailableStockList.length>0){
//       for (int i = 0; i < AvailableStockList.length; i++) {
//         String avlStock = AvailableStockList[i]["inputQty"].toString();
//
//         setState(() {
//           availableStockController.text = avlStock;
//         });
//       }
//     }
//
//
//   }
//
//
//
//   Future<bool> _onBackPressed() async {
//     return (await Alert(
//       context: context,
//       type: AlertType.warning,
//       title: "Cancel",
//       desc: "Are you sure you want to Cancel?",
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
//               "CTC",
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
//     listings.add(txt_label_mandatory("Withering Batch",Colors.black,14.0,false));
//     listings.add(DropDownWithModel(
//         itemlist: witheringItems,
//         selecteditem: slctWithering,
//         hint: 'Select Withering Batch',
//         onChanged: (value) {
//           setState(() {
//             slctWithering = value!;
//             slctWitheringtypId = slctWithering!.value;
//             slctWitheringtyp = slctWithering!.name;
//             loadAvailableStock(slctWitheringtypId);
//           });
//         },
//         onClear: () {
//           setState(() {
//             slctWitheringtyp = '';
//           });
//         }));
//
//     listings.add(txt_label_mandatory("Date",Colors.black,14.0,false));
//     listings.add(selectDate(
//       context1: context,
//       slctdate: labelCTCDate,
//       onConfirm: (date) => setState(() {//HH:mm:ss
//         ctcdate = DateFormat('dd-MM-yyyy').format(date!);
//         labelCTCDate = DateFormat('dd-MM-yyyy').format(date);
//         //print('CHECKJOIINGDFATE:2 '+icsjoiningDate);
//       }),
//     ));
//
//     listings.add(txt_label_mandatory("Time",Colors.black,14.0,false));
//
//     listings.add(RaisedButton(
//       color: Colors.green,
//
//       onPressed: () {
//         destnatTime(context);
//         print("time:"+selecteddesTime.hour.toString()+":"+selecteddesTime.minute.toString());
//       },
//       child: Text("${selecteddesTime.hour}:${selecteddesTime.minute}"),
//     ),);
//                                             //20
//     listings.add(txt_label_mandatory("Available STock", Colors.black, 14.0, false));
//     listings.add(cardlable_dynamic(availableStockController.text));
//                                         //5
//     listings.add(txt_label_mandatory("RV Input", Colors.black, 14.0, false));
//     listings.add(txtfield_digits("RV Input", rvInputController, true));
//
//
//     listings.add(txt_label_mandatory("RCV", Colors.black, 14.0, false));
//     listings.add(txtfield_digits("RCV", rcvController, true));
//
//     listings.add(txt_label_mandatory("CTC-1", Colors.black, 14.0, false));
//     listings.add(txtfield_digits("CTC-1", ctc1Controller, true));
//
//     listings.add(txt_label_mandatory("CTC-2", Colors.black, 14.0, false));
//     listings.add(txtfield_digits("CTC-2", ctc2Controller, true));
//
//     listings.add(txt_label_mandatory("CTC-3", Colors.black, 14.0, false));
//     listings.add(txtfield_digits("CTC-3", ctc3Controller, true));
//
//     listings.add(txt_label_mandatory("RV Ouput", Colors.black, 14.0, false));
//     listings.add(txtfield_digits("RV Output", rvOutputController, true));
//
//     listings.add(txt_label_mandatory("CTC Batch No", Colors.black, 14.0, false));
//     listings.add(cardlable_dynamic(CTCBatchNoStr));
//
//
//     listings.add(Container(
//       child: Row(
//         children: [
//
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
//                   _onBackPressed();
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
//
//           //
//         ],
//       ),
//     ));
//
//     return listings;
//   }
//
//
//   destnatTime(BuildContext context) async {
//     final TimeOfDay? timeOfDay = await showTimePicker(
//       context: context,
//       initialTime: selecteddesTime,
//       initialEntryMode: TimePickerEntryMode.dial,
//
//     );
//     if(timeOfDay != null && timeOfDay != selecteddesTime)
//     {
//       setState(() {
//         selecteddesTime = timeOfDay;
//       });
//     }
//   }
//
//
//   void btncancel() {
//     _onBackPressed();
//   }
//
//   void btnSubmit() {
//     // _progressHUD.state.show();
//     if(slctWitheringtyp.isNotEmpty&&slctWitheringtyp != ""){
//       if(labelCTCDate.isNotEmpty&&labelCTCDate != ""){
//         if(rvInputController.text.length>0 && rvInputController.text != ""){
//           if(rcvController.text.length>0 && rcvController.text != ""){
//             if(ctc1Controller.text.length>0 && ctc1Controller.text != ""){
//               if(ctc2Controller.text.length>0 && ctc2Controller.text != ""){
//                 if(ctc3Controller.text.length>0 && ctc3Controller.text !=""){
//                   if(rvOutputController.text.length>0 && rvOutputController.text !=""){
//                     confirmation();
//                   }else{
//                     errordialog(context, "info", "RV output should not be empty");
//                   }
//                 }else{
//                   errordialog(context, "info", "CTC - 3 should not be empty");
//                 }
//               }else{
//                 errordialog(context, "info", "CTC - 2 should not be empty");
//               }
//             }else{
//               errordialog(context, "info", "CTC -1 should not be empty");
//             }
//           }else{
//             errordialog(context, "info", "RCV should not be empty");
//           }
//         }else{
//           errordialog(context, "info", "RV Input not be empty");
//         }
//       }else{
//         errordialog(context, "info", "select CTC Date");
//       }
//     }else{
//       errordialog(context, "info", "select Withering Batch No");
//     }
//
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
//               saveCTC();
//               Navigator.pop(context);
//             },
//             color: Colors.green,
//           )
//         ]).show();
//   }
//
//
//   saveCTC() async {
//
//     Random rnd = new Random();
//     int recNo = 100000 + rnd.nextInt(999999 - 100000);
//     //String revNo = "CTB"+recNo.toString();
//     String revNo = recNo.toString();
//
//
//     final now = new DateTime.now();
//     String txntime = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
//     String msgNo = DateFormat('yyyyMMddHHmmss').format(now);
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     String? agentid = prefs.getString("agentId");
//     String? agentToken = prefs.getString("agentToken");
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
//     Future<List<Map>> txnHeader = db.GetTableValues('txnHeader');
//
//     //CustTransaction
//     AppDatas datas = new AppDatas();
//     int custTransaction = await db.saveCustTransaction(
//         txntime, datas.txn_ctc, revNo, '', '', '');
//     print('custTransaction : ' + custTransaction.toString());
//     print('ctc inserting');
//
//     String witheringBatch  = slctWitheringtypId;
//     String availableStockStr  = availableStockController.text;
//     String rvInput  = rvInputController.text;
//     String CTCdate  = ctcdate;
//     String CTCtime = selecteddesTime.hour.toString()+ ":" + selecteddesTime.minute.toString();
//     String rcv = rcvController.text;
//     String ctc1 = ctc1Controller.text;
//     String ctc2 =ctc2Controller.text;
//     String ctc3 = ctc3Controller.text;
//     String rvoutput = rvOutputController.text;
//     String ctcBatchNo = CTCBatchNoStr;
//     String latitude = Latitude;
//     String longitude = Longitude;
//     String isSynched = "0";
//
//     int ctcData = await db.saveCTC(
//         revNo,
//         isSynched,
//         witheringBatch,
//         CTCdate,
//         CTCtime,
//         availableStockStr,
//         rvInput,
//         rcv,
//         ctc1,
//         ctc2,
//         ctc3,
//         rvoutput,
//         ctcBatchNo,
//         latitude,
//         longitude
//     );
//
//     print("ctc data:"+ctcData.toString());
//
//
//     Alert(
//       context: context,
//       type: AlertType.info,
//       title: "Transaction",
//       desc: "CTC Successful",
//       buttons: [
//         DialogButton(
//           child: Text(
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
//     ).show();
//
//
//   }
//
//   void generateCTCBatchNo() {
//     Random rnd = new Random();
//     CTCBatchNo = 100000 + rnd.nextInt(999999 - 100000);
//     CTCBatchNoStr = "CTC" + CTCBatchNo.toString();
//   }
//
//
//
//
// }
//
//
