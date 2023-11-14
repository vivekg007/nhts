import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Database/Databasehelper.dart';
import '../Model/UIModel.dart';
import '../Model/dynamicfields.dart';
import '../Utils/MandatoryDatas.dart';
import '../commonlang/translateLang.dart';
import 'navigation.dart';

class ProcessingShiftOperations extends StatefulWidget {
  const ProcessingShiftOperations({Key? key}) : super(key: key);

  @override
  State<ProcessingShiftOperations> createState() => _CoffeePurchaseState();
}

class _CoffeePurchaseState extends State<ProcessingShiftOperations> {
  var db = DatabaseHelper();
  List<Map> agents = [];
  String seasoncode = '';
  String servicePointId = '';
  String agendId = '';
  String Latitude = '', Longitude = '';

  //Date
  String labelDate = "";
  String Date = "";

  //Date Started
  String labelStartDate = "";
  String startDate = "";

  //Time Started
  String labelTime = "";
  String startTime = "Select start time";

  TimeOfDay selectedTimeStart = TimeOfDay.now();
  TimeOfDay selecteddesTimeStart = TimeOfDay.now();

  //Date Finished
  String labelFinishDate = "";
  String finishDate = "";

  String formatStartDate = "", formatFinalDate = "";
  bool validDate = true;

  //Time Finished
  String labelFinshedTime = "";
  String finishedTime = "";

  TimeOfDay selectedTimeFinish = TimeOfDay.now();
  TimeOfDay selecteddesTimeFinish = TimeOfDay.now();

  //Lot no
  List<DropdownModel> lotNoItem = [];
  DropdownModel? slctLotNo;
  String slct_LotNo = "";
  String val_LotNo = "";

  //InputGrade
  List<DropdownModel> inputGradeItem = [];
  DropdownModel? slctInputGrade;
  String slct_InputGrade = "";
  String val_InputGrade = "";

  //OutputGrade
  List<DropdownModel> outputGradeItem = [];
  DropdownModel? slctOutputGrade;
  String slct_OutputGrade = "";
  String val_OuputGrade = "";

  int yearValue = 0;
  int monthValue = 0;
  int dayValue = 0;

  TextEditingController customer = new TextEditingController();
  TextEditingController inputBags = new TextEditingController();
  TextEditingController inputKgs = new TextEditingController();
  TextEditingController outputBags = new TextEditingController();
  TextEditingController outputKgs = new TextEditingController();
  TextEditingController preClean = new TextEditingController();
  TextEditingController stones = new TextEditingController();
  TextEditingController wasteGrade = new TextEditingController();
  TextEditingController reject1899 = new TextEditingController();
  TextEditingController reject1599 = new TextEditingController();
  TextEditingController reject1299 = new TextEditingController();
  TextEditingController reject1199 = new TextEditingController();
  TextEditingController slctStartTime = new TextEditingController();
  TextEditingController slctEndTime = new TextEditingController();

  String inputTotal = "";
  String outputTotal = "";
  String wTotalBags = "";
  String gTotalBags = "";

  List<InputDetail> inputDetailList = [];
  List<InputDetail> inputList = [];
  bool gradeAdded = true;
  String batchNumber = "";

  /* List<OutputDetail> outputDetailList = [];
  List<OutputDetail> outputList = [];*/

  String avlBags = '';
  String avlKgs = '';
  DateTime dateTime = DateTime.now();

  String? selectStartTime = "HH:MM";
  String? selectFinishTime = "HH:MM";
  String slctSTime = "";
  String slctFTime = "";

  /*20/6/2023 feedback changes*/
  List<DropdownModel> skuItems = [];
  DropdownModel? slctSku;
  String slct_sku = "";
  String val_sku = "";

  TextEditingController grnoBags = new TextEditingController();
  TextEditingController wgnoBags = new TextEditingController();
  TextEditingController skuController = new TextEditingController();

  double total = 0.0;

