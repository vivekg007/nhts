import 'dart:async';
import 'dart:convert';
import 'dart:math';

import '../Database/Databasehelper.dart';
import '../Database/Model/FarmerMaster.dart';
import '../Model/Geoareascalculate.dart';
import '../Model/Treelistmodel.dart';
import '../Model/UIModel.dart';
import '../Model/dynamicfields.dart';
import '../Model/txnHistoryModel.dart';
import '../Plugins/RestPlugin.dart';
import '../Plugins/TxnExecutor.dart';
import '../ResponseModel/TransactionHistoryResponseModel.dart';
import '../Utils/MandatoryDatas.dart';
import '../main.dart';
import 'geoploattingProposedLand.dart';
import 'geoplottingaddfarm.dart';
import 'navigation.dart';
import 'package:connectivity/connectivity.dart';
import 'package:cupertino_radio_choice/cupertino_radio_choice.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'dart:io' show File;
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import '../../../login.dart';

import 'txnHistory.dart';

class txnHistory extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _txnHistory();
  }
}

class _txnHistory extends State<txnHistory> {
  var db = DatabaseHelper();
  List<UImodel> VillageListUIModel = [];
  List<UImodel> FarmerLstUIModel = [];
  String slctVillage = "", srchFarmer = "", Date = "", Type = "", Amount = "";
  String? seasoncode;
  String? servicePointId;
  List<String> villagelist = ['Loading'];
  List<String> farmerLst = ['Loading'];
  List<Map>? agents;
  final List<DropdownMenuItem> villageitems = [], farmeritems = [];
  List<txnHistoryInfo> txnlist = [];
  String val_Village = "", val_Farmer = "", farmerCode = "";
  final Connectivity _connectivity = Connectivity();
  StreamSubscription<ConnectivityResult>? _connectivitySubscription;
  bool _internetconnection = false;
  bool farmerLoaded=false;


  @override
  void initState() {
    super.initState();

    slctVillage = villagelist[0];
    srchFarmer = farmerLst[0];
    initvalues();
    getClientData();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
    initConnectivity();
  }
  Future<void> initConnectivity() async {
    ConnectivityResult result;
// Platform messages may fail, so we use a try/catch PlatformException.

      result = await _connectivity.checkConnectivity();


// If the widget was removed from the tree while the asynchronous platform
// message was in flight, we want to discard the reply rather than calling
// setState to update our non-existent appearance.
    if (!mounted) {
      return Future.value('');
    }

    return _updateConnectionStatus(result);
  }
  Future<void> _updateConnectionStatus(ConnectivityResult? result) async {
    try {
      switch (result) {
        case ConnectivityResult.wifi:
          setState(() async {
            _internetconnection = true;
            print('internetconnection wifi');

          });
          break;
        case ConnectivityResult.mobile:
          print('internetconnection mobile');
          setState(() async {
            _internetconnection = true;

          });
          break;
        case ConnectivityResult.none:
          setState(() async {
            _internetconnection = false;
            toast('Internet Connection not available');
            Navigator.pop(context);

          });
          break;
        default:
          setState(() async {
            _internetconnection = false;

          });
          break;
      }
    } catch (Exc) {
      print("Internet exception : " + Exc.toString());
    }
  }
  @override
  void dispose() {
    super.dispose();
  }

  getClientData() async {
    agents = await db.RawQuery('SELECT * FROM agentMaster');

    //  agentdata = await db.getUser();

    seasoncode = agents![0]['currentSeasonCode'];
    servicePointId = agents![0]['servicePointId'];
  }

