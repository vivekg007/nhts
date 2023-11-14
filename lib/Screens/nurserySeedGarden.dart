import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Database/Databasehelper.dart';
import '../Model/UIModel.dart';
import '../Model/dynamicfields.dart';
import '../Utils/MandatoryDatas.dart';
import '../commonlang/translateLang.dart';

class nurserySeedGarden extends StatefulWidget {
  const nurserySeedGarden({Key? key}) : super(key: key);

  static String id = 'FLUTTER_NOTIFICATION_CLICK';

  @override
  State<nurserySeedGarden> createState() => _NurserySeedGardenState();
}

class _NurserySeedGardenState extends State<nurserySeedGarden> {
  var db = DatabaseHelper();
  List<Map> agents = [];
  String seasoncode = '';
  String servicePointId = '';
  String agendId = '';
  String Latitude = '', Longitude = '';

  List<UImodel6> inspectionListModel = [];

  List<DropdownModel> nuserySeedItems = [];
  DropdownModel? slctNurserySeed;
  String slct_NurserySeed = "";
  String val_NurserySeed = "";

  String inspectionType = "";
  String inspName = "";

  bool nurseryLoaded = false;
  bool seedGardenLoaded = true;

  String labelDate = "";
  String Date = "";

  String certificationNumber = '';
  String coffeeGardenNurseryName = '';

  List<DropdownModel> applicantNameItems = [];
  DropdownModel? slctApplicantName;
  String slct_ApplicantName = "";
  String val_ApplicantName = "";

  List<DropdownModel> typeNameItems = [];
  DropdownModel? slctTypeName;
  String slct_TypeName = "";
  String val_TypeName = "";

  List<DropdownModel> plottingMaterialItems = [];
  DropdownModel? slctPlottingMaterial;
  String slct_PlottingMaterial = "";
  String val_PlottingMaterial = "";

  List<DropdownModel> blackSoilItems = [];
  DropdownModel? slctBlackSoil;
  String slct_BlackSoil = "";
  String val_BlackSoil = "";

  List<DropdownModel> lakeSandItems = [];
  DropdownModel? slctLakeSand;
  String slct_LakeSand = "";
  String val_LakeSand = "";

  List<DropdownModel> sawDustItems = [];
  DropdownModel? slctSawDust;
  String slct_SawDust = "";
  String val_SawDust = "";

  List<DropdownModel> soilItems = [];
  DropdownModel? slctSoil;
  String slct_Soil = "";
  String val_Soil = "";

  List<DropdownModel> rootingHormoneItems = [];
  DropdownModel? slctRootHormone;
  String slct_RootHormone = "";
  String val_RootHormone = "";

  List<DropdownModel> perforatedItems = [];
  DropdownModel? slctPerforated;
  String slct_Perforated = "";
  String val_Perforated = "";

  List<DropdownModel> reliableWaterItems = [];
  List<DropdownModel> pestItems = [];
  List<DropdownModel> appItems = [];
  DropdownModel? slctReliableWater;
  DropdownModel? slctPest;
  DropdownModel? slctApp;
  String slct_ReliableWater = "";
  String slct_Pest = "";
  String slct_App = "";
  String val_ReliableWater = "";
  String val_Pest = "";
  String val_App = "";

  List<DropdownModel> floatingFacilityItems = [];
  DropdownModel? slctFloatingFacility;
  String slct_FloatingFacility = "";
  String val_FloatingFacility = "";

  List<DropdownModel> pulperItems = [];
  DropdownModel? slctPulper;
  String slct_Pulper = "";
  String val_Pulper = "";

  List<DropdownModel> dryingShedItems = [];
  DropdownModel? slctDryingShed;
  String slct_DryingShed = "";
  String val_DryingShed = "";

  List<DropdownModel> storageFacilityItems = [];
  DropdownModel? slctStorageFacility;
  String slct_StorageFacility = "";
  String val_StorageFacility = "";

  List<DropdownModel> suitableStatusItems = [];
  DropdownModel? slctSuitableStatus;
  String slct_SuitableStatus = "";
  String val_SuitableStatus = "";

  List<DropdownModel> wellDrainedItems = [];
  DropdownModel? slctWellDrained;
  String slct_WellDrained = "";
  String val_WellDrained = "";

  List<DropdownModel> rootingCageItems = [];
  DropdownModel? slctRootingCage;
  String slct_RootingCage = "";
  String val_RootingCage = "";

  List<DropdownModel> hardeningShedItems = [];
  DropdownModel? slctHardeningShed;
  String slct_HardeningShed = "";
  String val_HardeningShed = "";

  List<DropdownModel> demonPlotItems = [];
  DropdownModel? slctDemonPlot;
  String slct_DemonPlot = "";
  String val_DemonPlot = "";

  List<DropdownModel> sanitaryItems = [];
  DropdownModel? slctSanitary;
  String slct_Sanitary = "";
  String val_Sanitary = "";

  List<DropdownModel> officeWithRecordItems = [];
  DropdownModel? slctOfficeRecord;
  String slct_OfficeRecord = "";
  String val_OfficeRecord = "";

  List<DropdownModel> garbageDisposalItems = [];
  DropdownModel? slctGarbageDisposal;
  String slct_GarbageDisposal = "";
  String val_GarbageDisposal = "";

  List<DropdownModel> nurseryProItems = [];
  DropdownModel? slctNurseryPropagation;
  String slct_NurseryPropagation = "";
  String val_NurseryPropagation = "";

  List<DropdownModel> indiCoffeeVarItems = [];
  DropdownModel? slctIndiCoffVar;
  String slct_IndiCoffVar = "";
  String val_IndiCoffVar = "";

  List<DropdownModel> vegetativeItems = [];
  DropdownModel? slctVegetativeItems;
  String slct_Vegetative = "";
  String val_Vegetative = "";

  List<DropdownModel> recCoffVarItems = [];
  DropdownModel? slctRecCoffVarItems;
  String slct_RecCoffVar = "";
  String val_RecCoffVar = "";

  File? inspImageFile;
  String inspImg = "";
  TextEditingController recommendations = new TextEditingController();

  TextEditingController plottingMatC = new TextEditingController();
  TextEditingController blackSoilC = new TextEditingController();
  TextEditingController lakeSandC = new TextEditingController();
  TextEditingController sawDustC = new TextEditingController();
  TextEditingController soilC = new TextEditingController();
  TextEditingController rootingC = new TextEditingController();
  TextEditingController perforatedC = new TextEditingController();
  TextEditingController reliableWaterC = new TextEditingController();
  TextEditingController pestC = new TextEditingController();
  TextEditingController appC = new TextEditingController();
  TextEditingController floatingC = new TextEditingController();
  TextEditingController pulperC = new TextEditingController();
  TextEditingController dryingShedC = new TextEditingController();
  TextEditingController storageC = new TextEditingController();
  TextEditingController wellDrainedC = new TextEditingController();
  TextEditingController rootingCageC = new TextEditingController();
  TextEditingController hardeningC = new TextEditingController();
  TextEditingController demonstrationC = new TextEditingController();
  TextEditingController sanitaryC = new TextEditingController();
  TextEditingController officeRecordC = new TextEditingController();
  TextEditingController garbageC = new TextEditingController();
  TextEditingController nurseryC = new TextEditingController();
  TextEditingController labelIndiC = new TextEditingController();
  TextEditingController gardenC = new TextEditingController();
  TextEditingController recCoffVarC = new TextEditingController();
  TextEditingController suitableC = new TextEditingController();
  TextEditingController amtSeedProcure = new TextEditingController();
  String capacity = "";

  String villageId = "";
  String operatorName = "";
  String insId = "";
  String opName = '';
  String district = '';
  String districtCode = '';
  String districtCodeQ = '';

