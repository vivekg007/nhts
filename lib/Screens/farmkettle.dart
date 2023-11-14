import 'dart:async';
import 'dart:io' show File;
import 'dart:math';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Database/Databasehelper.dart';
import '../Model/GeoAreacalculateFarm.dart';
import '../Model/UIModel.dart';
import '../Model/dynamicfields.dart';
import '../Utils/MandatoryDatas.dart';
import '../commonlang/translateLang.dart';
import 'geo_plotting_new.dart';

class farm1 extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _farm1();
  }
}

class _farm1 extends State<farm1> {
  var db = DatabaseHelper();

  String Latitude = '', Longitude = '', Altitude = '';
  bool ishavefarmercode = false;
  bool farmerloaded = false;
  List<UImodel> groupsModel = [];
  List<UImodel> groupPosModel = [];
  List<UImodel> farmingTypeModel = [];
  List<UImodel> groupNameModel = [];
  List<UImodel> groupTypeModel = [];
  List<UImodel> certificationTypeModel = [];
  List<UImodel> countryUIModel = [];
  List<UImodel> zoneUIModel = [];
  List<UImodel> woredaUIModel = [];
  List<UImodel> kebeleUIModel = [];

  List<farmName> farmNameDetail = [];

  bool varietyLoaded = false;

  List<DropdownModel> certificationItems = [];
  DropdownModel? slctcertificationtype;
  String slctcertification = "", val_certification = "";

  List<DropdownModel> villageitems = [];
  DropdownModel? slctvillages;
  String slct_village = "", villageCode = "";

  List<DropdownModel> farmeritems = [];
  DropdownModel? slctFarmers;
  String slct_farmer = "", farmerId = "", farmerAddress = "";
  List<UImodel2> farmerlistUIModel = [];

  List<DropdownModel> countryitems = [];
  DropdownModel? slctcountrys;
  String val_country = '', slctcountry = '';

  List<DropdownModel> zoneitems = [];
  DropdownModel? slctzones;
  String val_zone = '', slctzone = '';

  List<DropdownModel> woredaitems = [];
  DropdownModel? slctworedas;
  String val_woreda = '', slctworeda = '';

  List<DropdownModel> kebeleitems = [];
  DropdownModel? slctkebeles;
  String val_kebele = '', slctkebele = '';

  List<DropdownModel> groupNameitems = [];
  DropdownModel? slctgroupNames;
  String val_groupName = '', slctgroupName = '';

  List<DropdownModel> groupTypeitems = [];
  DropdownModel? slctgroupTypes;
  String val_groupType = '', slctgroupType = '';

  List<DropdownModel> groupPositems = [];
  DropdownModel? slctgroupPoss;
  String val_groupPos = '', slctgroupPos = '';

  List<DropdownModel> farmingtypeItems = [];
  DropdownModel? slctfarmingtype;
  String val_farmingtype = '', slct_farmingtype = '';

  bool farmdataadded = false;

  List<Map> agents = [];

  bool zoneloaded = false;
  bool woredaloaded = false;
  bool kebeleloaded = false;

  TextEditingController gardenNameController = new TextEditingController();
  TextEditingController bhigaController = new TextEditingController();
  TextEditingController hectareController = new TextEditingController();
  TextEditingController approximateController = new TextEditingController();
  TextEditingController ikQtyController = new TextEditingController();
  TextEditingController ownerofLandController = new TextEditingController();

  String yuthalt = '';
  int elegibleRegister = 0;

  int farmerid = 0;
  bool isregistration = false;

  String seasoncode = '';
  String servicePointId = '';
  String agendId = '';

  String groupSelect = "";

  String group = "option1",
      _selectedgroup = "1",
      license = "option1",
      _selectedLicense = "1";

  String enrollmentDate = "",
      enrollmentFormatedDate = "",
      dateofbirth = '',
      dateofbirthFormatedDate = '',
      dateofyear = "";

  //Image files

  String aggregatorImage64 = "";
  String bankImage64 = "";
  String licenseImage64 = "";

  File? aggregatorImageFile;
  File? bankImageFile;
  File? licenseImageFile;

  int curIdLim = 0;
  int resId = 0;
  int curIdLimited = 0;

  // GeoareascalculateFarm? addFarmdata, proposedtotalArea;

  //ucda field list
  File? farmImageFile;
  String farmImage = "";

  List<DropdownModel> typeitems = [];
  DropdownModel? slctType;
  String slct_type = "";
  String val_type = "";

  final List<DropdownMenuItem> varitiesitems = [];
  List<String> Varities = [];
  List<UImodel> varitiesUIModel = [];
  String val_Varities = '';
  String slct_Varities = '';

  // List<DropdownModel> shadeTreeitems = [];
  // DropdownModel? slctShadeTree;
  // String slct_ShadeTree = "";
  // String val_ShadeTree = "";

  final List<DropdownMenuItem> shadeTreeitems = [];
  List<String> shadeTree = [];
  List<UImodel> shadeTreeUIModel = [];
  String valShadeTree = '';
  String slct_ShadeTree = '';

  final List<DropdownMenuItem> goodAgriitems = [];
  List<String> goodAgriPractices = [];
  List<UImodel> goodAgriUIModel = [];
  String valGoodAgri = '';
  String slct_GoodAgri = '';

  final List<DropdownMenuItem> intercropitems = [];
  List<String> interCrop = [];
  List<UImodel> interCropUIModel = [];
  String valInterCrop = '';
  String slctInterCrop = '';

  List<DropdownModel> landOwnerItem = [];
  DropdownModel? slctLandOwner;
  String slct_LandOwner = "";
  String val_LandOwner = "";

  List<DropdownModel> farmerItems = [];
  DropdownModel? slctFarmer;
  String slct_Farmer = "";
  String val_Farmer = "";

  List<DropdownModel> landTopographyItems = [];
  DropdownModel? slctLandTopography;
  String slct_LandTopography = "";
  String val_LandTopography = "";

  List<DropdownModel> landGradientItems = [];
  DropdownModel? slctLandGradient;
  String slct_LandGradient = "";
  String val_LandGradient = "";

  List<DropdownModel> accessRoadItems = [];
  DropdownModel? slctAccessRoad;
  String slct_AccessRoad = "";
  String val_AccessRoad = "";

  final List<DropdownMenuItem> certProgramItems = [];
  List<String> certProgram = [];
  List<UImodel> certProgramUIModel = [];
  String valCertProgram = '';
  String slctCertProgram = '';

  final List<DropdownMenuItem> liveStockItems = [];
  List<String> liveStock = [];
  List<UImodel> liveStockUIModel = [];
  String valLiveStock = '';
  String slctLiveStock = '';

  final List<DropdownMenuItem> otherCropItems = [];
  List<String> otherCrop = [];
  List<UImodel> otherCropUIModel = [];
  String valOtherCrop = '';
  String slctOtherCrop = '';

  List<DropdownModel> soilTypeItems = [];
  DropdownModel? slctSoilType;
  String slct_SoilType = "";
  String val_SoilType = "";

  List<DropdownModel> fertilityStatusItems = [];
  DropdownModel? slctFertilityStatus;
  String slct_FertilityStatus = "";
  String val_FertilityStatus = "";

  List<DropdownModel> irrigationSourceItems = [];
  DropdownModel? slctIrrigationSource;
  String slct_IrrigationSource = "";
  String val_IrrigationSource = "";

  List<DropdownModel> methodIrrigationItems = [];
  DropdownModel? slctIrrigation;
  String slct_Irrigation = "";
  String val_Irrigation = "";

  List<DropdownModel> waterHarvestingItems = [];
  DropdownModel? slctWaterHarvesting;
  String slct_WaterHarvesting = "";
  String val_WaterHarvesting = "";

  TextEditingController farm = new TextEditingController();
  TextEditingController spacingCoffeeHeight = new TextEditingController();
  TextEditingController spacingCoffeeWidth = new TextEditingController();
  TextEditingController yieldEstimate = new TextEditingController();
  TextEditingController totCoffeeAcreage = new TextEditingController();
  TextEditingController proposedCoffee = new TextEditingController();
  TextEditingController avgTrees = new TextEditingController();
  TextEditingController numShadeTrees = new TextEditingController();
  TextEditingController numProductiveTrees = new TextEditingController();
  TextEditingController numUnProductiveTrees = new TextEditingController();
  TextEditingController altitude = new TextEditingController();
  TextEditingController auditedArea = new TextEditingController();
  TextEditingController totNumTrees = new TextEditingController();

  String plantationDate = "", plantationFormattedDate = "";
  String pruningDate = "", pruningFormattedDate = "";
  DateTime? selectedPlantingYear;
  DateTime? selectedBirthYear;

  File? landFile;
  String landFileName = "";
  String landPhotoPath = "";

  String agentType = "";

  bool tyTree = false;

  GeoCalculatedValues? geoCalculatedValues;

  String recordNo = "";

  String farmCodeValue = "";

  final Map<String, String> irriSource = {
    'option1': "NO",
    'option2': "YES",
  };

  String _selectedIrriSoruce = "option1", irriSelect = "0";

  bool irrigationLoaded = false;

  String districtName = "";
  String subCountyName = "";
  String parishName = "";
  String villageName = "";

  List<DropdownMenuItem> districtitems = [],
      cityitems = [],
      stateitems = [],
      ditrictitems = [],
      talukitems = [],
      villageitemss = [];

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
      val_Village = "";

  List<UImodel> stateUIModel = [];
  List<UImodel> districtUIModel = [];
  List<UImodel> cityListUIModel = [];
  List<UImodel> VillageListUIModel = [];

  bool stateLoaded = false;
  bool districtLoaded = false;
  bool cityLoaded = false;
  bool villageLoaded = false;

  String region = "";

  bool yieldEstimates = false;

