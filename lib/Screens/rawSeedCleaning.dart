// import 'dart:io';
// import 'dart:math';
//
// import 'package:flutter/material.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:intl/intl.dart';
// import 'package:rflutter_alert/rflutter_alert.dart';
// import 'package:shared_preferences/shared_preferences.dart';
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
// import 'navigation.dart';
//
// class RawSeedCleaning extends StatefulWidget {
//   const RawSeedCleaning({Key? key}) : super(key: key);
//
//   @override
//   State<RawSeedCleaning> createState() => _RawSeedCleaningState();
// }
//
// class _RawSeedCleaningState extends State<RawSeedCleaning> {
//   String Lat = '', Lng = '';
//   String info = 'Information';
//   String servicePointId = '0';
//   String cancel = 'Cancel';
//   String rusurecancel = 'Are you sure want to cancel?';
//   String yes = 'Yes';
//   String no = 'No';
//   String ok = 'OK';
//   String success = 'Success !';
//   String confirm = 'Confirmation';
//   String proceed = 'Are you sure you want to Proceed?';
//   bool varietyload=true;
//   String seasoncode = '0';
//   String agentCode = '0';
//   List<Map> agents = [];
//   var db = DatabaseHelper();
//   String depatureDate = "";
//   String dateOfReception = "";
//   String depatureFormatedDate = "";
//   String receptionFormatedDate = "";
//   double autoNetWeight = 0;
//   double autoRecNetWeight = 0;
//
//   var Availtareweight,AvailgrossWeight,AvailnoOfBags,varietyCode,warehouseCode;
//
//   List<UImodel> varietyUIModel = [];
//   List<UImodel> generationUIModel = [];
//   List<UImodel> warehouseUIModel = [];
//   List<UImodel> destinationUIModel = [];
//   List<UImodel> cleaningUIModel = [];
//
//   List<UImodel> lotUIModel = [];
//
//   TextEditingController sivnController = new TextEditingController();
//   TextEditingController vehicleGrossController = new TextEditingController();
//   TextEditingController vehicleTareController = new TextEditingController();
//   TextEditingController noOfBagsController = new TextEditingController();
//   TextEditingController repNameController = new TextEditingController();
//   TextEditingController phoneNumController = new TextEditingController();
//   TextEditingController transportSerController = new TextEditingController();
//   TextEditingController driverNameController = new TextEditingController();
//   TextEditingController driverPhoneController = new TextEditingController();
//   TextEditingController plateNumController = new TextEditingController();
//   TextEditingController getInTicketController = new TextEditingController();
//   TextEditingController gatePassController = new TextEditingController();
//   TextEditingController repReceptionNameController =
//       new TextEditingController();
//   TextEditingController recVehicleWeightController =
//       new TextEditingController();
//   TextEditingController recVehicleTreController = new TextEditingController();
//   TextEditingController recNoOfBagsController = new TextEditingController();
//   TextEditingController grnController = new TextEditingController();
//   TextEditingController vareityCntrl = new TextEditingController();
//   TextEditingController warehouseCntrl = new TextEditingController();
//
//   String slctVrtyp = '', slctVartypId = '';
//   String slctGenrationtyp = '', slctGenrationtypId = '';
//   String slctWarehousetyp = '', slctWarehousetypId = '';
//   String slctDestinationtyp = '', slctDestinationtypId = '';
//   String slctCleaningCentyp = '', slctCleaningCentypId = '';
//   File? weightBridgeImageFile;
//   File? grnImageFile;
//
//   String slctLotName = '', slctLotValue = '';
//
//   String save = 'Save';
//   String chse = 'Choose';
//   String galry = 'Gallery';
//   String pickimg = 'Pick Image';
//   String Camera = 'Camera';
//   String deny = 'deny';
//   String onlytym = 'only this time';
//   String whiluseapp = 'While using the app ';
//   String Allowtakepic = 'Allow IronKettle to take picture and record video?';
//   String lotSpecification = 'Lot specification';
//   String cleaningUnit = 'Cleaning unit of reception';
//   String cleaningCenter = 'Name of cleaning center';
//   String receptionDate = 'Date of reception';
//   String variety = 'Variety Name';
//   String varietyHint = 'Select the Variety';
//   String destinationHint = 'Select the Destination';
//   String generation = 'Generation';
//   String generationHint = 'Select the Generation';
//   String warehouseHint = 'Select Warehouse of Departure';
//   String cleaningCenHint = 'Select Cleaning Center';
//   String warehouseDeparture = 'Warehouse of departure';
//   String warehouseName = 'Warehouse Name';
//   String dateOfDepature = 'Date of departure';
//   String sivn = 'SIV N°';
//   String vehicleGross = 'Vehicle Gross weight (kg)';
//   String vehicletare = 'Vehicle Tare (kg)';
//   String netWeight = 'Net Weight';
//   String noOfBags = 'No of bags';
//   String destination = 'Destination';
//   String repName = 'Representative name at reception';
//   String phoneNumber = 'Phone N°';
//   String transportService = 'Transport service provider';
//   String driverName = 'Driver Name';
//   String driverPhoneNum = 'Driver phone N°';
//   String plateNum = 'Plate N°';
//   String ticketNum = 'Get in Ticket N°';
//   String gatePassTicketNum = 'Gate pass Ticket N°';
//   String grnNum = 'GRN N°';
//   String receptionName = 'Representative name at reception';
//
//   String infoLotempty = 'Lot specification should not be empty';
//   String infovarietyName = 'Variety Name should not be empty';
//   String infoGeneration = 'Generation should not be empty';
//   String infoWarehouseName = 'Warehouse Name should not be empty';
//   String infoDepatureDate = 'Date of depature should not be empty';
//   String infoSiv = 'SIV N° should not be empty';
//   String infoVehicleGross = 'Vehicle Gross weight (kg) should not be empty';
//   String infoVehicleTare = 'Vehicle Tare weight (kg) should not be empty';
//   String vehiclelesthvaldat="Vehicle Tare(kg) should be less than Vehicle Gross weight(kg)";
//   String vehiclegrosswght="Vehicle Gross weight(kg) should be less than Available Gross weight";
//   String vehicletarewght="Vehicle Tare(kg) should be less than Available Tare weight";
//   String availvehiclegrosswght="Vehicle Gross weight(kg) should be less than Available Vehicle Gross weight(kg)";
//   String availvehicletarewght="Vehicle Tare(kg) should be less than Available Vehicle Tare(kg)";
//   String availNofbags="No of Bags should be less than Available No of Bags";
//   String infoNetWeight = 'Net Weight should not be empty';
//   String infoNoOfBags = 'No of bags should not be empty';
//   String infoDestination = 'Destination should not be empty';
//   String infoRepName = 'Representative name at reception should not be empty';
//   String infoPhoneNum = 'Phone N° should not be empty';
//   String infoTransportSer = 'Transport service provider should not be empty';
//   String infoDriverName = 'Driver Name should not be empty';
//   String infoDriverPhone = 'Driver phone N° should not be empty';
//   String infoPlateNum = 'Plate N° should not be empty';
//   String infoGetInTicket = 'Get In Ticket N° should not be empty';
//   String infoGatePassTickt = 'Gate Pass Ticket N° should not be empty';
//   String infoCleaningCen = 'Name of cleaning center should not be empty';
//   String infoRecDate = 'Date of reception should not be empty';
//   String infoGrnNo = 'GRN N° should not be empty';
//
//   List<DropdownModel> varietyitems = [];
//   DropdownModel? slctvarietys;
//
//   List<DropdownModel> cleaningCenteritems = [];
//   DropdownModel? slctCleaningCenter;
//
//   List<DropdownModel> generationItems = [];
//   DropdownModel? slctGeneration;
//
//   List<DropdownModel> warehouseItems = [];
//   DropdownModel? slctWarehouse;
//
//   List<DropdownModel> destinationItems = [];
//   DropdownModel? slctDestination;
//
//   List<DropdownModel> lotitems = [];
//   DropdownModel? slctlot;
//   @override
//   void initState() {
//     super.initState();
//     initdata();
//     getLocation();
//     getClientData();
//   }
//
//   Future<void> initdata() async {
//     loadLotspec();
//     loadVarieties();
//     loadGeneration();
//     loadWarehouse();
//     loadDestination();
//     loadCleaningCenter();
//
//     vehicleGrossController.addListener(() {
//       autoGenNetWeight();
//     });
//     vehicleTareController.addListener(() {
//       autoGenNetWeight();
//     });
//
//
//     recVehicleWeightController.addListener(() {
//       autoGenRecNetWeight();
//     });
//     recVehicleTreController.addListener(() {
//       autoGenRecNetWeight();
//     });
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
//       Alert(
//           context: context,
//           title: info,
//           desc: "GPS Location not enabled",
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
//   getClientData() async {
//     agents = await db.RawQuery('SELECT * FROM agentMaster');
//     seasoncode = agents[0]['currentSeasonCode'];
//     servicePointId = agents[0]['servicePointId'];
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
//               'Raw Seed Transfer',
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
//   List<Widget> _getListings(BuildContext context) {
//     List<Widget> listings = [];
//
//     /*listings
//         .add(txt_label_mandatory(lotSpecification, Colors.green, 18.0, true));*/
//
//     listings.add(txt_label_mandatory(lotSpecification, Colors.black, 14.0, false));
//     listings.add(DropDownWithModel(
//         itemlist: lotitems,
//         selecteditem: slctlot,
//         hint: "Select the Lot Specification",
//         onChanged: (value) {
//           setState(() {
//             slctlot = value!;
//             slctLotValue = slctlot!.value;
//             slctLotName = slctlot!.name;
//             loadstocktype(slctLotValue);
//           });
//         },
//         onClear: () {
//           setState(() {
//             slctLotValue = '';
//           });
//         }));
//
//     listings.add(txt_label_mandatory(variety, Colors.black, 14.0, false));
//     listings.add(txtfield_dynamic(variety, vareityCntrl,false, 25));
//     /*  listings.add(txt_label_mandatory(variety, Colors.black, 14.0, false));
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
//           }));*/
//
//     listings.add(txt_label_mandatory(generation, Colors.black, 14.0, false));
//     listings.add(DropDownWithModel(
//         itemlist: generationItems,
//         selecteditem: slctGeneration,
//         hint: generationHint,
//         onChanged: (value) {
//           setState(() {
//             slctGeneration = value!;
//             slctGenrationtypId = slctGeneration!.value;
//             slctGenrationtyp = slctGeneration!.name;
//           });
//         },
//         onClear: () {
//           setState(() {
//             slctGenrationtyp = '';
//           });
//         }));
//
//     listings
//         .add(txt_label_mandatory(warehouseDeparture, Colors.green, 18.0, true));
//
//     listings.add(txt_label_mandatory(warehouseName, Colors.black, 14.0, false));
//     listings.add(txtfield_dynamic(warehouseName, warehouseCntrl,false, 25));
//
//    /* listings.add(txt_label_mandatory(warehouseName, Colors.black, 14.0, false));
//     listings.add(DropDownWithModel(
//         itemlist: warehouseItems,
//         selecteditem: slctWarehouse,
//         hint: warehouseHint,
//         onChanged: (value) {
//           setState(() {
//             slctWarehouse = value!;
//             slctWarehousetypId = slctWarehouse!.value;
//             slctWarehousetyp = slctWarehouse!.name;
//           });
//         },
//         onClear: () {
//           setState(() {
//             slctWarehousetyp = '';
//           });
//         }));*/
//
//     listings.add(txt_label_mandatory(dateOfDepature, Colors.black, 14.0, false));
//     listings.add(selectDate(
//         context1: context,
//         slctdate: depatureFormatedDate,
//         onConfirm: (date) => setState(
//               () {
//                 depatureDate = DateFormat('dd-MM-yyyy HH:mm:ss').format(date!);
//                 depatureFormatedDate = DateFormat('dd-MM-yyyy').format(date);
//               },
//             )));
//
//     listings.add(txt_label_mandatory(sivn, Colors.black, 14.0, false));
//     listings.add(txtfield_digits(sivn, sivnController, true,4));
//
//     listings.add(txt_label_mandatory(vehicleGross, Colors.black, 14.0, false));
//     listings.add(txtfield_digits(vehicleGross, vehicleGrossController, false,8));
//
//     listings.add(txt_label_mandatory(vehicletare, Colors.black, 14.0, false));
//     listings.add(txtfield_digits(vehicletare, vehicleTareController, false,8));
//
//     listings.add(txt_label_mandatory(netWeight, Colors.black, 14.0, false));
//
//     listings.add(cardlable_dynamic(autoNetWeight.toString()));
//
//     listings.add(txt_label_mandatory(noOfBags, Colors.black, 14.0, false));
//     listings.add(txtfield_digits(noOfBags, noOfBagsController, false,4));
//
//     listings.add(txt_label_mandatory(destination, Colors.black, 14.0, false));
//     listings.add(DropDownWithModel(
//         itemlist: destinationItems,
//         selecteditem: slctDestination,
//         hint: destinationHint,
//         onChanged: (value) {
//           setState(() {
//             slctDestination = value!;
//             slctDestinationtypId = slctDestination!.value;
//             slctDestinationtyp = slctDestination!.name;
//           });
//         },
//         onClear: () {
//           setState(() {
//             slctDestinationtyp = '';
//           });
//         }));
//
//     listings.add(txt_label_mandatory(repName, Colors.black, 14.0, false));
//     listings.add(txtfield_dynamic(repName, repNameController, true,25));
//
//     listings.add(txt_label_mandatory(phoneNumber, Colors.black, 14.0, false));
//     listings.add(txtfield_withcharacterdigits(phoneNumber, phoneNumController, true,13));
//
//     listings
//         .add(txt_label_mandatory(transportService, Colors.black, 14.0, false));
//     listings
//         .add(txtfield_dynamic(transportService, transportSerController, true,25));
//
//     listings.add(txt_label_mandatory(driverName, Colors.black, 14.0, false));
//     listings.add(txtfield_dynamic(driverName, driverNameController, true,25));
//
//     listings
//         .add(txt_label_mandatory(driverPhoneNum, Colors.black, 14.0, false));
//     listings.add(txtfield_withcharacterdigits(driverPhoneNum, driverPhoneController, true,13));
//
//     listings.add(txt_label_mandatory(plateNum, Colors.black, 14.0, false));
//     listings.add(txtfield_dynamic(plateNum, plateNumController, true,15));
//
//     listings.add(txt_label_mandatory(ticketNum, Colors.black, 14.0, false));
//     listings.add(txtfield_digits(ticketNum, getInTicketController, true,4));
//
//     listings
//         .add(txt_label_mandatory(gatePassTicketNum, Colors.black, 14.0, false));
//     listings.add(txtfield_digits(gatePassTicketNum, gatePassController, true,4));
//
//    /* listings.add(txt_label_mandatory(cleaningUnit, Colors.green, 18.0, true));
//
//     listings
//         .add(txt_label_mandatory(cleaningCenter, Colors.black, 14.0, false));
//     listings.add(DropDownWithModel(
//         itemlist: cleaningCenteritems,
//         selecteditem: slctCleaningCenter,
//         hint: cleaningCenHint,
//         onChanged: (value) {
//           setState(() {
//             slctCleaningCenter = value!;
//             slctCleaningCentypId = slctCleaningCenter!.value;
//             slctCleaningCentyp = slctCleaningCenter!.name;
//           });
//         },
//         onClear: () {
//           setState(() {
//             slctCleaningCentyp = '';
//           });
//         }));
//
//     listings.add(txt_label_mandatory(receptionDate, Colors.black, 14.0, false));
//     listings.add(selectDate(
//         context1: context,
//         slctdate: receptionFormatedDate,
//         onConfirm: (date) => setState(
//               () {
//                 dateOfReception = DateFormat('dd-MM-yyyy HH:mm:ss').format(date!);
//                 receptionFormatedDate = DateFormat('dd-MM-yyyy').format(date);
//               },
//             )));
//
//     listings.add(txt_label_mandatory(grnNum, Colors.black, 14.0, false));
//     listings.add(txtfield_digits(grnNum, grnController, true,4));
//
//     listings.add(txt_label_mandatory(repName, Colors.black, 14.0, false));
//     listings.add(txtfield_dynamic(repName, repReceptionNameController, true,25));
//
//     listings.add(txt_label_mandatory(vehicleGross, Colors.black, 14.0, false));
//     listings
//         .add(txtfield_digits(vehicleGross, recVehicleWeightController, true,8));
//
//     listings.add(txt_label_mandatory(vehicletare, Colors.black, 14.0, false));
//     listings.add(txtfield_digits(vehicletare, recVehicleTreController, true,8));
//
//     listings.add(txt_label_mandatory(netWeight, Colors.black, 14.0, false));
//
//     listings.add(cardlable_dynamic(autoRecNetWeight.toString()));
//
//     listings.add(txt_label_mandatory(noOfBags, Colors.black, 14.0, false));
//     listings.add(txtfield_digits(noOfBags, recNoOfBagsController, true,8));
//
//     listings
//         .add(txt_label('Photo of weighbridge slip', Colors.black, 14.0, false));
//     listings.add(img_picker(
//         label: 'Photo of weighbridge slip',
//         onPressed: () {
//           imageDialog("weightbridge");
//         },
//         filename: weightBridgeImageFile,
//         ondelete: () {
//           ondelete("weightbridge");
//         }));
//
//     listings.add(txt_label('Photo GRN', Colors.black, 14.0, false));
//     listings.add(img_picker(
//         label: 'Photo GRN',
//         onPressed: () {
//           imageDialog("grn");
//         },
//         filename: grnImageFile,
//         ondelete: () {
//           ondelete("grn");
//         }));*/
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
//   void loadVarieties() async{
//     varietyUIModel = [];
//     varietyitems.clear();
//     String varietyQry =
//         'select * from animalCatalog where catalog_code =\'39\'';
//     List varietyList = await db.RawQuery(varietyQry);
//     for (int i = 0; i < varietyList.length; i++) {
//       String property_value = varietyList[i]["property_value"].toString();
//       String DISP_SEQ = varietyList[i]["DISP_SEQ"].toString();
//       var uimodel = new UImodel(property_value, DISP_SEQ);
//       varietyUIModel.add(uimodel);
//       setState(() {
//         varietyitems.add(DropdownModel(
//           property_value,
//           DISP_SEQ,
//         ));
//         //prooflist.add(property_value);
//       });
//     }
//   }
//
//   void loadLotspec() async{
//     lotUIModel = [];
//     lotitems.clear();
//     String lotQry =
//         'select * from villageWarehouse where stockType=\'1\'';
//     List lotList = await db.RawQuery(lotQry);
//     for (int i = 0; i < lotList.length; i++) {
//       String property_value = lotList[i]["batchNO"].toString();
//       String DISP_SEQ = lotList[i]["batchNO"].toString();
//       var uimodel = new UImodel(property_value, DISP_SEQ);
//       lotUIModel.add(uimodel);
//       setState(() {
//         lotitems.add(DropdownModel(
//           property_value,
//           property_value,
//         ));
//         //prooflist.add(property_value);
//       });
//     }
//   }
// loadstocktype(String stocktype) async {
//   List stockTypelist = await db.RawQuery(
//       'select * from villageWarehouse where batchNO =\'' + stocktype + '\'');
//   print('stockTypelist ' + stockTypelist.toString());
//   for (int i = 0; i < stockTypelist.length; i++) {
//     Availtareweight = stockTypelist[0]["tareWt"].toString();
//     AvailgrossWeight = stockTypelist[0]["grossWeight"].toString();
//     AvailnoOfBags = stockTypelist[0]["noOfBags"].toString();
//     vehicleTareController.text=Availtareweight;
//     vehicleGrossController.text=AvailgrossWeight;
//     noOfBagsController.text=AvailnoOfBags;
//     varietyCode = stockTypelist[0]["varietyCode"];
//     warehouseCode = stockTypelist[0]["warehouseCode"];
//   }
//
//   List varietyTypelist = await db.RawQuery(
//       'select * from varietyList where vCode =\'' + varietyCode + '\'');
//   print('varietyTypelist ' + varietyTypelist.toString());
//   vareityCntrl.text=varietyTypelist[0]["vName"].toString();
//
//
//   List warehouseTypelist = await db.RawQuery(
//       'select * from coOperative where coCode =\'' + warehouseCode + '\'');
//   print('warehouseTypelist ' + warehouseTypelist.toString());
//   warehouseCntrl.text=warehouseTypelist[0]["coName"].toString();
//
// }
//   void loadGeneration() async{
//     generationUIModel = [];
//     generationItems.clear();
//     String varietyQry =
//         'select * from animalCatalog where catalog_code =\'8\'';
//     List generationList = await db.RawQuery(varietyQry);
//     for (int i = 0; i < generationList.length; i++) {
//       String property_value = generationList[i]["property_value"].toString();
//       String DISP_SEQ = generationList[i]["DISP_SEQ"].toString();
//       var uimodel = new UImodel(property_value, DISP_SEQ);
//       generationUIModel.add(uimodel);
//       setState(() {
//         generationItems.add(DropdownModel(
//           property_value,
//           DISP_SEQ,
//         ));
//         //prooflist.add(property_value);
//       });
//     }
//   }
//
//   void loadWarehouse() async{
//     warehouseUIModel = [];
//     warehouseItems.clear();
//     String warehouseQry =
//         'select * from animalCatalog where catalog_code =\'44\'';
//     List warehouseList = await db.RawQuery(warehouseQry);
//     for (int i = 0; i < warehouseList.length; i++) {
//       String property_value = warehouseList[i]["property_value"].toString();
//       String DISP_SEQ = warehouseList[i]["DISP_SEQ"].toString();
//       var uimodel = new UImodel(property_value, DISP_SEQ);
//       warehouseUIModel.add(uimodel);
//       setState(() {
//         warehouseItems.add(DropdownModel(
//           property_value,
//           DISP_SEQ,
//         ));
//         //prooflist.add(property_value);
//       });
//     }
//   }
//
//
//   void loadDestination() async{
//     destinationUIModel = [];
//     destinationItems.clear();
//     String destinationQry =
//         'select * from animalCatalog where catalog_code =\'6\'';
//     List destinationList = await db.RawQuery(destinationQry);
//     for (int i = 0; i < destinationList.length; i++) {
//       String property_value = destinationList[i]["property_value"].toString();
//       String DISP_SEQ = destinationList[i]["DISP_SEQ"].toString();
//       var uimodel = new UImodel(property_value, DISP_SEQ);
//       destinationUIModel.add(uimodel);
//       setState(() {
//         destinationItems.add(DropdownModel(
//           property_value,
//           DISP_SEQ,
//         ));
//         //prooflist.add(property_value);
//       });
//     }
//   }
//
//   void loadCleaningCenter() async{
//     cleaningUIModel = [];
//     cleaningCenteritems.clear();
//     String cleaningCenterQry =
//         'select * from coOperative where coType = \'' + "2" + '\'';
//     List cleaningList = await db.RawQuery(cleaningCenterQry);
//     for (int i = 0; i < cleaningList.length; i++) {
//       String property_value = cleaningList[i]["coName"].toString();
//       String DISP_SEQ = cleaningList[i]["coCode"].toString();
//       var uimodel = new UImodel(property_value, DISP_SEQ);
//       cleaningUIModel.add(uimodel);
//       setState(() {
//         cleaningCenteritems.add(DropdownModel(
//           property_value,
//           DISP_SEQ,
//         ));
//         //prooflist.add(property_value);
//       });
//     }
//   }
//
//   void autoGenNetWeight() {
//       double vehicleGr=0,vehicleTar=0;
//
//     if (vehicleGrossController.text.length > 0)
//       {
//         vehicleGr =double.parse(vehicleGrossController.text);
//       }
//       if (vehicleTareController.text.length > 0)
//       {
//         vehicleTar =double.parse(vehicleTareController.text);
//       }
//
//     setState(() {
//       double valcalcontroller = vehicleGr-vehicleTar;
//       autoNetWeight = valcalcontroller;
//     });
//   }
//
//   void autoGenRecNetWeight() {
//
//     double vehicleGr=0,vehicleTar=0;
//
//     if (recVehicleWeightController.text.length > 0)
//     {
//       vehicleGr =double.parse(recVehicleWeightController.text);
//     }
//     if (recVehicleTreController.text.length > 0)
//     {
//       vehicleTar =double.parse(recVehicleTreController.text);
//     }
//
//     setState(() {
//       double valcalcontroller = vehicleGr-vehicleTar;
//       autoRecNetWeight = valcalcontroller;
//     });
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
//                 getImageFromGallery(photo);
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
//               getImageFromCamera(photo);
//               Navigator.pop(context);
//             },
//             color: Colors.green,
//           )
//         ]).show();
//   }
//
//   Future getImageFromGallery(String photo) async {
//     var image = await ImagePicker.platform
//         .pickImage(source: ImageSource.gallery, imageQuality: 30);
//     setState(() {
//       if (photo == "weightbridge") {
//         weightBridgeImageFile = File(image!.path);
//       } else if (photo == "grn") {
//         grnImageFile = File(image!.path);
//       }
//     });
//   }
//
//   Future getImageFromCamera(String photo) async {
//     var image = await ImagePicker.platform
//         .pickImage(source: ImageSource.camera, imageQuality: 30);
//     setState(() {
//       if (photo == "weightbridge") {
//         weightBridgeImageFile = File(image!.path);
//       } else if (photo == "grn") {
//         grnImageFile = File(image!.path);
//       }
//     });
//   }
//
//   void ondelete(String photo) {
//     setState(() {
//       if (photo == "weightbridge") {
//         if (weightBridgeImageFile != null) {
//           setState(() {
//             weightBridgeImageFile = null;
//           });
//         }
//       } else if (photo == "grn") {
//         if (grnImageFile != null) {
//           setState(() {
//             grnImageFile = null;
//           });
//         }
//       }
//     });
//   }
//
//   void btncancel() {}
//
//   void btnSubmit() {
//     if (slctLotValue.length > 0 || slctLotValue != '') {
//     if (slctGenrationtyp.length > 0 || slctGenrationtyp != '') {
//       if (depatureDate.length > 0 || depatureDate != '') {
//         if (sivnController.text.length > 0 || sivnController.text != '') {
//           if (vehicleGrossController.text.length > 0 || vehicleGrossController.text != '') {
//             if (vehicleTareController.text.length > 0 || vehicleTareController.text != '') {
//               if (autoNetWeight.toString().length > 0 || autoNetWeight.toString() != '') {
//                 if (noOfBagsController.text.length > 0 || noOfBagsController.text != '') {
//                   if (slctDestinationtyp.length > 0 || slctDestinationtyp != '') {
//                     if (repNameController.text.length > 0 || repNameController.text != '') {
//                       if (phoneNumController.text.length > 0 || phoneNumController.text != '') {
//                         if (transportSerController.text.length > 0 || transportSerController.text != '') {
//                           if (driverNameController.text.length > 0 || driverNameController.text != '') {
//                             if (driverPhoneController.text.length > 0 || driverPhoneController.text != '') {
//                               if (plateNumController.text.length > 0 || plateNumController.text != '') {
//                                 if (getInTicketController.text.length > 0 || getInTicketController.text != '') {
//                                   if (gatePassController.text.length > 0 || gatePassController.text != '') {
//                                     /*  if (slctCleaningCentyp.length > 0 || slctCleaningCentyp != '') {
//                                        if (dateOfReception.length > 0 || dateOfReception != '') {
//                                         if (grnController.text.length > 0 || grnController.text != '') {
//                                           if (repReceptionNameController.text.length > 0 || repReceptionNameController.text != '') {
//                                             if (recVehicleWeightController.text.length > 0 || recVehicleWeightController.text != '') {
//                                               if (recVehicleTreController.text.length > 0 || recVehicleTreController.text != '') {
//                                                if (recNoOfBagsController.text.length > 0 || recNoOfBagsController.text != '') {
//                                                if(num.parse(recVehicleWeightController.text)<=num.parse(vehicleGrossController.text)){
//                                                  if(num.parse(recVehicleTreController.text)<=num.parse(vehicleTareController.text)){
//                                                    if(num.parse(recVehicleTreController.text)<=num.parse(recVehicleWeightController.text)){
//                                                      if(num.parse(vehicleTareController.text)<=num.parse(Availtareweight)){
//                                                        if(num.parse(vehicleGrossController.text)<=num.parse(AvailgrossWeight)){
//                                                          if(num.parse(noOfBagsController.text)<=num.parse(AvailnoOfBags)){
//                                                            if(num.parse(vehicleTareController.text)<=num.parse(vehicleGrossController.text)){
//                                                              if(num.parse(recNoOfBagsController.text)<=num.parse(noOfBagsController.text)){*/
//                                                                        confirmationPopupp();
//
//                                                  /* } else {
//                                                     errordialog(context, info, availNofbags);
//                                                   }
//                                                   } else {
//                                                     errordialog(context, info, vehiclelesthvaldat);
//                                                   }
//                                                   } else {
//                                                     errordialog(context, info, availNofbags);
//                                                   }
//                                                   } else {
//                                                     errordialog(context, info, vehiclegrosswght);
//                                                   }
//                                                   } else {
//                                                     errordialog(context, info, vehicletarewght);
//                                                   }
//                                                   } else {
//                                                     errordialog(context, info, vehiclelesthvaldat);
//                                                   }
//                                                   } else {
//                                                     errordialog(context, info, availvehicletarewght);
//                                                   }
//                                                   } else {
//                                                     errordialog(context, info, availvehiclegrosswght);
//                                                   }*/
//                                                  /* }else {
//                                                   errordialog(context, info, infoNoOfBags);
//                                                    }
//                                                   } else {
//                                                   errordialog(context, info, infoVehicleTare);
//                                                    }
//                                                   } else {
//                                                      errordialog(context, info, infoVehicleGross);
//                                                    }
//                                                   } else {
//                                                     errordialog(context, info, infoRepName);
//                                                    }
//                                                   } else {
//                                                    errordialog(context, info, infoGrnNo);
//                                                    }
//                                                   } else {
//                                                   errordialog(context, info, infoRecDate);
//                                                    }
//                                                   } else {
//                                                   errordialog(context, info, infoCleaningCen);
//                                                       }*/
//                                                   } else {
//                                                      errordialog(context, info, infoGatePassTickt);
//                                                   }
//                                                   } else {
//                                                      errordialog(context, info, infoGetInTicket);
//                                                   }
//                                                   } else {
//                                                       errordialog(context, info, infoPlateNum);
//                                                   }
//                                                   } else {
//                                                        errordialog(context, info, infoDriverPhone);
//                                                    }
//                                                    } else {
//                                                         errordialog(context, info, infoDriverName);
//                                                    }
//                                                    } else {
//                                                       errordialog(context, info, infoTransportSer);
//                                                    }
//                                                    } else {
//                                                           errordialog(context, info, infoPhoneNum);
//                                                    }
//                                                    } else {
//                                                       errordialog(context, info, infoRepName);
//                                                     }
//                                                     } else {
//                                                       errordialog(context, info, infoDestination);
//                                                     }
//                                                     } else {
//                                                       errordialog(context, info, infoNoOfBags);
//                                                     }
//                                                     } else {
//                                                       errordialog(context, info, infoNetWeight);
//                                                     }
//                                                     } else {
//                                                       errordialog(context, info, infoVehicleTare);
//                                                     }
//                                                     } else {
//                                                       errordialog(context, info, infoVehicleGross);
//                                                     }
//                                                     } else {
//                                                       errordialog(context, info, infoSiv);
//                                                     }
//                                                     } else {
//                                                       errordialog(context, info, infoDepatureDate);
//                                                     }
//                                                     } else {
//                                                        errordialog(context, info, infoGeneration);
//                                                     }
//                                                     } else {
//                                                     errordialog(context, info, infoLotempty);
//                                                     }
//                                                     }
//
//
//   void confirmationPopupp() {
//     Alert(
//       context: context,
//       type: AlertType.warning,
//       title: confirm,
//       desc: proceed,
//       buttons: [
//         DialogButton(
//           child: Text(
//             yes,
//             style: TextStyle(color: Colors.white, fontSize: 20),
//           ),
//           onPressed: () {
//             saveRawSeedCleaning();
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
//    saveRawSeedCleaning() async{
//     final now = new DateTime.now();
//     String txntime = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
//     String msgNo = DateFormat('yyyyMMddHHmmss').format(now);
//     String stackId = "RT"+msgNo;
//     print('agentToken :' + servicePointId);
//     print(msgNo);
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
//             servicePointId +
//             '\',\'' +
//             revNo.toString() +
//             '\')';
//     int txnRes = await db.RawInsert(txnHeaderQuery);
//     print('txnRes:' + txnRes.toString());
//
//     /*Saving Custom Transaction*/
//     AppDatas appDatas = new AppDatas();
//     await db.saveCustTransaction(
//         txntime, appDatas.txn_RawSeedleaning, revNo.toString(), '', '', '');
//
//     String weightbridgePath = "";
//     if (weightBridgeImageFile != null) {
//       weightbridgePath = weightBridgeImageFile!.path;
//     }
//     String photogatepassPath = "";
//     if (grnImageFile != null) {
//       photogatepassPath = grnImageFile!.path;
//     }
//     try {
//       int rawSeedCleaning = await db.saveRawSeedCleaning(
//          "",
//         slctGenrationtypId,
//         "",
//         depatureDate,
//         sivnController.text,
//         vehicleGrossController.text,
//         vehicleTareController.text,
//         autoNetWeight.toString(),
//         noOfBagsController.text,
//         slctDestinationtypId,
//         repNameController.text,
//         phoneNumController.text,
//         transportSerController.text,
//         driverNameController.text,
//         driverPhoneController.text,
//         plateNumController.text,
//         getInTicketController.text,
//         gatePassController.text,
//         slctCleaningCentypId,
//         dateOfReception,
//         grnController.text,
//         repReceptionNameController.text,
//         recVehicleWeightController.text,
//         recVehicleTreController.text,
//         autoRecNetWeight.toString(),
//         recNoOfBagsController.text,
//           weightbridgePath,
//         //weightBridgeImageFile!.path,
//         //grnImageFile!.path,
//           photogatepassPath,
//         '1',
//         revNo.toString(),
//         Lat,
//         Lng,
//         stackId,
//         slctLotValue
//       );
//
//       int issync = await db.UpdateTableValue(
//           'rawseedclean', 'isSynched', '0', 'recNo', revNo.toString());
//
//      int stockUpdate = await db.UpdateTableValue(
//           'villageWarehouse', 'stockType', '4', 'batchNO', slctLotValue.toString());
//       print(issync);
//
//       TxnExecutor txnExecutor = new TxnExecutor();
//       txnExecutor.CheckCustTrasactionTable();
//
//
//       Alert(
//         context: context,
//         type: AlertType.info,
//         title: "Transaction Successful",
//         desc: "Raw Seed Transfer Successful.\nYour receipt ID is " + revNo.toString(),
//         buttons: [
//           DialogButton(
//             child: Text(
//               "OK",
//               style: TextStyle(color: Colors.white, fontSize: 20),
//             ),
//             onPressed: () {
//               Navigator.of(context).pushReplacement(MaterialPageRoute(
//                   builder: (BuildContext context) => DashBoard("", "")));
//             },
//             width: 120,
//           ),
//         ],
//       /*  closeFunction: (){
//           Navigator.pop(context);
//           Navigator.pop(context);
//         },*/
//       ).show();
//
//     }
//     catch(e){
//       print("invalid1"+e.toString());
//     }
//
//
//
//   }
//
//
// }
//
//