  Future<void> initvalues() async {
    String qry_villagelist =
        'Select distinct v.villCode,v.villName from villageList as v inner join farmer_master as f on f.villageId =v.villCode';
    //'select * from villageList';
    print('Approach Query:  ' + qry_villagelist);
    List villageslist = await db.RawQuery(qry_villagelist);
    print('villageslist 1:  ' + villageslist.toString());
    villageitems.clear();
    VillageListUIModel = [];

    for (int i = 0; i < villageslist.length; i++) {
      String property_value = villageslist[i]["villName"].toString();
      String DISP_SEQ = villageslist[i]["villCode"].toString();
      var uimodel = new UImodel(property_value, DISP_SEQ);
      VillageListUIModel.add(uimodel);
      setState(() {
        villageitems.add(DropdownMenuItem(
          child: Text(property_value),
          value: property_value,
        ));
      });
    }


    // String qry_farmerlist =
    //     'select fName,farmerCode from farmer_master where villageId = \'' +
    //         villageCode +
    //         '\'';
    // print('Approach Query:  ' + qry_farmerlist);
    // List farmerslist = await db.RawQuery(qry_farmerlist);
    // print('villageslist 2:  ' + farmerslist.toString());
    // farmeritems.clear();
    // FarmerLstUIModel = [];
    //
    // for (int i = 0; i < farmerslist.length; i++) {
    //   String property_value = farmerslist[i]["fName"].toString();
    //   String DISP_SEQ = farmerslist[i]["farmerCode"].toString();
    //   var uimodel = new UImodel(property_value, DISP_SEQ);
    //   FarmerLstUIModel.add(uimodel);
    //   setState(() {
    //     farmeritems.add(DropdownMenuItem(
    //       child: Text(property_value),
    //       value: property_value,
    //     ));
    //   });
    // }

  }

  Future<bool> _onBackPressed() async {
    return (await Alert(
      context: context,
      type: AlertType.warning,
      title: 'Cancel',
      desc: 'Are you sure want to cancel',
      buttons: [
        DialogButton(
          child: Text(
            'Yes',
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () {
            Navigator.pop(context);
            Navigator.pop(context);
          },
          width: 120,
        ),
        DialogButton(
          child: Text(
            'No',
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
          width: 120,
        )
      ],
    ).show()) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () {
                _onBackPressed();
              }),
          title: Text(
            'Transaction History',
            style: new TextStyle(
                color: Colors.white,
                fontSize: 18.0,
                fontWeight: FontWeight.w700),
          ),
          iconTheme: IconThemeData(color: Colors.white),
          backgroundColor: Colors.green,
          brightness: Brightness.light,
        ),
        body: Stack(
          children: [
            Container(
                child: Column(children: <Widget>[
                  Expanded(
                    child: ListView(
                      padding: EdgeInsets.all(10.0),
                      children: _getListings(
                          context), // <<<<< Note this change for the return type*/
                    ),
                    flex: 8,
                  ),
                ])),

          ],
        ),
      ),
    );
  }

  farmersearch(String val_Village) async {

    String qry_farmerlist =
        'select fName,farmerId from farmer_master where villageId = \'' +
            val_Village +
            '\'';
    print('Approach Query:  ' + qry_farmerlist);
    List farmerslist = await db.RawQuery(qry_farmerlist);
    print('villageslist 2:  ' + farmerslist.toString());
    farmeritems.clear();
    FarmerLstUIModel = [];

    for (int i = 0; i < farmerslist.length; i++) {
      String property_value = farmerslist[i]["fName"].toString();
      String DISP_SEQ = farmerslist[i]["farmerId"].toString();
      var uimodel = new UImodel(property_value, DISP_SEQ);
      FarmerLstUIModel.add(uimodel);
      setState(() {
        farmerLoaded = true;
        farmeritems.add(DropdownMenuItem(
          child: Text(property_value),
          value: property_value,
        ));
      });
    }

  }

  List<Widget> _getListings(BuildContext context) {
    List<Widget> listings = [];
    listings.add(singlesearchDropdown(
        itemlist: villageitems,
        selecteditem: slctVillage,
        hint: "Select the Village",
        onClear: (){
          setState(() {
            farmerLoaded = false;
            txnlist.clear();
          });
        },
        onChanged: (value) {
          setState(() {
            slctVillage = value!;
            print("CHECK_VILLAGE_NAME: " + slctVillage);

            for (int i = 0; i < VillageListUIModel.length; i++) {
              if (VillageListUIModel[i].name == slctVillage) {
               val_Village = VillageListUIModel[i].value;
                farmersearch(val_Village);
              }
            }

          });
        }));
    if(farmerLoaded){
      listings.add(singlesearchDropdown(
          itemlist: farmeritems,
          selecteditem: srchFarmer,
          hint: "Search for farmers",
          onClear: (){
            setState(() {
              txnlist.clear();
            });
          },
          onChanged: (value) {
            setState(() {
              srchFarmer = value!;

              for (int i = 0; i < FarmerLstUIModel.length; i++) {
                if (FarmerLstUIModel[i].name == srchFarmer) {
                  farmerCode = FarmerLstUIModel[i].value;

                }
              }
              print('CHECK_FARMER_CODE 5: ' + farmerCode);
            });
          }));
    }

    listings.add(btn_double_submit_cancel("x", "Submit", Colors.green, Colors.white,
        18.0, Alignment.center, 10.0, btnSubmit, btnCancel));
    if (txnlist != '' && txnlist.length > 0) {
      listings.add(addtxnlist(txnlist: txnlist));
      listings.add(
          txt_label("\nDI-Distribution  |  PR-Procurement", Colors.grey, 18.0, false));
    }
    return listings;
  }
  Widget addtxnlist({
    List<txnHistoryInfo>? txnlist,
  }) {
    Widget objWidget = Container(
      child: Column(children: <Widget>[
        Container(
            alignment: Alignment.center,
            child: Text("Transaction History",
                style: TextStyle(
                  color: Colors.green,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.underline,
                ))),
        ListView.builder(
          shrinkWrap: true,
          itemCount: txnlist == null ? 1 : txnlist.length + 1,
          itemBuilder: (BuildContext context, int index) {
            if (index == 0) {
// return the header
              return Container(
                margin: EdgeInsets.only(left: 5.0, right: 5.0, top: 10.0),
                alignment: Alignment.center,
                child: new Row(
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        child: Text(
                          "Date",
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              color: Colors.green,
                              fontSize: 14,
                              fontWeight: FontWeight.bold),
                        ),
                        alignment: Alignment.center,
                      ),
                      flex: 2,
                    ),
                    Expanded(
                      child: Container(
                        child: Text(
                          "Type",
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              color: Colors.green,
                              fontSize: 14,
                              fontWeight: FontWeight.bold),
                        ),
                        alignment: Alignment.center,
                      ),
                      flex: 2,
                    ),
                    Expanded(
                      child: Container(
                        child: Text(
                          "Amount",
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              color: Colors.green,
                              fontSize: 14,
                              fontWeight: FontWeight.bold),
                        ),
                        alignment: Alignment.center,
                      ),
                      flex: 2,
                    ),
                  ],
                ),
              );
            }
            index -= 1;
