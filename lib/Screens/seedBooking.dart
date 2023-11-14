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
// import '../main.dart';
//
//
//
// class SeedBooking extends StatefulWidget {
//   const SeedBooking({Key? key}) : super(key: key);
//
//   @override
//   State<SeedBooking> createState() => _SeedBookingState();
// }
//
// class _SeedBookingState extends State<SeedBooking> {
//   String Lat = '', Lng = '';
//   String info = 'Information';
//   String servicePointId = '0';
//   String cancel = 'Cancel';
//   String rusurecancel = 'Are you sure want to cancel?';
//   String yes = 'Yes';
//   String no = 'No';
//   String ok = 'OK';
//   String save = 'Save';
//   String chse = 'Choose';
//   String galry = 'Gallery';
//   String pickimg = 'Pick Image';
//   String Camera = 'Camera';
//   String deny = 'deny';
//   String onlytym = 'only this time';
//   String whiluseapp = 'While using the app ';
//   String Allowtakepic = 'Allow IronKettle to take picture and record video?';
//   String success = 'Success !';
//   String confirm = 'Confirmation';
//   String proceed = 'Are you sure you want to Proceed?';
//   String seasoncode = '0';
//   String agentCode = '0';
//   List<Map> agents = [];
//   var db = DatabaseHelper();
//
//   String aggregatorNameStr = "";
//   String fatherNameStr = "";
//   String grandFatherNameStr = "";
//   String genderStr = "";
//   String zoneStr = "";
//   String woredaStr = "";
//   String kebeleStr = "";
//
//   TextEditingController quantityResistedController = new TextEditingController();
//   TextEditingController quantityResistedRenController = new TextEditingController();
//   TextEditingController amountDepositedController = new TextEditingController();
//
//   String infoAggregatorCode = 'Aggregator Code should not be empty';
//   String infoAggregatorName = 'Aggregator Name should not be empty';
//   String infoFatherName = 'Father Name should not be empty';
//   String infoGFatherName = 'Grandfather Name should not be empty';
//   String infoGender = 'Gender should not be empty';
//   String infoZone = 'Zone should not be empty';
//   String infoWoreda = 'Woreda should not be empty';
//   String infoKebele = 'Kebele should not be empty';
//   String infoSeedBookingReq = 'Add Atleast one Seed booking request details';
//   String infoWareouseDesire = 'Warehouse of loading desired should not be empty';
//   String infoDateOfLoading = 'Date of loading should not be empty';
//   String infoSeedBookingRen = 'Add Atleast one Seed booking renegociated details';
//   String infoAmountDeposited = 'Amount to be deposited should not be empty';
//   String infoBookingId = 'Generate Booking ID should not be empty';
//
//
//
//
//   String aggregatorCode = 'Aggregator Code';
//   String aggregatorName = 'Aggregator Name';
//   String generateBookingId = 'Generate Booking ID';
//   String fatherName = 'Father Name';
//   String grandFatherName = 'Grandfather Name';
//   String gender = 'Gender';
//   String zone = 'Zone';
//   String woreda = 'Woreda';
//   String kebele = 'Kebele';
//   String seedBookingReqHeading = 'Seed booking request details';
//   String seedBookingRenegociatedHeading = 'Seed booking renegociated details';
//   String certificateHeading = 'Certificate and deposit emission';
//   String loadingDetailsHeading = 'Loading details';
//   String approvalFromSvmHeading = 'Approval from SCM';
//   String seedVarietyName = 'Seed variety name';
//   String seedGeneration = 'Seed generation';
//   String approval = 'Approval/Diapproval/To be negociated';
//   String certificateSigned = 'Certificate signed';
//   String contractOfSeed = 'Contract of seed retailing signed';
//   String warehouseLoading = 'Warehouse of loading desired';
//   String quantityResisted = 'Quantity requested (quintal)';
//   String amountDeposited = 'Amount to be deposited';
//   String certificatePhoto = 'Photo of certificate signed';
//   String depositPhoto = 'Photo of deposit slip';
//   String loadingDate = 'Date of loading';
//   String dateOfLoading= "";
//   String loadingFormatedDate = "";
//
//   int bookingId = 0;
//
//   File? certificateImageFile;
//   File? depositSlipImageFile;
//
//
//   String infoSeedVariety = 'Seed variety name should not be empty';
//   String infoSeedGeneration = 'Seed generation should not be empty';
//   String infoQuantityResisted = 'Quantity resisted should not be empty';
//
//
//
//   String aggregatorHint = 'Select Aggregator';
//   String seedVarietyHint = 'Select Seed variety name';
//   String seedGenerationHint = 'Select Seed generation';
//   String warehouseLoadingHint = 'Select Warehouse of loading desired';
//
//   final Map<String, String> approvalRadioList = {
//     'option1': "Yes",
//     'option2': "No",
//   };
//
//   final Map<String, String> certificateRadioList = {
//     'option1': "Yes",
//     'option2': "No",
//   };
//   final Map<String, String> seedContractRadioList = {
//     'option1': "Yes",
//     'option2': "No",
//   };
//   String selectedApprovalValue = 'option1',
//       selectedApproval = "1";
//
//   String selectedCertificateValue = 'option1',
//       selectedCertificate = "1";
//
//   String selectedContractSeedValue = 'option1',
//       selectedContractSeed = "1";
//
//   String slctAggregatorTyp = '', slctAggregatorTypId = '';
//   String slctSeedVarietyTyp = '', slctSeedVarietyTypId = '';
//   String slctSeedVarietyRenegociatedTyp = '', slctSeedVarietyRenegociatedTypId = '';
//   String slctSeedGenerationTyp = '', slctSeedGenerationTypId = '';
//   String slctSeedGenerationRenegociatedTyp = '', slctSeedGenerationRenegociatedTypId = '';
//   String slctWarehouseLoadingTyp = '', slctWarehouseLoadingTypId = '';
//
//   List<SeedBookingList> seedBookingList = [];
//   List<SeedBookingList> seedBookingRenList = [];
//
//
//   List<DropdownModel> aggregatoritems = [];
//   DropdownModel? slctAggregator;
//
//   List<DropdownModel> seedVarietyitems = [];
//   DropdownModel? slctSeedVariety;
//
//   List<DropdownModel> seedVarietyRenitems = [];
//   DropdownModel? slctSeedVarietyRen;
//
//   List<DropdownModel> seedGenerationitems = [];
//   DropdownModel? slctSeedGeneration;
//
//   List<DropdownModel> seedGenerationRenitems = [];
//   DropdownModel? slctSeedGenerationRen;
//
//   List<DropdownModel> warehouseLoadingitems = [];
//   DropdownModel? slctWarehouseLoading;
//
//   List<UImodel> aggregatorCodeUIModel = [];
//   List<UImodel> seedVarietyUIModel = [];
//   List<UImodel> seedVarietyRenUIModel = [];
//   List<UImodel> seedGenerationUIModel = [];
//   List<UImodel> seedGenerationRenUIModel = [];
//   List<UImodel> warehouseUIModel = [];
//
//
//
//
//
//   @override
//   void initState() {
//     super.initState();
//     initdata();
//     getLocation();
//     getClientData();
//   }
//
//
//   Future<void> initdata() async{
//     loadAggregatorCode();
//     loadSeedVariety();
//     loadSeedGeneration();
//     loadWarehouseDesire();
//     loadSeedVarietyRen();
//     loadSeedGenerationRen();
//     loadBookingId();
//   }
//   void loadAggregatorCode() async{
//     aggregatorCodeUIModel = [];
//     aggregatoritems.clear();
//     String aggregatorQry = 'select distinct aggregatorId,aggregatorName from aggregatorMaster';
//     List aggregatorList = await db.RawQuery(aggregatorQry);
//     for (int i = 0; i < aggregatorList.length; i++) {
//       String property_value = aggregatorList[i]["aggregatorId"].toString();
//       String DISP_SEQ = aggregatorList[i]["aggregatorName"].toString();
//       var uimodel = new UImodel(property_value, DISP_SEQ);
//       aggregatorCodeUIModel.add(uimodel);
//       setState(() {
//         aggregatoritems.add(DropdownModel(
//           property_value,
//           DISP_SEQ,
//         ));
//         //prooflist.add(property_value);
//       });
//     }
//   }
//   loadagricatordetails(String value) async {
//     print('agrdetailslist' + value.toString());
//     //AggregatorCodelist
//     List agrdetailslist = await db.RawQuery('select * from aggregatorMaster where aggregatorId = \'' +value + '\'');
//     print('agrdetailslist' + agrdetailslist.toString());
//     aggregatorNameStr = agrdetailslist[0]["aggregatorName"].toString();
//     fatherNameStr=agrdetailslist[0]["fatherName"].toString();
//     grandFatherNameStr=agrdetailslist[0]["gfatherName"].toString();
//     genderStr=agrdetailslist[0]["gender"].toString();
//
//     List agrdetailzonelist = await db.RawQuery('select * from districtList where districtCode = \'' +agrdetailslist[0]["zone"].toString() + '\'');
//     zoneStr=agrdetailzonelist[0]["districtName"].toString();
//
//     List agrdetailworedalist = await db.RawQuery('select * from cityList where cityCode = \'' +agrdetailslist[0]["woreda"].toString() + '\'');
//     woredaStr=agrdetailworedalist[0]["cityName"].toString();
//
//     List agrdetailkebelalist = await db.RawQuery('select * from villageList where villCode = \'' +agrdetailslist[0]["kebele"].toString() + '\'');
//     kebeleStr=agrdetailkebelalist[0]["villName"].toString();
//
//
//
//   }
//
//   void loadSeedVariety() async {
//     seedVarietyUIModel = [];
//     seedVarietyitems.clear();
//     String seedVarQry =
//         'select * from varietyList';
//     List seedVarList = await db.RawQuery(seedVarQry);
//     for (int i = 0; i < seedVarList.length; i++) {
//       String property_value = seedVarList[i]["vName"].toString();
//       String DISP_SEQ = seedVarList[i]["vCode"].toString();
//       var uimodel = new UImodel(property_value, DISP_SEQ);
//       seedVarietyUIModel.add(uimodel);
//       setState(() {
//         seedVarietyitems.add(DropdownModel(
//           property_value,
//           DISP_SEQ,
//         ));
//         //prooflist.add(property_value);
//       });
//     }
//   }
//
//   void loadSeedGeneration() async{
//     seedGenerationUIModel = [];
//     seedGenerationitems.clear();
//     String seedGenQry =
//         'select * from animalCatalog where catalog_code =\'8\'';
//     List seedGenList = await db.RawQuery(seedGenQry);
//     for (int i = 0; i < seedGenList.length; i++) {
//       String property_value = seedGenList[i]["property_value"].toString();
//       String DISP_SEQ = seedGenList[i]["DISP_SEQ"].toString();
//       var uimodel = new UImodel(property_value, DISP_SEQ);
//       seedGenerationUIModel.add(uimodel);
//       setState(() {
//         seedGenerationitems.add(DropdownModel(
//           property_value,
//           DISP_SEQ,
//         ));
//         //prooflist.add(property_value);
//       });
//     }
//   }
//
//   void loadWarehouseDesire() async{
//     warehouseUIModel = [];
//     warehouseLoadingitems.clear();
//     String warehouseQry =
//         'select * from animalCatalog where catalog_code =\'8\'';
//     List warehouseList = await db.RawQuery(warehouseQry);
//     for (int i = 0; i < warehouseList.length; i++) {
//       String property_value = warehouseList[i]["property_value"].toString();
//       String DISP_SEQ = warehouseList[i]["DISP_SEQ"].toString();
//       var uimodel = new UImodel(property_value, DISP_SEQ);
//       warehouseUIModel.add(uimodel);
//       setState(() {
//         warehouseLoadingitems.add(DropdownModel(
//           property_value,
//           DISP_SEQ,
//         ));
//         //prooflist.add(property_value);
//       });
//     }
//   }
//
//   void loadSeedVarietyRen() async {
//     seedVarietyRenUIModel = [];
//     seedVarietyRenitems.clear();
//     String seedVarRenQry =
//         'select * from varietyList';
//     List seedVarRenList = await db.RawQuery(seedVarRenQry);
//     for (int i = 0; i < seedVarRenList.length; i++) {
//       String property_value = seedVarRenList[i]["vName"].toString();
//       String DISP_SEQ = seedVarRenList[i]["vCode"].toString();
//       var uimodel = new UImodel(property_value, DISP_SEQ);
//       seedVarietyRenUIModel.add(uimodel);
//       setState(() {
//         seedVarietyRenitems.add(DropdownModel(
//           property_value,
//           DISP_SEQ,
//         ));
//         //prooflist.add(property_value);
//       });
//     }
//   }
//
//   void loadSeedGenerationRen() async {
//     seedGenerationRenUIModel = [];
//     seedGenerationRenitems.clear();
//     String seedGenRenQry =
//         'select * from animalCatalog where catalog_code =\'8\'';
//     List seedGenRenList = await db.RawQuery(seedGenRenQry);
//     for (int i = 0; i < seedGenRenList.length; i++) {
//       String property_value = seedGenRenList[i]["property_value"].toString();
//       String DISP_SEQ = seedGenRenList[i]["DISP_SEQ"].toString();
//       var uimodel = new UImodel(property_value, DISP_SEQ);
//       seedGenerationRenUIModel.add(uimodel);
//       setState(() {
//         seedGenerationRenitems.add(DropdownModel(
//           property_value,
//           DISP_SEQ,
//         ));
//         //prooflist.add(property_value);
//       });
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
//   void loadBookingId() {
//     Random rnd = new Random();
//     bookingId = 100000 + rnd.nextInt(999999 - 100000);
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
//               'Seed Booking',
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
//     listings.add(txt_label_mandatory(aggregatorCode, Colors.black, 14.0, false));
//     listings.add(DropDownWithModel(
//         itemlist: aggregatoritems,
//         selecteditem: slctAggregator,
//         hint: aggregatorHint,
//         onChanged: (value) {
//           setState(() {
//             slctAggregator = value!;
//             slctAggregatorTypId = slctAggregator!.value;
//             slctAggregatorTyp = slctAggregator!.name;
//             loadagricatordetails(slctAggregatorTyp!);
//
//           });
//         },
//         onClear: () {
//           setState(() {
//             slctAggregatorTyp = '';
//           });
//         }));
//
//     listings.add(txt_label_mandatory(aggregatorName, Colors.black, 14.0, false));
//     listings.add(cardlable_dynamic(aggregatorNameStr.toString()));
//
//     listings.add(txt_label_mandatory(fatherName, Colors.black, 14.0, false));
//     listings.add(cardlable_dynamic(fatherNameStr.toString()));
//
//     listings.add(txt_label_mandatory(grandFatherName, Colors.black, 14.0, false));
//     listings.add(cardlable_dynamic(grandFatherNameStr.toString()));
//
//     listings.add(txt_label_mandatory(gender, Colors.black, 14.0, false));
//     listings.add(cardlable_dynamic(genderStr.toString()));
//
//     listings.add(txt_label_mandatory(zone, Colors.black, 14.0, false));
//     listings.add(cardlable_dynamic(zoneStr.toString()));
//
//     listings.add(txt_label_mandatory(woreda, Colors.black, 14.0, false));
//     listings.add(cardlable_dynamic(woredaStr.toString()));
//
//     listings.add(txt_label_mandatory(kebele, Colors.black, 14.0, false));
//     listings.add(cardlable_dynamic(kebeleStr.toString()));
//
//
//     listings.add(txt_label_mandatory(seedBookingReqHeading, Colors.green, 18.0, true));
//
//
//     listings.add(txt_label_mandatory(seedVarietyName, Colors.black, 14.0, false));
//     listings.add(DropDownWithModel(
//         itemlist: seedVarietyitems,
//         selecteditem: slctSeedVariety,
//         hint: seedVarietyHint,
//         onChanged: (value) {
//           setState(() {
//             slctSeedVariety = value!;
//             slctSeedVarietyTypId = slctSeedVariety!.value;
//             slctSeedVarietyTyp = slctSeedVariety!.name;
//           });
//         },
//         onClear: () {
//           setState(() {
//             slctSeedVarietyTyp = '';
//           });
//         }));
//
//     listings.add(txt_label_mandatory(seedGeneration, Colors.black, 14.0, false));
//     listings.add(DropDownWithModel(
//         itemlist: seedGenerationitems,
//         selecteditem: slctSeedGeneration,
//         hint: seedGenerationHint,
//         onChanged: (value) {
//           setState(() {
//             slctSeedGeneration = value!;
//             slctSeedGenerationTypId = slctSeedGeneration!.value;
//             slctSeedGenerationTyp = slctSeedGeneration!.name;
//           });
//         },
//         onClear: () {
//           setState(() {
//             slctSeedGenerationTyp = '';
//           });
//         }));
//
//
//     listings.add(txt_label_mandatory(quantityResisted, Colors.black, 14.0, false));
//     listings.add(txtfieldAllowTwoDecimal(quantityResisted, quantityResistedController, true,9));
//
//     listings.add(btn_dynamic(
//         label: "Add",
//         bgcolor: Colors.green,
//         txtcolor: Colors.white,
//         fontsize: 18.0,
//         centerRight: Alignment.centerRight,
//         margin: 10.0,
//         btnSubmit: () async {
//           if (slctSeedVarietyTyp.length == 0 || slctSeedVarietyTyp =='' ) {
//             errordialog(context, info, infoSeedVariety);
//             } else  if (slctSeedGenerationTyp.length == 0 || slctSeedGenerationTyp =='' ) {
//             errordialog(context, info, infoSeedGeneration);
//           }else if (quantityResistedController.text.length < 0 || quantityResistedController.text == '' ) {
//             errordialog(context, info, infoQuantityResisted);
//           }  else {
//             var seedBookingRequestList = SeedBookingList(
//                 slctSeedVarietyTyp,
//                 slctSeedVarietyTypId,
//                 slctSeedGenerationTyp,
//                 slctSeedGenerationTypId,
//                 quantityResistedController.text
//                 );
//             setState(() {
//               seedBookingList.add(seedBookingRequestList);
//             });
//             setState(() {
//               slctSeedVarietyTyp = "";
//               slctSeedVarietyTypId = '';
//               slctSeedGenerationTypId = "";
//               slctSeedGenerationTyp = '';
//               quantityResistedController.text ='';
//             });
//           }
//         }));
//
//     if (seedBookingList.length > 0) {
//       listings.add(seedBookingReqDataTable());
//     }
//
//
//     listings.add(txt_label_mandatory(loadingDetailsHeading, Colors.green, 18.0, true));
//
//     listings.add(txt_label_mandatory(warehouseLoading, Colors.black, 14.0, false));
//     listings.add(DropDownWithModel(
//         itemlist: warehouseLoadingitems,
//         selecteditem: slctWarehouseLoading,
//         hint: warehouseLoadingHint,
//         onChanged: (value) {
//           setState(() {
//             slctWarehouseLoading = value!;
//             slctWarehouseLoadingTypId = slctWarehouseLoading!.value;
//             slctWarehouseLoadingTyp = slctWarehouseLoading!.name;
//           });
//         },
//         onClear: () {
//           setState(() {
//             slctWarehouseLoadingTyp = '';
//           });
//         }));
//
//     listings.add(txt_label_mandatory(loadingDate, Colors.black, 14.0, false));
//     listings.add(selectDate(
//         context1: context,
//         slctdate: dateOfLoading,
//         onConfirm: (date) => setState(
//               () {
//             dateOfLoading = DateFormat('dd/MM/yyyy').format(date!);
//             loadingFormatedDate = DateFormat('yyyyMMdd').format(date);
//           },
//         )));
//
//     listings.add(txt_label_mandatory(approvalFromSvmHeading, Colors.green, 18.0, true));
//
//     listings.add(txt_label_mandatory(approval, Colors.black, 14.0, false));
//     listings.add(radio_dynamic(
//         map: approvalRadioList,
//         selectedKey: selectedApprovalValue,
//         onChange: (value) {
//           setState(() {
//             selectedApprovalValue = value!;
//             if (value == "option1") {
//               selectedApprovalValue = "option1";
//               selectedApproval = "1";
//             } else {
//               selectedApprovalValue = "option2";
//               selectedApproval = "0";
//             }
//           });
//         }));
//
//
//     listings.add(txt_label_mandatory(seedBookingRenegociatedHeading, Colors.green, 18.0, true));
//
//
//     listings.add(txt_label_mandatory(seedVarietyName, Colors.black, 14.0, false));
//     listings.add(DropDownWithModel(
//         itemlist: seedVarietyRenitems,
//         selecteditem: slctSeedVarietyRen,
//         hint: seedVarietyHint,
//         onChanged: (value) {
//           setState(() {
//             slctSeedVarietyRen = value!;
//             slctSeedVarietyRenegociatedTypId = slctSeedVarietyRen!.value;
//             slctSeedVarietyRenegociatedTyp = slctSeedVarietyRen!.name;
//           });
//         },
//         onClear: () {
//           setState(() {
//             slctSeedVarietyRenegociatedTyp = '';
//           });
//         }));
//
//     listings.add(txt_label_mandatory(seedGeneration, Colors.black, 14.0, false));
//     listings.add(DropDownWithModel(
//         itemlist: seedGenerationRenitems,
//         selecteditem: slctSeedGenerationRen,
//         hint: seedGenerationHint,
//         onChanged: (value) {
//           setState(() {
//             slctSeedGenerationRen = value!;
//             slctSeedGenerationRenegociatedTypId = slctSeedGenerationRen!.value;
//             slctSeedGenerationRenegociatedTyp = slctSeedGenerationRen!.name;
//           });
//         },
//         onClear: () {
//           setState(() {
//             slctSeedGenerationTyp = '';
//           });
//         }));
//
//
//     listings.add(txt_label_mandatory(quantityResisted, Colors.black, 14.0, false));
//     listings.add(txtfieldAllowTwoDecimal(quantityResisted, quantityResistedRenController, true,9));
//
//     listings.add(btn_dynamic(
//         label: "Add",
//         bgcolor: Colors.green,
//         txtcolor: Colors.white,
//         fontsize: 18.0,
//         centerRight: Alignment.centerRight,
//         margin: 10.0,
//         btnSubmit: () async {
//           if (slctSeedVarietyRenegociatedTyp.length == 0 || slctSeedVarietyRenegociatedTyp =='' ) {
//             errordialog(context, info, infoSeedVariety);
//           } else  if (slctSeedGenerationRenegociatedTyp.length == 0 || slctSeedGenerationRenegociatedTyp =='' ) {
//             errordialog(context, info, infoSeedGeneration);
//           }else if (quantityResistedRenController.text.length < 0 || quantityResistedRenController.text == '' ) {
//             errordialog(context, info, infoQuantityResisted);
//           }  else {
//             var seedBookingRenegiotedList = SeedBookingList(
//                 slctSeedVarietyRenegociatedTyp,
//                 slctSeedVarietyRenegociatedTypId,
//                 slctSeedGenerationRenegociatedTyp,
//                 slctSeedGenerationRenegociatedTypId,
//                 quantityResistedRenController.text
//             );
//             setState(() {
//               seedBookingRenList.add(seedBookingRenegiotedList);
//             });
//             setState(() {
//               slctSeedVarietyRenegociatedTyp = "";
//               slctSeedVarietyRenegociatedTypId = '';
//               slctSeedGenerationRenegociatedTyp = "";
//               slctSeedGenerationRenegociatedTypId = '';
//               quantityResistedRenController.text ='';
//             });
//           }
//         }));
//
//     if (seedBookingRenList.length > 0) {
//       listings.add(seedBookingRenDataTable());
//     }
//
//     listings.add(txt_label_mandatory(certificateHeading, Colors.green, 18.0, true));
//
//     listings.add(txt_label_mandatory(certificateSigned, Colors.black, 14.0, false));
//     listings.add(radio_dynamic(
//         map: certificateRadioList,
//         selectedKey: selectedCertificateValue,
//         onChange: (value) {
//           setState(() {
//             selectedCertificateValue = value!;
//             if (value == "option1") {
//               selectedCertificateValue = "option1";
//               selectedCertificate = "1";
//             } else {
//               selectedCertificateValue = "option2";
//               selectedCertificate = "0";
//             }
//           });
//         }));
//
//
//     listings.add(txt_label_mandatory(amountDeposited, Colors.black, 14.0, false));
//     listings.add(txtfieldAllowTwoDecimal(amountDeposited, amountDepositedController, true,12));
//
//     listings.add(txt_label("Photo of certified signed", Colors.black, 14.0, false));
//     listings.add(img_picker(
//         label:certificatePhoto,
//         onPressed: () {
//           imageDialog("certificate");
//         },
//         filename: certificateImageFile,
//         ondelete: () {
//           ondelete("certificate");
//         }));
//
//     listings.add(txt_label("Photo of deposit slip", Colors.black, 14.0, false));
//     listings.add(img_picker(
//         label:depositPhoto,
//         onPressed: () {
//           imageDialog("deposit");
//         },
//         filename: depositSlipImageFile,
//         ondelete: () {
//           ondelete("deposit");
//         }));
//
//     listings.add(txt_label_mandatory(contractOfSeed, Colors.black, 14.0, false));
//     listings.add(radio_dynamic(
//         map: seedContractRadioList,
//         selectedKey: selectedContractSeedValue,
//         onChange: (value) {
//           setState(() {
//             selectedContractSeedValue = value!;
//             if (value == "option1") {
//               selectedContractSeedValue = "option1";
//               selectedContractSeed = "1";
//             } else {
//               selectedContractSeedValue = "option2";
//               selectedContractSeed = "0";
//             }
//           });
//         }));
//
//     listings.add(txt_label_mandatory(generateBookingId, Colors.black, 14.0, false));
//     listings.add(cardlable_dynamic(bookingId.toString()));
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
//                   "Cancel",
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
//   Widget seedBookingReqDataTable() {
//     List<DataColumn> columns = <DataColumn>[];
//     List<DataRow> rows = <DataRow>[];
//     columns.add(DataColumn(label: Text('Seed variety name')));
//     columns.add(DataColumn(label: Text('Seed generation')));
//     columns.add(DataColumn(label: Text('Quantity requested (quintal)')));
//     columns.add(DataColumn(label: Text('Delete')));
//
//     for (int i = 0; i < seedBookingList.length; i++) {
//       List<DataCell> singlecell = <DataCell>[];
//       singlecell.add(DataCell(Text(seedBookingList[i].seedVarietyNme)));
//       singlecell.add(DataCell(Text(seedBookingList[i].seedGeneration)));
//       singlecell.add(DataCell(Text(seedBookingList[i].quantityResisted)));
//
//       singlecell.add(DataCell(InkWell(
//         onTap: () {
//           setState(() {
//             seedBookingList.removeAt(i);
//           });
//         },
//         child: Icon(
//           Icons.delete_forever,
//           color: Colors.red,
//         ),
//       )));
//       rows.add(DataRow(
//         cells: singlecell,
//       ));
//     }
//     Widget objWidget = datatable_dynamic(columns: columns, rows: rows);
//     return objWidget;
//   }
//
//   Widget seedBookingRenDataTable() {
//     List<DataColumn> columns = <DataColumn>[];
//     List<DataRow> rows = <DataRow>[];
//     columns.add(DataColumn(label: Text('Seed variety name')));
//     columns.add(DataColumn(label: Text('Seed generation')));
//     columns.add(DataColumn(label: Text('Quantity requested (quintal)')));
//     columns.add(DataColumn(label: Text('Delete')));
//
//     for (int i = 0; i < seedBookingRenList.length; i++) {
//       List<DataCell> singlecell = <DataCell>[];
//       singlecell.add(DataCell(Text(seedBookingRenList[i].seedVarietyNme)));
//       singlecell.add(DataCell(Text(seedBookingRenList[i].seedGeneration)));
//       singlecell.add(DataCell(Text(seedBookingRenList[i].quantityResisted)));
//
//       singlecell.add(DataCell(InkWell(
//         onTap: () {
//           setState(() {
//             seedBookingRenList.removeAt(i);
//           });
//         },
//         child: Icon(
//           Icons.delete_forever,
//           color: Colors.red,
//         ),
//       )));
//       rows.add(DataRow(
//         cells: singlecell,
//       ));
//     }
//     Widget objWidget = datatable_dynamic(columns: columns, rows: rows);
//     return objWidget;
//   }
//
//   void btncancel() {
//     _onBackPressed();
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
//       if (photo == "certificate") {
//         certificateImageFile = File(image!.path);
//       } else if (photo == "deposit") {
//         depositSlipImageFile = File(image!.path);
//       }
//     });
//   }
//
//   Future getImageFromCamera(String photo) async {
//     var image = await ImagePicker.platform
//         .pickImage(source: ImageSource.camera, imageQuality: 30);
//     setState(() {
//       if (photo == "certificate") {
//         certificateImageFile = File(image!.path);
//       } else if (photo == "deposit") {
//         depositSlipImageFile = File(image!.path);
//       }
//     });
//   }
//
//   void ondelete(String photo) {
//     setState(() {
//       if (photo == "certificate") {
//         if (certificateImageFile != null) {
//           setState(() {
//             certificateImageFile = null;
//           });
//         }
//       } else if (photo == "deposit") {
//         if (depositSlipImageFile != null) {
//           setState(() {
//             depositSlipImageFile = null;
//           });
//         }
//       }
//     });
//   }
//
//
//
//
//
//   void btnSubmit() {
//     if (slctAggregatorTyp.length > 0 || slctAggregatorTyp != ''){
//       if (aggregatorNameStr.length > 0 || aggregatorNameStr != ''){
//         if (fatherNameStr.length > 0 || fatherNameStr != ''){
//           if (grandFatherNameStr.length > 0 || grandFatherNameStr != ''){
//             if (genderStr.length > 0 || genderStr != ''){
//               if (zoneStr.length > 0 || zoneStr != ''){
//                 if (woredaStr.length > 0 || woredaStr != ''){
//                   if (kebeleStr.length > 0 || kebeleStr != ''){
//                     if (seedBookingList.length > 0){
//                       if (slctWarehouseLoadingTyp.length > 0 || slctWarehouseLoadingTyp != ''){
//                         if (dateOfLoading.length > 0 || dateOfLoading != ''){
//                           if (seedBookingRenList.length > 0 ){
//                             if (amountDepositedController.text.length > 0 || amountDepositedController.text != ''){
//                               if (bookingId.toString().length > 0 || bookingId.toString() != ''){
//                                 confirmationPopupp();
//
//                               }else {errordialog(context, info, infoBookingId);}
//                             }else {errordialog(context, info, infoAmountDeposited);}
//                           }else {errordialog(context, info, infoSeedBookingRen);}
//                         }else {errordialog(context, info, infoDateOfLoading);}
//                       }else {errordialog(context, info, infoWareouseDesire);}
//                     }else {errordialog(context, info, infoSeedBookingReq);}
//                   }else {errordialog(context, info, infoKebele);}
//                 }else {errordialog(context, info, infoWoreda);}
//               }else {errordialog(context, info, infoZone);}
//             }else {errordialog(context, info, infoGender);}
//           }else {errordialog(context, info, infoGFatherName);}
//         }else {errordialog(context, info, infoFatherName);}
//       }else {errordialog(context, info, infoAggregatorName);}
//     }else {errordialog(context, info, infoAggregatorCode);}
//   }
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
//             saveSeedBooking();
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
//    saveSeedBooking() async{
//      final now = new DateTime.now();
//      String txntime = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
//      String msgNo = DateFormat('yyyyMMddHHmmss').format(now);
//      SharedPreferences prefs = await SharedPreferences.getInstance();
//      String? agentid = prefs.getString("agentId");
//      String? agentToken = prefs.getString("agentToken");
//
//      Random rnd = new Random();
//      int revNo = 100000 + rnd.nextInt(999999 - 100000);
//      String certificateImage = "";
//      if (certificateImageFile != null) {
//        certificateImage = certificateImageFile!.path;
//      }
//     String depositSlipImage = "";
//      if (depositSlipImageFile != null) {
//        depositSlipImage = depositSlipImageFile!.path;
//      }
//
//
//      String txnHeaderQuery =
//          'INSERT INTO "main"."txnHeader" ("isPrinted", "txnTime", "mode", "operType", "resentCount", "agentId", "agentToken", "msgNo", "servPointId", "txnRefId") VALUES ('
//              '0,\'' +
//              txntime +
//              '\', '
//                  '\'02\', '
//                  '\'01\', '
//                  '\'0\',\'' +
//              agentid! +
//              '\', \'' +
//              agentToken! +
//              '\',\'' +
//              msgNo +
//              '\', \'' +
//              servicePointId +
//              '\',\'' +
//              revNo.toString() +
//              '\')';
//      int txnRes = await db.RawInsert(txnHeaderQuery);
//      print('txnRes:' + txnRes.toString());
//
//      /*Saving Custom Transaction*/
//      AppDatas appDatas = new AppDatas();
//      await db.saveCustTransaction(
//          txntime, appDatas.txn_Seedbooking, revNo.toString(), '', '', '');
//      try {
//        int rawSeedCleaning = await db.saveSeedBooking(
//            slctAggregatorTyp,
//            slctWarehouseLoadingTypId,
//            dateOfLoading,
//            selectedApproval,
//            selectedCertificate,
//            amountDepositedController.text,
//            certificateImage,
//            depositSlipImage,
//            selectedContractSeed,
//            bookingId.toString(),
//            '1',
//            revNo.toString(),
//            Lat,
//            Lng
//
//        );
//
//        if (seedBookingList.length > 0) {
//          for (int i = 0; i < seedBookingList.length; i++) {
//            int saveSeedBookingReq = await db.seedBookingReqList(
//                revNo.toString(),
//                seedBookingList[i].seedVarietyId,
//                seedBookingList[i].seedGenerationId,
//                seedBookingList[i].quantityResisted);
//            print("saveSeedBookingReq" + saveSeedBookingReq.toString());
//          }
//        }
//        if (seedBookingRenList.length > 0) {
//          for (int i = 0; i < seedBookingRenList.length; i++) {
//            int saveSeedBookingRen = await db.seedBookingRenList(
//                revNo.toString(),
//                seedBookingRenList[i].seedVarietyId,
//                seedBookingRenList[i].seedGenerationId,
//                seedBookingRenList[i].quantityResisted);
//            print("saveSeedBookingRen" + saveSeedBookingRen.toString());
//          }
//        }
//
//
//        int issync = await db.UpdateTableValue(
//            'seedBooking', 'isSynched', '0', 'recNo', revNo.toString());
//        print(issync);
//
//
//
//        TxnExecutor txnExecutor = new TxnExecutor();
//        txnExecutor.CheckCustTrasactionTable();
//
//
//        Alert(
//          context: context,
//          type: AlertType.info,
//          title: "Transaction Successful",
//          desc: "Seed Booking Successful.\nYour receipt ID is " + revNo.toString(),
//          buttons: [
//            DialogButton(
//              child: Text(
//                "OK",
//                style: TextStyle(color: Colors.white, fontSize: 20),
//              ),
//              onPressed: () {
//                Navigator.pop(context);
//                Navigator.pop(context);
//              },
//              width: 120,
//            ),
//          ],
//          closeFunction: (){
//            Navigator.pop(context);
//            Navigator.pop(context);
//          },
//        ).show();
//
//      }
//      catch(e){
//        toast(e.toString());
//      }
//
//
//
//    }
//
//
//
//
// }
//
//
// class SeedBookingList {
//   String seedVarietyNme,
//         seedVarietyId,
//       seedGeneration,
//       seedGenerationId,
//       quantityResisted;
//
//
//       SeedBookingList(
//       this.seedVarietyNme,
//       this.seedVarietyId,
//       this.seedGeneration,
//       this.seedGenerationId,
//       this.quantityResisted,
//      );
// }