  @override
  void initState() {
    super.initState();

    initvalues();
    getClientData();

    getLocation();
    dateTime = getDateTime();

    // if(preClean.text.isNotEmpty && stones.text.isNotEmpty && wasteGrade.text.isNotEmpty){

    //preclean calculation

    /*   preClean.addListener(() {
      if (preClean.text.isNotEmpty &&
          stones.text.isEmpty &&
          wasteGrade.text.isEmpty) {
        setState(() {
          double t1Bag = double.parse(preClean.text);
          wTotalBags = t1Bag.toStringAsFixed(2);
        });
      } else if (preClean.text.isNotEmpty &&
          stones.text.isNotEmpty &&
          wasteGrade.text.isEmpty) {
        double pClean = double.parse(preClean.text);
        double sto = double.parse(stones.text);
        double totBags = pClean + sto;
        setState(() {
          wTotalBags = totBags.toStringAsFixed(2);
        });
      } else if (preClean.text.isNotEmpty &&
          wasteGrade.text.isNotEmpty &&
          stones.text.isEmpty) {
        double pClean = double.parse(preClean.text);
        double wGrade = double.parse(wasteGrade.text);
        double totBags = pClean + wGrade;
        setState(() {
          wTotalBags = totBags.toStringAsFixed(2);
        });
      } else if (preClean.text.isNotEmpty &&
          wasteGrade.text.isNotEmpty &&
          stones.text.isNotEmpty) {
        double pClean = double.parse(preClean.text);
        double wGrade = double.parse(wasteGrade.text);
        double sto = double.parse(stones.text);
        double totBags = pClean + wGrade + sto;
        setState(() {
          wTotalBags = totBags.toStringAsFixed(2);
        });
      } else if (preClean.text.isEmpty &&
          wasteGrade.text.isNotEmpty &&
          stones.text.isEmpty) {
        double wGrade = double.parse(wasteGrade.text);

        setState(() {
          wTotalBags = wGrade.toStringAsFixed(2);
        });
      } else if (preClean.text.isEmpty &&
          wasteGrade.text.isEmpty &&
          stones.text.isNotEmpty) {
        setState(() {
          double t2Bag = double.parse(stones.text);
          wTotalBags = t2Bag.toStringAsFixed(2);
        });
      } else if (preClean.text.isEmpty &&
          wasteGrade.text.isNotEmpty &&
          stones.text.isNotEmpty) {
        double wGrade = double.parse(wasteGrade.text);
        double sto = double.parse(stones.text);
        double totBags = wGrade + sto;
        setState(() {
          wTotalBags = totBags.toStringAsFixed(2);
        });
      } else if (preClean.text.isEmpty &&
          wasteGrade.text.isEmpty &&
          stones.text.isEmpty) {
        // int wGrade = int.parse(wasteGrade.text);
        //int sto = int.parse(stones.text);
        double totBags = 0;
        setState(() {
          wTotalBags = totBags.toStringAsFixed(2);
        });
      }
    });

    //stone calculation
    stones.addListener(() {
      if (stones.text.isNotEmpty &&
          preClean.text.isEmpty &&
          wasteGrade.text.isEmpty) {
        print("1 called");
        double sBag = double.parse(stones.text);
        setState(() {
          wTotalBags = sBag.toStringAsFixed(2);
        });
      } else if (preClean.text.isNotEmpty &&
          stones.text.isNotEmpty &&
          wasteGrade.text.isEmpty) {
        print("2 called");
        double pClean = double.parse(preClean.text);
        double sto = double.parse(stones.text);
        double totBags = pClean + sto;
        setState(() {
          wTotalBags = totBags.toStringAsFixed(2);
        });
      } else if (wasteGrade.text.isEmpty &&
          preClean.text.isNotEmpty &&
          stones.text.isEmpty) {
        print("3 called");
        // setState(() {
        double pClean = double.parse(preClean.text);
        setState(() {
          wTotalBags = pClean.toStringAsFixed(2);
        });
        // });

      } else if (wasteGrade.text.isNotEmpty &&
          preClean.text.isNotEmpty &&
          stones.text.isNotEmpty) {
        print("4 called");
        double pClean = double.parse(preClean.text);
        double wGrade = double.parse(wasteGrade.text);
        double sto = double.parse(stones.text);
        double totBags = pClean + wGrade + sto;
        setState(() {
          wTotalBags = totBags.toStringAsFixed(2);
        });
      } else if (wasteGrade.text.isNotEmpty &&
          preClean.text.isNotEmpty &&
          stones.text.isEmpty) {
        print("4 called");
        double pClean = double.parse(preClean.text);
        int wGrade = int.parse(wasteGrade.text);
        // int sto = int.parse(stones.text);
        double totBags = pClean + wGrade;
        setState(() {
          wTotalBags = totBags.toStringAsFixed(2);
        });
      } else if (preClean.text.isEmpty &&
          wasteGrade.text.isEmpty &&
          stones.text.isEmpty) {
        // int wGrade = int.parse(wasteGrade.text);
        //int sto = int.parse(stones.text);
        double totBags = 0;
        setState(() {
          wTotalBags = totBags.toStringAsFixed(2);
        });
      } else if (preClean.text.isEmpty &&
          wasteGrade.text.isNotEmpty &&
          stones.text.isNotEmpty) {
        double wGrade = double.parse(wasteGrade.text);
        double sto = double.parse(stones.text);
        double totBags = wGrade + sto;
        setState(() {
          wTotalBags = totBags.toStringAsFixed(2);
        });
      } else if (preClean.text.isEmpty &&
          wasteGrade.text.isNotEmpty &&
          stones.text.isEmpty) {
        double wGrade = double.parse(wasteGrade.text);
        //int sto = int.parse(stones.text);
        double totBags = wGrade;
        setState(() {
          wTotalBags = totBags.toStringAsFixed(2);
        });
      }
    });

    //waste grade calculation

    wasteGrade.addListener(() {
      if (wasteGrade.text.isNotEmpty &&
          preClean.text.isEmpty &&
          stones.text.isEmpty) {
        double wBag = double.parse(wasteGrade.text);
        setState(() {
          wTotalBags = wBag.toStringAsFixed(2);
        });
      } else if (wasteGrade.text.isNotEmpty &&
          preClean.text.isNotEmpty &&
          stones.text.isEmpty) {
        double pClean = double.parse(preClean.text);
        double wGrade = double.parse(wasteGrade.text);
        double totBags = pClean + wGrade;
        setState(() {
          wTotalBags = totBags.toStringAsFixed(2);
        });
      } else if (wasteGrade.text.isNotEmpty &&
          preClean.text.isNotEmpty &&
          stones.text.isNotEmpty) {
        double pClean = double.parse(preClean.text);
        double wGrade = double.parse(wasteGrade.text);
        double sto = double.parse(stones.text);
        double totBags = pClean + wGrade + sto;
        setState(() {
          wTotalBags = totBags.toStringAsFixed(2);
        });
      } else if (wasteGrade.text.isEmpty &&
          preClean.text.isNotEmpty &&
          stones.text.isNotEmpty) {
        double pClean = double.parse(preClean.text);
        double sto = double.parse(stones.text);
        double totBags = pClean + sto;
        setState(() {
          wTotalBags = totBags.toStringAsFixed(2);
        });
      } else if (wasteGrade.text.isEmpty &&
          preClean.text.isNotEmpty &&
          stones.text.isEmpty) {
        double pClean = double.parse(preClean.text);
        // int sto = int.parse(stones.text);
        double totBags = pClean;
        setState(() {
          wTotalBags = totBags.toStringAsFixed(2);
        });
      } else if (wasteGrade.text.isNotEmpty &&
          preClean.text.isEmpty &&
          stones.text.isNotEmpty) {
        //int pClean = int.parse(preClean.text);
        double wGrade = double.parse(wasteGrade.text);
        double sto = double.parse(stones.text);
        double totBags = wGrade + sto;
        setState(() {
          wTotalBags = totBags.toStringAsFixed(2);
        });
      } else if (wasteGrade.text.isEmpty &&
          preClean.text.isEmpty &&
          stones.text.isNotEmpty) {
        //int pClean = int.parse(preClean.text);
        //int wGrade  = int.parse(wasteGrade.text);
        double sto = double.parse(stones.text);
        double totBags = sto;
        setState(() {
          wTotalBags = totBags.toStringAsFixed(2);
        });
      } else if (preClean.text.isEmpty &&
          wasteGrade.text.isEmpty &&
          stones.text.isEmpty) {
        // int wGrade = int.parse(wasteGrade.text);
        //int sto = int.parse(stones.text);
        double totBags = 0;
        setState(() {
          wTotalBags = totBags.toStringAsFixed(2);
        });
      }
    });

    double r1899 = 0;
    double r1599 = 0;
    double r1199 = 0;
    double r1299 = 0;
*/ /*when value is entered for reject 1899*/ /*
    reject1899.addListener(() {
      if (reject1899.text.isNotEmpty &&
          reject1599.text.isEmpty &&
          reject1299.text.isEmpty &&
          reject1199.text.isEmpty) {
        */ /*when reject 1899 is not empty*/ /*
        double r18 = double.parse(reject1899.text);
        setState(() {
          gTotalBags = r18.toStringAsFixed(2);
        });
      } else if (reject1899.text.isEmpty &&
          reject1599.text.isEmpty &&
          reject1299.text.isEmpty &&
          reject1199.text.isEmpty) {
        */ /*when all values are empty*/ /*
        double gBags = 0;
        setState(() {
          gTotalBags = gBags.toStringAsFixed(2);
        });
      } else if (reject1899.text.isNotEmpty &&
          reject1599.text.isNotEmpty &&
          reject1299.text.isEmpty &&
          reject1199.text.isEmpty) {
        */ /*when reject 1899 and reject 1599 is not empty*/ /*
        r1899 = double.parse(reject1899.text);
        r1599 = double.parse(reject1599.text);
        double tBag = r1899 + r1599;
        setState(() {
          gTotalBags = tBag.toStringAsFixed(2);
        });
      } else if (reject1899.text.isNotEmpty &&
          reject1599.text.isNotEmpty &&
          reject1299.text.isNotEmpty &&
          reject1199.text.isNotEmpty) {
        */ /*when all values are not empty*/ /*
        r1899 = double.parse(reject1899.text);
        r1599 = double.parse(reject1599.text);
        r1299 = double.parse(reject1299.text);
        r1199 = double.parse(reject1199.text);

        double tBag = r1899 + r1599 + r1299 + r1199;
        setState(() {
          gTotalBags = tBag.toStringAsFixed(2);
        });
      } else if (reject1899.text.isNotEmpty &&
          reject1599.text.isEmpty &&
          reject1299.text.isNotEmpty &&
          reject1199.text.isEmpty) {
        */ /*when reject 1899 and reject 1299 values are not empty*/ /*
        r1899 = double.parse(reject1899.text);

        r1299 = double.parse(reject1299.text);

        double tBag = r1899 + r1299;
        setState(() {
          gTotalBags = tBag.toStringAsFixed(2);
        });
      } else if (reject1899.text.isNotEmpty &&
          reject1599.text.isEmpty &&
          reject1299.text.isEmpty &&
          reject1199.text.isNotEmpty) {
        */ /*when 1899,1199 values are not empty*/ /*
        r1899 = double.parse(reject1899.text);

        r1199 = double.parse(reject1199.text);

        double tBag = r1899 + r1199;
        setState(() {
          gTotalBags = tBag.toStringAsFixed(2);
        });
      } else if (reject1899.text.isNotEmpty &&
          reject1599.text.isNotEmpty &&
          reject1299.text.isNotEmpty &&
          reject1199.text.isEmpty) {
        */ /*when 1899,1599,1299 are not empty*/ /*
        r1899 = double.parse(reject1899.text);
        r1599 = double.parse(reject1599.text);
        r1299 = double.parse(reject1299.text);

        double tBag = r1899 + r1599 + r1299;
        setState(() {
          gTotalBags = tBag.toStringAsFixed(2);
        });
      } else if (reject1899.text.isNotEmpty &&
          reject1599.text.isNotEmpty &&
          reject1299.text.isEmpty &&
          reject1199.text.isNotEmpty) {
        */ /*when 1899,1599,1199 values are not empty*/ /*
        r1899 = double.parse(reject1899.text);
        r1599 = double.parse(reject1599.text);
        r1199 = double.parse(reject1199.text);

        double tBag = r1899 + r1599 + r1199;
        setState(() {
          gTotalBags = tBag.toStringAsFixed(2);
        });
      } else if (reject1899.text.isNotEmpty &&
          reject1599.text.isEmpty &&
          reject1299.text.isNotEmpty &&
          reject1199.text.isNotEmpty) {
        */ /*when 1899,1299,1199 values are not empty*/ /*
        r1899 = double.parse(reject1899.text);
        r1299 = double.parse(reject1299.text);
        r1199 = double.parse(reject1199.text);

        double tBag = r1899 + r1299 + r1199;
        setState(() {
          gTotalBags = tBag.toStringAsFixed(2);
        });
      } else if (reject1899.text.isEmpty &&
          reject1599.text.isNotEmpty &&
          reject1299.text.isNotEmpty &&
          reject1199.text.isNotEmpty) {
        */ /*when 1599,1299,1199 values are not empty*/ /*
        r1599 = double.parse(reject1599.text);
        r1299 = double.parse(reject1299.text);
        r1199 = double.parse(reject1199.text);

        double tBag = r1599 + r1299 + r1199;
        setState(() {
          gTotalBags = tBag.toStringAsFixed(2);
        });
      } else if (reject1899.text.isEmpty &&
          reject1599.text.isEmpty &&
          reject1299.text.isNotEmpty &&
          reject1199.text.isNotEmpty) {
        */ /*when 1299,1199 values are not empty*/ /*

        r1299 = double.parse(reject1299.text);
        r1199 = double.parse(reject1199.text);

        double tBag = r1299 + r1199;
        setState(() {
          gTotalBags = tBag.toStringAsFixed(2);
        });
      } else if (reject1899.text.isEmpty &&
          reject1599.text.isNotEmpty &&
          reject1299.text.isEmpty &&
          reject1199.text.isNotEmpty) {
        */ /*when 1599,1199 values are not empty*/ /*

        r1599 = double.parse(reject1599.text);
        r1199 = double.parse(reject1199.text);

        double tBag = r1599 + r1199;
        setState(() {
          gTotalBags = tBag.toStringAsFixed(2);
        });
      } else if (reject1899.text.isEmpty &&
          reject1599.text.isNotEmpty &&
          reject1299.text.isNotEmpty &&
          reject1199.text.isEmpty) {
        */ /*when 1599,1299 values are not empty*/ /*

        r1599 = double.parse(reject1599.text);
        r1299 = double.parse(reject1299.text);

        double tBag = r1599 + r1299;
        setState(() {
          gTotalBags = tBag.toStringAsFixed(2);
        });
      } else if (reject1899.text.isEmpty &&
          reject1599.text.isNotEmpty &&
          reject1299.text.isEmpty &&
          reject1199.text.isEmpty) {
        */ /*when 1599 values are not empty*/ /*

        r1599 = double.parse(reject1599.text);

        double tBag = r1599;
        setState(() {
          gTotalBags = tBag.toStringAsFixed(2);
        });
      } else if (reject1899.text.isEmpty &&
          reject1599.text.isEmpty &&
          reject1299.text.isNotEmpty &&
          reject1199.text.isEmpty) {
        */ /*when 1299 values are not empty*/ /*

        r1299 = double.parse(reject1299.text);

        double tBag = r1299;
        setState(() {
          gTotalBags = tBag.toStringAsFixed(2);
        });
      } else if (reject1899.text.isEmpty &&
          reject1599.text.isEmpty &&
          reject1299.text.isEmpty &&
          reject1199.text.isNotEmpty) {
        */ /*when 1199 values are not empty*/ /*

        r1199 = double.parse(reject1199.text);

        double tBag = r1199;
        setState(() {
          gTotalBags = tBag.toStringAsFixed(2);
        });
      }
    });
*/ /*when value is entered for reject 1599*/ /*
    reject1599.addListener(() {
      if (reject1899.text.isEmpty &&
          reject1599.text.isNotEmpty &&
          reject1299.text.isEmpty &&
          reject1199.text.isEmpty) {
        */ /*when reject 1599 is not empty*/ /*
        double r15 = double.parse(reject1599.text);
        setState(() {
          gTotalBags = r15.toStringAsFixed(2);
        });
      } else if (reject1899.text.isEmpty &&
          reject1599.text.isEmpty &&
          reject1299.text.isEmpty &&
          reject1199.text.isEmpty) {
        */ /*when all values are empty*/ /*
        double gBags = 0;
        setState(() {
          gTotalBags = gBags.toStringAsFixed(2);
        });
      } else if (reject1899.text.isNotEmpty &&
          reject1599.text.isNotEmpty &&
          reject1299.text.isEmpty &&
          reject1199.text.isEmpty) {
        */ /*when reject 1899 and reject 1599 is not empty*/ /*
        r1899 = double.parse(reject1899.text);
        r1599 = double.parse(reject1599.text);
        double tBag = r1899 + r1599;
        setState(() {
          gTotalBags = tBag.toStringAsFixed(2);
        });
      } else if (reject1899.text.isNotEmpty &&
          reject1599.text.isNotEmpty &&
          reject1299.text.isNotEmpty &&
          reject1199.text.isNotEmpty) {
        */ /*when all values are not empty*/ /*
        r1899 = double.parse(reject1899.text);
        r1599 = double.parse(reject1599.text);
        r1299 = double.parse(reject1299.text);
        r1199 = double.parse(reject1199.text);

        double tBag = r1899 + r1599 + r1299 + r1199;
        setState(() {
          gTotalBags = tBag.toStringAsFixed(2);
        });
      } else if (reject1899.text.isNotEmpty &&
          reject1599.text.isEmpty &&
          reject1299.text.isNotEmpty &&
          reject1199.text.isEmpty) {
        */ /*when reject 1899 and reject 1299 values are not empty*/ /*
        r1899 = double.parse(reject1899.text);

        r1299 = double.parse(reject1299.text);

        double tBag = r1899 + r1299;
        setState(() {
          gTotalBags = tBag.toStringAsFixed(2);
        });
      } else if (reject1899.text.isNotEmpty &&
          reject1599.text.isEmpty &&
          reject1299.text.isEmpty &&
          reject1199.text.isNotEmpty) {
        */ /*when 1899,1199 values are not empty*/ /*
        r1899 = double.parse(reject1899.text);

        r1199 = double.parse(reject1199.text);

        double tBag = r1899 + r1199;
        setState(() {
          gTotalBags = tBag.toStringAsFixed(2);
        });
      } else if (reject1899.text.isNotEmpty &&
          reject1599.text.isNotEmpty &&
          reject1299.text.isNotEmpty &&
          reject1199.text.isEmpty) {
        */ /*when 1899,1599,1299 are not empty*/ /*
        r1899 = double.parse(reject1899.text);
        r1599 = double.parse(reject1599.text);
        r1299 = double.parse(reject1299.text);

        double tBag = r1899 + r1599 + r1299;
        setState(() {
          gTotalBags = tBag.toStringAsFixed(2);
        });
      } else if (reject1899.text.isNotEmpty &&
          reject1599.text.isNotEmpty &&
          reject1299.text.isEmpty &&
          reject1199.text.isNotEmpty) {
        */ /*when 1899,1599,1199 values are not empty*/ /*
        r1899 = double.parse(reject1899.text);
        r1599 = double.parse(reject1599.text);
        r1199 = double.parse(reject1199.text);

        double tBag = r1899 + r1599 + r1199;
        setState(() {
          gTotalBags = tBag.toStringAsFixed(2);
        });
      } else if (reject1899.text.isNotEmpty &&
          reject1599.text.isEmpty &&
          reject1299.text.isNotEmpty &&
          reject1199.text.isNotEmpty) {
        */ /*when 1899,1299,1199 values are not empty*/ /*
        r1899 = double.parse(reject1899.text);
        r1299 = double.parse(reject1299.text);
        r1199 = double.parse(reject1199.text);

        double tBag = r1899 + r1299 + r1199;
        setState(() {
          gTotalBags = tBag.toStringAsFixed(2);
        });
      } else if (reject1899.text.isEmpty &&
          reject1599.text.isNotEmpty &&
          reject1299.text.isNotEmpty &&
          reject1199.text.isNotEmpty) {
        */ /*when 1599,1299,1199 values are not empty*/ /*
        r1599 = double.parse(reject1599.text);
        r1299 = double.parse(reject1299.text);
        r1199 = double.parse(reject1199.text);

        double tBag = r1599 + r1299 + r1199;
        setState(() {
          gTotalBags = tBag.toStringAsFixed(2);
        });
      } else if (reject1899.text.isEmpty &&
          reject1599.text.isEmpty &&
          reject1299.text.isNotEmpty &&
          reject1199.text.isNotEmpty) {
        */ /*when 1299,1199 values are not empty*/ /*

        r1299 = double.parse(reject1299.text);
        r1199 = double.parse(reject1199.text);

        double tBag = r1299 + r1199;
        setState(() {
          gTotalBags = tBag.toStringAsFixed(2);
        });
      } else if (reject1899.text.isEmpty &&
          reject1599.text.isNotEmpty &&
          reject1299.text.isEmpty &&
          reject1199.text.isNotEmpty) {
        */ /*when 1599,1199 values are not empty*/ /*

        r1599 = double.parse(reject1599.text);
        r1199 = double.parse(reject1199.text);

        double tBag = r1599 + r1199;
        setState(() {
          gTotalBags = tBag.toStringAsFixed(2);
        });
      } else if (reject1899.text.isEmpty &&
          reject1599.text.isNotEmpty &&
          reject1299.text.isNotEmpty &&
          reject1199.text.isEmpty) {
        */ /*when 1599,1299 values are not empty*/ /*

        r1599 = double.parse(reject1599.text);
        r1299 = double.parse(reject1299.text);

        double tBag = r1599 + r1299;
        setState(() {
          gTotalBags = tBag.toStringAsFixed(2);
        });
      } else if (reject1899.text.isEmpty &&
          reject1599.text.isNotEmpty &&
          reject1299.text.isEmpty &&
          reject1199.text.isEmpty) {
        */ /*when 1599 values are not empty*/ /*

        r1599 = double.parse(reject1599.text);

        double tBag = r1599;
        setState(() {
          gTotalBags = tBag.toStringAsFixed(2);
        });
      } else if (reject1899.text.isEmpty &&
          reject1599.text.isEmpty &&
          reject1299.text.isNotEmpty &&
          reject1199.text.isEmpty) {
        */ /*when 1299 values are not empty*/ /*

        r1299 = double.parse(reject1299.text);

        double tBag = r1299;
        setState(() {
          gTotalBags = tBag.toStringAsFixed(2);
        });
      } else if (reject1899.text.isEmpty &&
          reject1599.text.isEmpty &&
          reject1299.text.isEmpty &&
          reject1199.text.isNotEmpty) {
        */ /*when 1199 values are not empty*/ /*

        r1199 = double.parse(reject1199.text);

        double tBag = r1199;
        setState(() {
          gTotalBags = tBag.toStringAsFixed(2);
        });
      }
    });

*/ /*when value is entered for reject 1299*/ /*
    reject1299.addListener(() {
      if (reject1899.text.isEmpty &&
          reject1599.text.isEmpty &&
          reject1299.text.isNotEmpty &&
          reject1199.text.isEmpty) {
        */ /*when reject 1899 is not empty*/ /*
        double r12 = double.parse(reject1299.text);
        setState(() {
          gTotalBags = r12.toStringAsFixed(2);
        });
      } else if (reject1899.text.isEmpty &&
          reject1599.text.isEmpty &&
          reject1299.text.isEmpty &&
          reject1199.text.isEmpty) {
        */ /*when all values are empty*/ /*
        double gBags = 0;
        setState(() {
          gTotalBags = gBags.toStringAsFixed(2);
        });
      } else if (reject1899.text.isNotEmpty &&
          reject1599.text.isNotEmpty &&
          reject1299.text.isEmpty &&
          reject1199.text.isEmpty) {
        */ /*when reject 1899 and reject 1599 is not empty*/ /*
        r1899 = double.parse(reject1899.text);
        r1599 = double.parse(reject1599.text);
        double tBag = r1899 + r1599;
        setState(() {
          gTotalBags = tBag.toStringAsFixed(2);
        });
      } else if (reject1899.text.isNotEmpty &&
          reject1599.text.isNotEmpty &&
          reject1299.text.isNotEmpty &&
          reject1199.text.isNotEmpty) {
        */ /*when all values are not empty*/ /*
        r1899 = double.parse(reject1899.text);
        r1599 = double.parse(reject1599.text);
        r1299 = double.parse(reject1299.text);
        r1199 = double.parse(reject1199.text);

        double tBag = r1899 + r1599 + r1299 + r1199;
        setState(() {
          gTotalBags = tBag.toStringAsFixed(2);
        });
      } else if (reject1899.text.isNotEmpty &&
          reject1599.text.isEmpty &&
          reject1299.text.isNotEmpty &&
          reject1199.text.isEmpty) {
        */ /*when reject 1899 and reject 1299 values are not empty*/ /*
        r1899 = double.parse(reject1899.text);

        r1299 = double.parse(reject1299.text);

        double tBag = r1899 + r1299;
        setState(() {
          gTotalBags = tBag.toStringAsFixed(2);
        });
      } else if (reject1899.text.isNotEmpty &&
          reject1599.text.isEmpty &&
          reject1299.text.isEmpty &&
          reject1199.text.isNotEmpty) {
        */ /*when 1899,1199 values are not empty*/ /*
        r1899 = double.parse(reject1899.text);

        r1199 = double.parse(reject1199.text);

        double tBag = r1899 + r1199;
        setState(() {
          gTotalBags = tBag.toStringAsFixed(2);
        });
      } else if (reject1899.text.isNotEmpty &&
          reject1599.text.isNotEmpty &&
          reject1299.text.isNotEmpty &&
          reject1199.text.isEmpty) {
        */ /*when 1899,1599,1299 are not empty*/ /*
        r1899 = double.parse(reject1899.text);
        r1599 = double.parse(reject1599.text);
        r1299 = double.parse(reject1299.text);

        double tBag = r1899 + r1599 + r1299;
        setState(() {
          gTotalBags = tBag.toStringAsFixed(2);
        });
      } else if (reject1899.text.isNotEmpty &&
          reject1599.text.isNotEmpty &&
          reject1299.text.isEmpty &&
          reject1199.text.isNotEmpty) {
        */ /*when 1899,1599,1199 values are not empty*/ /*
        r1899 = double.parse(reject1899.text);
        r1599 = double.parse(reject1599.text);
        r1199 = double.parse(reject1199.text);

        double tBag = r1899 + r1599 + r1199;
        setState(() {
          gTotalBags = tBag.toStringAsFixed(2);
        });
      } else if (reject1899.text.isNotEmpty &&
          reject1599.text.isEmpty &&
          reject1299.text.isNotEmpty &&
          reject1199.text.isNotEmpty) {
        */ /*when 1899,1299,1199 values are not empty*/ /*
        r1899 = double.parse(reject1899.text);
        r1299 = double.parse(reject1299.text);
        r1199 = double.parse(reject1199.text);

        double tBag = r1899 + r1299 + r1199;
        setState(() {
          gTotalBags = tBag.toStringAsFixed(2);
        });
      } else if (reject1899.text.isEmpty &&
          reject1599.text.isNotEmpty &&
          reject1299.text.isNotEmpty &&
          reject1199.text.isNotEmpty) {
        */ /*when 1599,1299,1199 values are not empty*/ /*
        r1599 = double.parse(reject1599.text);
        r1299 = double.parse(reject1299.text);
        r1199 = double.parse(reject1199.text);

        double tBag = r1599 + r1299 + r1199;
        setState(() {
          gTotalBags = tBag.toStringAsFixed(2);
        });
      } else if (reject1899.text.isEmpty &&
          reject1599.text.isEmpty &&
          reject1299.text.isNotEmpty &&
          reject1199.text.isNotEmpty) {
        */ /*when 1299,1199 values are not empty*/ /*

        r1299 = double.parse(reject1299.text);
        r1199 = double.parse(reject1199.text);

        double tBag = r1299 + r1199;
        setState(() {
          gTotalBags = tBag.toStringAsFixed(2);
        });
      } else if (reject1899.text.isEmpty &&
          reject1599.text.isNotEmpty &&
          reject1299.text.isEmpty &&
          reject1199.text.isNotEmpty) {
        */ /*when 1599,1199 values are not empty*/ /*

        r1599 = double.parse(reject1599.text);
        r1199 = double.parse(reject1199.text);

        double tBag = r1599 + r1199;
        setState(() {
          gTotalBags = tBag.toStringAsFixed(2);
        });
      } else if (reject1899.text.isEmpty &&
          reject1599.text.isNotEmpty &&
          reject1299.text.isNotEmpty &&
          reject1199.text.isEmpty) {
        */ /*when 1599,1299 values are not empty*/ /*

        r1599 = double.parse(reject1599.text);
        r1299 = double.parse(reject1299.text);

        double tBag = r1599 + r1299;
        setState(() {
          gTotalBags = tBag.toStringAsFixed(2);
        });
      } else if (reject1899.text.isEmpty &&
          reject1599.text.isNotEmpty &&
          reject1299.text.isEmpty &&
          reject1199.text.isEmpty) {
        */ /*when 1599 values are not empty*/ /*

        r1599 = double.parse(reject1599.text);

        double tBag = r1599;
        setState(() {
          gTotalBags = tBag.toStringAsFixed(2);
        });
      } else if (reject1899.text.isEmpty &&
          reject1599.text.isEmpty &&
          reject1299.text.isNotEmpty &&
          reject1199.text.isEmpty) {
        */ /*when 1299 values are not empty*/ /*

        r1299 = double.parse(reject1299.text);

        double tBag = r1299;
        setState(() {
          gTotalBags = tBag.toStringAsFixed(2);
        });
      } else if (reject1899.text.isEmpty &&
          reject1599.text.isEmpty &&
          reject1299.text.isEmpty &&
          reject1199.text.isNotEmpty) {
        */ /*when 1199 values are not empty*/ /*

        r1199 = double.parse(reject1199.text);

        double tBag = r1199;
        setState(() {
          gTotalBags = tBag.toStringAsFixed(2);
        });
      }
    });

    */ /*when value is entered for reject 1199*/ /*
    reject1199.addListener(() {
      if (reject1899.text.isEmpty &&
          reject1599.text.isEmpty &&
          reject1299.text.isEmpty &&
          reject1199.text.isNotEmpty) {
        */ /*when reject 1899 is not empty*/ /*
        double r11 = double.parse(reject1199.text);
        setState(() {
          gTotalBags = r11.toStringAsFixed(2);
        });
      } else if (reject1899.text.isEmpty &&
          reject1599.text.isEmpty &&
          reject1299.text.isEmpty &&
          reject1199.text.isEmpty) {
        */ /*when all values are empty*/ /*
        double gBags = 0;
        setState(() {
          gTotalBags = gBags.toStringAsFixed(2);
        });
      } else if (reject1899.text.isNotEmpty &&
          reject1599.text.isNotEmpty &&
          reject1299.text.isEmpty &&
          reject1199.text.isEmpty) {
        */ /*when reject 1899 and reject 1599 is not empty*/ /*
        r1899 = double.parse(reject1899.text);
        r1599 = double.parse(reject1599.text);
        double tBag = r1899 + r1599;
        setState(() {
          gTotalBags = tBag.toStringAsFixed(2);
        });
      } else if (reject1899.text.isNotEmpty &&
          reject1599.text.isNotEmpty &&
          reject1299.text.isNotEmpty &&
          reject1199.text.isNotEmpty) {
        */ /*when all values are not empty*/ /*
        r1899 = double.parse(reject1899.text);
        r1599 = double.parse(reject1599.text);
        r1299 = double.parse(reject1299.text);
        r1199 = double.parse(reject1199.text);

        double tBag = r1899 + r1599 + r1299 + r1199;
        setState(() {
          gTotalBags = tBag.toStringAsFixed(2);
        });
      } else if (reject1899.text.isNotEmpty &&
          reject1599.text.isEmpty &&
          reject1299.text.isNotEmpty &&
          reject1199.text.isEmpty) {
        */ /*when reject 1899 and reject 1299 values are not empty*/ /*
        r1899 = double.parse(reject1899.text);

        r1299 = double.parse(reject1299.text);

        double tBag = r1899 + r1299;
        setState(() {
          gTotalBags = tBag.toStringAsFixed(2);
        });
      } else if (reject1899.text.isNotEmpty &&
          reject1599.text.isEmpty &&
          reject1299.text.isEmpty &&
          reject1199.text.isNotEmpty) {
        */ /*when 1899,1199 values are not empty*/ /*
        r1899 = double.parse(reject1899.text);

        r1199 = double.parse(reject1199.text);

        double tBag = r1899 + r1199;
        setState(() {
          gTotalBags = tBag.toStringAsFixed(2);
        });
      } else if (reject1899.text.isNotEmpty &&
          reject1599.text.isNotEmpty &&
          reject1299.text.isNotEmpty &&
          reject1199.text.isEmpty) {
        */ /*when 1899,1599,1299 are not empty*/ /*
        r1899 = double.parse(reject1899.text);
        r1599 = double.parse(reject1599.text);
        r1299 = double.parse(reject1299.text);

        double tBag = r1899 + r1599 + r1299;
        setState(() {
          gTotalBags = tBag.toStringAsFixed(2);
        });
      } else if (reject1899.text.isNotEmpty &&
          reject1599.text.isNotEmpty &&
          reject1299.text.isEmpty &&
          reject1199.text.isNotEmpty) {
        */ /*when 1899,1599,1199 values are not empty*/ /*
        r1899 = double.parse(reject1899.text);
        r1599 = double.parse(reject1599.text);
        r1199 = double.parse(reject1199.text);

        double tBag = r1899 + r1599 + r1199;
        setState(() {
          gTotalBags = tBag.toStringAsFixed(2);
        });
      } else if (reject1899.text.isNotEmpty &&
          reject1599.text.isEmpty &&
          reject1299.text.isNotEmpty &&
          reject1199.text.isNotEmpty) {
        */ /*when 1899,1299,1199 values are not empty*/ /*
        r1899 = double.parse(reject1899.text);
        r1299 = double.parse(reject1299.text);
        r1199 = double.parse(reject1199.text);

        double tBag = r1899 + r1299 + r1199;
        setState(() {
          gTotalBags = tBag.toStringAsFixed(2);
        });
      } else if (reject1899.text.isEmpty &&
          reject1599.text.isNotEmpty &&
          reject1299.text.isNotEmpty &&
          reject1199.text.isNotEmpty) {
        */ /*when 1599,1299,1199 values are not empty*/ /*
        r1599 = double.parse(reject1599.text);
        r1299 = double.parse(reject1299.text);
        r1199 = double.parse(reject1199.text);

        double tBag = r1599 + r1299 + r1199;
        setState(() {
          gTotalBags = tBag.toStringAsFixed(2);
        });
      } else if (reject1899.text.isEmpty &&
          reject1599.text.isEmpty &&
          reject1299.text.isNotEmpty &&
          reject1199.text.isNotEmpty) {
        */ /*when 1299,1199 values are not empty*/ /*

        r1299 = double.parse(reject1299.text);
        r1199 = double.parse(reject1199.text);

        double tBag = r1299 + r1199;
        setState(() {
          gTotalBags = tBag.toStringAsFixed(2);
        });
      } else if (reject1899.text.isEmpty &&
          reject1599.text.isNotEmpty &&
          reject1299.text.isEmpty &&
          reject1199.text.isNotEmpty) {
        */ /*when 1599,1199 values are not empty*/ /*

        r1599 = double.parse(reject1599.text);
        r1199 = double.parse(reject1199.text);

        double tBag = r1599 + r1199;
        setState(() {
          gTotalBags = tBag.toStringAsFixed(2);
        });
      } else if (reject1899.text.isEmpty &&
          reject1599.text.isNotEmpty &&
          reject1299.text.isNotEmpty &&
          reject1199.text.isEmpty) {
        */ /*when 1599,1299 values are not empty*/ /*

        r1599 = double.parse(reject1599.text);
        r1299 = double.parse(reject1299.text);

        double tBag = r1599 + r1299;
        setState(() {
          gTotalBags = tBag.toStringAsFixed(2);
        });
      } else if (reject1899.text.isEmpty &&
          reject1599.text.isNotEmpty &&
          reject1299.text.isEmpty &&
          reject1199.text.isEmpty) {
        */ /*when 1599 values are not empty*/ /*

        r1599 = double.parse(reject1599.text);

        double tBag = r1599;
        setState(() {
          gTotalBags = tBag.toStringAsFixed(2);
        });
      } else if (reject1899.text.isEmpty &&
          reject1599.text.isEmpty &&
          reject1299.text.isNotEmpty &&
          reject1199.text.isEmpty) {
        */ /*when 1299 values are not empty*/ /*

        r1299 = double.parse(reject1299.text);

        double tBag = r1299;
        setState(() {
          gTotalBags = tBag.toStringAsFixed(2);
        });
      } else if (reject1899.text.isEmpty &&
          reject1599.text.isEmpty &&
          reject1299.text.isEmpty &&
          reject1199.text.isNotEmpty) {
        */ /*when 1199 values are not empty*/ /*

        r1199 = double.parse(reject1199.text);

        double tBag = r1199;
        setState(() {
          gTotalBags = tBag.toStringAsFixed(2);
        });
      }
    });*/

    /*validation to check whether user enter value is less than available bag*/
    inputBags.addListener(() {
      outputBags.clear();
      if (double.parse(inputBags.text) > double.parse(avlBags)) {
        errordialog(context, "Information",
            "Input Bag should be less than or equal to Available bags");
        setState(() {
          inputBags.clear();
        });
      }
    });
    /*validation to check whether user enter value is less than available kg*/
    inputKgs.addListener(() {
      outputKgs.clear();
      if (double.parse(inputKgs.text) > double.parse(avlKgs)) {
        errordialog(context, "Information",
            "Input Kgs should be less than or equal to Available Kgs");
        setState(() {
          inputKgs.clear();
        });
      }
    });

    /*validation to check whether user enter value is less than input bag*/
    outputBags.addListener(() {
      if (double.parse(outputBags.text) > double.parse(inputBags.text)) {
        errordialog(context, "Information",
            "Output Bag should be less than or equal to Input bags");
        setState(() {
          outputBags.clear();
        });
      }
    });

    /*validation to check whether user enter value is less than available bag*/
    outputKgs.addListener(() {
      if (double.parse(outputKgs.text) > double.parse(inputKgs.text)) {
        errordialog(context, "Information",
            "Output Kgs should be less than or equal to Input Kgs");
        setState(() {
          outputKgs.clear();
        });
      }
    });

    wgnoBags.addListener(() {
      if (wgnoBags.text.isNotEmpty) {
        double fBag = double.parse(wgnoBags.text);
        double sku = double.parse(slct_sku);
        setState(() {
          double tKgs = fBag / sku;
          wTotalBags = tKgs.ceil().toString();
          print("total weight:" + tKgs.toString());
        });
      } else {
        setState(() {
          wTotalBags = "0";
        });
      }
    });

    grnoBags.addListener(() {
      if (grnoBags.text.isNotEmpty) {
        double fBag = double.parse(grnoBags.text);
        double sku = double.parse(slct_sku);
        setState(() {
          double tKgs = fBag / sku;
          gTotalBags = tKgs.ceil().toString();
          print("total weight:" + tKgs.toString());
        });
      } else {
        setState(() {
          gTotalBags = "0";
        });
      }
    });

    skuController.addListener(() {
      if (skuController.text.isNotEmpty && inputDetailList.isNotEmpty) {
        for (int i = 0; i < inputDetailList.length; i++) {
          double oBag = double.parse(inputDetailList[i].outputKgs);
          double sk = double.parse(skuController.text);
          total = oBag / sk;
          inputDetailList[i].outputBags = total.ceil().toString();
          print("skskskbag:" + total.toString());
        }
      }
    });

    skuController.addListener(() {
      if ((skuController.text.isNotEmpty && wgnoBags.text.isNotEmpty) ||
          (skuController.text.isNotEmpty && grnoBags.text.isNotEmpty)) {
        setState(() {
          double fBag = double.parse(wgnoBags.text);
          double sku = double.parse(slct_sku);
          setState(() {
            double tKgs = fBag / sku;
            wTotalBags = tKgs.round().toString();
            print("total weight:" + tKgs.toString());
          });
          double ffBag = double.parse(grnoBags.text);
          double ssku = double.parse(slct_sku);
          setState(() {
            double tsKgs = ffBag / ssku;
            gTotalBags = tsKgs.ceil().toString();
            print("total weight:" + tsKgs.toString());
          });
        });
      }
    });

    //}
  }

