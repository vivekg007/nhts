import 'dart:async';
import 'dart:convert';
import 'dart:io' show File;
import 'dart:math';
import 'dart:typed_data';

import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:signature/signature.dart';
import 'package:ucda/Database/Databasehelper.dart';
import 'package:ucda/Model/UIModel.dart';
import 'package:ucda/Model/dynamicfields.dart';
import 'package:ucda/commonlang/translateLang.dart';

import '../Utils/MandatoryDatas.dart';

class FarmerEnrollments extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _FarmerEnrollments();
  }
}

class _FarmerEnrollments extends State<FarmerEnrollments> {
  var db = DatabaseHelper();

  // ProgressHUD _progressHUD;
  // List<Map> agents;

  int farmerid = 0;
  bool isregistration = false;
  bool gramPanchayat = false;
  bool isloantaken = false;
  String Lat = '0', Lng = '0';
  String seasoncode = '';
  String servicePointId = '';
  String agendId = '';

  bool memberOrgLoaded = false;

  List<Map> agents = [];

  String _selectedGender = "option1", genderSelect = "1", _selectHead = "MALE";

  File? farmerImageFile;
  File? licenceImageFile;
  File? idProofImageFile;
  int curIdLim = 0;
  int resId = 0;
  int curIdLimited = 0;

  String farmerImage = "";
  String idImage = "";
  String adharImage = "";

  List<UImodel> countryUIModel = [];
  List<UImodel> stateUIModel = [];
  List<UImodel> districtUIModel = [];
  List<UImodel> cityListUIModel = [];
  List<UImodel> VillageListUIModel = [];

  List<UImodel> martialStatusUIModel = [];
  List<UImodel> groupUIModel = [];
  List<UImodel> vendorTypeUIModel = [];
  List<UImodel> bankNameUIModel = [];
  List<UImodel> medicalfacilitiesUIModel = [];
  List<UImodel> educationfacilitiesUIModel = [];
  List<UImodel> communicationUIModel = [];
  List<UImodel> educationLevelUIModel = [];
  List<UImodel> abilityToCommunicateUIModel = [];
  List<UImodel> foliarApplicationUIModel = [];
  List<UImodel> pestManagementUIModel = [];
  List<UImodel> priningTippingUIModel = [];
  List<UImodel> religionUIModel = [];
  List<UImodel> minorityUIModel = [];
  List<UImodel> govIdUIModel = [];
  List<UImodel> accessMarketUIModel = [];
  List<UImodel> cultivatorUIModel = [];

  List<DropdownModel> martialItems = [],
      groupItems = [],
      vendorItems = [],
      religionitems = [],
      minorityitems = [],
      govIditems = [],
      bankItems = [],
      medicalFacilitiesItems = [],
      educationItems = [],
      communicationItems = [],
      educationLevelItems = [],
      foliarItems = [],
      pestItems = [],
      priningItems = [],
      cultivatorItems = [],
      marketItems = [];

  List<String> abilitytocommunicate = [];

  final List<DropdownMenuItem> abilityToCommunicateItems = [];
  DropdownModel? slctGroup;
  DropdownModel? slctVendor;
  DropdownModel? slctBank;
  DropdownModel? slctMedical;
  DropdownModel? slctEducation;
  DropdownModel? slctcommunication;
  DropdownModel? slctEducationLevel;
  DropdownModel? slctAbilityCommunicate;
  DropdownModel? slctFoliar;
  DropdownModel? slctPest;
  DropdownModel? slctPrining;
  DropdownModel? slctCultivator;
  DropdownModel? slctReligion;
  DropdownModel? slctMinority;
  DropdownModel? slctGovId;
  DropdownModel? slctMarket;

  String slct_Group = '';
  String slct_Vendor = '';
  String slct_Bank = '';
  String slct_Medical = '';
  String slct_Education = '';
  String slct_communication = '';
  String slct_EducationLevel = '';
  String slct_AbilityCommunicate = '';
  String slct_Foliar = '';
  String slct_Pest = '';
  String slct_Prining = '';
  String slct_Cultivator = '';
  String slct_Religion = '';
  String slct_Minority = '';
  String slct_GovID = '';
  String slct_Market = '';

  String valMartial = '';
  String valGroup = '';
  String valVendor = '';
  String valBank = '';
  String valMedical = '';
  String valEducation = '';
  String valCommunication = '';
  String valEducationLevel = '';
  String valAbility = '';
  String valFoliar = '';
  String valPest = '';
  String valPrining = '';
  String valCultivator = '';
  String valReligion = '';
  String valMinority = '';
  String valGovId = '';
  String valMarket = '';

  List<DropdownMenuItem> districtitems = [],
      cityitems = [],
      countryitems = [],
      stateitems = [],
      ditrictitems = [],
      talukitems = [],
      villageitems = [];

  bool stateLoaded = false;
  bool districtLoaded = false;
  bool cityLoaded = false;
  bool villageLoaded = false;
  Map<String, String> genderMap = {
    'option1': "MALE",
    'option2': "FEMALE",
  };

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

  String dateofbirth = "";
  String dateofbirthFormatedDate = "";

  String dbformatdate = "";

  TextEditingController enrollementPlace = new TextEditingController();
  TextEditingController agec = new TextEditingController();
  TextEditingController annualIncome = new TextEditingController();
  TextEditingController fpoFggroup = new TextEditingController();
  TextEditingController contactNumber = new TextEditingController();
  TextEditingController licenseNumber = new TextEditingController();
  TextEditingController adharNumber = new TextEditingController();
  TextEditingController accountHolderName = new TextEditingController();
  TextEditingController bankAccountNumber = new TextEditingController();
  TextEditingController ifscCode = new TextEditingController();
  TextEditingController totalFamilyMembers = new TextEditingController();
  TextEditingController actualFarmer = new TextEditingController();
  TextEditingController son = new TextEditingController();
  TextEditingController daughter = new TextEditingController();
  TextEditingController grandChilderen = new TextEditingController();
  TextEditingController otherBussinessPotential = new TextEditingController();
  TextEditingController plucking = new TextEditingController();
  TextEditingController spraying = new TextEditingController();
  TextEditingController date = new TextEditingController();
  TextEditingController indegeneoustechnicalknowledge =
      new TextEditingController();
  TextEditingController currentGoodPractices = new TextEditingController();

  List<String> valabilityToCommunicate = [];

  String abilityTypes = "";

  List<BankDetail> bankDetailList = [];
  List<BankDetail> bankList = [];
  var dateRange = "";

  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now().add(Duration(days: 7));

  //ucda fields

  String registrationDate = "", registrationFormatedDate = "";
  TextEditingController farmerName = new TextEditingController();
  TextEditingController otherName = new TextEditingController();
  TextEditingController nameOwner = new TextEditingController();
  TextEditingController addressOwner = new TextEditingController();
  TextEditingController nin = new TextEditingController();
  TextEditingController address = new TextEditingController();
  TextEditingController email = new TextEditingController();
  TextEditingController phoneNumber = new TextEditingController();
  TextEditingController mobileMoneyNumber = new TextEditingController();
  TextEditingController totNumHouseHold = new TextEditingController();
  TextEditingController totAdultFamily = new TextEditingController();
  TextEditingController totChildren = new TextEditingController();
  TextEditingController totLandOwned = new TextEditingController();
  TextEditingController totNumFarms = new TextEditingController();
  TextEditingController nameCompany = new TextEditingController();
  TextEditingController amount = new TextEditingController();
  TextEditingController amount1 = new TextEditingController();
  TextEditingController nameCrop = new TextEditingController();
  TextEditingController familyHead = new TextEditingController();

  String addressOrganization = "";
  bool addressOrg = false;

  //name of organization
  List<DropdownModel> nameOrganizationitems = [];
  DropdownModel? slctNameOrganization;
  String slct_NameOrganization = "";
  String val_NameOrganization = "";

  //coffee organization
  List<DropdownModel> coffeeOrganizationitems = [];
  DropdownModel? slctCofeeOrganization;
  String slct_CoffeeOrganization = "";
  String val_CoffeeOrganization = "";

  //national id
  List<DropdownModel> nationaliditems = [];
  DropdownModel? slctNationalID;
  String slct_NationalID = "";
  String val_NationalID = "";

  //Gender
  List<DropdownModel> genderitems = [];
  DropdownModel? slctGender;
  String slct_Gender = "";
  String val_Gender = "";

  //martial
  List<DropdownModel> martialitems = [];
  DropdownModel? slctMartial;
  String slct_Martial = "";
  String val_Martial = "";

  //scheme
  List<DropdownModel> schemeitems = [];
  DropdownModel? slctScheme;
  String slct_Scheme = "";
  String val_Scheme = "";

  //head of family
  List<DropdownModel> headfamilyitems = [];
  DropdownModel? slctHeadFamily;
  String slct_HeadFamily = "";
  String val_HeadFamily = "";

  //total no of childeren
  List<DropdownModel> totChildrenitems = [];
  DropdownModel? slctTotChildren;
  String slct_TotChildren = "";
  String val_TotChildren = "";

  //land tenure system
  List<DropdownModel> landtenureitems = [];
  DropdownModel? slctLandTenure;
  String slct_LandTenure = "";
  String val_LandTenure = "";

  //disability
  List<DropdownModel> disabilityItem = [];
  DropdownModel? slctDisability;
  String slct_Disability = "";
  String val_Disability = "";

  //coffee type
  // List<DropdownModel> coffeetypeitems = [];
  // DropdownModel? slctCoffeeType;
  // String slct_CoffeeType = "";
  // String val_CoffeeType = "";

  List<DropdownModel> landOwnerItem = [];
  DropdownModel? slctLandOwner;
  String slct_LandOwner = "";
  String val_LandOwner = "";

  //level of education
  List<DropdownModel> leveleducationitems = [];
  DropdownModel? slctLevelEducation;
  String slct_LevelEducation = "";
  String val_LevelEducation = "";

  //period
  List<DropdownModel> perioditems = [];
  DropdownModel? slctPeriod;
  String slct_Period = "";
  String val_Period = "";

  //name of crop
  List<DropdownModel> namecropitems = [];
  DropdownModel? slctNameCrop;
  String slct_NameCrop = "";
  String val_NameCrop = "";

  //coffee farm
  final List<DropdownMenuItem> coffeeFarmItems = [];
  List<String> coffeeFarm = [];
  List<UImodel> coffeeFarmUIModel = [];
  String valCoffeeFarm = '';
  String slct_CoffeeFarm = '';

  //certification
  final List<DropdownMenuItem> certificationItems = [];
  List<String> certification = [];
  List<UImodel> certificationUIModel = [];
  String valCertification = '';
  String slct_Certification = '';

  //post harvest
  final List<DropdownMenuItem> postHarvestItems = [];
  List<String> postHarvest = [];
  List<UImodel> postHarvestUIModel = [];
  String valPostHarvest = '';
  String slct_PostHarvest = '';

  final List<DropdownMenuItem> coffeeTypeItems = [];
  List<String> coffeeType = [];
  List<UImodel> coffeeTypeUIModel = [];
  String valCoffeeType = '';
  String slct_CoffeeType = '';

  final Map<String, String> isCertifiedFarmer = {
    'option1': "NO",
    'option2': "YES",
  };
  final Map<String, String> isHeadFamily = {
    'option1': "NO",
    'option2': "YES",
  };

  String _selectedCeritifiedFarmer = "option1", certifiedSelect = "0";

  bool isCertifiedFar = false;

  String _selectedHeadFamily = "option1", familySelect = "0";

  bool isHeadFam = false;

  final Map<String, String> healthIns = {
    'option1': "NO",
    'option2': "YES",
  };

  String _selectedHealthIns = "option1", healthSelect = "0";

  final Map<String, String> memberOrg = {
    'option1': "NO",
    'option2': "YES",
  };

  String _selectedMemOrg = "option1", memOrgSelect = "0";

  bool isHealthIns = false;

  final Map<String, String> farmIns = {
    'option1': "NO",
    'option2': "YES",
  };

  String _selectedFarmIns = "option1", farmSelect = "0";

