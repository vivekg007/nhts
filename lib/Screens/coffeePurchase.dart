import 'dart:math';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Database/Databasehelper.dart';
import '../Model/UIModel.dart';
import '../Model/dynamicfields.dart';
import '../Utils/MandatoryDatas.dart';
import '../commonlang/translateLang.dart';

class CoffeePurchase extends StatefulWidget {
  const CoffeePurchase({Key? key}) : super(key: key);

  @override
  State<CoffeePurchase> createState() => _CoffeePurchaseState();
}

class _CoffeePurchaseState extends State<CoffeePurchase> {
  var db = DatabaseHelper();
  List<Map> agents = [];
  String seasoncode = '';
  String servicePointId = '';
  String agendId = '';
  String Latitude = '', Longitude = '';

  //Purchase Date
  String labelPurhaseDate = "";
  String purchaseDate = "";

  // Season
  List<DropdownModel> seasonItems = [];
  DropdownModel? slctSeason;
  String slct_Season = "";
  String val_Season = "";

  // Buying Center
  List<DropdownModel> buyingCenterItems = [];
  DropdownModel? slctBuyingCenter;
  String slct_BuyingCenter = "";
  String val_BuyingCenter = "";

  // Farmer Name
  List<DropdownModel> farmerItems = [];
  DropdownModel? slctFarmer;
  String slct_Farmer = "";
  String val_Farmer = "";

  // Farm Name
  List<DropdownModel> farmItems = [];
  DropdownModel? slctFarm;
  String slct_Farm = "";
  String val_Farm = "";

  //Coffee Type
  List<DropdownModel> coffeeTypeItems = [];
  DropdownModel? slctCoffeeType;
  String slct_CoffeeType = "";
  String val_CoffeeType = "";

  //Coffee Variety
  List<DropdownModel> coffeeVarietyItems = [];
  DropdownModel? slctCoffeeVariety;
  String slct_CoffeeVariety = "";
  String val_CoffeeVariety = "";

  //Coffee Grade
  List<DropdownModel> coffeeGradeItems = [];
  DropdownModel? slctCoffeeGrade;
  String slct_CoffeeGrade = "";
  String val_CoffeeGrade = "";

  String batchNo = "";
  String farmerCode = "";
  String totalAmount = "";
  TextEditingController quantity = new TextEditingController();
  TextEditingController priceKilogram = new TextEditingController();
  TextEditingController amountPaid = new TextEditingController();
  TextEditingController noOfBags = new TextEditingController();
  TextEditingController skuController = new TextEditingController();
  TextEditingController premium = new TextEditingController();

  bool varietyLoaded = false;
  String recpnumbr = "";
  String revNo = "";

  /*22/3/2023 feedback changes*/
  List<DropdownModel> skuItems = [];
  DropdownModel? slctSku;
  String slct_sku = "";
  String val_sku = "";

