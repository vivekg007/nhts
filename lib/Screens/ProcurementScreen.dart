// import 'dart:math';
//
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:intl/intl.dart';
// import 'package:rflutter_alert/rflutter_alert.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:ucda/Database/Databasehelper.dart';
// import 'package:ucda/Database/Model/FarmerMaster.dart';
// import 'package:ucda/Model/ProcurementWeightModel.dart';
// import 'package:ucda/Model/UIModel.dart';
// import 'package:ucda/Model/dynamicfields.dart';
// import 'package:ucda/Utils/MandatoryDatas.dart';
//
// import '../commonLang/translateLang.dart';
//
// class Procurement extends StatefulWidget {
//   @override
//   ProcurementScreen createState() => ProcurementScreen();
// }
//
// class ProcurementScreen extends State<Procurement>
//     with TickerProviderStateMixin {
//   String Lat = "", Lng = "";
//   String procurementdate = '';
//   String Labelprocurementdate = 'Select Procurement Date';
//   String Labelprocurement_unregdate = 'Select Procurement Date';
//   String procurementdate_unreg = '';
//   String slctVillage = "";
//   String val_Village = "";
//   String slctFarmer = "";
//   String val_farmer = "";
//   String slctProduct = "";
//   String val_Product = "";
//   String slctVariety = "";
//   String val_Variety = "";
//   String slctGrade = "";
//   String val_Grade = "";
//
//   String slctVillage_unreg = "";
//   String val_Village_unreg = "";
//   String slctFarmer_unreg = "";
//   String val_farmer_unreg = "";
//   String slctProduct_unreg = "";
//   String val_Product_unreg = "";
//   String slctVariety_unreg = "";
//   String val_Variety_unreg = "";
//   String slctGrade_unreg = "";
//   String val_Grade_unreg = "";
//   String totalAmt = "";
//   List<DropdownMenuItem> villageList = [];
//   List<DropdownMenuItem> unreg_villageList = [];
//   List<DropdownMenuItem> farmerList = [];
//   List<DropdownMenuItem> unreg_farmerList = [];
//   List<DropdownMenuItem> ProductList = [];
//   List<DropdownMenuItem> unreg_ProductList = [];
//   List<DropdownMenuItem> VarietyList = [];
//   List<DropdownMenuItem> unreg_VarietyList = [];
//   List<DropdownMenuItem> GradeList = [];
//   List<DropdownMenuItem> unreg_GradeList = [];
//
//   TextEditingController regpriceController = new TextEditingController();
//   TextEditingController regbagsController = new TextEditingController();
//   TextEditingController NetWeightController = new TextEditingController();
//   TextEditingController BatchNoController = new TextEditingController();
//   TextEditingController unreg_priceController = new TextEditingController();
//   TextEditingController unreg_bagsController = new TextEditingController();
//   TextEditingController unreg_NetWeightController = new TextEditingController();
//   TextEditingController unreg_BatchNoController = new TextEditingController();
//   TextEditingController farmernameController = new TextEditingController();
//   TextEditingController mobilenoController = new TextEditingController();
//
//   TextEditingController regPaymentController = new TextEditingController();
//   TextEditingController unregPaymentController = new TextEditingController();
//   TextEditingController grossWeightController = new TextEditingController();
//   TextEditingController ungrossWeightController = new TextEditingController();
//
//   TextEditingController cashController = new TextEditingController();
//
//   List<ProcurementWeight> weightlist = [];
//   List<ProcurementWeight> unregweightlist = [];
//
//   List<UImodel> VillageListUIModel = [];
//   List<UImodel2> FarmerUIModel = [];
//   List<UImodel> ProductUIModel = [];
//   List<UImodel> VarietyUIModel = [];
//   List<UImodel> GradeUIModel = [];
//
//   List<UImodel> VillageListUIModel_Unreg = [];
//   List<UImodel> FarmerUIModel_Unreg = [];
//   List<UImodel> ProductUIModel_Unreg = [];
//   List<UImodel> VarietyUIModel_Unreg = [];
//   List<UImodel> GradeUIModel_Unreg = [];
//
//   List<Map> agents = [];
//
//   List<String> reg_pricelist = [];
//   List<String> unreg_pricelist = [];
//   String seasoncode = '0';
//   String agentCode = '0';
//   String procBatchNo = '';
//   String servicePointId = '0';
//   String procurementBalance = '0';
//   String farmerCode = '0';
//   List<FarmerMaster> farmermasterglo = [];
//   var db = DatabaseHelper();
//   double dummyvalues = -1;
//   bool productloaded = false;
//   bool varietyloaded = false;
//   bool gradeloaded = false;
//   bool farmerloaded = false;
//   String agentDistributionBal = "";
//   String currency = "";
//   String farmerLabelBalance = "Farmer Opening Balance";
//   String MobileUserBalLabel = "Mobile User Opening Balance";
//   int _currentIndex = 0;
//   TabController? _controller;
//
//   List<DropdownModel> seasonItems = [];
//   DropdownModel? slctSeason;
//   String slct_Season = "";
//   String val_Season = "";
//
//   List<DropdownModel> unseasonItems = [];
//   DropdownModel? unslctSeason;
//   String unslct_Season = "";
//   String unval_Season = "";
//
//   @override
//   void initState() {
//     super.initState();
//     initdata();
//
//     getLocation();
//     getClientData();
//     setState(() {
//       cashController.text = "0";
//     });
//     _controller = new TabController(vsync: this, length: 2);
//     _controller!.addListener(_handleTabSelection);
//   }
//
//   _handleTabSelection() {
//     setState(() {
//       _currentIndex = _controller!.index;
//       _controller!.animateTo(_currentIndex);
//     });
//
//     if (_currentIndex == 1) {
//       Labelprocurement_unregdate = 'Select Procurement Date';
//     } else if (_currentIndex == 0) {
//       Labelprocurementdate = 'Select Procurement Date';
//     }
//   }
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
//     print("procurement batch no: " + procBatchNo);
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
//           title: "Information",
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
//     List villagelist = await db.RawQuery('select * from villageList ');
//     print('villagelist ' + villagelist.toString());
//     VillageListUIModel = [];
//     VillageListUIModel_Unreg = [];
//     villageList.clear();
//     unreg_villageList.clear();
//     for (int i = 0; i < villagelist.length; i++) {
//       String villCode = villagelist[i]["villCode"].toString();
//       String villName = villagelist[i]["villName"].toString();
//
//       var uimodel = new UImodel(villName, villCode);
//       VillageListUIModel.add(uimodel);
//       VillageListUIModel_Unreg.add(uimodel);
//       setState(() {
//         villageList.add(DropdownMenuItem(
//           child: Text(villName),
//           value: villName,
//         ));
//         unreg_villageList.add(DropdownMenuItem(
//           child: Text(villName),
//           value: villName,
//         ));
//       });
//     }
//
//     loadProducts();
//   }
//
//   loadProducts() async {
//     productloaded = false;
//     List productslist = await db.RawQuery('select * from procurementProducts');
//     print('productslist ' + productslist.toString());
//     ProductUIModel = [];
//     ProductUIModel_Unreg = [];
//     ProductList = [];
//     ProductList = [];
//     ProductList.clear();
//
//     unreg_ProductList.clear();
//     for (int i = 0; i < productslist.length; i++) {
//       String productCode = productslist[i]["code"].toString();
//       String productName = productslist[i]["name"].toString();
//
//       var uimodel = new UImodel(productName, productCode);
//       ProductUIModel.add(uimodel);
//       ProductUIModel_Unreg.add(uimodel);
//       setState(() {
//         ProductList.add(DropdownMenuItem(
//           child: Text(productName),
//           value: productName,
//         ));
//         unreg_ProductList.add(DropdownMenuItem(
//           child: Text(productName),
//           value: productName,
//         ));
//       });
//     }
//
//     Future.delayed(Duration(milliseconds: 100), () {
//       // Do something
//       setState(() {
//         productloaded = true;
//       });
//     });
//   }
//
//   changeFarmerListReg(String villagecode) async {
//     List<FarmerMaster> farmermaster =
//         await db.GetFarmerdatabyVillage(villagecode);
//     //toast(farmermaster.length.toString());
//     FarmerUIModel = [];
//
//     farmerList.clear();
//     for (int i = 0; i < farmermaster.length; i++) {
//       String? farmercode = farmermaster[i].farmerId;
//       String? farmername = farmermaster[i].fName;
//       String? procurementBalance = farmermaster[i].procurementBalance;
//
//       var uimodel = new UImodel2(farmername!, farmercode!, procurementBalance!);
//       FarmerUIModel.add(uimodel);
//       setState(() {
//         farmerloaded = true;
//         farmerList.add(DropdownMenuItem(
//           child: Text(farmername),
//           value: farmername,
//         ));
//       });
//     }
//   }
//
//   changeFarmerListUnReg(String villagecode) async {
//     List<FarmerMaster> farmermaster =
//         await db.GetFarmerdatabyVillage(villagecode);
//
//     FarmerUIModel_Unreg = [];
//
//     unreg_farmerList.clear();
//     for (int i = 0; i < farmermaster.length; i++) {
//       String? farmercode = farmermaster[i].farmerCode;
//       String? farmername = farmermaster[i].fName;
//       var uimodel = new UImodel(farmername!, farmercode!);
//       FarmerUIModel_Unreg.add(uimodel);
//       setState(() {
//         unreg_farmerList.add(DropdownMenuItem(
//           child: Text(farmername),
//           value: farmername,
//         ));
//       });
//     }
//   }
//
//   changeVarietyReg(String productcode) async {
//     List varietyList = await db.RawQuery(
//         'select * from varietyList where prodId =\'' + productcode + '\'');
//     print('varietyList ' + varietyList.toString());
//     VarietyUIModel = [];
//     VarietyList = [];
//     VarietyList.clear();
//
//     if (varietyList.length > 0) {
//       for (int i = 0; i < varietyList.length; i++) {
//         String vCode = varietyList[i]["vCode"].toString();
//         String vName = varietyList[i]["vName"].toString();
//
//         var uimodel = new UImodel(vName, vCode);
//         VarietyUIModel.add(uimodel);
//
//         setState(() {
//           VarietyList.add(DropdownMenuItem(
//             child: Text(vName),
//             value: vName,
//           ));
//         });
//       }
//     }
//
//     Future.delayed(Duration(milliseconds: 500), () {
//       // Do something
//       setState(() {
//         slctVariety = "";
//         varietyloaded = true;
//       });
//     });
//
//     // setState(() {
//     //   varietyloaded = true;
//     // });
//   }
//
//   changeVarietyUnReg(String productcode) async {
//     List varietyList = await db.RawQuery(
//         'select * from varietyList where prodId =\'' + productcode + '\'');
//     print('varietyList ' + varietyList.toString());
//     VarietyUIModel_Unreg = [];
//     unreg_VarietyList = [];
//     unreg_VarietyList.clear();
//
//     if (varietyList.length > 0) {}
//     for (int i = 0; i < varietyList.length; i++) {
//       String vCode = varietyList[i]["vCode"].toString();
//       String vName = varietyList[i]["vName"].toString();
//       var uimodel = new UImodel(vName, vCode);
//
//       VarietyUIModel_Unreg.add(uimodel);
//       setState(() {
//         unreg_VarietyList.add(DropdownMenuItem(
//           child: Text(vName),
//           value: vName,
//         ));
//       });
//     }
//
//     Future.delayed(Duration(milliseconds: 500), () {
//       // Do something
//       setState(() {
//         slctVariety_unreg = "";
//         varietyloaded = true;
//       });
//     });
//     // setState(() {
//     //   varietyloaded = true;
//     // });
//   }
//
//   ChangeGradeReg(String VarietyCode) async {
//     List procurementGrade = await db.RawQuery(
//         'select * from procurementGrade where vCode =\'' + VarietyCode + '\'');
//
//     print('procurementGrade ' + procurementGrade.toString());
//     GradeUIModel = [];
//     reg_pricelist = [];
//     GradeList = [];
//     GradeList.clear();
//     reg_pricelist.clear();
//
//     if (procurementGrade.length > 0) {
//       for (int i = 0; i < procurementGrade.length; i++) {
//         String gradeCode = procurementGrade[i]["gradeCode"].toString();
//         String grade = procurementGrade[i]["grade"].toString();
//         String price = procurementGrade[i]['price'].toString();
//
//         var uimodel = new UImodel(grade, gradeCode);
//         GradeUIModel.add(uimodel);
//         reg_pricelist.add(price);
//
//         setState(() {
//           GradeList.add(DropdownMenuItem(
//             child: Text(grade),
//             value: grade,
//           ));
//         });
//       }
//     }
//
//     Future.delayed(Duration(milliseconds: 500), () {
//       // Do something
//       setState(() {
//         slctGrade = "";
//         gradeloaded = true;
//       });
//     });
//
//     // setState(() {
//     //   gradeloaded = true;
//     // });
//   }
//
//   ChangeGradeUnReg(String VarietyCode) async {
//     List procurementGrade = await db.RawQuery(
//         'select * from procurementGrade where vCode =\'' + VarietyCode + '\'');
//
//     print('procurementGrade ' + procurementGrade.toString());
//
//     GradeUIModel_Unreg = [];
//     reg_pricelist = [];
//     unreg_GradeList = [];
//     unreg_GradeList.clear();
//     unreg_pricelist.clear();
//     if (procurementGrade.length > 0) {
//       for (int i = 0; i < procurementGrade.length; i++) {
//         String gradeCode = procurementGrade[i]["gradeCode"].toString();
//         String grade = procurementGrade[i]["grade"].toString();
//         String price = procurementGrade[i]['price'].toString();
//
//         var uimodel = new UImodel(grade, gradeCode);
//
//         GradeUIModel_Unreg.add(uimodel);
//         unreg_pricelist.add(price);
//         setState(() {
//           unreg_GradeList.add(DropdownMenuItem(
//             child: Text(grade),
//             value: grade,
//           ));
//         });
//       }
//     }
//
//     Future.delayed(Duration(milliseconds: 500), () {
//       // Do something
//       setState(() {
//         slctGrade_unreg = "";
//         gradeloaded = true;
//       });
//     });
//
//     // setState(() {
//     //   gradeloaded = true;
//     // });
//   }
//
//   Future<bool> _onBackPressed() async {
//     return (await Alert(
//           context: context,
//           type: AlertType.warning,
//           title: TranslateFun.langList['cnclCls'],
//           desc: TranslateFun.langList['ruWanCanclCls'],
//           buttons: [
//             DialogButton(
//               child: Text(
//                 TranslateFun.langList['yesCls'],
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
//                 TranslateFun.langList['noCls'],
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
//     return WillPopScope(
//       onWillPop: _onBackPressed,
//       child: MaterialApp(
//         theme: ThemeData(
//           primarySwatch: Colors.green,
//           buttonColor: Colors.green,
//         ),
//         home: DefaultTabController(
//           length: 2,
//           child: Container(
//             child: Scaffold(
//               appBar: AppBar(
//                 bottom: TabBar(
//                   indicatorColor: Colors.black54,
//                   controller: _controller,
//                   tabs: [
//                     Tab(text: 'Registered Farmer'),
//                     Tab(text: 'UnRegistered Farmer')
//                   ],
//                 ),
//                 leading: IconButton(
//                     icon: Icon(Icons.arrow_back, color: Colors.white),
//                     onPressed: () {
//                       _onBackPressed();
//                     }),
//                 title: Text('Procurement'),
//               ),
//               body: TabBarView(controller: _controller, children: [
//                 Container(
//                   child: ListView(
//                     padding: EdgeInsets.all(10.0),
//                     children: _RegisteredUI(
//                         context), // <<<<< Note this change for the return type
//                   ),
//                 ),
//                 Container(
//                   child: ListView(
//                     padding: EdgeInsets.all(10.0),
//                     children: _UnRegisteredUI(
//                         context), // <<<<< Note this change for the return type
//                   ),
//                 ),
//               ]),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   generateBatchNo(String farmerCode) async {
//     final now = new DateTime.now();
//     String date = DateFormat('ddMMyyyy').format(now);
//     print("Date Now:" + date);
//     agents = await db.RawQuery('SELECT * FROM agentMaster');
//
//     //  agentdata = await db.getUser();
//
//     String previousBatchNo = agents[0]['procBatchNo'];
//     print('previousBatchNo ' + previousBatchNo);
//     if (previousBatchNo == "") {
//       previousBatchNo = "AB-00-00-00";
//     }
//     String agentcode = agentCode.toString();
//     print(agentcode);
//     String checkDate = previousBatchNo.split("-")[2];
//     print(checkDate);
//     int sno = int.parse(previousBatchNo.split("-")[3]);
//     print("serial no: " + sno.toString());
//     int bno = 0;
//     String batchNum = "0";
//
//     if (date == checkDate) {
//       setState(() {
//         if (bno < 9) {
//           bno = sno + 1;
//           previousBatchNo = agentcode +
//               "-" +
//               farmerCode +
//               "-" +
//               date +
//               "-" +
//               "0" +
//               bno.toString();
//           print("Batch No: Current " + previousBatchNo);
//           setState(() {
//             BatchNoController.text = previousBatchNo;
//           });
//         } else {
//           bno = sno + 1;
//           previousBatchNo =
//               agentcode + "-" + farmerCode + "-" + date + "-" + bno.toString();
//           print("Batch No: " + previousBatchNo);
//           setState(() {
//             BatchNoController.text = previousBatchNo;
//           });
//         }
//       });
//     } else {
//       print("current date");
//       setState(() {
//         sno = 1;
//         previousBatchNo = agentcode +
//             "-" +
//             farmerCode +
//             "-" +
//             date +
//             "-" +
//             "0" +
//             sno.toString();
//         print("Batch No: " + batchNum);
//         setState(() {
//           BatchNoController.text = previousBatchNo;
//         });
//       });
//     }
//   }
//
//   List<Widget> _RegisteredUI(BuildContext context) {
//     List<Widget> listings = [];
//     listings.add(txt_label_mandatory("Date", Colors.black, 14.0, false));
//     listings.add(selectDate(
//       context1: context,
//       slctdate: Labelprocurementdate,
//       onConfirm: (date) => setState(() {
//         procurementdate = DateFormat('yyyy-MM-dd HH:mm:ss').format(date!);
//         Labelprocurementdate = DateFormat('yyyy-MM-dd').format(date);
//         //print('CHECKJOIINGDFATE:2 '+icsjoiningDate);
//       }),
//     ));
//
//     listings.add(txt_label_mandatory("Season", Colors.black, 14.0, false));
//     listings.add(DropDownWithModel(
//       itemlist: seasonItems,
//       selecteditem: slctSeason,
//       hint: "Select season",
//       onChanged: (value) {
//         setState(() {
//           slctSeason = value!;
//           val_Season = slctSeason!.value;
//           slct_Season = slctSeason!.name;
//           print("name of the val_Season:" + val_Season);
//         });
//       },
//     ));
//
//     listings.add(txt_label_mandatory("Village", Colors.black, 14.0, false));
//     listings.add(singlesearchDropdown(
//         itemlist: villageList,
//         selecteditem: slctVillage,
//         hint: "Search the Village",
//         onClear: () {
//           setState(() {
//             farmerloaded = false;
//           });
//         },
//         onChanged: (value) {
//           setState(() {
//             slctVillage = value!;
//             for (int i = 0; i < VillageListUIModel.length; i++) {
//               if (VillageListUIModel[i].name == slctVillage) {
//                 val_Village = VillageListUIModel[i].value;
//                 farmerloaded = false;
//                 changeFarmerListReg(VillageListUIModel[i].value);
//               }
//             }
//           });
//         }));
//     if (farmerloaded) {
//       listings.add(txt_label_mandatory("Farmer", Colors.black, 14.0, false));
//       listings.add(singlesearchDropdown(
//           itemlist: farmerList,
//           selecteditem: slctFarmer,
//           hint: "Search the Farmer",
//           onChanged: (value) {
//             setState(() {
//               slctFarmer = value!;
//               for (int i = 0; i < FarmerUIModel.length; i++) {
//                 if (FarmerUIModel[i].name == slctFarmer) {
//                   val_farmer = FarmerUIModel[i].value;
//                   procurementBalance = FarmerUIModel[i].value2;
//
//                   if (double.parse(procurementBalance) == 0) {
//                     farmerLabelBalance = "Farmer Opening Balance";
//                   } else if (double.parse(procurementBalance) > 0) {
//                     farmerLabelBalance = "Farmer Credit Balance";
//                   } else if (double.parse(procurementBalance) < 0) {
//                     farmerLabelBalance = "Farmer OutStanding Balance";
//                   }
//                   generateBatchNo(val_farmer);
//                 }
//               }
//             });
//           }));
//     }
//
//     if (productloaded = true) {
//       listings.add(txt_label_mandatory("Crop", Colors.black, 14.0, false));
//       listings.add(singlesearchDropdown(
//           itemlist: ProductList,
//           selecteditem: productloaded ? slctProduct : "",
//           hint: "Select Crop",
//           onClear: () {
//             setState(() {
//               slctProduct = '';
//               slctVariety = '';
//             });
//           },
//           onChanged: (value) {
//             setState(() {
//               slctProduct = value!;
//               varietyloaded = false;
//               slctVariety = "";
//               VarietyList = [];
//             });
//             for (int i = 0; i < ProductUIModel.length; i++) {
//               if (ProductUIModel[i].name == slctProduct) {
//                 val_Product = ProductUIModel[i].value;
//                 changeVarietyReg(val_Product);
//               }
//             }
//           }));
//       if (!varietyloaded) {
//         listings.add(txt_label_mandatory("Variety", Colors.black, 14.0, false));
//         listings.add(singlesearchDropdown(
//             itemlist: VarietyList,
//             selecteditem: varietyloaded ? slctVariety : "",
//             hint: "Select Variety",
//             onClear: () {
//               setState(() {
//                 slctVariety = '';
//                 slctGrade = '';
//               });
//             },
//             onChanged: (value) {
//               setState(() {
//                 slctVariety = value!;
//                 gradeloaded = false;
//                 slctGrade = "";
//                 GradeList = [];
//               });
//               for (int i = 0; i < VarietyUIModel.length; i++) {
//                 if (VarietyUIModel[i].name == slctVariety) {
//                   val_Variety = VarietyUIModel[i].value;
//                   ChangeGradeReg(val_Variety);
//                 }
//               }
//             }));
//       }
//
//       if (!gradeloaded) {
//         listings.add(txt_label_mandatory("Grade", Colors.black, 14.0, false));
//         listings.add(singlesearchDropdown(
//             itemlist: GradeList,
//             selecteditem: gradeloaded ? slctGrade : "",
//             hint: "Select Grade",
//             onChanged: (value) {
//               setState(() {
//                 slctGrade = value!;
//                 for (int i = 0; i < GradeUIModel.length; i++) {
//                   if (GradeUIModel[i].name == slctGrade) {
//                     val_Grade = GradeUIModel[i].value;
//                     regpriceController.text = reg_pricelist[i];
//                   }
//                 }
//               });
//             }));
//       }
//
//       listings.add(txt_label_mandatory("Unit", Colors.black, 14.0, false));
//       listings.add(
//           txtfield_digitswithoutdecimal("Unit", regbagsController, true, 3));
//
//       listings.add(txt_label_mandatory(
//           "Price Per Unit (" + currency + ")", Colors.black, 14.0, false));
//       listings.add(txtfield_digits("Price", regpriceController, true, 6, 2));
//     }
//
//     listings.add(txt_label_mandatory("No of Bags", Colors.black, 14.0, false));
//     listings.add(txtfield_digitswithoutdecimal(
//         "No of Bags", regbagsController, true, 3));
//
//     listings.add(txt_label_mandatory("Net Weight ", Colors.black, 14.0, false));
//     listings
//         .add(txtfield_digits("Net Weight", NetWeightController, true, 6, 2));
//
//     listings
//         .add(txt_label_mandatory("Gross Weight ", Colors.black, 14.0, false));
//     listings.add(
//         txtfield_digits("Gross Weight", grossWeightController, true, 6, 2));
//
//     listings
//         .add(txt_label_mandatory("Payment Amount ", Colors.black, 14.0, false));
//     listings
//         .add(txtfield_dynamic("Payment Amount", regPaymentController, false));
//
//     listings.add(txt_label_mandatory("Batch No ", Colors.black, 14.0, false));
//     listings.add(txtfield_dynamic("Batch No", BatchNoController, false));
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
//                   btnSubmitReg();
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
//   generateBatchNoUnReg(String farmerCode) async {
//     final now = new DateTime.now();
//     String date = DateFormat('ddMMyyyy').format(now);
//     print("Date Now:" + date);
//     agents = await db.RawQuery('SELECT * FROM agentMaster');
//
//     //  agentdata = await db.getUser();
//
//     String previousBatchNo = agents[0]['procBatchNo'];
//     print('previousBatchNo ' + previousBatchNo);
//     if (previousBatchNo == "") {
//       previousBatchNo = "AB-00-00-00";
//     }
//     String agentcode = agentCode.toString();
//     print(agentcode);
//     String checkDate = previousBatchNo.split("-")[2];
//     print(checkDate);
//     int sno = int.parse(previousBatchNo.split("-")[3]);
//     print("serial no: " + sno.toString());
//     int bno = 0;
//     String batchNum = "0";
//
//     if (date == checkDate) {
//       setState(() {
//         if (bno < 9) {
//           bno = sno + 1;
//           previousBatchNo = agentcode +
//               "-" +
//               farmerCode +
//               "-" +
//               date +
//               "-" +
//               "0" +
//               bno.toString();
//           print("Batch No: Current " + previousBatchNo);
//           setState(() {
//             unreg_BatchNoController.text = previousBatchNo;
//           });
//         } else {
//           bno = sno + 1;
//           previousBatchNo =
//               agentcode + "-" + farmerCode + "-" + date + "-" + bno.toString();
//           print("Batch No: " + previousBatchNo);
//           setState(() {
//             unreg_BatchNoController.text = previousBatchNo;
//           });
//         }
//       });
//     } else {
//       print("current date");
//       setState(() {
//         sno = 1;
//         previousBatchNo = agentcode +
//             "-" +
//             farmerCode +
//             "-" +
//             date +
//             "-" +
//             "0" +
//             sno.toString();
//         print("Batch No: " + batchNum);
//         setState(() {
//           unreg_BatchNoController.text = previousBatchNo;
//         });
//       });
//     }
//   }
//
//   List<Widget> _UnRegisteredUI(BuildContext context) {
//     List<Widget> listings = [];
//     listings.add(
//         txt_label_mandatory("Procurement Date ", Colors.black, 14.0, false));
//     listings.add(selectDate(
//       context1: context,
//       slctdate: Labelprocurement_unregdate,
//       onConfirm: (date) => setState(() {
//         procurementdate_unreg = DateFormat('yyyy-MM-dd HH:mm:ss').format(date!);
//         Labelprocurement_unregdate = DateFormat('yyyy-MM-dd').format(date);
//         //print('CHECKJOIINGDFATE:2 '+icsjoiningDate);
//       }),
//     ));
//
//     listings.add(txt_label_mandatory("Season", Colors.black, 14.0, false));
//     listings.add(DropDownWithModel(
//       itemlist: unseasonItems,
//       selecteditem: unslctSeason,
//       hint: "Select season",
//       onChanged: (value) {
//         setState(() {
//           unslctSeason = value!;
//           unval_Season = unslctSeason!.value;
//           unslct_Season = unslctSeason!.name;
//           print("name of the val_Season:" + unval_Season);
//         });
//       },
//     ));
//
//     listings.add(txt_label_mandatory("Village ", Colors.black, 14.0, false));
//     listings.add(singlesearchDropdown(
//         itemlist: unreg_villageList,
//         selecteditem: slctVillage_unreg,
//         hint: "Search the Village",
//         onChanged: (value) {
//           setState(() {
//             slctVillage_unreg = value!;
//             for (int i = 0; i < VillageListUIModel_Unreg.length; i++) {
//               if (VillageListUIModel_Unreg[i].name == slctVillage_unreg) {
//                 val_Village_unreg = VillageListUIModel_Unreg[i].value;
//               }
//             }
//             generateBatchNoUnReg("000000");
//           });
//         }));
//     listings
//         .add(txt_label_mandatory("Farmer Name ", Colors.black, 14.0, false));
//     listings.add(txtfield_dynamic("Farmer Name", farmernameController, true));
//
//     listings.add(txt_label_mandatory("Product ", Colors.black, 14.0, false));
//     if (productloaded) {
//       listings.add(singlesearchDropdown(
//           itemlist: unreg_ProductList,
//           selecteditem: productloaded ? slctProduct_unreg : "",
//           hint: "Select Crop",
//           onClear: () {
//             setState(() {
//               slctProduct = '';
//               slctVariety_unreg = '';
//             });
//           },
//           onChanged: (value) {
//             setState(() {
//               slctProduct_unreg = value!;
//               varietyloaded = false;
//               slctVariety_unreg = "";
//               unreg_VarietyList = [];
//             });
//             for (int i = 0; i < ProductUIModel_Unreg.length; i++) {
//               if (ProductUIModel_Unreg[i].name == slctProduct_unreg) {
//                 val_Product_unreg = ProductUIModel_Unreg[i].value;
//                 changeVarietyUnReg(val_Product_unreg);
//               }
//             }
//           }));
//       if (varietyloaded) {
//         listings.add(txt_label_mandatory("Variety", Colors.black, 14.0, false));
//         listings.add(singlesearchDropdown(
//             itemlist: unreg_VarietyList,
//             selecteditem: varietyloaded ? slctVariety_unreg : "",
//             hint: "Select Variety",
//             onClear: () {
//               setState(() {
//                 slctVariety_unreg = '';
//                 slctGrade_unreg = '';
//               });
//             },
//             onChanged: (value) {
//               setState(() {
//                 slctVariety_unreg = value!;
//                 gradeloaded = false;
//                 slctGrade_unreg = "";
//                 unreg_GradeList = [];
//               });
//               for (int i = 0; i < VarietyUIModel_Unreg.length; i++) {
//                 if (VarietyUIModel_Unreg[i].name == slctVariety_unreg) {
//                   val_Variety_unreg = VarietyUIModel_Unreg[i].value;
//                   ChangeGradeUnReg(val_Variety_unreg);
//                 }
//               }
//             }));
//       }
//       if (gradeloaded) {
//         listings.add(txt_label_mandatory("Grade", Colors.black, 14.0, false));
//         listings.add(singlesearchDropdown(
//             itemlist: unreg_GradeList,
//             selecteditem: gradeloaded ? slctGrade_unreg : "",
//             hint: "Select Grade",
//             onChanged: (value) {
//               setState(() {
//                 slctGrade_unreg = value!;
//                 for (int i = 0; i < GradeUIModel_Unreg.length; i++) {
//                   if (GradeUIModel_Unreg[i].name == slctGrade_unreg) {
//                     val_Grade_unreg = GradeUIModel_Unreg[i].value;
//                     unreg_priceController.text = unreg_pricelist[i];
//                   }
//                 }
//               });
//             }));
//       }
//
//       listings.add(txt_label_mandatory(
//           "Price Per Unit (" + currency + ")", Colors.black, 14.0, false));
//       listings.add(txtfield_digits("Price", unreg_priceController, true));
//     }
//     listings.add(txt_label_mandatory("No. of Bags", Colors.black, 14.0, false));
//     listings.add(txtfield_digitswithoutdecimal(
//         "No. of Bags", unreg_bagsController, true));
//
//     listings.add(txt_label_mandatory("Net Weight", Colors.black, 14.0, false));
//     listings
//         .add(txtfield_digits("Net Weight", unreg_NetWeightController, true));
//
//     listings
//         .add(txt_label_mandatory("Gross Weight", Colors.black, 14.0, false));
//     listings
//         .add(txtfield_digits("Gross Weight", ungrossWeightController, true));
//
//     listings
//         .add(txt_label_mandatory("Payment Amount ", Colors.black, 14.0, false));
//     listings
//         .add(txtfield_dynamic("Payment Amount", unregPaymentController, false));
//     listings.add(txt_label_mandatory("Batch No", Colors.black, 14.0, false));
//     listings.add(txtfield_dynamic("Batch No", unreg_BatchNoController, false));
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
//                   btnSubmitUnReg();
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
//   void btnSubmitReg() async {}
//
//   void btnSubmitUnReg() async {}
//
//   Widget Datatablereg() {
//     List<DataColumn> columns = <DataColumn>[];
//     List<DataRow> rows = <DataRow>[];
//     columns.add(DataColumn(label: Text('Crops')));
//     columns.add(DataColumn(label: Text('No of \nBags')));
//     columns.add(DataColumn(label: Text('Net Weight')));
//     columns.add(DataColumn(label: Text('Delete')));
//
//     for (int i = 0; i < weightlist.length; i++) {
//       List<DataCell> singlecell = <DataCell>[];
//       //1
//       singlecell.add(DataCell(Text(weightlist[i].productname! +
//           "/" +
//           weightlist[i].varietyname! +
//           "/" +
//           weightlist[i].grade!)));
//
//       //2
//       TextEditingController controller = new TextEditingController();
//       controller.text = weightlist[i].Nobags!;
//       singlecell.add(DataCell(
//           TextFormField(
//             controller: controller,
//             keyboardType: TextInputType.number,
//             inputFormatters: [
//               FilteringTextInputFormatter.digitsOnly,
//               LengthLimitingTextInputFormatter(3),
//             ],
//             onFieldSubmitted: (val) {
//               setState(() {
//                 if (val == '0') {
//                   controller.text = '';
//                   errordialog(context, "Alert", "No bags should not be zero");
//                 } else if (double.parse(val) >
//                     double.parse(weightlist[i].netweight!)) {
//                   errordialog(context, "Alert",
//                       "Net weight should not be smaller than no of bags");
//                   controller.text = weightlist[i].Nobags!;
//                 } else {
//                   setState(() {
//                     weightlist[i].Nobags = val;
//                   });
//                 }
//               });
//             },
//           ),
//           showEditIcon: true));
//       //3
//       TextEditingController controller2 = new TextEditingController();
//       controller2.text = weightlist[i].netweight!;
//       singlecell.add(DataCell(
//           TextFormField(
//             controller: controller2,
//             keyboardType: TextInputType.number,
//             inputFormatters: [
//               LengthLimitingTextInputFormatter(6),
//               FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
//             ],
//             onFieldSubmitted: (val) {
//               setState(() {
//                 if (val == '0') {
//                   controller2.text = '';
//                   errordialog(
//                       context, "Alert", "Net weight should not be zero");
//                 } else if (double.parse(val) <
//                     double.parse(weightlist[i].Nobags!)) {
//                   errordialog(context, "Alert",
//                       "Net weight should not be smaller than no of bags");
//                   controller2.text = weightlist[i].netweight!;
//                 } else {
//                   setState(() {
//                     weightlist[i].netweight = val;
//                   });
//                 }
//               });
//             },
//           ),
//           showEditIcon: true));
//       singlecell.add(DataCell(InkWell(
//         onTap: () {
//           setState(() {
//             weightlist.removeAt(i);
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
//   Widget DatatableUnreg() {
//     List<DataColumn> columns = <DataColumn>[];
//     List<DataRow> rows = <DataRow>[];
//     columns.add(DataColumn(label: Text('Crops')));
//     columns.add(DataColumn(label: Text('No of \nBags')));
//     columns.add(DataColumn(label: Text('Net Weight')));
//     columns.add(DataColumn(label: Text('Delete')));
//
//     for (int i = 0; i < unregweightlist.length; i++) {
//       List<DataCell> singlecell = <DataCell>[];
//       singlecell.add(DataCell(Text(unregweightlist[i].productname! +
//           "/" +
//           unregweightlist[i].varietyname! +
//           "/" +
//           unregweightlist[i].grade!)));
//
//       TextEditingController controller = new TextEditingController();
//       controller.text = unregweightlist[i].Nobags!;
//       // singlecell.add(DataCell(Text(weightlist[i].quantity)));
//       singlecell.add(DataCell(
//           TextFormField(
//             controller: controller,
//             keyboardType: TextInputType.number,
//             inputFormatters: [
//               FilteringTextInputFormatter.digitsOnly,
//               LengthLimitingTextInputFormatter(3),
//             ],
//             onFieldSubmitted: (val) {
//               setState(() {
//                 if (val == '0') {
//                   controller.text = '';
//                   errordialog(context, "Alert", "No bags should not be zero");
//                 } else if (double.parse(val) >
//                     double.parse(unregweightlist[i].netweight!)) {
//                   errordialog(context, "Alert",
//                       "Net weight should not be smaller than no of bags");
//                   controller.text = unregweightlist[i].Nobags!;
//                 } else {
//                   setState(() {
//                     unregweightlist[i].Nobags = val;
//                   });
//                 }
//               });
//             },
//           ),
//           showEditIcon: true));
//
//       TextEditingController controller2 = new TextEditingController();
//       controller2.text = unregweightlist[i].netweight!;
//       // singlecell.add(DataCell(Text(weightlist[i].quantity)));
//       singlecell.add(DataCell(
//           TextFormField(
//             controller: controller2,
//             keyboardType: TextInputType.number,
//             inputFormatters: [
//               LengthLimitingTextInputFormatter(6),
//               FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
//             ],
//             onFieldSubmitted: (val) {
//               setState(() {
//                 if (val == '0') {
//                   controller2.text = '';
//                   errordialog(
//                       context, "Alert", "Net weight should not be zero");
//                 } else if (double.parse(val) <
//                     double.parse(unregweightlist[i].Nobags!)) {
//                   errordialog(context, "Alert",
//                       "Net weight should not be smaller than no of bags");
//                   controller2.text = unregweightlist[i].netweight!;
//                 } else {
//                   setState(() {
//                     unregweightlist[i].netweight = val;
//                   });
//                 }
//               });
//             },
//           ),
//           showEditIcon: true));
//       singlecell.add(DataCell(InkWell(
//         onTap: () {
//           setState(() {
//             unregweightlist.removeAt(i);
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
//   saveProcurementReg() async {
//     try {
//       Random rnd = new Random();
//       int recNo = 100000 + rnd.nextInt(999999 - 100000);
//       String revNo = recNo.toString();
//       double totalamount = 0;
//       for (int i = 0; i < weightlist.length; i++) {
//         double amt = double.parse(weightlist[i].price!);
//         totalamount = amt + totalamount;
//       }
//       totalAmt = totalamount.toString();
//
//       print(totalamount.toString());
//       final now = new DateTime.now();
//       String txntime = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
//       String msgNo = DateFormat('yyyyMMddHHmmss').format(now);
//       print('agentToken :' + servicePointId);
//       print(msgNo);
//       SharedPreferences prefs = await SharedPreferences.getInstance();
//       String? agentid = prefs.getString("agentId");
//       String? agentToken = prefs.getString("agentToken");
//       print('agentToken :' + servicePointId);
//       String insqry =
//           'INSERT INTO "main"."txnHeader" ("isPrinted", "txnTime", "mode", "operType", "resentCount", "agentId", "agentToken", "msgNo", "servPointId", "txnRefId") VALUES ('
//                   '0, \'' +
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
//           txntime, datas.procure_txn, revNo, '', '', '');
//       print('custTransaction : ' + custTransaction.toString());
//       int procurementsave = await db.SaveProcurement(
//           recNo: "",
//           procId: "",
//           procType: "",
//           farmerId: "",
//           farmerName: "",
//           totalAmt: "",
//           isSynched: "",
//           procDate: "",
//           village: "",
//           pmtAmt: "",
//           season: "",
//           year: "",
//           driverName: "",
//           vehicleNo: "",
//           chartNo: "",
//           pDate: "",
//           city: "",
//           poNo: "",
//           samCode: "",
//           isReg: "",
//           mobileNo: "",
//           supplierType: "",
//           currentSeason: "",
//           roadMap: "",
//           vehicle: "",
//           farmId: "",
//           substituteFarmer: "",
//           farmerAttend: "",
//           farmCode: "",
//           farmerCode: "",
//           longitude: "",
//           latitude: "",
//           supplierTypeTxt: "",
//           labourCost: "",
//           transportCost: "",
//           farmFFC: "",
//           cropTypeProc: "",
//           invoiceNo: "",
//           buyerProc: "",
//           modeTrans: "");
//       print('procurementsave : ' + procurementsave.toString());
//       String netweight = "";
//       for (int i = 0; i < weightlist.length; i++) {
//         print(weightlist.length.toString());
//         netweight = weightlist[i].netweight!;
//         String Nobags = weightlist[i].Nobags!;
//         String productname = weightlist[i].productname!;
//         String price = weightlist[i].price!;
//         String grade = weightlist[i].gradeid!;
//         String productid = weightlist[i].productid!;
//         String varietyid = weightlist[i].varietyid!;
//         String varietyname = weightlist[i].varietyname!;
//         String batchNo = weightlist[i].batchNo!;
//
//         // int procurementdetails = await db.saveProcurementDetails(
//         //     productid,
//         //     price,
//         //     revNo,
//         //     totalAmt,
//         //     grade,
//         //     Nobags,
//         //     netweight,
//         //     "",
//         //     netweight,
//         //     batchNo,
//         //     "",
//         //     "",
//         //     val_farmer);
//         // print('procurementdetails : ' + procurementdetails.toString());
//       }
//
//       List<Map> procurement = await db.GetTableValues('procurement');
//       print("procurement : " + procurement.toString());
//       List<Map> procurementDetails =
//           await db.GetTableValues('procurementDetails');
//       print("procurementDetails : " + procurementDetails.toString());
//
//       double agentBal = double.parse(agentDistributionBal);
//       double mob = double.parse(procurementBalance);
//       print("mobile " + mob.toString());
//       print("netweight" + NetWeightController.text);
//       double wt = double.parse(netweight);
//       print("weught " + netweight.toString());
//       double cash = 0;
//       if (cashController.text != '') {
//         cash = double.parse(cashController.text);
//       }
//
//       print("cash " + cash.toString());
//       double bal = mob + cash;
//       print("bal " + bal.toString());
//       int upd = await db.UpdateTableValue('farmer_master', 'procurementBalance',
//           bal.toString(), 'farmerId', val_farmer);
//
//       print("agentbalance" + agentBal.toString());
//       double agentbalance = agentBal - cash;
//       String agentBalqry = 'Update agentMaster set agentProcurmentBal=\'' +
//           agentbalance.toString() +
//           '\'';
//       db.RawUpdate(agentBalqry);
//       int issync = await db.UpdateTableValue(
//           'procurement', 'isSynched', '0', 'recNo', revNo);
//       Alert(
//         context: context,
//         type: AlertType.info,
//         title: "Transaction Successful",
//         desc: "Procurement Successful.\nYour receipt ID is " + revNo,
//         buttons: [
//           DialogButton(
//             child: Text(
//               "OK",
//               style: TextStyle(color: Colors.white, fontSize: 20),
//             ),
//             onPressed: () {
//               Navigator.pop(context);
//               Navigator.pop(context);
//               Navigator.pop(context);
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
//
//   saveProcurementUnregistered() async {
//     try {
//       Random rnd = new Random();
//       int recNo = 100000 + rnd.nextInt(999999 - 100000);
//       String revNo = recNo.toString();
//       double totalamount = 0;
//       for (int i = 0; i < unregweightlist.length; i++) {
//         double amt = double.parse(unregweightlist[i].price!);
//         totalamount = amt + totalamount;
//       }
//       totalAmt = totalamount.toString();
//       final now = new DateTime.now();
//       String txntime = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
//       String msgNo = DateFormat('yyyyMMddHHmmss').format(now);
//
//       SharedPreferences prefs = await SharedPreferences.getInstance();
//       String? agentid = prefs.getString("agentId");
//       String? agentToken = prefs.getString("agentToken");
//       String insqry =
//           'INSERT INTO "main"."txnHeader" ("isPrinted", "txnTime", "mode", "operType", "resentCount", "agentId", "agentToken", "msgNo", "servPointId", "txnRefId") VALUES ('
//                   '0, \'' +
//               txntime +
//               '\', '
//                   '\'02\', '
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
//       AppDatas datas = new AppDatas();
//       int custTransaction = await db.saveCustTransaction(
//           txntime, datas.procure_txn, revNo, '', '', '');
//       print('custTransaction : ' + custTransaction.toString());
//       int procurementsave = await db.SaveProcurement(
//           recNo: "",
//           procId: "",
//           procType: "",
//           farmerId: "",
//           farmerName: "",
//           totalAmt: "",
//           isSynched: "",
//           procDate: "",
//           village: "",
//           pmtAmt: "",
//           season: "",
//           year: "",
//           driverName: "",
//           vehicleNo: "",
//           chartNo: "",
//           pDate: "",
//           city: "",
//           poNo: "",
//           samCode: "",
//           isReg: "",
//           mobileNo: "",
//           supplierType: "",
//           currentSeason: "",
//           roadMap: "",
//           vehicle: "",
//           farmId: "",
//           substituteFarmer: "",
//           farmerAttend: "",
//           farmCode: "",
//           farmerCode: "",
//           longitude: "",
//           latitude: "",
//           supplierTypeTxt: "",
//           labourCost: "",
//           transportCost: "",
//           farmFFC: "",
//           cropTypeProc: "",
//           invoiceNo: "",
//           buyerProc: "",
//           modeTrans: "");
//       print('procurementsave : ' + procurementsave.toString());
//       for (int i = 0; i < unregweightlist.length; i++) {
//         print(unregweightlist.length.toString());
//         String netweight = unregweightlist[i].netweight!;
//         String Nobags = unregweightlist[i].Nobags!;
//         String productname = unregweightlist[i].productname!;
//         String price = unregweightlist[i].price!;
//         String grade = unregweightlist[i].gradeid!;
//         String productid = unregweightlist[i].productid!;
//         String varietyid = unregweightlist[i].varietyid!;
//         String varietyname = unregweightlist[i].varietyname!;
//         String batchNo = unregweightlist[i].batchNo!;
//         // int procurementdetails = await db.saveProcurementDetails(
//         //     productid,
//         //     price,
//         //     revNo,
//         //     totalAmt,
//         //     grade,
//         //     Nobags,
//         //     netweight,
//         //     "",
//         //     netweight,
//         //     batchNo,
//         //     "",
//         //     "",
//         //     val_farmer);
//         // print('procurementdetails : ' + procurementdetails.toString());
//       }
//
//       List<Map> procurement = await db.GetTableValues('procurement');
//       print("procurement : " + procurement.toString());
//       List<Map> procurementDetails =
//           await db.GetTableValues('procurementDetails');
//       print("procurementDetails : " + procurementDetails.toString());
//       double agentBal = double.parse(agentDistributionBal);
//       double cash = 0;
//       if (cashController.text != '') {
//         cash = double.parse(cashController.text);
//       }
//       print("agentbalance" + agentBal.toString());
//       double agentbalance = agentBal - cash;
//       String agentBalqry = 'Update agentMaster set agentProcurementBal=\'' +
//           agentbalance.toString() +
//           '\'';
//       db.RawUpdate(agentBalqry);
//
//       int issync = await db.UpdateTableValue(
//           'procurement', 'isSynched', '0', 'recNo', revNo);
//
//       Alert(
//         context: context,
//         type: AlertType.info,
//         title: "Transaction Successful",
//         desc: "Procurement Successful.\nYour receipt ID is " + revNo,
//         buttons: [
//           DialogButton(
//             child: Text(
//               "OK",
//               style: TextStyle(color: Colors.white, fontSize: 20),
//             ),
//             onPressed: () {
//               Navigator.pop(context);
//               Navigator.pop(context);
//               Navigator.pop(context);
//             },
//             width: 120,
//           ),
//         ],
//       ).show();
//     } catch (e) {
//       print('invalid 2 ' + e.toString());
//       // toast(e.toString());
//     }
//   }
//
//   ConfirmationPopReg(dialogContext) {
//     try {
//       var alertStyle = AlertStyle(
//         animationType: AnimationType.fromBottom,
//         overlayColor: Colors.black87,
//         isCloseButton: true,
//         isOverlayTapDismiss: false,
//         titleStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
//         descStyle: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
//         animationDuration: Duration(milliseconds: 300),
//       );
//       int totbags = 0;
//       double totnetwgt = 0;
//       double totamount = 0;
//       for (int i = 0; i < weightlist.length; i++) {
//         int bag = int.parse(weightlist[i].Nobags!);
//         double netweight = double.parse(weightlist[i].netweight!);
//         double price = double.parse(weightlist[i].price!);
//         double amount = netweight * price;
//         totbags = totbags + bag;
//         totnetwgt = totnetwgt + netweight;
//         totamount = totamount + amount;
//       }
//       Alert(
//           context: dialogContext,
//           style: alertStyle,
//           title: "Procurement Summary",
//           content: SingleChildScrollView(
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               crossAxisAlignment: CrossAxisAlignment.stretch,
//               children: <Widget>[
//                 Row(
//                   children: [
//                     Expanded(
//                       flex: 1,
//                       child: Container(
//                         padding: EdgeInsets.all(5),
//                         child: Text(
//                           'Farmer Code',
//                           style: TextStyle(color: Colors.green, fontSize: 12),
//                         ),
//                       ),
//                     ),
//                     Expanded(
//                       flex: 1,
//                       child: Container(
//                         padding: EdgeInsets.all(5),
//                         child: Text(
//                           val_farmer,
//                           style: TextStyle(color: Colors.grey, fontSize: 14),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//                 Divider(
//                   color: Colors.black,
//                 ),
//                 Row(
//                   children: [
//                     Expanded(
//                       flex: 1,
//                       child: Container(
//                         padding: EdgeInsets.all(5),
//                         child: Text(
//                           'Farmer Name',
//                           style: TextStyle(color: Colors.green, fontSize: 12),
//                         ),
//                       ),
//                     ),
//                     Expanded(
//                       flex: 1,
//                       child: Container(
//                         padding: EdgeInsets.all(5),
//                         child: Text(
//                           slctFarmer,
//                           style: TextStyle(color: Colors.grey, fontSize: 14),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//                 Divider(
//                   color: Colors.black,
//                 ),
//                 Container(
//                   color: Colors.green,
//                   child: Row(
//                     children: [
//                       Expanded(
//                         flex: 1,
//                         child: Container(
//                           child: Text(
//                             'Crops',
//                             textAlign: TextAlign.center,
//                             style: TextStyle(color: Colors.white, fontSize: 10),
//                           ),
//                         ),
//                       ),
//                       Container(
//                           height: 20,
//                           child: VerticalDivider(color: Colors.white)),
//                       Expanded(
//                         flex: 1,
//                         child: Container(
//                           child: Text(
//                             'No of \nBags',
//                             textAlign: TextAlign.center,
//                             style: TextStyle(color: Colors.white, fontSize: 10),
//                           ),
//                         ),
//                       ),
//                       Container(
//                           height: 20,
//                           child: VerticalDivider(color: Colors.white)),
//                       Expanded(
//                         flex: 1,
//                         child: Container(
//                           child: Text(
//                             'Net\n Weight',
//                             textAlign: TextAlign.center,
//                             style: TextStyle(color: Colors.white, fontSize: 10),
//                           ),
//                         ),
//                       ),
//                       Container(
//                           height: 20,
//                           child: VerticalDivider(color: Colors.white)),
//                       Expanded(
//                         flex: 1,
//                         child: Container(
//                           child: Text(
//                             'Price\nUnit(' + currency + ')',
//                             textAlign: TextAlign.center,
//                             style: TextStyle(color: Colors.white, fontSize: 10),
//                           ),
//                         ),
//                       ),
//                       Container(
//                           height: 20,
//                           child: VerticalDivider(color: Colors.white)),
//                       Expanded(
//                         flex: 1,
//                         child: Container(
//                           child: Text(
//                             'Amount(' + currency + ')',
//                             textAlign: TextAlign.center,
//                             style: TextStyle(color: Colors.white, fontSize: 10),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 Container(
//                   child: Container(
//                     height: 200,
//                     width: 350,
//                     child: ListView.builder(
//                         itemCount: weightlist.length,
//                         itemBuilder: (context, postion) {
//                           return GestureDetector(
//                             child: Container(
//                               child: Column(
//                                 children: [
//                                   Row(
//                                     children: [
//                                       Expanded(
//                                         flex: 1,
//                                         child: Container(
//                                           child: Text(
//                                             weightlist[postion].productname! +
//                                                 '/' +
//                                                 weightlist[postion]
//                                                     .varietyname! +
//                                                 '/' +
//                                                 weightlist[postion].grade!,
//                                             textAlign: TextAlign.center,
//                                             style: TextStyle(
//                                                 color: Colors.black,
//                                                 fontSize: 10),
//                                           ),
//                                         ),
//                                       ),
//                                       Container(
//                                           height: 20,
//                                           child: VerticalDivider(
//                                               color: Colors.green)),
//                                       Expanded(
//                                         flex: 1,
//                                         child: Container(
//                                           child: Text(
//                                             weightlist[postion].Nobags!,
//                                             textAlign: TextAlign.center,
//                                             style: TextStyle(
//                                                 color: Colors.black,
//                                                 fontSize: 10),
//                                           ),
//                                         ),
//                                       ),
//                                       Container(
//                                           height: 20,
//                                           child: VerticalDivider(
//                                               color: Colors.green)),
//                                       Expanded(
//                                         flex: 1,
//                                         child: Container(
//                                           child: Text(
//                                             double.parse(weightlist[postion]
//                                                     .netweight!)
//                                                 .toStringAsFixed(2),
//                                             textAlign: TextAlign.right,
//                                             style: TextStyle(
//                                                 color: Colors.black,
//                                                 fontSize: 10),
//                                           ),
//                                         ),
//                                       ),
//                                       Container(
//                                           height: 20,
//                                           child: VerticalDivider(
//                                               color: Colors.green)),
//                                       Expanded(
//                                         flex: 1,
//                                         child: Container(
//                                           child: Text(
//                                             weightlist[postion].price!,
//                                             textAlign: TextAlign.right,
//                                             style: TextStyle(
//                                                 color: Colors.black,
//                                                 fontSize: 10),
//                                           ),
//                                         ),
//                                       ),
//                                       Container(
//                                           height: 20,
//                                           child: VerticalDivider(
//                                               color: Colors.green)),
//                                       Expanded(
//                                         flex: 1,
//                                         child: Container(
//                                           child: Text(
//                                             ((double.parse(weightlist[postion]
//                                                         .price!)) *
//                                                     (double.parse(
//                                                         weightlist[postion]
//                                                             .netweight!)))
//                                                 .toString(),
//                                             textAlign: TextAlign.center,
//                                             style: TextStyle(
//                                                 color: Colors.black,
//                                                 fontSize: 10),
//                                           ),
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                   Divider(
//                                     height: 1,
//                                     color: Colors.green,
//                                   )
//                                 ],
//                               ),
//                             ),
//                           );
//                         }),
//                   ),
//                 ),
//                 Container(
//                   color: Colors.green,
//                   child: Row(
//                     children: [
//                       Expanded(
//                         flex: 1,
//                         child: Container(
//                           child: Text(
//                             'Total(' + currency + ')',
//                             textAlign: TextAlign.center,
//                             style: TextStyle(color: Colors.white, fontSize: 10),
//                           ),
//                         ),
//                       ),
//                       Container(
//                           height: 20,
//                           child: VerticalDivider(color: Colors.white)),
//                       Expanded(
//                         flex: 1,
//                         child: Container(
//                           child: Text(
//                             totbags.toString(),
//                             textAlign: TextAlign.center,
//                             style: TextStyle(color: Colors.white, fontSize: 10),
//                           ),
//                         ),
//                       ),
//                       Container(
//                           height: 20,
//                           child: VerticalDivider(color: Colors.white)),
//                       Expanded(
//                         flex: 1,
//                         child: Container(
//                           child: Text(
//                             totnetwgt.toStringAsFixed(2),
//                             textAlign: TextAlign.right,
//                             style: TextStyle(color: Colors.white, fontSize: 10),
//                           ),
//                         ),
//                       ),
//                       Container(
//                           height: 20,
//                           child: VerticalDivider(color: Colors.white)),
//                       Expanded(
//                         flex: 1,
//                         child: Container(),
//                       ),
//                       Container(
//                           height: 20,
//                           child: VerticalDivider(color: Colors.white)),
//                       Expanded(
//                         flex: 1,
//                         child: Container(
//                           child: Text(
//                             totamount.toString(),
//                             textAlign: TextAlign.center,
//                             style: TextStyle(color: Colors.white, fontSize: 10),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 Container(
//                   padding: EdgeInsets.only(top: 10),
//                   child: Row(
//                     children: [
//                       Expanded(
//                           flex: 1,
//                           child: Container(
//                             child: Text(
//                               farmerLabelBalance + " : ",
//                               style:
//                                   TextStyle(color: Colors.green, fontSize: 12),
//                             ),
//                           )),
//                       Expanded(
//                           flex: 1,
//                           child: Container(
//                             child: Text(
//                               currency + ' ' + procurementBalance,
//                               style: TextStyle(fontSize: 12),
//                             ),
//                           ))
//                     ],
//                   ),
//                 ),
//                 Container(
//                   padding: EdgeInsets.only(top: 10),
//                   child: Row(
//                     children: [
//                       Expanded(
//                           flex: 1,
//                           child: Container(
//                             child: Text(
//                               MobileUserBalLabel,
//                               style:
//                                   TextStyle(color: Colors.green, fontSize: 12),
//                             ),
//                           )),
//                       Expanded(
//                           flex: 1,
//                           child: Container(
//                             child: Text(
//                               currency + ' ' + agentDistributionBal,
//                               style: TextStyle(fontSize: 12),
//                             ),
//                           ))
//                     ],
//                   ),
//                 ),
//                 // Container(
//                 //   padding: EdgeInsets.only(top: 10),
//                 //   child: Row(
//                 //     children: [
//                 //       Expanded(
//                 //           flex: 1,
//                 //           child: Container(
//                 //             child: Text(
//                 //               'Cash Paid',
//                 //               style:
//                 //                   TextStyle(color: Colors.green, fontSize: 12),
//                 //             ),
//                 //           )),
//                 //       Expanded(
//                 //           flex: 1,
//                 //           child: Container(
//                 //               child: TextField(
//                 //             controller: cashController,
//                 //             style: TextStyle(color: Colors.black, fontSize: 14),
//                 //             keyboardType: TextInputType.number,
//                 //           )))
//                 //     ],
//                 //   ),
//                 // )
//               ],
//             ),
//           ),
//           buttons: [
//             DialogButton(
//               child: Text(
//                 "Cancel",
//                 style: TextStyle(color: Colors.white, fontSize: 18),
//               ),
//               //onPressed:btncancel ,
//               onPressed: () {
//                 //setState(() {
//                 //Navigator.pop(dialogContext);
//                 Navigator.pop(context);
//                 //});
//               },
//               color: Colors.deepOrange,
//             ),
//             DialogButton(
//               child: Text(
//                 "OK",
//                 style: TextStyle(color: Colors.white, fontSize: 18),
//               ),
//               //onPressed:btnok,
//               onPressed: () {
//                 Navigator.pop(dialogContext);
//                 if (double.parse(cashController.text) >
//                     double.parse(agentDistributionBal)) {
//                   //Cash Paid should not be greater than Mobile User Opening Balance
//                   errordialog(context, "Information",
//                       "Cash Paid should not be greater than Mobile User Opening Balance");
//                 } else {
//                   Alert(
//                     context: context,
//                     type: AlertType.info,
//                     title: "Confirm",
//                     desc: "Are you sure want to proceed ?",
//                     buttons: [
//                       DialogButton(
//                         child: Text(
//                           "Yes",
//                           style: TextStyle(color: Colors.white, fontSize: 20),
//                         ),
//                         onPressed: () {
//                           saveProcurementReg();
//                         },
//                         width: 120,
//                       ),
//                       DialogButton(
//                         child: Text(
//                           "No",
//                           style: TextStyle(color: Colors.white, fontSize: 20),
//                         ),
//                         onPressed: () {
//                           Navigator.pop(context);
//                         },
//                         width: 120,
//                       )
//                     ],
//                   ).show();
//                 }
//
//                 //Navigator.pop(dialogContext);
//
//                 //});
//               },
//               color: Colors.green,
//             )
//           ]).show();
//     } catch (e) {
//       print('popup error :' + e.toString());
//       //toast(e.toString());
//     }
//   }
//
//   ConfirmationPopUnReg(dialogContext) {
//     try {
//       var alertStyle = AlertStyle(
//         animationType: AnimationType.fromBottom,
//         overlayColor: Colors.black87,
//         isCloseButton: true,
//         isOverlayTapDismiss: false,
//         titleStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
//         descStyle: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
//         animationDuration: Duration(milliseconds: 300),
//       );
//       int totbags = 0;
//       double totnetwgt = 0;
//       double totamount = 0;
//       for (int i = 0; i < unregweightlist.length; i++) {
//         int bag = int.parse(unregweightlist[i].Nobags!);
//         double netweight = double.parse(unregweightlist[i].netweight!);
//         double price = double.parse(unregweightlist[i].price!);
//         double amount = netweight * price;
//         totbags = totbags + bag;
//         totnetwgt = totnetwgt + netweight;
//         totamount = totamount + amount;
//       }
//       Alert(
//           context: dialogContext,
//           style: alertStyle,
//           title: "Procurement Summary",
//           content: SingleChildScrollView(
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               crossAxisAlignment: CrossAxisAlignment.stretch,
//               children: <Widget>[
//                 Row(
//                   children: [
//                     Expanded(
//                       flex: 1,
//                       child: Container(
//                         padding: EdgeInsets.all(5),
//                         child: Text(
//                           'Farmer Name',
//                           style: TextStyle(color: Colors.green, fontSize: 12),
//                         ),
//                       ),
//                     ),
//                     Expanded(
//                       flex: 1,
//                       child: Container(
//                         padding: EdgeInsets.all(5),
//                         child: Text(
//                           farmernameController.text,
//                           style: TextStyle(color: Colors.grey, fontSize: 14),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//                 Divider(
//                   color: Colors.black,
//                 ),
//                 Container(
//                   color: Colors.green,
//                   child: Row(
//                     children: [
//                       Expanded(
//                         flex: 1,
//                         child: Container(
//                           child: Text(
//                             'Crops',
//                             textAlign: TextAlign.center,
//                             style: TextStyle(color: Colors.white, fontSize: 10),
//                           ),
//                         ),
//                       ),
//                       Container(
//                           height: 20,
//                           child: VerticalDivider(color: Colors.white)),
//                       Expanded(
//                         flex: 1,
//                         child: Container(
//                           child: Text(
//                             'No of \nBags',
//                             textAlign: TextAlign.center,
//                             style: TextStyle(color: Colors.white, fontSize: 10),
//                           ),
//                         ),
//                       ),
//                       Container(
//                           height: 20,
//                           child: VerticalDivider(color: Colors.white)),
//                       Expanded(
//                         flex: 1,
//                         child: Container(
//                           child: Text(
//                             'Net\n Weight',
//                             textAlign: TextAlign.center,
//                             style: TextStyle(color: Colors.white, fontSize: 10),
//                           ),
//                         ),
//                       ),
//                       Container(
//                           height: 20,
//                           child: VerticalDivider(color: Colors.white)),
//                       Expanded(
//                         flex: 1,
//                         child: Container(
//                           child: Text(
//                             'Price\nUnit(\u20B9)',
//                             textAlign: TextAlign.center,
//                             style: TextStyle(color: Colors.white, fontSize: 10),
//                           ),
//                         ),
//                       ),
//                       Container(
//                           height: 20,
//                           child: VerticalDivider(color: Colors.white)),
//                       Expanded(
//                         flex: 1,
//                         child: Container(
//                           child: Text(
//                             'Amount(\u20B9)',
//                             textAlign: TextAlign.center,
//                             style: TextStyle(color: Colors.white, fontSize: 10),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 Container(
//                   child: Container(
//                     height: 200,
//                     width: 350,
//                     child: ListView.builder(
//                         itemCount: unregweightlist.length,
//                         itemBuilder: (context, postion) {
//                           return GestureDetector(
//                             child: Container(
//                               child: Column(
//                                 children: [
//                                   Row(
//                                     children: [
//                                       Expanded(
//                                         flex: 1,
//                                         child: Container(
//                                           child: Text(
//                                             unregweightlist[postion]
//                                                     .productname! +
//                                                 '/' +
//                                                 unregweightlist[postion]
//                                                     .varietyname! +
//                                                 '/' +
//                                                 unregweightlist[postion].grade!,
//                                             textAlign: TextAlign.center,
//                                             style: TextStyle(
//                                                 color: Colors.black,
//                                                 fontSize: 10),
//                                           ),
//                                         ),
//                                       ),
//                                       Container(
//                                           height: 20,
//                                           child: VerticalDivider(
//                                               color: Colors.green)),
//                                       Expanded(
//                                         flex: 1,
//                                         child: Container(
//                                           child: Text(
//                                             unregweightlist[postion].Nobags!,
//                                             textAlign: TextAlign.center,
//                                             style: TextStyle(
//                                                 color: Colors.black,
//                                                 fontSize: 10),
//                                           ),
//                                         ),
//                                       ),
//                                       Container(
//                                           height: 20,
//                                           child: VerticalDivider(
//                                               color: Colors.green)),
//                                       Expanded(
//                                         flex: 1,
//                                         child: Container(
//                                           child: Text(
//                                             unregweightlist[postion].netweight!,
//                                             textAlign: TextAlign.center,
//                                             style: TextStyle(
//                                                 color: Colors.black,
//                                                 fontSize: 10),
//                                           ),
//                                         ),
//                                       ),
//                                       Container(
//                                           height: 20,
//                                           child: VerticalDivider(
//                                               color: Colors.green)),
//                                       Expanded(
//                                         flex: 1,
//                                         child: Container(
//                                           child: Text(
//                                             unregweightlist[postion].price!,
//                                             textAlign: TextAlign.center,
//                                             style: TextStyle(
//                                                 color: Colors.black,
//                                                 fontSize: 10),
//                                           ),
//                                         ),
//                                       ),
//                                       Container(
//                                           height: 20,
//                                           child: VerticalDivider(
//                                               color: Colors.green)),
//                                       Expanded(
//                                         flex: 1,
//                                         child: Container(
//                                           child: Text(
//                                             ((double.parse(
//                                                         unregweightlist[postion]
//                                                             .price!)) *
//                                                     (double.parse(
//                                                         unregweightlist[postion]
//                                                             .netweight!)))
//                                                 .toString(),
//                                             textAlign: TextAlign.center,
//                                             style: TextStyle(
//                                                 color: Colors.black,
//                                                 fontSize: 10),
//                                           ),
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                   Divider(
//                                     height: 1,
//                                     color: Colors.green,
//                                   )
//                                 ],
//                               ),
//                             ),
//                           );
//                         }),
//                   ),
//                 ),
//                 Container(
//                   color: Colors.green,
//                   child: Row(
//                     children: [
//                       Expanded(
//                         flex: 1,
//                         child: Container(
//                           child: Text(
//                             'Total(\u20B9)',
//                             textAlign: TextAlign.center,
//                             style: TextStyle(color: Colors.white, fontSize: 10),
//                           ),
//                         ),
//                       ),
//                       Container(
//                           height: 20,
//                           child: VerticalDivider(color: Colors.white)),
//                       Expanded(
//                         flex: 1,
//                         child: Container(
//                           child: Text(
//                             totbags.toString(),
//                             textAlign: TextAlign.center,
//                             style: TextStyle(color: Colors.white, fontSize: 10),
//                           ),
//                         ),
//                       ),
//                       Container(
//                           height: 20,
//                           child: VerticalDivider(color: Colors.white)),
//                       Expanded(
//                         flex: 1,
//                         child: Container(
//                           child: Text(
//                             totnetwgt.toString(),
//                             textAlign: TextAlign.center,
//                             style: TextStyle(color: Colors.white, fontSize: 10),
//                           ),
//                         ),
//                       ),
//                       Expanded(
//                         flex: 1,
//                         child: Container(),
//                       ),
//                       Container(
//                           height: 20,
//                           child: VerticalDivider(color: Colors.white)),
//                       Expanded(
//                         flex: 1,
//                         child: Container(
//                           child: Text(
//                             totamount.toString(),
//                             textAlign: TextAlign.center,
//                             style: TextStyle(color: Colors.white, fontSize: 10),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 Container(
//                   padding: EdgeInsets.only(top: 10),
//                   child: Row(
//                     children: [
//                       Expanded(
//                           flex: 1,
//                           child: Container(
//                             child: Text(
//                               MobileUserBalLabel,
//                               style:
//                                   TextStyle(color: Colors.green, fontSize: 12),
//                             ),
//                           )),
//                       Expanded(
//                           flex: 1,
//                           child: Container(
//                             child: Text(
//                               '\u20B9' + agentDistributionBal,
//                               style: TextStyle(fontSize: 12),
//                             ),
//                           ))
//                     ],
//                   ),
//                 ),
//                 Container(
//                   padding: EdgeInsets.only(top: 10),
//                   child: Row(
//                     children: [
//                       Expanded(
//                           flex: 1,
//                           child: Container(
//                             child: Text(
//                               'Cash Paid',
//                               style:
//                                   TextStyle(color: Colors.green, fontSize: 12),
//                             ),
//                           )),
//                       Expanded(
//                           flex: 1,
//                           child: Container(
//                               child: TextField(
//                             controller: cashController,
//                             style: TextStyle(color: Colors.black, fontSize: 14),
//                             keyboardType: TextInputType.number,
//                           )))
//                     ],
//                   ),
//                 )
//               ],
//             ),
//           ),
//           buttons: [
//             DialogButton(
//               child: Text(
//                 "Cancel",
//                 style: TextStyle(color: Colors.white, fontSize: 18),
//               ),
//               //onPressed:btncancel ,
//               onPressed: () {
//                 //setState(() {
//                 //Navigator.pop(dialogContext);
//                 Navigator.pop(context);
//                 //});
//               },
//               color: Colors.deepOrange,
//             ),
//             DialogButton(
//               child: Text(
//                 "OK",
//                 style: TextStyle(color: Colors.white, fontSize: 18),
//               ),
//               //onPressed:btnok,
//               onPressed: () {
//                 Navigator.pop(dialogContext);
//                 Alert(
//                   context: context,
//                   type: AlertType.info,
//                   title: "Confirm",
//                   desc: "Are you sure want to proceed ?",
//                   buttons: [
//                     DialogButton(
//                       child: Text(
//                         "Yes",
//                         style: TextStyle(color: Colors.white, fontSize: 20),
//                       ),
//                       onPressed: () {
//                         saveProcurementUnregistered();
//                       },
//                       width: 120,
//                     ),
//                     DialogButton(
//                       child: Text(
//                         "No",
//                         style: TextStyle(color: Colors.white, fontSize: 20),
//                       ),
//                       onPressed: () {
//                         Navigator.pop(context);
//                       },
//                       width: 120,
//                     )
//                   ],
//                 ).show();
//
//                 //Navigator.pop(dialogContext);
//
//                 //});
//               },
//               color: Colors.green,
//             )
//           ]).show();
//     } catch (e) {
//       print('popup error :' + e.toString());
//       //toast(e.toString());
//     }
//   }
// }
