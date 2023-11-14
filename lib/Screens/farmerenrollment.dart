import 'dart:async';
import 'dart:convert';
import 'dart:math';
import '../Database/Databasehelper.dart';
import '../Database/Model/FarmerMaster.dart';
import '../Model/Geoareascalculate.dart';
import '../Model/Treelistmodel.dart';
import '../Model/UIModel.dart';
import '../Model/animalmodel.dart';
import '../Model/bankInfoModel.dart';
import '../Model/dynamicfields.dart';
import '../Model/equipmentmodel.dart';
import '../Plugins/TxnExecutor.dart';
import '../Utils/MandatoryDatas.dart';
import 'geoploattingProposedLand.dart';
import 'geoplottingaddfarm.dart';
import 'navigation.dart';
import 'package:cupertino_radio_choice/cupertino_radio_choice.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'dart:io' show File;
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';


class FarmerEnrollment extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _FarmerEnrollment();
  }
}

class _FarmerEnrollment extends State<FarmerEnrollment> {
  var db = DatabaseHelper();

  List<UImodel> icsnamelistModel = [];
  List<UImodel> icstracelistModel = [];
  //so we can call snackbar from anywhere
  List<UImodel> enrolllistModel = [];
  List<UImodel> countryUIModel = [];
  List<UImodel> stateUIModel = [];
  List<UImodel> districtUIModel = [];
  List<UImodel> cityListUIModel = [];
  List<UImodel> PanchayatListUIModel = [];
  List<UImodel> VillageListUIModel = [];
  List<UImodel> idProofUIModel = [];
  List<UImodel> marritallistModel = [];
  List<UImodel> educationlistModel = [];
  List<UImodel> farmequpmentslistModel = [];
  List<UImodel> animalhusbandarysModel = [];
  List<UImodel> consumerelectronicsModel = [];
  List<UImodel> vehiclesUIModel = [];
  List<UImodel> AccountTypeUIModel = [];
  // List<UImodel> LoanTypeUIModel = [];
  List<UImodel> CropTypeUIModel = [];
  List<UImodel> fodderModel = [];
  List<UImodel> animalhousingModel = [];
  List<UImodel> groupsModel = [];
  List<UImodel> certificationModel = [];
  List<UImodel> loanTakenModel = [];
  List<UImodel> loanPurposeModel = [];
  List<UImodel> loanSecurityModel = [];
  List<UImodel> positionGroupModel = [];
  List<UImodel> SchemeModel = [];
  List<UImodel> CategoryModel = [];
  List<UImodel> cuntryUIModel = [];
  List<UImodel> zoneUIModel = [];
  List<UImodel> woredaUIModel = [];
  List<UImodel> kebeleUIModel = [];
  List<UImodel> chieftownUIModel = [];

  List<DropdownModel> idProofitems = [];
  DropdownModel? slctidProofs;

  List<DropdownModel> cuntryitems = [];
  DropdownModel? slctcuntry;

  List<DropdownModel> zoneitems = [];
  DropdownModel? slctzone;

  List<DropdownModel> woredaitems = [];
  DropdownModel? slctworeda;

  List<DropdownModel> chiefTownitems = [];
  DropdownModel? slctchiefTowns;

  List<DropdownModel> kebeleitems = [];
  DropdownModel? slctkebele;

  List<DropdownModel> villageiteams = [];
  DropdownModel? slctvillage;

  List<DropdownModel> typgrupitems = [];
  DropdownModel? slcttypgrup;

  List<DropdownModel> namegrupitems = [];
  DropdownModel? slctnmaegrup;

  List<DropdownModel> positgrupitems = [];
  DropdownModel? slctpositgrup;

  List<DropdownModel> loanitems = [];
  DropdownModel? slctLoanType;

  List<DropdownModel> maptoitems = [];
  DropdownModel? slctmapto;

  List<DropdownModel> enrollemntitems = [];
  DropdownModel? slctEnrol;

  List<DropdownModel> educationitems = [];
  DropdownModel? slctEdu;

  String seedlingdate = 'Date of Birth';
  String farmerCodeval = "";

  List<Map> agents = [];

  bool stateLoaded = false;
  bool districtLoaded = false;
  bool cityLoaded = false;

  bool regionloaded = false;
  bool zoneloaded = false;
  bool woredaloaded = false;
  bool chieftownloaded = false;
  bool kebeleLoaded = false;
  bool villageLoaded = false;
  DropdownModel? slctProofs;
  String slctProof = '';
  String slctcertType = "",
      slctCountry = "",
      slctState = "",
      slctDistrict = "",
      slctTaluk = "",
      slctGram = "",
      slctVillage = "",
      slctGroups = "",
      slctMarital = "",
      slctEquipment = "",
      slctVechile = "",
      slctElectronic = "",
      slctAnimalHouse = "",
      slctfodder = "",
      slctAnimal = "",
      slctAccType = "",
      slctCropType = "",
      slctICS = "",
      slctTrace = "",
      slctLoanPurpose = '',
      slctLoanSecurity = '',
      slctPositionGropup = '',
      slctScheme = '',
      slctCategory = '',
      slctCrop = '',
      slctCircle = '',
      slctCommune = '',
      slctChieftown = '';
  List<DropdownModel> idproofitems = [];
  List<DropdownMenuItem> fodderitems = [],
      equipmentitems = [],
      certitypeitems = [],
      districtitems = [],
      cityitems = [],
      countryitems = [],
      stateitems = [],
      ditrictitems = [],
      talukitems = [],
      grampanchayatitems = [],
      groupitems = [],
      maritalitems = [],
      animalitems = [],
      animalhouseitems = [],
      acctypeitems = [],
      loantypeitems = [],
      croptypeitems = [],
      vechileitems = [],
      electronicitems = [],
      icsnameitems = [],
      icstraceitems = [],
      loanPurposeitems = [],
      loanSecurityitem = [],
      positiongroupitem = [],
      schemeitems = [],
      cateogryitems = [],
      chieftownitems = [];

  List<int> selectedequipments = [];
  List<int> selectedfodders = [];
  List<int> selectedelectronics = [];
  List<int> selectedvehicles = [];
  //List<int> selectedcrop = [];

  List<BankInformation> banklist = [];
  List<AnimalInfo> animallist = [];
  List<EquipmentModel> equipmentlist = [];

  TextEditingController? farmerNameController,
      enrollPersonController,
      fatherNameController,
      GrndfthNameController,
      mobileController,
      educatController,
      surNameController,
      loanAmountContoller,
      purposeContoller,
      accountnoController,
      bankController,
      branchController,
      yrbrthController,
      icsnameController,
      icscodeController,
      ageController,
      proofnoController,
      adhaarnoController,
      amtController,
      amthelController,
      acreController,
      amtCropController,
      addressController,
      phoneController,
      emailController,
      totNoFamilyController,
      totAdultMController,
      totAdultFController,
      totalChildMController,
      totChildFController,
      schlGoingMController,
      schlGoingFController,
      totHouseholdController,
      totHouseholdMController,
      totHouseholdFController,
      animalcountController,
      animalrevenueController,
      animalBreedController,
      estimateManureController,
      estimateUrineController,
      equipmentcountController,
      ifscController,
      icsfarmercodeController,
      icstracenetController,
      loanInterestController,
      loanRepaymentController,
      AdhaarcardController;

  String yuthalt = '';
  int elegibleRegister = 0;
  String  val_cuntry = "",val_zone="",val_woreda="",val_kebele="",val_typrgrup="",val_namegrup="",
      val_positgrup="",val_loanklst="",val_mapto="",val_enroll="",val_edu="";
  String slct_Zone="",slctCuntry="",slct_woreda="",slct_kebele="",slct_typgrup="",slct_namegrup="",
      slct_positgrup="",slct_loanlsyear="",slct_mapto="",slct_enroll="",slct_edu="";
  String val_certType = "",
      val_Enrol = "",
      val_Proof = "",
      val_State = "",
      val_District = "",
      val_Taluk = "",
      val_Gram = "",
      val_Village = "",
      val_Groups = "",
      val_Edu = "",
      val_Marital = "",
      val_Equipment = "",
      val_Vechile = "",
      val_Electronic = "",
      val_AnimalHouse = "",
      val_fodder = "",
      val_Animal = "",
      val_AccType = "",
      val_CropType = "",
      val_LoanType = "",
      val_ICSName = "",
      val_ICSTracenet = "",
      val_loanpurpose = '',
      val_loansecurity = '',
      val_positionGroup = '',
      val_Scheme = '',
      val_Categroy = '',
      val_circle = '',
      val_chieftown = '';

  int farmerid = 0;
  bool isregistration = false;
  bool gramPanchayat = false;
  bool isloantaken = false;
  String Lat = '0', Lng = '0';
  String seasoncode = '';
  String servicePointId = '';
  String agendId = '';

  List<String> educationList = ['Loading'];
  List<String> groupList = ['Loading'];
  List<String> countryList = ['Loading'];
  List<String> stateList = ['Loading'];
  List<String> distList = ['Loading'];
  List<String> talukList = ['Loading'];
  List<String> panchayatList = ['Loading'];
  List<String> kebeleList = ['Loading'];
  List<String> maritalList = ['Loading'];
  List<String> equipmentList = ['Loading'];
  List<String> electronicsList = ['Loading'];
  List<String> vechileList = ['Loading'];
  List<String> enrolList = ['Loading'];

  List<String> certtypeList = ['Loading'];

  List<String> prooflist = ['Loading'];

  List<String> salTypeList = ['Loading'];
  List<String> animalhouseList = ['Loading'];
  List<String> fodderList = ['Loading'];
  List<String> animalList = ['Loading'];

  List<String> regionList = ['Loading'];
  List<String> circleList = ['Loading'];
  List<String> woredaList = ['Loading'];
  List<String> chieftownList = ['Loading'];

  final Map<String, String> genderMap = {
    'option1': "MALE",
    'option2': "FEMALE",
  };

  final Map<String, String> appartgroup = {
    'option1': "NO",
    'option2': "YES",
  };
  final Map<String, String> cellphone = {
    'option1': "NO",
    'option2': "YES",
  };

  final Map<String, String> lifeInsurance = {
    'option1': "NO",
    'option2': "YES",
  };

  final Map<String, String> healthInsu = {
    'option1': "NO",
    'option2': "YES",
  };

  final Map<String, String> cropInsurance = {
    'option1': "NO",
    'option2': "YES",
  };

  final Map<String, String> loanTaken = {
    'option1': "NO",
    'option2': "YES",
  };

  final Map<String, String> interestPeriod = {
    'option1': "Month",
    'option2': "Year",
  };
  bool appargrup=false;
  String _selectedGender = "option1",
      _selectedAppargroup = "option1",
      genderSelect = "",
      appargrupSelect = "",
      _selectHead = "",
      _slctcellPhone = "1",
      _selectedlifeInsu = "2",
      _lifeInsurance = "option1",
      _selectedHealth = "2",
      helathInsurance = "option1",
      _selectedCropInsu = "2",
      insuranceCrop = "option1",
      _selectedloan = "2",
      loanTypeselected = "option1",
      _selectedinterestperiod = "1",
      interest = "option1";
  String enrollmentDate = "",
      enrollmentFormatedDate = "",
      dateofbirth = '',
      dateofbirthFormatedDate = '',
      loanRepaymentDate = "",
      loanRepaymentFormatedDate = '',
      icsjoiningDate = 'Select year',
      farmerImage64 = "",
      idProofimage64 = "",
      dateofyear = "";

  File? farmerImageFile;
  File? bankImageFile;
  File? idProofImageFile;
  int curIdLim = 0;
  int resId = 0;
  int curIdLimited = 0;
  bool addbank = false;
  bool loan_Taken = false;

  FormFieldSetter<dynamic>? _myActivities;
  String? _myActivitiesResult;

  final animalListitems = [
    {
      'display': "MALE1",
      'value': "MALE1",
    },
    {
      'display': "MALE2",
      'value': "MALE2",
    },
    {
      'display': "MALE3",
      'value': "MALE3",
    },
    {
      'display': "MALE4",
      'value': "MALE4",
    },
  ];