  @override
  void initState() {
    super.initState();

    initvalues();
    getClientData();

    getLocation();
  }

  Future<void> initvalues() async {
    // List statusList = [
    //   {"property_value": "Suitable", "DISP_SEQ": "0"},
    //   {"property_value": "Not Suitable", "DISP_SEQ": "1"}
    // ];

    List satisficatoryList = await db.RawQuery(
        'select * from animalCatalog where catalog_code = \'' + "283" + '\'');
    print(' shadeTreeList' + satisficatoryList.toString());

    for (int i = 0; i < satisficatoryList.length; i++) {
      String typurchseName = satisficatoryList[i]["property_value"].toString();
      String typurchseCode = satisficatoryList[i]["DISP_SEQ"].toString();

      setState(() {
        plottingMaterialItems.add(DropdownModel(
          typurchseName,
          typurchseCode,
        ));
      });
    }

    for (int i = 0; i < satisficatoryList.length; i++) {
      String typurchseName = satisficatoryList[i]["property_value"].toString();
      String typurchseCode = satisficatoryList[i]["DISP_SEQ"].toString();

      setState(() {
        blackSoilItems.add(DropdownModel(
          typurchseName,
          typurchseCode,
        ));
      });
    }

    for (int i = 0; i < satisficatoryList.length; i++) {
      String typurchseName = satisficatoryList[i]["property_value"].toString();
      String typurchseCode = satisficatoryList[i]["DISP_SEQ"].toString();

      setState(() {
        lakeSandItems.add(DropdownModel(
          typurchseName,
          typurchseCode,
        ));
      });
    }

    for (int i = 0; i < satisficatoryList.length; i++) {
      String typurchseName = satisficatoryList[i]["property_value"].toString();
      String typurchseCode = satisficatoryList[i]["DISP_SEQ"].toString();

      setState(() {
        sawDustItems.add(DropdownModel(
          typurchseName,
          typurchseCode,
        ));
      });
    }

    for (int i = 0; i < satisficatoryList.length; i++) {
      String typurchseName = satisficatoryList[i]["property_value"].toString();
      String typurchseCode = satisficatoryList[i]["DISP_SEQ"].toString();

      setState(() {
        rootingHormoneItems.add(DropdownModel(
          typurchseName,
          typurchseCode,
        ));
      });
    }

    for (int i = 0; i < satisficatoryList.length; i++) {
      String typurchseName = satisficatoryList[i]["property_value"].toString();
      String typurchseCode = satisficatoryList[i]["DISP_SEQ"].toString();

      setState(() {
        perforatedItems.add(DropdownModel(
          typurchseName,
          typurchseCode,
        ));
      });
    }

    for (int i = 0; i < satisficatoryList.length; i++) {
      String typurchseName = satisficatoryList[i]["property_value"].toString();
      String typurchseCode = satisficatoryList[i]["DISP_SEQ"].toString();

      setState(() {
        reliableWaterItems.add(DropdownModel(
          typurchseName,
          typurchseCode,
        ));
      });
    }

    for (int i = 0; i < satisficatoryList.length; i++) {
      String typurchseName = satisficatoryList[i]["property_value"].toString();
      String typurchseCode = satisficatoryList[i]["DISP_SEQ"].toString();

      setState(() {
        pestItems.add(DropdownModel(
          typurchseName,
          typurchseCode,
        ));
      });
    }

    for (int i = 0; i < satisficatoryList.length; i++) {
      String typurchseName = satisficatoryList[i]["property_value"].toString();
      String typurchseCode = satisficatoryList[i]["DISP_SEQ"].toString();

      setState(() {
        appItems.add(DropdownModel(
          typurchseName,
          typurchseCode,
        ));
      });
    }

    for (int i = 0; i < satisficatoryList.length; i++) {
      String typurchseName = satisficatoryList[i]["property_value"].toString();
      String typurchseCode = satisficatoryList[i]["DISP_SEQ"].toString();

      setState(() {
        storageFacilityItems.add(DropdownModel(
          typurchseName,
          typurchseCode,
        ));
      });
    }

    for (int i = 0; i < satisficatoryList.length; i++) {
      String typurchseName = satisficatoryList[i]["property_value"].toString();
      String typurchseCode = satisficatoryList[i]["DISP_SEQ"].toString();

      setState(() {
        wellDrainedItems.add(DropdownModel(
          typurchseName,
          typurchseCode,
        ));
      });
    }

    for (int i = 0; i < satisficatoryList.length; i++) {
      String typurchseName = satisficatoryList[i]["property_value"].toString();
      String typurchseCode = satisficatoryList[i]["DISP_SEQ"].toString();

      setState(() {
        rootingCageItems.add(DropdownModel(
          typurchseName,
          typurchseCode,
        ));
      });
    }

    for (int i = 0; i < satisficatoryList.length; i++) {
      String typurchseName = satisficatoryList[i]["property_value"].toString();
      String typurchseCode = satisficatoryList[i]["DISP_SEQ"].toString();

      setState(() {
        hardeningShedItems.add(DropdownModel(
          typurchseName,
          typurchseCode,
        ));
      });
    }

    for (int i = 0; i < satisficatoryList.length; i++) {
      String typurchseName = satisficatoryList[i]["property_value"].toString();
      String typurchseCode = satisficatoryList[i]["DISP_SEQ"].toString();

      setState(() {
        demonPlotItems.add(DropdownModel(
          typurchseName,
          typurchseCode,
        ));
      });
    }

    for (int i = 0; i < satisficatoryList.length; i++) {
      String typurchseName = satisficatoryList[i]["property_value"].toString();
      String typurchseCode = satisficatoryList[i]["DISP_SEQ"].toString();

      setState(() {
        sanitaryItems.add(DropdownModel(
          typurchseName,
          typurchseCode,
        ));
      });
    }

    for (int i = 0; i < satisficatoryList.length; i++) {
      String typurchseName = satisficatoryList[i]["property_value"].toString();
      String typurchseCode = satisficatoryList[i]["DISP_SEQ"].toString();

      setState(() {
        officeWithRecordItems.add(DropdownModel(
          typurchseName,
          typurchseCode,
        ));
      });
    }

    for (int i = 0; i < satisficatoryList.length; i++) {
      String typurchseName = satisficatoryList[i]["property_value"].toString();
      String typurchseCode = satisficatoryList[i]["DISP_SEQ"].toString();

      setState(() {
        garbageDisposalItems.add(DropdownModel(
          typurchseName,
          typurchseCode,
        ));
      });
    }

    for (int i = 0; i < satisficatoryList.length; i++) {
      String typurchseName = satisficatoryList[i]["property_value"].toString();
      String typurchseCode = satisficatoryList[i]["DISP_SEQ"].toString();

      setState(() {
        nurseryProItems.add(DropdownModel(
          typurchseName,
          typurchseCode,
        ));
      });
    }

    for (int i = 0; i < satisficatoryList.length; i++) {
      String typurchseName = satisficatoryList[i]["property_value"].toString();
      String typurchseCode = satisficatoryList[i]["DISP_SEQ"].toString();

      setState(() {
        indiCoffeeVarItems.add(DropdownModel(
          typurchseName,
          typurchseCode,
        ));
      });
    }

    for (int i = 0; i < satisficatoryList.length; i++) {
      String typurchseName = satisficatoryList[i]["property_value"].toString();
      String typurchseCode = satisficatoryList[i]["DISP_SEQ"].toString();

      setState(() {
        vegetativeItems.add(DropdownModel(
          typurchseName,
          typurchseCode,
        ));
      });
    }

    for (int i = 0; i < satisficatoryList.length; i++) {
      String typurchseName = satisficatoryList[i]["property_value"].toString();
      String typurchseCode = satisficatoryList[i]["DISP_SEQ"].toString();

      setState(() {
        recCoffVarItems.add(DropdownModel(
          typurchseName,
          typurchseCode,
        ));
      });
    }

    for (int i = 0; i < satisficatoryList.length; i++) {
      String typurchseName = satisficatoryList[i]["property_value"].toString();
      String typurchseCode = satisficatoryList[i]["DISP_SEQ"].toString();

      setState(() {
        soilItems.add(DropdownModel(
          typurchseName,
          typurchseCode,
        ));
      });
    }

    for (int i = 0; i < satisficatoryList.length; i++) {
      String typurchseName = satisficatoryList[i]["property_value"].toString();
      String typurchseCode = satisficatoryList[i]["DISP_SEQ"].toString();

      setState(() {
        floatingFacilityItems.add(DropdownModel(
          typurchseName,
          typurchseCode,
        ));
      });
    }

    for (int i = 0; i < satisficatoryList.length; i++) {
      String typurchseName = satisficatoryList[i]["property_value"].toString();
      String typurchseCode = satisficatoryList[i]["DISP_SEQ"].toString();

      setState(() {
        pulperItems.add(DropdownModel(
          typurchseName,
          typurchseCode,
        ));
      });
    }

    for (int i = 0; i < satisficatoryList.length; i++) {
      String typurchseName = satisficatoryList[i]["property_value"].toString();
      String typurchseCode = satisficatoryList[i]["DISP_SEQ"].toString();

      setState(() {
        dryingShedItems.add(DropdownModel(
          typurchseName,
          typurchseCode,
        ));
      });
    }
    List statusList = await db.RawQuery(
        'select * from animalCatalog where catalog_code = \'' + "282" + '\'');
    print(' statusList' + statusList.toString());
    suitableStatusItems.clear();
    for (int i = 0; i < statusList.length; i++) {
      String typurchseName = statusList[i]["property_value"].toString();
      String typurchseCode = statusList[i]["DISP_SEQ"].toString();

      setState(() {
        suitableStatusItems.add(DropdownModel(
          typurchseName,
          typurchseCode,
        ));
      });
    }

    loadNurseryData();
  }

