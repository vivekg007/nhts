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
// import 'navigation.dart';
//
// class RawSeedRecep extends StatefulWidget {
//   const RawSeedRecep({Key? key}) : super(key: key);
//
//   @override
//   State<RawSeedRecep> createState() => _RawSeedRecepState();
// }
//
// class _RawSeedRecepState extends State<RawSeedRecep> {
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
//   List<UImodel> csivnUIModel = [];
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
//   new TextEditingController();
//   TextEditingController recVehicleWeightController =
//   new TextEditingController();
//   TextEditingController recVehicleTreController = new TextEditingController();
//   TextEditingController recNoOfBagsController = new TextEditingController();
//   TextEditingController grnController = new TextEditingController();
//   TextEditingController vareityCntrl = new TextEditingController();
//   TextEditingController warehouseCntrl = new TextEditingController();
//
//   String slctVrtyp = '', slctVartypId = '',lotSpec='';
//   String slctGenrationtyp = '', slctGenrationtypId = '';
//   String slctWarehousetyp = '', slctWarehousetypId = '';
//   String slctDestinationtyp = '', slctDestinationtypId = '';
//   String slctCleaningCentyp = '', slctCleaningCentypId = '';
//   String slctsivnId = '', slctsivntyp = '';
//
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
//   String sivnHint = 'Select SIV N°';
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
//   String infoCleanempty = 'Cleaning center should not be empty';
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
//   List<DropdownModel> csivnitems = [];
//   DropdownModel? slctsivn;
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
//     loadcsivn();
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
//               'Raw Seed Reception',
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
//     List<Widget> listings = [];
//
//     listings.add(txt_label_mandatory(cleaningUnit, Colors.green, 18.0, true));
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
//     listings
//         .add(txt_label_mandatory(sivn, Colors.black, 14.0, false));
//     listings.add(DropDownWithModel(
//         itemlist: csivnitems,
//         selecteditem: slctsivn,
//         hint: sivnHint,
//         onChanged: (value) {
//           setState(() {
//             slctsivn = value!;
//             slctsivnId = slctsivn!.value;
//             slctsivntyp = slctsivn!.name;
//             getLotNo(slctsivnId);
//           });
//         },
//         onClear: () {
//           setState(() {
//             slctsivntyp = '';
//           });
//         }));
//
//     listings.add(txt_label_mandatory(receptionDate, Colors.black, 14.0, false));
//     listings.add(selectDate(
//         context1: context,
//         slctdate: receptionFormatedDate,
//         onConfirm: (date) => setState(
//               () {
//             dateOfReception = DateFormat('dd-MM-yyyy HH:mm:ss').format(date!);
//             receptionFormatedDate = DateFormat('dd-MM-yyyy').format(date);
//           },
//         )));
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
//
//     listings.add(img_picker(
//         label: 'Photo GRN',
//         onPressed: () {
//           imageDialog("grn");
//         },
//         filename: grnImageFile,
//         ondelete: () {
//           ondelete("grn");
//         }));
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
//
//   Future<void> getLotNo(String circleCode) async {
//     //woredalist
//     lotSpec='';
//     List woredalist = await db.RawQuery(
//         'select * from villageWarehouse where siv =\'' + circleCode + '\'');
//     print('' + woredalist.toString());
//     lotSpec = woredalist[0]["batchNO"].toString();
//     print('lotSpec:' + lotSpec.toString());
//
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
//         'select * from villageWarehouse where stockType=\'2\'';
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
//   loadstocktype(String stocktype) async {
//     List stockTypelist = await db.RawQuery(
//         'select * from villageWarehouse where batchNO =\'' + stocktype + '\'');
//     print('stockTypelist ' + stockTypelist.toString());
//     for (int i = 0; i < stockTypelist.length; i++) {
//       Availtareweight = stockTypelist[0]["tareWt"].toString();
//       AvailgrossWeight = stockTypelist[0]["grossWeight"].toString();
//       AvailnoOfBags = stockTypelist[0]["noOfBags"].toString();
//       vehicleTareController.text=Availtareweight;
//       vehicleGrossController.text=AvailgrossWeight;
//       noOfBagsController.text=AvailnoOfBags;
//       varietyCode = stockTypelist[0]["varietyCode"];
//       warehouseCode = stockTypelist[0]["warehouseCode"];
//     }
//
//     List varietyTypelist = await db.RawQuery(
//         'select * from varietyList where vCode =\'' + varietyCode + '\'');
//     print('varietyTypelist ' + varietyTypelist.toString());
//     vareityCntrl.text=varietyTypelist[0]["vName"].toString();
//
//
//     List warehouseTypelist = await db.RawQuery(
//         'select * from coOperative where coCode =\'' + warehouseCode + '\'');
//     print('warehouseTypelist ' + warehouseTypelist.toString());
//     warehouseCntrl.text=warehouseTypelist[0]["coName"].toString();
//
//   }
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
//   void loadcsivn() async{
//     csivnUIModel = [];
//     csivnitems.clear();
//     String csivnQry =
//         'select * from villageWarehouse where stockType=\'2\'';
//     List csivnList = await db.RawQuery(csivnQry);
//     for (int i = 0; i < csivnList.length; i++) {
//       String property_value = csivnList[i]["siv"].toString();
//       String DISP_SEQ = csivnList[i]["siv"].toString();
//       var uimodel = new UImodel(property_value, DISP_SEQ);
//       csivnUIModel.add(uimodel);
//       setState(() {
//         csivnitems.add(DropdownModel(
//           property_value,
//           DISP_SEQ,
//         ));
//         //prooflist.add(property_value);
//       });
//     }
//   }
//
//   void autoGenNetWeight() {
//     double vehicleGr=0,vehicleTar=0;
//
//     if (vehicleGrossController.text.length > 0)
//     {
//       vehicleGr =double.parse(vehicleGrossController.text);
//     }
//     if (vehicleTareController.text.length > 0)
//     {
//       vehicleTar =double.parse(vehicleTareController.text);
//     }
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
//    /* if (repNameController.text.length > 0 || repNameController.text != '') {
//       if (phoneNumController.text.length > 0 || phoneNumController.text != '') {
//         if (transportSerController.text.length > 0 || transportSerController.text != '') {
//           if (driverNameController.text.length > 0 || driverNameController.text != '') {
//             if (driverPhoneController.text.length > 0 || driverPhoneController.text != '') {
//               if (plateNumController.text.length > 0 || plateNumController.text != '') {
//                 if (getInTicketController.text.length > 0 || getInTicketController.text != '') {
//                   if (gatePassController.text.length > 0 || gatePassController.text != '') {*/
//                     if (slctCleaningCentyp.length > 0 || slctCleaningCentyp != '') {
//                       if (slctsivntyp.length > 0 || slctsivntyp != '') {
//                        if (dateOfReception.length > 0 || dateOfReception != '') {
//                         if (grnController.text.length > 0 || grnController.text != '') {
//                           if (repReceptionNameController.text.length > 0 || repReceptionNameController.text != '') {
//                             if (recVehicleWeightController.text.length > 0 || recVehicleWeightController.text != '') {
//                               if (recVehicleTreController.text.length > 0 || recVehicleTreController.text != '') {
//                                 if (recNoOfBagsController.text.length > 0 || recNoOfBagsController.text != '') {
//                                   //if(num.parse(recVehicleWeightController.text)<=num.parse(vehicleGrossController.text)){
//                                   //if(num.parse(recVehicleTreController.text)<=num.parse(vehicleTareController.text)){
//                                   if(num.parse(recVehicleTreController.text)<=num.parse(recVehicleWeightController.text)){
//                                     //if(num.parse(vehicleTareController.text)<=num.parse(Availtareweight)){
//                                     //if(num.parse(vehicleGrossController.text)<=num.parse(AvailgrossWeight)){
//                                     //if(num.parse(noOfBagsController.text)<=num.parse(AvailnoOfBags)){
//                                     // if(num.parse(vehicleTareController.text)<=num.parse(vehicleGrossController.text)){
//                                     // if(num.parse(recNoOfBagsController.text)<=num.parse(noOfBagsController.text)){
//                                     confirmationPopupp();
//
//                                       } else {
//                                         errordialog(context, info, vehiclelesthvaldat);
//                                       }
//                                       }else {
//                                         errordialog(context, info, infoNoOfBags);
//                                       }
//                                       } else {
//                                          errordialog(context, info, infoVehicleTare);
//                                       }
//                                       } else {
//                                         errordialog(context, info, infoVehicleGross);
//                                       }
//                                       } else {
//                                          errordialog(context, info, infoRepName);
//                                       }
//                                       } else {
//                                         errordialog(context, info, infoGrnNo);
//                                       }
//                                       } else {
//                                        errordialog(context, info, infoRecDate);
//                                       }
//                                       } else {
//                                        errordialog(context, info, infoSiv);
//                                        }
//                                       } else {
//                                         errordialog(context, info, infoCleanempty);
//                                       }
//
//
//                                      }
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
//             saveRawSeedRecep();
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
//   saveRawSeedRecep() async{
//     final now = new DateTime.now();
//     String txntime = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
//     String msgNo = DateFormat('yyyyMMddHHmmss').format(now);
//     String stackId = "RR"+msgNo;
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
//         txntime, appDatas.txn_RawSeedreception, revNo.toString(), '', '', '');
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
//       int rawSeedRecep = await db.saveRawSeedRecep(
//           slctCleaningCentypId,
//           slctsivnId,
//           dateOfReception,
//           grnController.text,
//           repReceptionNameController.text,
//           recVehicleWeightController.text,
//           recVehicleTreController.text,
//           autoRecNetWeight.toString(),
//           recNoOfBagsController.text,
//           weightbridgePath,
//           //weightBridgeImageFile!.path,
//           //grnImageFile!.path,
//           photogatepassPath,
//           '1',
//           revNo.toString(),
//           seasoncode,
//           Lat,
//           Lng,
//           stackId,
//           lotSpec
//       );
//
//       int issync = await db.UpdateTableValue(
//           'rawseedcleanReception', 'isSynched', '0', 'recNo', revNo.toString());
//
//       int stockUpdate = await db.UpdateTableValue(
//           'villageWarehouse', 'stockType', '4', 'siv', slctsivnId.toString());
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
//         desc: "Raw Seed Reception Successful.\nYour receipt ID is " + revNo.toString(),
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
//
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
