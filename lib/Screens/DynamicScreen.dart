import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ucda/Database/Databasehelper.dart';
import 'package:ucda/Model/DynamicModel.dart';
import 'package:ucda/Model/UIModel.dart';
import 'package:ucda/Model/dynamicfields.dart';
import 'package:ucda/ResponseModel/WeatherModel.dart';
import 'package:ucda/Utils/MandatoryDatas.dart';

import '../../../main.dart';

class DynamicScreen extends StatefulWidget {
  String ModuleName;
  String MenuId;
  String valVillage = "";

  DynamicScreen(this.ModuleName, this.MenuId);
  @override
  State<StatefulWidget> createState() {
    return _DynamicScreen();
  }
}

class _DynamicScreen extends State<DynamicScreen> {
  var db = DatabaseHelper();
  List dynamiccomponentFields = [];
  List dynamiccomponentSection = [];
  List imageListField = [];
  List listcounts = [];
  bool valuesloaded = false;

  List dropdownlist1 = [];
  List dropdownlist2 = [];
  List dropdownlist3 = [];
  List dropdownlist4 = [];
  List dropdownlist5 = [];
  List dropdownlist6 = [];
  List dropdownlist7 = [];
  List dropdownlist8 = [];
  List dropdownlist9 = [];
  List dropdownlist10 = [];
  List dropdownlist11 = [];
  List dropdownlist12 = [];
  List dropdownlist13 = [];
  TextEditingController controller1 = new TextEditingController();
  TextEditingController controller2 = new TextEditingController();
  TextEditingController controller3 = new TextEditingController();
  TextEditingController controller4 = new TextEditingController();
  TextEditingController controller5 = new TextEditingController();
  TextEditingController controller6 = new TextEditingController();
  TextEditingController controller7 = new TextEditingController();
  TextEditingController controller8 = new TextEditingController();
  TextEditingController controller9 = new TextEditingController();
  TextEditingController controller10 = new TextEditingController();
  TextEditingController controller11 = new TextEditingController();
  TextEditingController controller12 = new TextEditingController();
  TextEditingController controller13 = new TextEditingController();
  TextEditingController controller14 = new TextEditingController();
  TextEditingController controller15 = new TextEditingController();
  TextEditingController controller16 = new TextEditingController();
  TextEditingController controller1Type = new TextEditingController();
  TextEditingController controller2Type = new TextEditingController();
  TextEditingController controller3Type = new TextEditingController();
  TextEditingController controller20 = new TextEditingController();
  List<DynamicModel> dynamicList = [];
  List<DynamicModel> dynamicList2 = [];
  List<ValidationModel> validationlist = [];
  List<LabelModel> labelList = [];
  final List<DropdownMenuItem> dummylist = [];

  File? _imageFile1;
  File? _imageFile2;
  File? _imageFile3;
  String imgMandatory = "";
  String? val1, val2;
  String image1 = "", image2 = "", image3 = "";
  String pcTime = "";
  String txnTypeId = "";
  String txnTypeName = "";
  String entity = "";
  String listid = "";
  int iteration = 0;
  String sectionId = "";
  String Label = "";
  List<Map>? agents;
  String seasoncode = "";
  String servicePointId = "";
  String agentDistributionBal = '';
  String ListCount = '0';
  String sectionName = "";
  String Lat = '';
  String Lng = '';
  String ImageLng = '';
  String ImageLat = '';
  String revNo = '';
  String locationName = "Loading";
  //String val = "0";
  String currentTemperature = "0";
  String weather = "-";
  int imageWidgetCount = 0;
  int imageIdCount = 0;
  int idscount = 0;
  int valuee = 0;

  String imageMandatory = "";
  List<ComponentModel> componentidvalue = [];
  //var addListValue;
  List<ComponentModel> addListValue = [];

  List<ImageModel> imageidvalue = [];
  List<ListModel> iterationList = [];
  List<ListModel> dynamicListValues = [];
  List<WeatherInfoDynamic> weatherinfo = [];
  List<String> Dates = [];
  var lstmd;
  var villagelists;

  List<String> multiSearchFarmerList = [];
  List<String> multiSearchVillageList = [];

  List<DropdownMenuItem> multiVillageItems = [];
  List<DropdownMenuItem> multiFarmeritems = [];

  List<DropdownModel> groupItems = [];
  List<DropdownModel> villageItems = [];
  List<DropdownModel> farmerItems = [];
  List<DropdownModel> farmItems = [];
  List<DropdownModel> seasonItems = [];
  List<DropdownModel> cropItems = [];

  DropdownModel? selectGroup;
  DropdownModel? selectVillage;
  DropdownModel? selectFarmer;
  DropdownModel? selectFarm;
  DropdownModel? selectSeason;
  DropdownModel? selectCrop;

  List<UImodel> villageUiModel = [];
  List<UImodel> farmerUiModel = [];
  List<UImodel> farmUiModel = [];
  List<UImodel> seasonUiModel = [];
  List<UImodel> cropUiModel = [];
  List<UImodel> groupUiModel = [];
  String farmercode = '', entityBasedFarmerID = "";
  String slcVillage = "",
      slcFarmer = "",
      slcFarm = "",
      slcSeason = "",
      slcGroup = "",
      slcCrop = "";
  String valVillage = "",
      valFarmer = "",
      valFarm = "",
      valSeason = "",
      valGroup = "",
      valCrop = "";
  bool farmerLoaded = false, farmLoaded = false;
  bool villageDropdown = true,
      farmerMultiSearchDropDown = false,
      groupDropDown = false,
      cropDropDown = false,
      villageMultiSearchDropDown = false;
  String tempWeather = "",
      rainWeather = "",
      humidityWeather = "",
      speedWeather = "";
  bool farmerDropdown = true, farmDropdown = true;
  bool dataCleared = false;
  bool dropdownLoaded = false;
  bool addbtnclicked = false;
  bool dupli = false;
  bool positiveflow = false;
  bool editbutton = false;
  String valformula = "0";
  List<String> selectedDataList = [];

  final Map<String, String> map1 = {
    'option1': "No",
    'option2': "Yes",
  };

  final Map<String, String> map2 = {
    'option1': "No",
    'option2': "Yes",
  };

  final Map<String, String> map3 = {
    'option1': "No",
    'option2': "Yes",
  };

  final Map<String, String> map4 = {
    'option1': "No",
    'option2': "Yes",
  };
  String selectedValue1 = "option1";
  String selectedValue2 = "option1";
  String selectedValue3 = "option1";
  String selectedValue4 = "option1";
  int labelvalue = 0;
  bool labeladded = false;
  String mapValue1 = "2", mapValue2 = "2", mapValue3 = "2", mapValue4 = "2";
  DropdownModel? selectedItem1;
  DropdownModel? selectedItem2;
  DropdownModel? selectedItem3;
  DropdownModel? selectedItem4;
  DropdownModel? selectedItem5;
  DropdownModel? selectedItem6;
  DropdownModel? selectedItem7;
  DropdownModel? selectedItem8;
  DropdownModel? selectedItem9;
  DropdownModel? selectedItem10;
  DropdownModel? selectedItem11;
  DropdownModel? selectedItem12;
  DropdownModel? selectedItem13;
  String valueItem1 = "";
  String valueItem2 = "";
  String valueItem3 = "";
  String valueItem4 = "";
  String valueItem5 = "";
  String valueItem6 = "";
  String valueItem7 = "";
  String valueItem8 = "";
  String valueItem9 = "";
  String valueItem10 = "";
  String valueItem11 = "";
  String valueItem12 = "";
  String valueItem13 = "";

  @override
  void initState() {
    super.initState();
    initvalues();
    getLocation();
    Random rnd = new Random();
    int recNo = 100000 + rnd.nextInt(999999 - 100000);
    revNo = recNo.toString();
    getClientData();
    Village();
    Group();
    seasonSearch();
  }

  dropdownclear() {
    setState(() {
      controller1.clear();
      controller2.clear();
      controller3.clear();
      controller4.clear();
      controller5.clear();
      controller6.clear();
      controller7.clear();
      controller8.clear();
      controller9.clear();
      controller10.clear();
      controller11.clear();
      controller12.clear();
      controller13.clear();
      controller14.clear();
      controller15.clear();
      controller16.clear();
      controller20.clear();
      controller1Type.clear();
      controller2Type.clear();
      controller3Type.clear();
      val2 = '0';
      val1 = '0';
      valformula = "0";
      labelvalue = 0;
      valuee = 0;

      /* if (componentidvalue.length > 0 && positiveflow) {
        idscount = 0;
      } */

      dataCleared = true;
      dropdownLoaded = false;
      dupli = true;
      initvalues();
    });
  }

  getClientData() async {
    agents = await db.RawQuery('SELECT * FROM agentMaster');
    seasoncode = agents![0]['currentSeasonCode'];
    servicePointId = agents![0]['servicePointId'];
    agentDistributionBal = agents![0]['agentDistributionBal'];
  }

  void getLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    print("latitude :" +
        position.latitude.toString() +
        " longitude: " +
        position.longitude.toString());

    Lat = position.latitude.toString();
    Lng = position.longitude.toString();
    ImageLat = position.latitude.toString();
    ImageLng = position.longitude.toString();

    var response = await Dio().get(
        "http://api.openweathermap.org/data/2.5/forecast/daily?mode=json&cnt=8&appid=818dd2fdbfd1288c75a46100e6f450cb&lat=$Lat&lon=$Lng");