  loadNurseryData() async {
    String stateCodeValue = district;
    List districtCodeList = [];
    List districtCodeQList = [];
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
        String sName = stateNameList[s]['stateName'].toString();
        print("SName:" + sName);
        districtCodeQList.add("'$sName'");
        districtCodeList.add(sName);
        //LIKE "%$sName%"

      }
      districtCode = districtCodeList.join(',');
      districtCodeQ = districtCodeQList.join(',');
      print("districtCode:" + districtCodeQ);
    }

    List nurserySeedList = await db.RawQuery(
        'select distinct insVill,insId,insParish,insName,stockType,insCerNo,insType,insSubCnt,insDist,insAppName,insUniqueId from inspReqData where insDist  IN ($districtCodeQ)');
    print(' nurserySeedList' + nurserySeedList.toString());

    nuserySeedItems.clear();
    for (int i = 0; i < nurserySeedList.length; i++) {
      String typurchseName = nurserySeedList[i]["insAppName"].toString();
      print("inspection id:" + typurchseName);
      String typurchseCode = nurserySeedList[i]["insUniqueId"].toString();
      String insVill = nurserySeedList[i]["insVill"].toString();
      String insType = nurserySeedList[i]["insType"].toString();
      String insAppName = nurserySeedList[i]["insAppName"].toString();
      String insCerNo = nurserySeedList[i]["insCerNo"].toString();
      String insName = nurserySeedList[i]["insName"].toString();
      String insIdValue = nurserySeedList[i]['insId'].toString();
      String cap = nurserySeedList[i]['stockType'].toString();
      var uimodel = new UImodel6(typurchseName, typurchseCode, insVill, insType,
          insAppName, insCerNo, insName, insIdValue, cap);
      inspectionListModel.add(uimodel);
      setState(() {
        nuserySeedItems.add(DropdownModel(
          typurchseName + "-" + typurchseCode,
          typurchseCode,
        ));
      });
    }
  }

  loadVillageId(String villName) async {
    List villList = await db.RawQuery(
        'select villCode from villageList where villName = \'' +
            villName +
            '\'');
    for (int v = 0; v < villList.length; v++) {
      String villCode = villList[v]['villCode'].toString();
      print("inspectionvillage" + villCode);
      setState(() {
        villageId = villCode;
      });
    }
  }

  getClientData() async {
    agents = await db.RawQuery('SELECT * FROM agentMaster');

    seasoncode = agents[0]['currentSeasonCode'];
    servicePointId = agents[0]['servicePointId'];
    agendId = agents[0]['agentId'];
    district = agents[0]['cityCode'];
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
/*                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => DashBoard('name', 'agentid')),
                );*/
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
              "Nursery / Seed Garden" + "\n" + "\t\t\t\t\t\t\t\tInspection",
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

    listings.add(txt_label_mandatory("Date", Colors.black, 14.0, false));
    listings.add(selectDate(
      context1: context,
      slctdate: labelDate,
      onConfirm: (date) => setState(() {
        //HH:mm:ss
        Date = DateFormat('dd-MM-yyyy').format(date!);
        labelDate = DateFormat('dd-MM-yyyy').format(date);
        //print('CHECKJOIINGDFATE:2 '+icsjoiningDate);
      }),
    ));

    listings.add(txt_label_mandatory(
        "Inspection Request ID", Colors.black, 14.0, false));
    listings.add(DropDownWithModel(
      itemlist: nuserySeedItems,
      selecteditem: slctNurserySeed,
      hint: "Select inspection request id",
      onChanged: (value) {
        setState(() {
          slctNurserySeed = value!;
          inspectionType = "";

          coffeeGardenNurseryName = "";
          certificationNumber = "";
          val_NurserySeed = slctNurserySeed!.value;
          print("val_NurserySeed:" + val_NurserySeed);
          slct_NurserySeed = slctNurserySeed!.name;
          opName = slct_NurserySeed.split('-').first;
          print("slctNur" + opName);

          /*refresh value*/
          plottingMatC.clear();
          blackSoilC.clear();
          lakeSandC.clear();
          sawDustC.clear();
          soilC.clear();
          rootingC.clear();
          perforatedC.clear();
          reliableWaterC.clear();
          pestC.clear();
          appC.clear();
          floatingC.clear();
          pulperC.clear();
          dryingShedC.clear();
          storageC.clear();
          wellDrainedC.clear();
          rootingCageC.clear();
          hardeningC.clear();
          demonstrationC.clear();
          sanitaryC.clear();
          officeRecordC.clear();
          garbageC.clear();
          nurseryC.clear();
          labelIndiC.clear();
          gardenC.clear();
          recCoffVarC.clear();
          suitableC.clear();

          slctPlottingMaterial = null;
          slct_PlottingMaterial = "";
          val_PlottingMaterial = "";
          slctBlackSoil = null;
          slct_BlackSoil = "";
          val_BlackSoil = "";
          slctLakeSand = null;
          slct_LakeSand = "";
          val_LakeSand = "";
          slctSawDust = null;
          slct_SawDust = "";
          val_SawDust = "";
          slctSoil = null;
          slct_Soil = "";
          val_Soil = "";
          slctRootHormone = null;
          slct_RootHormone = "";
          val_RootHormone = "";
          slctPerforated = null;
          slct_Perforated = "";
          val_Perforated = "";
          slctReliableWater = null;
          slctPest = null;
          slctApp = null;
          slct_ReliableWater = "";
          slct_Pest = "";
          slct_App = "";
          val_ReliableWater = "";
          val_Pest = "";
          val_App = "";
          slctFloatingFacility = null;
          slct_FloatingFacility = "";
          val_FloatingFacility = "";
          slctPulper = null;
          slct_Pulper = "";
          val_Pulper = "";
          slctDryingShed = null;
          slct_DryingShed = "";
          val_DryingShed = "";
          slctStorageFacility = null;
          slct_StorageFacility = "";
          val_StorageFacility = "";
          inspImageFile = null;
          inspImg = "";
          slctSuitableStatus = null;
          slct_SuitableStatus = "";
          val_SuitableStatus = "";
          slctWellDrained = null;
          slct_WellDrained = "";
          val_WellDrained = "";
          slctRootingCage = null;
          slct_RootingCage = "";
          val_RootingCage = "";
          slctHardeningShed = null;
          slct_HardeningShed = "";
          val_HardeningShed = "";
          slctDemonPlot = null;
          slct_DemonPlot = "";
          val_DemonPlot = "";
          slctSanitary = null;
          slct_Sanitary = "";
          val_Sanitary = "";
          slctOfficeRecord = null;
          slct_OfficeRecord = "";
          val_OfficeRecord = "";
          slctGarbageDisposal = null;
          slct_GarbageDisposal = "";
          val_GarbageDisposal = "";
          slctNurseryPropagation = null;
          slct_NurseryPropagation = "";
          val_NurseryPropagation = "";
          slctIndiCoffVar = null;
          slct_IndiCoffVar = "";
          val_IndiCoffVar = "";
          slctVegetativeItems = null;
          slct_Vegetative = "";
          val_Vegetative = "";
          slctRecCoffVarItems = null;
          slct_RecCoffVar = "";
          val_RecCoffVar = "";

          for (int i = 0; i < inspectionListModel.length; i++) {
            print(
                "inspectionListModel[i].value" + inspectionListModel[i].value);
            if (inspectionListModel[i].value == val_NurserySeed) {
              inspectionType = inspectionListModel[i].value3;
              print("inspectionType:" + inspectionType);
              operatorName = inspectionListModel[i].value4;
              certificationNumber = inspectionListModel[i].value5;
              String villName = inspectionListModel[i].value2;
              //loadVillageId(villName);
              villageId = inspectionListModel[i].value2;
              coffeeGardenNurseryName = inspectionListModel[i].value6;
              insId = inspectionListModel[i].value7;
              capacity = inspectionListModel[i].value8;
              print("inspectionvillage:" + villageId);
            } else {
              print("not equal value");
            }
          }
        });
      },
    ));

    if (inspectionType == "0") {
      listings.add(
          txt_label_mandatory("Operators Name", Colors.black, 14.0, false));
      listings.add(cardlable_dynamic(operatorName));
      listings.add(txt_label_mandatory(
          "Registration number", Colors.black, 14.0, false));
      listings.add(cardlable_dynamic(certificationNumber));

      listings.add(
          txt_label_mandatory("Application Type", Colors.black, 14.0, false));
      listings.add(cardlable_dynamic("Seed Garden"));

      listings.add(txt_label_mandatory(
          "Coffee seed garden name", Colors.black, 14.0, false));
      listings.add(cardlable_dynamic(coffeeGardenNurseryName));

      listings.add(txt_label_mandatory(
          "Source Initial Planting", Colors.black, 14.0, false));
      listings.add(DropDownWithModel(
        itemlist: plottingMaterialItems,
        selecteditem: slctPlottingMaterial,
        hint: "Select Source Initial Planting",
        onChanged: (value) {
          setState(() {
            slctPlottingMaterial = value!;
            val_PlottingMaterial = slctPlottingMaterial!.value;
            slct_PlottingMaterial = slctPlottingMaterial!.name;
          });
        },
      ));

      listings.add(txt_label("Area of improvement", Colors.black, 14.0, false));
      listings.add(txtfield_dynamic("Area of improvement", plottingMatC, true));

      listings
          .add(txt_label_mandatory("Accessibility", Colors.black, 14.0, false));
      listings.add(DropDownWithModel(
        itemlist: blackSoilItems,
        selecteditem: slctBlackSoil,
        hint: "Select Accessibility",
        onChanged: (value) {
          setState(() {
            slctBlackSoil = value!;
            val_BlackSoil = slctBlackSoil!.value;
            slct_BlackSoil = slctBlackSoil!.name;
          });
        },
      ));

      listings.add(txt_label("Area of improvement", Colors.black, 14.0, false));
      listings.add(txtfield_dynamic("Area of improvement", blackSoilC, true));

      listings.add(
          txt_label_mandatory("Drying Surface", Colors.black, 14.0, false));
      listings.add(DropDownWithModel(
        itemlist: lakeSandItems,
        selecteditem: slctLakeSand,
        hint: "Select Drying Surface",
        onChanged: (value) {
          setState(() {
            slctLakeSand = value!;
            val_LakeSand = slctLakeSand!.value;
            slct_LakeSand = slctLakeSand!.name;
          });
        },
      ));

      listings.add(txt_label("Area of improvement", Colors.black, 14.0, false));
      listings.add(txtfield_dynamic("Area of improvement", lakeSandC, true));

      listings.add(txt_label_mandatory("Pulpers", Colors.black, 14.0, false));
      listings.add(DropDownWithModel(
        itemlist: sawDustItems,
        selecteditem: slctSawDust,
        hint: "Select Pulpers",
        onChanged: (value) {
          setState(() {
            slctSawDust = value!;
            val_SawDust = slctSawDust!.value;
            slct_SawDust = slctSawDust!.name;
          });
        },
      ));

      listings.add(txt_label("Area of improvement", Colors.black, 14.0, false));
      listings.add(txtfield_dynamic("Area of improvement", sawDustC, true));

      listings.add(
          txt_label_mandatory("Source of Water", Colors.black, 14.0, false));
      listings.add(DropDownWithModel(
        itemlist: soilItems,
        selecteditem: slctSoil,
        hint: "Select Source of Water",
        onChanged: (value) {
          setState(() {
            slctSoil = value!;
            val_Soil = slctSoil!.value;
            slct_Soil = slctSoil!.name;
          });
        },
      ));

      listings.add(txt_label("Area of improvement", Colors.black, 14.0, false));
      listings.add(txtfield_dynamic("Area of improvement", soilC, true));

      listings.add(
          txt_label_mandatory("Storage Facilities", Colors.black, 14.0, false));
      listings.add(DropDownWithModel(
        itemlist: rootingHormoneItems,
        selecteditem: slctRootHormone,
        hint: "Select Storage Facilities",
        onChanged: (value) {
          setState(() {
            slctRootHormone = value!;
            val_RootHormone = slctRootHormone!.value;
            slct_RootHormone = slctRootHormone!.name;
          });
        },
      ));

      listings.add(txt_label("Area of improvement", Colors.black, 14.0, false));
      listings.add(txtfield_dynamic("Area of improvement", rootingC, true));

      listings.add(txt_label_mandatory(
          "Coffee Variety Planted", Colors.black, 14.0, false));
      listings.add(DropDownWithModel(
        itemlist: perforatedItems,
        selecteditem: slctPerforated,
        hint: "Select Coffee Variety Planted",
        onChanged: (value) {
          setState(() {
            slctPerforated = value!;
            val_Perforated = slctPerforated!.value;
            slct_Perforated = slctPerforated!.name;
          });
        },
      ));

      listings.add(txt_label("Area of improvement", Colors.black, 14.0, false));
      listings.add(txtfield_dynamic("Area of improvement", perforatedC, true));

      listings.add(
          txt_label_mandatory("Disease Status", Colors.black, 14.0, false));
      listings.add(DropDownWithModel(
        itemlist: reliableWaterItems,
        selecteditem: slctReliableWater,
        hint: "Select Disease Status",
        onChanged: (value) {
          setState(() {
            slctReliableWater = value!;
            val_ReliableWater = slctReliableWater!.value;
            slct_ReliableWater = slctReliableWater!.name;
          });
        },
      ));

      listings.add(txt_label("Area of improvement", Colors.black, 14.0, false));
      listings
          .add(txtfield_dynamic("Area of improvement", reliableWaterC, true));

      listings
          .add(txt_label_mandatory("Pest Status", Colors.black, 14.0, false));
      listings.add(DropDownWithModel(
        itemlist: pestItems,
        selecteditem: slctPest,
        hint: "Select Pest Status",
        onChanged: (value) {
          setState(() {
            slctPest = value!;
            val_Pest = slctPest!.value;
            slct_Pest = slctPest!.name;
          });
        },
      ));

      listings.add(txt_label("Area of improvement", Colors.black, 14.0, false));
      listings.add(txtfield_dynamic("Area of improvement", pestC, true));

      listings.add(txt_label_mandatory(
          "Application of GAPs", Colors.black, 14.0, false));
      listings.add(DropDownWithModel(
        itemlist: appItems,
        selecteditem: slctApp,
        hint: "Select Application of GAPs",
        onChanged: (value) {
          setState(() {
            slctApp = value!;
            val_App = slctApp!.value;
            slct_App = slctApp!.name;
          });
        },
      ));

      listings.add(txt_label("Area of improvement", Colors.black, 14.0, false));
      listings.add(txtfield_dynamic("Area of improvement", appC, true));

      /*listings.add(txt_label_mandatory(
        "A floating facility", Colors.black, 14.0, false));
    listings.add(DropDownWithModel(
      itemlist: floatingFacilityItems,
      selecteditem: slctFloatingFacility,
      hint: "Select floating facility",
      onChanged: (value) {
        setState(() {
          slctFloatingFacility = value!;
          val_FloatingFacility = slctFloatingFacility!.value;
          slct_FloatingFacility = slctFloatingFacility!.name;
        });
      },
    ));

    listings.add(txt_label("Area of improvement", Colors.black, 14.0, false));
    listings.add(txtfield_dynamic("Area of improvement", floatingC, true));

    listings.add(txt_label_mandatory("A pulper", Colors.black, 14.0, false));
    listings.add(DropDownWithModel(
      itemlist: pulperItems,
      selecteditem: slctPulper,
      hint: "Select pulper",
      onChanged: (value) {
        setState(() {
          slctPulper = value!;
          val_Pulper = slctPulper!.value;
          slct_Pulper = slctPulper!.name;
        });
      },
    ));

    listings.add(txt_label("Area of improvement", Colors.black, 14.0, false));
    listings.add(txtfield_dynamic("Area of improvement", pulperC, true));

    listings
        .add(txt_label_mandatory("A drying shed", Colors.black, 14.0, false));
    listings.add(DropDownWithModel(
      itemlist: dryingShedItems,
      selecteditem: slctDryingShed,
      hint: "Select drying shed",
      onChanged: (value) {
        setState(() {
          slctDryingShed = value!;
          val_DryingShed = slctDryingShed!.value;
          slct_DryingShed = slctDryingShed!.name;
        });
      },
    ));

    listings.add(txt_label("Area of improvement", Colors.black, 14.0, false));
    listings.add(txtfield_dynamic("Area of improvement", dryingShedC, true));

    listings.add(
        txt_label_mandatory("Storage facility", Colors.black, 14.0, false));
    listings.add(DropDownWithModel(
      itemlist: storageFacilityItems,
      selecteditem: slctStorageFacility,
      hint: "Select storage facility",
      onChanged: (value) {
        setState(() {
          slctStorageFacility = value!;
          val_StorageFacility = slctStorageFacility!.value;
          slct_StorageFacility = slctStorageFacility!.name;
        });
      },
    ));

    listings.add(txt_label("Area of improvement", Colors.black, 14.0, false));
    listings.add(txtfield_dynamic("Area of improvement", storageC, true));*/

      listings.add(txt_label_mandatory("Photo", Colors.black, 14.0, false));

      listings.add(img_picker(
          label: "Photo \*",
          onPressed: () {
            imageDialog("Seed");
          },
          filename: inspImageFile,
          ondelete: () {
            ondelete("Seed");
          }));

      listings.add(
          txt_label_mandatory("Recommendations", Colors.black, 14.0, false));
      listings
          .add(txtFieldLargeDynamic("Recommendations", recommendations, true));

      listings.add(
          txt_label_mandatory("Suitable Status", Colors.black, 14.0, false));
      listings.add(DropDownWithModel(
        itemlist: suitableStatusItems,
        selecteditem: slctSuitableStatus,
        hint: "Select suitable status",
        onChanged: (value) {
          setState(() {
            slctSuitableStatus = value!;
            val_SuitableStatus = slctSuitableStatus!.value;
            slct_SuitableStatus = slctSuitableStatus!.name;
          });
        },
      ));

      listings.add(txt_label("Area of improvement", Colors.black, 14.0, false));
      listings.add(txtfield_dynamic("Area of improvement", suitableC, true));
    }

    if (inspectionType == "1") {
      listings.add(
          txt_label_mandatory("Operators Name", Colors.black, 14.0, false));
      listings.add(cardlable_dynamic(operatorName));
      listings.add(txt_label_mandatory(
          "Registration number", Colors.black, 14.0, false));
      listings.add(cardlable_dynamic(certificationNumber));
      listings.add(
          txt_label_mandatory("Application Type", Colors.black, 14.0, false));
      listings.add(cardlable_dynamic("Nursery"));

      listings.add(txt_label_mandatory(
          "Coffee nursery name", Colors.black, 14.0, false));
      listings.add(cardlable_dynamic(coffeeGardenNurseryName));

      listings.add(
          txt_label_mandatory("Plotting material", Colors.black, 14.0, false));
      listings.add(DropDownWithModel(
        itemlist: plottingMaterialItems,
        selecteditem: slctPlottingMaterial,
        hint: "Select plotting material",
        onChanged: (value) {
          setState(() {
            slctPlottingMaterial = value!;
            val_PlottingMaterial = slctPlottingMaterial!.value;
            slct_PlottingMaterial = slctPlottingMaterial!.name;
          });
        },
      ));

      listings.add(txt_label("Area of improvement", Colors.black, 14.0, false));
      listings.add(txtfield_dynamic("Area of improvement", plottingMatC, true));

      listings
          .add(txt_label_mandatory("Black soil", Colors.black, 14.0, false));
      listings.add(DropDownWithModel(
        itemlist: blackSoilItems,
        selecteditem: slctBlackSoil,
        hint: "Select black soil",
        onChanged: (value) {
          setState(() {
            slctBlackSoil = value!;
            val_BlackSoil = slctBlackSoil!.value;
            slct_BlackSoil = slctBlackSoil!.name;
          });
        },
      ));

      listings.add(txt_label("Area of improvement", Colors.black, 14.0, false));
      listings.add(txtfield_dynamic("Area of improvement", blackSoilC, true));

      listings.add(txt_label_mandatory("Lake sand", Colors.black, 14.0, false));
      listings.add(DropDownWithModel(
        itemlist: lakeSandItems,
        selecteditem: slctLakeSand,
        hint: "Select lake sand",
        onChanged: (value) {
          setState(() {
            slctLakeSand = value!;
            val_LakeSand = slctLakeSand!.value;
            slct_LakeSand = slctLakeSand!.name;
          });
        },
      ));

      listings.add(txt_label("Area of improvement", Colors.black, 14.0, false));
      listings.add(txtfield_dynamic("Area of improvement", lakeSandC, true));

      listings.add(txt_label_mandatory("Saw dust", Colors.black, 14.0, false));
      listings.add(DropDownWithModel(
        itemlist: sawDustItems,
        selecteditem: slctSawDust,
        hint: "Select saw dust",
        onChanged: (value) {
          setState(() {
            slctSawDust = value!;
            val_SawDust = slctSawDust!.value;
            slct_SawDust = slctSawDust!.name;
          });
        },
      ));

      listings.add(txt_label("Area of improvement", Colors.black, 14.0, false));
      listings.add(txtfield_dynamic("Area of improvement", sawDustC, true));

      listings.add(txt_label_mandatory(
          "Soil rooting hormone", Colors.black, 14.0, false));
      listings.add(DropDownWithModel(
        itemlist: soilItems,
        selecteditem: slctSoil,
        hint: "Select soil rooting hormone",
        onChanged: (value) {
          setState(() {
            slctSoil = value!;
            val_Soil = slctSoil!.value;
            slct_Soil = slctSoil!.name;
          });
        },
      ));

      listings.add(txt_label("Area of improvement", Colors.black, 14.0, false));
      listings.add(txtfield_dynamic("Area of improvement", soilC, true));

      listings.add(txt_label_mandatory(
          "Perforated black polythene pots", Colors.black, 14.0, false));
      listings.add(DropDownWithModel(
        itemlist: perforatedItems,
        selecteditem: slctPerforated,
        hint: "Select perforated black polythene pots",
        onChanged: (value) {
          setState(() {
            slctPerforated = value!;
            val_Perforated = slctPerforated!.value;
            slct_Perforated = slctPerforated!.name;
          });
        },
      ));

      listings.add(txt_label("Area of improvement", Colors.black, 14.0, false));
      listings.add(txtfield_dynamic("Area of improvement", perforatedC, true));

      listings.add(txt_label_mandatory(
          "A reliable water source", Colors.black, 14.0, false));
      listings.add(DropDownWithModel(
        itemlist: reliableWaterItems,
        selecteditem: slctReliableWater,
        hint: "Select reliable water source",
        onChanged: (value) {
          setState(() {
            slctReliableWater = value!;
            val_ReliableWater = slctReliableWater!.value;
            slct_ReliableWater = slctReliableWater!.name;
          });
        },
      ));

      listings.add(txt_label("Area of improvement", Colors.black, 14.0, false));
      listings
          .add(txtfield_dynamic("Area of improvement", reliableWaterC, true));

      listings.add(
          txt_label_mandatory("Storage facility", Colors.black, 14.0, false));
      listings.add(DropDownWithModel(
        itemlist: storageFacilityItems,
        selecteditem: slctStorageFacility,
        hint: "Select storage facility",
        onChanged: (value) {
          setState(() {
            slctStorageFacility = value!;
            val_StorageFacility = slctStorageFacility!.value;
            slct_StorageFacility = slctStorageFacility!.name;
          });
        },
      ));

      listings.add(txt_label("Area of improvement", Colors.black, 14.0, false));
      listings.add(txtfield_dynamic("Area of improvement", storageC, true));

      listings.add(txt_label_mandatory(
          "Well-drained or free draining land", Colors.black, 14.0, false));
      listings.add(DropDownWithModel(
        itemlist: wellDrainedItems,
        selecteditem: slctWellDrained,
        hint: "Select well-drained or free draining land",
        onChanged: (value) {
          setState(() {
            slctWellDrained = value!;
            val_WellDrained = slctWellDrained!.value;
            slct_WellDrained = slctWellDrained!.name;
          });
        },
      ));

      listings.add(txt_label("Area of improvement", Colors.black, 14.0, false));
      listings.add(txtfield_dynamic("Area of improvement", wellDrainedC, true));

      listings.add(txt_label_mandatory(
          "Rooting cage and shed", Colors.black, 14.0, false));
      listings.add(DropDownWithModel(
        itemlist: rootingCageItems,
        selecteditem: slctRootingCage,
        hint: "Select rooting cage and shed",
        onChanged: (value) {
          setState(() {
            slctRootingCage = value!;
            val_RootingCage = slctRootingCage!.value;
            slct_RootingCage = slctRootingCage!.name;
          });
        },
      ));

      listings.add(txt_label("Area of improvement", Colors.black, 14.0, false));
      listings.add(txtfield_dynamic("Area of improvement", rootingCageC, true));

      listings.add(
          txt_label_mandatory("Hardening shed", Colors.black, 14.0, false));
      listings.add(DropDownWithModel(
        itemlist: hardeningShedItems,
        selecteditem: slctHardeningShed,
        hint: "Select hardening shed",
        onChanged: (value) {
          setState(() {
            slctHardeningShed = value!;
            val_HardeningShed = slctHardeningShed!.value;
            slct_HardeningShed = slctHardeningShed!.name;
          });
        },
      ));

      listings.add(txt_label("Area of improvement", Colors.black, 14.0, false));
      listings.add(txtfield_dynamic("Area of improvement", hardeningC, true));

      listings.add(
          txt_label_mandatory("Demonstration plot", Colors.black, 14.0, false));
      listings.add(DropDownWithModel(
        itemlist: demonPlotItems,
        selecteditem: slctDemonPlot,
        hint: "Select demonstration plot",
        onChanged: (value) {
          setState(() {
            slctDemonPlot = value!;
            val_DemonPlot = slctDemonPlot!.value;
            slct_DemonPlot = slctDemonPlot!.name;
          });
        },
      ));

      listings.add(txt_label("Area of improvement", Colors.black, 14.0, false));
      listings
          .add(txtfield_dynamic("Area of improvement", demonstrationC, true));

      listings.add(txt_label_mandatory(
          "Sanitary facilities", Colors.black, 14.0, false));
      listings.add(DropDownWithModel(
        itemlist: sanitaryItems,
        selecteditem: slctSanitary,
        hint: "Select sanitary facilities",
        onChanged: (value) {
          setState(() {
            slctSanitary = value!;
            val_Sanitary = slctSanitary!.value;
            slct_Sanitary = slctSanitary!.name;
          });
        },
      ));

      listings.add(txt_label("Area of improvement", Colors.black, 14.0, false));
      listings.add(txtfield_dynamic("Area of improvement", sanitaryC, true));

      listings.add(txt_label_mandatory(
          "Office with records", Colors.black, 14.0, false));
      listings.add(DropDownWithModel(
        itemlist: officeWithRecordItems,
        selecteditem: slctOfficeRecord,
        hint: "Select office with records",
        onChanged: (value) {
          setState(() {
            slctOfficeRecord = value!;
            val_OfficeRecord = slctOfficeRecord!.value;
            slct_OfficeRecord = slctOfficeRecord!.name;
          });
        },
      ));

      listings.add(txt_label("Area of improvement", Colors.black, 14.0, false));
      listings
          .add(txtfield_dynamic("Area of improvement", officeRecordC, true));

      listings.add(txt_label_mandatory(
          "Garbage disposal facility", Colors.black, 14.0, false));
      listings.add(DropDownWithModel(
        itemlist: garbageDisposalItems,
        selecteditem: slctGarbageDisposal,
        hint: "Select garbage disposal facility",
        onChanged: (value) {
          setState(() {
            slctGarbageDisposal = value!;
            val_GarbageDisposal = slctGarbageDisposal!.value;
            slct_GarbageDisposal = slctGarbageDisposal!.name;
          });
        },
      ));

      listings.add(txt_label("Area of improvement", Colors.black, 14.0, false));
      listings.add(txtfield_dynamic("Area of improvement", garbageC, true));

      listings.add(txt_label_mandatory(
          "Nursery propagation shed", Colors.black, 14.0, false));
      listings.add(DropDownWithModel(
        itemlist: nurseryProItems,
        selecteditem: slctNurseryPropagation,
        hint: "Select nursery propagation shed",
        onChanged: (value) {
          setState(() {
            slctNurseryPropagation = value!;
            val_NurseryPropagation = slctNurseryPropagation!.value;
            slct_NurseryPropagation = slctNurseryPropagation!.name;
          });
        },
      ));

      listings.add(txt_label("Area of improvement", Colors.black, 14.0, false));
      listings.add(txtfield_dynamic("Area of improvement", nurseryC, true));

      listings.add(txt_label_mandatory(
          "Labels indicating the coffee variety", Colors.black, 14.0, false));
      listings.add(DropDownWithModel(
        itemlist: indiCoffeeVarItems,
        selecteditem: slctIndiCoffVar,
        hint: "Select labels indicating the coffee variety",
        onChanged: (value) {
          setState(() {
            slctIndiCoffVar = value!;
            val_IndiCoffVar = slctIndiCoffVar!.value;
            slct_IndiCoffVar = slctIndiCoffVar!.name;
          });
        },
      ));

      listings.add(txt_label("Area of improvement", Colors.black, 14.0, false));
      listings.add(txtfield_dynamic("Area of improvement", labelIndiC, true));

      listings.add(txt_label_mandatory(
          "A garden maintained in a vegetative phase",
          Colors.black,
          14.0,
          false));
      listings.add(DropDownWithModel(
        itemlist: vegetativeItems,
        selecteditem: slctVegetativeItems,
        hint: "Select garden maintained in a vegetative phase",
        onChanged: (value) {
          setState(() {
            slctVegetativeItems = value!;
            val_Vegetative = slctVegetativeItems!.value;
            slct_Vegetative = slctVegetativeItems!.name;
          });
        },
      ));

      listings.add(txt_label("Area of improvement", Colors.black, 14.0, false));
      listings.add(txtfield_dynamic("Area of improvement", gardenC, true));

      listings.add(txt_label_mandatory(
          "Recommended coffee varieties", Colors.black, 14.0, false));
      listings.add(DropDownWithModel(
        itemlist: recCoffVarItems,
        selecteditem: slctRecCoffVarItems,
        hint: "Select recommended coffee varieties",
        onChanged: (value) {
          setState(() {
            slctRecCoffVarItems = value!;
            val_RecCoffVar = slctRecCoffVarItems!.value;
            slct_RecCoffVar = slctRecCoffVarItems!.name;
          });
        },
      ));

      listings.add(txt_label("Area of improvement", Colors.black, 14.0, false));
      listings.add(txtfield_dynamic("Area of improvement", recCoffVarC, true));
      listings.add(
          txt_label_mandatory("Capacity (Kgs)", Colors.black, 14.0, false));
      listings.add(cardlable_dynamic(capacity));

      listings.add(txt_label_mandatory(
          "Amount of Seed Procured", Colors.black, 14.0, false));
      listings.add(
          txtfield_digits("Amount of Seed Procured", amtSeedProcure, true));

      listings.add(txt_label("Status Info", Colors.green, 20.0, true));

      listings.add(txt_label_mandatory("Photo", Colors.black, 14.0, false));

      listings.add(img_picker(
          label: "Photo \*",
          onPressed: () {
            imageDialog("Nursery");
          },
          filename: inspImageFile,
          ondelete: () {
            ondelete("Nursery");
          }));

      listings.add(
          txt_label_mandatory("Recommendations", Colors.black, 14.0, false));
      listings
          .add(txtFieldLargeDynamic("Recommendations", recommendations, true));

      listings.add(
          txt_label_mandatory("Suitable Status", Colors.black, 14.0, false));
      listings.add(DropDownWithModel(
        itemlist: suitableStatusItems,
        selecteditem: slctSuitableStatus,
        hint: "Select suitable status",
        onChanged: (value) {
          setState(() {
            slctSuitableStatus = value!;
            val_SuitableStatus = slctSuitableStatus!.value;
            slct_SuitableStatus = slctSuitableStatus!.name;
          });
        },
      ));

      listings.add(txt_label("Area of improvement", Colors.black, 14.0, false));
      listings.add(txtfield_dynamic("Area of improvement", suitableC, true));
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
                  if (inspectionType == "1") {
                    btnSubmit1();
                  } else {
                    btnSubmit();
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

  void btnSubmit() {
    if (inspImageFile != null) {
      inspImg = inspImageFile!.path;
    }

    if (labelDate.isEmpty) {
      errordialog(context, "Information", "Date should not be empty");
    } else if (slct_NurserySeed.isEmpty) {
      errordialog(
          context, "Information", "Inspection request id should not be empty");
    } else if (slct_PlottingMaterial.isEmpty) {
      errordialog(context, "Information",
          "Source Initial Planting should not be empty");
    } else if (slct_BlackSoil.isEmpty) {
      errordialog(context, "Information", "Accessibility should not be empty");
    } else if (slct_LakeSand.isEmpty) {
      errordialog(context, "Information", "Drying Surface should not be empty");
    } else if (slct_SawDust.isEmpty) {
      errordialog(context, "Information", "Pulpers should not be empty");
    } else if (slct_Soil.isEmpty) {
      errordialog(
          context, "Information", "Source of Water should not be empty");
    } else if (slct_RootHormone.isEmpty) {
      errordialog(
          context, "Information", "Storage Facilities should not be empty");
    } else if (slct_Perforated.isEmpty) {
      errordialog(
          context, "Information", "Coffee Variety Planted should not be empty");
    } else if (slct_ReliableWater.isEmpty) {
      errordialog(context, "Information", "Disease Status should not be empty");
    } else if (slct_Pest.isEmpty) {
      errordialog(context, "Information", "Pest Status should not be empty");
    } else if (slct_App.isEmpty) {
      errordialog(
          context, "Information", "Application of GAPs should not be empty");
    } /*else if (slct_FloatingFacility.isEmpty) {
      errordialog(
          context, "Information", "Floating Facility should not be empty");
    } else if (slct_Pulper.isEmpty) {
      errordialog(context, "Information", "Pulper should not be empty");
    } else if (slct_DryingShed.isEmpty) {
      errordialog(context, "Information", "A drying shed should not be empty");
    } else if (slct_StorageFacility.isEmpty) {
      errordialog(
          context, "Information", "Storage facility should not be empty");
    }*/
    else if (inspImg.isEmpty) {
      errordialog(context, "Information", "Photo should not be empty");
    } else if (recommendations.text.isEmpty) {
      errordialog(
          context, "Information", "Recommendations should not be empty");
    } else if (slct_SuitableStatus.isEmpty) {
      errordialog(
          context, "Information", "Suitable status should not be empty");
    } else {
      confirmation();
    }
  }

  void btnSubmit1() {
    if (inspImageFile != null) {
      inspImg = inspImageFile!.path;
    }

    if (labelDate.isEmpty) {
      errordialog(context, "Information", "Date should not be empty");
    } else if (slct_NurserySeed.isEmpty) {
      errordialog(
          context, "Information", "Inspection type should not be empty");
    } else if (slct_PlottingMaterial.isEmpty) {
      errordialog(
          context, "Information", "Plotting material should not be empty");
    } else if (slct_BlackSoil.isEmpty) {
      errordialog(context, "Information", "Black soil should not be empty");
    } else if (slct_LakeSand.isEmpty) {
      errordialog(context, "Information", "Lake sand should not be empty");
    } else if (slct_SawDust.isEmpty) {
      errordialog(context, "Information", "Saw dust should not be empty");
    } else if (slct_Soil.isEmpty) {
      errordialog(
          context, "Information", "Soil Rooting hormone should not be empty");
    } else if (slct_Perforated.isEmpty) {
      errordialog(context, "Information",
          "Perforated black polythene pots should not be empty");
    } else if (slct_ReliableWater.isEmpty) {
      errordialog(
          context, "Information", "Reliable water source should not be empty");
    } else if (slct_StorageFacility.isEmpty) {
      errordialog(
          context, "Information", "Storage facility should not be empty");
    } else if (slct_WellDrained.isEmpty) {
      errordialog(context, "Information",
          "Well-drained or free draining land should not be empty");
    } else if (slct_RootingCage.isEmpty) {
      errordialog(
          context, "Information", "Rooting cage and shed should not be empty");
    } else if (slct_HardeningShed.isEmpty) {
      errordialog(context, "Information", "Hardening shed should not be empty");
    } else if (slct_DemonPlot.isEmpty) {
      errordialog(
          context, "Information", "Demonstration plot should not be empty");
    } else if (slct_Sanitary.isEmpty) {
      errordialog(
          context, "Information", "Sanitary facilities should not be empty");
    } else if (slct_OfficeRecord.isEmpty) {
      errordialog(
          context, "Information", "Office with records should not be empty");
    } else if (slct_GarbageDisposal.isEmpty) {
      errordialog(context, "Information",
          "Garbage disposal facility should not be empty");
    } else if (slct_NurseryPropagation.isEmpty) {
      errordialog(context, "Information",
          "Nursery propagation shed should not be empty");
    } else if (slct_IndiCoffVar.isEmpty) {
      errordialog(context, "Information",
          "Labels indicating coffee variety should not be empty");
    } else if (slct_Vegetative.isEmpty) {
      errordialog(context, "Information",
          "A garden maintained in a vegetative phase should not be empty");
    } else if (slct_RecCoffVar.isEmpty) {
      errordialog(context, "Information",
          "Recommended coffee varieties should not be empty");
    } else if (amtSeedProcure.text.isEmpty) {
      errordialog(context, "Information",
          "Amount of seed procured should not be empty");
    } else if (inspImg.isEmpty) {
      errordialog(context, "Information", "Photo should not be empty");
    } else if (recommendations.text.isEmpty) {
      errordialog(
          context, "Information", "Recommendations should not be empty");
    } else if (slct_SuitableStatus.isEmpty) {
      errordialog(
          context, "Information", "Suitable status should not be empty");
    } else {
      confirmation();
    }
  }

  imageDialog(String photo) {
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
        title: TranslateFun.langList['picImgCls'],
        desc: TranslateFun.langList['chooseCls'],
        buttons: [
          DialogButton(
            child: Text(
              TranslateFun.langList['galCls'],
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            //onPressed:btncancel ,
            onPressed: () {
              setState(() {
                getImageFromGallery(photo);
                Navigator.pop(context);
              });
            },
            color: Colors.deepOrange,
          ),
          DialogButton(
            child: Text(
              TranslateFun.langList['camCls'],
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            //onPressed:btnok,
            onPressed: () {
              getImageFromCamera(photo);
              Navigator.pop(context);
            },
            color: Colors.green,
          )
        ]).show();
  }

  Future getImageFromCamera(String photo) async {
    var image = await ImagePicker.platform
        .pickImage(source: ImageSource.camera, imageQuality: 30);
    setState(() {
      if (photo == "Seed") {
        inspImageFile = File(image!.path);
      } else if (photo == "Nursery") {
        inspImageFile = File(image!.path);
      }
    });
  }

  Future getImageFromGallery(String photo) async {
    var image = await ImagePicker.platform
        .pickImage(source: ImageSource.gallery, imageQuality: 30);
    setState(() {
      if (photo == "Seed") {
        inspImageFile = File(image!.path);
      } else if (photo == "Nursery") {
        inspImageFile = File(image!.path);
      }
    });
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
              saveNurserySeedGarden();
              Navigator.pop(context);
            },
            color: Colors.green,
          )
        ]).show();
  }

  void ondelete(String photo) {
    setState(() {
      if (photo == "Seed") {
        setState(() {
          inspImageFile = null;
        });
      } else if (photo == "Nursery") {
        setState(() {
          inspImageFile = null;
        });
      }
    });
  }

  void saveNurserySeedGarden() async {
    Random rnd = new Random();
    int recNo = 100000 + rnd.nextInt(999999 - 100000);
    //String revNo = "CTB"+recNo.toString();
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
    Future<List<Map>> txnHeader = db.GetTableValues('txnHeader');

    //CustTransaction
    AppDatas datas = new AppDatas();
    int custTransaction = await db.saveCustTransaction(
        txntime, datas.nurserySeedGardenInspection, revNo, '', '', '');
    print('custTransaction : ' + custTransaction.toString());
    print('dryer inserting');

    String isSynched = "0";
    String latitude = Latitude;
    String longitude = Longitude;
    String recNo1 = revNo;

    int coffeePurchaseData = await db.nurserySeedGarden(
        date: labelDate,
        certificateNum: certificationNumber,
        coffeeSeNuName: coffeeGardenNurseryName,
        plottingMaterial: val_PlottingMaterial,
        blackSoil: val_BlackSoil,
        lakeSand: val_LakeSand,
        sawDust: val_SawDust,
        soil: val_Soil,
        rootHormone: val_RootHormone,
        perforatedPots: val_Perforated,
        relWaterSrc: val_ReliableWater,
        floFacility: val_FloatingFacility,
        pulper: val_Pulper,
        dryShed: val_DryingShed,
        stoFacility: val_StorageFacility,
        photo: inspImg,
        recommendations: recommendations.text,
        suitableStatus: val_SuitableStatus,
        wellDrained: val_WellDrained,
        rootingCage: val_RootingCage,
        hardShed: val_HardeningShed,
        demonPlot: val_DemonPlot,
        sanitaryFac: val_Sanitary,
        offRecords: val_OfficeRecord,
        garDisposal: val_GarbageDisposal,
        nurProShed: val_NurseryPropagation,
        labIndiCoff: val_IndiCoffVar,
        vegPhase: val_Vegetative,
        recCoffVar: val_RecCoffVar,
        recNo: revNo,
        isSynched: '0',
        latitude: Latitude,
        longitude: Longitude,
        seasonCode: seasoncode,
        inspReqId: opName,
        type: insId,
        name: inspectionType,
        perforatedImp: perforatedC.text,
        demPlotImp: demonstrationC.text,
        labelIndiImp: labelIndiC.text,
        sanFacImp: sanitaryC.text,
        wellDrainedImp: wellDrainedC.text,
        soilImp: soilC.text,
        vegPhaseImp: gardenC.text,
        lakeImp: lakeSandC.text,
        dryShedImp: dryingShedC.text,
        pulperImp: pulperC.text,
        sawImp: sawDustC.text,
        nurProImp: nurseryC.text,
        recCoffImp: recCoffVarC.text,
        rootImp: rootingC.text,
        hardShedImp: hardeningC.text,
        stoFacImp: storageC.text,
        garDisImp: garbageC.text,
        plotImp: plottingMatC.text,
        waterImp: reliableWaterC.text,
        blackImp: blackSoilC.text,
        offRecImp: officeRecordC.text,
        floFacImp: floatingC.text,
        rootCageImp: rootingCageC.text,
        villageId: villageId,
        suitableStatusImp: suitableC.text,
        pest: val_Pest,
        appl: val_App,
        pestImp: pestC.text,
        appImp: appC.text,
        capacity: capacity,
        seedProcure: amtSeedProcure.text);
    print("coffee purchase data:" + coffeePurchaseData.toString());

    int issync = await db.UpdateTableValue(
        'coffeeSeedNursery', 'isSynched', '0', 'recNo', revNo);

    Alert(
      context: context,
      type: AlertType.info,
      title: TranslateFun.langList['traCls'],
      desc: "Nursery/Seed garden Inspection Successful",
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
