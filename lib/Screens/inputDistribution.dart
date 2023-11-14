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
import 'navigation.dart';

class InputDistribution extends StatefulWidget {
  const InputDistribution({Key? key}) : super(key: key);

  @override
  State<InputDistribution> createState() => _InputDistributionState();
}

class _InputDistributionState extends State<InputDistribution> {
  String Lat = '0', Lng = '0';
  String seasoncode = '';
  String servicePointId = '';
  String agendId = '';
  var db = DatabaseHelper();
  List<Map> agents = [];

  String registrationDate = "", registrationFormatedDate = "";

  //name of organization
  List<DropdownModel> nameOrganizationitems = [];
  DropdownModel? slctNameOrganization;
  String slct_NameOrganization = "";
  String val_NameOrganization = "";

  List<DropdownModel> coffeetypeitems = [];
  DropdownModel? slctCoffeeType;
  String slct_CoffeeType = "";
  String val_CoffeeType = "";

  List<DropdownMenuItem> districtitems = [],
      cityitems = [],
      countryitems = [],
      stateitems = [],
      ditrictitems = [],
      talukitems = [],
      villageitems = [];

  List<UImodel> countryUIModel = [];
  List<UImodel> stateUIModel = [];
  List<UImodel> districtUIModel = [];
  List<UImodel> cityListUIModel = [];
  List<UImodel> VillageListUIModel = [];

  bool stateLoaded = false;
  bool districtLoaded = false;
  bool cityLoaded = false;
  bool villageLoaded = false;
  bool farmerloaded = false;

  List<DropdownModel> farmeritems = [];
  DropdownModel? slctFarmers;
  String slct_farmer = "",
      farmerId = "",
      farmerAge = "",
      frmGender = '',
      frmMob = '',
      frmNin = '';
  List<UImodel5> farmerlistUIModel = [];

  //name of crop
  List<DropdownModel> namecropitems = [];
  DropdownModel? slctNameCrop;
  String slct_NameCrop = "";
  String val_NameCrop = "";

  String slctCountry = "",
      slctState = "",
      slctDistrict = "",
      slctTaluk = "",
      slctVillage = "",
      villageList = '';

  String val_farmerType = "",
      val_Country = "",
      val_State = "",
      val_District = "",
      val_Taluk = "",
      val_Village = "",
      villageName = '';

  TextEditingController demandQan = new TextEditingController();
  TextEditingController distributeQan = new TextEditingController();

  List<InputDetail> inputDetailList = [];

  @override
  void initState() {
    super.initState();

    getClientData();
    getLocation();
    loadFarmerOrganisation();
    loadCountry();

    distributeQan.addListener(() {
      if (distributeQan.text.isNotEmpty && demandQan.text.isNotEmpty) {
        if (double.parse(distributeQan.text) > double.parse(demandQan.text)) {
          errordialog(context, TranslateFun.langList['infoCls'],
              "Distributed Quantity should not be greater than Demand Quantity");
          distributeQan.clear();
        }
      }
    });
  }

  Future<void> loadProduct(String inputType) async {
    List cropList = await db.RawQuery(
        'select distinct productCode,productName from inputType where categoryCode = \'' +
            inputType +
            '\'  ');
    print(' productList' + cropList.toString());

    namecropitems.clear();
    for (int i = 0; i < cropList.length; i++) {
      String typurchseCode = cropList[i]["productCode"].toString();
      String typurchseName = cropList[i]['productName'].toString();
      var uimodel = new UImodel(typurchseName, typurchseCode);

      setState(() {
        namecropitems.add(DropdownModel(
          typurchseName,
          typurchseCode,
        ));
      });
    }
  }

  Future<void> loadFarmerOrganisation() async {
    List nameOrgList = await db.RawQuery('select * from coOperative');
    print(' nameOrgList' + nameOrgList.toString());

    nameOrganizationitems.clear();
    for (int i = 0; i < nameOrgList.length; i++) {
      String typurchseName = nameOrgList[i]["coName"].toString();
      String typurchseCode = nameOrgList[i]["coCode"].toString();

      var uimodel = new UImodel(typurchseName, typurchseCode);

      setState(() {
        nameOrganizationitems.add(DropdownModel(
          typurchseName,
          typurchseCode,
        ));
      });
    }
  }

