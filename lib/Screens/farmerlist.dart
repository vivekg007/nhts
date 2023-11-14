import 'package:data_tables/data_tables.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import '../Database/Databasehelper.dart';
import '../Database/Model/FarmerMaster.dart';
import '../Model/UIModel.dart';
import '../Model/dynamicfields.dart';
import '../login.dart';
import 'FarmerEditScreen.dart';
import 'farmeredit.dart';

class FarmerListNew extends StatefulWidget {
  @override
  _FarmerTableState createState() => _FarmerTableState();
}

class _FarmerTableState extends State<FarmerListNew> {
  List<FarmerMaster> farmermaster = [];
  List<String> farmeritemscount = ['10'];
  String CatalogValue = '10';
  List<DropdownModel> villageiteams = [];
  DropdownModel? slctvillage;
  List<UImodel> VillageListUIModel = [];
  List<DropdownModel> Farmeriteams = [];
  DropdownModel? slctfarmer;
  List<UImodel> FarmerListUIModel = [];
  String slctVillage = "", val_village = "";
  String slctFarmer = "", val_farmer = "";
  List farmermasternew = [];
  bool farmerLoaded = false;
  bool pageloadLoaded = false;
  bool valueLoaded = false;
  var pageloadLoadedcount = 0;
  List<FarmerMaster> _items = [];
  int _rowsOffset = 0;
  int _sortColumnIndex = 0;
  bool _sortAscending = true;
  var _rowsPerPage1 = PaginatedDataTable.defaultRowsPerPage;
  int _rowsPerPage = PaginatedDataTable.defaultRowsPerPage;

  //export to excel
  static const int rows = 10000;
  Duration? executionTime;

  @override
  void initState() {
    villageload();
    GetFarmerdataDB();
    super.initState();
  }

  /* void _sort<T>(
      Comparable<T> getField(FarmerMaster d), int columnIndex, bool ascending) {
    _items.sort((FarmerMaster a, FarmerMaster b) {
      if (!ascending) {
        final FarmerMaster c = a;
        a = b;
        b = c;
      }
      final Comparable<T> aValue = getField(a);
      final Comparable<T> bValue = getField(b);
      return Comparable.compare(aValue, bValue);
    });
    setState(() {
      _sortColumnIndex = columnIndex;
      _sortAscending = ascending;
    });
  }*/
  villageload() async {
    List villagelist = await db.RawQuery('select * from villageList ');
    print('villagelist' + villagelist.toString());
    villageiteams.clear();
    for (int i = 0; i < villagelist.length; i++) {
      String villCode = villagelist[i]["villCode"].toString();
      String villName = villagelist[i]["villName"].toString();

      var uimodel = new UImodel(villName, villCode);
      VillageListUIModel.add(uimodel);
      setState(() {
        villageiteams.add(DropdownModel(
          villName,
          villCode,
        ));
      });

      Future.delayed(Duration(milliseconds: 500), () {
        print("villageloaeddealy" + villName);
        setState(() {
          if (villageiteams.length > 0) {
            slctVillage = '';
          }
        });
      });
    }
  }

  farmerloadvillage(farmerid) async {
    var db = DatabaseHelper();
    List<FarmerMaster> farmermaster1 = await db.GetFarmerdatavillage(farmerid);
    print("farmermaster : " + farmermaster1.toString());
    setState(() {
      farmermaster = farmermaster1;
    });
  }

  void GetFarmerdataDB() async {
    var db = DatabaseHelper();
    List<FarmerMaster> farmermaster1 = await db.GetFarmerdata();
    print("farmermaster : " + farmermaster1.toString());
    setState(() {
      farmermaster = farmermaster1;
      print("_rowsPerPage1" + farmermaster.length.toString());
    });
  }

  void farmerload(villagecode) async {
    var db = DatabaseHelper();
    List<FarmerMaster> farmermaster1 = await db.GetFarmervilldata(villagecode);
    print("farmermaster : " + farmermaster1.toString());
    setState(() {
      farmermaster = farmermaster1;
    });
    List farmerlist = await db.RawQuery(
        'SELECT * FROM farmer_master frmr inner join villageList vill on frmr.villageId=vill.villCode where  frmr.villageId=\'' +
            villagecode +
            '\' and blockId = "0"');
    print('villagelist67' + farmerlist.toString());
    Farmeriteams.clear();
    for (int i = 0; i < farmerlist.length; i++) {
      String farmerId = farmerlist[i]["farmerId"].toString();
      String fName = farmerlist[i]["fName"].toString();

      var uimodel = new UImodel(fName, farmerId);
      FarmerListUIModel.add(uimodel);
      setState(() {
        Farmeriteams.add(DropdownModel(
          fName,
          farmerId,
        ));
      });
      print("Farmeriteams" + Farmeriteams.length.toString());
      Future.delayed(Duration(milliseconds: 500), () {
        setState(() {
          if (Farmeriteams.length > 0) {
            farmerLoaded = true;
          }
        });
      });
    }
  }

