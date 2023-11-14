import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:ucda/login.dart';

import '../Model/dynamicfields.dart';

class StockReportScreen extends StatefulWidget {
  StockReportScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<StockReportScreen> createState() => _StockReportScreen();
}

class _StockReportScreen extends State<StockReportScreen> {
  String closedBatch = "Closed";
  String latitude = "";
  String longitude = "";

  String seasonCode = "", servicePointId = "", agentId = "";

  @override
  void initState() {
    getLocation();
    getClientData();
    purchasestockLoad();
    transferstockLoad();
    receptionStockLoad();

    super.initState();
  }

  void getLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    setState(() {
      latitude = position.latitude.toString();
      longitude = position.longitude.toString();
    });
  }

  getClientData() async {
    List<Map> agents = await db.RawQuery('SELECT * FROM agentMaster');
    seasonCode = agents[0]['currentSeasonCode'];
    servicePointId = agents[0]['servicePointId'];
    agentId = agents[0]['agentId'];
  }

  purchasestockLoad() async {
    // if (agentType == "01") {
    String query =
        'select distinct purRecieptNo,grossWeight,trnsDate,stockType,noofbags from villageWarehouse where stockType = "0"';
    print("cmStockQuery : $query");
    List stockList = await db.RawQuery(query);
    print("cmStockQuery : " + stockList.toString());
    for (int k = 0; k < stockList.length; k++) {
      var data = StockReportDetails(
          date: stockList[k]["trnsdate"],
          batchNo: stockList[k]["purRecieptNo"],
          quantity: stockList[k]["grossWeight"],
          noofbags: stockList[k]["noofbags"],
          transactionType: "Coffee Purchase");
      stockReportDetails.add(data);
    }
  }

  transferstockLoad() async {
    // if (agentType == "01") {
    String query =
        'select distinct transferRecptNo,weightTransferred,trnsDate,stockType,bagsTransferred from villageWarehouse where stockType = "1"';
    print("cmStockQuery : $query");
    List stockList = await db.RawQuery(query);
    print("cmStockQuery : " + stockList.toString());
    for (int k = 0; k < stockList.length; k++) {
      var data = StockReportDetails(
          date: stockList[k]["trnsdate"],
          batchNo: stockList[k]["transferRecptNo"],
          quantity: stockList[k]["weightTransferred"],
          noofbags: stockList[k]["bagsTransferred"],
          transactionType: "Transfer to Primary Processing");
      stockReportDetails.add(data);
    }
  }

  receptionStockLoad() async {
    // if (agentType == "01") {
    String query =
        'select distinct receptionNo,weightRecieved,trnsDate,stockType,bagsRecieved from villageWarehouse where stockType = "2"';
    print("cmStockQuery : $query");
    List stockList = await db.RawQuery(query);
    print("cmStockQuery : " + stockList.toString());
    for (int k = 0; k < stockList.length; k++) {
      var data = StockReportDetails(
          date: stockList[k]["trnsdate"],
          batchNo: stockList[k]["receptionNo"],
          quantity: stockList[k]["weightRecieved"],
          noofbags: stockList[k]["bagsRecieved"],
          transactionType: "Reception");
      stockReportDetails.add(data);
    }
  }

  List<StockReportDetails> stockReportDetails = [];

  Widget stockReportDetailsTable() {
    List<DataColumn> columns = <DataColumn>[];
    List<DataRow> rows = <DataRow>[];
    columns.add(
        const DataColumn(label: Text("S.No", style: TextStyle(fontSize: 16))));
    columns.add(
        const DataColumn(label: Text("Date", style: TextStyle(fontSize: 16))));
    columns.add(const DataColumn(
        label: Text("Reciept No", style: TextStyle(fontSize: 16))));
    columns.add(const DataColumn(
        label: Text("Quantity(Kgs)", style: TextStyle(fontSize: 16))));
    columns.add(const DataColumn(
        label: Text("No of Bags", style: TextStyle(fontSize: 16))));
    columns.add(const DataColumn(
        label: Text("Transaction Type", style: TextStyle(fontSize: 16))));

    for (int i = 0; i < stockReportDetails.length; i++) {
      List<DataCell> singlecell = <DataCell>[];
      singlecell.add(DataCell(
          Text((i + 1).toString(), style: const TextStyle(fontSize: 16))));
      singlecell.add(DataCell(Text(stockReportDetails[i].date,
          style: const TextStyle(fontSize: 16))));
      singlecell.add(DataCell(Text(stockReportDetails[i].batchNo,
          style: const TextStyle(fontSize: 16))));
      singlecell.add(DataCell(Text(stockReportDetails[i].quantity,
          style: const TextStyle(fontSize: 16))));
      singlecell.add(DataCell(Text(stockReportDetails[i].noofbags,
          style: const TextStyle(fontSize: 16))));
      singlecell.add(DataCell(Text(stockReportDetails[i].transactionType,
          style: const TextStyle(fontSize: 16))));

      rows.add(DataRow(
        cells: singlecell,
      ));
    }

    Widget obj = datatable_dynamic(columns: columns, rows: rows);
    return obj;
  }

  Future<bool> _onBackPressed() async {
    return (await Alert(
          context: context,
          type: AlertType.warning,
          title: "Cancel",
          desc: 'Are you sure want to cancel?',
          buttons: [
            DialogButton(
              child: const Text(
                "yes",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              width: 120,
            ),
            DialogButton(
              child: const Text(
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
          resizeToAvoidBottomInset: true,
          appBar: AppBar(
            backgroundColor: Colors.green,
            centerTitle: true,
            title: const Text("Stock Report"),
            leading: IconButton(
              onPressed: _onBackPressed,
              icon: const Icon(Icons.arrow_back, color: Colors.white),
            ),
          ),
          body: Container(
            child: Column(
              children: <Widget>[
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.all(10.0),
                    children: getListings(context),
                  ),
                  flex: 8,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> getListings(BuildContext context) {
    List<Widget> listings = [];
    listings.add(stockReportDetailsTable());
    return listings;
  }
}

class StockReportDetails {
  String date, batchNo, quantity, noofbags, transactionType;

  StockReportDetails({
    required this.date,
    required this.batchNo,
    required this.quantity,
    required this.noofbags,
    required this.transactionType,
  });
}