  String farmerenrollment = 'Farmer Registration';
  String PersonalInfo = 'Personal Information';
  String FName = 'Farmer Name';
  String FthrName = 'Father Name';
  String FCode = 'Farmer Code';
  String GrndfthrName = 'Grandfather Name';
  String Dob = 'Date of birth';
  String Gender = 'Gender';
  String male = 'Male';
  String female = 'Female';
  String IDproof = 'ID Proof';
  String IDproofHint = 'Select the ID Proof';
  String ProofNo = 'Proof No';
  String FarmerPhoto = 'Farmer Photo';
  String cuntry = 'Country';
  String cuntryHint = 'Select the Country';
  String zone = 'Zone';
  String zoneHint = 'Select the Zone';
  String woreda = 'Woreda';
  String woredaHint = 'Select the Woreda';
  String chiefTown = 'Chief Town';
  String chiefTownHint = 'Select the Chief Town';
  String kebele = 'Kebele';
  String KebeleHint = 'Select the Kebele';
  String mobileNo = 'Mobile Number';
  String noFamilyMem = 'Number of Family Memebers';
  String typgrcup = 'Type of group';
  String namegrup = 'Name of the group';
  String positgrup = 'Position in the Group';
  String typgrupHint = 'Select the Type of group';
  String namegrupHint = 'Select the Name of the group';
  String positgrupHint = 'Select the Position in the Group';
  String save = 'Save';
  String chse = 'Choose';
  String galry = 'Gallery';
  String pickimg = 'Pick Image';
  String Camera = 'Camera';
  String deny = 'deny';
  String onlytym = 'only this time';
  String whiluseapp = 'While using the app ';
  String Allowtakepic = 'Allow IronKettle to take picture and record video?';
  String info = 'Information';
  String infoFname = 'Farmer Name should not be empty';
  String infoFthname = 'Father Name should not be empty';
  String infodob = 'Date of Birth should not be empty';
  String infocuntry = 'Country should not be empty';
  String infocircle = 'Circle should not be empty';
  String infoworeda = 'Woreda should not be empty';
  String infChiefcommune = 'Chief Town should not be empty';
  String infokebele = 'Kebele should not be empty';
  String transactionsuccesfull = 'Transaction Successful';
  String farmersuccess = 'Farmer Registration Successfull';
  String infonof = 'Number of Family Members should not be empty';
  String infogroupco = 'Group / CoOperative should not be empty';
  String cancel = 'Cancel';
  String rusurecancel = 'Are you sure want to cancel?';
  String success = 'Success !';
  String confirm = 'Confirmation';
  String proceed = 'Are you sure you want to Proceed?';
  String yes = 'Yes';
  String no = 'No';
  String gpslocation = 'GPS Location not enabled';
  String ok = 'OK';
  @override
  void initState() {
    super.initState();

    initvalues();
    getClientData();
    translate();
    genderSelect = male;
    val_loanklst="NO";
    enrollPersonController = new TextEditingController();
    farmerNameController = new TextEditingController();
    fatherNameController = new TextEditingController();
    GrndfthNameController = new TextEditingController();
    mobileController = new TextEditingController();
    surNameController = new TextEditingController();
    loanAmountContoller = new TextEditingController();
    purposeContoller = new TextEditingController();
    accountnoController = new TextEditingController();
    bankController= new TextEditingController();
    branchController= new TextEditingController();
    yrbrthController = new TextEditingController();
    icsnameController = new TextEditingController();
    icscodeController = new TextEditingController();
    ageController = new TextEditingController();
    proofnoController = new TextEditingController();
    adhaarnoController = new TextEditingController();
    amtController = new TextEditingController();
    amthelController = new TextEditingController();
    acreController = new TextEditingController();
    addressController = new TextEditingController();
    educatController = new TextEditingController();
    phoneController = new TextEditingController();
    emailController = new TextEditingController();
    totNoFamilyController = new TextEditingController();
    totAdultMController = new TextEditingController();
    totAdultFController = new TextEditingController();
    totalChildMController = new TextEditingController();
    totChildFController = new TextEditingController();
    schlGoingMController = new TextEditingController();
    schlGoingFController = new TextEditingController();
    totHouseholdController = new TextEditingController();
    totHouseholdMController = new TextEditingController();
    totHouseholdFController = new TextEditingController();
    animalcountController = new TextEditingController();
    animalrevenueController = new TextEditingController();
    animalBreedController = new TextEditingController();
    estimateManureController = new TextEditingController();
    estimateUrineController = new TextEditingController();
    accountnoController = new TextEditingController();
    bankController = new TextEditingController();
    branchController = new TextEditingController();
    ifscController = new TextEditingController();
    equipmentcountController = new TextEditingController();
    icsfarmercodeController = new TextEditingController();
    icstracenetController = new TextEditingController();
    loanInterestController = new TextEditingController();
    loanRepaymentController = new TextEditingController();
    AdhaarcardController = new TextEditingController();
    amtCropController = new TextEditingController();

    yrbrthController!.addListener(() {
      setState(() {
        calAgeyr();
      });
    });

    isloantaken = false;
    getLocation();
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
      Alert(context: context, title: info, desc: gpslocation, buttons: [
        DialogButton(
          child: Text(
            ok,
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
    String resIdd = agents[0]['resIdSeqF'];
    print("resIdgetcliendata" + resIdd);
    print("agendId_agendId" + agendId);
    farmerIdGeneration();

    print("farmerid_farmergeneration" + farmerid.toString());
  }

  void farmerIdGeneration() {
    print("farmerIDgenearation");
    String temp = agents[0]['curIdSeqF'];
    int curId = int.parse(agents[0]['curIdSeqF']);
    print("curId_curId" + curId.toString());
    resId = int.parse(agents[0]['resIdSeqF']);
    print("resId_resId" + resId.toString());
    curIdLim = int.parse(agents[0]['curIdLimitF']);
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

  Future<void> initvalues() async {
    loan_Taken = false;
    //enrollment place
    List enrolllist= await db.RawQuery('select * from dropdownValues where catalog_code = \'ENROLLPLACE\' and lang =\'en\'');
    print('enrolllist ' + enrolllist.toString());
    enrollemntitems.clear();
    for (int i = 0; i < enrolllist.length; i++) {
      String property_value = enrolllist[i]["property_value"].toString();
      String DISP_SEQ = enrolllist[i]["DISP_SEQ"].toString();

      setState(() {
        enrollemntitems.add(DropdownModel(
          property_value,
          DISP_SEQ,
        ));
      });
    }
    /*String qryics =
        'SELECT anicat.DISP_SEQ,anicat.catalog_code,IF''(dylang.langValue,anicat.property_value) as property_value,anicat._ID from '
        'animalCatalog as anicat LEFT JOIN dynamiccomponentLanguage as dylang ON dylang.componentID = anicat.DISP_SEQ and dylang.langCode = \'en\' '
        'order by upper(anicat.DISP_SEQ) asc;';
    print('icslist ' + qryics);
    List icslist = await db.RawQuery(qryics);

    icsnamelistModel = [];
    icsnameitems.clear();

    icstracelistModel = [];
    icstraceitems.clear();

    print('icslist ' + icslist.toString());

    for (int i = 0; i < icslist.length; i++) {
      if (icslist[i]["catalog_code"].toString() == "28") {
        String property_value = icslist[i]["property_value"].toString();
        String DISP_SEQ = icslist[i]["DISP_SEQ"].toString();
        var uimodel = new UImodel(property_value, DISP_SEQ);
        icsnamelistModel.add(uimodel);
        setState(() {
          icsnameitems.add(DropdownMenuItem(
            child: Text(property_value),
            value: property_value,
          ));
        });
      } else if (icslist[i]["catalog_code"].toString() == "29") {
        String property_value = icslist[i]["property_value"].toString();
        String DISP_SEQ = icslist[i]["DISP_SEQ"].toString();
        var uimodel = new UImodel(property_value, DISP_SEQ);
        icstracelistModel.add(uimodel);
        setState(() {
          icstraceitems.add(DropdownMenuItem(
            child: Text(property_value),
            value: property_value,
          ));
        });
      }
    }*/

    List cateloglist = await db.RawQuery('select * from animalCatalog');
    print('animalCatalog ' + cateloglist.toString());

    //countrylist
    // List countrylist = await db.RawQuery('select * from countryList');
    // print('countryList ' + countrylist.toString());
    // countryUIModel = [];
    // countryitems.clear();
    // for (int i = 0; i < countrylist.length; i++) {
    //   String countryCode = countrylist[i]["countryCode"].toString();
    //   String countryName = countrylist[i]["countryName"].toString();
    //
    //   var uimodel = new UImodel(countryName, countryCode);
    //   countryUIModel.add(uimodel);
    //   setState(() {
    //     countryitems.add(DropdownMenuItem(
    //       child: Text(countryName),
    //       value: countryName,
    //     ));
    //   });
    // }

    /*IDPROOF */
    List idprooflist = await db.RawQuery(
        'select * from animalCatalog where catalog_code =\'44\'');

    List otherlist = await db.RawQuery(
        'select distinct DISP_SEQ ,property_value from catalog where  DISP_SEQ=\'99\' and property_value =\'Others\' ');

    List newList = idprooflist + otherlist;
    print("newList_newList" + newList.toString());

    idProofUIModel = [];

    idproofitems.clear();
    for (int i = 0; i < newList.length; i++) {
      String property_value = newList[i]["property_value"].toString();
      String DISP_SEQ = newList[i]["DISP_SEQ"].toString();
      var uimodel = new UImodel(property_value, DISP_SEQ);
      idProofUIModel.add(uimodel);

      setState(() {
        idproofitems.add(DropdownModel(
          property_value,
          DISP_SEQ,
        ));
        //prooflist.add(property_value);
      });
    }

    //Category
    List categroy = await db.RawQuery(
        'select * from animalCatalog where catalog_code =\'12\'');
    print('categroy ' + categroy.toString());
    CategoryModel = [];
    cateogryitems.clear();
    for (int i = 0; i < categroy.length; i++) {
      String property_value = categroy[i]["property_value"].toString();
      String DISP_SEQ = categroy[i]["DISP_SEQ"].toString();

      var uimodel = new UImodel(property_value, DISP_SEQ);
      CategoryModel.add(uimodel);
      setState(() {
        cateogryitems.add(DropdownMenuItem(
          child: Text(property_value),
          value: property_value,
        ));
        //prooflist.add(property_value);
      });
    }

    //marrital status
    List marritallist = await db.RawQuery(
        'select * from animalCatalog where catalog_code =\'47\'');
    print('marritallist ' + marritallist.toString());
    marritallistModel = [];
    //maritalList.clear();
    maritalitems.clear();
    for (int i = 0; i < marritallist.length; i++) {
      String property_value = marritallist[i]["property_value"].toString();
      String DISP_SEQ = marritallist[i]["DISP_SEQ"].toString();

      var uimodel = new UImodel(property_value, DISP_SEQ);
      marritallistModel.add(uimodel);
      setState(() {
        maritalitems.add(DropdownMenuItem(
          child: Text(property_value),
          value: property_value,
        ));
        //maritalList.add(property_value);
      });
    }

    //Education
    List educationlist = await db.RawQuery(
        'select * from animalCatalog where catalog_code =\'7\'');
    print('marritallist ' + educationlist.toString());
    educationitems.clear();
    for (int i = 0; i < educationlist.length; i++) {
      String property_value = educationlist[i]["property_value"].toString();
      String DISP_SEQ = educationlist[i]["DISP_SEQ"].toString();
      setState(() {
        educationitems.add(DropdownModel(
          property_value,
          DISP_SEQ,
        ));
      });
    }

    //Farm Equipments
    List farmequipments = await db.RawQuery(
        'select * from animalCatalog where catalog_code =\'1\'');
    print('farmequipments ' + farmequipments.toString());
    farmequpmentslistModel = [];
    //equipmentList.clear();
    equipmentitems.clear();
    for (int i = 0; i < farmequipments.length; i++) {
      String property_value = farmequipments[i]["property_value"].toString();
      String DISP_SEQ = farmequipments[i]["DISP_SEQ"].toString();

      var uimodel = new UImodel(property_value, DISP_SEQ);
      farmequpmentslistModel.add(uimodel);
      setState(() {
        equipmentitems.add(DropdownMenuItem(
          child: Text(property_value),
          value: property_value,
        ));
        //equipmentList.add(property_value);
      });
    }

    //animal husbandary
    List animalhusbandarys = await db.RawQuery(
        'select * from animalCatalog where catalog_code =\'2\'');
    print('farmequipments ' + animalhusbandarys.toString());
    animalhusbandarysModel = [];
    //animalList.clear();
    animalitems.clear();
    for (int i = 0; i < animalhusbandarys.length; i++) {
      String property_value = animalhusbandarys[i]["property_value"].toString();
      String DISP_SEQ = animalhusbandarys[i]["DISP_SEQ"].toString();

      var uimodel = new UImodel(property_value, DISP_SEQ);
      animalhusbandarysModel.add(uimodel);
      setState(() {
        animalitems.add(DropdownMenuItem(
          child: Text(property_value),
          value: property_value,
        ));
      });
    }

    //fodder
    List fodders = await db.RawQuery(
        'select * from animalCatalog where catalog_code =\'3\'');
    print('fodder ' + fodders.toString());
    fodderModel = [];
    fodderitems.clear();
    for (int i = 0; i < fodders.length; i++) {
      String property_value = fodders[i]["property_value"].toString();
      String DISP_SEQ = fodders[i]["DISP_SEQ"].toString();

      var uimodel = new UImodel(property_value, DISP_SEQ);
      fodderModel.add(uimodel);
      setState(() {
        fodderitems.add(DropdownMenuItem(
          child: Text(property_value),
          value: property_value,
        ));
        //fodderList.add(property_value);
      });
    }

    List animalhousings = await db.RawQuery(
        'select * from animalCatalog where catalog_code =\'4\'');
    print('animalhousings ' + animalhousings.toString());
    animalhousingModel = [];
    //animalhouseList.clear();
    animalhouseitems.clear();
    for (int i = 0; i < animalhousings.length; i++) {
      String property_value = animalhousings[i]["property_value"].toString();
      String DISP_SEQ = animalhousings[i]["DISP_SEQ"].toString();

      var uimodel = new UImodel(property_value, DISP_SEQ);
      animalhousingModel.add(uimodel);
      setState(() {
        animalhouseitems.add(DropdownMenuItem(
          child: Text(property_value),
          value: property_value,
        ));
      });
    }

    //Groups
    List groups = await db.RawQuery(
        'select sam.samCode,sam.samName from samitee sam,agentSamiteeList agentsam where agentsam.samCode=sam.samCode');
    print('groups ' + groups.toString());
    groupsModel = [];
    //groupList.clear();
    typgrupitems.clear();
    for (int i = 0; i < groups.length; i++) {
      String samName = groups[i]["samName"].toString();
      String samCode = groups[i]["samCode"].toString();

      var uimodel = new UImodel(samName, samCode);
      groupsModel.add(uimodel);
      setState(() {
        typgrupitems.add(DropdownModel(
          samName,
          samCode,
        ));
        //prooflist.add(property_value);
      });
    }
    //Name of the group
    List namegroups = await db.RawQuery('select * from animalCatalog where catalog_code =\'5\'');
    print('namegroups ' + namegroups.toString());
    namegrupitems.clear();
    for (int i = 0; i < namegroups.length; i++) {
      String groupName = namegroups[i]["property_value"].toString();
      String groupCode = namegroups[i]["DISP_SEQ"].toString();
      setState(() {
        namegrupitems.add(DropdownModel(
          groupName,
          groupCode,
        ));
      });
    }

    //Position in the Group
    List positgroups = await db.RawQuery('select * from animalCatalog where catalog_code =\'4\'');
    print('positgroups ' + positgroups.toString());
    positgrupitems.clear();
    for (int i = 0; i < positgroups.length; i++) {
      String positgroupName = positgroups[i]["property_value"].toString();
      String positgroupCode = positgroups[i]["DISP_SEQ"].toString();
      setState(() {
        positgrupitems.add(DropdownModel(
          positgroupName,
          positgroupCode,
        ));
      });
    }

    List certificationtypes =
    await db.RawQuery('select * from catalog where catalog_code=\'CET\'');

    print('certificationtypes ' + certificationtypes.toString());
    certificationModel = [];
    certtypeList.clear();
    for (int i = 0; i < certificationtypes.length; i++) {
      String property_value =
      certificationtypes[i]["property_value"].toString();
      String DISP_SEQ = certificationtypes[i]["DISP_SEQ"].toString();

      var uimodel = new UImodel(property_value, DISP_SEQ);
      certificationModel.add(uimodel);
      setState(() {
        certitypeitems.add(DropdownMenuItem(
          child: Text(property_value),
          value: property_value,
        ));
        //certtypeList.add(property_value);
      });
    }

    //consumer electronics
    List consumerelectronics = await db.RawQuery(
        'select * from animalCatalog where catalog_code =\'8\'');
    print('consumerelectronics ' + consumerelectronics.toString());
    consumerelectronicsModel = [];
    //electronicsList.clear();
    electronicitems.clear();
    for (int i = 0; i < consumerelectronics.length; i++) {
      String property_value =
      consumerelectronics[i]["property_value"].toString();
      property_value = consumerelectronics[i]["property_value"].toString();
      String DISP_SEQ = consumerelectronics[i]["DISP_SEQ"].toString();

      var uimodel = new UImodel(property_value, DISP_SEQ);
      consumerelectronicsModel.add(uimodel);
      setState(() {
        electronicitems.add(DropdownMenuItem(
          child: Text(property_value),
          value: property_value,
        ));
        //electronicsList.add(property_value);
      });
    }

    List vehicles = await db.RawQuery(
        'select * from animalCatalog where catalog_code =\'1\'');
    print('vehicles ' + vehicles.toString());
    vehiclesUIModel = [];
    vechileitems.clear();
    for (int i = 0; i < vehicles.length; i++) {
      String property_value = vehicles[i]["property_value"].toString();
      String DISP_SEQ = vehicles[i]["DISP_SEQ"].toString();

      var uimodel = new UImodel(property_value, DISP_SEQ);
      vehiclesUIModel.add(uimodel);
      setState(() {
        vechileitems.add(DropdownMenuItem(
          child: Text(property_value),
          value: property_value,
        ));
        //vechileList.add(property_value);
      });
    }

    //accounttypes
    List accounttypes = await db.RawQuery(
        'select * from animalCatalog where catalog_code =\'7\'');
    print('accounttypes ' + accounttypes.toString());
    AccountTypeUIModel = [];
    //salTypeList.clear();
    acctypeitems.clear();
    for (int i = 0; i < accounttypes.length; i++) {
      String property_value = accounttypes[i]["property_value"].toString();
      String DISP_SEQ = accounttypes[i]["DISP_SEQ"].toString();

      var uimodel = new UImodel(property_value, DISP_SEQ);
      AccountTypeUIModel.add(uimodel);
      setState(() {
        acctypeitems.add(DropdownMenuItem(
          child: Text(property_value),
          value: property_value,
        ));
        //salTypeList.add(property_value);
      });
    }

    List croptypes = await db.RawQuery('select * from cropList');
    print('croptypes ' + croptypes.toString());
    CropTypeUIModel = [];
    //salTypeList.clear();
    croptypeitems.clear();
    for (int i = 0; i < croptypes.length; i++) {
      String property_value = croptypes[i]["fname"].toString();
      String DISP_SEQ = croptypes[i]["fcode"].toString();

      var uimodel = new UImodel(property_value, DISP_SEQ);
      CropTypeUIModel.add(uimodel);
      setState(() {
        croptypeitems.add(DropdownMenuItem(
          child: Text(property_value),
          value: property_value,
        ));
      });
    }

    //Loan Taken Last Year
    List loantypes = await db.RawQuery('select * from animalCatalog where catalog_code =\'5\'');
    print('loantypes ' + loantypes.toString());
    loanTakenModel = [];
    //groupList.clear();
    loanitems.clear();
    for (int i = 0; i < loantypes.length; i++) {
      String property_value = loantypes[i]["property_value"].toString();
      String DISP_SEQ = loantypes[i]["DISP_SEQ"].toString();

      var uimodel = new UImodel(property_value, DISP_SEQ);
      loanTakenModel.add(uimodel);
      setState(() {
        loanitems.add(DropdownModel(
          property_value,
          DISP_SEQ,
        ));
        //prooflist.add(property_value);
      });
    }
    //Mapped To
    List mapto= await db.RawQuery('select * from animalCatalog where catalog_code =\'1\'');
    print('mappedto ' + mapto.toString());
    maptoitems.clear();
    for (int i = 0; i < mapto.length; i++) {
      String property_value = mapto[i]["property_value"].toString();
      String DISP_SEQ = mapto[i]["DISP_SEQ"].toString();

      setState(() {
        maptoitems.add(DropdownModel(
          property_value,
          DISP_SEQ,
        ));
      });
    }

    //Fpo/Fg group
    List schemename = await db.RawQuery(
        'select * from animalCatalog where catalog_code =\'1\'');
    print('loantypes ' + loantypes.toString());
    SchemeModel = [];
    schemeitems.clear();
    for (int i = 0; i < schemename.length; i++) {
      String property_value = schemename[i]["property_value"].toString();
      String DISP_SEQ = schemename[i]["DISP_SEQ"].toString();

      var uimodel = new UImodel(property_value, DISP_SEQ);
      SchemeModel.add(uimodel);
      setState(() {
        schemeitems.add(DropdownMenuItem(
          child: Text(property_value),
          value: property_value,
        ));
        //salTypeList.add(property_value);
      });
    }

    // loanpurpose
    List loanPurpose = await db.RawQuery(
        'select * from animalCatalog where catalog_code =\'35\'');
    loanPurposeModel = [];
    loanPurposeitems.clear();
    for (int i = 0; i < loanPurpose.length; i++) {
      String property_value = loanPurpose[i]["property_value"].toString();
      String DISP_SEQ = loanPurpose[i]["DISP_SEQ"].toString();

      var uimodel = new UImodel(property_value, DISP_SEQ);
      loanPurposeModel.add(uimodel);
      setState(() {
        loanPurposeitems.add(DropdownMenuItem(
          child: Text(property_value),
          value: property_value,
        ));
        //salTypeList.add(property_value);
      });
    }

    //security
    List Security = await db.RawQuery(
        'select distinct * from animalCatalog where catalog_code =\'36\'');
    print('loantypes ' + loantypes.toString());
    loanSecurityModel = [];
    loanSecurityModel.clear();
    for (int i = 0; i < Security.length; i++) {
      String property_value = Security[i]["property_value"].toString();
      String DISP_SEQ = Security[i]["DISP_SEQ"].toString();

      var uimodel = new UImodel(property_value, DISP_SEQ);
      loanSecurityModel.add(uimodel);
      setState(() {
        loanSecurityitem.add(DropdownMenuItem(
          child: Text(property_value),
          value: property_value,
        ));
        //salTypeList.add(property_value);
      });
    }

    //countrylist
    List countrylist = await db.RawQuery('select * from countryList ');
    print(' ' + countrylist.toString());
    cuntryUIModel = [];
    cuntryitems.clear();
    for (int i = 0; i < countrylist.length; i++) {
      String cuntryCode = countrylist[i]["countryCode"].toString();
      String cuntryName = countrylist[i]["countryName"].toString();

      var uimodel = new UImodel(cuntryName, cuntryCode);
      cuntryUIModel.add(uimodel);
      setState(() {
        cuntryitems.add(DropdownModel(
          cuntryName,
          cuntryCode,
        ));
        //prooflist.add(property_value);
      });
    }
  }

  // Future<void> ChangeStates(String countrycode) async {
  //   List statelist = await db.RawQuery(
  //       'select * from stateList where countryCode =\'' + countrycode + '\'');
  //   print('stateList ' + statelist.toString());
  //   stateUIModel = [];
  //   stateitems = [];
  //   stateitems.clear();
  //   for (int i = 0; i < statelist.length; i++) {
  //     String countryCode = statelist[i]["countryCode"].toString();
  //     String stateCode = statelist[i]["stateCode"].toString();
  //     String stateName = statelist[i]["stateName"].toString();
  //
  //     var uimodel = new UImodel(stateName, stateCode);
  //     stateUIModel.add(uimodel);
  //     setState(() {
  //       stateitems.add(DropdownMenuItem(
  //         child: Text(stateName),
  //         value: stateName,
  //       ));
  //       //stateList.add(stateName);
  //     });
  //
  //     Future.delayed(Duration(milliseconds: 500), () {
  //       print("State_delayfunction" + stateName);
  //       setState(() {
  //         if (statelist.length > 0) {
  //           slctState = '';
  //           stateLoaded = true;
  //         }
  //       });
  //     });
  //   }
  // }
  //
  // /*Future<void> changeState(String countrycode) async {
  //   //statelist
  //   List statelist = await db.RawQuery(
  //       'select * from stateList where countryCode =\'' + countrycode + '\'');
  //   print('stateList ' + statelist.toString());
  //   stateUIModel = [];
  //   stateitems.clear();
  //   for (int i = 0; i < statelist.length; i++) {
  //     String countryCode = statelist[i]["countryCode"].toString();
  //     String stateCode = statelist[i]["stateCode"].toString();
  //     String stateName = statelist[i]["stateName"].toString();
  //
  //     var uimodel = new UImodel(stateName, stateCode);
  //     stateUIModel.add(uimodel);
  //     setState(() {
  //       stateitems.add(DropdownMenuItem(
  //         child: Text(stateName),
  //         value: stateName,
  //       ));
  //     });
  //   }
  //   //   setState(() {
  //   // val_State = stateUIModel[0].value;
  //   // slctState = stateUIModel[0].name;
  //   //changeDistrict(val_State);
  //   // });
  // } */
  //
  // Future<void> changeDistrict(String stateCode) async {
  //   //districtlist
  //   List districtlist = await db.RawQuery(
  //       'select * from districtList where stateCode =\'' + stateCode + '\'');
  //   print('' + districtlist.toString());
  //   districtUIModel = [];
  //   districtitems = [];
  //   districtitems.clear();
  //   for (int i = 0; i < districtlist.length; i++) {
  //     String stateCode = districtlist[i]["stateCode"].toString();
  //     String districtName = districtlist[i]["districtName"].toString();
  //     String districtCode = districtlist[i]["districtCode"].toString();
  //
  //     var uimodel = new UImodel(districtName, districtCode);
  //     districtUIModel.add(uimodel);
  //     setState(() {
  //       districtitems.add(DropdownMenuItem(
  //         child: Text(districtName),
  //         value: districtName,
  //       ));
  //     });
  //
  //     Future.delayed(Duration(milliseconds: 500), () {
  //       print("district_delayfunction" + districtName);
  //       setState(() {
  //         if (districtlist.length > 0) {
  //           districtLoaded = true;
  //           slctDistrict = '';
  //         }
  //       });
  //     });
  //   }
  // }
  //
  // Future<void> changeCity(String districtCode) async {
  //   //cityList
  //   List cityList = await db.RawQuery(
  //       'select * from cityList where districtCode =\'' + districtCode + '\'');
  //   print('cityList_farmerEnrollment' + cityList.toString());
  //   cityListUIModel = [];
  //   cityitems = [];
  //   cityitems.clear();
  //   for (int i = 0; i < cityList.length; i++) {
  //     String cityName = cityList[i]["cityName"].toString();
  //     String cityCode = cityList[i]["cityCode"].toString();
  //
  //     var uimodel = new UImodel(cityName, cityCode);
  //     cityListUIModel.add(uimodel);
  //     setState(() {
  //       cityitems.add(DropdownMenuItem(
  //         child: Text(cityName),
  //         value: cityName,
  //       ));
  //     });
  //
  //     Future.delayed(Duration(milliseconds: 500), () {
  //       print("functioncity_delay" + cityName);
  //       setState(() {
  //         if (cityList.length > 0) {
  //           cityLoaded = true;
  //           slctTaluk = '';
  //         }
  //       });
  //     });
  //   }
  // }
  //
  // Future<void> changePanchayat(String cityCode) async {
  //   //gramPanchayatList
  //   List gramPanchayatList = await db.RawQuery(
  //       'select * from gramPanchayat where cityCode =\'' + cityCode + '\'');
  //   print('gramPanchayatList' + gramPanchayatList.toString());
  //   PanchayatListUIModel = [];
  //   grampanchayatitems = [];
  //   grampanchayatitems.clear();
  //   for (int i = 0; i < gramPanchayatList.length; i++) {
  //     String gpName = gramPanchayatList[i]["gpName"].toString();
  //     String gpCode = gramPanchayatList[i]["gpCode"].toString();
  //
  //     var uimodel = new UImodel(gpName, gpCode);
  //     PanchayatListUIModel.add(uimodel);
  //     setState(() {
  //       grampanchayatitems.add(DropdownMenuItem(
  //         child: Text(gpName),
  //         value: gpName,
  //       ));
  //     });
  //   }
  // }

  Future<void> changezone(String zonecode) async {
    List zonelist = await db.RawQuery(
        'select  * from stateList where countryCode =\'' + zonecode + '\'');
    print('zonelist ' + zonelist.toString());
    zoneUIModel = [];
    zoneitems = [];
    zoneitems.clear();
    for (int i = 0; i < zonelist.length; i++) {
      String regionCode = zonelist[i]["countryCode"].toString();
      String zoneCode = zonelist[i]["stateCode"].toString();
      String zoneName = zonelist[i]["stateName"].toString();

      var uimodel = new UImodel(zoneName, zoneCode);
      zoneUIModel.add(uimodel);
      setState(() {
        zoneitems.add(DropdownModel(
          zoneName,
          zoneCode,
        ));
      });

      Future.delayed(Duration(milliseconds: 500), () {
        print("zone_delayfunction" + zoneName);
        setState(() {
          if (zonelist.length > 0) {
            zoneloaded = true;
          }
        });
      });
    }
  }

  Future<void> changeworeda(String circleCode) async {
    //woredalist
    List woredalist = await db.RawQuery(
        'select * from districtList where stateCode =\'' + circleCode + '\'');
    print('' + woredalist.toString());
    woredaUIModel = [];
    woredaitems = [];
    woredaitems.clear();
    for (int i = 0; i < woredalist.length; i++) {
      String woredaName = woredalist[i]["districtName"].toString();
      String woredaCode = woredalist[i]["districtCode"].toString();

      var uimodel = new UImodel(woredaName, woredaCode);
      woredaUIModel.add(uimodel);
      setState(() {
        woredaitems.add(DropdownModel(
          woredaName,
          woredaCode,
        ));
        //prooflist.add(property_value);
      });

      Future.delayed(Duration(milliseconds: 500), () {
        print("" + woredaName);
        setState(() {
          if (woredalist.length > 0) {
            woredaloaded = true;
            slct_woreda = '';
          }
        });
      });
    }
  }

  Future<void> changechieftown(String communeCode) async {
    //chieftownList
    List chieftownList = await db.RawQuery(
        'select * from cityList where districtCode =\'' + communeCode + '\'');
    print('' + chieftownList.toString());
    chieftownUIModel = [];
    chieftownitems = [];
    chieftownitems.clear();
    for (int i = 0; i < chieftownList.length; i++) {
      String chieftownName = chieftownList[i]["cityName"].toString();
      String chieftownCode = chieftownList[i]["cityCode"].toString();

      var uimodel = new UImodel(chieftownName, chieftownCode);
      chieftownUIModel.add(uimodel);
      setState(() {
        chiefTownitems.add(DropdownModel(
          chieftownName,
          chieftownCode,
        ));
        //prooflist.add(property_value);
      });

      Future.delayed(Duration(milliseconds: 500), () {
        print("" + chieftownName);
        setState(() {
          if (chieftownList.length > 0) {
            chieftownloaded = true;
            slctChieftown = '';
          }
        });
      });
    }
  }

  Future<void> changekebele(String Code) async {
    //kebelelist
    List kebelelist = await db.RawQuery(
        'select * from cityList where districtCode =\'' + Code + '\'');
    print('kebelelistFarmerEnrollment' + kebelelist.toString());
    kebeleUIModel = [];
    kebeleitems.clear();
    for (int i = 0; i < kebelelist.length; i++) {
      String kebeleName = kebelelist[i]["cityName"].toString();
      String kebeleCode = kebelelist[i]["cityCode"].toString();

      var uimodel = new UImodel(kebeleName, kebeleCode);
      kebeleUIModel.add(uimodel);
      setState(() {
        kebeleitems.add(DropdownModel(
          kebeleName,
          kebeleCode,
        ));
        //prooflist.add(property_value);
      });

      Future.delayed(Duration(milliseconds: 500), () {
        print("kebeleloaeddealy" + kebeleName);
        setState(() {
          if (kebeleList.length > 0) {
            slct_kebele = '';
            kebeleLoaded = true;
          }
        });
      });
    }
  }

  Future<void> changeVillage(String Code) async {
    List villagelist = await db.RawQuery(
        'select * from villageList where gpCode =\'' + Code + '\'');
    print('villagelistFarmerEnrollment' + villagelist.toString());
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
      title: cancel,
      desc: rusurecancel,
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
    ).show()) ??
        false;
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
          case "farmerCode":
            setState(() {
              FCode = labelName;
            });
            break;
          case "dob":
            setState(() {
              Dob = labelName;
            });
            break;
          case "gender":
            setState(() {
              Gender = labelName;
            });
            break;
          case "idproof":
            setState(() {
              IDproof = labelName;
            });
            break;
          case "proofNo":
            setState(() {
              ProofNo = labelName;
            });
            break;
          case "farmerphoto":
            setState(() {
              FarmerPhoto = labelName;
            });
            break;

          case "mobno":
            setState(() {
              mobileNo = labelName;
            });
            break;
          case "nofamily":
            setState(() {
              noFamilyMem = labelName;
            });
            break;
          case "chiefTownHint":
            setState(() {
              chiefTownHint = labelName;
            });
            break;
          case "IDproofHint":
            setState(() {
              IDproofHint = labelName;
            });
            break;
          case "male":
            setState(() {
              male = labelName;
              genderMap['option1'] = male;
            });
            break;
          case "female":
            setState(() {
              female = labelName;
              genderMap['option2'] = female;
            });
            break;
          case "farmerenrollment":
            setState(() {
              farmerenrollment = labelName;
            });
            break;
          case "PersonalInfo":
            setState(() {
              PersonalInfo = labelName;
            });
            break;
          case "save":
            setState(() {
              save = labelName;
            });
            break;
          case "Cancel":
            setState(() {
              cancel = labelName;
            });
            break;
          case "info":
            setState(() {
              info = labelName;
            });
            break;
          case "infoFname":
            setState(() {
              infoFname = labelName;
            });
            break;
          case "infodob":
            setState(() {
              infodob = labelName;
            });
            break;
          case "infocircle":
            setState(() {
              infocircle = labelName;
            });
            break;
          case "infochiefcommune":
            setState(() {
              infChiefcommune = labelName;
            });
            break;
          case 'transactionsuccesfull':
            setState(() {
              transactionsuccesfull = labelName;
            });
            break;
          case 'farmersuccess':
            setState(() {
              farmersuccess = labelName;
            });
            break;
          case 'confirm':
            setState(() {
              confirm = labelName;
            });
            break;
          case "infonof":
            setState(() {
              infonof = labelName;
            });
            break;
          case "infogroupco":
            setState(() {
              infogroupco = labelName;
            });
            break;
          case "rusurecancel":
            setState(() {
              rusurecancel = labelName;
            });
            break;
          case "success":
            setState(() {
              success = labelName;
            });
            break;
          case "ArewntPrcd":
            setState(() {
              proceed = labelName;
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
          case "ok":
            setState(() {
              ok = labelName;
            });
            break;
          case "gallery":
            setState(() {
              galry = labelName;
            });
            break;
          case "pickimage":
            setState(() {
              pickimg = labelName;
            });
            break;
          case "choose":
            setState(() {
              chse = labelName;
            });
            break;
          case "camera":
            setState(() {
              Camera = labelName;
            });
            break;
          case "gpslocation":
            setState(() {
              gpslocation = labelName;
            });
            break;
          case 'Allowtakepic':
            setState(() {
              Allowtakepic = labelName;
            });
            break;
          case 'deny':
            setState(() {
              deny = labelName;
            });
            break;
          case 'whiluseapp':
            setState(() {
              whiluseapp = labelName;
            });
            break;
          case 'onlytym':
            setState(() {
              onlytym = labelName;
            });
            break;
        }
      }
    } catch (e) {
      print('translation err' + e.toString());
      //toast(e.toString());
    }
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
              farmerenrollment,
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


  void equipmentCount(BuildContext context, List<int> selecteditems) {
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
        title: "Add Equipment Count",
        content: SingleChildScrollView(
          child: ListView.builder(
              itemCount: selecteditems.length,
              itemBuilder: (context, index) {
                return Text("NAME");
              }),
        ),
        buttons: [
          DialogButton(
            child: Text(
              "Cancel",
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            onPressed: () {
              setState(() {});
            },
            color: Colors.deepOrange,
          ),
          DialogButton(
            child: Text(
              "OK",
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            onPressed: () {
              setState(() {});
            },
            color: Colors.green,
          )
        ]).show();
  }

  List<Widget> _getListings(BuildContext context) {
    List<Widget> listings = [];
    //Filfare image;
    int i = 0;
   // for (i = 0; i < 5; i++) {
     // if (i == 0) {
        //Enrollment Place
        listings.add(txt_label_mandatory("Enrollment Place", Colors.black, 14.0, false));
        listings.add(DropDownWithModel(
          itemlist: enrollemntitems,
          selecteditem: slctEnrol,
          hint:"Select the Enrollment Place",
          onChanged: (value) {
            setState(() {
              slctEnrol = value!;
              val_enroll = slctEnrol!.value;
              slct_enroll = slctEnrol!.name;
            });
          },
        ));


        //Enrollment Date
        listings.add(txt_label_mandatory("Enrollment Date", Colors.black, 14.0, false));
        listings.add(selectDate(
            context1: context,
            slctdate: enrollmentDate,
            onConfirm: (date) => setState(
                  () {
                enrollmentDate = DateFormat('dd/MM/yyyy').format(date!);
                enrollmentFormatedDate =
                    DateFormat('yyyyMMdd').format(date);
              },
            )));
        //Farmer Code
        listings
            .add(txt_label_mandatory(FCode, Colors.black, 14.0, false));

        listings.add(cardlable_dynamic(farmerCodeval));

        //Enrolling person
        listings
            .add(txt_label_mandatory("Enrolling person", Colors.black, 14.0, false));
        listings.add(txtfield_dynamic("Enrolling person", enrollPersonController!, true,25));


        listings.add(txt_label(PersonalInfo, Colors.green, 18.0, true));

        //Farmer Name
        listings.add(txt_label_mandatory(FName, Colors.black, 14.0, false));
        listings.add(txtfield_dynamic(FName, farmerNameController!, true,25));

        //Father Name
        listings.add(txt_label_mandatory(FthrName, Colors.black, 14.0, false));
        listings.add(txtfield_dynamic(FthrName, fatherNameController!, true,25));

        //Farmer Code
        listings.add(txt_label_mandatory(GrndfthrName, Colors.black, 14.0, false));
        listings.add(txtfield_dynamic(GrndfthrName, GrndfthNameController!, true,25));

        /* Gender*/
        listings.add(txt_label_mandatory(Gender, Colors.black, 14.0, false));

        listings.add(radio_dynamic(
            map: genderMap,
            selectedKey: _selectedGender,
            onChange: (value) {
              setState(() {
                _selectedGender = value!;
                if (value == 'option1') {
                  genderSelect = male;
                } else if (value == 'option2') {
                  genderSelect = female;
                }

                print("genderSelect_genderSelect" + genderSelect);
              });
            }));

        // Date of Birth
        listings.add(txt_label_mandatory(Dob, Colors.black, 14.0, false));
        listings.add(selectDate(
            context1: context,
            slctdate: dateofbirth,
            onConfirm: (date) => setState(
                  () {
                dateofbirth = DateFormat('dd/MM/yyyy').format(date!);
                dateofbirthFormatedDate =
                    DateFormat('yyyyMMdd').format(date!);

                dateofyear = DateFormat('yyyy').format(date!);
                calAgeyr();
              },
            )));

        // Farmer Photo
        listings.add(txt_label_mandatory(FarmerPhoto, Colors.black, 14.0, false));
        listings.add(img_picker(
            label: FarmerPhoto,
            onPressed: () {
              imageDialog("Farmer");
            },
            filename: farmerImageFile,
            ondelete: () {
              ondelete("Farmer");
            }));

        //Education
        listings.add(txt_label("Education", Colors.black, 14.0, false));
        listings.add(txtfield_dynamic("Education", educatController!, true,25));

        //Mobile Number
        listings.add(
            txt_label_mandatory("Mobile Number", Colors.black, 14.0, false));
        listings.add(txtfield_digits("Mobile Number", mobileController!, true,12));


        /* country*/
        listings.add(txt_label_mandatory(cuntry, Colors.black, 14.0, false));

        listings.add(DropDownWithModel(
            itemlist: cuntryitems,
            selecteditem: slctcuntry,
            hint: cuntryHint,
            onChanged: (value) {
              setState(() {
                slctcuntry = value!;
                zoneloaded = false;
                chieftownloaded = false;
                kebeleLoaded = false;
                woredaloaded = false;
                slctchiefTowns = null;
                slctzone = null;
                slctworeda = null;
                slct_kebele = "";
                val_cuntry = slctcuntry!.value;
                slctCuntry = slctcuntry!.name;

                changezone(val_cuntry);
              });
              print("Country Code" + val_cuntry.toString());
              print("Country Name" + slctCuntry.toString());
            },
            onClear: () {
              setState(() {
                slctCuntry = '';
              });
            }));

        // Zone
        listings.add(zoneloaded
            ? txt_label_mandatory(zone, Colors.black, 14.0, false)
            : Container());

        listings.add(zoneloaded
            ? DropDownWithModel(
            itemlist: zoneitems,
            selecteditem: slctzone,
            hint: zoneHint,
            onChanged: (value) {
              setState(() {
                slctzone = value!;
                woredaloaded = false;
                chieftownloaded = false;
                kebeleLoaded = false;
                slctchiefTowns = null;
                slct_woreda = "";
                slct_kebele = "";

                val_zone = slctzone!.value;
                slct_Zone = slctzone!.name;
                changeworeda(val_zone);
              });
              print("Zone Code" + val_zone.toString());
              print("Zone Name" + slct_Zone.toString());
            },
            onClear: () {
              setState(() {
                slct_Zone = '';
                slct_woreda = '';
                slctChieftown = '';
                slctVillage = '';
              });
            })
            : Container());

        //woreda
        listings.add(woredaloaded
            ? txt_label_mandatory(woreda, Colors.black, 14.0, false)
            : Container());

        listings.add(woredaloaded
            ? DropDownWithModel(
            itemlist: woredaitems,
            selecteditem: slctworeda,
            hint: woredaHint,
            onChanged: (value) {
              setState(() {
                slctworeda = value!;
                chieftownloaded = false;
                kebeleLoaded = false;
                slct_kebele = "";
                //toast(slctFarmers!.value);
                val_woreda = slctworeda!.value;
                slct_woreda = slctworeda!.name;
                changekebele(val_woreda);
              });
              print("Woreda Code" + val_woreda.toString());
              print("Woreda Name" + slct_woreda.toString());
            },
            onClear: () {
              slct_woreda = '';
              slct_kebele = '';
            })
            : Container());


        listings.add(kebeleLoaded
            ? txt_label_mandatory(kebele, Colors.black, 14.0, false)
            : Container());

        listings.add(kebeleLoaded
            ? DropDownWithModel(
            itemlist: kebeleitems,
            selecteditem: slctkebele,
            hint: KebeleHint,
            onChanged: (value) {
              setState(() {
                slctkebele = value!;
                val_kebele = slctkebele!.value;
                slct_kebele = slctkebele!.name;
              });
              print("kebele Code" + val_kebele.toString());
              print("kebele Name" + slct_kebele.toString());
            },
            onClear: () {
              setState(() {
                slct_kebele = '';
              });
            })
            : Container());

        listings.add(txt_label("Farmer Group Mapping", Colors.green, 18.0, true));

        /* Appartenance to a group */
        listings.add(txt_label_mandatory("Appartenance to a group Y/N", Colors.black, 14.0, false));

        listings.add(radio_dynamic(
            map: appartgroup,
            selectedKey: _selectedAppargroup,
            onChange: (value) {
              setState(() {
                _selectedAppargroup = value!;
                if (value == 'option1') {
                  appargrupSelect = "NO";
                  appargrup=false;
                } else if (value == 'option2') {
                  appargrupSelect = "YES";
                  appargrup=true;
                }

                print("AppartenanceSelect_AppartenanceSelect" + appargrupSelect);
              });
            }));

        // Drop Down - Type of group
        if(appargrup){
          listings.add(txt_label_mandatory(typgrcup, Colors.black, 14.0, false));

          listings.add(DropDownWithModel(
            itemlist: typgrupitems,
            selecteditem: slcttypgrup,
            hint: typgrupHint,
            onChanged: (value) {
              setState(() {
                slcttypgrup = value!;
                val_typrgrup = slcttypgrup!.value;
                slct_typgrup = slcttypgrup!.name;
              });
            },
          ));
        }
        // Drop Down - Name of the group
        listings.add(txt_label_mandatory(namegrup, Colors.black, 14.0, false));

        listings.add(DropDownWithModel(
          itemlist: namegrupitems,
          selecteditem: slctnmaegrup,
          hint: namegrupHint,
          onChanged: (value) {
            setState(() {
              slctnmaegrup = value!;
              val_namegrup = slctnmaegrup!.value;
              slct_namegrup = slctnmaegrup!.name;
            });
          },
        ));
        // Drop Down - Position in the Group
        listings.add(txt_label_mandatory(positgrup, Colors.black, 14.0, false));

        listings.add(DropDownWithModel(
          itemlist: positgrupitems,
          selecteditem: slctpositgrup,
          hint: positgrupHint,
          onChanged: (value) {
            setState(() {
              slctpositgrup = value!;
              val_positgrup = slctpositgrup!.value;
              slct_positgrup = slctpositgrup!.name;
            });
          },
        ));
        listings.add(txt_label("Loan Details", Colors.green, 18.0, true));

        listings.add(txt_label("Loan Taken Last Year", Colors.black, 14.0, false));
        listings.add(radio_dynamic(
            map: loanTaken,
            selectedKey: loanTypeselected,
            onChange: (value) {
              setState(() {
                loanTypeselected = value!;
                if (value == 'option1') {
                  val_loanklst = "NO";
                } else if (value == 'option2') {
                  val_loanklst = "YES";
                }

                print("LoanTakenSelect_LoanTakenSelect" + val_loanklst);
              });
            }));


        listings.add(txt_label("Amount", Colors.black, 14.0, false));
        listings.add(txtfield_digits("Amount", loanAmountContoller!, true,12));

        listings.add(txt_label("Purpose", Colors.black, 14.0, false));
        listings.add(txtfield_dynamic("Purpose", purposeContoller!, true,50));

        listings.add(txt_label("Bank Information", Colors.green, 18.0, true));
        listings.add(
            txt_label("Account Number", Colors.black, 14.0, false));
        listings
            .add(txtfield_digits("Account Number", accountnoController!, true,13));

        listings
            .add(txt_label("Bank Name", Colors.black, 14.0, false));
        listings.add(txtfield_dynamic("Bank Name", bankController!, true,10));

        listings.add(
            txt_label("Bank Branch", Colors.black, 14.0, false));
        listings
            .add(txtfield_dynamic("Bank Branch", branchController!, true,25));
        // bank photo
        listings.add(txt_label("Photo of bank account", Colors.black, 14.0, false));
        listings.add(img_picker(
            label: "Photo of bank account",
            onPressed: () {
              imageDialog("bankphoto");
            },
            filename: bankImageFile,
            ondelete: () {
              ondelete("bankphoto");
            }));
        listings.add(txt_label("Aggregator Mapping", Colors.green, 18.0, true));

        listings.add(txt_label_mandatory("Mapped to", Colors.black, 14.0, false));
        listings.add(DropDownWithModel(
          itemlist: maptoitems,
          selecteditem: slctmapto,
          hint: "Select Mapped to",
          onChanged: (value) {
            setState(() {
              slctmapto = value!;
              val_mapto = slctmapto!.value;
              slct_mapto = slctmapto!.name;
            });
          },
        ));


        listings.add(Container(
          child: Row(
            children: [
              Expanded(
                flex: 1,
                child: Container(
                  padding: EdgeInsets.all(3),
                  child: RaisedButton(
                    child: Text(
                      "Cancel",
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
                      "Submit",
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

     // }
    //}
    return listings;
  }

  void calAgeyr() {
    DateTime currentDate = DateTime.now();
    int month1 = currentDate.month;
    setState(() {
      yuthalt = "";
      elegibleRegister = 0;
      if (dateofbirth!.length > 0) {
        print("estimatedMT_estimatedMT1" + dateofbirth!.toString());
        print("currentDate" + currentDate.year.toString());
        int agecalcontroller = 0;
        agecalcontroller = int.parse(dateofyear);
        int estcaldat = (currentDate.year - agecalcontroller);
        print("currentDate" + agecalcontroller.toString());
        elegibleRegister = estcaldat;
        if (estcaldat >= 35) {
          yuthalt = "Adult";
        } else {
          yuthalt = "Youth";
        }
      }
    });
  }

  Widget addlistitem() {
    Widget objWidget = Container(
      child: Column(children: <Widget>[
        Container(
            alignment: Alignment.center,
            child: Text("Bank Information",
                style: TextStyle(
                  color: Colors.green,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.underline,
                ))),
        ListView.builder(
          shrinkWrap: true,
          itemCount: banklist == null ? 1 : banklist.length + 1,
          itemBuilder: (BuildContext context, int index) {
            if (index == 0) {
              // return the header
              return Container(
                margin: EdgeInsets.only(left: 5.0, right: 5.0, top: 10.0),
                alignment: Alignment.center,
                child: new Row(
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        child: Text(
                          "Account Number",
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              color: Colors.green,
                              fontSize: 14,
                              fontWeight: FontWeight.bold),
                        ),
                        alignment: Alignment.center,
                      ),
                      flex: 2,
                    ),
                    Expanded(
                      child: Container(
                        child: Text(
                          "Bank Name",
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              color: Colors.green,
                              fontSize: 14,
                              fontWeight: FontWeight.bold),
                        ),
                        alignment: Alignment.center,
                      ),
                      flex: 2,
                    ),
                    Expanded(
                      child: Container(
                        child: Text(
                          "Branch Name",
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              color: Colors.green,
                              fontSize: 14,
                              fontWeight: FontWeight.bold),
                        ),
                        alignment: Alignment.center,
                      ),
                      flex: 2,
                    ),
                    Expanded(
                      child: Container(),
                      flex: 1,
                    ),
                    Expanded(
                      child: Container(),
                      flex: 1,
                    )
                  ],
                ),
              );
            }
            index -= 1;
            // return row
            var row = banklist[index];
            return Column(children: <Widget>[
              Container(
                margin: EdgeInsets.only(left: 5.0, right: 5.0, top: 10.0),
                alignment: Alignment.center,
                child: new Row(
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        child: Text(
                          banklist[index].acc_no,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.bold),
                        ),
                        alignment: Alignment.center,
                      ),
                      flex: 2,
                    ),
                    Expanded(
                      child: Container(
                        child: Text(
                          banklist[index].bank_name,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.bold),
                        ),
                        alignment: Alignment.center,
                      ),
                      flex: 2,
                    ),
                    Expanded(
                      child: Container(
                        child: Text(
                          banklist[index].branch_name,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.bold),
                        ),
                        alignment: Alignment.center,
                      ),
                      flex: 2,
                    ),
                    Expanded(
                      child: Container(
                        child: IconButton(
                          icon: Icon(Icons.border_color, color: Colors.black26),
                          onPressed: () {
                            EditBankPopup(context, index);
                          },
                        ),
                        alignment: Alignment.center,
                      ),
                      flex: 1,
                    ),
                    Expanded(
                      child: Container(
                        child: IconButton(
                          icon: Icon(Icons.delete, color: Colors.black26),
                          onPressed: () {
                            setState(() {
                              banklist.removeAt(index);
                            });
                            //confirmationPopup(context,banklist[index]);
                          },
                        ),
                        alignment: Alignment.center,
                      ),
                      flex: 1,
                    ),
                  ],
                ),
              ),
            ]);
          },
        ),
      ]),
    );
    return objWidget;
  }

