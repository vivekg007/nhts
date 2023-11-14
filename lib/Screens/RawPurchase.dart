// import 'dart:convert';
// import 'dart:core';
// import 'dart:math';
//
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
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:intl/intl.dart';
// import 'package:rflutter_alert/rflutter_alert.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'navigation.dart';
// import 'dart:io' show File;
// class Rawpurchase extends StatefulWidget {
//   @override
//   RawpurchaseScreen createState() => RawpurchaseScreen();
// }
//
// class RawpurchaseScreen extends State<Rawpurchase>
//     with TickerProviderStateMixin {
//   String Lat = '', Lng = '';
//   String rawpurchase='Raw Purchase';
//   String info = 'Information';
//   String TypMultr= 'Type of multiplicator';
//   String save = 'Save';
//   String submit = 'Submit';
//   String AresurCancl = 'Are you sure want to cancel?';
//   String AresurProcd = 'Are you sure want to proceed?';
//   String Cancel = 'Cancel';
//   String Cnfm = 'Confirmation';
//   String agtrcod = 'Aggregator Code';
//   String agtename = 'Aggregator Name';
//   String fathername = 'Father Name';
//   String grandfathrname = 'Grandfather Name';
//   String gender = 'Gender';
//   String zone = 'Zone';
//   String woreda= 'Woreda';
//   String kebele = 'Kebele';
//   String add = 'Add';
//   String groupname = 'Group name';
//   String loan= 'Loan';
//   String amuntloan = 'Amount of loan';
//   String grn = 'GRN';
//   String datedelivery = 'Date of delivery';
//   String Labeldatedelivery = 'Select Date of delivery';
//   String warehusedelivery = 'Warehouse of delivery';
//   String truckticket = 'Truck ticket N°';
//   String plate= 'Plate N°';
//   String sampleby = 'Sample by';
//   String samplereference= 'Sample reference';
//   String qualitycheckedby = 'Quality checked by';
//   String delete = 'Delete';
//   String ok = 'Ok';
//   String qualityancemttickt = 'Quality announcement ticket N°';
//   String approvdby = 'Approved by';
//   String unstackedby= 'Unstacked by';
//   String qualitycheck = 'Quality checking';
//   String moisture= 'Moisture';
//   String screening = 'Screening > 2.5 mm';
//   String screeningbtwn = 'Screening between 2.2 and 2.5 mm';
//   String undersieve = 'Under sieve < 2.2 mm';
//   String brokengrain = 'Broken grain';
//   String inertmattr = 'Inert matter (stone, soil, etc)';
//   String otherseed = 'Other seeds (brome, wheat, etc.)';
//   String dustrawothr = 'Dust, straw, and other foreign matter';
//   String totaladmixture = 'Total admixture';
//   String wildoat = 'Wild oat';
//   String yes = 'Yes';
//   String no = 'No';
//   String greengrain = 'Green grain';
//   String infestdgrain = 'Infested Grain';
//   String aproutedgrain = 'Sprouted Grain';
//   String Diseasegrain = 'Diseased Grain / Molded grain / Fusarium';
//   String total = 'Total';
//   String variety= 'Variety';
//   String varietyname= 'Variety name';
//   String varietypurity= 'Variety purity';
//   String maltbarlygrade= 'Malt barley grade';
//   String comment= 'Comments';
//   String weghtbrigdetails= 'Weightbridge details';
//   String vehiclegrossdetails= 'Vehicle Gross weight (kg)';
//   String vehicletare= 'Vehicle Tare (kg)';
//   String netwght= 'Net Weight';
//   String numbrbags= 'Number of Bags';
//   String othrdudctn= 'Other deduction';
//   String netwghtpaid= 'Net weight to be paid';
//   String weghtbridslpphoto= 'Weight bridge slip photo';
//   String gatepass= 'Gate pass';
//   String photogatepass= 'Photo of Gate pass';
//   String trasnsucc = 'Transaction Successful';
//   String rawptchstrnssuccrecpid = 'Raw Purchase Successful ';
//   String typmulticatrHint = 'Select the Type of multiplicator';
//   String aggricatorHint = 'Select the Aggregator Code';
//   String warsehsedelvyHint = 'Select the Warehouse of delivery';
//   String varietynameHint = 'Select the Variety name';
//   String maltbarlygradeHint = 'Select the Malt barley grade';
//   String chse = 'Choose';
//   String galry = 'Gallery';
//   String pickimg = 'Pick Image';
//   String Camera = 'Camera';
//   String Typmultipcatempty="Type of multiplicator should not be empty";
//   String agratecodeempty="Aggregator Code should not be empty";
//   String Datedeliveryempty="Date of delivery should not be empty";
//   String Warehusedeliveryempty="Warehouse of delivery should not be empty";
//   String Truckticketempty="Truck ticket N° should not be empty";
//   String Platenempty="Plate N° should not be empty";
//   String Samplebyempty = "Sample by should not be empty";
//   String Samplerefncempty= "Sample reference should not be empty";
//   String qualitycheckempty = "Quality checked by should not be empty";
//   String qualityancticktempty = "Quality announcement ticket N° should not be empty";
//   String Unstackedbyempty="Unstacked by should not be empty";
//   String moisturempty="Moisture should not be empty";
//   String screeningempty="Screening > 2.5 mm should not be empty";
//   String screeningbtwnempty="Screening between 2.2 and 2.5 mm should not be empty";
//   String undersievenempty="Under sieve < 2.2 mm should not be empty";
//   String varietyempty="Variety name should not be empty";
//   String vartypurityempty="Variety purity should not be empty";
//   String maltbarlyempty="Malt barley grade should not be empty";
//   String vehclegrsdetlsempty="Vehicle Gross weight (kg) should not be empty";
//   String vehcltarempty="Vehicle Tare (kg) should not be empty";
//   String vehiclelesthvaldat="Vehicle Tare (kg) should not less than Vehicle Gross weight (kg)";
//   String numbrbagsempty="Number of Bags should not be empty";
//   String weightbridgeempty="Weight bridge slip photo should not be empty";
//   String photogatepassImageempty="Photo of Gate pass should not be empty";
//   String dateofdelivery="";
//   String? slctypmultctr = "",slcagratecode="",slctwaredelivery="";
//   String val_typmultcatr= "",val_aggratecode="",val_warehusedelivry="";
//   String aggricatorcode="", aggricatorname="",fthrname="",grndfthrname="",genderval="",zoneval="",
//       woredaval="",kebeleval="",groupval="",loanamuntval="",totaladmixtureval="",totalval="",
//       val_varirty="",slcvariety="",netwghtval="",othrdudctnval="",netwghtpaidval="",val_maltbarly="",slcmaltbarly="";
//
//    File? weightbridgeImageFile;
//    File? photogatepassImageFile;
//
//   List<UImodel> TypmultcatorUIModel = [];
//   List<DropdownModel> typemultcatritems = [];
//   DropdownModel? slcttypemultcatr;
//
//   List<UImodel> agrcodeUIModel = [];
//   List<DropdownModel> agrcodeitems = [];
//   DropdownModel? slctagrcode ;
//
//   List<UImodel2> warehuseofdeliveryUIModel = [];
//   List<DropdownModel> warehuseofdeliveryitems = [];
//   DropdownModel? slctwarehusedelivery ;
//
//   List<UImodel> varietyUIModel = [];
//   List<DropdownModel> varietyitems = [];
//   DropdownModel? slctvariety;
//
//   List<UImodel> maltbarlygradUIModel = [];
//   List<DropdownModel> maltbarlygraditems = [];
//   DropdownModel? slcmaltbarlygrad ;
//
//   List<DropdownModel> typMul =[];
//
//   TextEditingController trucktickController = new TextEditingController();
//   TextEditingController platenController = new TextEditingController();
//   TextEditingController samplebyController = new TextEditingController();
//   TextEditingController samplerefnceController = new TextEditingController();
//   TextEditingController qualitycheckController = new TextEditingController();
//   TextEditingController qualityancticktController = new TextEditingController();
//   TextEditingController approvdbyController = new TextEditingController();
//   TextEditingController unstackedbyController = new TextEditingController();
//   TextEditingController moistureController = new TextEditingController();
//   TextEditingController screeningController = new TextEditingController();
//   TextEditingController screeningbtwnController = new TextEditingController();
//   TextEditingController undersieveController = new TextEditingController();
//   TextEditingController brokengrainController = new TextEditingController();
//   TextEditingController inertmattrController = new TextEditingController();
//   TextEditingController otherseedController = new TextEditingController();
//   TextEditingController dustrawothrController = new TextEditingController();
//   TextEditingController wildoatController = new TextEditingController();
//   TextEditingController DiseasegrainController = new TextEditingController();
//   TextEditingController infestdgrainController = new TextEditingController();
//   TextEditingController aproutedgrainController = new TextEditingController();
//   TextEditingController greengrainController = new TextEditingController();
//   TextEditingController varietypurityController = new TextEditingController();
//   TextEditingController commentController = new TextEditingController();
//   TextEditingController vehclegrsdetlsController = new TextEditingController();
//   TextEditingController vehicletareController = new TextEditingController();
//   TextEditingController numbrbagsController = new TextEditingController();
//
//
//   List<Map> agents = [];
//
//   String seasoncode = '0';
//   String agentCode = '0';
//   String samcode = '';
//   String procBatchNo = '',agentName='';
//   String servicePointId = '0';
//   String procurementBalance = '0';
//   String farmerCode = '0';
//   var db = DatabaseHelper();
//   String agentDistributionBal = "";
//   String currency = "";
//
//
//   @override
//   void initState() {
//     super.initState();
//     initdata();
//     final now = new DateTime.now();
//     getLocation();
//     translate();
//     getClientData();
//     typMul.add(DropdownModel("Commercial Farmers", "1"));
//     typMul.add(DropdownModel("Farmers cluster", "2"));
//     typMul.add(DropdownModel("state farm", "3"));
//   }
//
//
//   getClientData() async {
//     agents = await db.RawQuery('SELECT * FROM agentMaster');
//
//     //  agentdata = await db.getUser();
//
//     seasoncode = agents[0]['currentSeasonCode'];
//     servicePointId = agents[0]['servicePointId'];
//     agentDistributionBal = agents[0]['agentProcurementBal'];
//     currency = agents[0]['currency'];
//     agentCode = agents[0]['agntPrefxCod'];
//     print("agent code:" + agentCode);
//     procBatchNo = agents[0]['procBatchNo'];
//     agentName = agents[0]['agentName'];
//     //approvdbyController.text=agentName;
//     print("batch no: " + procBatchNo);
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
//   @override
//   void dispose() {
//     super.dispose();
//   }
//
//   Future<void> initdata() async {
//
//     //Typeofmultiplicatorlist
//     List typemultpicatorlist = await db.RawQuery('select * from animalCatalog where catalog_code = \'' + "8" + '\'');
//     print(' typemultpicatorlist' + typemultpicatorlist.toString());
//     TypmultcatorUIModel = [];
//     typemultcatritems.clear();
//     for (int i = 0; i < typemultpicatorlist.length; i++) {
//       String multiplcatrName = typemultpicatorlist[i]["property_value"].toString();
//       String multiplcatrCode = typemultpicatorlist[i]["DISP_SEQ"].toString();
//       var uimodel = new UImodel(multiplcatrName, multiplcatrCode);
//
//       TypmultcatorUIModel.add(uimodel);
//       setState(() {
//         typemultcatritems.add(DropdownModel(
//           multiplcatrName,
//           multiplcatrCode,
//         ));
//       });
//     }
//
//     //AggregatorCodelist
//    List agrcatorcodelist = await db.RawQuery('select distinct aggregatorId,aggregatorName from aggregatorMaster');
//     print('agrcatorcodelist' + agrcatorcodelist.toString());
//     agrcodeUIModel = [];
//     agrcodeitems.clear();
//     for (int i = 0; i < agrcatorcodelist.length; i++) {
//       String aggrcatorName = agrcatorcodelist[i]["aggregatorName"].toString();
//       String agrcatorCode = agrcatorcodelist[i]["aggregatorId"].toString();
//       var uimodel = new UImodel(aggrcatorName, agrcatorCode);
//
//       agrcodeUIModel.add(uimodel);
//       setState(() {
//         agrcodeitems.add(DropdownModel(
//           agrcatorCode,
//           aggrcatorName,
//         ));
//       });
//     }
//
//
//     //Warehouseofdeliverylist
//     List warehsedeliverylist = await db.RawQuery('select * from coOperative where coType = \'' + "1" + '\'');
//     print(' warehsedeliverylist' + warehsedeliverylist.toString());
//     warehuseofdeliveryUIModel = [];
//     warehuseofdeliveryitems.clear();
//     for (int i = 0; i < warehsedeliverylist.length; i++) {
//       String warehsedeliveryName = warehsedeliverylist[i]["coName"].toString();
//       String warehsedeliveryCode = warehsedeliverylist[i]["coCode"].toString();
//       String warehsedeliveryIn = warehsedeliverylist[i]["copInchge"].toString();
//       var uimodel = new UImodel2(warehsedeliveryName, warehsedeliveryCode,warehsedeliveryIn);
//
//       warehuseofdeliveryUIModel.add(uimodel);
//       setState(() {
//         warehuseofdeliveryitems.add(DropdownModel(
//           warehsedeliveryName,
//           warehsedeliveryCode,
//         ));
//
//       });
//     }
//
//     //varietylist
//     List varietylist = await db.RawQuery('select * from varietyList');
//     print(' typemultpicatorlist' + varietylist.toString());
//     varietyUIModel = [];
//     varietyitems.clear();
//     for (int i = 0; i < varietylist.length; i++) {
//       String varietyName = varietylist[i]["vName"].toString();
//       String varietyCode = varietylist[i]["vCode"].toString();
//       var uimodel = new UImodel(varietyName, varietyCode);
//
//       varietyUIModel.add(uimodel);
//       setState(() {
//         varietyitems.add(DropdownModel(
//           varietyName,
//           varietyCode,
//         ));
//       });
//     }
//
//     //Maltbarleygradelist
//     /*List Maltbarleylist = await db.RawQuery('select * from animalCatalog where catalog_code = \'' + "62" + '\'');
//     print(' Maltbarleylist' + Maltbarleylist.toString());
//     maltbarlygradUIModel = [];
//     maltbarlygraditems.clear();
//     for (int i = 0; i < Maltbarleylist.length; i++) {
//       String maltbarlygradName = Maltbarleylist[i]["property_value"].toString();
//       String maltbarlygradCode = Maltbarleylist[i]["DISP_SEQ"].toString();
//       var uimodel = new UImodel(maltbarlygradName, maltbarlygradCode);
//
//       maltbarlygradUIModel.add(uimodel);
//       setState(() {
//         maltbarlygraditems.add(DropdownModel(
//           maltbarlygradName,
//           maltbarlygradCode,
//         ));
//       });
//     }*/
//    /*Total admixture calculation*/
//     undersieveController.addListener(() {
//       caltotaladdmix();
//     });
//     brokengrainController.addListener(() {
//      caltotaladdmix();
//     });
//     inertmattrController.addListener(() {
//      caltotaladdmix();
//     });
//     otherseedController.addListener(() {
//       caltotaladdmix();
//     });
//     moistureController.addListener(() {
//       caltotalval();
//       calculateotherdect();
//     });
//     screeningController.addListener(() {
//       caltotalval();
//     });
//     screeningbtwnController.addListener(() {
//       caltotalval();
//     });
//     dustrawothrController.addListener(() {
//       caltotalval();
//     });
//     wildoatController.addListener(() {
//       caltotalval();
//     });
//     DiseasegrainController.addListener(() {
//       caltotalval();
//     });
//     infestdgrainController.addListener(() {
//       caltotalval();
//     });
//     aproutedgrainController.addListener(() {
//       caltotalval();
//     });
//     /*calculate Net weight*/
//     vehclegrsdetlsController.addListener(() {
//       calnetwghtval();
//     });
//     vehicletareController.addListener(() {
//       calnetwghtval();
//     });
//
//
//   }
//   loadagricatordetails(String value) async {
//     print('agrdetailslist' + value.toString());
//     //AggregatorCodelist
//     List agrdetailslist = await db.RawQuery('select * from aggregatorMaster where aggregatorId = \'' +value + '\'');
//     print('agrdetailslist' + agrdetailslist.toString());
//     aggricatorname = agrdetailslist[0]["aggregatorName"].toString();
//     fthrname=agrdetailslist[0]["fatherName"].toString();
//     grndfthrname=agrdetailslist[0]["gfatherName"].toString();
//     genderval=agrdetailslist[0]["gender"].toString();
//
//     List agrdetailzonelist = await db.RawQuery('select * from districtList where districtCode = \'' +agrdetailslist[0]["zone"].toString() + '\'');
//     zoneval=agrdetailzonelist[0]["districtName"].toString();
//
//     List agrdetailworedalist = await db.RawQuery('select * from cityList where cityCode = \'' +agrdetailslist[0]["woreda"].toString() + '\'');
//     woredaval=agrdetailworedalist[0]["cityName"].toString();
//
//     List agrdetailkebelalist = await db.RawQuery('select * from villageList where villCode = \'' +agrdetailslist[0]["kebele"].toString() + '\'');
//     kebeleval=agrdetailkebelalist[0]["villName"].toString();
//
//    // List agrdetailkebelalist = await db.RawQuery('select * from cityList where cityCode = \'' +agrdetailslist[0]["kebele"].toString() + '\'');
//     groupval=agrdetailslist[0]["groupName"].toString();
//     loanamuntval = agrdetailslist[0]["amt"].toString();
//
//     /*for (int i = 0; i < agrdetailslist.length; i++) {
//       aggricatorname = agrdetailslist[i]["property_value"].toString();
//       fthrname=agrdetailslist[i]["property_value"].toString();
//       grndfthrname=agrdetailslist[i]["property_value"].toString();
//       genderval = agrdetailslist[i]["DISP_SEQ"].toString();
//       zoneval = agrdetailslist[i]["DISP_SEQ"].toString();
//       woredaval = agrdetailslist[i]["DISP_SEQ"].toString();
//       kebeleval = agrdetailslist[i]["DISP_SEQ"].toString();
//       groupval = agrdetailslist[i]["DISP_SEQ"].toString();
//       loanamuntval = agrdetailslist[i]["DISP_SEQ"].toString();
//     }*/
//
//   }
//   caltotaladdmix(){
//     totaladmixtureval = "";
//     if (undersieveController.text.length > 0||
//         brokengrainController.text.length > 0||
//         inertmattrController.text.length > 0||
//         otherseedController.text.length > 0) {
//       var undersieve,brokengrain,inertmattr,otherseed;
//       undersieve=0;
//       brokengrain=0;
//       inertmattr=0;
//       otherseed=0;
//       if(undersieveController.text.length > 0){
//         undersieve=num.parse(undersieveController.text);
//       }
//       if( brokengrainController.text.length > 0){
//         brokengrain=num.parse(brokengrainController.text);
//       }
//       if(inertmattrController.text.length > 0){
//         inertmattr=num.parse(inertmattrController.text);
//       }
//       if(otherseedController.text.length > 0){
//         otherseed=num.parse(otherseedController.text);
//       }
//
//       setState(() {
//         var valcalcontroller = undersieve+ brokengrain+ inertmattr+ otherseed;
//         totaladmixtureval = valcalcontroller.toString();
//         caltotalval();
//       });
//     }
//
//   }
//   caltotalval(){
//     totalval = "";
//     if (moistureController.text.length > 0||
//         screeningController.text.length > 0||
//         screeningbtwnController.text.length > 0||
//         dustrawothrController.text.length > 0||
//         wildoatController.text.length > 0||
//         DiseasegrainController.text.length >0||
//         infestdgrainController.text.length >0||
//         aproutedgrainController.text.length >0||
//         totaladmixtureval!="") {
//       var moisture,screening, screeningbtw,dustrawothr, wildoat,Diseasegrain,infestdgrain,aproutedgrain,totmixture;
//       moisture=0;
//       screening=0;
//       screeningbtw=0;
//       dustrawothr=0;
//       wildoat=0;
//       Diseasegrain=0;
//       infestdgrain=0;
//       aproutedgrain=0;
//       totmixture=0;
//       print("moisture"+moistureController.text.length.toString());
//       //print("wildoat"+wildoat+"Diseasegrain"+Diseasegrain+"infestdgrain"+infestdgrain+"aproutedgrain"+aproutedgrain);
//       if(moistureController.text.length > 0){
//         moisture=num.parse(moistureController.text);
//       }
//       if( screeningController.text.length > 0){
//         screening=num.parse(screeningController.text);
//       }
//       if(screeningbtwnController.text.length > 0){
//         screeningbtw=num.parse(screeningbtwnController.text);
//       }
//       if(dustrawothrController.text.length > 0){
//         dustrawothr=num.parse(dustrawothrController.text);
//       }
//       if(wildoatController.text.length > 0){
//         wildoat=num.parse(wildoatController.text);
//       }
//       if( DiseasegrainController.text.length > 0){
//         Diseasegrain=num.parse(DiseasegrainController.text);
//       }
//       if(infestdgrainController.text.length > 0){
//         infestdgrain=num.parse(infestdgrainController.text);
//       }
//       if(aproutedgrainController.text.length > 0){
//         aproutedgrain=num.parse(aproutedgrainController.text);
//       }
//       if(totaladmixtureval!=""){
//         totmixture=num.parse(totaladmixtureval);
//       }
//       var valcalcontroller =moisture+screening+screeningbtw+
//           dustrawothr+wildoat+ Diseasegrain+ infestdgrain+ aproutedgrain+totmixture;
//
//       print("valcalcontroller"+valcalcontroller.toString());
//       setState(() {
//        totalval = valcalcontroller.toString();
//       });
//     }
//
//   }
//
//   calnetwghtval(){
//     netwghtval = "";
//       if (vehclegrsdetlsController.text.length > 0||
//         vehicletareController.text.length > 0) {
//       var vehclegrs,vehicletare;
//       vehclegrs=0;
//       vehicletare=0;
//       if(vehclegrsdetlsController.text.length > 0){
//         vehclegrs=num.parse(vehclegrsdetlsController.text);
//       }
//       if( vehicletareController.text.length > 0){
//         vehicletare=num.parse(vehicletareController.text);
//       }
//
//       setState(() {
//         var valcalcontroller = vehclegrs-vehicletare;
//         netwghtval = valcalcontroller.toString();
//         calculateotherdect();
//         netwghtopaid();
//       });
//     }
//
//   }
//
//
//   calculateotherdect(){
//     othrdudctnval="";
//     if (moistureController.text.length > 0||netwghtval!=""){
//       var moisture,moisturedect,netweight,otherdection;
//       moisture=0;
//       netweight=0;
//       moisturedect=0;
//       otherdection=0.00;
//       if(moistureController.text.length > 0){
//         moisture=num.parse(moistureController.text);
//       }
//       if(netwghtval!=""){
//         netweight=num.parse(netwghtval);
//       }
//       if(moisture<=14.5){
//         moisturedect=0.00;
//       }else{
//         moisturedect=moisture-14.5;
//       }
//       if(moisturedect!=0.00){
//         otherdection=moisturedect*netweight/100;
//       }else{
//         otherdection=moisturedect;
//       }
//       setState(() {
//         var valcalcontroller=otherdection.toStringAsFixed(2);
//         othrdudctnval =valcalcontroller.toString();
//         netwghtopaid();
//       });
//     }
//   }
//
//   netwghtopaid(){
//     netwghtpaidval="";
//     if(othrdudctnval!=""||netwghtval!=""){
//       var netwt,othrdec,netwghtopaid;
//       netwt=0;
//       othrdec=0;
//
//       if(netwghtval!=""){
//         netwt=num.parse(netwghtval);
//       }
//       if(othrdudctnval!=""){
//         othrdec=num.parse(othrdudctnval);
//       }
//       setState(() {
//         var valcalcontroller=netwt-othrdec;
//         netwghtpaidval =valcalcontroller.toStringAsFixed(2);
//       });
//
//     }
//
//   }
//
//   void translate() async {
//     try {
//       String? Lang = '';
//       try {
//         SharedPreferences prefs = await SharedPreferences.getInstance();
//         Lang = prefs.getString("langCode");
//       } catch (e) {
//         Lang = 'en';
//       }
//       String qry =
//           'select * from labelNamechange where tenantID =  \'cediam\' and lang = \'' +
//               Lang! +
//               '\'';
//
//       print('Lanquery' + qry);
//       List transList = await db.RawQuery(qry);
//       print('translist:' + transList.toString());
//       for (int i = 0; i < transList.length; i++) {
//         String classname = transList[i]['className'];
//         String labelName = transList[i]['labelName'];
//         switch (classname) {
//           case "yes":
//             setState(() {
//               yes = labelName;
//             });
//             break;
//           case "no":
//             setState(() {
//               no = labelName;
//             });
//             break;
//           case "delete":
//             setState(() {
//               delete = labelName;
//             });
//             break;
//           case "adbt":
//             setState(() {
//               add = labelName;
//             });
//             break;
//           case "Cancel":
//             setState(() {
//               Cancel = labelName;
//             });
//             break;
//           case "rusurecancel":
//             setState(() {
//               AresurCancl = labelName;
//             });
//             break;
//           case "confirm":
//             setState(() {
//               Cnfm = labelName;
//             });
//             break;
//           case "ArewntPrcd":
//             setState(() {
//               AresurProcd = labelName;
//             });
//             break;
//           case "save":
//             setState(() {
//               save = labelName;
//             });
//             break;
//           case "submit":
//             setState(() {
//               submit = labelName;
//             });
//             break;
//           case "info":
//             setState(() {
//               info = labelName;
//             });
//             break;
//           case "ok":
//             setState(() {
//               ok = labelName;
//             });
//             break;
//         }
//       }
//     } catch (e) {
//       print('translation err' + e.toString());
//       //toast(e.toString());
//     }
//   }
//
//   Future<bool> _onBackPressed() async {
//     return (await Alert(
//       context: context,
//       type: AlertType.warning,
//       title: Cancel,
//       desc: AresurCancl,
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
//
//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//         child: WillPopScope(
//           onWillPop: _onBackPressed,
//           child: Scaffold(
//             resizeToAvoidBottomInset: false,
//             appBar: AppBar(
//               centerTitle: true,
//               leading: IconButton(
//                 icon: Icon(Icons.arrow_back, color: Colors.white),
//                 onPressed: () {
//                   _onBackPressed();
//                 },
//               ),
//               title: Text(
//                 rawpurchase,
//                 style: new TextStyle(
//
//                     color: Colors.white,
//                     fontSize: 18.0,
//                     fontWeight: FontWeight.w700),
//               ),
//               iconTheme: IconThemeData(color: Colors.white),
//               backgroundColor: Colors.green,
//               brightness: Brightness.light,
//             ),
//             body: Container(
//               child: ListView(
//                 padding: EdgeInsets.all(10.0),
//                 children: _rawpurchaseUI(
//                     context), // <<<<< Note this change for the return type
//               ),
//             ),
//           ),
//         ));
//   }
//
//   List<Widget> _rawpurchaseUI(BuildContext context) {
//     List<Widget> listings = [];
//     listings.add(txt_label_mandatory(TypMultr, Colors.black, 14.0, false));
//
//     listings.add(DropDownWithModel(
//         itemlist: typMul,
//         selecteditem: slcttypemultcatr,
//         hint: typmulticatrHint,
//         onChanged: (value) {
//           setState(() {
//             slcttypemultcatr = value!;
//             val_typmultcatr = slcttypemultcatr!.value;
//             slctypmultctr = slcttypemultcatr!.name;
//               print(slctypmultctr!+" "+val_typmultcatr);
//             /*for (int i = 0; i < TypmultcatorUIModel.length; i++) {
//               if (val_typmultcatr == TypmultcatorUIModel[i].value) {
//                 print(val_typmultcatr);
//               }
//             }*/
//           });
//         },
//         onClear: () {
//           setState(() {
//             slctypmultctr = '';
//           });
//         }));
//
//
//     listings.add(txt_label_mandatory(agtrcod, Colors.black, 14.0, false));
//     listings.add(DropDownWithModel(
//         itemlist: agrcodeitems,
//         selecteditem: slctagrcode,
//         hint: aggricatorHint,
//         onChanged: (value) {
//           setState(() {
//             slctagrcode = value!;
//             val_aggratecode = slctagrcode!.name;
//             slcagratecode = slctagrcode!.value;
//             loadagricatordetails(val_aggratecode);
//             /*for (int i = 0; i < agrcodeUIModel.length; i++) {
//               if (val_aggratecode == agrcodeUIModel[i].value) {
//                 print(val_aggratecode);
//               }
//             }*/
//           });
//         },
//         onClear: () {
//           setState(() {
//             slcagratecode = '';
//           });
//         }));
//
//     listings.add(txt_label_mandatory(agtename, Colors.black, 14.0, false));
//     listings.add(cardlable_dynamic(aggricatorname));
//
//     listings.add(txt_label_mandatory(fathername, Colors.black, 14.0, false));
//     listings.add(cardlable_dynamic(fthrname));
//
//     listings.add(txt_label_mandatory(grandfathrname, Colors.black, 14.0, false));
//     listings.add(cardlable_dynamic(grndfthrname));
//
//     listings.add(txt_label_mandatory(gender, Colors.black, 14.0, false));
//     listings.add(cardlable_dynamic(genderval));
//
//     listings.add(txt_label_mandatory(zone, Colors.black, 14.0, false));
//     listings.add(cardlable_dynamic(zoneval));
//
//     listings.add(txt_label_mandatory(woreda, Colors.black, 14.0, false));
//     listings.add(cardlable_dynamic(woredaval));
//
//     listings.add(txt_label_mandatory(kebele, Colors.black, 14.0, false));
//     listings.add(cardlable_dynamic(kebeleval));
//
//     listings.add(txt_label(groupname, Colors.black, 14.0, false));
//     listings.add(cardlable_dynamic(groupval));
//
//     listings.add(
//         txt_label(loan, Colors.green, 18.0, true));
//     listings.add(txt_label_mandatory(amuntloan, Colors.black, 14.0, false));
//
//     listings.add(cardlable_dynamic(loanamuntval));
//     listings.add(
//         txt_label(grn, Colors.green, 18.0, true));
//     listings.add(txt_label_mandatory(datedelivery, Colors.black, 14.0, false));
//     listings.add(selectDate(
//       context1: context,
//       slctdate: Labeldatedelivery,
//       onConfirm: (date) => setState(() {
//         dateofdelivery = DateFormat('dd-MM-yyyy HH:mm:ss').format(date!);
//         Labeldatedelivery = DateFormat('dd-MM-yyyy').format(date);
//         //print('CHECKJOIINGDFATE:2 '+icsjoiningDate);
//       }),
//     ));
//     listings.add(txt_label_mandatory(warehusedelivery, Colors.black, 14.0, false));
//     listings.add(DropDownWithModel(
//         itemlist: warehuseofdeliveryitems,
//         selecteditem: slctwarehusedelivery,
//         hint: warsehsedelvyHint,
//         onChanged: (value) {
//           setState(() {
//             slctwarehusedelivery = value!;
//             val_warehusedelivry = slctwarehusedelivery!.value;
//             slctwaredelivery = slctwarehusedelivery!.name;
//
//             for (int i = 0; i < warehuseofdeliveryUIModel.length; i++) {
//               if (val_warehusedelivry == warehuseofdeliveryUIModel[i].value) {
//                 print(warehuseofdeliveryUIModel[i].value2);
//                 approvdbyController.text=warehuseofdeliveryUIModel[i].value2;
//               }
//             }
//           });
//         },
//         onClear: () {
//           setState(() {
//             slctwaredelivery = '';
//           });
//         }));
//     listings.add(txt_label_mandatory(
//         truckticket , Colors.black, 14.0, false));
//     listings.add(txtfield_dynamic(truckticket, trucktickController, true, 4));
//
//     listings.add(txt_label_mandatory(plate, Colors.black, 14.0, false));
//     listings.add(txtfield_dynamic(plate, platenController, true, 15));
//
//     listings.add(txt_label_mandatory(sampleby, Colors.black, 14.0, false));
//     listings.add(txtfield_dynamic(sampleby, samplebyController, true, 25));
//
//     listings.add(txt_label_mandatory(samplereference, Colors.black, 14.0, false));
//     listings.add(txtfield_dynamic(samplereference, samplerefnceController, true, 10));
//
//     listings.add(txt_label_mandatory(qualitycheckedby, Colors.black, 14.0, false));
//     listings.add(txtfield_dynamic(qualitycheckedby, qualitycheckController, true, 25));
//
//     listings.add(txt_label_mandatory(qualityancemttickt, Colors.black, 14.0, false));
//     listings.add(txtfield_dynamic(qualityancemttickt, qualityancticktController, true, 4));
//
//     listings.add(txt_label_mandatory(approvdby, Colors.black, 14.0, false));
//     listings.add(txtfield_dynamic(approvdby, approvdbyController,false, 25));
//
//
//     listings.add(txt_label_mandatory(
//         unstackedby , Colors.black, 14.0, false));
//     listings.add(txtfield_dynamic(unstackedby, unstackedbyController, true, 25));
//
//     listings.add(
//         txt_label(qualitycheck, Colors.green, 18.0, true));
//
//     listings.add(txt_label_mandatory(
//         moisture , Colors.black, 14.0, false));
//     listings.add(txtfieldAllowTwoDecimal(moisture, moistureController!, true,5));
//
//     listings.add(txt_label_mandatory(
//         screening , Colors.black, 14.0, false));
//     listings.add(txtfieldAllowTwoDecimal(screening,screeningController, true,5));
//
//     listings.add(txt_label_mandatory(
//         screeningbtwn , Colors.black, 14.0, false));
//     listings.add(txtfieldAllowTwoDecimal(screeningbtwn,screeningbtwnController, true,5));
//
//     listings.add(txt_label_mandatory(
//         undersieve , Colors.black, 14.0, false));
//     listings.add(txtfieldAllowTwoDecimal(undersieve,undersieveController, true,5));
//
//     listings.add(txt_label(
//         brokengrain , Colors.black, 14.0, false));
//     listings.add(txtfieldAllowTwoDecimal(brokengrain,brokengrainController, true, 5));
//
//     listings.add(txt_label(
//         inertmattr , Colors.black, 14.0, false));
//     listings.add(txtfieldAllowTwoDecimal(inertmattr,inertmattrController, true, 5));
//
//     listings.add(txt_label(
//         otherseed , Colors.black, 14.0, false));
//     listings.add(txtfieldAllowTwoDecimal(otherseed,otherseedController, true,5));
//
//     listings.add(txt_label(
//         dustrawothr , Colors.black, 14.0, false));
//     listings.add(txtfieldAllowTwoDecimal(dustrawothr,dustrawothrController, true,5));
//
//     listings.add(txt_label_mandatory(totaladmixture, Colors.black, 14.0, false));
//     listings.add(cardlable_dynamic(totaladmixtureval));
//
//     listings.add(txt_label(
//         wildoat , Colors.black, 14.0, false));
//     listings.add(txtfieldAllowTwoDecimal(wildoat,wildoatController, true,5));
//
//     listings.add(txt_label(
//         Diseasegrain , Colors.black, 14.0, false));
//     listings.add(txtfieldAllowTwoDecimal(Diseasegrain,DiseasegrainController, true,5));
//
//     listings.add(txt_label(
//         infestdgrain , Colors.black, 14.0, false));
//     listings.add(txtfieldAllowTwoDecimal(infestdgrain,infestdgrainController, true,5));
//
//     listings.add(txt_label(
//         aproutedgrain , Colors.black, 14.0, false));
//     listings.add(txtfieldAllowTwoDecimal(aproutedgrain,aproutedgrainController, true, 5));
//
//     listings.add(txt_label(
//         greengrain , Colors.black, 14.0, false));
//     listings.add(txtfieldAllowTwoDecimal(greengrain,greengrainController, true,5));
//
//     listings.add(txt_label(total, Colors.black, 14.0, false));
//     listings.add(cardlable_dynamic(totalval));
//
//     listings.add(
//         txt_label(variety, Colors.green, 18.0, true));
//
//     listings.add(txt_label_mandatory(varietyname, Colors.black, 14.0, false));
//     listings.add(DropDownWithModel(
//         itemlist: varietyitems,
//         selecteditem: slctvariety,
//         hint: varietynameHint,
//         onChanged: (value) {
//           setState(() {
//             slctvariety = value!;
//             val_varirty = slctvariety!.value;
//             slcvariety = slctvariety!.name;
//
//             changeGrade(val_varirty);
//           });
//         },
//         onClear: () {
//           setState(() {
//             slcvariety = '';
//           });
//         }));
//
//     listings.add(txt_label_mandatory(
//         varietypurity , Colors.black, 14.0, false));
//     listings.add(txtfield_digits(varietypurity,varietypurityController, true, 3, 0));
//
//     listings.add(txt_label_mandatory(
//         maltbarlygrade , Colors.black, 14.0, false));
//     listings.add(DropDownWithModel(
//         itemlist: maltbarlygraditems,
//         selecteditem: slcmaltbarlygrad,
//         hint: maltbarlygradeHint,
//         onChanged: (value) {
//           setState(() {
//             slcmaltbarlygrad = value!;
//             val_maltbarly = slcmaltbarlygrad!.value;
//             slcmaltbarly = slcmaltbarlygrad!.name;
//
//             for (int i = 0; i < maltbarlygradUIModel.length; i++) {
//               if (val_maltbarly == maltbarlygradUIModel[i].value) {
//                 print(val_maltbarly);
//               }
//             }
//           });
//         },
//         onClear: () {
//           setState(() {
//             slcmaltbarly = '';
//           });
//         }));
//
//     listings.add(txt_label(
//         comment , Colors.black, 14.0, false));
//     listings.add(txtArea_dynamic(intialVal: comment,
//       initial:false,
//       hint: comment,
//       txtcontroller: commentController,
//       focus: true));
//
//     listings.add(
//         txt_label(weghtbrigdetails, Colors.green, 18.0, true));
//
//     listings.add(txt_label_mandatory(
//         vehiclegrossdetails , Colors.black, 14.0, false));
//     listings.add(txtfieldAllowTwoDecimal(vehiclegrossdetails,vehclegrsdetlsController, true, 8));
//
//     listings.add(txt_label_mandatory(
//         vehicletare , Colors.black, 14.0, false));
//     listings.add(txtfieldAllowTwoDecimal(vehicletare,vehicletareController, true, 8));
//
//     listings.add(txt_label_mandatory(
//         netwght , Colors.black, 14.0, false));
//     listings.add(cardlable_dynamic(netwghtval));
//
//     listings.add(txt_label_mandatory(
//         numbrbags , Colors.black, 14.0, false));
//     listings.add(txtfield_digits(numbrbags,numbrbagsController, true,4));
//
//     listings.add(txt_label_mandatory(
//         othrdudctn , Colors.black, 14.0, false));
//     listings.add(cardlable_dynamic(othrdudctnval));
//
//     listings.add(txt_label_mandatory(
//         netwghtpaid , Colors.black
//         , 14.0, false));
//     listings.add(cardlable_dynamic(netwghtpaidval));
//
//     listings.add(txt_label_mandatory(weghtbridslpphoto, Colors.black, 14.0, false));
//     listings.add(img_picker(
//         label: weghtbridslpphoto,
//         onPressed: () {
//           imageDialog("weightbridgephoto");
//         },
//         filename: weightbridgeImageFile,
//         ondelete: () {
//           ondelete("weightbridgephoto");
//         }));
//
//     listings.add(txt_label_mandatory(photogatepass, Colors.black, 14.0, false));
//     listings.add(img_picker(
//         label: photogatepass,
//         onPressed: () {
//           imageDialog("photogatepassphoto");
//         },
//         filename: photogatepassImageFile,
//         ondelete: () {
//           ondelete("photogatepassphoto");
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
//                   Cancel,
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
//                   submit,
//                   style: new TextStyle(color: Colors.white, fontSize: 18),
//                 ),
//                 onPressed: () {
//                   saverawpurchase();
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
//   Future<void> changeGrade(String varCode) async {
//     List vareitylist = await db.RawQuery(
//         'select * from procurementGrade where vCode =\'' + varCode + '\'');
//     print('vareitylist ' + vareitylist.toString());
//     maltbarlygradUIModel = [];
//     maltbarlygraditems = [];
//     maltbarlygraditems.clear();
//     for (int i = 0; i < vareitylist.length; i++) {
//       //String regionCode = vareitylist[i]["stateCode"].toString();
//       String zoneCode = vareitylist[i]["gradeCode"].toString();
//       String zoneName = vareitylist[i]["grade"].toString();
//
//       var uimodel = new UImodel(zoneName, zoneCode);
//       maltbarlygradUIModel.add(uimodel);
//       setState(() {
//         maltbarlygraditems.add(DropdownModel(
//           zoneName,
//           zoneCode,
//         ));
//         //prooflist.add(property_value);
//       });
//
//     }
//   }
//
//   void ondelete(String photo) {
//     setState(() {
//       if (photo == "weightbridgephoto") {
//         if (weightbridgeImageFile != null) {
//           setState(() {
//             weightbridgeImageFile = null;
//           });
//         }
//       } else {
//         if (photogatepassImageFile != null) {
//           setState(() {
//             photogatepassImageFile = null;
//           });
//         }
//       }
//     });
//   }
//   imageDialog(photo) {
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
//   Future getImageFromCamera(photo) async {
//     var image = await ImagePicker.platform
//         .pickImage(source: ImageSource.camera, imageQuality: 50);
//     setState(() {
//       if(photo=="weightbridgephoto"){
//         weightbridgeImageFile = File(image!.path);
//       }else{
//         photogatepassImageFile=File(image!.path);
//       }
//     });
//   }
//
//   Future getImageFromGallery(photo) async {
//     var image = await ImagePicker.platform
//         .pickImage(source: ImageSource.gallery, imageQuality: 50);
//     setState(() {
//       if(photo=="weightbridgephoto"){
//         weightbridgeImageFile = File(image!.path);
//       }else{
//         photogatepassImageFile=File(image!.path);
//       }
//
//     });
//   }
//
//
//   saverawpurchase() async {
//     if (slctypmultctr == "") {
//       errordialog(context, info, Typmultipcatempty);
//     } else if (slcagratecode == "") {
//       errordialog(context, info,agratecodeempty);
//     } else if (dateofdelivery == "") {
//       errordialog(context, info, Datedeliveryempty);
//     } else if (slctwaredelivery == "") {
//       errordialog(context, info, Warehusedeliveryempty);
//     } else if (trucktickController!.value.text.length==0 || trucktickController!.value.text == '') {
//       errordialog(context, info, Truckticketempty);
//     } else if (platenController!.value.text.length==0 || platenController!.value.text == '') {
//       errordialog(context, info, Platenempty);
//     } else if (samplebyController!.value.text.length==0 || samplebyController!.value.text == '') {
//       errordialog(context, info,Samplebyempty);
//     } else if (samplerefnceController!.value.text.length==0 || samplerefnceController!.value.text == '') {
//       errordialog(context, info,Samplerefncempty);
//     } else if (qualitycheckController!.value.text.length==0 || qualitycheckController!.value.text == '') {
//       errordialog(context, info,qualitycheckempty);
//     } else if (qualityancticktController!.value.text.length==0 || qualityancticktController!.value.text == '') {
//       errordialog(context, info,qualityancticktempty);
//     } else if (unstackedbyController!.value.text.length==0 || unstackedbyController!.value.text == '') {
//       errordialog(context, info, Unstackedbyempty);
//     } else if (moistureController!.value.text.length==0 || moistureController!.value.text == '') {
//       errordialog(context, info, moisturempty);
//     } else if (screeningController!.value.text.length==0 || screeningController!.value.text == '') {
//       errordialog(context, info, screeningempty);
//     }/* else if (num.parse(screeningController.text)<2.5) {
//       errordialog(context, info, "'Screening > 2.5 mm' should be greater than 2.5");
//     }*/ else if (screeningbtwnController!.value.text.length==0 || screeningbtwnController!.value.text == '') {
//       errordialog(context, info, screeningbtwnempty);
//     } /*else if (num.parse(screeningbtwnController.text)<2.2) {
//       errordialog(context, info, "'Screening between 2.2 and 2.5 mm' should be greater than 2.2");
//     } else if (num.parse(screeningbtwnController.text)>2.5) {
//       errordialog(context, info, "'Screening between 2.2 and 2.5 mm' should be less than 2.5");
//     }*/ else if (undersieveController!.value.text.length==0 || undersieveController!.value.text == '') {
//       errordialog(context, info, undersievenempty);
//     }/* else if (num.parse(undersieveController.text)>2.2) {
//       errordialog(context, info, "'Under sieve < 2.2 mm' should be less than 2.2");
//     }*/else if (slcvariety == '') {
//       errordialog(context, info, varietyempty);
//     } else if (varietypurityController!.value.text.length==0 || varietypurityController!.value.text == '') {
//       errordialog(context, info, vartypurityempty);
//     } else if (slcmaltbarly == "") {
//       errordialog(context, info, maltbarlyempty);
//     } else if (vehclegrsdetlsController!.value.text.length==0 || vehclegrsdetlsController!.value.text == '') {
//       errordialog(context, info, vehclegrsdetlsempty);
//     } else if (vehicletareController!.value.text.length==0 || vehicletareController!.value.text == '') {
//       errordialog(context, info, vehcltarempty);
//     } else if (num.parse(vehclegrsdetlsController.text) < num.parse(vehicletareController.text)) {
//       errordialog(context,  info, vehiclelesthvaldat);
//     } else if (numbrbagsController!.value.text.length==0 || numbrbagsController!.value.text == '') {
//       errordialog(context, info, numbrbagsempty);
//     }else if ((weightbridgeImageFile == null || weightbridgeImageFile == '')) {
//       errordialog(context, info, weightbridgeempty);
//     }else if ((photogatepassImageFile == null || photogatepassImageFile == '')) {
//       errordialog(context, info, photogatepassImageempty);
//     } else {
//       Alert(
//         context: context,
//         type: AlertType.warning,
//         title: Cnfm,
//         desc: AresurProcd,
//         buttons: [
//           DialogButton(
//             child: Text(
//               yes,
//               style: TextStyle(color: Colors.white, fontSize: 20),
//             ),
//             onPressed: () {
//               saveRqpurchase();
//               Navigator.pop(context);
//             },
//             width: 120,
//           ),
//           DialogButton(
//             child: Text(
//               "No",
//               style: TextStyle(color: Colors.white, fontSize: 20),
//             ),
//             onPressed: () {
//               setState(() {
//                 Navigator.pop(context);
//               });
//             },
//             width: 120,
//           )
//         ],
//       ).show();
//     }
//
//   }
//
//   saveRqpurchase() async {
//     try {
//       Random rnd = new Random();
//       int recNo = 100000 + rnd.nextInt(999999 - 100000);
//       String revNo = recNo.toString();
//       double totalamount = 0;
//       // totalAmt = totalamount.toString();
//
//       print(totalamount.toString());
//       final now = new DateTime.now();
//       String txntime = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
//       String msgNo = DateFormat('yyyyMMddHHmmss').format(now);
//       String stackId = "RP"+msgNo;
//       print('agentToken :' + servicePointId);
//       print(msgNo);
//       SharedPreferences prefs = await SharedPreferences.getInstance();
//       String? agentid = prefs.getString("agentId");
//       String? agentToken = prefs.getString("agentToken");
//       print('agentToken :' + servicePointId);
//       String insqry =
//           'INSERT INTO "main"."txnHeader" ("isPrinted", "txnTime", "mode", "operType", "resentCount", "agentId", "agentToken", "msgNo", "servPointId", "txnRefId") VALUES ('
//               '0, \'' +
//               txntime +
//               '\', '
//                   '\'01\', '
//                   '\'01\', '
//                   '\'0\', \'' +
//               agentid! +
//               '\',\' ' +
//               agentToken! +
//               '\',\' ' +
//               msgNo +
//               '\',\' ' +
//               servicePointId +
//               '\',\' ' +
//               revNo +
//               '\')';
//       print('txnHeader ' + insqry);
//       int succ = await db.RawInsert(insqry);
//       print(succ);
//
//       //Future<List<Map>> txnHeader = db.GetTableValues('txnHeader');
//
//       AppDatas datas = new AppDatas();
//       int custTransaction = await db.saveCustTransaction(
//           txntime, datas.rawpurchse_txn, revNo, '', '', rawpurchase);
//       print('custTransaction : ' + custTransaction.toString());
//
//       String netweight = "";
//       double grandTotal = 0.0;
//       String weightbridgePath = "";
//       String photogatepassPath = "";
//       if (weightbridgeImageFile != null) {
//         weightbridgePath = weightbridgeImageFile!.path;
//       }
//
//       if (photogatepassImageFile != null) {
//         photogatepassPath = photogatepassImageFile!.path;
//       }
//       int rawpurchasesave = await db.SaveRawpurchase(
//           revNo,
//           '1',
//           Lng,
//           Lat,
//           datas.rawpurchse_txn,
//           txntime,
//           seasoncode,
//           datas.tenent,
//           val_typmultcatr,
//           //slcagratecode!,
//           val_aggratecode!,
//           dateofdelivery,
//           val_warehusedelivry,
//           trucktickController.text,
//           platenController.text,
//           samplebyController.text,
//           samplerefnceController.text,
//           qualitycheckController.text,
//           qualityancticktController.text,
//           approvdbyController.text,
//           unstackedbyController.text,
//           moistureController.text,
//           screeningController.text,
//           screeningbtwnController.text,
//           undersieveController.text,
//           brokengrainController.text,
//           inertmattrController.text,
//           otherseedController.text,
//           dustrawothrController.text,
//           totaladmixtureval,
//           wildoatController.text,
//           DiseasegrainController.text,
//           infestdgrainController.text,
//           aproutedgrainController.text,
//           greengrainController.text,
//           totalval,
//           val_varirty,
//           varietypurityController.text,
//           val_maltbarly,
//           commentController.text,
//           vehclegrsdetlsController.text,
//           vehicletareController.text,
//           netwghtval,
//           numbrbagsController.text,
//           othrdudctnval,
//           netwghtpaidval,
//           weightbridgePath,
//           photogatepassPath,
//       stackId);
//       print('rawpurchasesave : ' + rawpurchasesave.toString());
//       List<Map> rawPurchase = await db.GetTableValues('rawPurchase');
//       print("rawPurchase : " + rawPurchase.toString());
//
//       int issync = await db.UpdateTableValue(
//           'rawPurchase', 'isSynched', '0', 'recNo', revNo);
//       Alert(
//         context: context,
//         type: AlertType.info,
//         title: trasnsucc,
//         desc: rawptchstrnssuccrecpid,
//         buttons: [
//           DialogButton(
//             child: Text(
//               ok,
//               style: TextStyle(color: Colors.white, fontSize: 20),
//             ),
//             onPressed: () {
//               Navigator.of(context).pushReplacement(MaterialPageRoute(
//                   builder: (BuildContext context) => DashBoard("", "")));
//             },
//             width: 120,
//           ),
//         ],
//       ).show();
//     } catch (e) {
//       print("invalid1 " + e.toString());
//       // toast(e.toString());
//     }
//   }
// }