  @override
  void initState() {
    super.initState();

    initvalues();
    getClientData();

    getLocation();

    Random rnd = new Random();
    int recNo = 100000 + rnd.nextInt(999999 - 100000);
    //String revNo = "CTB"+recNo.toString();
    revNo = recNo.toString();
    recpnumbr = revNo;

    premium.addListener(() {
      if (premium.text.isNotEmpty &&
          priceKilogram.text.isNotEmpty &&
          quantity.text.isNotEmpty) {
        setState(() {
          double tot = double.parse(priceKilogram.text) *
              double.parse(quantity.text) *
              double.parse(premium.text);
          totalAmount = tot.toStringAsFixed(2).toString();
          amountPaid.clear();
        });
        amountPaid.clear();
      } else {
        setState(() {
          totalAmount = "";
        });
      }
    });

    priceKilogram.addListener(() {
      if (premium.text.isNotEmpty &&
          priceKilogram.text.isNotEmpty &&
          quantity.text.isNotEmpty) {
        setState(() {
          double tot = double.parse(priceKilogram.text) *
              double.parse(quantity.text) *
              double.parse(premium.text);
          totalAmount = tot.toStringAsFixed(2).toString();
          amountPaid.clear();
        });
        amountPaid.clear();
      } else {
        setState(() {
          totalAmount = "";
        });
      }
    });

    quantity.addListener(() {
      if (quantity.text.isNotEmpty &&
          priceKilogram.text.isNotEmpty &&
          premium.text.isNotEmpty) {
        setState(() {
          double tot = double.parse(priceKilogram.text) *
              double.parse(quantity.text) *
              double.parse(premium.text);
          totalAmount = tot.toStringAsFixed(2).toString();
          amountPaid.clear();
        });
        amountPaid.clear();
      } else if (quantity.text == "0") {
        errordialog(context, "information", "Quantity should not be zero");
        quantity.clear();
      } else {
        setState(() {
          totalAmount = "";
        });
      }
    });

    amountPaid.addListener(() {
      if (amountPaid.text.isNotEmpty && totalAmount.isNotEmpty) {
        if (double.parse(amountPaid.text) > double.parse(totalAmount)) {
          errordialog(context, TranslateFun.langList['infoCls'],
              TranslateFun.langList['ampatothfashbelethoreqtotoamCls']);
          amountPaid.clear();
        }
      }
    });

    skuController.addListener(() {
      if (skuController.text.isNotEmpty && quantity.text.isNotEmpty) {
        setState(() {
          double nBag = double.parse(quantity.text);
          double sBag = double.parse(skuController.text);
          double tBag = nBag / sBag;
          noOfBags.text = tBag.ceil().toString();
        });
      }
    });

    quantity.addListener(() {
      if (quantity.text == "0") {
        errordialog(context, "information", "Quantity should not be zero");
        quantity.clear();
      } else if (quantity.text.isNotEmpty) {
        setState(() {
          double nBag = double.parse(quantity.text);
          double sBag = double.parse(skuController.text);
          double tBag = nBag / sBag;
          noOfBags.text = tBag.ceil().toString();
        });
      } else {
        setState(() {
          noOfBags.text = "";
        });
      }
    });

    quantity.addListener(() {
      decimalanddigitval(quantity.text, quantity, 7);
    });

    priceKilogram.addListener(() {
      decimalanddigitval(priceKilogram.text, priceKilogram, 7);
    });

    amountPaid.addListener(() {
      decimalanddigitval(amountPaid.text, amountPaid, 7);
    });
  }