  bool isFarmIns = false;

  bool isMember = false;
  bool signdynClicked = false;
  ByteData _img = ByteData(0);
  String encoded = "";
  String encodedValue = "";

  Uint8List? signImg;

  final SignatureController _sign = SignatureController(
    penStrokeWidth: 2,
    penColor: Colors.black,
  );

  String agentType = "";

  bool leasedTrue = false;

  String districtName = "";
  String subCountyName = "";
  String parishName = "";
  String villageName = "";

  String farmerSign = '';
  String farmerSignPath = '';

  String region = "";

  @override
  void initState() {
    super.initState();
    // _progressHUD = new ProgressHUD(
    //   backgroundColor: Colors.black12,
    //   color: Colors.white,
    //   containerColor: Colors.green,
    //   borderRadius: 5.0,
    //   loading: false,
    //   text: 'Loading...',
    // );
    enrollementPlace = new TextEditingController();
    agec = new TextEditingController();
    farmerName = new TextEditingController();
    annualIncome = new TextEditingController();
    fpoFggroup = new TextEditingController();
    contactNumber = new TextEditingController();
    address = new TextEditingController();
    licenseNumber = new TextEditingController();
    accountHolderName = new TextEditingController();
    bankAccountNumber = new TextEditingController();
    ifscCode = new TextEditingController();
    totalFamilyMembers = new TextEditingController();
    son = new TextEditingController();
    daughter = new TextEditingController();
    grandChilderen = new TextEditingController();
    otherBussinessPotential = new TextEditingController();
    plucking = new TextEditingController();
    spraying = new TextEditingController();
    indegeneoustechnicalknowledge = new TextEditingController();
    currentGoodPractices = new TextEditingController();

    farmerName = new TextEditingController();
    otherName = new TextEditingController();
    nameOwner = new TextEditingController();
    addressOwner = new TextEditingController();
    nin = new TextEditingController();
    address = new TextEditingController();
    email = new TextEditingController();
    phoneNumber = new TextEditingController();
    mobileMoneyNumber = new TextEditingController();
    totNumHouseHold = new TextEditingController();
    totAdultFamily = new TextEditingController();
    totChildren = new TextEditingController();
    totLandOwned = new TextEditingController();
    totNumFarms = new TextEditingController();
    nameCompany = new TextEditingController();
    amount = new TextEditingController();
    amount1 = new TextEditingController();
    nameCrop = new TextEditingController();

    getDraft();

    getClientData();
    initvalues();

    final now1 = new DateTime.now();
    String dateString = DateFormat('dd/MM/yyyy').format(now1);
    String dateValue = DateFormat('yyyyMMdd').format(now1);
    registrationFormatedDate = dateValue;
    registrationDate = dateString;

    slctCountry = "";
    slctState = "";
    slctDistrict = "";
    slctTaluk = "";
    slctVillage = "";

    getLocation();

    amount1.addListener(() {
      decimalanddigitval(amount1.text, amount1, 7);
    });

    totNumHouseHold.addListener(() {
      if (totNumHouseHold.text.isNotEmpty && totAdultFamily.text.isNotEmpty) {
        if (int.parse(totNumHouseHold.text) < int.parse(totAdultFamily.text)) {
          errordialog(context, "Information",
              "Total Number Of Household Members should be greater than Total Adults In Family (Above 18 Years)");
          totAdultFamily.clear();
          totChildren.clear();
          totNumHouseHold.clear();
        } /*else {
          setState(() {});
          // int totNumHouse = int.parse(totNumHouseHold.text);
          // int totAdult = int.parse(totAdultFamily.text);
          // int tot = totNumHouse - totAdult;
          // totChildren.text = tot.toString();
          totAdultFamily.clear();
          totChildren.clear();
        }*/
      } else {
        totAdultFamily.clear();
        totChildren.clear();
      }
    });

    totAdultFamily.addListener(() {
      if (totAdultFamily.text.isNotEmpty) {
        if (int.parse(totAdultFamily.text) > int.parse(totNumHouseHold.text)) {
          errordialog(context, "Information",
              "Total Adult in Family (Above 18 Years) should be less than or equal to Total Number Of Household Members ");
          totAdultFamily.clear();
          totChildren.clear();
        } else {
          setState(() {});
          int totNumHouse = int.parse(totNumHouseHold.text);
          int totAdult = int.parse(totAdultFamily.text);
          int tot = totNumHouse - totAdult;
          totChildren.text = tot.toString();
        }
      } else {
        totChildren.clear();
      }
    });

    totChildren.addListener(() {
      if (totChildren.text.isNotEmpty && totNumHouseHold.text.isNotEmpty) {
        if (int.parse(totChildren.text) > int.parse(totNumHouseHold.text)) {
          errordialog(context, "Information",
              "Total Number Of Children In the Family (Below 18 Years) should be less than or equal to Total Number Of Household Members");
          totChildren.clear();
        }
      }
    });

    amount.addListener(() {
      decimalanddigitval(amount.text, amount, 7);
    });

    totLandOwned.addListener(() {
      decimalanddigitval(totLandOwned.text, totLandOwned, 7);
    });

    ChangeStates();

    //farmerIdGeneration();
  }

  getDraft() async {
    String farmerQry = 'select * from farmerkettle where isSynched = "2"';
    List farmerQryList = await db.RawQuery(farmerQry);
    print("farmerQrylist:" + farmerQryList.toString());
    String dropDownNameQry = 'select * from harvestData';
    List dropDownNameQryList = await db.RawQuery(dropDownNameQry);
    print("dropDownNameQryList:" + dropDownNameQryList.toString());
    // String fId = "";
    // fId = farmerQryList[0]['farmerId'].toString();
    String orgQry = "";
    List orgQryList = [];

    try {
      EasyLoading.show(status: 'loading...');
      if (farmerQryList.length > 0) {
        for (int f = 0; f < farmerQryList.length; f++) {
          setState(() {});
          registrationFormatedDate = farmerQryList[f]['enrollementPlace'] ?? "";
          registrationDate = dropDownNameQryList[0]['farmerId'] ?? "";
          farmerid = int.parse(farmerQryList[f]['farmerId']);
          orgQry = 'select * from bankList where farmerId = \'' +
              farmerid.toString() +
              '\'';
          orgQryList = await db.RawQuery(orgQry);
          print("orgQryList:" + orgQryList.toString());
          farmerName.text = farmerQryList[f]['fName'] ?? "";
          otherName.text = farmerQryList[f]['lName'] ?? "";
          dateofbirth = farmerQryList[f]['group1'] ?? "";
          dateofbirthFormatedDate = farmerQryList[f]['dob'] ?? "";
          dbformatdate = farmerQryList[f]['group1'] ?? "";
          memOrgSelect = farmerQryList[f]['annualIncome'] ?? "";
          print("memOrgSelect" + memOrgSelect);
          if (memOrgSelect == "1") {
            _selectedMemOrg = "option2";
          } else {
            _selectedMemOrg = "option1";
          }

          val_LandOwner = farmerQryList[f]['landOwned'] ?? "";
          if (val_LandOwner == "0") {
            slct_LandOwner = "Self-Owned";
          } else if (val_LandOwner == "1") {
            slct_LandOwner = "Leased";
          }
          nameOwner.text = farmerQryList[f]['idPhoto'] ?? "";
          addressOwner.text = farmerQryList[f]['fpoFgGroup'] ?? "";
          agec.text = farmerQryList[f]['age'] ?? "";
          val_Gender = farmerQryList[f]['gender'] ?? "";

          if (val_Gender == "0") {
            val_Gender = "0";
            slct_Gender = "FEMALE";
          } else if (val_Gender == "1") {
            val_Gender = "1";
            slct_Gender = "MALE";
          } else {
            val_Gender = "";
            slct_Gender = "";
          }
          val_NationalID = farmerQryList[f]['recNo'] ?? "";
          nin.text = farmerQryList[f]['mobileNo'] ?? "";
          val_State = farmerQryList[f]['state'] ?? "";
          val_District = farmerQryList[f]['district'] ?? "";
          val_Taluk = farmerQryList[f]['city'] ?? "";
          val_Village = farmerQryList[f]['village'] ?? "";
          if (val_State.isNotEmpty) {
            changeDistrict(val_State);
          }
          List regionList = await db.RawQuery(
              'select distinct countryName from countryList c,stateList s where c.countryCode = s.countryCode and s.stateCode =\'' +
                  val_State +
                  '\'');
          if (regionList.isNotEmpty) {
            region = regionList[0]['countryName'].toString();
          }

          if (val_District.isNotEmpty) {
            changeCity(val_District);
          }

          if (val_Taluk.isNotEmpty) {
            changeVillage(val_Taluk);
            villageLoaded = true;
          }
          districtName = dropDownNameQryList[0]['farmCrop'] ?? "";
          subCountyName = dropDownNameQryList[0]['harvestedQty'] ?? "";
          parishName = dropDownNameQryList[0]['harvestedDate'] ?? "";
          villageName = dropDownNameQryList[0]['buyerName'] ?? "";
          address.text = farmerQryList[f]['address'] ?? "";
          email.text = farmerQryList[f]['email'] ?? "";
          String phoneNumbers = farmerQryList[f]['vendorType'] ?? "";
          String parsedMbNo = phoneNumbers.substring(4);
          print("mobile number:" + phoneNumbers.toString() + parsedMbNo);
          String mobileNumbers = farmerQryList[f]['licenseNo'] ?? "";
          //martial status
          val_Martial = farmerQryList[f]['maritalStatus'] ?? "";
          if (val_Martial.isNotEmpty) {
            List marSts = await db.RawQuery(
                'select * from animalCatalog where DISP_SEQ = \'' +
                    val_Martial +
                    '\'');
            slct_Martial = marSts[0]['property_value'] ?? "";
          }

          val_HeadFamily = farmerQryList[f]['daughter'] ?? "";
          print("val_HeadFamily-----" + val_HeadFamily);
          if (val_HeadFamily == "0") {
            slct_HeadFamily = "No";
          } else if (val_HeadFamily == "1") {
            slct_HeadFamily = "Yes";
          } else {
            slct_HeadFamily = "";
            val_HeadFamily = "";
          }
          familyHead.text = farmerQryList[f]['fatherName'] ?? "";
          totNumHouseHold.text = farmerQryList[f]['grandChildren'] ?? "";
          totAdultFamily.text = farmerQryList[f]['medicalFacilities'] ?? "";
          totChildren.text = farmerQryList[f]['educationFacilities'] ?? "";
          /*coffee farm equipments*/
          slct_CoffeeFarm = dropDownNameQryList[0]['harvestedAmt'] ?? "";
          valCoffeeFarm = farmerQryList[f]['otherBusPotential'] ?? "";
          valPostHarvest = farmerQryList[f]['communication'] ?? "";
          slct_PostHarvest = dropDownNameQryList[0]['cropPhoto'] ?? "";

          val_LandTenure = farmerQryList[f]['educationLevel'] ?? "";
          //land tenure
          if (val_LandTenure.isNotEmpty) {
            List landTenures = await db.RawQuery(
                'select * from animalCatalog where DISP_SEQ = \'' +
                    val_LandTenure +
                    '\'');
            slct_LandTenure = landTenures[0]['property_value'] ?? "";
          }

          val_LevelEducation = farmerQryList[f]['foliarApp'] ?? "";
          //level of education
          if (val_LevelEducation.isNotEmpty) {
            List levelEdu = await db.RawQuery(
                'select * from animalCatalog where DISP_SEQ = \'' +
                    val_LevelEducation +
                    '\'');
            slct_LevelEducation = levelEdu[0]['property_value'];
          }

          totNumFarms.text = farmerQryList[f]['priningTipping'] ?? "";
          healthSelect = farmerQryList[f]['plucking'] ?? "";
          if (healthSelect == "1") {
            _selectedHealthIns = "option2";
          } else {
            _selectedHealthIns = "option1";
          }
          nameCompany.text = farmerQryList[f]['spraying'] ?? "";
          amount.text = farmerQryList[f]['indigenTechKnowledge'] ?? "";
          val_Period = farmerQryList[f]['samCode'] ?? "";
          if (val_Period.isNotEmpty) {
            List perList = await db.RawQuery(
                'select * from animalCatalog where DISP_SEQ = \'' +
                    val_Period +
                    '\'');
            slct_Period = perList[0]['property_value'] ?? "";
          }

          farmSelect = farmerQryList[0]['gpCode'].toString() ?? "";

          if (farmSelect == "1") {
            _selectedFarmIns = "option2";
          } else {
            _selectedFarmIns = "option1";
          }

          val_NameCrop = farmerQryList[f]['coCode'] ?? "";
          if (val_NameCrop.isNotEmpty) {
            List crpList = await db.RawQuery(
                'select name from procurementProducts where code = \'' +
                    val_NameCrop +
                    '\'');
            print("crpList:" + crpList.toString());
            slct_NameCrop = crpList[0]['name'] ?? "";
          }

          amount1.text = farmerQryList[f]['farmerSurname'] ?? "";
          String fPhoto = farmerQryList[f]['frPhoto'] ?? "";
          String fSign = farmerQryList[f]['signature'] ?? "";
          String disabilityStatus = farmerQryList[f]['tenant'] ?? "";
          val_Disability = disabilityStatus;
          if (disabilityStatus == "CG00426") {
            slct_Disability = "Disabled";
          } else {
            slct_Disability = "Not Disabled";
          }

          print("farmer photo:" + fSign);
          File? _beneficiaryimage;
          if (fPhoto.isNotEmpty) {
            _beneficiaryimage = File(fPhoto);
          }

          if (fSign.isNotEmpty) {
            File _signImage = File(fSign);
            List<int> imageBytes = _signImage.readAsBytesSync();
            String signPhoto = base64Encode(imageBytes);
            signImg = const Base64Decoder().convert(signPhoto);
          }

          print("farmer signature:" + signImg.toString());

          //name of crop/entity

          String parsedMbNo1 = mobileNumbers.substring(4);

          setState(() {
            phoneNumber.text = parsedMbNo;
            mobileMoneyNumber.text = parsedMbNo1;
            farmerImageFile = _beneficiaryimage;
            encoded = fSign;
            farmerSign = fSign;
            farmerSignPath = fSign;
          });
        }
        if (orgQryList.isNotEmpty) {
          print("organization called");
          for (int o = 0; o < orgQryList.length; o++) {
            String nameOrganization = orgQryList[o]['bankName'];
            String addressOrganizations = orgQryList[o]['bankACNumber'];

            List nOrgList = await db.RawQuery(
                'select * from coOperative where coCode = \'' +
                    nameOrganization +
                    '\'');
            String nOrg = "";
            for (int n = 0; n < nOrgList.length; n++) {
              nOrg = nOrgList[n]['coName'];
              setState(() {
                var bankDetaillist = BankDetail(
                    nOrg, addressOrganizations, nameOrganization, '', '');
                bankDetailList.add(bankDetaillist);
                memberOrgLoaded = true;
              });
            }
          }
        }
      }
    } catch (e) {
      EasyLoading.dismiss();
    }
  }

