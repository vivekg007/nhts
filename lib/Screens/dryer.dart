// import 'dart:math';
//
// import 'package:flutter/material.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:intl/intl.dart';
// import 'package:rflutter_alert/rflutter_alert.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// import '../Database/Databasehelper.dart';
// import '../Model/dynamicfields.dart';
// import '../Utils/MandatoryDatas.dart';
// import 'navigation.dart';
//
//
// class DryerScreen extends StatefulWidget {
//   const DryerScreen({Key? key}) : super(key: key);
//
//   @override
//   State<DryerScreen> createState() => _DryerScreenState();
// }
//
//
//
//
// class _DryerScreenState extends State<DryerScreen> {
//   var db = DatabaseHelper();
//   List<Map> agents = [];
//   String seasoncode = '';
//   String servicePointId = '';
//   String agendId = '';
//   String Latitude = '', Longitude = '';
//
//
//   String labelCTCDate = "date";
//   String dryerdate = "";
//
//   TimeOfDay selectedTime = TimeOfDay.now();
//   TimeOfDay selecteddesTime = TimeOfDay.now();
//
//
//   TextEditingController dtController = new TextEditingController();
//   TextEditingController t1Controller = new TextEditingController();
//   TextEditingController t2Controller = new TextEditingController();
//   TextEditingController t3Controller = new TextEditingController();
//   TextEditingController t4Controller = new TextEditingController();
//   TextEditingController dmController = new TextEditingController();
//   TextEditingController densityController = new TextEditingController();
//   TextEditingController greenDensityController = new TextEditingController();
//   TextEditingController dryerDensityController = new TextEditingController();
//   TextEditingController teaDensityController = new TextEditingController();
//   TextEditingController outputController = new TextEditingController();
//
//
//   @override
//   void initState() {
//     super.initState();
//
//     initvalues();
//     getClientData();
//
//     getLocation();
//
//   }
//
//   void initvalues() {}
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
//   List<Widget> _getListings(BuildContext context) {
//     List<Widget> listings = [];
//
//     listings.add(txt_label_mandatory("Date",Colors.black,14.0,false));
//     listings.add(selectDate(
//       context1: context,
//       slctdate: labelCTCDate,
//       onConfirm: (date) => setState(() {//HH:mm:ss
//         dryerdate = DateFormat('dd-MM-yyyy').format(date!);
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
//     listings.add(txt_label_mandatory("D.T", Colors.black, 14.0, false));
//     listings.add(txtfield_dynamic("D.T", dtController, true));
//
//     listings.add(txt_label_mandatory("T-1", Colors.black, 14.0, false));
//     listings.add(txtfield_dynamic("T-1", t1Controller, true));
//
//     listings.add(txt_label_mandatory("T-2", Colors.black, 14.0, false));
//     listings.add(txtfield_dynamic("T-2", t2Controller, true));
//
//     listings.add(txt_label_mandatory("T-3", Colors.black, 14.0, false));
//     listings.add(txtfield_dynamic("T-3", t3Controller, true));
//
//     listings.add(txt_label_mandatory("T-4", Colors.black, 14.0, false));
//     listings.add(txtfield_dynamic("T-4", t4Controller, true));
//
//     listings.add(txt_label_mandatory("D.M", Colors.black, 14.0, false));
//     listings.add(txtfield_dynamic("D.M", dmController, true));
//
//     listings.add(txt_label_mandatory("Density", Colors.black, 14.0, false));
//     listings.add(txtfield_dynamic("Density", densityController, true));
//
//     listings.add(txt_label_mandatory("Green density", Colors.black, 14.0, false));
//     listings.add(txtfield_dynamic("Green density", greenDensityController, true));
//
//     listings.add(txt_label_mandatory("Dryer density", Colors.black, 14.0, false));
//     listings.add(txtfield_dynamic("Dryer density", dryerDensityController, true));
//
//     listings.add(txt_label_mandatory("Made tea density", Colors.black, 14.0, false));
//     listings.add(txtfield_dynamic("Made tea density", teaDensityController, true));
//
//     listings.add(txt_label_mandatory("Output", Colors.black, 14.0, false));
//     listings.add(txtfield_dynamic("Output", outputController, true));
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
//     return listings;
//
//   }
//
//
//
//   void destnatTime(BuildContext context) {
//     destnatTime(BuildContext context) async {
//       final TimeOfDay? timeOfDay = await showTimePicker(
//         context: context,
//         initialTime: selecteddesTime,
//         initialEntryMode: TimePickerEntryMode.dial,
//
//       );
//       if(timeOfDay != null && timeOfDay != selecteddesTime)
//       {
//         setState(() {
//           selecteddesTime = timeOfDay;
//         });
//       }
//     }
//   }
//
//   void btnSubmit() {
//     if(labelCTCDate.isNotEmpty && labelCTCDate !=""){
//       if(dtController.text.length>0 && dtController.text!=""){
//         if(t1Controller.text.length>0 && t1Controller.text!=""){
//           if(t2Controller.text.length>0 && t2Controller.text!=""){
//             if(t3Controller.text.length>0 && t3Controller.text!=""){
//               if(t4Controller.text.length>0 && t4Controller.text!=""){
//                 if(dmController.text.length>0 && dmController.text!=""){
//                   if(densityController.text.length>0 && densityController.text!=""){
//                     if(greenDensityController.text.length>0 && greenDensityController.text!=""){
//                       if(dryerDensityController.text.length>0 && dryerDensityController.text!=""){
//                         if(teaDensityController.text.length>0 && teaDensityController.text!=""){
//                           if(outputController.text.length>0 && outputController.text!=""){
//                             confirmation();
//
//                           }else{
//                             errordialog(context,"info", "Output should not be empty");
//                           }
//                         }else{
//                           errordialog(context,"info", "Made tea density should not be empty");
//                         }
//                       }else{
//                         errordialog(context,"info", "Dryer density should not be empty");
//                       }
//                     }else{
//                       errordialog(context,"info", "Green density should not be empty");
//                     }
//                   }else{
//                     errordialog(context,"info", "Density should not be empty");
//                   }
//                 }else{
//                   errordialog(context,"info", "D.M should not be empty");
//                 }
//               }else{
//                 errordialog(context,"info", "T-4 should not be empty");
//               }
//             }else{
//               errordialog(context,"info", "T-3 should not be empty");
//             }
//           }else{
//             errordialog(context,"info", "T-2 should not be empty");
//           }
//         }else{
//           errordialog(context,"info", "T-1 should not be empty");
//         }
//       }else{
//         errordialog(context,"info", "D.T should not be empty");
//       }
//     }else{
//       errordialog(context,"info", "date should not be empty");
//     }
//
//     }
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
//               saveDryer();
//               Navigator.pop(context);
//             },
//             color: Colors.green,
//           )
//         ]).show();
//   }
//
//   void saveDryer() async{
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
//         txntime, datas.txn_dryer, revNo, '', '', '');
//     print('custTransaction : ' + custTransaction.toString());
//     print('dryer inserting');
//
//     String recNo1 = revNo.toString();
//     String isSynched="0";
//     String dryerDate= dryerdate;
//     String dryerTime=selecteddesTime.hour.toString()+ ":" + selecteddesTime.minute.toString();
//     String dt=dtController.text;
//     String t1=t1Controller.text;
//     String t2=t2Controller.text;
//     String t3=t3Controller.text;
//     String t4=t4Controller.text;
//     String dm=dmController.text;
//     String density=densityController.text;
//     String greenDensity=greenDensityController.text;
//     String dryerDensity=dryerDensityController.text;
//     String teaDensity=teaDensityController.text;
//     String output=outputController.text;
//     String latitude=Latitude;
//     String longitude=Longitude;
//
//     int dryerData = await db.saveDryer(
//         recNo1,
//         isSynched,
//         dryerDate,
//         dryerTime,
//         dt,
//         t1,
//         t2,
//         t3,
//         t4,
//         dm,
//         density,
//         greenDensity,
//         dryerDensity,
//         teaDensity,
//         output,
//         latitude,
//         longitude
//     );
//
//     print("dryer data:"+dryerData.toString());
//
//     Alert(
//       context: context,
//       type: AlertType.info,
//       title: "Transaction",
//       desc: "Dryer Successful",
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
//
//   }
// }
//
