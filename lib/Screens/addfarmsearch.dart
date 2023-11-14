// import '../Database/Databasehelper.dart';
// import '../Database/Model/FarmerMaster.dart';
// import '../Model/Geoareascalculate.dart';
// import '../Model/Treelistmodel.dart';
// import '../Model/UIModel.dart';
// import '../Model/dynamicfields.dart';
// import '../Plugins/TxnExecutor.dart';
// import '../Utils/MandatoryDatas.dart';
// import 'addfarm.dart';
// import 'geoploattingProposedLand.dart';
// import 'geoplottingaddfarm.dart';
// import 'navigation.dart';
// import 'package:flutter/material.dart';
// import 'package:rflutter_alert/rflutter_alert.dart';
//
// import '../../../main.dart';
//
// class AddFarmSearch extends StatefulWidget {
//   @override
//   State<StatefulWidget> createState() {
//     return _AddFarmSearch();
//   }
// }
//
// class _AddFarmSearch extends State<AddFarmSearch> {
//   var db = DatabaseHelper();
//   List<UImodel> villagelistUIModel = [];
//   List<UImodel> farmerlistUIModel = [];
//
//   final List<DropdownMenuItem> villageitems = [], farmeritems = [];
//   String slct_village = "", slct_farmer = "";
//   String val_village = "", val_farmer = "", farmerCode = "";
//   @override
//   void initState() {
//     super.initState();
//     intdatabasevalues();
//   }
//
//   @override
//   void dispose() {
//     super.dispose();
//   }
//
//   Future<bool> _onBackPressed() async {
//     return (await Alert(
//       context: context,
//       type: AlertType.warning,
//       title: 'Cancel',
//       desc: 'Are you sure want to cancel',
//       buttons: [
//         DialogButton(
//           child: Text(
//             'Yes',
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
//             'No',
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
//               'Add Farmer',
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
//     listings.add(
//         txt_label("Village", Colors.black, 16.0, false));
//
//     listings.add(singlesearchDropdown(
//         itemlist: villageitems,
//         selecteditem: slct_village,
//         hint: "Select the Village",
//         onChanged: (value) {
//           setState(() {
//             slct_village = value!;
//             print("CHECK_VILLAGE_NAME: " + slct_village);
//             farmersearch();
//           });
//         }));
//     listings.add(
//         txt_label("Farmer", Colors.black, 16.0, false));
//     listings.add(singlesearchDropdown(
//         itemlist: farmeritems,
//         selecteditem: slct_farmer,
//         hint: "Search for farmers",
//         onChanged: (value) {
//           setState(() {
//             slct_farmer = value!;
//             print('CHECK_FAARMER_CODE 1: ' + farmerlistUIModel[0].name);
//             print('CHECK_FAARMER_CODE 2: ' + farmerlistUIModel[0].value);
//             print('CHECK_FAARMER_CODE 3: ' + farmerCode);
//             print('CHECK_FAARMER_CODE 4: ' + slct_farmer);
//
//             for (int i = 0; i < farmerlistUIModel.length; i++) {
//               if (farmerlistUIModel[i].name == slct_farmer) {
//                 farmerCode = farmerlistUIModel[i].value;
//               }
//             }
//             print('CHECK_FAARMER_CODE 5: ' + farmerCode);
//           });
//         }));
//     listings.add(btn_double_dynamic("x", "Submit", Colors.green, Colors.white,
//         18.0, Alignment.centerRight, 10.0, btnSubmit));
//
//     return listings;
//   }
//
//   void btnSubmit() async {
//     if (farmerCode != '' && farmerCode.length > 0) {
//
//       // Navigator.of(context).pushReplacement(MaterialPageRoute(
//       //     builder: (BuildContext context) => AddFarm(
//       //         farmerCode
//       //     )));
//       Navigator.of(context)
//           .push(MaterialPageRoute(builder: (context) => AddFarm()));
//     } else {
//       toast("Please search village and farmer");
//     }
//   }
//
//   Future<void> intdatabasevalues() async {
//     String qry_villagelist =
//         'Select distinct v.villCode,v.villName from villageList as v inner join farmer_master as f on f.villageId =v.villCode';
//     //'select * from villageList';
//     print('Approach Query:  ' + qry_villagelist);
//     List villageslist = await db.RawQuery(qry_villagelist);
//     print('villageslist 1:  ' + villageslist.toString());
//     villageitems.clear();
//     villagelistUIModel = [];
//
//     for (int i = 0; i < villageslist.length; i++) {
//       String property_value = villageslist[i]["villName"].toString();
//       String DISP_SEQ = villageslist[i]["villCode"].toString();
//       var uimodel = new UImodel(property_value, DISP_SEQ);
//       villagelistUIModel.add(uimodel);
//       setState(() {
//         villageitems.add(DropdownMenuItem(
//           child: Text(property_value),
//           value: property_value,
//         ));
//       });
//     }
//     if (villageitems.length > 0) {
//       setState(() {
//         val_village = villageitems[0].value;
//       });
//     }
//
//     String villageCode = villagelistUIModel[0].value;
//
//     String qry_farmerlist =
//         'select fName,farmerCode from farmer_master where villageId = \'' +
//             villageCode +
//             '\'';
//     print('Approach Query:  ' + qry_farmerlist);
//     List farmerslist = await db.RawQuery(qry_farmerlist);
//     print('villageslist 2:  ' + farmerslist.toString());
//     farmeritems.clear();
//     farmerlistUIModel = [];
//
//     for (int i = 0; i < farmerslist.length; i++) {
//       String property_value = farmerslist[i]["fName"].toString();
//       String DISP_SEQ = farmerslist[i]["farmerCode"].toString();
//       var uimodel = new UImodel(property_value, DISP_SEQ);
//       farmerlistUIModel.add(uimodel);
//       setState(() {
//         farmeritems.add(DropdownMenuItem(
//           child: Text(property_value),
//           value: property_value,
//         ));
//       });
//     }
//     if (farmeritems.length > 0) {
//       setState(() {
//         val_farmer = farmeritems[0].value;
//       });
//     }
//   }
//
//   farmersearch() async {
//     String villageCode = "";
//     for (int i = 0; i < villagelistUIModel.length; i++) {
//       if (villagelistUIModel[i].name == slct_village) {
//         villageCode = villagelistUIModel[i].value;
//       }
//     }
//     String qry_farmerlist =
//         'select fName,farmerCode from farmer_master where villageId = \'' +
//             villageCode +
//             '\'';
//     print('Approach Query:  ' + qry_farmerlist);
//     List farmerslist = await db.RawQuery(qry_farmerlist);
//     print('villageslist 2:  ' + farmerslist.toString());
//     farmeritems.clear();
//     farmerlistUIModel = [];
//
//     for (int i = 0; i < farmerslist.length; i++) {
//       String property_value = farmerslist[i]["fName"].toString();
//       String DISP_SEQ = farmerslist[i]["farmerCode"].toString();
//       var uimodel = new UImodel(property_value, DISP_SEQ);
//       farmerlistUIModel.add(uimodel);
//       setState(() {
//         farmeritems.add(DropdownMenuItem(
//           child: Text(property_value),
//           value: property_value,
//         ));
//       });
//     }
//     if (farmeritems.length > 0) {
//       setState(() {
//         val_farmer = farmeritems[0].value;
//       });
//     }
//   }
// }