// return row
            var row = txnlist![index];
            return Column(children: <Widget>[
              Container(
                margin: EdgeInsets.only(left: 5.0, right: 5.0, top: 10.0),
                alignment: Alignment.center,
                child: new Row(
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        child: Text(
                          txnlist[index].Date,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.bold),
                        ),
                        alignment: Alignment.center,
                      ),
                      flex: 2,
                    ),
                    Expanded(
                      child: Container(
                        child: Text(
                          txnlist[index].Type,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.bold),
                        ),
                        alignment: Alignment.center,
                      ),
                      flex: 2,
                    ),
                    Expanded(
                      child: Container(
                        child: Text(
                          txnlist[index].Amount,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.bold),
                        ),
                        alignment: Alignment.center,
                      ),
                      flex: 2,
                    ),
                  ],
                ),
              ),
            ]);
          },
        ),
      ]),
    );
    return objWidget;
  }
  void btnSubmit() async {
    // setState(() {
    //   var txninfo = new txnHistoryInfo(
    //     Date,
    //     Type,
    //     Amount,
    //   );
    //   txnlist.add(txninfo);
    //   print("length" + txnlist.length.toString());
    // });
    if (farmerCode != '' && farmerCode.length > 0) {
      setState(() {
        txnlist.clear();
      });
      try{

        restplugin rest = restplugin();
        String response = await rest.TransactionHistoryDownload(farmerCode);
        print('tnshry '+response);
        Map<String, dynamic> json = jsonDecode(response);
        print('farm res ' + json.toString());
        TransactionHistoryResponseModel trnshryList = TransactionHistoryResponseModel.fromJson(json);

        for(int i=0;i<trnshryList.response!.body!.txnHistory!.length;i++){
          String Date = trnshryList.response!.body!.txnHistory![i].txnTime!;
          String Type = trnshryList.response!.body!.txnHistory![i].txnType!;

          String Amount = ChangeDecimalTwo(trnshryList.response!.body!.txnHistory![i].txnAmt!);

          var txninfo = new txnHistoryInfo(
            Date,
            Type,
            Amount,
          );
          setState(() {
            txnlist.add(txninfo);
          });

        }

      }catch(E){
toast(E.toString());


      }

    } else {
      errordialog(
          context, "Information", "Farmer should not be empty");
    }
  }

  void btnCancel() {
    _onBackPressed();
  }
}
