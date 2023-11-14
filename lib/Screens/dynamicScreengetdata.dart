import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:eval_ex/expression.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:signature/signature.dart';
import 'package:ucda/Database/Databasehelper.dart';
import 'package:ucda/Model/UIModel.dart';
import 'package:ucda/Model/dynamicfields.dart';
import 'package:ucda/Plugins/TxnExecutor.dart';
import 'package:ucda/ResponseModel/WeatherModel.dart';
import 'package:ucda/Utils/MandatoryDatas.dart';
import 'package:ucda/main.dart';

import 'DynamicScreen.dart';
import 'geoplottingaddfarm.dart';

class dynamicScreengetdata extends StatefulWidget {
  String? farmhect;
  String? MenuTxnId;
  String? MenuName;

  dynamicScreengetdata(String menuName, String menuId) {
    this.MenuTxnId = menuId;
    this.MenuName = menuName;
  }

  @override
  State<StatefulWidget> createState() {
    print('createState');
    return _dynamicScreengetdata();
  }
}

class _dynamicScreengetdata extends State<dynamicScreengetdata> {
  var db = DatabaseHelper();
  AppDatas appDatas = new AppDatas();
  String? dynamicTxnId;
  String? dynamicTxnName;
  String? mileVillageIn;
  String? mileVillageIn_str;
  String? mileFarmerIn;
  String? mileFarmerIn_str;
  String? mileFarmIn;
  String? mileFarmIn_str;
  String? mileSeasonIn;
  String? mileSeasonIn_str;

  List<Map>? dynamiccomponentMenus;
  List<UImodel> VillageListUIModelfarmile = [];
  List<UImodel> farmListUIModelfarmile = [];
  List<UImodel> FarmerMasterListUIModelmile = [];

  final List<DropdownMenuItem> villageitemsfarmermilestone = [],
      farmermasteritemsmile = [],
      farmermasteritemsfarmermilestone = [],
      farmfarmermilestone = [];

  List dropdownlistMaster = [];

  String slctVillage = "",
      slctSeason = "",
      val_Village = "",
      frmrcode = "",
      slctFarmermaster = "",
      val_Farmermaster = "",
      valseason = "",
      val_village = "";

  String? labelvaluedyn = '';

  List<UImodel> activityUIModel = [];
  List<DropdownMenuItem> activityDropdown = [];
  String entity = "", entityBasedFarmerID = "";

  bool farmerDropdown = true,
      farmDropdown = true,
      farmerDropdowndet = false,
      villageDropdown = true,
      farmerMultiSearchDropDown = false,
      groupDropDown = false,
      cropDropDown = false,
      villageMultiSearchDropDown = false;

  String txnTypeId = "";
  String txnTypeName = "";
  String season = "";
  String farSts = "";

  int imageWidgetCount = 0;
  int imageIdCount = 0;
  String imageMandatory = "";

  TextEditingController sexController = new TextEditingController();
  TextEditingController marstatusController = new TextEditingController();
  TextEditingController relationController = new TextEditingController();
  TextEditingController ageController = new TextEditingController();

  int idscount = 0;

  List cropvalList = [];

  List<Map> dynamiccomponentSection = [];
  List<Map> dynamiccomponentFields = [];
  List<Map> imageListField = [];
  List<ValidationModel> validationlist = [];
  List<ComponentModel> componentidvalueFarMile = [];
  List<ComponentModel> componentidvalue = [];
  List componentidvalue_Label = [];
  List dynamicDropValues = [];
  List dependencyDropdownValues = [];
  List<ListModel> iterationList = [];
  List<ListModel> dynamicListValues = [];

  String image1 = "";
  String image2 = "";
  String image3 = "";
  String dropdownValue = "";

  List<MultipleImageModel> multipleImageList = [];
  List<DropDownModel> DropdownList = [];
  List<CatalogModel> catalogList = [];
  List<DatesModel> DatesModelList = [];
  List<CheckboxModel> selectedCheckbox = [];

  List<UImodel> villageListUiModel = [];
  List<DropdownModel> villageDropdownl = [];
  bool villageLoaded = false;

  List multipleImageListString = [];

  String selectedItemDyn = "", valueItemDyn = "";

  String Lat = '0.0', Lng = '0.0';
  String ImageLng = '';
  String ImageLat = '';
  String pcTime = "";

  List<ImageModeldynamic> imageidvalue = [];

  String locationName = "Loading";
  String weather = "-";
  String currentTemperature = "0";

  List<WeatherInfoDynamic> weatherinfo = [];
  String revNo = '';
  var lstmd;
  List<DynamicModel> dynamicList = [];
  List<DynamicModel> dynamicList2 = [];
  List? listcounts = [];
  String? ListCount = '0';
  List<DateModel> Dates = [];
  List vrtyList = [];
  List prodList = [];
  List Glo_All_Pro_Grade = [];

  bool _value = false;
  int radioval = -1;
  List<MultipleRadioModel> multipleRadioList = [];

  String farmercode = '';
  var villagelists;
  String villageList = "";
  List<MutipleDropDownModel> selectedList = [];

  String slcFarmer = "",
      slcFarm = "",
      slcSeason = "",
      slcGroup = "",
      slcCrop = "",
      valDistrict = "",
      slcVillage = "",
      slcNursery = "";

  DropdownModel? slctUpazila;
  DropdownModel? slctUnion;
  DropdownModel? slctWard;
  DropdownModel? slcbenificiary;
  DropdownModel? slctComponent;
  DropdownModel? slcActivity;
  DropdownModel? selectedGroup;
  DropdownModel? slctDistrict;
  DropdownModel? selectedVillage;
  DropdownModel? selectedFarmer;
  DropdownModel? selectedFarm;
  DropdownModel? selectedSeason;
  DropdownModel? selectedCrop;
  DropdownModel? selectedVariety;
  DropdownModel? selectedNursery;

  String valUpazila = "";
  String valUnion = "";
  String valWard = "";
  String valbenificiary = "";
  bool signdynClicked = false;
  ByteData _img = ByteData(0);
  String encoded = "";

  Uint8List? signImg;

  final SignatureController _sign = SignatureController(
    penStrokeWidth: 2,
    penColor: Colors.black,
  );

  List<DropdownModelClass> multiSearchFarmerList = [];
  List<DropdownModelClass> multiSearchVillageList = [];
  List<DropdownModelClass> multiVillageItems = [];
  List<DropdownModelClass> multiFarmeritems = [];

  List<UImodel> villageUiModel = [];
  List<UImodel2> farmerUiModel = [];
  List<UImodel> farmUiModel = [];
  List<UImodel> seasonUiModel = [];
  List<UImodel> cropUiModel = [];
  List<UImodel> groupUiModel = [];
  List<UImodel> vrtyUiModel = [];
  List<UImodel> districtListUiModel = [];
  List<UImodel> upazilaListUiModel = [];
  List<UImodel> unionListUiModel = [];
  List<UImodel> wardListUiModel = [];
  List<UImodel2> nurseryUIModel = [];

  List<DropdownModel> districtDropDownItem = [];
  List<DropdownModel> upazilaDropDownItem = [];
  List<DropdownModel> unionDropDownItem = [];
  List<DropdownModel> wardDropDownItem = [];
  List<DropdownModel> groupItems = [];
  List<DropdownModel> farmItems = [];
  List<DropdownModel> seasonItems = [];
  List<DropdownModel> vrtyItems = [];
  List<DropdownModel> cropItems = [];
  List<DropdownModel> villageItems = [];
  List<DropdownModel> farmerItems = [];
  List<DropdownModel> nurseryItems = [];

  String valVillage = "",
      valFarmer = "",
      valFarm = "",
      valSeason = "",
      valGroup = "",
      valCrop = "",
      valComponent = "",
      valActivity = "",
      valNursery = "";

  bool distLoaded = false,
      upazLoaded = false,
      unionLoaded = false,
      wardLoaded = false,
      farmerLoaded = false,
      farmLoaded = false,
      nurseryLoaded = false;
  String loading = 'Loading...';

  List<UImodel> componentListUiModel = [];
  List<UImodel> activityListUiModel = [];
  List<UImodel> beneficiaryUIModel = [];
  List<DropdownModel> componentDropDownItem = [];
  List<DropdownModel> activityDropDownItem = [];
  List<DropdownModel> beneficiaryDropdown = [];

  List<Map> agents = [];
  String seasoncode = "";
  String servicePointId = "";
  String agentDistributionBal = '';
  String agentType = "";
  String agendId = "";
  String agentDistrictCode = "";

  TextEditingController househeadController = new TextEditingController();
  TextEditingController hhidController = new TextEditingController();
  TextEditingController mobilenoController = new TextEditingController();
  TextEditingController totmalelessController = new TextEditingController();
  TextEditingController totmalegreaterController = new TextEditingController();
  TextEditingController totfemalelessController = new TextEditingController();
  TextEditingController totfemalegreaterController =
      new TextEditingController();
  TextEditingController totdisableController = new TextEditingController();
  TextEditingController totmemberController = new TextEditingController();
  TextEditingController latitudeController = new TextEditingController();
  TextEditingController landsizeController = new TextEditingController();
  TextEditingController longtitudeController = new TextEditingController();

  String temp = "0";
  String rain = "0";
  String humidity = "0";
  String speed = "0";

  String reDate = "", reDateFormated = "";

  List<DropdownModel> vacCat = [];
  DropdownModel? slctvacCat;
  List<UImodel> vacCatUIModel = [];
  String slct_vacCat = "", val_vacCat = "";

  List<DropdownModel> regStat = [];
  DropdownModel? slctregStat;
  List<UImodel> regStatUIModel = [];
  String slct_regStat = "", val_regStat = "";

  List<DropdownModel> chainAct = [];
  DropdownModel? slctChainAct;
  List<UImodel2> chainActUIModel = [];
  String slct_chainAct = "", val_chainAct = "";
  TextEditingController vacController = new TextEditingController();
  bool inspection = false;

  List<DropdownModelClass> multivcaitems = [];
  List<DropdownModelClass> multiSearchvcaitems = [];

  List<DropdownModel> vcaDataList = [];
  DropdownModel? slctvcaData;
  List<UImodel2> vcaDataUIModel = [];
  String slct_vca = "", val_vca = "";

  bool vcabool = false;
  TextEditingController rmNumberController = new TextEditingController();

  //district
  List<DropdownModel> districtItem = [];
  DropdownModel? slctDistrictItem;
  String slct_District = "";
  String val_District = "";

  //subcounty/division
  List<DropdownModel> subCountyItem = [];
  DropdownModel? slctSubCounty;
  String slct_SubCounty = "";
  String val_SubCounty = "";

  //parish/ward
  List<DropdownModel> parishItem = [];
  DropdownModel? slctParish;
  String slct_Parish = "";
  String val_Parish = "";

  String vcaName = "";
  String value1 = "";

  TextEditingController genderController = new TextEditingController();
  TextEditingController addressController = new TextEditingController();
  TextEditingController emailController = new TextEditingController();

  String isSurvey = "";

  bool vcaSurveyLoaded = false;
  String catName = "";
  String farName = "";
  String dName = "";

  String recordNo = "";

  /*26/06/2023*/
  List<DropdownModelClass> multiDistrictItems = [];
  List<DropdownModelClass> multiSubCountyItems = [];
  List<DropdownModelClass> multiParishItems = [];

  List<DropdownModelClass> multiSearchDistrictList = [];
  List<DropdownModelClass> multiSearchSubCountyList = [];
  List<DropdownModelClass> multiSearchParishList = [];

  String valDist = '';
  String valSubCounty = '';
  String valParish = '';

  String nameDistrict = '';
  String nameSubCounty = '';
  String nameParish = '';
  String nameVillage = '';
  String region = "";
  DropdownModel? selectedItem;

  TextEditingController? controller9 = TextEditingController();

  @override
  void initState() {
    print("initState_dynamicScreengetdata");
    super.initState();
    getLocation();
    initWeather();
    Random rnd = new Random();
    int recNo = 100000 + rnd.nextInt(999999 - 100000);
    revNo = recNo.toString();

    dynamicTxnId = widget.MenuTxnId;
    dynamicTxnName = widget.MenuName;
    /*mileVillageIn = widget.mileVillage;
    mileVillageIn_str = widget.mileVillage_str;
    mileFarmerIn = widget.mileFarmer;
    mileFarmerIn_str = widget.mileFarmer_str;
    mileFarmIn = widget.mileFarm;
    mileFarmIn_str = widget.mileFarm_str;
    mileSeasonIn = widget.mileSeason;
    mileSeasonIn_str = widget.mileSeason_str;*/

    print("dynamicTxnId:  " + dynamicTxnId!);
    print("dynamicTxnName:  " + dynamicTxnName!);
    if (dynamicTxnId == "2026" || dynamicTxnId == "2027") {
      loadTrainingData();
    }

    /*Future.delayed(Duration(milliseconds: 15), () {
      setState(() {

      });
    });*/
    initvaluesDynamic();
    DropdownLoad();
    getClientData();
    Group();
    seasonSearch();
    loadDistrict();
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
    latitudeController =
        TextEditingController(text: position.latitude.toString());
    longtitudeController =
        TextEditingController(text: position.longitude.toString());
  }

  Future<void> initWeather() async {
    var response = await Dio().get(
        "http://api.openweathermap.org/data/2.5/forecast/daily?mode=json&cnt=8&appid=818dd2fdbfd1288c75a46100e6f450cb&lat=$Lat&lon=$Lng");

    Map<String, dynamic> json = jsonDecode(response.toString());
    WeatherModel weatherdata = WeatherModel.fromJson(json);
    locationName = weatherdata.city!.name;
    weather = weatherdata.list![0].weather![0].main;
    currentTemperature =
        ChangeDecimalTwo((weatherdata.list![0].temp!.day - 273.15).toString());

    setState(() {
      temp = ChangeDecimalTwo(
          (weatherdata.list![0].temp!.day - 273.15).toString());
      rain = weatherdata.list![0].rain.toString();
      humidity = weatherdata.list![0].humidity.toString();
      speed = weatherdata.list![0].speed.toString();
      if (rain == "null") {
        rain = "0";
      }
    });
  }

  loadTrainingData() async {
    String trainingQry = "";
    if (dynamicTxnId == "2026") {
      trainingQry =
          'select * from trainingDraftTable where txnId = \'' + "2026" + '\' ';
    } else {
      trainingQry =
          'select * from trainingDraftTable where txnId = \'' + "2027" + '\' ';
    }

    List trainingList = await db.RawQuery(trainingQry);
    print("trainingList:" + trainingList.toString());

    for (int t = 0; t < trainingList.length; t++) {
      String text = trainingList[t]['compVal'];
      String multipleComponentVal = text;
      List<String> multiComponent = [];
      List<String> multiComponentList = [];
      List<String> multiComponentL = multipleComponentVal.split(',').toList();
      String multiDependent = "";
      for (int k = 0; k < multiComponentL.length; k++) {
        multiDependent = multiComponentL[k].toString();
        print("multidependent:" + multiDependent);
        List catMultiList = await db.RawQuery(
            'select * from animalCatalog where DISP_SEQ= \'' +
                multiDependent +
                '\'');

        for (int l = 0; l < catMultiList.length; l++) {
          String cName = catMultiList[l]['property_value'].toString();
          print("cName:" + cName);
          multiComponentList.add("'$cName'");
          multiComponent.add(cName);
        }
      }
      String componentID = trainingList[t]['componentId'];
      String componentType = trainingList[t]['compType'];
      print("componentTypeValue" + componentType);
      String sectionId = trainingList[t]['sectionId'];
      String isMandatory = trainingList[t]['isMandatory'];
      String componentLabel = trainingList[t]['componentLabel'];
      String parentField = trainingList[t]['parentField'];
      String dependencyField = trainingList[t]['dependencyField'];
      String parentDependency = trainingList[t]['parentDependency'];
      String iflistFld = trainingList[t]['ifListFld'];
      String districtCode = trainingList[t]['districtCode'];
      String districtName = trainingList[t]['districtName'];
      String subCountyCode = trainingList[t]['subCountyCode'];
      String subCountyName = trainingList[t]['subCountyName'];
      String parishCode = trainingList[t]['parishCode'];
      String parishName = trainingList[t]['parishName'];
      String villageName = trainingList[t]['villageName'];
      String villageId = trainingList[t]['village'];
      String farmerName = trainingList[t]['farmerName'];
      String farmerId = trainingList[t]['farmerId'];
      String date = trainingList[t]['date'];
      recordNo = trainingList[t]['RecNo'];

      setState(() {
        dName = districtName;
        valDist = districtCode;
        nameDistrict = districtName;
        valSubCounty = subCountyCode;
        nameSubCounty = subCountyName;
        valParish = parishCode;
        nameParish = parishName;
        nameVillage = villageName;
        valVillage = villageId;
        farName = farmerName;
        valFarmer = farmerId;
        val_chainAct = farmerId;
        slct_chainAct = farmerName;
        reDate = date;
        if (txnTypeId == "2027") {
          valChainAction("", valVillage);
        } else {
          farmersearch2(valVillage);
        }
      });

      String catNameQry =
          'select * from animalCatalog where DISP_SEQ = \'' + text + '\'';

      List catList = await db.RawQuery(catNameQry);
      print("catlist:" + catList.toString());
      for (int j = 0; j < catList.length; j++) {
        catName = catList[j]['property_value'].toString();
      }

      switch (componentType) {
        case "4":
          setState(() {
            var compModel = ComponentModel(
                componentID,
                text,
                t.toString(),
                componentType,
                sectionId,
                isMandatory,
                componentLabel,
                catName,
                "4",
                parentField,
                dependencyField,
                parentDependency,
                iflistFld,
                catName);
            updateDynamicComponentDynamic(compModel);
          });

          break;
        case "5":
          setState(() {
            var compenentModel = ComponentModel(
                componentID,
                text,
                t.toString(),
                componentType,
                sectionId,
                isMandatory,
                componentLabel,
                text,
                componentType,
                parentField,
                dependencyField,
                parentDependency,
                iflistFld,
                "");
            updateDynamicComponentDynamic(compenentModel);
          });
          break;

        case "9":
          setState(() {
            var compenentModel = new ComponentModel(
                componentID,
                text,
                t.toString(),
                componentType,
                sectionId,
                isMandatory,
                componentLabel,
                text,
                "9",
                parentField,
                dependencyField,
                parentDependency,
                iflistFld,
                "");
            List<String> dyList = [];
            dyList.add(text);
            selectedList.add(MutipleDropDownModel(
                componentID, componentLabel, multiComponent));
            updateDynamicComponentDynamic(compenentModel);
          });
          break;

        case "1":
          setState(() {
            componentidvalue = takeNumber(
                text,
                componentID,
                t.toString(),
                componentType,
                sectionId,
                isMandatory,
                componentLabel,
                "1",
                componentidvalue,
                componentidvalue_Label,
                parentField,
                dependencyField,
                parentDependency,
                iflistFld);
          });
          break;
      }
    }
    String trainingImageQry = "";
    if (dynamicTxnId == "2026") {
      trainingImageQry =
          'select * from trainingImageDraft where txnTypeId = \'' +
              "2026" +
              '\' ';
    } else {
      trainingImageQry =
          'select * from trainingImageDraft where txnTypeId = \'' +
              "2027" +
              '\' ';
    }

    List trainingImageList = await db.RawQuery(trainingImageQry);
    print("trainingImageList:" + trainingImageList.toString());

    for (int i = 0; i < trainingImageList.length; i++) {
      String componentType = "12";
      String imageUrl = trainingImageList[i]['imageUrl'];
      String sectionId = trainingImageList[i]['sectionId'];
      String imageLat = trainingImageList[i]['imageLat'];
      String imageLon = trainingImageList[i]['imageLon'];
      String componentId = trainingImageList[i]['glo_popupId'];
      String txnTypeId = trainingImageList[i]['txnTypeId'];
      String imageTime = trainingImageList[i]['imageTime'];
      String position = trainingImageList[i]['listIteration'];
      String caExist = trainingImageList[i]['cameraExist'];
      bool cameExist = true;
      if (caExist == "0") {
        cameExist = true;
      } else {
        cameExist = false;
      }

      switch (componentType) {
        case "12":
          setState(() {
            File _beneficiaryimage = File(imageUrl);
            multipleImageList.add(MultipleImageModel(
                componentType,
                componentId,
                _beneficiaryimage,
                sectionId,
                imageLat,
                imageLon,
                imageTime,
                "0",
                0,
                cameExist));
            print("multipleimagelistcase12:" +
                multipleImageList.length.toString());
            var imageModeldyn = new ImageModeldynamic(componentId, position,
                componentType, sectionId, imageLat, imageLon, imageTime, "N");
            imageidvalue.add(imageModeldyn);
            updateDynamicComponentImageNew(imageModeldyn, multipleImageList);
          });
          break;
      }
    }

    String iterList = "";
    String iList = "";

    if (dynamicTxnId == "2026") {
      iterList = 'select * from dynamicListValues where txnTypeId = \'' +
          "2026" +
          '\'';
      iList = ' select * from listPartial';
    } else {
      iterList = 'select * from dynamicListValues where txnTypeId = \'' +
          "2027" +
          '\' ';
      iList = ' select * from listPartial';
    }

    List trainList = await db.RawQuery(iterList);
    print("trainList:" + trainList.toString());

    List itList = await db.RawQuery(iList);

    print("partiallist:" + itList.toString());

    String sectionId = "";
    for (int l = 0; l < trainList.length; l++) {
      String fieldId = trainList[l]['fieldId'];
      String fieldValue = trainList[l]['fieldValue'];
      String fieldLabel = trainList[l]['fieldLabel'];
      String listID = trainList[l]['listID'];
      String listItration = trainList[l]['listItration'];
      sectionId = trainList[l]['sectionId'];
      String componentType = trainList[l]['componentType'];
      String recNu = trainList[l]['recNu'];
      String txnTypeId = trainList[l]['txnTypeId'];
      String componentValue = trainList[l]['componentValueText'];
      String txtControllerValue = trainList[l]['blockId'];
      print("trainlistfieldid:" + fieldValue);
    }

    String lId = "";
    String iteration = "";
    String sction = "";
    String lbl = "";
    String txtController = "";
    for (int r = 0; r < itList.length; r++) {
      lId = itList[r]['listId'];
      iteration = itList[r]['iteration'];
      sction = itList[r]['section'];
      lbl = itList[r]['label'];
      txtController = itList[r]['textControllerValue'];

      setState(() {
        //print("listidvalue2:"+listid);
        lstmd = ListModel(lId, iteration, sction, "", txtController);
        listAddedFunction(lstmd);
        List<Widget> listings = [];
        listings = _getDynamicScreenWidget(context, listings);
        switch ("8") {
          case "8": //label
            print("iterationList case8 " + iterationList.length.toString());
            if (iterationList.length > 0) {
              dynamicListValues = [];
              for (int s = 0; s < iterationList.length; s++) {
                print("sectionId case8 " + sectionId);
                print("iterationList[s].Section case8 " +
                    iterationList[s].Section);
                if (sectionId == iterationList[s].Section) {
                  dynamicListValues.add(iterationList[s]);
                }
              }
              if (dynamicListValues.length > 0) {
                // listings.add(addDynamic(
                //     productlist: dynamicListValues, title: componentLabel));
                listings.add(Datatablereg(sectionId));
              }
            }
            break;
        }
      });
    }
  }

