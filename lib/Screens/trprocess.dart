import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Database/Databasehelper.dart';
import '../Model/UIModel.dart';
import '../Model/dynamicfields.dart';
import '../Plugins/TxnExecutor.dart';
import '../Utils/MandatoryDatas.dart';
import '../commonlang/translateLang.dart';
import '../main.dart';

class Transferprocess extends StatefulWidget {
  const Transferprocess({Key? key}) : super(key: key);

  @override
  State<Transferprocess> createState() => _TransferprocessState();
}

class _TransferprocessState extends State<Transferprocess> {
  String seasoncode = '0';
  String agentCode = '0';
  List<Map> agents = [];
  String servicePointId = '0';
  String Lat = '', Lng = '';
  var db = DatabaseHelper();
  String delete = 'Delete';

  String farmerName = '',
      farmerocde = '',
      coffetype = '',
      coffevarity = '',
      coffeegrade = '',
      exisisstock = '',
      farmcde = '',
      avilstock = '',
      recpnumbr = '';

  TextEditingController vehiclenumberController = new TextEditingController();
  TextEditingController drivernameController = new TextEditingController();
  TextEditingController numofbagsController = new TextEditingController();
  TextEditingController totalwghtController = new TextEditingController();

  String slctsendernme = '', slctsenderId = '';
  String senderData = "";
  String slctrecivernme = '', slctreciverId = '';
  String slctbatchnumbr = '', slctbatchnumbrId = '';

  String datetransfer = "";
  String transferFormatedDate = "";

  List<DropdownModel> senderitems = [];
  DropdownModel? slctsender;

  List<DropdownModel> reciveritems = [];
  DropdownModel? slctreciver;

  List<DropdownModel> batchnumbritems = [];
  DropdownModel? slctbatchnumber;

  List<UImodel> senderUIModel = [];
  List<UImodel> reciverUIModel = [];
  List<UImodel> batchnumberUIModel = [];

  List<TransferprocssList> TrnsferprocssList = [];

  String noofBagss = "";
  String weightKg = "";
  int revNo = 0;

  String coGrade = "";
  String coType = "";
  String coVariety = "";
  String Tseason = "";

  String farmIDT = "";
  String farmIDValue = "";

  bool batchNumberLoaded = false;
  bool purchaseDetailLoaded = false;

  bool senderLoaded = true;
  bool senderValueLoaded = false;

  @override
  void initState() {
    super.initState();
    initdata();
    getLocation();
    getClientData();

    numofbagsController.addListener(() {
      if (numofbagsController.text.isNotEmpty && noofBagss.isNotEmpty) {
        if (double.parse(numofbagsController.text) > double.parse(noofBagss)) {
          errordialog(context, TranslateFun.langList['infoCls'],
              TranslateFun.langList['noofbatrshbelethoreqtoexbaCls']);
          numofbagsController.clear();
        } else if (numofbagsController.text == "0") {
          errordialog(
              context, "information", "No of bags should not contain zero");
          numofbagsController.clear();
        }
      }
    });

    totalwghtController.addListener(() {
      if (totalwghtController.text.isNotEmpty && weightKg.isNotEmpty) {
        if (double.parse(totalwghtController.text) > double.parse(weightKg)) {
          errordialog(context, TranslateFun.langList['infoCls'],
              TranslateFun.langList['towetrshbelethoreqtoexstkgCls']);
          totalwghtController.clear();
        } else if (totalwghtController.text == "0") {
          errordialog(context, "information",
              "Total weight transferred should not contain zero");
          totalwghtController.clear();
        }
      }
    });
  }

