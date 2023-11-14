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
import '../main.dart';
import 'navigation.dart';

class Reception1 extends StatefulWidget {
  const Reception1({Key? key}) : super(key: key);

  @override
  State<Reception1> createState() => _TransferprocessState();
}

class _TransferprocessState extends State<Reception1> {
  List<DropdownModel> receiptNoItems = [];
  List<DropdownModel> purRecptNo = [];
  DropdownModel? slctRcptNo;

  String slct_rcptNo = "", val_rcptNo = "";

  DropdownModel? slctPurchaseRecNo;

  String slct_PurRecNo = "", val_PurRecNo = "";

  String tranferredDate = "",
      driverName = "",
      vehicleNumber = "",
      purchaseNumber = "",
      farmerName = "",
      farmerCode = "",
      farmName = "",
      coffeeType = "",
      coffeeVariety = "",
      grade = "",
      noOfBagsTransferred = "",
      netWeightTransferred = "";

  String gradeCode = '';
  String coGrade = "";
  String coType = "";
  String coVariety = "";

  TextEditingController noOfBagsRcvdController = new TextEditingController();
  TextEditingController netWeightRcvdController = new TextEditingController();

  List<ReceptionList> TableList = [];

  List<Map> agents = [];
  String? seasoncode;
  String? servicePointId;

  String Lat = '';
  String Lng = '';
  String Date = 'Select Date';
  String receptiondate = '';

  List<DropdownModel> recieverItems = [];
  DropdownModel? slctReceiver;
  String slct_Reciever = "";
  String val_Reciever = "";

  String recieverData = "";
  String trReceiptNoData = "";

  var db = DatabaseHelper();

  String? agentId;
  String farmeCode = '';
  String RseasoncodeValue = "";
  String farmIDT = "";

  bool receRecieverLoaded = true;
  bool receRecievernotLoaded = false;

  bool trReceiptNoLoaded = false;
  bool trReceiptNoNotLoaded = true;

  @override
  void initState() {
    super.initState();
    initdata();
    getLocation();
    getClientData();
    //getReceitpNo();

    noOfBagsRcvdController.addListener(() {
      if (noOfBagsRcvdController.text.isNotEmpty &&
          noOfBagsTransferred.isNotEmpty) {
        if (double.parse(noOfBagsRcvdController.text) >
            double.parse(noOfBagsTransferred)) {
          errordialog(context, TranslateFun.langList['infoCls'],
              "No of bags received should not be greater than no of bags transferred");
          noOfBagsRcvdController.clear();
        } else if (noOfBagsRcvdController.text == "0") {
          errordialog(
              context, "information", "No of Bags should not contain zero");
          noOfBagsRcvdController.clear();
        }
      }
    });

    netWeightRcvdController.addListener(() {
      if (netWeightRcvdController.text.isNotEmpty &&
          netWeightTransferred.isNotEmpty) {
        if (double.parse(netWeightRcvdController.text) >
            double.parse(netWeightTransferred)) {
          errordialog(context, TranslateFun.langList['infoCls'],
              "Net weight received should not be greater than net weight transferred");
          netWeightRcvdController.clear();
        } else if (netWeightRcvdController.text == "0") {
          errordialog(context, "information",
              "Net weight received should not contain zero");
        }
      }
    });
  }

  Future<void> getReceitpNo(String reciever) async {
    List recptList = await db.RawQuery(
        'select distinct transferRecptNo from villageWarehouse where stockType = "1" and buyingCenter = \'' +
            reciever +
            '\' and processType = "1" and purRecieptNo !="" ');
    print(' landTenureList' + recptList.toString());

    receiptNoItems.clear();
    for (int i = 0; i < recptList.length; i++) {
      String typurchseName = recptList[i]["transferRecptNo"].toString();
      String typurchseCode = recptList[i]["transferRecptNo"].toString();
      var uimodel = new UImodel(typurchseName, typurchseCode);

      setState(() {
        receiptNoItems.add(DropdownModel(
          typurchseName,
          typurchseCode,
        ));
      });
    }
  }