  // _exportToExcel() {
  //   final excel = Excel.createExcel();
  //   final sheet = excel[excel.getDefaultSheet() as String];
  //
  //   sheet.setColWidth(2, 50);
  //   sheet.setColAutoFit(3);
  //
  //   sheet.cell(CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: 3)).value =
  //       'Text String';
  //   sheet.cell(CellIndex.indexByColumnRow(columnIndex: 4, rowIndex: 6)).value =
  //       'Text String';
  //
  //   // for (var row = 0; row < rows; row++) {
  //   //   sheet
  //   //       .cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: row))
  //   //       .value = 'FLUTTER';
  //   //   sheet
  //   //       .cell(CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: row))
  //   //       .value = 'FLUTTER';
  //   //   sheet
  //   //       .cell(CellIndex.indexByColumnRow(columnIndex: 3, rowIndex: row))
  //   //       .value = 'FLUTTER';
  //   //   sheet
  //   //       .cell(CellIndex.indexByColumnRow(columnIndex: 4, rowIndex: row))
  //   //       .value = 'FLUTTER';
  //   //   sheet
  //   //       .cell(CellIndex.indexByColumnRow(columnIndex: 5, rowIndex: row))
  //   //       .value = 'FLUTTER';
  //   // }
  //   excel.save(fileName: 'Farmerlist.xlsx');
  //   print("excel saved");
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

  Widget build(BuildContext context) {
    _items = farmermaster;
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
                  _onBackPressed();
                }),
            title: Text(
              'Farmer List',
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
              flex: 3,
            ),
            Expanded(
              child: NativeDataTable.builder(
                rowsPerPage: _rowsPerPage,
                itemCount: _items?.length ?? 0,
                firstRowIndex: _rowsOffset,
                alwaysShowDataTable: true,
                handleNext: () async {
                  setState(() {
                    _rowsOffset += _rowsPerPage;
                  });
                  print("_rowsOffset" + _rowsOffset.toString());
                },
                handlePrevious: () {
                  setState(() {
                    _rowsOffset -= _rowsPerPage;
                  });
                  if (_rowsOffset < 0) {
                    _rowsOffset = 0;
                  }
                  print("_rowsOffset" +
                      _rowsOffset.toString() +
                      _rowsPerPage.toString());
                },
                itemBuilder: (int index) {
                  var index1 = index + 1;
                  return DataRow.byIndex(index: index, cells: [
                    DataCell(InkWell(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (BuildContext context) => FarmerEditScreen(
                                farmermaster[index].farmerId!)));
                      },
                      child: Icon(
                        Icons.remove_red_eye,
                        color: Colors.red,
                      ),
                    )),
                    DataCell(InkWell(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (BuildContext context) =>
                                FarmerEdit(farmermaster[index].farmerId!)));
                      },
                      child: Icon(
                        Icons.edit,
                        color: Colors.red,
                      ),
                    )),
                    // DataCell(Text(index1.toString())),

                    DataCell(Text(farmermaster[index].villageName!)),
                    DataCell(Text(farmermaster[index].fName! +
                        " " +
                        farmermaster[index].lName!)),
                    DataCell(Text(farmermaster[index].farmerCode!)),
                  ]);
                },
                onRowsPerPageChanged: (value) {
                  setState(() {
                    _rowsPerPage = value!;
                  });
                  print("New Rows: $value");
                },
                rowCountApproximate: false,
                columns: <DataColumn>[
                  DataColumn(label: Text('View')),
                  DataColumn(label: Text('Edit')),
                  //DataColumn(label: Text('S.No')),

                  DataColumn(label: Text('Village')),
                  DataColumn(
                    label: Text('Farmer Name'),
                  ),
                  DataColumn(label: Text('Farmer Code')),
                ],
              ),

              // ),
              // ),
              flex: 7,
            ),
          ])),
        ),
      ),
    );
  }

  List<Widget> _getListings(BuildContext context) {
    List<Widget> listings = [];
    listings.add(
        txt_label_icon("Village", Colors.black, 14.0, true, Icons.location_on));
    listings.add(DropDownWithModel(
      itemlist: villageiteams,
      selecteditem: slctvillage,
      hint: "select village",
      onChanged: (value) {
        setState(() {
          slctfarmer = null;
          slctvillage = value!;
          val_village = slctvillage!.value;
          slctVillage = slctvillage!.name;
          farmerload(val_village);
        });
      },
    ));
    listings.add(farmerLoaded
        ? txt_label_icon("Farmer", Colors.black, 14.0, true, Icons.location_on)
        : Container());
    listings.add(farmerLoaded
        ? DropDownWithModel(
            itemlist: Farmeriteams,
            selecteditem: slctfarmer,
            hint: "select Farmer",
            onChanged: (value) {
              setState(() {
                slctfarmer = value!;
                val_farmer = slctfarmer!.value;
                slctFarmer = slctfarmer!.name;
                farmerloadvillage(val_farmer);
              });
            },
            onClear: () {
              slctFarmer = "";
            })
        : Container());

    // listings.add(ElevatedButton(
    //     onPressed: () {
    //       _exportToExcel();
    //     },
    //     child: Text('Export ')));
    return listings;
  }
}
