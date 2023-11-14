import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:ucda/commonlang/translateLang.dart';

import '../Database/Databasehelper.dart';
import '../Database/Model/FarmerMaster.dart';
import '../Model/Geoareascalculate.dart';
import '../Model/Treelistmodel.dart';
import '../Model/UIModel.dart';
import '../Model/dynamicfields.dart';
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
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
// import 'package:progress_hud/progress_hud.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Translate extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _Translate();
  }
}

class _Translate extends State<Translate> {
  var db = DatabaseHelper();
  List<UImodel> langUIModel = [];
  // ProgressHUD _progressHUD = new ProgressHUD(
  //   backgroundColor: Colors.black12,
  //   color: Colors.white,
  //   containerColor: Colors.green,
  //   borderRadius: 5.0,
  //   loading: false,
  //   text: 'Loading...',
  // );
  List<Map> agents = [];
  String slctLang = "";
  String Lang = 'en';
  final List<DropdownMenuItem> transitems = [];
  String val_Lang = "";
  int farmerid = 0;
  String Lat = '0', Lng = '0';
  String seasoncode = '';
  String servicePointId = '';
  List<String> transList = ['Loading'];
  String Date = '';

  static const Map<String, String> lang = {
    "English": "en",
    "Amharic": "am",
  };

  @override
  void initState() {
    super.initState();
    // _progressHUD = new ProgressHUD(
    //   backgroundColor: Colors.black12,
    //   color: Colors.white,
    //   containerColor: Colors.green,
    //   borderRadius: 5.0,
    //   loading: false,
    //   text: 'Loading...',
    // );
    initvalues();
    getClientData();
    slctLang = transList[0];

    getLocation();
    final now = new DateTime.now();
    String txntime = DateFormat('dd/MM/yy').format(now);
    Date = txntime;
    print("1" + Date);
  }

  void getLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    print("latitude :" +
        position.latitude.toString() +
        " longitude: " +
        position.longitude.toString());
    setState(() {
      Lat = position.latitude.toString();
      Lng = position.longitude.toString();
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> initvalues() async {
    List transList = await db.RawQuery(
        'select distinct lang from labelNamechange where tenantID = "cediam" ');
    print('transList ' + transList.toString());
    langUIModel = [];
    transitems.clear();
    for (int i = 0; i < transList.length; i++) {
      String lang = transList[i]["lang"].toString();

      var uimodel = new UImodel(lang, lang);
      langUIModel.add(uimodel);
      setState(() {
        transitems.add(DropdownMenuItem(
          child: Text(lang),
          value: lang,
        ));
      });
    }
    setState(() {
      //  if (slctLang == "") {
      val_Lang = langUIModel[0].value;
      slctLang = langUIModel[0].name;
      // }
    });
  }

  getClientData() async {
    agents = await db.RawQuery('SELECT * FROM agentMaster');

    //  agentdata = await db.getUser();

    seasoncode = agents[0]['currentSeasonCode'];
    servicePointId = agents[0]['servicePointId'];
    //farmerid = farmerIdGeneration(agents);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () {
                Navigator.pop(context);
              }),
          title: Text(
            'Translator',
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
                      context), // <<<<< Note this change for the return type
                ),
                flex: 8,
              ),
            ])),
            // Positioned(
            //   child: _progressHUD,
            // ),
          ],
        ),
      ),
    );
  }

  List<Widget> _getListings(BuildContext context) {
    List<Widget> listings = [];
    listings.add(
        txt_label_icon("Language", Colors.black, 14.0, false, Icons.language));
    listings.add(singlesearchDropdown(
        itemlist: transitems,
        selecteditem: slctLang,
        hint: "Translate",
        onChanged: (value) async {
          slctLang = value!;
        }));
    listings.add(btn_double_submit("x", "OK", Colors.green, Colors.white, 18.0,
        Alignment.centerRight, 10.0, btnSubmit, btnCancel));

    return listings;
  }

  void btnSubmit() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("langCode", slctLang);
    TranslateFun.translate();
    Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (BuildContext context) => DashBoard(
              '',
              '',
            )));
  }

  void btnCancel() async {
    Navigator.pop(context);
  }
}
