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

class exporterReception extends StatefulWidget {
  const exporterReception({Key? key}) : super(key: key);

  @override
  State<exporterReception> createState() => _TransferprocessState();
}

class _TransferprocessState extends State<exporterReception> {
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
        'select distinct transferRecptNo from villageWarehouse where stockType = "1" and recieverId = \'' +
            reciever +
            '\' and processType = "2" and isTransferCompleted = "0"');
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
        'select distinct recieverName,recieverId from villageWareHouse where processType = "2" and isTransferCompleted = "0"';
    List warehouseList = await db.RawQuery(warehouseQry);
    print("warehouseList:" + warehouseList.toString());
    for (int i = 0; i < warehouseList.length; i++) {
      String property_value = warehouseList[i]["recieverName"].toString();
      String DISP_SEQ = warehouseList[i]["recieverId"].toString();
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
        'select v.trnsDate,v.vehicleNumber,v.driverName,v.purRecieptNo,v.weightTransferred,v.bagsTransferred,v.coffeeGrade,a.property_value,v.purRecieptNo  from villageWarehouse v, animalCatalog a where transferRecptNo = \'' +
            val_rcptNo +
            '\' and stockType = "1" and v.coffeeGrade = a.DISP_SEQ  ';
    List batchList = await db.RawQuery(loadBatchDet);
    print("batch list:" + batchList.toString());

    String tDate = "";
    String vNo = "";
    String driName = "";
    String purRecNo = "";
    String grossWt = "";
    String noBags = "";
    String coGra = "";
    String btNo="";

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
      grossWt = batchList[i]['weightTransferred'].toString();
      noBags = batchList[i]['bagsTransferred'].toString();

      //coffee grade
      gradeCode = batchList[i]["coffeeGrade"].toString();
      coGra = batchList[i]["property_value"].toString();
      btNo = batchList[i]['purRecieptNo'].toString();

      setState(() {
        tranferredDate = tDate;
        vehicleNumber = vNo;
        driverName = driName;
        purchaseNumber = purRecNo;

        TableList.add(
          ReceptionList(
              batchNo: btNo,
              grade: gradeCode,
              noBagTransferred: noBags,
              totWtTransferred: grossWt,
              noBagRecieved: "0",
              totWtRecieved: "0",
              gradeName: coGra)
        );

      });
    }
  }

  loadPurRecieptNo(String trRecieptNo) async {
    String loadPurRec =
        'select distinct purRecieptNo from villageWarehouse where transferRecptNo = \'' +
            val_rcptNo +
            '\' and stockType = "1" and processType="2" and isTransferCompleted = "0"  ';
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
        'select v.coffeeGrade,v.bagsTransferred,v.weightTransferred,a.property_value from villageWarehouse v, animalCatalog a where purRecieptNo = \'' +
            purRecieptno +
            '\' and stockType = "1" and processType = "2" and v.coffeeGrade = a.DISP_SEQ ';
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

      print("farmIDT:" + farmName);
      grossWt = purbatchList[i]['weightTransferred'].toString();
      noBags = purbatchList[i]['bagsTransferred'].toString();

      //coffee grade
      gradeCode = purbatchList[i]["coffeeGrade"].toString();
      coGra = purbatchList[i]["property_value"].toString();




      setState(() {
        grade = coGra;
        noOfBagsTransferred = noBags;
        netWeightTransferred = grossWt;

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
              "Exporter Reception",
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
            });
          },
          onClear: () {
            setState(() {
              slct_rcptNo = '';
            });
          }));
    }else{
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
      listings.add(txt_label_mandatory(
          "Transfer Receipt Number", Colors.black, 14.0, false));

      listings.add(DropDownWithModel(
          itemlist: receiptNoItems,
          selecteditem: slctRcptNo,
          hint: 'Select Transfer Receipt Number',
          onChanged: (value) {
            setState(() {
              slctRcptNo = value!;
              val_rcptNo = slctRcptNo!.value;
              slct_rcptNo = slctRcptNo!.name;
              trReceiptNoData = slctRcptNo!.value;
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
    }else{
      listings.add(txt_label_mandatory(
          "Transfer Receipt Number", Colors.black, 14.0, false));
      listings.add(cardlable_dynamic(trReceiptNoData));
    }

    if (trReceiptNoLoaded && TableList.length > 0) {

    }

    listings.add(txt_label_mandatory(
        TranslateFun.langList['trnsfrdDateCls'], Colors.black, 14.0, false));
    listings.add(cardlable_dynamic(tranferredDate.toString()));
/*
    listings.add(txt_label_mandatory(
        TranslateFun.langList['vehicleNoCls'], Colors.black, 14.0, false));
    listings.add(cardlable_dynamic(vehicleNumber.toString()));

    listings.add(txt_label_mandatory(
        TranslateFun.langList['driverNmeCls'], Colors.black, 14.0, false));
    listings.add(cardlable_dynamic(driverName.toString()));*/

    // listings.add(txt_label_mandatory(
    //     'Batch Number', Colors.black, 14.0, false));
    // listings.add(DropDownWithModel(
    //     itemlist: purRecptNo,
    //     selecteditem: slctPurchaseRecNo,
    //     hint: 'Select Batch Number',
    //     onChanged: (value) {
    //       setState(() {
    //         slctPurchaseRecNo = value!;
    //         val_PurRecNo = slctPurchaseRecNo!.value;
    //         slct_PurRecNo = slctPurchaseRecNo!.name;
    //         purchaseNumber = slctPurchaseRecNo!.value;
    //         loadDetails(val_PurRecNo);
    //       });
    //     },
    //     onClear: () {
    //       setState(() {
    //         slct_rcptNo = '';
    //       });
    //     }));
    //
    //
    //
    // listings.add(txt_label_mandatory(
    //    "Coffee Grade", Colors.black, 14.0, false));
    // listings.add(cardlable_dynamic(grade.toString()));
    //
    // listings.add(txt_label_mandatory(
    //     TranslateFun.langList['noOfBagsCls'], Colors.black, 14.0, false));
    // listings.add(cardlable_dynamic(noOfBagsTransferred.toString()));
    //
    // listings.add(txt_label_mandatory(
    //     TranslateFun.langList['netWghtCls'], Colors.black, 14.0, false));
    // listings.add(cardlable_dynamic(netWeightTransferred.toString()));
    //
    // listings.add(txt_label_mandatory(
    //     TranslateFun.langList['bagsRecCls'], Colors.black, 14.0, false));
    // listings.add(txtfield_digitswithoutdecimal(
    //     TranslateFun.langList['bagsRecCls'], noOfBagsRcvdController, true));
    //
    // listings.add(txt_label_mandatory(
    //     TranslateFun.langList['wghtRecCls'], Colors.black, 14.0, false));
    // listings.add(txtfieldAllowTwoDecimal(
    //     TranslateFun.langList['wghtRecCls'], netWeightRcvdController, true, 7));
    //
    // listings.add(btn_dynamic(
    //     label: TranslateFun.langList['addCls'],
    //     bgcolor: Colors.green,
    //     txtcolor: Colors.white,
    //     fontsize: 18.0,
    //     centerRight: Alignment.centerRight,
    //     margin: 10.0,
    //     btnSubmit: _addBtnPressed));

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

    setState(() {
      receRecieverLoaded = false;
      receRecievernotLoaded = true;
      trReceiptNoNotLoaded = false;
      trReceiptNoLoaded = true;
    });
    if (slct_PurRecNo.isEmpty) {
      errordialog(context, "information",
          "Batch Number should not be empty");
    } else if (noOfBagsRcvdController.text.isEmpty) {
      errordialog(context, TranslateFun.langList['infoCls'],
          TranslateFun.langList['valBagsRecCls']);
    } else if (netWeightRcvdController.text.isEmpty) {
      errordialog(context, TranslateFun.langList['infoCls'],
          TranslateFun.langList['valWghtRecCls']);
    }else if(recieverData.isEmpty){
      errordialog(context, "information", "Receiver should not be empty");
    } else if(trReceiptNoData.isEmpty){
      errordialog(context, "information", "Transfer Receipt Number should not be empty");
    } else {
      for (int i = 0; i < TableList.length; i++) {
        if (val_PurRecNo == TableList[i].batchNo) {
          already = true;
        }
      }
      if (!already) {
        setState(() {
          var tableListData = ReceptionList(
              batchNo: val_PurRecNo,
              grade: gradeCode,
              noBagTransferred: noOfBagsTransferred,
              totWtTransferred: netWeightTransferred,
              noBagRecieved: noOfBagsRcvdController.text,
              totWtRecieved: netWeightRcvdController.text,
          gradeName: grade);
          TableList.add(tableListData);

          val_PurRecNo="";
          slctPurchaseRecNo=null;
          grade="";
          gradeCode="";
          noOfBagsTransferred="";
          netWeightTransferred="";
          noOfBagsRcvdController.clear();
          netWeightRcvdController.clear();


        });
      } else {
        errordialog(
            context, "information", "batch number already added");
      }
    }
  }

  Widget ItemListDataTable() {
    List<DataColumn> columns = <DataColumn>[];
    List<DataRow> rows = <DataRow>[];
    columns.add(DataColumn(label: Text("Batch Number")));
    columns.add(DataColumn(label: Text("Coffee Grade")));
    columns.add(DataColumn(label: Text("No Of Bags Transferred")));
    columns.add(DataColumn(label: Text("Net Weight Transferred")));
    columns.add(DataColumn(label: Text("No Of Bags Received")));
    columns.add(DataColumn(label: Text("Net Weight Received")));
    columns.add(DataColumn(label: Text("Delete")));

    for (int i = 0; i < TableList.length; i++) {
      List<DataCell> singlecell = <DataCell>[];
      singlecell.add(DataCell(Text(TableList[i].batchNo.toString())));
      singlecell.add(DataCell(Text(TableList[i].gradeName.toString())));
      singlecell
          .add(DataCell(Text(TableList[i].noBagTransferred.toString())));
      singlecell
          .add(DataCell(Text(TableList[i].totWtTransferred.toString())));

      TextEditingController controller = TextEditingController();

      controller.text = TableList[i].noBagRecieved.toString();
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
              }else if (double.parse(value)>double.parse(TableList[i].noBagTransferred) ) {
                errordialog(context, "Information",
                    "No of bags Received should not be greater than No of bags transferred.");
                setState(() {
                  var Value = value;

                  controller.text = Value;
                });
              } else {
                setState(() {
                  TableList[i].noBagRecieved = value;
                  print("distAmt : ${TableList[i].noBagRecieved}");
                  controller.text = TableList[i].noBagRecieved.toString();
                });
              }
            },
          ),
          showEditIcon: true));

      TextEditingController controller1 = TextEditingController();

      controller1.text = TableList[i].totWtRecieved.toString();
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
              }else if (double.parse(value)>double.parse(TableList[i].totWtTransferred) ) {
                errordialog(context, "Information",
                    "Net Weight Received should not be greater than Net Weight transferred.");
                setState(() {
                  var Value = value;

                  controller.text = Value;
                });
              } else {
                setState(() {
                  TableList[i].totWtRecieved = value;
                  print("distAmt : ${TableList[i].totWtRecieved}");
                  controller1.text = TableList[i].totWtRecieved.toString();
                });
              }
            },
          ),
          showEditIcon: true));

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
              recieverData="";
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

      int saveReception = await db.exporterReception(
          reciever: val_Reciever,
          date: receptiondate,
          trRecNo: val_rcptNo,
          trDate: tranferredDate,
          vehNo: vehicleNumber,
          driNo: driverName,
          batchNo: val_PurRecNo,
          recNo: recNo.toString(),
          isSynched: isSynched,
          latitude: Lat,
          longitude: Lng,
          seasonCode: seasoncode!);

      if (TableList.length > 0) {
        for (int i = 0; i < TableList.length; i++) {
          int saveRecepDetails = await db.exporterReceptionDetail(
              batchNo: TableList[i].batchNo,
              grade: TableList[i].grade,
              noBag: TableList[i].noBagTransferred,
              totWt: TableList[i].totWtTransferred,
              noBagRec: TableList[i].noBagRecieved,
              totWtRec: TableList[i].totWtRecieved,
              recNo: recNo.toString(),
              stockType: "");
          print("saveRecepDetails" + revNo.toString());
        }
      }
      int issync = await db.UpdateTableValue(
          'exporterReception', 'isSynched', '0', 'recNo', revNo);

      Alert(
        context: context,
        type: AlertType.info,
        title: "Transaction Successful",
        desc: "Exporter Reception Successful",
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
          "Transfer Receipt Number should not be empty");
    } else if (TableList.isEmpty && TableList.length == 0) {
      errordialog(
          context, TranslateFun.langList['infoCls'], "Add at-least one List");
    } else {
     confirmation();
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

  String batchNo;
  String grade;
  String gradeName;
  String noBagTransferred;
  String totWtTransferred;
  String noBagRecieved;
  String totWtRecieved;

  ReceptionList(
  {
  required this.batchNo,
  required this.grade,
    required this.noBagTransferred,
    required this.totWtTransferred,
    required this.noBagRecieved,
    required this.totWtRecieved,
    required this.gradeName
}
     );
}
