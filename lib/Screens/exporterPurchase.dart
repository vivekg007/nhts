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

class ExporterPurchase extends StatefulWidget {
  const ExporterPurchase({Key? key}) : super(key: key);

  @override
  State<ExporterPurchase> createState() => _CoffeePurchaseState();
}

class _CoffeePurchaseState extends State<ExporterPurchase> {
  var db = DatabaseHelper();
  List<Map> agents = [];
  String seasoncode = '';
  String servicePointId = '';
  String agendId = '';
  String Latitude = '', Longitude = '';

  //Purchase Date
  String labelPurhaseDate = "";
  String purchaseDate = "";

  /*Exporter*/
  List<DropdownModel> exporterItem = [];
  DropdownModel? slctExporter;
  String slct_Exporter = "";
  String val_Exporter = "";

  /*Batch No*/
  List<DropdownModel> batchNoItem = [];
  DropdownModel? slctBatchNo;
  String slct_BatchNo = "";
  String val_BatchNo = "";

  String exporter = "";
  bool gradeAdded = true;


  /*Grade*/

  List<DropdownModel> gradeItem = [];
  DropdownModel? slctGrade;
  String slct_Grade = "";
  String val_Grade = "";

  String existingStock="";
  String existingBag="";

  TextEditingController noOfBagTransferred = new TextEditingController();
  TextEditingController totalWeightTransferred = new TextEditingController();
  TextEditingController transferReceiptNo = new TextEditingController();
  TextEditingController driverName = new TextEditingController();
  TextEditingController vehicleNo = new TextEditingController();

  List<exporterDetail>ExporterDetail=[];

  String exstStkBag="";




  bool varietyLoaded = false;
  String recpnumbr = "";
  String revNo = "";

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

    noOfBagTransferred.addListener(() {
      if(double.parse(noOfBagTransferred.text)>double.parse(existingBag)){
        errordialog(context, "Information", "No of Bags Transferred should be less than or equal to Existing Bag");
        setState(() {
          noOfBagTransferred.clear();
        });
      }else if(noOfBagTransferred.text=="0"){
        errordialog(context, "Information", "No of Bag Transferred should not be zero");
        noOfBagTransferred.clear();
      }
    });