  Widget addanimallist(
      {List<DropdownMenuItem>? fodderitems,
        List<DropdownMenuItem>? animalhouselist}) {
    Widget objWidget = Container(
      child: Column(children: <Widget>[
        Container(
            alignment: Alignment.centerLeft,
            child: Text("Animal Details",
                style: TextStyle(
                  color: Colors.green,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.underline,
                ))),
        ListView.builder(
          shrinkWrap: true,
          itemCount: animallist == null ? 1 : animallist.length + 1,
          itemBuilder: (BuildContext context, int index) {
            if (index == 0) {
              // return the header
              return Container(
                margin: EdgeInsets.only(left: 5.0, right: 5.0, top: 10.0),
                alignment: Alignment.center,
                child: new Row(
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        child: Text(
                          "Animal Type",
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              color: Colors.green,
                              fontSize: 14,
                              fontWeight: FontWeight.bold),
                        ),
                        alignment: Alignment.centerLeft,
                      ),
                      flex: 2,
                    ),
                    SizedBox(
                      width: 10.0,
                    ),
                    Expanded(
                      child: Container(
                        child: Text(
                          "Count",
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              color: Colors.green,
                              fontSize: 14,
                              fontWeight: FontWeight.bold),
                        ),
                        alignment: Alignment.centerLeft,
                      ),
                      flex: 2,
                    ),
                    SizedBox(
                      width: 10.0,
                    ),
                    Expanded(
                      child: Container(),
                      flex: 1,
                    ),
                    SizedBox(
                      width: 10.0,
                    ),
                    Expanded(
                      child: Container(),
                      flex: 1,
                    )
                  ],
                ),
              );
            }
            index -= 1;
            // return row

            return Column(children: <Widget>[
              Container(
                margin: EdgeInsets.only(left: 5.0, right: 5.0, top: 10.0),
                alignment: Alignment.center,
                child: new Row(
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        child: Text(
                          animallist[index].animal_name,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.bold),
                        ),
                        alignment: Alignment.centerLeft,
                      ),
                      flex: 2,
                    ),
                    SizedBox(
                      width: 10.0,
                    ),
                    Expanded(
                      child: Container(
                        child: Text(
                          animallist[index].animalCount,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.bold),
                        ),
                        alignment: Alignment.centerLeft,
                      ),
                      flex: 2,
                    ),
                    SizedBox(
                      width: 10.0,
                    ),
                    Expanded(
                      child: Container(
                        child: IconButton(
                          icon: Icon(Icons.border_color, color: Colors.black26),
                          // onPressed:onedit(animalslist[index]),
                          onPressed: () {
                            // setState(() {
                            //UpdateAnimallist(context, animallist[index],fodderitems, animalhouselist, index);
                            // });
                          },
                        ),
                        alignment: Alignment.centerLeft,
                      ),
                      flex: 1,
                    ),
                    SizedBox(
                      width: 10.0,
                    ),
                    Expanded(
                      child: Container(
                        child: IconButton(
                          icon: Icon(Icons.delete, color: Colors.black26),
                          //onPressed: ondeleted(animalslist[index]),
                          onPressed: () {
                            setState(() {
                              animallist.removeAt(index);
                            });
                          },
                        ),
                        alignment: Alignment.centerLeft,
                      ),
                      flex: 1,
                    )
                  ],
                ),
              ),
            ]);
          },
        ),
      ]),
    );
    return objWidget;
  }

  Widget addEquipment({
    List<EquipmentModel>? equipmentlist,
  }) {
    Widget objWidget = Container(
      child: Column(children: <Widget>[
        Container(
            alignment: Alignment.center,
            child: Text("Equipment Detail",
                style: TextStyle(
                  color: Colors.green,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.underline,
                ))),
        ListView.builder(
          shrinkWrap: true,
          itemCount: equipmentlist == null ? 1 : equipmentlist.length + 1,
          itemBuilder: (BuildContext context, int index) {
            if (index == 0) {
// return the header
              return Container(
                margin: EdgeInsets.only(left: 5.0, right: 5.0, top: 10.0),
                alignment: Alignment.center,
                child: new Row(
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        child: Text(
                          "Equipment Type",
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              color: Colors.green,
                              fontSize: 14,
                              fontWeight: FontWeight.bold),
                        ),
                        alignment: Alignment.centerLeft,
                      ),
                      flex: 2,
                    ),
                    SizedBox(
                      width: 10.0,
                    ),
                    Expanded(
                      child: Container(
                        child: Text(
                          "Equipment Count",
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              color: Colors.green,
                              fontSize: 14,
                              fontWeight: FontWeight.bold),
                        ),
                        alignment: Alignment.centerLeft,
                      ),
                      flex: 2,
                    ),
                    SizedBox(
                      width: 10.0,
                    ),
                    Expanded(
                      child: Container(),
                      flex: 1,
                    ),
                    SizedBox(
                      width: 10.0,
                    ),
                    Expanded(
                      child: Container(),
                      flex: 1,
                    )
                  ],
                ),
              );
            }
            index -= 1;
// return row
            //var row = equipmentlist[index];
            return Column(children: <Widget>[
              Container(
                margin: EdgeInsets.only(left: 5.0, right: 5.0, top: 10.0),
                alignment: Alignment.center,
                child: new Row(
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        child: Text(
                          equipmentlist![index].equipName,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.bold),
                        ),
                        alignment: Alignment.centerLeft,
                      ),
                      flex: 2,
                    ),
                    SizedBox(
                      width: 10.0,
                    ),
                    Expanded(
                      child: Container(
                        child: Text(
                          equipmentlist[index].equipCount,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.bold),
                        ),
                        alignment: Alignment.centerLeft,
                      ),
                      flex: 2,
                    ),
                    SizedBox(
                      width: 10.0,
                    ),
                    Expanded(
                      child: Container(
                        child: IconButton(
                          icon: Icon(Icons.border_color, color: Colors.black26),
                          onPressed: () {
                            //setState(() {
                            ConfimationEquipment(
                                context, equipmentlist[index], index);
                            //});
                          },
                        ),
                        alignment: Alignment.centerLeft,
                      ),
                      flex: 1,
                    ),
                    SizedBox(
                      width: 10.0,
                    ),
                    Expanded(
                      child: Container(
                        child: IconButton(
                          icon: Icon(Icons.delete, color: Colors.black26),
                          onPressed: () {
                            setState(() {
                              equipmentlist.removeAt(index);
                            });
                          },
                        ),
                        alignment: Alignment.centerLeft,
                      ),
                      flex: 1,
                    )
                  ],
                ),
              ),
            ]);
          },
        ),
      ]),
    );
    return objWidget;
  }

  ConfimationEquipment(dialogContext, EquipmentModel equipment, int position) {
    var alertStyle = AlertStyle(
      animationType: AnimationType.grow,
      overlayColor: Colors.black87,
      isCloseButton: true,
      isOverlayTapDismiss: true,
      titleStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
      descStyle: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
      animationDuration: Duration(milliseconds: 400),
    );
    TextEditingController equipmentCountController =
    new TextEditingController();
    equipmentCountController.text = equipmentlist[position].equipCount;
    String slctequip = equipmentlist[position].equipName;

    Alert(
        context: dialogContext,
        style: alertStyle,
        title: "Update Equipment Detail",
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              singlesearchDropdown(
                  itemlist: equipmentitems,
                  selecteditem: equipment.equipName,
                  hint: "Select the Equipment",
                  onChanged: (value) {
                    setState(() {
                      slctequip = value!;
                      if (farmequpmentslistModel.length > 0) {
                        for (int i = 0;
                        i < farmequpmentslistModel.length;
                        i++) {
                          if (farmequpmentslistModel[i].name == slctequip) {
                            val_Equipment = farmequpmentslistModel[i].value;
                          }
                        }
                      }
                    });
                  }),
              txt_label("Equipment Count", Colors.black, 14.0, false),
              txtfield_digits(
                  "Equipment Count", equipmentCountController, true),
            ],
          ),
        ),
        buttons: [
          DialogButton(
            child: Text(
              "Cancel",
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            onPressed: () {
              Navigator.pop(dialogContext);
            },
            color: Colors.deepOrange,
          ),
          DialogButton(
            child: Text(
              "OK",
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            onPressed: () {
              setState(() {
                equipmentlist[position].equipName = slctequip;
                equipmentlist[position].equipCount =
                    equipmentCountController.text;
              });
              Navigator.pop(context);
            },
            color: Colors.green,
          )
        ]).show();
  }

  /*void UpdateAnimallist(
      BuildContext context,
      AnimalInfo animalitem,
      List<DropdownMenuItem> fodderlist,
      List<DropdownMenuItem> animalhouselist,
      int position) {
    var alertStyle = AlertStyle(
      animationType: AnimationType.grow,
      overlayColor: Colors.black87,
      isCloseButton: true,
      isOverlayTapDismiss: true,
      titleStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
      descStyle: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
      animationDuration: Duration(milliseconds: 400),
    );
    TextEditingController animalCountController = new TextEditingController();
    TextEditingController revenueController = new TextEditingController();
    TextEditingController breadController = new TextEditingController();
    TextEditingController manurecontroller = new TextEditingController();
    TextEditingController urineController = new TextEditingController();
    animalCountController.text = animallist[position].animalCount;
    revenueController.text = animallist[position].revenue;
    breadController.text = animallist[position].breed;
    manurecontroller.text = animallist[position].estiManure;
    urineController.text = animallist[position].estimUrine;
    Alert(
        context: context,
        style: alertStyle,
        title: "Update Animal Details",
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextField(
                controller: animalCountController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    labelText: 'Animal Count',
                    hintText: animallist[position].animalCount),
                textInputAction: TextInputAction.next,
              ),
              TextField(
                controller: revenueController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    labelText: 'Revenue', hintText: animalitem.revenue),
                textInputAction: TextInputAction.next,
              ),
              TextField(
                keyboardType: TextInputType.text,
                controller: breadController,
                decoration: InputDecoration(
                    labelText: 'Breed', hintText: animalitem.breed),
                textInputAction: TextInputAction.next,
              ),
              TextField(
                controller: manurecontroller,
                obscureText: false,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                    labelText: 'Manure', hintText: animalitem.estiManure),
                textInputAction: TextInputAction.next,
              ),
              TextField(
                controller: urineController,
                obscureText: false,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                    labelText: 'Urine', hintText: animalitem.estimUrine),
                textInputAction: TextInputAction.next,
              ),
            ],
          ),
        ),
        buttons: [
          DialogButton(
            child: Text(
              "Cancel",
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            //onPressed:btncancel ,
            onPressed: () {
              /* setState(() {

            });*/
              Navigator.pop(context);
            },
            color: Colors.deepOrange,
          ),
          DialogButton(
            child: Text(
              "OK",
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            onPressed: () {
              setState(() {
                try {
                  var animalinfo = new AnimalInfo(
                    animallist[position].animal_name ?? "",
                    animallist[position].animal_type ?? "",
                    animalCountController.value.text ?? "",
                    animallist[position].animalHousingType ?? "",
                    animallist[position].animalHousingType ?? "",
                    revenueController.value.text ?? "",
                    breadController.value.text ?? "",
                    manurecontroller.value.text ?? "",
                    urineController.value.text ?? "",
                    animallist[position].selctfodders ?? "",
                  );

                  //  toast('pressed');
                  animallist.removeAt(position);
                  animallist.add(animalinfo);
                  Navigator.pop(context);
                } catch (e) {
                  // toast(e);
                }
              });
            },
            color: Colors.green,
          )
        ]).show();
  }*/

  void ondelete(String photo) {
    setState(() {
      if (photo == "Farmer") {
        if (farmerImageFile != null) {
          setState(() {
            farmerImageFile = null;
          });
        }
      } else {
        if (idProofImageFile != null) {
          setState(() {
            idProofImageFile = null;
          });
        }
      }
    });
  }

  void btncancel() {
    _onBackPressed();
  }

  void btnSubmit() {

    if(slct_enroll.length > 0 && slct_enroll != '') {
      if(enrollmentDate.length > 0 && enrollmentDate != ''){
        if (enrollPersonController!.value.text.length > 0 &&
            enrollPersonController!.value.text != '') {
          if (farmerNameController!.value.text.length > 0 &&
              farmerNameController!.value.text != '') {
            if (fatherNameController!.value.text.length > 0 &&
                fatherNameController!.value.text != '') {
              if (GrndfthNameController!.value.text.length > 0 &&
                  GrndfthNameController!.value.text != '') {
                if(genderSelect.length > 0 && genderSelect != '') {
                  if (dateofbirth.length > 0) {
                    if (farmerImageFile!=null && farmerImageFile!='') {
                      if (mobileController!.value.text.length > 0 &&
                          mobileController!.value.text != '') {
                        if (slctCuntry.length > 0 && slctCuntry != '') {
                          if (slct_Zone.length > 0 && slct_Zone != '') {
                            if (slct_woreda.length > 0 && slct_woreda != '') {
                              if (slct_kebele.length > 0 && slct_kebele != '') {
                                if (slct_typgrup.length > 0 && slct_typgrup != ''|| appargrup==false) {
                                  if (slct_namegrup.length > 0 && slct_namegrup != '') {
                                    if (slct_positgrup.length > 0 && slct_positgrup != '') {
                                      if (slct_mapto.length > 0 && slct_mapto != '') {
                                        confirmationPopupp();
                                      } else {
                                        errordialog(context, info, "Mapped to should not be empty");
                                      }
                                    } else {
                                      errordialog(context, info, "Position in the Group should not be empty");
                                    }
                                  } else {
                                    errordialog(context, info, "Name of the group should not be empty");
                                  }
                                } else {
                                  errordialog(context, info, "Type of group should not be empty");
                                }
                              } else {
                                errordialog(context, info, infokebele);
                              }

                            } else {
                              errordialog(context, info, infoworeda);
                            }
                          } else {
                            errordialog(context, info, "Zone should not be empty");
                          }
                        } else {
                          errordialog(context, info, infocuntry);
                        }
                      } else {
                        errordialog(context, info, "Mobile Number should not be empty");
                      }
                    } else {
                      errordialog(context, info, "Farmer Photo should not be empty");
                    }
                  } else {
                    errordialog(context, info, infodob);
                  }
                } else {
                  errordialog(context, info, "Gender should not be empty");
                }
              } else {
                errordialog(context, info, "Grandfather Name should not be empty");
              }
            } else {
              errordialog(context, info, infoFthname);
            }
          } else {
            errordialog(context, info, infoFname);
          }
        } else {
          errordialog(context, info, "Enrolling person should not be empty");
        }
      } else {
        errordialog(context, info, "Enrollment Date should not be empty");
      }
    } else {
      errordialog(context, info, "Enrollment Place should not be empty");
    }
  }



  void calculateAge(DateTime birthDate) {
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
    ageController!.text = age.toString();
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
        title: pickimg,
        desc: chse,
        buttons: [
          DialogButton(
            child: Text(
              galry,
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
              Camera,
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
        .pickImage(source: ImageSource.camera, imageQuality: 50);
    setState(() {
      if (photo == "Farmer") {
        farmerImageFile = File(image!.path);
      } else if(photo == "bankphoto") {
        bankImageFile = File(image!.path);
      } else {
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
      } else if(photo == "bankphoto") {
        bankImageFile = File(image!.path);
      } else {
        idProofImageFile = File(image!.path);
      }
    });
  }

  EditBankPopup(dialogContext, int Position) {
    var alertStyle = AlertStyle(
      animationType: AnimationType.grow,
      overlayColor: Colors.black87,
      isCloseButton: true,
      isOverlayTapDismiss: true,
      titleStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
      descStyle: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
      animationDuration: Duration(milliseconds: 400),
    );
    TextEditingController accountNoController = new TextEditingController();
    TextEditingController bankNameController = new TextEditingController();
    TextEditingController branchNameController = new TextEditingController();
    TextEditingController ifscController = new TextEditingController();

    accountNoController.text = banklist[Position].acc_no;
    bankNameController.text = banklist[Position].bank_name;
    branchNameController.text = banklist[Position].branch_name;
    ifscController.text = banklist[Position].ifsc_code;
    Alert(
        context: dialogContext,
        style: alertStyle,
        title: "Update Bank Details",
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextFormField(
                controller: accountNoController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Account Number',
                  hintText: banklist[Position].acc_no,
                ),
                textInputAction: TextInputAction.next,
              ),
              TextFormField(
                controller: bankNameController,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  labelText: 'Bank Name',
                  hintText: banklist[Position].bank_name,
                ),
                textInputAction: TextInputAction.next,
              ),
              TextFormField(
                controller: branchNameController,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  labelText: 'Branch Name',
                  hintText: banklist[Position].branch_name,
                ),
                textInputAction: TextInputAction.next,
              ),
              TextFormField(
                controller: ifscController,
                obscureText: false,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  labelText: 'IFSC Code',
                  hintText: banklist[Position].ifsc_code,
                ),
                textInputAction: TextInputAction.done,
              ),
            ],
          ),
        ),
        buttons: [
          DialogButton(
            child: Text(
              "Cancel",
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            //onPressed:btncancel ,
            onPressed: () {
              //setState(() {
              Navigator.pop(dialogContext);
              //});
            },
            color: Colors.deepOrange,
          ),
          DialogButton(
            child: Text(
              "OK",
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            //onPressed:btnok,
            onPressed: () {
              setState(() {
                try {
                  // var bankinfo = new BankInformation(
                  //     banklist[Position].acc_Type,
                  //     accountNoController.value.text,
                  //     bankNameController.value.text,
                  //     branchNameController.value.text,
                  //     ifscController.value.text);

                  banklist.removeAt(Position);
                  //banklist.add(bankinfo);
                } catch (e) {
                  // toast(e);
                }
              });
              Navigator.pop(dialogContext);
            },
            color: Colors.green,
          )
        ]).show();
  }

  confirmationPopup(dialogContext) {
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
        context: dialogContext,
        style: alertStyle,
        title: "Confirmation",
        desc: "Do you want to reset the farmer details",
        buttons: [
          DialogButton(
            child: Text(
              "Cancel",
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            //onPressed:btncancel ,
            onPressed: () {
              setState(() {
                isregistration = false;
                Navigator.pop(context);
              });
            },
            color: Colors.deepOrange,
          ),
          DialogButton(
            child: Text(
              "OK",
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            //onPressed:btnok,
            onPressed: () {
              setState(() {
                isregistration = true;
                Navigator.pop(context);
              });
            },
            color: Colors.green,
          )
        ]).show();
  }

  saveFarmer() async {
    String farmerName,
        fatherName,
        grandfatherName,
        farmerCode,
        age,
        dob,
        proofno,
        addres,
        mobileNo,
        phoneNo,
        email,
        totfamMember,
        totMadults,
        totFdults,
        totMChilds,
        totFChilds,
        totalMschool,
        totalFschool,
        totHousehold,
        totMHousehold,
        totFHousehold,
        animalcount,
        revenue,
        breed,
        esitmate_manure,
        estimate_urine,
        bank_acc_no,
        bank_name,
        branch_name,
        bankdetail,
        ifsc_code,
        icsname,
        icscode,
        certifieduser,
        icsfarmercode,
        icsfarmertracenet;
    farmerName = farmerNameController!.value.text;
    fatherName = fatherNameController!.value.text;
    grandfatherName = GrndfthNameController!.value.text;
    farmerCode = farmerid.toString();
    icsname = icsnameController!.value.text;
    icscode = icscodeController!.value.text;
    age = ageController!.value.text;
    proofno = proofnoController!.value.text;
    addres = addressController!.value.text;
    mobileNo = mobileController!.value.text;
    phoneNo = phoneController!.value.text;
    email = emailController!.value.text;
    totfamMember = totNoFamilyController!.value.text;
    totMadults = totAdultMController!.value.text;
    totFdults = totAdultFController!.value.text;
    totMChilds = totalChildMController!.value.text;
    totFChilds = totChildFController!.value.text;
    totalMschool = schlGoingMController!.value.text;
    totalFschool = schlGoingFController!.value.text;
    totHousehold = totHouseholdController!.value.text;
    totMHousehold = totHouseholdMController!.value.text;
    totFHousehold = totHouseholdFController!.value.text;
    animalcount = animalcountController!.value.text;
    //revenue = yrbrthController!.value.text;
    revenue = dateofbirth!.toString();
    breed = animalBreedController!.value.text;
    esitmate_manure = estimateManureController!.value.text;
    estimate_urine = estimateUrineController!.value.text;
    bank_name = bankController!.value.text;
    bank_acc_no = accountnoController!.value.text;
    branch_name = branchController!.value.text;
    ifsc_code = ifscController!.value.text;
    icsfarmercode = icsfarmercodeController!.value.text;
    icsfarmertracenet = icstracenetController!.value.text;
    //dob = yrbrthController!.value.text;
    dob = dateofbirth!.toString();

    certifieduser = "0";

    if (isregistration) {
      certifieduser = "1";
    } else {
      certifieduser = "0";
    }
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
            farmerid.toString() +
            '\')';
    print('txnHeader ' + insqry);
    int txnsucc = await db.RawInsert(insqry);
    print(txnsucc);
    Future<List<Map>> txnHeader = db.GetTableValues('txnHeader');

    //CustTransaction
    AppDatas datas = new AppDatas();
    await db.saveCustTransaction(
        txntime, datas.txnFarmerEnrollment, farmerid.toString(), '', '', '');
    print('farmer inserting');

    String photoPath = "";
    if (farmerImageFile != null) {
      photoPath = farmerImageFile!.path;
    }

    String idPath = "";
    if (idProofImageFile != null) {
      idPath = idProofImageFile!.path;
    }
    String bankimgPath = "";
    if (bankImageFile != null) {
      bankimgPath = bankImageFile!.path;
    }
    int farmersave = await db.SaveFarmer(
        farmerid.toString() ,
        '1',
        Lng,
        Lat,
        datas.tenent,
        seasoncode,
        val_enroll,//Enrollment Place
        enrollmentDate,//Enrollment Date
        farmerCodeval,//Farmer Code
        enrollPersonController!.value.text,//Enrolling person
        farmerName,//Farmer Nmae
        fatherName,//Father Name
        grandfatherName,//GrandFather Nmae
        genderSelect,//Gender
        dateofbirth,//Date of birth
        photoPath,//Farmer Photo
        educatController!.value.text,//Education
        mobileNo,//Mobile Number
        val_cuntry,//country
        val_zone,//zone
        val_woreda,//woreda
        val_kebele,//kebele
        appargrupSelect,//Appartenance to a group Y/N
        val_typrgrup,//Type of group
        val_namegrup,//Name of the group
        val_positgrup,// Position in the Group
        val_loanklst,//Loan Taken Last Year
        loanAmountContoller!.text ,//loan Amount
        purposeContoller!.text,//loan Purpose
        bank_acc_no,//Account Number
        bank_name,//bank name
        branch_name,//branch name
        bankimgPath,//bank photo
        val_mapto//Select Mapped to
    );
    print('farmersave : ' + farmersave.toString());
    List<Map> farmervalsave = await db.GetTableValues('farmer');
    print("farmer : " + farmervalsave.toString());

    /*  String farmerinsqry =
        'INSERT INTO "main"."farmer" ("isSynched","farmerId","traceId","fName","lName","fatherName","farmerSurname","gender","dob","photo","noOfMembers","address","country","state","district","city","village","zipcode","phoneNo","mobileNo","email","latitude","longitude","timeStamp","coCode","samCode","gpCode","postCode","police_station","doj","farmerCode","maritalStatus","education","fpofgGrp","childCntSite","childCntPrim","childCntSec","certStandard","certCategory","fCertType","houseOwnership","houseType","annualIncome","ICSstatus","inspecType","enrollmentPlace","otherEnrollPlace","otherHouseType","adultCntSite","ppCode","trader","smartPhone","irpValue","certifiedFarmer","icsName","icsCode","ICSUnitNo","ICSTTracenet","farmerCodeByICS","farmerCodeByTracenet","isBeneficiary","nameOfScheme","schoolChild","workingChild","totalMale","totalFemale","otherHomeIncome","totalIncome","consumerElectronics","otherElectric","consumerVehicle","otherVehicle","farmerMobile","electricHouse","drinkWaterSource","otherdrinkSource","farmerInsurance","farmercropInsurance","farmerLoanapply","loanVendor","loanAmount","loanPurpose","loanInterestRate","loanSecurity","totFamilyMem","enrollmentDate","Age","category","status","otherHseOwner","otherLoanTakenFrom","currentSeason","adhar","idProof","idProofOthr","idProofVal","cooperative","HOF","toilet","toiletUsage","healthAmount","crpInsAmt","cropname","cropAcres","farmerLifeInsunce","LifeAmount","otherLoanPur","insTenure","otherLoanSec","deptOfScheme","cookFuel","ctName","otherCookFuel","adultCntSiteFe","childCntSiteFe","schoolChildFe","loanRePayAmount","loanRePayDate","homeDiff","workDiff","comDiff","assistiveDev","assistiveDevName","reqassistiveDev","healthIssue","healthIssueDes","homeDiffOth","workDiffOth","comDiffOth","formFiled","objective","placeAssmnt","assemnt","yearOfICS","farmerLoanGovScheme","loanGovScheme","qtyCookFuel","costCookFuel","fingerPrint","customVillageName","tenant","IdProofLatitude","IdProofLongitude","IdProofTimeStamp","IdProofphoto","idstatus","frPhoto","digitalSign")'
                'VALUES ('
                '\'1\',\'' +
            farmerid.toString() +
            '\','
                'null,\'' +
            farmerName +//farmer name
            '\',\'' +
            fatherName +//father name
            '\','
                'null,\'' +
            surNameController!.text +
            '\',\'' //dob
            +
            genderSelect +
            '\',\'' //gender
            +
            dob +
            '\',\'' //dob
            +
            // farmerImage64 +
            photoPath +
            '\',\'' //photo
            +
            totfamMember +
            '\',\'' //noOfMembers
            +
            addres +
            '\',\'' //address
            +
            val_cuntry +
            '\',\'' +
            val_circle +
            '\',\'' +
            val_woreda +
            '\',\'' +
            val_chieftown +
            '\',\'' +
            val_Village +
            '\','
                'null,\'' //pincode
            +
            phoneNo +
            '\',\'' +
            mobileNo +
            '\',\'' +
            email +
            '\',\'' +
            Lat +
            '\',\'' +
            Lng +
            '\',\'' +
            txntime +
            '\','
                'null,\'' +
            val_Groups +
            '\',\'' +
            val_Gram +
            '\','
                'null,'
                'null,'
                'null,\'' +
            farmerCode +
            '\',\'' +
            val_Marital +
            '\',\'' +
            val_Edu +//Education
            '\',\'' +
            val_Scheme +
            '\',\'' +
            totMChilds +
            '\','
                'null,'
                'null,'
                'null,'
                'null,\'' +
            val_certType +
            '\','
                'null,' //house ownership
                'null,\'' //house type
            +
            revenue +
            '\',' // annual income
                'null,' //ICS Status
                'null,\'' //InspecType
            +
            val_Enrol +
            '\',' //enrolPlace
                'null,' //otherEnrollPlace
                'null,\'' //otherHouseType
            +
            totMadults +
            '\',\'' //farmerflyNoAdt
            +
            yuthalt +
            '\',\'' //ppCode
            +
            bank_name +
            '\',\'' //trader
            +
            bank_acc_no +
            '\',\'' //smartPhone
            +
            branch_name +
            '\',\'' //irpValue
            +
            certifieduser +
            '\',\'' //certifiedFarmer
            +
            icsname +
            '\',\'' //icsName
            +
            icscode +
            '\',\'' //icscode
            +
            val_ICSName +
            '\',\'' //ICSUnitNo
            +
            val_ICSTracenet +
            '\',\'' //ICSTTracenet
            +
            icsfarmercode +
            '\',\'' //FarmerCodeICS
            +
            icsfarmertracenet +
            '\',' //FarmerCodeTrac
                'null,' //schemeStatus
                'null,\'' //nameOfScheme
            +
            totalMschool +
            '\',' //schoolChild
                '\'\',' //workingchild
                '\'\',' //totalMale
                '\'\',' //totalfemale
                'null,' //otherHomeIncome
                'null,\'' //totalIncome
            +
            val_Electronic +
            '\',' //consumerElectronics
                'null,\'' //otherElectric
            +
            val_Vechile +
            '\',' //consumerVehicle
                'null,' //otherVehicle
                'null,' //farmercellPhone
                'null,' //electricHouse
                'null,' //drinkWaterSource
                'null,\'' //otherdrinkSource
            +
            _selectedHealth +
            '\',\'' //farmerInsurance
            +
            _selectedCropInsu +
            '\',\'' //farmercropInsurance
            +
            _selectedloan +
            '\',\'' + //farmerLoanapply
            val_LoanType +
            '\',\'' +
            loanAmountContoller!.text +
            '\',\'' +
            val_loanpurpose +
            '\',\'' +
            loanInterestController!.text +
            '\',\'' +
            val_loansecurity +
            '\',\'' +
            totfamMember +
            '\',\'' //totFamilyMem
            +
            enrollmentFormatedDate +
            '\',\'' //enrollmentDate
            +
            age +
            '\',\'' //Age
            +
            val_Categroy +
            '\','
                'null,' //farmerStatus
                'null,' //otherHouseowner
                'null,\'' //otherLoanTakenFrom
            +
            seasoncode +
            '\',\'' //currentSeason
            +
            adhaarnoController!.text +
            '\',\'' //currentSeason
            +
            val_Proof +
            '\',' //ID proof
                'null,\'' //idProofOthr
            +
            proofno +
            '\',' //idProofVal
                'null,\'' //cooperative
            +
            _selectHead +
            '\',' //familyHead
                'null,' //toilet
                'null,\'' //toiletUsage
            +
            amthelController!.text +
            '\',\'' +
            amtCropController!.text +
            '\',\'' +
            val_CropType +
            '\',\'' +
            acreController!.text +
            '\',\'' +
            _selectedlifeInsu +
            '\',\'' +
            amtController!.text +
            '\',' + //LifeAmount
            'null,\'' //otherLoanPur
            +
            _selectedinterestperiod +
            '\',' //insTenure
                'null,' //otherLoanSec
                'null,' //deptOfScheme
                'null,' //cookFuel
                'null,' //ctName
                'null,\'' //otherCookFuel
            +
            totFdults +
            '\',\'' //farmerflyNoAdtFe
            +
            totFChilds +
            '\',\'' //numberOfchildsInSiteFe
            +
            totalFschool +
            '\',\'' + //schoolChildFe
            loanRepaymentController!.text +
            '\',\'' //numberOfchildsInSiteFe
            + //loanRePayAmount
            loanRepaymentFormatedDate +
            '\',' //numberOfchildsInSiteFe
                //loanRePayDate
                'null,' //homeDiff
                'null,' //workDiff
                'null,' //comDiff
                'null,' //assisDevice
                'null,' //assistiveDevName
                'null,' //reqassistiveDev
                'null,' //healthIssue
                'null,' //healthIssueDes
                'null,' //homeDiffOth
                'null,' //workDiffOth
                'null,' //comDiffOth
                'null,' //formFiled
                'null,' //objective
                'null,' //placeAssmnt
                'null,' //assemnt
                'null,' //yearOfICS
                'null,' //farmerLoanGovScheme
                'null,' //loanGovScheme
                'null,' //qtyCookFuel
                'null,' //costCookFuel
                'null,' //fingerPrint
                'null,\'' //customVillageName
            +
            appDatas.tenent +
            '\',' //teantId
                'null,' //IdProofLatitude
                'null,' //IdProofLongitude
                'null,\'' //cropAcres
            +
            idPath +
            '\',' //IdProofphoto
                '\'1\',' //idstatus
                '\'1\',' //frPhoto
                'null);';

    print(farmerinsqry);

    db.RawInsert(farmerinsqry);

    print(farmerinsqry);*/

    /* for (int i = 0; i < banklist.length; i++) {
      String branch_name = banklist[i].branch_name;
      String bank_name = banklist[i].bank_name;
      String ifsc = banklist[i].ifsc_code;
      String acc_no = banklist[i].acc_no;
      String acc_type = banklist[i].acc_Type;
      String bankins =
          'INSERT INTO "main"."bankList" ("farmerId", "bankACNumber", "bankName", "bankBranch", "IFSCcode", "SWIFTcode", "accountType", "otherAccountType") VALUES '
                  '(\'' +
              farmerid.toString() +
              '\',\' ' +
              acc_no +
              '\',\' ' +
              bank_name +
              '\',\' ' +
              branch_name +
              '\',\' ' +
              ifsc +
              '\', '
                  'null,\' ' +
              acc_type +
              '\', '
                  'null)';
      print("banklistinserting " + bankins);
      db.RawQuery(bankins);
    }*/


    db.UpdateTableValue(
        'farmer', 'isSynched', '0', 'farmerId', farmerid.toString());

    if (curIdLimited != 0) {
      db.UpdateTableValue(
          'agentMaster', 'curIdSeqF', farmerid.toString(), 'agentId', agendId);
      db.UpdateTableValue(
          'agentMaster', 'resIdSeqF', resId.toString(), 'agentId', agendId);
      db.UpdateTableValue('agentMaster', 'curIdLimitF', curIdLimited.toString(),
          'agentId', agendId);
    } else {
      db.UpdateTableValue(
          'agentMaster', 'curIdSeqF', farmerid.toString(), 'agentId', agendId);
    }
    /* String farmerCredit =
        'INSERT INTO "main"."farmerCrList" ("farmerCode", "farmerName", "osBal", "osBalProcurement", "tmpOsBal", "season", "season_settlement", "rateOfInterest", "principleAmount", "interestAmountAccumulated", "lastInterestCalDate", "proRateOfInterest", "proPrincipleAmount", "proInterestAmtAccumulate" ,"proLastInterestCalDate") VALUES '
                '(\'' +
            farmerid.toString() +
            '\',\' ' +
            farmerName +
            " " +
            fatherName +
            '\',\' ' +
            "0.00" +
            '\',\' ' +
            "0.00" +
            '\',\' ' +
            "0.00" +
            '\', \' ' +
            seasoncode +
            '\',\'' +
            "0.00" +
            '\', \' ' +
            "0.00" +
            '\',\' ' +
            "0.00" +
            '\', \' ' +
            "0.00" +
            '\', \' ' +
            "0.00" +
            '\', \' ' +
            "0.00" +
            '\', \' ' +
            "0.00" +
            '\', \' ' +
            "0.00" +
            '\', \' ' +
            "0.00" +
            '\')';
    print("farmerCredit " + farmerCredit);
    db.RawQuery(farmerCredit);*/
    Alert(
      context: context,
      type: AlertType.info,
      title: "Transaction Successful",
      desc: "Farmer Enrollment Successful",
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
        title: confirm,
        desc: proceed,
        buttons: [
          DialogButton(
            child: Text(
              no,
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
              yes,
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            //onPressed:btnok,
            onPressed: () {
              saveFarmer();
              Navigator.pop(context);
            },
            color: Colors.green,
          )
        ]).show();
  }

  void confirmationPopupp() {
    Alert(
      context: context,
      type: AlertType.warning,
      title: confirm,
      desc: proceed,
      buttons: [
        DialogButton(
          child: Text(
            yes,
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () {
            saveFarmer();
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

  Widget DatatableEquipment() {
    List<DataColumn> columns = [];
    List<DataRow> rows = [];
    columns.add(DataColumn(label: Text('Type')));
    columns.add(DataColumn(label: Text('Count')));
    columns.add(DataColumn(label: Text('Delete')));

    for (int i = 0; i < equipmentlist.length; i++) {
      List<DataCell> singlecell = [];
      //1
      singlecell.add(DataCell(Text(equipmentlist[i].equipName)));

      //2
      TextEditingController controller = new TextEditingController();
      controller.text = equipmentlist[i].equipCount;
      singlecell.add(DataCell(
          TextFormField(
            controller: controller,
            keyboardType: TextInputType.number,
            onFieldSubmitted: (val) {
              setState(() {
                if (val == '0') {
                  controller.text = '';
                  errordialog(context, "Alert", "Count should not be zero");
                } else {
                  setState(() {
                    equipmentlist[i].equipCount = val;
                  });
                }
              });
            },
          ),
          showEditIcon: true));
      //3

      singlecell.add(DataCell(InkWell(
        onTap: () {
          setState(() {
            equipmentlist.removeAt(i);
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

  Widget DatatableAnimal() {
    List<DataColumn> columns = [];
    List<DataRow> rows = [];
    columns.add(DataColumn(label: Text('Husbandry')));
    columns.add(DataColumn(label: Text('Count')));
    columns.add(DataColumn(label: Text('Fodder')));
    columns.add(DataColumn(label: Text('Housing')));
    columns.add(DataColumn(label: Text('Revenue')));
    columns.add(DataColumn(label: Text('Breed')));
    columns
        .add(DataColumn(label: Text('Estimated Manure Collected\n per Month')));
    columns
        .add(DataColumn(label: Text('Estimated Urine Collected\n per Month')));
    columns.add(DataColumn(label: Text('Delete')));

    for (int i = 0; i < animallist.length; i++) {
      List<DataCell> singlecell = [];
      //1
      singlecell.add(DataCell(Text(animallist[i].animal_name)));

      //2
      TextEditingController controller = new TextEditingController();
      controller.text = animallist[i].animalCount;
      singlecell.add(DataCell(
          TextFormField(
            controller: controller,
            keyboardType: TextInputType.number,
            onFieldSubmitted: (val) {
              setState(() {
                if (val == '0') {
                  controller.text = '';
                  errordialog(context, "Alert", "Count should not be zero");
                } else {
                  setState(() {
                    animallist[i].animalCount = val;
                  });
                }
              });
            },
          ),
          showEditIcon: true));
      //3
      String fodders = "";
      for (int f = 0; f < animallist[i].selctfodders.length; f++) {
        if (f == 0) {
          fodders = fodderModel[animallist[i].selctfodders[f]].name;
        } else {
          fodders =
              fodders + "," + fodderModel[animallist[i].selctfodders[f]].name;
        }
      }
      singlecell.add(DataCell(Text(fodders)));

      //4
      singlecell.add(DataCell(Text(animallist[i].animalHousing)));

      //5
      TextEditingController controller2 = new TextEditingController();
      controller2.text = animallist[i].revenue;
      singlecell.add(DataCell(
          TextFormField(
            controller: controller2,
            keyboardType: TextInputType.number,
            onFieldSubmitted: (val) {
              setState(() {
                if (val == '0') {
                  controller2.text = '';
                  errordialog(context, "Alert", "Revenue should not be zero");
                } else {
                  setState(() {
                    animallist[i].revenue = val;
                  });
                }
              });
            },
          ),
          showEditIcon: true));

      //6
      TextEditingController controller3 = new TextEditingController();
      controller3.text = animallist[i].breed;
      singlecell.add(DataCell(
          TextFormField(
            controller: controller3,
            keyboardType: TextInputType.number,
            onFieldSubmitted: (val) {
              setState(() {
                if (val == '0') {
                  controller3.text = '';
                  errordialog(context, "Alert", "Breed should not be zero");
                } else {
                  setState(() {
                    animallist[i].breed = val;
                  });
                }
              });
            },
          ),
          showEditIcon: true));

      //7
      TextEditingController controller4 = new TextEditingController();
      controller4.text = animallist[i].estiManure;
      singlecell.add(DataCell(
          TextFormField(
            controller: controller4,
            keyboardType: TextInputType.number,
            onFieldSubmitted: (val) {
              setState(() {
                if (val == '0') {
                  controller4.text = '';
                  errordialog(context, "Alert",
                      "Estimated Manure Collected per Month should not be zero");
                } else {
                  setState(() {
                    animallist[i].estiManure = val;
                  });
                }
              });
            },
          ),
          showEditIcon: true));

      //8
      TextEditingController controller5 = new TextEditingController();
      controller5.text = animallist[i].estimUrine;
      singlecell.add(DataCell(
          TextFormField(
            controller: controller5,
            keyboardType: TextInputType.number,
            onFieldSubmitted: (val) {
              setState(() {
                if (val == '0') {
                  controller5.text = '';
                  errordialog(context, "Alert",
                      "Estimated Urine Collected per Month should not be zero");
                } else {
                  setState(() {
                    animallist[i].estimUrine = val;
                  });
                }
              });
            },
          ),
          showEditIcon: true));

      singlecell.add(DataCell(InkWell(
        onTap: () {
          setState(() {
            animallist.removeAt(i);
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

  Widget DatatableBank() {
    List<DataColumn> columns = [];
    List<DataRow> rows = [];
    columns.add(DataColumn(label: Text('Account Type')));
    columns.add(DataColumn(label: Text('Account Number')));
    columns.add(DataColumn(label: Text('Bank Name')));
    columns.add(DataColumn(label: Text('Branch Name')));
    columns.add(DataColumn(label: Text('Sort/IFSC Code')));
    columns.add(DataColumn(label: Text('Delete')));

    for (int i = 0; i < banklist.length; i++) {
      List<DataCell> singlecell = [];
      //1
      singlecell.add(DataCell(Text(banklist[i].acc_Type)));

      //2
      TextEditingController controller = new TextEditingController();
      controller.text = banklist[i].acc_no;
      singlecell.add(DataCell(
          TextFormField(
            controller: controller,
            keyboardType: TextInputType.number,
            onFieldSubmitted: (val) {
              setState(() {
                if (val == '') {
                  controller.text = '';
                  errordialog(
                      context, "Alert", "Account Number should not be Empty");
                } else {
                  setState(() {
                    banklist[i].acc_no = val;
                  });
                }
              });
            },
          ),
          showEditIcon: true));
      //3
      TextEditingController controller2 = new TextEditingController();
      controller2.text = banklist[i].bank_name;
      singlecell.add(DataCell(
          TextFormField(
            controller: controller2,
            keyboardType: TextInputType.text,
            onFieldSubmitted: (val) {
              setState(() {
                if (val == '') {
                  controller2.text = '';
                  errordialog(
                      context, "Alert", "Bank Name should not be Empty");
                } else {
                  setState(() {
                    banklist[i].bank_name = val;
                  });
                }
              });
            },
          ),
          showEditIcon: true));

      //4
      TextEditingController controller3 = new TextEditingController();
      controller3.text = banklist[i].branch_name;
      singlecell.add(DataCell(
          TextFormField(
            controller: controller3,
            keyboardType: TextInputType.text,
            onFieldSubmitted: (val) {
              setState(() {
                if (val == '') {
                  controller3.text = '';
                  errordialog(
                      context, "Alert", "Branch Name should not be Empty");
                } else {
                  setState(() {
                    banklist[i].branch_name = val;
                  });
                }
              });
            },
          ),
          showEditIcon: true));

      //5
      TextEditingController controller4 = new TextEditingController();
      controller4.text = banklist[i].ifsc_code;
      singlecell.add(DataCell(
          TextFormField(
            controller: controller4,
            keyboardType: TextInputType.text,
            onFieldSubmitted: (val) {
              setState(() {
                if (val == '') {
                  controller4.text = '';
                  errordialog(
                      context, "Alert", "Sort/IFSC Code should not be Empty");
                } else {
                  setState(() {
                    banklist[i].ifsc_code = val;
                  });
                }
              });
            },
          ),
          showEditIcon: true));

      singlecell.add(DataCell(InkWell(
        onTap: () {
          setState(() {
            banklist.removeAt(i);
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
}


