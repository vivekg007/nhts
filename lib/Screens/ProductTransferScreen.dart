import 'dart:math';

import 'package:flutter/services.dart';
import '../Database/Databasehelper.dart';
import '../Database/Model/FarmerMaster.dart';
import '../Model/Geoareascalculate.dart';
import '../Model/ProductTransferModel.dart';
import '../Model/Treelistmodel.dart';
import '../Model/UIModel.dart';
import '../Model/dynamicfields.dart';
import '../Plugins/TxnExecutor.dart';
import '../Utils/MandatoryDatas.dart';
import 'geoploattingProposedLand.dart';
import 'geoplottingaddfarm.dart';
import 'navigation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:horizontal_data_table/horizontal_data_table.dart';
import 'package:intl/intl.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../main.dart';
import 'navigation.dart';

class ProductTransfer extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ProductTransfer();
  }
}

class _ProductTransfer extends State<ProductTransfer> {
  /*Date of Transfer*/
  String transferDate = '', labeltransferDate = 'Select Transfer Date';
  String pructransfr = 'Product Transfer';
  String info = 'Information';
  String save = 'save';
  String submt = 'Submit';
  String AresurCancl = 'Are you sure want to cancel?';
  String AresurProcd = 'Are you sure want to proceed?';
  String Cancel = 'Cancel';
  String yes = 'Yes';
  String no = 'No';
  String ok = 'OK';
  String Cnfm = 'Confirmation';
  String Farmr = 'Farmer';
  String vrty = 'Variety';
  String grade = 'Grade';
  String drivr = 'Driver';
  String processcntrwhse = 'Processing Centre/Warehouse';
  String Slctprocesscntrwhse = 'Select the processing centre/warehouse';
  String trnsdate = 'Transfer Date';
  String trucknum = 'Truck Number';
  String farmerlst = 'Farmer List';
  String NofCrates = 'No. of crates';
  String transCrates = 'Transferred Crates';
  String transwght = 'Transferred Weight (Kgs)';
  String Grosswght = 'Gross Weight(Kgs)';
  String trasnsucc = 'Transaction Successful';
  String proctrnssuccrecpid =
      'Product Transfer Successful.\nYour receipt ID is ';
  String addproduct = 'Please Add Product';
  String Transfrdat = 'Transfer Date should not be empty';
  String proctrwrhuse = 'Processing Centre/Warehouse should not be empty';
  String trucknumemp = 'Truck Number should not be empty';
  String Drivemp = 'Driver  should not be empty';
  String Trsnafrcratemp = 'Transferred Crates should not be empty';
  String Trsnafrcratempty = 'Transferred Crates should not be Zero';
  String Trsnafrcralethcrats =
      'Transferred No. of crates should  be less than No. of crates ';
  bool productAlreadyAdded = false;
  bool listEdited = false;
  /*Processing Centre/Warehouse Dropdown*/
  List<DropdownMenuItem> prosCentreWhDropDownLists = [];
  String slctProsCentreWh = '', valProsCentreWh = '', slctProsCentreWhId = '';
  List<UImodel> prosCentreWhUIModel = [];

  List<DropdownModel> warehouseitems = [];
  DropdownModel? slctwarehouses ;

  /*Truck Number Field*/
  TextEditingController trckNumberController = new TextEditingController();

  /*Driver Name Field*/
  TextEditingController driverNameController = new TextEditingController();

  /*Group Name Dropdown*/
  List<DropdownMenuItem> groupNameDropDownLists = [];
  String slctGroupName = '',
      valGroupName = '',
      slctGroupNameId = '',
      productid = '';
  List<UImodel2> groupNameUIModel = [];

  /*Variety Name Dropdown*/
  List<DropdownMenuItem> varietyDropDownLists = [];
  String slctVariety = '', valVariety = '', slctVarietyId = '';
  List<UImodel> varietyUIModel = [];
  List<DropdownMenuItem> VarietyList = [];
  /*Product Name Dropdown*/
  List<DropdownMenuItem> productDropDownLists = [];
  String slctProduct = '', valProduct = '', slctProductId = '';
  List<UImodel> productUIModel = [];
  String avlnetwght = '', avlbags = '', netwght = '', bags = '';
  /*Available No. of Boxes/Bags Field*/
  TextEditingController avlNoOfBoxBagsController = new TextEditingController();
  String Farmername = "",
      Variety = "",
      NoCrats = "",
      Totwght = "",
      Transferwght = "";
  /*Available Net Weight (Kgs) Field*/
  TextEditingController avlNetWgtKgsController = new TextEditingController();