  Future<void> initvalues() async {
    List batchNoList = await db.RawQuery(
        'select distinct batchNo from batchCreationList where stockType ="1" and isDelete = "0" and cast(weight as double)>0 and cast(noOfBag as int)>0');
    print(' batchNoList' + batchNoList.toString());

    outputGradeItem.clear();
    for (int i = 0; i < batchNoList.length; i++) {
      String typurchseName = batchNoList[i]["batchNo"].toString();
      String typurchseCode = batchNoList[i]["batchNo"].toString();
      var uimodel = new UImodel(typurchseName, typurchseCode);

      setState(() {
        lotNoItem.add(DropdownModel(
          typurchseName,
          typurchseCode,
        ));
      });
    }

    List skuList = await db.RawQuery(
        'select * from animalCatalog where catalog_code = \'' + "346" + '\'');
    print(' skulist' + skuList.toString());

    skuItems.clear();
    for (int i = 0; i < skuList.length; i++) {
      String typurchseName = skuList[i]["property_value"].toString();
      String typurchseCode = skuList[i]["DISP_SEQ"].toString();
      var uimodel = new UImodel(typurchseName, typurchseCode);

      setState(() {
        skuItems.add(DropdownModel(
          typurchseName,
          typurchseCode,
        ));
      });
    }
  }