  Future<void> loadInputType(String farmerId) async {
    List coffeetypeList = await db.RawQuery(
        'select distinct inputType from inputDemandList where farmerId =\'' +
            farmerId +
            '\' ');
    print(' inputType' + coffeetypeList.toString());

    coffeetypeitems.clear();
    for (int i = 0; i < coffeetypeList.length; i++) {
      String typurchseCode = coffeetypeList[i]["inputType"].toString();

      List inputNameList = await db.RawQuery(
          'select categoryName from inputType where categoryCode =\'' +
              typurchseCode +
              '\' ');
      print(' inputType' + coffeetypeList.toString());

      String typurchseName = inputNameList[i]['categoryName'].toString();
      var uimodel = new UImodel(typurchseName, typurchseCode);

      setState(() {
        coffeetypeitems.add(DropdownModel(
          typurchseName,
          typurchseCode,
        ));
      });
    }
  }

  Future<void> loadCountry() async {
    List countrylist = await db.RawQuery('select * from countryList');
    print('countryList ' + countrylist.toString());
    countryUIModel = [];
    countryitems.clear();
    for (int i = 0; i < countrylist.length; i++) {
      String countryCode = countrylist[i]["countryCode"].toString();
      String countryName = countrylist[i]["countryName"].toString();

      var uimodel = UImodel(countryName, countryCode);
      countryUIModel.add(uimodel);
      setState(() {
        countryitems.add(DropdownMenuItem(
          child: Text(countryName),
          value: countryName,
        ));
      });
    }
  }

  Future<void> changeDistrict(String stateCode) async {
    //districtlist
    List districtlist = await db.RawQuery(
        'select * from districtList where stateCode =\'' + stateCode + '\'');
    print('districtlist_farmerEnrollment' + districtlist.toString());
    districtUIModel = [];
    districtitems = [];
    districtitems.clear();
    for (int i = 0; i < districtlist.length; i++) {
      String stateCode = districtlist[i]["stateCode"].toString();
      String districtName = districtlist[i]["districtName"].toString();
      String districtCode = districtlist[i]["districtCode"].toString();

      var uimodel = UImodel(districtName, districtCode);
      districtUIModel.add(uimodel);
      setState(() {
        districtitems.add(DropdownMenuItem(
          child: Text(districtName),
          value: districtName,
        ));
      });

      Future.delayed(Duration(milliseconds: 500), () {
        print("district_delayfunction" + districtName);
        setState(() {
          if (districtlist.isNotEmpty) {
            districtLoaded = true;
            slctDistrict = "";
          }
        });
      });
    }
  }

  Future<void> changeCity(String districtCode) async {
    //cityList
    List cityList = await db.RawQuery(
        'select * from cityList where districtCode =\'' + districtCode + '\'');
    print('cityList_farmerEnrollment' + cityList.toString());
    cityListUIModel = [];
    cityitems = [];
    cityitems.clear();
    for (int i = 0; i < cityList.length; i++) {
      String cityName = cityList[i]["cityName"].toString();
      String cityCode = cityList[i]["cityCode"].toString();

      var uimodel = UImodel(cityName, cityCode);
      cityListUIModel.add(uimodel);
      setState(() {
        cityitems.add(DropdownMenuItem(
          child: Text(cityName),
          value: cityName,
        ));
      });

      Future.delayed(const Duration(milliseconds: 500), () {
        print("functioncity_delay" + cityName);
        setState(() {
          if (cityList.isNotEmpty) {
            cityLoaded = true;
            slctTaluk = "";
          }
        });
      });
    }
  }

  Future<void> changeVillage(String Code) async {
    //villagelist
    print('' + 'select * from villageList where cityCode =\'' + Code + '\'');
    List villagelist = await db.RawQuery(
        'select * from villageList where gpCode =\'' + Code + '\'');
    print('villagelistFarmerEnrollment' + villagelist.toString());
    VillageListUIModel = [];
    villageitems = [];
    villageitems.clear();
    for (int i = 0; i < villagelist.length; i++) {
      String villCode = villagelist[i]["villCode"].toString();
      String villName = villagelist[i]["villName"].toString();

      var uimodel = UImodel(villName, villCode);
      VillageListUIModel.add(uimodel);
      setState(() {
        villageitems.add(DropdownMenuItem(
          child: Text(villName),
          value: villName,
        ));
      });

      Future.delayed(const Duration(milliseconds: 500), () {
        print("villageloaeddealy" + villName);
        setState(() {
          if (villageList.isNotEmpty) {
            slctVillage = "";
            villageLoaded = true;
          }
        });
      });
    }
  }