  Future<void> initdata() async {
    List inputTypeList = await db.RawQuery('select * from inputType');
    print(' inputTypeList' + inputTypeList.toString());
    loadsender();

    reciverUIModel = [];
    reciveritems.clear();
    String warehouseQry =
        'select applicantId,certNo,applicantName,vId from vcaRegListData where actCat = "9"';
    List warehouseList = await db.RawQuery(warehouseQry);
    print("warehouse list:" + warehouseList.toString());
    for (int i = 0; i < warehouseList.length; i++) {
      String property_value = warehouseList[i]["applicantName"].toString();
      String DISP_SEQ = warehouseList[i]["vId"].toString();
      var uimodel = new UImodel(property_value, DISP_SEQ);
      reciverUIModel.add(uimodel);
      setState(() {
        reciveritems.add(DropdownModel(
          property_value,
          DISP_SEQ,
        ));
        //prooflist.add(property_value);
      });
    }

    // loadreciver();

    Random rnd = new Random();
    revNo = 100000 + rnd.nextInt(999999 - 100000);

    recpnumbr = revNo.toString();
  }

  void loadsender() async {
    senderUIModel = [];
    senderitems.clear();
    String warehouseQry = 'select a.procBatchNo,c.coName from agentMaster a, coOperative c where a.procBatchNo=c.coCode';
    List warehouseList = await db.RawQuery(warehouseQry);
    for (int i = 0; i < warehouseList.length; i++) {
      String property_value = warehouseList[i]["coName"].toString();
      String DISP_SEQ = warehouseList[i]["procBatchNo"].toString();
      var uimodel = new UImodel(property_value, DISP_SEQ);
      senderUIModel.add(uimodel);
      setState(() {
        senderitems.add(DropdownModel(
          property_value,
          DISP_SEQ,
        ));
        //prooflist.add(property_value);
      });
    }
  }

  // void loadreciver() async {
  //
  // }

  void loadbatchnumber(String sender) async {
    batchnumberUIModel = [];
    batchnumbritems.clear();
    String warehouseQry =
        'select distinct purRecieptNo from villageWarehouse where buyingCenter = \'' +
            sender +
            '\'and  stockType = "0" ';
    List warehouseList = await db.RawQuery(warehouseQry);
    for (int i = 0; i < warehouseList.length; i++) {
      String property_value = warehouseList[i]["purRecieptNo"].toString();
      String DISP_SEQ = warehouseList[i]["purRecieptNo"].toString();
      var uimodel = new UImodel(property_value, DISP_SEQ);
      batchnumberUIModel.add(uimodel);
      setState(() {
        batchnumbritems.add(DropdownModel(
          property_value,
          DISP_SEQ,
        ));
        //prooflist.add(property_value);
      });
    }

    Future.delayed(Duration(milliseconds: 500), () {
      setState(() {
        if (batchnumbritems.length > 0) {
          slctbatchnumbrId = '';
          batchNumberLoaded = true;
        }
      });
    });
  }