  loadGrade(String batchNo) async {
    List inputGradeList = await db.RawQuery(
        'select b.grade,a.property_value,b.noOfBag,b.weight from batchCreationList b, animalCatalog a where batchNo = \'' +
            batchNo +
            '\' and a.DISP_SEQ=b.grade and stockType="1" and isDelete = "0" ');
    print(' coffeeGradeList' + inputGradeList.toString());

    String grd = "";
    String noBag = "";
    String wght = "";
    String grdName = "";

    inputGradeItem.clear();
    for (int i = 0; i < inputGradeList.length; i++) {
      String typurchseName = inputGradeList[i]["property_value"].toString();
      String typurchseCode = inputGradeList[i]["grade"].toString();
      String nBag = inputGradeList[i]['noOfBag'].toString();
      String tWeight = inputGradeList[i]['weight'].toString();
      var uimodel = new UImodel(typurchseName, typurchseCode);

      setState(() {
        /* inputGradeItem.add(DropdownModel(
          typurchseName,
          typurchseCode,
        ));*/
        grd = typurchseCode;
        grdName = typurchseName;
        wght = tWeight;
        noBag = nBag;

        inputDetailList.add(InputDetail(
            gradeName: grdName,
            gradeCode: grd,
            availableBags: noBag,
            availableKgs: wght,
            inputBags: noBag,
            inputKgs: wght,
            outputBags: "0",
            outputKgs: "0"));
      });
    }
  }