  Future<void> ChangeStates(String countrycode) async {
    List statelist = await db.RawQuery(
        'select * from stateList where countryCode =\'' + countrycode + '\'');
    print('stateList ' + statelist.toString());
    stateUIModel = [];
    stateitems = [];
    stateitems.clear();
    for (int i = 0; i < statelist.length; i++) {
      String countryCode = statelist[i]["countryCode"].toString();
      String stateCode = statelist[i]["stateCode"].toString();
      String stateName = statelist[i]["stateName"].toString();

      var uimodel = UImodel(stateName, stateCode);
      stateUIModel.add(uimodel);
      setState(() {
        stateitems.add(DropdownMenuItem(
          child: Text(stateName),
          value: stateName,
        ));
        //stateList.add(stateName);
      });

      Future.delayed(Duration(milliseconds: 500), () {
        print("State_delayfunction" + stateName);
        setState(() {
          if (statelist.isNotEmpty) {
            slctState = "";
            stateLoaded = true;
          }
        });
      });
    }
  }

  getClientData() async {
    agents = await db.RawQuery('SELECT * FROM agentMaster');

    print("agent_master:" + agents.toString());

    seasoncode = agents[0]['currentSeasonCode'];
    servicePointId = agents[0]['servicePointId'];
    agendId = agents[0]['agentId'];
    String resIdd = agents[0]['resIdSeqAgg'];
    //print("resIdgetcliendata" + resIdd);
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
                TranslateFun.langList['okCls'],
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
  void dispose() {
    super.dispose();
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
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () {
                  // Navigator.of(context).pop();

                  _onBackPressed();
                }),
            title: Text(
              'Input Distribution',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 18.0,
                  fontWeight: FontWeight.w700),
            ),
            iconTheme: const IconThemeData(color: Colors.white),
            backgroundColor: Colors.green,
            brightness: Brightness.light,
          ),
          body: Stack(
            children: [
              Container(
                  child: Column(children: <Widget>[
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.all(10.0),
                    children: _getListings(
                        context), // <<<<< Note this change for the return type
                  ),
                  flex: 8,
                ),
              ])),
              // Positioned(
              //   child: _progressHUD,
              // ),
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
        slctdate: registrationDate,
        onConfirm: (date) => setState(
              () {
                registrationDate = DateFormat('dd/MM/yyyy').format(date!);
                registrationFormatedDate = DateFormat('yyyyMMdd').format(date);
              },
            )));

    listings.add(txt_label_mandatory(
        TranslateFun.langList['frOrgCls'], Colors.black, 14.0, false));
    listings.add(DropDownWithModel(
      itemlist: nameOrganizationitems,
      selecteditem: slctNameOrganization,
      hint: TranslateFun.langList['slctFrOrgCls'],
      onChanged: (value) {
        setState(() {
          slctNameOrganization = value!;
          val_NameOrganization = slctNameOrganization!.value;
          slct_NameOrganization = slctNameOrganization!.name;
        });
      },
    ));

    listings.add(txt_label_mandatory('Country', Colors.black, 14.0, false));
    listings.add(singlesearchDropdown(
        itemlist: countryitems,
        selecteditem: slctCountry,
        hint: 'Select country',
        onChanged: (value) {
          setState(
            () {
              slctCountry = value!;
              stateLoaded = false;
              slctState = "";
              stateitems.clear();
              districtLoaded = false;
              slctDistrict = "";
              districtitems.clear();
              cityLoaded = false;
              slctTaluk = "";
              cityitems.clear();
              villageLoaded = false;
              villageitems.clear();
              slctVillage = "";
              frmGender = '';
              farmerAge = '';
              frmNin = '';
              frmMob = '';
              slctFarmers = null;
              farmerId = "";
              slct_farmer = "";
              slctCoffeeType = null;
              val_CoffeeType = "";
              slctNameCrop = null;
              val_NameCrop = "";
              slct_NameCrop = "";
              demandQan.clear();
              farmerloaded = false;

              slct_CoffeeType = "";

              for (int i = 0; i < countryUIModel.length; i++) {
                if (value == countryUIModel[i].name) {
                  val_Country = countryUIModel[i].value;
                  ChangeStates(val_Country);
                }
              }
            },
          );
        },
        onClear: () {
          slctCountry = "";
        }));

    listings.add(stateLoaded
        ? txt_label_mandatory('District', Colors.black, 14.0, false)
        : Container());
    listings.add(stateLoaded
        ? singlesearchDropdown(
            itemlist: stateitems,
            selecteditem: stateLoaded ? slctState : "",
            hint: 'Select district',
            onChanged: (value) {
              setState(() {
                slctState = value!;
                districtLoaded = false;
                slctDistrict = "";
                districtitems.clear();
                cityLoaded = false;
                slctTaluk = "";
                cityitems.clear();
                villageLoaded = false;
                villageitems.clear();
                slctVillage = "";
                frmGender = '';
                farmerAge = '';
                frmNin = '';
                frmMob = '';
                slctFarmers = null;
                farmerId = "";
                slct_farmer = "";
                slctCoffeeType = null;
                val_CoffeeType = "";
                slctNameCrop = null;
                val_NameCrop = "";
                slct_NameCrop = "";
                demandQan.clear();
                farmerloaded = false;

                slct_CoffeeType = "";

                for (int i = 0; i < stateUIModel.length; i++) {
                  if (value == stateUIModel[i].name) {
                    val_State = stateUIModel[i].value;
                    changeDistrict(val_State);
                  }
                }
              });
            },
            onClear: () {
              slctState = "";
              slctDistrict = "";
              slctTaluk = "";
              slctVillage = "";
            })
        : Container());

    listings.add(districtLoaded
        ? txt_label_mandatory("Subcountry", Colors.black, 14.0, false)
        : Container());
    listings.add(districtLoaded
        ? singlesearchDropdown(
            itemlist: districtitems,
            selecteditem: districtLoaded ? slctDistrict : "",
            hint: 'Select Subcountry',
            onChanged: (value) {
              setState(() {
                slctDistrict = value!;
                cityLoaded = false;
                slctTaluk = "";
                cityitems.clear();
                villageLoaded = false;
                villageitems.clear();
                slctVillage = "";
                frmGender = '';
                farmerAge = '';
                frmNin = '';
                frmMob = '';
                slctFarmers = null;
                farmerId = "";
                slct_farmer = "";
                slctCoffeeType = null;
                val_CoffeeType = "";
                slctNameCrop = null;
                val_NameCrop = "";
                slct_NameCrop = "";
                demandQan.clear();
                farmerloaded = false;

                slct_CoffeeType = "";

                for (int i = 0; i < districtUIModel.length; i++) {
                  if (value == districtUIModel[i].name) {
                    val_District = districtUIModel[i].value;
                    changeCity(val_District);
                  }
                }
              });
            },
            onClear: () {
              slctDistrict = "";
              slctTaluk = "";
              slctVillage = "";
            })
        : Container());

    listings.add(cityLoaded
        ? txt_label_mandatory('Parish', Colors.black, 14.0, false)
        : Container());
    listings.add(cityLoaded
        ? singlesearchDropdown(
            itemlist: cityitems,
            selecteditem: cityLoaded ? slctTaluk : "",
            hint: 'Select Parish',
            onChanged: (value) {
              setState(() {
                slctTaluk = value!;
                villageLoaded = true;
                villageitems.clear();
                slctVillage = "";
                frmGender = '';
                farmerAge = '';
                frmNin = '';
                frmMob = '';
                slctFarmers = null;
                farmerId = "";
                slct_farmer = "";
                slctCoffeeType = null;
                val_CoffeeType = "";
                slctNameCrop = null;
                val_NameCrop = "";
                slct_NameCrop = "";
                demandQan.clear();
                farmerloaded = false;

                slct_CoffeeType = "";
                for (int i = 0; i < cityListUIModel.length; i++) {
                  if (value == cityListUIModel[i].name) {
                    val_Taluk = cityListUIModel[i].value;
                    //changePanchayat(val_Taluk);
                    changeVillage(val_Taluk);
                  }
                }
              });
            },
            onClear: () {
              slctTaluk = "";
              slctVillage = "";
            })
        : Container());

    listings.add(villageLoaded
        ? txt_label_mandatory('Village', Colors.black, 14.0, false)
        : Container());
    listings.add(villageLoaded
        ? singlesearchDropdown(
            itemlist: villageitems,
            selecteditem: villageLoaded ? slctVillage : "",
            hint: 'Select Village',
            onChanged: (value) {
              setState(() {
                slctVillage = value!;
                frmGender = '';
                farmerAge = '';
                frmNin = '';
                frmMob = '';
                slctFarmers = null;
                farmerId = "";
                slct_farmer = "";
                slctCoffeeType = null;
                val_CoffeeType = "";
                slctNameCrop = null;
                val_NameCrop = "";
                slct_NameCrop = "";
                demandQan.clear();
                slct_CoffeeType = "";
                for (int i = 0; i < VillageListUIModel.length; i++) {
                  if (value == VillageListUIModel[i].name) {
                    val_Village = VillageListUIModel[i].value;
                    villageName = VillageListUIModel[i].name;
                    farmersearch(val_Village);
                  }
                }
              });
            },
            onClear: () {
              slctVillage = "";
            })
        : Container());

    listings.add(farmerloaded
        ? txt_label_mandatory('Farmer name', Colors.black, 14.0, false)
        : Container());

    listings.add(farmerloaded
        ? DropDownWithModel(
            itemlist: farmeritems,
            selecteditem: slctFarmers,
            hint: TranslateFun.langList['slcFrmNmeLocCls'],
            onChanged: (value) {
              setState(() {
                frmGender = '';
                farmerAge = '';
                frmNin = '';
                frmMob = '';
                slctFarmers = value!;
                farmerId = slctFarmers!.value;
                slct_farmer = slctFarmers!.name;
                slctNameCrop = null;
                val_NameCrop = "";
                slct_NameCrop = "";
                slctCoffeeType = null;
                val_CoffeeType = "";

                slct_CoffeeType = "";
                namecropitems.clear();

                loadInputType(farmerId);

                for (int i = 0; i < farmerlistUIModel.length; i++) {
                  if (farmerlistUIModel[i].value == farmerId) {
                    farmerAge = farmerlistUIModel[i].value2;
                    frmGender = farmerlistUIModel[i].value3;
                    frmMob = farmerlistUIModel[i].value4;
                    frmNin = farmerlistUIModel[i].value5;
                    demandQan.text = farmerlistUIModel[i].value6;
                  }
                }
              });
            },
            onClear: () {
              setState(() {
                slct_farmer = '';
              });
            })
        : Container());

    if (farmerloaded) {
      listings.add(txt_label_mandatory('Gender', Colors.black, 14.0, false));
      listings.add(cardlable_dynamic(frmGender));

      listings.add(txt_label_mandatory('Age', Colors.black, 14.0, false));
      listings.add(cardlable_dynamic(farmerAge));

      listings.add(txt_label_mandatory(
          TranslateFun.langList['natIDNumCls'], Colors.black, 14.0, false));
      listings.add(cardlable_dynamic(frmNin));

      listings.add(txt_label_mandatory(
          TranslateFun.langList['mobNoCls'], Colors.black, 14.0, false));
      listings.add(cardlable_dynamic(frmMob));
    }

    listings.add(txt_label_mandatory(
        TranslateFun.langList['inpTypCls'], Colors.black, 14.0, false));
    listings.add(DropDownWithModel(
      itemlist: coffeetypeitems,
      selecteditem: slctCoffeeType,
      hint: TranslateFun.langList['slctInpCls'],
      onChanged: (value) {
        setState(() {
          slctCoffeeType = value!;
          slctNameCrop = null;
          val_NameCrop = "";
          slct_NameCrop = "";
          val_CoffeeType = slctCoffeeType!.value;
          print("input type:" + val_CoffeeType);
          slct_CoffeeType = slctCoffeeType!.name;
          loadProduct(val_CoffeeType);
        });
      },
    ));

    listings.add(txt_label_mandatory(
        TranslateFun.langList['prodCls'], Colors.black, 14.0, false));

    listings.add(DropDownWithModel(
      itemlist: namecropitems,
      selecteditem: slctNameCrop,
      hint: TranslateFun.langList['slcProdCls'],
      onChanged: (value) {
        setState(() {
          slctNameCrop = value!;
          val_NameCrop = slctNameCrop!.value;
          slct_NameCrop = slctNameCrop!.name;
          if (farmerId.isNotEmpty) {
            calculateDemandQty(farmerId, val_NameCrop);
          }

          print("name crop:" + val_NameCrop);
        });
      },
    ));

    listings.add(txt_label_mandatory(
        TranslateFun.langList['demQtyCls'], Colors.black, 14.0, false));

    listings.add(
        txtfield_digits(TranslateFun.langList['demQtyCls'], demandQan, false));

    listings.add(txt_label_mandatory(
        TranslateFun.langList['disQtytCls'], Colors.black, 14.0, false));

    listings.add(txtfield_digits(
        TranslateFun.langList['disQtytCls'], distributeQan, true));

    listings.add(btn_dynamic(
        label: TranslateFun.langList['addCls'],
        bgcolor: Colors.green,
        txtcolor: Colors.white,
        fontsize: 18.0,
        centerRight: Alignment.centerRight,
        margin: 10.0,
        btnSubmit: () async {
          if (val_Village.isNotEmpty) {
            if (farmerId.isNotEmpty) {
              if (frmGender.isNotEmpty) {
                if (farmerAge.isNotEmpty) {
                  if (frmNin.isNotEmpty) {
                    /*if (frmMob.isNotEmpty) {*/
                      if (val_NameCrop.isNotEmpty) {
                        if (demandQan.text.isNotEmpty) {
                          if (distributeQan.text.isNotEmpty) {
                            var inputDetaillist = InputDetail(
                                val_Village,
                                villageName,
                                farmerId,
                                slct_farmer,
                                frmGender,
                                farmerAge,
                                frmNin,
                                frmMob,
                                val_NameCrop,
                                slct_NameCrop,
                                demandQan.text,
                                distributeQan.text);
                            setState(() {
                              inputDetailList.add(inputDetaillist);
                              frmGender = "";
                              farmerAge = "";
                              frmNin = "";
                              frmMob = "";
                              val_NameCrop = "";
                              slct_NameCrop = "";
                              demandQan.text = "";
                              distributeQan.text = "";
                            });
                          } else {
                            errordialog(
                                context,
                                TranslateFun.langList['infoCls'],
                                TranslateFun.langList['valDisQtyCls']);
                          }
                        } else {
                          errordialog(context, TranslateFun.langList['infoCls'],
                              TranslateFun.langList['valDeQtyCls']);
                        }
                      } else {
                        errordialog(context, TranslateFun.langList['infoCls'],
                            TranslateFun.langList['valProdCls']);
                      }
                    /*} else {
                      errordialog(context, TranslateFun.langList['infoCls'],
                          TranslateFun.langList['valMobCls']);
                    }*/
                  } else {
                    errordialog(context, TranslateFun.langList['infoCls'],
                        TranslateFun.langList['valNINCls']);
                  }
                } else {
                  errordialog(context, TranslateFun.langList['infoCls'],
                      'Age should not be empty');
                }
              } else {
                errordialog(context, TranslateFun.langList['infoCls'],
                    'Gender should not be empty');
              }
            } else {
              errordialog(context, TranslateFun.langList['infoCls'],
                  'Farmer should not be empty');
            }
          } else {
            errordialog(context, TranslateFun.langList['infoCls'],
                'Village should not be empty');
          }
        }));

    if (inputDetailList.length > 0) {
      listings.add(inputListTable());
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
                  style: TextStyle(color: Colors.white, fontSize: 16),
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
                  style: TextStyle(color: Colors.white, fontSize: 16),
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

  farmersearch(String villageCode) async {
    //select distinct fm.fName as fName,fm.farmerId as farmerId,fk.age as age,fk.gender as gender,fm.mobileNo as mobileNo,fk.mobileNo as nin from farmer_master as fm,farmerkettle as fk where fm.villageId = \'' +
    //             villageCode +
    //             '\' and fk.village = fm.villageId

    String qry_farmerlist =
        'select distinct farmerId,gender,age,nin,mobNo,demandQty from inputDemandList where  village = \'' +
            villageCode +
            '\' ';
    List farmerslist = await db.RawQuery(qry_farmerlist);
    print('qry_farmerlist:  ' + farmerslist.toString());

    farmeritems = [];
    farmeritems.clear();
    farmerlistUIModel = [];

    if (farmerslist.length > 0) {
      for (int i = 0; i < farmerslist.length; i++) {
        String farmerId = farmerslist[i]["farmerId"].toString();
        List frName = await db.RawQuery(
            'select distinct fName from farmer_master where farmerCode = \'' +
                farmerId +
                '\'');
        String fName = frName[0]['fName'].toString();
        String age = farmerslist[i]["age"].toString();
        String gender = farmerslist[i]["gender"].toString();
        String mobileNo = farmerslist[i]["mobNo"].toString();
        String nin = farmerslist[i]["nin"].toString();
        //String demandQty = farmerslist[i]['demandQty'].toString();
        // print("demandQtyValue:" + demandQty);
        var uimodel =
            new UImodel5(fName, farmerId, age, gender, mobileNo, nin, '');
        farmerlistUIModel.add(uimodel);
        setState(() {
          farmeritems.add(DropdownModel(
            fName,
            farmerId,
          ));
        });
      }
    }

    Future.delayed(Duration(milliseconds: 500), () {
      setState(() {
        if (farmeritems.length > 0) {
          slct_farmer = '';
          farmerloaded = true;
        }
      });
    });
  }

  calculateDemandQty(String farmerId, String product) async {
    String demandList =
        'select SUM(demandQty) as demandQty from inputDemandList where  farmerId = \'' +
            farmerId +
            '\' and  product = \'' +
            product +
            '\' ';
    List demandQtyList = await db.RawQuery(demandList);
    for (int i = 0; i < demandQtyList.length; i++) {
      String demandValue = demandQtyList[0]['demandQty'].toString();
      setState(() {
        if (demandValue != null) {
          demandQan.text = demandValue;
        } else {
          demandQan.text = "0";
        }
      });
      print("Demand value:" + demandValue);
    }
    print('total demand Qty:  ' + demandQtyList.toString());
  }

  Widget inputListTable() {
    List<DataColumn> columns = <DataColumn>[];
    List<DataRow> rows = <DataRow>[];
    columns.add(DataColumn(label: Text('Village')));
    columns.add(DataColumn(label: Text('Farmer')));
    columns.add(DataColumn(label: Text('Gender')));
    columns.add(DataColumn(label: Text('Age')));
    columns.add(DataColumn(label: Text('NIN')));
    columns.add(DataColumn(label: Text('Mobile')));
    columns.add(DataColumn(label: Text('Product')));
    columns.add(DataColumn(label: Text('Demand Qty')));
    columns.add(DataColumn(label: Text('Distributed Qty')));
    columns.add(DataColumn(label: Text('Delete')));

    for (int i = 0; i < inputDetailList.length; i++) {
      List<DataCell> singlecell = <DataCell>[];
      singlecell.add(DataCell(Text(inputDetailList[i].villageName)));
      singlecell.add(DataCell(Text(inputDetailList[i].farmerName)));
      singlecell.add(DataCell(Text(inputDetailList[i].gender)));
      singlecell.add(DataCell(Text(inputDetailList[i].age)));
      singlecell.add(DataCell(Text(inputDetailList[i].nin)));
      singlecell.add(DataCell(Text(inputDetailList[i].mobNo)));
      singlecell.add(DataCell(Text(inputDetailList[i].productName)));
      singlecell.add(DataCell(Text(inputDetailList[i].demand)));
      singlecell.add(DataCell(Text(inputDetailList[i].distribute)));

      singlecell.add(DataCell(InkWell(
        onTap: () {
          setState(() {
            inputDetailList.removeAt(i);
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

  void btnSubmit() {
    if (registrationDate.isNotEmpty) {
      if (val_NameOrganization.isNotEmpty) {
        if (val_CoffeeType.isNotEmpty) {
          if (val_Country.isNotEmpty) {
            if (val_State.isNotEmpty) {
              if (val_District.isNotEmpty) {
                if (val_Taluk.isNotEmpty) {
                  if (val_Village.isNotEmpty) {
                    if (farmerId.isNotEmpty) {
                      if (inputDetailList.isNotEmpty) {
                        confirmation();
                      } else {
                        errordialog(context, TranslateFun.langList['infoCls'],
                            TranslateFun.langList['valAtlstOneCls']);
                      }
                    } else {
                      errordialog(context, TranslateFun.langList['infoCls'],
                          "Farmer should not be emtpy");
                    }
                  } else {
                    errordialog(context, TranslateFun.langList['infoCls'],
                        'Village should not be empty');
                  }
                } else {
                  errordialog(context, TranslateFun.langList['infoCls'],
                      'Parish should not be empty');
                }
              } else {
                errordialog(context, TranslateFun.langList['infoCls'],
                    'Sub country should not be empty');
              }
            } else {
              errordialog(context, TranslateFun.langList['infoCls'],
                  'District should not be empty');
            }
          } else {
            errordialog(context, TranslateFun.langList['infoCls'],
                'Country should not be empty');
          }
        } else {
          errordialog(context, TranslateFun.langList['infoCls'],
              TranslateFun.langList['valInpTypCls']);
        }
      } else {
        errordialog(context, TranslateFun.langList['infoCls'],
            TranslateFun.langList['valFrmrOrgCls']);
      }
    } else {
      errordialog(context, TranslateFun.langList['infoCls'],
          TranslateFun.langList['valdateCls']);
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
        title: "Information",
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
              saveInputDemand();
              Navigator.pop(context);
            },
            color: Colors.green,
          )
        ]).show();
  }

  void saveInputDemand() async {
    Random rnd = new Random();
    int recNo = 100000 + rnd.nextInt(999999 - 100000);
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

    //Future<List<Map>> txnHeader = db.GetTableValues('txnHeader');

    AppDatas datas = new AppDatas();
    int custTransaction = await db.saveCustTransaction(
        txntime, datas.txn_inputDistribution, revNo, '', '', '');
    print('custTransaction : ' + custTransaction.toString());
    String isSynched = "0";

    int inputDemand = await db.saveInputDistribution(
        isSynched,
        revNo,
        msgNo,
        registrationDate,
        val_NameOrganization,
        val_CoffeeType,
        val_Country, //country
        val_State, //district
        val_District, //subcountry
        val_Taluk, // parish
        Lat,
        Lng,
        seasoncode,
        "");

    if (inputDetailList.length > 0) {
      for (int i = 0; i < inputDetailList.length; i++) {
      /*  int saveInputDemDetails = await db.saveInputDistributionDetail(
            inputDetailList[i].villageCode,
            inputDetailList[i].farmerCode,
            inputDetailList[i].gender,
            inputDetailList[i].age,
            inputDetailList[i].nin,
            inputDetailList[i].mobNo,
            inputDetailList[i].productCode,
            inputDetailList[i].demand,
            inputDetailList[i].distribute,
            revNo.toString(),
            "","");*/
        print("savefarmgpslocation" + revNo.toString());
      }
    }

    int issync = await db.UpdateTableValue(
        'inputDistribution', 'isSynched', '0', 'recNo', revNo);

    Alert(
      context: context,
      type: AlertType.info,
      title: "Transaction Successful",
      desc: "Input Distribution Successful",
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
  }
}

class InputDetail {
  String villageCode,
      villageName,
      farmerCode,
      farmerName,
      gender,
      age,
      nin,
      mobNo,
      productCode,
      productName,
      demand,
      distribute;

  InputDetail(
      this.villageCode,
      this.villageName,
      this.farmerCode,
      this.farmerName,
      this.gender,
      this.age,
      this.nin,
      this.mobNo,
      this.productCode,
      this.productName,
      this.demand,
      this.distribute);
}
