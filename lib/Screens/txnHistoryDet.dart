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
import '../Plugins/TxnExecutor.dart';
import '../Utils/MandatoryDatas.dart';
import 'geoploattingProposedLand.dart';
import 'geoplottingaddfarm.dart';
import 'navigation.dart';
import 'package:cupertino_radio_choice/cupertino_radio_choice.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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

class txnHistoryDet extends StatefulWidget {
  String? farmerCode;
  String? srchFarmer;
  String? slctVillage;
  List<txnHistoryInfo>? txnlist ;
  // List<Geoareascalculate> polygonLatLngs = List<Geoareascalculate>();

  txnHistoryDet(
      this.farmerCode, this.srchFarmer, this.slctVillage, this.txnlist);
  @override
  State<StatefulWidget> createState() {
    return _txnHistoryDet(farmerCode, srchFarmer, slctVillage, txnlist);
  }
}

class _txnHistoryDet extends State<txnHistoryDet> {
  var db = DatabaseHelper();
  String? farmerCode;
  String? srchFarmer;
  String? slctVillage;
  List<txnHistoryInfo>? txnlist ;
  _txnHistoryDet(
      this.farmerCode, this.srchFarmer, this.slctVillage, this.txnlist);
  String? servicePointId;
  String? seasoncode;
  List<Map>? agents;
  /* String farmerCode = "",
  farmerName = "";*/
  @override
  void initState() {
    super.initState();
    print("inistate");
    //initvalues();
    getClientData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  getClientData() async {
    agents = await db.RawQuery('SELECT * FROM agentMaster');

    seasoncode = agents![0]['currentSeasonCode'];
    servicePointId = agents![0]['servicePointId'];
  }

  // Future<void> initvalues() async {
  //
  // }

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
    return SafeArea(
      child: WillPopScope(
        onWillPop: _onBackPressed,
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            centerTitle: true,
            leading: IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () {
                  /*   Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (BuildContext context) => DashBoard(
                      '',
                      '',
                    )));*/

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
          body: Container(
              child: Column(children: <Widget>[
            Expanded(
              child: ListView(
                padding: EdgeInsets.all(10.0),
                children: _getListings(
                    context), // <<<<< Note this change for the return type
              ),
              flex: 8,
            ),
          ])),
        ),
      ),
    );
  }

  List<Widget> _getListings(BuildContext context) {
    List<Widget> listings = [];
    listings.add(Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Row(
          children: [
            Expanded(
              flex: 1,
              child: Container(
                padding: EdgeInsets.all(5),
                child: Text(
                  'Farmer Code',
                  style: TextStyle(color: Colors.green, fontSize: 12),
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(
                padding: EdgeInsets.all(5),
                child: Text(
                  farmerCode!,
                  style: TextStyle(color: Colors.grey, fontSize: 14),
                ),
              ),
            ),
          ],
        ),
        Divider(
          color: Colors.black,
        ),
        Row(
          children: [
            Expanded(
              flex: 1,
              child: Container(
                padding: EdgeInsets.all(5),
                child: Text(
                  'Farmer Name',
                  style: TextStyle(color: Colors.green, fontSize: 12),
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(
                padding: EdgeInsets.all(5),
                child: Text(
                  srchFarmer!,
                  style: TextStyle(color: Colors.grey, fontSize: 14),
                ),
              ),
            ),
          ],
        ),
        Divider(
          color: Colors.black,
        ),
        Row(
          children: [
            Expanded(
              flex: 1,
              child: Container(
                padding: EdgeInsets.all(5),
                child: Text(
                  'Village',
                  style: TextStyle(color: Colors.green, fontSize: 12),
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(
                padding: EdgeInsets.all(5),
                child: Text(
                  slctVillage!,
                  style: TextStyle(color: Colors.grey, fontSize: 14),
                ),
              ),
            ),
          ],
        ),
      ],
    ));
    if (txnlist != null && txnlist!.length > 0) {
      listings.add(addtxnlist(txnlist: txnlist!));
    }

    listings.add(
        txt_label("DI-Distribution|PR-Procurement", Colors.black, 14.0, false));
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
          itemCount: txnlist == '' ? 1 : txnlist!.length + 1,
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

            return Column(children: <Widget>[
              Container(
                margin: EdgeInsets.only(left: 5.0, right: 5.0, top: 10.0),
                alignment: Alignment.center,
                child: new Row(
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        child: Text(
                          txnlist![index].Date,
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
}