  loadAvailableWtandKgs(String grade) async {
    List avlWtKg = await db.RawQuery(
        'select noOfBag,weight from batchCreationList where grade = \'' +
            grade +
            '\' and batchNo = \'' +
            val_LotNo +
            '\' and stockType="1"');
    print(' coffeeGradeList' + avlWtKg.toString());

    for (int i = 0; i < avlWtKg.length; i++) {
      String availableWt = avlWtKg[i]['weight'].toString();
      String availableBag = avlWtKg[i]['noOfBag'].toString();

      setState(() {
        avlKgs = availableWt;
        avlBags = availableBag;
      });
    }
  }

  getClientData() async {
    agents = await db.RawQuery('SELECT * FROM agentMaster');

    seasoncode = agents[0]['currentSeasonCode'];
    servicePointId = agents[0]['servicePointId'];
    agendId = agents[0]['agentId'];
    // String resIdd = agents[0]['resIdSeqF'];
    // print("resIdgetcliendata" + resIdd);
    print("agendId_agendId" + agendId);
  }

  void getLocation() async {
    bool isLocationEnabled = await Geolocator.isLocationServiceEnabled();
    if (isLocationEnabled) {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      print("latitude :" +
          position.latitude.toString() +
          " longitude: " +
          position.longitude.toString());
      setState(() {
        Latitude = position.latitude.toString();
        Longitude = position.longitude.toString();
      });
    } else {
      Alert(
          context: context,
          title: "Information",
          desc: "GPS location not enabled",
          buttons: [
            DialogButton(
              child: Text(
                "OK",
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              color: Colors.green,
            )
          ]).show();
    }
  }

  Future<bool> _onBackPressed() async {
    return (await Alert(
          context: context,
          type: AlertType.warning,
          title: "Cancel",
          desc: "Are you sure you want to Cancel?",
          buttons: [
            DialogButton(
              child: Text(
                "Yes",
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
                "No",
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
          appBar: AppBar(
            centerTitle: true,
            leading: IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () {
                  // Navigator.of(context).pop();

                  _onBackPressed();
                }),
            title: Text(
              "Primary Processing",
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
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _getListings(BuildContext context) {
    List<Widget> listings = [];

    listings.add(txt_label_mandatory(
        TranslateFun.langList['dateeCls'], Colors.black, 14.0, false));
    listings.add(selectDate(
        context1: context,
        slctdate: labelDate,
        onConfirm: (date) => setState(
              () {
                labelDate = DateFormat('dd/MM/yyyy').format(date!);
                Date = DateFormat('yyyyMMdd').format(date);
              },
            )));
    if (inputDetailList.length == 0 && gradeAdded) {
      listings
          .add(txt_label_mandatory("Batch Number", Colors.black, 14.0, false));
      listings.add(DropDownWithModel(
        itemlist: lotNoItem,
        selecteditem: slctLotNo,
        hint: "Select Batch Number",
        onChanged: (value) {
          setState(() {
            slctLotNo = value!;
            val_LotNo = slctLotNo!.value;
            slct_LotNo = slctLotNo!.name;
            batchNumber = slctLotNo!.value;
            slctInputGrade = null;
            slct_InputGrade = "";
            val_InputGrade = "";
            avlBags = "";
            avlKgs = "";
            inputKgs.clear();
            inputBags.clear();
            outputKgs.clear();
            outputBags.clear();
            loadGrade(val_LotNo);
            print("name of the slctLotNo:" + val_LotNo);
          });
        },
      ));
    } else {
      listings
          .add(txt_label_mandatory("Batch Number", Colors.black, 14.0, false));
      listings.add(cardlable_dynamic(batchNumber));
    }

    listings.add(
        txt_label(TranslateFun.langList['cusCls'], Colors.black, 14.0, false));
    listings
        .add(txtfield_dynamic(TranslateFun.langList['cusCls'], customer, true));

    listings.add(txt_label_mandatory(
        TranslateFun.langList['daStCls'], Colors.black, 14.0, false));
    listings.add(selectDate(
        context1: context,
        slctdate: startDate,
        onConfirm: (date) => setState(
              () {
                startDate = DateFormat('dd/MM/yyyy').format(date!);
                formatStartDate = DateFormat('yyyy/MM/dd').format(date);
                labelStartDate = DateFormat('yyyyMMdd').format(date);
                finalDateComparison(formatFinalDate);
                yearValue = int.parse(DateFormat('yyyy').format(date));
                monthValue = int.parse(DateFormat('MM').format(date));
                dayValue = int.parse(DateFormat('dd').format(date));
              },
            )));

    /*listings.add(
      ElevatedButton( style: ElevatedButton.styleFrom(
        primary: Colors.green,
      ), onPressed: (){
        setState(() {
          Utils.showSheet(
            context,
            child: buildTimePicker(),
            onClicked: () {
              setState(() {
                final value = DateFormat('HH:mm').format(dateTime);
                // Utils.showSnackBar(context, 'Selected "$value"');

                startTime = value.toString();
              });


              Navigator.pop(context);
            },);
        });

      }, child: Text(startTime))
    );*/

    listings.add(txt_label_mandatory(
        TranslateFun.langList['tiStCls'], Colors.black, 14.0, false));
    listings.add(
      MaterialButton(
        color: Colors.green,
        onPressed: () {
          setState(() {
            displayTimeDialog();
            print("time:" +
                selecteddesTimeStart.hour.toString() +
                ":" +
                selecteddesTimeStart.minute.toString());
            startTime =
                "${selecteddesTimeStart.hour}:${selecteddesTimeStart.minute}";
          });
        },
        child: Text("${selectStartTime}"),
      ),
    );

    if (labelStartDate.isNotEmpty) {
      listings.add(txt_label_mandatory(
          TranslateFun.langList['daFiCls'], Colors.black, 14.0, false));
      listings.add(selectFutureDate(
          year: yearValue,
          month: monthValue,
          day: dayValue,
          context1: context,
          slctdate: finishDate,
          onConfirm: (date) => setState(
                () {
                  finishDate = DateFormat('dd/MM/yyyy').format(date!);
                  formatFinalDate = DateFormat('yyyy/MM/dd').format(date!);
                  labelFinishDate = DateFormat('yyyyMMdd').format(date);
                  finalDateComparison(formatFinalDate);
                },
              )));
    }

    listings.add(txt_label_mandatory(
        TranslateFun.langList['tiFiCls'], Colors.black, 14.0, false));
    listings.add(
      MaterialButton(
        color: Colors.green,
        onPressed: () {
          displayTimeEndDialog();
          // print("timeFinished:" +
          //     selecteddesTimeFinish.hour.toString() +
          //     ":" +
          //     selecteddesTimeFinish.minute.toString()+finishedTime);
          //
          // finishedTime = selecteddesTimeFinish.hour.toString() +
          //     ":" +
          //     selecteddesTimeFinish.minute.toString();
        },
        child: Text("${selectFinishTime}"),
      ),
    );

    listings.add(txt_label_mandatory("SKU", Colors.black, 14.0, false));
    listings.add(DropDownWithModel(
      itemlist: skuItems,
      selecteditem: slctSku,
      hint: "Select SKU",
      onChanged: (value) {
        setState(() {
          slctSku = value!;
          val_sku = slctSku!.value;
          slct_sku = slctSku!.name;
          skuController.text = slctSku!.name;
          print("sku value:" + val_sku);
        });
      },
    ));

    /*grade*/
    /*listings
        .add(txt_label_mandatory("Coffee Grade", Colors.black, 14.0, false));
    listings.add(DropDownWithModel(
      itemlist: inputGradeItem,
      selecteditem: slctInputGrade,
      hint: "Select Coffee Grade",
      onChanged: (value) {
        setState(() {
          slctInputGrade = value!;
          val_InputGrade = slctInputGrade!.value;
          slct_InputGrade = slctInputGrade!.name;
          inputBags.clear();
          inputKgs.clear();
          outputBags.clear();
          outputKgs.clear();
          loadAvailableWtandKgs(val_InputGrade);
          print("name of the val_InputGrade:" + val_InputGrade);
        });
      },
    ));
    */ /*available Bags*/ /*
    listings
        .add(txt_label_mandatory("Available Bags", Colors.black, 14.0, false));
    listings.add(cardlable_dynamic(avlBags));
    */ /*available kgs*/ /*
    listings
        .add(txt_label_mandatory("Available Kgs", Colors.black, 14.0, false));
    listings.add(cardlable_dynamic(avlKgs));

    */ /*input Bags*/ /*
    listings.add(txt_label_mandatory("Input Bags", Colors.black, 14.0, false));
    listings
        .add(txtfield_digitswithoutdecimal("Input Bags", inputBags, true, 9));
    */ /*input kgs*/ /*
    listings.add(txt_label_mandatory("Input Kgs", Colors.black, 14.0, false));
    listings.add(txtfieldAllowTwoDecimal("Input Kgs", inputKgs, true, 9));
    */ /*output Bags*/ /*
    listings.add(txt_label_mandatory("Output Bags", Colors.black, 14.0, false));
    listings
        .add(txtfield_digitswithoutdecimal("Output Bags", outputBags, true, 9));
    listings.add(txt_label_mandatory("Output Kgs", Colors.black, 14.0, false));
    listings.add(txtfieldAllowTwoDecimal("Output Kgs", outputKgs, true, 9));*/

    // listings.add(txt_label_mandatory(
    //     TranslateFun.langList['totCls'], Colors.black, 14.0, false));
    // listings.add(cardlable_dynamic(inputTotal));

    /* listings.add(btn_dynamic(
        label: TranslateFun.langList['addCls'],
        bgcolor: Colors.green,
        txtcolor: Colors.white,
        fontsize: 18.0,
        centerRight: Alignment.centerRight,
        margin: 10.0,
        btnSubmit: () async {
          bool already = false;
          // setState(() {

          if (slct_InputGrade.isNotEmpty) {
            if (inputBags.text.isNotEmpty) {
              if (double.parse(inputBags.text) > 0) {
                if (inputKgs.text.isNotEmpty) {
                  if (double.parse(inputKgs.text) > 0) {
                    if (outputBags.text.isNotEmpty) {
                      if (double.parse(outputBags.text) > 0) {
                        if (outputKgs.text.isNotEmpty) {
                          if (batchNumber.isNotEmpty) {
                            if (double.parse(outputKgs.text) > 0) {
                              for (int i = 0; i < inputDetailList.length; i++) {
                                if (inputDetailList[i].gradeCode ==
                                    val_InputGrade) {
                                  already = true;
                                }
                              }
                              if (!already) {
                                gradeAdded = false;
                                setState(() {
                                  var inputDetaillistVal = InputDetail(
                                      gradeName: slct_InputGrade,
                                      gradeCode: val_InputGrade,
                                      availableBags: avlBags,
                                      availableKgs: avlKgs,
                                      inputBags: inputBags.text,
                                      inputKgs: inputKgs.text,
                                      outputBags: outputBags.text,
                                      outputKgs: outputKgs.text);

                                  inputDetailList.add(inputDetaillistVal);
                                  val_InputGrade = "";
                                  slct_InputGrade = "";
                                  slctInputGrade = null;
                                  inputKgs.clear();
                                  inputBags.clear();
                                  outputBags.clear();
                                  outputKgs.clear();
                                  avlBags = "";
                                  avlKgs = "";
                                });
                              } else {
                                errordialog(context, "Information",
                                    "select different grade");
                              }
                            } else {
                              errordialog(context, "Information",
                                  "Output Kgs should not be zero");
                              outputKgs.clear();
                            }
                          } else {
                            errordialog(context, "Information",
                                "Batch No should not be empty");
                          }
                        } else {
                          errordialog(context, "Information",
                              "Output Kgs should not be empty");
                        }
                      } else {
                        errordialog(context, "Information",
                            "Output bags should not be zero");
                        outputBags.clear();
                      }
                    } else {
                      errordialog(context, "information",
                          "Output Bags should not be empty");
                    }
                  } else {
                    errordialog(
                        context, "Information", "Input Kgs should not be zero");
                    inputKgs.clear();
                  }
                } else {
                  errordialog(
                      context, "Information", "Input Kgs should not be empty");
                }
              } else {
                errordialog(
                    context, "Information", "Input Bags should not be zero");
                inputBags.clear();
              }
            } else {
              errordialog(
                  context, "Information", "Input Bags should not be empty");
            }
          } else {
            errordialog(
                context, "Information", "Coffee Grade should not be empty");
          }

          // });
        }));*/

    if (inputDetailList.length > 0) {
      /*input-output detail*/

      listings.add(
          txt_labelsection("Input/Output Details", Colors.green, 18.0, true));

      listings.add(inputListTable());
    }

    listings.add(txt_labelsection(
        TranslateFun.langList['waGrCls'], Colors.green, 18.0, true));

    listings.add(
        txt_label(TranslateFun.langList['prClCls'], Colors.black, 14.0, false));
    listings.add(txtfieldAllowTwoDecimal(
        TranslateFun.langList['prClCls'], preClean, true, 8));

    listings.add(
        txt_label(TranslateFun.langList['stoCls'], Colors.black, 14.0, false));
    listings.add(txtfieldAllowTwoDecimal(
        TranslateFun.langList['stoCls'], stones, true, 8));

    listings.add(
        txt_label(TranslateFun.langList['waGrCls'], Colors.black, 14.0, false));
    listings.add(txtfieldAllowTwoDecimal(
        TranslateFun.langList['waGrCls'], wasteGrade, true, 8));

    listings.add(txt_label("Total Weight", Colors.black, 14.0, false));
    listings.add(txtfieldAllowTwoDecimal("Total Weight", wgnoBags, true, 8));

    listings.add(txt_label("No of Bags", Colors.black, 14.0, false));
    listings.add(cardlable_dynamic(wTotalBags));

    listings.add(txt_labelsection(
        TranslateFun.langList['gRCls'], Colors.green, 18.0, true));

    listings.add(
        txt_label(TranslateFun.langList['re18Cls'], Colors.black, 14.0, false));
    listings.add(txtfieldAllowTwoDecimal(
        TranslateFun.langList['re18Cls'], reject1899, true, 8));

    listings.add(
        txt_label(TranslateFun.langList['re15Cls'], Colors.black, 14.0, false));
    listings.add(txtfieldAllowTwoDecimal(
        TranslateFun.langList['re15Cls'], reject1599, true, 8));

    listings.add(
        txt_label(TranslateFun.langList['re12Cls'], Colors.black, 14.0, false));
    listings.add(txtfieldAllowTwoDecimal(
        TranslateFun.langList['re12Cls'], reject1299, true, 8));

    listings.add(
        txt_label(TranslateFun.langList['re11Cls'], Colors.black, 14.0, false));
    listings.add(txtfieldAllowTwoDecimal(
        TranslateFun.langList['re11Cls'], reject1199, true, 8));

    listings.add(txt_label("Total Weight", Colors.black, 14.0, false));
    listings.add(txtfieldAllowTwoDecimal("Total Weight", grnoBags, true, 8));

    listings.add(txt_label("No of Bags", Colors.black, 14.0, false));
    listings.add(cardlable_dynamic(gTotalBags));

    listings.add(Container(
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Container(
              padding: EdgeInsets.all(3),
              child: MaterialButton(
                child: Text(
                  "Cancel",
                  style: new TextStyle(color: Colors.white, fontSize: 18),
                ),
                onPressed: () {
                  _onBackPressed();
                },
                color: Colors.redAccent,
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              padding: EdgeInsets.all(3),
              child: MaterialButton(
                child: Text(
                  "Submit",
                  style: new TextStyle(color: Colors.white, fontSize: 18),
                ),
                onPressed: () {
                  btnSubmit();
                },
                color: Colors.green,
              ),
            ),
          ),

          //
        ],
      ),
    ));

    return listings;
  }

  // // void destnatTime(BuildContext context) {
  // //   destnatTime(BuildContext context) async {
  // //     final TimeOfDay? timeOfDay = await showTimePicker(
  // //       context: context,
  // //       initialTime: selecteddesTime,
  // //       initialEntryMode: TimePickerEntryMode.dial,
  // //     );
  // //     if (timeOfDay != null && timeOfDay != selecteddesTime) {
  // //       setState(() {
  // //         selecteddesTime = timeOfDay;
  // //       });
  // //     }
  // //   }
  // }

  void btnSubmit() {
    // String sDate = startDate;
    // String eDate = finishDate;
    //
    // DateTime dt1 = DateTime.parse(sDate);
    // DateTime dt2 = DateTime.parse(eDate);

    if (labelDate.isEmpty) {
      errordialog(context, "Information", "Date should not be empty");
    } else if (slct_LotNo.isEmpty) {
      errordialog(context, "Information", "Batch Number should not be empty");
    } /*else if(customer.text.isEmpty){
      errordialog(context, "Information", "Customer should not be empty");
    }*/
    else if (startDate.isEmpty) {
      errordialog(context, "Information", "Date Started should not be empty");
    } else if (slctSTime!.isEmpty) {
      errordialog(context, "Information", "Time Started should not be empty");
    } else if (finishDate.isEmpty) {
      errordialog(context, "Information", "Date Finished should not be empty");
    } else if (!validDate) {
      errordialog(context, "Information",
          "Date Finished Should be Greater than Date Started");
    } else if (slctFTime!.isEmpty) {
      errordialog(context, "Information", "Time Finished should not be empty");
    } else if (slct_sku!.isEmpty) {
      errordialog(context, "Information", "SKU should not be empty");
    } else if (inputDetailList.isEmpty) {
      errordialog(context, "Information", "Add atleast one grade");
    } else {
      confirmation();
    }
  }

  destnatTime(BuildContext context) async {
    final TimeOfDay? timeOfDay = await showTimePicker(
      context: context,
      initialTime: selecteddesTimeStart,
      initialEntryMode: TimePickerEntryMode.dial,
    );
    if (timeOfDay != null && timeOfDay != selecteddesTimeStart) {
      setState(() {
        selecteddesTimeStart = timeOfDay;
      });
    }
  }

  Future<void> displayTimeDialog() async {
    final TimeOfDay? time =
        await showTimePicker(context: context, initialTime: TimeOfDay.now());
    if (time != null) {
      setState(() {
        selectStartTime = time.format(context);
        slctStartTime.text = selectStartTime.toString();
        slctSTime = selectStartTime.toString();
      });
    }
  }

  Future<void> displayTimeEndDialog() async {
    final TimeOfDay? time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
        initialEntryMode: TimePickerEntryMode.dial);
    if (time != null) {
      setState(() {
        selectFinishTime = time.format(context);
        slctEndTime.text = selectFinishTime.toString();
        slctFTime = selectFinishTime.toString();
      });
    }
  }

  destnatTime1(BuildContext context) async {
    final TimeOfDay? timeOfDay = await showTimePicker(
      context: context,
      initialTime: selecteddesTimeFinish,
      initialEntryMode: TimePickerEntryMode.dial,
    );
    if (timeOfDay != null && timeOfDay != selecteddesTimeFinish) {
      setState(() {
        selecteddesTimeFinish = timeOfDay;
      });
    }
  }

  void finalDateComparison(String finalDate) async {
    if (formatStartDate != "" && formatFinalDate != "") {
      String dateValue = formatStartDate;
      String finalDateValue = finalDate;
      String trimmedDate = dateValue.substring(0, 10);

      String startDate = trimmedDate;
      List<String> splitStartDate = startDate.split('/');
      List<String> splitFinalDate = finalDateValue.split('/');

      String strYearq = splitStartDate[0];
      String strMonthq = splitStartDate[1];
      String strDateq = splitStartDate[2];

      int strYear = int.parse(strYearq);
      int strMonths = int.parse(strMonthq);
      int strDate = int.parse(strDateq);

      DateTime convertStartDate = new DateTime(strYear, strMonths, strDate);

      String strYearE = splitFinalDate[0];
      String strMonthE = splitFinalDate[1];
      String strDateE = splitFinalDate[2];

      int strYear1 = int.parse(strYearE);
      int strMonths1 = int.parse(strMonthE);
      int strDate1 = int.parse(strDateE);

      DateTime convertFinalDate = new DateTime(strYear1, strMonths1, strDate1);
      DateTime valEnd = convertStartDate;
      bool valDate = convertFinalDate.isAfter(valEnd);
      bool valDate1 = convertFinalDate.isAtSameMomentAs(valEnd);
      if (valDate) {
        setState(() {
          validDate = true;
        });
      } else if (valDate1) {
        setState(() {
          validDate = true;
        });
      } else {
        setState(() {
          validDate = false;
        });
      }
    }
  }

  Widget inputListTable() {
    List<DataColumn> columns = <DataColumn>[];
    List<DataRow> rows = <DataRow>[];
    columns.add(DataColumn(label: Text('Coffee Grade')));
    columns.add(DataColumn(label: Text('Available Bags')));
    columns.add(DataColumn(label: Text('Available Kgs')));
    columns.add(DataColumn(label: Text('Input Bags')));
    columns.add(DataColumn(label: Text('Input Kgs')));
    columns.add(DataColumn(label: Text('Output Kgs')));
    columns.add(DataColumn(label: Text('Output Bags')));
    columns.add(DataColumn(label: Text('Delete')));

    for (int i = 0; i < inputDetailList.length; i++) {
      List<DataCell> singlecell = <DataCell>[];

      singlecell.add(DataCell(Text(inputDetailList[i].gradeName)));
      singlecell.add(DataCell(Text(inputDetailList[i].availableBags)));
      singlecell.add(DataCell(Text(inputDetailList[i].availableKgs)));
      singlecell.add(DataCell(Text(inputDetailList[i].inputBags)));
      singlecell.add(DataCell(Text(inputDetailList[i].inputKgs)));
      TextEditingController controller = TextEditingController();

      controller.text = inputDetailList[i].outputKgs.toString();
      singlecell.add(DataCell(
          TextFormField(
            controller: controller,
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(9),
            ],
            decoration: const InputDecoration(border: InputBorder.none),
            onFieldSubmitted: (value) {
              if (value == "0") {
                errordialog(
                    context, "Information", "Output kgs should not be zero");
                setState(() {
                  var Value = value;

                  controller.text = Value;
                });
              } else if (value.isEmpty) {
                errordialog(
                    context, "Information", "Output kgs should not be empty.");
                setState(() {
                  var Value = value;

                  controller.text = Value;
                });
              } /* else if (double.parse(value) >
                  double.parse(inputDetailList[i].inputBags)) {
                errordialog(context, "Information",
                    "Output bags should not be greater than Input bags");
                setState(() {
                  var Value = value;

                  controller.text = Value;
                });
              }*/
              else {
                setState(() {
                  inputDetailList[i].outputKgs = value;
                  double oBag = double.parse(inputDetailList[i].outputKgs);
                  double skBag = double.parse(slct_sku);
                  print("skBag:" + skBag.toString());
                  total = oBag / skBag;
                  inputDetailList[i].outputBags = total.ceil().toString();
                  print("distAmt : ${inputDetailList[i].outputKgs}");
                  controller.text = inputDetailList[i].outputKgs.toString();
                });
              }
            },
          ),
          showEditIcon: true));
      /*   TextEditingController controller1 = TextEditingController();

      controller1.text = inputDetailList[i].outputKgs.toString();
      singlecell.add(DataCell(
          TextFormField(
            controller: controller1,
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'(^\d*\.?\d{0,2})')),
              LengthLimitingTextInputFormatter(9),
            ],
            decoration: const InputDecoration(border: InputBorder.none),
            onFieldSubmitted: (value) {
              if (value == "0") {
                errordialog(
                    context, "Information", "Output bags should not be zero");
                setState(() {
                  var Value = value;

                  controller1.text = Value;
                });
              } else if (value.isEmpty) {
                errordialog(
                    context, "Information", "Output bags should not be empty.");
                setState(() {
                  var Value = value;

                  controller1.text = Value;
                });
              } */ /* else if (double.parse(value) >
                  double.parse(inputDetailList[i].inputKgs)) {
                errordialog(context, "Information",
                    "Output Kgs should not be greater than Input Kgs");
                setState(() {
                  var Value = value;

                  controller.text = Value;
                });
              }*/ /*
              else {
                setState(() {
                  inputDetailList[i].outputKgs = value;
                  print("distAmt : ${inputDetailList[i].outputKgs}");
                  controller1.text = inputDetailList[i].outputKgs.toString();
                });
              }
            },
          ),
          showEditIcon: true));*/
      // singlecell.add(DataCell(Text(inputDetailList[i].outputBags)));
      singlecell.add(DataCell(Text(inputDetailList[i].outputBags)));
      singlecell.add(DataCell(InkWell(
        onTap: () {
          setState(() {
            inputDetailList.removeAt(i);
          });
          if (inputDetailList.isEmpty) {
            inputGradeItem.clear();
            slctLotNo = null;
            slct_LotNo = "";
            val_LotNo = "";
            gradeAdded = true;
            batchNumber = "";
          }
        },
        child: Icon(
          Icons.delete_forever,
          color: Colors.red,
        ),
      )));
      rows.add(DataRow(
        cells: singlecell,
      ));
    }
    Widget objWidget = datatable_dynamic(columns: columns, rows: rows);
    return objWidget;
  }

  confirmation() {
    var alertStyle = AlertStyle(
      animationType: AnimationType.grow,
      overlayColor: Colors.black87,
      isCloseButton: true,
      isOverlayTapDismiss: true,
      titleStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
      descStyle: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
      animationDuration: Duration(milliseconds: 400),
    );

    Alert(
        context: context,
        style: alertStyle,
        title: "Confirmation",
        desc: "Are you sure you want to proceed?",
        buttons: [
          DialogButton(
            child: Text(
              "No",
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            //onPressed:btncancel ,
            onPressed: () {
              setState(() {
                Navigator.pop(context);
              });
            },
            color: Colors.deepOrange,
          ),
          DialogButton(
            child: Text(
              "Yes",
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            //onPressed:btnok,
            onPressed: () {
              saveCoffeePurchase();
              Navigator.pop(context);
            },
            color: Colors.green,
          )
        ]).show();
  }

  void saveCoffeePurchase() async {
    Random rnd = new Random();
    int recNo = 100000 + rnd.nextInt(999999 - 100000);
    //String revNo = "CTB"+recNo.toString();
    String revNo = recNo.toString();

    final now = new DateTime.now();
    String txntime = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
    String msgNo = DateFormat('yyyyMMddHHmmss').format(now);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? agentid = prefs.getString("agentId");
    String? agentToken = prefs.getString("agentToken");
    print('txnHeader ' + agentid! + "" + agentToken!);
    String insqry =
        'INSERT INTO "main"."txnHeader" ("isPrinted", "txnTime", "mode", "operType", "resentCount", "agentId", "agentToken", "msgNo", "servPointId", "txnRefId") VALUES ('
                '0,\'' +
            txntime +
            '\', '
                '\'02\', '
                '\'01\', '
                '\'0\',\'' +
            agentid +
            '\', \'' +
            agentToken +
            '\',\'' +
            msgNo +
            '\', \'' +
            servicePointId +
            '\',\'' +
            revNo +
            '\')';
    print('txnHeader ' + insqry);
    int succ = await db.RawInsert(insqry);
    print(succ);
    Future<List<Map>> txnHeader = db.GetTableValues('txnHeader');

    //CustTransaction
    AppDatas datas = new AppDatas();
    int custTransaction = await db.saveCustTransaction(
        txntime, datas.txnPrimaryProcessing, revNo, '', '', '');
    print('custTransaction : ' + custTransaction.toString());
    print('dryer inserting');

    String isSynched = "0";
    String latitude = Latitude;
    String longitude = Longitude;
    String recNo1 = revNo;
    print("FinishedTimeVal:" + finishedTime);

    int primaryProcessing = await db.primaryProcessing(
        recNo: recNo1,
        latitude: latitude,
        longitude: longitude,
        isSynched: isSynched,
        date: labelDate,
        batchNo: val_LotNo,
        customer: customer.text,
        dateStarted: startDate,
        timeStarted: selectStartTime
            .toString(), //selecteddesTimeStart.hour.toString()+":"+selecteddesTimeStart.minute.toString()
        dateFinished: finishDate,
        timeFinished: selectFinishTime
            .toString(), //selecteddesTimeFinish.hour.toString()+":"+selecteddesTimeFinish.minute.toString()
        preClean: preClean.text,
        stones: stones.text,
        wasteGrade: wasteGrade.text,
        totalWBags: wTotalBags,
        reject1899: reject1899.text,
        reject1599: reject1599.text,
        reject1299: reject1299.text,
        reject1199: reject1199.text,
        totalGBags: gTotalBags,
        processType: "3",
        seasonCode: seasoncode,
        skuType: val_sku,
        wnoBag: wgnoBags.text,
        gnoBag: grnoBags.text);

    for (int i = 0; i < inputDetailList.length; i++) {
      int primaryProcessingList = await db.primaryProcessingDetail(
          grade: inputDetailList[i].gradeCode,
          avlBags: inputDetailList[i].availableBags,
          avlKgs: inputDetailList[i].availableKgs,
          inputBags: inputDetailList[i].inputBags,
          inputKgs: inputDetailList[i].inputKgs,
          inputTotal: inputTotal,
          outputBags: inputDetailList[i].outputBags,
          outputKgs: inputDetailList[i].outputKgs,
          outputTotal: outputTotal,
          recNo: recNo1,
          outputTotalKg: inputDetailList[i].outputKgs,
          outputTotalBag: inputDetailList[i].outputBags,
          processBatchNo: val_LotNo,
          exporterId: '',
          exporterName: '',
          processType: '3');
    }

    int issync = await db.UpdateTableValue(
        'primaryProcessing', 'isSynched', '0', 'recNo', revNo);

    Alert(
      context: context,
      type: AlertType.info,
      title: "Transaction",
      desc: "Primary Processing Successful",
      buttons: [
        DialogButton(
          child: Text(
            "OK",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () {
            Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (BuildContext context) => DashBoard("", "")));
          },
          width: 120,
        ),
      ],
    ).show();
  }

  Widget buildTimePicker() => SizedBox(
        height: 180,
        child: CupertinoDatePicker(
          initialDateTime: dateTime,
          mode: CupertinoDatePickerMode.time,
          minuteInterval: 10,
          //use24hFormat: true,
          onDateTimeChanged: (dateTime) =>
              setState(() => this.dateTime = dateTime),
        ),
      );

  DateTime getDateTime() {
    final now = DateTime.now();

    return DateTime(now.year, now.month, now.day, now.hour, 0);
  }
}

class InputDetail {
  String gradeName,
      gradeCode,
      availableBags,
      availableKgs,
      inputBags,
      inputKgs,
      outputBags,
      outputKgs;

  InputDetail(
      {required this.gradeName,
      required this.gradeCode,
      required this.availableBags,
      required this.availableKgs,
      required this.inputBags,
      required this.inputKgs,
      required this.outputBags,
      required this.outputKgs});
}