  Future<void> initdata() async {
    Random rnd = new Random();

    recieverItems.clear();
    String warehouseQry =
        'select applicantId,certNo,applicantName,vId from vcaRegListData where actCat = "9"';
    List warehouseList = await db.RawQuery(warehouseQry);
    print("warehouseList:" + warehouseList.toString());
    for (int i = 0; i < warehouseList.length; i++) {
      String property_value = warehouseList[i]["applicantName"].toString();
      String DISP_SEQ = warehouseList[i]["vId"].toString();
      var uimodel = new UImodel(property_value, DISP_SEQ);
      setState(() {
        recieverItems.add(DropdownModel(
          property_value,
          DISP_SEQ,
        ));
        //prooflist.add(property_value);
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
    servicePointId = agents[0]['servicePointId'];
  }

  void loadBatchDetails(String val_rcptNo) async {
    String loadBatchDet =
        'select * from villageWarehouse where transferRecptNo = \'' +
            val_rcptNo +
            '\' and stockType = "1" and processType = "1" ';
    List batchList = await db.RawQuery(loadBatchDet);
    print("batch list:" + batchList.toString());

    String tDate = "";
    String vNo = "";
    String driName = "";
    String purRecNo = "";

    setState(() {
      tranferredDate = '';
      vehicleNumber = '';
      driverName = '';
      purchaseNumber = '';
    });

    for (int i = 0; i < batchList.length; i++) {
      tDate = batchList[i]["trnsdate"].toString();

      vNo = batchList[i]["vehicleNumber"].toString();
      driName = batchList[i]["driverName"].toString();
      purRecNo = batchList[i]["purRecieptNo"].toString();

      setState(() {
        tranferredDate = tDate;
        vehicleNumber = vNo;
        driverName = driName;
        purchaseNumber = purRecNo;
      });
    }
  }

  loadPurRecieptNo(String trRecieptNo) async {
    String loadPurRec =
        'select distinct purRecieptNo from villageWarehouse where transferRecptNo = \'' +
            val_rcptNo +
            '\' and stockType = "1" and processType = "1" ';
    List batchList = await db.RawQuery(loadPurRec);
    print("batch list:" + batchList.toString());
    purRecptNo.clear();
    for (int i = 0; i < batchList.length; i++) {
      String property_value = batchList[i]["purRecieptNo"].toString();
      String DISP_SEQ = batchList[i]["purRecieptNo"].toString();
      var uimodel = new UImodel(property_value, DISP_SEQ);
      setState(() {
        purRecptNo.add(DropdownModel(
          property_value,
          DISP_SEQ,
        ));
        //prooflist.add(property_value);
      });
    }
  }

  loadDetails(String purRecieptno) async {
    String loadBatchDet =
        'select * from villageWarehouse where purRecieptNo = \'' +
            purRecieptno +
            '\' and stockType = "1" and processType = "1"';
    List purbatchList = await db.RawQuery(loadBatchDet);
    print("batch list:" + purbatchList.toString());

    String grossWt = "";
    String noBags = "";
    String farmName1 = "";
    String coGra = "";
    String fName1 = "";
    String farmNameVal = "";

    String cofType = "";
    String coVarietys = "";
    String farmerName1 = "";

    setState(() {
      farmerName = '';
      farmerCode = '';
      farmName = '';
      coffeeType = '';
      coffeeVariety = '';
      grade = '';
      noOfBagsTransferred = '';
      noOfBagsTransferred = '';
    });

    for (int i = 0; i < purbatchList.length; i++) {
      //farmer Code
      farmName1 = purbatchList[i]["farmName"].toString();

      farmIDT = purbatchList[i]["farmCode"].toString();

      grossWt = purbatchList[i]['weightTransferred'].toString();
      noBags = purbatchList[i]['bagsTransferred'].toString();
      farmeCode = purbatchList[i]["farmerCode"].toString();
      farmerName1 = purbatchList[i]["farmerName"].toString();

      //coffee grade
      gradeCode = purbatchList[i]["coffeeGrade"].toString();
      List coGr1 = await db.RawQuery(
          'select property_value from animalCatalog where DISP_SEQ = \'' +
              gradeCode +
              '\'');
      print("coffeeType:" + coGr1.toString());
      coGra = coGr1[0]["property_value"].toString();

      //coffee Type
      coType = purbatchList[i]['coffeeType'].toString();
      List cType = await db.RawQuery(
          'select vName from varietyList where vCode = \'' + coType + '\'');
      cofType = cType[0]['vName'].toString();
      print("coffee type :" + cofType);

      //coffee Variety
      /*coVariety = purbatchList[i]["coffeeVariety"].toString();
      List coVarity = await db.RawQuery(
          'select grade from procurementGrade where gradeCode = \'' +
              coVariety +
              '\'');
      coVarietys = coVarity[0]['grade'].toString();*/
      coVarietys = "";
      print("coVarietys:" + coVarietys);

      setState(() {
        farmerName = farmerName1;
        farmName = farmName1;
        coffeeType = cofType;
        coffeeVariety = coVarietys;
        grade = coGra;
        noOfBagsTransferred = noBags;
        netWeightTransferred = grossWt;
        farmerCode = farmeCode;
      });
    }
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
              "Reception",
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
    if (receRecieverLoaded && TableList.length == 0) {
      listings.add(txt_label_mandatory(
          TranslateFun.langList['rcvrCls'], Colors.black, 14.0, false));
      listings.add(DropDownWithModel(
          itemlist: recieverItems,
          selecteditem: slctReceiver,
          hint: 'Select Receiver',
          onChanged: (value) {
            setState(() {
              slctReceiver = value!;
              val_Reciever = slctReceiver!.value;

              slct_Reciever = slctReceiver!.name;
              recieverData = slctReceiver!.name;
              getReceitpNo(val_Reciever);
              slctRcptNo = null;
              val_rcptNo = "";
              slct_rcptNo = "";
              purchaseNumber = "";
              farmerName = "";
              farmerCode = "";
              farmName = "";
              coType = "";
              coffeeType = "";
              coVariety = "";
              coffeeVariety = "";
              gradeCode = "";
              grade = "";
              noOfBagsTransferred = "";
              netWeightTransferred = "";
              noOfBagsRcvdController.clear();
              val_rcptNo = "";
              netWeightRcvdController.clear();
              farmIDT = "";
              tranferredDate = "";
              vehicleNumber = "";
              driverName = "";
              slctPurchaseRecNo = null;
              farmeCode = "";
            });
          },
          onClear: () {
            setState(() {
              slct_rcptNo = '';
            });
          }));
    }

    if (receRecievernotLoaded && TableList.length > 0) {
      listings.add(txt_label_mandatory("Receiver", Colors.black, 14.0, false));
      listings.add(cardlable_dynamic(recieverData));
    }

    listings.add(txt_label_mandatory(
        TranslateFun.langList['dateeCls'], Colors.black, 14.0, false));
    listings.add(selectDate(
      context1: context,
      slctdate: Date,
      onConfirm: (date) => setState(() {
        receptiondate = DateFormat('dd-MM-yyyy').format(date!);
        Date = DateFormat('dd-MM-yyyy').format(date);
        print("reception date:" + receptiondate);
        //print('CHECKJOIINGDFATE:2 '+icsjoiningDate);
      }),
    ));

    if (trReceiptNoNotLoaded && TableList.length == 0) {
      listings
          .add(txt_label_mandatory("Purchase Batch Number", Colors.black, 14.0, false));

      listings.add(DropDownWithModel(
          itemlist: receiptNoItems,
          selecteditem: slctRcptNo,
          hint: 'Select the Batch Number',
          onChanged: (value) {
            setState(() {
              slctRcptNo = value!;
              val_rcptNo = slctRcptNo!.value;
              slct_rcptNo = slctRcptNo!.name;
              trReceiptNoData = slctRcptNo!.value;
              ;
              loadBatchDetails(val_rcptNo);
              loadPurRecieptNo(val_rcptNo);
              slctPurchaseRecNo = null;
              val_PurRecNo = "";
              slct_PurRecNo = "";
              purchaseNumber = "";
              farmerName = "";
              farmeCode = "";
              farmName = "";
              coffeeType = "";
              coffeeVariety = "";
              grade = "";
              noOfBagsTransferred = "";
              netWeightTransferred = "";
            });
          },
          onClear: () {
            setState(() {
              slct_rcptNo = '';
            });
          }));
    }

    if (trReceiptNoLoaded && TableList.length > 0) {
      listings
          .add(txt_label_mandatory("Purchase Batch Number", Colors.black, 14.0, false));
      listings.add(cardlable_dynamic(trReceiptNoData));
    }

    listings.add(txt_label_mandatory(
        TranslateFun.langList['trnsfrdDateCls'], Colors.black, 14.0, false));
    listings.add(cardlable_dynamic(tranferredDate.toString()));

    /*  listings.add(txt_label_mandatory(
        TranslateFun.langList['vehicleNoCls'], Colors.black, 14.0, false));
    listings.add(cardlable_dynamic(vehicleNumber.toString()));

    listings.add(txt_label_mandatory(
        TranslateFun.langList['driverNmeCls'], Colors.black, 14.0, false));
    listings.add(cardlable_dynamic(driverName.toString()));*/

    listings.add(txt_label_mandatory(
        'Coffee Purchase Receipt Number', Colors.black, 14.0, false));
    listings.add(DropDownWithModel(
        itemlist: purRecptNo,
        selecteditem: slctPurchaseRecNo,
        hint: 'Select the coffee  purchase receipt No',
        onChanged: (value) {
          setState(() {
            slctPurchaseRecNo = value!;
            val_PurRecNo = slctPurchaseRecNo!.value;
            slct_PurRecNo = slctPurchaseRecNo!.name;
            purchaseNumber = slctPurchaseRecNo!.value;
            loadDetails(val_PurRecNo);
          });
        },
        onClear: () {
          setState(() {
            slct_rcptNo = '';
          });
        }));

    listings.add(txt_label_mandatory("Farmer Name", Colors.black, 14.0, false));
    listings.add(cardlable_dynamic(farmerName.toString()));

    listings.add(txt_label_mandatory(
        TranslateFun.langList['frmrCodeCls'], Colors.black, 14.0, false));
    listings.add(cardlable_dynamic(farmeCode.toString()));

    listings.add(txt_label_mandatory("Farm Name", Colors.black, 14.0, false));
    listings.add(cardlable_dynamic(farmName.toString()));

    listings.add(txt_label_mandatory("Coffee Type", Colors.black, 14.0, false));
    listings.add(cardlable_dynamic(coffeeType.toString()));

    /*  listings
        .add(txt_label_mandatory("Coffee Variety", Colors.black, 14.0, false));
    listings.add(cardlable_dynamic(coffeeVariety.toString()));*/

    listings.add(txt_label_mandatory(
        TranslateFun.langList['grdeCls'], Colors.black, 14.0, false));
    listings.add(cardlable_dynamic(grade.toString()));

    listings.add(txt_label_mandatory(
        TranslateFun.langList['noOfBagsCls'], Colors.black, 14.0, false));
    listings.add(cardlable_dynamic(noOfBagsTransferred.toString()));

    listings.add(txt_label_mandatory(
        TranslateFun.langList['netWghtCls'], Colors.black, 14.0, false));
    listings.add(cardlable_dynamic(netWeightTransferred.toString()));

    listings.add(txt_label_mandatory(
        TranslateFun.langList['bagsRecCls'], Colors.black, 14.0, false));
    listings.add(txtfield_digitswithoutdecimal(
        TranslateFun.langList['bagsRecCls'], noOfBagsRcvdController, true));

    listings.add(txt_label_mandatory(
        TranslateFun.langList['wghtRecCls'], Colors.black, 14.0, false));
    listings.add(txtfieldAllowTwoDecimal(
        TranslateFun.langList['wghtRecCls'], netWeightRcvdController, true, 7));

    listings.add(btn_dynamic(
        label: TranslateFun.langList['addCls'],
        bgcolor: Colors.green,
        txtcolor: Colors.white,
        fontsize: 18.0,
        centerRight: Alignment.centerRight,
        margin: 10.0,
        btnSubmit: _addBtnPressed));

    if (TableList.isNotEmpty) {
      listings.add(ItemListDataTable());
    }

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
                  _btnSubmit();
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

  Future _addBtnPressed() async {
    bool already = false;

    if (slct_PurRecNo.isEmpty) {
      errordialog(context, "information",
          "Coffee Purchase Receipt Number should not be empty");
    } else if (noOfBagsRcvdController.text.isEmpty) {
      errordialog(context, TranslateFun.langList['infoCls'],
          TranslateFun.langList['valBagsRecCls']);
    } else if (netWeightRcvdController.text.isEmpty) {
      errordialog(context, TranslateFun.langList['infoCls'],
          TranslateFun.langList['valWghtRecCls']);
    } else if (recieverData.isEmpty) {
      errordialog(context, TranslateFun.langList['infoCls'],
          "Receiver should not be empty");
    } else {
      for (int i = 0; i < TableList.length; i++) {
        if (val_PurRecNo == TableList[i].batchNumber) {
          already = true;
        }
      }
      if (!already) {
        setState(() {
          receRecieverLoaded = false;
          receRecievernotLoaded = true;
          trReceiptNoNotLoaded = false;
          trReceiptNoLoaded = true;
        });
        setState(() {
          var tableListData = ReceptionList(
              purchaseNumber,
              farmerName,
              farmerCode,
              farmName,
              coType,
              coffeeType,
              coVariety,
              coffeeVariety,
              gradeCode,
              grade,
              noOfBagsTransferred,
              netWeightTransferred,
              noOfBagsRcvdController.text,
              val_rcptNo,
              netWeightRcvdController.text,
              farmIDT);
          TableList.add(tableListData);

          netWeightRcvdController.clear();
          noOfBagsRcvdController.clear();
          purchaseNumber = "";
          farmerName = "";
          farmeCode = "";
          farmName = "";
          coffeeType = "";
          coffeeVariety = "";
          grade = "";
          noOfBagsTransferred = "";
          netWeightTransferred = "";
          slctPurchaseRecNo = null;
        });
      } else {
        errordialog(
            context, "information", "Purchase receipt number already added");
      }
    }
  }

  Widget ItemListDataTable() {
    List<DataColumn> columns = <DataColumn>[];
    List<DataRow> rows = <DataRow>[];
    columns.add(DataColumn(label: Text("Coffee Purchase Receipt number")));
    columns.add(DataColumn(label: Text("Farmer Name")));
    columns.add(DataColumn(label: Text("Farm Name")));
    columns.add(DataColumn(label: Text("Coffee Type")));
    columns.add(DataColumn(label: Text("Coffee Variety")));
    columns.add(DataColumn(label: Text("Grade")));
    columns.add(DataColumn(label: Text("No Of Bags Transferred")));
    columns.add(DataColumn(label: Text("Net Weight Transferred")));
    columns.add(DataColumn(label: Text("No Of Bags Received")));
    columns.add(DataColumn(label: Text("Net Weight Received")));
    columns.add(DataColumn(label: Text("Delete")));

    for (int i = 0; i < TableList.length; i++) {
      List<DataCell> singlecell = <DataCell>[];
      singlecell.add(DataCell(Text(TableList[i].batchNumber.toString())));
      singlecell.add(DataCell(Text(TableList[i].farmerName.toString())));
      singlecell.add(DataCell(Text(TableList[i].farmName.toString())));
      singlecell.add(DataCell(Text(TableList[i].coffeeTypeName.toString())));
      singlecell.add(DataCell(Text(TableList[i].coffeeVarietyName.toString())));
      singlecell.add(DataCell(Text(TableList[i].gradeName.toString())));
      singlecell
          .add(DataCell(Text(TableList[i].noOfBagsTransferred.toString())));
      singlecell
          .add(DataCell(Text(TableList[i].netWeightTransferred.toString())));

      TextEditingController controller = TextEditingController();

      controller.text = TableList[i].noOfBagsReceived.toString();
      singlecell.add(DataCell(
          TextFormField(
            controller: controller,
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(3),
            ],
            decoration: const InputDecoration(border: InputBorder.none),
            onFieldSubmitted: (value) {
              if (value == "0") {
                errordialog(context, "Information",
                    "No of Bags Received should not be zero");
                setState(() {
                  var Value = value;

                  controller.text = Value;
                });
              } else if (value.isEmpty) {
                errordialog(context, "Information",
                    "No of Bags Received should not be empty.");
                setState(() {
                  var Value = value;

                  controller.text = Value;
                });
              } else {
                setState(() {
                  TableList[i].noOfBagsReceived = value;
                  print("distAmt : ${TableList[i].noOfBagsReceived}");
                  controller.text = TableList[i].noOfBagsReceived.toString();
                });
              }
            },
          ),
          showEditIcon: false));

      TextEditingController controller1 = TextEditingController();

      controller1.text = TableList[i].netWeightReceived.toString();
      singlecell.add(DataCell(
          TextFormField(
            controller: controller1,
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(3),
            ],
            decoration: const InputDecoration(border: InputBorder.none),
            onFieldSubmitted: (value) {
              if (value == "0") {
                errordialog(context, "Information",
                    "Net Weight Received should not be zero");
                setState(() {
                  var Value = value;

                  controller1.text = Value;
                });
              } else if (value.isEmpty) {
                errordialog(context, "Information",
                    "Net Weight Received should not be empty.");
                setState(() {
                  var Value = value;

                  controller1.text = Value;
                });
              } else {
                setState(() {
                  TableList[i].netWeightReceived = value;
                  print("distAmt : ${TableList[i].netWeightReceived}");
                  controller1.text = TableList[i].netWeightReceived.toString();
                });
              }
            },
          ),
          showEditIcon: false));

      singlecell.add(DataCell(InkWell(
        onTap: () {
          setState(() {
            TableList.removeAt(i);
            if (TableList.length == 0) {
              receRecieverLoaded = true;
              receRecievernotLoaded = false;
              trReceiptNoNotLoaded = true;
              trReceiptNoLoaded = false;
              tranferredDate = "";
              vehicleNumber = "";
              driverName = "";
              slctReceiver = null;
              val_Reciever = "";
              slct_Reciever = "";
              val_rcptNo = "";
              slct_rcptNo = "";
              receiptNoItems.clear();
              purRecptNo.clear();
              recieverData = "";
            }
            slctPurchaseRecNo = null;
            slctRcptNo = null;

            farmerName = "";
            farmeCode = "";
            farmName = "";
            coffeeType = "";
            coffeeVariety = "";
            grade = "";
            noOfBagsTransferred = "";
            netWeightTransferred = "";
            netWeightRcvdController.clear();
            noOfBagsRcvdController.clear();

            print("table length:" + TableList.length.toString());
            controller1.clear();
          });
        },
        child: const Icon(
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
                TranslateFun.langList['yesCls'],
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
                TranslateFun.langList['noCls'],
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

  void btnSubmit() {}

  saveReceptionData() async {
    try {
      print("hello");
      Random rnd = new Random();
      int recNo = 100000 + rnd.nextInt(999999 - 100000);
      String revNo = recNo.toString();

      final now = new DateTime.now();
      String txntime = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
      String msgNo = DateFormat('yyyyMMddHHmmss').format(now);

      SharedPreferences prefs = await SharedPreferences.getInstance();

      String? agentid = prefs.getString("agentId");
      String? agentToken = prefs.getString("agentToken");
      String insqry =
          'INSERT INTO "main"."txnHeader" ("isPrinted", "txnTime", "mode", "operType", "resentCount", "agentId", "agentToken", "msgNo", "servPointId", "txnRefId") VALUES (0, \'$txntime\', \'02\', \'01\', \'0\', \'${agentid!}\',\' ${agentToken!}\',\' $msgNo\',\' ${servicePointId!}\',\' $revNo\')';
      print('txnHeader $Lng $Lat' + insqry);
      int succ = await db.RawInsert(insqry);
      print(succ);

      AppDatas datas = new AppDatas();
      int custTransaction = await db.saveCustTransaction(
          txntime, datas.txn_reception, revNo, '', '', '');
      print('custTransaction : ' + custTransaction.toString());
      String isSynched = "0";

      int saveReception = await db.saveReception(
          isSynched,
          revNo,
          receptiondate,
          val_Reciever,
          receptiondate,
          val_rcptNo,
          tranferredDate,
          vehicleNumber,
          //country
          driverName,
          //district
          Lat,
          Lng,
          seasoncode!);

      if (TableList.length > 0) {
        for (int i = 0; i < TableList.length; i++) {
          int saveRecepDetails = await db.saveReceptionDetail(
              TableList[i].batchNumber.toString(),
              TableList[i].farmerCode.toString(),
              TableList[i].farmName.toString(),
              TableList[i].coffeeType.toString(),
              TableList[i].coffeeVariety.toString(),
              TableList[i].grade.toString(),
              TableList[i].noOfBagsTransferred.toString(),
              TableList[i].netWeightTransferred.toString(),
              TableList[i].noOfBagsReceived.toString(),
              TableList[i].netWeightReceived.toString(),
              revNo.toString(),
              receptiondate,
              TableList[i].transferReceipt!,
              TableList[i].farmCode.toString(),
              '',
              TableList[i].farmerName.toString());
          print("saveRecepDetails" + revNo.toString());
        }
      }
      int issync = await db.UpdateTableValue(
          'reception', 'isSynched', '0', 'recNo', revNo);

      Alert(
        context: context,
        type: AlertType.info,
        title: "Transaction Successful",
        desc: "Reception Successful",
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
      // Navigator.pop(context);

    } catch (e) {
      print("invalid" + e.toString());
      toast(e.toString());
    }
  }

  void _btnSubmit() async {
    if (val_Reciever.isEmpty) {
      errordialog(context, TranslateFun.langList['infoCls'],
          TranslateFun.langList['valrcvrCls']);
    } else if (receptiondate.isEmpty) {
      errordialog(context, TranslateFun.langList['infoCls'],
          "Date should not be empty");
    } else if (slct_rcptNo.isEmpty) {
      errordialog(context, TranslateFun.langList['infoCls'],
          "Purchase Batch Number should not be empty");
    } else if (TableList.isEmpty && TableList.length == 0) {
      errordialog(
          context, TranslateFun.langList['infoCls'], "Add at-least one List");
    } else {
      String loadPurRec =
          'select distinct purRecieptNo from villageWarehouse where transferRecptNo = \'' +
              val_rcptNo +
              '\' and stockType = "1" ';
      List batchList = await db.RawQuery(loadPurRec);

      bool checkNow = false;

      /*check*/
      if (batchList.isNotEmpty) {
        for (int kl = 0; kl < batchList.length; kl++) {
          String valuer = batchList[kl]['purRecieptNo'];
          print("for loop1");
          for (int ll = 0; ll < TableList.length; ll++) {
            print("for loop2");
            String? tableValue = TableList[ll].batchNumber;
            if (valuer != tableValue) {
              checkNow = false;
              /*Show Validations*/

            } else if (batchList.length == (kl + 1)) {
              checkNow = true;
            }
          }
        }
      }

      if (checkNow) {
        confirmation();
      } else {
        errordialog(context, "information", "Add all coffee purchase reciept no");
      }
    }
  }

  confirmation() {
    var alertStyle = const AlertStyle(
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
        desc: "Do you want to Proceed?",
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
              Navigator.pop(context);
              // Navigator.pop(context);
              saveReceptionData();
            },
            color: Colors.green,
          )
        ]).show();
  }
}

class ReceptionList {
  String? batchNumber,
      farmerName,
      farmerCode,
      farmName,
      coffeeType,
      coffeeTypeName,
      coffeeVariety,
      coffeeVarietyName,
      grade,
      gradeName,
      noOfBagsTransferred,
      netWeightTransferred,
      noOfBagsReceived,
      transferReceipt,
      netWeightReceived,
      farmCode;

  ReceptionList(
      this.batchNumber,
      this.farmerName,
      this.farmerCode,
      this.farmName,
      this.coffeeType,
      this.coffeeTypeName,
      this.coffeeVariety,
      this.coffeeVarietyName,
      this.grade,
      this.gradeName,
      this.noOfBagsTransferred,
      this.netWeightTransferred,
      this.noOfBagsReceived,
      this.transferReceipt,
      this.netWeightReceived,
      this.farmCode);
}
