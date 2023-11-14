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

class InputDemand1 extends StatefulWidget {
  @override
  State<InputDemand1> createState() => _InputDemandState();
}

class _InputDemandState extends State<InputDemand1> {
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

  List<DropdownModel> receiptNoItem = [];
  DropdownModel? slctReceiptNo;
  String slct_ReceiptNo = "";
  String val_ReceiptNo = "";

  List<DropdownModel> transTypeItems = [];
  DropdownModel? slctTransTypeItems;
  String slct_TransType = "";
  String val_TransType = "";

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

  TextEditingController distributeQan = new TextEditingController();
  TextEditingController nooftrees = new TextEditingController();
  TextEditingController totTrees = new TextEditingController();

  bool stateLoaded = true;
  bool districtLoaded = false;
  bool cityLoaded = false;
  bool villageLoaded = false;
  bool farmerloaded = false;
  bool farmloaded = false;

  List<DropdownModel> farmeritems = [];
  List<DropdownModel> farmitems = [];
  DropdownModel? slctFarmers;
  DropdownModel? slctFarm;
  String slct_farmer = "",
      slct_farm = "",
      farmerId = "",
      farmId = "",
      farmerAge = "",
      frmGender = '',
      frmMob = '',
      frmNin = '';
  List<UImodel5> farmerlistUIModel = [];
  List<UImodel3> farmlistUIModel = [];

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

  List<InputDetail> inputDetailList = [];
  List<InputDetail1> inputDetailList1 = [];
  List<InputSummary> inputSummaryList = [];

  bool productLoaded = false;
  bool already = false;

  bool listNotAdded = true;
  bool listAdded = false;

  bool inputDisListNotAdded = true;
  bool inputDistListAdded = false;

  String did = "";

  String farmerOrg = "";
  String inType = "";
  String country = "";
  String district = "";
  String subcountry = "";
  String parish = "";
  String village = "";

  bool inputDistributionAdded = true;

  String disCode = "";
  String region = "";