    totalWeightTransferred.addListener(() {
      if(double.parse(totalWeightTransferred.text)>double.parse(existingStock)){
        errordialog(context, "Information", "Total Weight Transferred should be less than or equal to Existing Weight");
        setState(() {
          totalWeightTransferred.clear();
        });
      }else if(totalWeightTransferred.text=="0"){
        errordialog(context, "Information", "Total Weight Transferred should not be zero");
        totalWeightTransferred.clear();
      }
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

    List exporterListValue = await db.RawQuery(
        'select vId,applicantName from vcaRegListData where actCat ="3" ');
    print(' batchNoList' + exporterListValue.toString());

    exporterItem.clear();
    for (int i = 0; i < exporterListValue.length; i++) {
      String typurchseName = exporterListValue[i]["applicantName"].toString();
      String typurchseCode = exporterListValue[i]["vId"].toString();
      var uimodel = new UImodel(typurchseName, typurchseCode);

      setState(() {
        exporterItem.add(DropdownModel(
          typurchseName,
          typurchseCode,
        ));
      });
    }

    List batchNoList = await db.RawQuery(
        'select distinct batchNo from batchCreationList where stockType ="3" and cast(weight as double)>0 and cast(noOfBag as int)>0 and isDelete = "0"');
    print(' batchNoList' + batchNoList.toString());

    batchNoItem.clear();
    for (int i = 0; i < batchNoList.length; i++) {
      String typurchseName = batchNoList[i]["batchNo"].toString();
      String typurchseCode = batchNoList[i]["batchNo"].toString();
      var uimodel = new UImodel(typurchseName, typurchseCode);

      setState(() {
        batchNoItem.add(DropdownModel(
          typurchseName,
          typurchseCode,
        ));
      });
    }

  }

  loadGrade(String batchNo)async{
    List inputGradeList = await db.RawQuery(
        'select distinct v.grade,a.property_value from batchCreationList v, animalCatalog a where batchNo = \'' + batchNo + '\' and v.grade = a.DISP_SEQ and stockType="3" ');
    print(' coffeeGradeList' + inputGradeList.toString());

    gradeItem.clear();
    for (int i = 0; i < inputGradeList.length; i++) {
      String typurchseName = inputGradeList[i]["property_value"].toString();
      String typurchseCode = inputGradeList[i]["grade"].toString();
      var uimodel = new UImodel(typurchseName, typurchseCode);

      setState(() {
        gradeItem.add(DropdownModel(
          typurchseName,
          typurchseCode,
        ));
      });
    }
  }

  loadAvailableWtandKgs(String grade)async{
    List avlWtKg = await db.RawQuery(
        'select weight,noOfBag from batchCreationList where grade = \'' + grade + '\' and batchNo = \'' + val_BatchNo + '\' and stockType="3"');
    print(' coffeeGradeList' + avlWtKg.toString());
    existingStock="";
    existingBag="";
    for (int i = 0; i < avlWtKg.length; i++) {
      String availableWt = avlWtKg[i]['weight'].toString();
      String availableBag = avlWtKg[i]['noOfBag'].toString();

      setState(() {
        existingStock = availableWt;
        existingBag = availableBag;
        exstStkBag = existingStock + "/"+ existingBag;
      });
      print("existingStock and bag:"+existingStock+existingBag);
    }
  }





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
             "Exporter Purchase",
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
        "Purchase Date", Colors.black, 14.0, false));
    listings.add(selectDate(
      context1: context,
      slctdate: labelPurhaseDate,
      onConfirm: (date) => setState(() {
        //HH:mm:ss
        purchaseDate = DateFormat('dd-MM-yyyy').format(date!);
        labelPurhaseDate = DateFormat('dd/MM/yyyy').format(date);
        //print('CHECKJOIINGDFATE:2 '+icsjoiningDate);
      }),
    ));

    /*exporter field*/
    if(gradeAdded && ExporterDetail.length==0) {
      listings.add(txt_label_mandatory(
          "Exporter", Colors.black, 14.0, false));
      listings.add(DropDownWithModel(
        itemlist: exporterItem,
        selecteditem: slctExporter,
        hint: "Select Exporter",
        onChanged: (value) {
          setState(() {
            slctExporter = value!;
            val_Exporter = slctExporter!.value;
            slct_Exporter = slctExporter!.name;
            exporter = slctExporter!.name;
          });
        },
      ));
    }else{
      listings.add(txt_label_mandatory("Exporter", Colors.black, 14.0, false));

      listings.add(cardlable_dynamic(exporter));

    }


   /* listings.add(txt_label_mandatory("Vehicle Number", Colors.black, 14.0, false));

    listings.add(txtfield_vehicleNumber("Vehicle Number", vehicleNo, true));

    listings.add(txt_label_mandatory("Driver Name", Colors.black, 14.0, false));

    listings.add(txtfield_dynamic("Driver Name", driverName, true));*/

    listings.add(txt_label_mandatory(
        "Batch Number", Colors.black, 14.0, false));

    listings.add(DropDownWithModel(
      itemlist: batchNoItem,
      selecteditem: slctBatchNo,
      hint: "Select Batch Number",
      onChanged: (value) {
        setState(() {
          slctBatchNo = value!;
          val_BatchNo = slctBatchNo!.value;
          slct_BatchNo = slctBatchNo!.name;
          slctGrade=null;
          slct_Grade="";
          val_Grade="";
          existingBag="";
          existingStock="";
          exstStkBag="";

          loadGrade(val_BatchNo);

        });
      },
    ));

    listings.add(txt_label_mandatory(
        "Coffee Grade", Colors.black, 14.0, false));

    listings.add(DropDownWithModel(
      itemlist: gradeItem,
      selecteditem: slctGrade,
      hint: "Select Coffee Grade",
      onChanged: (value) {
        setState(() {
          slctGrade = value!;
          val_Grade = slctGrade!.value;
          slct_Grade = slctGrade!.name;
          noOfBagTransferred.clear();
          totalWeightTransferred.clear();
          loadAvailableWtandKgs(val_Grade);

        });
      },
    ));

    listings.add(txt_label_mandatory(
        "Existing Stock (Kgs & Bags)", Colors.black, 14.0, false));

    listings.add(cardlable_dynamic(exstStkBag));
    
    listings.add(txt_label_mandatory("No of Bags Transferred", Colors.black, 14.0, false));

    listings.add(txtfield_digitswithoutdecimal("No of Bags Transferred", noOfBagTransferred, true, 7));

    listings.add(txt_label_mandatory("Total Weight Transferred", Colors.black, 14.0, false));

    listings.add(txtfieldAllowTwoDecimal("Total Weight Transferred", totalWeightTransferred, true, 9));





    listings.add(btn_dynamic(
        label: TranslateFun.langList['addCls'],
        bgcolor: Colors.green,
        txtcolor: Colors.white,
        fontsize: 18.0,
        centerRight: Alignment.centerRight,
        margin: 10.0,
        btnSubmit: () async {
          bool already = false;
          if(exporter.isNotEmpty&&val_Exporter.isNotEmpty) {
          if(val_BatchNo.isNotEmpty){
            if(val_Grade.isNotEmpty){
              if(existingStock.isNotEmpty){
                if(existingBag.isNotEmpty){
                  if(noOfBagTransferred.text.isNotEmpty){
                    if(totalWeightTransferred.text.isNotEmpty){

                        for (int i = 0; i < ExporterDetail.length; i++) {
                          if (ExporterDetail[i].batchNo == val_BatchNo && ExporterDetail[i].grade == val_Grade) {
                            already = true;
                          }
                        }
                        if (!already) {
                          setState(() {
                            gradeAdded = false;

                            var exporterList = exporterDetail(
                                batchNo: val_BatchNo,
                                grade: val_Grade,
                                gradeName: slct_Grade,
                                existingStock: existingStock + "/" +
                                    existingBag,
                                noOfBags: noOfBagTransferred.text,
                                totalWeight: totalWeightTransferred.text,
                                exstBag: existingBag,
                                exstStk: existingStock,
                                exporterName: slct_Exporter,
                                exporterId: val_Exporter);
                            ExporterDetail.add(exporterList);

                            /*empty batch no*/
                            slctBatchNo = null;
                            val_BatchNo = "";
                            slct_BatchNo = "";

                            /*empty grade*/
                            slctGrade = null;
                            slct_Grade = "";
                            val_Grade = "";
                            gradeItem.clear();

                            /*empty existing bag and weight*/
                            existingStock = "";
                            existingBag = "";
                            exstStkBag = "";

                            /*empty no of bags transferred*/
                            noOfBagTransferred.clear();

                            /*empty total weight transferred*/
                            totalWeightTransferred.clear();
                          });
                        } else {
                          errordialog(context, "information",
                              "Select different batch number or grade");
                        }

                    }else{
                      errordialog(context, "information", "Total weight transferred should not be empty");
                    }
                  }else{
                    errordialog(context, "information", "No of bags transferred should not be empty");
                  }
                }else{
                  errordialog(context, "information", "Existing bag should not be empty");
                }
              }else{
                errordialog(context, "information", "Existing stock should not be empty");
              }
            }else{
              errordialog(context, "information", "Coffee Grade should not be empty");
            }
          }else{
            errordialog(context, "information", "Batch number should not be empty");
          }
          } else{
            errordialog(context, "information", "Exporter should not be empty");
          }


        }));

    if (ExporterDetail.length > 0) {
      listings.add(inputListTable());
    }

    listings.add(
        txt_label("Exporter Purchase Receipt Number", Colors.black, 14.0, false));
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

  Widget inputListTable() {
    List<DataColumn> columns = <DataColumn>[];
    List<DataRow> rows = <DataRow>[];
    columns.add(DataColumn(label: Text('Batch Number')));
    columns.add(DataColumn(label: Text('Coffee Grade')));
    columns.add(DataColumn(label: Text('Existing Stock (Kgs & Bags)')));
    columns.add(DataColumn(label: Text('No of Bags Transferred')));
    columns.add(DataColumn(label: Text('Total Weight Transferred')));
    columns.add(DataColumn(label: Text('Delete')));

    for (int i = 0; i < ExporterDetail.length; i++) {
      List<DataCell> singlecell = <DataCell>[];
      singlecell.add(DataCell(Text(ExporterDetail[i].batchNo!)));
      singlecell.add(DataCell(Text(ExporterDetail[i].gradeName!)));
      singlecell.add(DataCell(Text(ExporterDetail[i].existingStock!)));
      singlecell.add(DataCell(Text(ExporterDetail[i].noOfBags!)));
      singlecell.add(DataCell(Text(ExporterDetail[i].totalWeight!)));

      singlecell.add(DataCell(InkWell(
        onTap: () {
          setState(() {
            ExporterDetail.removeAt(i);
            gradeAdded = true;
            if(ExporterDetail.isEmpty){
              exporter = "";
              slct_Exporter="";
              val_Exporter="";
              slctExporter = null;
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




  void btnSubmit() {

    if(labelPurhaseDate.isEmpty){
      errordialog(context, "information", "Purchase Date should not be empty");
    }else if(val_Exporter.isEmpty){
      errordialog(context, "information", "Exporter should not be empty");
    }/*else if(vehicleNo.text.isEmpty){
      errordialog(context, "information", "Vehicle Number should not be empty");
    }else if(driverName.text.isEmpty){
      errordialog(context, "information", "Driver Name should not be empty");
    }*/else if(ExporterDetail.isEmpty){
      errordialog(context, "information", "Add atleast one batch ");
    }else{
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
        txntime, datas.exporterPurchase, revNo, '', '', '');
    print('custTransaction : ' + custTransaction.toString());
    print('dryer inserting');

    String isSynched = "0";
    String latitude = Latitude;
    String longitude = Longitude;
    String recNo1 = revNo;

    int exporterPurchase = await db.exporterPurchase(
        purDate: purchaseDate,
        exporter: val_Exporter,
        batchNo: "",
        coffGrade: "",
        exstBag: "",
        exstStk: "",
        noBag: "",
        totWt: "",
        trRecNo: "",
        vehNo: vehicleNo.text,
        driNo: driverName.text,
        recNo: recNo1,
        isSynched: isSynched,
        latitude: latitude,
        longitude: longitude,
        seasonCode: seasoncode);

    for(int i=0;i<ExporterDetail.length;i++){
      int exporterlist = await db.exporterPurchaseDetail(
          batchNo: ExporterDetail[i].batchNo!,
          coffGrade: ExporterDetail[i].grade!,
          exstBag: ExporterDetail[i].exstBag!,
          exstStk: ExporterDetail[i].exstStk!,
          noBag: ExporterDetail[i].noOfBags!,
          totWt: ExporterDetail[i].totalWeight!,
          trRecNo: recNo1,
          recNo: recNo1,
          stockType: "",
          trDate: purchaseDate,
        dName: driverName.text,
        vName: vehicleNo.text, exporterId: ExporterDetail[i].exporterId!, exporterName: ExporterDetail[i].exporterName!
      );
    }



    int issync = await db.UpdateTableValue(
        'exporterPurchase', 'isSynched', '0', 'recNo', revNo);

    Alert(
      context: context,
      type: AlertType.info,
      title: TranslateFun.langList['traCls'],
      desc: "Exporter Purchase Successful",
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

class exporterDetail{

  String? batchNo;
  String? grade;
  String? existingStock;
  String? noOfBags;
  String? totalWeight;
  String? gradeName;
  String? exstBag;
  String? exstStk;
  String? exporterName;
  String? exporterId;

  exporterDetail({
    required this.batchNo,
    required this.grade,
    required this.existingStock,
    required this.noOfBags,
    required this.totalWeight,
    required this.gradeName,
    required this.exstBag,
    required this.exstStk,
    required this.exporterName,
    required this.exporterId
});

}