  @override
  void initState() {
    super.initState();

    initvalues();
    getClientData();
    ChangeStates();

    getLocation();
    getDraft();

    proposedCoffee.addListener(() {
      decimalanddigitval(proposedCoffee.text, proposedCoffee, 7);
    });

    altitude.addListener(() {
      decimalanddigitval(altitude.text, altitude, 7);
    });

    avgTrees.addListener(() {
      decimalanddigitval(avgTrees.text, avgTrees, 7);
    });

    totCoffeeAcreage.addListener(() {
      decimalanddigitval(totCoffeeAcreage.text, totCoffeeAcreage, 7);
    });
    numShadeTrees.addListener(() {
      if (numShadeTrees.text.isNotEmpty &&
          double.parse(numShadeTrees.text) < 1.0) {
        setState(() {
          tyTree = false;
        });
      } else if (numShadeTrees.text.isNotEmpty &&
          double.parse(numShadeTrees.text) >= 1.0) {
        setState(() {
          tyTree = true;
        });
      }
    });

    totNumTrees.addListener(() {
      if (totNumTrees.text.isNotEmpty && numUnProductiveTrees.text.isNotEmpty) {
        if (int.parse(totNumTrees.text) >
            int.parse(numUnProductiveTrees.text)) {
          int ns = int.parse(totNumTrees.text);
          int np = int.parse(numUnProductiveTrees.text);
          int tot = ns - np;
          numProductiveTrees.text = tot.toString();
        } else {
          errordialog(context, "Information",
              "Total Number Of Trees should be greater than Number Of Productive Trees");
          totNumTrees.clear();
          numProductiveTrees.clear();
          numUnProductiveTrees.clear();
        }
      }
    });

    numUnProductiveTrees.addListener(() {
      if (totNumTrees.text.isNotEmpty && numUnProductiveTrees.text.isNotEmpty) {
        if (int.parse(totNumTrees.text) >=
            int.parse(numUnProductiveTrees.text)) {
          int ns = int.parse(totNumTrees.text);
          int np = int.parse(numUnProductiveTrees.text);
          int tot = ns - np;
          numProductiveTrees.text = tot.toString();
        } else {
          errordialog(context, "Information",
              "Number Of Unproductive Trees should be less than or equal to Total Number Of Trees");

          numProductiveTrees.clear();
          numUnProductiveTrees.clear();
        }
      }
    });

    numProductiveTrees.addListener(() {
      if (totNumTrees.text.isNotEmpty && numProductiveTrees.text.isNotEmpty) {
        if (int.parse(totNumTrees.text) < int.parse(numProductiveTrees.text)) {
          errordialog(context, "Information",
              "Number Of Productive Trees should be less than or equal to Total Number Of Trees");
          numUnProductiveTrees.clear();
          numProductiveTrees.clear();
        }
      }
    });

    avgTrees.addListener(() {
      if (avgTrees.text.isNotEmpty && double.parse(avgTrees.text) > 100.0) {
        errordialog(context, "information",
            "Average Age Of Coffee Trees (in years) should not beyond 100 years");
        avgTrees.text = "";
      } else if (avgTrees.text.isNotEmpty && double.parse(avgTrees.text) < 1) {
        yieldEstimate.text = "0.0";
        yieldEstimates = false;
        setState(() {});
      } else if (avgTrees.text.isNotEmpty && double.parse(avgTrees.text) >= 1) {
        setState(() {});
        yieldEstimates = true;
        yieldEstimate.clear();
      }
    });
  }

  farmCodeGeneration(String farmerId) async {
    List farmCodeList = await db.RawQuery(
        'select icsCode,farmerCode from farmer_master where farmerId = \'' +
            farmerId +
            '\'');
    print(' farmCodeList' + farmCodeList.toString());

    String farCode = farmCodeList[0]['icsCode'];

    if (farCode.isNotEmpty) {
      String pName = farCode.split('/')[0];
      String pCode = farCode.split('/')[1];
      String yearCode = farCode.split('/')[2];
      String faCode = farCode.split('/')[3];

      String fCode = farCode.split('/').last;
      print("fCode" + fCode);

      int fCount = int.parse(fCode);
      print("fCountVal:" + fCount.toString());
      setState(() {
        int total = fCount + 1;
        String farmCount = total.toString();
        String farmmCode = "";
        if (total <= 8) {
          farmmCode = pName +
              "/" +
              pCode +
              "/" +
              yearCode +
              "/" +
              faCode +
              "/" +
              "0000" +
              farmCount.toString();
          farmCodeValue = farmmCode;
        } else if (total >= 9 && total < 99) {
          farmmCode = pName +
              "/" +
              pCode +
              "/" +
              yearCode +
              "/" +
              faCode +
              "/" +
              "000" +
              farmCount.toString();
          farmCodeValue = farmmCode;
        } else if (total >= 99 && total < 999) {
          farmmCode = pName +
              "/" +
              pCode +
              "/" +
              yearCode +
              "/" +
              faCode +
              "/" +
              "00" +
              farmCount.toString();
          farmCodeValue = farmmCode;
        }
        print("farmcodefarmcode:" + farmmCode);
      });
    } else {
      String farsCode = farmCodeList[0]['farmerCode'];
      farmCodeValue = farsCode + "/" + "00001";
    }
  }