  @override
  void initState() {
    super.initState();

    getClientData();
    getLocation();
    initdata();

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

  LoadRegion(String cCode) async {
    List regionList = await db.RawQuery(
        'select  countryName from countryList c,stateList s where c.countryCode = s.countryCode and s.stateCode =\'' +
            cCode +
            '\'');
    if (regionList.isNotEmpty) {
      region = regionList[0]['countryName'].toString();
    }
  }

  Future<void> initdata() async {
    loadCountry();
    ChangeStates();

    List typeList = [
      {"property_value": "Input Demand", "DISP_SEQ": "0"},
      {"property_value": "Input Distribution", "DISP_SEQ": "1"}
    ];

    transTypeItems.clear();
    for (int i = 0; i < typeList.length; i++) {
      String typurchseName = typeList[i]["property_value"].toString();
      String typurchseCode = typeList[i]["DISP_SEQ"].toString();
      var uimodel = new UImodel(typurchseName, typurchseCode);

      setState(() {
        transTypeItems.add(DropdownModel(
          typurchseName,
          typurchseCode,
        ));
      });
    }

    List inputTypeList = await db.RawQuery(
        'select distinct categoryCode,categoryName from inputType');
    print(' inputTypeList' + inputTypeList.toString());

    coffeetypeitems.clear();
    for (int i = 0; i < inputTypeList.length; i++) {
      String typurchseName = inputTypeList[i]["categoryName"].toString();
      String typurchseCode = inputTypeList[i]["categoryCode"].toString();
      var uimodel = new UImodel(typurchseName, typurchseCode);

      setState(() {
        coffeetypeitems.add(DropdownModel(
          typurchseName,
          typurchseCode,
        ));
      });
    }

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

  Future<void> loadProduct(String inputType) async {
    List cropList = await db.RawQuery(
        'select productName,productCode from inputType where categoryCode = \'' +
            inputType +
            '\'  ');
    print(' cropList' + cropList.toString());

    namecropitems.clear();
    for (int i = 0; i < cropList.length; i++) {
      String typurchseName = cropList[i]["productName"].toString();
      String typurchseCode = cropList[i]["productCode"].toString();
      var uimodel = new UImodel(typurchseName, typurchseCode);

      setState(() {
        namecropitems.add(DropdownModel(
          typurchseName,
          typurchseCode,
        ));
      });
    }

    Future.delayed(Duration(milliseconds: 500), () {
      print("district_delayfunction" + cropList.toString());
      setState(() {
        if (cropList.isNotEmpty) {
          productLoaded = true;
          slctNameCrop = null;
          slct_NameCrop = "";
          val_NameCrop = "";
        }
      });
    });
  }

  Future<void> loadProducts(String batchNo, String farmerId) async {
    List prodList = await db.RawQuery(
        'select product from inputDemandList where batchNo = \'' +
            batchNo +
            '\' and farmerId = \'' +
            farmerId +
            '\'   ');
    print(' prodList' + prodList.toString());

    namecropitems.clear();
    for (int i = 0; i < prodList.length; i++) {
      String typurchseName = "";
      String typurchseCode = prodList[i]["product"].toString();
      print("typurchseCode" + typurchseCode);
      List productList = await db.RawQuery(
          'select productName from inputType where productCode = \'' +
              typurchseCode +
              '\'  ');
      for (int j = 0; j < productList.length; j++) {
        typurchseName = productList[j]['productName'].toString();
        print("typurchseName" + typurchseName);
      }
      var uimodel = new UImodel(typurchseName, typurchseCode);

      setState(() {
        namecropitems.add(DropdownModel(
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

  //Future<void> ChangeStates(String countrycode) async {
  Future<void> ChangeStates() async {
    List statelist = await db.RawQuery('select cityCode from agentMaster');

    stateUIModel = [];
    stateitems = [];
    stateitems.clear();
    String stateName = "";
    for (int i = 0; i < statelist.length; i++) {
      String countryCode = statelist[i]["countryCode"].toString();
      String stateCodeValue = statelist[i]["cityCode"].toString();
      List<String> stateCodeL = stateCodeValue.split(',').toList();
      print("stateCodeL:" + stateCodeL.length.toString());
      String stateCode = "";
      for (int j = 0; j < stateCodeL.length; j++) {
        stateCode = stateCodeL[j].toString();
        print("stateCodeValue:" + stateCode);
        List stateNameList = await db.RawQuery(
            'select  stateName from stateList where stateCode =\'' +
                stateCode +
                '\'');
        print('stateFarmerEnrollement' +
            stateNameList.toString() +
            "" +
            'select stateName from stateList where stateCode =\'' +
            stateCode +
            '\'');

        for (int s = 0; s < stateNameList.length; s++) {
          stateName = stateNameList[s]["stateName"].toString();
          print("stateNameValue:" + stateName);
          var uimodel = UImodel(stateName, stateCode);
          stateUIModel.add(uimodel);
          setState(() {
            stateitems.add(DropdownMenuItem(
              child: Text(stateName),
              value: stateName,
            ));
            //stateList.add(stateName);
          });
        }
      }

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
    disCode = agents[0]['cityCode'].toString();
    loadReceiptNo(disCode);
    //print("resIdgetcliendata" + resIdd);

    print("agendId_agendId" + agendId + disCode);
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
          desc: TranslateFun.langList['gpsLocCls'],
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
              "Input Demand / Distribution",
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

    listings.add(txt_label_mandatory("Type", Colors.black, 14.0, false));
    listings.add(DropDownWithModel(
      itemlist: transTypeItems,
      selecteditem: slctTransTypeItems,
      hint: "Select type",
      onChanged: (value) {
        setState(() {
          slctTransTypeItems = value!;
          val_TransType = slctTransTypeItems!.value;
          slct_TransType = slctTransTypeItems!.name;
          inputSummaryList.clear();

          slctState = "";
          //stateitems.clear();
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
          slctNameOrganization = null;
          val_NameOrganization = "";
          slct_NameOrganization = "";
          farmerOrg = "";
          listNotAdded = true;
          listAdded = false;
          inputDetailList.clear();
          inputDetailList = [];
          listAdded = false;
          inType = "";
          country = "";
          district = "";
          subcountry = "";
          parish = "";
          val_Village = "";
          villageName = "";
          village = "";
          frmGender = '';
          farmerAge = '';
          frmNin = '';
          frmMob = '';
          slctFarmers = null;
          farmerId = "";
          slct_farmer = "";
          demandQan.clear();
          demandQan.text = '';
          slctReceiptNo = null;
          slctFarm = null;
          farmId = "";
          slct_farm = "";
          totTrees.text = "";
          nooftrees.text = "";
          farmloaded = false;

          val_ReceiptNo = "";

          slct_ReceiptNo = "";
          farmerloaded = false;
          inputDisListNotAdded = true;
          inputDistListAdded = false;
          inputDetailList1.clear();
          inputDetailList1 = [];
          distributeQan.text = '';
          distributeQan.clear();
          slctCountry = "";
          country = "";
          val_Country = "";
          stateLoaded = true;
          districtLoaded = false;
          cityLoaded = false;
          villageLoaded = false;

          slct_CoffeeType = "";
        });
      },
    ));

    if (val_TransType == "0") {
      listings.add(txt_label_mandatory(
          TranslateFun.langList['dateeCls'], Colors.black, 14.0, false));
      listings.add(selectDate(
          context1: context,
          slctdate: registrationDate,
          onConfirm: (date) => setState(
                () {
                  registrationDate = DateFormat('dd/MM/yyyy').format(date!);
                  registrationFormatedDate =
                      DateFormat('yyyyMMdd').format(date);
                },
              )));

      if (listNotAdded && inputDetailList.length == 0) {
        /*  listings.add(txt_label_mandatory(
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
              farmerOrg = slctNameOrganization!.name;
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
              slctCountry = "";
              val_Country = "";
              slctState = "";
              val_State = "";
              stateLoaded = false;
              districtLoaded = false;
              cityLoaded = false;
              villageLoaded = false;
              val_District = "";
              val_Taluk = "";
              val_Village = "";
              farmerloaded = false;
            });
          },
        ));*/

        /* listings.add(txt_label_mandatory('Country', Colors.black, 14.0, false));
        listings.add(singlesearchDropdown(
            itemlist: countryitems,
            selecteditem: slctCountry,
            hint: 'Select country',
            onChanged: (value) {
              setState(
                () {
                  slctCountry = value!;
                  country = slctCountry;
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
                  slctNameCrop = null;
                  val_NameCrop = "";
                  slct_NameCrop = "";
                  demandQan.clear();
                  farmerloaded = false;

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
            }));*/

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
                    district = slctState;
                    slctDistrict = "";
                    districtitems.clear();
                    cityLoaded = false;
                    slctTaluk = "";
                    cityitems.clear();
                    villageLoaded = false;
                    villageitems.clear();
                    slctVillage = "";
                    slctNameCrop = null;
                    val_NameCrop = "";
                    slct_NameCrop = "";
                    demandQan.clear();
                    farmerloaded = false;
                    slctFarm = null;
                    farmId = "";
                    slct_farm = "";
                    totTrees.text = "";
                    nooftrees.text = "";
                    farmloaded = false;
                    val_District = "";
                    val_Taluk = "";
                    val_Village = "";

                    for (int i = 0; i < stateUIModel.length; i++) {
                      if (value == stateUIModel[i].name) {
                        val_State = stateUIModel[i].value;
                        changeDistrict(val_State);
                        LoadRegion(val_State);
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
            ? txt_label("Region", Colors.black, 14.0, false)
            : Container());
        listings.add(districtLoaded ? cardlable_dynamic(region) : Container());

        listings.add(districtLoaded
            ? txt_label_mandatory("Subcounty", Colors.black, 14.0, false)
            : Container());
        listings.add(districtLoaded
            ? singlesearchDropdown(
                itemlist: districtitems,
                selecteditem: districtLoaded ? slctDistrict : "",
                hint: 'Select Subcounty',
                onChanged: (value) {
                  setState(() {
                    slctDistrict = value!;
                    cityLoaded = false;
                    subcountry = slctDistrict;
                    slctTaluk = "";
                    cityitems.clear();
                    villageLoaded = false;
                    villageitems.clear();
                    slctVillage = "";
                    slctNameCrop = null;
                    val_NameCrop = "";
                    slct_NameCrop = "";
                    demandQan.clear();
                    farmerloaded = false;
                    slctFarm = null;
                    farmId = "";
                    slct_farm = "";
                    totTrees.text = "";
                    nooftrees.text = "";
                    farmloaded = false;
                    val_Taluk = "";
                    val_Village = "";

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
                    parish = slctTaluk;
                    villageitems.clear();
                    slctVillage = "";
                    slctNameCrop = null;
                    val_NameCrop = "";
                    slct_NameCrop = "";
                    demandQan.clear();
                    slctFarm = null;
                    farmId = "";
                    slct_farm = "";
                    totTrees.text = "";
                    nooftrees.text = "";
                    farmerloaded = false;
                    farmloaded = false;
                    val_Village = "";
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
      }

      if (listAdded && inputDetailList.length > 0) {
        /* listings.add(txt_label_mandatory(
            TranslateFun.langList['frOrgCls'], Colors.black, 14.0, false));
        listings.add(cardlable_dynamic(farmerOrg));*/

        /*listings.add(txt_label_mandatory(
            TranslateFun.langList['inpTypCls'], Colors.black, 14.0, false));

        listings.add(cardlable_dynamic(inType));*/

        /*listings.add(txt_label_mandatory('Country', Colors.black, 14.0, false));
        listings.add(cardlable_dynamic(country));*/

        listings
            .add(txt_label_mandatory('District', Colors.black, 14.0, false));
        listings.add(cardlable_dynamic(district));

        listings
            .add(txt_label_mandatory("Subcounty", Colors.black, 14.0, false));
        listings.add(cardlable_dynamic(subcountry));

        listings.add(txt_label_mandatory('Parish', Colors.black, 14.0, false));
        listings.add(cardlable_dynamic(parish));
      }

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
                  for (int i = 0; i < VillageListUIModel.length; i++) {
                    if (value == VillageListUIModel[i].name) {
                      val_Village = VillageListUIModel[i].value;
                      villageName = VillageListUIModel[i].name;
                      village = VillageListUIModel[i].name;
                      farmersearch(val_Village);
                      slctFarmers = null;
                      farmerId = "";
                      slct_farmer = "";
                      farmerAge = "";
                      frmGender = "";
                      frmMob = "";
                      frmNin = "";
                      slctFarm = null;
                      farmId = "";
                      farmloaded = false;
                      slct_farm = "";
                      farmeritems = [];
                      totTrees.text = "";
                      nooftrees.text = "";
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
                  slctFarm = null;
                  farmId = "";
                  farmloaded = false;
                  slct_farm = "";
                  totTrees.text = "";
                  nooftrees.text = "";
                  slctFarmers = value!;
                  farmerId = slctFarmers!.value;
                  slct_farmer = slctFarmers!.name;
                  String farmerIdd = "";

                  for (int i = 0; i < farmerlistUIModel.length; i++) {
                    if (farmerlistUIModel[i].value == farmerId) {
                      farmerAge = farmerlistUIModel[i].value2;
                      frmGender = farmerlistUIModel[i].value3;
                      print("frmGender:" + frmGender);
                      frmMob = farmerlistUIModel[i].value4;
                      frmNin = farmerlistUIModel[i].value5;
                      farmerIdd = farmerlistUIModel[i].value6;
                    }
                  }
                  loadfarm(farmerIdd);
                });
              },
              onClear: () {
                setState(() {
                  slct_farmer = '';
                  slctFarm = null;
                  farmId = "";
                  slct_farm = "";
                  nooftrees.text = "";
                });
              })
          : Container());

      listings.add(farmloaded
          ? txt_label_mandatory('Farm name', Colors.black, 14.0, false)
          : Container());

      listings.add(farmloaded
          ? DropDownWithModel(
              itemlist: farmitems,
              selecteditem: slctFarm,
              hint: "Select Farm",
              onChanged: (value) {
                setState(() {
                  slctFarm = value!;
                  farmId = slctFarm!.value;
                  slct_farm = slctFarm!.name;
                  totTrees.text = "";
                  nooftrees.text = "";

                  for (int i = 0; i < farmlistUIModel.length; i++) {
                    if (farmlistUIModel[i].value == farmId) {
                      totTrees.text = farmlistUIModel[i].value2;
                    }
                  }
                });
              },
              onClear: () {
                setState(() {
                  slct_farm = '';
                  nooftrees.text = "";
                  totTrees.text = "";
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

      if (farmloaded) {
        listings.add(txt_label_mandatory(
            "Total Number of Trees", Colors.black, 14.0, false));

        listings.add(txtfield_digits("Total Number of Trees", totTrees, false));
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
            val_CoffeeType = slctCoffeeType!.value;
            slct_CoffeeType = slctCoffeeType!.name;
            inType = slct_CoffeeType;
            print("valCoffeetype:" + val_CoffeeType);
            loadProduct(val_CoffeeType);
            slctNameCrop = null;
            val_NameCrop = "";
            slct_NameCrop = "";
            demandQan.text = "";
          });
        },
      ));

      if (val_CoffeeType == "FP00005") {
        listings.add(txt_label_mandatory(
            "Number of  trees to be fertilized", Colors.black, 14.0, false));

        listings.add(txtfield_digits(
            "Number of  trees to be fertilized", nooftrees, true));
      }

      listings.add(productLoaded
          ? txt_label_mandatory(
              TranslateFun.langList['prodCls'], Colors.black, 14.0, false)
          : Container());

      listings.add(productLoaded
          ? DropDownWithModel(
              itemlist: namecropitems,
              selecteditem: slctNameCrop,
              hint: TranslateFun.langList['slcProdCls'],
              onChanged: (value) {
                setState(() {
                  demandQan.text = "";
                  slctNameCrop = value!;
                  val_NameCrop = slctNameCrop!.value;
                  slct_NameCrop = slctNameCrop!.name;
                  print("name crop:" + val_NameCrop);
                });
              },
            )
          : Container());
      if (productLoaded) {
        listings.add(txt_label_mandatory(
            TranslateFun.langList['demQtyCls'], Colors.black, 14.0, false));

        listings.add(txtfieldAllowTwoDecimal(
            TranslateFun.langList['demQtyCls'], demandQan, true, 9));
      }

      listings.add(btn_dynamic(
          label: TranslateFun.langList['addCls'],
          bgcolor: Colors.green,
          txtcolor: Colors.white,
          fontsize: 18.0,
          centerRight: Alignment.centerRight,
          margin: 10.0,
          btnSubmit: () async {
            bool already = false;
            String sttrees = totTrees.text;
            String sntrees = nooftrees.text;
            double ttrees = 0.0;
            if (sttrees != null && sttrees != "") {
              ttrees = double.parse(sttrees);
            } else {
              ttrees = 0;
            }
            double ntrees = 0.0;
            if (sntrees != null && sntrees != "") {
              ntrees = double.parse(sntrees);
            } else {
              ntrees = 0;
            }

            if (val_Village.isEmpty) {
              errordialog(context, TranslateFun.langList['infoCls'],
                  'Village should not be empty');
            } else if (farmerId.isEmpty) {
              errordialog(context, TranslateFun.langList['infoCls'],
                  'Farmer should not be empty');
            } else if (farmId.isEmpty) {
              errordialog(context, TranslateFun.langList['infoCls'],
                  'Farm should not be empty');
            } else if (frmGender.isEmpty) {
              errordialog(context, TranslateFun.langList['infoCls'],
                  'Gender should not be empty');
            } else if (farmerAge.isEmpty) {
              errordialog(context, TranslateFun.langList['infoCls'],
                  'Age should not be empty');
            } else if (val_CoffeeType.isEmpty) {
              errordialog(context, TranslateFun.langList['infoCls'],
                  TranslateFun.langList['valInpTypCls']);
            } else if (nooftrees.text.isEmpty && val_CoffeeType == "FP00005") {
              errordialog(context, TranslateFun.langList['infoCls'],
                  "Number of  trees to be fertilized should not be empty");
            } else if (ttrees < ntrees && val_CoffeeType == "FP00005") {
              errordialog(context, TranslateFun.langList['infoCls'],
                  "Number of  trees to be fertilized should not be greater than total number of trees ");
            } else if (val_NameCrop.isEmpty) {
              errordialog(context, TranslateFun.langList['infoCls'],
                  TranslateFun.langList['valProdCls']);
            } else if (demandQan.text.isEmpty) {
              errordialog(context, TranslateFun.langList['infoCls'],
                  TranslateFun.langList['valDeQtyCls']);
            } else {
              for (int i = 0; i < inputDetailList.length; i++) {
                if (val_NameCrop == inputDetailList[i].productCode &&
                    farmerId == inputDetailList[i].farmerCode) {
                  already = true;
                }
              }
              listNotAdded = false;
              listAdded = true;
              if (!already) {
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
                    registrationDate,
                    val_CoffeeType,
                    slct_CoffeeType,
                    val_NameOrganization,
                    farmId,
                    slct_farm,
                    ttrees.toString(),
                    nooftrees.text.isNotEmpty
                        ? int.parse(nooftrees.text).toString()
                        : "");

                var inputSummarylist = InputSummary(
                    inputType: inType,
                    product: slct_NameCrop,
                    demandQty: demandQan.text,
                    productCode: val_NameCrop);
                setState(() {
                  var isAlready = inputSummaryList
                      .where((element) => element.productCode == val_NameCrop)
                      .toList();
                  if (isAlready.isEmpty) {
                    inputSummaryList.add(inputSummarylist);
                  } else {
                    isAlready[0].demandQty = (double.parse(demandQan.text) +
                            double.parse(isAlready[0].demandQty))
                        .toString();
                  }
                  inputDetailList.add(inputDetaillist);

                  val_Village = "";
                  villageName = "";
                  slctVillage = '';
                  slctFarmers = null;
                  farmerId = "";
                  slct_farmer = '';
                  frmGender = "";
                  farmerAge = "";
                  frmNin = "";
                  frmMob = "";
                  slct_NameCrop = "";
                  demandQan.text = "";
                  slctNameCrop = null;
                  slctCoffeeType = null;
                  val_CoffeeType = "";
                  slct_CoffeeType = "";
                  inType = "";
                  slctFarm = null;
                  farmId = "";
                  farmloaded = false;
                  slct_farm = "";
                  totTrees.text = "";
                  farmeritems = [];
                  nooftrees.text = "";
                  namecropitems.clear();
                });
              } else {
                errordialog(context, TranslateFun.langList['infoCls'],
                    "Add different product");
              }
            }

            /*          if (val_Village.isNotEmpty) {
              if (farmerId.isNotEmpty) {
                if (farmId.isNotEmpty) {
                  if (frmGender.isNotEmpty) {
                    if (farmerAge.isNotEmpty) {
                      */ /* if (frmNin.isNotEmpty) {*/ /*
                      */ /* if (frmMob.isNotEmpty) {*/ /*
                      if (val_CoffeeType.isNotEmpty) {
                        if (val_NameCrop.isNotEmpty) {
                          if (nooftrees.text.isNotEmpty &&
                              val_CoffeeType == "FP00005") {
                            if (ttrees >= ntrees) {
                              if (demandQan.text.isNotEmpty) {
                                for (int i = 0;
                                    i < inputDetailList.length;
                                    i++) {
                                  if (val_NameCrop ==
                                          inputDetailList[i].productCode &&
                                      farmerId ==
                                          inputDetailList[i].farmerCode) {
                                    already = true;
                                  }
                                }
                                listNotAdded = false;
                                listAdded = true;
                                if (!already) {
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
                                      registrationDate,
                                      val_CoffeeType,
                                      slct_CoffeeType,
                                      val_NameOrganization,
                                      farmId,
                                      slct_farm,
                                      ttrees.toString(),
                                      int.parse(nooftrees.text).toString());

                                  var inputSummarylist = InputSummary(
                                      inputType: inType,
                                      product: slct_NameCrop,
                                      demandQty: demandQan.text,
                                      productCode: val_NameCrop);
                                  setState(() {
                                    var isAlready = inputSummaryList
                                        .where((element) =>
                                            element.productCode == val_NameCrop)
                                        .toList();
                                    if (isAlready.isEmpty) {
                                      inputSummaryList.add(inputSummarylist);
                                    } else {
                                      isAlready[0].demandQty =
                                          (double.parse(demandQan.text) +
                                                  double.parse(
                                                      isAlready[0].demandQty))
                                              .toString();
                                    }
                                    inputDetailList.add(inputDetaillist);

                                    val_Village = "";
                                    villageName = "";
                                    slctVillage = '';
                                    slctFarmers = null;
                                    farmerId = "";
                                    slct_farmer = '';
                                    frmGender = "";
                                    farmerAge = "";
                                    frmNin = "";
                                    frmMob = "";
                                    slct_NameCrop = "";
                                    demandQan.text = "";
                                    slctNameCrop = null;
                                    slctCoffeeType = null;
                                    val_CoffeeType = "";
                                    slct_CoffeeType = "";
                                    inType = "";
                                    slctFarm = null;
                                    farmId = "";
                                    farmloaded = false;
                                    slct_farm = "";
                                    totTrees.text = "";
                                    farmeritems = [];
                                    nooftrees.text = "";
                                    namecropitems.clear();
                                  });
                                } else {
                                  errordialog(
                                      context,
                                      TranslateFun.langList['infoCls'],
                                      "Add different product");
                                }
                              } else {
                                errordialog(
                                    context,
                                    TranslateFun.langList['infoCls'],
                                    TranslateFun.langList['valDeQtyCls']);
                              }
                            } else {
                              errordialog(
                                  context,
                                  TranslateFun.langList['infoCls'],
                                  "Number of  trees to be fertilized should not be greater than total number of trees ");
                            }
                          } else {
                            errordialog(
                                context,
                                TranslateFun.langList['infoCls'],
                                "Number of  trees to be fertilized should not be empty");
                          }
                        } else {
                          errordialog(context, TranslateFun.langList['infoCls'],
                              TranslateFun.langList['valProdCls']);
                        }
                      } else {
                        errordialog(context, TranslateFun.langList['infoCls'],
                            TranslateFun.langList['valInpTypCls']);
                      }
                      */ /* } else {
                        errordialog(context, TranslateFun.langList['infoCls'],
                            TranslateFun.langList['valMobCls']);
                      }*/ /*
                      */ /*} else {
                        errordialog(context, TranslateFun.langList['infoCls'],
                            TranslateFun.langList['valNINCls']);
                      }*/ /*
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
                      'Farm should not be empty');
                }
              } else {
                errordialog(context, TranslateFun.langList['infoCls'],
                    'Farmer should not be empty');
              }
            } else {
              errordialog(context, TranslateFun.langList['infoCls'],
                  'Village should not be empty');
            }*/
          }));

      if (inputDetailList.isNotEmpty) {
        listings.add(inputListTable());
        listings.add(cardlable_dynamic("Input Demand Summary"));
        listings.add(inputDemandSummary());
      }
    }
    if (val_TransType == "1") {
      listings.add(txt_label_mandatory(
          TranslateFun.langList['dateeCls'], Colors.black, 14.0, false));
      listings.add(selectDate(
          context1: context,
          slctdate: registrationDate,
          onConfirm: (date) => setState(
                () {
                  registrationDate = DateFormat('dd/MM/yyyy').format(date!);
                  registrationFormatedDate =
                      DateFormat('yyyyMMdd').format(date);
                },
              )));

      listings.add(
          txt_label_mandatory("Input Request ID", Colors.black, 14.0, false));
      listings.add(DropDownWithModel(
        itemlist: receiptNoItem,
        selecteditem: slctReceiptNo,
        hint: "Select Input Request ID",
        onChanged: (value) {
          setState(() {
            slctReceiptNo = value!;

            val_ReceiptNo = slctReceiptNo!.value;

            slct_ReceiptNo = slctReceiptNo!.name;
            slctNameCrop = null;
            val_NameCrop = "";
            slct_NameCrop = "";
            inputDetailList1.clear();
            inputDetailList1 = [];
            loadReceiptDetail(val_ReceiptNo);
          });
        },
      ));

      if (inputDetailList1.length > 0) {
        listings.add(inputListTable1());
      }
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
                  if (val_TransType == "0") {
                    btnSubmit();
                  } else if (val_TransType == "1") {
                    btnSubmitDistribution();
                  } else if (slct_TransType.isEmpty) {
                    errordialog(
                        context, "information", "Type should not be empty");
                  }
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

  loadfarm(String farmerId) async {
    String qry_farmlist =
        'select distinct farmIDT,farmName,insDate as prodLand from farm where farmerId = \'' +
            farmerId +
            '\'';

    List farmlist = await db.RawQuery(qry_farmlist);

    farmitems = [];
    farmitems.clear();
    farmlistUIModel = [];

    if (farmlist.length > 0) {
      for (int i = 0; i < farmlist.length; i++) {
        String fName = farmlist[i]["farmName"].toString();
        String farmId = farmlist[i]["farmIDT"].toString();
        String totTrees = farmlist[i]["prodLand"].toString();

        var uimodel = new UImodel3(fName, farmId, totTrees, "");
        farmlistUIModel.add(uimodel);
        setState(() {
          farmitems.add(DropdownModel(fName, farmId));
        });
      }

      //farmloaded
    }

    Future.delayed(Duration(milliseconds: 500), () {
      setState(() {
        if (farmitems.length > 0) {
          slct_farm = '';
          slct_farm = '';
          farmloaded = true;
        }
      });
    });
  }

  farmersearch(String villageCode) async {
    //'select distinct fm.fName as fName,fm.farmerId as farmerId,fk.age as age,fk.gender as gender,fm.mobileNo as mobileNo,fk.mobileNo as nin from farmer_master as fm,farmerkettle as fk where fm.villageId = \'' +
    //             villageCode +
    //
    //             '\' and fk.village = fm.villageId'

    if (villageCode.isNotEmpty) {
      String qry_farmerlist =
          'select distinct farmerCode,fName,lName,inspection,trader,mobileNo,dead,farmerId from farmer_master where villageId = \'' +
              villageCode +
              '\' and blockId = "0"   ';
      //and phoneNo LIKE "%$farmerOrg%"
      List farmerslist = await db.RawQuery(qry_farmerlist);
      print('qry_farmerlist:  ' + farmerslist.toString());

      farmeritems = [];
      farmeritems.clear();
      farmerlistUIModel = [];

      if (farmerslist.length > 0) {
        for (int i = 0; i < farmerslist.length; i++) {
          String gender = "";
          String ageValue = farmerslist[i]["Inspection"].toString();
          print("age value:" + ageValue);
          if (ageValue == "1") {
            gender = "MALE";
          } else {
            gender = "FEMALE";
          }

          String fName = farmerslist[i]["fName"].toString() +
              " " +
              farmerslist[i]['lName'].toString();
          String farmerId = farmerslist[i]["farmerCode"].toString();
          String age = farmerslist[i]["trader"].toString();

          String mobileNo = farmerslist[i]["mobileNo"].toString();
          String nin = farmerslist[i]["dead"].toString();
          String farmerIdd = farmerslist[i]["farmerId"].toString();
          var uimodel = new UImodel5(
              fName, farmerId, age, gender, mobileNo, nin, farmerIdd);
          farmerlistUIModel.add(uimodel);
          setState(() {
            farmeritems.add(DropdownModel(
              fName,
              farmerId,
            ));
          });
        }
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

  calculateDemandQty(String farmerId, String product, String batchNo) async {
    String demandList =
        'select SUM(demandQty) as demandQty from inputDemandList where  farmerId = \'' +
            farmerId +
            '\' and  product = \'' +
            product +
            '\' and  batchNo = \'' +
            batchNo +
            '\' ';
    List demandQtyList = await db.RawQuery(demandList);
    for (int i = 0; i < demandQtyList.length; i++) {
      String demandValue = demandQtyList[0]['demandQty'].toString();
      setState(() {
        if (demandValue != null) {
          demandQan.text = demandValue;
        } else if (demandValue == null) {
          demandQan.text = "0";
        }
      });
      print("Demand value:" + demandValue);
    }
    print('total demand Qty:  ' + demandQtyList.toString());
  }

  loadReceiptNo(String dCode) async {
    List<String> stateCodeL = dCode.split(',').toList();
    List districtCodeList = [];
    List districtCodeQList = [];
    String districtCode = "";
    String districtCodeQ = "";

    for (int s = 0; s < stateCodeL.length; s++) {
      String sName = stateCodeL[s].toString();
      print("SName:" + sName);
      districtCodeQList.add("'$sName'");
      districtCodeList.add(sName);
      //LIKE "%$sName%"

    }

    districtCode = districtCodeList.join(',');
    districtCodeQ = districtCodeQList.join(',');

    String receiptNo =
        'select distinct batchNo  from inputDemandList where districtCode  IN ($districtCodeQ)';
    print("recieptNoQuery:" + receiptNo);
    List receiptNoList = await db.RawQuery(receiptNo);
    print("reception list:" + receiptNoList.toString());
    receiptNoItem.clear();
    // if(farmerId.isNotEmpty&&organization.isNotEmpty) {
    for (int i = 0; i < receiptNoList.length; i++) {
      String receiptNo = receiptNoList[i]['batchNo'].toString();
      String didVal =
          'select  distQty from inputDemandList where  batchNo = \'' +
              receiptNo +
              '\'';
      List didList = await db.RawQuery(didVal);
      String disid = didList[0]['distQty'].toString();
      setState(() {
        did = disid;
        print("distributed qty value:" + did);
        receiptNoItem.add(DropdownModel(
          receiptNo,
          receiptNo,
        ));
      });
    }
    // }
  }

  Widget inputListTable1() {
    List<DataColumn> columns = <DataColumn>[];
    List<DataRow> rows = <DataRow>[];
    columns.add(DataColumn(label: Text('Village')));
    columns.add(DataColumn(label: Text('Farmer')));
    /*columns.add(DataColumn(label: Text('Farm')));
    columns.add(DataColumn(label: Text('Total Number of Trees')));
    columns.add(DataColumn(label: Text('Number of trees to be fertilized')));*/
    columns.add(DataColumn(label: Text('Input Request ID')));
    columns.add(DataColumn(label: Text('Gender')));
    columns.add(DataColumn(label: Text('Age')));
    columns.add(DataColumn(label: Text('NIN')));
    columns.add(DataColumn(label: Text('Mobile')));
    columns.add(DataColumn(label: Text('Product')));
    columns.add(DataColumn(label: Text('Demand Qty')));
    columns.add(DataColumn(label: Text('Distributed Qty')));
    // columns.add(DataColumn(label: Text('Delete')));

    for (int i = 0; i < inputDetailList1.length; i++) {
      List<DataCell> singlecell = <DataCell>[];
      singlecell.add(DataCell(Text(inputDetailList1[i].villName)));
      singlecell.add(DataCell(Text(inputDetailList1[i].farmerName)));
      singlecell.add(DataCell(Text(inputDetailList1[i].batchNo)));
      singlecell.add(DataCell(Text(inputDetailList1[i].gender)));
      singlecell.add(DataCell(Text(inputDetailList1[i].age)));
      singlecell.add(DataCell(Text(inputDetailList1[i].nin)));
      singlecell.add(DataCell(Text(inputDetailList1[i].mobNo)));
      singlecell.add(DataCell(Text(inputDetailList1[i].productName)));
      singlecell.add(DataCell(Text(inputDetailList1[i].demandQty)));

      TextEditingController wtCtlr = TextEditingController();
      wtCtlr.text = inputDetailList1[i].distQty;
      singlecell.add(DataCell(
          TextFormField(
            controller: wtCtlr,
            // initialValue: procurementModel[i].weight,
            keyboardType: TextInputType.number,
            onFieldSubmitted: (val) {
              setState(() {
                if (val.isEmpty) {
                  errordialog(context, "information",
                      "Distributed Quantity should not be empty");
                  wtCtlr.text = inputDetailList1[i].distQty;
                } else if (double.parse(val) <= 0) {
                  errordialog(context, "information",
                      "Distributed Quantity should not be zero");
                  wtCtlr.text = inputDetailList1[i].distQty;
                } else if (double.parse(val) >
                    double.parse(inputDetailList1[i].demandQty)) {
                  errordialog(context, "information",
                      "Distributed Quantity should not be greater than the Demand Quantity");
                  wtCtlr.text = inputDetailList1[i].distQty;
                } else {
                  wtCtlr.text = val;
                  inputDetailList1[i].distQty = wtCtlr.text;
                  // double amount = double.parse(wtCtlr.text) *
                  //     double.parse(procurementModel[i].price);
                  // procurementModel[i].amount = amount.toString();
                  //
                  // /*update weight*/
                  // double existingQuantity =
                  // double.parse(procurementModel[i].weight);
                  // double newQuantity = double.parse(wtCtlr.text);
                  // setState(() {
                  //   procurementModel[i].weight =
                  //       (existingQuantity - newQuantity).toString();
                  // });
                }

                ///

                // procurementModel[i].weight = val;
                // double amount =
                //     double.parse(val) * double.parse(procurementModel[i].price);
                // procurementModel[i].amount = amount.toString();
              });
            },
          ),
          showEditIcon: true));
      // singlecell.add(DataCell(Text(inputDetailList1[i].distQty),showEditIcon: true));

      // singlecell.add(DataCell(InkWell(
      //   onTap: () {
      //     setState(() {
      //       inputDetailList1.removeAt(i);
      //       if (inputDetailList1.length == 0) {
      //         inputDistributionAdded = true;
      //         inputDisListNotAdded = true;
      //         farmerloaded = false;
      //         inputDistListAdded = false;
      //         slctNameOrganization = null;
      //         val_NameOrganization = "";
      //         slct_NameOrganization = "";
      //         slctCoffeeType = null;
      //         val_CoffeeType = "";
      //         slct_CoffeeType = "";
      //         slctState = "";
      //         stateitems.clear();
      //         val_State = "";
      //         slctDistrict = "";
      //         districtitems.clear();
      //         val_District = "";
      //         slctTaluk = "";
      //         cityitems.clear();
      //         val_Taluk = "";
      //         slctCountry = "";
      //         districtLoaded = false;
      //         stateLoaded = false;
      //         cityLoaded = false;
      //         villageLoaded = false;
      //         receiptNoItem.clear();
      //         namecropitems=[];
      //         namecropitems.clear();
      //       }
      //     });
      //   },
      //   child: Icon(
      //     Icons.delete_forever,
      //     color: Colors.red,
      //   ),
      // )));
      rows.add(DataRow(
        cells: singlecell,
      ));
    }

    Widget objWidget = datatable_dynamic(columns: columns, rows: rows);
    return objWidget;
  }

  Widget inputListTable() {
    List<DataColumn> columns = <DataColumn>[];
    List<DataRow> rows = <DataRow>[];

    columns.add(DataColumn(label: Text('Village')));
    columns.add(DataColumn(label: Text('Farmer')));
    columns.add(DataColumn(label: Text('Farm')));
    columns.add(DataColumn(label: Text('Gender')));
    columns.add(DataColumn(label: Text('Age')));
    columns.add(DataColumn(label: Text('NIN')));
    columns.add(DataColumn(label: Text('Mobile')));
    columns.add(DataColumn(label: Text('Total no. of trees')));
    columns.add(DataColumn(label: Text('No of trees to be fertilized')));
    columns.add(DataColumn(label: Text('Input Type')));
    columns.add(DataColumn(label: Text('Product')));
    columns.add(DataColumn(label: Text('Demand Qty')));
    columns.add(DataColumn(label: Text('Delete')));

    for (int i = 0; i < inputDetailList.length; i++) {
      List<DataCell> singlecell = <DataCell>[];

      singlecell.add(DataCell(Text(inputDetailList[i].villageName)));
      singlecell.add(DataCell(Text(inputDetailList[i].farmerName)));
      singlecell.add(DataCell(Text(inputDetailList[i].farmName)));
      singlecell.add(DataCell(Text(inputDetailList[i].gender)));
      singlecell.add(DataCell(Text(inputDetailList[i].age)));
      singlecell.add(DataCell(Text(inputDetailList[i].nin)));
      singlecell.add(DataCell(Text(inputDetailList[i].mobNo)));
      singlecell.add(DataCell(Text(inputDetailList[i].totTrees)));
      singlecell.add(DataCell(Text(inputDetailList[i].noofTrees)));
      singlecell.add(DataCell(Text(inputDetailList[i].inputTypeName)));
      singlecell.add(DataCell(Text(inputDetailList[i].productName)));
      singlecell.add(DataCell(Text(inputDetailList[i].demand)));

      singlecell.add(DataCell(InkWell(
        onTap: () {
          print("///// RTRTRTTT");
          setState(() {
            print("KKKK ${i}");

            inputDetailList.removeAt(i);

            // if(inputDetailList[i].productName==inputSummaryList[i].product){
            //   inputSummaryList[];
            // }
            if (inputDetailList.isEmpty) {
              listNotAdded = true;
              listAdded = false;
              slctNameOrganization = null;
              val_NameOrganization = "";
              slct_NameOrganization = "";
              slctCoffeeType = null;
              val_CoffeeType = "";
              slct_CoffeeType = "";
              slctState = "";
              //stateitems.clear();
              val_State = "";
              slctDistrict = "";
              //districtitems.clear();
              val_District = "";
              slctTaluk = "";
              //cityitems.clear();
              val_Taluk = "";
              slctNameCrop = null;
              val_NameCrop = "";
              slct_NameCrop = "";
              namecropitems.clear();
              slctCountry = "";
              districtLoaded = false;
              stateLoaded = true;
              cityLoaded = false;
              inputSummaryList.clear();
              inputSummaryList = [];
            } else {
              var data = inputSummaryList
                  .where((element) =>
                      element.productCode == inputDetailList[i].productCode)
                  .toList();
              print("demand qty:" + data[0].demandQty);
              if (data.isNotEmpty) {
                print("demand quantity:" + inputDetailList[i].demand);
                data[0].demandQty = (double.parse(data[0].demandQty) -
                        double.parse(inputDetailList[i].demand))
                    .toString();
                print("///// ${data[0].demandQty}");
                print("JJJJ ${data.length}");
                if (double.parse(data[0].demandQty) == 0) {
                  print("delete called for demand:");
                  var ind = inputSummaryList.indexWhere(
                      (element) => element.productCode == data[0].productCode);
                  // data.clear();
                  print("IND ${ind}");
                  inputSummaryList.removeAt(ind);
                  setState(() {});
                }
              }
            }

            print("input detail list:" + inputDetailList.length.toString());
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

  Widget inputDemandSummary() {
    List<DataColumn> columns = <DataColumn>[];
    List<DataRow> rows = <DataRow>[];
    columns.add(DataColumn(label: Text('Input Type')));
    columns.add(DataColumn(label: Text('Product')));
    columns.add(DataColumn(label: Text('Demand Qty')));

    for (int i = 0; i < inputSummaryList.length; i++) {
      List<DataCell> singlecell = <DataCell>[];

      double demQuantity = 0;
      demQuantity += double.parse(inputSummaryList[i].demandQty);

      singlecell.add(DataCell(Text(inputSummaryList[i].inputType)));
      singlecell.add(DataCell(Text(inputSummaryList[i].product)));
      singlecell.add(DataCell(Text(demQuantity.toString())));

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
      //  if (val_NameOrganization.isNotEmpty) {
      //if (val_CoffeeType.isNotEmpty) {
      //if (val_Country.isNotEmpty) {
      if (val_State.isNotEmpty) {
        if (val_District.isNotEmpty) {
          if (val_Taluk.isNotEmpty) {
            if (inputDetailList.isNotEmpty) {
              confirmation();
            } else {
              errordialog(context, TranslateFun.langList['infoCls'],
                  TranslateFun.langList['valAtlstOneCls']);
            }
          } else {
            errordialog(context, TranslateFun.langList['infoCls'],
                'Parish should not be empty');
          }
        } else {
          errordialog(context, TranslateFun.langList['infoCls'],
              'Subcounty should not be empty');
        }
      } else {
        errordialog(context, TranslateFun.langList['infoCls'],
            'District should not be empty');
      }
      /*} else {
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
      }*/
    } else {
      errordialog(context, TranslateFun.langList['infoCls'],
          TranslateFun.langList['valdateCls']);
    }
  }

  void btnSubmitDistribution() {
    if (registrationDate.isNotEmpty) {
      if (val_ReceiptNo.isNotEmpty) {
        // if (val_NameOrganization.isNotEmpty) {
        //   if (val_Country.isNotEmpty) {
        //     if (val_State.isNotEmpty) {
        //       if (val_District.isNotEmpty) {
        //         if (val_Taluk.isNotEmpty) {
        //           if (val_Village.isNotEmpty) {
        //             if (farmerId.isNotEmpty) {
        //               if (inputDetailList1.isNotEmpty) {
        confirmation();
        /*} else {
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
            TranslateFun.langList['valFrmrOrgCls']);
      }
    } */
      } else {
        errordialog(
            context, "information", "Input Request ID should not be empty");
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
              if (val_TransType == "0") {
                saveInputDemand();
              } else {
                saveInputDistribution();
              }

              Navigator.pop(context);
            },
            color: Colors.green,
          )
        ]).show();
  }

  loadReceiptDetail(String recieptNo) async {
    String receiptDetail =
        'select batchNo, farmerId,gender,age,nin,mobNo,product,inputType,demandQty,distQty,warehouseId,t.categoryName,t.productName,village from inputDemandList i,inputType t where  batchNo = \'' +
            recieptNo +
            '\' and i.inputType=t.categoryCode and i.product=t.productCode';
    List receiptList = await db.RawQuery(receiptDetail);

    for (int i = 0; i < receiptList.length; i++) {
      String batchNo = receiptList[i]['batchNo'].toString();
      String farmerId = receiptList[i]['farmerId'].toString();

      String farmerNameList =
          'select fName,lName from farmer_master where farmerCode = \'' +
              farmerId +
              '\' ';
      String farmerName = "";
      String fName = "";
      String lName = "";
      List farList = await db.RawQuery(farmerNameList);
      for (int f = 0; f < farList.length; f++) {
        fName = farList[f]['fName'].toString();
        lName = farList[f]['lName'].toString();
        farmerName = fName + " " + lName;
      }

      String gender = receiptList[i]['gender'].toString();
      String genderName = "";
      if (gender == "0") {
        genderName = "Female";
      } else {
        genderName = "Male";
      }
      String villId = receiptList[i]['village'].toString();

      String villNameList =
          'select villName from villageList where villCode = \'' +
              villId +
              '\' ';
      String villName = "";
      List villList = await db.RawQuery(villNameList);
      for (int v = 0; v < villList.length; v++) {
        villName = villList[v]['villName'].toString();
      }

      String age = receiptList[i]['age'].toString();
      String nin = receiptList[i]['nin'].toString();
      String mobNo = receiptList[i]['mobNo'].toString();
      String productId = receiptList[i]['product'].toString();
      String productName = receiptList[i]['productName'].toString();
      String inputTypeId = receiptList[i]['inputType'].toString();
      String inputTypeName = receiptList[i]['categoryName'].toString();
      String did = receiptList[i]['distQty'].toString();
      String demandQty = receiptList[i]['demandQty'].toString();
      /*String wareHouseId = receiptList[i]['warehouseId'].toString();
      String wareHouseName = receiptList[i]['coName'].toString();*/
      setState(() {
        inputDetailList1.add(InputDetail1(
            batchNo: batchNo,
            villageId: villId,
            villName: villName,
            farmerId: farmerId,
            farmerName: farmerName,
            genderCode: gender,
            gender: genderName,
            age: age,
            nin: nin,
            mobNo: mobNo,
            productId: productId,
            productName: productName,
            inputTypId: inputTypeId,
            inpTypName: inputTypeName,
            demandQty: demandQty,
            did: did,
            distQty: "0",
            wareHouseId: "",
            wareHouseName: ""));

        print("inputDetailList1:" + inputDetailList1.length.toString());
      });
    }
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
        txntime, datas.txn_inputDemand, revNo, '', '', '');
    print('custTransaction : ' + custTransaction.toString());
    String isSynched = "0";

    int inputDemand = await db.saveInputDemand(
        isSynched,
        revNo,
        seasoncode,
        registrationDate,
        val_NameOrganization,
        val_CoffeeType,
        val_Country, //country
        val_State, //district
        val_District, //subcountry
        val_Taluk, // parish
        Lat,
        Lng,
        val_TransType);

    if (inputDetailList.length > 0) {
      for (int i = 0; i < inputDetailList.length; i++) {
        int saveInputDemDetails = await db.saveInputDemandDetail(
          inputDetailList[i].villageCode,
          inputDetailList[i].farmerCode,
          inputDetailList[i].gender,
          inputDetailList[i].age,
          inputDetailList[i].nin,
          inputDetailList[i].mobNo,
          inputDetailList[i].productCode,
          inputDetailList[i].demand,
          revNo.toString(),
          inputDetailList[i].date,
          inputDetailList[i].inputType,
          inputDetailList[i].warehouseId,
          inputDetailList[i].farmId,
          inputDetailList[i].totTrees,
          inputDetailList[i].noofTrees,
        );
        print("savefarmgpslocation" + revNo.toString());
      }
    }
    int issync = await db.UpdateTableValue(
        'inputDemand', 'isSynched', '0', 'recNo', revNo);

    Alert(
      context: context,
      type: AlertType.info,
      title: TranslateFun.langList['txnSuccCls'],
      desc: TranslateFun.langList['inpDemSuccCls'],
      buttons: [
        DialogButton(
          child: Text(
            TranslateFun.langList['okCls'],
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

  void saveInputDistribution() async {
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
        val_TransType);

    if (inputDetailList1.length > 0) {
      for (int i = 0; i < inputDetailList1.length; i++) {
        // saveInputDistributionDetail(
        //     inputDetailList1[i].villageCode,
        //     inputDetailList1[i].farmerCode,
        //     inputDetailList1[i].gender,
        //     inputDetailList1[i].age,
        //     inputDetailList1[i].nin,
        //     inputDetailList1[i].mobNo,
        //     inputDetailList1[i].productCode,
        //     inputDetailList1[i].demand,
        //     inputDetailList1[i].distribute,
        //     revNo.toString(),
        //     inputDetailList1[i].demBatchNo,inputDetailList1[i].btNo);
        int saveInputDemDetails = await db.saveInputDistributionDetail(
            villageCode: inputDetailList1[i].villageId,
            farmer: inputDetailList1[i].farmerId,
            gender: inputDetailList1[i].genderCode,
            age: inputDetailList1[i].age,
            nin: inputDetailList1[i].nin,
            mobNo: inputDetailList1[i].mobNo,
            productCode: inputDetailList1[i].productId,
            demand: inputDetailList1[i].demandQty,
            distribution: inputDetailList1[i].distQty,
            recNo: revNo.toString(),
            demBatchNo: inputDetailList1[i].did,
            demRecNo: inputDetailList1[i].batchNo);
        print("savefarmgpslocation" + revNo.toString());
      }
    }

    int issync = await db.UpdateTableValue(
        'inputDistribution', 'isSynched', '0', 'recNo', revNo);

    // Container(
    //   child: inputDemandSummary(),
    // );
    Alert(
      context: context,
      type: AlertType.info,
      title: "Transaction Successful",
      desc: "Input Distribution/Demand Successful",
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
      date,
      inputType,
      inputTypeName,
      warehouseId,
      farmId,
      farmName,
      totTrees,
      noofTrees;

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
      this.date,
      this.inputType,
      this.inputTypeName,
      this.warehouseId,
      this.farmId,
      this.farmName,
      this.totTrees,
      this.noofTrees);
}

class InputDetail1 {
  String batchNo;
  String villageId;
  String villName;
  String farmerId;
  String farmerName;
  String genderCode;
  String gender;
  String age;
  String nin;
  String mobNo;
  String productId;
  String productName;
  String inputTypId;
  String inpTypName;
  String demandQty;
  String did;
  String distQty;
  String wareHouseId;
  String wareHouseName;

  InputDetail1(
      {required this.batchNo,
      required this.villageId,
      required this.villName,
      required this.farmerId,
      required this.farmerName,
      required this.genderCode,
      required this.gender,
      required this.age,
      required this.nin,
      required this.mobNo,
      required this.productId,
      required this.productName,
      required this.inputTypId,
      required this.inpTypName,
      required this.demandQty,
      required this.did,
      required this.distQty,
      required this.wareHouseId,
      required this.wareHouseName});
}

class InputSummary {
  String inputType;
  String product;
  String demandQty;
  String productCode;

  InputSummary(
      {required this.inputType,
      required this.product,
      required this.demandQty,
      required this.productCode});
}

class StateCode {
  String stateCode;
  StateCode({required this.stateCode});
}
