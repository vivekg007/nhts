// import 'dart:async';
// import 'dart:convert';
// import 'dart:math';
// import '../Database/Databasehelper.dart';
// import '../Database/Model/FarmerMaster.dart';
// import '../Model/Geoareascalculate.dart';
// import '../Model/Treelistmodel.dart';
// import '../Model/UIModel.dart';
// import '../Model/animalmodel.dart';
// import '../Model/bankInfoModel.dart';
// import '../Model/dynamicfields.dart';
// import '../Model/equipmentmodel.dart';
// import '../Plugins/TxnExecutor.dart';
// import '../Utils/MandatoryDatas.dart';
// import 'geoploattingProposedLand.dart';
// import 'geoplottingaddfarm.dart';
// import 'navigation.dart';
// import 'package:cupertino_radio_choice/cupertino_radio_choice.dart';
// import 'package:dropdown_search/dropdown_search.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
//
// import 'dart:io' show File;
// import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:intl/intl.dart';
//
// import 'package:rflutter_alert/rflutter_alert.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// import 'addfarm.dart';
//
// class SeniorAgronomist extends StatefulWidget {
//   @override
//   State<StatefulWidget> createState() {
//     return _SeniorAgronomist();
//   }
// }
//
// class _SeniorAgronomist extends State<SeniorAgronomist> {
//   var db = DatabaseHelper();
//
//   List<UImodel> icsnamelistModel = [];
//   List<UImodel> icstracelistModel = [];
//   //so we can call snackbar from anywhere
//   List<UImodel> enrolllistModel = [];
//   List<UImodel> countryUIModel = [];
//   List<UImodel> stateUIModel = [];
//   List<UImodel> districtUIModel = [];
//   List<UImodel> cityListUIModel = [];
//   List<UImodel> PanchayatListUIModel = [];
//   List<UImodel> VillageListUIModel = [];
//   List<UImodel> idProofUIModel = [];
//   List<UImodel> marritallistModel = [];
//   List<UImodel> educationlistModel = [];
//   List<UImodel> farmequpmentslistModel = [];
//   List<UImodel> animalhusbandarysModel = [];
//   List<UImodel> consumerelectronicsModel = [];
//   List<UImodel> vehiclesUIModel = [];
//   List<UImodel> AccountTypeUIModel = [];
//   // List<UImodel> LoanTypeUIModel = [];
//   List<UImodel> CropTypeUIModel = [];
//   List<UImodel> fodderModel = [];
//   List<UImodel> animalhousingModel = [];
//   List<UImodel> groupsModel = [];
//   List<UImodel> certificationModel = [];
//   List<UImodel> loanTakenModel = [];
//   List<UImodel> loanPurposeModel = [];
//   List<UImodel> loanSecurityModel = [];
//   List<UImodel> positionGroupModel = [];
//   List<UImodel> SchemeModel = [];
//   List<UImodel> CategoryModel = [];
//   List<UImodel> cuntryUIModel = [];
//   List<UImodel> zoneUIModel = [];
//   List<UImodel> woredaUIModel = [];
//   List<UImodel> kebeleUIModel = [];
//   List<UImodel> chieftownUIModel = [];
//
//   List<DropdownModel> idProofitems = [];
//   DropdownModel? slctidProofs;
//
//   List<DropdownModel> cuntryitems = [];
//   DropdownModel? slctcuntry;
//
//   List<DropdownModel> zoneitems = [];
//   DropdownModel? slctzone;
//
//   List<DropdownModel> woredaitems = [];
//   DropdownModel? slctworeda;
//
//   List<DropdownModel> chiefTownitems = [];
//   DropdownModel? slctchiefTowns;
//
//   List<DropdownModel> kebeleitems = [];
//   DropdownModel? slctkebele;
//
//   List<DropdownModel> villageiteams = [];
//   DropdownModel? slctvillage;
//
//   List<DropdownModel> typgrupitems = [];
//   DropdownModel? slcttypgrup;
//
//   List<DropdownModel> namegrupitems = [];
//   DropdownModel? slctnmaegrup;
//
//   List<DropdownModel> positgrupitems = [];
//   DropdownModel? slctpositgrup;
//
//   List<DropdownModel> loanitems = [];
//   DropdownModel? slctLoanType;
//
//   List<DropdownModel> maptoitems = [];
//   DropdownModel? slctmapto;
//
//   List<DropdownModel> enrollemntitems = [];
//   DropdownModel? slctEnrol;
//
//   List<DropdownModel> educationitems = [];
//   DropdownModel? slctEdu;
//
//   String seedlingdate = 'Date of Birth';
//   String farmerCodeval = "";
//
//   String curLat = '';
//   String curLong = '';
//   String Landsize = '';
//
//   List<Map> agents = [];
//   String agronomistDate = "",agronomistFormatedDate="";
//   bool stateLoaded = false;
//   bool districtLoaded = false;
//   bool cityLoaded = false;
//
//   bool regionloaded = false;
//   bool zoneloaded = false;
//   bool woredaloaded = false;
//   bool chieftownloaded = false;
//   bool kebeleLoaded = false;
//   bool villageLoaded = false;
//   DropdownModel? slctProofs;
//   String slctProof = '';
//   String slctcertType = "",
//       slctCountry = "",
//       slctState = "",
//       slctDistrict = "",
//       slctTaluk = "",
//       slctGram = "",
//       slctVillage = "",
//       slctGroups = "",
//       slctMarital = "",
//       slctEquipment = "",
//       slctVechile = "",
//       slctElectronic = "",
//       slctAnimalHouse = "",
//       slctfodder = "",
//       slctAnimal = "",
//       slctAccType = "",
//       slctCropType = "",
//       slctICS = "",
//       slctTrace = "",
//       slctLoanPurpose = '',
//       slctLoanSecurity = '',
//       slctPositionGropup = '',
//       slctScheme = '',
//       slctCategory = '',
//       slctCrop = '',
//       slctCircle = '',
//       slctCommune = '',
//       slctChieftown = '';
//   List<DropdownModel> idproofitems = [];
//   List<DropdownMenuItem> fodderitems = [],
//       equipmentitems = [],
//       certitypeitems = [],
//       districtitems = [],
//       cityitems = [],
//       countryitems = [],
//       stateitems = [],
//       ditrictitems = [],
//       talukitems = [],
//       grampanchayatitems = [],
//       groupitems = [],
//       maritalitems = [],
//       animalitems = [],
//       animalhouseitems = [],
//       acctypeitems = [],
//       loantypeitems = [],
//       croptypeitems = [],
//       vechileitems = [],
//       electronicitems = [],
//       icsnameitems = [],
//       icstraceitems = [],
//       loanPurposeitems = [],
//       loanSecurityitem = [],
//       positiongroupitem = [],
//       schemeitems = [],
//       cateogryitems = [],
//       chieftownitems = [];
//
//   List<int> selectedequipments = [];
//   List<int> selectedfodders = [];
//   List<int> selectedelectronics = [];
//   List<int> selectedvehicles = [];
//   //List<int> selectedcrop = [];
//
//   List<BankInformation> banklist = [];
//   List<AnimalInfo> animallist = [];
//   List<EquipmentModel> equipmentlist = [];
//
//   TextEditingController? farmerNameController,
//       enrollPersonController,
//       fatherNameController,
//       GrndfthNameController,
//       mobileController,
//       educatController,
//       surNameController,
//       loanAmountContoller,
//       purposeContoller,
//       accountnoController,
//       bankController,
//       branchController,
//       yrbrthController,
//       icsnameController,
//       icscodeController,
//       ageController,
//       proofnoController,
//       adhaarnoController,
//       amtController,
//       amthelController,
//       acreController,
//       amtCropController,
//       addressController,
//       phoneController,
//       emailController,
//       totNoFamilyController,
//       totAdultMController,
//       totAdultFController,
//       totalChildMController,
//       totChildFController,
//       schlGoingMController,
//       schlGoingFController,
//       totHouseholdController,
//       totHouseholdMController,
//       totHouseholdFController,
//       animalcountController,
//       animalrevenueController,
//       animalBreedController,
//       estimateManureController,
//       estimateUrineController,
//       equipmentcountController,
//       ifscController,
//       icsfarmercodeController,
//       icstracenetController,
//       loanInterestController,
//       loanRepaymentController,
//       AdhaarcardController;
//
//   String yuthalt = '';
//   int elegibleRegister = 0;
//   String  val_cuntry = "",val_zone="",val_woreda="",val_kebele="",val_typrgrup="",val_namegrup="",
//       val_positgrup="",val_loanklst="",val_mapto="",val_enroll="",val_edu="";
//   String slct_Zone="",slctCuntry="",slct_woreda="",slct_kebele="",slct_typgrup="",slct_namegrup="",
//       slct_positgrup="",slct_loanlsyear="",slct_mapto="",slct_enroll="",slct_edu="";
//   String val_certType = "",
//       val_Enrol = "",
//       val_Proof = "",
//       val_State = "",
//       val_District = "",
//       val_Taluk = "",
//       val_Gram = "",
//       val_Village = "",
//       val_Groups = "",
//       val_Edu = "",
//       val_Marital = "",
//       val_Equipment = "",
//       val_Vechile = "",
//       val_Electronic = "",
//       val_AnimalHouse = "",
//       val_fodder = "",
//       val_Animal = "",
//       val_AccType = "",
//       val_CropType = "",
//       val_LoanType = "",
//       val_ICSName = "",
//       val_ICSTracenet = "",
//       val_loanpurpose = '',
//       val_loansecurity = '',
//       val_positionGroup = '',
//       val_Scheme = '',
//       val_Categroy = '',
//       val_circle = '',
//       val_chieftown = '';
//
//   int farmerid = 0;
//   bool isregistration = false;
//   bool ishavefarmercode = false;
//   bool gramPanchayat = false;
//   bool isloantaken = false;
//   String Lat = '0', Lng = '0';
//   String seasoncode = '';
//   String servicePointId = '';
//   String agendId = '';
//   String slct_farmer='',slct_farm='',villageCode='',slct_village='',farmerId='',farmId='',dateofbirth='',dateofyear='';
//
//   List<DropdownModel> farmeritems = [];
//   DropdownModel? slctFarmers;
//
//   List<DropdownModel> villageitems = [];
//   DropdownModel? slctvillages;
//
//   List<DropdownModel> farmitems = [];
//   DropdownModel? slctFarm;
//
//   List<UImodel> villagelistUIModel = [];
//   List<UImodel2> farmerlistUIModel = [];
//   List<UImodel2> farmlistUIModel = [];
//
//   File? farmerImageFile;
//   File? bankImageFile;
//   File? idProofImageFile;
//   int curIdLim = 0;
//   int resId = 0;
//   int curIdLimited = 0;
//   bool addbank = false;
//   bool loan_Taken = false;
//   bool farmerloaded = false;
//   bool farmloaded = false;
//
//   FormFieldSetter<dynamic>? _myActivities;
//   String? _myActivitiesResult;
//
//   final animalListitems = [
//     {
//       'display': "MALE1",
//       'value': "MALE1",
//     },
//     {
//       'display': "MALE2",
//       'value': "MALE2",
//     },
//     {
//       'display': "MALE3",
//       'value': "MALE3",
//     },
//     {
//       'display': "MALE4",
//       'value': "MALE4",
//     },
//   ];
//
//   String farmerenrollment = 'Farmer Registration';
//   String PersonalInfo = 'Personal Information';
//   String FName = 'Farmer Name';
//   String FthrName = 'Father Name';
//   String FCode = 'Farmer Code';
//   String GrndfthrName = 'Grandfather Name';
//   String Dob = 'Date of birth';
//   String Gender = 'Gender';
//   String male = 'Male';
//   String female = 'Female';
//   String IDproof = 'ID Proof';
//   String IDproofHint = 'Select the ID Proof';
//   String ProofNo = 'Proof No';
//   String FarmerPhoto = 'Farmer Photo';
//   String cuntry = 'Country';
//   String cuntryHint = 'Select the Country';
//   String zone = 'Zone';
//   String zoneHint = 'Select the Zone';
//   String woreda = 'Woreda';
//   String woredaHint = 'Select the Woreda';
//   String chiefTown = 'Chief Town';
//   String chiefTownHint = 'Select the Chief Town';
//   String kebele = 'Kebele';
//   String KebeleHint = 'Select the Kebele';
//   String mobileNo = 'Mobile Number';
//   String noFamilyMem = 'Number of Family Memebers';
//   String typgrcup = 'Type of group';
//   String namegrup = 'Name of the group';
//   String positgrup = 'Position in the Group';
//   String typgrupHint = 'Select the Type of group';
//   String namegrupHint = 'Select the Name of the group';
//   String positgrupHint = 'Select the Position in the Group';
//   String save = 'Save';
//   String chse = 'Choose';
//   String galry = 'Gallery';
//   String pickimg = 'Pick Image';
//   String Camera = 'Camera';
//   String deny = 'deny';
//   String onlytym = 'only this time';
//   String whiluseapp = 'While using the app ';
//   String Allowtakepic = 'Allow IronKettle to take picture and record video?';
//   String info = 'Information';
//   String infoFname = 'Farmer Name should not be empty';
//   String infoFthname = 'Father Name should not be empty';
//   String infodob = 'Date of Birth should not be empty';
//   String infocuntry = 'Country should not be empty';
//   String infocircle = 'Circle should not be empty';
//   String infoworeda = 'Woreda should not be empty';
//   String infChiefcommune = 'Chief Town should not be empty';
//   String infokebele = 'Kebele should not be empty';
//   String transactionsuccesfull = 'Transaction Successful';
//   String farmersuccess = 'Farmer Registration Successfull';
//   String infonof = 'Number of Family Members should not be empty';
//   String infogroupco = 'Group / CoOperative should not be empty';
//   String cancel = 'Cancel';
//   String rusurecancel = 'Are you sure want to cancel?';
//   String success = 'Success !';
//   String confirm = 'Confirmation';
//   String proceed = 'Are you sure you want to Proceed?';
//   String yes = 'Yes';
//   String no = 'No';
//   String gpslocation = 'GPS Location not enabled';
//   String ok = 'OK';
//   @override
//   void initState() {
//     super.initState();
//
//     initvalues();
//     getClientData();
//     val_loanklst="NO";
//     enrollPersonController = new TextEditingController();
//     farmerNameController = new TextEditingController();
//     fatherNameController = new TextEditingController();
//     GrndfthNameController = new TextEditingController();
//     mobileController = new TextEditingController();
//     surNameController = new TextEditingController();
//     loanAmountContoller = new TextEditingController();
//     purposeContoller = new TextEditingController();
//     accountnoController = new TextEditingController();
//     bankController= new TextEditingController();
//     branchController= new TextEditingController();
//     yrbrthController = new TextEditingController();
//     icsnameController = new TextEditingController();
//     icscodeController = new TextEditingController();
//     ageController = new TextEditingController();
//     proofnoController = new TextEditingController();
//     adhaarnoController = new TextEditingController();
//     amtController = new TextEditingController();
//     amthelController = new TextEditingController();
//     acreController = new TextEditingController();
//     addressController = new TextEditingController();
//     educatController = new TextEditingController();
//     phoneController = new TextEditingController();
//     emailController = new TextEditingController();
//     totNoFamilyController = new TextEditingController();
//     totAdultMController = new TextEditingController();
//     totAdultFController = new TextEditingController();
//     totalChildMController = new TextEditingController();
//     totChildFController = new TextEditingController();
//     schlGoingMController = new TextEditingController();
//     schlGoingFController = new TextEditingController();
//     totHouseholdController = new TextEditingController();
//     totHouseholdMController = new TextEditingController();
//     totHouseholdFController = new TextEditingController();
//     animalcountController = new TextEditingController();
//     animalrevenueController = new TextEditingController();
//     animalBreedController = new TextEditingController();
//     estimateManureController = new TextEditingController();
//     estimateUrineController = new TextEditingController();
//     accountnoController = new TextEditingController();
//     bankController = new TextEditingController();
//     branchController = new TextEditingController();
//     ifscController = new TextEditingController();
//     equipmentcountController = new TextEditingController();
//     icsfarmercodeController = new TextEditingController();
//     icstracenetController = new TextEditingController();
//     loanInterestController = new TextEditingController();
//     loanRepaymentController = new TextEditingController();
//     AdhaarcardController = new TextEditingController();
//     amtCropController = new TextEditingController();
//
//     yrbrthController!.addListener(() {
//       setState(() {
//         calAgeyr();
//       });
//     });
//     final now = new DateTime.now();
//     agronomistDate = DateFormat('yyyy-MM-dd').format(now);
//     isloantaken = false;
//     getLocation();
//   }
//
//   void getLocation() async {
//     bool isLocationEnabled = await Geolocator.isLocationServiceEnabled();
//     if (isLocationEnabled) {
//       Position position = await Geolocator.getCurrentPosition(
//           desiredAccuracy: LocationAccuracy.high);
//
//       print("latitude :" +
//           position.latitude.toString() +
//           " longitude: " +
//           position.longitude.toString());
//       setState(() {
//         Lat = position.latitude.toString();
//         Lng = position.longitude.toString();
//
//         curLat = position.latitude.toString();
//         curLong = position.longitude.toString();
//       });
//     } else {
//       Alert(context: context, title: info, desc: gpslocation, buttons: [
//         DialogButton(
//           child: Text(
//             ok,
//             style: TextStyle(color: Colors.white, fontSize: 18),
//           ),
//           onPressed: () {
//             Navigator.pop(context);
//             Navigator.pop(context);
//           },
//           color: Colors.green,
//         )
//       ]).show();
//     }
//   }
//
//   @override
//   void dispose() {
//     super.dispose();
//   }
//
//   getClientData() async {
//     agents = await db.RawQuery('SELECT * FROM agentMaster');
//
//     seasoncode = agents[0]['currentSeasonCode'];
//     servicePointId = agents[0]['servicePointId'];
//     agendId = agents[0]['agentId'];
//     String resIdd = agents[0]['resIdSeqF'];
//     print("resIdgetcliendata" + resIdd);
//     print("agendId_agendId" + agendId);
//     //farmerIdGeneration();
//
//    // print("farmerid_farmergeneration" + farmerid.toString());
//   }
//
//   void farmerIdGeneration() {
//     print("farmerIDgenearation");
//     String temp = agents[0]['curIdSeqF'];
//     int curId = int.parse(agents[0]['curIdSeqF']);
//     print("curId_curId" + curId.toString());
//     resId = int.parse(agents[0]['resIdSeqF']);
//     print("resId_resId" + resId.toString());
//     curIdLim = int.parse(agents[0]['curIdLimitF']);
//     print("curIdLim_curIdLim" + curIdLim.toString()); //45
//     int newIdGen = 0;
//     int incGenId = curId + 1;
//     print("incGenId_incGenId" + incGenId.toString());
//     curIdLimited = 0;
//     int MAX_Limit = 5;
//     if (incGenId <= curIdLim) {
//       newIdGen = incGenId;
//       print('farmer_id_lessthan ' + newIdGen.toString());
//       farmerid = newIdGen;
//     } else {
//       if (resId != 0) {
//         newIdGen = resId + 1;
//         curId = newIdGen;
//         curIdLimited = resId + MAX_Limit;
//         print('resId ' + resId.toString());
//         resId = 0;
//         print('farmer_id_notequal ' + newIdGen.toString());
//         farmerid = newIdGen;
//       } else {
//         print('farmer_id_else ' + newIdGen.toString());
//         farmerid = newIdGen;
//       }
//     }
//   }
//
//   Future<void> initvalues() async {
//     loan_Taken = false;
//     //enrollment place
//     List enrolllist= await db.RawQuery('select * from dropdownValues where catalog_code = \'ENROLLPLACE\' and lang =\'en\'');
//     print('enrolllist ' + enrolllist.toString());
//     enrollemntitems.clear();
//     for (int i = 0; i < enrolllist.length; i++) {
//       String property_value = enrolllist[i]["property_value"].toString();
//       String DISP_SEQ = enrolllist[i]["DISP_SEQ"].toString();
//
//       setState(() {
//         enrollemntitems.add(DropdownModel(
//           property_value,
//           DISP_SEQ,
//         ));
//       });
//     }
//     /*String qryics =
//         'SELECT anicat.DISP_SEQ,anicat.catalog_code,IF''(dylang.langValue,anicat.property_value) as property_value,anicat._ID from '
//         'animalCatalog as anicat LEFT JOIN dynamiccomponentLanguage as dylang ON dylang.componentID = anicat.DISP_SEQ and dylang.langCode = \'en\' '
//         'order by upper(anicat.DISP_SEQ) asc;';
//     print('icslist ' + qryics);
//     List icslist = await db.RawQuery(qryics);
//
//     icsnamelistModel = [];
//     icsnameitems.clear();
//
//     icstracelistModel = [];
//     icstraceitems.clear();
//
//     print('icslist ' + icslist.toString());
//
//     for (int i = 0; i < icslist.length; i++) {
//       if (icslist[i]["catalog_code"].toString() == "28") {
//         String property_value = icslist[i]["property_value"].toString();
//         String DISP_SEQ = icslist[i]["DISP_SEQ"].toString();
//         var uimodel = new UImodel(property_value, DISP_SEQ);
//         icsnamelistModel.add(uimodel);
//         setState(() {
//           icsnameitems.add(DropdownMenuItem(
//             child: Text(property_value),
//             value: property_value,
//           ));
//         });
//       } else if (icslist[i]["catalog_code"].toString() == "29") {
//         String property_value = icslist[i]["property_value"].toString();
//         String DISP_SEQ = icslist[i]["DISP_SEQ"].toString();
//         var uimodel = new UImodel(property_value, DISP_SEQ);
//         icstracelistModel.add(uimodel);
//         setState(() {
//           icstraceitems.add(DropdownMenuItem(
//             child: Text(property_value),
//             value: property_value,
//           ));
//         });
//       }
//     }*/
//
//     List cateloglist = await db.RawQuery('select * from animalCatalog');
//     print('animalCatalog ' + cateloglist.toString());
//
//     //countrylist
//     // List countrylist = await db.RawQuery('select * from countryList');
//     // print('countryList ' + countrylist.toString());
//     // countryUIModel = [];
//     // countryitems.clear();
//     // for (int i = 0; i < countrylist.length; i++) {
//     //   String countryCode = countrylist[i]["countryCode"].toString();
//     //   String countryName = countrylist[i]["countryName"].toString();
//     //
//     //   var uimodel = new UImodel(countryName, countryCode);
//     //   countryUIModel.add(uimodel);
//     //   setState(() {
//     //     countryitems.add(DropdownMenuItem(
//     //       child: Text(countryName),
//     //       value: countryName,
//     //     ));
//     //   });
//     // }
//
//     /*IDPROOF */
//     List idprooflist = await db.RawQuery(
//         'select * from animalCatalog where catalog_code =\'44\'');
//
//     List otherlist = await db.RawQuery(
//         'select distinct DISP_SEQ ,property_value from catalog where  DISP_SEQ=\'99\' and property_value =\'Others\' ');
//
//     List newList = idprooflist + otherlist;
//     print("newList_newList" + newList.toString());
//
//     idProofUIModel = [];
//
//     idproofitems.clear();
//     for (int i = 0; i < newList.length; i++) {
//       String property_value = newList[i]["property_value"].toString();
//       String DISP_SEQ = newList[i]["DISP_SEQ"].toString();
//       var uimodel = new UImodel(property_value, DISP_SEQ);
//       idProofUIModel.add(uimodel);
//
//       setState(() {
//         idproofitems.add(DropdownModel(
//           property_value,
//           DISP_SEQ,
//         ));
//         //prooflist.add(property_value);
//       });
//     }
//
//     //Category
//     List categroy = await db.RawQuery(
//         'select * from animalCatalog where catalog_code =\'12\'');
//     print('categroy ' + categroy.toString());
//     CategoryModel = [];
//     cateogryitems.clear();
//     for (int i = 0; i < categroy.length; i++) {
//       String property_value = categroy[i]["property_value"].toString();
//       String DISP_SEQ = categroy[i]["DISP_SEQ"].toString();
//
//       var uimodel = new UImodel(property_value, DISP_SEQ);
//       CategoryModel.add(uimodel);
//       setState(() {
//         cateogryitems.add(DropdownMenuItem(
//           child: Text(property_value),
//           value: property_value,
//         ));
//         //prooflist.add(property_value);
//       });
//     }
//
//     //marrital status
//     List marritallist = await db.RawQuery(
//         'select * from animalCatalog where catalog_code =\'47\'');
//     print('marritallist ' + marritallist.toString());
//     marritallistModel = [];
//     //maritalList.clear();
//     maritalitems.clear();
//     for (int i = 0; i < marritallist.length; i++) {
//       String property_value = marritallist[i]["property_value"].toString();
//       String DISP_SEQ = marritallist[i]["DISP_SEQ"].toString();
//
//       var uimodel = new UImodel(property_value, DISP_SEQ);
//       marritallistModel.add(uimodel);
//       setState(() {
//         maritalitems.add(DropdownMenuItem(
//           child: Text(property_value),
//           value: property_value,
//         ));
//         //maritalList.add(property_value);
//       });
//     }
//
//     //Education
//     List educationlist = await db.RawQuery(
//         'select * from animalCatalog where catalog_code =\'7\'');
//     print('marritallist ' + educationlist.toString());
//     educationitems.clear();
//     for (int i = 0; i < educationlist.length; i++) {
//       String property_value = educationlist[i]["property_value"].toString();
//       String DISP_SEQ = educationlist[i]["DISP_SEQ"].toString();
//       setState(() {
//         educationitems.add(DropdownModel(
//           property_value,
//           DISP_SEQ,
//         ));
//       });
//     }
//
//     //Farm Equipments
//     List farmequipments = await db.RawQuery(
//         'select * from animalCatalog where catalog_code =\'1\'');
//     print('farmequipments ' + farmequipments.toString());
//     farmequpmentslistModel = [];
//     //equipmentList.clear();
//     equipmentitems.clear();
//     for (int i = 0; i < farmequipments.length; i++) {
//       String property_value = farmequipments[i]["property_value"].toString();
//       String DISP_SEQ = farmequipments[i]["DISP_SEQ"].toString();
//
//       var uimodel = new UImodel(property_value, DISP_SEQ);
//       farmequpmentslistModel.add(uimodel);
//       setState(() {
//         equipmentitems.add(DropdownMenuItem(
//           child: Text(property_value),
//           value: property_value,
//         ));
//         //equipmentList.add(property_value);
//       });
//     }
//
//     //animal husbandary
//     List animalhusbandarys = await db.RawQuery(
//         'select * from animalCatalog where catalog_code =\'2\'');
//     print('farmequipments ' + animalhusbandarys.toString());
//     animalhusbandarysModel = [];
//     //animalList.clear();
//     animalitems.clear();
//     for (int i = 0; i < animalhusbandarys.length; i++) {
//       String property_value = animalhusbandarys[i]["property_value"].toString();
//       String DISP_SEQ = animalhusbandarys[i]["DISP_SEQ"].toString();
//
//       var uimodel = new UImodel(property_value, DISP_SEQ);
//       animalhusbandarysModel.add(uimodel);
//       setState(() {
//         animalitems.add(DropdownMenuItem(
//           child: Text(property_value),
//           value: property_value,
//         ));
//       });
//     }
//
//     //fodder
//     List fodders = await db.RawQuery(
//         'select * from animalCatalog where catalog_code =\'3\'');
//     print('fodder ' + fodders.toString());
//     fodderModel = [];
//     fodderitems.clear();
//     for (int i = 0; i < fodders.length; i++) {
//       String property_value = fodders[i]["property_value"].toString();
//       String DISP_SEQ = fodders[i]["DISP_SEQ"].toString();
//
//       var uimodel = new UImodel(property_value, DISP_SEQ);
//       fodderModel.add(uimodel);
//       setState(() {
//         fodderitems.add(DropdownMenuItem(
//           child: Text(property_value),
//           value: property_value,
//         ));
//         //fodderList.add(property_value);
//       });
//     }
//
//     List animalhousings = await db.RawQuery(
//         'select * from animalCatalog where catalog_code =\'4\'');
//     print('animalhousings ' + animalhousings.toString());
//     animalhousingModel = [];
//     //animalhouseList.clear();
//     animalhouseitems.clear();
//     for (int i = 0; i < animalhousings.length; i++) {
//       String property_value = animalhousings[i]["property_value"].toString();
//       String DISP_SEQ = animalhousings[i]["DISP_SEQ"].toString();
//
//       var uimodel = new UImodel(property_value, DISP_SEQ);
//       animalhousingModel.add(uimodel);
//       setState(() {
//         animalhouseitems.add(DropdownMenuItem(
//           child: Text(property_value),
//           value: property_value,
//         ));
//       });
//     }
//
//     //Groups
//     List groups = await db.RawQuery(
//         'select sam.samCode,sam.samName from samitee sam,agentSamiteeList agentsam where agentsam.samCode=sam.samCode');
//     print('groups ' + groups.toString());
//     groupsModel = [];
//     //groupList.clear();
//     typgrupitems.clear();
//     for (int i = 0; i < groups.length; i++) {
//       String samName = groups[i]["samName"].toString();
//       String samCode = groups[i]["samCode"].toString();
//
//       var uimodel = new UImodel(samName, samCode);
//       groupsModel.add(uimodel);
//       setState(() {
//         typgrupitems.add(DropdownModel(
//           samName,
//           samCode,
//         ));
//         //prooflist.add(property_value);
//       });
//     }
//     //Name of the group
//     List namegroups = await db.RawQuery('select * from animalCatalog where catalog_code =\'62\'');
//     print('namegroups ' + namegroups.toString());
//     namegrupitems.clear();
//     for (int i = 0; i < namegroups.length; i++) {
//       String groupName = namegroups[i]["property_value"].toString();
//       String groupCode = namegroups[i]["DISP_SEQ"].toString();
//       setState(() {
//         namegrupitems.add(DropdownModel(
//           groupName,
//           groupCode,
//         ));
//       });
//     }
//
//     //Position in the Group
//     List positgroups = await db.RawQuery('select * from animalCatalog where catalog_code =\'153\'');
//     print('positgroups ' + positgroups.toString());
//     positgrupitems.clear();
//     for (int i = 0; i < positgroups.length; i++) {
//       String positgroupName = positgroups[i]["property_value"].toString();
//       String positgroupCode = positgroups[i]["DISP_SEQ"].toString();
//       setState(() {
//         positgrupitems.add(DropdownModel(
//           positgroupName,
//           positgroupCode,
//         ));
//       });
//     }
//
//
//     //consumer electronics
//     List consumerelectronics = await db.RawQuery(
//         'select * from animalCatalog where catalog_code =\'65\'');
//     print('consumerelectronics ' + consumerelectronics.toString());
//     consumerelectronicsModel = [];
//     //electronicsList.clear();
//     electronicitems.clear();
//     for (int i = 0; i < consumerelectronics.length; i++) {
//       String property_value =
//       consumerelectronics[i]["property_value"].toString();
//       property_value = consumerelectronics[i]["property_value"].toString();
//       String DISP_SEQ = consumerelectronics[i]["DISP_SEQ"].toString();
//
//       var uimodel = new UImodel(property_value, DISP_SEQ);
//       consumerelectronicsModel.add(uimodel);
//       setState(() {
//         electronicitems.add(DropdownMenuItem(
//           child: Text(property_value),
//           value: property_value,
//         ));
//         //electronicsList.add(property_value);
//       });
//     }
//
//     List vehicles = await db.RawQuery(
//         'select * from animalCatalog where catalog_code =\'66\'');
//     print('vehicles ' + vehicles.toString());
//     vehiclesUIModel = [];
//     vechileitems.clear();
//     for (int i = 0; i < vehicles.length; i++) {
//       String property_value = vehicles[i]["property_value"].toString();
//       String DISP_SEQ = vehicles[i]["DISP_SEQ"].toString();
//
//       var uimodel = new UImodel(property_value, DISP_SEQ);
//       vehiclesUIModel.add(uimodel);
//       setState(() {
//         vechileitems.add(DropdownMenuItem(
//           child: Text(property_value),
//           value: property_value,
//         ));
//         //vechileList.add(property_value);
//       });
//     }
//
//     //accounttypes
//     List accounttypes = await db.RawQuery(
//         'select * from animalCatalog where catalog_code =\'33\'');
//     print('accounttypes ' + accounttypes.toString());
//     AccountTypeUIModel = [];
//     //salTypeList.clear();
//     acctypeitems.clear();
//     for (int i = 0; i < accounttypes.length; i++) {
//       String property_value = accounttypes[i]["property_value"].toString();
//       String DISP_SEQ = accounttypes[i]["DISP_SEQ"].toString();
//
//       var uimodel = new UImodel(property_value, DISP_SEQ);
//       AccountTypeUIModel.add(uimodel);
//       setState(() {
//         acctypeitems.add(DropdownMenuItem(
//           child: Text(property_value),
//           value: property_value,
//         ));
//         //salTypeList.add(property_value);
//       });
//     }
//
//     List croptypes = await db.RawQuery('select * from cropList');
//     print('croptypes ' + croptypes.toString());
//     CropTypeUIModel = [];
//     //salTypeList.clear();
//     croptypeitems.clear();
//     for (int i = 0; i < croptypes.length; i++) {
//       String property_value = croptypes[i]["fname"].toString();
//       String DISP_SEQ = croptypes[i]["fcode"].toString();
//
//       var uimodel = new UImodel(property_value, DISP_SEQ);
//       CropTypeUIModel.add(uimodel);
//       setState(() {
//         croptypeitems.add(DropdownMenuItem(
//           child: Text(property_value),
//           value: property_value,
//         ));
//       });
//     }
//
//     //Loan Taken Last Year
//     List loantypes = await db.RawQuery('select * from animalCatalog where catalog_code =\'34\'');
//     print('loantypes ' + loantypes.toString());
//     loanTakenModel = [];
//     //groupList.clear();
//     loanitems.clear();
//     for (int i = 0; i < loantypes.length; i++) {
//       String property_value = loantypes[i]["property_value"].toString();
//       String DISP_SEQ = loantypes[i]["DISP_SEQ"].toString();
//
//       var uimodel = new UImodel(property_value, DISP_SEQ);
//       loanTakenModel.add(uimodel);
//       setState(() {
//         loanitems.add(DropdownModel(
//           property_value,
//           DISP_SEQ,
//         ));
//         //prooflist.add(property_value);
//       });
//     }
//     //Mapped To
//     List mapto= await db.RawQuery('select * from animalCatalog where catalog_code =\'157\'');
//     print('mappedto ' + mapto.toString());
//     maptoitems.clear();
//     for (int i = 0; i < mapto.length; i++) {
//       String property_value = mapto[i]["property_value"].toString();
//       String DISP_SEQ = mapto[i]["DISP_SEQ"].toString();
//
//       setState(() {
//         maptoitems.add(DropdownModel(
//           property_value,
//           DISP_SEQ,
//         ));
//       });
//     }
//
//     //Fpo/Fg group
//     List schemename = await db.RawQuery(
//         'select * from animalCatalog where catalog_code =\'11\'');
//     print('loantypes ' + loantypes.toString());
//     SchemeModel = [];
//     schemeitems.clear();
//     for (int i = 0; i < schemename.length; i++) {
//       String property_value = schemename[i]["property_value"].toString();
//       String DISP_SEQ = schemename[i]["DISP_SEQ"].toString();
//
//       var uimodel = new UImodel(property_value, DISP_SEQ);
//       SchemeModel.add(uimodel);
//       setState(() {
//         schemeitems.add(DropdownMenuItem(
//           child: Text(property_value),
//           value: property_value,
//         ));
//         //salTypeList.add(property_value);
//       });
//     }
//
//     // loanpurpose
//     List loanPurpose = await db.RawQuery(
//         'select * from animalCatalog where catalog_code =\'35\'');
//     loanPurposeModel = [];
//     loanPurposeitems.clear();
//     for (int i = 0; i < loanPurpose.length; i++) {
//       String property_value = loanPurpose[i]["property_value"].toString();
//       String DISP_SEQ = loanPurpose[i]["DISP_SEQ"].toString();
//
//       var uimodel = new UImodel(property_value, DISP_SEQ);
//       loanPurposeModel.add(uimodel);
//       setState(() {
//         loanPurposeitems.add(DropdownMenuItem(
//           child: Text(property_value),
//           value: property_value,
//         ));
//         //salTypeList.add(property_value);
//       });
//     }
//
//     //security
//     List Security = await db.RawQuery(
//         'select distinct * from animalCatalog where catalog_code =\'36\'');
//     print('loantypes ' + loantypes.toString());
//     loanSecurityModel = [];
//     loanSecurityModel.clear();
//     for (int i = 0; i < Security.length; i++) {
//       String property_value = Security[i]["property_value"].toString();
//       String DISP_SEQ = Security[i]["DISP_SEQ"].toString();
//
//       var uimodel = new UImodel(property_value, DISP_SEQ);
//       loanSecurityModel.add(uimodel);
//       setState(() {
//         loanSecurityitem.add(DropdownMenuItem(
//           child: Text(property_value),
//           value: property_value,
//         ));
//         //salTypeList.add(property_value);
//       });
//     }
//
//     //countrylist
//     List countrylist = await db.RawQuery('select * from countryList ');
//     print(' ' + countrylist.toString());
//     cuntryUIModel = [];
//     cuntryitems.clear();
//     for (int i = 0; i < countrylist.length; i++) {
//       String cuntryCode = countrylist[i]["countryCode"].toString();
//       String cuntryName = countrylist[i]["countryName"].toString();
//
//       var uimodel = new UImodel(cuntryName, cuntryCode);
//       cuntryUIModel.add(uimodel);
//       setState(() {
//         cuntryitems.add(DropdownModel(
//           cuntryName,
//           cuntryCode,
//         ));
//         //prooflist.add(property_value);
//       });
//     }
//   }
//
//
//   farmersearch(String villageCode) async {
//     String qry_farmerlist =
//         'select fName,farmerId,certifiedFarmer,address from farmer_master where villageId = \'' +
//             villageCode +
//             '\'';
//     print('Approach Query:  ' + qry_farmerlist);
//     List farmerslist = await db.RawQuery(qry_farmerlist);
//     print('villageslist 2:  ' + farmerslist.toString());
//
//     farmeritems = [];
//     farmeritems.clear();
//     farmerlistUIModel = [];
//
//     if (farmerslist.length > 0) {
//       for (int i = 0; i < farmerslist.length; i++) {
//         String property_value = farmerslist[i]["fName"].toString();
//         String DISP_SEQ = farmerslist[i]["farmerId"].toString();
//         String address = farmerslist[i]["address"].toString();
//         var uimodel = new UImodel2(property_value, DISP_SEQ, address);
//         farmerlistUIModel.add(uimodel);
//         setState(() {
//           farmeritems.add(DropdownModel(
//             property_value,
//             DISP_SEQ,
//           ));
//           //prooflist.add(property_value);
//         });
//       }
//     }
//
//     Future.delayed(Duration(milliseconds: 500), () {
//       setState(() {
//         if (farmeritems.length > 0) {
//           slct_farmer = '';
//           farmerloaded = true;
//         }
//       });
//     });
//
//   }
//
//   farmload(String farmerid) async {
//     String qry_farmlist =
//         'select farmName,farmIDT,totLand from farm where farmerId = \'' +
//             farmerid +
//             '\'';
//     print('qry_farmlist : ' + qry_farmlist);
//     List farmlist = await db.RawQuery(qry_farmlist);
//     print('farmlist 2:  ' + farmlist.toString());
//
//     farmitems = [];
//     farmitems.clear();
//     farmlistUIModel = [];
//
//     if (farmlist.length > 0) {
//       for (int i = 0; i < farmlist.length; i++) {
//         String farmName = farmlist[i]["farmName"].toString();
//         String farmIDT = farmlist[i]["farmIDT"].toString();
//         String totLand = farmlist[i]["totLand"].toString();
//         var uimodel = new UImodel2(farmName, farmIDT, totLand);
//         farmlistUIModel.add(uimodel);
//         setState(() {
//           farmitems.add(DropdownModel(
//             farmName,
//             farmIDT,
//           ));
//         });
//       }
//     }
//
//     Future.delayed(Duration(milliseconds: 500), () {
//       setState(() {
//         if (farmitems.length > 0) {
//           slct_farm = '';
//           farmloaded = true;
//         }
//       });
//     });
//
//   }
//   Future<bool> _onBackPressed() async {
//     return (await Alert(
//       context: context,
//       type: AlertType.warning,
//       title: cancel,
//       desc: rusurecancel,
//       buttons: [
//         DialogButton(
//           child: Text(
//             yes,
//             style: TextStyle(color: Colors.white, fontSize: 20),
//           ),
//           onPressed: () {
//             Navigator.pop(context);
//             Navigator.pop(context);
//           },
//           width: 120,
//         ),
//         DialogButton(
//           child: Text(
//             no,
//             style: TextStyle(color: Colors.white, fontSize: 20),
//           ),
//           onPressed: () {
//             Navigator.pop(context);
//           },
//           width: 120,
//         )
//       ],
//     ).show()) ??
//         false;
//   }
//
//   void translate() async {
//     try {
//       String? Lang = '';
//       try {
//         SharedPreferences prefs = await SharedPreferences.getInstance();
//         Lang = prefs.getString("langCode");
//       } catch (e) {
//         Lang = 'en';
//       }
//       String qry =
//           'select * from labelNamechange where tenantID =  \'cediam\' and lang = \'' +
//               Lang! +
//               '\'';
//
//       print('Lanquery' + qry);
//       List transList = await db.RawQuery(qry);
//       print('translist:' + transList.toString());
//       for (int i = 0; i < transList.length; i++) {
//         String classname = transList[i]['className'];
//         String labelName = transList[i]['labelName'];
//         switch (classname) {
//           case "farmerCode":
//             setState(() {
//               FCode = labelName;
//             });
//             break;
//           case "dob":
//             setState(() {
//               Dob = labelName;
//             });
//             break;
//           case "gender":
//             setState(() {
//               Gender = labelName;
//             });
//             break;
//           case "idproof":
//             setState(() {
//               IDproof = labelName;
//             });
//             break;
//           case "proofNo":
//             setState(() {
//               ProofNo = labelName;
//             });
//             break;
//           case "farmerphoto":
//             setState(() {
//               FarmerPhoto = labelName;
//             });
//             break;
//
//           case "mobno":
//             setState(() {
//               mobileNo = labelName;
//             });
//             break;
//           case "nofamily":
//             setState(() {
//               noFamilyMem = labelName;
//             });
//             break;
//           case "chiefTownHint":
//             setState(() {
//               chiefTownHint = labelName;
//             });
//             break;
//           case "IDproofHint":
//             setState(() {
//               IDproofHint = labelName;
//             });
//             break;
//           case "farmerenrollment":
//             setState(() {
//               farmerenrollment = labelName;
//             });
//             break;
//           case "PersonalInfo":
//             setState(() {
//               PersonalInfo = labelName;
//             });
//             break;
//           case "save":
//             setState(() {
//               save = labelName;
//             });
//             break;
//           case "Cancel":
//             setState(() {
//               cancel = labelName;
//             });
//             break;
//           case "info":
//             setState(() {
//               info = labelName;
//             });
//             break;
//           case "infoFname":
//             setState(() {
//               infoFname = labelName;
//             });
//             break;
//           case "infodob":
//             setState(() {
//               infodob = labelName;
//             });
//             break;
//           case "infocircle":
//             setState(() {
//               infocircle = labelName;
//             });
//             break;
//           case "infochiefcommune":
//             setState(() {
//               infChiefcommune = labelName;
//             });
//             break;
//           case 'transactionsuccesfull':
//             setState(() {
//               transactionsuccesfull = labelName;
//             });
//             break;
//           case 'farmersuccess':
//             setState(() {
//               farmersuccess = labelName;
//             });
//             break;
//           case 'confirm':
//             setState(() {
//               confirm = labelName;
//             });
//             break;
//           case "infonof":
//             setState(() {
//               infonof = labelName;
//             });
//             break;
//           case "infogroupco":
//             setState(() {
//               infogroupco = labelName;
//             });
//             break;
//           case "rusurecancel":
//             setState(() {
//               rusurecancel = labelName;
//             });
//             break;
//           case "success":
//             setState(() {
//               success = labelName;
//             });
//             break;
//           case "ArewntPrcd":
//             setState(() {
//               proceed = labelName;
//             });
//             break;
//           case "yes":
//             setState(() {
//               yes = labelName;
//             });
//             break;
//           case "no":
//             setState(() {
//               no = labelName;
//             });
//             break;
//           case "ok":
//             setState(() {
//               ok = labelName;
//             });
//             break;
//           case "gallery":
//             setState(() {
//               galry = labelName;
//             });
//             break;
//           case "pickimage":
//             setState(() {
//               pickimg = labelName;
//             });
//             break;
//           case "choose":
//             setState(() {
//               chse = labelName;
//             });
//             break;
//           case "camera":
//             setState(() {
//               Camera = labelName;
//             });
//             break;
//           case "gpslocation":
//             setState(() {
//               gpslocation = labelName;
//             });
//             break;
//           case 'Allowtakepic':
//             setState(() {
//               Allowtakepic = labelName;
//             });
//             break;
//           case 'deny':
//             setState(() {
//               deny = labelName;
//             });
//             break;
//           case 'whiluseapp':
//             setState(() {
//               whiluseapp = labelName;
//             });
//             break;
//           case 'onlytym':
//             setState(() {
//               onlytym = labelName;
//             });
//             break;
//         }
//       }
//     } catch (e) {
//       print('translation err' + e.toString());
//       //toast(e.toString());
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: WillPopScope(
//         onWillPop: _onBackPressed,
//         child: Scaffold(
//           appBar: AppBar(
//             centerTitle: true,
//             leading: IconButton(
//                 icon: Icon(Icons.arrow_back, color: Colors.white),
//                 onPressed: () {
//                   // Navigator.of(context).pop();
//
//                   _onBackPressed();
//                 }),
//             title: Text(
//               "Sr.Agronomist agro card",
//               style: new TextStyle(
//                   color: Colors.white,
//                   fontSize: 18.0,
//                   fontWeight: FontWeight.w700),
//             ),
//             iconTheme: IconThemeData(color: Colors.white),
//             backgroundColor: Colors.green,
//             brightness: Brightness.light,
//           ),
//           body: Stack(
//             children: [
//               Container(
//                   child: Column(children: <Widget>[
//                     Expanded(
//                       child: ListView(
//                         padding: EdgeInsets.all(10.0),
//                         children: _getListings(
//                             context), // <<<<< Note this change for the return type
//                       ),
//                       flex: 8,
//                     ),
//                   ])),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//
//
//
//   List<Widget> _getListings(BuildContext context) {
//     List<Widget> listings = [];
//     //Filfare image;
//     int i = 0;
//     for (i = 0; i < 5; i++) {
//       if (i == 0) {
//           listings.add(txt_label("Village", Colors.black, 14.0, false));
//
//           listings.add(DropDownWithModel(
//               itemlist: villageitems,
//               selecteditem: slctvillages,
//               hint: "Select the Village",
//               onChanged: (value) {
//                 setState(() {
//                   slctvillages = value!;
//                   villageCode = slctvillages!.value;
//                   slct_village = slctvillages!.name;
//                   farmersearch(villageCode);
//                 });
//               },
//               onClear: () {
//                 setState(() {
//                   slct_farmer = '';
//                   ishavefarmercode = false;
//                 });
//               }));
//
//           listings.add(farmerloaded
//               ? txt_label("Farmer", Colors.black, 14.0, false)
//               : Container());
//
//           listings.add(farmerloaded
//               ? DropDownWithModel(
//               itemlist: farmeritems,
//               selecteditem: slctFarmers,
//               hint: "Select the Farmer",
//               onChanged: (value) {
//                 setState(() {
//                   slctFarmers = value!;
//                   //toast(slctFarmers!.value);
//                   farmerId = slctFarmers!.value;
//                   slct_farmer = slctFarmers!.name;
//                   farmload(farmerId);
//
//                 });
//               },
//               onClear: () {
//                 setState(() {
//                   slct_farmer = '';
//                   ishavefarmercode = false;
//                 });
//               })
//               : Container());
//
//           listings.add(farmloaded
//               ? txt_label("Farm", Colors.black, 14.0, false)
//               : Container());
//
//           listings.add(farmloaded
//               ? DropDownWithModel(
//               itemlist: farmitems,
//               selecteditem: slctFarm,
//               hint: "Select the Farm",
//               onChanged: (value) {
//                 setState(() {
//                   slctFarm = value!;
//                   farmId = slctFarm!.value;
//                   slct_farm = slctFarm!.name;
//                   for (int i = 0; i < farmlistUIModel.length; i++) {
//                     if (farmlistUIModel[i].value == farmId) {
//                       Landsize = farmlistUIModel[i].value2;
//                     }
//                   }
//
//                 });
//               },
//               onClear: () {
//                 setState(() {
//                   slct_farm = '';
//                 });
//               })
//               : Container());
//
//           listings.add(txt_label_mandatory("Land size in MB", Colors.black, 14.0, false));
//           listings.add(cardlable_dynamic(Landsize.toString()));
//
//         listings.add(txt_label("Block General Details", Colors.green, 18.0, true));
//         //Block visited ID
//         listings.add(txt_label_mandatory("Block visited ID", Colors.black, 14.0, false));
//         listings.add(DropDownWithModel(
//           itemlist: enrollemntitems,
//           selecteditem: slctEnrol,
//           hint:"Select the Block visited ID",
//           onChanged: (value) {
//             setState(() {
//               slctEnrol = value!;
//               val_enroll = slctEnrol!.value;
//               slct_enroll = slctEnrol!.name;
//             });
//           },
//         ));
//
//
//         listings.add(txt_label_mandatory("Agronomist Name", Colors.black, 14.0, false));
//         listings.add(DropDownWithModel(
//           itemlist: educationitems,
//           selecteditem: slctEdu,
//           hint:"Select the Agronomist Name",
//           onChanged: (value) {
//             setState(() {
//               slctEdu = value!;
//               val_edu = slctEdu!.value;
//               slct_edu = slctEdu!.name;
//             });
//           },
//         ));
//
//         // Date
//         listings.add(txt_label_mandatory("Date", Colors.black, 14.0, false));
//         listings.add(selectDate(
//             context1: context,
//             slctdate: agronomistDate,
//             onConfirm: (date) => setState(
//                   () {
//                     agronomistDate = DateFormat('dd/MM/yyyy').format(date!);
//                     agronomistFormatedDate =
//                     DateFormat('yyyyMMdd').format(date);
//               },
//             )));
//
//
//
//         listings.add(txt_label_mandatory("Latitude", Colors.black, 14.0, false));
//         listings.add(cardlable_dynamic(curLat.toString()));
//
//         listings.add(txt_label_mandatory("Longitude", Colors.black, 14.0, false));
//         listings.add(cardlable_dynamic(curLong.toString()));
//
//         listings.add(Container(
//           child: Row(
//             children: [
//               Expanded(
//                 flex: 1,
//                 child: Container(
//                   padding: EdgeInsets.all(3),
//                   child: RaisedButton(
//                     child: Text(
//                       "Cancel",
//                       style: new TextStyle(color: Colors.white, fontSize: 18),
//                     ),
//                     onPressed: () {
//                       btncancel();
//                     },
//                     color: Colors.redAccent,
//                   ),
//                 ),
//               ),
//               Expanded(
//                 flex: 1,
//                 child: Container(
//                   padding: EdgeInsets.all(3),
//                   child: RaisedButton(
//                     child: Text(
//                       "Submit",
//                       style: new TextStyle(color: Colors.white, fontSize: 18),
//                     ),
//                     onPressed: () {
//                       btnSubmit();
//                     },
//                     color: Colors.green,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ));
//
//       }
//     }
//     return listings;
//   }
//
//   void calAgeyr() {
//     DateTime currentDate = DateTime.now();
//     int month1 = currentDate.month;
//     setState(() {
//       yuthalt = "";
//       elegibleRegister = 0;
//       if (dateofbirth!.length > 0) {
//         print("estimatedMT_estimatedMT1" + dateofbirth!.toString());
//         print("currentDate" + currentDate.year.toString());
//         int agecalcontroller = 0;
//         agecalcontroller = int.parse(dateofyear);
//         int estcaldat = (currentDate.year - agecalcontroller);
//         print("currentDate" + agecalcontroller.toString());
//         elegibleRegister = estcaldat;
//         if (estcaldat >= 35) {
//           yuthalt = "Adult";
//         } else {
//           yuthalt = "Youth";
//         }
//       }
//     });
//   }
//
//
//
//   void ondelete(String photo) {
//     setState(() {
//       if (photo == "Farmer") {
//         if (farmerImageFile != null) {
//           setState(() {
//             farmerImageFile = null;
//           });
//         }
//       } else {
//         if (idProofImageFile != null) {
//           setState(() {
//             idProofImageFile = null;
//           });
//         }
//       }
//     });
//   }
//
//   void btncancel() {
//     _onBackPressed();
//   }
//
//   void btnSubmit() {
//
//     if(slct_enroll.length > 0 && slct_enroll != '') {
//       if(slct_edu.length > 0 && slct_edu != ''){
//         if (agronomistDate.length > 0 &&
//             agronomistDate != '') {
//
//              confirmationPopupp();
//
//         } else {
//           errordialog(context, info, "Date should not be empty");
//         }
//       } else {
//         errordialog(context, info, "Agronomist Name should not be empty");
//       }
//     } else {
//       errordialog(context, info, "Block visited ID  should not be empty");
//     }
//   }
//
//
//
//   void calculateAge(DateTime birthDate) {
//     DateTime currentDate = DateTime.now();
//     int age = currentDate.year - birthDate.year;
//     int month1 = currentDate.month;
//     int month2 = birthDate.month;
//     if (month2 > month1) {
//       age--;
//     } else if (month1 == month2) {
//       int day1 = currentDate.day;
//       int day2 = birthDate.day;
//       if (day2 > day1) {
//         age--;
//       }
//     }
//     ageController!.text = age.toString();
//   }
//
//   imageDialog(String photo) {
//     var alertStyle = AlertStyle(
//       animationType: AnimationType.grow,
//       overlayColor: Colors.black87,
//       isCloseButton: true,
//       isOverlayTapDismiss: true,
//       titleStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
//       descStyle: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
//       animationDuration: Duration(milliseconds: 400),
//     );
//
//     Alert(
//         context: context,
//         style: alertStyle,
//         title: pickimg,
//         desc: chse,
//         buttons: [
//           DialogButton(
//             child: Text(
//               galry,
//               style: TextStyle(color: Colors.white, fontSize: 18),
//             ),
//             //onPressed:btncancel ,
//             onPressed: () {
//               setState(() {
//                 getImageFromGallery(photo);
//                 Navigator.pop(context);
//               });
//             },
//             color: Colors.deepOrange,
//           ),
//           DialogButton(
//             child: Text(
//               Camera,
//               style: TextStyle(color: Colors.white, fontSize: 18),
//             ),
//             //onPressed:btnok,
//             onPressed: () {
//               getImageFromCamera(photo);
//               Navigator.pop(context);
//             },
//             color: Colors.green,
//           )
//         ]).show();
//   }
//
//   Future getImageFromCamera(String photo) async {
//     var image = await ImagePicker.platform
//         .pickImage(source: ImageSource.camera, imageQuality: 30);
//     setState(() {
//       if (photo == "Farmer") {
//         farmerImageFile = File(image!.path);
//       } else if(photo == "bankphoto") {
//         bankImageFile = File(image!.path);
//       } else {
//         idProofImageFile = File(image!.path);
//       }
//     });
//   }
//
//   Future getImageFromGallery(String photo) async {
//     var image = await ImagePicker.platform
//         .pickImage(source: ImageSource.gallery, imageQuality: 30);
//     setState(() {
//       if (photo == "Farmer") {
//         farmerImageFile = File(image!.path);
//       } else if(photo == "bankphoto") {
//         bankImageFile = File(image!.path);
//       } else {
//         idProofImageFile = File(image!.path);
//       }
//     });
//   }
//
//
//   confirmationPopup(dialogContext) {
//     var alertStyle = AlertStyle(
//       animationType: AnimationType.grow,
//       overlayColor: Colors.black87,
//       isCloseButton: true,
//       isOverlayTapDismiss: true,
//       titleStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
//       descStyle: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
//       animationDuration: Duration(milliseconds: 400),
//     );
//
//     Alert(
//         context: dialogContext,
//         style: alertStyle,
//         title: "Confirmation",
//         desc: "Do you want to reset the farmer details",
//         buttons: [
//           DialogButton(
//             child: Text(
//               "Cancel",
//               style: TextStyle(color: Colors.white, fontSize: 18),
//             ),
//             //onPressed:btncancel ,
//             onPressed: () {
//               setState(() {
//                 isregistration = false;
//                 Navigator.pop(context);
//               });
//             },
//             color: Colors.deepOrange,
//           ),
//           DialogButton(
//             child: Text(
//               "OK",
//               style: TextStyle(color: Colors.white, fontSize: 18),
//             ),
//             //onPressed:btnok,
//             onPressed: () {
//               setState(() {
//                 isregistration = true;
//                 Navigator.pop(context);
//               });
//             },
//             color: Colors.green,
//           )
//         ]).show();
//   }
//
//   saveSeniorAgronomist() async {
//     final now = new DateTime.now();
//     String txntime = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
//     String msgNo = DateFormat('yyyyMMddHHmmss').format(now);
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     String? agentid = prefs.getString("agentId");
//     String? agentToken = prefs.getString("agentToken");
//
//     Random rnd = new Random();
//     int revNo = 100000 + rnd.nextInt(999999 - 100000);
//
//     print('txnHeader ' + agentid! + "" + agentToken!);
//     String insqry =
//         'INSERT INTO "main"."txnHeader" ("isPrinted", "txnTime", "mode", "operType", "resentCount", "agentId", "agentToken", "msgNo", "servPointId", "txnRefId") VALUES ('
//             '0,\'' +
//             txntime +
//             '\', '
//                 '\'02\', '
//                 '\'01\', '
//                 '\'0\',\'' +
//             agentid +
//             '\', \'' +
//             agentToken +
//             '\',\'' +
//             msgNo +
//             '\', \'' +
//             servicePointId +
//             '\',\'' +
//             revNo.toString() +
//             '\')';
//     print('txnHeader ' + insqry);
//     int txnsucc = await db.RawInsert(insqry);
//     print(txnsucc);
//     Future<List<Map>> txnHeader = db.GetTableValues('txnHeader');
//
//     //CustTransaction
//     AppDatas datas = new AppDatas();
//     await db.saveCustTransaction(
//         txntime, datas.txn_seniorAgronomist, revNo.toString(), '', '', '');
//     print('Senior Agronomist inserting');
//
//
//     int agronomistsave = await db.SaveAgronomist(
//         val_enroll,//Enrollment Place
//         val_edu,//Enrollment Place
//         agronomistDate,//Enrollment Date
//         curLat,//Farmer Code
//         curLong,//Enrolling person
//         revNo.toString(),
//         "1",
//         txntime
//     );
//     print('agronomistsave : ' + agronomistsave.toString());
//     List<Map> agronomistvalsave = await db.GetTableValues('agronomist');
//     print("agronomist : " +agronomistvalsave.toString());
//
//
//     db.UpdateTableValue(
//         'agronomist', 'isSynched', '0', 'recNo', revNo.toString());
//
//
//
//     Alert(
//       context: context,
//       type: AlertType.info,
//       title: "Transaction Successful",
//       desc: "Sr. Agronomist agro cards Successful",
//       buttons: [
//         DialogButton(
//           child: Text(
//             ok,
//             style: TextStyle(color: Colors.white, fontSize: 20),
//           ),
//           onPressed: () {
//             Navigator.of(context).pushReplacement(MaterialPageRoute(
//                 builder: (BuildContext context) => DashBoard("", "")));
//           },
//           width: 120,
//         ),
//       ],
//     ).show();
//     // Navigator.pop(context);
//   }
//
//   confirmation() {
//     var alertStyle = AlertStyle(
//       animationType: AnimationType.grow,
//       overlayColor: Colors.black87,
//       isCloseButton: true,
//       isOverlayTapDismiss: true,
//       titleStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
//       descStyle: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
//       animationDuration: Duration(milliseconds: 400),
//     );
//
//     Alert(
//         context: context,
//         style: alertStyle,
//         title: confirm,
//         desc: proceed,
//         buttons: [
//           DialogButton(
//             child: Text(
//               no,
//               style: TextStyle(color: Colors.white, fontSize: 18),
//             ),
//             //onPressed:btncancel ,
//             onPressed: () {
//               setState(() {
//                 Navigator.pop(context);
//               });
//             },
//             color: Colors.deepOrange,
//           ),
//           DialogButton(
//             child: Text(
//               yes,
//               style: TextStyle(color: Colors.white, fontSize: 18),
//             ),
//             //onPressed:btnok,
//             onPressed: () {
//               saveSeniorAgronomist();
//               Navigator.pop(context);
//             },
//             color: Colors.green,
//           )
//         ]).show();
//   }
//
//   void confirmationPopupp() {
//     Alert(
//       context: context,
//       type: AlertType.warning,
//       title: confirm,
//       desc: proceed,
//       buttons: [
//         DialogButton(
//           child: Text(
//             yes,
//             style: TextStyle(color: Colors.white, fontSize: 20),
//           ),
//           onPressed: () {
//             saveSeniorAgronomist();
//             Navigator.pop(context);
//           },
//           width: 120,
//         ),
//         DialogButton(
//           child: Text(
//             no,
//             style: TextStyle(color: Colors.white, fontSize: 20),
//           ),
//           onPressed: () {
//             Navigator.pop(context);
//           },
//           width: 120,
//         )
//       ],
//     ).show();
//   }
//
// }
//
//
