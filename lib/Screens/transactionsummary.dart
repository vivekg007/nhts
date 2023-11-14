import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import '../Database/Databasehelper.dart';
import '../Model/dynamicfields.dart';
import '../Model/summaryModel.dart';
import '../Utils/MandatoryDatas.dart';
import '../commonlang/translateLang.dart';

var db = DatabaseHelper();
List<TSummaryModel> tsummarylist = [];
List<TSummaryPendingModel> tsummarypendinglist = [];
String agendId = "";

var datas = new AppDatas();

class TransactionSummary extends StatefulWidget {
  @override
  _TransactionSummary createState() => _TransactionSummary();
}

class _TransactionSummary extends State<TransactionSummary> {
  List<Map> agents = [];

  @override
  void initState() {
    super.initState();
    getClientData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  getClientData() async {
    agents = await db.RawQuery('SELECT * FROM agentMaster');

    agendId = agents[0]['agentType'];
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

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return SafeArea(
      child: WillPopScope(
        onWillPop: _onBackPressed,
        child: DefaultTabController(
          length: 2,
          child: Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
              centerTitle: true,
              title: Text(
                TranslateFun.langList['trSuCls'],
                style: new TextStyle(
                    color: Colors.white,
                    fontSize: 18.0,
                    fontWeight: FontWeight.w700),
              ),
              iconTheme: IconThemeData(color: Colors.white),
              backgroundColor: Colors.green,
              brightness: Brightness.light,
              bottom: TabBar(
                tabs: [
                  Tab(
                    icon: Icon(Icons.calendar_today),
                    text: TranslateFun.langList['sumCls'],
                  ),
                  Tab(
                    icon: Icon(Icons.calendar_today),
                    text: TranslateFun.langList['datCls'],
                  ),
                ],
              ),
            ),
            body: TabBarView(
              children: [
                SummaryTabBar(),
                DatewiseTabBar(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SummaryTabBar extends StatefulWidget {
  _SummaryTabBar createState() => _SummaryTabBar();
}

class _SummaryTabBar extends State<SummaryTabBar> {
  bool pendingsummary = false;
  List<Map> agents = [];
  @override
  void initState() {
    super.initState();
    getClientData();
  }

  getClientData() async {
    agents = await db.RawQuery('SELECT * FROM agentMaster');

    agendId = agents[0]['agentType'];
    getvaluesfromdb(agendId);
  }

  @override
  void dispose() {
    super.dispose();
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

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
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
    );
  }

  List<Widget> _getListings(BuildContext context) {
    List<Widget> listings = [];
    listings.add(Container(
      padding: EdgeInsets.all(10.0),
      child: Row(children: <Widget>[
        Expanded(
          child: MaterialButton(
            color: Colors.red,
            child: new Text(TranslateFun.langList['allCls'],
                style: new TextStyle(fontSize: 18.0, color: Colors.white)),
            onPressed: () {
              tsummarylist.clear();
              getvaluesfromdb(agendId);

              setState(() {
                pendingsummary = false;
              });
            },
          ),
          flex: 1,
        ),
        VerticalDivider(
          width: 10.0,
        ),
        Expanded(
            child: MaterialButton(
              color: Colors.green,
              child: new Text(TranslateFun.langList['penCls'],
                  style: new TextStyle(fontSize: 18.0, color: Colors.white)),
              onPressed: () {
                tsummarypendinglist.clear();
                getpendingtsfromdb();
                setState(() {
                  pendingsummary = true;
                });
              },
            ),
            flex: 1),
      ]),
    ));
    if (tsummarylist.length > 0 && !pendingsummary) {
      listings.add(transummarylist(tsummarylist));
    }
    if (tsummarypendinglist.length > 0 && pendingsummary) {
      listings.add(transummaryPendinglist(tsummarypendinglist));
    }
    listings.add(btn_dynamic(
        label: TranslateFun.langList['okCls'],
        bgcolor: Colors.green,
        txtcolor: Colors.white,
        fontsize: 18.0,
        centerRight: Alignment.centerRight,
        margin: 10.0,
        btnSubmit: () {
          Navigator.pop(context);
        }));

    return listings;
  }

  getvaluesfromdb(String agentId) async {
    // String qry_translist =
    //     'SELECT distinct txn_Code,sum(isSynched) as isSynched,sum(pending) as pending,sum(total) as total FROM txn_summary_cnt GROUP BY txn_Code;';

    //
    print("agentId:" + agendId);
    String qry_translist =
        'SELECT * FROM txn_summary_cnt WHERE agentType = \'' + agendId + '\' ';

    print('tsummarylist1qry:  ' + qry_translist);
    List translist = await db.RawQuery(qry_translist);
    print('translist1list:  ' + translist.toString());
    tsummarylist.clear();

    for (int i = 0; i < translist.length; i++) {
      String txnCode = translist[i]["txn_Code"].toString();
      print("txncode:" + txnCode);
      String txnSynched = translist[i]["isSynched"].toString();
      String pending = translist[i]["pending"].toString();
      String total = translist[i]["total"].toString();
      String txnname = "";
      String txnType = translist[i]["txnType"].toString() ?? "";
      print("transaction type:" + txnType);
      if (txnCode == datas.txnFarmerEnrollment) {
        txnname = "Farmer Enrollment";
      } /* else if (txnCode == datas.txn_mrlInsp) {
        txnname = "MRL Inspection";
      } else if (txnCode == datas.procure_txn) {
        txnname = "Procurement";
      } else if (txnCode == datas.txn_withering) {
        txnname = "Coffee Purchase";
      } else if (txnCode == datas.txnSowingscreen) {
        txnname = "Planting";
      }*/
      else if (txnCode == datas.txn_farmSoufflet) {
        txnname = "Farm Registration";
      } else if (txnCode == datas.txn_farmInspection) {
        txnname = "Farm Inspection";
      } else if (txnCode == datas.txnInputReturn) {
        txnname = "Input Return";
      } else if (txnCode == datas.txnDistribution) {
        txnname = "Distribution";
      } else if (txnCode == datas.txnProductTransfer) {
        txnname = "Product Transfer";
      } else if (txnCode == datas.txn_productSale) {
        txnname = "Product Sale";
      } else if (txnCode == datas.txn_payment) {
        txnname = "Payment";
      } else if (txnCode == datas.txn_changePassword) {
        txnname = "Change Password";
      } else if (txnCode == datas.txnCropHarvest) {
        txnname = "Crop Harvest";
      } else if (txnCode == datas.txn_sensitizing) {
        txnname = "Sensitizing";
      } else if (txnCode == datas.txn_cropCalendar) {
        txnname = "Crop Calendar";
      } else if (txnCode == datas.farmer_edit) {
        txnname = "Farmer/Farm Edit";
      } /* else if (txnCode == datas.txn_trp) {
        txnname = "Trip Sheet";
      } else if (txnCode == datas.txn_aggregator) {
        txnname = "Aggregator Registration";
      }*/ /* else if (txnCode == datas.rawpurchse_txn) {
        txnname = "Raw Purchase";
      } else if (txnCode == datas.txn_RawSeedleaning) {
        txnname = "Raw Seed Transfer";
      } else if (txnCode == datas.txn_RawSeedreception) {
        txnname = "Raw Seed Reception";
      }*/
      else if (txnCode == datas.coffeePurchase) {
        agendId == "06" ? txnname = "Coffee Purchase" : "";
      } else if (txnCode == datas.txn_Txnprimaryprocess) {
        agendId == "05"
            ? txnname = "Exporter Purchase"
            : txnname = "Transfer to primary processing";
      } else if (txnCode == datas.txn_reception) {
        agendId == "08"
            ? txnname = "Exporter Reception"
            : txnname = "Reception";
      } else if (txnCode == datas.txn_inputDemand) {
        txnname = "Input Demand/Distribution";
      } else if (txnCode == datas.txn_inputDistribution) {
        txnname = "Input Demand/Distribution";
      } else if (txnCode == datas.nurserySeedGardenInspection) {
        txnname = "Seed Garden/Nursery Inspection";
      } else if (txnType == datas.farmInspection) {
        txnname = "Farm Inspections";
      } else if (txnType == datas.costOfCultivation) {
        txnname = "Cost of Cultivation";
      } else if (txnType == datas.farmerTraining) {
        txnname = "Farmer Training";
      } else if (txnType == datas.vcaInspection && agendId == "04") {
        txnname = "Value Chain Actor Inspection";
      } else if (txnType == datas.stockFarmer) {
        txnname = "Stock Farmer";
      } else if (txnType == datas.vcaTraining && agendId == "04") {
        txnname = "VCA Training";
      } else if (txnType == datas.stockProcessor && agendId == "04") {
        txnname = "Stock Processor";
      } else if (txnType == datas.stockExporter && agendId == "04") {
        txnname = "Stock Exporter";
      } else if (txnCode == datas.txn_dynamic) {
        txnname = "Survey";
      } else if (txnCode == datas.txnPrimaryProcessing) {
        agendId == "08"
            ? txnname = "Secondary Processing"
            : txnname = "Primary Processing";
      } else if (txnCode == datas.exporterPurchase) {
        txnname = "Exporter Purchase";
      } else if (txnCode == datas.exporterReception) {
        txnname = "Exporter Reception";
      } else if (txnCode == datas.activityTxn) {
        txnname = "Other Activities";
      } else if (txnCode == datas.entityFarm) {
        txnname = "Entity Farm Registration";
      }
      print("txnname_txnname" + txnname);
      print("txnSynched_txnSynched" + txnSynched);
      print("total_total" + total);
      print("pending_pending" + pending);

      var tsModel = new TSummaryModel(txnname, total, txnSynched, pending);
      setState(() {
        tsummarylist.add(tsModel);
      });
    }
    print("tsummarylistsummarylist: " + tsummarylist.length.toString());

    /*  String qry_translist_pen = 'SELECT distinct txn_Code,sum(isSynched) as isSynched,sum(pending) as pending,sum(total) as total FROM txn_summary_cnt GROUP BY txn_Code;';
    print('tsummarylist 1:  ' + qry_translist_pen);
    List trans_penlist = await db.RawQuery(qry_translist_pen);
    print('tsummarylist 2:  ' + trans_penlist.toString());
    tsummarylist.clear();

    for (int i = 0; i < trans_penlist.length; i++) {
      String txnCode = trans_penlist[i]["txn_Code"].toString();
      String txnSynched = trans_penlist[i]["isSynched"].toString();
      String pending = trans_penlist[i]["pending"].toString();
      String total = trans_penlist[i]["total"].toString();
      var tsModel = new TSummaryModel(txnCode, txnSynched,pending,total);
      tsummarylist.add(tsModel);
    }
    print("tsummarylist 3: " + tsummarylist.length.toString());*/
  }

  Future<void> getpendingtsfromdb() async {
    String qry_trans_pen_list =
        'Select * from txn_summary_cnt_pending agentType = \'' + agendId + '\'';
    print('trans_pen_listqry:  ' + qry_trans_pen_list);
    List trans_pen_list = await db.RawQuery(qry_trans_pen_list);
    print('trans_pendinglist ' + trans_pen_list.toString());
    tsummarylist.clear();

    for (int i = 0; i < trans_pen_list.length; i++) {
      String _ID = trans_pen_list[i]["_ID"].toString();
      String txnCode = trans_pen_list[i]["txn_Code"].toString();
      String txn_Date = trans_pen_list[i]["txn_Date"].toString();
      String txn_Full_Date = trans_pen_list[i]["txn_Full_Date"].toString();
      String farmerName = trans_pen_list[i]["farmerName"].toString();
      String village = trans_pen_list[i]["village"].toString();
      String txnRefId = trans_pen_list[i]["txnRefId"].toString();
      String txnname = "";
      String txnType = trans_pen_list[i]["txnType"].toString() ?? "";
      if (farmerName == 'null') {
        farmerName = '-';
      }
      if (village == 'null') {
        village = '-';
      }
      if (txnCode == datas.txnFarmerEnrollment) {
        txnname = "Farmer Enrollment";
      } /* else if (txnCode == datas.txn_mrlInsp) {
        txnname = "MRL Inspection";
      } else if (txnCode == datas.procure_txn) {
        txnname = "Procurement";
      } else if (txnCode == datas.txn_withering) {
        txnname = "Coffee Purchase";
      } else if (txnCode == datas.txnSowingscreen) {
        txnname = "Planting";
      } else if (txnCode == datas.txn_addFarm) {
        txnname = "Farm Registration";
      }*/
      else if (txnCode == datas.txn_farmInspection) {
        txnname = "Farm Inspection";
      } else if (txnCode == datas.txnInputReturn) {
        txnname = "Input Return";
      } else if (txnCode == datas.txnDistribution) {
        txnname = "Distribution";
      } else if (txnCode == datas.txnProductTransfer) {
        txnname = "Product Transfer";
      } else if (txnCode == datas.txn_productSale) {
        txnname = "Product Sale";
      } else if (txnCode == datas.txn_payment) {
        txnname = "Payment";
      } else if (txnCode == datas.txn_changePassword) {
        txnname = "Change Password";
      } else if (txnCode == datas.txn_sensitizing) {
        txnname = "Sensitizing";
      } else if (txnCode == datas.txn_cropCalendar) {
        txnname = "Crop Calendar";
      } else if (txnCode == datas.farmer_edit) {
        txnname = "Farmer/Farm Edit";
      } else if (txnCode == datas.activityTxn) {
        txnname = "Other Activities";
      } /*else if (txnCode == datas.txn_trp) {
        txnname = "Trip Sheet";
      } else if (txnCode == datas.txn_aggregator) {
        txnname = "Aggregator Registration";
      } else if (txnCode == datas.rawpurchse_txn) {
        txnname = "Raw Purchase";
      } else if (txnCode == datas.txn_RawSeedleaning) {
        txnname = "Raw Seed Transfer";
      } else if (txnCode == datas.txn_RawSeedreception) {
        txnname = "Raw Seed Reception";
      }*/
      else if (txnCode == datas.coffeePurchase) {
        agendId == "06" ? txnname = "Coffee Purchase" : "";
      } else if (txnCode == datas.txn_Txnprimaryprocess) {
        agendId == "05"
            ? txnname = "Exporter Purchase"
            : txnname = "Transfer to primary processing";
      } else if (txnCode == datas.txn_reception) {
        agendId == "08"
            ? txnname = "Exporter Reception"
            : txnname = "Reception";
      } else if (txnCode == datas.txn_inputDemand) {
        txnname = "Input Demand/Distribution";
      } else if (txnCode == datas.txn_inputDistribution) {
        txnname = "Input Demand/Distribution";
      } else if (txnCode == datas.nurserySeedGardenInspection) {
        txnname = "Seed Garden/Nursery Inspection";
      } else if (txnType == datas.farmInspection) {
        txnname = "Farm Inspections";
      } else if (txnType == datas.costOfCultivation) {
        txnname = "Cost of Cultivation";
      } else if (txnType == datas.farmerTraining) {
        txnname = "Farmer Training";
      } else if (txnType == datas.vcaInspection && agendId == "04") {
        txnname = "Value Chain Actor Inspection";
      } else if (txnType == datas.stockFarmer) {
        txnname = "Stock Farmer";
      } else if (txnType == datas.vcaTraining && agendId == "04") {
        txnname = "VCA Training";
      } else if (txnType == datas.stockProcessor && agendId == "04") {
        txnname = "Stock Processor";
      } else if (txnType == datas.stockExporter && agendId == "04") {
        txnname = "Stock Exporter";
      } else if (txnCode == datas.txn_dynamic) {
        txnname = "Survey";
      } else if (txnCode == datas.txnPrimaryProcessing) {
        agendId == "08"
            ? txnname = "Secondary Processing"
            : txnname = "Primary Processing";
      } else if (txnCode == datas.exporterPurchase) {
        txnname = "Exporter Purchase";
      } else if (txnCode == datas.exporterReception) {
        txnname = "Exporter Reception";
      } else if (txnCode == datas.entityFarm) {
        txnname = "Entity Farm Registration";
      }

      // var tsModel = new TSummaryModel(txnname+"/"+txnDate, txnSynched,pending,total);
      var tsModel = new TSummaryPendingModel(_ID, txnCode, txn_Date,
          txn_Full_Date, farmerName, village, txnRefId, txnname);

      setState(() {
        tsummarypendinglist.add(tsModel);
      });
    }
    print("TSummaryPendingModel" + tsummarylist.length.toString());
  }
}

class DatewiseTabBar extends StatefulWidget {
  _DatewiseTabBar createState() => _DatewiseTabBar();
}

class _DatewiseTabBar extends State<DatewiseTabBar> {
  List<Map> agents = [];
  @override
  void initState() {
    super.initState();
    getClientData();
  }

  getClientData() async {
    agents = await db.RawQuery('SELECT * FROM agentMaster');

    agendId = agents[0]['agentType'];
    getvaluesfromdb(agendId);
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> getvaluesfromdb(String agentId) async {
    // String qry_translist =
    //     'SELECT distinct txn_Code,sum(isSynched) as isSynched,sum(pending) as pending,sum(total) as total, txn_Date FROM txn_summary_cnt GROUP BY txn_Code;';

    /* String qry_translist =
        "SELECT * FROM txn_summary_cnt WHERE txn_Date BETWEEN datetime('now','-7 days') AND datetime('now', 'localtime') and" +
            '  agentType = \'' +
            agendId +
            '\'';*/
    String qry_translist =
        'SELECT * FROM txn_summary_cnt WHERE agentType = \'' + agendId + '\' ';
    print('tsummarylistqry:  ' + qry_translist);
    List translist = await db.RawQuery(qry_translist);
    print('tsummarylistlist:  ' + translist.toString());
    tsummarylist.clear();

    for (int i = 0; i < translist.length; i++) {
      String txnCode = translist[i]["txn_Code"].toString();
      String txnSynched = translist[i]["isSynched"].toString();
      String pending = translist[i]["pending"].toString();
      String total = translist[i]["total"].toString();
      String txn_Date = translist[i]["txn_Date"].toString();
      String txnname = "";
      String txnType = translist[i]["txnType"].toString();
      print("txnType:" + txnType);
      if (txnCode == datas.txnFarmerEnrollment) {
        txnname = "Farmer Enrollment";
      } else if (txnCode == datas.txn_farmSoufflet) {
        txnname = "Farm Registration";
      } /*else if (txnCode == datas.txn_mrlInsp) {
        txnname = "MRL Inspection";
      } else if (txnCode == datas.txn_addFarm) {
        txnname = "Farm Registration";
      } else if (txnCode == datas.txnSowingscreen) {
        txnname = "Planting";
      } else if (txnCode == datas.procure_txn) {
        txnname = "Procurement";
      } else if (txnCode == datas.txn_withering) {
        txnname = "Coffee Purchase";
      } else if (txnCode == datas.txn_ctc) {
        txnname = "CTC";
      } else if (txnCode == datas.txn_cfm) {
        txnname = "CFM";
      } else if (txnCode == datas.txn_dryer) {
        txnname = "Dryer";
      }*/
      else if (txnCode == datas.txnProductTransfer) {
        txnname = "Product Transfer";
      } else if (txnCode == datas.txn_productSale) {
        txnname = "Product Sale";
      } else if (txnCode == datas.txn_payment) {
        txnname = "Payment";
      } else if (txnCode == datas.txn_changePassword) {
        txnname = "Change Password";
      } else if (txnCode == datas.txn_sensitizing) {
        txnname = "Sensitizing";
      } else if (txnCode == datas.txn_cropCalendar) {
        txnname = "Crop Calendar";
      } else if (txnCode == datas.farmer_edit) {
        txnname = "Farmer/Farm Edit";
      } else if (txnCode == datas.entityFarm) {
        txnname = "Entity Farm Registration";
      } /* else if (txnCode == datas.txn_trp) {
        txnname = "Trip Sheet";
      } else if (txnCode == datas.txn_aggregator) {
        txnname = "Aggregator Registration";
      } else if (txnCode == datas.rawpurchse_txn) {
        txnname = "Raw Purchase";
      } else if (txnCode == datas.txn_RawSeedleaning) {
        txnname = "Raw Seed Transfer";
      } else if (txnCode == datas.txn_RawSeedreception) {
        txnname = "Raw Seed Reception";
      }*/
      else if (txnCode == datas.coffeePurchase) {
        agendId == "06" ? txnname = "Coffee Purchase" : "";
      } else if (txnCode == datas.txn_Txnprimaryprocess) {
        agendId == "05"
            ? txnname = "Exporter Purchase"
            : txnname = "Transfer to primary processing";
      } else if (txnCode == datas.txn_reception) {
        agendId == "08"
            ? txnname = "Exporter Reception"
            : txnname = "Reception";
      } else if (txnCode == datas.txn_inputDemand) {
        txnname = "Input Demand/Distribution";
      } else if (txnCode == datas.txn_inputDistribution) {
        txnname = "Input Demand/Distribution";
      } else if (txnCode == datas.nurserySeedGardenInspection) {
        txnname = "Seed Garden/Nursery Inspection";
      } else if (txnType == datas.farmInspection) {
        txnname = "Farm Inspections";
      } else if (txnType == datas.costOfCultivation) {
        txnname = "Cost of Cultivation";
      } else if (txnType == datas.farmerTraining) {
        txnname = "Farmer Training";
      } else if (txnType == datas.vcaInspection && agendId == "04") {
        txnname = "Value Chain Actor Inspection";
      } else if (txnType == datas.stockFarmer) {
        txnname = "Stock Farmer";
      } else if (txnType == datas.vcaTraining && agendId == "04") {
        txnname = "VCA Training";
      } else if (txnType == datas.stockProcessor && agendId == "04") {
        txnname = "Stock Processor";
      } else if (txnType == datas.stockExporter && agendId == "04") {
        txnname = "Stock Exporter";
      } else if (txnCode == datas.txn_dynamic) {
        txnname = "Survey";
      } else if (txnCode == datas.txnPrimaryProcessing) {
        agendId == "08"
            ? txnname = "Secondary Processing"
            : txnname = "Primary Processing";
      } else if (txnCode == datas.exporterPurchase) {
        txnname = "Exporter Purchase";
      } else if (txnCode == datas.exporterReception) {
        txnname = "Exporter Reception";
      } else if (txnCode == datas.activityTxn) {
        txnname = "Other Activities";
      }

      var tsModel = new TSummaryModel(
          txnname + '/' + txn_Date, total, txnSynched, pending);
      setState(() {
        tsummarylist.add(tsModel);
      });
    }
    print("tsummarylistmodel: " + tsummarylist.length.toString());

    /*  String qry_translist_pen = 'SELECT distinct txn_Code,sum(isSynched) as isSynched,sum(pending) as pending,sum(total) as total FROM txn_summary_cnt GROUP BY txn_Code;';
    print('tsummarylist 1:  ' + qry_translist_pen);
    List trans_penlist = await db.RawQuery(qry_translist_pen);
    print('tsummarylist 2:  ' + trans_penlist.toString());
    tsummarylist.clear();

    for (int i = 0; i < trans_penlist.length; i++) {
      String txnCode = trans_penlist[i]["txn_Code"].toString();
      String txnSynched = trans_penlist[i]["isSynched"].toString();
      String pending = trans_penlist[i]["pending"].toString();
      String total = trans_penlist[i]["total"].toString();
      var tsModel = new TSummaryModel(txnCode, txnSynched,pending,total);
      tsummarylist.add(tsModel);
    }
    print("tsummarylist 3: " + tsummarylist.length.toString());*/
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

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
          resizeToAvoidBottomInset: false,
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
          ]))),
    );
  }

  List<Widget> _getListings(BuildContext context) {
    List<Widget> listings = [];
    /*listings.add( Container(
      padding: EdgeInsets.all(10.0),
      child: Row(
          children: <Widget>[
            Expanded(
              child: MaterialButton(
                color: Colors.red,
                child: new Text("All",
                    style: new TextStyle(fontSize: 18.0, color: Colors.white)),
                onPressed: (){
                  getvaluesfromdb();
                },
              ),
              flex:1,
            ),
            VerticalDivider(width: 10.0,),
            Expanded(
                child: MaterialButton(
                  color: Colors.green,
                  child: new Text("Pending",
                      style: new TextStyle(fontSize: 18.0, color: Colors.white)),
                  onPressed: (){
                    getvaluesfromdb();
                  },
                ),
                flex:1
            ),
          ]),
    ));*/
    if (tsummarylist.length > 0) {
      listings.add(transummarylist(tsummarylist));
    }
    listings.add(btn_dynamic(
        label: TranslateFun.langList['okCls'],
        bgcolor: Colors.green,
        txtcolor: Colors.white,
        fontsize: 18.0,
        centerRight: Alignment.centerRight,
        margin: 10.0,
        btnSubmit: () {
          Navigator.pop(context);
        }));

    return listings;
  }
}

Widget transummarylist(List<TSummaryModel> tsummarylist) {
  Widget objWidget = Container(
    child: Column(children: <Widget>[
      ListView.builder(
        shrinkWrap: true,
        //physics: ClampingScrollPhysics(),
        physics: NeverScrollableScrollPhysics(),
        itemCount: tsummarylist == '' ? 1 : tsummarylist.length + 1,
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
                        TranslateFun.langList['trNaCls'],
                        style: TextStyle(
                            color: Colors.green,
                            fontSize: 14,
                            fontWeight: FontWeight.bold),
                      ),
                      alignment: Alignment.center,
                    ),
                    flex: 3,
                  ),
                  SizedBox(
                    width: 10.0,
                  ),
                  Expanded(
                    child: Container(
                      child: Text(
                        TranslateFun.langList['totCls'],
                        style: TextStyle(
                            color: Colors.green,
                            fontSize: 14,
                            fontWeight: FontWeight.bold),
                      ),
                      alignment: Alignment.center,
                    ),
                    flex: 2,
                  ),
                  SizedBox(
                    width: 10.0,
                  ),
                  Expanded(
                    child: Container(
                      child: Text(
                        TranslateFun.langList['synCls'],
                        style: TextStyle(
                            color: Colors.green,
                            fontSize: 14,
                            fontWeight: FontWeight.bold),
                      ),
                      alignment: Alignment.center,
                    ),
                    flex: 2,
                  ),
                  SizedBox(
                    width: 10.0,
                  ),
                  Expanded(
                    child: Container(
                      child: Text(
                        TranslateFun.langList['penCls'],
                        style: TextStyle(
                            color: Colors.green,
                            fontSize: 14,
                            fontWeight: FontWeight.bold),
                      ),
                      alignment: Alignment.center,
                    ),
                    flex: 2,
                  )
                ],
              ),
            );
          }
          index -= 1;
          // return row
          var row = tsummarylist[index];
          return Column(children: <Widget>[
            Container(
              margin: EdgeInsets.only(left: 5.0, right: 5.0, top: 10.0),
              alignment: Alignment.center,
              child: new Row(
                children: <Widget>[
                  Expanded(
                    child: Container(
                      child: Text(
                        tsummarylist[index].tsname,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.bold),
                      ),
                      alignment: Alignment.center,
                    ),
                    flex: 3,
                  ),
                  SizedBox(
                    width: 10.0,
                  ),
                  Expanded(
                    child: Container(
                      child: Text(
                        tsummarylist[index].tsTotal,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.bold),
                      ),
                      alignment: Alignment.center,
                    ),
                    flex: 2,
                  ),
                  SizedBox(
                    width: 10.0,
                  ),
                  Expanded(
                    child: Container(
                      child: Text(
                        tsummarylist[index].tsSynched,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.bold),
                      ),
                      alignment: Alignment.center,
                    ),
                    flex: 2,
                  ),
                  SizedBox(
                    width: 10.0,
                  ),
                  Expanded(
                    child: Container(
                      child: Text(
                        tsummarylist[index].tspending,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.bold),
                      ),
                      alignment: Alignment.center,
                    ),
                    flex: 2,
                  )
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

Widget transummaryPendinglist(List<TSummaryPendingModel> tsummarylist) {
  Widget objWidget = Container(
    child: Column(children: <Widget>[
      ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: tsummarylist == '' ? 1 : tsummarylist.length + 1,
        itemBuilder: (BuildContext context, int index) {
          if (index == 0) {
            // return the header
            return Container(
              margin: EdgeInsets.only(left: 5, right: 5, top: 10.0),
              color: Colors.green,
              alignment: Alignment.center,
              child: new Row(
                children: <Widget>[
                  Expanded(
                    child: Container(
                      child: Text(
                        "Farmer",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold),
                      ),
                      alignment: Alignment.center,
                    ),
                    flex: 3,
                  ),
                  SizedBox(
                    width: 10.0,
                  ),
                  Expanded(
                    child: Container(
                      child: Text(
                        TranslateFun.langList['trNaCls'],
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold),
                      ),
                      alignment: Alignment.center,
                    ),
                    flex: 2,
                  ),
                  SizedBox(
                    width: 10.0,
                  ),
                  Expanded(
                    child: Container(
                      child: Text(
                        TranslateFun.langList['trDaCls'],
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold),
                      ),
                      alignment: Alignment.center,
                    ),
                    flex: 2,
                  ),
                  SizedBox(
                    width: 10.0,
                  ),
                  Expanded(
                    child: Container(
                      child: Text(
                        "Village/PFC",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold),
                      ),
                      alignment: Alignment.center,
                    ),
                    flex: 2,
                  )
                ],
              ),
            );
          }
          index -= 1;
          // return row
          var row = tsummarylist[index];
          return Column(children: <Widget>[
            Container(
              margin: EdgeInsets.only(left: 5.0, right: 5.0, top: 10.0),
              alignment: Alignment.center,
              child: new Row(
                children: <Widget>[
                  Expanded(
                    child: Container(
                      child: Text(
                        tsummarylist[index].farmerName,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 12,
                            fontWeight: FontWeight.bold),
                      ),
                      alignment: Alignment.center,
                    ),
                    flex: 3,
                  ),
                  SizedBox(
                    width: 10.0,
                  ),
                  Expanded(
                    child: Container(
                      child: Text(
                        tsummarylist[index].txnName,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 12,
                            fontWeight: FontWeight.bold),
                      ),
                      alignment: Alignment.center,
                    ),
                    flex: 2,
                  ),
                  SizedBox(
                    width: 10.0,
                  ),
                  Expanded(
                    child: Container(
                      child: Text(
                        tsummarylist[index].txn_Full_Date,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 12,
                            fontWeight: FontWeight.bold),
                      ),
                      alignment: Alignment.center,
                    ),
                    flex: 2,
                  ),
                  SizedBox(
                    width: 10.0,
                  ),
                  Expanded(
                    child: Container(
                      child: Text(
                        tsummarylist[index].village,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 12,
                            fontWeight: FontWeight.bold),
                      ),
                      alignment: Alignment.center,
                    ),
                    flex: 2,
                  )
                ],
              ),
            ),
            Container(
              child: Divider(
                color: Colors.grey,
              ),
              padding: EdgeInsets.only(left: 5, right: 5),
            ),
          ]);
        },
      ),
    ]),
  );
  return objWidget;
}