  getDraft() async {
    String farmQry = 'select * from farmSoufflet where isSynched = "2" ';
    String cList = 'select * from wareHouseList';
    List ccList = await db.RawQuery(cList);
    List farmQryList = await db.RawQuery(farmQry);
    print("farmQryList:" + farmQryList.toString());

    String dropdown = 'select * from catName ';
    List dropdownList = await db.RawQuery(dropdown);
    print("dropdownList:" + dropdownList.toString());

    try {
      EasyLoading.show(status: 'loading...');
      if (farmQryList.isNotEmpty) {
        setState(() {});
        for (int f = 0; f < farmQryList.length; f++) {
          recordNo = farmQryList[f]['recNo'] ?? "";
          villageCode = farmQryList[f]['villageId'] ?? "";
          farmerId = farmQryList[f]['farmerId'] ?? "";
          farmCodeValue = farmQryList[f]['farmIDT'] ?? "";

          if (villageCode.isNotEmpty && farmerId.isNotEmpty) {
            ishavefarmercode = true;
          }

          farm.text = farmQryList[f]['farmName'] ?? "";

          /*spacing of coffee tree*/
          String spTree = farmQryList[f]['spacingTree'] ?? "";
          List<String> shw = spTree.split('*').toList();
          spacingCoffeeWidth.text = shw[1].toString() ?? "";
          spacingCoffeeHeight.text = shw[0].toString() ?? "";
          totCoffeeAcreage.text = farmQryList[f]['totCoffeeAcr'] ?? "";
          proposedCoffee.text = farmQryList[f]['propCoffeeAr'] ?? "";
          auditedArea.text = farmQryList[f]['auditedArea'] ?? "";
          avgTrees.text = farmQryList[f]['avgTree'] ?? "";
          numShadeTrees.text = farmQryList[f]['numTree'] ?? "";
          numProductiveTrees.text = farmQryList[f]['numPrTrees'] ?? "";
          numUnProductiveTrees.text = farmQryList[f]['numUnPrTrees'] ?? "";
          yieldEstimate.text = farmQryList[f]['yieldTree'] ?? "";

          /*shade tree*/
          valShadeTree = farmQryList[f]['typTree'] ?? "";
          slct_ShadeTree = dropdownList[0]['typShTrees'] ?? "";
          totNumTrees.text = farmQryList[f]['landOwner'] ?? "";

          /*plantation date*/
          plantationFormattedDate = farmQryList[f]['plDate'] ?? "";
          plantationDate = dropdownList[0]['plDate'] ?? "";
          /*pruning date*/
          pruningDate = dropdownList[0]['prDate'] ?? "";
          pruningFormattedDate = farmQryList[f]['prDate'] ?? "";

          /*type*/
          slct_type = dropdownList[0]['type'] ?? "";
          val_type = farmQryList[f]['type'] ?? "";
          varietySearch(val_type);
          /*varieties*/
          val_Varities = farmQryList[f]['varieties'] ?? "";
          slct_Varities = dropdownList[0]['varieties'] ?? "";
          varietyLoaded = true;
          /*good agricultural*/
          slct_GoodAgri = dropdownList[0]['goodAgri'] ?? "";
          valGoodAgri = farmQryList[f]['goodAgri'] ?? "";
          /*livestock*/
          slctLiveStock = dropdownList[0]['liveStock'] ?? "";
          valLiveStock = farmQryList[f]['liveStock'] ?? "";
          /*land topography*/
          val_LandTopography = farmQryList[f]['landTopo'] ?? "";
          slct_LandTopography = dropdownList[0]['landTopo'] ?? "";
          /*land gradient*/
          val_LandGradient = farmQryList[f]['landGr'] ?? "";
          slct_LandGradient = dropdownList[0]['landGr'] ?? "";
          /*access road*/
          slct_AccessRoad = dropdownList[0]['accRoad'] ?? "";
          val_AccessRoad = farmQryList[f]['accRoad'] ?? "";
          /*certification program*/
          slctCertProgram = dropdownList[0]['certProgram'] ?? "";
          valCertProgram = farmQryList[f]['certProgram'] ?? "";
          /*other crop*/
          valOtherCrop = farmQryList[f]['otCrop'] ?? "";
          slctOtherCrop = dropdownList[0]['othCrop'] ?? "";
          /*soil type*/
          val_SoilType = farmQryList[f]['soilTyp'] ?? "";
          slct_SoilType = dropdownList[0]['soilType'] ?? "";
          /*fertility status*/
          val_FertilityStatus = farmQryList[f]['fertStatus'] ?? "";
          slct_FertilityStatus = dropdownList[0]['fertStatus'] ?? "";
          /*irrigation source*/
          irriSelect = farmQryList[f]['irriSource'] ?? "";
          if (irriSelect == "1") {
            _selectedIrriSoruce = "option2";
          } else {
            _selectedIrriSoruce = "option1";
          }
          slct_IrrigationSource = dropdownList[0]['irrSource'] ?? "";
          /*method of irrigation*/
          val_Irrigation = farmQryList[f]['metIrr'] ?? "";
          slct_Irrigation = dropdownList[0]['methIrri'] ?? "";
          /*water harvesting*/
          val_WaterHarvesting = farmQryList[f]['watHarMethod'] ?? "";
          slct_WaterHarvesting = dropdownList[0]['watHarvest'] ?? "";
          /*farm photo*/
          String fPhoto = farmQryList[f]['frPhoto'] ?? "";
          File? _beneficiaryimage;
          if (fPhoto.isNotEmpty) {
            _beneficiaryimage = File(fPhoto);
            farmImageFile = _beneficiaryimage;
          }
          /*land title document*/
          String landTitle = farmQryList[f]['landTitleDoc'] ?? "";
          File? laPath;
          if (landTitle.isNotEmpty) {
            laPath = File(landTitle);
            landFile = laPath;
            landFileName = laPath.path.split('/').last;
          }
          altitude.text = farmQryList[f]['altitude'] ?? "";
          val_Village = farmQryList[f]['altitudeValue'] ?? "";
          if (val_Village.isNotEmpty) {
            String villListQry =
                'select cityName,stateName,villName,districtName,d.districtCode,c.cityCode,s.stateCode from cityList c,villageList v,districtList d,stateList s where c.cityCode = v.gpCode and d.districtCode = c.districtCode and s.stateCode = d.stateCode and v.villCode = \'' +
                    val_Village +
                    '\' ';
            List villList = await db.RawQuery(villListQry);
            print("villList:" + villList.toString());

            districtName = villList[0]['stateName'];
            subCountyName = villList[0]['districtName'];
            parishName = villList[0]['cityName'];
            villageName = villList[0]['villName'];
            String sCode = "";
            String dCode = "";
            String cCode = "";
            sCode = villList[0]['stateCode'];

            dCode = villList[0]['districtCode'];
            cCode = villList[0]['cityCode'];
            val_District = dCode;
            val_State = sCode;
            val_Taluk = cCode;
            changeDistrict(sCode);
            changeCity(dCode);
            changeVillage(cCode);
            districtLoaded = true;
            stateLoaded = true;
            cityLoaded = true;
            villageLoaded = true;
          }

          if (ccList.isNotEmpty) {
            val_State = ccList[0]['wareHouseCode'];

            changeDistrict(val_State);
            List regionList = await db.RawQuery(
                'select distinct countryName from countryList c,stateList s where c.countryCode = s.countryCode and s.stateCode =\'' +
                    val_State +
                    '\'');
            List sNList = await db.RawQuery(
                'select distinct stateName from stateList where stateCode =\'' +
                    val_State +
                    '\'');
            districtName = sNList[0]['stateName'];
            if (regionList.isNotEmpty) {
              region = regionList[0]['countryName'].toString();
            }
            val_District = ccList[0]['wareHouseName'];
            val_Taluk = ccList[0]['wareHouseCity'];
            List dNList = await db.RawQuery(
                'select distinct districtName from districtList where districtCode =\'' +
                    val_District +
                    '\'');
            subCountyName = dNList[0]['districtName'];
            List pNList = await db.RawQuery(
                'select distinct cityName from cityList where cityCode =\'' +
                    val_Taluk +
                    '\'');
            parishName = pNList[0]['cityName'];
            changeCity(val_District);
            changeVillage(val_Taluk);
            districtLoaded = true;
            stateLoaded = true;
            cityLoaded = true;
            villageLoaded = true;
          }
        }
      }
    } catch (e) {
      EasyLoading.dismiss();
      print("eee" + e.toString());
    }
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
        String alt =
            double.parse(position.altitude.toString()).round().toString();
        altitude.text = alt;
      });
    } else {
      Alert(
          context: context,
          title: "Information",
          desc: "GPS location not enabled",
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

  @override
  void dispose() {
    super.dispose();
  }

  getClientData() async {
    agents = await db.RawQuery('SELECT * FROM agentMaster');

    seasoncode = agents[0]['currentSeasonCode'];
    servicePointId = agents[0]['servicePointId'];
    agendId = agents[0]['agentId'];
    String resIdd = agents[0]['resIdSeqAgg'];
    agentType = agents[0]['agentType'];
    print("resIdgetcliendata" + resIdd);
    print("agendId_agendId" + agendId);
  }

  Future<void> initvalues() async {
    String qry_villagelist =
        'Select distinct v.villCode,v.villName from villageList as v inner join farmer_master as f on f.villageId =v.villCode';
    print('qry_villagelist:  ' + qry_villagelist);
    List villageslist = await db.RawQuery(qry_villagelist);
    print('villageslist 1:  ' + villageslist.toString());
    villageitems.clear();

    for (int i = 0; i < villageslist.length; i++) {
      String villName = villageslist[i]["villName"].toString();
      String villCode = villageslist[i]["villCode"].toString();
      setState(() {
        villageitems.add(DropdownModel(
          villName,
          villCode,
        ));
      });
    }

    List typeList =
        await db.RawQuery('select distinct vName,vCode from varietyList');
    print(' typeList' + typeList.toString());

    typeitems.clear();
    for (int i = 0; i < typeList.length; i++) {
      String typurchseName = typeList[i]["vName"].toString();
      String typurchseCode = typeList[i]["vCode"].toString();
      var uimodel = new UImodel(typurchseName, typurchseCode);

      setState(() {
        typeitems.add(DropdownModel(
          typurchseName,
          typurchseCode,
        ));
      });
    }

    List shadeTreeList = await db.RawQuery(
        'select * from animalCatalog where catalog_code = \'' + "252" + '\'');
    print(' shadeTreeList' + shadeTreeList.toString());

    shadeTreeitems.clear();
    for (int i = 0; i < shadeTreeList.length; i++) {
      String typurchseName = shadeTreeList[i]["property_value"].toString();
      String typurchseCode = shadeTreeList[i]["DISP_SEQ"].toString();
      var uimodel = new UImodel(typurchseName, typurchseCode);
      shadeTreeUIModel.add(uimodel);

      setState(() {
        shadeTreeitems.add(DropdownMenuItem(
          value: typurchseName,
          child: Text(typurchseName),
        ));
      });
    }

    //
    // shadeTreeitems.clear();
    // shadeTreeUIModel.clear();
    // for (int i = 0; i < shadeTreeList.length; i++) {
    //   String typurchseName = shadeTreeList[i]["property_value"].toString();
    //   String typurchseCode = shadeTreeList[i]["DISP_SEQ"].toString();
    //   var uimodel = new UImodel(typurchseName, typurchseCode);
    //   shadeTreeUIModel.add(uimodel);
    //   setState(() {
    //     shadeTreeitems.add(DropdownMenuItem(
    //       value: typurchseName,
    //       child: Text(typurchseName),
    //     ));
    //   });
    // }

    List agriPracticeList = await db.RawQuery(
        'select * from animalCatalog where catalog_code = \'' + "253" + '\'');
    print(' agriPracticeList' + agriPracticeList.toString());

    goodAgriitems.clear();
    goodAgriUIModel = [];
    for (int i = 0; i < agriPracticeList.length; i++) {
      String typurchseName = agriPracticeList[i]["property_value"].toString();
      String typurchseCode = agriPracticeList[i]["DISP_SEQ"].toString();
      var uimodel = new UImodel(typurchseName, typurchseCode);
      goodAgriUIModel.add(uimodel);

      setState(() {
        goodAgriitems.add(DropdownMenuItem(
          value: typurchseName,
          child: Text(typurchseName),
        ));
      });
    }

    List liveStockList = await db.RawQuery(
        'select * from animalCatalog where catalog_code = \'' + "254" + '\'');
    print(' liveStockList' + liveStockList.toString());

    liveStockItems.clear();
    liveStockUIModel = [];
    for (int i = 0; i < liveStockList.length; i++) {
      String typurchseName = liveStockList[i]["property_value"].toString();
      String typurchseCode = liveStockList[i]["DISP_SEQ"].toString();
      var uimodel = new UImodel(typurchseName, typurchseCode);
      liveStockUIModel.add(uimodel);

      setState(() {
        liveStockItems.add(DropdownMenuItem(
          value: typurchseName,
          child: Text(typurchseName),
        ));
      });
    }

    List certificationList = await db.RawQuery(
        'select * from animalCatalog where catalog_code = \'' + "260" + '\'');
    print(' certificationList' + certificationList.toString());

    certProgramItems.clear();
    certProgramUIModel = [];
    for (int i = 0; i < certificationList.length; i++) {
      String typurchseName = certificationList[i]["property_value"].toString();
      String typurchseCode = certificationList[i]["DISP_SEQ"].toString();
      var uimodel = new UImodel(typurchseName, typurchseCode);
      certProgramUIModel.add(uimodel);

      setState(() {
        certProgramItems.add(DropdownMenuItem(
          value: typurchseName,
          child: Text(typurchseName),
        ));
      });
    }

    List landOwnerList = await db.RawQuery(
        'select * from animalCatalog where catalog_code = \'' + "35" + '\'');
    print(' landOwnerList' + landOwnerList.toString());

    landOwnerItem.clear();
    for (int i = 0; i < landOwnerList.length; i++) {
      String typurchseName = landOwnerList[i]["property_value"].toString();
      String typurchseCode = landOwnerList[i]["DISP_SEQ"].toString();
      var uimodel = new UImodel(typurchseName, typurchseCode);

      setState(() {
        landOwnerItem.add(DropdownModel(
          typurchseName,
          typurchseCode,
        ));
      });
    }

    List landTopographyList = await db.RawQuery(
        'select * from animalCatalog where catalog_code = \'' + "257" + '\'');
    print(' landTopographyList' + landTopographyList.toString());

    landTopographyItems.clear();
    for (int i = 0; i < landTopographyList.length; i++) {
      String typurchseName = landTopographyList[i]["property_value"].toString();
      String typurchseCode = landTopographyList[i]["DISP_SEQ"].toString();
      var uimodel = new UImodel(typurchseName, typurchseCode);

      setState(() {
        landTopographyItems.add(DropdownModel(
          typurchseName,
          typurchseCode,
        ));
      });
    }

    List landGradientlist = await db.RawQuery(
        'select * from animalCatalog where catalog_code = \'' + "258" + '\'');
    print(' landGradientlist' + landGradientlist.toString());

    landGradientItems.clear();
    for (int i = 0; i < landGradientlist.length; i++) {
      String typurchseName = landGradientlist[i]["property_value"].toString();
      String typurchseCode = landGradientlist[i]["DISP_SEQ"].toString();
      var uimodel = new UImodel(typurchseName, typurchseCode);

      setState(() {
        landGradientItems.add(DropdownModel(
          typurchseName,
          typurchseCode,
        ));
      });
    }

    List accessRoadList = await db.RawQuery(
        'select * from animalCatalog where catalog_code = \'' + "259" + '\'');
    print(' accessRoadList' + accessRoadList.toString());

    accessRoadItems.clear();
    for (int i = 0; i < accessRoadList.length; i++) {
      String typurchseName = accessRoadList[i]["property_value"].toString();
      String typurchseCode = accessRoadList[i]["DISP_SEQ"].toString();
      var uimodel = new UImodel(typurchseName, typurchseCode);

      setState(() {
        accessRoadItems.add(DropdownModel(
          typurchseName,
          typurchseCode,
        ));
      });
    }

    List otherCropList = await db.RawQuery(
        'select * from animalCatalog where catalog_code = \'' + "261" + '\'');
    print(' otherCropList' + otherCropList.toString());

    otherCropItems.clear();
    otherCropUIModel = [];
    for (int i = 0; i < otherCropList.length; i++) {
      String typurchseName = otherCropList[i]["property_value"].toString();
      String typurchseCode = otherCropList[i]["DISP_SEQ"].toString();
      var uimodel = new UImodel(typurchseName, typurchseCode);
      otherCropUIModel.add(uimodel);

      setState(() {
        otherCropItems.add(DropdownMenuItem(
          value: typurchseName,
          child: Text(typurchseName),
        ));
      });
    }

    List soilTypeList = await db.RawQuery(
        'select * from animalCatalog where catalog_code = \'' + "262" + '\'');
    print(' soilTypeList' + soilTypeList.toString());

    soilTypeItems.clear();
    for (int i = 0; i < soilTypeList.length; i++) {
      String typurchseName = soilTypeList[i]["property_value"].toString();
      String typurchseCode = soilTypeList[i]["DISP_SEQ"].toString();
      var uimodel = new UImodel(typurchseName, typurchseCode);

      setState(() {
        soilTypeItems.add(DropdownModel(
          typurchseName,
          typurchseCode,
        ));
      });
    }

    List fertilityList = await db.RawQuery(
        'select * from animalCatalog where catalog_code = \'' + "202" + '\'');
    print(' soilTypeList' + fertilityList.toString());

    fertilityStatusItems.clear();
    for (int i = 0; i < fertilityList.length; i++) {
      String typurchseName = fertilityList[i]["property_value"].toString();
      String typurchseCode = fertilityList[i]["DISP_SEQ"].toString();
      var uimodel = new UImodel(typurchseName, typurchseCode);

      setState(() {
        fertilityStatusItems.add(DropdownModel(
          typurchseName,
          typurchseCode,
        ));
      });
    }

    List irrigationSourceList = await db.RawQuery(
        'select * from animalCatalog where catalog_code = \'' + "203" + '\'');
    print(' soilTypeList' + irrigationSourceList.toString());

    irrigationSourceItems.clear();
    for (int i = 0; i < irrigationSourceList.length; i++) {
      String typurchseName =
          irrigationSourceList[i]["property_value"].toString();
      String typurchseCode = irrigationSourceList[i]["DISP_SEQ"].toString();
      var uimodel = new UImodel(typurchseName, typurchseCode);

      setState(() {
        irrigationSourceItems.add(DropdownModel(
          typurchseName,
          typurchseCode,
        ));
      });
    }

    List methodIrrigationList = await db.RawQuery(
        'select * from animalCatalog where catalog_code = \'' + "265" + '\'');
    print(' soilTypeList' + methodIrrigationList.toString());

    methodIrrigationItems.clear();
    for (int i = 0; i < methodIrrigationList.length; i++) {
      String typurchseName =
          methodIrrigationList[i]["property_value"].toString();
      String typurchseCode = methodIrrigationList[i]["DISP_SEQ"].toString();
      var uimodel = new UImodel(typurchseName, typurchseCode);

      setState(() {
        methodIrrigationItems.add(DropdownModel(
          typurchseName,
          typurchseCode,
        ));
      });
    }

    List waterHarvestList = await db.RawQuery(
        'select * from animalCatalog where catalog_code = \'' + "266" + '\'');
    print(' waterHarvestList' + waterHarvestList.toString());

    waterHarvestingItems.clear();
    for (int i = 0; i < waterHarvestList.length; i++) {
      String typurchseName = waterHarvestList[i]["property_value"].toString();
      String typurchseCode = waterHarvestList[i]["DISP_SEQ"].toString();
      var uimodel = new UImodel(typurchseName, typurchseCode);

      setState(() {
        waterHarvestingItems.add(DropdownModel(
          typurchseName,
          typurchseCode,
        ));
      });
    }
    EasyLoading.dismiss();
  }

  LoadRegion(String cCode) async {
    List regionList = await db.RawQuery(
        'select distinct countryName from countryList c,stateList s where c.countryCode = s.countryCode and s.stateCode =\'' +
            cCode +
            '\'');
    if (regionList.isNotEmpty) {
      region = regionList[0]['countryName'].toString();
    }
  }

  varietySearch(String type) async {
    List varietiesList = await db.RawQuery(
        'select distinct grade,gradeCode from procurementGrade where vCode = \'' +
            type +
            '\'');
    print(' varietiesList' + varietiesList.toString());

    varitiesitems.clear();
    varitiesUIModel = [];
    for (int i = 0; i < varietiesList.length; i++) {
      String typurchseName = varietiesList[i]["grade"].toString();
      String typurchseCode = varietiesList[i]["gradeCode"].toString();
      var uimodel = new UImodel(typurchseName, typurchseCode);
      varitiesUIModel.add(uimodel);

      setState(() {
        varitiesitems.add(DropdownMenuItem(
          value: typurchseName,
          child: Text(typurchseName),
        ));
      });
    }

    Future.delayed(Duration(milliseconds: 500), () {
      print("varietyFunction");
      setState(() {
        if (varietiesList.isNotEmpty) {
          Varities = [];
          varietyLoaded = true;
        } else {
          varietyLoaded = false;
        }
      });
    });
  }

  farmersearch(String villageCode) async {
    String qry_farmerlist =
        'select fName,lName,farmerId,certifiedFarmer,address from farmer_master where villageId = \'' +
            villageCode +
            '\' and (blockId = "0" or blockId = "2")';
    List farmerslist = await db.RawQuery(qry_farmerlist);
    print('qry_farmerlist:  ' + farmerslist.toString());

    farmeritems = [];
    farmeritems.clear();
    farmerlistUIModel = [];

    if (farmerslist.length > 0) {
      for (int i = 0; i < farmerslist.length; i++) {
        String fName = farmerslist[i]["fName"].toString() +
            " " +
            farmerslist[i]["lName"].toString();
        String farmerId = farmerslist[i]["farmerId"].toString();
        String address = farmerslist[i]["address"].toString();
        var uimodel = new UImodel2(fName, farmerId, address, "", "", "");
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

  loadFarmName(String farm) async {
    String qry_farmlist =
        'select farmName from farm WHERE farmerId = \'' + farmerId + '\'';
    List farmlist = await db.RawQuery(qry_farmlist);
    print('qry_farmerlist:  ' + farmlist.toString());

    for (int i = 0; i < farmlist.length; i++) {
      String farmName1 = farmlist[i]['farmName'].toString();
      var farmNameValue = farmName(farmName1);
      farmNameDetail.add(farmNameValue);
      print("farmName:" + farmNameDetail.length.toString());
    }
  }

  farmCount(String farmerId) async {
    String qry_farmerlist =
        'select COUNT(*) from farm WHERE farmerId = \'' + farmerId + '\'';
    List farmerslist = await db.RawQuery(qry_farmerlist);
    print('qry_farmerlist:  ' + farmerslist.toString());

    // farmeritems = [];
    // farmeritems.clear();
    // farmerlistUIModel = [];
    //
    // if (farmerslist.length > 0) {
    //   for (int i = 0; i < farmerslist.length; i++) {
    //     String fName = farmerslist[i]["fName"].toString();
    //     String farmerId = farmerslist[i]["farmerId"].toString();
    //     String address = farmerslist[i]["address"].toString();
    //     var uimodel = new UImodel2(fName, farmerId, address);
    //     farmerlistUIModel.add(uimodel);
    //     setState(() {
    //       farmeritems.add(DropdownModel(
    //         fName,
    //         farmerId,
    //       ));
    //     });
    //   }
    // }
    //
    // Future.delayed(Duration(milliseconds: 500), () {
    //   setState(() {
    //     if (farmeritems.length > 0) {
    //       slct_farmer = '';
    //       farmerloaded = true;
    //     }
    //   });
    // });
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
              TranslateFun.langList['cofffarmCls'],
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

  Future<void> changeDistrict(String stateCode) async {
    //districtlist
    List districtlist = await db.RawQuery(
        'select distinct stateCode,districtName,districtCode from districtList where stateCode =\'' +
            stateCode +
            '\'');
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

  Future<void> ChangeStates() async {
    List statelist =
        await db.RawQuery('select distinct cityCode from agentMaster');

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
            'select distinct stateName from stateList where stateCode =\'' +
                stateCode +
                '\'');
        print('stateFarmerEnrollement' +
            stateNameList.toString() +
            "" +
            'select distinct stateName from stateList where stateCode =\'' +
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

  Future<void> changeCity(String districtCode) async {
    //cityList
    List cityList = await db.RawQuery(
        'select distinct cityName,cityCode from cityList where districtCode =\'' +
            districtCode +
            '\'');
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
        'select distinct villCode,villName from villageList where gpCode =\'' +
            Code +
            '\'');
    print('villagelistFarmerEnrollment' + villagelist.toString());
    VillageListUIModel = [];
    villageitemss = [];
    villageitemss.clear();
    for (int i = 0; i < villagelist.length; i++) {
      String villCode = villagelist[i]["villCode"].toString();
      String villName = villagelist[i]["villName"].toString();

      var uimodel = UImodel(villName, villCode);
      VillageListUIModel.add(uimodel);
      setState(() {
        villageitemss.add(DropdownMenuItem(
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

  List<Widget> _getListings(BuildContext context) {
    List<Widget> listings = [];
    if (!ishavefarmercode) {
      listings.add(txt_label_mandatory(
          TranslateFun.langList['villCls'], Colors.black, 14.0, false));
      listings.add(DropDownWithModel(
          itemlist: villageitems,
          selecteditem: slctvillages,
          hint: "Select Village",
          onChanged: (value) {
            setState(() {
              slctvillages = value!;
              villageCode = slctvillages!.value;
              slct_village = slctvillages!.name;
              slctFarmers = null;
              farmerId = '';
              slct_farmer = '';
              farmersearch(villageCode);
            });
          },
          onClear: () {
            setState(() {
              slct_farmer = '';
              ishavefarmercode = false;
            });
          }));

      listings.add(farmerloaded
          ? txt_label_mandatory(
              TranslateFun.langList['frmrCls'], Colors.black, 14.0, false)
          : Container());

      listings.add(farmerloaded
          ? DropDownWithModel(
              itemlist: farmeritems,
              selecteditem: slctFarmers,
              hint: "Select Farmer",
              onChanged: (value) {
                setState(() {
                  slctFarmers = value!;
                  farmerId = slctFarmers!.value;
                  slct_farmer = slctFarmers!.name;
                  print("farmerIdfarmerId:" + farmerId);
                  farmCount(farmerId);
                  loadFarmName(farmerId);
                  farmCodeGeneration(farmerId);

                  for (int i = 0; i < farmerlistUIModel.length; i++) {
                    if (farmerlistUIModel[i].value == farmerId) {
                      farmerAddress = farmerlistUIModel[i].value2;
                    }
                  }
                });
              },
              onClear: () {
                setState(() {
                  slct_farmer = '';
                  ishavefarmercode = false;
                });
              })
          : Container());

      listings.add(btn_dynamic(
          label: TranslateFun.langList['subCls'],
          bgcolor: Colors.green,
          txtcolor: Colors.white,
          fontsize: 18.0,
          centerRight: Alignment.centerRight,
          margin: 10.0,
          btnSubmit: () async {
            setState(() {
              if (slct_village != '' && slct_village.length > 0) {
                if (farmerId != '' && farmerId.length > 0) {
                  ishavefarmercode = true;
                } else {
                  ishavefarmercode = false;
                  errordialog(context, TranslateFun.langList['infoCls'],
                      TranslateFun.langList['valFrmrCls']);
                }
              } else {
                errordialog(context, TranslateFun.langList['infoCls'],
                    TranslateFun.langList['valVillCls']);
              }
            });
          }));
    }
    if (ishavefarmercode) {
      listings.add(txt_label_mandatory("Farm Code", Colors.black, 14.0, false));
      listings.add(cardlable_dynamic(farmCodeValue));

      listings.add(txt_label_mandatory("Farm Name", Colors.black, 14.0, false));

      listings.add(txtfield_digitCharacter("Farm Name", farm, true));

      listings
          .add(txt_label_mandatory("Farm Photo", Colors.black, 14.0, false));

      listings.add(img_picker(
          label: "Farm Photo \*",
          onPressed: () {
            imageDialog("Farm");
          },
          filename: farmImageFile,
          ondelete: () {
            ondelete("Farm");
          }));

      listings.add(stateLoaded
          ? txt_label_mandatory(
              TranslateFun.langList['disCls'], Colors.black, 14.0, false)
          : Container());
      listings.add(stateLoaded
          ? singlesearchDropdown(
              itemlist: stateitems,
              selecteditem: stateLoaded ? slctState : "",
              hint: districtName.isEmpty
                  ? TranslateFun.langList['seDiCls']
                  : districtName,
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

                  subCountyName = '';
                  parishName = '';
                  villageName = '';

                  val_District = "";
                  val_Taluk = "";
                  val_Village = "";

                  for (int i = 0; i < stateUIModel.length; i++) {
                    if (value == stateUIModel[i].name) {
                      val_State = stateUIModel[i].value;
                      districtName = stateUIModel[i].name;
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
          ? txt_label_mandatory("Subcounty/Division", Colors.black, 14.0, false)
          : Container());
      listings.add(districtLoaded
          ? singlesearchDropdown(
              itemlist: districtitems,
              selecteditem: districtLoaded ? slctDistrict : "",
              hint: subCountyName.isEmpty
                  ? TranslateFun.langList['seSuCoCls']
                  : subCountyName,
              onChanged: (value) {
                setState(() {
                  slctDistrict = value!;
                  cityLoaded = false;
                  slctTaluk = "";
                  cityitems.clear();
                  villageLoaded = false;
                  villageitems.clear();
                  slctVillage = "";

                  parishName = '';
                  villageName = '';

                  val_Taluk = "";
                  val_Village = "";

                  for (int i = 0; i < districtUIModel.length; i++) {
                    if (value == districtUIModel[i].name) {
                      val_District = districtUIModel[i].value;
                      subCountyName = districtUIModel[i].name;
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
          ? txt_label_mandatory(
              TranslateFun.langList['parCls'], Colors.black, 14.0, false)
          : Container());
      listings.add(cityLoaded
          ? singlesearchDropdown(
              itemlist: cityitems,
              selecteditem: cityLoaded ? slctTaluk : "",
              hint: parishName.isEmpty
                  ? TranslateFun.langList['sePaCls']
                  : parishName,
              onChanged: (value) {
                setState(() {
                  slctTaluk = value!;
                  villageLoaded = true;
                  villageitems.clear();
                  slctVillage = "";
                  villageName = '';
                  val_Village = "";
                  for (int i = 0; i < cityListUIModel.length; i++) {
                    if (value == cityListUIModel[i].name) {
                      val_Taluk = cityListUIModel[i].value;
                      parishName = cityListUIModel[i].name;
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
          ? txt_label_mandatory(
              TranslateFun.langList['vilCls'], Colors.black, 14.0, false)
          : Container());
      listings.add(villageLoaded
          ? singlesearchDropdown(
              itemlist: villageitemss,
              selecteditem: villageLoaded ? slctVillage : "",
              hint: villageName.isEmpty
                  ? TranslateFun.langList['seViCls']
                  : villageName,
              onChanged: (value) {
                setState(() {
                  slctVillage = value!;
                  for (int i = 0; i < VillageListUIModel.length; i++) {
                    if (value == VillageListUIModel[i].name) {
                      val_Village = VillageListUIModel[i].value;
                      villageName = VillageListUIModel[i].name;
                    }
                  }
                });
              },
              onClear: () {
                slctVillage = "";
              })
          : Container());

      listings.add(txt_label_mandatory(
          "Coffee " + TranslateFun.langList['typCls'],
          Colors.black,
          14.0,
          false));
      listings.add(DropDownWithModel(
        itemlist: typeitems,
        selecteditem: slctType,
        hint: slct_type.isEmpty ? "Select Coffee Type" : slct_type,
        onChanged: (value) {
          setState(() {
            slctType = value!;
            val_type = slctType!.value;
            slct_type = slctType!.name;
            Varities = [];
            varietySearch(val_type);
          });
        },
      ));

      listings.add(varietyLoaded
          ? txt_label_mandatory("Coffee Variety", Colors.black, 14.0, false)
          : Container());

      listings.add(varietyLoaded
          ? multisearchDropdownHint(
              itemlist: varitiesitems,
              selectedlist: Varities,
              hint: slct_Varities.isEmpty
                  ? "Select Coffee Variety"
                  : slct_Varities,
              onChanged: (item) {
                setState(() {
                  Varities = item;
                  String values = '';
                  String names = '';
                  String cropValue = "";
                  String cropName = "";
                  String quotation = "'";
                  for (int i = 0; i < varitiesUIModel.length; i++) {
                    for (int j = 0; j < item.length; j++) {
                      String name = item[j].toString();
                      if (name == varitiesUIModel[i].name) {
                        String value = varitiesUIModel[i].value;
                        String name = varitiesUIModel[i].name;

                        if (values == "" && names == "") {
                          values = value;
                          cropValue = value;
                          names = name;
                          cropName = name;
                        } else {
                          values = values + ',' + value;
                          names = names + ',' + name;
                          cropValue =
                              cropValue + quotation + ',' + quotation + value;
                          cropName =
                              cropName + quotation + ',' + quotation + name;
                        }

                        val_Varities = values;
                        slct_Varities = names;
                        print("val_Varities:" + val_Varities);
                      }
                    }
                  }
                });
              },
            )
          : Container());

      listings.add(txt_label_mandatory(
          "Spacing Of Coffee Trees (Feet)", Colors.black, 14.0, false));

      listings.add(Row(
        children: [
          Expanded(
            child:
                txtfieldAllowTwoDecimal('Height', spacingCoffeeHeight, true, 9),
          ),
          txt_label('x', Colors.black, 14.0, false),
          Expanded(
            child:
                txtfieldAllowTwoDecimal('Width', spacingCoffeeWidth, true, 9),
          ),
        ],
      ));

      listings.add(txt_label_mandatory(
          "Total Farm Area (Acre)", Colors.black, 14.0, false));
      listings.add(txtfieldAllowTwoDecimal(
          "Total Farm Area (Acre)", totCoffeeAcreage, true, 10));

      listings
          .add(txt_label_mandatory("GPS Location", Colors.green, 20.0, true));

      listings.add(txt_label(
          TranslateFun.langList['latCls'], Colors.black, 14.0, false));
      listings.add(cardlable_dynamic(Latitude));

      listings.add(txt_label(
          TranslateFun.langList['lonCls'], Colors.black, 14.0, false));
      listings.add(cardlable_dynamic(Longitude));

      //
      // listings.add(Expanded(child: Row(
      //   children: [
      //       Expanded(
      //         flex: 2,
      //         child: Column(
      //           children: [
      //
      //
      //           ],
      //         ),
      //       ),
      //     Expanded(
      //       flex: 2,
      //       child: Column(
      //         children: [
      //
      //
      //         ],
      //       ),
      //     ),
      //   ],
      // )));

      listings.add(txt_label_mandatory(
          "Coffee Farm Size (Acre)", Colors.black, 14.0, false));
      listings.add(txtfieldAllowTwoDecimal(
          "Coffee Farm Size (Acre)", proposedCoffee, true, 10));

      listings.add(txt_label_mandatory(
          "Audited Area (Acre)", Colors.black, 14.0, false));
      listings.add(txtfieldAllowTwoDecimal(
          "Audited Area (Acre)", auditedArea, false, 10));

      listings.add(btn_dynamic(
          label: "Area",
          bgcolor: Colors.green,
          txtcolor: Colors.white,
          fontsize: 18.0,
          centerRight: Alignment.centerRight,
          margin: 10.0,
          btnSubmit: () async {
            GeoareascalculateFarm? farmdata;
            geoCalculatedValues = await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        // geoploattingFarm(1)
                        const GeoPlottingNew()));
            farmdata = geoCalculatedValues?.farmData;

            double AcreData = double.parse(farmdata!.Acre);

            auditedArea.text = AcreData.toStringAsFixed(3).toString();

            setState(() {});
            setState(() {});
          }));

/*      listings.add(btn_dynamic(
          label: TranslateFun.langList['areaCls'],
          bgcolor: Colors.green,
          txtcolor: Colors.white,
          fontsize: 18.0,
          centerRight: Alignment.centerRight,
          margin: 10.0,
          btnSubmit: () async {
            farmdataadded = await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => geoploattingaddFarm(1)));

            double hectareValue = 0.2508;
            double bhigaValue = 3.9536;
            double c;

            if (farmdataadded) {
              auditedArea.text = addFarmdata!.Acre;
            } else {
              auditedArea.text = hectareAre;
            }
          }));*/

      listings.add(txt_label_mandatory(
          "Average Age Of Coffee Trees (In Years)", Colors.black, 14.0, false));
      listings.add(txtfieldAllowTwoDecimal(
          "Average Age Of Coffee Trees (In Years)", avgTrees, true, 10));

      listings.add(txt_label_mandatory(
          "Number Of Shade Trees", Colors.black, 14.0, false));
      listings.add(txtfield_digits(
        "Number Of Shade Trees",
        numShadeTrees,
        true,
      ));

      if (tyTree) {
        listings
            .add(txt_label("Types Of Shade Trees", Colors.black, 14.0, false));

        /*listings.add(DropDownWithModel(
          itemlist: shadeTreeitems,
          selecteditem: slctShadeTree,
          hint: TranslateFun.langList['slcShadeCls'],
          onChanged: (value) {
            setState(() {
              slctShadeTree = value!;
              val_ShadeTree = slctShadeTree!.value;
              slct_ShadeTree = slctShadeTree!.name;
            });
          },
        ));*/

        listings.add(multisearchDropdownHint(
          itemlist: shadeTreeitems,
          selectedlist: shadeTree,
          hint: slct_ShadeTree.isEmpty
              ? "Select Types Of Shade Trees"
              : slct_ShadeTree,
          onChanged: (item) {
            setState(() {
              shadeTree = item;
              String values = '';
              String names = '';
              String cropValue = "";
              String cropName = "";
              String quotation = "'";
              for (int i = 0; i < shadeTreeUIModel.length; i++) {
                for (int j = 0; j < item.length; j++) {
                  String name = item[j].toString();
                  if (name == shadeTreeUIModel[i].name) {
                    String value = shadeTreeUIModel[i].value;
                    String name = shadeTreeUIModel[i].name;

                    if (values == "" && names == "") {
                      values = value;
                      cropValue = value;
                      names = name;
                      cropName = name;
                    } else {
                      values = values + ',' + value;
                      names = names + ',' + name;
                      cropValue =
                          cropValue + quotation + ',' + quotation + value;
                      cropName = cropName + quotation + ',' + quotation + name;
                    }
                    valShadeTree = values;
                    slct_ShadeTree = names;
                    print("coffee farm:" + valShadeTree);
                    // valCropHSCode = valCropCategory;
                  }
                }
              }
              // cropName(cropValue);
            });
          },
        ));
      }

      // listings.add(DropDownWithModel(
      //   itemlist: shadeTreeitems,
      //   selecteditem: slctShadeTree,
      //   hint: TranslateFun.langList['slcShadeCls'],
      //   onChanged: (value) {
      //     setState(() {
      //       slctShadeTree = value!;
      //       val_ShadeTree = slctShadeTree!.value;
      //       slct_ShadeTree = slctShadeTree!.name;
      //     });
      //   },
      // ));

      listings.add(txt_label_mandatory(
          "Total Number Of Trees", Colors.black, 14.0, false));
      listings.add(txtfieldAllowTwoDecimal(
          "Total Number Of Trees", totNumTrees, true, 10));

      listings.add(txt_label_mandatory(
          "Number Of Unproductive Trees", Colors.black, 14.0, false));
      listings.add(txtfield_digits(
          "Number Of Unproductive Trees", numUnProductiveTrees, true));

      listings.add(txt_label_mandatory(
          "Number Of Productive Trees", Colors.black, 14.0, false));
      listings.add(txtfield_digits(
          "Number Of Productive Trees", numProductiveTrees, true));

      if (yieldEstimates) {
        listings.add(txt_label_mandatory(
            "Yield Estimate/Red cherry (Kgs)", Colors.black, 14.0, false));
        listings.add(txtfieldAllowTwoDecimal(
            "Yield Estimate/Red cherry (Kgs)", yieldEstimate, true, 9));
      }

      listings.add(txt_label(
          "Good Agricultural Practices (GAP'S)/Business Management Practices (BMP'S)",
          Colors.black,
          14.0,
          false));

      listings.add(multisearchDropdownHint(
        itemlist: goodAgriitems,
        selectedlist: goodAgriPractices,
        hint: slct_GoodAgri.isEmpty
            ? "Select Good Agricultural Practices (GAP'S)/Business Management Practices (BMP'S)"
            : slct_GoodAgri,
        onChanged: (item) {
          setState(() {
            goodAgriPractices = item;
            String values = '';
            String names = '';
            String cropValue = "";
            String cropName = "";
            String quotation = "'";
            for (int i = 0; i < goodAgriUIModel.length; i++) {
              for (int j = 0; j < item.length; j++) {
                String name = item[j].toString();
                if (name == goodAgriUIModel[i].name) {
                  String value = goodAgriUIModel[i].value;
                  String name = goodAgriUIModel[i].name;

                  if (values == "" && names == "") {
                    values = value;
                    cropValue = value;
                    names = name;
                    cropName = name;
                  } else {
                    values = values + ',' + value;
                    names = names + ',' + name;
                    cropValue = cropValue + quotation + ',' + quotation + value;
                    cropName = cropName + quotation + ',' + quotation + name;
                  }

                  valGoodAgri = values;
                  slct_GoodAgri = names;
                  print("coffee farm:" + valGoodAgri);
                  // valCropHSCode = valCropCategory;
                }
              }
            }
            // cropName(cropValue);
          });
        },
      ));

      listings.add(txt_label("Livestock", Colors.black, 14.0, false));

      listings.add(multisearchDropdownHint(
        itemlist: liveStockItems,
        selectedlist: liveStock,
        hint: slctLiveStock.isEmpty ? "Select Livestock" : slctLiveStock,
        onChanged: (item) {
          setState(() {
            liveStock = item;
            String values = '';
            String names = '';
            String cropValue = "";
            String cropName = "";
            String quotation = "'";
            for (int i = 0; i < liveStockUIModel.length; i++) {
              for (int j = 0; j < item.length; j++) {
                String name = item[j].toString();
                if (name == liveStockUIModel[i].name) {
                  String value = liveStockUIModel[i].value;
                  String name = liveStockUIModel[i].name;

                  if (values == "" && names == "") {
                    values = value;
                    cropValue = value;
                    names = name;
                    cropName = name;
                  } else {
                    values = values + ',' + value;
                    names = names + ',' + name;
                    cropValue = cropValue + quotation + ',' + quotation + value;
                    cropName = cropName + quotation + ',' + quotation + name;
                  }

                  valLiveStock = values;
                  slctLiveStock = names;
                  print("coffee farm:" + valLiveStock);
                  // valCropHSCode = valCropCategory;
                }
              }
            }
            // cropName(cropValue);
          });
        },
      ));

      listings.add(txt_label("Land Topography", Colors.black, 14.0, false));
      listings.add(DropDownWithModel(
        itemlist: landTopographyItems,
        selecteditem: slctLandTopography,
        hint: slct_LandTopography.isEmpty
            ? "Select Land Topography"
            : slct_LandTopography,
        onChanged: (value) {
          setState(() {
            slctLandTopography = value!;
            val_LandTopography = slctLandTopography!.value;
            slct_LandTopography = slctLandTopography!.name;
          });
        },
      ));

      listings.add(txt_label(
          TranslateFun.langList['laGrCls'], Colors.black, 14.0, false));
      listings.add(DropDownWithModel(
        itemlist: landGradientItems,
        selecteditem: slctLandGradient,
        hint: slct_LandGradient.isEmpty
            ? TranslateFun.langList['gradCls']
            : slct_LandGradient,
        onChanged: (value) {
          setState(() {
            slctLandGradient = value!;
            val_LandGradient = slctLandGradient!.value;
            slct_LandGradient = slctLandGradient!.name;
          });
        },
      ));

      listings.add(txt_label("Access Road", Colors.black, 14.0, false));
      listings.add(DropDownWithModel(
        itemlist: accessRoadItems,
        selecteditem: slctAccessRoad,
        hint: slct_AccessRoad.isEmpty ? "Select Access Road" : slct_AccessRoad,
        onChanged: (value) {
          setState(() {
            slctAccessRoad = value!;
            val_AccessRoad = slctAccessRoad!.value;
            slct_AccessRoad = slctAccessRoad!.name;
          });
        },
      ));

      listings
          .add(txt_label("Altitude (In Meters)", Colors.black, 14.0, false));
      listings.add(
          txtfieldAllowTwoDecimal("Altitude (In Meters)", altitude, false, 10));

      listings
          .add(txt_label("Certification Program", Colors.black, 14.0, false));

      listings.add(multisearchDropdownHint(
        itemlist: certProgramItems,
        selectedlist: certProgram,
        hint: slctCertProgram.isEmpty
            ? "Select Certification Program"
            : slctCertProgram,
        onChanged: (item) {
          setState(() {
            certProgram = item;
            String values = '';
            String names = '';
            String cropValue = "";
            String cropName = "";
            String quotation = "'";
            for (int i = 0; i < certProgramUIModel.length; i++) {
              for (int j = 0; j < item.length; j++) {
                String name = item[j].toString();
                if (name == certProgramUIModel[i].name) {
                  String value = certProgramUIModel[i].value;
                  String name = certProgramUIModel[i].name;

                  if (values == "" && names == "") {
                    values = value;
                    cropValue = value;
                    names = name;
                    cropName = name;
                  } else {
                    values = values + ',' + value;
                    names = names + ',' + name;
                    cropValue = cropValue + quotation + ',' + quotation + value;
                    cropName = cropName + quotation + ',' + quotation + name;
                  }

                  valCertProgram = values;
                  slctCertProgram = names;
                  print("coffee farm:" + valCertProgram);
                  // valCropHSCode = valCropCategory;
                }
              }
            }
            // cropName(cropValue);
          });
        },
      ));

      listings
          .add(txt_label("Year Of Establishment", Colors.black, 14.0, false));
      listings.add(
        YearSelector1(
          futureYear: 0,
          context: context,
          selectYear: plantationFormattedDate,
          onConfirm: (a) {
            selectedBirthYear = a;
            plantationFormattedDate = selectedBirthYear!.year.toString();
            setState(() {});
          },
          selectedDate: selectedBirthYear,
        ),
      );
      /* listings.add(selectDate(
          context1: context,
          slctdate: plantationDate,
          onConfirm: (date) => setState(
                () {
                  plantationDate = DateFormat('dd/MM/yyyy').format(date!);
                  plantationFormattedDate = DateFormat('yyyyMMdd').format(date);
                },
              )));*/

      listings.add(txt_label(
          "Other Crops Grown On The Farm", Colors.black, 14.0, false));

      listings.add(multisearchDropdownHint(
        itemlist: otherCropItems,
        selectedlist: otherCrop,
        hint: slctOtherCrop.isEmpty
            ? "Select Other Crops Grown On The Farm"
            : slctOtherCrop,
        onChanged: (item) {
          setState(() {
            otherCrop = item;
            String values = '';
            String names = '';
            String cropValue = "";
            String cropName = "";
            String quotation = "'";
            for (int i = 0; i < otherCropUIModel.length; i++) {
              for (int j = 0; j < item.length; j++) {
                String name = item[j].toString();
                if (name == otherCropUIModel[i].name) {
                  String value = otherCropUIModel[i].value;
                  String name = otherCropUIModel[i].name;

                  if (values == "" && names == "") {
                    values = value;
                    cropValue = value;
                    names = name;
                    cropName = name;
                  } else {
                    values = values + ',' + value;
                    names = names + ',' + name;
                    cropValue = cropValue + quotation + ',' + quotation + value;
                    cropName = cropName + quotation + ',' + quotation + name;
                  }
                  valOtherCrop = values;
                  slctOtherCrop = names;
                  print("coffee farm:" + valOtherCrop);
                  // valCropHSCode = valCropCategory;
                }
              }
            }
            // cropName(cropValue);
          });
        },
      ));

      listings.add(txt_label("Stumping Date", Colors.black, 14.0, false));
      listings.add(selectDate(
          context1: context,
          slctdate: pruningDate,
          onConfirm: (date) => setState(
                () {
                  pruningDate = DateFormat('dd/MM/yyyy').format(date!);
                  pruningFormattedDate = DateFormat('yyyyMMdd').format(date);
                },
              )));

      listings
          .add(txt_label("Land Title Document ", Colors.black, 14.0, false));
      listings.add(fileUpload(
          label: "Environmental Assessment Report \*",
          onPressed: () {
            getImageFile('Land');
          },
          filename: landFile,
          ondelete: () {
            onDeleteFile('Land');
          },
          uploadFileName: landFileName));

      //listings.add(cardlable_dynamic("Soil and irrigation section"));

      listings.add(txt_label(
          TranslateFun.langList['soanirseCls'], Colors.green, 20.0, true));

      listings
          .add(txt_label("Soil Type And Texture", Colors.black, 14.0, false));
      listings.add(DropDownWithModel(
        itemlist: soilTypeItems,
        selecteditem: slctSoilType,
        hint: slct_SoilType.isEmpty
            ? "Select Soil Type And Texture"
            : slct_SoilType,
        onChanged: (value) {
          setState(() {
            slctSoilType = value!;
            val_SoilType = slctSoilType!.value;
            slct_SoilType = slctSoilType!.name;
          });
        },
      ));

      listings.add(txt_label("Do You Irrigate?", Colors.black, 14.0, false));

      listings.add(radio_dynamic(
          map: irriSource,
          selectedKey: _selectedIrriSoruce,
          onChange: (value) {
            setState(() {
              _selectedIrriSoruce = value!;
              if (value == 'option1') {
                setState(() {
                  irriSelect = '0';
                  irrigationLoaded = false;
                  slctFertilityStatus = null;
                  val_FertilityStatus = "";
                  slct_FertilityStatus = "";
                  slctWaterHarvesting = null;
                  val_WaterHarvesting = "";
                  slct_WaterHarvesting = "";
                  slctIrrigation = null;
                  val_Irrigation = "";
                  slct_Irrigation = "";
                });
              } else if (value == 'option2') {
                setState(() {
                  irriSelect = '1';
                  irrigationLoaded = true;
                  slctFertilityStatus = null;
                  val_FertilityStatus = "";
                  slct_FertilityStatus = "";
                  slctWaterHarvesting = null;
                  val_WaterHarvesting = "";
                  slct_WaterHarvesting = "";
                  slctIrrigation = null;
                  val_Irrigation = "";
                  slct_Irrigation = "";
                });
              }
            });
          }));

      if (irriSelect == "0") {
        listings.add(txt_label(
            TranslateFun.langList['feStCls'], Colors.black, 14.0, false));
        listings.add(DropDownWithModel(
          itemlist: fertilityStatusItems,
          selecteditem: slctFertilityStatus,
          hint: slct_FertilityStatus.isEmpty
              ? TranslateFun.langList['slcFerStsCls']
              : slct_FertilityStatus,
          onChanged: (value) {
            setState(() {
              slctFertilityStatus = value!;
              val_FertilityStatus = slctFertilityStatus!.value;
              slct_FertilityStatus = slctFertilityStatus!.name;
            });
          },
        ));
        listings.add(
            txt_label("Water Harvesting Method", Colors.black, 14.0, false));
        listings.add(DropDownWithModel(
          itemlist: waterHarvestingItems,
          selecteditem: slctWaterHarvesting,
          hint: slct_WaterHarvesting.isEmpty
              ? "Select Water Harvesting Method"
              : slct_WaterHarvesting,
          onChanged: (value) {
            setState(() {
              slctWaterHarvesting = value!;
              val_WaterHarvesting = slctWaterHarvesting!.value;
              slct_WaterHarvesting = slctWaterHarvesting!.name;
            });
          },
        ));
      }

      if (irriSelect == "1") {
        listings.add(txt_label("Source Of Water", Colors.black, 14.0, false));
        listings.add(DropDownWithModel(
          itemlist: methodIrrigationItems,
          selecteditem: slctIrrigation,
          hint: slct_Irrigation.isEmpty
              ? "Select Source Of Water"
              : slct_Irrigation,
          onChanged: (value) {
            setState(() {
              slctIrrigation = value!;
              val_Irrigation = slctIrrigation!.value;
              slct_Irrigation = slctIrrigation!.name;
            });
          },
        ));
      }

      /* listings.add(txt_label(
          TranslateFun.langList['irSoCls'], Colors.black, 14.0, false));
      listings.add(DropDownWithModel(
        itemlist: irrigationSourceItems,
        selecteditem: slctIrrigationSource,
        hint: slct_IrrigationSource.isEmpty
            ? TranslateFun.langList['slcIrriSrcCls']
            : slct_IrrigationSource,
        onChanged: (value) {
          setState(() {
            slctIrrigationSource = value!;
            val_IrrigationSource = slctIrrigationSource!.value.trim();
            slct_IrrigationSource = slctIrrigationSource!.name.trim();
            print('slct_IrrigationSource--' + slct_IrrigationSource);
            print('val_IrrigationSource--' + val_IrrigationSource);
          });
        },
      ));*/

      /* if (!(slct_IrrigationSource == 'Rainfed'.trim() ||
          val_IrrigationSource == 'CG00110'.trim())) {
        listings.add(txt_label(
            TranslateFun.langList['meofirCls'], Colors.black, 14.0, false));
        listings.add(DropDownWithModel(
          itemlist: methodIrrigationItems,
          selecteditem: slctIrrigation,
          hint: slct_Irrigation.isEmpty
              ? TranslateFun.langList['slcMetIrriCls']
              : slct_Irrigation,
          onChanged: (value) {
            setState(() {
              slctIrrigation = value!;
              val_Irrigation = slctIrrigation!.value;
              slct_Irrigation = slctIrrigation!.name;
            });
          },
        ));
      }*/

      listings.add(Container(
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: Container(
                //padding: EdgeInsets.all(3),
                child: MaterialButton(
                  onPressed: () {
                    alertMessageDraft();
                  },
                  color: Colors.orange,
                  child: const Text(
                    'Save Draft',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 0,
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
              flex: 0,
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
          ],
        ),
      ));
    }

    return listings;
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
      if (photo == "Farm") {
        farmImageFile = File(image!.path);
      }
    });
  }

  Future getImageFromGallery(String photo) async {
    var image = await ImagePicker.platform
        .pickImage(source: ImageSource.gallery, imageQuality: 30);
    setState(() {
      if (photo == "Farm") {
        farmImageFile = File(image!.path);
      }
    });
  }

  void ondelete(String photo) {
    setState(() {
      if (photo == "Farm") {
        setState(() {
          farmImageFile = null;
        });
      }
    });
  }

  void btncancel() {
    _onBackPressed();
  }

  void btnSubmit() {
    // _progressHUD.state.show();

    // confirmation();

    if (farmImageFile != null) {
      farmImage = farmImageFile!.path;
    }

    if (landFile != null) {
      landPhotoPath = landFile!.path;
    }

    if (farm.text.isEmpty && farm.text.length == 0) {
      errordialog(context, TranslateFun.langList['infoCls'],
          "Farm Name should not be empty");
    } else if (farmImage.isEmpty && farmImage.length == 0) {
      errordialog(context, TranslateFun.langList['infoCls'],
          "Farm Photo should not be empty");
    } else if (val_State.isEmpty && val_State.length == 0) {
      errordialog(context, TranslateFun.langList['infoCls'],
          TranslateFun.langList['dishnobeemCls']);
    } else if (val_District.isEmpty && val_District.length == 0) {
      errordialog(context, TranslateFun.langList['infoCls'],
          TranslateFun.langList['sushnobeemCls']);
    } else if (val_Taluk.isEmpty && val_Taluk.length == 0) {
      errordialog(context, TranslateFun.langList['infoCls'],
          TranslateFun.langList['pashnobeemCls']);
    } else if (val_Village.isEmpty && val_Village.length == 0) {
      errordialog(context, TranslateFun.langList['infoCls'],
          TranslateFun.langList['vishnobeemCls']);
    } else if (slct_type.isEmpty && slct_type.length == 0) {
      errordialog(context, TranslateFun.langList['infoCls'],
          "Coffee Type should not be empty");
    } else if (val_Varities.isEmpty) {
      errordialog(context, TranslateFun.langList['infoCls'],
          "Coffee Variety should not be empty");
    } else if (spacingCoffeeHeight.text.isEmpty &&
        spacingCoffeeHeight.text.length == 0) {
      errordialog(context, TranslateFun.langList['infoCls'],
          'Spacing Of Coffee Trees (Feet) Height should not be empty');
    } else if (spacingCoffeeWidth.text.isEmpty &&
        spacingCoffeeWidth.text.length == 0) {
      errordialog(context, TranslateFun.langList['infoCls'],
          'Spacing Of Coffee Trees (Feet) Width should not be empty');
    } else if (totCoffeeAcreage.text.isEmpty &&
        totCoffeeAcreage.text.length == 0) {
      errordialog(context, TranslateFun.langList['infoCls'],
          "Total Farm Area (Acre) should not be empty");
    } else if (proposedCoffee.text.isEmpty) {
      errordialog(context, TranslateFun.langList['infoCls'],
          "Coffee Farm Size (Acre) should not be empty");
    } else if (double.parse(proposedCoffee.text) >
        double.parse(totCoffeeAcreage.text)) {
      errordialog(context, TranslateFun.langList['infoCls'],
          "Coffee Farm Size (Acre) should be less than or equal to Total Farm Area (Acre)");
    } else if (auditedArea.text.isEmpty) {
      errordialog(context, TranslateFun.langList['infoCls'],
          "Audited Area (Acre) should not be empty");
    } else if (avgTrees.text.isEmpty && avgTrees.text.length == 0) {
      errordialog(context, TranslateFun.langList['infoCls'],
          "Please enter Average Age Of Coffee Trees (in Years)");
    } else if (numShadeTrees.text.isEmpty && numShadeTrees.text.length == 0) {
      errordialog(context, TranslateFun.langList['infoCls'],
          "Number Of Shade Trees should not be empty");
    } /*else if (val_ShadeTree.isEmpty && val_ShadeTree.length == 0) {
      errordialog(context, TranslateFun.langList['infoCls'],
          TranslateFun.langList['valTypShdCls']);
    }*/
    else if (totNumTrees.text.isEmpty) {
      errordialog(context, TranslateFun.langList['infoCls'],
          "Total Number Of Trees should not be empty");
    } else if (numUnProductiveTrees.text.isEmpty &&
        numUnProductiveTrees.text.length == 0) {
      errordialog(context, TranslateFun.langList['infoCls'],
          "Number Of Unproductive Trees should not be empty");
    } else if (numProductiveTrees.text.isEmpty &&
        numProductiveTrees.text.length == 0) {
      errordialog(context, TranslateFun.langList['infoCls'],
          "Number Of Productive Trees should not be empty");
    } else if (yieldEstimate.text.isEmpty &&
        yieldEstimate.text.length == 0 &&
        yieldEstimates) {
      errordialog(context, TranslateFun.langList['infoCls'],
          "Please enter Yield Estimate/Red cherry (kgs)");
    }
    // else if (slct_LandOwner.isEmpty && slct_LandOwner.length == 0) {
    //   errordialog(context, "information", "Land ownership should not be empty");
    // }
    else {
      confirmation();
    }

    // } catch (e) {
    //   toast(e.toString());
    //   _progressHUD.state.dismiss();`
    // }
  }

  Future getImageFile(String label) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    var path2 = result!.files.single.path;
    File file = File(path2 ?? "");
    PlatformFile platformFile = result.files.first;
    String getFileName = result.files.first.name;
    String fileType = "";

    print("getFileName_getFileName" + getFileName.toString());

    if (platformFile.extension != null) {
      fileType = platformFile.extension!;
      print("fileType_fileType" + fileType.toString());
    }

    if (label == "Land") {
      setState(() {
        landFile = file;
      });
      landFileName = getFileName;
    }
  }

  void onDeleteFile(String label) {
    if (label == 'Land') {
      setState(() {
        landFile = null;
      });
    }
  }

  Future<void> savefarmSoufflet() async {
    db.RawQuery("Delete from farmSoufflet where isSynched = '2'");
    db.DeleteTable("catName");
    db.DeleteTable("wareHouseList");

    Random rnd = new Random();
    int recNo = 100000 + rnd.nextInt(999999 - 100000);
    String revNo = recordNo.isEmpty ? recNo.toString() : recordNo;

    final now = new DateTime.now();
    String txntime = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
    String txnDate = DateFormat('yyyyMMdd').format(now);
    var formatDate = "";
    String msgNo = DateFormat('yyyyMMddHHmmss').format(now);
    var dttime = DateTime.parse(txntime);
    formatDate = "${dttime.year}";
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
            '\', \'' + //989293
            servicePointId +
            '\',\'' +
            revNo +
            '\')';
    print("recipt no:" + revNo);
    print('txnHeader ' + insqry);
    int succ = await db.RawInsert(insqry);
    print(succ);

    //Future<List<Map>> txnHeader = db.GetTableValues('txnHeader');

    AppDatas datas = new AppDatas();
    int custTransaction = await db.saveCustTransaction(
        txntime,
        datas.txn_farmSoufflet,
        recordNo.isEmpty ? revNo : recordNo,
        '',
        '',
        '');
    print('custTransaction : ' + custTransaction.toString());

    String isSynched = "0";

    String farmCode = msgNo;
    //String farmId = "UCDA/F/" + formatDate + "/" + farmerId + "/";
    String farmId = farmCodeValue;

    int farData = await db.SaveFarmsflt1(
        farmerId: farmerId,
        farmIDT: farmId,
        farmName: farm.text,
        frPhoto: farmImage,
        type: val_type,
        varieties: val_Varities,
        spacingTree: spacingCoffeeHeight.text + '*' + spacingCoffeeWidth.text,
        yieldTree: yieldEstimate.text,
        totCoffeeAcr: totCoffeeAcreage.text,
        propCoffeeAr: proposedCoffee.text,
        avgTree: avgTrees.text,
        numTree: numShadeTrees.text,
        typTree: valShadeTree,
        numPrTrees: numProductiveTrees.text,
        numUnPrTrees: numUnProductiveTrees.text,
        goodAgri: valGoodAgri,
        certProgram: valCertProgram,
        landOwner: totNumTrees.text,
        landTopo: val_LandTopography,
        landGr: val_LandGradient,
        accRoad: val_AccessRoad,
        altitude: altitude.text,
        plDate: plantationFormattedDate,
        otCrop: valOtherCrop,
        prDate: pruningFormattedDate,
        soilTyp: val_SoilType,
        fertStatus: val_FertilityStatus,
        irriSource: irriSelect,
        metIrr: val_Irrigation,
        watHarMethod: val_WaterHarvesting,
        isSynched: isSynched,
        recNo: recordNo.isEmpty ? revNo : recordNo,
        latitude: Latitude,
        longitude: Longitude,
        villageId: villageCode,
        liveStock: valLiveStock,
        auditedArea: auditedArea.text,
        altitudeValue: val_Village,
        landTitleDoc: landPhotoPath);

    if (geoCalculatedValues != null) {
      for (int j = 0; j < geoCalculatedValues!.listData.length; j++) {
        var geo = geoCalculatedValues!.listData[j];

        int savefarmgpslocation = await db.saveFarmGPSLocationExists(
            geo.latitude,
            geo.longitude,
            farmerId,
            farmId,
            (j + 1).toString(),
            revNo.toString(),
            "");
      }
    }

    List<Map> Farmsflt1 = await db.GetTableValues('farmSoufflet');
    print("Farm value:" + Farmsflt1.toString());

    List<Map> Farmsflt = await db.GetTableValues('farmSoufflet');

    /* if(agentType=="03"){
      db.UpdateTableValue("farm", ColumnName, SetValue, WhereColumn, Wherevalue)
    }*/

    db.UpdateTableValue(
        'farmer_master', 'icsCode', farmCodeValue, 'farmerId', farmerId);

    db.UpdateTableValue(
        'farm', 'totTrees', totNumTrees.text, 'farmerId', farmerId);

    int issync = await db.UpdateTableValue(
        'farmSoufflet', 'isSynched', '0', 'recNo', revNo);

    Alert(
      context: context,
      type: AlertType.info,
      title: TranslateFun.langList['txnSuccCls'],
      desc: TranslateFun.langList['frmRegSccCls'],
      buttons: [
        DialogButton(
          child: Text(
            TranslateFun.langList['okCls'],
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () {
            /*Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (BuildContext context) => DashBoard("", "")));*/
            /* Navigator.of(context).push(MaterialPageRoute(
                builder: (BuildContext context) => DashBoard("", "")));*/
            Navigator.pop(context);
            Navigator.pop(context);
            //Navigator.pop(context);
          },
          width: 120,
        ),
      ],
    ).show();
    // Navigator.pop(context);
  }

  savePartialFarm() async {
    Random rnd = new Random();
    int recNo = 100000 + rnd.nextInt(999999 - 100000);
    String revNo = recNo.toString();

    final now = new DateTime.now();
    String txntime = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
    String txnDate = DateFormat('yyyyMMdd').format(now);
    var formatDate = "";
    String msgNo = DateFormat('yyyyMMddHHmmss').format(now);
    var dttime = DateTime.parse(txntime);
    formatDate = "${dttime.year}";

    var db1 = DatabaseHelper();

    db.RawQuery("Delete from farmSoufflet where isSynched = '2'");
    db.DeleteTable("catName");
    db.DeleteTable("wareHouseList");

    String isSynched = "2";
    if (farmImageFile != null) {
      farmImage = farmImageFile!.path;
    }

    if (landFile != null) {
      landPhotoPath = landFile!.path;
    }

    String farmCode = msgNo;
    String farmId = farmCodeValue;

    String spacingCoffHeight = spacingCoffeeHeight.text ?? "";
    String spacingCoffWidth = spacingCoffeeWidth.text ?? "";

    int farData = await db.SaveFarmsflt1(
        farmerId: farmerId,
        farmIDT: farmId,
        farmName: farm.text,
        frPhoto: farmImage,
        type: val_type,
        varieties: val_Varities,
        spacingTree: spacingCoffHeight + '*' + spacingCoffWidth,
        yieldTree: yieldEstimate.text,
        totCoffeeAcr: totCoffeeAcreage.text,
        propCoffeeAr: proposedCoffee.text,
        avgTree: avgTrees.text,
        numTree: numShadeTrees.text,
        typTree: valShadeTree,
        numPrTrees: numProductiveTrees.text,
        numUnPrTrees: numUnProductiveTrees.text,
        goodAgri: valGoodAgri,
        certProgram: valCertProgram,
        landOwner: totNumTrees.text,
        landTopo: val_LandTopography,
        landGr: val_LandGradient,
        accRoad: val_AccessRoad,
        altitude: altitude.text,
        plDate: plantationFormattedDate,
        otCrop: valOtherCrop,
        prDate: pruningFormattedDate,
        soilTyp: val_SoilType,
        fertStatus: val_FertilityStatus,
        irriSource: irriSelect,
        metIrr: val_Irrigation,
        watHarMethod: val_WaterHarvesting,
        isSynched: "2",
        recNo: recordNo.isEmpty ? revNo : recordNo,
        latitude: Latitude,
        longitude: Longitude,
        villageId: villageCode,
        liveStock: valLiveStock,
        auditedArea: auditedArea.text,
        altitudeValue: val_Village,
        landTitleDoc: landPhotoPath);

    int cData = await db.saveCountry(
        wareHouseCode: val_State,
        wareHouseName: val_District,
        wareHouseCity: val_Taluk);

    int farmdata = await db.saveCatData(
        type: slct_type,
        varieties: slct_Varities,
        typShTree: slct_ShadeTree,
        goodAgri: slct_GoodAgri,
        liveStock: slctLiveStock,
        landTopo: slct_LandTopography,
        landGr: slct_LandGradient,
        accRoad: slct_AccessRoad,
        certProgram: slctCertProgram,
        othCrop: slctOtherCrop,
        soilType: slct_SoilType,
        fertStatus: slct_FertilityStatus,
        irrSource: slct_IrrigationSource,
        methIrri: slct_Irrigation,
        watHarvest: slct_WaterHarvesting,
        plDate: plantationDate,
        prDate: pruningDate);

    if (geoCalculatedValues != null) {
      for (int j = 0; j < geoCalculatedValues!.listData.length; j++) {
        var geo = geoCalculatedValues!.listData[j];
        int savefarmgpslocation = await db.saveFarmGPSLocationExists(
            geo.latitude,
            geo.longitude,
            farmerId,
            farmId,
            (j + 1).toString(),
            recordNo.isEmpty ? revNo.toString() : recordNo,
            "2");
      }
    }

    Alert(
      context: context,
      type: AlertType.info,
      title: "Success",
      desc: "Farm Draft Successful",
      buttons: [
        DialogButton(
          child: Text(
            TranslateFun.langList['okCls'],
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () {
            /* Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (BuildContext context) => DashBoard("", "")));*/
            Navigator.pop(context);
            Navigator.pop(context);
            //Navigator.pop(context);
          },
          width: 120,
        ),
      ],
    ).show();
    // Navigator.pop(context);
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
              savefarmSoufflet();
              Navigator.pop(context);
            },
            color: Colors.green,
          )
        ]).show();
  }

  Future<void> alertMessageDraft() async {
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
        desc: "Are you sure you want to save as Draft?",
        buttons: [
          DialogButton(
            child: Text(
              "No",
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
              "Yes",
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            //onPressed:btnok,
            onPressed: () {
              savePartialFarm();
              Navigator.pop(context);
              //Put your code here which you want to execute on No button click.
            },
            color: Colors.green,
          )
        ]).show();
  }
}

class farmName {
  String farmName1;

  farmName(this.farmName1);
}