  getClientData() async {
    agents = await db.RawQuery('SELECT * FROM agentMaster');

    print("agent_master:" + agents.toString());

    seasoncode = agents[0]['currentSeasonCode'];
    servicePointId = agents[0]['servicePointId'];
    agendId = agents[0]['agentId'];
    String resIdd = agents[0]['resIdSeqAgg'];
    agentType = agents[0]['agentType'];
    //print("resIdgetcliendata" + resIdd);
    print("agendId_agendId" + agentType + agendId);
    farmerIdGeneration();

    print("farmerid_farmergeneration" + farmerid.toString());
  }

  void farmerIdGeneration() {
    print("farmerIDgenearation");
    String temp = agents[0]['curIdSeqAgg'];
    int curId = int.parse(agents[0]['curIdSeqAgg']);
    print("curId_curId" + curId.toString());
    resId = int.parse(agents[0]['resIdSeqAgg']);
    print("resId_resId" + resId.toString());
    curIdLim = int.parse(agents[0]['curIdLimitAgg']);
    print("curIdLim_curIdLim" + curIdLim.toString()); //45
    int newIdGen = 0;
    int incGenId = curId + 1;
    print("incGenId_incGenId" + incGenId.toString());
    curIdLimited = 0;
    int MAX_Limit = 5;
    if (incGenId <= curIdLim) {
      newIdGen = incGenId;
      print('farmer_id_lessthan ' + newIdGen.toString());
      farmerid = newIdGen;
    } else {
      if (resId != 0) {
        newIdGen = resId + 1;
        curId = newIdGen;
        curIdLimited = resId + MAX_Limit;
        print("curdid limited:" + curIdLimited.toString());
        print('resId ' + resId.toString());
        resId = 0;
        print('farmer_id_notequal ' + newIdGen.toString());
        farmerid = newIdGen;
      } else {
        print('farmer_id_else ' + newIdGen.toString());
        farmerid = newIdGen;
      }
    }
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

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> initvalues() async {
//countrylist
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

    List nameOrgList = await db.RawQuery('select * from coOperative');
    print(' maritalList' + nameOrgList.toString());

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

    List gList = [
      {"property_value": "MALE", "DISP_SEQ": "1"},
      {"property_value": "FEMALE", "DISP_SEQ": "0"}
    ];

    List genderList = await db.RawQuery(
        'select * from animalCatalog where catalog_code = \'' + "30" + '\'');
    print(' genderList' + genderList.toString());

    genderitems.clear();
    for (int i = 0; i < gList.length; i++) {
      String typurchseName = gList[i]["property_value"].toString();
      String typurchseCode = gList[i]["DISP_SEQ"].toString();

      var uimodel = new UImodel(typurchseName, typurchseCode);

      setState(() {
        genderitems.add(DropdownModel(
          typurchseName,
          typurchseCode,
        ));
      });
    }

    List coffeeOrgList = await db.RawQuery(
        'select * from animalCatalog where catalog_code = \'' + "123" + '\'');
    print(' maritalList' + coffeeOrgList.toString());

    coffeeOrganizationitems.clear();
    for (int i = 0; i < coffeeOrgList.length; i++) {
      String typurchseName = coffeeOrgList[i]["property_value"].toString();
      String typurchseCode = coffeeOrgList[i]["DISP_SEQ"].toString();
      var uimodel = new UImodel(typurchseName, typurchseCode);

      setState(() {
        coffeeOrganizationitems.add(DropdownModel(
          typurchseName,
          typurchseCode,
        ));
      });
    }

    List nationalIDList = [
      {"property_value": "National ID Number (NIN)", "DISP_SEQ": "nin"},
      {"property_value": "Driver's License", "DISP_SEQ": "dln"},
      {"property_value": "Voter's Card", "DISP_SEQ": "vin"}
    ];

    // List nationalIDList = await db.RawQuery(
    //     'select * from animalCatalog where catalog_code = \'' + "28" + '\'');
    print(' maritalList' + nationalIDList.toString());

    nationaliditems.clear();
    for (int i = 0; i < nationalIDList.length; i++) {
      String typurchseName = nationalIDList[i]["property_value"].toString();
      String typurchseCode = nationalIDList[i]["DISP_SEQ"].toString();
      var uimodel = new UImodel(typurchseName, typurchseCode);

      setState(() {
        nationaliditems.add(DropdownModel(
          typurchseName,
          typurchseCode,
        ));
      });
    }

    List martialList = await db.RawQuery(
        'select * from animalCatalog where catalog_code = \'' + "123" + '\'');
    print(' maritalList' + martialList.toString());

    martialItems.clear();
    for (int i = 0; i < martialList.length; i++) {
      String typurchseName = martialList[i]["property_value"].toString();
      String typurchseCode = martialList[i]["DISP_SEQ"].toString();
      var uimodel = new UImodel(typurchseName, typurchseCode);

      setState(() {
        martialitems.add(DropdownModel(
          typurchseName,
          typurchseCode,
        ));
      });
    }

    List headFamilyList = [
      {"property_value": "Yes", "DISP_SEQ": "1"},
      {"property_value": "No", "DISP_SEQ": "0"}
    ];

    headfamilyitems.clear();
    for (int i = 0; i < headFamilyList.length; i++) {
      String typurchseName = headFamilyList[i]["property_value"].toString();
      String typurchseCode = headFamilyList[i]["DISP_SEQ"].toString();
      var uimodel = new UImodel(typurchseName, typurchseCode);

      setState(() {
        headfamilyitems.add(DropdownModel(
          typurchseName,
          typurchseCode,
        ));
      });
    }

    List totNumChildrenList = await db.RawQuery(
        'select * from animalCatalog where catalog_code = \'' + "123" + '\'');
    print(' headFamilyList' + totNumChildrenList.toString());

    totChildrenitems.clear();
    for (int i = 0; i < totNumChildrenList.length; i++) {
      String typurchseName = totNumChildrenList[i]["property_value"].toString();
      String typurchseCode = totNumChildrenList[i]["DISP_SEQ"].toString();
      var uimodel = new UImodel(typurchseName, typurchseCode);

      setState(() {
        totChildrenitems.add(DropdownModel(
          typurchseName,
          typurchseCode,
        ));
      });
    }

    List coffeeFarmList = await db.RawQuery(
        'select * from animalCatalog where catalog_code = \'' + "36" + '\'');
    print(' headFamilyList' + coffeeFarmList.toString());

    coffeeFarmItems.clear();
    coffeeFarmUIModel = [];
    for (int i = 0; i < coffeeFarmList.length; i++) {
      String typurchseName = coffeeFarmList[i]["property_value"].toString();
      String typurchseCode = coffeeFarmList[i]["DISP_SEQ"].toString();
      var uimodel = new UImodel(typurchseName, typurchseCode);
      coffeeFarmUIModel.add(uimodel);

      setState(() {
        coffeeFarmItems.add(DropdownMenuItem(
          value: typurchseName,
          child: Text(typurchseName),
        ));
      });
    }

    List postHarvestList = await db.RawQuery(
        'select * from animalCatalog where catalog_code = \'' + "37" + '\'');
    print(' headFamilyList' + postHarvestList.toString());

    postHarvestItems.clear();
    postHarvestUIModel = [];
    for (int i = 0; i < postHarvestList.length; i++) {
      String typurchseName = postHarvestList[i]["property_value"].toString();
      String typurchseCode = postHarvestList[i]["DISP_SEQ"].toString();
      var uimodel = new UImodel(typurchseName, typurchseCode);
      postHarvestUIModel.add(uimodel);

      setState(() {
        postHarvestItems.add(DropdownMenuItem(
          value: typurchseName,
          child: Text(typurchseName),
        ));
      });
    }

    List landTenureList = await db.RawQuery(
        'select * from animalCatalog where catalog_code = \'' + "31" + '\'');
    print(' landTenureList' + landTenureList.toString());

    landtenureitems.clear();
    for (int i = 0; i < landTenureList.length; i++) {
      String typurchseName = landTenureList[i]["property_value"].toString();
      String typurchseCode = landTenureList[i]["DISP_SEQ"].toString();
      var uimodel = new UImodel(typurchseName, typurchseCode);

      setState(() {
        landtenureitems.add(DropdownModel(
          typurchseName,
          typurchseCode,
        ));
      });
    }

    List coffeetypeList = await db.RawQuery('select * from varietyList');
    print(' landTenureList' + coffeetypeList.toString());

    coffeeTypeItems.clear();
    for (int i = 0; i < coffeetypeList.length; i++) {
      String typurchseName = coffeetypeList[i]["vName"].toString();
      String typurchseCode = coffeetypeList[i]["vCode"].toString();
      var uimodel = new UImodel(typurchseName, typurchseCode);
      coffeeTypeUIModel.add(uimodel);

      setState(() {
        coffeeTypeItems.add(DropdownMenuItem(
          value: typurchseName,
          child: Text(typurchseName),
        ));
      });
    }

    List levelEducationList = await db.RawQuery(
        'select * from animalCatalog where catalog_code = \'' + "128" + '\'');
    print(' levelEducationList' + levelEducationList.toString());

    leveleducationitems.clear();
    for (int i = 0; i < levelEducationList.length; i++) {
      String typurchseName = levelEducationList[i]["property_value"].toString();
      String typurchseCode = levelEducationList[i]["DISP_SEQ"].toString();
      var uimodel = new UImodel(typurchseName, typurchseCode);

      setState(() {
        leveleducationitems.add(DropdownModel(
          typurchseName,
          typurchseCode,
        ));
      });
    }

    List landOwnerList = [
      {
        'property_value': 'Self-Owned',
        'DISP_SEQ': '0',
      },
      {
        'property_value': 'Leased',
        'DISP_SEQ': '1',
      }
    ];
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

    List periodList = await db.RawQuery(
        'select * from animalCatalog where catalog_code = \'' + "34" + '\'');
    print(' periodList' + periodList.toString());

    perioditems.clear();
    for (int i = 0; i < periodList.length; i++) {
      String typurchseName = periodList[i]["property_value"].toString();
      String typurchseCode = periodList[i]["DISP_SEQ"].toString();
      var uimodel = new UImodel(typurchseName, typurchseCode);

      setState(() {
        perioditems.add(DropdownModel(
          typurchseName,
          typurchseCode,
        ));
      });
    }

    List schemeList = await db.RawQuery(
        'select * from animalCatalog where catalog_code = \'' + "29" + '\'');
    print(' schemeList' + schemeList.toString());

    certificationItems.clear();
    certificationUIModel = [];
    for (int i = 0; i < schemeList.length; i++) {
      String typurchseName = schemeList[i]["property_value"].toString();
      String typurchseCode = schemeList[i]["DISP_SEQ"].toString();
      var uimodel = new UImodel(typurchseName, typurchseCode);
      certificationUIModel.add(uimodel);
      setState(() {
        certificationItems.add(DropdownMenuItem(
          value: typurchseName,
          child: Text(typurchseName),
        ));
      });
    }

    List cropList = await db.RawQuery('select * from procurementProducts');
    print(' cropList' + cropList.toString());

    namecropitems.clear();
    for (int i = 0; i < cropList.length; i++) {
      String typurchseName = cropList[i]["name"].toString();
      String typurchseCode = cropList[i]["code"].toString();
      var uimodel = new UImodel(typurchseName, typurchseCode);

      setState(() {
        namecropitems.add(DropdownModel(
          typurchseName,
          typurchseCode,
        ));
      });
    }

    List disabilityList = await db.RawQuery(
        'select * from animalCatalog where catalog_code = \'' + "351" + '\'');
    print(' disabilityList' + disabilityList.toString());

    disabilityItem.clear();
    for (int i = 0; i < disabilityList.length; i++) {
      String typurchseName = disabilityList[i]["property_value"].toString();
      String typurchseCode = disabilityList[i]["DISP_SEQ"].toString();
      var uimodel = new UImodel(typurchseName, typurchseCode);

      setState(() {
        disabilityItem.add(DropdownModel(
          typurchseName,
          typurchseCode,
        ));
      });
    }

    // _progressHUD.state.dismiss();
    EasyLoading.dismiss();
  }

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

  LoadRegion(String cCode) async {
    List regionList = await db.RawQuery(
        'select distinct countryName from countryList c,stateList s where c.countryCode = s.countryCode and s.stateCode =\'' +
            cCode +
            '\'');
    if (regionList.isNotEmpty) {
      region = regionList[0]['countryName'].toString();
    }
  }

  Future<void> LoadAddress(String coCode) async {
    List addressList = await db.RawQuery(
        'select * from coOperative where coCode =\'' + coCode + '\'');
    print('stateList ' + addressList.toString());

    for (int i = 0; i < addressList.length; i++) {
      String address = addressList[i]['address1'].toString();

      setState(() {
        addressOrg = true;
        addressOrganization = address;
        //stateList.add(stateName);
      });
    }
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

  // Future displayDateRangePicker(BuildContext context) async {
  //   final List<DateTime> picked = await DateRangePicker.showDatePicker(
  //       context: context,
  //       initialFirstDate: _startDate,
  //       initialLastDate: _endDate,
  //       firstDate: new DateTime(DateTime.now().year - 50),
  //       lastDate: new DateTime(DateTime.now().year + 50));
  //   if (picked != null && picked.length == 2) {
  //     setState(() {
  //       _startDate = picked[0];
  //       _endDate = picked[1];
  //     });
  //   }
  // }

  // void showDemoDialog({BuildContext? context}) {
  //   showDialog<dynamic>(
  //     context: context!,
  //     builder: (BuildContext context) => CalendarPopupView(
  //       barrierDismissible: true,
  //       minimumDate: DateTime.now(),
  //       initialEndDate: _endDate,
  //       initialStartDate: _startDate,
  //       onApplyClick: (DateTime startData, DateTime endData) {
  //         setState(() {
  //           _startDate = startData;
  //           _endDate = endData;
  //         });
  //       },
  //     ),
  //   );
  // }

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
              TranslateFun.langList['coFaCls'],
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

  List<Widget> _getListings(BuildContext context) {
    List<Widget> listings = [];
    //Filfare image;
    int i = 0;
    for (i = 0; i < 5; i++) {
      if (i == 0) {
        listings.add(txt_label_mandatory(
            "Date Of Registration", Colors.black, 14.0, false));
        // listings.add(cardlable_dynamic(registrationFormatedDate));

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

        listings.add(txt_label_mandatory(
            TranslateFun.langList['faCoCls'], Colors.black, 14.0, false));

        listings.add(cardlable_dynamic(farmerid.toString()));

        listings
            .add(txt_label_mandatory("First Name", Colors.black, 14.0, false));
        listings.add(txtfield_dynamic("First Name", farmerName, true, 25));

        listings
            .add(txt_label_mandatory("Other Name", Colors.black, 14.0, false));
        listings.add(txtfield_dynamic("Other Name", otherName, true, 25));

        listings.add(txt_label_mandatory(
            "Member Of a Coffee Organization/Cooperative",
            Colors.black,
            14.0,
            false));

        listings.add(radio_dynamic(
            map: memberOrg,
            selectedKey: _selectedMemOrg,
            onChange: (value) {
              setState(() {
                _selectedMemOrg = value!;
                if (value == 'option1') {
                  setState(() {
                    memOrgSelect = '0';
                    memberOrgLoaded = false;
                    val_NameOrganization = "";
                    addressOrganization = "";
                    slctNameOrganization = null;
                    bankDetailList.clear();
                  });
                } else if (value == 'option2') {
                  setState(() {
                    memOrgSelect = '1';
                    memberOrgLoaded = true;
                  });
                }

                print("genderSelect_genderSelect " +
                    memOrgSelect +
                    "eeee" +
                    _selectedMemOrg);
              });
            }));

        /*  listings.add(radio_dynamic(
            map: farmIns,
            selectedKey: _selectedFarmIns,
            onChange: (value) {
              setState(() {
                _selectedFarmIns = value!;
                if (value == 'option1') {
                  farmSelect = "0";
                  isFarmIns = false;
                  val_NameCrop = "";
                  slctNameCrop = null;
                  amount1.clear();
                } else if (value == 'option2') {
                  farmSelect = "1";
                  isFarmIns = true;
                }

                print("_selectedHealth" + _selectedFarmIns);
              });
            }));*/

        if (memOrgSelect == '1') {
          listings.add(txt_label_mandatory(
              "Name Of Organization / Cooperative", Colors.black, 14.0, false));
          listings.add(DropDownWithModel(
            itemlist: nameOrganizationitems,
            selecteditem: slctNameOrganization,
            hint: "Select Name Of Organization / Cooperative",
            onChanged: (value) {
              setState(() {
                slctNameOrganization = value!;
                val_NameOrganization = slctNameOrganization!.value;
                slct_NameOrganization = slctNameOrganization!.name;
                LoadAddress(val_NameOrganization);
                print("name of the organization:" + val_NameOrganization);
              });
            },
          ));

          if (addressOrg) {
            listings.add(txt_label_mandatory(
                "Address Of Organization/Cooperative",
                Colors.black,
                14.0,
                false));

            listings.add(cardlable_dynamic(addressOrganization));
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

                if (slct_NameOrganization.isNotEmpty &&
                    slct_NameOrganization.length > 0) {
                  /* if (addressOrganization.isNotEmpty &&
                      addressOrganization.length > 0) {*/
                  for (int i = 0; i < bankDetailList.length; i++) {
                    if (val_NameOrganization == bankDetailList[i].accNumber) {
                      already = true;
                    }
                  }
                  if (!already) {
                    var bankDetaillist = BankDetail(slct_NameOrganization,
                        addressOrganization, val_NameOrganization, '', '');
                    setState(() {
                      bankDetailList.add(bankDetaillist);
                      slct_NameOrganization = "";
                      val_NameOrganization = "";
                      slctNameOrganization = null;
                      addressOrganization = "";
                    });
                  } else {
                    errordialog(context, TranslateFun.langList['infoCls'],
                        "Name of Organization/Cooperatives already added");
                  }
                  /* } else {
                    errordialog(context, TranslateFun.langList['infoCls'],
                        TranslateFun.langList['adofOrCoshnobeemCls']);
                  }*/
                } else {
                  errordialog(context, TranslateFun.langList['infoCls'],
                      TranslateFun.langList['naofOrshnobeemCls']);
                }

                // if (slct_NameOrganization.isEmpty &&
                //     slct_NameOrganization == '') {
                //   errordialog(context, TranslateFun.langList['infoCls'],
                //       TranslateFun.langList['naofOrshnobeemCls']);
                // } else if (addressOrganization.isEmpty &&
                //     addressOrganization == '') {
                //   errordialog(context, TranslateFun.langList['infoCls'],
                //       TranslateFun.langList['adofOrCoshnobeemCls']);
                // }for(int i=0;i<bankDetailList.length;i++){
                //
                // } else {
                //   var bankDetaillist = BankDetail(slct_NameOrganization,
                //       addressOrganization, val_NameOrganization, '', '');
                //   setState(() {
                //     bankDetailList.add(bankDetaillist);
                //   });
                // }
              }));

          if (bankDetailList.length > 0) {
            listings.add(bankListTable());
          }
        }

        // listings.add(txt_label_mandatory(
        //     "Coffee organization / company scheme", Colors.black, 14.0, false));
        // listings.add(DropDownWithModel(
        //   itemlist: coffeeOrganizationitems,
        //   selecteditem: slctCofeeOrganization,
        //   hint: "Select Coffee organization / company scheme",
        //   onChanged: (value) {
        //     setState(() {
        //       slctCofeeOrganization = value!;
        //       val_CoffeeOrganization = slctCofeeOrganization!.value;
        //       slct_CoffeeOrganization = slctCofeeOrganization!.name;
        //     });
        //   },
        // ));
        listings.add(txt_label_mandatory(
            "Type Of Land Owned", Colors.black, 14.0, false));
        listings.add(DropDownWithModel(
          itemlist: landOwnerItem,
          selecteditem: slctLandOwner,
          hint: slct_LandOwner.isEmpty
              ? "Select Type Of Land Owned"
              : slct_LandOwner,
          onChanged: (value) {
            setState(() {
              slctLandOwner = value!;
              val_LandOwner = slctLandOwner!.value;
              slct_LandOwner = slctLandOwner!.name;
              print('val_LandOwner' + val_LandOwner);
              print('slct_LandOwner' + slct_LandOwner);
            });
          },
        ));
        if (val_LandOwner == '1') {
          listings.add(txt_label_mandatory(
              "Name Of Owner Of The Land", Colors.black, 14.0, false));
          listings.add(txtfield_digitCharacter1(
              "Name Of Owner of The Land", nameOwner, true));

          listings.add(txt_label_mandatory(
              "Address Of Owner Of The Land", Colors.black, 14.0, false));
          listings.add(txtfield_digitCharacter1(
              "Address Of Owner Of The Land", addressOwner, true));
        }

        listings.add(txt_label_mandatory(
            "Farmer's Date Of Birth", Colors.black, 14.0, false));
        /*Date*/
        listings.add(selectDate(
          context1: context,
          slctdate: dateofbirth,
          onConfirm: (date) => setState(() {
            dateofbirth = DateFormat('yyyy-MM-dd').format(date!);
            dateofbirthFormatedDate = DateFormat('yyyyMMdd').format(date);
            dbformatdate = DateFormat('dd-MM-yyyy').format(date);

            calculateAge(date);
          }),
        ));

        listings.add(txt_label_mandatory(
            TranslateFun.langList['ageCls'], Colors.black, 14.0, false));

        listings
            .add(txtfield_digits(TranslateFun.langList['ageCls'], agec, false));

        listings.add(txt_label_mandatory(
            TranslateFun.langList['genCls'], Colors.black, 14.0, false));

        listings.add(DropDownWithModel(
          itemlist: genderitems,
          selecteditem: slctGender,
          hint: slct_Gender.isEmpty
              ? TranslateFun.langList['seGeCls']
              : slct_Gender,
          onChanged: (value) {
            setState(() {
              slctGender = value!;
              val_Gender = slctGender!.value;
              slct_Gender = slctGender!.name;
              // if(slct_Gender == "Female"){
              //   val_Gender = "0";
              // }else{
              //   val_Gender = "1";
              // }
              print("gendervalue:" + val_Gender);
            });
          },
        ));

        // listings.add(radio_dynamic(
        //     map: genderMap,
        //     selectedKey: _selectedGender,
        //     onChange: (value) {
        //       setState(() {
        //         _selectedGender = value!;
        //         if (value == 'option1') {
        //           setState(() {
        //             genderSelect = '1';
        //           });
        //         } else if (value == 'option2') {
        //           setState(() {
        //             genderSelect = '0';
        //           });
        //         }
        //
        //         print("genderSelect_genderSelect " + genderSelect);
        //       });
        //     }));

        /* listings.add(txt_label_mandatory(
            "Identification Type", Colors.black, 14.0, false));
        listings.add(DropDownWithModel(
          itemlist: nationaliditems,
          selecteditem: slctNationalID,
          hint: slct_NationalID.isEmpty
              ? "Select Identification Type"
              : slct_NationalID,
          onChanged: (value) {
            setState(() {
              slctNationalID = value!;
              val_NationalID = slctNationalID!.value;
              slct_NationalID = slctNationalID!.name;
              nin.clear();
            });
          },
        ));*/
        listings.add(txt_label_mandatory(
            "National ID Number (NIN)", Colors.black, 14.0, false));
        listings.add(
            txtfield_digitCharacter("National ID Number (NIN)", nin, true, 14));
        /*   if (val_NationalID == "nin") {
          listings.add(
              txt_label("National ID number (NIN)", Colors.black, 14.0, false));
          listings.add(txtfield_digitCharacter(
              "National ID number (NIN)", nin, true, 14));
        } else if (val_NationalID == "dln") {
          listings.add(
              txt_label("Driver's license number", Colors.black, 14.0, false));
          listings.add(txtfield_digitCharacter(
              "Driver's license number", nin, true, 15));
        } else if (val_NationalID == "vin") {
          listings
              .add(txt_label("Voter's card number", Colors.black, 14.0, false));
          listings.add(
              txtfield_digitCharacter("Voter's card number", nin, true, 8));
        }*/

        // listings.add(txt_label_mandatory(
        //     TranslateFun.langList['couCls'], Colors.black, 14.0, false));
        // listings.add(cardlable_dynamic("Uganda"));
        /* listings.add(singlesearchDropdown(
            itemlist: countryitems,
            selecteditem: slctCountry,
            hint: TranslateFun.langList['sethCoCls'],
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
*/
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
            ? txt_label_mandatory(
                "Subcounty/Division", Colors.black, 14.0, false)
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
                itemlist: villageitems,
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

        /* listings.add(txt_label_mandatory(
            TranslateFun.langList['addCls'] + "ress",
            Colors.black,
            14.0,
            false));
        listings.add(txtfield_digitCharacter1(
            TranslateFun.langList['addCls'] + "ress", address, true));*/

        listings.add(txt_label(
            TranslateFun.langList['emaCls'], Colors.black, 14.0, false));
        listings
            .add(txtfield_email(TranslateFun.langList['emaCls'], email, true));

        listings.add(txt_label("Phone Number", Colors.black, 14.0, false));

        listings.add(Container(
          child: Row(
            children: [
              Expanded(
                child: cardlable_dynamic("+256"),
              ),
              Expanded(
                flex: 4,
                child: txtfield_digitswithoutdecimal(
                    "Phone Number", phoneNumber!, true, 9),
              ),
            ],
          ),
        ));
        /* listings.add(txtfield_digits(
            TranslateFun.langList['phnuCls'], phoneNumber, true, 11));*/

        listings
            .add(txt_label("Mobile Money Number", Colors.black, 14.0, false));

        listings.add(Container(
          child: Row(
            children: [
              Expanded(
                child: cardlable_dynamic("+256"),
              ),
              Expanded(
                flex: 4,
                child: txtfield_digitswithoutdecimal(
                    "Mobile Money Number", mobileMoneyNumber!, true, 9),
              ),
            ],
          ),
        ));
        /* listings.add(txtfield_digits(
            TranslateFun.langList['momonuCls'], mobileMoneyNumber, true, 11));*/

        listings.add(txt_label("Marital Status", Colors.black, 14.0, false));
        listings.add(DropDownWithModel(
          itemlist: martialitems,
          selecteditem: slctMartial,
          hint: slct_Martial.isEmpty ? "Select Marital Status" : slct_Martial,
          onChanged: (value) {
            setState(() {
              slctMartial = value!;
              val_Martial = slctMartial!.value;
              slct_Martial = slctMartial!.name;
            });
          },
        ));

        /*   listings.add(txt_label_mandatory(
            TranslateFun.langList['isthfaceCls'], Colors.black, 14.0, false));

        listings.add(radio_dynamic(
            map: isCertifiedFarmer,
            selectedKey: _selectedCeritifiedFarmer,
            onChange: (value) {
              setState(() {
                _selectedCeritifiedFarmer = value!;
                if (value == 'option1') {
                  certifiedSelect = "0";
                  isCertifiedFar = false;
                  val_Scheme = "";
                  slct_Scheme = "";
                  slctScheme = null;
                } else if (value == 'option2') {
                  certifiedSelect = "1";
                  isCertifiedFar = true;
                }

                print("certifiedSelectFarmer" + certifiedSelect);
              });
            }));

        if (isCertifiedFar) {
          listings.add(txt_label_mandatory(
              TranslateFun.langList['ifyewhscCls'], Colors.black, 14.0, false));

          listings.add(multisearchDropdownHint(
            itemlist: certificationItems,
            selectedlist: certification,
            hint: TranslateFun.langList['seScCls'],
            onChanged: (item) {
              setState(() {
                certification = item;
                String values = '';
                String cropValue = "";
                String quotation = "'";
                for (int i = 0; i < certificationUIModel.length; i++) {
                  for (int j = 0; j < item.length; j++) {
                    String name = item[j].toString();
                    if (name == certificationUIModel[i].name) {
                      String value = certificationUIModel[i].value;

                      if (values == "") {
                        values = value;
                        cropValue = value;
                      } else {
                        values = values + ',' + value;
                        cropValue =
                            cropValue + quotation + ',' + quotation + value;
                      }

                      valCertification = values;
                      print("certification:" + valCertification);
                      // valCropHSCode = valCropCategory;
                    }
                  }
                }
                // cropName(cropValue);
              });
            },
          ));
          */ /*listings.add(DropDownWithModel(
            itemlist: schemeitems,
            selecteditem: slctScheme,
            hint: TranslateFun.langList['seScCls'],
            onChanged: (value) {
              setState(() {
                slctScheme = value!;
                val_Scheme = slctScheme!.value;
                slct_Scheme = slctScheme!.name;
              });
            },
          ));*/ /*
        }*/

        listings.add(txt_label(
            "Is Farmer The Head Of The Family?", Colors.black, 14.0, false));
        listings.add(DropDownWithModel(
          itemlist: headfamilyitems,
          selecteditem: slctHeadFamily,
          hint: slct_HeadFamily.isEmpty
              ? "Select Head Of The Family"
              : slct_HeadFamily,
          onChanged: (value) {
            setState(() {
              slctHeadFamily = value!;
              val_HeadFamily = slctHeadFamily!.value;
              slct_HeadFamily = slctHeadFamily!.name;

              print('val_HeadFamily---' + val_HeadFamily);
              familyHead.clear();
            });
          },
        ));

        if (val_HeadFamily == "0") {
          listings.add(txt_label("Enter Name Of The Head Of The Family",
              Colors.black, 14.0, false));

          listings.add(txtfield_dynamic(
              "Enter Name Of The Head Of The Family", familyHead, true));
        }

        listings.add(txt_label_mandatory(
            "Total Number Of Household Members", Colors.black, 14.0, false));
        listings.add(txtfield_digits(
            "Total Number Of Household Members", totNumHouseHold, true));

        listings.add(txt_label("Total Adults In Family (Above 18 Years)",
            Colors.black, 14.0, false));
        listings.add(txtfield_digits(
            "Total Adults In Family (Above 18 Years)", totAdultFamily, true));

        listings.add(txt_label(
            "Total Number Of Children In The Family (Below 18 years)",
            Colors.black,
            14.0,
            false));

        listings.add(txtfield_digits(
            "Total Number Of Children In The Family (Below 18 years)",
            totChildren,
            true,
            25));

        listings.add(
            txt_label("Coffee Farm Equipments", Colors.black, 14.0, false));

        listings.add(multisearchDropdownHint(
          itemlist: coffeeFarmItems,
          selectedlist: coffeeFarm,
          hint: slct_CoffeeFarm.isEmpty
              ? "Select Coffee Farm Equipments"
              : slct_CoffeeFarm,
          onChanged: (item) {
            setState(() {
              coffeeFarm = item;
              String values = '';
              String names = '';
              String cropValue = "";
              String cropName = "";
              String quotation = "'";
              for (int i = 0; i < coffeeFarmUIModel.length; i++) {
                for (int j = 0; j < item.length; j++) {
                  String name = item[j].toString();
                  if (name == coffeeFarmUIModel[i].name) {
                    String value = coffeeFarmUIModel[i].value;
                    String name = coffeeFarmUIModel[i].name;

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

                    valCoffeeFarm = values;
                    slct_CoffeeFarm = names;
                    print(
                        "coffee farm:" + valCoffeeFarm + " " + slct_CoffeeFarm);
                    // valCropHSCode = valCropCategory;
                  }
                }
              }
              // cropName(cropValue);
            });
          },
        ));

        listings.add(
            txt_label("Post Harvest Facilities", Colors.black, 14.0, false));

        listings.add(multisearchDropdownHint(
          itemlist: postHarvestItems,
          selectedlist: postHarvest,
          hint: slct_PostHarvest.isEmpty
              ? "Select Post Harvest Facilities"
              : slct_PostHarvest,
          onChanged: (item) {
            setState(() {
              postHarvest = item;
              String values = '';
              String names = '';
              String cropValue = "";
              String cropName = "";
              String quotation = "'";
              for (int i = 0; i < postHarvestUIModel.length; i++) {
                for (int j = 0; j < item.length; j++) {
                  String name = item[j].toString();
                  if (name == postHarvestUIModel[i].name) {
                    String value = postHarvestUIModel[i].value;
                    String name = postHarvestUIModel[i].name;

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

                    valPostHarvest = values;
                    slct_PostHarvest = names;
                    print("post harvest:" +
                        valPostHarvest +
                        " " +
                        slct_PostHarvest);
                    // valCropHSCode = valCropCategory;
                  }
                }
              }
              // cropName(cropValue);
            });
          },
        ));

        listings.add(txt_label_mandatory(
            "Land Tenure System", Colors.black, 14.0, false));
        listings.add(DropDownWithModel(
          itemlist: landtenureitems,
          selecteditem: slctLandTenure,
          hint: slct_LandTenure.isEmpty
              ? "Select Land Tenure System"
              : slct_LandTenure,
          onChanged: (value) {
            setState(() {
              slctLandTenure = value!;
              val_LandTenure = slctLandTenure!.value;
              slct_LandTenure = slctLandTenure!.name;
            });
          },
        ));

        listings
            .add(txt_label("Level Of Education", Colors.black, 14.0, false));
        listings.add(DropDownWithModel(
          itemlist: leveleducationitems,
          selecteditem: slctLevelEducation,
          hint: slct_LevelEducation.isEmpty
              ? "Select Level Of Education"
              : slct_LevelEducation,
          onChanged: (value) {
            setState(() {
              slctLevelEducation = value!;
              val_LevelEducation = slctLevelEducation!.value;
              slct_LevelEducation = slctLevelEducation!.name;
            });
          },
        ));

        listings
            .add(txt_label("Total Number Of Farms", Colors.black, 14.0, false));
        listings
            .add(txtfield_digits("Total Number Of Farms", totNumFarms, true));

        listings.add(txt_label("Disability Status", Colors.black, 14.0, false));
        listings.add(DropDownWithModel(
          itemlist: disabilityItem,
          selecteditem: slctDisability,
          hint: slct_Disability.isEmpty
              ? "Select Disability Status"
              : slct_Disability,
          onChanged: (value) {
            setState(() {
              slctDisability = value!;
              val_Disability = slctDisability!.value;
              slct_Disability = slctDisability!.name;
            });
          },
        ));

        listings.add(txt_label("Farmer Photo", Colors.black, 14.0, false));

        listings.add(img_picker(
            label: "Farmer Photo \*",
            onPressed: () {
              imageDialog("Farmer");
            },
            filename: farmerImageFile,
            ondelete: () {
              ondelete("Farmer");
            }));

        listings
            .add(txt_label("Insurance Information", Colors.green, 20.0, true));

        listings.add(txt_label(
            TranslateFun.langList['heInCls'], Colors.black, 14.0, false));

        listings.add(radio_dynamic(
            map: healthIns,
            selectedKey: _selectedHealthIns,
            onChange: (value) {
              setState(() {
                _selectedHealthIns = value!;
                if (value == 'option1') {
                  healthSelect = "0";
                  isHealthIns = false;
                  nameCompany.clear();
                  amount.clear();
                  val_Period = "";
                  slctPeriod = null;
                } else if (value == 'option2') {
                  healthSelect = "1";
                  isHealthIns = true;
                }

                print("_selectedHealth" + _selectedHealthIns);
              });
            }));

        if (healthSelect == "1") {
          listings.add(txt_label(
              "If Yes, Name Of The Company", Colors.black, 14.0, false));
          listings.add(txtfield_dynamic(
              "If Yes, Name Of The Company", nameCompany, true));
          listings.add(txt_label(
              TranslateFun.langList['amoCls'], Colors.black, 14.0, false));
          listings.add(txtfieldAllowTwoDecimal(
              TranslateFun.langList['amoCls'], amount, true, 10));

          listings
              .add(txt_label("Period (How Long)", Colors.black, 14.0, false));
          listings.add(DropDownWithModel(
            itemlist: perioditems,
            selecteditem: slctPeriod,
            hint:
                slct_Period.isEmpty ? "Select Period (How Long)" : slct_Period,
            onChanged: (value) {
              setState(() {
                slctPeriod = value!;
                val_Period = slctPeriod!.value;
                slct_Period = slctPeriod!.name;
              });
            },
          ));
        }

        listings.add(
            txt_label("Farm Enterprise Insurance", Colors.black, 14.0, false));

        listings.add(radio_dynamic(
            map: farmIns,
            selectedKey: _selectedFarmIns,
            onChange: (value) {
              setState(() {
                _selectedFarmIns = value!;
                if (value == 'option1') {
                  farmSelect = "0";
                  isFarmIns = false;
                  val_NameCrop = "";
                  slctNameCrop = null;
                  amount1.clear();
                } else if (value == 'option2') {
                  farmSelect = "1";
                  isFarmIns = true;
                }

                print("_selectedHealth" + _selectedFarmIns);
              });
            }));

        if (farmSelect == "1") {
          listings.add(txt_label(
              "If Yes, Name Of The Crop/Entity", Colors.black, 14.0, false));

          listings.add(DropDownWithModel(
            itemlist: namecropitems,
            selecteditem: slctNameCrop,
            hint: slct_NameCrop.isEmpty
                ? "Select Name Of The Crop/Entity"
                : slct_NameCrop,
            onChanged: (value) {
              setState(() {
                slctNameCrop = value!;
                val_NameCrop = slctNameCrop!.value;
                slct_NameCrop = slctNameCrop!.name;
                print("name crop:" + val_NameCrop);
              });
            },
          ));

          listings.add(txt_label(
              TranslateFun.langList['amoCls'], Colors.black, 14.0, false));
          listings.add(txtfieldAllowTwoDecimal(
              TranslateFun.langList['amoCls'], amount1, true, 10));
        }

        listings.add(
            txt_label_mandatory("Farmer Signature", Colors.black, 14.0, false));

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

        listings.add(Container(
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: Container(
                  padding: EdgeInsets.all(3),
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
                flex: 0,
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
      }
    }
    return listings;
  }

  void btncancel() {
    _onBackPressed();
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

      signImg = data!;
      encodedValue = signImg.toString();
      print("sign image:" + encodedValue);
      encoded = base64Encode(signImg!);
      Uint8List bytes = base64Decode(encoded);
      String dir = (await getApplicationDocumentsDirectory()).path;
      File file = File(
          "$dir/" + DateTime.now().microsecondsSinceEpoch.toString() + ".jpg");
      await file.writeAsBytes(bytes);
      print("file path value:" + file.path);
      farmerSignPath = file.path;
      signdynClicked = false;
      _sign.clear();
      setState(() {});
    } else {
      errordialog(context, "Information", "Enter Signature");
    }
  }

  calculateAge(DateTime birthDate) {
    DateTime currentDate = DateTime.now();
    int age = currentDate.year - birthDate.year;
    int month1 = currentDate.month;
    int month2 = birthDate.month;
    if (month2 > month1) {
      age--;
    } else if (month1 == month2) {
      int day1 = currentDate.day;
      int day2 = birthDate.day;
      if (day2 > day1) {
        age--;
      }
    }
    setState(() {
      agec.text = age.toString();
    });
    return age;
  }

  void btnSubmit() {
    if (farmerImageFile != null) {
      farmerImage = farmerImageFile!.path;
    }

    if (registrationFormatedDate.isEmpty &&
        registrationFormatedDate.length == 0) {
      errordialog(context, TranslateFun.langList['infoCls'],
          TranslateFun.langList['daofreshnobeemCls']);
    } else if (farmerName.text.isEmpty && farmerName.text.length == 0) {
      errordialog(context, TranslateFun.langList['infoCls'],
          "First Name should not be empty");
    } else if (otherName.text.isEmpty && otherName.text.length == 0) {
      errordialog(context, TranslateFun.langList['infoCls'],
          "Other Name should not be empty");
    } else if (memOrgSelect == "1") {
      val();
    } else {
      val1();
    }
  }

  void val() {
    if (bankDetailList.length == 0) {
      errordialog(context, TranslateFun.langList['infoCls'],
          TranslateFun.langList['adatonmeCls']);
    } else if (val_LandOwner.isEmpty) {
      errordialog(context, TranslateFun.langList['infoCls'],
          'Type Of Land Owned should not be empty');
    } else if (val_LandOwner == '1' &&
        nameOwner.text.isEmpty &&
        nameOwner.text.length == 0) {
      errordialog(context, TranslateFun.langList['infoCls'],
          "Name Of Owner Of the Land should not be empty ");
    } else if (val_LandOwner == '1' &&
        addressOwner.text.isEmpty &&
        addressOwner.text.length == 0) {
      errordialog(context, TranslateFun.langList['infoCls'],
          "Address Of Owner Of The Land should not be empty");
    } else if (dateofbirthFormatedDate.isEmpty &&
        dateofbirthFormatedDate.length == 0) {
      errordialog(context, TranslateFun.langList['infoCls'],
          "Farmer's Date Of Birth should not be empty");
    } else if (agec.text.isEmpty && agec.text.length == 0) {
      errordialog(context, TranslateFun.langList['infoCls'],
          TranslateFun.langList['agshnobeemCls']);
    } else if (agec.value.text == "0") {
      errordialog(context, TranslateFun.langList['infoCls'],
          "Selected Age should not be zero");
    } else if (int.parse(agec.value.text) < 16) {
      errordialog(context, TranslateFun.langList['infoCls'],
          "Selected Age should be greater than or equal to 16");
    } else if (slct_Gender.isEmpty && slct_Gender.length == 0) {
      errordialog(context, TranslateFun.langList['infoCls'],
          TranslateFun.langList['geshnobeemCls']);
    } else if (nin.text.isEmpty) {
      errordialog(context, TranslateFun.langList['infoCls'],
          "National ID Number (NIN) Should not be empty");
    } else if (val_State.isEmpty) {
      errordialog(context, TranslateFun.langList['infoCls'],
          TranslateFun.langList['dishnobeemCls']);
    } else if (val_District.isEmpty) {
      errordialog(context, TranslateFun.langList['infoCls'],
          TranslateFun.langList['sushnobeemCls']);
    } else if (val_Taluk.isEmpty) {
      errordialog(context, TranslateFun.langList['infoCls'],
          TranslateFun.langList['pashnobeemCls']);
    } else if (val_Village.isEmpty) {
      errordialog(context, TranslateFun.langList['infoCls'],
          TranslateFun.langList['vishnobeemCls']);
    } /*else if (address.text.isEmpty && address.text.length == 0) {
      errordialog(context, TranslateFun.langList['infoCls'],
          TranslateFun.langList['adshnobeemCls']);
    }*/ /*else if (phoneNumber.text.isEmpty && phoneNumber.text.length == 0) {
      errordialog(context, TranslateFun.langList['infoCls'],
          TranslateFun.langList['phnushnobeemCls']);
    }*/
    else if (phoneNumber.text.isNotEmpty && phoneNumber.text.length < 9) {
      errordialog(context, TranslateFun.langList['infoCls'],
          "Enter Valid Phone Number");
    } else {
      validation1();
    }
  }

  void val1() {
    if (val_LandOwner.isEmpty) {
      errordialog(context, TranslateFun.langList['infoCls'],
          'Type Of Land Owned should not be empty');
    } else if (val_LandOwner == '1' &&
        nameOwner.text.isEmpty &&
        nameOwner.text.length == 0) {
      errordialog(context, TranslateFun.langList['infoCls'],
          "Name Of Owner Of The Land should not be empty");
    } else if (val_LandOwner == '1' &&
        addressOwner.text.isEmpty &&
        addressOwner.text.length == 0) {
      errordialog(context, TranslateFun.langList['infoCls'],
          "Address Of Owner Of The Land should not be empty");
    } else if (dateofbirthFormatedDate.isEmpty &&
        dateofbirthFormatedDate.length == 0) {
      errordialog(context, TranslateFun.langList['infoCls'],
          "Farmer's Date Of Birth should not be empty");
    } else if (agec.text.isEmpty && agec.text.length == 0) {
      errordialog(
          context, TranslateFun.langList['infoCls'], "Age should not be empty");
    } else if (agec.value.text == "0") {
      errordialog(context, TranslateFun.langList['infoCls'],
          "Selected Age should not be zero");
    } else if (int.parse(agec.value.text) < 16) {
      errordialog(context, TranslateFun.langList['infoCls'],
          "Selected Age should be greater than or equal to 16");
    } else if (slct_Gender.isEmpty && slct_Gender.length == 0) {
      errordialog(context, TranslateFun.langList['infoCls'],
          TranslateFun.langList['geshnobeemCls']);
    } else if (nin.text.isEmpty) {
      errordialog(context, TranslateFun.langList['infoCls'],
          "National ID Number (NIN) Should not be empty");
    } else if (nin.text.isNotEmpty && nin.text.length < 14) {
      errordialog(context, TranslateFun.langList['infoCls'],
          "National ID Number (NIN) Should not be less than 14 characters");
    } else if (val_State.isEmpty) {
      errordialog(context, TranslateFun.langList['infoCls'],
          TranslateFun.langList['dishnobeemCls']);
    } else if (val_District.isEmpty) {
      errordialog(context, TranslateFun.langList['infoCls'],
          TranslateFun.langList['sushnobeemCls']);
    } else if (val_Taluk.isEmpty) {
      errordialog(context, TranslateFun.langList['infoCls'],
          TranslateFun.langList['pashnobeemCls']);
    } else if (val_Village.isEmpty) {
      errordialog(context, TranslateFun.langList['infoCls'],
          TranslateFun.langList['vishnobeemCls']);
    } /*else if (address.text.isEmpty && address.text.length == 0) {
      errordialog(context, TranslateFun.langList['infoCls'],
          TranslateFun.langList['adshnobeemCls']);
    } */ /*else if (phoneNumber.text.isEmpty && phoneNumber.text.length == 0) {
      errordialog(context, TranslateFun.langList['infoCls'],
          TranslateFun.langList['phnushnobeemCls']);
    }*/
    else if (phoneNumber.text.isNotEmpty && phoneNumber.text.length < 9) {
      errordialog(context, TranslateFun.langList['infoCls'],
          "Enter Valid Phone Number");
    } else if (certifiedSelect.isEmpty && certifiedSelect.length == 0) {
      errordialog(context, TranslateFun.langList['infoCls'],
          TranslateFun.langList['isthFaceshnobeemCls']);
    } else if (certifiedSelect == "1") {
      validation();
    } else {
      validation1();
    }
  }

  void validation() {
    if (valCertification.isEmpty && valCertification.length == 0) {
      errordialog(context, TranslateFun.langList['infoCls'],
          TranslateFun.langList['scshnobeemCls']);
    } /* else if (familySelect == "0" && familyHead.text.isEmpty) {
      errordialog(context, "information",
          "Name of head of the family should not be empty");
    }*/
    else if (totNumHouseHold.text.isEmpty && totNumHouseHold.text.length == 0) {
      errordialog(context, TranslateFun.langList['infoCls'],
          "Total Number Of Household Members should not be empty");
    } else if (slct_LandTenure.isEmpty && slct_LandTenure.length == 0) {
      errordialog(context, TranslateFun.langList['infoCls'],
          "Land Tenure System should not be empty");
    } /* else if (coffeeType.isEmpty && coffeeType.length == 0) {
      errordialog(context, TranslateFun.langList['infoCls'],
          TranslateFun.langList['cotyshnobeemCls']);
    } */
    else if (email.text.isNotEmpty) {
      setState(() {
        String emailVal = email.text;
        print('not valid');
        final bool isValid = EmailValidator.validate(emailVal);
        if (!isValid) {
          errordialog(context, "information", "Enter valid email");
        } else {
          confirmation();
        }
      });
    } else if (encoded.isEmpty) {
      errordialog(context, TranslateFun.langList['infoCls'],
          "Farmer Signature should not be empty");
    } else {
      confirmation();
    }
  }

  void validation1() {
    /*if (familySelect == "0" && familyHead.text.isEmpty) {
      errordialog(context, "information",
          "Name of head of the family should not be empty");
    } else*/
    if (totNumHouseHold.text.isEmpty && totNumHouseHold.text.length == 0) {
      errordialog(context, TranslateFun.langList['infoCls'],
          "Total Number Of Household Members should not be empty");
    } else if (slct_LandTenure.isEmpty && slct_LandTenure.length == 0) {
      errordialog(context, TranslateFun.langList['infoCls'],
          "Land Tenure System should not be empty");
    } /* else if (coffeeType.isEmpty && coffeeType.length == 0) {
      errordialog(context, TranslateFun.langList['infoCls'],
          TranslateFun.langList['cotyshnobeemCls']);
    }*/
    else if (email.text.isNotEmpty) {
      setState(() {
        String emailVal = email.text;
        print('not valid');
        final bool isValid = EmailValidator.validate(emailVal);
        if (!isValid) {
          errordialog(context, "information", "Enter valid email");
        } else {
          confirmation();
        }
      });
    } else if (encoded.isEmpty) {
      errordialog(context, TranslateFun.langList['infoCls'],
          "Farmer Signature should not be empty");
    } else {
      confirmation();
    }
  }

  Widget bankListTable() {
    List<DataColumn> columns = <DataColumn>[];
    List<DataRow> rows = <DataRow>[];
    columns.add(DataColumn(label: Text('Name Of Organization/Cooperative')));
    columns.add(DataColumn(label: Text('Address Of Organization/Cooperative')));
    columns.add(DataColumn(label: Text('Delete')));

    for (int i = 0; i < bankDetailList.length; i++) {
      List<DataCell> singlecell = <DataCell>[];
      singlecell.add(DataCell(Text(bankDetailList[i].accHolderName)));
      singlecell.add(DataCell(Text(bankDetailList[i].bankName)));

      singlecell.add(DataCell(InkWell(
        onTap: () {
          setState(() {
            bankDetailList.removeAt(i);
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

  void ondelete(String photo) {
    setState(() {
      if (photo == "Farmer") {
        setState(() {
          farmerImageFile = null;
        });
      } else if (photo == "ID") {
        if (licenceImageFile != null) {
          setState(() {
            licenceImageFile = null;
          });
        }
      } else if (photo == "Aadhaar") {
        if (idProofImageFile != null) {
          setState(() {
            idProofImageFile = null;
          });
        }
      }
    });
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
              saveDraft();
              Navigator.pop(context);
              //Put your code here which you want to execute on No button click.
            },
            color: Colors.green,
          )
        ]).show();
  }

  Future getImageFromCamera(String photo) async {
    var image = await ImagePicker.platform
        .pickImage(source: ImageSource.camera, imageQuality: 30);
    setState(() {
      if (photo == "Farmer") {
        farmerImageFile = File(image!.path);
      } else if (photo == "ID") {
        licenceImageFile = File(image!.path);
      } else if (photo == "Aadhaar") {
        idProofImageFile = File(image!.path);
      }
    });
  }

  Future getImageFromGallery(String photo) async {
    var image = await ImagePicker.platform
        .pickImage(source: ImageSource.gallery, imageQuality: 30);
    setState(() {
      if (photo == "Farmer") {
        farmerImageFile = File(image!.path);
      } else if (photo == "ID") {
        licenceImageFile = File(image!.path);
      } else if (photo == "Aadhaar") {
        idProofImageFile = File(image!.path);
      }
    });
  }

  // void calculateAge(DateTime birthDate) {
  //   DateTime currentDate = DateTime.now();
  //   int age = currentDate.year - birthDate.year;
  //   int month1 = currentDate.month;
  //   int month2 = birthDate.month;
  //   if (month2 > month1) {
  //     age--;
  //   } else if (month1 == month2) {
  //     int day1 = currentDate.day;
  //     int day2 = birthDate.day;
  //     if (day2 > day1) {
  //       age--;
  //     }
  //   }
  //   agec.text = age.toString();
  // }

  saveFarmerceo() async {
    db.RawQuery("Delete from farmerkettle where isSynched = '2'");
    db.DeleteTable("harvestData");
    db.RawQuery("Delete from bankList where otherAccountType = '2'");
    Random rnd = new Random();
    int recNo = 100000 + rnd.nextInt(999999 - 100000);
    //String revNo = "CTB"+recNo.toString();
    String revNo = "FE" + farmerid.toString();
    var formatDate = "";
    final now = new DateTime.now();
    String txntime = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
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
/*
    await db.saveCustTransaction(
        txntime, datas.txnFarmerEnrollment, farmerid.toString(), '', '', '');
*/
    setState(() {});

    int t = await db.saveCustTransaction(
        txntime, datas.txnFarmerEnrollment, farmerid.toString(), '', '', '');

    //  toast("txn executor called" + t.toString());

    print('farmer inserting');

    String placeRegistration = registrationFormatedDate;
    String farmerCode = "UCDA/F/" + formatDate + "/" + farmerid.toString();
    String firstNameVal = farmerName.text;
    String otherNameVal = otherName.text;
    String memberCoffeeOrg = memOrgSelect;
    String nameOwnerVal = nameOwner.text;
    String addressOwnerVal = addressOwner.text;
    String dob = dateofbirthFormatedDate;
    String age = agec.text;
    String gender = val_Gender;
    String nationalID = val_NationalID;
    String ninVal = nin.text;
    String farmerPhoto = farmerImage;
    String addressVal = address.text;
    String country = val_Country;
    String district = val_State;
    String subCountry = val_District;
    String parishWard = val_Taluk;
    String village = val_Village;
    String emailVal = email.text;
    String phoneNum = "";
    if (phoneNumber.text.isNotEmpty) {
      phoneNum = "+256" + phoneNumber.text;
    } else {
      phoneNum = "";
    }

    String mobileMonNum = "";
    if (mobileMoneyNumber.text.isNotEmpty) {
      mobileMonNum = "+256" + mobileMoneyNumber.text;
    } else {
      mobileMonNum = "";
    }
    String martialStatus = val_Martial;
    String isFarmerCertified = certifiedSelect;
    String scheme = val_Scheme;
    String headFamily = val_HeadFamily;
    String totFamHouseHold = totNumHouseHold.text;
    String totAdultFam = totAdultFamily.text;
    String totChildFam = totChildren.text;
    String coffeeFarm = valCoffeeFarm;
    String postHarvest = valPostHarvest;
    String landTenure = val_LandTenure;
    String coffeeType = valCoffeeType;
    String levelEducation = val_LevelEducation;
    String totLandOwnedFarmer = totLandOwned.text;
    String totNumFarm = totNumFarms.text;
    String healthIns = healthSelect;
    String nameCompanyVal = nameCompany.text;
    String amountVal = amount.text;
    String periodVal = val_Period;
    String farmIns = farmSelect;
    String nameCropVal = val_NameCrop;
    String amountVal1 = amount1.text;
    String group = '';
    String hFamilyName = familyHead.text;
    String landOwned = val_LandOwner;

    int f = await db.saveFarmerData1(
        landOwned,
        registrationFormatedDate,
        farmerid.toString(),
        farmerCode,
        firstNameVal,
        otherNameVal,
        farmerImage,
        gender,
        dob,
        age,
        memberCoffeeOrg,
        val_Martial,
        nameOwnerVal,
        val_State,
        val_District,
        val_Taluk,
        val_Village,
        addressOwnerVal,
        nin.text,
        emailVal,
        address.text,
        phoneNum,
        mobileMonNum,
        certifiedSelect,
        valCertification,
        val_HeadFamily,
        totFamHouseHold,
        totAdultFam,
        totChildFam,
        coffeeFarm,
        postHarvest,
        landTenure,
        coffeeType,
        levelEducation,
        totLandOwnedFarmer,
        totNumFarm,
        healthSelect,
        nameCompanyVal,
        amountVal,
        periodVal,
        txntime,
        Lng,
        Lat,
        emailVal,
        farmIns,
        nameCropVal,
        "0",
        val_NationalID,
        val_Disability,
        hFamilyName,
        amountVal1,
        val_Country,
        group,
        farmerSign.isEmpty ? farmerSignPath : farmerSign);

    String bankACNumber = "";
    String bankName = "";
    if (bankDetailList.length > 0) {
      for (int i = 0; i < bankDetailList.length; i++) {
        bankACNumber = bankDetailList[i].bankName;
        bankName = bankDetailList[i].accNumber;
        String bankBranch = "";
        String IFSCcode = "";
        String SWIFTcode = "";
        String accountType = "";
        String otherAccountType = "";

        int saveBankDetails = await db.saveBankDetails(
            farmerid.toString(),
            bankACNumber,
            bankName,
            bankBranch,
            IFSCcode,
            SWIFTcode,
            accountType,
            otherAccountType);
        print("bankdetails:" + saveBankDetails.toString());
      }
    }

    db.UpdateTableValue(
        'farmerkettle', 'isSynched', '0', 'farmerId', farmerid.toString());

    if (curIdLimited != 0) {
      db.UpdateTableValue('agentMaster', 'curIdSeqAgg', farmerid.toString(),
          'agentId', agendId);
      db.UpdateTableValue(
          'agentMaster', 'resIdSeqAgg', resId.toString(), 'agentId', agendId);
      db.UpdateTableValue('agentMaster', 'curIdLimitAgg',
          curIdLimited.toString(), 'agentId', agendId);
    } else {
      db.UpdateTableValue('agentMaster', 'curIdSeqAgg', farmerid.toString(),
          'agentId', agendId);
    }

    if (agentType == "03") {
      print("update farmer called");
      // db.UpdateTableValue("farmer_master", "blockId", "0", "farmerId", farmerid.toString());
      db.UpdateTableValue("farmer_master", "maritalStatus", dbformatdate,
          "farmerId", farmerid.toString());
    }

    Alert(
      context: context,
      type: AlertType.info,
      title: TranslateFun.langList['txnSuccCls'],
      desc: TranslateFun.langList['coFaEnSuCls'],
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

    // Navigator.pop(context);
    // Navigator.pop(context);
  }

  saveFarmerpcda() async {
    db.RawQuery("Delete from farmerkettle where isSynched = '2'");
    db.DeleteTable("harvestData");
    db.RawQuery("Delete from bankList where otherAccountType = '2'");
    Random rnd = new Random();
    int recNo = 100000 + rnd.nextInt(999999 - 100000);
    //String revNo = "CTB"+recNo.toString();
    String revNo = "FE" + farmerid.toString();
    var formatDate = "";
    final now = new DateTime.now();
    String txntime = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
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
/*
    await db.saveCustTransaction(
        txntime, datas.txnFarmerEnrollment, farmerid.toString(), '', '', '');
*/

    int t = await db.saveCustTransaction(
        txntime, datas.txnFarmerEnrollment, farmerid.toString(), '', '', '');

    //  toast("txn executor called" + t.toString());

    print('farmer inserting');

    String placeRegistration = registrationFormatedDate;
    String farmerCode = "UCDA/F/" + formatDate + "/" + farmerid.toString();
    String firstNameVal = farmerName.text;
    String otherNameVal = otherName.text;
    String memberCoffeeOrg = memOrgSelect;
    String nameOwnerVal = nameOwner.text;
    String addressOwnerVal = addressOwner.text;
    String dob = dateofbirthFormatedDate;
    String age = agec.text;
    String gender = val_Gender;
    String nationalID = val_NationalID;
    String ninVal = nin.text;
    String farmerPhoto = farmerImage;
    String addressVal = address.text;
    String country = val_Country;
    String district = val_State;
    String subCountry = val_District;
    String parishWard = val_Taluk;
    String village = val_Village;
    String emailVal = email.text;
    String phoneNum = "+256" + phoneNumber.text;
    String mobileMonNum = "+256" + mobileMoneyNumber.text;
    String martialStatus = val_Martial;
    String isFarmerCertified = certifiedSelect;
    String scheme = val_Scheme;
    String headFamily = val_HeadFamily;
    String totFamHouseHold = totNumHouseHold.text;
    String totAdultFam = totAdultFamily.text;
    String totChildFam = totChildren.text;
    String coffeeFarm = valCoffeeFarm;
    String postHarvest = valPostHarvest;
    String landTenure = val_LandTenure;
    String coffeeType = valCoffeeType;
    String levelEducation = val_LevelEducation;
    String totLandOwnedFarmer = totLandOwned.text;
    String totNumFarm = totNumFarms.text;
    String healthIns = healthSelect;
    String nameCompanyVal = nameCompany.text;
    String amountVal = amount.text;
    String periodVal = val_Period;
    String farmIns = farmSelect;
    String nameCropVal = val_NameCrop;
    String amountVal1 = amount1.text;
    String group = '';
    String hFamilyName = familyHead.text;
    String landOwned = val_LandOwner;

    int f = await db.saveFarmerData1(
        landOwned,
        registrationFormatedDate,
        farmerid.toString(),
        farmerCode,
        firstNameVal,
        otherNameVal,
        farmerImage,
        gender,
        dob,
        age,
        memberCoffeeOrg,
        val_Martial,
        nameOwnerVal,
        val_State,
        val_District,
        val_Taluk,
        val_Village,
        addressOwnerVal,
        nin.text,
        emailVal,
        address.text,
        phoneNum,
        mobileMonNum,
        certifiedSelect,
        valCertification,
        val_HeadFamily,
        totFamHouseHold,
        totAdultFam,
        totChildFam,
        coffeeFarm,
        postHarvest,
        landTenure,
        coffeeType,
        levelEducation,
        totLandOwnedFarmer,
        totNumFarm,
        healthSelect,
        nameCompanyVal,
        amountVal,
        periodVal,
        txntime,
        Lng,
        Lat,
        emailVal,
        farmIns,
        nameCropVal,
        "0",
        val_NationalID,
        val_Disability,
        hFamilyName,
        amountVal1,
        val_Country,
        group,
        farmerSign.isEmpty ? farmerSignPath : farmerSign);

    if (bankDetailList.length > 0) {
      for (int i = 0; i < bankDetailList.length; i++) {
        String bankACNumber = bankDetailList[i].bankName;
        String bankName = bankDetailList[i].accNumber;
        String bankBranch = "";
        String IFSCcode = "";
        String SWIFTcode = "";
        String accountType = "";
        String otherAccountType = "";

        int saveBankDetails = await db.saveBankDetails(
            farmerid.toString(),
            bankACNumber,
            bankName,
            bankBranch,
            IFSCcode,
            SWIFTcode,
            accountType,
            otherAccountType);
        print("bankdetails:" + saveBankDetails.toString());
      }
    }

    db.UpdateTableValue(
        'farmerkettle', 'isSynched', '0', 'farmerId', farmerid.toString());

    if (curIdLimited != 0) {
      db.UpdateTableValue('agentMaster', 'curIdSeqAgg', farmerid.toString(),
          'agentId', agendId);
      db.UpdateTableValue(
          'agentMaster', 'resIdSeqAgg', resId.toString(), 'agentId', agendId);
      db.UpdateTableValue('agentMaster', 'curIdLimitAgg',
          curIdLimited.toString(), 'agentId', agendId);
    } else {
      db.UpdateTableValue('agentMaster', 'curIdSeqAgg', farmerid.toString(),
          'agentId', agendId);
    }

    Alert(
      context: context,
      type: AlertType.info,
      title: TranslateFun.langList['txnSuccCls'],
      desc: TranslateFun.langList['coFaEnSuCls'],
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

    // Navigator.pop(context);
    // Navigator.pop(context);
  }

  //draft functionality implementation
  saveDraft() async {
    var formatDate = "";
    final now = new DateTime.now();
    String txntime = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
    String msgNo = DateFormat('yyyyMMddHHmmss').format(now);
    var dttime = DateTime.parse(txntime);
    formatDate = "${dttime.year}";

    db.RawQuery("Delete from farmerkettle where isSynched = '2'");
    db.DeleteTable('harvestData');
    db.RawQuery("Delete from bankList where otherAccountType = '2'");

    if (farmerImageFile != null) {
      farmerImage = farmerImageFile!.path;
    }

    print('val_HeadFamily----' + val_HeadFamily);

    String placeRegistration = registrationFormatedDate;
    String farmerCode = "UCDA/F/" + formatDate + "/" + farmerid.toString();
    String firstNameVal = farmerName.text;
    String otherNameVal = otherName.text;
    String memberCoffeeOrg = memOrgSelect;
    String nameOwnerVal = nameOwner.text;
    String addressOwnerVal = addressOwner.text;
    String dob = dateofbirthFormatedDate;
    String age = agec.text;
    String gender = val_Gender;
    String nationalID = val_NationalID;
    String ninVal = nin.text;
    String farmerPhoto = farmerImage;
    String addressVal = address.text;
    String country = val_Country;
    String district = val_State;

    String subCountry = val_District;
    String parishWard = val_Taluk;
    String village = val_Village;
    String emailVal = email.text;
    String phoneNum = "+256" + phoneNumber.text;
    String mobileMonNum = "+256" + mobileMoneyNumber.text;
    String martialStatus = val_Martial;
    String isFarmerCertified = certifiedSelect;
    String scheme = val_Scheme;
    String headFamily = val_HeadFamily;
    String totFamHouseHold = totNumHouseHold.text;
    String totAdultFam = totAdultFamily.text;
    String totChildFam = totChildren.text;
    String coffeeFarm = valCoffeeFarm;
    String postHarvest = valPostHarvest;
    String landTenure = val_LandTenure;
    String coffeeType = valCoffeeType;
    String levelEducation = val_LevelEducation;
    String totLandOwnedFarmer = totLandOwned.text;
    String totNumFarm = totNumFarms.text;
    String healthIns = healthSelect;
    String nameCompanyVal = nameCompany.text;
    String amountVal = amount.text;
    String periodVal = val_Period;
    String farmIns = farmSelect;
    String nameCropVal = val_NameCrop;
    String amountVal1 = amount1.text;
    String group = dateofbirth;
    String hFamilyName = familyHead.text;
    String landOwned = val_LandOwner;

    int f = await db.saveFarmerData1(
        landOwned,
        registrationFormatedDate,
        farmerid.toString(),
        farmerCode,
        firstNameVal,
        otherNameVal,
        farmerImage,
        gender,
        dob,
        age,
        memberCoffeeOrg,
        val_Martial,
        nameOwnerVal,
        val_State,
        val_District,
        val_Taluk,
        val_Village,
        addressOwnerVal,
        nin.text,
        emailVal,
        address.text,
        phoneNum,
        mobileMonNum,
        certifiedSelect,
        valCertification,
        headFamily,
        totFamHouseHold,
        totAdultFam,
        totChildFam,
        coffeeFarm,
        postHarvest,
        landTenure,
        coffeeType,
        levelEducation,
        totLandOwnedFarmer,
        totNumFarm,
        healthSelect,
        nameCompanyVal,
        amountVal,
        periodVal,
        txntime,
        Lng,
        Lat,
        emailVal,
        farmIns,
        nameCropVal,
        "2",
        val_NationalID,
        val_Disability,
        hFamilyName,
        amountVal1,
        val_Country,
        group,
        farmerSignPath);

    int fr = await db.saveNameData(
        districtName: districtName,
        subCountyName: subCountyName,
        parishName: parishName,
        villageName: villageName,
        coffeeFarmEquipments: slct_CoffeeFarm,
        postHarvestFacilities: slct_PostHarvest,
        date: slct_Period,
        other: registrationDate);

    if (bankDetailList.length > 0) {
      for (int i = 0; i < bankDetailList.length; i++) {
        String bankACNumber = bankDetailList[i].bankName;
        String bankName = bankDetailList[i].accNumber;
        String bankBranch = "";
        String IFSCcode = "";
        String SWIFTcode = "";
        String accountType = "";
        String otherAccountType = "2";

        int saveBankDetails = await db.saveBankDetails(
            farmerid.toString(),
            bankACNumber,
            bankName,
            bankBranch,
            IFSCcode,
            SWIFTcode,
            accountType,
            otherAccountType);
        print("bankdetails:" + saveBankDetails.toString());
      }
    }

    Alert(
      context: context,
      type: AlertType.info,
      title: "Success",
      desc: "Farmer Draft Successful",
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

    // Navigator.pop(context);
    // Navigator.pop(context);
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
              if (agentType == "03") {
                saveFarmerceo();
              } else {
                saveFarmerpcda();
              }

              Navigator.pop(context);
            },
            color: Colors.green,
          )
        ]).show();
  }
}

class BankDetail {
  String accHolderName, bankName, accNumber, ifscCode, bankCode;

  BankDetail(this.accHolderName, this.bankName, this.accNumber, this.ifscCode,
      this.bankCode);
}