    Map<String, dynamic> json = jsonDecode(response.toString());
    WeatherModel weatherdata = WeatherModel.fromJson(json);
    locationName = weatherdata.city!.name;
    weather = weatherdata.list![0].weather![0].main;
    currentTemperature =
        ChangeDecimalTwo((weatherdata.list![0].temp!.day - 273.15).toString());
    for (int i = 1; i < weatherdata.list!.length; i++) {
      String temp = ChangeDecimalTwo(
          (weatherdata.list![i].temp!.day - 273.15).toString());
      String weather = weatherdata.list![i].weather![0].main;
      String rain = weatherdata.list![i].rain.toString();
      String humidity = weatherdata.list![i].humidity.toString();
      String speed = weatherdata.list![i].speed.toString();
      if (rain == "null") {
        rain = "-";
      }
      weatherinfo.add(new WeatherInfoDynamic(temp, rain, humidity, speed));
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<bool> _onBackPressed() async {
    return (await Alert(
          context: context,
          type: AlertType.warning,
          title: 'Cancel',
          desc: 'Are you sure you want to cancel?',
          buttons: [
            DialogButton(
              child: Text(
                'yes',
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
                'no',
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
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            centerTitle: true,
            leading: IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () {
                  _onBackPressed();
                }),
            title: Text(
              widget.ModuleName,
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
            child: valuesloaded
                ? ListView(
                    padding: EdgeInsets.all(10.0),
                    children: DynamicUi(context),
                  )
                : Container(),
          ),
        ),
      ),
    );
  }

  Future<void> Village() async {
    String qry_villagelist =
        'Select distinct v.villCode,v.villName from villageList as v inner join farmer_master as f on f.villageId =v.villCode'; //'select * from villageList';
    List villageslist = await db.RawQuery(qry_villagelist);
    villageItems.clear();
    villageUiModel = [];
    multiVillageItems.clear();

    for (int i = 0; i < villageslist.length; i++) {
      String property_value = villageslist[i]["villName"].toString();
      String DISP_SEQ = villageslist[i]["villCode"].toString();
      var uimodel = new UImodel(property_value, DISP_SEQ);
      villageUiModel.add(uimodel);
      setState(() {
        villageItems.add(DropdownModel(
          property_value,
          DISP_SEQ,
        ));
      });
      setState(() {
        multiVillageItems.add(DropdownMenuItem(
          child: Text(property_value),
          value: property_value,
        ));
      });
    }
  }

  Future<void> Group() async {
    String Groupqry =
        'select sam.samCode as samCode,sam.samName as samName,sam.utzStatus from samitee  as sam inner join agentSamiteeList as vsam on sam.samCode = vsam.samCode order by sam.samName asc';

    List groupList = await db.RawQuery(Groupqry);
    groupItems = [];
    groupItems.clear();
    groupUiModel = [];
    if (groupList.length > 0) {
      for (int i = 0; i < groupList.length; i++) {
        String DISP_SEQ = groupList[i]["samCode"].toString();
        String property_value = groupList[i]["samName"].toString();

        var uimodel = new UImodel(property_value, DISP_SEQ);
        groupUiModel.add(uimodel);
        setState(() {
          groupItems.add(DropdownModel(
            property_value,
            DISP_SEQ,
          ));
        });
      }
    }
  }

  farmersearch(String VillageId) async {
    String qry_farmerlist =
        'select farmerId,fName,farmerCode from farmer_master where villageId = \'' +
            VillageId +
            '\'';
    List farmerslist = await db.RawQuery(qry_farmerlist);

    farmerItems = [];
    multiFarmeritems = [];
    farmerUiModel.clear();
    farmerUiModel = [];
    for (int i = 0; i < farmerslist.length; i++) {
      String property_value = farmerslist[i]["fName"].toString();
      String DISP_SEQ = farmerslist[i]["farmerId"].toString();
      farmercode = farmerslist[i]["farmerCode"].toString();
      var uimodel = new UImodel(property_value + "-" + farmercode, DISP_SEQ);
      farmerUiModel.add(uimodel);
      setState(() {
        farmerItems.add(DropdownModel(
          property_value + "-" + farmercode,
          DISP_SEQ,
        ));
      });

      setState(() {
        multiFarmeritems.add(DropdownMenuItem(
          child: Text(property_value),
          value: property_value,
        ));
      });

      Future.delayed(Duration(milliseconds: 500), () {
        setState(() {
          if (farmerItems.length > 0) {
            farmerLoaded = true;
            slcFarmer = '';
          }
        });
      });
    }
  }

  farmersearch2(String VillageId) async {
    villagelists = valVillage.split(',');

    for (int i = 0; i < villagelists.length; i++) {
      if (i == 0) {
        valVillage = "'" + villagelists[0] + "'";
      } else {
        valVillage = valVillage + ",'" + villagelists[i] + "'";
      }
    }
    String qry_farmerlist =
        'select farmerId,farmerCode,fName,lName as name from farmer_master  where villageId IN (' +
            valVillage +
            ')';
    print("trainqry " + qry_farmerlist);
    List farmerslist = await db.RawQuery(qry_farmerlist);

    farmerItems = [];
    farmerUiModel.clear();
    farmerUiModel = [];
    for (int i = 0; i < farmerslist.length; i++) {
      String property_value = farmerslist[i]["fName"].toString();
      String DISP_SEQ = farmerslist[i]["farmerId"].toString();
      farmercode = farmerslist[i]["farmerCode"].toString();
      var uimodel = new UImodel(property_value + "-" + farmercode, DISP_SEQ);
      farmerUiModel.add(uimodel);
      setState(() {
        farmerItems.add(DropdownModel(
          property_value + "-" + farmercode,
          DISP_SEQ,
        ));
      });

      Future.delayed(Duration(milliseconds: 500), () {
        setState(() {
          if (farmerItems.length > 0) {
            farmerLoaded = true;
            slcFarmer = '';
          }
        });
      });
    }
  }

  farmSearch(String farmerCode) async {
    String qry_farm =
        'select farmIDT,farmName,farmArea, landProd,seasonYear  from farm where farmerId = \'' +
            farmerCode +
            '\'';
    List farmlist = await db.RawQuery(qry_farm);

    farmItems = [];
    farmItems.clear();
    farmUiModel = [];

    if (farmlist.length > 0) {
      for (int i = 0; i < farmlist.length; i++) {
        String DISP_SEQ = farmlist[i]["farmIDT"].toString();
        String property_value = farmlist[i]["farmName"].toString();
        String farmtotarea = farmlist[i]["farmArea"].toString();

        var uimodel = new UImodel(property_value + "-" + farmtotarea, DISP_SEQ);
        farmUiModel.add(uimodel);
        setState(() {
          farmItems.add(DropdownModel(
            property_value + "-" + farmtotarea,
            DISP_SEQ,
          ));
        });

        Future.delayed(Duration(milliseconds: 500), () {
          setState(() {
            if (farmItems.length > 0) {
              farmLoaded = true;
              slcFarm = '';
            }
          });
        });
      }
    }
  }

  seasonSearch() async {
    String qry_farm = 'select seasonId,seasonName from seasonYear';
    List seasonList = await db.RawQuery(qry_farm);
    seasonItems = [];
    seasonItems.clear();
    seasonUiModel = [];
    if (seasonList.length > 0) {
      for (int i = 0; i < seasonList.length; i++) {
        String DISP_SEQ = seasonList[i]["seasonId"].toString();
        String property_value = seasonList[i]["seasonName"].toString();

        var uimodel = new UImodel(property_value, DISP_SEQ);
        seasonUiModel.add(uimodel);
        setState(() {
          seasonItems.add(DropdownModel(
            property_value,
            DISP_SEQ,
          ));
        });
      }
    }
  }

  Future<void> Crop(String farmCode) async {
    String farmCrop =
        'select distinct crop.fcode as cropId, crop.fname as cropName,Unit,vl.[vCode], vl.[vName] from cropList as crop '
                'inner join farmCrop as fmcrp on crop.fcode=fmcrp.[cropCode] inner join varietyList as vl on vl.[vCode]=fmcrp.[cropVariety] where fmcrp.farmcrpIDT=\'' +
            farmCode +
            '\'';

    List cropList = await db.RawQuery(farmCrop);
    cropItems = [];
    cropItems.clear();
    cropUiModel = [];
    if (cropList.length > 0) {
      for (int i = 0; i < cropList.length; i++) {
        String DISP_SEQ = cropList[i]["cropId"].toString();
        String property_value = cropList[i]["cropName"].toString();

        var uimodel = new UImodel(property_value, DISP_SEQ);
        cropUiModel.add(uimodel);
        setState(() {
          cropItems.add(DropdownModel(
            property_value,
            DISP_SEQ,
          ));
        });
      }
    }
  }

  Future<void> initvalues() async {
    String listcuntqry =
        "select distinct list.listId ,sec.secName from dynamiccomponentList as list,dynamiccomponentMenu as menu,dynamiccomponentSections as sec where menu.txnTypeIdMenu=list.txnTypeId and sec.sectionId=list.sectionId  and menu.menuId=\'" +
            widget.MenuId +
            "\'";

    listcounts = await db.RawQuery(listcuntqry);

    ListCount = listcounts.length.toString();
    String dynamiccomponentMenuqry =
        'select * from dynamiccomponentMenu where menuId=\'' +
            widget.MenuId +
            '\'';

    List dynamiccomponentMenus = await db.RawQuery(dynamiccomponentMenuqry);
    String txnTypeIdMenu = dynamiccomponentMenus[0]["txnTypeIdMenu"];
    String menuName = dynamiccomponentMenus[0]["menuName"];
    setState(() {
      entity = dynamiccomponentMenus[0]["entity"].toString();
      entityFarmerID();
    });

    txnTypeId = txnTypeIdMenu;
    txnTypeName = menuName;

    String sectionqry =
        'select distinct sec.secName,sec.sectionId from dynamiccomponentMenu as menu,dynamiccomponentSections as sec where txnTypeId=\'' +
            txnTypeId +
            '\' and menu.menuId =\'' +
            widget.MenuId +
            '\'';

    dynamiccomponentSection = await db.RawQuery(sectionqry);

    String qry =
        'select distinct flds.catalogValueId,flds.componentType,flds.componentLabel,flds.componentID,flds.isMandatory,flds.formulaDependency,flds.dependencyField,flds.validationType,flds.sectionId,sec.secName from dynamiccomponentFields flds,dynamiccomponentSections sec where flds.txnTypeId=\'' +
            txnTypeId +
            '\' and sec.sectionId=flds.sectionId ';

    dynamiccomponentFields = await db.RawQuery(qry);

    String imageqry =
        'select distinct flds.catalogValueId,flds.componentType,flds.componentLabel,flds.componentID,flds.isMandatory,flds.formulaDependency,flds.dependencyField,flds.validationType,flds.sectionId,sec.secName from dynamiccomponentFields flds,dynamiccomponentSections sec where flds.txnTypeId=\'' +
            txnTypeId +
            '\' and sec.sectionId=flds.sectionId and componentType=\'12\'';
    imageListField = await db.RawQuery(imageqry);

    if (imageListField.length > 0) {
      for (int i = 0; i < imageListField.length; i++) {
        imageMandatory = imageListField[i]["isMandatory"].toString();
        setState(() {
          if (imageMandatory == "1") {
            imageWidgetCount = imageWidgetCount + 1;
          }
        });
      }
    }

    for (int d = 0; d < dynamiccomponentFields.length; d++) {
      Dates.add("Select Date");
    }

    DropdownLoad();
  }

  Future<void> entityFarmerID() async {
    if (entity.length > 0 && entity != "") {
      if (entity == "2") {
        setState(() {
          entityBasedFarmerID = valFarm;
        });
      } else if (entity == "4") {
        setState(() {
          entityBasedFarmerID = valFarm;
        });
      } else if (entity == "1") {
        setState(() {
          groupDropDown = true;
          entityBasedFarmerID = valFarmer;
          farmDropdown = false;
        });
      } else if (entity == "3") {
        setState(() {
          groupDropDown = true;
          entityBasedFarmerID = valGroup;
          farmerDropdown = false;
          farmDropdown = false;
        });
      } else if (entity == "5") {
        setState(() {
          villageMultiSearchDropDown = true;
          farmerMultiSearchDropDown = true;
          entityBasedFarmerID = valVillage;
          entityBasedFarmerID = valFarmer;
          villageDropdown = false;
          farmerDropdown = false;
          farmDropdown = false;
        });
      } else if (entity == "6") {
        setState(() {
          cropDropDown = true;
          entityBasedFarmerID = valCrop;
        });
      } else {
        entityBasedFarmerID = valFarmer;
      }
    }
  }

  Future<void> DropdownLoad() async {
    int dropdownload = 0;
    for (int i = 0; i < dynamiccomponentFields.length; i++) {
      String componentType =
          dynamiccomponentFields[i]["componentType"].toString();
      String catalogValueId =
          dynamiccomponentFields[i]["catalogValueId"].toString();
      String componentID = dynamiccomponentFields[i]["componentID"].toString();

      if (componentType == "4") {
        switch (dropdownload) {
          case 0:
            List dropdownlist = await loaddropdownvalues(catalogValueId);
            dropdownlist1 = dropdownlist;

            break;
          case 1:
            List dropdownlist = await loaddropdownvalues(catalogValueId);
            dropdownlist2 = dropdownlist;
            break;
          case 2:
            List dropdownlist = await loaddropdownvalues(catalogValueId);
            dropdownlist3 = dropdownlist;
            break;
          case 3:
            List dropdownlist = await loaddropdownvalues(catalogValueId);
            dropdownlist4 = dropdownlist;
            break;
          case 4:
            List dropdownlist = await loaddropdownvalues(catalogValueId);
            dropdownlist5 = dropdownlist;
            break;
          case 4:
            List dropdownlist = await loaddropdownvalues(catalogValueId);
            dropdownlist5 = dropdownlist;
            break;
          case 5:
            List dropdownlist = await loaddropdownvalues(catalogValueId);
            dropdownlist6 = dropdownlist;
            break;
          case 6:
            List dropdownlist = await loaddropdownvalues(catalogValueId);
            dropdownlist7 = dropdownlist;
            break;
          case 7:
            List dropdownlist = await loaddropdownvalues(catalogValueId);
            dropdownlist8 = dropdownlist;
            break;
          case 8:
            List dropdownlist = await loaddropdownvalues(catalogValueId);
            dropdownlist9 = dropdownlist;
            break;
          case 9:
            List dropdownlist = await loaddropdownvalues(catalogValueId);
            dropdownlist10 = dropdownlist;
            break;
          case 10:
            List dropdownlist = await loaddropdownvalues(catalogValueId);
            dropdownlist11 = dropdownlist;
            break;
          case 11:
            List dropdownlist = await loaddropdownvalues(catalogValueId);
            dropdownlist12 = dropdownlist;
            break;
          case 12:
            List dropdownlist = await loaddropdownvalues(catalogValueId);
            dropdownlist13 = dropdownlist;
            break;
        }
        dropdownload = dropdownload + 1;
      }
    }
    if (dynamiccomponentFields.isNotEmpty) {
      setState(() {
        valuesloaded = true;
        dropdownLoaded = true;
        //toast("dropdownLoade");
      });
    }

    // setState(() {
    //   val_Enrol = enrolllistModel[0].value;
    //   slctEnrol = enrolllistModel[0].name;
    // });
  }

  List<Widget> DynamicUi(BuildContext context) {
    List<Widget> listings = [];

    listings.add(groupDropDown
        ? txt_label_mandatory("Group", Colors.black, 14.0, false)
        : Container());
    listings.add(groupDropDown
        ? singlesearchdynamic(
            itemlist: groupItems,
            selecteditem: selectGroup,
            hint: "Select the Group",
            onChanged: (value) {
              setState(() {
                selectGroup = value;
                slcGroup = selectGroup!.name;
                valGroup = selectGroup!.value;
                farmerLoaded = false;
                slcFarmer = '';
                farmLoaded = false;
                slcFarm = '';
                farmersearch(valVillage);
                entityFarmerID();
              });
            },
          )
        : Container());

    if (entity != "3" && entity != "5") {
      listings.add(txt_label_mandatory("Village", Colors.black, 14.0, false));
      listings.add(singlesearchdynamic(
        itemlist: villageItems,
        selecteditem: selectVillage,
        hint: "Select the Village",
        onChanged: (value) {
          setState(() {
            selectVillage = value;
            slcVillage = selectVillage!.name;
            valVillage = selectVillage!.value;
            farmerLoaded = false;
            slcFarmer = '';
            farmLoaded = false;
            slcFarm = '';
            farmersearch(valVillage);
          });
        },
      ));
    }

    if (farmerDropdown) {
      listings.add(farmerLoaded
          ? txt_label_mandatory("Farmer", Colors.black, 14.0, false)
          : Container());
      listings.add(farmerLoaded
          ? singlesearchdynamic(
              itemlist: farmerItems,
              selecteditem: selectFarmer,
              hint: "Select the Farmer",
              onChanged: (value) {
                setState(() {
                  selectFarmer = value;

                  slcFarmer = selectFarmer!.name;
                  valFarmer = selectFarmer!.value;
                  farmLoaded = false;
                  slcFarm = '';
                  farmSearch(valFarmer);
                  entityFarmerID();
                });
              })
          : Container());
    }

    if (entity != "3" && entity == "5") {
      listings.add(villageMultiSearchDropDown
          ? txt_label_mandatory("Village", Colors.black, 14.0, false)
          : Container());
      listings.add(villageMultiSearchDropDown
          ? multisearchDropdownHint(
              hint: "Select the Village",
              itemlist: multiVillageItems,
              selectedlist: multiSearchVillageList,
              onChanged: (item) {
                setState(() {
                  multiSearchVillageList = item;
                  String villageName = "";
                  for (int i = 0; i < multiSearchVillageList.length; i++) {
                    String value = villageUiModel[i].value;
                    if (villageName.length > 0) {
                      villageName = villageName + "," + value;
                    } else {
                      villageName = villageName + value;
                    }
                    valVillage = villageName;
                    farmersearch2(valVillage);
                  }
                  entityFarmerID();
                });
              })
          : Container());
    }

    if (entity != "3") {
      listings.add(farmerMultiSearchDropDown
          ? txt_label_mandatory("Farmer", Colors.black, 14.0, false)
          : Container());
      listings.add(farmerMultiSearchDropDown
          ? multisearchDropdownHint(
              hint: "Select the Farmer",
              itemlist: multiFarmeritems,
              selectedlist: multiSearchFarmerList,
              onChanged: (item) {
                setState(() {
                  multiSearchFarmerList = item;
                  String farmerName = "";
                  for (int i = 0; i < multiSearchFarmerList.length; i++) {
                    String value = farmerUiModel[i].value;
                    if (farmerName.length > 0) {
                      farmerName = farmerName + "," + value;
                    } else {
                      farmerName = farmerName + value;
                    }
                    valFarmer = farmerName;
                    farmSearch(valFarmer);
                  }
                  entityFarmerID();
                });
              })
          : Container());
    }

    if (farmDropdown) {
      listings.add(farmLoaded
          ? txt_label_mandatory("Farm", Colors.black, 14.0, false)
          : Container());
      listings.add(farmLoaded
          ? singlesearchdynamic(
              itemlist: farmItems,
              selecteditem: selectFarm,
              hint: "Select the Farm",
              onChanged: (value) {
                setState(() {
                  selectFarm = value;
                  slcFarm = selectFarm!.name;
                  valFarm = selectFarm!.value;
                  Crop(valFarm);

                  entityFarmerID();
                });
              },
            )
          : Container());
    }

    if (entity != "3") {
      listings.add(cropDropDown
          ? txt_label_mandatory("Crop", Colors.black, 14.0, false)
          : Container());
      listings.add(cropDropDown
          ? singlesearchdynamic(
              itemlist: cropItems,
              selecteditem: selectCrop,
              hint: "Select the Crop",
              onChanged: (value) {
                setState(() {
                  selectCrop = value;
                  slcCrop = selectCrop!.name;
                  valCrop = selectCrop!.value;
                  entityFarmerID();
                });
              },
            )
          : Container());
    }

    listings.add(txt_label_mandatory("Season", Colors.black, 14.0, false));
    listings.add(singlesearchdynamic(
      itemlist: seasonItems,
      selecteditem: selectSeason,
      hint: "Select the Season",
      onChanged: (value) {
        setState(() {
          selectSeason = value!;
          slcSeason = selectSeason!.name;
          valSeason = selectSeason!.value;
        });
      },
    ));

    int dropdownload = 0;
    int listnumber = 0;
    int photocount = 0;
    int controllercount = 1;
    int sectionIdCount = 1;
    int radiobutton = 0;
    int largeTextControllerCount = 0;

    validationlist = [];

    String secname = '';

    for (int i = 0; i < dynamiccomponentFields.length; i++) {
      String componentType =
          dynamiccomponentFields[i]["componentType"].toString();
      String componentLabel =
          dynamiccomponentFields[i]["componentLabel"].toString();
      String componentID = dynamiccomponentFields[i]["componentID"].toString();
      String isMandatory = dynamiccomponentFields[i]["isMandatory"].toString();
      String formulaDependency =
          dynamiccomponentFields[i]["formulaDependency"].toString();
      String isDependency =
          dynamiccomponentFields[i]["isDependency"].toString();
      String dependencyField =
          dynamiccomponentFields[i]["dependencyField"].toString();

      String validationType =
          dynamiccomponentFields[i]["validationType"].toString();

      String sectionId = dynamiccomponentFields[i]["sectionId"].toString();
      String secName = dynamiccomponentFields[i]["secName"].toString();
      String listID = dynamiccomponentFields[i]["listId"].toString();

      if (secname != secName) {
        secname = secName;
        listings.add(txt_label(secName, Colors.green, 18.0, true));
      }

      validationlist
          .add(ValidationModel("", sectionId, isMandatory, componentID));

      switch (componentType) {
        case "1": //textfield
          if (isMandatory == "1") {
            listings.add(
                txt_label_mandatory(componentLabel, Colors.black, 14.0, false));
          } else if (isMandatory == "0") {
            listings.add(txt_label(componentLabel, Colors.black, 14.0, false));
          }

          switch (controllercount) {
            case 1:
              if (validationType == '2' || validationType == '4') {
                listings.add(txtfield_digitswithoutdecimal(
                    componentLabel, controller1, true, 80));
              } else {
                listings
                    .add(txtfield_dynamic(componentLabel, controller1, true));
              }
              controller1.addListener(() {
                final text = controller1.text;
                var compenentModel = new ComponentModel(
                    componentID,
                    text,
                    i.toString(),
                    componentType,
                    sectionId,
                    isMandatory,
                    componentLabel,
                    text,
                    "1");
                updateDynamicComponent(compenentModel);
              });
              break;

            case 2:
              if (validationType == '2' || validationType == '4') {
                listings.add(txtfield_digitswithoutdecimal(
                    componentLabel, controller2, true, 80));
              } else {
                listings
                    .add(txtfield_dynamic(componentLabel, controller2, true));
              }
              controller2.addListener(() {
                final text = controller2.text;
                var compenentModel = new ComponentModel(
                    componentID,
                    text,
                    i.toString(),
                    componentType,
                    sectionId,
                    isMandatory,
                    componentLabel,
                    text,
                    "1");
                updateDynamicComponent(compenentModel);
              });

              break;
            case 3:
              if (validationType == '2' || validationType == '4') {
                listings.add(txtfield_digitswithoutdecimal(
                    componentLabel, controller3, true, 80));
              } else {
                listings
                    .add(txtfield_dynamic(componentLabel, controller3, true));
              }
              controller3.addListener(() {
                final text = controller3.text;
                var compenentModel = new ComponentModel(
                    componentID,
                    text,
                    i.toString(),
                    componentType,
                    sectionId,
                    isMandatory,
                    componentLabel,
                    text,
                    "1");
                updateDynamicComponent(compenentModel);
              });

              break;
            case 4:
              if (validationType == '2' || validationType == '4') {
                listings.add(txtfield_digitswithoutdecimal(
                    componentLabel, controller4, true, 80));
              } else {
                listings
                    .add(txtfield_dynamic(componentLabel, controller4, true));
              }
              controller4.addListener(() {
                final text = controller4.text;
                var compenentModel = new ComponentModel(
                    componentID,
                    text,
                    i.toString(),
                    componentType,
                    sectionId,
                    isMandatory,
                    componentLabel,
                    text,
                    "1");
                updateDynamicComponent(compenentModel);
              });

              break;
            case 5:
              if (validationType == '2' || validationType == '4') {
                listings.add(txtfield_digitswithoutdecimal(
                    componentLabel, controller5, true, 80));
              } else {
                listings
                    .add(txtfield_dynamic(componentLabel, controller5, true));
              }
              controller5.addListener(() {
                final text = controller5.text;
                var compenentModel = new ComponentModel(
                    componentID,
                    text,
                    i.toString(),
                    componentType,
                    sectionId,
                    isMandatory,
                    componentLabel,
                    text,
                    "1");
                updateDynamicComponent(compenentModel);
              });
              break;
            case 6:
              if (validationType == '2' || validationType == '4') {
                listings.add(txtfield_digitswithoutdecimal(
                    componentLabel, controller6, true, 80));
              } else {
                listings
                    .add(txtfield_dynamic(componentLabel, controller6, true));
              }
              controller6.addListener(() {
                final text = controller6.text;
                var compenentModel = new ComponentModel(
                    componentID,
                    text,
                    i.toString(),
                    componentType,
                    sectionId,
                    isMandatory,
                    componentLabel,
                    text,
                    "1");
                updateDynamicComponent(compenentModel);
              });
              break;

            case 7:
              if (validationType == '2' || validationType == '4') {
                listings.add(txtfield_digitswithoutdecimal(
                    componentLabel, controller7, true, 80));
              } else {
                listings
                    .add(txtfield_dynamic(componentLabel, controller7, true));
              }
              controller7.addListener(() {
                final text = controller7.text;
                var compenentModel = new ComponentModel(
                    componentID,
                    text,
                    i.toString(),
                    componentType,
                    sectionId,
                    isMandatory,
                    componentLabel,
                    text,
                    "1");
                updateDynamicComponent(compenentModel);
              });
              break;

            case 8:
              if (validationType == '2' || validationType == '4') {
                listings.add(txtfield_digitswithoutdecimal(
                    componentLabel, controller8, true, 80));
              } else {
                listings
                    .add(txtfield_dynamic(componentLabel, controller8, true));
              }
              controller8.addListener(() {
                final text = controller8.text;
                var compenentModel = new ComponentModel(
                    componentID,
                    text,
                    i.toString(),
                    componentType,
                    sectionId,
                    isMandatory,
                    componentLabel,
                    text,
                    "1");
                updateDynamicComponent(compenentModel);
              });
              break;

            case 9:
              if (validationType == '2' || validationType == '4') {
                listings.add(txtfield_digitswithoutdecimal(
                    componentLabel, controller9, true, 80));
              } else {
                listings
                    .add(txtfield_dynamic(componentLabel, controller9, true));
              }
              controller9.addListener(() {
                final text = controller9.text;
                var compenentModel = new ComponentModel(
                    componentID,
                    text,
                    i.toString(),
                    componentType,
                    sectionId,
                    isMandatory,
                    componentLabel,
                    text,
                    "1");
                updateDynamicComponent(compenentModel);
              });
              break;

            case 10:
              if (validationType == '2' || validationType == '4') {
                listings.add(txtfield_digitswithoutdecimal(
                    componentLabel, controller10, true, 80));
              } else {
                listings
                    .add(txtfield_dynamic(componentLabel, controller10, true));
              }
              controller10.addListener(() {
                final text = controller10.text;
                var compenentModel = new ComponentModel(
                    componentID,
                    text,
                    i.toString(),
                    componentType,
                    sectionId,
                    isMandatory,
                    componentLabel,
                    text,
                    "1");
                updateDynamicComponent(compenentModel);
              });
              break;

            case 11:
              if (validationType == '2' || validationType == '4') {
                listings.add(txtfield_digitswithoutdecimal(
                    componentLabel, controller11, true, 80));
              } else {
                listings
                    .add(txtfield_dynamic(componentLabel, controller11, true));
              }
              controller11.addListener(() {
                final text = controller11.text;
                var compenentModel = new ComponentModel(
                    componentID,
                    text,
                    i.toString(),
                    componentType,
                    sectionId,
                    isMandatory,
                    componentLabel,
                    text,
                    "1");
                updateDynamicComponent(compenentModel);
              });
              break;

            case 12:
              if (validationType == '2' || validationType == '4') {
                listings.add(txtfield_digitswithoutdecimal(
                    componentLabel, controller12, true, 80));
              } else {
                listings
                    .add(txtfield_dynamic(componentLabel, controller12, true));
              }
              controller12.addListener(() {
                final text = controller12.text;
                var compenentModel = new ComponentModel(
                    componentID,
                    text,
                    i.toString(),
                    componentType,
                    sectionId,
                    isMandatory,
                    componentLabel,
                    text,
                    "1");
                updateDynamicComponent(compenentModel);
              });
              break;

            case 13:
              if (validationType == '2' || validationType == '4') {
                listings.add(txtfield_digitswithoutdecimal(
                    componentLabel, controller13, true, 80));
              } else {
                listings
                    .add(txtfield_dynamic(componentLabel, controller13, true));
              }
              controller13.addListener(() {
                final text = controller13.text;
                var compenentModel = new ComponentModel(
                    componentID,
                    text,
                    i.toString(),
                    componentType,
                    sectionId,
                    isMandatory,
                    componentLabel,
                    text,
                    "1");
                updateDynamicComponent(compenentModel);
              });
              break;

            case 14:
              if (validationType == '2' || validationType == '4') {
                listings.add(txtfield_digitswithoutdecimal(
                    componentLabel, controller14, true, 80));
              } else {
                listings
                    .add(txtfield_dynamic(componentLabel, controller14, true));
              }
              controller14.addListener(() {
                final text = controller14.text;
                var compenentModel = new ComponentModel(
                    componentID,
                    text,
                    i.toString(),
                    componentType,
                    sectionId,
                    isMandatory,
                    componentLabel,
                    text,
                    "1");
                updateDynamicComponent(compenentModel);
              });
              break;

            case 15:
              if (validationType == '2' || validationType == '4') {
                listings.add(txtfield_digitswithoutdecimal(
                    componentLabel, controller15, true, 80));
              } else {
                listings
                    .add(txtfield_dynamic(componentLabel, controller15, true));
              }
              controller15.addListener(() {
                final text = controller15.text;
                var compenentModel = new ComponentModel(
                    componentID,
                    text,
                    i.toString(),
                    componentType,
                    sectionId,
                    isMandatory,
                    componentLabel,
                    text,
                    "1");
                updateDynamicComponent(compenentModel);
              });

              break;

            case 16:
              if (validationType == '2' || validationType == '4') {
                listings.add(txtfield_digitswithoutdecimal(
                    componentLabel, controller16, true, 80));
              } else {
                listings
                    .add(txtfield_dynamic(componentLabel, controller16, true));
              }
              controller16.addListener(() {
                final text = controller16.text;
                var compenentModel = new ComponentModel(
                    componentID,
                    text,
                    i.toString(),
                    componentType,
                    sectionId,
                    isMandatory,
                    componentLabel,
                    text,
                    "1");
                updateDynamicComponent(compenentModel);
              });
              break;
          }

          controllercount = controllercount + 1;
          break;
        case "2":
          if (isMandatory == "1") {
            listings.add(
                txt_label_mandatory(componentLabel, Colors.black, 14.0, false));
          } else if (isMandatory == "0") {
            listings.add(txt_label(componentLabel, Colors.black, 14.0, false));
          }

          switch (radiobutton) {
            case 0:
              radiobutton = radiobutton + 1;
              listings.add(radio_dynamic(
                  map: map1,
                  selectedKey: selectedValue1,
                  onChange: (value) {
                    setState(() {
                      selectedValue1 = value!;
                      if (value == 'option1') {
                        mapValue1 = '2';
                      } else {
                        mapValue1 = '1';
                      }

                      var compenentModel = new ComponentModel(
                          componentID,
                          mapValue1,
                          i.toString(),
                          componentType,
                          sectionId,
                          isMandatory,
                          componentLabel,
                          mapValue1,
                          "");
                      updateDynamicComponent(compenentModel);
                    });
                  }));
              break;

            case 1:
              radiobutton = radiobutton + 1;
              listings.add(radio_dynamic(
                  map: map2,
                  selectedKey: selectedValue2,
                  onChange: (value) {
                    setState(() {
                      selectedValue2 = value!;
                      if (value == 'option1') {
                        mapValue2 = '2';
                      } else {
                        mapValue2 = '1';
                      }
                      var compenentModel = new ComponentModel(
                          componentID,
                          mapValue2,
                          i.toString(),
                          componentType,
                          sectionId,
                          isMandatory,
                          componentLabel,
                          mapValue2,
                          "");
                      updateDynamicComponent(compenentModel);
                    });
                  }));
              break;

            case 2:
              radiobutton = radiobutton + 1;
              listings.add(radio_dynamic(
                  map: map3,
                  selectedKey: selectedValue3,
                  onChange: (value) {
                    setState(() {
                      selectedValue3 = value!;
                      if (value == 'option1') {
                        mapValue3 = '2';
                      } else {
                        mapValue3 = '1';
                      }
                      var compenentModel = new ComponentModel(
                          componentID,
                          mapValue3,
                          i.toString(),
                          componentType,
                          sectionId,
                          isMandatory,
                          componentLabel,
                          mapValue3,
                          "");
                      updateDynamicComponent(compenentModel);
                    });
                  }));
              break;

            case 3:
              radiobutton = radiobutton + 1;
              listings.add(radio_dynamic(
                  map: map4,
                  selectedKey: selectedValue4,
                  onChange: (value) {
                    setState(() {
                      selectedValue4 = value!;
                      if (value == 'option1') {
                        mapValue4 = '2';
                      } else {
                        mapValue4 = '1';
                      }

                      var compenentModel = new ComponentModel(
                          componentID,
                          mapValue4,
                          i.toString(),
                          componentType,
                          sectionId,
                          isMandatory,
                          componentLabel,
                          mapValue4,
                          "");
                      updateDynamicComponent(compenentModel);
                    });
                  }));
              break;
          }
          break;

        case "3": // date selection

          if (isMandatory == "1") {
            listings.add(
                txt_label_mandatory(componentLabel, Colors.black, 14.0, false));
          } else {
            listings.add(txt_label(componentLabel, Colors.black, 14.0, false));
          }
          listings.add(selectDate(
            context1: context,
            slctdate: Dates[i],
            onConfirm: (date) => setState(() {
              String slctdates = DateFormat('dd-MM-yyyy').format(date!);
              Dates[i] = slctdates;
              var compenentModel = new ComponentModel(
                  componentID,
                  slctdates,
                  i.toString(),
                  componentType,
                  sectionId,
                  isMandatory,
                  componentLabel,
                  slctdates,
                  "");
              updateDynamicComponent(compenentModel);
            }),
          ));
          break;

        case "4": // dropdown
          if (isMandatory == "1") {
            listings.add(
                txt_label_mandatory(componentLabel, Colors.black, 14.0, false));
          } else {
            listings.add(txt_label(componentLabel, Colors.black, 14.0, false));
          }
          switch (dropdownload) {
            case 0:
              dropdownload = dropdownload + 1;
              String selecteditem;
              List<DropdownModel> DropdownList = [];
              List dropdownlist = [];
              dropdownlist = dropdownlist1;
              if (dropdownlist1.isNotEmpty) {
                List<UImodel> UImodels = [];
                UImodels = [];
                //DropdownList.clear();

                for (int i = 0; i < dropdownlist.length; i++) {
                  String property_value =
                      dropdownlist[i]["property_value"].toString();
                  String DISP_SEQ = dropdownlist[i]["DISP_SEQ"].toString();

                  var uimodel = new UImodel(property_value, DISP_SEQ);
                  UImodels.add(uimodel);

                  setState(() {
                    DropdownList.add(DropdownModel(
                      property_value,
                      DISP_SEQ,
                    ));
                  });
                }

                listings.add(singlesearchdynamic(
                    itemlist: DropdownList,
                    selecteditem: selectedItem1,
                    hint: componentLabel,
                    onChanged: (value) {
                      setState(() {
                        selectedItem1 = value!;
                        valueItem1 = selectedItem1!.value;

                        var compenentModel = new ComponentModel(
                            componentID,
                            selectedItem1!.name,
                            i.toString(),
                            componentType,
                            sectionId,
                            isMandatory,
                            componentLabel,
                            valueItem1,
                            "");
                        updateDynamicComponent(compenentModel);
                      });
                    }));
              }
              break;
            case 1:
              dropdownload = dropdownload + 1;
              String selecteditem;
              List<DropdownModel> DropdownList = [];
              List dropdownlist = [];
              dropdownlist = dropdownlist2;
              if (dropdownlist2.isNotEmpty) {
                List<UImodel> UImodels = [];
                UImodels = [];
                // DropdownList.clear();

                for (int i = 0; i < dropdownlist.length; i++) {
                  String property_value =
                      dropdownlist[i]["property_value"].toString();
                  String DISP_SEQ = dropdownlist[i]["DISP_SEQ"].toString();

                  var uimodel = new UImodel(property_value, DISP_SEQ);
                  UImodels.add(uimodel);

                  setState(() {
                    DropdownList.add(DropdownModel(
                      property_value,
                      DISP_SEQ,
                    ));
                  });
                }

                listings.add(singlesearchdynamic(
                    itemlist: DropdownList,
                    selecteditem: selectedItem2,
                    hint: componentLabel,
                    onChanged: (value) {
                      setState(() {
                        selectedItem2 = value!;
                        valueItem2 = selectedItem2!.value;

                        var compenentModel = new ComponentModel(
                            componentID,
                            selectedItem2!.name,
                            i.toString(),
                            componentType,
                            sectionId,
                            isMandatory,
                            componentLabel,
                            valueItem2,
                            "");
                        updateDynamicComponent(compenentModel);
                      });
                    }));
              }
              break;
            case 2:
              dropdownload = dropdownload + 1;
              String selecteditem;
              List<DropdownModel> DropdownList = [];
              List dropdownlist = [];
              dropdownlist = dropdownlist3;
              List<UImodel> UImodels = [];
              UImodels = [];
              //  DropdownList.clear();

              for (int i = 0; i < dropdownlist.length; i++) {
                String property_value =
                    dropdownlist[i]["property_value"].toString();
                String DISP_SEQ = dropdownlist[i]["DISP_SEQ"].toString();

                var uimodel = new UImodel(property_value, DISP_SEQ);
                UImodels.add(uimodel);

                setState(() {
                  DropdownList.add(DropdownModel(
                    property_value,
                    DISP_SEQ,
                  ));
                });
              }

              listings.add(singlesearchdynamic(
                  itemlist: DropdownList,
                  selecteditem: selectedItem3,
                  hint: componentLabel,
                  onChanged: (value) {
                    setState(() {
                      selectedItem3 = value!;
                      valueItem3 = selectedItem3!.value;

                      var compenentModel = new ComponentModel(
                          componentID,
                          selectedItem3!.name,
                          i.toString(),
                          componentType,
                          sectionId,
                          isMandatory,
                          componentLabel,
                          valueItem3,
                          "");
                      updateDynamicComponent(compenentModel);
                    });
                  }));
              break;
            case 3:
              dropdownload = dropdownload + 1;
              String selectedItem;
              List<DropdownModel> DropdownList = [];
              List dropdownlist = [];
              dropdownlist = dropdownlist4;
              List<UImodel> UImodels = [];
              UImodels = [];
              // DropdownList.clear();

              for (int i = 0; i < dropdownlist.length; i++) {
                String property_value =
                    dropdownlist[i]["property_value"].toString();
                String DISP_SEQ = dropdownlist[i]["DISP_SEQ"].toString();

                var uimodel = new UImodel(property_value, DISP_SEQ);
                UImodels.add(uimodel);

                setState(() {
                  DropdownList.add(DropdownModel(
                    property_value,
                    DISP_SEQ,
                  ));
                });
              }

              listings.add(dropdownLoaded
                  ? singlesearchdynamic(
                      itemlist: DropdownList,
                      selecteditem: selectedItem4,
                      hint: componentLabel,
                      onChanged: (value) {
                        setState(() {
                          selectedItem4 = value!;
                          valueItem4 = selectedItem4!.value;

                          var compenentModel = new ComponentModel(
                              componentID,
                              selectedItem4!.name,
                              i.toString(),
                              componentType,
                              sectionId,
                              isMandatory,
                              componentLabel,
                              valueItem4,
                              "2");
                          updateDynamicComponent(compenentModel);
                        });
                      },
                    )
                  : Container());
              break;
            case 4:
              dropdownload = dropdownload + 1;
              String selectedItem;
              List<DropdownModel> DropdownList = [];
              List dropdownlist = [];
              dropdownlist = dropdownlist5;
              List<UImodel> UImodels = [];
              UImodels = [];
              //DropdownList.clear();

              for (int i = 0; i < dropdownlist.length; i++) {
                String property_value =
                    dropdownlist[i]["property_value"].toString();
                String DISP_SEQ = dropdownlist[i]["DISP_SEQ"].toString();

                var uimodel = new UImodel(property_value, DISP_SEQ);
                UImodels.add(uimodel);

                setState(() {
                  DropdownList.add(DropdownModel(
                    property_value,
                    DISP_SEQ,
                  ));
                });
              }

              listings.add(dropdownLoaded
                  ? singlesearchdynamic(
                      itemlist: DropdownList,
                      selecteditem: selectedItem5,
                      hint: componentLabel,
                      onChanged: (value) {
                        setState(() {
                          selectedItem5 = value!;
                          valueItem5 = selectedItem5!.value;
                          var compenentModel = new ComponentModel(
                              componentID,
                              selectedItem5!.name,
                              i.toString(),
                              componentType,
                              sectionId,
                              isMandatory,
                              componentLabel,
                              valueItem5,
                              "");
                          updateDynamicComponent(compenentModel);
                        });
                      },
                    )
                  : Container());
              break;
            case 5:
              dropdownload = dropdownload + 1;
              String selectedItem;
              List<DropdownModel> DropdownList = [];
              List dropdownlist = [];
              dropdownlist = dropdownlist6;
              List<UImodel> UImodels = [];
              UImodels = [];
              //DropdownList.clear();

              for (int i = 0; i < dropdownlist.length; i++) {
                String property_value =
                    dropdownlist[i]["property_value"].toString();
                String DISP_SEQ = dropdownlist[i]["DISP_SEQ"].toString();

                var uimodel = new UImodel(property_value, DISP_SEQ);
                UImodels.add(uimodel);

                setState(() {
                  DropdownList.add(DropdownModel(
                    property_value,
                    DISP_SEQ,
                  ));
                });
              }

              listings.add(dropdownLoaded
                  ? singlesearchdynamic(
                      itemlist: DropdownList,
                      selecteditem: selectedItem6,
                      hint: componentLabel,
                      onChanged: (value) {
                        setState(() {
                          selectedItem6 = value!;
                          valueItem6 = selectedItem6!.value;

                          var compenentModel = new ComponentModel(
                              componentID,
                              selectedItem6!.name,
                              i.toString(),
                              componentType,
                              sectionId,
                              isMandatory,
                              componentLabel,
                              valueItem6,
                              "");
                          updateDynamicComponent(compenentModel);
                        });
                      },
                    )
                  : Container());
              break;
            case 6:
              dropdownload = dropdownload + 1;
              String selecteditem;
              List<DropdownModel> DropdownList = [];
              List dropdownlist = [];
              dropdownlist = dropdownlist7;
              List<UImodel> UImodels = [];
              UImodels = [];
              // DropdownList.clear();

              for (int i = 0; i < dropdownlist.length; i++) {
                String property_value =
                    dropdownlist[i]["property_value"].toString();
                String DISP_SEQ = dropdownlist[i]["DISP_SEQ"].toString();

                var uimodel = new UImodel(property_value, DISP_SEQ);
                UImodels.add(uimodel);

                setState(() {
                  DropdownList.add(DropdownModel(
                    property_value,
                    DISP_SEQ,
                  ));
                });
              }

              listings.add(singlesearchdynamic(
                  itemlist: DropdownList,
                  selecteditem: selectedItem7,
                  hint: componentLabel,
                  onChanged: (value) {
                    setState(() {
                      selectedItem7 = value!;
                      valueItem7 = selectedItem7!.value;

                      var compenentModel = new ComponentModel(
                          componentID,
                          selectedItem7!.name,
                          i.toString(),
                          componentType,
                          sectionId,
                          isMandatory,
                          componentLabel,
                          valueItem7,
                          "");
                      updateDynamicComponent(compenentModel);
                    });
                  }));
              break;
            case 7:
              dropdownload = dropdownload + 1;
              String selecteditem;
              List<DropdownModel> DropdownList = [];
              List dropdownlist = [];
              dropdownlist = dropdownlist8;
              List<UImodel> UImodels = [];
              UImodels = [];
              // DropdownList.clear();

              for (int i = 0; i < dropdownlist.length; i++) {
                String property_value =
                    dropdownlist[i]["property_value"].toString();
                String DISP_SEQ = dropdownlist[i]["DISP_SEQ"].toString();

                var uimodel = new UImodel(property_value, DISP_SEQ);
                UImodels.add(uimodel);

                setState(() {
                  DropdownList.add(DropdownModel(
                    property_value,
                    DISP_SEQ,
                  ));
                });
              }

              listings.add(singlesearchdynamic(
                  itemlist: DropdownList,
                  selecteditem: selectedItem8,
                  hint: componentLabel,
                  onChanged: (value) {
                    setState(() {
                      selectedItem8 = value!;
                      valueItem8 = selectedItem8!.value;

                      var compenentModel = new ComponentModel(
                          componentID,
                          selectedItem8!.name,
                          i.toString(),
                          componentType,
                          sectionId,
                          isMandatory,
                          componentLabel,
                          valueItem8,
                          "");
                      updateDynamicComponent(compenentModel);
                    });
                  }));
              break;
            case 8:
              dropdownload = dropdownload + 1;
              String selecteditem;
              List<DropdownModel> DropdownList = [];
              List dropdownlist = [];
              dropdownlist = dropdownlist9;
              List<UImodel> UImodels = [];
              UImodels = [];
              //DropdownList.clear();

              for (int i = 0; i < dropdownlist.length; i++) {
                String property_value =
                    dropdownlist[i]["property_value"].toString();
                String DISP_SEQ = dropdownlist[i]["DISP_SEQ"].toString();

                var uimodel = new UImodel(property_value, DISP_SEQ);
                UImodels.add(uimodel);

                setState(() {
                  DropdownList.add(DropdownModel(
                    property_value,
                    DISP_SEQ,
                  ));
                });
              }

              listings.add(singlesearchdynamic(
                  itemlist: DropdownList,
                  selecteditem: selectedItem9,
                  hint: componentLabel,
                  onChanged: (value) {
                    setState(() {
                      selectedItem9 = value!;
                      valueItem9 = selectedItem9!.value;

                      var compenentModel = new ComponentModel(
                          componentID,
                          selectedItem9!.name,
                          i.toString(),
                          componentType,
                          sectionId,
                          isMandatory,
                          componentLabel,
                          valueItem9,
                          "");
                      updateDynamicComponent(compenentModel);
                    });
                  }));
              break;
            case 9:
              dropdownload = dropdownload + 1;
              String selecteditem;
              List<DropdownModel> DropdownList = [];
              List dropdownlist = [];
              dropdownlist = dropdownlist10;
              List<UImodel> UImodels = [];
              UImodels = [];
              //  DropdownList.clear();

              for (int i = 0; i < dropdownlist.length; i++) {
                String property_value =
                    dropdownlist[i]["property_value"].toString();
                String DISP_SEQ = dropdownlist[i]["DISP_SEQ"].toString();

                var uimodel = new UImodel(property_value, DISP_SEQ);
                UImodels.add(uimodel);

                setState(() {
                  DropdownList.add(DropdownModel(property_value, DISP_SEQ));
                });
              }

              listings.add(singlesearchdynamic(
                  itemlist: DropdownList,
                  selecteditem: selectedItem10,
                  hint: componentLabel,
                  onChanged: (value) {
                    setState(() {
                      selectedItem10 = value!;
                      valueItem10 = selectedItem10!.value;

                      var compenentModel = new ComponentModel(
                          componentID,
                          selectedItem10!.name,
                          i.toString(),
                          componentType,
                          sectionId,
                          isMandatory,
                          componentLabel,
                          valueItem10,
                          "");
                      updateDynamicComponent(compenentModel);
                    });
                  }));
              break;

            case 10:
              dropdownload = dropdownload + 1;
              String selecteditem;
              List<DropdownModel> DropdownList = [];
              List dropdownlist = [];
              dropdownlist = dropdownlist11;
              List<UImodel> UImodels = [];
              UImodels = [];
              // DropdownList.clear();

              for (int i = 0; i < dropdownlist.length; i++) {
                String property_value =
                    dropdownlist[i]["property_value"].toString();
                String DISP_SEQ = dropdownlist[i]["DISP_SEQ"].toString();

                var uimodel = new UImodel(property_value, DISP_SEQ);
                UImodels.add(uimodel);

                setState(() {
                  DropdownList.add(DropdownModel(
                    property_value,
                    DISP_SEQ,
                  ));
                });
              }

              listings.add(singlesearchdynamic(
                  itemlist: DropdownList,
                  selecteditem: selectedItem11,
                  hint: componentLabel,
                  onChanged: (value) {
                    setState(() {
                      selectedItem11 = value!;
                      valueItem11 = selectedItem11!.value;

                      var compenentModel = new ComponentModel(
                          componentID,
                          selectedItem11!.name,
                          i.toString(),
                          componentType,
                          sectionId,
                          isMandatory,
                          componentLabel,
                          valueItem11,
                          "");
                      updateDynamicComponent(compenentModel);
                    });
                  }));
              break;

            case 11:
              dropdownload = dropdownload + 1;
              String selecteditem;
              List<DropdownModel> DropdownList = [];
              List dropdownlist = [];
              dropdownlist = dropdownlist12;
              List<UImodel> UImodels = [];
              UImodels = [];
              // DropdownList.clear();

              for (int i = 0; i < dropdownlist.length; i++) {
                String property_value =
                    dropdownlist[i]["property_value"].toString();
                String DISP_SEQ = dropdownlist[i]["DISP_SEQ"].toString();

                var uimodel = new UImodel(property_value, DISP_SEQ);
                UImodels.add(uimodel);

                setState(() {
                  DropdownList.add(DropdownModel(
                    property_value,
                    DISP_SEQ,
                  ));
                });
              }

              listings.add(singlesearchdynamic(
                  itemlist: DropdownList,
                  selecteditem: selectedItem12,
                  hint: componentLabel,
                  onChanged: (value) {
                    setState(() {
                      selectedItem12 = value!;
                      valueItem12 = selectedItem12!.value;

                      var compenentModel = new ComponentModel(
                          componentID,
                          selectedItem12!.name,
                          i.toString(),
                          componentType,
                          sectionId,
                          isMandatory,
                          componentLabel,
                          valueItem12,
                          "");
                      updateDynamicComponent(compenentModel);
                    });
                  }));
              break;

            case 12:
              dropdownload = dropdownload + 1;
              String selecteditem;
              List<DropdownModel> DropdownList = [];
              List dropdownlist = [];
              dropdownlist = dropdownlist13;
              List<UImodel> UImodels = [];
              UImodels = [];
              // DropdownList.clear();

              for (int i = 0; i < dropdownlist.length; i++) {
                String property_value =
                    dropdownlist[i]["property_value"].toString();
                String DISP_SEQ = dropdownlist[i]["DISP_SEQ"].toString();

                var uimodel = new UImodel(property_value, DISP_SEQ);
                UImodels.add(uimodel);

                setState(() {
                  DropdownList.add(DropdownModel(
                    property_value,
                    DISP_SEQ,
                  ));
                });
              }

              listings.add(singlesearchdynamic(
                  itemlist: DropdownList,
                  selecteditem: selectedItem13,
                  hint: componentLabel,
                  onChanged: (value) {
                    setState(() {
                      selectedItem13 = value!;
                      valueItem13 = selectedItem13!.value;

                      var compenentModel = new ComponentModel(
                          componentID,
                          selectedItem13!.name,
                          i.toString(),
                          componentType,
                          sectionId,
                          isMandatory,
                          componentLabel,
                          valueItem13,
                          "");
                      updateDynamicComponent(compenentModel);
                    });
                  }));
              break;
          }

          break;

        case "5":
          if (isMandatory == "1") {
            listings.add(
                txt_label_mandatory(componentLabel, Colors.black, 14.0, false));
          } else if (isMandatory == "0") {
            listings.add(txt_label(componentLabel, Colors.black, 14.0, false));
          }

          switch (largeTextControllerCount) {
            case 0:
              largeTextControllerCount = largeTextControllerCount + 1;
              listings.add(
                  txtFieldLargeDynamic(componentLabel, controller1Type, true));
              controller1Type.addListener(() {
                final text = controller1Type.text;
                var compenentModel = new ComponentModel(
                    componentID,
                    text,
                    i.toString(),
                    componentType,
                    sectionId,
                    isMandatory,
                    componentLabel,
                    text,
                    "1");
                updateDynamicComponent(compenentModel);
              });

              break;
            case 1:
              largeTextControllerCount = largeTextControllerCount + 1;
              listings.add(
                  txtFieldLargeDynamic(componentLabel, controller2Type, true));
              controller2Type.addListener(() {
                final text = controller2Type.text;
                var compenentModel = new ComponentModel(
                    componentID,
                    text,
                    i.toString(),
                    componentType,
                    sectionId,
                    isMandatory,
                    componentLabel,
                    text,
                    "2");
                updateDynamicComponent(compenentModel);
              });

              break;

            case 2:
              largeTextControllerCount = largeTextControllerCount + 1;
              listings.add(
                  txtFieldLargeDynamic(componentLabel, controller3Type, true));
              controller3Type.addListener(() {
                final text = controller3Type.text;
                var compenentModel = new ComponentModel(
                    componentID,
                    text,
                    i.toString(),
                    componentType,
                    sectionId,
                    isMandatory,
                    componentLabel,
                    text,
                    "1");
                updateDynamicComponent(compenentModel);
              });
          }
          break;

        case "7": //label

          listings.add(
              txt_label_mandatory(componentLabel, Colors.black, 14.0, false));

          if (formulaDependency != '') {
            List<String> formdeps;
            String value1 = "", value2 = "";

            // c= CG102*C049

            if (formulaDependency.contains('*')) {
              formdeps = formulaDependency.split('*');
              setState(() {
                String firstValue =
                    formdeps[0].replaceAll(new RegExp(r'[^\w\s]+'), '');
                String secondValue =
                    formdeps[1].replaceAll(new RegExp(r'[^\w\s]+'), '');

                value1 = firstValue.trim();
                value2 = secondValue.trim();
              });
              String val1 = '0';
              String val2 = '0';
              for (int k = 0; k < componentidvalue.length; k++) {
                if (value1 == componentidvalue[k].componentid) {
                  val1 = componentidvalue[k].value;
                }
                if (value2 == componentidvalue[k].componentid) {
                  val2 = componentidvalue[k].value;
                }
              }
              int labelvalue = int.parse(val1) * int.parse(val2);
              listings.add(cardlable_dynamic(labelvalue.toString()));
            } else {
              String val = "0";
              String valueFormated = "";
              setState(() {
                String value =
                    formulaDependency.replaceAll(new RegExp(r'[^\w\s]+'), '');
                valueFormated = value.trim();
              });
              for (int k = 0; k < componentidvalue.length; k++) {
                if (valueFormated == componentidvalue[k].componentid) {
                  val = componentidvalue[k].value;
                }
              }
              listings.add(cardlable_dynamic(val));
            }
          }

          break;

        case "8": //label

          // listings.add(
          //     txt_label(componentLabel, Colors.green, 18.0, true));
          if (iterationList != null && iterationList.length > 0) {
            dynamicListValues = [];
            for (int s = 0; s < iterationList.length; s++) {
              if (sectionId == iterationList[s].Section) {
                dynamicListValues.add(iterationList[s]);
              }
            }
            if (dynamicListValues != null && dynamicListValues.length > 0) {
              // listings.add(addDynamic(
              //     productlist: dynamicListValues, title: componentLabel));
              // addbtnclicked = false;
              listings.add(Datatablereg(dynamicListValues));
            }
          }
          break;

        case "14":
          if (weatherinfo.length > 0) {
            for (int i = 0; i < weatherinfo.length; i++) {
              setState(() {
                tempWeather = weatherinfo[0].temp;
                rainWeather = weatherinfo[0].rain;
                humidityWeather = weatherinfo[0].humidity;
                speedWeather = weatherinfo[0].windSpeed;
              });
            }
          }

          if (isMandatory == "1") {
            listings.add(
                txt_label_mandatory(componentLabel, Colors.black, 14.0, false));
          } else {
            listings.add(txt_label(componentLabel, Colors.black, 14.0, false));
          }

          listings.add(Container(
              child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Container(
                      padding: EdgeInsets.all(5),
                      child: Text(
                        'Temperature',
                        style: TextStyle(color: Colors.black38, fontSize: 12),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      padding: EdgeInsets.all(5),
                      child: Text(
                        tempWeather,
                        style: TextStyle(color: Colors.green, fontSize: 14),
                      ),
                    ),
                  ),
                ],
              ),
              Divider(
                color: Colors.black,
              ),
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Container(
                      padding: EdgeInsets.all(5),
                      child: Text(
                        'Rain',
                        style: TextStyle(color: Colors.black38, fontSize: 12),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      padding: EdgeInsets.all(5),
                      child: Text(
                        rainWeather,
                        style: TextStyle(color: Colors.green, fontSize: 14),
                      ),
                    ),
                  ),
                ],
              ),
              Divider(
                color: Colors.black,
              ),
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Container(
                      padding: EdgeInsets.all(5),
                      child: Text(
                        "Humidity",
                        style: TextStyle(color: Colors.black38, fontSize: 12),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      padding: EdgeInsets.all(5),
                      child: Text(
                        humidityWeather,
                        style: TextStyle(color: Colors.green, fontSize: 14),
                      ),
                    ),
                  ),
                ],
              ),
              Divider(
                color: Colors.black,
              ),
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Container(
                      padding: EdgeInsets.all(5),
                      child: Text(
                        'Wind Speed',
                        style: TextStyle(color: Colors.black38, fontSize: 12),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      padding: EdgeInsets.all(5),
                      child: Text(
                        speedWeather,
                        style: TextStyle(color: Colors.green, fontSize: 14),
                      ),
                    ),
                  ),
                ],
              ),
              Divider(
                color: Colors.black,
              ),
            ],
          )));

          break;

        case "12":
          if (isMandatory == "1") {
            listings.add(
                txt_label_mandatory(componentLabel, Colors.black, 14.0, false));
          } else {
            listings.add(txt_label(componentLabel, Colors.black, 14.0, false));
          }
          switch (photocount) {
            case 0:
              photocount = photocount + 1;
              Future getImage() async {
                var image = await ImagePicker.platform
                    .pickImage(source: ImageSource.camera, imageQuality: 25);
                setState(() {
                  _imageFile1 = File(image!.path);
                });
                if (_imageFile1 != null) {
                  List<int> imageBytes = _imageFile1!.readAsBytesSync();
                  image1 = base64Encode(imageBytes);
                }
              }

              void ondelete() {
                if (_imageFile1 != null) {
                  setState(() {
                    _imageFile1 = null;
                  });
                }
              }
              listings.add(img_picker(
                  label: componentLabel,
                  onPressed: getImage,
                  filename: _imageFile1,
                  ondelete: ondelete));

              getLocation();
              final now = new DateTime.now();
              pcTime = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
              setState(() {
                String imageList = "";
                if (listID == "" || listID.length > 0) {
                  imageList = "N";
                }
                var imageModel = new ImageModel(
                    componentID,
                    image1,
                    i.toString(),
                    componentType,
                    sectionId,
                    ImageLat,
                    ImageLng,
                    pcTime,
                    imageList);
                updateDynamicComponentImage(imageModel);
              });

              break;

            case 1:
              photocount = photocount + 1;

              Future getImage() async {
                var image = await ImagePicker.platform
                    .pickImage(source: ImageSource.camera, imageQuality: 25);
                setState(() {
                  _imageFile2 = File(image!.path);
                });
                if (_imageFile2 != null) {
                  List<int> imageBytes = _imageFile2!.readAsBytesSync();
                  image2 = base64Encode(imageBytes);
                }
              }

              void ondelete() {
                if (_imageFile2 != null) {
                  setState(() {
                    _imageFile2 = null;
                  });
                }
              }
              listings.add(img_picker(
                  label: componentLabel,
                  onPressed: getImage,
                  filename: _imageFile2,
                  ondelete: ondelete));

              getLocation();
              final now = new DateTime.now();
              pcTime = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
              setState(() {
                String imageList = "";
                if (listID == "" || listID.length > 0) {
                  imageList = "N";
                }
                var imageModel = new ImageModel(
                    componentID,
                    image1,
                    i.toString(),
                    componentType,
                    sectionId,
                    ImageLat,
                    ImageLng,
                    pcTime,
                    imageList);
                updateDynamicComponentImage(imageModel);
              });

              break;

            case 2:
              Future getImage() async {
                var image = await ImagePicker.platform
                    .pickImage(source: ImageSource.camera, imageQuality: 25);
                setState(() {
                  _imageFile3 = File(image!.path);
                });
                if (_imageFile3 != null) {
                  List<int> imageBytes = _imageFile3!.readAsBytesSync();
                  image3 = base64Encode(imageBytes);
                }
              }

              void ondelete() {
                if (_imageFile3 != null) {
                  setState(() {
                    _imageFile3 = null;
                  });
                }
              }
              photocount = photocount + 1;
              listings.add(img_picker(
                  label: componentLabel,
                  onPressed: getImage,
                  filename: _imageFile3,
                  ondelete: ondelete));

              getLocation();
              final now = new DateTime.now();
              pcTime = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
              setState(() {
                String imageList = "";
                if (listID == "" || listID.length > 0) {
                  imageList = "N";
                }
                var imageModel = new ImageModel(
                    componentID,
                    image1,
                    i.toString(),
                    componentType,
                    sectionId,
                    ImageLat,
                    ImageLng,
                    pcTime,
                    listID);
                updateDynamicComponentImage(imageModel);
              });

              break;
          }

          break;
        case "10": //Button
          listings.add(btn_dynamic(
              label: !editbutton ? componentLabel : "Update",
              bgcolor: Colors.green,
              txtcolor: Colors.white,
              fontsize: 18.0,
              centerRight: Alignment.centerRight,
              margin: 10.0,
              btnSubmit: () async {
                addbtnclicked = true;
                editbutton = false;
                try {
                  List dynamiccomponentList = await db.RawQuery(
                      "select listId from dynamiccomponentList where sectionId = \'" +
                          sectionId +
                          "\'");
                  String listid = dynamiccomponentList[0]["listId"];

                  bool validationpending = false;
                  String validation_message = "";
                  List<String> componentLabels = [];
                  int widgetscount = 0;
                  for (int c = 0; c < dynamiccomponentFields.length; c++) {
                    if (sectionId == dynamiccomponentFields[c]["sectionId"]) {
                      String componentLabel = dynamiccomponentFields[c]
                              ["componentLabel"]
                          .toString();
                      String componentType =
                          dynamiccomponentFields[c]["componentType"].toString();
                      String formulaDependency = dynamiccomponentFields[c]
                              ["formulaDependency"]
                          .toString();
                      String isMandatoryfield =
                          dynamiccomponentFields[c]["isMandatory"].toString();
                      if (componentLabel != "List" &&
                          componentLabel != "Add" &&
                          componentType != "8" &&
                          componentType != "2" &&
                          formulaDependency == "") {
                        if (isMandatoryfield == "1") {
                          widgetscount = widgetscount + 1;
                        }

                        componentLabels.add(componentLabel);
                      }
                    }
                  }

                  //int idscount = 0;
                  try {
                    for (int c = 0; c < componentidvalue.length; c++) {
                      if (sectionId == componentidvalue[c].Section) {
                        if (componentidvalue[c].isMandatory == "1") {
                          idscount = idscount + 1;
                        }
                      }
                    }
                    //toast("Componentid" + componentidvalue.toString());

                    for (int c = 0; c < dynamiccomponentFields.length; c++) {
                      if (sectionId == dynamiccomponentFields[c]["sectionId"]) {
                        String componentID =
                            dynamiccomponentFields[c]["componentID"].toString();
                        String componentLabel = dynamiccomponentFields[c]
                                ["componentLabel"]
                            .toString();
                        if (componentLabel == "List") {
                        } else if (idscount < widgetscount) {
                          print("Id count" + idscount.toString());
                          print("Widget count" + widgetscount.toString());
                          validationpending = true;
                          validation_message =
                              "Mandatory Fields Should not be empty";
                          c = dynamiccomponentFields.length;
                        } else if (componentidvalue.length > 0) {
                          // toast("componentid");
                          for (int k = 0; k < componentidvalue.length; k++) {
                            if (componentidvalue[k].componentid ==
                                componentID) {
                              if (componentidvalue[k].componentid == "") {
                                validationpending = true;
                                validation_message =
                                    componentLabel + " Should not be empty";
                                c = dynamiccomponentFields.length;
                                k = componentidvalue.length;
                                break;
                              }
                            }
                          }
                        } else {
                          //toast("last else");
                          validationpending = true;
                          validation_message =
                              componentLabel + " Should not be empty";
                          c = dynamiccomponentFields.length;
                        }
                      }
                    }
                  } catch (e) {
                    errordialog(context, "Information",
                        "Mandatory Field Should not be empty");
                  }
                  //componentidvalue.clear();

                  if (!validationpending) {
                    positiveflow = true;
                    int iteration = 1;
                    if (iterationList.length != 0) {
                      List<String> dummylist = [];
                      for (int i = 0; i < iterationList.length; i++) {
                        if (iterationList[i].ListId == listid) {
                          dummylist.add(iterationList[i].iTeration);
                        }
                      }
                      iteration = dummylist.length + 1;
                    }

                    String Label = '';
                    String selectedData = "";
                    String dropDownvalue = "";
                    String textControllerValue = "";
                    print("componentidlength" +
                        componentidvalue.length.toString());
                    for (int c = 0; c < componentidvalue.length; c++) {
                      if (sectionId == componentidvalue[c].Section) {
                        String FieldId = componentidvalue[c].componentid;
                        String fieldLabel = componentidvalue[c].value;
                        String FieldVal =
                            componentidvalue[c].componentLabelValue;
                        print("fieldLabel_fieldLabel" + fieldLabel.toString());
                        //String FieldLabelId=componentidvalue[c].componentLabelValue;
                        String ArrayName = "";
                        String listID = listid;
                        String blockId = "";
                        String listHeading = "";

                        if (componentidvalue[c].type == "1") {
                          print("componentidvaluetype" +
                              componentidvalue[c].type);
                          String valu = componentidvalue[c].value;
                          if (textControllerValue == '') {
                            textControllerValue = valu;
                          } else {
                            textControllerValue =
                                textControllerValue + "," + valu;
                          }
                        } else {
                          print("componentidvalue+componentidvaluetype" +
                              componentidvalue[c].value);
                          String value = componentidvalue[c].value;
                          if (dropDownvalue == '') {
                            dropDownvalue = value;
                          } else {
                            dropDownvalue = dropDownvalue + "," + value;
                          }
                        }

                        print("selectedData_selectedData" + selectedData);
                        db.SaveDynamicListValue(
                            FieldId,
                            FieldVal,
                            fieldLabel,
                            ArrayName,
                            listID,
                            textControllerValue,
                            listHeading,
                            iteration.toString(),
                            sectionId,
                            componentType,
                            revNo,
                            txnTypeId,
                            fieldLabel,
                            "1");
                      }
                    }
                    dropdownclear();
                    lstmd = ListModel(listid, iteration.toString(), sectionId,
                        dropDownvalue, textControllerValue);
                    listAddedFunction(lstmd);
                    if (addbtnclicked == false) {
                      if (componentidvalue.length > 0) {
                        dropdownclear();
                      }
                    }

                    for (int i = 0; i < iterationList.length; i++) {
                      print("iterationListLabel" + iterationList[i].Label);
                      print("iterationlistlength" +
                          iterationList.length.toString());
                    }

                    var model =
                        new DynamicModel(iteration.toString(), Label, "1");

                    setState(() {
                      switch (listnumber) {
                        case 0:
                          dynamicList.add(model);
                          listnumber = listnumber + 1;
                          break;
                        case 1:
                          dynamicList2.add(model);
                          listnumber = listnumber + 1;
                          break;
                      }
                    });
                  } else {
                    errordialog(context, "Information", validation_message);
                  }
                } catch (ee) {}
              }));
          break;
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
                  'Submit',
                  style: new TextStyle(color: Colors.white, fontSize: 18),
                ),
                onPressed: () {
                  try {
                    void fieldValidation() {
                      try {
                        bool validationpending = false;
                        List<String> componentLabels = [];
                        int widgetscount = 0;
                        for (int c = 0;
                            c < dynamiccomponentFields.length;
                            c++) {
                          String componentLabel = dynamiccomponentFields[c]
                                  ["componentLabel"]
                              .toString();
                          String formulaDependency = dynamiccomponentFields[c]
                                  ["formulaDependency"]
                              .toString();
                          String componentType = dynamiccomponentFields[c]
                                  ["componentType"]
                              .toString();

                          String mandatory = dynamiccomponentFields[c]
                                  ["isMandatory"]
                              .toString();

                          if (componentLabel != "List" &&
                              componentLabel != "Add" &&
                              componentLabel != "Weather Info" &&
                              componentType != "8" &&
                              componentType != "2" &&
                              formulaDependency == "") {
                            if (mandatory == "1") {
                              widgetscount = widgetscount + 1;
                            }
                            componentLabels.add(componentLabel);
                          }
                        }
                        //int idscount = 0;

                        try {
                          for (int c = 0; c < componentidvalue.length; c++) {
                            if (componentidvalue[c].isMandatory == "1") {
                              idscount = idscount + 1;
                            }
                          }
                          for (int c = 0;
                              c < dynamiccomponentFields.length;
                              c++) {
                            String componentID = dynamiccomponentFields[c]
                                    ["componentID"]
                                .toString();
                            String componentLabel = dynamiccomponentFields[c]
                                    ["componentLabel"]
                                .toString();
                            if (componentLabel == "List") {
                            } else if (idscount < widgetscount) {
                              validationpending = true;
                              errordialog(context, "information11",
                                  "Mandatory Fields Should not be empty");
                              c = dynamiccomponentFields.length;
                            } else if (componentidvalue.length > 0) {
                              for (int k = 0;
                                  k < componentidvalue.length;
                                  k++) {
                                if (componentidvalue[k].componentid ==
                                    componentID) {
                                  if (componentidvalue[k].componentid == "") {
                                    validationpending = true;
                                    c = dynamiccomponentFields.length;
                                    k = componentidvalue.length;
                                    break;
                                  }
                                }
                              }
                            } else {
                              validationpending = true;
                              errordialog(context, "information22",
                                  componentLabel + " Should not be empty");
                              c = dynamiccomponentFields.length;
                            }
                          }
                          if (!validationpending) {
                            if (imageListField.length > 0) {
                              if (imageIdCount > imageWidgetCount ||
                                  imageIdCount == imageWidgetCount) {
                                alertMessage();
                              } else {
                                errordialog(context, "information33",
                                    "Mandatory field should not empty");
                              }
                            } else {
                              alertMessage();
                            }
                          }
                        } catch (e) {
                          errordialog(context, "information",
                              "Mandatory should not be empty");
                        }
                      } catch (ee) {}
                    }

                    void listValidation() {
                      if (int.parse(ListCount) > 0) {
                        bool validation = true;
                        for (int k = 0; k < listcounts.length; k++) {
                          String listId = listcounts[k]['listId'];
                          String secName = listcounts[k]['secName'];
                          bool listfound = false;
                          for (int sw = 0; sw < iterationList.length; sw++) {
                            String LISTID = iterationList[sw].ListId;
                            if (LISTID == listId) {
                              listfound = true;
                            }
                          }
                          if (!listfound) {
                            if (validation) {
                              errordialog(context, "Information",
                                  secName + " cannot be empty");
                            }
                            validation = false;
                          }
                        }
                        if (validation) {
                          fieldValidation();
                        }
                      }
                    }

                    void listFieldMethod() {
                      if (int.parse(ListCount) > 0) {
                        listValidation();
                      } else {
                        fieldValidation();
                      }
                    }

                    void seasonValidation() {
                      if (slcSeason == null || slcSeason.length == 0) {
                        errordialog(context, "Information",
                            "Season should not be empty");
                      } else if (cropDropDown) {
                        if (slcCrop == null || slcCrop.length == 0) {
                          errordialog(context, "Information",
                              "Crop should not be empty");
                        } else {
                          listFieldMethod();
                        }
                      } else {
                        listFieldMethod();
                      }
                    }

                    void staticDropdownvalidation() {
                      print("valFarmer_valFarmer" + valFarmer);
                      if (valFarmer == null || valFarmer.length == 0) {
                        errordialog(context, "Information",
                            "Farmer should not be empty");
                      } else if (farmDropdown) {
                        if (slcFarm == null || slcFarm.length == 0) {
                          errordialog(context, "Information",
                              "Farm should not be empty");
                        } else {
                          seasonValidation();
                        }
                      } else {
                        seasonValidation();
                      }
                    }

                    if (groupDropDown == true) {
                      if (slcGroup == null || slcGroup.length == 0) {
                        errordialog(
                            context, "Informtion", "Group should not be empty");
                      } else if (entity != "3") {
                        if (slcVillage == null || slcVillage.length == 0) {
                          errordialog(context, "Informtion",
                              "Village should not be empty");
                        } else {
                          staticDropdownvalidation();
                        }
                      } else {
                        seasonValidation();
                      }
                    } else {
                      if (valVillage == null || valVillage.length == 0) {
                        errordialog(context, "Informtion",
                            "Village should not be empty");
                      } else {
                        staticDropdownvalidation();
                      }
                    }
                  } catch (e) {}
                  //
                },
                color: Colors.green,
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              padding: EdgeInsets.all(3),
              child: RaisedButton(
                child: Text(
                  'Cancel',
                  style: new TextStyle(color: Colors.white, fontSize: 18),
                ),
                onPressed: () {
                  _onBackPressed();
                },
                color: Colors.redAccent,
              ),
            ),
          ),
        ],
      ),
    ));

    return listings;
  }

  Widget Datatablereg(List<ListModel> iteration) {
    List<DataColumn> columns = [];
    List<DataRow> rows = [];

    columns.add(DataColumn(
        label: Text(
      'S No',
      style: TextStyle(color: Colors.green),
    )));

    columns.add(DataColumn(
        label: Text(
      'Details',
      style: TextStyle(color: Colors.green),
    )));

    columns.add(DataColumn(
        label: Text(
      'Edit',
      style: TextStyle(color: Colors.green),
    )));

    columns.add(DataColumn(
        label: Text(
      'Delete',
      style: TextStyle(color: Colors.green),
    )));

    for (int i = 0; i < iteration.length; i++) {
      List<DataCell> singlecell = [];
      //1
      int sno = i + 1;
      singlecell.add(DataCell(Text(
        sno.toString(),
        style: TextStyle(color: Colors.black87),
      )));

      //2
      singlecell.add(DataCell(Text(
        iteration[i].Label + "," + iteration[i].textContollerValue,
        style: TextStyle(color: Colors.black87),
      )));

      //TextEditingController controller = new TextEditingController();
      //controller.text = iteration[i].textContollerValue;
      //singlecell.add(DataCell(
      // TextFormField(
      // controller: controller,
      //keyboardType: TextInputType.number,
      //onFieldSubmitted: (valu) {
      singlecell.add(DataCell(InkWell(
        onTap: () {
          setState(() {
            print("iteration[i].Label" + iteration[i].Label);
            String labelStr = iteration[i].Label;
            String labelSt2 = iteration[i].textContollerValue;

            List<String> dataValue = labelSt2.split(",");

            for (int m = 0; m < selectedDataList.length; m++) {
              print("selectedDataList[3]" + selectedDataList[2].toString());
              setState(() {
                selectedDataList[m] = dataValue[m].toString();
              });
            }
            setState(() {
              //iteration[i].textContollerValue = valu;
              dropdownLoaded = false;
              editbutton = true;
              initvalues();
              iterationList.removeAt(i);
            });
            // }
          });
        },
        child: Icon(
          Icons.edit,
          color: Colors.green,
        ),
        //showEditIcon: true
      )));

      singlecell.add(DataCell(InkWell(
        onTap: () async {
          for (int i = 0; i < iterationList.length; i++) {
            String Section = iterationList[i].Section;
            String ListId = iterationList[i].ListId;
            String ITeration = iterationList[i].iTeration;
            db.deleteComponentFields(ListId, revNo, ITeration, Section);

            setState(() {
              //removing in UI
              iterationList.removeAt(i);
            });
            List<Map> fields = await db.RawQuery(
                "Select * from dynamicListValues where recNu =\'" +
                    revNo +
                    "\'");

            //}
          }
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

  void updateDynamicComponent(var compenentModel) {
    String position = compenentModel.Position;
    String componentid = compenentModel.componentid;
    String value = compenentModel.value;

    if (value == "" || value.length == 0) {
    } else if (value.length > 0) {
      bool found = false;
      for (int i = 0; i < componentidvalue.length; i++) {
        if (componentid == componentidvalue[i].componentid) {
          found = true;
          setState(() {
            componentidvalue[i].value = value;
          });
        }
      }
      if (!found) {
        setState(() {
          componentidvalue.add(compenentModel);
        });
      }
    }
  }

  void updateDynamicComponentImage(var ImageModel) {
    String position = ImageModel.Position;
    String componentid = ImageModel.componentid;
    String value = ImageModel.value;
    if (value == "") {
      print('updateDynamicComponent empty');
    } else {
      bool found = false;
      for (int i = 0; i < imageidvalue.length; i++) {
        if (componentid == imageidvalue[i].componentid) {
          found = true;
          setState(() {
            imageidvalue[i].value = value;
          });
        }
      }
      if (!found) {
        setState(() {
          imageidvalue.add(ImageModel);
          if (imageidvalue.length > 0) {
            for (int i = 0; i < imageidvalue.length; i++) {
              setState(() {
                imageIdCount = imageIdCount + 1;
              });
            }
          }
        });
      }
    }
  }

  Future<void> listAddedFunction(var lstmd) async {
    String Label = lstmd.Label;
    if (iterationList.length == 0) {
      print("type30");
      iterationList.add(lstmd);
    } else {
      print("type31");
      bool listexist = false;
      for (int i = 0; i < iterationList.length; i++) {
        if (iterationList[i].Label == Label) {
          listexist = true;
        }
      }
      if (listexist) {
        errordialog(context, "Information", "Already Exist");
      } else {
        print("type35");
        iterationList.add(lstmd);
      }
    }
  }

  Future<void> alertMessage() async {
    Alert(
      context: context,
      type: AlertType.info,
      title: "Confirm",
      desc: "Are you sure want to proceed ?",
      buttons: [
        DialogButton(
          child: Text(
            "Yes",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () {
            Navigator.pop(context);
            savedynamicData();
          },
          width: 120,
        ),
        DialogButton(
          child: Text(
            "No",
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

  Future<List> loaddropdownvalues(String code) async {
    var catcode = code.split('|');
    String qry = 'select * from animalCatalog where catalog_code =\'' +
        catcode[0] +
        '\'';

    List datalist = await db.RawQuery(qry);

    return datalist;
  }

  savedynamicData() async {
    final now = new DateTime.now();
    String txntime = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
    String msgNo = DateFormat('yyyyMMddHHmmss').format(now);

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? agentid = prefs.getString("agentId");
    String? agentToken = prefs.getString("agentToken");
    String insqry =
        'INSERT INTO "main"."txnHeader" ("isPrinted", "txnTime", "mode", "operType", "resentCount", "agentId", "agentToken", "msgNo", "servPointId", "txnRefId") VALUES ('
                '0, \'' +
            txntime +
            '\', '
                '\'02\', '
                '\'01\', '
                '\'0\', \'' +
            agentid! +
            '\',\' ' +
            agentToken! +
            '\',\' ' +
            msgNo +
            '\',\' ' +
            servicePointId.toString() +
            '\',\' ' +
            revNo +
            '\')';
    print('txnHeader ' + insqry);
    int succ = await db.RawInsert(insqry);
    print(succ);

    AppDatas datas = new AppDatas();
    int custTransaction = await db.saveCustTransaction(
        txntime, datas.txn_dynamic, revNo, '', txnTypeId, txnTypeName);
    print('custTransaction : ' + custTransaction.toString());

    String farmerId = entityBasedFarmerID;
    String farmId = "";
    String isSynched = "1";
    String season = seasoncode;
    String longitude = Lng;
    String latitude = Lat;
    String txnType = txnTypeId;
    String txnUniqueId = revNo;
    String txnDate = txntime;
    String txnTypeIdMaster = "500";
    String inspectionStatus = "";
    String converStatus = "";
    String corActPln = "";
    String menuEntity = entity;
    String dynseasonCode = valSeason;
    String inspectionDate = "";
    String scopeOpr = "";
    String inspectionType = "";
    String nameofInspect = "";
    String inspectorMblNo = "";
    String certTotalLnd = "";
    String certlandOrganic = "";
    String certTotalsite = "";
    String activityId = "";
    String startTime = "";
    String activityStatus = "";
    String reason = "";
    String lotcode = "";
    String component = "";
    String district = "";
    String upazila = "";
    String union = "";
    String ward = "";
    String village = "";
    String group = "";
    //String digitalSign = "";
    // String agentSign = "";
    // String teantId = datas.tenent;

    int SavemultiTenantParent = await db.SavemultiTenantParent(
        revNo,
        farmerId,
        farmId,
        ward,
        isSynched,
        season,
        longitude,
        latitude,
        txnType,
        txnUniqueId,
        txnDate,
        txnTypeIdMaster,
        inspectionStatus,
        converStatus,
        corActPln,
        menuEntity,
        dynseasonCode,
        inspectionDate,
        scopeOpr,
        inspectionType,
        nameofInspect,
        inspectorMblNo,
        certTotalLnd,
        certlandOrganic,
        certTotalsite,
        activityId,
        startTime,
        activityStatus,
        reason,
        lotcode,
        "",
        "");
    print(SavemultiTenantParent);
    for (int i = 0; i < componentidvalue.length; i++) {
      String FieldId = componentidvalue[i].componentid;
      String FieldVal = componentidvalue[i].componentLabelValue;
      String ComponentType = componentidvalue[i].ComponentType;
      int dynamicfieldSave = await db.SavedynamiccomponentFieldValues(
          FieldId, FieldVal, ComponentType, revNo, txnTypeId, "");
      print("dynamicfieldSave" + dynamicfieldSave.toString());
    }

    if (imageidvalue.length > 0) {
      for (int i = 0; i < imageidvalue.length; i++) {
        int iteration = i + 1;
        String FieldId = imageidvalue[i].componentid;
        String FieldVal = imageidvalue[i].value;
        String ComponentType = imageidvalue[i].ComponentType;
        String latitude = imageidvalue[i].lat;
        String longitude = imageidvalue[i].lat;
        String pcTime = imageidvalue[i].pcTime;
        String sectionid = imageidvalue[i].Section;
        String listid = imageidvalue[i].List;

        db.SavedynamiccomponentImage(
            FieldId,
            pcTime,
            FieldVal,
            latitude,
            longitude,
            "",
            iteration.toString(),
            listid,
            sectionid,
            "",
            txnTypeId,
            "",
            revNo);
        print("dynamicfieldSaveImage");
      }
    }

    int issync = await db.UpdateTableValue(
        'multiTenantParent', 'isSynched', '0', 'recNo', revNo);
    print(issync);
    int dynasync = await db.UpdateTableValue(
        'dynamicListValues', 'isSynched', '0', 'recNu', revNo);
    print(dynasync);

    Navigator.pop(context);
  }
}

class ComponentModel {
  String componentid;
  String value;
  String Position;
  String ComponentType;
  String Section;
  String isMandatory;
  String componentLabel;
  String componentLabelValue;
  String type;

  ComponentModel(
      this.componentid,
      this.value,
      this.Position,
      this.ComponentType,
      this.Section,
      this.isMandatory,
      this.componentLabel,
      this.componentLabelValue,
      this.type);
}

class MultipleRadioModel {
  String parentcomponentID;
  String componentID;
  int value;

  MultipleRadioModel(this.parentcomponentID, this.componentID, this.value);
}

class ImageModel {
  String componentid;
  String value;
  String Position;
  String ComponentType;
  String Section;
  String lat;
  String lon;
  String pcTime;
  String List;
  ImageModel(this.componentid, this.value, this.Position, this.ComponentType,
      this.Section, this.lat, this.lon, this.pcTime, this.List);
}

class MandatoryModel {
  String ComponentId, ComponentLabel;

  MandatoryModel(this.ComponentId, this.ComponentLabel);
}

class ListModel {
  String ListId;
  String iTeration;
  String Section;
  String Label;
  String textContollerValue;
  ListModel(this.ListId, this.iTeration, this.Section, this.Label,
      this.textContollerValue);
}

class ValidationModel {
  String ListId;
  String Section;
  String mandatory;
  String componentId;

  ValidationModel(this.ListId, this.Section, this.mandatory, this.componentId);
}

class sectionNameList {
  String sectionName;
  String sectionID;

  sectionNameList(this.sectionName, this.sectionID);
}

class WeatherInfoDynamic {
  String temp;
  String rain;
  String humidity;
  String windSpeed;

  WeatherInfoDynamic(this.temp, this.rain, this.humidity, this.windSpeed);
}

class LabelModel {
  String labelID;
  bool added;

  LabelModel(this.labelID, this.added);
}