  /*Transferred No. of Bags Field*/
  TextEditingController transNoOfBoxBagsController =
      new TextEditingController();

  /*Transferred Net Weight (Kgs) Field*/
  //TextEditingController transNetWgtKgsController = new TextEditingController();

  /*Database*/
  var db = DatabaseHelper();

  /*Product Transfer New Model*/
  List<ProductTransferModel> productModelList = [];

  /*ClientDate*/
  List<Map> agents = [];
  String seasoncode = "";
  String servicePointId = "";
  String agentid = "";
  String timestamp = "";
  bool varityLoaded = false;
  bool productLoaded = false;
  /*Latitude&Longitude*/
  String Lat = "", Lng = "";

  /*InitState*/
  @override
  void initState() {
    super.initState();
    /*Call Method getClientDate()*/
    getClientData();
    translate();
    /*Call Method getLocation()*/
    getLocation();
    /*Call Method initdata()*/
    initdata();
  }

  /*getClientData() Method*/
  getClientData() async {
    agents = await db.RawQuery('SELECT * FROM agentMaster');
    seasoncode = agents[0]['currentSeasonCode'];
    servicePointId = agents[0]['servicePointId'];
    agentid = agents[0]['agentId'];
  }

  /*getLocation() Method */
  void getLocation() async {
    /*TimeStamp*/
    var now = new DateTime.now();
    var Timestamp = new DateFormat('ddMMyyyyHHmmss');
    timestamp = Timestamp.format(now);

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

  /*initdata() Method*/
  Future<void> initdata() async {
    /*Get Processing Centre/Warehouse Data From coOperative Table - Processing Centre/Warehouse Data*/
    String corptiveQry = "SELECT * from coOperative";
    List<Map> prosCentreWhList = await db.RawQuery(corptiveQry);
    //List<Map> prosCentreWhList = await db.GetTableValues('coOperative');
    prosCentreWhDropDownLists = [];
    warehouseitems.clear();
    print("prosCentreWhList.length " + prosCentreWhList.length.toString());

    if (prosCentreWhList.length > 0) {
      for (int i = 0; i < prosCentreWhList.length; i++) {
        String prosCentreWhId = prosCentreWhList[i]["coCode"].toString();
        String prosCentreWh = prosCentreWhList[i]["coName"].toString();

        var uiModel = new UImodel(prosCentreWh, prosCentreWhId);
        prosCentreWhUIModel.add(uiModel);

        setState(() {
          warehouseitems.add(DropdownModel(prosCentreWh,
            prosCentreWhId,
          ));
          //prooflist.add(property_value);
        });
      }
    } else {
      print(
          'There is no data from coOperative Table - Processing Centre/Warehouse Data');
    }

    /*Get Group Data From villageList(Temp) Table - Group Data*/
    String groupQry =
        'Select distinct  sam.samCode,sam.samName from samitee as sam inner join villageWarehouse as v on v.samcode =sam.samCode';
    List groupList = await db.RawQuery(groupQry);

    groupNameDropDownLists = [];
    groupNameUIModel.clear();

    if (groupList.length > 0) {
      for (int i = 0; i < groupList.length; i++) {
        String groupNameId = groupList[i]["samCode"].toString();
        String groupName = groupList[i]["samName"].toString();
        productid = groupList[i]["productId"].toString();
        var uiModel = new UImodel2(groupName, groupNameId, productid,"","","");
        groupNameUIModel.add(uiModel);

        setState(() {
          groupNameDropDownLists.add(DropdownMenuItem(
            child: Text(groupName),
            value: groupName,
          ));
        });
      }
    } else {
      print('There is no Group Data From villageList(Temp) Table - Group Data');
    }

    /* transNetWgtKgsController.addListener(() {
      caltotwght();
      // caltarewght();
      // amountcal();
    }); */
    displayProductlist();
  }

  changeVarietyReg(String grouphcode) async {
    List varietyList = await db.RawQuery(
        //'select distinct ver.vCode,ver.vName,v.productId from varietyList as ver inner join villageWarehouse as v on v.grade =ver.vCode where v.samcode =\'' +
        'select distinct ver.vCode,ver.vName,v.productId from varietyList as ver inner join villageWarehouse as v on v.productId = ver.prodId where v.productId =\'' +
            grouphcode +
            '\'');
    print('varietyList ' + varietyList.toString());
    varietyUIModel = [];
    VarietyList = [];
    VarietyList.clear();
    for (int i = 0; i < varietyList.length; i++) {
      String property_value = varietyList[i]["vCode"].toString();
      String DISP_SEQ = varietyList[i]["vName"].toString();
      var uimodel = new UImodel(DISP_SEQ, property_value);
      varietyUIModel.add(uimodel);
      setState(() {
        VarietyList.add(DropdownMenuItem(
          child: Text(DISP_SEQ),
          value: DISP_SEQ,
        ));
      });

      Future.delayed(Duration(milliseconds: 500), () {
        //print("State_delayfunction" + DISP_SEQ);
        setState(() {
          if (varietyList.length > 0) {
            slctVariety = '';
            varityLoaded = true;
          }
        });
      });
    }
  }

  changeproductReg(String vertycode) async {
    List productList = await db.RawQuery(
        'select distinct prd.code,prd.name from procurementProducts as prd inner join villageWarehouse as v on v.productId =prd.code inner join varietyList as ver on ver.prodId =prd.code where v.samcode =\'' +
            vertycode +
            '\'');
    print('productList ' + productList.toString());
    productDropDownLists = [];
    productUIModel.clear();
    for (int i = 0; i < productList.length; i++) {
      String productId = productList[i]["code"].toString();
      String productName = productList[i]["name"].toString();

      var uiModel = new UImodel(productName, productId);
      productUIModel.add(uiModel);
      setState(() {
        productDropDownLists.add(DropdownMenuItem(
          child: Text(productName),
          value: productId,
        ));
      });
      Future.delayed(Duration(milliseconds: 500), () {
        print("State_delayfunction" + productId);
        setState(() {
          if (productList.length > 0) {
            slctProduct = '';
            productLoaded = true;
          }
        });
      });
    }
  }

  changeval(String productId, String groupid, String varietyid) async {
    avlNoOfBoxBagsController.text = "";
    avlNetWgtKgsController.text = "";
    //  toast(varietyid);
    List changevalList = await db.RawQuery(
        'select distinct noOfBags,grossWeight from villageWarehouse  where productId =\'' +
            productId +
            '\' and samcode = \'' +
            groupid +
            '\' and grade = \'' +
            varietyid +
            '\'');
    print('productList ' + changevalList.toString());
    for (int i = 0; i < changevalList.length; i++) {
      avlNoOfBoxBagsController.text = changevalList[i]["noOfBags"].toString();
      avlNetWgtKgsController.text = changevalList[i]["grossWeight"].toString();
    }
  }

  void translate() async {
    try {
      String? Lang = '';
      try {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        Lang = prefs.getString("langCode");
      } catch (e) {
        Lang = 'en';
      }
      String qry =
          'select * from labelNamechange where tenantID =  \'cediam\' and lang = \'' +
              Lang! +
              '\'';

      print('Lanquery' + qry);
      List transList = await db.RawQuery(qry);
      print('translist:' + transList.toString());
      for (int i = 0; i < transList.length; i++) {
        String classname = transList[i]['className'];
        String labelName = transList[i]['labelName'];
        switch (classname) {
          case "prductrnsuc":
            setState(() {
              proctrnssuccrecpid = labelName;
            });
            break;
          case "transactionsuccesfull":
            setState(() {
              trasnsucc = labelName;
            });
            break;
          case "yes":
            setState(() {
              yes = labelName;
            });
            break;
          case "no":
            setState(() {
              no = labelName;
            });
            break;

          case "Cancel":
            setState(() {
              Cancel = labelName;
            });
            break;
          case "rusurecancel":
            setState(() {
              AresurCancl = labelName;
            });
            break;
          case "confirm":
            setState(() {
              Cnfm = labelName;
            });
            break;
          case "ArewntPrcd":
            setState(() {
              AresurProcd = labelName;
            });
            break;
          case "save":
            setState(() {
              save = labelName;
            });
            break;
          case "info":
            setState(() {
              info = labelName;
            });
            break;
          case "farmer":
            setState(() {
              Farmr = labelName;
            });
            break;
          case "Variety":
            setState(() {
              vrty = labelName;
            });
            break;
          case "Grade":
            setState(() {
              grade = labelName;
            });
            break;
          case "submit":
            setState(() {
              submt = labelName;
            });
            break;
          case "producttransfer":
            setState(() {
              pructransfr = labelName;
            });
            break;
          case "transferdat":
            setState(() {
              trnsdate = labelName;
            });
            break;
          case "Slcttransferdat":
            setState(() {
              labeltransferDate = labelName;
            });
            break;
          case "trunum":
            setState(() {
              trucknum = labelName;
            });
            break;
          case "driv":
            setState(() {
              drivr = labelName;
            });
            break;
          case "procentrwarehse":
            setState(() {
              processcntrwhse = labelName;
            });
            break;
          case "Slctprcwrhuse":
            setState(() {
              Slctprocesscntrwhse = labelName;
            });
            break;
          case "farmerlist":
            setState(() {
              farmerlst = labelName;
            });
            break;
          case "NoCrates":
            setState(() {
              NofCrates = labelName;
            });
            break;
          case "grosswght":
            setState(() {
              Grosswght = labelName;
            });
            break;
          case "trsncrates":
            setState(() {
              transCrates = labelName;
            });
            break;
          case "trswght":
            setState(() {
              transwght = labelName;
            });
            break;
          case "addprct":
            setState(() {
              addproduct = labelName;
            });
            break;
          case "trsfrdate":
            setState(() {
              Transfrdat = labelName;
            });
            break;
          case "prcenwremp":
            setState(() {
              proctrwrhuse = labelName;
            });
            break;
          case "truckemp":
            setState(() {
              trucknumemp = labelName;
            });
            break;
          case "drivremp":
            setState(() {
              Drivemp = labelName;
            });
            break;
          case "trafrcrtasemp":
            setState(() {
              Trsnafrcratemp = labelName;
            });
            break;
          case "Trsfrcratesempty":
            setState(() {
              Trsnafrcratempty = labelName;
            });
            break;
          case "Trsfrlethcrats":
            setState(() {
              Trsnafrcralethcrats = labelName;
            });
            break;
          case "ok":
            setState(() {
              ok = labelName;
            });
            break;
        }
      }
    } catch (e) {
      print('translation err' + e.toString());
      //toast(e.toString());
    }
  }

  /*onBackPressedMethod*/
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

  /*GetListingsMethod*/
  List<Widget> _getListings(BuildContext context) {
    List<Widget> listings = [];

    /*Harvest Date*/
    /*Label*/
    listings.add(txt_label_mandatory(trnsdate, Colors.black, 14.0, false));
    /*Date*/
    listings.add(selectDate(
      context1: context,
      slctdate: labeltransferDate,
      onConfirm: (date) => setState(() {
        transferDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(date!);
        labeltransferDate = DateFormat('yyyy-MM-dd').format(date!);
      }),
    ));

    /*Truck Number*/
    /*Label*/
    listings.add(txt_label_mandatory(trucknum, Colors.black, 14.0, false));
    /*Field*/
    listings.add(txtfield_dynamic(trucknum, trckNumberController, true));

    /*Driver Name*/
    /*Label*/
    listings.add(txt_label_mandatory(drivr, Colors.black, 14.0, false));
    /*Field*/
    listings.add(txtfield_dynamic(drivr, driverNameController, true));
    /*Processing Centre/Warehouse Dropdown*/
    /*Label*/
    listings
        .add(txt_label_mandatory(processcntrwhse, Colors.black, 14.0, false));
    /*Dropdown*/
  /*  listings.add(singlesearchDropdown(
        itemlist: prosCentreWhDropDownLists,
        hint: Slctprocesscntrwhse,
        selecteditem: slctProsCentreWh,
        onChanged: (value) {
          setState(() {
            slctProsCentreWh = value!;

            for (int i = 0; i < prosCentreWhUIModel.length; i++) {
              if (slctProsCentreWh == prosCentreWhUIModel[i].name) {
                slctProsCentreWhId = prosCentreWhUIModel[i].value;
                print('slctProsCentreWh: ' +
                    slctProsCentreWh +
                    slctProsCentreWhId);
              }
            }
          });
        },
        onClear: () {
          setState(() {
            slctProsCentreWh = '';
          });
        }));  */

    listings.add(DropDownWithModel(
        itemlist: warehouseitems,
        selecteditem: slctwarehouses,
        hint: Slctprocesscntrwhse,
        onChanged: (value) {
          setState(() {
            slctwarehouses = value!;
            //toast(slctFarmers!.value);
            slctProsCentreWhId = slctwarehouses!.value;
            slctProsCentreWh = slctwarehouses!.name;

            /* for (int i = 0; i < farmerlistUIModel.length; i++) {
              if (farmerlistUIModel[i].value == farmerId) {
                farmerAddress = farmerlistUIModel[i].value2;
              }
            } */
          });
        },
        onClear: () {
          setState(() {
            slctProsCentreWh = '';
          });
        }
    ));


    listings.add(
      Container(
          child: InkWell(
        child: Row(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(left: 150.0, right: 10.0, top: 10.0),
              child: Text(
                farmerlst,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.green,
                ),
              ),
            ),
          ],
        ),
      )),
    );
    listings.add(
      Container(
        padding: EdgeInsets.only(top: 5),
        child: Divider(
          color: Colors.black,
          height: 1,
        ),
      ),
    );
    if (productModelList != '' && productModelList.length > 0) {
      listings.add(DatatableProductTransfer());
    }
    /*Label*/
    /*  listings.add(txt_label_mandatory(
        transCrates, Colors.black, 14.0, false));
    /*Field*/
    listings.add(txtfield_dynamic(
        transCrates, transNetWgtKgsController, true)); */
    /*listings.add(txt_label(
        transwght, Colors.black, 14.0, false));
    listings.add(txt_label(Transferwght, Colors.black, 14.0, false)); */
    /*Add, Submit & Cancel Button*/
    listings.add(Container(
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Container(
              padding: EdgeInsets.all(3),
              child: RaisedButton(
                child: Text(
                  Cancel,
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
                  submt,
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

  /*Product Transfer Datatable*/
  Widget DatatableProductTransfer() {
    // product[];
    List<DataColumn> columns = [];
    List<DataRow> rows = [];

    /*Columns*/
    //columns.add(DataColumn(label: Text('S.No')));
    //columns.add(DataColumn(label: Text('Processing Centre/Warehouse')));
    columns.add(DataColumn(label: Text(Farmr)));
    columns.add(DataColumn(label: Text(vrty)));
    columns.add(DataColumn(label: Text(grade)));
    columns.add(DataColumn(label: Text(NofCrates)));
    columns.add(DataColumn(label: Text(Grosswght)));
    columns.add(DataColumn(label: Text(transCrates)));
    columns.add(DataColumn(label: Text(transwght)));

    // columns.add(DataColumn(label: Text('Delete')));
    /*Rows*/
    for (int i = 0; i < productModelList.length; i++) {
      int rowno = i + 1;
      String Sno = rowno.toString();
      List<DataCell> singlecell = [];

      singlecell.add(DataCell(Text(productModelList[i].farmerName)));
      singlecell.add(DataCell(Text(productModelList[i].variety)));
      singlecell.add(DataCell(Text(productModelList[i].grade)));
      singlecell.add(DataCell(Text(productModelList[i].avlNoOfBoxBags)));
      /*TextEditingController controller1 = new TextEditingController();
      controller1.text = productModelList[i].avlNoOfBoxBags;
     singlecell.add(DataCell(
          TextFormField(
            controller: controller1,
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(4),
            ],
            onFieldSubmitted: (val) {
              setState(() {});
            },
          ),
          showEditIcon: false));*/
      singlecell.add(DataCell(Text(productModelList[i].avlNetWgtKgs)));
      // singlecell.add(DataCell(Text(weightlist[i].WghFlot )));
      TextEditingController transNetWgtKgsController =
          new TextEditingController();

      if (transNetWgtKgsController.text == "" && !productModelList[i].edited) {
        transNetWgtKgsController.text = productModelList[i].avlNoOfBoxBags;
        productModelList[i].transNoOfBoxBags =
            productModelList[i].avlNoOfBoxBags;
        productModelList[i].transNetWgtKgs = productModelList[i].avlNetWgtKgs;
      } else {
        transNetWgtKgsController.text = productModelList[i].transNoOfBoxBags;
      }
      transNetWgtKgsController.selection = TextSelection.fromPosition(
          TextPosition(offset: transNetWgtKgsController.text.length));
      singlecell.add(DataCell(
        TextField(
          controller: transNetWgtKgsController,
          keyboardType: TextInputType.number,

          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(10),
          ],
          //obscureText: true,
          onChanged: (val) {
            bool nrtwght = false;
            productModelList[i].edited = true;
            var AvlntWght, TrnsfrntWght;
            AvlntWght = productModelList[i].avlNoOfBoxBags;
            TrnsfrntWght = val;
            print("avlNetWgtKgs" +
                productModelList[i].avlNoOfBoxBags +
                "val" +
                val);
            if ((val != '0' && val != '') &&
                (num.parse(productModelList[i].avlNoOfBoxBags) <
                    num.parse(val))) {
              nrtwght = true;
            } else {
              nrtwght = false;
            }

            print("vallll$val");
            /* if (val == '0' || val == '') {
              errordialog(context, info, Trsnafrcratempty);
              transNetWgtKgsController.text = '';
            } else*/
            if (nrtwght == true) {
              errordialog(context, info, Trsnafrcralethcrats);
              transNetWgtKgsController.text = '';
            } else {
              productModelList[i].transNoOfBoxBags = val;
              print("transNoOfBoxBags" + productModelList[i].transNoOfBoxBags);
              setState(() {
                if (transNetWgtKgsController.text.length > 0) {
                  changewght(productModelList[i].transNoOfBoxBags, i);
                } else {
                  setState(() {
                    productModelList[i].transNetWgtKgs = "";
                  });
                }
              });
            }
          },
        ),
      ));

      singlecell.add(DataCell(Text(productModelList[i].transNetWgtKgs)));
      rows.add(DataRow(
        cells: singlecell,
      ));
    }

    Widget objWidget = datatable_dynamic(columns: columns, rows: rows);
    return objWidget;
  }

  changewght(String calval, int recno) {
    setState(() {
      productModelList[recno].transNetWgtKgs = "";
      if (calval.length > 0) {
        var weight = num.parse(calval);
        var valcalcontroller = (weight * 14);
        productModelList[recno].transNetWgtKgs = valcalcontroller.toString();
      }
    });
  }

  displayProductlist() async {
    List FarmerList = await db.RawQuery(
        'SELECT  distinct vill.farmerId,vill.fName,vill.lName,vill.villageId,vill.samithiCode,proc.grade,proc.gradeCode,vWare.productId,ver.vCode,ver.vName,vWare.grossWeight,vWare.noOfBags from farmer_master as vill INNER JOIN villageWarehouse as vWare ON vill.farmerId=vWare.farmerId INNER JOIN varietyList as ver ON vWare.samcode = ver.vCode INNER JOIN procurementGrade as proc ON proc.gradeCode=vWare.grade');
    for (int i = 0; i < FarmerList.length; i++) {
      var productTransferValues = new ProductTransferModel(
          transferDate,
          slctProsCentreWhId,
          slctProsCentreWh,
          trckNumberController.text,
          driverNameController.text,
          FarmerList[i]["villageId"].toString(),
          FarmerList[i]["gradeCode"].toString(),
          FarmerList[i]["farmerId"].toString(),
          FarmerList[i]["fName"].toString(),
          FarmerList[i]["vCode"].toString(),
          FarmerList[i]["vName"].toString(),
          FarmerList[i]["grade"].toString(),
          FarmerList[i]["productId"].toString(),
          "",
          FarmerList[i]["noOfBags"].toString(),
          FarmerList[i]["grossWeight"].toString(),
          "",
          Transferwght,
          false);
      productModelList.add(productTransferValues);
    }
  }

  /*Widget*/
  @override
  Widget build(BuildContext context) {
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
            },
          ),
          title: Text(
            pructransfr,
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
          child: Column(
            children: <Widget>[
              Expanded(
                child: ListView(
                  padding: EdgeInsets.all(10.0),
                  children: _getListings(context),
                ),
                flex: 8,
              ),
            ],
          ),
        ),
      ),
    ));
  }

  /*btnAdd() Method*/
  void btnAdd() {
    /*Validation Process*/
    bool bags = false;
    bool nrtwght = false;
    try {
      var AvlBags, TrsfrBag, AvlntWght, TrnsfrntWght;
      AvlBags = num.parse(avlNoOfBoxBagsController.text);
      TrsfrBag = num.parse(transNoOfBoxBagsController.text);
      AvlntWght = num.parse(avlNoOfBoxBagsController.text);
      //TrnsfrntWght = num.parse(transNetWgtKgsController.text);
      if (AvlBags < TrsfrBag) {
        bags = true;
      } else {
        bags = false;
      }
      if (AvlntWght < TrnsfrntWght) {
        nrtwght = true;
      } else {
        nrtwght = false;
      }
    } catch (e) {}

    if (transferDate.length == 0) {
      AlertPopup(Transfrdat);
    } else if (trckNumberController.text.length == 0) {
      AlertPopup("Truck Number should not be empty");
    } else if (driverNameController.text.length == 0) {
      AlertPopup("Driver  should not be empty");
    } else if (productAlreadyAdded == true) {
      AlertPopup("Product name already added update the list");
      avlNoOfBoxBagsController.text = "";
      avlNetWgtKgsController.text = "";
      driverNameController.text = "";
      trckNumberController.text = "";
      slctGroupName = '';
      slctVariety = '';
      slctProduct = '';
      transNoOfBoxBagsController.text = "";
      // transNetWgtKgsController.text = "";
    } else {}
  }

  /*btnCancel Method*/
  void btncancel() {
    Alert(
      context: context,
      type: AlertType.warning,
      title: Cancel,
      desc: AresurCancl,
      buttons: [
        DialogButton(
          child: Text(
            yes,
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
            no,
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

  /*AlertPopUp*/
  void AlertPopup(String message) {
    Alert(
      context: context,
      type: AlertType.warning,
      title: info,
      desc: message,
      buttons: [
        DialogButton(
          child: Text(
            ok,
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

  /*btnSubmit Method*/
  btnSubmit() async {
    // product[];
    bool bags = false;
    bool nrtwght = false;
    for (int i = 0; i < productModelList.length; i++) {
      String netWeight = productModelList[i].avlNetWgtKgs;
      String avlNoOfBags = productModelList[i].avlNoOfBoxBags;
      avlbags = avlNoOfBags;
      avlnetwght = netWeight;
      if (productModelList[i].transNoOfBoxBags != "") {
        if (int.parse(productModelList[i].transNoOfBoxBags) > 0) {
          bags = true;
          break;
        }
      }
    }
    /*try {
      var AvlBags, TrsfrBag, AvlntWght, TrnsfrntWght;
      AvlBags = avlbags;
      // TrsfrBag = num.parse(transNetWgtKgsController.text);
      AvlntWght = avlnetwght;
      TrnsfrntWght = Transferwght;
      if (AvlBags < TrsfrBag) {
        bags = true;
      } else {
        bags = false;
      }
      if (AvlntWght < TrnsfrntWght) {
        nrtwght = true;
      } else {
        nrtwght = false;
      }
    } catch (e) {}*/
    if (productModelList.length <= 0) {
      AlertPopup(addproduct);
    } else if (transferDate.length == 0) {
      AlertPopup(Transfrdat);
    } else if (slctProsCentreWh == '' || slctProsCentreWh.length == 0) {
      AlertPopup(proctrwrhuse);
    } else if (trckNumberController.text.length == 0) {
      AlertPopup(trucknumemp);
    } else if (driverNameController.text.length == 0) {
      AlertPopup(Drivemp);
      /* }  else if (transNetWgtKgsController.text.length == 0) {
      AlertPopup(Trsnafrcratemp);
    } else if (transNetWgtKgsController.text == "0") {
      AlertPopup(Trsnafrcratempty);
    } else if (bags == true) {
      AlertPopup(Trsnafrcralethcrats); */
    } else {
      if (bags) {
        confirmationPopup();
      } else {
        AlertPopup(addproduct);
      }
    }
  }

  /*confirmationPopUp Method*/

  void confirmationPopup() {
    Alert(
      context: context,
      type: AlertType.warning,
      title: Cnfm,
      desc: AresurProcd,
      buttons: [
        DialogButton(
          child: Text(
            yes,
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () {
            /*Call Save Product Tranfser Data Method*/
            //product[];
            saveProductTransferData();
            Navigator.pop(context);
          },
          width: 120,
        ),
        DialogButton(
          child: Text(
            no,
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

  /*Save Product Tranfser Data*/
  saveProductTransferData() async {
    /*TxnHeader*/
    final now = new DateTime.now();
    String txntime = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
    String msgNo = DateFormat('yyyyMMddHHmmss').format(now);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? agentid = prefs.getString("agentId");
    String? agentToken = prefs.getString("agentToken");

    Random rnd = new Random();
    int revNo = 100000 + rnd.nextInt(999999 - 100000);

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
        txntime, appDatas.txnProductTransfer, revNo.toString(), '', '', '');

    /*Values*/
    String transDate = transferDate;
    String truckNumber = trckNumberController.text;
    String driverName = driverNameController.text;
    String processingCentreWh = slctProsCentreWhId;
    String isSynched = '1';
    String mtntDate = txntime;
    String mtntTxnNo = appDatas.txnProductTransfer;
    String season = seasoncode;
    String totBags = "";
    String totGrossWeight = "";
    String totTareWeight = "";
    String totNetWeight = "";

    /*Saving values to mtnt Table*/
    int productSave = await db.SaveProductTransfer(
        revNo.toString(),
        revNo.toString(),
        totBags,
        totGrossWeight,
        totTareWeight,
        totNetWeight,
        isSynched,
        transDate,
        processingCentreWh,
        "",
        //ptDate
        truckNumber,
        driverName,
        "",
        //dvrMob
        processingCentreWh,
        //coCode
        season,
        Lng,
        Lat,
        "",
        //labourCost
        "",
        //transportCost
        "",
        //receiverType
        "",
        //totalAmount
        "",
        //invoiceNo
        mtntTxnNo);

    print('ProductSaved: ' + productSave.toString());

    print("productModelList" + productModelList.length.toString());
    /*Saving values to mtntDetails Table*/
    for (int i = 0; i < productModelList.length; i++) {
      String productCode = productModelList[i].productId;
      String mtntId = revNo.toString();
      String noOfBags = productModelList[i].transNoOfBoxBags;
      print("transNoOfBoxBags" + productModelList[i].transNoOfBoxBags);
      String grossWeight = productModelList[i].transNetWgtKgs;
      print("transNoOfBoxBags1" + productModelList[i].transNetWgtKgs);
      String netWeight = productModelList[i].avlNetWgtKgs;
      String villageCode = productModelList[i].groupNameId;
      String GradeCode = productModelList[i].groupName;
      String farmerid = productModelList[i].farmerId;
      String gCode = productModelList[i].varietyId;
      String grade = productModelList[i].groupName;
      String avlNoOfBags = productModelList[i].avlNoOfBoxBags;
      valVariety = productModelList[i].varietyId;
      avlbags = avlNoOfBags;
      avlnetwght = netWeight;
      //netwght = grossWeight;
      // bags = noOfBags;
      print("transNoOfBoxBags" +
          productModelList[i].transNoOfBoxBags +
          "transNetWgtKgs" +
          productModelList[i].transNetWgtKgs +
          "avlNetWgtKgs" +
          productModelList[i].avlNetWgtKgs +
          "avlNoOfBoxBags" +
          productModelList[i].avlNoOfBoxBags);
      print("noOfBags" + noOfBags + "noOfBags" + Transferwght);
      if (noOfBags != "0" && noOfBags != "") {
        int productTransfer = await db.SaveProductTransferDetail(
          productCode,
          mtntId,
          noOfBags,
          grossWeight,
          "",
          //mode
          valVariety,
          avlNoOfBags,
          //tareWeight
          netWeight,
          //netWeight
          GradeCode,
          //Variety
          "",
          //unitSelCost
          "",
          //UOM
          "",
          //totSelCost
          "",
          //batchNo
          farmerid, //farmerId
        );
        print(productTransfer);
      }
      //  int numberOfBags=int.parse(avlbags) ;
      // int netWeightKgs=int.parse(avlnetwght);
      // int NOBAGG=0;
      //int  NOBAGG= numberOfBags-num.parse(transNetWgtKgsController.text);
      /*   String villageWar = 'UPDATE villageWarehouse SET noOfBags =\'' +
          noOfBags +
          '\' and grossWeight =\'' +
          grossWeight +
          '\' WHERE samcode =\'' +
          valVariety +
          '\' and productId =\'' +
          farmerid +
          '\' and farmerId =\'' +
          productCode +
          '\' and grade =\'' +
          grade +
          '\'';
      List<Map> villageWarehouse = await db.RawQuery(villageWar);
      print("villageWar: " + villageWar.toString());
      print("villageWarehouse: " + villageWarehouse.toString());*/
    }

    int issync = await db.UpdateTableValue(
        'mtnt', 'isSynched', '0', 'recNo', revNo.toString());
    print("isSynched: " + issync.toString());
    TxnExecutor txnExecutor = new TxnExecutor();
    txnExecutor.CheckCustTrasactionTable();

    /*Alert*/
    Alert(
      context: context,
      type: AlertType.info,
      title: trasnsucc,
      desc: proctrnssuccrecpid+" " + revNo.toString(),
      buttons: [
        DialogButton(
          child: Text(
            ok,
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
}

class ProductModel {
  String gradeCode;
  String prodId;
  String prodName;
  String grade;
  String price;
  String vCode;
  String vName;
  String NoofBags;
  String NetWeight;

  ProductModel(
    this.gradeCode,
    this.prodId,
    this.prodName,
    this.grade,
    this.price,
    this.vCode,
    this.vName,
    this.NoofBags,
    this.NetWeight,
  );
}