  void loadBatchDetails(String batchNo) async {
    String loadBatchDet =
        'select * from villageWarehouse where purRecieptNo = \'' +
            batchNo +
            '\' and stockType = "0" ';
    List batchList = await db.RawQuery(loadBatchDet);

    print("batch list:" + batchList.toString());
    String farmerrCode = "";
    String coGra = "";
    String fName1 = "";
    String farmNameVal = "";
    String farmName1 = "";
    String cofType = "";
    String coVarietys = "";
    String grossWt = "";
    String noBags = "";
    setState(() {
      farmerrCode = "";
      coGra = "";
      fName1 = "";
      farmNameVal = "";
      farmName1 = "";
      cofType = "";
      coVarietys = "";
      grossWt = "";
      noBags = "";
      farmerName = "";
      farmerocde = "";
      farmcde = "";
      coffetype = "";
      coffevarity = "";
      coffeegrade = "";
      exisisstock = "";
      noofBagss = "";
      weightKg = "";
      farmIDT = "";
    });

    for (int i = 0; i < batchList.length; i++) {
      //farmer Code
      farmerrCode = batchList[i]["farmerCode"].toString();
      print("farmerrrcode" + farmerrCode);
      fName1 = batchList[i]['farmerName'].toString();

      farmIDT = batchList[i]['farmCode'].toString();
      farmName1 = batchList[i]['farmName'].toString();


      //coffee grade
      coGrade = batchList[i]["coffeeGrade"].toString();
      List coGr1 = await db.RawQuery(
          'select property_value from animalCatalog where DISP_SEQ = \'' +
              coGrade +
              '\'');
      print("coffeeType:" + coGr1.toString());
      coGra = coGr1[0]["property_value"].toString();


      coVariety = batchList[i]["coffeeVariety"].toString();

      //coffee Type
      coType = batchList[i]['coffeeType'].toString();
      List cType = await db.RawQuery(
          'select vName from varietyList where vCode = \'' + coType + '\'');
      cofType = cType[0]['vName'].toString();
      print("coffee type :" + cofType);

      //coffee Variety

      /*  List coVarity = await db.RawQuery(
          'select grade from procurementGrade where gradeCode = \'' +
              coVariety +
              '\'');
      coVarietys = coVarity[0]['grade'].toString();*/
      coVarietys="";
      print("coVarietys:" + coVarietys);
      grossWt = batchList[i]['netWt'].toString();
      noBags = batchList[i]['noofbags'].toString();

      setState(() {
        farmerName = fName1;
        farmerocde = farmerrCode;
        farmcde = farmName1;

        coffetype = cofType;
        coffevarity = coVarietys;
        coffeegrade = coGra;
        exisisstock = grossWt + "/" + noBags;
        noofBagss = noBags;
        weightKg = grossWt;
      });
    }
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
        Lat = position.latitude.toString();
        Lng = position.longitude.toString();
      });
    } else {
      Alert(
          context: context,
          title: TranslateFun.langList['infoCls'],
          desc: "GPS Location not enabled",
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

  getClientData() async {
    agents = await db.RawQuery('SELECT * FROM agentMaster');
    seasoncode = agents[0]['currentSeasonCode'];
    print("current season code:" + seasoncode);
    servicePointId = agents[0]['servicePointId'];
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: WillPopScope(
        onWillPop: _onBackPressed,
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          appBar: AppBar(
            centerTitle: true,
            leading: IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () {
                  _onBackPressed();
                }),
            title: Text(
              TranslateFun.langList['trtoPrPrSuCls'],
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

    if (senderLoaded && TrnsferprocssList.length == 0) {
      listings.add(txt_label_mandatory(
          TranslateFun.langList['senCls'], Colors.black, 14.0, false));
      listings.add(DropDownWithModel(
          itemlist: senderitems,
          selecteditem: slctsender,
          hint: TranslateFun.langList['seSeCls'],
          onChanged: (value) {
            setState(() {
              slctsender = value!;
              slctsenderId = slctsender!.value;
              slctsendernme = slctsender!.name;
              senderData = slctsender!.name;
              loadbatchnumber(slctsenderId);
              slctbatchnumber = null;
              slctbatchnumbrId = "";
              slctbatchnumbr = "";
              farmerName = "";
              farmerocde = "";
              farmcde = "";
              coffetype = "";
              coffevarity = "";
              coffeegrade = "";
              numofbagsController.clear();
              totalwghtController.clear();
              coType = "";
              coVariety = "";
              coGrade = "";
              exisisstock = "";
              exisisstock = "";
              farmIDValue = "";
            });
          },
          onClear: () {
            setState(() {
              slctsenderId = '';
            });
          }));
    }

    if (senderValueLoaded && TrnsferprocssList.length > 0) {
      listings.add(txt_label_mandatory("Sender", Colors.black, 14.0, false));
      listings.add(cardlable_dynamic(senderData));
    }

    listings.add(txt_label_mandatory(
        TranslateFun.langList['recCls'], Colors.black, 14.0, false));
    listings.add(DropDownWithModel(
        itemlist: reciveritems,
        selecteditem: slctreciver,
        hint: TranslateFun.langList['seReCls'],
        onChanged: (value) {
          setState(() {
            slctreciver = value!;
            slctreciverId = slctreciver!.value;
            slctrecivernme = slctreciver!.name;
          });
        },
        onClear: () {
          setState(() {
            slctreciverId = '';
          });
        }));

    listings.add(txt_label_mandatory(
        TranslateFun.langList['dateeCls'], Colors.black, 14.0, false));
    listings.add(selectDate(
        context1: context,
        slctdate: datetransfer,
        onConfirm: (date) => setState(
              () {
            datetransfer = DateFormat('dd-MM-yyyy').format(date!);
            transferFormatedDate = DateFormat('yyyyMMdd').format(date);
          },
        )));

    listings.add(txt_label_mandatory(
        TranslateFun.langList['veNuCls'], Colors.black, 14.0, false));
    listings.add(txtfield_vehicleNumber(
        TranslateFun.langList['veNuCls'], vehiclenumberController, true));

    listings.add(txt_label_mandatory(
        TranslateFun.langList['drNaCls'], Colors.black, 14.0, false));
    listings.add(txtfield_dynamic(
        TranslateFun.langList['drNaCls'], drivernameController, true));

    listings.add(batchNumberLoaded
        ? txt_label_mandatory(
        TranslateFun.langList['reNuCls'], Colors.black, 14.0, false)
        : Container());
    listings.add(batchNumberLoaded
        ? DropDownWithModel(
        itemlist: batchnumbritems,
        selecteditem: slctbatchnumber,
        hint: TranslateFun.langList['seReNuCls'],
        onChanged: (value) {
          setState(() {
            slctbatchnumber = value!;
            slctbatchnumbrId = slctbatchnumber!.value;
            slctbatchnumbr = slctbatchnumber!.name;
            purchaseDetailLoaded = true;
            loadBatchDetails(slctbatchnumbr);
          });
        },
        onClear: () {
          setState(() {
            slctbatchnumbrId = '';
          });
        })
        : Container());

    if (purchaseDetailLoaded) {
      listings.add(txt_label_mandatory(
          TranslateFun.langList['farrNaCls'], Colors.black, 14.0, false));
      listings.add(cardlable_dynamic(farmerName.toString()));

      listings.add(txt_label_mandatory(
          TranslateFun.langList['faCoCls'], Colors.black, 14.0, false));
      listings.add(cardlable_dynamic(farmerocde.toString()));

      listings.add(txt_label_mandatory(
          TranslateFun.langList['faNaCls'], Colors.black, 14.0, false));
      listings.add(cardlable_dynamic(farmcde.toString()));

      listings.add(txt_label_mandatory(
          TranslateFun.langList['coTyCls'], Colors.black, 14.0, false));
      listings.add(cardlable_dynamic(coffetype.toString()));

      /*   listings.add(txt_label_mandatory(
          TranslateFun.langList['coVaCls'], Colors.black, 14.0, false));
      listings.add(cardlable_dynamic(coffevarity.toString()));*/

      listings.add(txt_label_mandatory(
          TranslateFun.langList['coGrCls'], Colors.black, 14.0, false));
      listings.add(cardlable_dynamic(coffeegrade.toString()));

      listings.add(txt_label_mandatory(
          TranslateFun.langList['exStKBaCls'], Colors.black, 14.0, false));
      listings.add(cardlable_dynamic(exisisstock.toString()));

      listings.add(txt_label_mandatory(
          TranslateFun.langList['noofBaTrCls'], Colors.black, 14.0, false));
      listings.add(txtfield_digitswithoutdecimal(
          TranslateFun.langList['noofBaTrCls'], numofbagsController, true));

      listings.add(txt_label_mandatory(
          TranslateFun.langList['toWeTrCls'], Colors.black, 14.0, false));
      listings.add(txtfieldAllowTwoDecimal(
          TranslateFun.langList['toWeTrCls'], totalwghtController, true, 7));

      // listings.add(txt_label_mandatory(availstock, Colors.black, 14.0, false));
      // listings.add(cardlable_dynamic(avilstock.toString()));

      listings.add(btn_dynamic(
          label: TranslateFun.langList['addCls'],
          bgcolor: Colors.green,
          txtcolor: Colors.white,
          fontsize: 18.0,
          centerRight: Alignment.centerRight,
          margin: 10.0,
          btnSubmit: () async {
            bool already = false;

            if (slctbatchnumbr.length == 0 || slctbatchnumbr == '') {
              errordialog(context, TranslateFun.langList['infoCls'],
                  TranslateFun.langList['reNushnobeemCls']);
            } else if (numofbagsController.text.length < 0 ||
                numofbagsController.text == '') {
              errordialog(context, TranslateFun.langList['infoCls'],
                  TranslateFun.langList['noofBaTrshnobeemCls']);
            } else if (totalwghtController.text.length < 0 ||
                totalwghtController.text == '') {
              errordialog(context, TranslateFun.langList['infoCls'],
                  TranslateFun.langList['toWeTrshnobeemCls']);
            }else if (senderData.isEmpty&&slctsenderId.isEmpty) {
              errordialog(context, TranslateFun.langList['infoCls'],
                  "Sender should not be empty");
            } else {
              for (int i = 0; i < TrnsferprocssList.length; i++) {
                if (slctbatchnumbrId == TrnsferprocssList[i].slctbatchnumbrId) {
                  already = true;
                }
              }
              if (!already) {
                setState(() {
                  senderLoaded = false;
                  senderValueLoaded = true;
                });
                var TransferprocessList = TransferprocssList(
                    slctbatchnumbr,
                    slctbatchnumbrId,
                    farmerName,
                    farmerocde,
                    farmcde,
                    coffetype,
                    coffevarity,
                    coffeegrade,
                    numofbagsController.text,
                    totalwghtController.text,
                    datetransfer,
                    coType,
                    coVariety,
                    coGrade,
                    exisisstock,
                    exisisstock,
                    farmIDT,
                    slctreciverId);
                setState(() {
                  TrnsferprocssList.add(TransferprocessList);
                });
                setState(() {
                  slctbatchnumbr = "";
                  slctbatchnumbrId = '';
                  farmerName = "";
                  farmerocde = "";
                  farmcde = "";
                  coffetype = "";
                  coffevarity = "";
                  coffeegrade = "";
                  exisisstock = "";
                  numofbagsController.text = '';
                  totalwghtController.text = '';
                  slctbatchnumber = null;
                });
              } else {
                errordialog(
                    context, "information", "Receipt number already added");
              }
            }
          }));

      if (TrnsferprocssList.length > 0) {
        listings.add(TransferprocessDataTable());
      }
    }

    listings.add(txt_label(
        TranslateFun.langList['trReNuCls'], Colors.black, 14.0, false));
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
                  btncancel();
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
        ],
      ),
    ));

    return listings;
  }

  Widget TransferprocessDataTable() {
    List<DataColumn> columns = <DataColumn>[];
    List<DataRow> rows = <DataRow>[];
    columns.add(DataColumn(label: Text(TranslateFun.langList['reNuCls'])));
    columns.add(DataColumn(label: Text("Farmer Name")));
    columns.add(DataColumn(label: Text(TranslateFun.langList['faCoCls'])));
    columns.add(DataColumn(label: Text(TranslateFun.langList['fanaCls'])));
    columns.add(DataColumn(label: Text(TranslateFun.langList['coTyCls'])));
    columns.add(DataColumn(label: Text(TranslateFun.langList['coVaCls'])));
    columns.add(DataColumn(label: Text(TranslateFun.langList['coGrCls'])));
    columns.add(DataColumn(label: Text(TranslateFun.langList['noofBaTrCls'])));
    columns.add(DataColumn(label: Text(TranslateFun.langList['toWeTrCls'])));
    columns.add(DataColumn(label: Text(delete)));

    for (int i = 0; i < TrnsferprocssList.length; i++) {
      List<DataCell> singlecell = <DataCell>[];
      singlecell.add(DataCell(Text(TrnsferprocssList[i].slctbatchnumbr)));
      singlecell.add(DataCell(Text(TrnsferprocssList[i].farmerName)));
      singlecell.add(DataCell(Text(TrnsferprocssList[i].farmerCode)));
      singlecell.add(DataCell(Text(TrnsferprocssList[i].farmName)));
      singlecell.add(DataCell(Text(TrnsferprocssList[i].coffeeType)));
      singlecell.add(DataCell(Text(TrnsferprocssList[i].coffeeVariety)));
      singlecell.add(DataCell(Text(TrnsferprocssList[i].coffeeGrade)));
      singlecell.add(DataCell(Text(TrnsferprocssList[i].numofbags)));
      singlecell.add(DataCell(Text(TrnsferprocssList[i].totalwght)));

      singlecell.add(DataCell(InkWell(
        onTap: () {
          setState(() {
            TrnsferprocssList.removeAt(i);
            if (TrnsferprocssList.length == 0) {
              senderLoaded = true;
              senderValueLoaded = false;
              slctsendernme = "";
              slctsenderId = "";
              slctsender = null;
              slctbatchnumber = null;
              slctbatchnumbrId = "";
              slctbatchnumbr = "";
              batchnumbritems.clear();
              senderData="";

            }
          });
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

  void btncancel() {
    _onBackPressed();
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

  void btnSubmit() {
    if (slctsendernme.length == 0 || slctsendernme == '') {
      errordialog(context, TranslateFun.langList['infoCls'],
          TranslateFun.langList['seshnobeemCls']);
    } else if (slctrecivernme.length == 0 || slctrecivernme == '') {
      errordialog(context, TranslateFun.langList['infoCls'],
          TranslateFun.langList['reshnobeemCls']);
    } else if (datetransfer.length == 0 || datetransfer == '') {
      errordialog(context, TranslateFun.langList['infoCls'],
          TranslateFun.langList['valdateCls']);
    } else if (vehiclenumberController.text.length == 0 ||
        vehiclenumberController.text == '') {
      errordialog(context, TranslateFun.langList['infoCls'],
          TranslateFun.langList['veNushnobeemCls']);
    } else if (drivernameController.text.length == 0 ||
        drivernameController.text == '') {
      errordialog(context, TranslateFun.langList['infoCls'],
          TranslateFun.langList['drNashnobeemCls']);
    } else if (TrnsferprocssList.length == 0) {
      errordialog(context, TranslateFun.langList['infoCls'],
          TranslateFun.langList['adatonstCls']);
    } else {
      confirmationPopupp();
    }
  }

  void confirmationPopupp() {
    Alert(
      context: context,
      type: AlertType.warning,
      title: TranslateFun.langList['confmCls'],
      desc: TranslateFun.langList['proceedCls'],
      buttons: [
        DialogButton(
          child: Text(
            TranslateFun.langList['yesCls'],
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () {
            savetransferprocess();
            Navigator.pop(context);
          },
          width: 120,
        ),
        DialogButton(
          child: Text(
            TranslateFun.langList['noCls'],
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
          width: 120,
        )
      ],
    ).show();
  }

  savetransferprocess() async {
    final now = new DateTime.now();
    String txntime = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
    String msgNo = DateFormat('yyyyMMddHHmmss').format(now);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? agentid = prefs.getString("agentId");
    String? agentToken = prefs.getString("agentToken");

    String txnHeaderQuery =
        'INSERT INTO "main"."txnHeader" ("isPrinted", "txnTime", "mode", "operType", "resentCount", "agentId", "agentToken", "msgNo", "servPointId", "txnRefId") VALUES ('
            '0,\'' +
            txntime +
            '\', '
                '\'02\', '
                '\'01\', '
                '\'0\',\'' +
            agentid! +
            '\', \'' +
            agentToken! +
            '\',\'' +
            msgNo +
            '\', \'' +
            servicePointId +
            '\',\'' +
            revNo.toString() +
            '\')';
    int txnRes = await db.RawInsert(txnHeaderQuery);
    print('txnRes:' + txnRes.toString());

    /*Saving Custom Transaction*/
    AppDatas appDatas = new AppDatas();
    await db.saveCustTransaction(
        txntime, appDatas.txn_Txnprimaryprocess, revNo.toString(), '', '', '');
    try {
      int transferprocess = await db.savetransferprmyprocss(
          sender: slctsenderId,
          reciver: slctreciverId,
          datetransfer: datetransfer,
          vehiclenumber: vehiclenumberController.text,
          drivername: drivernameController.text,
          isSynched: "1",
          recNo: revNo.toString(),
          latitude: Lat,
          longitude: Lng,
          purRecieptNo: "",
          trRecieptNo: revNo.toString(),
          seasonCode: seasoncode);

      if (TrnsferprocssList.length > 0) {
        for (int i = 0; i < TrnsferprocssList.length; i++) {
          int saveprocesstransfer = await db.transferprocessList(
              recNo: TrnsferprocssList[i].exstStock,
              batchnumbr: TrnsferprocssList[i].slctbatchnumbrId,
              totalwght: TrnsferprocssList[i].totalwght,
              numofbags: TrnsferprocssList[i].numofbags,
              trRecieptNo: revNo.toString(),
              farmerName: TrnsferprocssList[i].farmerName,
              farmerCode: TrnsferprocssList[i].farmerCode,
              farmName: TrnsferprocssList[i].farmName,
              coffeeType: TrnsferprocssList[i].coffeeTypeId,
              coffeeVariety: TrnsferprocssList[i].coffeeVarietyId,
              coffeeGrade: TrnsferprocssList[i].coffeeGradeId,
              tDate: datetransfer,
              vName: vehiclenumberController.text,
              dName: drivernameController.text,
              TseasonCode: TrnsferprocssList[i].exstStock,
              farmCode: TrnsferprocssList[i].farmCode,
              buyingCenter: TrnsferprocssList[i].buyingCenter, totWeightTransfer: '', totBagTransfer: '');
          print("saveprocesstransfer" + saveprocesstransfer.toString());

          // int date = await db.UpdateTableValue('villageWarehouse', 'siv',
          //     datetransfer, 'seasonCode', revNo.toString());
        }
      }

      int issync = await db.UpdateTableValue(
          'transferPrimary', 'isSynched', '0', 'recNo', revNo.toString());
      print(issync);

      TxnExecutor txnExecutor = new TxnExecutor();
      txnExecutor.CheckCustTrasactionTable();

      Alert(
        context: context,
        type: AlertType.info,
        title: TranslateFun.langList['txnSuccCls'],
        desc: TranslateFun.langList['trtoPrPrSuCls'],
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
        closeFunction: () {
          Navigator.pop(context);
          Navigator.pop(context);
        },
      ).show();
    } catch (e) {
      toast(e.toString());
    }
  }
}

class TransferprocssList {
  String slctbatchnumbr,
      slctbatchnumbrId,
      farmerName,
      farmerCode,
      farmName,
      farmCode,
      coffeeType,
      coffeeVariety,
      coffeeGrade,
      numofbags,
      totalwght,
      date,
      coffeeTypeId,
      coffeeVarietyId,
      coffeeGradeId,
      exstStock,
      seasonCode,
      buyingCenter;

  TransferprocssList(
      this.slctbatchnumbr,
      this.slctbatchnumbrId,
      this.farmerName,
      this.farmerCode,
      this.farmName,
      this.coffeeType,
      this.coffeeVariety,
      this.coffeeGrade,
      this.numofbags,
      this.totalwght,
      this.date,
      this.coffeeTypeId,
      this.coffeeVarietyId,
      this.coffeeGradeId,
      this.exstStock,
      this.seasonCode,
      this.farmCode,
      this.buyingCenter);
}
