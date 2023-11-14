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
//
// class Withering extends StatefulWidget {
//   @override
//   State<StatefulWidget> createState() {
//     return _WitheringNew();
//   }
// }
//
// class _WitheringNew extends State<Withering> {
//   var db = DatabaseHelper();
//
//   String Latitude = '', Longitude = '';
//   bool ishavefarmercode = false;
//
//   List<Map> agents = [];
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
//   // 17/05/2022
//
//   TextEditingController capacityTroughController = TextEditingController();
//   TextEditingController thicknessController = TextEditingController();
//   TextEditingController inputQtyController = TextEditingController();
//   TextEditingController outputQtyController = TextEditingController();
//
//   //output
//   TextEditingController outputDateController = TextEditingController();
//   TextEditingController outputTimeController = TextEditingController();
//   TextEditingController outputcapacityTroughController =
//       TextEditingController();
//   TextEditingController outputthicknessController = TextEditingController();
//   TextEditingController outputinputQtyController = TextEditingController();
//
//   String labelCTCDate = "date";
//   String ctcdate = "";
//
//   TimeOfDay inputTime = TimeOfDay.now();
//   TimeOfDay selecteddesTime = TimeOfDay.now();
//
//   TimeOfDay outputTime = TimeOfDay.now();
//   TimeOfDay selecteddesTime1 = TimeOfDay.now();
//
//   List<DropdownModel> witheringNo = [];
//   DropdownModel? slctWitheringNo;
//   String slct_WitheringNo = "", val_WitheringNo = "";
//
//   bool outputloaded = false;
//
//   bool outputloaded1 = false;
//
//   bool inputLoaded = true;
//
//   String timeInput = "";
//   String timeOutput = "";
//
//   //31/05/22
//   List<DropdownModel> troughitem = [];
//   DropdownModel? slcttrough;
//   String val_trough = '', slct_trough = '';
//   List<UImodel> troughUIModel = [];
//
//   List<DropdownModel> Factoryitems = [];
//   DropdownModel? slctFactorys;
//   String val_Factory = '', slctFactory = '';
//   List<UImodel> factoryUIModel = [];
//
//   List<DropdownModel> batchitem = [];
//   DropdownModel? slctbatch;
//   String val_batch = '', slct_batch = '';
//   List<UImodel> batchUIModel = [];
//
//   TextEditingController availableStock = TextEditingController();
//   TextEditingController witheringBatchNo = TextEditingController();
//
//   int WitheringBatchNo = 0;
//   double availableStock1 = 0.0;
//   String WitheringBatchNoStr = '';
//
//   bool batchLoaded = false;
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
//     getLocation();
//
//     generateWitheringBatchNo();
//
//     // Random rnd = new Random();
//     // int witherNo = 100000 + rnd.nextInt(999999 - 100000);
//     // //String revNo = "CTB"+recNo.toString();
//     // String witheringNo = "W" + witherNo.toString();
//     // print("withering batch no:" + witheringNo);
//     // setState(() {
//     //   witheringBatchNo.text = witheringNo;
//     // });
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
//     // String resIdd = agents[0]['resIdSeqF'];
//     //print("resIdgetcliendata" + resIdd);
//     print("agendId_agendId" + agendId);
//   }
//
//   Future<void> initvalues() async {
//     String witheringinput = 'select recNo from witheringInput';
//     print('qry_villagelist:  ' + witheringinput);
//     List witheringList = await db.RawQuery(witheringinput);
//     print('witheringList  ' + witheringList.toString());
//     witheringNo.clear();
//
//     if (witheringList.length > 0) {
//       for (int i = 0; i < witheringList.length; i++) {
//         String recNo = witheringList[i]["recNo"].toString();
//         setState(() {
//           witheringNo.add(DropdownModel(recNo, ""));
//           outputloaded = true;
//         });
//       }
//     }
//
//     List factoryTypeList = await db.RawQuery('select * from wareHouseList');
//     print('factory type list' + factoryTypeList.toString());
//     factoryUIModel = [];
//     Factoryitems = [];
//     Factoryitems.clear();
//     for (int i = 0; i < factoryTypeList.length; i++) {
//       String property_value = factoryTypeList[i]["wareHouseName"].toString();
//       String DISP_SEQ = factoryTypeList[i]["wareHouseCode"].toString();
//
//       var uimodel = new UImodel(property_value, DISP_SEQ);
//       factoryUIModel.add(uimodel);
//       setState(() {
//         Factoryitems.add(DropdownModel(
//           property_value,
//           DISP_SEQ,
//         ));
//         //prooflist.add(property_value);
//       });
//     }
//   }
//
//   loadTroughNo(String trough) async {
//     List troughNoList = await db.RawQuery(
//         'select distinct batchNO from villageWareHouse where wareHouseCode = \'' +
//             trough +
//             '\'');
//     print('trough no List' + troughNoList.toString());
//     troughUIModel = [];
//     troughitem = [];
//     troughitem.clear();
//     for (int i = 0; i < troughNoList.length; i++) {
//       String property_value = troughNoList[i]["batchNO"].toString();
//       String DISP_SEQ = troughNoList[i]["batchNO"].toString();
//
//       var uimodel = new UImodel(property_value, DISP_SEQ);
//       troughUIModel.add(uimodel);
//       setState(() {
//         troughitem.add(DropdownModel(
//           property_value,
//           DISP_SEQ,
//         ));
//         //prooflist.add(property_value);
//       });
//     }
//   }
//
//   loadBatchNo(String troughNo) async {
//     List batchNoList = await db.RawQuery(
//         'select distinct grade from villageWarehouse where batchNO =\'' +
//             troughNo +
//             '\' and stockType = "1" and siv = "1" ');
//
//     print('batchList ' + batchNoList.toString());
//     batchUIModel = [];
//     batchitem = [];
//     batchitem.clear();
//
//     if (batchNoList.length > 0) {
//       for (int i = 0; i < batchNoList.length; i++) {
//         String vCode = batchNoList[i]["grade"].toString();
//         String vName = batchNoList[i]["grade"].toString();
//
//         var uimodel = new UImodel(vName, vCode);
//         batchUIModel.add(uimodel);
//
//         setState(() {
//           batchitem.add(DropdownModel(
//             vName,
//             vCode,
//           ));
//           //prooflist.add(property_value);
//         });
//       }
//     }
//
//     Future.delayed(Duration(milliseconds: 500), () {
//       setState(() {
//         if (batchNoList.length > 0) {
//           setState(() {
//             batchLoaded = true;
//           });
//         }
//       });
//     });
//   }
//
//   loadAvailableStock(String batchNo) async {
//     List AvailableStockList = await db.RawQuery(
//         'select netWt from villageWarehouse where grade =\'' + batchNo + '\'');
//
//     print('batchList ' + AvailableStockList.toString());
//
//     if (AvailableStockList.length > 0) {
//       for (int i = 0; i < AvailableStockList.length; i++) {
//         String avlStock = AvailableStockList[i]["netWt"].toString();
//
//         setState(() {
//           availableStock.text = avlStock;
//         });
//       }
//     }
//   }
//   // witheringInput(String witheringNo) async {
//   //   String witheringDetail =
//   //       'select * from witheringInput where recNo = \'' + witheringNo + '\'';
//   //   List witheringDetailList = await db.RawQuery(witheringDetail);
//   //   print('witheringInputList:  ' + witheringDetailList.toString());
//   //
//   //   if (witheringDetailList.length > 0) {
//   //     for (int i = 0; i < witheringDetailList.length; i++) {
//   //       String date = witheringDetailList[i]['wDate'].toString();
//   //       String time = witheringDetailList[i]['wTime'].toString();
//   //       String capTrough = witheringDetailList[i]['capacityTrough'].toString();
//   //       String thickLeaf = witheringDetailList[i]['thicknessLeaf'].toString();
//   //       String inpQty = witheringDetailList[i]['inputQty'].toString();
//   //
//   //       setState(() {
//   //         outputDateController.text = date;
//   //         outputTimeController.text = time;
//   //         outputcapacityTroughController.text = capTrough;
//   //         outputthicknessController.text = thickLeaf;
//   //         outputinputQtyController.text = inpQty;
//   //       });
//   //     }
//   //   }
//   //
//   //   Future.delayed(Duration(milliseconds: 500), () {
//   //     setState(() {
//   //       if (witheringDetailList.length > 0) {
//   //         slct_WitheringNo = '';
//   //         outputloaded = true;
//   //       }
//   //     });
//   //   });
//   // }
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
//               "Withering",
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
//
//     // if (outputloaded) {
//     //   listings
//     //       .add(txt_label_mandatory("Withering No", Colors.black, 14.0, false));
//     //
//     //   listings.add(DropDownWithModel(
//     //     itemlist: witheringNo,
//     //     selecteditem: slctWitheringNo,
//     //     hint: "Select Withering No",
//     //     onChanged: (value) {
//     //       setState(() {
//     //         slctWitheringNo = value!;
//     //         val_WitheringNo = slctWitheringNo!.value;
//     //         slct_WitheringNo = slctWitheringNo!.name;
//     //         witheringInput(slct_WitheringNo);
//     //         outputloaded1 = true;
//     //         inputLoaded = false;
//     //       });
//     //     },
//     //   ));
//     // }
//
//     // if (inputLoaded) {
//     listings.add(txt_label_mandatory("Date", Colors.black, 14.0, false));
//     listings.add(selectDate(
//       context1: context,
//       slctdate: labelCTCDate,
//       onConfirm: (date) => setState(() {
//         //HH:mm:ss
//         ctcdate = DateFormat('yyyy-MM-dd').format(date!);
//         labelCTCDate = DateFormat('yyyy-MM-dd').format(date);
//         //print('CHECKJOIINGDFATE:2 '+icsjoiningDate);
//       }),
//     ));
//
//     listings
//         .add(txt_label_mandatory("Time (Input)", Colors.black, 14.0, false));
//
//     listings.add(
//       RaisedButton(
//         color: Colors.green,
//         onPressed: () {
//           destnatTime(context);
//           print("time:" +
//               selecteddesTime.hour.toString() +
//               ":" +
//               selecteddesTime.minute.toString());
//           setState(() {
//             timeInput = selecteddesTime.hour.toString() +
//                 ":" +
//                 selecteddesTime.minute.toString();
//           });
//         },
//         child: Text("${selecteddesTime.hour}:${selecteddesTime.minute}"),
//       ),
//     );
//
//     listings.add(txt_label_mandatory("Factory", Colors.black, 14.0, false));
//
//     listings.add(DropDownWithModel(
//       itemlist: Factoryitems,
//       selecteditem: slctFactorys,
//       hint: "Select the Factory",
//       onChanged: (value) {
//         setState(() {
//           slctFactorys = value!;
//           val_Factory = slctFactorys!.value;
//           slctFactory = slctFactorys!.name;
//           print("slctFactory:" + slctFactory);
//           slcttrough = null;
//           val_trough = "";
//           slct_trough = "";
//           slctbatch = null;
//           slct_batch = "";
//           val_batch = "";
//           availableStock.clear();
//           loadTroughNo(slctFactory);
//         });
//       },
//     ));
//
//     listings.add(txt_label_mandatory("Trough No", Colors.black, 14.0, false));
//
//     listings.add(DropDownWithModel(
//       itemlist: troughitem,
//       selecteditem: slcttrough,
//       hint: "Select Trough No",
//       onChanged: (item) {
//         setState(() {
//           slcttrough = item!;
//           val_trough = slcttrough!.value;
//           slct_trough = slcttrough!.name;
//           slctbatch = null;
//           val_batch = "";
//           slct_batch = "";
//           availableStock.clear();
//           loadBatchNo(val_trough);
//           print("val trough:" + val_trough);
//         });
//       },
//     ));
//
//     listings.add(batchLoaded
//         ? txt_label_mandatory("Batch No", Colors.black, 14.0, false)
//         : Container());
//
//     listings.add(batchLoaded
//         ? DropDownWithModel(
//             itemlist: batchitem,
//             selecteditem: slctbatch,
//             hint: "Select Batch No",
//             onChanged: (item) {
//               setState(() {
//                 slctbatch = item!;
//                 val_batch = slctbatch!.value;
//                 slct_batch = slctbatch!.name;
//                 loadAvailableStock(val_batch);
//                 print("val batch:" + val_batch);
//               });
//             },
//           )
//         : Container());
//
//     listings
//         .add(txt_label_mandatory("Available Stock", Colors.black, 14.0, false));
//     listings.add(cardlable_dynamic(availableStock.text.toString()));
//
//     listings.add(txt_label_mandatory(
//         "Capacity of the trough", Colors.black, 14.0, false));
//
//     listings.add(txtfield_digits(
//         "Capacity of the trough", capacityTroughController, true));
//
//     listings.add(
//         txt_label_mandatory("Thickness of Leaf", Colors.black, 14.0, false));
//
//     listings
//         .add(txtfield_digits("Thickness of Leaf", thicknessController, true));
//
//     listings.add(txt_label_mandatory("Input Qty", Colors.black, 14.0, false));
//
//     listings.add(txtfield_digits("Input Qty", inputQtyController, true));
//     // }
//
//     // if (outputloaded1) {
//     //   listings.add(txt_label("Date", Colors.black, 25.0, false));
//     //
//     //   listings.add(txtfield_dynamic("Date", outputDateController, false));
//     //
//     //   listings.add(txt_label("Time (Input)", Colors.black, 14.0, false));
//     //
//     //   listings
//     //       .add(txtfield_dynamic("Time (Input)", outputTimeController, false));
//     //
//     //   listings
//     //       .add(txt_label("Capacity of the trough", Colors.black, 14.0, false));
//     //
//     //   listings.add(txtfield_dynamic(
//     //       "Capacity of the trough", outputcapacityTroughController, false));
//     //
//     //   listings.add(txt_label("Thickness of leaf", Colors.black, 14.0, false));
//     //
//     //   listings.add(txtfield_dynamic(
//     //       "Thickness of the leaf", outputthicknessController, false));
//     //
//     //   listings.add(txt_label("Input Qty", Colors.black, 14.0, false));
//     //
//     //   listings
//     //       .add(txtfield_dynamic("Input Qty", outputinputQtyController, false));
//
//     listings.add(txt_label_mandatory("Output Qty", Colors.black, 14.0, false));
//
//     listings.add(txtfield_digits("Output Qty", outputQtyController, true));
//
//     listings
//         .add(txt_label_mandatory("Time (Output)", Colors.black, 14.0, false));
//
//     listings.add(
//       RaisedButton(
//         color: Colors.green,
//         onPressed: () {
//           destnatTime1(context);
//           print("time:" +
//               selecteddesTime1.hour.toString() +
//               ":" +
//               selecteddesTime1.minute.toString());
//
//           setState(() {
//             timeOutput = selecteddesTime1.hour.toString() +
//                 ":" +
//                 selecteddesTime1.minute.toString();
//           });
//         },
//         child: Text("${selecteddesTime1.hour}:${selecteddesTime1.minute}"),
//       ),
//     );
//     // }
//
//     listings.add(
//         txt_label_mandatory("Withering Batch No", Colors.black, 14.0, false));
//     listings.add(cardlable_dynamic(WitheringBatchNoStr));
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
//                   btnSubmitInput();
//                   print("called withering");
//                   // if (outputloaded & outputloaded1) {
//                   //   btnSubmitOutput();
//                   // } else {
//                   //   btnSubmitInput();
//                   // }
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
//   destnatTime(BuildContext context) async {
//     final TimeOfDay? timeOfDay = await showTimePicker(
//       context: context,
//       initialTime: selecteddesTime,
//       initialEntryMode: TimePickerEntryMode.dial,
//     );
//     if (timeOfDay != null && timeOfDay != selecteddesTime) {
//       setState(() {
//         selecteddesTime = timeOfDay;
//       });
//     }
//   }
//
//   destnatTime1(BuildContext context) async {
//     final TimeOfDay? timeOfDay = await showTimePicker(
//       context: context,
//       initialTime: selecteddesTime1,
//       initialEntryMode: TimePickerEntryMode.dial,
//     );
//     if (timeOfDay != null && timeOfDay != selecteddesTime1) {
//       setState(() {
//         selecteddesTime1 = timeOfDay;
//       });
//     }
//   }
//
//   void btncancel() {
//     _onBackPressed();
//   }
//
//   void btnSubmitInput() {
//     // _progressHUD.state.show();
//     print("w called");
//     // confirmation();
//
//     if (ctcdate.isNotEmpty && ctcdate != "") {
//       if (slctFactory.isNotEmpty && slctFactory != "") {
//         if (slct_trough.isNotEmpty && slct_trough != "") {
//           if (slct_batch.isNotEmpty && slct_batch != "") {
//             if (capacityTroughController.text.isNotEmpty &&
//                 capacityTroughController.text.length > 0) {
//               if (thicknessController.text.isNotEmpty &&
//                   thicknessController.text.length > 0) {
//                 if (inputQtyController.text.isNotEmpty &&
//                     inputQtyController.text.length > 0) {
//                   if (outputQtyController.text.isNotEmpty &&
//                       outputQtyController.text.length > 0) {
//                     confirmation();
//                   } else {
//                     errordialog(
//                         context, "info", "Output Quantity should not be empty");
//                   }
//                 } else {
//                   errordialog(
//                       context, "info", "Input Quantity should not be empty");
//                 }
//               } else {
//                 errordialog(
//                     context, "info", "Thickness of leaf should not be empty");
//               }
//             } else {
//               errordialog(
//                   context, "info", "Capacity of trough should not be empty");
//             }
//           } else {
//             errordialog(context, "info", "Batch No should not be empty");
//           }
//         } else {
//           errordialog(context, "info", "Trough no should not be empty");
//         }
//       } else {
//         errordialog(context, "info", "Factory should not be empty");
//       }
//     } else {
//       errordialog(context, "info", "Date should not be empty");
//     }
//   }
//
//   // void btnSubmitOutput() {
//   //
//   //   if(val_WitheringNo.isNotEmpty && val_WitheringNo.length>0){
//   //     if(outputQtyController.text.isNotEmpty && outputQtyController.text.length>0){
//   //       if(timeOutput.isNotEmpty && timeOutput.length>0){
//   //         confirmation();
//   //       }
//   //     }
//   //   }
//   //   confirmation();
//   // }
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
//               saveWitheringInput();
//               // if (outputloaded & outputloaded1) {
//               //   saveWitheringOutput();
//               //   Navigator.pop(context);
//               // } else {
//               //   saveWitheringInput();
//               //   Navigator.pop(context);
//               // }
//             },
//             color: Colors.green,
//           )
//         ]).show();
//   }
//
//   saveWitheringInput() async {
//     Random rnd = new Random();
//     int recNo = 100000 + rnd.nextInt(999999 - 100000);
//     //String revNo = "CTB"+recNo.toString();
//     String revNo = recNo.toString();
//     final now = new DateTime.now();
//     String txntime = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
//     String msgNo = DateFormat('yyyyMMddHHmmss').format(now);
//
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     String? agentid = prefs.getString("agentId");
//     String? agentToken = prefs.getString("agentToken");
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
//     Future<List<Map>> txnHeader = db.GetTableValues('txnHeader');
//
//     //CustTransaction
//     AppDatas datas = new AppDatas();
//     int custTransaction = await db.saveCustTransaction(
//         txntime, datas.txn_withering, revNo, '', '', '');
//     print('custTransaction : ' + custTransaction.toString());
//     print('withering inserting');
//
//     String recNo1 = revNo;
//     String wDate = ctcdate;
//     String wTime = selecteddesTime.hour.toString() +
//         ":" +
//         selecteddesTime.minute.toString();
//     String troughNo = val_trough;
//     String batchNo = val_batch;
//     String avlStock = availableStock.text;
//     String capacityTrough = capacityTroughController.text;
//     String thicknessLeaf = thicknessController.text;
//     String inputQty = inputQtyController.text;
//     String outputQty = outputQtyController.text;
//     String timeOutput = selecteddesTime1.hour.toString() +
//         ":" +
//         selecteddesTime1.minute.toString();
//     String wBatchNo = WitheringBatchNoStr;
//     String latitude = Latitude;
//     String longitude = Longitude;
//     String isSynched = "0";
//     String factory = val_Factory;
//
//     int witheringInp = await db.saveWitheringInput(
//         recNo1,
//         wDate,
//         wTime,
//         troughNo,
//         batchNo,
//         avlStock,
//         capacityTrough,
//         thicknessLeaf,
//         inputQty,
//         outputQty,
//         timeOutput,
//         wBatchNo,
//         latitude,
//         longitude,
//         isSynched,
//         factory);
//
//     print("witheringInput:" + witheringInp.toString());
//
//     Alert(
//       context: context,
//       type: AlertType.info,
//       title: "Transaction",
//       desc: "Withering Successful",
//       buttons: [
//         DialogButton(
//           child: Text(
//             "OK",
//             style: TextStyle(color: Colors.white, fontSize: 20),
//           ),
//           onPressed: () {
//             Navigator.pop(context);
//             Navigator.pop(context);
//             Navigator.pop(context);
//           },
//           width: 120,
//         ),
//       ],
//     ).show();
//   }
//
//   // saveWitheringOutput() async {
//   //   Random rnd = new Random();
//   //   int recNo = 100000 + rnd.nextInt(999999 - 100000);
//   //   //String revNo = "CTB"+recNo.toString();
//   //   String revNo = recNo.toString();
//   //
//   //   final now = new DateTime.now();
//   //   String txntime = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
//   //   String msgNo = DateFormat('yyyyMMddHHmmss').format(now);
//   //   SharedPreferences prefs = await SharedPreferences.getInstance();
//   //   String? agentid = prefs.getString("agentId");
//   //   String? agentToken = prefs.getString("agentToken");
//   //   print('txnHeader ' + agentid! + "" + agentToken!);
//   //   String insqry =
//   //       'INSERT INTO "main"."txnHeader" ("isPrinted", "txnTime", "mode", "operType", "resentCount", "agentId", "agentToken", "msgNo", "servPointId", "txnRefId") VALUES ('
//   //               '0,\'' +
//   //           txntime +
//   //           '\', '
//   //               '\'02\', '
//   //               '\'01\', '
//   //               '\'0\',\'' +
//   //           agentid +
//   //           '\', \'' +
//   //           agentToken +
//   //           '\',\'' +
//   //           msgNo +
//   //           '\', \'' +
//   //           servicePointId +
//   //           '\',\'' +
//   //           slct_WitheringNo +
//   //           '\')';
//   //   print('txnHeader ' + insqry);
//   //   int succ = await db.RawInsert(insqry);
//   //   print(succ);
//   //   Future<List<Map>> txnHeader = db.GetTableValues('txnHeader');
//   //
//   //   //CustTransaction
//   //   AppDatas datas = new AppDatas();
//   //   int custTransaction = await db.saveCustTransaction(
//   //       txntime, datas.txn_withering, slct_WitheringNo, '', '', '');
//   //   print('custTransaction : ' + custTransaction.toString());
//   //   print('withering inserting');
//   //
//   //   String recNo1 = slct_WitheringNo;
//   //   String wDate = outputDateController.text;
//   //   String wTimeInput = outputTimeController.text;
//   //   String capTrough = outputcapacityTroughController.text;
//   //   String thickLeaf = outputthicknessController.text;
//   //   String inputQty = outputinputQtyController.text;
//   //   String outputQty = outputQtyController.text;
//   //   String wTimeOutput = selecteddesTime1.hour.toString() +
//   //       ":" +
//   //       selecteddesTime1.minute.toString();
//   //   String isSynched = "0";
//   //   String latitude = Latitude;
//   //   String longitude = Longitude;
//   //
//   //   int witheringOutput = await db.saveWitheringOutput(
//   //       recNo1,
//   //       wDate,
//   //       wTimeInput,
//   //       capTrough,
//   //       thickLeaf,
//   //       inputQty,
//   //       outputQty,
//   //       wTimeOutput,
//   //       isSynched,
//   //       latitude,
//   //       longitude);
//   //
//   //   List<Map> WitheringOutput = await db.GetTableValues('witheringOutput');
//   //   print("Withering Output value:" + WitheringOutput.toString());
//   //
//   //   List<Map> witheringv = await db.GetTableValues('witheringOutput');
//   //
//   //   int issync = await db.UpdateTableValue(
//   //       'witheringOutput', 'isSynched', '0', 'recNo', recNo1);
//   //
//   //   Alert(
//   //     context: context,
//   //     type: AlertType.info,
//   //     title: "Transaction",
//   //     desc: "Withering Successful",
//   //     buttons: [
//   //       DialogButton(
//   //         child: Text(
//   //           "OK",
//   //           style: TextStyle(color: Colors.white, fontSize: 20),
//   //         ),
//   //         onPressed: () {
//   //           Navigator.of(context).pushReplacement(MaterialPageRoute(
//   //               builder: (BuildContext context) => DashBoard("", "")));
//   //         },
//   //         width: 120,
//   //       ),
//   //     ],
//   //   ).show();
//   // }
//
//   void generateWitheringBatchNo() {
//     Random rnd = new Random();
//     WitheringBatchNo = 100000 + rnd.nextInt(999999 - 100000);
//     WitheringBatchNoStr = "W" + WitheringBatchNo.toString();
//   }
// }
