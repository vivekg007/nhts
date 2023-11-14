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
// class CFM extends StatefulWidget {
//   @override
//   State<StatefulWidget> createState() {
//     return _CFMNew();
//   }
// }
//
// class _CFMNew extends State<CFM> {
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
//
//   int curIdLim = 0;
//   int resId = 0;
//   int curIdLimited = 0;
//
//
//   // 12/05/2022
//   TextEditingController m1Controller = new TextEditingController();
//   TextEditingController m2Controller = new TextEditingController();
//   TextEditingController m3Controller = new TextEditingController();
//   TextEditingController m4Controller = new TextEditingController();
//   TextEditingController m5Controller = new TextEditingController();
//   TextEditingController m6Controller = new TextEditingController();
//   TextEditingController m7Controller = new TextEditingController();
//   TextEditingController droppingController = new TextEditingController();
//   TextEditingController fermentingTimeController = new TextEditingController();
//   TextEditingController m1percentController = new TextEditingController();
//   TextEditingController m2percentController = new TextEditingController();
//   TextEditingController m3percentController = new TextEditingController();
//   TextEditingController m4percentController = new TextEditingController();
//   TextEditingController m5percentController = new TextEditingController();
//   TextEditingController m6percentController = new TextEditingController();
//   TextEditingController m7percentController = new TextEditingController();
//
//
//
//   String labelCTCDate = "date";
//   String ctcdate = "";
//
//   TimeOfDay selectedTime = TimeOfDay.now();
//   TimeOfDay selecteddesTime = TimeOfDay.now();
//
//   List<DropdownModel> ctcitem = [];
//   DropdownModel? slctctc;
//   String val_ctc = '', slct_ctc = '';
//
//
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
//     m1Controller = new TextEditingController();
//     m2Controller = new TextEditingController();
//     m3Controller = new TextEditingController();
//     m4Controller = new TextEditingController();
//     m5Controller = new TextEditingController();
//     m6Controller = new TextEditingController();
//     m7Controller = new TextEditingController();
//     droppingController = new TextEditingController();
//     fermentingTimeController = new TextEditingController();
//     m1percentController = new TextEditingController();
//     m2percentController = new TextEditingController();
//     m3percentController = new TextEditingController();
//     m4percentController = new TextEditingController();
//     m5percentController = new TextEditingController();
//     m6percentController = new TextEditingController();
//     m7percentController = new TextEditingController();
//
//
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
//
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
//               "CFM",
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
//
//     listings.add(txt_label_mandatory("CTC Batch No", Colors.black, 14.0, false));
//
//     listings.add(DropDownWithModel(
//       itemlist: ctcitem,
//       selecteditem: slctctc,
//       hint: "Select Batch No",
//       onChanged: (item) {
//         setState(() {
//           slctctc = item!;
//           val_ctc = slctctc!.value;
//           slct_ctc = slctctc!.name;
//           print("val ctc:" + val_ctc);
//         });
//       },
//     ));
//
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
//
//     listings.add(txt_label_mandatory("M-1", Colors.black, 14.0, false));
//     listings.add(txtfield_dynamic("M-1", m1Controller, true));
//
//     listings.add(txt_label_mandatory("M-2", Colors.black, 14.0, false));
//     listings.add(txtfield_dynamic("M-2", m2Controller, true));
//
//     listings.add(txt_label_mandatory("M-3", Colors.black, 14.0, false));
//     listings.add(txtfield_dynamic("M-3", m3Controller, true));
//
//     listings.add(txt_label_mandatory("M-4", Colors.black, 14.0, false));
//     listings.add(txtfield_dynamic("M-4", m4Controller, true));
//
//     listings.add(txt_label_mandatory("M-5", Colors.black, 14.0, false));
//     listings.add(txtfield_dynamic("M-5", m5Controller, true));
//
//     listings.add(txt_label_mandatory("M-6", Colors.black, 14.0, false));
//     listings.add(txtfield_dynamic("M-6", m6Controller, true));
//
//     listings.add(txt_label_mandatory("M-7", Colors.black, 14.0, false));
//     listings.add(txtfield_dynamic("M-7", m7Controller, true));
//
//     listings.add(txt_label_mandatory("Dropping", Colors.black, 14.0, false));
//     listings.add(txtfield_dynamic("Dropping", droppingController, true));
//
//     listings.add(txt_label_mandatory("Fermenting time in Mins", Colors.black, 14.0, false));
//     listings.add(txtfield_dynamic("Fermenting time in Mins", fermentingTimeController, true));
//
//     listings.add(txt_label_mandatory("M-1%", Colors.black, 14.0, false));
//     listings.add(txtfield_dynamic("M-1%", m1percentController, true));
//
//     listings.add(txt_label_mandatory("M-2%", Colors.black, 14.0, false));
//     listings.add(txtfield_dynamic("M-2%", m2percentController, true));
//
//     listings.add(txt_label_mandatory("M-3%", Colors.black, 14.0, false));
//     listings.add(txtfield_dynamic("M-3%", m3percentController, true));
//
//     listings.add(txt_label_mandatory("M-4%", Colors.black, 14.0, false));
//     listings.add(txtfield_dynamic("M-4%", m4percentController, true));
//
//     listings.add(txt_label_mandatory("M-5%", Colors.black, 14.0, false));
//     listings.add(txtfield_dynamic("M-5%", m5percentController, true));
//
//     listings.add(txt_label_mandatory("M-6%", Colors.black, 14.0, false));
//     listings.add(txtfield_dynamic("M-6%", m6percentController, true));
//
//     listings.add(txt_label_mandatory("M-7%", Colors.black, 14.0, false));
//     listings.add(txtfield_dynamic("M-7%", m7percentController, true));
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
//
//
//
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
//
//     if(labelCTCDate.isNotEmpty && labelCTCDate !=""){
//       if(m1Controller.text.length>0 && m1Controller.text!=""){
//         if(m2Controller.text.length>0 && m2Controller.text!=""){
//           if(m3Controller.text.length>0 && m3Controller.text!=""){
//             if(m4Controller.text.length>0 && m4Controller.text !=""){
//               if(m5Controller.text.length>0&&m5Controller.text !=""){
//                 if(m6Controller.text.length>0&&m6Controller.text!=""){
//                   if(m7Controller.text.length>0&&m7Controller.text!=""){
//                     if(droppingController.text.length>0&&droppingController.text!=''){
//                       if(fermentingTimeController.text.length>0&&fermentingTimeController.text!=''){
//                         if(m1percentController.text.length>0&&m1percentController.text!=""){
//                           if(m2percentController.text.length>0&&m2percentController.text!=""){
//                             if(m3percentController.text.length>0&&m3percentController.text!=""){
//                               if(m4percentController.text.length>0&&m4percentController.text!=""){
//                                 if(m5percentController.text.length>0&&m5percentController.text!=""){
//                                   if(m6percentController.text.length>0&&m6percentController.text!=""){
//                                     if(m7percentController.text.length>0&&m7percentController.text!=""){
//                                       confirmation();
//                                     }else{
//                                       errordialog(context, "info", "M-7 percentage should not be empty");
//                                     }
//                                   }else{
//                                     errordialog(context, "info", "M-6 percentage should not be empty");
//                                   }
//                                 }else{
//                                   errordialog(context, "info", "M-5 percentage should not be empty");
//                                 }
//                               }else{
//                                 errordialog(context, "info", "M-4 percentage should not be empty");
//                               }
//                             }else{
//                               errordialog(context, "info", "M-3 percentage should not be empty");
//                             }
//                           }else{
//                             errordialog(context, "info", "M-2 percentage should not be empty");
//                           }
//                         }else{
//                           errordialog(context, "info", "M-1 percentage should not be empty");
//                         }
//                       }else{
//                         errordialog(context, "info", "Fermenting time in minutes should not be empty");
//                       }
//                     }else{
//                       errordialog(context, "info", "dropping should not be empty");
//                     }
//                   }else{
//                     errordialog(context, "info", "M-7 should not be empty");
//                   }
//                 }else{
//                   errordialog(context, "info", "M-6 should not be empty");
//                 }
//               }else{
//                 errordialog(context, "info", "M-5 should not be empty");
//               }
//             }else{
//               errordialog(context, "info", "M-4 should not be empty");
//             }
//           }else{
//             errordialog(context, "info", "M-3 should not be empty");
//           }
//         }else{
//           errordialog(context, "info", "M-2 should not be empty");
//         }
//       }else{
//         errordialog(context, "info", "M-1 should not be empty");
//       }
//     }else{
//       errordialog(context,"info", "date should not be empty");
//     }
//
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
//               saveCFM();
//               Navigator.pop(context);
//             },
//             color: Colors.green,
//           )
//         ]).show();
//   }
//
//
//   saveCFM() async {
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
//         txntime, datas.txn_cfm, revNo, '', '', '');
//     print('custTransaction : ' + custTransaction.toString());
//     print('cfm inserting');
//
//     String ctcBatchNo = val_ctc;
//     String recNo1 = revNo.toString();
//     String isSynched="0";
//     String cfmDate= ctcdate;
//     String cfmTime=selecteddesTime.hour.toString()+ ":" + selecteddesTime.minute.toString();
//     String cfm1=m1Controller.text;
//     String cfm2=m2Controller.text;
//     String cfm3=m3Controller.text;
//     String cfm4=m4Controller.text;
//     String cfm5=m5Controller.text;
//     String cfm6=m6Controller.text;
//     String cfm7=m7Controller.text;
//     String dropping=droppingController.text;
//     String fermentingTime=fermentingTimeController.text;
//     String cfm1percent=m1percentController.text;
//     String cfm2percent=m2percentController.text;
//     String cfm3percent=m3percentController.text;
//     String cfm4percent=m4percentController.text;
//     String cfm5percent=m5percentController.text;
//     String cfm6percent=m6percentController.text;
//     String cfm7percent=m7percentController.text;
//     String latitude=Latitude;
//     String longitude=Longitude;
//
//
//     int cfmData = await db.saveCFM(
//         recNo1,
//         isSynched,
//         cfmDate,
//         cfmTime,
//         cfm1,
//         cfm2,
//         cfm3,
//         cfm4,
//         cfm5,
//         cfm6,
//         cfm7,
//         dropping,
//         fermentingTime,
//         cfm1percent,
//         cfm2percent,
//         cfm3percent,
//         cfm4percent,
//         cfm5percent,
//         cfm6percent,
//         cfm7percent,
//         latitude,
//         longitude,
//     ctcBatchNo);
//
//     print("cfm data:"+cfmData.toString());
//
//
//
//     Alert(
//       context: context,
//       type: AlertType.info,
//       title: "Transaction",
//       desc: "CFM Successful",
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
//
//
//   }
//
//
// }
//
//