  Future<void> Village(String Parish) async {
    String qry_villagelist = ''; //'select * from villageList';

    String districtCodeQ = '';

    //load district based on agent mapping
    String stateCodeValue = agentDistrictCode;
    List districtCodeList = [];
    List districtCodeQList = [];
    List<String> stateCodeL = stateCodeValue.split(',').toList();
    print("stateCodeL:" + stateCodeL.length.toString());
    String stateCode = "";
    for (int j = 0; j < stateCodeL.length; j++) {
      stateCode = stateCodeL[j].toString();
      districtCodeQList.add("'$stateCode'");
      print("stateCodeValue:" + stateCode);
    }
    districtCodeQ = districtCodeQList.join(',');
    print("districtCodeVal:" + districtCodeQ);

    if (entity == "9") {
      qry_villagelist =
          'Select distinct v.villCode,v.villName from  villageList as v inner join vcaRegListData as vca on vca.vilCode =v.villCode inner join cityList as c on c.cityCode = v.gpCode inner join districtList as d on d.districtCode = c.districtCode where v.gpCode = \'' +
              Parish +
              '\' ';
    } else if (entity == "11" || entity == "10") {
      qry_villagelist =
          'Select distinct v.villCode,v.villName from villageList as v inner join vcaData as vca on vca.vilCode =v.villCode inner join cityList as c on c.cityCode = v.gpCode inner join districtList as d on d.districtCode = c.districtCode where v.gpCode = \'' +
              Parish +
              '\'';
    } else if (entity == "12") {
      qry_villagelist =
          'Select distinct v.villCode,v.villName from  villageList as v  inner join cityList as c on c.cityCode = v.gpCode inner join districtList as d on d.districtCode = c.districtCode where v.gpCode = \'' +
              Parish +
              '\' ';
    } else if (entity == "8") {
      qry_villagelist =
          'Select distinct v.villCode,v.villName from  villageList as v inner join nurseryReg as vca on vca.village =v.villCode inner join cityList as c on c.cityCode = v.gpCode inner join districtList as d on d.districtCode = c.districtCode where v.gpCode = \'' +
              Parish +
              '\' ';
    } else {
      qry_villagelist =
          'Select distinct v.villCode,v.villName from villageList as v inner join farmer_master as f on f.villageId =v.villCode inner join cityList as c on c.cityCode = v.gpCode inner join districtList as d on d.districtCode = c.districtCode where v.gpCode = \'' +
              Parish +
              '\'';
    }
    print('Txn_entity ' + entity);
    print('qry_villagelist ' +
        qry_villagelist +
        " " +
        'Select distinct v.villCode,v.villName from villageList as v inner join vcaRegListData as vca on vca.vilCode =v.villCode inner join cityList as c on c.cityCode = v.gpCode inner join districtList as d on d.districtCode = c.districtCode where v.gpCode = "M00012"');
    List villageslist = await db.RawQuery(qry_villagelist);
    villageItems = [];
    villageItems.clear();
    villageUiModel = [];
    multiVillageItems.clear();

    for (int i = 0; i < villageslist.length; i++) {
      String property_value = villageslist[i]["villName"].toString();
      String DISP_SEQ = villageslist[i]["villCode"].toString();
      var uimodel = new UImodel(property_value, DISP_SEQ);
      villageUiModel.add(uimodel);
      setState(() {
        villageItems.add(DropdownModel(property_value, DISP_SEQ));
      });
      setState(() {
        multiVillageItems.add(DropdownModelClass(property_value, DISP_SEQ));
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
        'select farmerId,fName,lName,farmerCode,mobileNo,address,Inspection,farmerIndicator from farmer_master where villageId = \'' +
            VillageId +
            '\' and blockId = "0"';
    List farmerslist = await db.RawQuery(qry_farmerlist);

    farmerItems = [];
    farmerUiModel.clear();
    farmerUiModel = [];
    for (int i = 0; i < farmerslist.length; i++) {
      String property_value = farmerslist[i]["fName"].toString() +
          " " +
          farmerslist[i]["lName"].toString();
      String DISP_SEQ = farmerslist[i]["farmerId"].toString();
      farmercode = farmerslist[i]["farmerCode"].toString();
      String mobNo = farmerslist[i]["mobileNo"].toString();
      String address = farmerslist[i]["address"].toString();
      String genderCode = farmerslist[i]["Inspection"].toString();
      String email = farmerslist[i]["farmerIndicator"].toString();

      print("gender code:" + genderCode);
      String genderName = "";
      if (genderCode == "1") {
        genderName = "Male";
      } else if (genderCode == "0") {
        genderName = "Female";
      }

      var uimodel = UImodel2(property_value + "-" + farmercode, DISP_SEQ, mobNo,
          address, genderName, email);
      farmerUiModel.add(uimodel);
      setState(() {
        farmerItems.add(DropdownModel(
          property_value + "-" + farmercode,
          DISP_SEQ,
        ));
      });

      Future.delayed(Duration(milliseconds: 500), () {
        setState(() {
          if (farmerItems.isNotEmpty) {
            farmerLoaded = true;
            slcFarmer = '';
          }
        });
      });
    }
  }

  farmersearch2(String VillageId) async {
    villageList = VillageId;

    List typVillList = [];
    List typVillageList = [];
    List<String> typVillaList = villageList.split(',').toList();
    print("subcountylistval:" + typVillaList.toString());

    for (int k = 0; k < typVillaList.length; k++) {
      String t = typVillaList[k].toString();
      typVillageList.add("'$t'");
      typVillList.add(t);
    }
    String cCodeV = typVillageList.join(',');
    print("cCode:" + cCodeV);
    String qry_farmerlist = "";

    qry_farmerlist =
        'select farmerId,farmerCode,fName,lName as name,mobileNo from farmer_master  where villageId IN (' +
            cCodeV +
            ') and blockId = "0"';
    List farmerslist = await db.RawQuery(qry_farmerlist);
    print("trainqry " + farmerslist.toString());

    farmerUiModel.clear();
    multiFarmeritems = [];
    farmerUiModel = [];
    for (int i = 0; i < farmerslist.length; i++) {
      String property_value = farmerslist[i]["fName"].toString() +
          " " +
          farmerslist[i]['name'].toString();
      String DISP_SEQ = farmerslist[i]["farmerId"].toString();
      farmercode = farmerslist[i]["farmerCode"].toString();
      String mobNo = farmerslist[i]["mobileNo"].toString();
      var uimodel = UImodel2(
          property_value + "-" + farmercode, DISP_SEQ, mobNo, "", "", "");
      farmerUiModel.add(uimodel);
      setState(() {
        multiFarmeritems.add(
            DropdownModelClass(property_value + '-' + farmercode, DISP_SEQ));
      });

      Future.delayed(Duration(milliseconds: 500), () {
        setState(() {
          if (multiFarmeritems.length > 0) {
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
            '\' and verifyStatus = "0"';
    print("qry_farm_qry_farm " + qry_farm.toString());
    List farmlist = await db.RawQuery(qry_farm);

    farmItems = [];
    farmItems.clear();
    farmUiModel = [];

    if (farmlist.length > 0) {
      for (int i = 0; i < farmlist.length; i++) {
        String DISP_SEQ = farmlist[i]["farmIDT"].toString();
        String property_value = farmlist[i]["farmName"].toString();
        String farmtotarea = farmlist[i]["farmArea"].toString();

        var uimodel =
            new UImodel(property_value /*+ "-" + farmtotarea*/, DISP_SEQ);
        farmUiModel.add(uimodel);
        setState(() {
          farmItems.add(DropdownModel(
            property_value /*+ "-" + farmtotarea*/,
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

  /*load district based on country*/
  Future<void> loadDistrict() async {
    List statelist = await db.RawQuery('select cityCode from agentMaster');

    districtItem.clear();
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
          setState(() {
            districtItem.add(DropdownModel(
              stateName,
              stateCode,
            ));

            multiDistrictItems.add(DropdownModelClass(stateName, stateCode));
          });
        }
      }

      Future.delayed(Duration(milliseconds: 500), () {
        print("State_delayfunction" + stateName);
        setState(() {
          if (statelist.isNotEmpty) {
            slct_District = "";
            distLoaded = true;
          }
        });
      });
    }
  }

  /*load subcounty based on district*/
  Future<void> loadSubCounty(String stateCode) async {
    //districtlist
    List districtlist = [];

    districtlist = await db.RawQuery(
        'select * from districtList where stateCode =\'' + stateCode + '\'');

    print('districtlist_farmerEnrollment' + districtlist.toString());
    subCountyItem.clear();
    for (int i = 0; i < districtlist.length; i++) {
      String stateCode = districtlist[i]["stateCode"].toString();
      String districtName = districtlist[i]["districtName"].toString();
      String districtCode = districtlist[i]["districtCode"].toString();

      var uimodel = UImodel(districtName, districtCode);

      setState(() {
        subCountyItem.add(DropdownModel(
          districtName,
          districtCode,
        ));
        multiSubCountyItems.add(DropdownModelClass(districtName, districtCode));
      });

      Future.delayed(Duration(milliseconds: 500), () {
        print("district_delayfunction" + districtName);
        setState(() {
          // if (districtlist.isNotEmpty) {
          //   districtLoaded = true;
          //   slctDistrict = "";
          // }
        });
      });
    }
  }

  loadSubCounty2(String stateCode) async {
    villageList = stateCode;

    List typVillList = [];
    List typVillageList = [];
    List<String> typVillaList = villageList.split(',').toList();
    print("subcountylistval:" + typVillaList.toString());

    for (int k = 0; k < typVillaList.length; k++) {
      String t = typVillaList[k].toString();
      typVillageList.add("'$t'");
      typVillList.add(t);
    }
    String cCodeV = typVillageList.join(',');
    print("cCode:" + cCodeV);

    String qry_farmerlist = "";

    qry_farmerlist =
        'select distinct districtName,districtCode from districtList  where stateCode IN (' +
            cCodeV +
            ')';

    List subcountyList = await db.RawQuery(qry_farmerlist);
    print("trainqry " + subcountyList.toString());

    multiSubCountyItems.clear();

    for (int i = 0; i < subcountyList.length; i++) {
      String districtName = subcountyList[i]["districtName"].toString();
      String districtCode = subcountyList[i]["districtCode"].toString();

      setState(() {
        multiSubCountyItems.add(DropdownModelClass(districtName, districtCode));
      });

      Future.delayed(Duration(milliseconds: 500), () {
        setState(() {});
      });
    }
  }

  /*load parish based on subcounty*/
  Future<void> loadParish(String districtCode) async {
    //cityList
    List cityList = await db.RawQuery(
        'select * from cityList where districtCode =\'' + districtCode + '\'');
    print('cityList_farmerEnrollment' + cityList.toString());
    parishItem.clear();
    for (int i = 0; i < cityList.length; i++) {
      String cityName = cityList[i]["cityName"].toString();
      String cityCode = cityList[i]["cityCode"].toString();

      var uimodel = UImodel(cityName, cityCode);

      setState(() {
        parishItem.add(DropdownModel(
          cityName,
          cityCode,
        ));
      });

      Future.delayed(const Duration(milliseconds: 500), () {
        print("functioncity_delay" + cityName);
        setState(() {
          // if (cityList.isNotEmpty) {
          //   cityLoaded = true;
          //   slctTaluk = "";
          // }
        });
      });
    }
  }

  loadParish2(String subCounty) async {
    villageList = subCounty;

    List typVillList = [];
    List typVillageList = [];
    List<String> typVillaList = villageList.split(',').toList();
    print("subcountylistval:" + typVillaList.toString());

    for (int k = 0; k < typVillaList.length; k++) {
      String t = typVillaList[k].toString();
      typVillageList.add("'$t'");
      typVillList.add(t);
    }
    String cCodeV = typVillageList.join(',');
    print("cCode:" + cCodeV);

    String qry_farmerlist = "";

    qry_farmerlist =
        'select distinct cityName,cityCode from cityList  where districtCode IN (' +
            cCodeV +
            ')';

    List cityList = await db.RawQuery(qry_farmerlist);
    print("trainqry " + cityList.toString());

    multiParishItems.clear();

    for (int i = 0; i < cityList.length; i++) {
      String cityName = cityList[i]["cityName"].toString();
      String cityCode = cityList[i]["cityCode"].toString();

      setState(() {
        multiParishItems.add(DropdownModelClass(cityName, cityCode));
      });

      Future.delayed(Duration(milliseconds: 500), () {
        setState(() {});
      });
    }
  }

  loadVillage2(String parish) async {
    villageList = parish;

    List typVillList = [];
    List typVillageList = [];
    List<String> typVillaList = villageList.split(',').toList();
    print("subcountylistval:" + typVillaList.toString());

    for (int k = 0; k < typVillaList.length; k++) {
      String t = typVillaList[k].toString();
      typVillageList.add("'$t'");
      typVillList.add(t);
    }
    String cCodeV = typVillageList.join(',');
    print("cCode:" + cCodeV);

    String qry_farmerlist = "";

    qry_farmerlist =
        'Select distinct villCode,villName from  villageList  where gpCode IN (' +
            cCodeV +
            ')';

    List villageslist = await db.RawQuery(qry_farmerlist);
    print("trainqry " + villageslist.toString());

    multiVillageItems.clear();

    for (int i = 0; i < villageslist.length; i++) {
      String property_value = villageslist[i]["villName"].toString();
      String DISP_SEQ = villageslist[i]["villCode"].toString();

      setState(() {
        multiVillageItems.add(DropdownModelClass(property_value, DISP_SEQ));
      });

      Future.delayed(Duration(milliseconds: 500), () {
        setState(() {});
      });
    }
  }

  Future<void> valChainAction(String catCode, String villCode) async {
    print('catCode ' + catCode + ' villCode ' + villCode);

    List typVillList = [];
    List typVillageList = [];
    List<String> typVillaList = villCode.split(',').toList();
    print("subcountylistval:" + typVillaList.toString());

    for (int k = 0; k < typVillaList.length; k++) {
      String t = typVillaList[k].toString();
      typVillageList.add("'$t'");
      typVillList.add(t);
    }
    String cCodeV = typVillageList.join(',');
    print("cCode:" + cCodeV);

    String qry = '';
    if (entity == '12') {
      print("catCodeV" + catCode);
      qry = 'select * from vcaRegListData where vilCode =\'' +
          villCode +
          '\' and actCat = \'' +
          catCode +
          '\'';
    } else if (entity == '9') {
      qry = 'select * from vcaRegListData where vilCode  IN (' + cCodeV + ')';
    }
    print('valChainAction_qry:' + qry);
    List ValChainAction = await db.RawQuery(qry);
    print('ValChainActionList: ' + ValChainAction.toString());
    chainAct = [];
    chainActUIModel = [];
    multivcaitems = [];
    for (int i = 0; i < ValChainAction.length; i++) {
      String vacName = ValChainAction[i]["applicantName"].toString();
      String vacCode = ValChainAction[i]["vId"].toString();
      String email = ValChainAction[i]['email'].toString();
      String address = ValChainAction[i]['address'].toString();
      String mobileNo = ValChainAction[i]['phoneNo'].toString();
      var uimodel =
          new UImodel2(vacName, vacCode, email, address, mobileNo, "");
      chainActUIModel.add(uimodel);
      setState(() {
        chainAct.add(DropdownModel(vacName, vacCode));
        multivcaitems.add(DropdownModelClass(vacName, vacCode));
      });
    }
  }

  Future<void> nurseryReg(String villCode) async {
    String qry = "";

    if (entity == '8') {
      qry = 'select * from nurseryReg where village =\'' + villCode + '\' ';
    }
    print('nurseryReg:' + qry);
    List ValChainAction = await db.RawQuery(qry);
    print('nurseryRegList: ' + ValChainAction.toString());

    nurseryItems = [];
    nurseryUIModel.clear();
    nurseryUIModel = [];
    for (int i = 0; i < ValChainAction.length; i++) {
      String property_value = ValChainAction[i]['opName'].toString();
      String fullName = ValChainAction[i]['fullName'].toString();
      String nurId = ValChainAction[i]['nurId'].toString();
      String mobNo = ValChainAction[i]['mobileNum'].toString();
      String address = ValChainAction[i]['address'].toString();
      String email = ValChainAction[i]['mail'].toString();

      var uimodel = UImodel2(
          property_value + "-" + fullName, nurId, mobNo, address, "", email);
      nurseryUIModel.add(uimodel);
      setState(() {
        nurseryItems.add(DropdownModel(
          fullName + "-" + property_value,
          nurId,
        ));
      });

      Future.delayed(Duration(milliseconds: 500), () {
        setState(() {
          if (nurseryItems.isNotEmpty) {
            nurseryLoaded = true;
            slcNursery = '';
          } else {
            nurseryLoaded = false;
          }
        });
      });
    }
  }

  Future<void> vcaDatadropdown(String villCode) async {
    String qry = '';
    if (entity == '11') {
      qry = 'Select * from vcaData where vilCode = \'' +
          villCode +
          '\' and vcaCat = "5"';
    } else if (entity == '10') {
      qry = 'Select * from vcaData where vilCode = \'' +
          villCode +
          '\' and vcaCat = "3"';
    }
    print('vcaData_qry:' + qry);
    List vcaData = await db.RawQuery(qry);
    print('vcaDataList: ' + vcaData.toString());

    vcaDataList = [];
    vcaDataList.clear();
    vcaDataUIModel = [];

    for (int i = 0; i < vcaData.length; i++) {
      String vacDName = vcaData[i]["applicantName"].toString();
      String vacDCode = vcaData[i]["vId"].toString();
      String rmNumber = '';
      if (entity == "11") {
        rmNumber = vcaData[i]["mobNo"].toString();
      } else if (entity == "10") {
        rmNumber = vcaData[i]["regNo"].toString();
      }
      var uimodel = UImodel2(vacDName, vacDCode, rmNumber, "", "", "");
      vcaDataUIModel.add(uimodel);
      setState(() {
        vcaDataList.add(DropdownModel(vacDName, vacDCode));
      });
    }
  }

  Future<void> getClientData() async {
    agents = await db.RawQuery('SELECT * FROM agentMaster');
    seasoncode = agents[0]['currentSeasonCode'];
    servicePointId = agents[0]['servicePointId'];
    agentDistrictCode = agents[0]['cityCode'];
    print("cityCodeVal:" + agentDistrictCode);
    //agentDistributionBal = agents[0]['agentDistributionBal'];
  }

  Future<void> initvaluesDynamic() async {
    String qryVrty = 'SELECT * from varietyList order by vName asc';
    vrtyList = await db.RawQuery(qryVrty);

    String qryprod = 'SELECT * from products order by productName asc';
    prodList = await db.RawQuery(qryprod);

    String dynamiccomponentMenuqry =
        'select * from dynamiccomponentMenu where txnTypeIdMenu=\'' +
            dynamicTxnId! +
            '\'';

    print("dynamiccomponentMenuqry" + dynamiccomponentMenuqry.toString());

    List dynamiccomponentMenus = await db.RawQuery(dynamiccomponentMenuqry);
    String txnTypeIdMenu = dynamiccomponentMenus[0]["txnTypeIdMenu"].toString();
    String menuName = dynamiccomponentMenus[0]["menuName"].toString();
    setState(() {
      entity = dynamiccomponentMenus[0]["entity"].toString();
      isSurvey = dynamiccomponentMenus[0]["is_survey"].toString();
      //season = dynamiccomponentMenus[0]["seasonFlag"].toString();
      //farSts = dynamiccomponentMenus[0]["farSts"].toString();
      entityFarmerID();
      Village(val_Parish);
    });

    txnTypeId = txnTypeIdMenu;
    txnTypeName = menuName;

    String listcuntqry =
        /*'select distinct list.listId ,sec.secName,sec.sectionId from dynamiccomponentList as list inner join dynamiccomponentSections as sec on list.sectionId=sec.sectionId inner join dynamiccomponentFields as fieldslist on list.sectionId=fieldslist.sectionId where fieldslist.txnTypeId=\'' +
            txnTypeId! +
            '\' and fieldslist.isMandatory=\'1\'';*/
        'select distinct fieldslist.sectionId,fieldslist.componentLabel as secName,list.listId from dynamiccomponentFields as fieldslist inner join dynamiccomponentList as list on fieldslist.txnTypeId=list.txnTypeId and fieldslist.sectionId=list.sectionId where fieldslist.txnTypeId=\'' +
            txnTypeId +
            '\' and fieldslist.componentType=\'8\' and fieldslist.isMandatory=\'1\'';

    print("listcuntqry" + listcuntqry.toString());

    listcounts = await db.RawQuery(listcuntqry);
    ListCount = listcounts!.length.toString();

    //loadComponent();
    /*String sectionqry =
        'select distinct sec.secName,sec.sectionId from dynamiccomponentMenu as menu,dynamiccomponentSections as sec where menu.txnTypeIdMenu=\'' +
            dynamicTxnId! +
            '\'';
    print("sectionqry" + sectionqry.toString());*/

    String sectionqry =
        'select distinct sec.secName,sec.sectionId from dynamiccomponentMenu as menu,dynamiccomponentSections as sec where txnTypeId=\'' +
            txnTypeId +
            '\' and menu.menuId =\'' +
            dynamicTxnId! +
            '\'';

    print("sectionqry" + sectionqry.toString());

    dynamiccomponentSection = await db.RawQuery(sectionqry);

    String qry = "";
    String alreadyAns = '0';
    /*'select distinct flds.ifListNo,flds.fieldOrder,flds.componentID,flds.maxLength,flds.minLength,flds.referenceId,flds.catalogValueId,flds.componentType,flds.componentLabel,flds.componentID,flds.isMandatory,flds.formulaDependency,flds.dependencyField,flds.validationType,flds.sectionId,flds.parentDependency,flds.parentField,flds.isOther,flds.valueDependency,sec.secName from dynamiccomponentFields as flds,dynamiccomponentSections as sec where flds.txnTypeId=\'' +
            txnTypeId +
            '\' and sec.sectionId=flds.sectionId order by flds.fieldOrder asc';
    print("qry_qry" + qry.toString());*/
    if (dynamicTxnId == "M37" || dynamicTxnId == "M36") {
      qry =
          'select distinct flds.ifListNo,flds.fieldOrder,flds.componentID,flds.maxLength,flds.minLength,flds.referenceId,flds.catalogValueId,flds.componentType,flds.componentLabel,flds.componentID,flds.isMandatory,flds.formulaDependency,flds.dependencyField,flds.validationType,flds.sectionId,flds.parentDependency,flds.parentField,flds.isOther,flds.valueDependency,sec.secName from dynamiccomponentFields as flds,dynamiccomponentSections as sec where flds.txnTypeId=\'' +
              txnTypeId +
              '\' and flds.alreadyAns=\'' +
              alreadyAns +
              '\' and sec.sectionId=flds.sectionId order by flds.fieldOrder asc';
      print("qry_qry" + qry.toString());
    } else {
      qry =
          'select distinct flds.ifListNo,flds.fieldOrder,flds.componentID,flds.maxLength,flds.minLength,flds.referenceId,flds.catalogValueId,flds.componentType,flds.componentLabel,flds.componentID,flds.isMandatory,flds.formulaDependency,flds.dependencyField,flds.validationType,flds.sectionId,flds.parentDependency,flds.parentField,flds.isOther,flds.valueDependency,sec.secName from dynamiccomponentFields as flds,dynamiccomponentSections as sec where flds.txnTypeId=\'' +
              txnTypeId +
              '\' and sec.sectionId=flds.sectionId order by flds.fieldOrder asc';
      print("qry_qry called" + qry.toString());
    }

    dynamiccomponentFields = await db.RawQuery(qry);

    print("dynamiccomponentFields " + dynamiccomponentFields.toString());

    String imageqry =
        'select distinct flds.catalogValueId,flds.componentType,flds.componentLabel,flds.componentID,flds.isMandatory,flds.formulaDependency,flds.dependencyField,flds.validationType,flds.sectionId,sec.secName from dynamiccomponentFields flds,dynamiccomponentSections sec where flds.txnTypeId=\'' +
            txnTypeId +
            '\' and sec.sectionId=flds.sectionId and componentType=\'12\'';

    print("imageqry_imageqry" + imageqry.toString());
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

    List actList = await db.RawQuery(
        'select * from animalCatalog where catalog_code =\'501\' ORDER BY _ID desc');

    print("actlist:" + actList.toString());

    activityListUiModel = [];
    activityDropDownItem = [];
    activityDropDownItem.clear();

    for (int i = 0; i < actList.length; i++) {
      String propertyValue = actList[i]["property_value"].toString();
      String diSpSeq = actList[i]["DISP_SEQ"].toString();

      var uiModel = new UImodel(propertyValue, diSpSeq);
      activityListUiModel.add(uiModel);
      setState(() {
        activityDropDownItem.add(DropdownModel(
          propertyValue,
          diSpSeq,
        ));
      });
    }

    List vacCatList = [
      {"property_value": "0", "DISP_SEQ": "Coffee Pulpers"},
      {"property_value": "1", "DISP_SEQ": "Coffee Buyers"},
      {"property_value": "2", "DISP_SEQ": "Coffee Graders"},
      {"property_value": "3", "DISP_SEQ": "Coffee Exporters"},
      {
        "property_value": "4",
        "DISP_SEQ": "Coffee Store operators/Warehousemen"
      },
      {"property_value": "5", "DISP_SEQ": "Coffee Processors"},
      {
        "property_value": "6",
        "DISP_SEQ": "Coffee Brewers / Coffee Roasters / Coffee Shop operators"
      },
      {"property_value": "7", "DISP_SEQ": "Coffee Hullers"},
      {"property_value": "8", "DISP_SEQ": "Coffee Extractor"},
      {"property_value": "9", "DISP_SEQ": "Coffee Factory"},
    ];
    vacCat = [];
    vacCatUIModel = [];
    for (int i = 0; i < vacCatList.length; i++) {
      String vacCatName = vacCatList[i]["DISP_SEQ"].toString();
      String vacCatCode = vacCatList[i]["property_value"].toString();

      var uimodel = new UImodel(vacCatName, vacCatCode);
      vacCatUIModel.add(uimodel);
      setState(() {
        vacCat.add(DropdownModel(
          vacCatName,
          vacCatCode,
        ));
      });
    }

    List regStatList = [
      {"property_value": "Registered", "DISP_SEQ": "0"},
      {"property_value": "Not Registered", "DISP_SEQ": "1"},
    ];
    regStat = [];
    regStatUIModel = [];
    for (int i = 0; i < regStatList.length; i++) {
      String regStatName = regStatList[i]["property_value"].toString();
      String regStatCode = regStatList[i]["DISP_SEQ"].toString();

      var uimodel = new UImodel(regStatName, regStatCode);
      regStatUIModel.add(uimodel);
      setState(() {
        regStat.add(DropdownModel(
          regStatName,
          regStatCode,
        ));
      });
    }
  }

  loadVCAInspection(String vcaCategory) async {
    List vcaList = [];
    vcaList.add("'$vcaCategory'");
    String vc = vcaList.join(',');
    //initvaluesDynamic();
    controller9!.clear();
    componentidvalue.clear();

    setState(() {});

    dynamiccomponentFields = [];
    String qry =
        'select distinct flds.ifListNo,flds.fieldOrder,flds.componentID,flds.maxLength,flds.minLength,flds.referenceId,flds.catalogValueId,flds.componentType,flds.componentLabel,flds.componentID,flds.isMandatory,flds.formulaDependency,flds.dependencyField,flds.validationType,flds.sectionId,flds.parentDependency,flds.parentField,flds.isOther,flds.valueDependency,sec.secName from dynamiccomponentFields as flds,dynamiccomponentSections as sec where flds.txnTypeId=\'' +
            txnTypeId +
            '\' and sec.sectionId=flds.sectionId and flds.actionPlan like "%' +
            vcaCategory +
            '%"  order by flds.fieldOrder asc ';

    dynamiccomponentFields = await db.RawQuery(qry);
    print("dynamiccomponentFieldsvca " + qry);
    print("dynamiccomponentFieldsvca " + dynamiccomponentFields.toString());

    List<Widget> listings = [];
    listings = _getDynamicScreenWidget(context, listings);
  }

  Future<void> loadbeneficairydata(String benId) async {
    farmerDropdowndet = true;
    int countmaleless = 0;
    int countmalegreater = 0;
    int countfemaleless = 0;
    int countfemalegreater = 0;
    int countdisability = 0;

    List benficiaryList = await db.RawQuery(
        'select distinct f.lName,f.serialNo,f.mobileNo,a.property_value,CAST(f.age as INT) as Age,(select property_value from animalCatalog where f.disability = DISP_SEQ) as disability from farmer_master as f left join animalCatalog as a on f.sex= a.DISP_SEQ where f.farmerId =\'' +
            benId +
            '\'');
    print("beneficiarylist:" + benficiaryList.toString());
    househeadController.text = benficiaryList[0]["lName"].toString();
    hhidController.text = benficiaryList[0]["serialNo"].toString();
    mobilenoController.text = benficiaryList[0]["mobileNo"].toString();
    ageController.text = benficiaryList[0]["Age"].toString();
    sexController.text = benficiaryList[0]["property_value"].toString();

    int age = benficiaryList[0]["Age"];
    //toast(age.toString());

    if (benficiaryList[0]["property_value"].toString().toUpperCase() ==
            "MALE" &&
        age < 18) {
      countmaleless = countmaleless + 1;
    } else if (benficiaryList[0]["property_value"].toString().toUpperCase() ==
            "MALE" &&
        age >= 18) {
      countmalegreater = countmalegreater + 1;
    } else if (benficiaryList[0]["property_value"].toString().toUpperCase() ==
            "FEMALE" &&
        age < 18) {
      countfemaleless = countfemaleless + 1;
    } else if (benficiaryList[0]["property_value"].toString().toUpperCase() ==
            "FEMALE" &&
        age >= 18) {
      countfemalegreater = countfemalegreater + 1;
    }
    if (benficiaryList[0]["disability"].toUpperCase() != "NO DISABILITY") {
      countdisability = countdisability + 1;
    }

    List benficiarydemoList = await db.RawQuery(
        'select distinct a.property_value,CAST(f.Age as INT) as Age,(select property_value from animalCatalog where f.disability = DISP_SEQ) as disability from farm as f left join animalCatalog as a on f.sex= a.DISP_SEQ where f.beneficiary =\'' +
            benId +
            '\'');
    print("benificiarydemolist:" + benficiarydemoList.toString());

    for (int i = 0; i < benficiarydemoList.length; i++) {
      int age = benficiarydemoList[i]["Age"];
      //toast(age.toString());

      if (benficiarydemoList[i]["property_value"].toString().toUpperCase() ==
              "MALE" &&
          age < 18) {
        countmaleless = countmaleless + 1;
      } else if (benficiarydemoList[i]["property_value"]
                  .toString()
                  .toUpperCase() ==
              "MALE" &&
          age >= 18) {
        countmalegreater = countmalegreater + 1;
      } else if (benficiarydemoList[i]["property_value"]
                  .toString()
                  .toUpperCase() ==
              "FEMALE" &&
          age < 18) {
        countfemaleless = countfemaleless + 1;
      } else if (benficiarydemoList[i]["property_value"]
                  .toString()
                  .toUpperCase() ==
              "FEMALE" &&
          age >= 18) {
        countfemalegreater = countfemalegreater + 1;
      }
      if (benficiarydemoList[i]["disability"].toUpperCase() !=
          "NO DISABILITY") {
        countdisability = countdisability + 1;
      }
    }

    int totalmember =
        countmaleless + countmalegreater + countfemaleless + countfemalegreater;

    totmalelessController.text = countmaleless.toString();
    totmalegreaterController.text = countmalegreater.toString();
    totfemalelessController.text = countfemaleless.toString();
    totfemalegreaterController.text = countfemalegreater.toString();
    totdisableController.text = countdisability.toString();
    totmemberController.text = totalmember.toString();
  }

  Future<void> entityFarmerID() async {
    if (entity.isNotEmpty && entity != "") {
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
          farmerMultiSearchDropDown = true;
          entityBasedFarmerID = valVillage;
          entityBasedFarmerID = valFarmer;
          farmerDropdown = false;
          farmDropdown = false;
        });
      } else if (entity == "6") {
        setState(() {
          cropDropDown = true;
          entityBasedFarmerID = valCrop;
        });
      } else if (entity == "12") {
        setState(() {
          if (val_regStat == '0') {
            entityBasedFarmerID = val_chainAct;
          } else if (val_regStat == '1') {
            entityBasedFarmerID = vacController.text;
          }
        });
      } else if (entity == "9") {
        setState(() {
          entityBasedFarmerID = val_chainAct;
        });
      } else if (entity == "11" || entity == "10") {
        setState(() {
          entityBasedFarmerID = val_vca;
        });
      } else {
        entityBasedFarmerID = valFarmer;
      }
    }
  }

  List getDropValues(String componentType, String catalogValueId,
      String valueDependency, String parentValue) {
    print('parentValue: $parentValue');
    print('valueDependency: $valueDependency');

    List UImodels = [];
    var catcode = catalogValueId.split('|');
    print("catcode_catcode" + catcode.toString());

    print("catalogValueIdddd" + catcode[1].toString());
    if (catcode[1] == "3") {
      if (catcode[0] == "10") {
        for (var i = 0; i < vrtyList.length; i++) {
          String propertyValue = vrtyList[i]["vName"].toString();
          String DISPSEQ = vrtyList[i]["vCode"].toString();
          String prodId = vrtyList[i]["prodId"].toString();
          var uimodel =
              new dynamicDropMasterModel(propertyValue, DISPSEQ, prodId, "0");
          UImodels.add(uimodel);

          print("propertyValue_Variety" + propertyValue.toString());
          print("propertyValue_DISPSEQ" + DISPSEQ.toString());
        }
      } else if (catcode[0] == "13") {
        var seasonDetailList1 = Glo_All_Pro_Grade.length;
        for (var ind = 0; ind < seasonDetailList1; ind++) {
          String propertyValue = Glo_All_Pro_Grade[ind]["grade"].toString();
          String DISPSEQ = Glo_All_Pro_Grade[ind]["gradeCode"].toString();
          String vCode = Glo_All_Pro_Grade[ind]["vCode"].toString();
          var uimodel =
              new dynamicDropMasterModel(propertyValue, DISPSEQ, vCode, "0");
          UImodels.add(uimodel);
        }
      } else if (catcode[0] == "12") {
        for (var i = 0; i < prodList.length; i++) {
          String propertyValue = prodList[i]["productName"].toString();
          String DISPSEQ = prodList[i]["productCode"].toString();
          String unit = prodList[i]["unit"].toString();
          var uimodel =
              new dynamicDropMasterModel(propertyValue, DISPSEQ, unit, "0");
          UImodels.add(uimodel);

          print("propertyValue_Variety" + propertyValue.toString());
          print("propertyValue_DISPSEQ" + DISPSEQ.toString());
        }
      }
    } else {
      if (componentType == "4") {
        for (int i = 0; i < dynamicDropValues.length; i++) {
          String propertyValue =
              dynamicDropValues[i]["property_value"].toString();
          String DISPSEQ = dynamicDropValues[i]["DISP_SEQ"].toString();
          String catalogCode = dynamicDropValues[i]["catalog_code"].toString();
          if (catcode[0] == catalogCode) {
            printWrapped("catalogCode_catalogCodes" + catalogCode.toString());
            printWrapped("catalogCode_catalogCode" + catalogCode.toString());
            var uimodel =
                new dynamicDropModel(propertyValue, DISPSEQ, catalogCode);
            UImodels.add(uimodel);
          }
        }
      } else if (componentType == "9") {
        print("called multipledropdown");
        for (int i = 0; i < dynamicDropValues.length; i++) {
          if (valueDependency == "1" && componentidvalue.isNotEmpty) {
            for (int k = 0; k < componentidvalue.length; k++) {
              print("componentidvalue[k].value.toString().trim()" +
                  componentidvalue[k].value.toString().split('-')[0].trim());
              List<String> compenentValueSplit =
                  (componentidvalue[k].value.toString().split('-')[0].trim())
                      .split(',');

              if (compenentValueSplit.isNotEmpty) {
                for (int c = 0; c < compenentValueSplit.length; c++) {
                  print("compenentValueSplit[c]" + compenentValueSplit[c]);
                  if (compenentValueSplit[c] ==
                      dynamicDropValues[i]["parentID"].toString().trim()) {
                    String propertyValue =
                        dynamicDropValues[i]["property_value"].toString();
                    String DISPSEQ =
                        dynamicDropValues[i]["DISP_SEQ"].toString();
                    String catalog_code =
                        dynamicDropValues[i]["catalog_code"].toString();
                    var uimodel = new dynamicDropModel(
                        propertyValue, DISPSEQ, catalog_code.toString());
                    UImodels.add(uimodel);
                  }
                }
              }
              /* if (componentidvalue[k].value.toString().split('-')[0].trim() ==
                  dynamicDropValues[i]["parentID"].toString().trim()) {
                String propertyValue =
                    dynamicDropValues[i]["property_value"].toString();
                String DISPSEQ = dynamicDropValues[i]["DISP_SEQ"].toString();
                String catalog_code =
                    dynamicDropValues[i]["catalog_code"].toString();
                var uimodel = new dynamicDropModel(
                    propertyValue, DISPSEQ, catalog_code.toString());
                UImodels.add(uimodel);
              }*/
            }
          } else {
            String propertyValue =
                dynamicDropValues[i]["property_value"].toString();
            String DISPSEQ = dynamicDropValues[i]["DISP_SEQ"].toString();
            String catalogCode =
                dynamicDropValues[i]["catalog_code"].toString();
            String parentID = dynamicDropValues[i]["parentID"].toString();
            if (catcode[0] == catalogCode) {
              var uimodel =
                  new dynamicDropModel(propertyValue, DISPSEQ, catalogCode);
              UImodels.add(uimodel);
            }
          }
        }
      }
    }
    return UImodels;
  }

  List getCatvalues(String componentType, String catalogValueId, String WholeId,
      String componentIDchild) {
    var catcode = catalogValueId.split('|');
    List catTool = [];
    if (catcode[1] == "3") {
      if (catcode[0] == "10") {
        for (var i = 0; i < vrtyList.length; i++) {
          String propertyValue = vrtyList[i]["vName"].toString();
          String DISPSEQ = vrtyList[i]["vCode"].toString();
          String prodId = vrtyList[i]["prodId"].toString();

          if (WholeId == prodId) {
            var uimodel = new dynamicDropMasterModel(
                propertyValue, DISPSEQ, prodId, componentIDchild);
            catTool.add(uimodel);
          }
        }
      } else if (catcode[0] == "13") {
        var seasonDetailList1 = Glo_All_Pro_Grade.length;
        for (var ind = 0; ind < seasonDetailList1; ind++) {
          String propertyValue = Glo_All_Pro_Grade[ind]["grade"].toString();
          String DISPSEQ = Glo_All_Pro_Grade[ind]["gradeCode"].toString();
          String vCode = Glo_All_Pro_Grade[ind]["vCode"].toString();

          if (WholeId == Glo_All_Pro_Grade[ind].vCode) {
            var uimodel = new dynamicDropMasterModel(
                propertyValue, DISPSEQ, vCode, componentIDchild);
            catTool.add(uimodel);
          }
        }
      }
    } else {
      for (int i = 0; i < dynamicDropValues.length; i++) {
        String propertyValue =
            dynamicDropValues[i]["property_value"].toString();
        String DISPSEQ = dynamicDropValues[i]["DISP_SEQ"].toString();
        String catalogCode = dynamicDropValues[i]["catalog_code"].toString();

        if (catcode[0] == catalogCode) {
          var uimodel =
              new dynamicDropModel(propertyValue, DISPSEQ, catalogCode);
          catTool.add(uimodel);
        }
      }
    }
    return catTool;
  }

  List<dynamicDropModel> getDropValuesRadio(
      String componentType, String catalogValueId) {
    List<dynamicDropModel> UImodels = [];
    var catcode = catalogValueId.split('|');
    if (componentType == "2") {
      for (int i = 0; i < dynamicDropValues.length; i++) {
        String propertyValue =
            dynamicDropValues[i]["property_value"].toString();
        String DISPSEQ = dynamicDropValues[i]["DISP_SEQ"].toString();
        String catalogCode = dynamicDropValues[i]["catalog_code"].toString();

        if (catcode[0] == catalogCode) {
          var uimodel =
              new dynamicDropModel(propertyValue, DISPSEQ, catalogCode);
          UImodels.add(uimodel);
        }
      }
    }
    return UImodels;
  }

  Future<void> DropdownLoad() async {
    dynamicDropValues = await loaddropdownvalues();
    print("List dynamicDropValues: " + dynamicDropValues.toString());
  }

  Future<List> loaddropdownvalues() async {
    //var catcode = code.split('|');
    //String qry = 'select * from animalCatalog where catalog_code =\'' + catcode[0] +'\'';
    String qry = 'select * from animalCatalog ORDER BY _ID desc';

    List datalist = await db.RawQuery(qry);
    print("catalogdropdown:" + qry + " " + datalist.toString());
    return datalist;
  }

  Future<bool> _onBackPressed() async {
    return (await Alert(
          context: context,
          type: AlertType.warning,
          title: "Cancel",
          desc: "Are you sure want to cancel?",
          buttons: [
            DialogButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              width: 120,
              child: const Text(
                "Yes",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
            DialogButton(
              onPressed: () {
                Navigator.pop(context);
              },
              width: 120,
              child: const Text(
                "No",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
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
          centerTitle: true,
          leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () {
                _onBackPressed();
              }),
          title: Text(
            txnTypeName,
            style: new TextStyle(
                color: Colors.white,
                fontSize: 18.0,
                fontWeight: FontWeight.w700),
          ),
          iconTheme: IconThemeData(color: Colors.white),
          backgroundColor: Colors.green,
          systemOverlayStyle: SystemUiOverlayStyle.dark,
        ),
        body: Container(
            child: Column(children: <Widget>[
          Expanded(
            child: ListView(
              padding: EdgeInsets.all(10.0),
              children: _getListingsDynamicScreen(
                  context), // <<<<< Note this change for the return type
            ),
            flex: 8,
          ),
        ])),
      ),
    ));
  }

  List<Widget> _getListingsDynamicScreen(BuildContext context) {
    List<Widget> listings = [];

    if (entity != '') {
      listings.add(txt_label_mandatory('Date', Colors.black, 14.0, false));
      listings.add(selectDate(
          context1: context,
          slctdate: reDate,
          onConfirm: (date) => setState(
                () {
                  reDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(date!);
                  reDateFormated = DateFormat('yyyyMMdd').format(date);
                },
              )));
    }

    if (dynamicTxnId != "M37" && dynamicTxnId != "M36" && entity != "1") {
      listings.add(groupDropDown
          ? txt_label_mandatory("Group", Colors.black, 14.0, false)
          : Container());
      listings.add(groupDropDown
          ? DropDownWithModel(
              itemlist: groupItems,
              selecteditem: selectedGroup,
              hint: "Select the Group",
              onChanged: (value) {
                setState(() {
                  selectedGroup = value;
                  slcGroup = selectedGroup!.name;
                  valGroup = selectedGroup!.value;
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
    }

    if (txnTypeId == '2027' || txnTypeId == '2026') {
      listings.add(txt_label_mandatory("District", Colors.black, 14.0, false));
      listings.add(MultiDropDownWithModel(
          hint: nameDistrict.isEmpty ? "Select the District" : nameDistrict,
          itemlist: multiDistrictItems,
          selectedItems: multiSearchDistrictList,
          onChanged: (item) {
            setState(() {
              multiFarmeritems = [];
              multiSearchDistrictList = item;
              multiSubCountyItems.clear();
              multiSearchSubCountyList = [];
              multiParishItems.clear();
              multiSearchParishList = [];
              multiVillageItems.clear();
              multiSearchVillageList = [];
              nameSubCounty = "";
              nameParish = "";
              nameVillage = "";
              String villageName = "";
              String disName = "";
              farName = "";
              for (int i = 0; i < multiSearchDistrictList.length; i++) {
                String value = multiSearchDistrictList[i].value;
                String name = multiSearchDistrictList[i].name;
                if (villageName.length > 0) {
                  villageName = villageName + "," + value;
                  disName = disName + "," + name;
                } else {
                  villageName = villageName + value;
                  disName = disName + name;
                }
                valDist = villageName;
                nameDistrict = disName;
                loadSubCounty2(valDist);
                print('districtdistrict:' + valDist + " " + nameDistrict);
              }

              multiSearchFarmerList = [];
            });
          },
          onClear: () {}));

      listings.add(
          txt_label_mandatory("Subcounty/Division", Colors.black, 14.0, false));
      listings.add(MultiDropDownWithModel(
          hint: nameSubCounty.isEmpty
              ? "Select the Subcounty/Division"
              : nameSubCounty,
          itemlist: multiSubCountyItems,
          selectedItems: multiSearchSubCountyList,
          onChanged: (item) {
            setState(() {
              multiFarmeritems = [];
              multiSearchSubCountyList = item;
              multiParishItems.clear();
              multiSearchParishList = [];
              multiVillageItems.clear();
              multiSearchVillageList = [];
              farName = "";
              nameParish = "";
              nameVillage = "";
              String villageName = "";
              String subName = "";
              for (int i = 0; i < multiSearchSubCountyList.length; i++) {
                String value = multiSearchSubCountyList[i].value;
                String name = multiSearchSubCountyList[i].name;
                if (villageName.length > 0) {
                  villageName = villageName + "," + value;
                  subName = subName + "," + name;
                } else {
                  villageName = villageName + value;
                  subName = subName + name;
                }
                valSubCounty = villageName;
                nameSubCounty = subName;
                loadParish2(valSubCounty);
                print('valSubCounty:' + valSubCounty);
              }

              multiSearchFarmerList = [];
            });
          },
          onClear: () {}));

      listings.add(txt_label_mandatory("Parish", Colors.black, 14.0, false));
      listings.add(MultiDropDownWithModel(
          hint: nameParish.isEmpty ? "Select the Parish" : nameParish,
          itemlist: multiParishItems,
          selectedItems: multiSearchParishList,
          onChanged: (item) {
            setState(() {
              multiFarmeritems = [];
              multiSearchParishList = item;
              multiVillageItems.clear();
              multiSearchVillageList = [];
              farName = "";
              nameVillage = "";
              String villageName = "";
              String parName = "";
              for (int i = 0; i < multiSearchParishList.length; i++) {
                String value = multiSearchParishList[i].value;
                String name = multiSearchParishList[i].name;
                if (villageName.length > 0) {
                  villageName = villageName + "," + value;
                  parName = parName + "," + name;
                } else {
                  villageName = villageName + value;
                  parName = parName + name;
                }
                valParish = villageName;
                nameParish = parName;
                loadVillage2(valParish);
                print('valSubCounty:' + valParish);
              }

              multiSearchFarmerList = [];
            });
          },
          onClear: () {}));

      listings.add(txt_label_mandatory("Village", Colors.black, 14.0, false));
      listings.add(MultiDropDownWithModel(
          hint: nameVillage.isEmpty ? "Select the Village" : nameVillage,
          itemlist: multiVillageItems,
          selectedItems: multiSearchVillageList,
          onChanged: (item) {
            setState(() {
              multiFarmeritems = [];
              multiSearchVillageList = item;
              farName = "";
              String villageName = "";
              String viName = "";
              for (int i = 0; i < multiSearchVillageList.length; i++) {
                String value = multiSearchVillageList[i].value;
                String name = multiSearchVillageList[i].name;
                if (villageName.length > 0) {
                  villageName = villageName + "," + value;
                  viName = viName + "," + name;
                } else {
                  villageName = villageName + value;
                  viName = viName + name;
                }
                valVillage = villageName;
                nameVillage = viName;
                if (txnTypeId == "2026") {
                  farmersearch2(valVillage);
                } else {
                  valChainAction("", valVillage);
                }

                print('farmerSearch2_valVill2:' + valVillage);
              }

              entityFarmerID();
              multiSearchFarmerList = [];
            });
          },
          onClear: () {}));
    }

    if (entity != "3" &&
        dynamicTxnId != "M37" &&
        dynamicTxnId != "M36" &&
        txnTypeId != "2026" &&
        txnTypeId != "2027") {
      listings.add(txt_label_mandatory("District", Colors.black, 14.0, false));
      listings.add(DropDownWithModel(
          itemlist: districtItem,
          selecteditem: slctDistrictItem,
          hint: dName.isEmpty ? "Select the District" : dName,
          onChanged: (value) {
            setState(() {
              subCountyItem = [];
              parishItem = [];
              villageItems = [];
              farmerItems = [];
              farmItems = [];
              multiFarmeritems = [];
              vcaDataList = [];
              slctDistrictItem = value;
              slct_District = slctDistrictItem!.name;
              dName = slctDistrictItem!.name;
              val_District = slctDistrictItem!.value;
              slctSubCounty = null;
              val_SubCounty = "";
              slct_SubCounty = "";
              slctParish = null;
              slct_Parish = "";
              val_Parish = "";
              selectedVillage = null;
              slctVillage = "";
              valVillage = "";
              selectedFarmer = null;
              slcFarmer = "";
              valFarmer = "";
              selectedFarm = null;
              slcFarm = "";
              valFarm = "";
              mobilenoController.clear();
              multiSearchFarmerList = [];
              slctvacCat = null;
              val_vacCat = "";
              slct_vacCat = "";
              slctregStat = null;
              val_regStat = "";
              slct_regStat = "";
              slctChainAct = null;
              val_chainAct = "";
              slct_chainAct = "";
              vacController.clear();
              multiSearchvcaitems = [];
              multivcaitems = [];
              val_chainAct = "";
              chainActUIModel.clear();
              vcaName = "";
              value1 = "";
              mobilenoController.text = '';
              rmNumberController.text = '';
              slctvcaData = null;
              val_vca = "";
              slct_vca = "";
              selectedNursery = null;
              slcNursery = "";
              valNursery = "";
              genderController.text = '';
              emailController.text = '';
              addressController.text = '';
              slcVillage = '';
              farName = "";

              loadSubCounty(val_District);
              LoadRegion(val_District);
            });
          }));

      listings.add(txt_label("Region", Colors.black, 14.0, false));
      listings.add(cardlable_dynamic(region));

      listings.add(
          txt_label_mandatory("Subcounty/Division", Colors.black, 14.0, false));
      listings.add(DropDownWithModel(
          itemlist: subCountyItem,
          selecteditem: slctSubCounty,
          hint: "Select the Subcounty/Division",
          onChanged: (value) {
            setState(() {
              parishItem = [];
              villageItems = [];
              farmerItems = [];
              farmItems = [];
              multiFarmeritems = [];
              vcaDataList = [];

              slctSubCounty = value;
              slct_SubCounty = slctSubCounty!.name;
              val_SubCounty = slctSubCounty!.value;
              slctParish = null;
              slct_Parish = "";
              val_Parish = "";
              selectedVillage = null;
              slctVillage = "";
              valVillage = "";
              selectedFarmer = null;
              slcFarmer = "";
              valFarmer = "";
              selectedFarm = null;
              slcFarm = "";
              valFarm = "";
              mobilenoController.clear();
              multiSearchFarmerList = [];
              slctvacCat = null;
              val_vacCat = "";
              slct_vacCat = "";
              slctregStat = null;
              val_regStat = "";
              slct_regStat = "";
              slctChainAct = null;
              val_chainAct = "";
              slct_chainAct = "";
              vacController.clear();
              multiSearchvcaitems = [];
              val_chainAct = "";
              multivcaitems = [];
              chainActUIModel.clear();
              vcaName = "";
              value1 = "";
              slctvcaData = null;
              val_vca = "";
              slct_vca = "";
              mobilenoController.text = '';
              rmNumberController.text = '';
              addressController.text = '';
              emailController.text = '';
              selectedNursery = null;
              slcNursery = "";
              valNursery = "";
              genderController.text = '';
              slcVillage = '';
              farName = "";
              loadParish(val_SubCounty);
            });
          }));

      listings
          .add(txt_label_mandatory("Parish/Ward", Colors.black, 14.0, false));
      listings.add(DropDownWithModel(
          itemlist: parishItem,
          selecteditem: slctParish,
          hint: "Select the Parish/Ward",
          onChanged: (value) {
            setState(() {
              villageItems = [];
              farmerItems = [];
              farmItems = [];
              multiFarmeritems = [];
              vcaDataList = [];

              slctParish = value;
              slct_Parish = slctParish!.name;
              val_Parish = slctParish!.value;
              selectedVillage = null;
              slctVillage = "";
              valVillage = "";
              selectedFarmer = null;
              slcFarmer = "";
              valFarmer = "";
              selectedFarm = null;
              slcFarm = "";
              valFarm = "";
              mobilenoController.clear();
              multiSearchFarmerList = [];
              slctvacCat = null;
              val_vacCat = "";
              slct_vacCat = "";
              slctregStat = null;
              val_regStat = "";
              slct_regStat = "";
              slctChainAct = null;
              val_chainAct = "";
              slct_chainAct = "";
              vacController.clear();
              multiSearchvcaitems = [];
              val_chainAct = "";
              multivcaitems = [];
              chainActUIModel.clear();
              vcaName = "";
              value1 = "";
              slctvcaData = null;
              val_vca = "";
              slct_vca = "";
              mobilenoController.text = '';
              rmNumberController.text = '';
              addressController.text = '';
              emailController.text = '';
              selectedNursery = null;
              slcNursery = "";
              valNursery = "";
              genderController.text = '';
              slcVillage = '';
              farName = "";

              Village(val_Parish);
            });
          }));

      listings.add(txt_label_mandatory("Village", Colors.black, 14.0, false));
      listings.add(DropDownWithModel(
        itemlist: villageItems,
        selecteditem: selectedVillage,
        hint: "Select the Village",
        onChanged: (value) {
          setState(() {
            farmerItems = [];
            farmItems = [];
            multiFarmeritems = [];
            vcaDataList = [];
            farName = "";

            selectedVillage = value;
            slcVillage = selectedVillage!.name;
            valVillage = selectedVillage!.value;
            farmerLoaded = false;
            slcFarmer = '';
            farmLoaded = false;
            slcFarm = '';
            if ((entity == "9" && isSurvey == "0") || entity == "12") {
              slctvacCat = null;
              val_vacCat = "";
              slct_vacCat = "";
              chainAct = [];
              slctregStat = null;
              val_regStat = "";
              slct_regStat = "";
              slctChainAct = null;
              val_chainAct = "";
              slct_chainAct = "";
              vacController.clear();

              valChainAction(val_vacCat, valVillage);
            } else if (entity == "11" || entity == "10") {
              vcaDataList = [];
              vcaDatadropdown(valVillage);
            } else if (entity == "5") {
              farmerItems = [];
              farmersearch2(valVillage);
            } else if (entity == "8") {
              nurseryItems = [];
              nurseryReg(valVillage);
            } else if (entity == "9" && isSurvey == "1") {
              slctvacCat = null;
              val_vacCat = "";
              slct_vacCat = "";
              chainAct = [];
              slctregStat = null;
              val_regStat = "";
              slct_regStat = "";
              slctChainAct = null;
              val_chainAct = "";
              slct_chainAct = "";
              vacController.clear();
              vcaSurveyLoaded = true;

              valChainAction(val_vacCat, valVillage);
            } else {
              farmerItems = [];
              farmersearch(valVillage);
            }
            slctChainAct = null;
            slctvcaData = null;
            selectedFarmer = null;
            selectedNursery = null;
            multiSearchvcaitems = [];
            multiSearchFarmerList = [];
            mobilenoController.text = '';
            rmNumberController.text = '';
            addressController.text = '';
            emailController.text = '';
            genderController.text = '';
            selectedNursery = null;
            slcNursery = "";
            valNursery = "";
          });
        },
      ));
    }

    if (farmerDropdown &&
        dynamicTxnId != "M37" &&
        dynamicTxnId != "M36" &&
        entity != "5" &&
        entity != "8" &&
        txnTypeId != "2027") {
      listings.add(farmerLoaded
          ? txt_label_mandatory("Farmer Name", Colors.black, 14.0, false)
          : Container());
      listings.add(farmerLoaded
          ? DropDownWithModel(
              itemlist: farmerItems,
              selecteditem: selectedFarmer,
              hint: "Select the Farmer Name",
              onChanged: (value) {
                setState(() {
                  selectedFarmer = value;
                  selectedFarm = null;
                  valFarm = '';
                  slcFarmer = selectedFarmer!.name;
                  valFarmer = selectedFarmer!.value;
                  farmLoaded = false;
                  slcFarm = '';
                  farmSearch(valFarmer);
                  entityFarmerID();
                  for (int i = 0; i < farmerUiModel.length; i++) {
                    if (farmerUiModel[i].value == valFarmer) {
                      mobilenoController.text = farmerUiModel[i].value2;
                      genderController.text = farmerUiModel[i].value4;
                      addressController.text = farmerUiModel[i].value3;
                      emailController.text = farmerUiModel[i].value5;
                    }
                  }
                });
              })
          : Container());

      if ((farmerLoaded && entity == "1")) {
        listings.add(txt_label_icon(
            "Mobile Number", Colors.black, 14.0, true, Icons.account_box));
        listings.add(cardlable_dynamic(mobilenoController.text));
        listings.add(txt_label_icon(
            "Gender", Colors.black, 14.0, true, Icons.account_box));
        listings.add(cardlable_dynamic(genderController.text));
        listings.add(txt_label_icon(
            "Address", Colors.black, 14.0, true, Icons.account_box));
        listings.add(cardlable_dynamic(addressController.text));
      }
    }

    if (entity == "8" && nurseryLoaded) {
      listings.add(txt_label_mandatory("Nursery", Colors.black, 14.0, false));
      listings.add(DropDownWithModel(
          itemlist: nurseryItems,
          selecteditem: selectedNursery,
          hint: "Select the Nursery",
          onChanged: (value) {
            setState(() {
              selectedNursery = value;
              slcNursery = selectedNursery!.name;
              valNursery = selectedNursery!.value;
              for (int i = 0; i < nurseryUIModel.length; i++) {
                if (nurseryUIModel[i].value == valNursery) {
                  mobilenoController.text = nurseryUIModel[i].value2;
                  //genderController.text = farmerUiModel[i].value4;
                  addressController.text = nurseryUIModel[i].value3;
                  emailController.text = nurseryUIModel[i].value5;
                }
              }
            });
          }));
    }

    if (entity != "3") {
      listings.add(villageMultiSearchDropDown
          ? txt_label_mandatory("Village", Colors.black, 14.0, false)
          : Container());
      listings.add(villageMultiSearchDropDown
          ? MultiDropDownWithModel(
              hint: "Select the Village",
              itemlist: multiVillageItems,
              selectedItems: multiSearchVillageList,
              onChanged: (item) {
                setState(() {
                  multiFarmeritems = [];
                  multiSearchVillageList = item;
                  String villageName = "";
                  for (int i = 0; i < multiSearchVillageList.length; i++) {
                    String value = multiSearchVillageList[i].value;
                    if (villageName.length > 0) {
                      villageName = villageName + "," + value;
                    } else {
                      villageName = villageName + value;
                    }
                    valVillage = villageName;
                    farmersearch2(valVillage);
                    print('villagevill2:' + valVillage);
                  }
                  entityFarmerID();
                  multiSearchFarmerList = [];
                });
              },
              onClear: () {})
          : Container());
    }

    if (entity != "3" && txnTypeId != "2027") {
      listings.add(farmerMultiSearchDropDown
          ? txt_label_mandatory("Farmer", Colors.black, 14.0, false)
          : Container());
      listings.add(farmerMultiSearchDropDown
          ? MultiDropDownWithModel(
              hint: farName.isEmpty ? "Select the Farmer" : farName,
              itemlist: multiFarmeritems,
              selectedItems: multiSearchFarmerList,
              onChanged: (item) {
                setState(() {
                  multiSearchFarmerList = item;
                  String farmerName = "";
                  String farmerCode = "";
                  for (int i = 0; i < multiSearchFarmerList.length; i++) {
                    String value = multiSearchFarmerList[i].value;
                    String name = multiSearchFarmerList[i].name;
                    if (farmerName.length > 0) {
                      farmerName = farmerName + "," + value;
                      farmerCode = farmerCode + "\n" + " " + "\n" + name;
                    } else {
                      farmerName = farmerName + value;
                      farmerCode = farmerCode + name;
                    }
                    farName = farmerCode;
                    print("farmernamevalue:" + farName);
                    valFarmer = farmerName;
                    farmSearch(valFarmer);
                  }
                  entityFarmerID();
                });
              },
              onClear: () {})
          : Container());
    }

    if (farmDropdown && dynamicTxnId != "M37") {
      listings.add(farmLoaded
          ? txt_label_mandatory("Farm Name", Colors.black, 14.0, false)
          : Container());
      listings.add(farmLoaded
          ? DropDownWithModel(
              itemlist: farmItems,
              selecteditem: selectedFarm,
              hint: "Select the Farm Name",
              onChanged: (value) {
                setState(() {
                  selectedFarm = value;
                  slcFarm = selectedFarm!.name;
                  valFarm = selectedFarm!.value;
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
          ? DropDownWithModel(
              itemlist: cropItems,
              selecteditem: selectedCrop,
              hint: "Select the Crop",
              onChanged: (value) {
                setState(() {
                  selectedCrop = value;
                  slcCrop = selectedCrop!.name;
                  valCrop = selectedCrop!.value;
                  entityFarmerID();
                });
              },
            )
          : Container());
    }

    if (dynamicTxnId != "M37" &&
        dynamicTxnId != "M36" &&
        entity != "12" &&
        entity != "9" &&
        entity != "1" &&
        entity != "10" &&
        entity != "11" &&
        entity != "5" &&
        entity != "2" &&
        entity != "8") {
      listings.add(txt_label_mandatory("Season", Colors.black, 14.0, false));
      listings.add(DropDownWithModel(
        itemlist: seasonItems,
        selecteditem: selectedSeason,
        hint: "Select the Season",
        onChanged: (value) {
          setState(() {
            selectedSeason = value!;
            slcSeason = selectedSeason!.name;
            valSeason = selectedSeason!.value;
          });
        },
      ));
    }

    if (dynamicTxnId == "M37") {
      listings.add(
          txt_label_mandatory("Village Name: ", Colors.black, 14.0, false));
      listings.add(cardlable_dynamic(mileVillageIn_str!));
      listings
          .add(txt_label_mandatory("Farmer Name: ", Colors.black, 14.0, false));
      listings.add(cardlable_dynamic(mileFarmerIn_str!));
      listings
          .add(txt_label_mandatory("Season Name: ", Colors.black, 14.0, false));
      listings.add(cardlable_dynamic(mileSeasonIn_str!));
      setState(() {
        entityBasedFarmerID = mileFarmerIn!;
      });
    } else if (dynamicTxnId == "M36") {
      listings.add(
          txt_label_mandatory("Village Name: ", Colors.black, 14.0, false));
      listings.add(cardlable_dynamic(mileVillageIn_str!));
      listings
          .add(txt_label_mandatory("Farmer Name: ", Colors.black, 14.0, false));
      listings.add(cardlable_dynamic(mileFarmerIn_str!));
      listings
          .add(txt_label_mandatory("Farm Name: ", Colors.black, 14.0, false));
      listings.add(cardlable_dynamic(mileFarmIn_str!));
      listings
          .add(txt_label_mandatory("Season Name: ", Colors.black, 14.0, false));
      listings.add(cardlable_dynamic(mileSeasonIn_str!));
      setState(() {
        entityBasedFarmerID = mileFarmIn!;
      });
    }

    if (entity == "11" || entity == "10") {
      String vcadatahint = '';
      if (entity == "11") {
        listings.add(txt_label_mandatory(
            'Name of Processor', Colors.black, 14.0, false));
        vcadatahint = 'Select Name of Processor';
      } else if (entity == "10") {
        listings.add(
            txt_label_mandatory('Name of Exporter', Colors.black, 14.0, false));
        vcadatahint = 'Select Name of Exporter';
      }
      listings.add(DropDownWithModel(
        itemlist: vcaDataList,
        selecteditem: slctvcaData,
        hint: vcadatahint,
        onChanged: (value) {
          setState(() {
            slctvcaData = value!;
            val_vca = slctvcaData!.value;
            slct_vca = slctvcaData!.name;
            entityFarmerID();
            vcabool = true;
            rmNumberController.text = '';
            for (int i = 0; i < vcaDataUIModel.length; i++) {
              if (vcaDataUIModel[i].value == val_vca) {
                rmNumberController.text = vcaDataUIModel[i].value2;
              }
            }
          });
        },
      ));

      if (vcabool && entity == "11") {
        listings.add(txt_label('Mobile Number', Colors.black, 14.0, false));
        listings.add(cardlable_dynamic(rmNumberController.text));
      } else if (vcabool && entity == "10") {
        listings
            .add(txt_label('Registration Number', Colors.black, 14.0, false));
        listings.add(cardlable_dynamic(rmNumberController.text));
      }
    }

    if (entity == "12") {
      listings.add(txt_label_mandatory(
          'Value Chain Actor Category', Colors.black, 14.0, false));
      listings.add(DropDownWithModel(
          itemlist: vacCat,
          selecteditem: slctvacCat,
          hint: 'Select Value Chain Actor Category',
          onChanged: (value) {
            setState(() {
              slctvacCat = value!;
              val_vacCat = slctvacCat!.value;

              slct_vacCat = slctvacCat!.name;
              print("vcacatvalue:" + val_vacCat);
              chainAct = [];
              slctregStat = null;
              val_regStat = "";
              slct_regStat = "";
              slctChainAct = null;
              val_chainAct = "";
              slct_chainAct = "";

              slctChainAct = null;
              valChainAction(val_vacCat, valVillage);
              loadVCAInspection(val_vacCat);
            });
          },
          onClear: () {
            setState(() {
              slct_vacCat = '';
            });
          }));

      listings.add(txt_label_mandatory(
          'Registration Status', Colors.black, 14.0, false));
      listings.add(DropDownWithModel(
          itemlist: regStat,
          selecteditem: slctregStat,
          hint: 'Select Registration Status',
          onChanged: (value) {
            setState(() {
              slctregStat = value!;
              val_regStat = slctregStat!.value;
              slct_regStat = slctregStat!.name;
              inspection = true;
              vacController.clear();
              slctChainAct = null;
              val_chainAct = "";
              slct_chainAct = "";
            });
          },
          onClear: () {
            setState(() {
              slct_regStat = '';
              inspection = false;
            });
          }));

      if (inspection == true) {
        if (val_regStat == '0') {
          listings.add(txt_label_mandatory(
              'Value Chain Actor', Colors.black, 14.0, false));
          listings.add(DropDownWithModel(
              itemlist: chainAct,
              selecteditem: slctChainAct,
              hint: 'Select Value Chain Actor',
              onChanged: (value) {
                setState(() {
                  slctChainAct = value!;
                  val_chainAct = slctChainAct!.value;
                  slct_chainAct = slctChainAct!.name;

                  entityFarmerID();
                });
              },
              onClear: () {
                setState(() {
                  slct_chainAct = '';
                });
              }));
        } else if (val_regStat == '1') {
          listings.add(txt_label_mandatory(
              "Value Chain Actor", Colors.black, 14.0, false));
          listings.add(
              txtfield_dynamic("Value Chain Actor", vacController, true, 25));
          entityFarmerID();
        }
      }
    } else if (entity == "9" && isSurvey == "0") {
      listings.add(
          txt_label_mandatory("Value Chain Actor", Colors.black, 14.0, false));
      listings.add(MultiDropDownWithModel(
          hint: slct_chainAct.isEmpty
              ? "Select Value Chain Actor"
              : slct_chainAct,
          itemlist: multivcaitems,
          selectedItems: multiSearchvcaitems,
          onChanged: (item) {
            setState(() {
              multiSearchvcaitems = item;
              print("multiSearchvcaItem:" + multiSearchvcaitems.toString());

              String nameVal = "";

              for (int i = 0; i < multiSearchvcaitems.length; i++) {
                value1 = multiSearchvcaitems[i].value;
                String name = multiSearchvcaitems[i].name;
                if (vcaName.length > 0) {
                  vcaName = vcaName + "," + value1;
                  nameVal = nameVal + "," + name;
                } else {
                  vcaName = vcaName + value1;
                  nameVal = nameVal + name;
                }
                val_chainAct = vcaName;
                slct_chainAct = nameVal;
              }
              entityFarmerID();
            });
          },
          onClear: () {}));
    } else if (entity == "9" && isSurvey == "1" && vcaSurveyLoaded == true) {
      print("called entity value chain");
      listings.add(
          txt_label_mandatory('Value Chain Actor', Colors.black, 14.0, false));
      listings.add(DropDownWithModel(
          itemlist: chainAct,
          selecteditem: slctChainAct,
          hint: 'Select Value Chain Actor',
          onChanged: (value) {
            setState(() {
              slctChainAct = value!;
              val_chainAct = slctChainAct!.value;
              slct_chainAct = slctChainAct!.name;
              for (int i = 0; i < chainActUIModel.length; i++) {
                if (chainActUIModel[i].value == val_chainAct) {
                  mobilenoController.text = chainActUIModel[i].value4;
                  //genderController.text = chainActUIModel[i].value4;
                  addressController.text = chainActUIModel[i].value3;
                  emailController.text = chainActUIModel[i].value2;
                }
              }
              entityFarmerID();
            });
          },
          onClear: () {
            setState(() {
              slct_chainAct = '';
            });
          }));
    }

    if ((nurseryLoaded && entity == "8") ||
        (entity == "9" && isSurvey == "1" && vcaSurveyLoaded == true)) {
      listings.add(
          txt_label_mandatory("Mobile Number ", Colors.black, 14.0, false));
      listings.add(cardlable_dynamic(mobilenoController.text));
      listings.add(
          txt_label_mandatory("Email Address: ", Colors.black, 14.0, false));
      listings.add(cardlable_dynamic(emailController.text));
      listings.add(txt_label_mandatory("Address: ", Colors.black, 14.0, false));
      listings.add(cardlable_dynamic(addressController.text));
    }

    listings = _getDynamicScreenWidget(context, listings);
    return listings;
  }

  /*Future<void> farmerMilestoneDBdata(
      String val_village,
      String val_Farmermaster,
      String val_season,
      BuildContext context,
      List<Widget> listings) async {
    try {
      EasyLoading.show(
        status: loading,
        maskType: EasyLoadingMaskType.black,
      );

      restplugin rest = restplugin();
      final String response = await rest.Download399FarmerMilestone(
          val_village, val_Farmermaster, val_season, "399");
      print('loginApi ' + response);
      Map<String, dynamic> json = jsonDecode(response);

      String code = json['response']['status']['code'];
      if (code == '00') {
        print("ifcase");
        farmermilestone logindata = farmermilestone.fromJson(json);
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String? agentToken = prefs.getString("agentToken");

        final snackBar =
        SnackBar(content: Text(logindata.response!.status!.message!));
        Scaffold.of(context).showSnackBar(snackBar);
        if (logindata.response!.status!.code == '00') {
          print("login 00");

          for (int i = 0; i < logindata.response!.body!.menulist!.length; i++) {
            String menuId = logindata.response!.body!.menulist![i].menuId!;
            String? menuName = logindata.response!.body!.menulist![i].menuLabel;
            String? iconClass =
                logindata.response!.body!.menulist![i].iconClass;
            print("iconClass121212" + iconClass!);
            String? menuOrder =
                logindata.response!.body!.menulist![i].menuOrder;
            String? txnTypeIdMenu =
                logindata.response!.body!.menulist![i].txnTypeId;
            String? entity = logindata.response!.body!.menulist![i].entity;
            String menucommonClass = "menuClick";
            String? seasonFlag =
                logindata.response!.body!.menulist![i].seasonFlag;
            String? agentType =
                logindata.response!.body!.menulist![i].agentType;

            String txnDate = "",
                refId = "",
                refName = "",
                village = "",
                grpName = "",
                statusState = "1",
                fluptxnId = "",
                isfollowup = "";
            int det = await db.DeleteTableRecord(
                "dynamiccomponentMenu", "menuId", menuId);
            print("detMenu " + det.toString());
            int saveMenu = await db.saveDynamicMenu(
                menuId,
                menuName!,
                iconClass,
                menuOrder!,
                txnTypeIdMenu!,
                entity!,
                menucommonClass,
                seasonFlag!,
                agentType!,
                "",
                statusState);
            print("saveMenu " + saveMenu.toString());

            for (int j = 0;
                j < logindata.response!.body!.menulist![i].sections!.length;
                j++) {
              String? txnTypeId =
                  logindata.response!.body!.menulist![i].sections![j].txnTypeId;
              String? blockId =
                  logindata.response!.body!.menulist![i].sections![j].blockId;
              String? sectionId =
                  logindata.response!.body!.menulist![i].sections![j].secId;
              String? secName =
                  logindata.response!.body!.menulist![i].sections![j].secName;
              String? beinsert = logindata
                  .response!.body!.menulist![i].sections![j].beforeInsert;
              String? afterins = logindata
                  .response!.body!.menulist![i].sections![j].afterInsert;
              String ifListNo = 'N';

              db.SaveDynamicCompenentSection(
                  txnTypeId!,
                  blockId!,
                  sectionId!,
                  secName!,
                  beinsert!,
                  afterins!,
                  "",
                  "",
                  fluptxnId,
                  isfollowup);

              for (int k = 0;k <logindata.response!.body!.menulist![i].sections![j].lists!.length;k++) {
                String? listId = logindata.response!.body!.menulist![i].sections![j].lists![k].listId;
                String? listName = logindata.response!.body!.menulist![i].sections![j].lists![k].listName;
                int compententsave = await db.SaveDynamicCompenentList(listId!, listName!, blockId, txnTypeId, sectionId);
                ifListNo = 'Y';
                print("compentent_Save " + compententsave.toString());
              }

              for (int k = 0;
                  k <
                      logindata.response!.body!.menulist![i].sections![j]
                          .fieldList!.length;
                  k++) {
                String? componentType = logindata.response!.body!.menulist![i]
                    .sections![j].fieldList![k].compoType;
                String? componentID = logindata.response!.body!.menulist![i]
                    .sections![j].fieldList![k].compoId;
                String? componentLabel = logindata.response!.body!.menulist![i]
                    .sections![j].fieldList![k].compoLabel;
                String? isMandatory = logindata.response!.body!.menulist![i]
                    .sections![j].fieldList![k].isRequired;
                String? validationType = logindata.response!.body!.menulist![i]
                    .sections![j].fieldList![k].validType;
                String? maxLength = logindata.response!.body!.menulist![i]
                    .sections![j].fieldList![k].maxLength;
                String? minLength = logindata.response!.body!.menulist![i]
                    .sections![j].fieldList![k].minLength;
                String? dependentField = logindata.response!.body!.menulist![i]
                    .sections![j].fieldList![k].dependentField;
                String? cattype = logindata.response!.body!.menulist![i]
                    .sections![j].fieldList![k].catType;
                String? parentDepend = logindata.response!.body!.menulist![i]
                    .sections![j].fieldList![k].parentDepend;
                String? listMethodName = logindata.response!.body!.menulist![i]
                    .sections![j].fieldList![k].listMethodName;
                String? formulaDependency = logindata.response!.body!
                    .menulist![i].sections![j].fieldList![k].formulaDependency;
                String? parentField = logindata.response!.body!.menulist![i]
                    .sections![j].fieldList![k].parentField;
                String? catDepKey = logindata.response!.body!.menulist![i]
                    .sections![j].fieldList![k].catDepKey;
                String? isOther = logindata.response!.body!.menulist![i]
                    .sections![j].fieldList![k].isOther;
                String? secId = logindata.response!.body!.menulist![i]
                    .sections![j].fieldList![k].secId;
                String? listId = logindata.response!.body!.menulist![i]
                    .sections![j].fieldList![k].listId;

                String textType = "";
                String dateboxType = "";
                String decimalLength = "";
                String isDependency = "";
                String fieldOrder = "";
                String referenceId = "";
                String? valueDependency = ""; // logindata.response!.body!.menulist![i].sections![j].fieldList![k].valueDependency;
                String actionPlan = "";
                String deadline = "";
                String answer = "";

                int detcompent = await db.RawUpdate(
                    'DELETE FROM dynamiccomponentFields Where sectionId = \'' +
                        sectionId +
                        '\' AND componentID = \'' +
                        componentID! +
                        '\' AND txnTypeId = \'' +
                        txnTypeId +
                        '\'');

                print("detcompent " + detcompent.toString());
                print("secId " + secId.toString());
                int compententsave = await db.SaveDynamicCompenentFields(
                    componentType!,
                    componentID,
                    componentLabel!,
                    textType,
                    beinsert,
                    afterins,
                    dateboxType,
                    isMandatory!,
                    validationType!,
                    maxLength!,
                    minLength!,
                    decimalLength,
                    isDependency,
                    dependentField!,
                    cattype!,
                    parentDepend!,
                    txnTypeId,
                    blockId,
                    fieldOrder,
                    ifListNo,
                    secId!,
                    listMethodName!,
                    formulaDependency!,
                    parentField!,
                    catDepKey!,
                    isOther!,
                    referenceId,
                    valueDependency!,
                    "");
                print("compentent_Save " + compententsave.toString());
              }
            }
          }
          //Navigator.of(context).push(MaterialPageRoute(
          //builder: (BuildContext context) => dynamicScreengetdata("Farmer Milestones", "M37")));
          initvaluesDynamic();
          DropdownLoad();
        }
      }
      EasyLoading.dismiss();
      print(response);
    } catch (e) {
      print("catchcase");
      EasyLoading.dismiss();
      print("loginE:" + e.toString());
    }
  }*/

  List<Widget> _getDynamicScreenWidget(
      BuildContext context, List<Widget> listings) {
    setState(() {
      int dropdownload = 0;
      int multidropdownload = 0;
      int listnumber = 0;
      int photocount = 0;
      int controllercount = 1;
      validationlist = [];
      int radiobutton = 0;
      var length = 45;
      var minLengthval = 45;
      String secname = '';

      for (int i = 0; i < dynamiccomponentFields.length; i++) {
        String componentType =
            dynamiccomponentFields[i]["componentType"].toString();
        String componentLabel =
            dynamiccomponentFields[i]["componentLabel"].toString();
        componentLabel = componentLabel.replaceAll("\r\n", "");
        String componentID =
            dynamiccomponentFields[i]["componentID"].toString();
        String catalogValueId =
            dynamiccomponentFields[i]["catalogValueId"].toString();
        String isMandatory =
            dynamiccomponentFields[i]["isMandatory"].toString();
        String formulaDependency =
            dynamiccomponentFields[i]["formulaDependency"].toString();
        String isDependency =
            dynamiccomponentFields[i]["isDependency"].toString();
        String dependencyField =
            dynamiccomponentFields[i]["dependencyField"].toString();
        String parentDependency =
            dynamiccomponentFields[i]["parentDependency"].toString();
        parentDependency = parentDependency.trim();
        String parentField =
            dynamiccomponentFields[i]["parentField"].toString();
        String validationType =
            dynamiccomponentFields[i]["validationType"].toString();
        String sectionId = dynamiccomponentFields[i]["sectionId"].toString();
        String secName = dynamiccomponentFields[i]["secName"].toString();
        String listID = dynamiccomponentFields[i]["listId"].toString();
        String valueDependency =
            dynamiccomponentFields[i]["valueDependency"].toString();
        var maxlength = dynamiccomponentFields[i]["maxLength"].toString();
        var minlength = dynamiccomponentFields[i]["minLength"].toString();
        String isOther = dynamiccomponentFields[i]["isOther"].toString();
        String iflistFld = dynamiccomponentFields[i]["ifListNo"].toString();

        bool isparentField = false;
        bool isFieldShow = false;
        String hints = "";
        bool initial = false;
        if (!parentDependency.isEmpty &&
            !parentField.isEmpty &&
            parentDependency != "null") {
          isparentField = false;
        } else {
          isparentField = true;
        }

        print("maxlength" + maxlength);
        if (maxlength.isNotEmpty) {
          length = int.parse(maxlength);
        } else {
          length = 45;
        }

        if (minlength.isNotEmpty) {
          minLengthval = int.parse(minlength);
        } else {
          minLengthval = 45;
        }

        if (!isparentField) {
          for (int c = 0; c < componentidvalue.length; c++) {
            print("componentID Athi UP " + componentID);
            print("parentField Athi " + parentField);
            print("componentidvalue componentid Athi " +
                componentidvalue[c].componentid);
            if (parentField == componentidvalue[c].componentid) {
              if (componentidvalue[c].ComponentType == "9") {
                String splStr = componentidvalue[c].value;
                print("splStr:" + splStr);
                List<String> splittedStr = splStr.split(',');
                if (splittedStr.length == 1) {
                  if (parentDependency == componentidvalue[c].value) {
                    isFieldShow = true;
                    break;
                  } else {
                    componentidvalue.removeWhere(
                        (element) => element.componentid == componentID);
                    isFieldShow = false;
                  }
                } else {
                  for (int j = 0; j < splittedStr.length; j++) {
                    if ((splittedStr[j] == parentDependency)) {
                      isFieldShow = true;
                      break;
                    } else {
                      // componentidvalue.removeWhere((element) => element.componentid == componentID);
                      isFieldShow = false;
                    }
                  }
                }
              } else if (componentidvalue[c].ComponentType == "4") {
                String splStr = componentidvalue[c].value;
                List<String> splittedStr = parentDependency.split(',');
                if (splittedStr.length == 1) {
                  if (parentDependency == componentidvalue[c].value) {
                    isFieldShow = true;
                    break;
                  } else {
                    componentidvalue.removeWhere(
                        (element) => element.componentid == componentID);
                    isFieldShow = false;
                  }
                } else {
                  for (int j = 0; j < splittedStr.length; j++) {
                    if ((splittedStr[j] == componentidvalue[c].value)) {
                      isFieldShow = true;
                      break;
                    } else {
                      // componentidvalue.removeWhere((element) => element.componentid == componentID);
                      isFieldShow = false;
                    }
                  }
                }
              } else if (componentidvalue[c].ComponentType == "2") {
                print("componentID Athi DOWN type 2" + componentID);
                if (parentDependency == componentidvalue[c].value) {
                  isFieldShow = true;
                  break;
                } else {
                  componentidvalue.removeWhere(
                      (element) => element.componentid == componentID);
                  for (int k = 0; k < multipleRadioList.length; k++) {
                    if (componentID == multipleRadioList[k].componentID) {
                      print('radiobuttondynamic componentID UP ' + componentID);
                      multipleRadioList[k].value =
                          -1; // commented for value setted after textfield submitted issue
                    }
                  }
                  isFieldShow = false;
                }
              }
            } else {
              print("componentID Athi DOWN " + componentID);
              if (componentType == "2") {
                /*componentidvalue.removeWhere((element) => element.componentid == componentID);
              for (int k = 0; k < multipleRadioList.length; k++) {
                  if(componentID == multipleRadioList[k].componentID){
                    multipleRadioList[k].value = -1;
                  }
              }*/
              } else if (componentType == "4") {
              } else if (componentType == "9") {}
            }
          }
        } else {
          isFieldShow = true;
        }

        if (secname != secName) {
          secname = secName;
          listings.add(txt_labelsection(secName, Colors.green, 18.0, true));
        }

        validationlist
            .add(ValidationModel("", sectionId, isMandatory, componentID));

        switch (componentType) {
          case "1": //textfield
            if (isFieldShow) {
              if (isMandatory == "1") {
                listings.add(txt_label_mandatory(
                    componentLabel, Colors.black, 14.0, false));
              } else if (isMandatory == "0") {
                listings
                    .add(txt_label(componentLabel, Colors.black, 14.0, false));
              }

              /*int len1 = componentidvalue.length;
            if (len1 > 0) {
              for (int d = 0; d < componentidvalue.length; d++) {
                if(componentID==componentidvalue[d].parentField){
                  componentidvalue.removeWhere((element) => element.parentField == componentID);
                }
              }
            }*/

              String hints = "";
              bool initial = false;
              String len = componentidvalue.length.toString();
              if (int.parse(len) > 0) {
                for (int c = 0; c < int.parse(len); c++) {
                  if (componentID == componentidvalue[c].componentid) {
                    hints = componentidvalue[c].value;
                    initial = true;
                  }
                }
              } else {
                hints = "";
                initial = false;
              }

              if (validationType == '2') {
                listings.add(txtfield_digitswithoutdecimalandController(
                    intialVal: hints,
                    initial: initial,
                    length: length,
                    hint: componentLabel,
                    txtcontroller: controller9,
                    focus: true,
                    Position: i.toString(),
                    componentType: componentType,
                    sectionId: sectionId,
                    isMandatory: isMandatory,
                    componentLabel: componentLabel,
                    Type: "1",
                    componentidvalue: componentidvalue,
                    componentid: componentID,
                    onChange: (text) {
                      String nextValue = text;

                      String prevValue = "";
                      /*farm inspection changes start*/
                      if (componentidvalue.isNotEmpty) {
                        for (int c = 0; c < componentidvalue.length; c++) {
                          if (componentidvalue[c]
                                  .componentid
                                  .contains("C007") &&
                              valueDependency == "1") {
                            prevValue = componentidvalue[c].value;
                            print("value c007 contains" + prevValue);
                            if (prevValue.isNotEmpty && nextValue.isNotEmpty) {
                              if (int.parse(prevValue) < int.parse(nextValue)) {
                                errordialog(context, "information",
                                    "Total number of alive seedlings planted should be greater than Number of alive seedlings");
                                text = "";
                              }
                            }
                          } else if (componentidvalue[c]
                                  .componentid
                                  .contains("C008") &&
                              valueDependency == "0") {
                            prevValue = componentidvalue[c].value;
                            print("value c007 contains" + prevValue);
                            if (prevValue.isNotEmpty && nextValue.isNotEmpty) {
                              if (int.parse(prevValue) > int.parse(nextValue)) {
                                errordialog(context, "information",
                                    "Total number of alive seedlings planted should be greater than Number of alive seedlings");
                                text = "";
                              }
                            }
                          }
                        }
                      }

                      /*farm inspection changes end*/

                      print("txtfieldController " + componentID + " : " + text);
                      print("componentidvalue" + componentidvalue.toString());
                      //componentidvalue.add(ComponentModel(componentID, text, i.toString(), componentType, sectionId, isMandatory, componentLabel, text, componentType,parentField,parentDependency));
                      componentidvalue = takeNumber(
                          text,
                          componentID,
                          i.toString(),
                          componentType,
                          sectionId,
                          isMandatory,
                          componentLabel,
                          "1",
                          componentidvalue,
                          componentidvalue_Label,
                          parentField,
                          dependencyField,
                          parentDependency,
                          iflistFld);
                      setState(() {});
                    }));
              } else if (validationType == '3') {
                print("validationTypeelse" +
                    validationType.toString() +
                    " " +
                    componentID +
                    " " +
                    componentLabel);
                //TextEditingController? controller9 = TextEditingController();

                //listings.add(txtfield_dynamicWothoutcontroller(componentLabel, componentID, true, i.toString(), componentType, sectionId,isMandatory, componentLabel,"1",componentidvalue));
                listings.add(txtfield_dynamicwithchareactercontroller(
                    intialVal: hints,
                    length: length,
                    initial: initial,
                    hint: componentLabel,
                    txtcontroller: controller9,
                    focus: true,
                    Position: i.toString(),
                    componentType: componentType,
                    sectionId: sectionId,
                    isMandatory: isMandatory,
                    componentLabel: componentLabel,
                    Type: "1",
                    componentID: componentID,
                    componentidvalue: componentidvalue,
                    onChange: (text) {
                      print("componentidvalue" + componentidvalue.toString());
                      //componentidvalue.add(ComponentModel(componentID, text, i.toString(), componentType, sectionId, isMandatory, componentLabel, text, componentType,parentField,parentDependency));
                      componentidvalue = takeNumber(
                          text,
                          componentID,
                          i.toString(),
                          componentType,
                          sectionId,
                          isMandatory,
                          componentLabel,
                          "1",
                          componentidvalue,
                          componentidvalue_Label,
                          parentField,
                          dependencyField,
                          parentDependency,
                          iflistFld);
                      print('componentidvaluelength ' +
                          componentID +
                          ' ' +
                          componentidvalue.length.toString() +
                          ' ' +
                          text);
                    }));
              } else if (validationType == '4') {
                //TextEditingController? controller9 = TextEditingController();
                listings.add(txtfield_digitswithdecimalandController(
                    intialVal: hints,
                    initial: initial,
                    length: length,
                    minlength: minLengthval,
                    hint: componentLabel,
                    txtcontroller: controller9,
                    focus: true,
                    Position: i.toString(),
                    componentType: componentType,
                    sectionId: sectionId,
                    isMandatory: isMandatory,
                    componentLabel: componentLabel,
                    Type: "1",
                    componentidvalue: componentidvalue,
                    componentid: componentID,
                    onChange: (text) {
                      print("txtfieldController " + componentID + " : " + text);
                      //componentidvalue.add(ComponentModel(componentID, text, i.toString(), componentType, sectionId, isMandatory, componentLabel, text, componentType,parentField,parentDependency));
                      componentidvalue = takeNumber(
                          text,
                          componentID,
                          i.toString(),
                          componentType,
                          sectionId,
                          isMandatory,
                          componentLabel,
                          "1",
                          componentidvalue,
                          componentidvalue_Label,
                          parentField,
                          dependencyField,
                          parentDependency,
                          iflistFld);
                      setState(() {});
                    }));
              } else if (validationType == '5') {
                print("validationTypalphanumeric" +
                    validationType.toString() +
                    " " +
                    componentID +
                    " " +
                    componentLabel);
                //TextEditingController? controller9 = TextEditingController();

                String val = "";
                //listings.add(txtfield_dynamicWothoutcontroller(componentLabel, componentID, true, i.toString(), componentType, sectionId,isMandatory, componentLabel,"1",componentidvalue));
                listings.add(txtfield_dynamicaphanumericcontroller(
                    intialVal: hints,
                    length: length,
                    initial: initial,
                    hint: componentLabel,
                    txtcontroller: controller9,
                    focus: true,
                    Position: i.toString(),
                    componentType: componentType,
                    sectionId: sectionId,
                    isMandatory: isMandatory,
                    componentLabel: componentLabel,
                    Type: "1",
                    componentID: componentID,
                    componentidvalue: componentidvalue,
                    onChange: (text) {
                      //componentidvalue.add(ComponentModel(componentID, text, i.toString(), componentType, sectionId, isMandatory, componentLabel, text, componentType,parentField,parentDependency));
                      componentidvalue = takeNumber(
                          text,
                          componentID,
                          i.toString(),
                          componentType,
                          sectionId,
                          isMandatory,
                          componentLabel,
                          "1",
                          componentidvalue,
                          componentidvalue_Label,
                          parentField,
                          dependencyField,
                          parentDependency,
                          iflistFld);
                      print('componentidvaluelength ' +
                          componentID +
                          ' ' +
                          componentidvalue.length.toString() +
                          ' ' +
                          text);
                    }));
              } else if (validationType == '7') {
                //TextEditingController? controller9 = TextEditingController();
                listings.add(txtfield_digitswithdecimalandController1(
                    intialVal: hints,
                    initial: initial,
                    length: length,
                    minlength: minLengthval,
                    hint: componentLabel,
                    txtcontroller: controller9,
                    focus: true,
                    Position: i.toString(),
                    componentType: componentType,
                    sectionId: sectionId,
                    isMandatory: isMandatory,
                    componentLabel: componentLabel,
                    Type: "1",
                    componentidvalue: componentidvalue,
                    componentid: componentID,
                    onChange: (text) {
                      print("txtfieldController " + componentID + " : " + text);
                      //componentidvalue.add(ComponentModel(componentID, text, i.toString(), componentType, sectionId, isMandatory, componentLabel, text, componentType,parentField,parentDependency));
                      componentidvalue = takeNumber(
                          text,
                          componentID,
                          i.toString(),
                          componentType,
                          sectionId,
                          isMandatory,
                          componentLabel,
                          "1",
                          componentidvalue,
                          componentidvalue_Label,
                          parentField,
                          dependencyField,
                          parentDependency,
                          iflistFld);
                      setState(() {});
                    }));
              } else {
                print("validationTypeelse" +
                    validationType.toString() +
                    " " +
                    componentID +
                    " " +
                    componentLabel);
                //TextEditingController? controller9 = TextEditingController();

                listings.add(txtfield_dynamicWothoutcontroller(
                    intialVal: hints,
                    length: length,
                    initial: initial,
                    hint: componentLabel,
                    txtcontroller: controller9,
                    focus: true,
                    Position: i.toString(),
                    componentType: componentType,
                    sectionId: sectionId,
                    isMandatory: isMandatory,
                    componentLabel: componentLabel,
                    Type: "1",
                    componentID: componentID,
                    componentidvalue: componentidvalue,
                    onChange: (text) {
                      print("txtfieldController " + componentID + " : " + text);
                      //componentidvalue.add(ComponentModel(componentID, text, i.toString(), componentType, sectionId, isMandatory, componentLabel, text, componentType,parentField,parentDependency));
                      componentidvalue = takeNumber(
                          text,
                          componentID,
                          i.toString(),
                          componentType,
                          sectionId,
                          isMandatory,
                          componentLabel,
                          "1",
                          componentidvalue,
                          componentidvalue_Label,
                          parentField,
                          dependencyField,
                          parentDependency,
                          iflistFld);
                      print('componentidvaluelength ' +
                          componentID +
                          ' ' +
                          componentidvalue.length.toString() +
                          ' ' +
                          text);
                    }));
              }
              /* controller1.addListener(() {
                    final text = controller1.text;
                    var compenentModel = new ComponentModel(componentID, text, i.toString(), componentType, sectionId,isMandatory, componentLabel, text, "1");
                    updateDynamicComponentDynamic(compenentModel);
                });*/
            }
            break;

          case "2": //Radio
            if (isFieldShow) {
              if (isMandatory == "1") {
                listings.add(txt_label_mandatory(
                    componentLabel, Colors.black, 14.0, false));
              } else {
                listings
                    .add(txt_label(componentLabel, Colors.black, 14.0, false));
              }

              List<dynamicDropModel> sampleData = [];
              sampleData = getDropValuesRadio(componentType, catalogValueId);
              void getRadiochange(int? position, String ComponentId,
                  String DISPSEQ, String? parentField) {
                bool found = false;
                for (int g = 0; g < multipleRadioList.length; g++) {
                  if (multipleRadioList[g].componentID == ComponentId) {
                    multipleRadioList[g].value = position!;
                    found = true;
                  }
                }
                if (!found) {
                  multipleRadioList.add(
                      MultipleRadioModel(parentField!, ComponentId, position!));
                }

                /* int len = componentidvalue.length;
              if (len > 0) {
                for (int c = 0; c < componentidvalue.length; c++) {
                  if(componentID==componentidvalue[c].parentField){
                    print('radiobuttondynamic parentField '+componentidvalue[c].parentField);
                    componentidvalue.removeWhere((element) => element.parentField == componentID);
                    for (int k = 0; k < multipleRadioList.length; k++) {
                      if(parentField==multipleRadioList[k].parentcomponentID){
                        if(componentID != multipleRadioList[k].componentID){
                          print('radiobuttondynamic componentID '+componentID);
                          multipleRadioList[k].value = -1;// commented for value setted after textfield submitted issue
                        }
                      }

                    }
                  }
                }
              }*/

                /* if(multipleRadioList.length>0){
                for (int c = 0; c < multipleRadioList.length; c++) {
                  if(componentID != multipleRadioList[c].componentID){
                    multipleRadioList[c].value = -1;
                  }
                }
              }*/

                var compenentModel = ComponentModel(
                    componentID,
                    DISPSEQ,
                    i.toString(),
                    componentType,
                    sectionId,
                    isMandatory,
                    componentLabel,
                    DISPSEQ,
                    "2",
                    parentField!,
                    dependencyField,
                    parentDependency,
                    iflistFld,
                    "");
                updateDynamicComponentDynamic(compenentModel);
                var compenentModeldate = new DatesModel(componentID, DISPSEQ);
                updateDateComponentDynamic(compenentModeldate);
              }

              listings.add(dynamicRadio(
                  radioContext: context,
                  sampleData: sampleData,
                  ontap: getRadiochange,
                  multipleRadioList: multipleRadioList,
                  parentField: parentField,
                  ComponentId: componentID));
              //listings.add(dynamicRadio(radioContext: context, sampleData: sampleData2, ontap: getRadiochange,multipleRadioList: multipleRadioList,ComponentId: "777"));
            }
            break;

          case "3": // date selection
            if (isFieldShow) {
              if (isMandatory == "1") {
                listings.add(txt_label_mandatory(
                    componentLabel, Colors.black, 14.0, false));
              } else {
                listings
                    .add(txt_label(componentLabel, Colors.black, 14.0, false));
              }

              listings.add(selectDateDynamic(
                context1: context,
                slctdate: "Select Date",
                datemodel: Dates,
                ComponentId: componentID,
                onConfirm: (date) => setState(() {
                  String slctdates =
                      DateFormat('yyyy-MM-dd HH:mm:ss').format(date!);
                  // Dates[i] = slctdates;
                  bool found = false;
                  for (int i = 0; i < Dates.length; i++) {
                    if (componentID == Dates[i].ComponentId) {
                      Dates[i].Date = slctdates;
                      found = true;
                    }
                  }
                  if (!found) {
                    Dates.add(DateModel(componentID, slctdates));
                  }
                  var compenentModel = ComponentModel(
                      componentID,
                      slctdates,
                      i.toString(),
                      componentType,
                      sectionId,
                      isMandatory,
                      componentLabel,
                      slctdates,
                      "",
                      parentField,
                      dependencyField,
                      parentDependency,
                      iflistFld,
                      "");
                  updateDynamicComponentDynamic(compenentModel);
                  var compenentModeldate = DatesModel(componentID, slctdates);
                  updateDateComponentDynamic(compenentModeldate);
                }),
              ));
            }
            break;

          case "4": // dropdown
            if (isFieldShow) {
              if (isMandatory == "1") {
                listings.add(txt_label_mandatory(
                    componentLabel, Colors.black, 14.0, false));
              } else {
                listings.add(txt_label_Dynamic(
                    componentLabel, Colors.black, 14.0, false));
              }
              bool isCatalogAdd = false;
              if (isOther == "1") {
                isCatalogAdd = true;
              }

              List dropdownlist = [];

              List<DropdownModel> dropdownItems = [];
              dropdownlist = getDropValues(
                  componentType, catalogValueId, valueDependency, parentField);
              List<UImodel> UImodels = [];
              UImodels = [];

              var catcode = catalogValueId.split('|');

              print("catcode[1] " + catcode[1]);
              if (catcode[1] == "3") {
                if (valueDependency == "0") {
                  dropdownlistMaster = getDropValues(componentType,
                      catalogValueId, valueDependency, parentField);
                  for (int jj = 0; jj < dropdownlistMaster.length; jj++) {
                    String propertyValue =
                        dropdownlistMaster[jj].property_value;
                    String DISPSEQ = dropdownlistMaster[jj].DISP_SEQ;
                    setState(() {
                      dropdownItems.add(DropdownModel(propertyValue, DISPSEQ));
                    });
                  }
                } else if (dropdownlistMaster.length > 0 &&
                    valueDependency == "1") {
                  print('selectedvalues2 dependency' + "");
                  for (int jj = 0; jj < dropdownlistMaster.length; jj++) {
                    String propertyValue =
                        dropdownlistMaster[jj].property_value;
                    String DISPSEQ = dropdownlistMaster[jj].DISP_SEQ;
                    String componentIDchild =
                        dropdownlistMaster[jj].componentIDchild;
                    if (componentID == componentIDchild) {
                      setState(() {
                        dropdownItems
                            .add(DropdownModel(propertyValue, DISPSEQ));
                      });
                    }
                  }
                } else {
                  if (catcode[0] == "9") {
                    for (var i = 0; i < cropvalList.length; i++) {
                      String propertyValue = cropvalList[i]["fname"].toString();
                      String DISPSEQ = cropvalList[i]["fcode"].toString();
                      String unit = cropvalList[i]["Unit"].toString();
                      setState(() {
                        dropdownItems
                            .add(DropdownModel(propertyValue, DISPSEQ));
                      });
                    }
                  }
                }
              } else {
                if (dropdownlist.isNotEmpty) {
                  for (int i = 0; i < dropdownlist.length; i++) {
                    String propertyValue = dropdownlist[i].property_value;
                    String DISPSEQ = dropdownlist[i].DISP_SEQ;
                    var uimodel = UImodel(propertyValue, DISPSEQ);
                    UImodels.add(uimodel);

                    dropdownItems.add(DropdownModel(propertyValue, DISPSEQ));
                  }
                }
              }
              /*for (int i = 0; i < catalogList.length; i++) {
                if(catalogList[i].ComponentId==componentID){
                  String propertyValue = catalogList[i].CatalogValue;
                  String DISPSEQ = catalogList[i].CatalogValue;
                  //print("RR DISPSEQ  "+DISPSEQ);
                  var uimodel = new UImodel(propertyValue, DISPSEQ);
                  UImodels.add(uimodel);

                  items.add(DropdownMenuItem(
                    child: Text(propertyValue),
                    value: DISPSEQ,
                  ));
                }
              }*/
              DropdownList.add(DropDownModel(
                  componentID, componentLabel, "", dropdownItems));
              DropdownModel? selectedItem;
              String valueItem = "";
              for (int c = 0; c < componentidvalue.length; c++) {
                print("selectedvalues3 " +
                    componentID +
                    " <> " +
                    componentidvalue[c].componentid +
                    " <> " +
                    componentidvalue[c].componentLabel);
                if (componentID == componentidvalue[c].componentid) {
                  print("selectedvalues2 " + componentID);
                  print("selectedvalues2 parentField 1 " +
                      componentidvalue[c].parentField);
                  print("selectedvalues2 selectedName 1 " +
                      componentidvalue[c].selectedName);

                  selectedItem = DropdownModel(componentidvalue[c].selectedName,
                      componentidvalue[c].value);
                }
              }

              listings.add(DropdownDynamic(
                  itemlist: DropdownList,
                  selecteditem: selectedItem,
                  context: context,
                  componentLabel: componentLabel,
                  hint: "Select an option",
                  AddCatalog: isCatalogAdd,
                  ComponentId: componentID,
                  onChanged: (value) {
                    setState(() {
                      if (value != null) {
                        int len = componentidvalue.length;
                        /*if (len > 0) {
                        for (int c = 0; c < componentidvalue.length; c++) {
                          if(componentID==componentidvalue[c].parentField){
                            componentidvalue.removeWhere((element) => element.parentField == componentID);
                          }
                        }
                      }*/
                        String firstchar = value.value[0];
                        String? nameSlct = value.name;
                        print("nameSlct" + nameSlct);
                        /* List<String> splitdependency = dependencyField.split(',');
                      print("labelvaluedyn"+splitdependency.toString());
                      print("labelvaluedyn"+splitdependency.toString());
                      for(int i=0;i<splitdependency.length;i++){
                      if(splitdependency[i]==componentID){
                        labelvaluedyn!=nameSlct;
                        print("labelvaluedyn"+labelvaluedyn.toString());
                      }else{
                        labelvaluedyn="";
                      }
                      }*/
                        labelvaluedyn = nameSlct;

                        print("firstchar 1" + firstchar);
                        print("firstchar 1" + nameSlct);
                        if (firstchar == "#") {
                          print('addcatalog 1');
                          String selectedvalue =
                              value.value.substring(1, value.value.length);

                          print("selectedVal:" + selectedvalue);

                          catalogList
                              .add(CatalogModel(componentID, selectedvalue));
                          for (int c = 0; c < DropdownList.length; c++) {
                            if (componentID == DropdownList[c].ComponentId) {
                              DropdownList[c].SelectedValue = selectedvalue;
                              print("DropdownList[c].SelectedValue" +
                                  DropdownList[c].SelectedValue.toString());
                            }
                          }
                          selectedItem!.value = selectedvalue;
                          print(
                              "selectedvalueString" + selectedvalue.toString());
                          var compenentModel = ComponentModel(
                              componentID,
                              selectedvalue,
                              i.toString(),
                              componentType,
                              sectionId,
                              isMandatory,
                              componentLabel,
                              selectedvalue,
                              "4",
                              parentField,
                              dependencyField,
                              parentDependency,
                              iflistFld,
                              nameSlct);
                          updateDynamicComponentDynamic(compenentModel);
                        } else {
                          for (int c = 0; c < DropdownList.length; c++) {
                            if (componentID == DropdownList[c].ComponentId) {
                              DropdownList[c].SelectedValue = value.value;
                            }
                          }

                          for (int i = 0; i < UImodels.length; i++) {
                            if (value.value == UImodels[i].value) {
                              valueItem = UImodels[i].value;
                            }
                          }
                          if (value == null) {
                            // selectedItem = "";
                            dropdownValue = "";
                          } else {
                            selectedItem = value;
                            dropdownValue = value.value;
                            var compenentModel = ComponentModel(
                                componentID,
                                value.value,
                                i.toString(),
                                componentType,
                                sectionId,
                                isMandatory,
                                componentLabel,
                                nameSlct,
                                "4",
                                parentField,
                                dependencyField,
                                parentDependency,
                                iflistFld,
                                nameSlct);
                            updateDynamicComponentDynamic(compenentModel);
                          }
                        }

                        for (int p = 0; p < componentidvalue.length; p++) {
                          for (int m = 0; m < dynamicDropValues.length; m++) {
                            if (value.value.toString().trim() ==
                                dynamicDropValues[m]["parentID"]
                                    .toString()
                                    .trim()) {
                              selectedList = [];
                            }
                          }
                        }
                      } else {
                        selectedItem = null;
                      }
                    });
                  },
                  onClear: () {
                    setState(() {
                      for (int c = 0; c < componentidvalue.length; c++) {
                        if (componentID == componentidvalue[c].componentid) {
                          componentidvalue.removeAt(c);
                        }
                      }
                    });
                  }));
            }
            break;

          case "5": //textfield
            if (isFieldShow) {
              if (isMandatory == "1") {
                listings.add(txt_label_mandatory(
                    componentLabel, Colors.black, 14.0, false));
              } else if (isMandatory == "0") {
                listings
                    .add(txt_label(componentLabel, Colors.black, 14.0, false));
              }
              int len1 = componentidvalue.length;
              if (len1 > 0) {
                for (int d = 0; d < componentidvalue.length; d++) {
                  if (componentID == componentidvalue[d].parentField) {
                    componentidvalue.removeWhere(
                        (element) => element.parentField == componentID);
                  }
                }
              }

              int len = componentidvalue.length;
              if (len > 0) {
                for (int c = 0; c < len; c++) {
                  if (parentField != "" && parentDependency != "") {
                    for (int d = 0; d < componentidvalue.length; d++) {
                      if (parentField == componentidvalue[d].componentid) {
                        if (componentidvalue[d].ComponentType == "9") {
                          String splStr = componentidvalue[d].value;
                          List<String> splittedStr = splStr.split(',');
                          print("text area splittedStr.length " +
                              splittedStr.length.toString());
                          print("text area parentDependency.length " +
                              parentDependency);
                          print("text area componentidvalue[c].value.length " +
                              componentidvalue[d].value);
                          if (splittedStr.length == 1) {
                            if (parentDependency == componentidvalue[d].value) {
                              hints = "";
                              initial = true;
                            } else {
                              hints = "";
                              initial = false;
                            }
                          } else {
                            print(
                                "splittedStr.length " + splittedStr.toString());
                            print("parentDependency multi " + parentDependency);
                            for (int j = 0; j < splittedStr.length; j++) {
                              if ((splittedStr[j] == parentDependency)) {
                                hints = "";
                                initial = true;
                                break;
                              } else {
                                hints = "";
                                initial = false;
                              }
                            }
                          }
                        }
                        if (componentidvalue[d].ComponentType == "4") {
                          String splStr = componentidvalue[d].value;
                          List<String> splittedStr =
                              parentDependency.split(',');
                          print("splittedStr.length " +
                              splittedStr.length.toString());
                          print("parentDependency.length " + parentDependency);
                          print("componentidvalue[c].value.length " +
                              componentidvalue[d].value);
                          if (splittedStr.length == 1) {
                            if (parentDependency == componentidvalue[d].value) {
                              hints = "";
                              initial = true;
                            } else {
                              hints = "";
                              initial = false;
                            }
                          } else {
                            print(
                                "splittedStr.length " + splittedStr.toString());
                            print("componentidvalue[c].value multi " +
                                componentidvalue[d].value);
                            for (int j = 0; j < splittedStr.length; j++) {
                              if ((splittedStr[j] ==
                                  componentidvalue[d].value)) {
                                hints = "";
                                initial = true;
                                break;
                              } else {
                                hints = "";
                                initial = false;
                              }
                            }
                          }
                        }
                        if (componentidvalue[d].ComponentType == "2") {
                          if (parentDependency == componentidvalue[d].value) {
                            hints = "";
                            initial = true;
                          } else {
                            hints = "";
                            initial = false;
                          }
                        }
                      }
                    }
                  } else {
                    if (componentID == componentidvalue[c].componentid) {
                      hints = "";
                      initial = true;
                    } else {
                      hints = "";
                      initial = false;
                    }
                  }
                }
              } else {
                hints = "";
                initial = false;
              }

              print("validationType else " + validationType.toString());
              TextEditingController? controller9;
              listings.add(txtArea_dynamic(
                  intialVal: hints,
                  length: length,
                  initial: initial,
                  hint: componentLabel,
                  txtcontroller: controller9,
                  focus: true,
                  Position: i.toString(),
                  componentType: componentType,
                  sectionId: sectionId,
                  isMandatory: isMandatory,
                  componentLabel: componentLabel,
                  Type: "1",
                  componentidvalue: componentidvalue,
                  componentID: componentID,
                  onChange: (text) {
                    // setState(() {
                    print('txtArea_dynamic ' + componentID + ' ' + text);
                    if (text == "") {
                      text = "";
                    }
                    var compenentModel = ComponentModel(
                        componentID,
                        text,
                        i.toString(),
                        componentType,
                        sectionId,
                        isMandatory,
                        componentLabel,
                        text,
                        componentType,
                        parentField,
                        dependencyField,
                        parentDependency,
                        iflistFld,
                        "");
                    updateDynamicComponentDynamic(compenentModel);
                    // });
                  }));
            }
            break;

          case "6": //checkbox
            bool checkboxvalue = false;

            listings.add(checkbox_dynamic(
                label: componentLabel,
                checked: checkboxvalue,
                ComponentId: componentID,
                selectedCheckbox: selectedCheckbox,
                onChange: (value) {
                  setState(() {
                    checkboxvalue = value!;
                    bool found = false;
                    for (int k = 0; k < selectedCheckbox.length; k++) {
                      if (selectedCheckbox[k].ComponentId == componentID) {
                        selectedCheckbox[k].selected = value;
                        found = true;
                      }
                    }
                    if (!found) {
                      selectedCheckbox.add(CheckboxModel(componentID, value));
                    }
                    String selectedvalue = "0";
                    if (value) {
                      selectedvalue = "1";
                    }
                    var compenentModel = ComponentModel(
                        componentID,
                        selectedvalue,
                        i.toString(),
                        componentType,
                        sectionId,
                        isMandatory,
                        componentLabel,
                        selectedvalue,
                        "6",
                        parentField,
                        dependencyField,
                        parentDependency,
                        iflistFld,
                        "");
                    updateDynamicComponentDynamic(compenentModel);
                  });
                }));
            break;

          case "7": //label
            if (isFieldShow) {
              listings.add(txt_label_mandatory(
                  componentLabel, Colors.black, 14.0, false));
              print("formulaDependency_inti" + formulaDependency.toString());
              // formulaDependency='{C0263}*{C0264}';
              double labelvalue = 0.0;

              List<String> formdeps;

              if (formulaDependency != '') {
                formulaDependency = formulaDependency.replaceAll("{", "");
                formulaDependency = formulaDependency.replaceAll("}", "");

                for (int k = 0; k < componentidvalue.length; k++) {
                  if ((componentidvalue[k].type != "7") ||
                      (componentidvalue[k].type == "7" &&
                          componentidvalue[k].value != '0.00')) {
                    print('shhhhh--' +
                        componentidvalue[k].componentid +
                        '-' +
                        componentidvalue[k].value);

                    formulaDependency = formulaDependency.replaceAll(
                        componentidvalue[k].componentid,
                        componentidvalue[k].value);
                  }
                }
                print('formulaDependency--' + formulaDependency);

                String parsedString = '';
                if (formulaDependency.isNotEmpty) {
                  parsedString = parseFormula(formulaDependency);
                  print('parsedString' + parsedString.toString());
                }

                List<String> listAfterParsing = [];

                if (parsedString.isNotEmpty) {
                  listAfterParsing = parsedString.split(',');
                  print('listAfterParsing' + listAfterParsing!.toString());
                }

                if (listAfterParsing.isNotEmpty) {
                  for (int i = 0; i < listAfterParsing.length; i++) {
                    if (listAfterParsing[i].contains('C') ||
                        listAfterParsing[i].contains("Infinity")) {
                      formulaDependency = formulaDependency.replaceAll(
                          listAfterParsing[i], '0.0');
                    }
                  }
                }
                print('formulaDependencyFinal' + formulaDependency!.toString());

                String evalres = "0.0";

                if ((!formulaDependency.contains("C")) &&
                    (!formulaDependency.contains("Infinity"))) {
                  try {
                    Expression exp = Expression(formulaDependency);
                    evalres = exp.eval().toString();
                  } catch (e) {
                    print('-----' + e.toString());
                  }
                }

                labelvalue = double.parse(evalres);
                if (componentID == "K014") {
                  labelvalue = double.parse(evalres).roundToDouble();
                }
                if (componentID == "C017") {
                  labelvalue =
                      double.parse(double.parse(evalres).toStringAsFixed(1));
                }
                if (componentID == "MOR001") {
                  labelvalue = double.parse(evalres).roundToDouble();
                }
                listings.add(cardlable_dynamic(labelvalue.toString()));
              }
              /*List<String> spacenum = teststr.split(' ');
          for(int i=0;i<spacenum.length;i++){
            toast(spacenum[i]);
          }*/
              var compenentModel = ComponentModel(
                  componentID,
                  labelvalue.toString(),
                  i.toString(),
                  componentType,
                  sectionId,
                  isMandatory,
                  componentLabel,
                  labelvalue.toString(),
                  componentType,
                  parentField,
                  dependencyField,
                  parentDependency,
                  iflistFld,
                  "");

              updateDynamicComponentDynamic(compenentModel);
            }

            break;

          case "8": //label
            print("iterationList case8 " + iterationList.length.toString());
            if (iterationList.length > 0) {
              dynamicListValues = [];
              for (int s = 0; s < iterationList.length; s++) {
                print("sectionId case8 " + sectionId);
                print("iterationList[s].Section case8 " +
                    iterationList[s].Section);
                if (sectionId == iterationList[s].Section) {
                  dynamicListValues.add(iterationList[s]);
                }
              }
              if (dynamicListValues.length > 0) {
                // listings.add(addDynamic(
                //     productlist: dynamicListValues, title: componentLabel));
                listings.add(Datatablereg(sectionId));
              }
            }
            break;

          case "9": // multiple dropdown
            if (isFieldShow) {
              if (isMandatory == "1") {
                listings.add(txt_label_mandatory(
                    componentLabel, Colors.black, 14.0, false));
              } else {
                listings
                    .add(txt_label(componentLabel, Colors.black, 14.0, false));
              }
              List<DropdownMenuItem> multipleItemList = [];

              List<UImodel> multipleModel = [];
              List dropdownlist = [];

              dropdownlist = getDropValues(
                  componentType, catalogValueId, valueDependency, parentField);
              multipleModel = [];

              for (int i = 0; i < dropdownlist.length; i++) {
                String propertyValue = dropdownlist[i].property_value;
                String DISPSEQ = dropdownlist[i].DISP_SEQ;
                var uimodel = new UImodel(propertyValue, DISPSEQ);
                multipleModel.add(uimodel);

                setState(() {
                  multipleItemList.add(DropdownMenuItem(
                    child: Text(propertyValue),
                    value: propertyValue,
                  ));
                });
              }

              /*      var catcode = catalogValueId.split('|');
              if (catcode[1]== "1") {
                if (valueDependency == "1") {
                  dropdownlistMaster = getDropValues(componentType, catalogValueId,valueDependency,parentField);
                  for (int jj = 0; jj < dropdownlistMaster.length; jj++) {
                    String propertyValue = dropdownlistMaster[jj].property_value;
                    String DISPSEQ = dropdownlistMaster[jj].DISP_SEQ;
                    var uimodel = new UImodel(propertyValue, DISPSEQ);
                    multipleModel.add(uimodel);
                    setState(() {
                      multipleItemList.add(DropdownMenuItem(
                        child: Text(propertyValue),
                        value: propertyValue,
                      ));
                    });
                    print("propertyValueADDDD"+propertyValue.toString());
                  }
                }
              }*/

              for (int i = 0; i < selectedList.length; i++) {
                if (componentID == selectedList[i].ComponentId) {
                  print('selectedvalues100000' +
                      selectedList[i].selected.toString());

                  //selectedList[i].selected = [];
                }
              }
              listings.add(multisearchDropdownDynamic(
                  itemlist: multipleItemList,
                  selectedlist: selectedList,
                  componentId: componentID,
                  onChanged: (item) {
                    setState(() {
                      /*if (componentID == "C0629") {
                        selectedList.clear();
                      }*/
                      bool found = false;
                      for (int i = 0; i < item.length; i++) {
                        if (item[i] == "None of above") {
                          item.clear();
                          item.add("None of above");
                          print('selectedITEMS cleared');
                        }
                      }

                      for (int f = 0; f < selectedList.length; f++) {
                        if (selectedList[f].ComponentId == componentID) {
                          found = true;
                          selectedList[f].selected = item;
                        }
                      }
                      if (!found) {
                        selectedList.add(MutipleDropDownModel(
                            componentID, componentLabel, item));
                      }

                      //  toast(selectedList.length.toString());
                      String selectedvalues = '';
                      //toast(item.length.toString());
                      print("itemlengthvalue:" + item.length.toString());
                      if (item.isNotEmpty) {
                        for (int i = 0; i < item.length; i++) {
                          String value = multipleModel[i].value;
                          String text = item[i].toString();
                          for (int j = 0; j < multipleModel.length; j++) {
                            if (multipleModel[j].name == text) {
                              if (selectedvalues == '') {
                                selectedvalues = multipleModel[j].value;
                              } else {
                                selectedvalues = selectedvalues +
                                    ',' +
                                    multipleModel[j].value;
                              }
                            }
                          }
                        }
                      } else {}

                      print("selectedvaluesmultiple " +
                          selectedvalues +
                          " " +
                          iflistFld);

                      var compenentModel = new ComponentModel(
                          componentID,
                          selectedvalues,
                          i.toString(),
                          componentType,
                          sectionId,
                          isMandatory,
                          componentLabel,
                          selectedList[0].selected.toString(),
                          "9",
                          parentField,
                          dependencyField,
                          parentDependency,
                          iflistFld,
                          "");
                      updateDynamicComponentDynamic(compenentModel);
                      if (selectedvalues == '' || selectedvalues == "") {
                        print('selectedvalues removed ' + componentID);
                        for (int c = 0; c < componentidvalue.length; c++) {
                          if (componentidvalue[c].parentField == componentID) {
                            componentidvalue.removeAt(c);
                          }
                        }
                        componentidvalue.removeWhere(
                            (element) => element.componentid == componentID);
                      } else {
                        print(
                            'selectedvalues  selectedvalues ' + selectedvalues);
                        List<String> selectedValues = selectedvalues.split(",");

                        for (int c = 0; c < componentidvalue.length; c++) {
                          if (componentidvalue[c].parentField == componentID) {
                            bool presentvalues = false;
                            for (int s = 0; s < selectedValues.length; s++) {
                              print('selectedvalues4 ' +
                                  selectedValues[s] +
                                  ' ' +
                                  componentidvalue[c].parentDependency);
                              if (selectedValues[s] ==
                                  componentidvalue[c].parentDependency) {
                                presentvalues = true;
                              }
                            }
                            if (!presentvalues) {
                              print('selectedvalues4  removing ' +
                                  c.toString() +
                                  " " +
                                  componentidvalue[c].selectedName);
                              componentidvalue.removeAt(c);
                            } else {}
                          }
                        }
                      }

                      //Refresh child value
                      print('parentField: $componentID');
                      print('depentField: $dependencyField');

                      selectedList.removeWhere(
                          (element) => element.ComponentId == dependencyField);
                    });
                  },
                  Label: "Search Option"));
            }
            break;

          case "12": //photo
            if (isFieldShow) {
              if (isMandatory == "1") {
                listings.add(txt_label_mandatory(
                    componentLabel, Colors.black, 14.0, false));
              } else {
                listings
                    .add(txt_label(componentLabel, Colors.black, 14.0, false));
              }
              //getLocation();
              //final now = new DateTime.now();
              //pcTime = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
              if (txnTypeId == "2026" || txnTypeId == "2027") {
                Future getMultipleImage(
                    String componentID, int photoType) async {
                  var image;
                  if (photoType == 1) {
                    image = await ImagePicker.platform.pickImage(
                        source: ImageSource.gallery, imageQuality: 50);

                    setState(() {
                      getLocation();
                      final now = new DateTime.now();
                      pcTime = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
                      File _beneficiaryimage = File(image!.path);

                      String pht = "";
                      if (_beneficiaryimage != null) {
                        pht = _beneficiaryimage!.path;
                      } else {
                        pht = "";
                      }
                      multipleImageList.add(MultipleImageModel(
                          componentType,
                          componentID,
                          _beneficiaryimage,
                          sectionId,
                          ImageLat,
                          ImageLng,
                          pcTime,
                          listID,
                          photoType,
                          false));
                    });
                  } else {
                    image = await ImagePicker.platform.pickImage(
                        source: ImageSource.camera, imageQuality: 50);

                    setState(() {
                      getLocation();
                      final now = new DateTime.now();
                      pcTime = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
                      File _beneficiaryimage = File(image!.path);

                      String pht = "";
                      if (_beneficiaryimage != null) {
                        pht = _beneficiaryimage!.path;
                      } else {
                        pht = "";
                      }

                      multipleImageList.add(MultipleImageModel(
                          componentType,
                          componentID,
                          _beneficiaryimage,
                          sectionId,
                          ImageLat,
                          ImageLng,
                          pcTime,
                          listID,
                          photoType,
                          true));
                    });
                  }
                }

                imageDialog(String componentID) {
                  var alertStyle = AlertStyle(
                    animationType: AnimationType.grow,
                    overlayColor: Colors.black87,
                    isCloseButton: true,
                    isOverlayTapDismiss: true,
                    titleStyle:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    descStyle:
                        TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
                    animationDuration: Duration(milliseconds: 400),
                  );

                  Alert(
                      context: context,
                      style: alertStyle,
                      title: "Pick Image",
                      desc: "Choose",
                      buttons: [
                        DialogButton(
                          child: Text(
                            "Gallery",
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                          onPressed: () {
                            setState(() {
                              getMultipleImage(componentID, 1);
                              Navigator.pop(context);
                            });
                          },
                          color: Colors.deepOrange,
                        ),
                        DialogButton(
                          child: Text(
                            "Camera",
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                          onPressed: () {
                            getMultipleImage(componentID, 2);
                            Navigator.pop(context);
                          },
                          color: Colors.green,
                        )
                      ]).show();
                }

                void ondeletemultiple(int position) {
                  if (multipleImageList.length != 0) {
                    setState(() {
                      //multipleImageList
                      //.removeWhere((element) => element.image.path == position.path);
                      multipleImageList.removeAt(position);
                    });
                  }
                }

                /* void ondeletemultiple(int position, String path) {
                if (multipleImageList.isNotEmpty) {
                  multipleImageList
                      .removeWhere((element) => element.image.path == path);
                  setState(() {});
                }
              }*/

                listings.add(multipleImage_picker_dynamic(
                    dialogContext: context,
                    onPressed: imageDialog,
                    ondelete: ondeletemultiple,
                    imagelist: multipleImageList,
                    ComponentID: componentID));

                /*     listings.add(multipleImage_picker_dynamic(
                  dialogContext: context,
                  onPressed: getMultipleImage,
                  ondelete: ondeletemultiple,
                  imagelist: multipleImageList,
                  ComponentID: componentID));*/

                setState(() {
                  String imageList = "";
                  if (listID == "" || listID.length > 0) {
                    imageList = "N";
                  }
                  var imageModeldyn = new ImageModeldynamic(
                      componentID,
                      i.toString(),
                      componentType,
                      sectionId,
                      ImageLat,
                      ImageLng,
                      pcTime,
                      imageList);
                  updateDynamicComponentImageNew(
                      imageModeldyn, multipleImageList);

                  // String lattlon = ImageLat.toString() + " ,SS " + ImageLng.toString();

                  for (int c = 0; c < multipleImageList.length; c++) {
                    if (multipleImageList[c].componentID == componentID) {
                      listings.add(txt_label_mandatory(
                          "Capture Time: ", Colors.black, 14.0, false));
                      listings
                          .add(cardlable_dynamic(multipleImageList[c].pcTime));
                      listings.add(txt_label_mandatory(
                          "Image Latitude & Longitude: ",
                          Colors.black,
                          14.0,
                          false));
                      listings.add(cardlable_dynamic(
                          multipleImageList[c].ImageLat +
                              "," +
                              multipleImageList[c].ImageLng));

                      print('PhotoSelected');
                    }
                  }
                });
              } else {
                Future getMultipleImage(String componentID) async {
                  var image = await ImagePicker.platform
                      .pickImage(source: ImageSource.camera, imageQuality: 50);
                  setState(() {
                    getLocation();
                    final now = new DateTime.now();
                    pcTime = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
                    File _beneficiaryimage = File(image!.path);
                    multipleImageList.add(MultipleImageModel(
                        componentType,
                        componentID,
                        _beneficiaryimage,
                        sectionId,
                        ImageLat,
                        ImageLng,
                        pcTime,
                        listID,
                        2,
                        true));
                  });
                }

                print("multiimageList:" + multipleImageList.toString());

                void ondeletemultiple(int position) {
                  if (multipleImageList.length != 0) {
                    setState(() {
                      print("positionval:" + position.toString());
                      multipleImageList.removeAt(position);
                    });
                  }
                }

                listings.add(multipleImage_picker_dynamic(
                    dialogContext: context,
                    onPressed: getMultipleImage,
                    ondelete: ondeletemultiple,
                    imagelist: multipleImageList,
                    ComponentID: componentID));

                /* listings.add(Container(child: Image.file(File('/data/user/0/com.sts.datagreen.ucda/cache/scaled_e9ec5d35-ee5d-4759-aa79-eebe428be2367477061079366783780.jpg')),height: 100,width: 100,));
*/
                setState(() {
                  String imageList = "";
                  if (listID == "" || listID.length > 0) {
                    imageList = "N";
                  }
                  var imageModeldyn = new ImageModeldynamic(
                      componentID,
                      i.toString(),
                      componentType,
                      sectionId,
                      ImageLat,
                      ImageLng,
                      pcTime,
                      imageList);
                  updateDynamicComponentImageNew(
                      imageModeldyn, multipleImageList);

                  // String lattlon = ImageLat.toString() + " ,SS " + ImageLng.toString();

                  for (int c = 0; c < multipleImageList.length; c++) {
                    if (multipleImageList[c].componentID == componentID) {
                      listings.add(txt_label_mandatory(
                          "Capture Time: ", Colors.black, 14.0, false));
                      listings
                          .add(cardlable_dynamic(multipleImageList[c].pcTime));
                      listings.add(txt_label_mandatory(
                          "Image Latitude & Longitude: ",
                          Colors.black,
                          14.0,
                          false));
                      listings.add(cardlable_dynamic(
                          multipleImageList[c].ImageLat +
                              "," +
                              multipleImageList[c].ImageLng));
                    }
                  }

                  /*  var compenentModel = new ComponentModel(
                    componentID,
                    lattlon,
                    i.toString(),
                    componentType,
                    sectionId,
                    isMandatory,
                    componentLabel,
                    lattlon,
                    "12",
                    parentField,
                    dependencyField,
                    parentDependency,
                    pcTime.toString());
                updateDynamicComponentDynamic(compenentModel);*/

                  /*listings.add(txt_label_mandatory(
                    "Capture Time: ", Colors.black, 14.0, false));
                listings.add(cardlable_dynamic(pcTime.toString()));
                */
                });
              }
            }
            break;

          case "14": //weather info
            if (isFieldShow) {
              if (isMandatory == "1") {
                listings.add(txt_label_mandatory(
                    componentLabel, Colors.black, 14.0, false));
              } else if (isMandatory == "0") {
                listings
                    .add(txt_label(componentLabel, Colors.black, 14.0, false));
              }
              //temp
              listings.add(const SizedBox(
                height: 5,
              ));

              listings.add(Row(
                children: [
                  const Expanded(
                    flex: 1,
                    child: Text(
                      'Temperature:',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(
                      temp + ' ' + '\u2103',
                      style: const TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.bold),
                    ),
                  )
                ],
              ));

              //rain
              listings.add(const SizedBox(
                height: 5,
              ));

              listings.add(Row(
                children: [
                  const Expanded(
                    flex: 1,
                    child: Text(
                      'Rain:',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(
                      rain + ' mm',
                      style: const TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.bold),
                    ),
                  )
                ],
              ));

              //humidity
              listings.add(const SizedBox(
                height: 5,
              ));

              listings.add(Row(
                children: [
                  const Expanded(
                    flex: 1,
                    child: Text(
                      'Humidity:',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(
                      humidity + ' %',
                      style: const TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.bold),
                    ),
                  )
                ],
              ));

              //Wind-speed
              listings.add(const SizedBox(
                height: 5,
              ));

              listings.add(Row(
                children: [
                  const Expanded(
                    flex: 1,
                    child: Text(
                      'Wind Speed:',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(
                      speed + ' m/s',
                      style: const TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.bold),
                    ),
                  )
                ],
              ));
            }
            break;

          case "15": // Area geo-plotting
            if (isFieldShow) {
              if (isMandatory == "1") {
                listings.add(txt_label_mandatory(
                    componentLabel, Colors.black, 14.0, false));
              } else if (isMandatory == "0") {
                listings
                    .add(txt_label(componentLabel, Colors.black, 14.0, false));
              }

              /*int len1 = componentidvalue.length;
                  if (len1 > 0) {
                  for (int d = 0; d < componentidvalue.length; d++) {
                    if(componentID==componentidvalue[d].parentField){
                    componentidvalue.removeWhere((element) => element.parentField == componentID);
                    }
                  }
              }*/

              String hints = "";
              bool initial = false;
              String len = componentidvalue.length.toString();
              if (int.parse(len) > 0) {
                for (int c = 0; c < int.parse(len); c++) {
                  if (componentID == componentidvalue[c].componentid) {
                    hints = componentidvalue[c].value;
                    initial = true;
                  }
                }
              } else {
                hints = "";
                initial = false;
              }

              if (validationType == '2') {
                TextEditingController? controller9 = TextEditingController();

                listings.add(txtfield_digitswithoutdecimalandController(
                    intialVal: hints,
                    initial: initial,
                    length: length,
                    hint: componentLabel,
                    txtcontroller: controller9,
                    focus: true,
                    Position: i.toString(),
                    componentType: componentType,
                    sectionId: sectionId,
                    isMandatory: isMandatory,
                    componentLabel: componentLabel,
                    Type: "1",
                    componentidvalue: componentidvalue,
                    componentid: componentID,
                    onChange: (text) {
                      print("txtfieldController " + componentID + " : " + text);
                      //  toast("txtfieldController "+componentID+" : "+text);
                      //componentidvalue.add(ComponentModel(componentID, text, i.toString(), componentType, sectionId, isMandatory, componentLabel, text, componentType,parentField,parentDependency));
                      componentidvalue = takeNumber(
                          text,
                          componentID,
                          i.toString(),
                          componentType,
                          sectionId,
                          isMandatory,
                          componentLabel,
                          "1",
                          componentidvalue,
                          componentidvalue_Label,
                          parentField,
                          dependencyField,
                          parentDependency,
                          iflistFld);
                      setState(() {});
                    }));
              } else if (validationType == '4') {
                TextEditingController? controller9 = TextEditingController();

                listings.add(txtfield_digitswithdecimalandController(
                    intialVal: hints,
                    initial: initial,
                    length: length,
                    minlength: minLengthval,
                    hint: componentLabel,
                    txtcontroller: controller9,
                    focus: true,
                    Position: i.toString(),
                    componentType: componentType,
                    sectionId: sectionId,
                    isMandatory: isMandatory,
                    componentLabel: componentLabel,
                    Type: "1",
                    componentidvalue: componentidvalue,
                    componentid: componentID,
                    onChange: (text) {
                      print("txtfieldController " + componentID + " : " + text);
                      //  toast("txtfieldController "+componentID+" : "+text);
                      //componentidvalue.add(ComponentModel(componentID, text, i.toString(), componentType, sectionId, isMandatory, componentLabel, text, componentType,parentField,parentDependency));
                      componentidvalue = takeNumber(
                          text,
                          componentID,
                          i.toString(),
                          componentType,
                          sectionId,
                          isMandatory,
                          componentLabel,
                          "1",
                          componentidvalue,
                          componentidvalue_Label,
                          parentField,
                          dependencyField,
                          parentDependency,
                          iflistFld);
                      setState(() {});
                    }));
              } else {
                print("validationTypeelse" +
                    validationType.toString() +
                    " " +
                    componentID +
                    " " +
                    componentLabel);
                TextEditingController? controller9 = TextEditingController();

                String val = "";
                //listings.add(txtfield_dynamicWothoutcontroller(componentLabel, componentID, true, i.toString(), componentType, sectionId,isMandatory, componentLabel,"1",componentidvalue));
                listings.add(txtfield_dynamicWothoutcontroller(
                    intialVal: hints,
                    length: length,
                    initial: initial,
                    hint: componentLabel,
                    txtcontroller: controller9,
                    focus: true,
                    Position: i.toString(),
                    componentType: componentType,
                    sectionId: sectionId,
                    isMandatory: isMandatory,
                    componentLabel: componentLabel,
                    Type: "1",
                    componentID: componentID,
                    componentidvalue: componentidvalue,
                    onChange: (text) {
                      //componentidvalue.add(ComponentModel(componentID, text, i.toString(), componentType, sectionId, isMandatory, componentLabel, text, componentType,parentField,parentDependency));
                      componentidvalue = takeNumber(
                          text,
                          componentID,
                          i.toString(),
                          componentType,
                          sectionId,
                          isMandatory,
                          componentLabel,
                          "1",
                          componentidvalue,
                          componentidvalue_Label,
                          parentField,
                          dependencyField,
                          parentDependency,
                          iflistFld);
                      print('componentidvaluelength ' +
                          componentID +
                          ' ' +
                          componentidvalue.length.toString() +
                          ' ' +
                          text);
                    }));
              }
              /* controller1.addListener(() {
                    final text = controller1.text;
                    var compenentModel = new ComponentModel(componentID, text, i.toString(), componentType, sectionId,isMandatory, componentLabel, text, "1");
                    updateDynamicComponentDynamic(compenentModel);
                });*/
            }
            listings.add(btn_dynamic(
                label: "Area",
                bgcolor: Colors.green,
                txtcolor: Colors.white,
                fontsize: 18.0,
                centerRight: Alignment.centerRight,
                margin: 10.0,
                btnSubmit: () async {
                  TextEditingController? controller9 = TextEditingController();
                  bool farmdataadded = await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => geoploattingaddFarm(1)));
                  setState(() {
                    if (farmdataadded) {
                      controller9.text = addFarmdata!.Hectare;
                      if (Geoploattingaddfarmlist.length > 0) {
                        latitudeController.text =
                            Geoploattingaddfarmlist[0].latitude;
                        longtitudeController.text =
                            Geoploattingaddfarmlist[0].longitude;
                      }
                    } else {
                      controller9.text = hectareAre;
                    }

                    componentidvalue = takeNumber(
                        controller9.text,
                        componentID,
                        i.toString(),
                        componentType,
                        sectionId,
                        isMandatory,
                        componentLabel,
                        "1",
                        componentidvalue,
                        componentidvalue_Label,
                        parentField,
                        dependencyField,
                        parentDependency,
                        iflistFld);
                    print('componentidvaluelength ' +
                        componentID +
                        ' ' +
                        componentidvalue.length.toString() +
                        ' ' +
                        controller9.text);
                  });
                }));
            break;

          case "16": //Signature
            if (isFieldShow) {
              if (isMandatory == "1") {
                listings.add(txt_label_mandatory(
                    componentLabel, Colors.black, 14.0, false));
              } else {
                listings
                    .add(txt_label(componentLabel, Colors.black, 14.0, false));
              }

              listings.add(btn_dynamic(
                  label: "Signature",
                  bgcolor: Colors.green,
                  txtcolor: Colors.white,
                  fontsize: 18.0,
                  centerRight: Alignment.centerRight,
                  margin: 10.0,
                  btnSubmit: () async {
                    setState(() {
                      signdynClicked = true;
                      FocusScope.of(context).requestFocus(FocusNode());
                    });
                  }));

              if (signdynClicked) {
                listings.add(signaturePad(
                  _sign,
                  _img,
                  encoded,
                  clearSign,
                  getSign,
                ));
              }

              if (signImg != null) {
                listings.add(Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    LimitedBox(
                        maxHeight: 250.0,
                        child: Image.memory(
                          signImg!,
                          filterQuality: FilterQuality.medium,
                        )),
                  ],
                ));
              }

              print("signImg" + signImg.toString());
              var compenentModel = ComponentModel(
                  componentID,
                  encoded,
                  i.toString(),
                  componentType,
                  sectionId,
                  isMandatory,
                  componentLabel,
                  encoded,
                  "16",
                  parentField,
                  dependencyField,
                  parentDependency,
                  iflistFld,
                  "");

              updateDynamicComponentDynamic(compenentModel);
            }
            break;

          case "10": //Button
            if (isFieldShow) {
              listings.add(btn_dynamic(
                  label: '+',
                  bgcolor: Colors.green,
                  txtcolor: Colors.white,
                  fontsize: 18.0,
                  centerRight: Alignment.centerRight,
                  margin: 10.0,
                  btnSubmit: () async {
                    try {
                      List dynamiccomponent2List = await db.RawQuery(
                          "select distinct ifListNo,referenceId,sectionId from dynamiccomponentFields where componentID = \'" +
                              componentID +
                              "\'");
                      print('ValidationCheck1' +
                          dynamiccomponent2List.toString());

                      List<MandatoryModel> MandatoryComponent = [];
                      bool validationpending = false;
                      if (dynamiccomponent2List.length > 0) {
                        String isList = dynamiccomponent2List[0]['ifListNo'];
                        String ListNo = dynamiccomponent2List[0]['referenceId'];
                        List listMandatorys = await db.RawQuery(
                            "select distinct componentLabel,componentType,sectionId,componentID,parentDependency,parentField from dynamiccomponentFields where sectionId = \'" +
                                sectionId +
                                "\'");
                        print('ValidationCheck ' + listMandatorys.toString());

                        for (int v = 0; v < listMandatorys.length; v++) {
                          String compLabel =
                              listMandatorys[v]['componentLabel'];
                          String sectionIdlist = listMandatorys[v]['sectionId'];

                          int compTyp = listMandatorys[v]['componentType'];
                          String compID = listMandatorys[v]['componentID'];
                          String parentDependency =
                              listMandatorys[v]['parentDependency'];
                          String parentField = listMandatorys[v]['parentField'];

                          print('ValidationCheck ' +
                              compLabel.toString() +
                              ' ' +
                              compTyp.toString());
                          if (compTyp == 8) {
                          } else if (compTyp == 10) {
                            if (dynamiccomponent2List[0]['sectionId'] ==
                                sectionIdlist) {}
                          } else {
                            if (parentDependency != "" && parentField != "") {
                              for (int dx = 0;
                                  dx < componentidvalue.length;
                                  dx++) {
                                if (parentField ==
                                        componentidvalue[dx].componentid &&
                                    parentDependency ==
                                        componentidvalue[dx].value) {
                                  MandatoryComponent.add(
                                      MandatoryModel(compID, compLabel));
                                }
                              }
                            } else {
                              MandatoryComponent.add(
                                  MandatoryModel(compID, compLabel));
                            }
                          }
                        }

                        bool loopclose = false;
                        for (int dy = 0; dy < MandatoryComponent.length; dy++) {
                          bool validated = false;

                          for (int dx = 0; dx < componentidvalue.length; dx++) {
                            if (MandatoryComponent[dy].ComponentId ==
                                componentidvalue[dx].componentid) {
                              validated = true;
                            }
                          }
                          if (!loopclose && !validated) {
                            validationpending = true;
                            errordialog(
                                context,
                                "Information",
                                MandatoryComponent[dy].ComponentLabel +
                                    " Should not be empty");
                            loopclose = true;
                          }
                        }
                      }

                      List dynamiccomponentList = await db.RawQuery(
                          "select listId from dynamiccomponentList where sectionId = \'" +
                              sectionId +
                              "\'");
                      print('dynamiccomponentList ' +
                          "select listId from dynamiccomponentList where sectionId = \'" +
                          sectionId +
                          "\'");

                      print("res " + dynamiccomponentList.toString());
                      String listid = dynamiccomponentList[0]["listId"];
                      print("res:" + listid);

                      if (!validationpending) {
                        int iteration = 1;
                        print("validationpending iterationList " +
                            iterationList.length.toString());

                        if (iterationList.length != 0) {
                          List<String> dummylist = [];
                          for (int i = 0; i < iterationList.length; i++) {
                            if (iterationList[i].ListId == listid) {
                              dummylist.add(iterationList[i].iTeration);
                            }
                            iteration =
                                int.parse(iterationList[i].iTeration) + 1;
                            SharedPreferences prefs =
                                await SharedPreferences.getInstance();
                            prefs.setString(
                                "iterationIdDyn", iteration.toString());
                          }
                        }

                        String dropDownvalue = "";
                        String textControllerValue = "";
                        String listCompination = "";
                        for (int c = 0; c < componentidvalue.length; c++) {
                          if (sectionId == componentidvalue[c].Section) {
                            String FieldId = componentidvalue[c].componentid;
                            String fieldLabel = componentidvalue[c].value;
                            String FieldVal = componentidvalue[c].value;
                            String componentTypeloc =
                                componentidvalue[c].ComponentType;
                            String ArrayName = "";
                            String listID = listid;
                            String blockId = "";
                            String listHeading = "";

                            /* if (dropDownvalue == '') {
                              if (componentidvalue[c].type == "2") {
                                dropDownvalue = fieldLabel;
                              }
                            } else {
                              dropDownvalue = dropDownvalue + "/" + fieldLabel;
                            }*/

                            if (textControllerValue == '') {
                              if (componentidvalue[c].type == "1") {
                                textControllerValue = fieldLabel;
                              } else if (componentidvalue[c].type == "4") {
                                textControllerValue =
                                    componentidvalue[c].selectedName;
                              }
                            } else {
                              if (componentidvalue[c].type == "1") {
                                textControllerValue =
                                    textControllerValue + "/" + fieldLabel;
                              } else if (componentidvalue[c].type == "4") {
                                textControllerValue = textControllerValue +
                                    "/" +
                                    componentidvalue[c].selectedName;
                              }
                            }

                            // if (componentidvalue[c].isPrimaryField == "1") {
                            //   if (listCompination.isEmpty) {
                            //     listCompination = componentidvalue[c].value;
                            //   } else {
                            //     listCompination = listCompination + "-" +
                            //         componentidvalue[c].value;
                            //   }
                            // }

                            Future<int> res = db.SaveDynamicListValue(
                                FieldId,
                                FieldVal,
                                fieldLabel,
                                ArrayName,
                                listID,
                                blockId,
                                listHeading,
                                iteration.toString(),
                                sectionId,
                                componentTypeloc,
                                recordNo.isEmpty ? revNo : recordNo,
                                txnTypeId,
                                fieldLabel,
                                "1");

                            print("res" + res.toString());
                          }
                        }

                        List listDataRemoval = await db.RawQuery(
                            "select distinct componentLabel,componentType,sectionId,componentID from dynamiccomponentFields where catDepKey='' and sectionId = \'" +
                                sectionId +
                                "\'");
                        print('ValidationCheck ' + listDataRemoval.toString());

                        for (int v = 0; v < listDataRemoval.length; v++) {
                          String compLabel =
                              listDataRemoval[v]['componentLabel'];
                          String sectionIdlist =
                              listDataRemoval[v]['sectionId'];

                          int compTyp = listDataRemoval[v]['componentType'];
                          String compID = listDataRemoval[v]['componentID'];

                          print('ValidationCheck ' +
                              compLabel.toString() +
                              compTyp.toString());
                          if (compTyp == 8) {
                          } else if (compTyp == 10) {
                            if (dynamiccomponent2List[0]['sectionId'] ==
                                sectionIdlist) {
                              //MandatoryComponent.add(
                              // MandatoryModel(compID, compLabel));
                              // print('MandatoryComponentCheck ' + MandatoryComponent
                              //  .toString());
                            }
                          } else {
                            for (int r = 0; r < componentidvalue.length; r++) {
                              if (componentidvalue[r].componentid == compID) {
                                print('compTyp ' + compTyp.toString());

                                if (compTyp == 3) {
                                  //removing date
                                  for (int dt = 0; dt < Dates.length; dt++) {
                                    if (Dates[dt].ComponentId == compID) {
                                      setState(() {
                                        Dates.removeAt(dt);
                                      });
                                    }
                                  }
                                } else if (compTyp == 1) {
                                  // controller
                                  componentidvalue.removeAt(r);
                                } else if (compTyp == 2) {
                                  //multiple radio button

                                  for (int dt = 0;
                                      dt < multipleRadioList.length;
                                      dt++) {
                                    if (multipleRadioList[dt].componentID ==
                                        compID) {
                                      setState(() {
                                        multipleRadioList.removeAt(dt);
                                      });
                                    }
                                  }
                                } else if (compTyp == 4) {
                                  // dropdown
                                  componentidvalue.removeAt(r);
                                }
                              }
                            }
                          }
                        }

                        //dropdownclear();
                        if (iterationList.length == 0) {
                          setState(() {
                            print("listidvalue1:" + listid);
                            lstmd = ListModel(listid, iteration.toString(),
                                sectionId, dropDownvalue, textControllerValue);
                            listAddedFunction(lstmd);
                            savePartialData(
                                recordNo,
                                listid,
                                iteration,
                                sectionId,
                                dropdownValue,
                                textControllerValue,
                                revNo);
                          });
                        } else {
                          bool val = false;
                          for (int k = 0; k < iterationList.length; k++) {}
                          if (val) {
                            errordialog(
                                context, "Information", "Item Already Exist");
                          } else {
                            setState(() {
                              print("listidvalue2:" + listid);

                              lstmd = ListModel(
                                  listid,
                                  iteration.toString(),
                                  sectionId,
                                  dropDownvalue,
                                  textControllerValue);
                              listAddedFunction(lstmd);
                              savePartialData(
                                  recordNo,
                                  listid,
                                  iteration,
                                  sectionId,
                                  dropdownValue,
                                  textControllerValue,
                                  revNo);
                            });
                          }
                        }

                        /*if (addbtnclicked == false) {
                            if (componentidvalue.length > 0) {
                              dropdownclear();
                            }
                        }*/
                        /*for (int i = 0; i < iterationList.length; i++) {
                          print("iterationListLabel" + iterationList[i].Label);
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
                        });*/
                      } else {
                        //errordialog(context, "Information", "Mandatory Fields should not be empty");
                      }
                    } catch (e) {}
                  }));
            }
            break;
        }
      }

      listings.add(Row(
        children: [
          txnTypeId == "2026" || txnTypeId == "2027"
              ? Expanded(
                  flex: 1,
                  child: Container(
                    padding: EdgeInsets.all(3),
                    child: MaterialButton(
                      onPressed: () {
                        draftSubmit();
                      },
                      color: Colors.orange,
                      child: const Text(
                        'Save Draft',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),
                  ),
                )
              : Container(),
          Expanded(
            flex: 1,
            child: Container(
              padding: const EdgeInsets.all(3),
              child: MaterialButton(
                child: const Text(
                  'Submit',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
                color: Colors.green,
                onPressed: () {
                  try {
                    Future<void> listValidation() async {
                      print('List Athi enter ');
                      if (int.parse(ListCount!) > 0) {
                        bool validation = true;
                        for (int k = 0; k < listcounts!.length; k++) {
                          String listId = listcounts![k]['listId'];
                          String secName = listcounts![k]['secName'];
                          String sectionId = listcounts![k]['sectionId'];
                          bool listfound = false;

                          for (int sw = 0; sw < iterationList.length; sw++) {
                            String LISTID = iterationList[sw].ListId;
                            if (LISTID == listId) {
                              listfound = true;
                            } /*else if (int.parse(ListCount!) > 0) {
                                  errordialog(context, "Information",
                                    secName + " cannot be empty");
                                  validation = false;
                              }*/
                          }
                          /*if (int.parse(ListCount!) > 0 &&
                              iterationList.length == 0) {
                            errordialog(context, "Information",
                                secName + " cannot be empty");
                            validation = false;
                          }*/
                          print('List Athi listId listfound ' +
                              listfound.toString());
                          if (!listfound) {
                            List dynamiccomponent2List = await db.RawQuery(
                                "select distinct componentID,parentDependency,parentField,isMandatory,ifListNo,referenceId,sectionId from dynamiccomponentFields where sectionId = \'" +
                                    sectionId +
                                    "\' and componentType='8'");
                            print('ValidationCheck1' +
                                dynamiccomponent2List.toString());

                            if (dynamiccomponent2List.length > 0) {
                              bool valueDyn = false;
                              if (dynamiccomponent2List[0]
                                          ['parentDependency'] !=
                                      "" &&
                                  dynamiccomponent2List[0]['parentField'] !=
                                      "") {
                                for (int k = 0;
                                    k < componentidvalue.length;
                                    k++) {
                                  if (componentidvalue[k].componentid ==
                                          dynamiccomponent2List[0]
                                              ['parentField'] &&
                                      componentidvalue[k].value ==
                                          dynamiccomponent2List[0]
                                              ['parentDependency']) {
                                    valueDyn = true;
                                  }
                                }
                              } else {
                                if (dynamiccomponent2List[0]['isMandatory'] ==
                                    1) {
                                  valueDyn = true;
                                }
                              }
                              if (validation && valueDyn) {
                                errordialog(context, "Information",
                                    secName + " cannot be empty");
                                validation = false;
                              }
                            }
                          }
                        }
                        if (validation) {
                          //fieldValidation();
                          alertMessage();
                        }
                      }
                    }

                    Future<void> fieldValidation() async {
                      print("validationvalidation called");
                      try {
                        bool validationpending = false;
                        List<String> componentLabels = [];
                        List<String> validationLabels = [];
                        List<String> parentID = [];
                        List<String> parentdependID = [];
                        int widgetscount = 0;
                        /* List listdynamic = await db.RawQuery(
                            "select * from dynamicListValues");
                        if (listdynamic != null && listdynamic.length > 0) {
                          for (int c = 0; c < componentidvalue.length; c++) {
                            for (int s = 0; s < listdynamic.length; s++) {
                              if (componentidvalue[c].componentid== listdynamic[s]["fieldId"]&&listdynamic[s]["componentType"]==componentidvalue[c].ComponentType) {
                                componentidvalue.removeWhere((ComponentModel) => ComponentModel.componentid == listdynamic[s]["fieldId"]);
                              }
                            }
                          }
                        }*/
                        String isMandatory = '1';
                        String compType = '8';
                        String alreadyAns = '0';
                        String ifListNo = 'N';
                        String ifListYES = 'Y';
                        String qry = '';
                        if (dynamicTxnId == "M37" || dynamicTxnId == "M36") {
                          qry =
                              'select distinct flds.ifListNo,flds.fieldOrder,flds.componentID,flds.maxLength,flds.minLength,flds.referenceId,flds.catalogValueId,flds.componentType,flds.componentLabel,flds.componentID,flds.isMandatory,flds.formulaDependency,flds.dependencyField,flds.validationType,flds.sectionId,flds.parentDependency,flds.parentField,flds.isOther,flds.valueDependency from dynamiccomponentFields as flds where flds.txnTypeId=\'' +
                                  txnTypeId +
                                  '\' and flds.isMandatory=\'' +
                                  isMandatory +
                                  '\' and ( flds.ifListNo = \'' +
                                  ifListNo +
                                  '\'  or (flds.ifListNo = \'' +
                                  ifListYES +
                                  '\' and flds.componentType=\'' +
                                  compType +
                                  '\')) and flds.alreadyAns=\'' +
                                  alreadyAns +
                                  '\' order by flds.fieldOrder asc';
                          print("qry if called");
                        } else {
                          if (txnTypeId == "2005") {
                            qry =
                                'select distinct flds.ifListNo,flds.fieldOrder,flds.componentID,flds.maxLength,flds.minLength,flds.referenceId,flds.catalogValueId,flds.componentType,flds.componentLabel,flds.componentID,flds.isMandatory,flds.formulaDependency,flds.dependencyField,flds.validationType,flds.sectionId,flds.parentDependency,flds.parentField,flds.isOther,flds.valueDependency from dynamiccomponentFields as flds where flds.txnTypeId=\'' +
                                    txnTypeId +
                                    '\' and flds.isMandatory=\'' +
                                    isMandatory +
                                    '\' and ( flds.ifListNo = \'' +
                                    ifListNo +
                                    '\'  or (flds.ifListNo = \'' +
                                    ifListYES +
                                    '\' and flds.componentType=\'' +
                                    compType +
                                    '\')) and flds.actionPlan like "%' +
                                    val_vacCat +
                                    '%" order by flds.fieldOrder asc';
                          } else {
                            qry =
                                'select distinct flds.ifListNo,flds.fieldOrder,flds.componentID,flds.maxLength,flds.minLength,flds.referenceId,flds.catalogValueId,flds.componentType,flds.componentLabel,flds.componentID,flds.isMandatory,flds.formulaDependency,flds.dependencyField,flds.validationType,flds.sectionId,flds.parentDependency,flds.parentField,flds.isOther,flds.valueDependency from dynamiccomponentFields as flds where flds.txnTypeId=\'' +
                                    txnTypeId +
                                    '\' and flds.isMandatory=\'' +
                                    isMandatory +
                                    '\' and ( flds.ifListNo = \'' +
                                    ifListNo +
                                    '\'  or (flds.ifListNo = \'' +
                                    ifListYES +
                                    '\' and flds.componentType=\'' +
                                    compType +
                                    '\')) order by flds.fieldOrder asc';
                          }

                          print("qry else called");
                        }
                        /*String qry =
                            'select distinct flds.ifListNo,flds.fieldOrder,flds.componentID,flds.maxLength,flds.minLength,flds.referenceId,flds.catalogValueId,flds.componentType,flds.componentLabel,flds.componentID,flds.isMandatory,flds.formulaDependency,flds.dependencyField,flds.validationType,flds.sectionId,flds.parentDependency,flds.parentField,flds.isOther,flds.valueDependency,sec.secName from dynamiccomponentFields as flds,dynamiccomponentSections as sec where flds.txnTypeId=\'' +
                                txnTypeId +
                                '\' and isMandatory="1" order by flds.fieldOrder asc';*/
                        print("qry_qry section " + qry.toString());
                        List<Map> dynamiccomponentFieldsSection = [];
                        dynamiccomponentFieldsSection = await db.RawQuery(qry);

                        try {
                          for (int c = 0; c < componentidvalue.length; c++) {
                            if (componentidvalue[c].isMandatory == "1") {
                              idscount = idscount + 1;
                            }
                          }

                          bool parentDyn = false;
                          for (int c = 0;
                              c < dynamiccomponentFieldsSection.length;
                              c++) {
                            bool valueDyn = false;
                            String componentID =
                                dynamiccomponentFieldsSection[c]["componentID"]
                                    .toString();
                            String componentType =
                                dynamiccomponentFieldsSection[c]
                                        ["componentType"]
                                    .toString();
                            String componentLabel =
                                dynamiccomponentFieldsSection[c]
                                        ["componentLabel"]
                                    .toString();
                            String parentDependency =
                                dynamiccomponentFieldsSection[c]
                                        ["parentDependency"]
                                    .toString();
                            String mandatory = dynamiccomponentFieldsSection[c]
                                    ["isMandatory"]
                                .toString();
                            String parentField =
                                dynamiccomponentFieldsSection[c]["parentField"]
                                    .toString();
                            String dependencyField =
                                dynamiccomponentFieldsSection[c]
                                        ["dependencyField"]
                                    .toString();

                            //if (componentLabel == "List") {
                            if (componentType == "8") {
                              print("component 8 called");
                              //parentDyn = true;
                              //listValidation();
                              if (int.parse(ListCount!) > 0) {
                                bool validation = true;
                                for (int k = 0; k < listcounts!.length; k++) {
                                  String listId = listcounts![k]['listId'];
                                  String secName = listcounts![k]['secName'];
                                  String sectionId =
                                      listcounts![k]['sectionId'];
                                  bool listfound = false;

                                  for (int sw = 0;
                                      sw < iterationList.length;
                                      sw++) {
                                    String LISTID = iterationList[sw].ListId;
                                    if (LISTID == listId) {
                                      listfound = true;
                                    }
                                  }
                                  print('List Athi listId listfound ' +
                                      listfound.toString());
                                  if (!listfound) {
                                    List dynamiccomponent2List = await db.RawQuery(
                                        "select distinct componentID,parentDependency,parentField,isMandatory,ifListNo,referenceId,sectionId from dynamiccomponentFields where sectionId = \'" +
                                            sectionId +
                                            "\' and componentType='8'");
                                    print('ValidationCheck1' +
                                        dynamiccomponent2List.toString());

                                    if (dynamiccomponent2List.length > 0) {
                                      bool valueDyn = false;
                                      if (dynamiccomponent2List[0]
                                                  ['parentDependency'] !=
                                              "" &&
                                          dynamiccomponent2List[0]
                                                  ['parentField'] !=
                                              "") {
                                        for (int k = 0;
                                            k < componentidvalue.length;
                                            k++) {
                                          if (componentidvalue[k].componentid ==
                                                  dynamiccomponent2List[0]
                                                      ['parentField'] &&
                                              componentidvalue[k].value ==
                                                  dynamiccomponent2List[0]
                                                      ['parentDependency']) {
                                            valueDyn = true;
                                          }
                                        }
                                      } else {
                                        if (dynamiccomponent2List[0]
                                                ['isMandatory'] ==
                                            1) {
                                          valueDyn = true;
                                        }
                                      }
                                      if (validation && valueDyn) {
                                        validationpending = true;
                                        errordialog(context, "Information",
                                            secName + " cannot be empty");
                                        validation = false;
                                        valueDyn = false;
                                        break;
                                      }
                                    }
                                  }
                                }
                                if (validationpending) {
                                  break;
                                }
                                if (validation) {
                                  //fieldValidation();
                                  //alertMessage();
                                  validationpending = false;
                                }
                              }
                            } else if (componentidvalue.isEmpty &&
                                componentType != "12" &&
                                componentType != "8" &&
                                componentType != "10" &&
                                parentField == "") {
                              for (int k = 0;
                                  k < componentidvalue.length;
                                  k++) {
                                if (componentidvalue[k].componentid ==
                                    componentID) {
                                  valueDyn = true;
                                }
                              }

                              if (!parentDyn && !valueDyn) {
                                bool subparentvalAvail = subparentChecking(
                                    parentDependency, parentField);
                                if (parentDependency != "" &&
                                    parentField != "") {
                                  bool parentvalAvail = parentChecking(
                                      parentField, parentDependency);

                                  if (parentvalAvail) {
                                    validationpending = true;
                                    errordialog(
                                        context,
                                        "Information",
                                        componentLabel +
                                            " Should not be empty");
                                    parentDyn = true;
                                    break;
                                  } else if (subparentvalAvail) {
                                    print("subparentvalidation");
                                    validationpending = true;
                                    errordialog(
                                        context,
                                        "Information",
                                        componentLabel +
                                            " Should not be empty");
                                    parentDyn = true;
                                    break;
                                  }
                                } else if (mandatory == "1") {
                                  validationpending = true;
                                  errordialog(context, "Information",
                                      componentLabel + " Should not be empty");
                                  parentDyn = true;
                                  break;
                                }
                              }
                            } else if (componentidvalue.isNotEmpty &&
                                componentType != "12" &&
                                componentType != "8" &&
                                componentType != "10" &&
                                parentField == "") {
                              for (int k = 0;
                                  k < componentidvalue.length;
                                  k++) {
                                if (componentidvalue[k].componentid ==
                                        componentID &&
                                    componentidvalue[k].value != '') {
                                  valueDyn = true;
                                }
                              }

                              if (!parentDyn && !valueDyn) {
                                bool subparentvalAvail = subparentChecking(
                                    parentDependency, parentField);
                                if (parentDependency != "" &&
                                    parentField != "") {
                                  bool parentvalAvail = parentChecking(
                                      parentField, parentDependency);

                                  if (parentvalAvail) {
                                    validationpending = true;
                                    errordialog(
                                        context,
                                        "Information",
                                        componentLabel +
                                            " Should not be empty");
                                    parentDyn = true;
                                    break;
                                  } else if (subparentvalAvail) {
                                    print("subparentvalidation");
                                    validationpending = true;
                                    errordialog(
                                        context,
                                        "Information",
                                        componentLabel +
                                            " Should not be empty");
                                    parentDyn = true;
                                    break;
                                  }
                                } else if (mandatory == "1") {
                                  validationpending = true;
                                  errordialog(context, "Information",
                                      componentLabel + " Should not be empty");
                                  parentDyn = true;
                                  break;
                                }
                              }
                            } else if (componentidvalue.isNotEmpty &&
                                componentType != "12" &&
                                componentType != "8" &&
                                componentType != "10" &&
                                parentField != "") {
                              for (int k = 0;
                                  k < componentidvalue.length;
                                  k++) {
                                if (componentidvalue[k].componentid ==
                                        componentID &&
                                    componentidvalue[k].value != '') {
                                  valueDyn = true;
                                }
                              }

                              if (!parentDyn && !valueDyn) {
                                bool subparentvalAvail = subparentChecking(
                                    parentDependency, parentField);
                                if (parentDependency != "" &&
                                    parentField != "") {
                                  bool parentvalAvail = parentChecking(
                                      parentField, parentDependency);

                                  if (parentvalAvail) {
                                    validationpending = true;
                                    errordialog(
                                        context,
                                        "Information",
                                        componentLabel +
                                            " Should not be empty");
                                    parentDyn = true;
                                    break;
                                  } else if (subparentvalAvail) {
                                    print("subparentvalidation");
                                    validationpending = true;
                                    errordialog(
                                        context,
                                        "Information",
                                        componentLabel +
                                            " Should not be empty");
                                    parentDyn = true;
                                    break;
                                  }
                                } else if (mandatory == "1") {
                                  validationpending = true;
                                  errordialog(context, "Information",
                                      componentLabel + " Should not be empty");
                                  parentDyn = true;
                                  break;
                                }
                              }
                            } else if (idscount < widgetscount &&
                                !parentDyn &&
                                mandatory == "1" &&
                                parentField == "" &&
                                componentType != "16") {
                              validationpending = true;
                              errordialog(context, "Information",
                                  componentLabel + " Should not be empty");
                              c = dynamiccomponentFields.length;
                            }
                            /* else {
                            validationpending = true;
                            errordialog(context, "Information33",
                                componentLabel + " Should not be empty");
                            c = dynamiccomponentFields.length;
                          }*/
                          }
                          if (!validationpending) {
                            if (imageListField.length > 0) {
                              if (imageWidgetCount > 0) {
                                if (multipleImageList.length > 0) {
                                  bool parentImage = false;
                                  int len = 0;
                                  for (int d = 0;
                                      d < imageListField.length;
                                      d++) {
                                    len++;
                                    bool imageval = false;
                                    bool cameraPhoto = false;
                                    String imageMandatory = imageListField[d]
                                            ["isMandatory"]
                                        .toString();
                                    String componentID = imageListField[d]
                                            ["componentID"]
                                        .toString();
                                    String componentLabel = imageListField[d]
                                            ["componentLabel"]
                                        .toString();
                                    for (int k = 0;
                                        k < multipleImageList.length;
                                        k++) {
                                      if (multipleImageList[k].componentID ==
                                          componentID) {
                                        imageval = true;
                                      }

                                      if (multipleImageList[k].photoType == 2 &&
                                          multipleImageList[k].cameraExist ==
                                              true) {
/*                                            multipleImageList[k].cameraExist =
                                                true;*/
                                        cameraPhoto = true;
                                      } /*else if (multipleImageList[k]
                                                      .photoType ==
                                                  1 &&
                                              multipleImageList[k]
                                                      .cameraExist ==
                                                  false) {
                                            cameraPhoto = false;
                                          }*/

                                    }
                                    if (!parentImage && !imageval) {
                                      validationpending = true;
                                      errordialog(
                                          context,
                                          "Information ph ",
                                          componentLabel +
                                              " Should not be empty");
                                      parentImage = true;
                                    }

                                    // if (cameraPhoto == false && imageval && txnTypeId == "2026") {
                                    //   errordialog(context, "Information",
                                    //       "Choose at least One Image from the Camera for $componentLabel");
                                    //   break;
                                    // }

                                    if (len == imageListField.length &&
                                        !parentImage &&
                                        imageval) {
                                      //alertMessage();
                                      if (int.parse(ListCount!) > 0) {
                                        listValidation();
                                      } else /* if(componentidvalue.isNotEmpty && txnTypeId == "7129")*/ {
                                        print("error logg clled");
                                        setState(() {
                                          int index = componentidvalue
                                              .indexWhere((element) =>
                                                  element.componentid ==
                                                  "K013");
                                          print("index value:" +
                                              index.toString());
                                          if (index != -1 &&
                                              double.parse(
                                                      componentidvalue[index]
                                                          .value) >
                                                  100) {
                                            errordialog(context, "information",
                                                "Survival Rate should be between 0-100");
                                          } else {
                                            alertMessage();
                                          }
                                        });

                                        print("alert mesage called 3");
                                        //   alertMessage();
                                      } /*else{
                                        alertMessage();
                                      }*/
                                    }
                                  }
                                } else {
                                  validationpending = true;
                                  errordialog(context, "Information",
                                      "Photo Should not be empty");
                                }
                              } else {
                                print("alert mesage called 2");
                                alertMessage();
                                /*if (int.parse(ListCount!) > 0) {
                                  listValidation();
                                } else {
                                  alertMessage();
                                }*/
                              }
                            } else {
                              print("alert mesage called 1");
                              alertMessage();
                              /*if (int.parse(ListCount!) > 0) {
                                listValidation();
                              } else {
                                alertMessage();
                              }*/
                            }
                          }
                        } catch (e) {
                          errordialog(context, "Information",
                              "Mandatory should not be empty");
                        }
                      } catch (ee) {}
                    }

                    void listFieldMethod() {
                      // if (int.parse(ListCount!) > 0) {
                      //   listValidation();
                      // } else {
                      fieldValidation();
                      // }
                    }

                    void seasonValidation() {
                      if (valSeason.length == 0) {
                        errordialog(context, "Information",
                            "Season should not be empty");
                      }
                      /* else if (cropDropDown) {
                        if (slcCrop == null || slcCrop.length == 0) {
                          errordialog(context, "Information",
                              "Crop should not be empty");
                        } else {
                          listFieldMethod();
                        }
                      }*/
                      else {
                        listFieldMethod();
                      }
                    }

                    print("groupDropDown " + groupDropDown.toString());
                    print("dynamicTxnId " + dynamicTxnId!);
                    print("entity " + entity);
                    if (entity == "1" &&
                        dynamicTxnId != "M37" &&
                        dynamicTxnId != "M36") {
                      /*if (valGroup == null || valGroup.length == 0) {
                        errordialog(context, "Information",
                            "Group should not be empty");
                      } else*/
                      if (reDate.isEmpty) {
                        errordialog(
                            context, "Information", "Date should not be empty");
                      } else if (val_District.length == 0) {
                        errordialog(context, "Information",
                            "District should not be empty");
                      } else if (val_SubCounty.length == 0) {
                        errordialog(context, "Information",
                            "Subcounty/Division should not be empty");
                      } else if (val_Parish.length == 0) {
                        errordialog(context, "Information",
                            "Parish/Ward should not be empty");
                      } else if (valVillage.length == 0) {
                        errordialog(context, "Information",
                            "Village should not be empty");
                      } else if (valFarmer.length == 0) {
                        errordialog(context, "Information",
                            "Farmer  should not be empty");
                      } else {
                        listFieldMethod();
                        // seasonValidation();
                      }
                    } else if ((entity == "2" || entity == "4") &&
                        dynamicTxnId != "M37" &&
                        dynamicTxnId != "M36") {
                      if (reDate.isEmpty) {
                        errordialog(
                            context, "Information", "Date should not be empty");
                      } else if (val_District == null ||
                          val_District.length == 0) {
                        errordialog(context, "Information",
                            "District should not be empty");
                      } else if (val_SubCounty == null ||
                          val_SubCounty.length == 0) {
                        errordialog(context, "Information",
                            "Subcounty/Division should not be empty");
                      } else if (val_Parish == null || val_Parish.length == 0) {
                        errordialog(context, "Information",
                            "Parish/Ward should not be empty");
                      } else if (valVillage.length == 0) {
                        errordialog(context, "Information",
                            "Village should not be empty");
                      } else if (valFarmer.length == 0) {
                        errordialog(context, "Information",
                            "Farmer Name should not be empty");
                      } else if (valFarm.length == 0) {
                        errordialog(context, "Information",
                            "Farm Name should not be empty");
                      } else {
                        listFieldMethod();
                      }
                    } else if (entity == "3" &&
                        dynamicTxnId != "M37" &&
                        dynamicTxnId != "M36") {
                      if (reDate.isEmpty) {
                        errordialog(
                            context, "Information", "Date should not be empty");
                      } else if (valGroup.length == 0) {
                        errordialog(context, "Information",
                            "Group should not be empty");
                      } else {
                        seasonValidation();
                      }
                    } else if (entity == "5" &&
                        dynamicTxnId != "M37" &&
                        dynamicTxnId != "M36" &&
                        txnTypeId != "2026") {
                      if (reDate.isEmpty) {
                        errordialog(
                            context, "Information", "Date should not be empty");
                      } else if (val_District == null ||
                          val_District.length == 0) {
                        errordialog(context, "Information",
                            "District should not be empty");
                      } else if (val_SubCounty == null ||
                          val_SubCounty.length == 0) {
                        errordialog(context, "Information",
                            "Subcounty/Division should not be empty");
                      } else if (val_Parish == null || val_Parish.length == 0) {
                        errordialog(context, "Information",
                            "Parish/Ward should not be empty");
                      } else if (valVillage == null || valVillage.length == 0) {
                        errordialog(context, "Information",
                            "Village should not be empty");
                      } else if (valFarmer == null || valFarmer.length == 0) {
                        errordialog(context, "Information",
                            "Farmer should not be empty");
                      } else {
                        listFieldMethod();
                      }
                    } else if (dynamicTxnId != "M37" &&
                        dynamicTxnId != "M36" &&
                        entity == "12" &&
                        entity == "9" &&
                        txnTypeId != "2027") {
                      if (reDate.isEmpty) {
                        errordialog(
                            context, "Information", "Date should not be empty");
                      } else if (valGroup.length == 0) {
                        errordialog(context, "Information",
                            "Group should not be empty");
                      } else if (val_District.length == 0) {
                        errordialog(context, "Information",
                            "District should not be empty");
                      } else if (val_SubCounty.length == 0) {
                        errordialog(context, "Information",
                            "Subcounty/Division should not be empty");
                      } else if (val_Parish.length == 0) {
                        errordialog(context, "Information",
                            "Parish/Ward should not be empty");
                      } else if (valVillage.length == 0) {
                        errordialog(context, "Information",
                            "Village should not be empty");
                      } else if (valFarmer.length == 0) {
                        errordialog(context, "Information",
                            "Farmer should not be empty");
                      } else if (valFarm.length == 0) {
                        errordialog(context, "Information",
                            "Farm Name should not be empty");
                      } else {
                        seasonValidation();
                      }
                    } else if (entity == "5" &&
                        dynamicTxnId != "M37" &&
                        dynamicTxnId != "M36" &&
                        txnTypeId == "2026") {
                      if (reDate.isEmpty) {
                        errordialog(
                            context, "Information", "Date should not be empty");
                      } else if (valDist.isEmpty) {
                        errordialog(context, "Information",
                            "District should not be empty");
                      } else if (valSubCounty.isEmpty) {
                        errordialog(context, "Information",
                            "Subcounty/Division should not be empty");
                      } else if (valParish.isEmpty) {
                        errordialog(context, "Information",
                            "Parish/Ward should not be empty");
                      } else if (valVillage.isEmpty) {
                        errordialog(context, "Information",
                            "Village should not be empty");
                      } else if (valFarmer.isEmpty) {
                        errordialog(context, "Information",
                            "Farmer should not be empty");
                      } else {
                        listFieldMethod();
                      }
                    } else if (dynamicTxnId == "M37") {
                      valVillage = mileVillageIn!;
                      valFarmer = mileFarmerIn!;
                      valSeason = mileSeasonIn!;
                      seasonValidation();
                    } else if (dynamicTxnId == "M36") {
                      valVillage = mileVillageIn!;
                      valFarmer = mileFarmerIn!;
                      valFarm = mileFarmIn!;
                      valSeason = mileSeasonIn!;
                      seasonValidation();
                    } else if (entity == "12") {
                      if (reDate.isEmpty) {
                        errordialog(
                            context, "Information", "Date should not be empty");
                      } else if (val_District.length == 0) {
                        errordialog(context, "Information",
                            "District should not be empty");
                      } else if (val_SubCounty.length == 0) {
                        errordialog(context, "Information",
                            "Subcounty/Division should not be empty");
                      } else if (val_Parish.length == 0) {
                        errordialog(context, "Information",
                            "Parish/Ward should not be empty");
                      } else if (valVillage.isEmpty) {
                        errordialog(context, "Information",
                            "Village should not be empty");
                      } else if (val_vacCat.isEmpty) {
                        errordialog(context, "Information",
                            "Value Chain Actor Category should not be empty");
                      } else if (val_regStat.isEmpty) {
                        errordialog(context, "Information",
                            "Registration Status should not be empty");
                      } else if (inspection == true) {
                        if (val_regStat == '0' && val_chainAct.isEmpty) {
                          errordialog(context, "Information",
                              "Value Chain Actor should not be empty");
                        } else if (val_regStat == '1' &&
                            vacController.text.isEmpty) {
                          errordialog(context, "Information",
                              "Value Chain Actor should not be empty");
                        } else {
                          listFieldMethod();
                        }
                      } else {
                        listFieldMethod();
                      }
                    } else if (entity == "9" && txnTypeId == "2027") {
                      if (reDate.isEmpty) {
                        errordialog(
                            context, "Information", "Date should not be empty");
                      } else if (valDist.isEmpty) {
                        errordialog(context, "Information",
                            "District should not be empty");
                      } else if (valSubCounty.isEmpty) {
                        errordialog(context, "Information",
                            "Subcounty/Division should not be empty");
                      } else if (valParish.isEmpty) {
                        errordialog(context, "Information",
                            "Parish/Ward should not be empty");
                      } else if (valVillage.isEmpty) {
                        errordialog(context, "Information",
                            "Village should not be empty");
                      } else if (val_chainAct.isEmpty) {
                        errordialog(context, "Information",
                            "Value Chain Actor should not be empty");
                      } else {
                        listFieldMethod();
                      }
                    } else if (entity == "11" || entity == "10") {
                      if (reDate.isEmpty) {
                        errordialog(
                            context, "Information", "Date should not be empty");
                      } else if (val_District.length == 0) {
                        errordialog(context, "Information",
                            "District should not be empty");
                      } else if (val_SubCounty.length == 0) {
                        errordialog(context, "Information",
                            "Subcounty/Division should not be empty");
                      } else if (val_Parish.length == 0) {
                        errordialog(context, "Information",
                            "Parish/Ward should not be empty");
                      } else if (valVillage.isEmpty) {
                        errordialog(context, "Information",
                            "Village should not be empty");
                      } else if (val_vca.isEmpty) {
                        if (entity == "11") {
                          errordialog(context, "Information",
                              "Name of Processor should not be empty");
                        } else if (entity == "10") {
                          errordialog(context, "Information",
                              "Name of Exporter should not be empty");
                        }
                      } else {
                        listFieldMethod();
                      }
                    } else if (entity == "8") {
                      if (reDate.isEmpty) {
                        errordialog(
                            context, "Information", "Date should not be empty");
                      } else if (val_District.length == 0) {
                        errordialog(context, "Information",
                            "District should not be empty");
                      } else if (val_SubCounty.length == 0) {
                        errordialog(context, "Information",
                            "Subcounty/Division should not be empty");
                      } else if (val_Parish.length == 0) {
                        errordialog(context, "Information",
                            "Parish/Ward should not be empty");
                      } else if (valVillage.isEmpty) {
                        errordialog(context, "Information",
                            "Village should not be empty");
                      } else if (valNursery.isEmpty) {
                        errordialog(context, "Information",
                            "Nursery should not be empty");
                      } else {
                        listFieldMethod();
                      }
                    }
                  } catch (e) {
                    print(e.toString());
                  }
                },
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              padding: EdgeInsets.all(3),
              child: MaterialButton(
                onPressed: () {
                  _onBackPressed();
                },
                color: Colors.redAccent,
                child: const Text(
                  'Cancel',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
            ),
          ),
        ],
      ));
    });
    return listings;
  }

  trainingDraftSubmit() async {
    String qry = "select * from trainingDraftTable";
    List training = await db.RawQuery(qry);
    if (training.length > 0) {
      await db.DeleteTable('trainingDraftTable');
    }

    String imageQry = "select * from trainingImageDraft";
    List trainingImage = await db.RawQuery(imageQry);
    if (trainingImage.length > 0) {
      await db.DeleteTable('trainingImageDraft');
    }
    Future.delayed(Duration(milliseconds: 200), () async {
      if (componentidvalue.length > 0) {
        for (int i = 0; i < componentidvalue.length; i++) {
          String componentId = componentidvalue[i].componentid;
          String componentValue = componentidvalue[i].value;
          String componentType = componentidvalue[i].ComponentType;
          String componentLabel = componentidvalue[i].componentLabel;
          String dependencyField = componentidvalue[i].dependencyField;
          String parentDependency = componentidvalue[i].parentDependency;
          String selectedValue = componentidvalue[i].selectedName;
          String sectionId = componentidvalue[i].Section;
          String parentField = componentidvalue[i].parentField;
          String ifListFld = componentidvalue[i].iflistFld;
          String isMandatory = componentidvalue[i].isMandatory;
          print("farmernamefarmername:" + farName);

          int dynamicfieldSave = await db.saveDraftTable(
              recNu: recordNo.isEmpty ? revNo : recordNo,
              village: valVillage,
              farmerId: entityBasedFarmerID.isEmpty
                  ? val_chainAct
                  : entityBasedFarmerID,
              componentId: componentId,
              compVal: componentValue,
              menuId: entity,
              compType: componentType,
              txnId: txnTypeId,
              componentLabel: componentLabel,
              dependencyField: dependencyField,
              parentDependency: parentDependency,
              selectedValue: selectedValue,
              sectionId: sectionId,
              parentField: parentField,
              ifListFld: ifListFld,
              isMandatory: isMandatory,
              districtName: nameDistrict,
              districtCode: valDist,
              subCountyCode: valSubCounty,
              subCountyName: nameSubCounty,
              parishName: nameParish,
              parishCode: valParish,
              farmerName: farName.isEmpty ? slct_chainAct : farName,
              villageName: nameVillage,
              date: reDate);
          print("dynamicfieldSave" + dynamicfieldSave.toString());
        }
      } else {
        int dynamicfieldSave = await db.saveDraftTable(
            recNu: recordNo.isEmpty ? revNo : recordNo,
            village: valVillage,
            farmerId: entityBasedFarmerID.isEmpty
                ? val_chainAct
                : entityBasedFarmerID,
            componentId: "",
            compVal: "",
            menuId: entity,
            compType: "",
            txnId: txnTypeId,
            componentLabel: "",
            dependencyField: "",
            parentDependency: "",
            selectedValue: "",
            sectionId: "",
            parentField: "",
            ifListFld: "",
            isMandatory: "",
            districtName: nameDistrict,
            districtCode: valDist,
            subCountyCode: valSubCounty,
            subCountyName: nameSubCounty,
            parishName: nameParish,
            parishCode: valParish,
            farmerName: farName.isEmpty ? slct_chainAct : farName,
            villageName: nameVillage,
            date: reDate);
        print("dynamicfieldSave" + dynamicfieldSave.toString());
      }

      if (imageidvalue.length > 0) {
        if (multipleImageList.length > 0) {
          for (int j = 0; j < multipleImageList.length; j++) {
            String imageloc = multipleImageList[j].image.path;
            print("dynamicfieldSaveImage j " +
                multipleImageList[j].image.toString());
            String imageTime = multipleImageList[j].pcTime;
            String imageUrl = multipleImageList[j].image.path;
            String imageLat = multipleImageList[j].ImageLat;
            String imageLon = multipleImageList[j].ImageLng;
            String sectionId = multipleImageList[j].sectionId;
            String gloPopupId = multipleImageList[j].componentID;
            String listIteration = j.toString();
            String recNo = revNo;
            bool cExist = multipleImageList[j].cameraExist;
            String camExist = "";

            if (cExist) {
              camExist = "0";
            } else {
              camExist = "1";
            }

            db.saveTrainingImageDraft(
                imageTime: imageTime,
                imageUrl: imageUrl,
                imageLat: imageLat,
                imageLon: imageLon,
                sectionId: sectionId,
                gloPopupId: gloPopupId,
                listIteration: listIteration,
                txnTypeId: txnTypeId,
                recNo: recNo,
                cameraExist: camExist);
            print("dynamicfieldSaveImage");
          }
        }
      }
    });
  }

  decimalanddigitval(controllerval, controller, length, declength) {
    try {
      String controllervalue = controllerval;
      print("controllervalue" + controllervalue);
      List<String> values = controllervalue.split(".");
      if (values[0].length > length) {
        Alert(
          context: context,
          type: AlertType.info,
          title: 'Confirmation',
          desc: 'Invalid Format',
          buttons: [
            DialogButton(
              child: Text(
                "ok",
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
      } else if (values[1].length > declength) {
        Alert(
          context: context,
          type: AlertType.info,
          title: 'Confirmation',
          desc: 'Invalid Format',
          buttons: [
            DialogButton(
              child: Text(
                "ok",
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
    } catch (e) {}
  }

  clearSign() async {
    _sign.clear();
    setState(() {
      signImg = null;
      signdynClicked = false;
    });
  }

  getSign() async {
    if (_sign.isNotEmpty) {
      final Uint8List? data = await _sign.toPngBytes();
      setState(() {
        signImg = data!;
        encoded = base64Encode(signImg!);
        signdynClicked = false;
        _sign.clear();
      });
    } else {
      errordialog(context, "Information", "Enter Signature");
    }
  }

  bool parentChecking(componentID, parentdepend) {
    bool valid = false;
    for (int k = 0; k < componentidvalue.length; k++) {
      if (componentidvalue[k].componentid == componentID &&
          componentidvalue[k].value == parentdepend &&
          componentidvalue[k].isMandatory == "1") {
        valid = true;
      }
    }
    return valid;
  }

  bool subparentChecking(String parentdepend, String parentfield) {
    bool valid = false;
    for (int k = 0; k < componentidvalue.length; k++) {
      List<String> parentdepends = parentdepend.split(",");
      for (int p = 0; p < parentdepends.length; p++) {
        if (componentidvalue[k].value == parentdepends[p] &&
            parentfield == componentidvalue[k].componentid &&
            componentidvalue[k].isMandatory == "1") {
          valid = true;
        }
      }
    }
    return valid;
  }

  void alertMandatoryDynamic(
      String componentID, String componentLabel, int len, int totalLen) {
    if (componentidvalue.isNotEmpty) {
      for (int k = 0; k < componentidvalue.length; k++) {
        print("componentidvalue[k].componentid " +
            componentidvalue[k].componentid);
        print("componentidvalue[k].componentLabel " +
            componentidvalue[k].componentLabel);
        print("componentLabel " + componentLabel);

        if (componentidvalue[k].componentid != componentID && len == totalLen) {
          errordialog(
              context, "Information", componentLabel + " Should not be empty");
          break;
        }
      }
    } else {
      errordialog(
          context, "Information", componentLabel + " Should not be empty");
    }
  }

  // Widget Datatablereg(sectionId) {
  //   List<DataColumn> columns = [];
  //   List<DataRow> rows = [];
  //
  //   columns.add(const DataColumn(
  //       label: Text(
  //         'S No',
  //         style: TextStyle(color: Colors.green),
  //       )));
  //
  //   columns.add(const DataColumn(
  //       label: Text(
  //         'Arabica,Robusta',
  //         style: TextStyle(color: Colors.green),
  //       )));
  //
  //   columns.add(const DataColumn(
  //       label: Text(
  //         'Update/Delete',
  //         style: TextStyle(color: Colors.green),
  //       )));
  //
  //   for (int i = 0; i < dynamicListValues.length; i++) {
  //     List<DataCell> singlecell = [];
  //     //1
  //     print("dynamicListValues DataCell Athi " +
  //         dynamicListValues.length.toString());
  //
  //     singlecell.add(DataCell(Text(
  //       dynamicListValues[i].iTeration,
  //       style: TextStyle(color: Colors.black87),
  //     )));
  //
  //     singlecell.add(DataCell(Text(
  //       dynamicListValues[i].Label +
  //           "" +
  //           dynamicListValues[i].textContollerValue,
  //       style: TextStyle(color: Colors.black87),
  //     )));
  //
  //     singlecell.add(DataCell(InkWell(
  //       onTap: () async {
  //         print("dynamicListValues UPP " + dynamicListValues.length.toString());
  //         print("iterationList UPP " + iterationList.length.toString());
  //         for (int j = 0; j < iterationList.length; j++) {
  //           String Section = iterationList[j].Section;
  //           String ListId = iterationList[j].ListId;
  //           String ITeration = iterationList[j].iTeration;
  //
  //           if (sectionId == Section) {
  //             db.deleteComponentFields(ListId, revNo, ITeration, Section);
  //             print("j " + j.toString());
  //             print("dynamicListValues " + iterationList.length.toString());
  //             print("iterationList " + iterationList.length.toString());
  //             setState(() {
  //               //removing in UI
  //               iterationList.removeAt(j);
  //               Datatablereg(sectionId);
  //             });
  //           }
  //         }
  //       },
  //       child: const Icon(
  //         Icons.delete_forever,
  //         color: Colors.red,
  //       ),
  //     )));
  //
  //     //2
  //     rows.add(DataRow(cells: singlecell));
  //   }
  //   Widget objWidget = datatable_dynamic(columns: columns, rows: rows);
  //   return objWidget;
  // }

  Widget Datatablereg(sectionId) {
    List<DataColumn> columns = [];
    List<DataRow> rows = [];

    columns.add(const DataColumn(
        label: Text(
      'S No',
      style: TextStyle(color: Colors.green),
    )));

    columns.add(const DataColumn(
        label: Text(
      'Details',
      style: TextStyle(color: Colors.green),
    )));

    columns.add(const DataColumn(
        label: Text(
      'Delete',
      style: TextStyle(color: Colors.green),
    )));

    for (int i = 0; i < dynamicListValues.length; i++) {
      print("dynamicListValues UPP " + dynamicListValues.length.toString());
      List<DataCell> singlecell = [];
      //1
      print("dynamicListValues DataCell Athi " +
          dynamicListValues[i].textContollerValue.toString());

      singlecell.add(DataCell(Text(
        dynamicListValues[i].iTeration,
        style: TextStyle(color: Colors.black87),
      )));

      singlecell.add(DataCell(Text(
        dynamicListValues[i].Label +
            "" +
            dynamicListValues[i].textContollerValue,
        style: TextStyle(color: Colors.black87),
      )));

      singlecell.add(DataCell(InkWell(
        onTap: () async {
          setState(() {});
          print("dynamicListValues UPP " + dynamicListValues.length.toString());
          print("iterationList UPP " + iterationList.length.toString());
          for (int j = 0; j < iterationList.length; j++) {
            String Section = iterationList[j].Section;
            String ListId = iterationList[j].ListId;
            String ITeration = iterationList[j].iTeration;

            if (sectionId == Section) {
              db.deleteComponentFields(ListId, revNo, ITeration, Section);
              db.deletePartialFields(ListId, ITeration, Section);
              print("j " + j.toString());
              print("dynamicListValues " + iterationList.length.toString());
              print("iterationList " + iterationList.length.toString());
              setState(() async {
                //removing in UI
                print("jvalue:${i}${j}");
                iterationList.removeAt(i);
                //deleteFromTable(i.toString());

                Datatablereg(sectionId);
              });
            }
          }
        },
        child: const Icon(
          Icons.delete_forever,
          color: Colors.red,
        ),
      )));

      //2
      rows.add(DataRow(cells: singlecell));
    }
    Widget objWidget = datatable_dynamic(columns: columns, rows: rows);
    return objWidget;
  }

  deleteFromTable(String iterationId) async {
    await db.RawQuery("delete from dynamicListValues where listItration = \'" +
        iterationId.toString() +
        "\'");
  }

  String parseFormula(String dynamicFormula) {
    String parsedFormula = dynamicFormula.replaceAll(
        RegExp(r"\p{P}", unicode: true), ","); // Subtraction
    String parsedFormula2 = '';
    String parsedFormula3 = '';
    if (parsedFormula.contains('+')) {
      parsedFormula2 = parsedFormula.replaceAll('+', ',');
    } else {
      parsedFormula2 = parsedFormula;
    }
    if (parsedFormula2.contains('/')) {
      parsedFormula3 = parsedFormula2.replaceAll('/', ',');
    } else {
      parsedFormula3 = parsedFormula2;
    }
    List parsedFormulaList = parsedFormula3.split(",");
    List<String> formulaValuesList = [];

    if (parsedFormulaList.isNotEmpty) {
      for (int s = 0; s < parsedFormulaList.length; s++) {
        String spaceRemovedString =
            parsedFormulaList[s].toString().replaceAll(" ", "");
        if (spaceRemovedString.isNotEmpty) {
          formulaValuesList.add(spaceRemovedString);
        }
      }
    }
    print("Formula: $dynamicFormula");
    print("FinalOutput: ${formulaValuesList.join(",")}");
    return formulaValuesList.join(",");
  }

  void updateDynamicComponentImageNew(
      var ImageModeldynamicc, List multipleImageList) {
    String componentid = ImageModeldynamicc.componentid;
    //String value = ImageModel.value;
    int length = multipleImageList.length;
    print("length repo:  " + length.toString());
    if (length == 0) {
      print('updateDynamicComponentImage empty');
    } else {
      bool found = false;
      for (int i = 0; i < imageidvalue.length; i++) {
        if (componentid == imageidvalue[i].componentid) {
          found = true;
          /*setState(() {
            imageidvalue[i].value = value;
          });*/
        }
      }
      if (!found) {
        setState(() {
          imageidvalue.add(ImageModeldynamicc);
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

  void updateDynamicComponentDynamic(var compenentModel) {
    String position = compenentModel.Position;
    String componentid = compenentModel.componentid;
    String value = compenentModel.value;
    String label = compenentModel.componentLabel;
    String txt = compenentModel.selectedName;
    /*if (value == "" || value.length == 0) {
    } else */
    // if (value.length > 0) {
    bool found = false;
    for (int i = 0; i < componentidvalue.length; i++) {
      if (componentid == componentidvalue[i].componentid) {
        found = true;
        print("priya" + value);
        print("priya" + txt);
        //setState(() {
        if (value == "") {
          componentidvalue.removeAt(i);
          componentidvalue_Label.removeAt(i);
        } else {
          componentidvalue[i].value = value;
          componentidvalue[i].selectedName = txt;
        }
        //});
      }
    }
    if (!found) {
      setState(() {
        componentidvalue.add(compenentModel);
        componentidvalue_Label.add(label);
      });
    }
    // }
  }

  void updateDateComponentDynamic(var compenentModel) {
    String componentid = compenentModel.componentID;
    String value = compenentModel.value;
    //String label = compenentModel.componentLabel;

    if (value == "" || value.length == 0) {
    } else if (value.length > 0) {
      bool found = false;
      for (int i = 0; i < DatesModelList.length; i++) {
        if (componentid == DatesModelList[i].componentID) {
          found = true;
          setState(() {
            DatesModelList[i].value = value;
          });
        }
      }
      if (!found) {
        setState(() {
          DatesModelList.add(compenentModel);
        });
      }
    }
  }

  List<ComponentModel> takeNumber(
      String text,
      String itemId,
      String Position,
      String componentType,
      String sectionId,
      String isMandatory,
      String componentLabel,
      String Type,
      List<ComponentModel> compenentList,
      List componentidvalueLabel,
      String parentField,
      String dependencyField,
      String parentDependency,
      String iflistFld) {
    try {
      var compenentModel = ComponentModel(
          itemId,
          text,
          Position,
          componentType,
          sectionId,
          isMandatory,
          componentLabel,
          text,
          Type,
          parentField,
          dependencyField,
          parentDependency,
          iflistFld,
          "");
      compenentList = updateDynamicComponentFarMile(
          compenentModel, compenentList, componentidvalueLabel);
    } on FormatException {}
    return compenentList;
  }

  Future<void> listAddedFunction(var lstmd) async {
    String Label = lstmd.Label;
    iterationList.add(lstmd);
    /*if (iterationList.length == 0) {
      iterationList.add(lstmd);
    } else {
      bool listexist = false;
      for (int i = 0; i < iterationList.length; i++) {
        setState(() {
          if (iterationList[i].Label == Label) {
            listexist = true;
          }
        });
      }
      if (listexist) {
        errordialog(context, "Information", "Already exist");
      } else {
        iterationList.add(lstmd);
      }
    }*/
  }

  draftSubmit() {
    if (reDate.isEmpty) {
      errordialog(context, "Information", "Date should not be empty");
    } else if (valDist.isEmpty) {
      errordialog(context, "Information", "District should not be empty");
    } else if (valSubCounty.isEmpty) {
      errordialog(
          context, "Information", "Subcounty/Division should not be empty");
    } else if (valParish.isEmpty) {
      errordialog(context, "Information", "Parish/Ward should not be empty");
    } else if (valVillage.isEmpty) {
      errordialog(context, "Information", "Village should not be empty");
    } else if (valFarmer.isEmpty && txnTypeId == "2026") {
      errordialog(context, "Information", "Farmer should not be empty");
    } else if (val_chainAct.isEmpty && txnTypeId == "2027") {
      errordialog(
          context, "Information", "Value Chain Actor should not be empty");
    } else {
      alertMessageDraft();
    }
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
        desc: "Are you sure you want to proceed?",
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
              trainingDraftSubmit();
              //Put your code here which you want to execute on No button click.
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
            color: Colors.green,
          )
        ]).show();
  }

  Future<void> alertMessage() async {
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
        desc: "Are you sure you want to proceed?",
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
              savedynamicData();
              //Put your code here which you want to execute on No button click.
              Navigator.of(context).pop();
            },
            color: Colors.green,
          )
        ]).show();
  }

  phtottest() {
    print("multipleImageList.length " + multipleImageList.length.toString());
    print("imageidvalue.length " + imageidvalue.length.toString());
    if (imageidvalue.isNotEmpty) {
      if (multipleImageList.isNotEmpty) {
        for (int j = 0; j < multipleImageList.length; j++) {
          List<int> imageBytes = multipleImageList[j].image.readAsBytesSync();
          String FieldVal = base64Encode(imageBytes);
          print("dynamicfieldSaveImage j " + j.toString() + " / " + FieldVal);
        }
      }
    }
  }

  savedynamicData() async {
    final now = DateTime.now();
    String txntime = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
    String msgNo = DateFormat('yyyyMMddHHmmss').format(now);

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? agentid = prefs.getString("agentId");
    String? agentToken = prefs.getString("agentToken");
    String rNo = recordNo.isEmpty ? revNo : recordNo;
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
            rNo +
            '\')';
    print('txnHeader ' + insqry);
    int succ = await db.RawInsert(insqry);
    print(succ);

    if (vacController.text.isNotEmpty) {
      entityBasedFarmerID = vacController.text;
    }

    AppDatas datas = new AppDatas();
    int custTransaction = await db.saveCustTransaction(
        txntime,
        datas.txn_dynamic,
        recordNo.isEmpty ? revNo : recordNo,
        '',
        txnTypeId,
        txnTypeName);
    print('custTransaction : ' + custTransaction.toString());

    await db.DeleteTable('trainingDraftTable');
    await db.DeleteTable('trainingImageDraft');
    await db.DeleteTable('listPartial');

    String farmerId = entityBasedFarmerID;
    String farmId = valFarm;
    String isSynched = "1";
    String season = seasoncode;
    // String longitude = Lng;
    String longitude = longtitudeController.text;
    // String latitude = Lat;
    String latitude = latitudeController.text;
    String txnType = txnTypeId;
    String txnUniqueId = revNo;
    String txnDate = txntime;
    String txnTypeIdMaster = "500";
    String inspectionStatus = "";
    String converStatus = "";
    String corActPln = "";
    String menuEntity = entity;
    String dynseasonCode = valSeason;
    String inspectionDate = reDate;
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
    String component = valComponent;
    String district = valDistrict;
    String upazila = valUpazila;
    String union = valUnion;
    String ward = valWard;
    String village = valVillage;
    String group = valGroup;
    String activity = valActivity;

    if (activity == "" || activity == "null") {
      activity = "";
    }

    int SavemultiTenantParent = await db.SavemultiTenantParent(
        recordNo.isEmpty ? revNo : recordNo,
        farmerId.isEmpty ? valNursery : farmerId,
        farmId,
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
        village,
        val_vacCat,
        val_regStat);

    print(SavemultiTenantParent);
    for (int i = 0; i < componentidvalue.length; i++) {
      String FieldId = componentidvalue[i].componentid;
      String FieldVal = componentidvalue[i].value;
      String ComponentType = componentidvalue[i].ComponentType;
      String iflistFld = componentidvalue[i].iflistFld;
      if (iflistFld == 'N') {
        int dynamicfieldSave = await db.SavedynamiccomponentFieldValues(
            FieldId,
            FieldVal,
            ComponentType,
            recordNo.isEmpty ? revNo : recordNo,
            txnTypeId,
            "");
        print("dynamicfieldSave" + dynamicfieldSave.toString());
      }
    }

    print("multipleImageList.length " + multipleImageList.length.toString());
    if (imageidvalue.length > 0) {
      if (multipleImageList.length > 0) {
        for (int j = 0; j < multipleImageList.length; j++) {
          //List<int> imageBytes = multipleImageList[j].image.readAsBytesSync();
          //String FieldVal = base64Encode(imageBytes);
          String imageloc = multipleImageList[j].image.path;
          print("dynamicfieldSaveImage j " +
              multipleImageList[j].image.toString());
          db.SavedynamiccomponentImage(
              multipleImageList[j].componentID,
              pcTime,
              imageloc,
              latitude,
              longitude,
              "",
              j.toString(),
              multipleImageList[j].listID,
              multipleImageList[j].sectionId,
              "",
              txnTypeId,
              "",
              recordNo.isEmpty ? revNo : recordNo);
          print("dynamicfieldSaveImage");
        }
      }
    }

    /*if (imageidvalue.length > 0) {
      for (int i = 0; i < imageidvalue.length; i++) {
        int iteration = i + 1;
        String FieldId = imageidvalue[i].componentid;
        String listid = imageidvalue[i].List;
        String sectionid = imageidvalue[i].Section;
        if (multipleImageList.length > 0) {
          List<File> imageFileList = [];
          int len=0;
          for (int j = 0; j < multipleImageList.length; j++) {
            len++;
            if (multipleImageList[j].componentID == FieldId) {
              imageFileList.add(multipleImageList[j].image);
            }
            if(len==multipleImageList.length){
              for (int k = 0; k < imageFileList.length; k++) {
                //if (_imageFile1 != null) {
                  List<int> imageBytes = imageFileList[k].readAsBytesSync();
                  String FieldVal = base64Encode(imageBytes);
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
               // }
              }
            }
          }
        }
      }
    }*/
    /*if (imageidvalue.length > 0) {
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
    }*/

    int issync = await db.UpdateTableValue(
        'multiTenantParent', 'isSynched', '0', 'recNo', rNo);
    print(issync);
    int dynasync = await db.UpdateTableValue(
        'dynamicListValues', 'isSynched', '0', 'recNu', rNo);
    print(dynasync);
    TxnExecutor txnExecutor = new TxnExecutor();
    txnExecutor.CheckCustTrasactionTable();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return WillPopScope(
            onWillPop: () async => false,
            child: AlertDialog(
              title: Text(dynamicTxnName! + " " + "Transaction Successful."),
              actions: <Widget>[
                ElevatedButton(
                  child: Text("OK"),
                  onPressed: () {
                    if (dynamicTxnId == "M37" || dynamicTxnId == "M36") {
                      Navigator.pop(context);
                      Navigator.pop(context);
                      Navigator.pop(context);
                    } else {
                      Navigator.pop(context);
                      Navigator.pop(context);
                    }
                  },
                ),
              ],
            ));
      },
    );
  }
}

savePartialData(String recordNo, String listid, int iteration, String sectionId,
    String dropdownValue, String textControllerValue, String revNo) async {
  print("partial save called");
  var db = DatabaseHelper();

  int res1 = await db.saveListPartialDraft(
      recNo: recordNo.isEmpty ? revNo : recordNo,
      listId: listid,
      iteration: iteration.toString(),
      section: sectionId,
      label: dropdownValue,
      textControllerValue: textControllerValue,
      date: "",
      other: "");
  print("resultstring" + res1.toString());
}

List<ComponentModel> updateDynamicComponentFarMile(var compenentModel,
    List<ComponentModel> componentidvalueFarMile, List componentidvalueLabel) {
  String position = compenentModel.Position;
  String componentid = compenentModel.componentid;
  String value = compenentModel.value;
  String label = compenentModel.componentLabel;
  // if (value == "" || value.length == 0) {
  // } else if (value.length > 0) {
  bool found = false;
  for (int i = 0; i < componentidvalueFarMile.length; i++) {
    if (componentid == componentidvalueFarMile[i].componentid) {
      print('componentidvaluelength ' + componentid);
      found = true;
      componentidvalueFarMile[i].value = value;
    }
  }
  print('componentidvaluelength ' + componentid + ' ' + compenentModel.value);
  if (!found) {
    componentidvalueFarMile.add(compenentModel);
    componentidvalueLabel.add(label);
  }
  // }
  return componentidvalueFarMile;
}

class ComponentModel {
  String componentid;
  String value;
  String Position;
  String ComponentType;
  String Section;
  String isMandatory;
  String componentLabel;
  String selectedName;
  String type;
  String parentField;
  String parentDependency;
  String dependencyField;
  String iflistFld;
  String dropDownName;

  ComponentModel(
      this.componentid,
      this.value,
      this.Position,
      this.ComponentType,
      this.Section,
      this.isMandatory,
      this.componentLabel,
      this.selectedName,
      this.type,
      this.parentField,
      this.dependencyField,
      this.parentDependency,
      this.iflistFld,
      this.dropDownName);
}

class ValidationModel {
  String ListId;
  String Section;
  String mandatory;
  String componentId;

  ValidationModel(this.ListId, this.Section, this.mandatory, this.componentId);
}

class ImageModeldynamic {
  String componentid;
  String Position;
  String ComponentType;
  String Section;
  String lat;
  String lon;
  String pcTime;
  String List;

  ImageModeldynamic(this.componentid, this.Position, this.ComponentType,
      this.Section, this.lat, this.lon, this.pcTime, this.List);
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

class MultipleImageModel {
  String componenttype;
  String componentID;
  File image;
  String sectionId;
  String ImageLat;
  String ImageLng;
  String pcTime;
  String listID;
  int photoType;
  bool cameraExist;

  MultipleImageModel(
      this.componenttype,
      this.componentID,
      this.image,
      this.sectionId,
      this.ImageLat,
      this.ImageLng,
      this.pcTime,
      this.listID,
      this.photoType,
      this.cameraExist);
}

class DropDownModel {
  String ComponentId;
  String ComponentLabel;
  String SelectedValue;
  List<DropdownModel> dropdownitem;

  DropDownModel(this.ComponentId, this.ComponentLabel, this.SelectedValue,
      this.dropdownitem);
}

class CheckboxModel {
  String ComponentId;
  bool selected;

  CheckboxModel(this.ComponentId, this.selected);
}

class CatalogModel {
  String ComponentId;
  String CatalogValue;

  CatalogModel(this.ComponentId, this.CatalogValue);
}

class DatesModel {
  String componentID;
  String value;

  DatesModel(this.componentID, this.value);
}

class MultipleRadioModel {
  String parentcomponentID;
  String componentID;
  int value;

  MultipleRadioModel(this.parentcomponentID, this.componentID, this.value);
}

class WeatherInfoDynamic {
  String temp;
  String rain;
  String humidity;
  String windSpeed;

  WeatherInfoDynamic(this.temp, this.rain, this.humidity, this.windSpeed);
}

class MutipleDropDownModel {
  String ComponentId;
  String ComponentLabel;
  List<String> selected;

  MutipleDropDownModel(this.ComponentId, this.ComponentLabel, this.selected);
}

class dynamicDropModel {
  String property_value;
  String DISP_SEQ;
  String catalog_code;

  dynamicDropModel(this.property_value, this.DISP_SEQ, this.catalog_code);
}

class dynamicDropMasterModel {
  String property_value;
  String DISP_SEQ;
  String parent;
  String componentIDchild;

  dynamicDropMasterModel(
      this.property_value, this.DISP_SEQ, this.parent, this.componentIDchild);
}

class DynamicModel {
  String sno;
  String data;
  String type;

  DynamicModel(this.sno, this.data, this.type);
}

class DateModel {
  String ComponentId, Date;

  DateModel(this.ComponentId, this.Date);
}

void printWrapped(String text) {
  final pattern = RegExp('.{1,800}'); // 800 is the size of each chunk
  pattern.allMatches(text).forEach((match) => print(match.group(0)));
}