  decimalanddigitval(controllerval, controller, length) {
    try {
      String controllervalue = controllerval;
      if (controllervalue.length > length) {
        if (controllervalue.contains(".")) {
          List<String> values = controllervalue.split(".");
          print("controllervalue1" + controllervalue.substring(0, 2).trim());
          if (values[0].length > length) {
            Alert(
              context: context,
              type: AlertType.info,
              title: TranslateFun.langList['confmCls'],
              desc: TranslateFun.langList['numucoondibedeCls'],
              buttons: [
                DialogButton(
                  child: Text(
                    TranslateFun.langList['okCls'],
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    controller.clear();
                  },
                  width: 120,
                ),
              ],
            ).show();
            // toast('Number must be two numbers');
          }
        } else {
          Alert(
            context: context,
            type: AlertType.info,
            title: TranslateFun.langList['confmCls'],
            desc: TranslateFun.langList['numucoondibedeCls'],
            buttons: [
              DialogButton(
                child: Text(
                  TranslateFun.langList['okCls'],
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                onPressed: () {
                  Navigator.pop(context);
                  controller.clear();
                },
                width: 120,
              ),
            ],
          ).show();
          // toast('Invalid Format');
        }
      }
    } catch (e) {}
  }

  Future<void> initvalues() async {
    List seasonList = await db.RawQuery('select * from seasonYear');
    print(' shadeTreeList' + seasonList.toString());

    seasonItems.clear();
    for (int i = 0; i < seasonList.length; i++) {
      String typurchseName = seasonList[i]["seasonName"].toString();
      String typurchseCode = seasonList[i]["seasonId"].toString();
      var uimodel = new UImodel(typurchseName, typurchseCode);

      setState(() {
        seasonItems.add(DropdownModel(
          typurchseName,
          typurchseCode,
        ));
      });
    }

    List buyingCenterList = await db.RawQuery(
        'select a.procBatchNo,c.coName from agentMaster a, coOperative c where a.procBatchNo=c.coCode');
    print(' buyingCenterList' + buyingCenterList.toString());

    buyingCenterItems.clear();
    for (int i = 0; i < buyingCenterList.length; i++) {
      String typurchseName = buyingCenterList[i]["coName"].toString();
      String typurchseCode = buyingCenterList[i]["procBatchNo"].toString();

      var uimodel = new UImodel(typurchseName, typurchseCode);

      setState(() {
        buyingCenterItems.add(DropdownModel(
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

  /*getCoffeeGrade(String cropType) async {
    List coffeeGList = await db.RawQuery(
        'select inspName from farm where insType = \'' + cropType + '\'');
    print(' coffeeGList' + coffeeGList.toString());
    List cGList = [];
    List cGQList = [];
    String cG = coffeeGList[0]['inspName'].toString();
    List<String> cGValueList = cG.split(',').toList();

    for (int c = 0; c < cGValueList.length; c++) {
      String CoffGr = cGValueList[c].toString();
      print("CoffGr:" + CoffGr);
      cGQList.add("'$CoffGr'");
      cGList.add(CoffGr);
    }
    String cGG = cGList.join(',');
    String cGQ = cGQList.join(',');
    print("CGQ:" + cGQ);

    List coffeeGradeList = await db.RawQuery(
        'select * from procurementGrade where gradeCode IN ($cGQ)');
    print(' coffeeGradeList' + coffeeGradeList.toString());

    coffeeGradeItems.clear();
    for (int i = 0; i < coffeeGradeList.length; i++) {
      String typurchseName = coffeeGradeList[i]["grade"].toString();
      String typurchseCode = coffeeGradeList[i]["gradeCode"].toString();
      var uimodel = new UImodel(typurchseName, typurchseCode);

      setState(() {
        coffeeGradeItems.add(DropdownModel(
          typurchseName,
          typurchseCode,
        ));
      });
    }
  }*/

  getCoffeeGrade(String cropType) async {
    coffeeGradeItems.clear();
    List coffeeGList = await db.RawQuery(
        'select distinct fCrpCode,yield,idPoll from cropYieldList where idPoll = \'' +
            cropType +
            '\'');
    print(' coffeeGList' + coffeeGList.toString());

    for (int c = 0; c < coffeeGList.length; c++) {
      String typurchseName = coffeeGList[c]["yield"].toString();
      String typurchseCode = coffeeGList[c]["fCrpCode"].toString();
      var uimodel = new UImodel(typurchseName, typurchseCode);

      setState(() {
        coffeeGradeItems.add(DropdownModel(
          typurchseName,
          typurchseCode,
        ));
      });
    }
  }

  getCoffeeType(String farmId) async {
    List coffeeTypeList = await db.RawQuery(
        'select insType from farm where farmIDT = \'' + farmId + '\'');
    print(' coffeeTypeList' + coffeeTypeList.toString());

    coffeeTypeItems.clear();
    for (int i = 0; i < coffeeTypeList.length; i++) {
      String typurchseCode = coffeeTypeList[i]["insType"].toString();
      List coffeeTypeListValue = await db.RawQuery(
          'select vName from varietyList where vCode = \'' +
              typurchseCode +
              '\'');
      String typurchseName = coffeeTypeListValue[0]["vName"].toString();

      var uimodel = new UImodel(typurchseName, typurchseCode);

      setState(() {
        coffeeTypeItems.add(DropdownModel(
          typurchseName,
          typurchseCode,
        ));
      });
    }
  }

  /*getCoffeeVariety(String coffeeType) async {
    print("coffeevariety:" + coffeeType);
    List coffeeVarietyList = await db.RawQuery(
        'select distinct inspName from farm where insType = \'' +
            coffeeType +
            '\'');
    print(' coffeeTypeList' + coffeeVarietyList.toString());

    coffeeVarietyItems.clear();
    for (int i = 0; i < coffeeVarietyList.length; i++) {
      String typurchseCode = coffeeVarietyList[i]["inspName"].toString();
      print("coffeevarietyCode:" + typurchseCode);
      List coffeeVarietyListValue = await db.RawQuery(
          'select grade from procurementGrade where gradeCode = \'' +
              typurchseCode +
              '\'');
      String typurchseName = coffeeVarietyListValue[0]["grade"].toString();
      print("coffeevarietyName:" + typurchseName);

      var uimodel = new UImodel(typurchseName, typurchseCode);

      setState(() {
        coffeeVarietyItems.add(DropdownModel(
          typurchseName,
          typurchseCode,
        ));
      });
    }

    if (coffeeVarietyItems.isNotEmpty) {
      setState(() {
        varietyLoaded = true;
      });
    }
  }*/

  getFarmer(String buyingCenter) async {
    String qry_farmerlist =
        'select fName,lName,farmerId,farmerCode from farmer_master where phoneNo LIKE "%$buyingCenter%" and blockId = "0"';

    List farmerslist = await db.RawQuery(qry_farmerlist);
    print('qry_farmerlist:  ' + qry_farmerlist.toString());

    farmerItems = [];
    farmerItems.clear();

    if (farmerslist.length > 0) {
      for (int i = 0; i < farmerslist.length; i++) {
        String fName = farmerslist[i]["fName"].toString() +
            " " +
            farmerslist[i]["lName"].toString();
        String farmerId = farmerslist[i]["farmerId"].toString();
        String address = farmerslist[i]["address"].toString();
        var uimodel = new UImodel2(fName, farmerId, address, "", "", "");
        setState(() {
          farmerItems.add(DropdownModel(
            fName,
            farmerId,
          ));
        });
      }
    }

    Future.delayed(Duration(milliseconds: 500), () {
      setState(() {
        if (farmerItems.length > 0) {
          slct_Farmer = '';
        }
      });
    });
  }

  getFarmerCode(String farmerId) async {
    List farmerCodeList = await db.RawQuery(
        'select farmerCode from farmer_master where farmerId = \'' +
            farmerId +
            '\'');
    print(' shadeTreeList' + farmerCodeList.toString());

    for (int i = 0; i < farmerCodeList.length; i++) {
      String fCode = farmerCodeList[i]["farmerCode"].toString();
      var uimodel = new UImodel(fCode, "");

      setState(() {
        farmerCode = fCode;
      });
    }
  }

  getFarmDetail(String farmerId) async {
    List farmList = await db.RawQuery(
        'select farmName,farmIDT from farm where farmerId = \'' +
            farmerId +
            '\' and verifyStatus = "0" ');
    print(' shadeTreeList' + farmList.toString());

    farmItems.clear();
    for (int i = 0; i < farmList.length; i++) {
      String typurchseName = farmList[i]["farmName"].toString();
      String typurchseCode = farmList[i]["farmIDT"].toString();
      var uimodel = new UImodel(typurchseName, typurchseCode);

      setState(() {
        farmItems.add(DropdownModel(
          typurchseName,
          typurchseCode,
        ));
      });
    }
  }

  // varietySearch(String type) async {
  //   List varietiesList = await db.RawQuery(
  //       'select grade,gradeCode from procurementGrade where vCode = \'' +
  //           type +
  //           '\'');
  //   print(' varietiesList' + varietiesList.toString());
  //
  //   coffeeVarietyItems.clear();
  //   for (int i = 0; i < varietiesList.length; i++) {
  //     String typurchseName = varietiesList[i]["grade"].toString();
  //     String typurchseCode = varietiesList[i]["gradeCode"].toString();
  //     var uimodel = new UImodel(typurchseName, typurchseCode);
  //
  //     setState(() {
  //       coffeeVarietyItems.add(DropdownModel(
  //         typurchseName,
  //         typurchseCode,
  //       ));
  //     });
  //   }
  //
  //   Future.delayed(Duration(milliseconds: 500), () {
  //     print("varietyFunction");
  //     setState(() {
  //       if (varietiesList.isNotEmpty) {
  //         slct_CoffeeVariety = "";
  //         varietyLoaded = true;
  //       } else {
  //         varietyLoaded = false;
  //       }
  //     });
  //   });
  // }

  getClientData() async {
    agents = await db.RawQuery('SELECT * FROM agentMaster');

    seasoncode = agents[0]['currentSeasonCode'];
    servicePointId = agents[0]['servicePointId'];
    agendId = agents[0]['agentId'];
    // String resIdd = agents[0]['resIdSeqF'];
    // print("resIdgetcliendata" + resIdd);
    // print("agendId_agendId" + agendId);
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
          title: TranslateFun.langList['cnclCls'],
          desc: TranslateFun.langList['ruWanCanclCls'],
          buttons: [
            DialogButton(
              child: Text(
                TranslateFun.langList['yESCls'],
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
                TranslateFun.langList['nOCls'],
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
              TranslateFun.langList['coPuCls'],
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
        TranslateFun.langList['puDaCls'], Colors.black, 14.0, false));
    listings.add(selectDate(
      context1: context,
      slctdate: labelPurhaseDate,
      onConfirm: (date) => setState(() {
        //HH:mm:ss
        purchaseDate = DateFormat('dd-MM-yyyy').format(date!);
        labelPurhaseDate = DateFormat('dd-MM-yyyy').format(date);
        //print('CHECKJOIINGDFATE:2 '+icsjoiningDate);
      }),
    ));

    listings.add(txt_label_mandatory(
        TranslateFun.langList['seaCls'], Colors.black, 14.0, false));
    listings.add(DropDownWithModel(
      itemlist: seasonItems,
      selecteditem: slctSeason,
      hint: TranslateFun.langList['seSessCls'],
      onChanged: (value) {
        setState(() {
          slctSeason = value!;
          val_Season = slctSeason!.value;
          slct_Season = slctSeason!.name;
          print("name of the val_Season:" + val_Season);
        });
      },
    ));

    // listings.add(txt_label_mandatory(
    //     TranslateFun.langList['banuCls'], Colors.black, 14.0, false));
    //
    // listings.add(cardlable_dynamic(batchNo.toString()));

    listings.add(txt_label_mandatory(
        TranslateFun.langList['buceCls'], Colors.black, 14.0, false));
    listings.add(DropDownWithModel(
      itemlist: buyingCenterItems,
      selecteditem: slctBuyingCenter,
      hint: TranslateFun.langList['seBuceCls'],
      onChanged: (value) {
        setState(() {
          slctBuyingCenter = value!;
          val_BuyingCenter = slctBuyingCenter!.value;
          slct_BuyingCenter = slctBuyingCenter!.name;
          slctFarmer = null;
          val_Farmer = "";
          slct_Farmer = "";
          slctFarm = null;
          val_Farm = "";
          slct_Farm = "";
          farmerCode = "";
          slctCoffeeType = null;
          slct_CoffeeType = "";
          val_CoffeeType = "";
          slctCoffeeVariety = null;
          slct_CoffeeVariety = "";
          val_CoffeeVariety = "";
          slctCoffeeGrade = null;
          slct_CoffeeGrade = "";
          val_CoffeeGrade = "";
          getFarmer(val_BuyingCenter);
          print("name of the val_BuyingCenter:" + val_BuyingCenter);
        });
      },
    ));

    listings.add(txt_label_mandatory(
        TranslateFun.langList['frmrCls'], Colors.black, 14.0, false));
    listings.add(DropDownWithModel(
      itemlist: farmerItems,
      selecteditem: slctFarmer,
      hint: TranslateFun.langList['selFaCls'],
      onChanged: (value) {
        setState(() {
          slctFarmer = value!;
          val_Farmer = slctFarmer!.value;
          slct_Farmer = slctFarmer!.name;
          getFarmerCode(val_Farmer);
          getFarmDetail(val_Farmer);
          slctFarm = null;
          slct_Farm = "";
          val_Farm = "";
          slctCoffeeType = null;
          slct_CoffeeType = "";
          val_CoffeeType = "";
          slctCoffeeVariety = null;
          slct_CoffeeVariety = "";
          val_CoffeeVariety = "";
          slctCoffeeGrade = null;
          slct_CoffeeGrade = "";
          val_CoffeeGrade = "";
          print("name of the val_Farmer:" + val_Farmer);
        });
      },
    ));

    listings.add(txt_label_mandatory(
        TranslateFun.langList['faCoCls'], Colors.black, 14.0, false));

    listings.add(cardlable_dynamic(farmerCode.toString()));

    listings.add(txt_label_mandatory(
        TranslateFun.langList['faNaCls'], Colors.black, 14.0, false));
    listings.add(DropDownWithModel(
      itemlist: farmItems,
      selecteditem: slctFarm,
      hint: TranslateFun.langList['seFaNaCls'],
      onChanged: (value) {
        setState(() {
          slctFarm = value!;
          val_Farm = slctFarm!.value;
          slct_Farm = slctFarm!.name;
          getCoffeeType(val_Farm);
          slctCoffeeType = null;
          slct_CoffeeType = "";
          val_CoffeeType = "";
          slctCoffeeVariety = null;
          slct_CoffeeVariety = "";
          val_CoffeeVariety = "";
          slctCoffeeGrade = null;
          slct_CoffeeGrade = "";
          val_CoffeeGrade = "";
          coffeeGradeItems.clear();
          print("name of the val_Farm:" + val_Farm);
        });
      },
    ));

    listings.add(txt_label_mandatory(
        TranslateFun.langList['coTyCls'], Colors.black, 14.0, false));
    listings.add(DropDownWithModel(
      itemlist: coffeeTypeItems,
      selecteditem: slctCoffeeType,
      hint: TranslateFun.langList['seCoTyCls'],
      onChanged: (value) {
        setState(() {
          slctCoffeeType = value!;
          val_CoffeeType = slctCoffeeType!.value;
          slct_CoffeeType = slctCoffeeType!.name;
          slctCoffeeVariety = null;
          slct_CoffeeVariety = "";
          val_CoffeeVariety = "";
          //getCoffeeVariety(val_CoffeeType);
          getCoffeeGrade(val_CoffeeType);
          //varietySearch(val_CoffeeType);
          print("name of the val_CoffeeType:" + val_CoffeeType);
        });
      },
    ));

    // listings.add(varietyLoaded
    //     ? txt_label_mandatory(
    //         TranslateFun.langList['coVaCls'], Colors.black, 14.0, false)
    //     : Container());
    // listings.add(varietyLoaded
    //     ? DropDownWithModel(
    //         itemlist: coffeeVarietyItems,
    //         selecteditem: slctCoffeeVariety,
    //         hint: TranslateFun.langList['seCoVaCls'],
    //         onChanged: (value) {
    //           setState(() {
    //             slctCoffeeVariety = value!;
    //             val_CoffeeVariety = slctCoffeeVariety!.value;
    //             slct_CoffeeVariety = slctCoffeeVariety!.name;
    //
    //             print("name of the val_CoffeeVariety:" + val_CoffeeVariety);
    //           });
    //         },
    //       )
    //     : Container());

    listings.add(txt_label_mandatory(
        TranslateFun.langList['coGrCls'], Colors.black, 14.0, false));
    listings.add(DropDownWithModel(
      itemlist: coffeeGradeItems,
      selecteditem: slctCoffeeGrade,
      hint: TranslateFun.langList['seCoGrCls'],
      onChanged: (value) {
        setState(() {
          slctCoffeeGrade = value!;
          val_CoffeeGrade = slctCoffeeGrade!.value;
          slct_CoffeeGrade = slctCoffeeGrade!.name;
          print("name of the val_CoffeeGrade:" + val_CoffeeGrade);
        });
      },
    ));

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

    listings.add(txt_label_mandatory(
        TranslateFun.langList['quaCls'], Colors.black, 14.0, false));

    listings.add(txtfieldAllowTwoDecimal(
        TranslateFun.langList['quaCls'], quantity, true, 11));

    listings.add(txt_label_mandatory(
        TranslateFun.langList['noofBaCls'], Colors.black, 14.0, false));

    listings.add(txtfield_digitswithoutdecimal(
        TranslateFun.langList['noofBaCls'], noOfBags, false));

    listings.add(txt_label_mandatory(
        TranslateFun.langList['prCls'], Colors.black, 14.0, false));

    listings.add(txtfieldAllowTwoDecimal(
        TranslateFun.langList['prCls'], priceKilogram, true, 11));

    listings.add(txt_label_mandatory("Premium/Kg", Colors.black, 14.0, false));

    listings.add(txtfieldAllowTwoDecimal("Premium/Kg", premium, true, 11));

    listings.add(txt_label_mandatory(
        TranslateFun.langList['toAmCls'], Colors.black, 14.0, false));

    listings.add(cardlable_dynamic(totalAmount.toString()));

    listings.add(txt_label_mandatory(
        TranslateFun.langList['ampatothfaCls'], Colors.black, 14.0, false));

    listings.add(txtfieldAllowTwoDecimal(
        TranslateFun.langList['ampatothfaCls'], amountPaid, true, 11));

    listings.add(
        txt_label("Coffee Purchase Receipt Number", Colors.black, 14.0, false));
    listings.add(cardlable_dynamic(recpnumbr.toString()));

    listings.add(Container(
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Container(
              padding: EdgeInsets.all(3),
              child: RaisedButton(
                child: Text(
                  TranslateFun.langList['cnclCls'],
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
              child: RaisedButton(
                child: Text(
                  TranslateFun.langList['subCls'],
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
    if (purchaseDate.isEmpty && purchaseDate.length == 0) {
      errordialog(context, TranslateFun.langList['infoCls'],
          TranslateFun.langList['puDashnobeemCls']);
    } else if (slct_Season.isEmpty && slct_Season.length == 0) {
      errordialog(context, TranslateFun.langList['infoCls'],
          TranslateFun.langList['seasonshnoCls']);
    } else if (slct_BuyingCenter.isEmpty && slct_BuyingCenter.length == 0) {
      errordialog(context, TranslateFun.langList['infoCls'],
          TranslateFun.langList['buceshnobeemCls']);
    } else if (slct_Farmer.isEmpty && slct_Farmer.length == 0) {
      errordialog(context, TranslateFun.langList['infoCls'],
          TranslateFun.langList['valFrmrCls']);
    } else if (farmerCode.isEmpty && farmerCode.length == 0) {
      errordialog(context, TranslateFun.langList['infoCls'],
          TranslateFun.langList['facoshnobeemCls']);
    } else if (slct_Farm.isEmpty && slct_Farm.length == 0) {
      errordialog(context, TranslateFun.langList['infoCls'],
          TranslateFun.langList['fanashnobeemCls']);
    } else if (slct_CoffeeType.isEmpty && slct_CoffeeType.length == 0) {
      errordialog(context, TranslateFun.langList['infoCls'],
          TranslateFun.langList['cotyshnobeemCls']);
    } /*else if (slct_CoffeeVariety.isEmpty && slct_CoffeeVariety.length == 0) {
      errordialog(context, TranslateFun.langList['infoCls'],
          TranslateFun.langList['covashnobeemCls']);
    } */
    else if (slct_CoffeeGrade.isEmpty && slct_CoffeeGrade.length == 0) {
      errordialog(context, TranslateFun.langList['infoCls'],
          TranslateFun.langList['cogrshnobeemCls']);
    } else if (slct_sku.isEmpty && slct_sku.length == 0) {
      errordialog(
          context, TranslateFun.langList['infoCls'], "SKU should not be empty");
    } else if (noOfBags.text.isEmpty && noOfBags.text.length == 0) {
      errordialog(context, TranslateFun.langList['infoCls'],
          TranslateFun.langList['noofBashnobeemCls']);
    } else if (quantity.text.isEmpty && quantity.text.length == 0) {
      errordialog(context, TranslateFun.langList['infoCls'],
          TranslateFun.langList['qushnobeemCls']);
    } else if (priceKilogram.text.isEmpty && priceKilogram.text.length == 0) {
      errordialog(context, TranslateFun.langList['infoCls'],
          TranslateFun.langList['prshnobeemCls']);
    } else if (premium.text.isEmpty && premium.text.length == 0) {
      errordialog(context, TranslateFun.langList['infoCls'],
          "Premium/Kg should not be empty");
    } else if (totalAmount.isEmpty && totalAmount.length == 0) {
      errordialog(context, TranslateFun.langList['infoCls'],
          TranslateFun.langList['toamshnobeemCls']);
    } else if (amountPaid.text.isEmpty && amountPaid.text.length == 0) {
      errordialog(context, TranslateFun.langList['infoCls'],
          TranslateFun.langList['ampatothfashnobeemCls']);
    } else {
      confirmation();
    }
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
        title: TranslateFun.langList['confmCls'],
        desc: TranslateFun.langList['proceedCls'],
        buttons: [
          DialogButton(
            child: Text(
              TranslateFun.langList['noCls'],
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
              TranslateFun.langList['yesCls'],
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
        txntime, datas.coffeePurchase, revNo, '', '', '');
    print('custTransaction : ' + custTransaction.toString());
    print('dryer inserting');

    String isSynched = "0";
    String latitude = Latitude;
    String longitude = Longitude;
    String recNo1 = revNo;

    int coffeePurchaseData = await db.SaveCoffeePurchase(
        purDate: purchaseDate,
        season: val_Season,
        batchNo: recNo1,
        buyingCenter: val_BuyingCenter,
        farmerName: slct_Farmer,
        farmerId: val_Farmer,
        farmerCode: farmerCode,
        farmName: slct_Farm,
        farmId: val_Farm,
        coffeeType: val_CoffeeType,
        coffeeVariety: val_sku,
        coffeeGrade: val_CoffeeGrade,
        noofBags: noOfBags.text,
        quantity: quantity.text,
        priceKilogram: priceKilogram.text,
        totAmt: totalAmount,
        amtPaid: amountPaid.text,
        latitude: latitude,
        longitude: longitude,
        recNo: recNo1,
        isSynched: isSynched,
        premium: premium.text);

    print("coffee purchase data:" + coffeePurchaseData.toString());

    int issync = await db.UpdateTableValue(
        'coffeePurchase', 'isSynched', '0', 'recNo', revNo);

    Alert(
      context: context,
      type: AlertType.info,
      title: TranslateFun.langList['traCls'],
      desc: TranslateFun.langList['coPuSuCls'],
      buttons: [
        DialogButton(
          child: Text(
            TranslateFun.langList['okCls'],
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () {
            Navigator.pop(context);
            Navigator.pop(context);
          },
          width: 120,
        ),
      ],
    ).show();
  }
}
