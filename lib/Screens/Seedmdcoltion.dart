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
// import '../Model/Seedemandmodel.dart';
// import 'navigation.dart';
// import 'dart:io' show File;
// class Seedmdcoltion extends StatefulWidget {
//   @override
//   SeedmdcoltionScreen createState() => SeedmdcoltionScreen();
// }
//
// class SeedmdcoltionScreen extends State<Seedmdcoltion>
//     with TickerProviderStateMixin {
//   String Lat = '', Lng = '';
//   String seedamtcoltion='Seed Demand Collection';
//   String info = 'Information';
//   String TypofPchse= 'Type of purchaser';
//   String typpurchseHint = 'Select the Type of purchaser';
//   String Typurchseempty="Type of purchaser should not be empty";
//   String save = 'Save';
//   String submit = 'Submit';
//   String AresurCancl = 'Are you sure want to cancel?';
//   String AresurProcd = 'Are you sure want to proceed?';
//   String Cancel = 'Cancel';
//   String Cnfm = 'Confirmation';
//   String agtrcod = 'Aggregator Code';
//   String farmerName = 'Farmer Name';
//   String fathername = 'Father Name';
//   String grandfathrname = 'Grandfather Name';
//   String gender = 'Gender';
//   String zone = 'Zone';
//   String woreda= 'Woreda';
//   String kebele = 'Kebele';
//   String add = 'Add';
//   String groupname = 'Group name';
//   String seedamt= 'Seed demand';
//   String quantityreqest= 'Quantity requested (quintal)';
//   String seedgenrtion = 'Seed generation';
//   String delete = 'Delete';
//   String ok = 'Ok';
//   String yes = 'Yes';
//   String no = 'No';
//   String seedvarietyname= 'Seed variety name';
//   String trasnsucc = 'Transaction Successful';
//   String seedmtcoltrnssuccrecpid = 'Seed Demand Collection Successfull ';
//   String aggricatorHint = 'Select the Aggregator Code';
//   String seedgenrtionHint = 'Select the Seed generation';
//   String seedvarietynameHint = 'Select the Seed variety name';
//   String chse = 'Choose';
//   String galry = 'Gallery';
//   String pickimg = 'Pick Image';
//   String Camera = 'Camera';
//
//   String agratecodeempty="Aggregator Code should not be empty";
//   String seedgenempty="Seed generation should not be empty";
//   String seedvarietyempty="Seed variety name should not be empty";
//   String seedvarietyexistalert = 'Seed variety name already exist.';
//   String quantityreqestemp= 'Quantity requested (quintal) should not be empty';
//
//   String? slctypurchse = "",slcagratecode="",slctseedgen="";
//   String val_typpurchse= "",val_aggratecode="",val_seedgen="";
//   String aggricatorcode="", farmername="",fthrname="",grndfthrname="",genderval="",zoneval="",
//       woredaval="",kebeleval="",groupval="", val_seedvarirty="",slcseedvariety="";
//
//   File? weightbridgeImageFile;
//   File? photogatepassImageFile;
//
//   List<UImodel> TypurchseUIModel = [];
//   List<DropdownModel> typurchseitems = [];
//   DropdownModel? slcttypurchse;
//
//   List<UImodel> agrcodeUIModel = [];
//   List<DropdownModel> agrcodeitems = [];
//   DropdownModel? slctagrcode ;
//
//   List<UImodel> seedgenrationUIModel = [];
//   List<DropdownModel> seedgenitems = [];
//   DropdownModel? slctseedgenrtion ;
//
//   List<UImodel> seedvarietyUIModel = [];
//   List<DropdownModel> seedvarietyitems = [];
//   DropdownModel? slctseedvariety;
//
//
//   TextEditingController quantityreqstController = new TextEditingController();
//
//   List<Seedemandmodel> SeedemantModelList = [];
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
//
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
//     List typepurchselist = await db.RawQuery('select * from animalCatalog where catalog_code = \'' + "2" + '\'');
//     print(' typemultpicatorlist' + typepurchselist.toString());
//     TypurchseUIModel = [];
//     typurchseitems.clear();
//     for (int i = 0; i < typepurchselist.length; i++) {
//       String typurchseName = typepurchselist[i]["property_value"].toString();
//       String typurchseCode = typepurchselist[i]["DISP_SEQ"].toString();
//       var uimodel = new UImodel(typurchseName, typurchseCode);
//
//       TypurchseUIModel.add(uimodel);
//       setState(() {
//         typurchseitems.add(DropdownModel(
//           typurchseName,
//           typurchseCode,
//         ));
//       });
//     }
//
//     //AggregatorCodelist
//     List agrcatorcodelist = await db.RawQuery('select distinct aggregatorId,aggregatorName from aggregatorMaster');
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
//     List seedgenrationlist = await db.RawQuery('select * from animalCatalog where catalog_code = \'' + "8" + '\'');
//     print(' seedgenrationlist' + seedgenrationlist.toString());
//     seedgenrationUIModel = [];
//     seedgenitems.clear();
//     for (int i = 0; i < seedgenrationlist.length; i++) {
//       String seedgenName = seedgenrationlist[i]["property_value"].toString();
//       String seedgenCode = seedgenrationlist[i]["DISP_SEQ"].toString();
//       var uimodel = new UImodel(seedgenName,seedgenCode);
//
//       seedgenrationUIModel.add(uimodel);
//       setState(() {
//         seedgenitems.add(DropdownModel(
//           seedgenName,
//           seedgenCode,
//         ));
//       });
//     }
//
//     //varietylist
//     List seedvarietylist = await db.RawQuery('select * from varietyList');
//     print('seed varietylist' + seedvarietylist.toString());
//     seedvarietyUIModel = [];
//     seedvarietyitems.clear();
//     for (int i = 0; i < seedvarietylist.length; i++) {
//       String seedvarietyName = seedvarietylist[i]["vName"].toString();
//       String seedvarietyCode = seedvarietylist[i]["vCode"].toString();
//       var uimodel = new UImodel(seedvarietyName, seedvarietyCode);
//
//       seedvarietyUIModel.add(uimodel);
//       setState(() {
//         seedvarietyitems.add(DropdownModel(
//           seedvarietyName,
//           seedvarietyCode,
//         ));
//       });
//     }
//
//
//   }
//   loadagricatordetails(String value) async {
//     print('agrdetailslist' + value.toString());
//     //AggregatorCodelist
//     List agrdetailslist = await db.RawQuery('select * from aggregatorMaster where aggregatorId = \'' +value + '\'');
//     print('agrdetailslist' + agrdetailslist.toString());
//     farmername = agrdetailslist[0]["aggregatorName"].toString();
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
//     groupval=agrdetailslist[0]["groupName"].toString();
//
//
//
//   }
//
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
//                 seedamtcoltion,
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
//                 children: _seedamtcollUI(
//                     context), // <<<<< Note this change for the return type
//               ),
//             ),
//           ),
//         ));
//   }
//
//   List<Widget> _seedamtcollUI(BuildContext context) {
//     List<Widget> listings = [];
//     listings.add(txt_label(TypofPchse, Colors.black, 14.0, false));
//
//     listings.add(DropDownWithModel(
//         itemlist: typurchseitems,
//         selecteditem: slcttypurchse,
//         hint: typpurchseHint,
//         onChanged: (value) {
//           setState(() {
//             slcttypurchse = value!;
//             val_typpurchse = slcttypurchse!.value;
//             slctypurchse = slcttypurchse!.name;
//
//           });
//         },
//         onClear: () {
//           setState(() {
//             slctypurchse = '';
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
//             val_aggratecode = slctagrcode!.value;
//             slcagratecode = slctagrcode!.name;
//             loadagricatordetails(slcagratecode!);
//
//           });
//         },
//         onClear: () {
//           setState(() {
//             slcagratecode = '';
//           });
//         }));
//
//     listings.add(txt_label_mandatory(farmerName, Colors.black, 14.0, false));
//     listings.add(cardlable_dynamic(farmername));
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
//         txt_label(seedamt, Colors.green, 18.0, true));
//     listings.add(txt_label_mandatory(seedvarietyname, Colors.black, 14.0, false));
//     listings.add(DropDownWithModel(
//         itemlist: seedvarietyitems,
//         selecteditem: slctseedvariety,
//         hint: seedvarietynameHint,
//         onChanged: (value) {
//           setState(() {
//             slctseedvariety = value!;
//             val_seedvarirty = slctseedvariety!.value;
//             slcseedvariety = slctseedvariety!.name;
//
//           });
//         },
//         onClear: () {
//           setState(() {
//             slcseedvariety = '';
//           });
//         }));
//
//
//     listings.add(txt_label_mandatory(seedgenrtion, Colors.black, 14.0, false));
//     listings.add(DropDownWithModel(
//         itemlist: seedgenitems,
//         selecteditem: slctseedgenrtion,
//         hint: seedgenrtionHint,
//         onChanged: (value) {
//           setState(() {
//             slctseedgenrtion = value!;
//             val_seedgen = slctseedgenrtion!.value;
//             slctseedgen = slctseedgenrtion!.name;
//
//           });
//         },
//         onClear: () {
//           setState(() {
//             slctseedgen = '';
//           });
//         }));
//
//     listings.add(txt_label_mandatory(
//         quantityreqest , Colors.black, 14.0, false));
//     listings.add(txtfieldAllowTwoDecimal(quantityreqest,quantityreqstController, true, 9));
//
//     listings.add(btn_dynamic(
//         label: add,
//         bgcolor: Colors.green,
//         txtcolor: Colors.white,
//         fontsize: 18.0,
//         centerRight: Alignment.centerRight,
//         margin: 20.0,
//         btnSubmit: () {
//           bool variety = false;
//           for (int i = 0; i < SeedemantModelList.length; i++) {
//             print("1st Variety" );
//             if (SeedemantModelList[i].seedvarietynameid == val_seedvarirty) {
//               variety = true;
//             }
//           }
//           if (slcseedvariety == '') {
//             errordialog(context, info, seedvarietyempty);
//           } else if (variety == true) {
//             errordialog(context, info,seedvarietyexistalert);
//           } else if (slctseedgen == "") {
//             errordialog(context, info, seedgenempty);
//           } else if (quantityreqstController!.value.text.length==0 || quantityreqstController!.value.text == '') {
//             errordialog(context, info, quantityreqestemp);
//           } else {
//             setState(() {
//               var SeedemandlistValues = new Seedemandmodel(
//                 slcseedvariety,
//                 val_seedvarirty,
//                 slctseedgen!,
//                 val_seedgen,
//                 quantityreqstController.text,
//               );
//               //confirmationPopup();
//               SeedemantModelList.add(SeedemandlistValues);
//             });
//
//             seedvarietynameHint="";
//             slctseedgen =seedgenrtionHint;
//             quantityreqstController.text= "";
//           }
//         }));
//     if (SeedemantModelList != '' && SeedemantModelList.length > 0) {
//       listings.add(DatatableSeedemand());
//     }
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
//                   saveseedmtcoll();
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
//   Widget DatatableSeedemand() {
//     // product[];
//     List<DataColumn> columns = [];
//     List<DataRow> rows = [];
//
//     /*Columns*/
//     //columns.add(DataColumn(label: Text('S.No')));
//     //columns.add(DataColumn(label: Text('Processing Centre/Warehouse')));
//     columns.add(DataColumn(label: Text(seedvarietyname)));
//     columns.add(DataColumn(label: Text(seedgenrtion)));
//     columns.add(DataColumn(label: Text(quantityreqest)));
//     columns.add(DataColumn(label: Text(delete)));
//
//     // columns.add(DataColumn(label: Text('Delete')));
//     /*Rows*/
//     for (int i = 0; i < SeedemantModelList.length; i++) {
//       int rowno = i + 1;
//       String Sno = rowno.toString();
//       List<DataCell> singlecell = [];
//
//       singlecell.add(DataCell(Text(SeedemantModelList[i].seedvarietyname)));
//       singlecell.add(DataCell(Text(SeedemantModelList[i].seedgen)));
//       singlecell.add(DataCell(Text(SeedemantModelList[i].qualityreq)));
//       singlecell.add(DataCell(InkWell(
//         onTap: () {
//           setState(() {
//             SeedemantModelList.removeAt(i);
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
//
//     Widget objWidget = datatable_dynamic(columns: columns, rows: rows);
//     return objWidget;
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
//   saveseedmtcoll() async {
//     if (slcagratecode == "") {
//       errordialog(context, info,agratecodeempty);
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
//             onPressed: () async {
//               try {
//                 Random rnd = new Random();
//                 int recNo = 100000 + rnd.nextInt(999999 - 100000);
//                 String revNo = recNo.toString();
//                 double totalamount = 0;
//                 // totalAmt = totalamount.toString();
//
//                 print(totalamount.toString());
//                 final now = new DateTime.now();
//                 String txntime = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
//                 String msgNo = DateFormat('yyyyMMddHHmmss').format(now);
//                 print('agentToken :' + servicePointId);
//                 print(msgNo);
//                 SharedPreferences prefs = await SharedPreferences.getInstance();
//                 String? agentid = prefs.getString("agentId");
//                 String? agentToken = prefs.getString("agentToken");
//                 print('agentToken :' + servicePointId);
//                 String insqry =
//                     'INSERT INTO "main"."txnHeader" ("isPrinted", "txnTime", "mode", "operType", "resentCount", "agentId", "agentToken", "msgNo", "servPointId", "txnRefId") VALUES ('
//                         '0, \'' +
//                         txntime +
//                         '\', '
//                             '\'01\', '
//                             '\'01\', '
//                             '\'0\', \'' +
//                         agentid! +
//                         '\',\' ' +
//                         agentToken! +
//                         '\',\' ' +
//                         msgNo +
//                         '\',\' ' +
//                         servicePointId +
//                         '\',\' ' +
//                         revNo +
//                         '\')';
//                 print('txnHeader ' + insqry);
//                 int succ = await db.RawInsert(insqry);
//                 print(succ);
//
//                 //Future<List<Map>> txnHeader = db.GetTableValues('txnHeader');
//
//                 AppDatas datas = new AppDatas();
//                 int custTransaction = await db.saveCustTransaction(
//                     txntime, datas.seedamdcoll_txn, revNo, '', '', seedamtcoltion);
//                 print('custTransaction : ' + custTransaction.toString());
//                 for (int i = 0; i < SeedemantModelList.length; i++) {
//                   String seedvarietynameid = SeedemantModelList[i].seedvarietynameid;
//                   String seedgenid = SeedemantModelList[i].seedgenid;
//                   String qualityreq = SeedemantModelList[i].qualityreq;
//                   String seedmins =
//                       'INSERT INTO "main"."seedemantList" ("recNo", "seedvarirtyname", "seedgen", "quantityreq") VALUES '
//                           '(\'' +
//                           revNo +
//                           '\',\' ' +
//                           seedvarietynameid +
//                           '\',\' ' +
//                           seedgenid +
//                           '\',\' ' +
//                           qualityreq +
//                           '\')';
//                   print("seedminserting " + seedmins);
//                   db.RawQuery(seedmins);
//                 }
//
//
//                 int seedmdcollsave = await db.SaveSeedmdcoll(
//                     revNo,
//                     '1',
//                     Lng,
//                     Lat,
//                     datas.rawpurchse_txn,
//                     txntime,
//                     seasoncode,
//                     datas.tenent,
//                     val_typpurchse,
//                     slcagratecode!,);
//
//                 print('seedmdcollsave : ' + seedmdcollsave.toString());
//
//                 List<Map> seedmdcoll = await db.GetTableValues('seedDemandcoll');
//                 print("seedmdcoll : " + seedmdcoll.toString());
//
//                 int issync = await db.UpdateTableValue('seedDemandcoll', 'isSynched', '0', 'recNo', revNo);
//
//                 Alert(
//                   context: context,
//                   type: AlertType.info,
//                   title: trasnsucc,
//                   desc: seedmtcoltrnssuccrecpid,
//                   buttons: [
//                     DialogButton(
//                       child: Text(
//                         ok,
//                         style: TextStyle(color: Colors.white, fontSize: 20),
//                       ),
//                       onPressed: () {
//                         Navigator.of(context).pushReplacement(MaterialPageRoute(
//                             builder: (BuildContext context) => DashBoard("", "")));
//                       },
//                       width: 120,
//                     ),
//                   ],
//                 ).show();
//               } catch (e) {
//                 print("invalid1 " + e.toString());
//                 // toast(e.toString());
//               }
//             },
//             width: 120,
//           ),
//           DialogButton(
//             child: Text(
//               "No",
//               style: TextStyle(color: Colors.white, fontSize: 20),
//             ),
//             onPressed: () {
//               Navigator.pop(context);
//             },
//             width: 120,
//           )
//         ],
//       ).show();
//     }
//
//   }
// }
