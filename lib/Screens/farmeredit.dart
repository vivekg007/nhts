import 'dart:io';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Database/Databasehelper.dart';
import '../Database/Model/FarmerMaster.dart';
import '../Model/UIModel.dart';
import '../Model/dynamicfields.dart';
import '../Utils/MandatoryDatas.dart';
import '../commonlang/translateLang.dart';
import 'FarmEditScrreen.dart';
import 'farmedit.dart';

class FarmerEdit extends StatefulWidget {
  String farmerId;
  FarmerEdit(this.farmerId);
  @override
  State<StatefulWidget> createState() {
    return _FarmerEditScreen();
  }
}

class _FarmerEditScreen extends State<FarmerEdit> {
  List<UImodel> idProofUIModel = [];
  List<UImodel> GroupListUIModel = [];

  // List<DropdownMenuItem> villageList = [];
  List<DropdownMenuItem> groupList = [];
  List<DropdownMenuItem> idproofitems = [];
  List<FarmerMaster> farmermaster = [];
  List<Asset> images = [];
  List<Map> agents = [];
  String? seasoncode;
  String? servicePointId;
  String agentDistributionBal = '';
  String farmId = '';
  List farmerDetails = [];

  String slctProof = "";
  String val_Proof = "";
  // String val_Village = "";
  String slctGroup = "";
  String val_Group = "";
  String Date = '';
  File? _imageID;
  File? _imageFarmer;
  String IdProofphoto = "";
  String farmerPhoto = "";
  bool farmExist = false;
  String farmerIdEdit = '';
  var db = DatabaseHelper();

  String Lat = '';
  String Lng = '';

  String transferDate = '', labeltransferDate = 'Select Transfer Date';
  String pructransfr = 'Product Transfer';
  String info = 'Information';

  String submt = 'Submit';
  String AresurCancl = 'Are you sure want to cancel?';
  String AresurProcd = 'Are you sure want to proceed?';
  String save = 'Save';
  String farmname = 'Farm Name';
  String farmphoto = 'Farm Photo';

  String procdetils = 'Product Details';
  String Cancel = 'Cancel';
  String yes = 'Yes';
  String proofno = 'Proof No';
  String farmerphoto = 'Farmer Photo';
  String mobno = 'Mobile Number';
  String no = 'No';
  String farmercode = 'Farmer Code';
  String IDproofHint = 'Select the ID Proof';
  String idproof = 'ID Proof';
  String village = 'Village';
  String gpslocation = 'GPS Location not enabled';
  String variety = 'Variety';
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

  String dateSow = 'Date of sowing';
  String cropName = 'Crop Name';
  String farmerName = 'Farmer Name';
  String area = 'Area';
  String totLandhold = 'Total Land Holding (Hectare)';
  String farmeditsuc = 'Farm Edit Submitted Successfully';
  String farmreditsuc = 'Farmer Edit Submitted Successfully';
  String estmd = 'Estimated';
  String yield = 'Yield';
  String maunds = '(maunds)';
  String farmEdit = 'Farm Edit';
  String farmerEdit = 'Farmer Edit';
  String infoIdpho = 'ID proof photo should not be empty';
  String farmID = 'Farm ID';
  String update = 'Update';
  String balance = 'Balance';
  String idproofphoto = 'ID Proof Photo';

  TextEditingController FarmerNameController = new TextEditingController();
  TextEditingController FarmerCodeController = new TextEditingController();
  TextEditingController nameOrganization = new TextEditingController();
  TextEditingController nameOwner = new TextEditingController();
  TextEditingController addressOwner = new TextEditingController();
  TextEditingController gender = new TextEditingController();
  TextEditingController dob = new TextEditingController();
  TextEditingController agev = new TextEditingController();
  TextEditingController nationalId = new TextEditingController();
  TextEditingController address = new TextEditingController();
  TextEditingController country = new TextEditingController();
  TextEditingController district = new TextEditingController();
  TextEditingController division = new TextEditingController();
  TextEditingController parish = new TextEditingController();
  TextEditingController VillageController = new TextEditingController();
  TextEditingController MobileNumberController = new TextEditingController();
  TextEditingController proofnoController = new TextEditingController();
  TextEditingController FarmNameController = new TextEditingController();
  TextEditingController BalanceController = new TextEditingController();
  TextEditingController otherNameController = new TextEditingController();

  List<DropdownModel> genderitems = [];
  DropdownModel? slctGender;
  String slct_Gender = "";
  String val_Gender = "";

  String dateofbirth = "";
  String dateofbirthFormatedDate = "";

  List<DropdownModel> nationaliditems = [];
  DropdownModel? slctNationalID;
  String slct_NationalID = "";
  String val_NationalID = "";
  String idType = "";

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

  List<UImodel> countryUIModel = [];
  List<UImodel> stateUIModel = [];
  List<UImodel> districtUIModel = [];
  List<UImodel> cityListUIModel = [];
  List<UImodel> VillageListUIModel = [];

  final Map<String, String> memberOrg = {
    'option1': "NO",
    'option2': "YES",
  };

  String _selectedMemOrg = "", memOrgSelect = "";

  bool isMember = false;

  bool memberOrgLoaded = false;

  List<BankDetail> bankDetailList = [];
  List<BankDetail> bankList = [];

  String addressOrganization = "";
  bool addressOrg = false;
  List<String> data = [];
  List<String> data1 = [];

  //name of organization
  List<DropdownModel> nameOrganizationitems = [];
  DropdownModel? slctNameOrganization;
  String slct_NameOrganization = "";
  String val_NameOrganization = "";
  String orgaCode = "";

  List<DropdownModel> memOrganizationitems = [];
  DropdownModel? slctmemOrganization;
  String slct_memOrganization = "";
  String val_memOrganization = "";

  bool listadded = false;
  String stringList = "";
  String stringlistavl = "";

  String stringNameList = "";
  String stringNameListVal = "";

  String landType = "";

  String region = "";

  @override
  void initState() {
    super.initState();
    print(widget.farmerId);
    farmerIdEdit = widget.farmerId;
    print("farmerIdEdit $farmerIdEdit");
    initdata();
    getClientData();
    getLocation();
    ChangeStates();
    nationalId = TextEditingController();
  }

  getClientData() async {
    agents = await db.RawQuery('SELECT * FROM agentMaster');
    seasoncode = agents[0]['currentSeasonCode'];
    servicePointId = agents[0]['servicePointId'];
    //agentDistributionBal = agents[0]['agentDistributionBal'];
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

  Future<void> initdata() async {
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

    List nationalIDList = [
      {"property_value": "National ID Number (NIN)", "DISP_SEQ": "nin"},
      {"property_value": "Driver's License", "DISP_SEQ": "dln"},
      {"property_value": "Voter's Card", "DISP_SEQ": "vin"}
    ];

    List memList = [
      {"property_value": "Yes", "DISP_SEQ": "1"},
      {"property_value": "No", "DISP_SEQ": "0"},
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

    for (int i = 0; i < memList.length; i++) {
      String typurchseName = memList[i]["property_value"].toString();
      String typurchseCode = memList[i]["DISP_SEQ"].toString();
      var uimodel = new UImodel(typurchseName, typurchseCode);

      setState(() {
        memOrganizationitems.add(DropdownModel(
          typurchseName,
          typurchseCode,
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

    print(widget.farmerId);
    farmerIdEdit = widget.farmerId;
    print("farmerIdEdit $farmerIdEdit");
    //List farmerDetails =[];
    farmerDetails = await db.RawQuery(
        'select frmr.farmerCode,frmr.fName,frmr.lName,frmr.villageId,frmr.procurementBalance,vill.villName,frmr.mobileNo,fm.farmIDT,fm.farmName,frmr.dead,frmr.ctName,frmr.trader,frmr.Inspection,frmr.proName,frmr.fCertType,frmr.address,frmr.maritalStatus,frmr.districtCode,frmr.samithiCode,frmr.phoneNo,frmr.certCategory,frmr.farmerCertStatus_sym from farmer_master frmr,villageList vill,farm fm where vill.villCode = frmr.villageId and fm.farmerId = frmr.farmerId and frmr.farmerId =\'' +
            widget.farmerId +
            '\'');
    print("farmerDetails:" + farmerDetails.toString());
    String dCode = "";
    String villId = "";
    if (farmerDetails.isEmpty) {
      setState(() {
        farmExist = false;
      });
      //   print("QueryRow:" + farmExist.toString());
      farmerDetails = await db.RawQuery(
          'select frmr.farmerCode,frmr.fName,frmr.lName,frmr.villageId,frmr.procurementBalance,vill.villName,frmr.mobileNo,frmr.dead,frmr.ctName,frmr.trader,frmr.Inspection,frmr.proName,frmr.fCertType,frmr.address,frmr.maritalStatus,frmr.districtCode,frmr.samithiCode,frmr.phoneNo,frmr.certCategory,frmr.farmerCertStatus_sym from farmer_master frmr,villageList vill where vill.villCode = frmr.villageId and frmr.farmerId =\'' +
              widget.farmerId +
              '\'');
    } else {
      print("else farmExist");
      setState(() {
        farmExist = true;
      });
    }
    setState(() {
      String genderValue = farmerDetails[0]['Inspection'].toString();
      if (genderValue == "0") {
        gender.text = "Female";
        slct_Gender = "Female";
        val_Gender = "0";
      } else {
        gender.text = "Male";
        slct_Gender = "Male";
        val_Gender = "1";
      }
      landType = farmerDetails[0]['certCategory'];
      val_memOrganization = farmerDetails[0]['farmerCertStatus_sym'].toString();
      //_selectedMemOrg = "option2";
      print("landtypeval:" + landType);
      FarmerNameController.text = farmerDetails[0]['fName'];
      otherNameController.text = farmerDetails[0]['lName'];
      if (farmerDetails[0]['farmerCode'].toString().isEmpty) {
        FarmerCodeController.text = '';
      } else {
        FarmerCodeController.text = farmerDetails[0]['farmerCode'];
      }
      VillageController.text = farmerDetails[0]['villName'];
      MobileNumberController.text = farmerDetails[0]['mobileNo'];
      String mbNo = MobileNumberController.text.toString();
      if (mbNo.isNotEmpty) {
        String parsedMbNo = mbNo.substring(4);
        print("mobile number:" + mbNo.toString() + parsedMbNo);
        MobileNumberController.text = parsedMbNo;
      }

      if (farmerDetails[0]['farmName'].toString().isEmpty) {
        FarmNameController.text = '';
      } else {
        FarmNameController.text = farmerDetails[0]['farmName'] ?? "";
      }
      // BalanceController.text = farmerDetails[0]['procurementBalance'];
      if (farmerDetails[0]['farmIDT'].toString().isEmpty) {
        farmId = '';
      } else {
        farmId = farmerDetails[0]['farmIDT'] ?? "";
      }
      nationalId.text = farmerDetails[0]['dead'].toString();
      nameOrganization.text = farmerDetails[0]['ctName'].toString();
      agev.text = farmerDetails[0]['trader'].toString();
      nameOwner.text = farmerDetails[0]['fCertType'].toString();
      addressOwner.text = farmerDetails[0]['proName'].toString();
      address.text = farmerDetails[0]['address'].toString();
      dob.text = farmerDetails[0]['maritalStatus'].toString();
      country.text = "Uganda";
      dCode = farmerDetails[0]['districtCode'].toString();
      val_State = farmerDetails[0]['districtCode'].toString();
      villId = farmerDetails[0]['villageId'].toString();
      val_Village = farmerDetails[0]['villageId'].toString();
      val_NationalID = farmerDetails[0]['samithiCode'].toString();
      print("nationalID:" + val_NationalID);
      /*   if (val_NationalID == "vin") {
        idType = "Voter's Card";
      } else if (val_NationalID == "nin") {
        idType = "National ID Number (NIN)";
      } else {
        idType = "Driver's License";
      }*/
    });

    //name of organization/cooperative
    // List<String> orgName = farmerDetails[0]['ctName'].toList();
    // print("orgName:" + orgName.toString());

    orgaCode = farmerDetails[0]['phoneNo'].toString();
    print("orgaCode:" + orgaCode);

    List<String> orgCode = orgaCode.split(',').toList();
    print("orgCode:" + orgCode.toString());

    String orgName = farmerDetails[0]['ctName'].toString();
    data1.add(orgName);
    stringNameListVal = data1.join(',');

    data.add(orgaCode);
    stringlistavl = data.join(',');
    print("data data:" + data.toString() + stringlistavl);

    for (int i = 0; i < orgCode.length; i++) {
      String orgCodeV = orgCode[i].toString();
      String orgNameV = "";

      List cooperative = await db.RawQuery(
          'select coName from coOperative where coCode= \'' + orgCodeV + '\'');

      for (int j = 0; j < cooperative.length; j++) {
        orgNameV = cooperative[j]['coName'].toString();
      }
      print("orgNameV:" + orgNameV);

      bankDetailList.add(BankDetail(
          accHolderName: orgCodeV,
          bankName: orgNameV,
          accNumber: orgCodeV,
          ifscCode: '',
          bankCode: ''));
    }

    List parishList = await db.RawQuery(
        'select c.cityCode,c.cityName from cityList c, villageList v where v.villCode= \'' +
            villId +
            '\' and c.cityCode = v.gpCode ');
    List disCodeList = await db.RawQuery(
        'select stateName from stateList where stateCode = \'' + dCode + '\'');
    List regionList = await db.RawQuery(
        'select distinct countryName from countryList c,stateList s where c.countryCode = s.countryCode and s.stateCode =\'' +
            dCode +
            '\'');
    if (regionList.isNotEmpty) {
      region = regionList[0]['countryName'].toString();
    }
    String cityCode = parishList[0]['cityCode'].toString();
    val_Taluk = parishList[0]['cityCode'].toString();
    List divisionList = await db.RawQuery(
        'select d.districtName,d.districtCode from cityList c,districtList d where c.cityCode =  \'' +
            cityCode +
            '\' and c.districtCode=d.districtCode ');
    setState(() {
      district.text = disCodeList[0]['stateName'].toString();
      parish.text = parishList[0]['cityName'].toString();
      division.text = divisionList[0]['districtName'].toString();
      val_District = divisionList[0]['districtCode'].toString();
      slctState = disCodeList[0]['stateName'].toString();
      print("slctDistrict:" + slctState);
      slctDistrict = divisionList[0]['districtName'].toString();
      slctTaluk = parishList[0]['cityName'].toString();
    });

    print('farmerDetails ' + farmerDetails.toString());

    List idprooflist = await db.RawQuery(
        'select * from animalCatalog where catalog_code =\'44\'');
    print('idprooflist ' + idprooflist.toString());
    idProofUIModel = [];

    List otherlist = await db.RawQuery(
        'select distinct DISP_SEQ ,property_value from catalog where  DISP_SEQ=\'99\' and property_value =\'Others\' ');

    List newList = idprooflist + otherlist;
    print("newList_newList" + newList.toString());

    idproofitems.clear();
    for (int i = 0; i < newList.length; i++) {
      String property_value = newList[i]["property_value"].toString();
      String DISP_SEQ = newList[i]["DISP_SEQ"].toString();

      var uimodel = new UImodel(property_value, DISP_SEQ);
      idProofUIModel.add(uimodel);
      setState(() {
        idproofitems.add(DropdownMenuItem(
          child: Text(property_value),
          value: property_value,
        ));
        //prooflist.add(property_value);
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
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
          case "proofno":
            setState(() {
              proofno = labelName;
            });
            break;
          case "farmerphoto":
            setState(() {
              farmerphoto = labelName;
            });
            break;
          case "mobno":
            setState(() {
              mobno = labelName;
            });
            break;
          case "no":
            setState(() {
              no = labelName;
            });
            break;
          case "farmercode":
            setState(() {
              farmercode = labelName;
            });
            break;
          case "village":
            setState(() {
              village = labelName;
            });
            break;
          case "idproof":
            setState(() {
              idproof = labelName;
            });
            break;
          case "IDproofHint":
            setState(() {
              IDproofHint = labelName;
            });
            break;
          case "gpslocation":
            setState(() {
              gpslocation = labelName;
            });
            break;
          case "variety":
            setState(() {
              variety = labelName;
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
          case "confrm":
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
          case "farmname ":
            setState(() {
              farmname = labelName;
            });
            break;
          case "farmphoto":
            setState(() {
              farmphoto = labelName;
            });
            break;
          case "procdetils":
            setState(() {
              procdetils = labelName;
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
          case "ok":
            setState(() {
              ok = labelName;
            });
            break;
          case "dateSow":
            setState(() {
              dateSow = labelName;
            });
            break;
          case "cropName":
            setState(() {
              cropName = labelName;
            });
            break;
          case "farmerName":
            setState(() {
              farmerName = labelName;
            });
            break;
          case "area":
            setState(() {
              area = labelName;
            });
            break;
          case "totLandhold":
            setState(() {
              totLandhold = labelName;
            });
            break;
          case "farmeditsuc":
            setState(() {
              farmeditsuc = labelName;
            });
            break;
          case "farmreditsuc":
            setState(() {
              farmreditsuc = labelName;
            });
            break;
          case "estmd":
            setState(() {
              estmd = labelName;
            });
            break;
          case "yield":
            setState(() {
              yield = labelName;
            });
            break;
          case "maunds":
            setState(() {
              maunds = labelName;
            });
            break;
          case "farmEdit":
            setState(() {
              farmEdit = labelName;
            });
            break;
          case "farmerEdit":
            setState(() {
              farmerEdit = labelName;
            });
            break;
          case "infoIdpho":
            setState(() {
              infoIdpho = labelName;
            });
            break;
          case "farmId":
            setState(() {
              farmID = labelName;
            });
            break;
          case "update":
            setState(() {
              update = labelName;
            });
            break;
          case "balance":
            setState(() {
              balance = labelName;
            });
            break;
          case "idproofphoto":
            setState(() {
              idproofphoto = labelName;
            });
            break;
        }
      }
    } catch (e) {
      print('translation err' + e.toString());
      //toast(e.toString());
    }
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

  LoadRegion(String cCode) async {
    List regionList = await db.RawQuery(
        'select distinct countryName from countryList c,stateList s where c.countryCode = s.countryCode and s.stateCode =\'' +
            cCode +
            '\'');
    if (regionList.isNotEmpty) {
      region = regionList[0]['countryName'].toString();
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

  Future<bool> _onBackPressed() async {
    return (await Alert(
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
              "Farmer Edit",
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
            child: ListView(
              padding: EdgeInsets.all(10.0),
              children: FarmerEditUI(
                  context), // <<<<< Note this change for the return type
            ),
          ),
        ),
      ),
    );
  }

  Future<void> loadAssets() async {
    List<Asset> resultList = [];
    String error = 'No Error Dectected';

    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 2,
        enableCamera: true,
        selectedAssets: images,
        cupertinoOptions: CupertinoOptions(takePhotoIcon: "chat"),
        materialOptions: MaterialOptions(
          actionBarColor: "#abcdef",
          actionBarTitle: "Select Image for production",
          allViewTitle: "All Photos",
          useDetailsView: false,
          selectCircleStrokeColor: "#000000",
        ),
      );
    } on Exception catch (e) {
      error = e.toString();
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      images = resultList;
      print("kirubhasankar" + images[0].toString());
      // String  imageB64 = base64Encode(images[i].getByteData());
    });
  }

  List<Widget> FarmerEditUI(BuildContext context) {
    List<Widget> listings = [];

    listings.add(txt_label_icon(
        "First Name", Colors.black, 14.0, true, Icons.account_box));
    listings.add(
        txtfield_digitCharacter("Farmer Name", FarmerNameController, true));
    listings.add(txt_label_icon(
        "Other Name", Colors.black, 14.0, true, Icons.account_box));
    listings
        .add(txtfield_digitCharacter("Farmer Name", otherNameController, true));
    listings.add(txt_label_icon(
        farmercode, Colors.black, 14.0, true, Icons.account_box));
    listings.add(cardlable_dynamic(FarmerCodeController.text));
    /* listings.add(
        txt_label_icon(village, Colors.black, 14.0, true, Icons.location_on));
    listings.add(cardlable_dynamic(VillageController.text));*/
    // listings.add(txt_label_icon("Name of Organization / Cooperative",
    //     Colors.black, 14.0, true, Icons.location_on));
    // listings.add(cardlable_dynamic(nameOrganization.text));
    listings.add(txt_label_mandatory(
        TranslateFun.langList['meofaCoOrCoCls'], Colors.black, 14.0, false));

    // listings.add(radio_dynamic(
    //   map: memberOrg,
    //   selectedKey: _selectedMemOrg,
    //   onChange: (value) {
    //     setState(() {
    //       _selectedMemOrg = value!;
    //       if (value == 'option1') {
    //         setState(() {
    //           memOrgSelect = '0';
    //           memberOrgLoaded = false;
    //           val_NameOrganization = "";
    //           addressOrganization = "";
    //           slctNameOrganization = null;
    //           bankDetailList.clear();
    //         });
    //       } else if (value == 'option2') {
    //         setState(() {
    //           memOrgSelect = '1';
    //           memberOrgLoaded = true;
    //         });
    //       }
    //
    //       print("genderSelect_genderSelect " + memOrgSelect);
    //     });
    //   }));

    listings.add(DropDownWithModel(
      itemlist: memOrganizationitems,
      selecteditem: slctmemOrganization,
      hint: val_memOrganization == "1" ? "Yes" : "No",
      onChanged: (value) {
        setState(() {
          slctmemOrganization = value!;
          val_memOrganization = slctmemOrganization!.value;
          slct_memOrganization = slctmemOrganization!.name;
          bankDetailList.clear();

          if (val_memOrganization == "0") {
            setState(() {
              stringlistavl = "";
              stringNameListVal = "";
            });
          }
        });
      },
    ));

    if (val_memOrganization == '1') {
      listings.add(txt_label_mandatory(
          TranslateFun.langList['naofOrCoCls'], Colors.black, 14.0, false));
      listings.add(DropDownWithModel(
        itemlist: nameOrganizationitems,
        selecteditem: slctNameOrganization,
        hint: TranslateFun.langList['seNaofOrCoCls'],
        onChanged: (value) {
          setState(() {
            slctNameOrganization = value!;
            val_NameOrganization = slctNameOrganization!.value;
            slct_NameOrganization = slctNameOrganization!.name;
          });
        },
      ));

      // if (addressOrg) {
      //   listings.add(txt_label_mandatory(
      //       TranslateFun.langList['adofOrCoCls'], Colors.black, 14.0, false));
      //
      //   listings.add(cardlable_dynamic(addressOrganization));
      // }

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
                listadded = true;
                if (listadded) {
                  data.add(val_NameOrganization);
                  stringlistavl = data.join(",");
                  print("data data data:" + data.toString());

                  data1.add(slct_NameOrganization);
                  stringNameListVal = data1.join(',');
                  print("dataname dataname dataname:" +
                      stringNameListVal.toString());

                  print("data data dataa:" + stringlistavl);
                }

                var bankDetaillist = BankDetail(
                    accHolderName: val_NameOrganization,
                    bankName: slct_NameOrganization,
                    accNumber: val_NameOrganization,
                    ifscCode: '',
                    bankCode: '');
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
              /*  } else {
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

    if (landType == "1") {
      listings.add(txt_label_icon("Name of Owner of the land", Colors.black,
          14.0, true, Icons.location_on));
      listings.add(txtfield_digitCharacter1(
          "Name of Owner of the land", nameOwner, true));

      listings.add(txt_label_icon("Address of Owner of the land", Colors.black,
          14.0, true, Icons.location_on));
      listings.add(txtfield_digitCharacter1(
          "Address of Owner of the land", addressOwner, true));
    }

    listings.add(
        txt_label_icon("Gender", Colors.black, 14.0, true, Icons.location_on));
    listings.add(DropDownWithModel(
      itemlist: genderitems,
      selecteditem: slctGender,
      hint: slct_Gender.isNotEmpty
          ? slct_Gender
          : TranslateFun.langList['seGeCls'],
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
    listings.add(txt_label_icon(
        "Farmer's Date of Birth", Colors.black, 14.0, true, Icons.location_on));
    listings.add(selectDate(
      context1: context,
      slctdate: dateofbirth.isEmpty ? dob.text.toString() : dateofbirth,
      onConfirm: (date) => setState(() {
        dateofbirth = DateFormat('dd-MM-yyyy').format(date!);
        dateofbirthFormatedDate = DateFormat('yyyyMMdd').format(date);
        calculateAge(date);
      }),
    ));
    // listings.add(cardlable_dynamic(dateofbirth));
    listings.add(
        txt_label_icon("Age", Colors.black, 14.0, true, Icons.location_on));
    listings.add(cardlable_dynamic(agev.text));
    // listings.add(txt_label_icon("National ID Number (NIN)", Colors.black, 14.0,
    //     true, Icons.location_on));
    // listings.add(cardlable_dynamic(nationalId.text));

    /*listings.add(
        txt_label_mandatory("Identification Type", Colors.black, 14.0, false));
    listings.add(DropDownWithModel(
      itemlist: nationaliditems,
      selecteditem: slctNationalID,
      hint: idType.isEmpty ? "Select Identification Type" : idType,
      onChanged: (value) {
        setState(() {
          slctNationalID = value!;
          val_NationalID = slctNationalID!.value;
          slct_NationalID = slctNationalID!.name;
          nationalId.clear();
        });
      },
    ));*/
    listings.add(txt_label_mandatory(
        "National ID number (NIN)", Colors.black, 14.0, false));
    listings.add(txtfield_digitCharacter(
        "National ID number (NIN)", nationalId, true, 14));
    /*if (val_NationalID == "nin") {
      listings.add(txt_label_mandatory(
          "National ID number (NIN)", Colors.black, 14.0, false));
      listings.add(txtfield_digitCharacter(
          "National ID number (NIN)", nationalId, true, 14));
    }
    else if (val_NationalID == "dln") {
      listings.add(txt_label_mandatory(
          "Driver's license number", Colors.black, 14.0, false));
      listings.add(txtfield_digitCharacter(
          "Driver's license number", nationalId, true, 15));
    }
    else if (val_NationalID == "vin") {
      listings.add(txt_label_mandatory(
          "Voter's card number", Colors.black, 14.0, false));
      listings.add(
          txtfield_digitCharacter("Voter's card number", nationalId, true, 8));
    }*/

    /*listings.add(
      Container(
        child: Row(
          children: [
            Expanded(
                child: txt_label_icon(
                    "Country", Colors.black, 14.0, true, Icons.location_on)),
            Expanded(
                child: txt_label_icon(
                    "District", Colors.black, 14.0, true, Icons.location_on)),
          ],
        ),
      ),
    );
    listings.add(
      Container(
        child: Row(
          children: [
            Expanded(child: cardlable_dynamic(country.text)),
            Expanded(child: cardlable_dynamic(district.text)),
          ],
        ),
      ),
    );
    listings.add(
      Container(
        child: Row(
          children: [
            Expanded(
                child: txt_label_icon(
                    "Division", Colors.black, 14.0, true, Icons.location_on)),
            Expanded(
                child: txt_label_icon("Parish/Ward", Colors.black, 14.0, true,
                    Icons.location_on)),
          ],
        ),
      ),
    );
    listings.add(
      Container(
        child: Row(
          children: [
            Expanded(child: cardlable_dynamic(division.text)),
            Expanded(child: cardlable_dynamic(parish.text)),
          ],
        ),
      ),
    );

    listings.add(txt_label_icon(
        "Village/Cell", Colors.black, 14.0, true, Icons.location_on));
    listings.add(cardlable_dynamic(VillageController.text));*/

    // listings.add(
    //     txt_label_icon("Country", Colors.black, 14.0, true, Icons.location_on));
    // listings.add(cardlable_dynamic(country.text));

    listings.add(txt_label_mandatory(
        TranslateFun.langList['disCls'], Colors.black, 14.0, false));
    listings.add(singlesearchDropdown(
        itemlist: stateitems,
        selecteditem: slctState,
        hint: district.text.isEmpty
            ? TranslateFun.langList['seDiCls']
            : district.text,
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
            division.clear();
            parish.clear();
            VillageController.clear();
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
        }));

    listings.add(txt_label_mandatory("Region", Colors.black, 14.0, false));
    listings.add(cardlable_dynamic(region));

    listings.add(
        txt_label_mandatory("Subcounty/Division", Colors.black, 14.0, false));
    listings.add(singlesearchDropdown(
        itemlist: districtitems,
        selecteditem: slctDistrict,
        hint: division.text.isEmpty
            ? TranslateFun.langList['seSuCoCls']
            : division.text,
        onChanged: (value) {
          setState(() {
            slctDistrict = value!;
            cityLoaded = false;
            slctTaluk = "";
            cityitems.clear();
            villageLoaded = false;
            villageitems.clear();
            slctVillage = "";
            parish.clear();
            VillageController.clear();
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
        }));

    listings.add(txt_label_mandatory(
        TranslateFun.langList['parCls'], Colors.black, 14.0, false));
    listings.add(singlesearchDropdown(
        itemlist: cityitems,
        selecteditem: slctTaluk,
        hint: parish.text.isEmpty
            ? TranslateFun.langList['sePaCls']
            : parish.text,
        onChanged: (value) {
          setState(() {
            slctTaluk = value!;
            villageLoaded = true;
            villageitems.clear();
            slctVillage = "";
            VillageController.clear();
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
        }));

    listings.add(txt_label_mandatory(
        TranslateFun.langList['vilCls'], Colors.black, 14.0, false));
    listings.add(singlesearchDropdown(
        itemlist: villageitems,
        selecteditem: slctVillage,
        hint: VillageController.text.isEmpty
            ? TranslateFun.langList['seViCls']
            : VillageController.text,
        onChanged: (value) {
          setState(() {
            slctVillage = value!;
            for (int i = 0; i < VillageListUIModel.length; i++) {
              if (value == VillageListUIModel[i].name) {
                val_Village = VillageListUIModel[i].value;
              }
            }
          });
        },
        onClear: () {
          slctVillage = "";
        }));

    /*listings.add(
        txt_label_icon("Address", Colors.black, 14.0, true, Icons.location_on));
    listings.add(txtfield_digitCharacter1("Address", address, true));*/
    listings.add(txt_label_icon(
        "Phone Number", Colors.black, 14.0, false, Icons.location_on));
    // listings
    //     .add(txtfield_digits("Phone Number", MobileNumberController, true, 10));
    listings.add(Container(
      child: Row(
        children: [
          Expanded(
            child: cardlable_dynamic("+256"),
          ),
          Expanded(
            flex: 4,
            child: txtfield_digitswithoutdecimal(
                "Phone Number", MobileNumberController!, true, 9),
          ),
        ],
      ),
    ));

    if (farmExist) {
      listings.add(Datatablefarm());
    }

    // listings.add(
    //     txt_label_icon(balance, Colors.black, 14.0, true, Icons.ac_unit));
    // listings.add(cardlable_dynamic(BalanceController.text));

    listings.add(
      Container(
        padding: EdgeInsets.only(top: 5),
        child: Divider(
          color: Colors.grey,
          height: 1,
        ),
      ),
    );

    listings.add(Container(
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Container(
              padding: EdgeInsets.all(3),
              child: RaisedButton(
                child: Text(
                  save,
                  style: new TextStyle(color: Colors.white, fontSize: 18),
                ),
                onPressed: () {
                  btnSubmit();
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
                  Cancel,
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

  Widget bankListTable() {
    List<DataColumn> columns = <DataColumn>[];
    List<DataRow> rows = <DataRow>[];
    columns.add(DataColumn(label: Text('Name of Organization/Cooperative')));
    columns.add(DataColumn(label: Text('Delete')));

    for (int i = 0; i < bankDetailList.length; i++) {
      print("bank name and bank code:" +
          bankDetailList[i].bankName +
          " " +
          bankDetailList[i].accHolderName +
          " " +
          data.length.toString());
      List<DataCell> singlecell = <DataCell>[];
      if (bankDetailList[i].bankName.isNotEmpty) {
        singlecell.add(DataCell(Text(bankDetailList[i].bankName)));

        singlecell.add(DataCell(InkWell(
          onTap: () {
            setState(() {
              bankDetailList.removeAt(i);

              String bankCode = stringlistavl;
              print("bankcode:" + stringlistavl);
              List<String> bCode = bankCode.split(',');
              print("bCode" + bCode.length.toString());
              setState(() {
                //bCode.removeWhere((element) => element == bankDetailList[i].accHolderName);
                bCode.removeAt(i);
              });

              print("data length:" + bCode.toString());

              data.forEach((element) {
                print("element:" + element);
              });

              stringlistavl = bCode.join(',');
              data.clear();
              data = stringlistavl.split(',');
              print("data updated:" + data.toString());
              print("stringvalue:" + stringlistavl.toString());

              //name

              String bankName = stringNameListVal;
              print("bankName:" + bankName);
              List<String> bName = bankName.split(',');
              print("bName" + bName.length.toString());
              // bName.removeWhere((element) => element == bankDetailList[i].bankName);
              bName.removeAt(i);
              print("data length:" + bName.toString());

              stringNameListVal = bName.join(',');
              data1.clear();
              data1 = stringNameListVal.split(',');
              print("data name updated:" + data1.toString());
              print("stringvalueName:" + stringNameListVal.toString());
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
    }
    Widget objWidget = datatable_dynamic(columns: columns, rows: rows);
    return objWidget;
  }

  void btnSubmit() {
    print("national id called");
    if (FarmerNameController.text.isEmpty) {
      errordialog(context, TranslateFun.langList['infoCls'],
          "First name should not be empty");
    } else if (otherNameController.text.isEmpty) {
      errordialog(context, TranslateFun.langList['infoCls'],
          "Other name should not be empty");
    } else if (val_memOrganization == "1" && bankDetailList.length == 0) {
      errordialog(context, TranslateFun.langList['infoCls'],
          TranslateFun.langList['adatonmeCls']);
    } else if (landType == "1" && nameOwner.text.isEmpty) {
      errordialog(context, TranslateFun.langList['infoCls'],
          "Name of owner of the land should not be empty");
    } else if (landType == "1" && addressOwner.text.isEmpty) {
      errordialog(context, TranslateFun.langList['infoCls'],
          "Address of owner of the land should not be empty");
    } else if (dob.text.isEmpty &&
        dateofbirthFormatedDate.isEmpty &&
        dateofbirthFormatedDate.length == 0) {
      errordialog(context, TranslateFun.langList['infoCls'],
          "Farmer's " + TranslateFun.langList['daofbishnobeemCls']);
    } else if (agev.text.isEmpty && agev.text.length == 0) {
      errordialog(context, TranslateFun.langList['infoCls'],
          TranslateFun.langList['agshnobeemCls']);
    } else if (agev.value.text == "0") {
      errordialog(context, TranslateFun.langList['infoCls'],
          "Selected age should not be zero");
    } else if (int.parse(agev.value.text) < 16) {
      errordialog(context, TranslateFun.langList['infoCls'],
          "Selected age should be greater than or equal to 16");
    } else if (nationalId.text.isEmpty) {
      errordialog(context, TranslateFun.langList['infoCls'],
          "National ID Number (NIN) should not be empty");
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
    } /*else if (address.text.isEmpty) {
      errordialog(context, "information", "Address should not be empty");
    }*/
    else if (MobileNumberController.text.isNotEmpty &&
        MobileNumberController.text.length < 9) {
      errordialog(context, "information",
          "Mobile Number should not be less than 9 digits");
    } else {
      confirmation();
    }
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
              saveFarmerEditData();

              Navigator.pop(context);
            },
            color: Colors.green,
          )
        ]).show();
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
      agev.text = age.toString();
    });
    return age;
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
      type: AlertType.info,
      style: alertStyle,
      title: Cnfm,
      desc: AresurProcd,
      buttons: [
        DialogButton(
          child: Text(
            yes,
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () {
            Navigator.pop(context);
            saveFarmerEditData();
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

  Widget Datatablefarm() {
    List<DataColumn> columns = [];
    List<DataRow> rows = [];
    columns.add(DataColumn(
        label: Text(
      "View",
      style: TextStyle(color: Colors.green),
    )));
    columns.add(DataColumn(
        label: Text(
      "Edit",
      style: TextStyle(color: Colors.green),
    )));
    columns.add(DataColumn(
        label: Text(
      farmname,
      style: TextStyle(color: Colors.green),
    )));

    columns.add(DataColumn(
        label: Text(
      farmID,
      style: TextStyle(color: Colors.green),
    )));

    for (int i = 0; i < farmerDetails.length; i++) {
      List<DataCell> singlecell = [];
      //1
      print(farmerDetails[i]['farmName']);
      singlecell.add(DataCell(InkWell(
        onTap: () {
          setState(() {
            //farmerDetails.removeAt(i);

            Navigator.of(context).push(MaterialPageRoute(
                builder: (BuildContext context) => FarmEditScreen(
                    farmerDetails[0]['fName'] + " " + farmerDetails[0]['lName'],
                    farmerDetails[i]["farmIDT"],
                    farmerDetails[i]["farmName"],
                    farmerIdEdit)));
          });
        },
        child: Icon(
          Icons.remove_red_eye,
          color: Colors.red,
        ),
      )));
      singlecell.add(DataCell(InkWell(
        onTap: () {
          setState(() {
            //farmerDetails.removeAt(i);

            Navigator.of(context).push(MaterialPageRoute(
                builder: (BuildContext context) => FarmEdit(
                    farmerDetails[0]['fName'] + " " + farmerDetails[0]['lName'],
                    farmerDetails[i]["farmIDT"],
                    farmerDetails[i]["farmName"],
                    farmerIdEdit,
                    val_Village)));
          });
        },
        child: Icon(
          Icons.edit,
          color: Colors.red,
        ),
      )));
      singlecell.add(DataCell(Text(
        farmerDetails[i]["farmName"],
        style: TextStyle(color: Colors.black87),
      )));
      //2

      singlecell.add(DataCell(Text(
        farmerDetails[i]["farmIDT"],
        style: TextStyle(color: Colors.black87),
      )));

      rows.add(DataRow(
        cells: singlecell,
      ));
    }
    Widget objWidget = datatable_dynamic(columns: columns, rows: rows);
    return objWidget;
  }

  Future getImage() async {
    var image = await ImagePicker.platform
        .pickImage(source: ImageSource.camera, imageQuality: 50);
    setState(() {
      _imageID = File(image!.path);
    });
  }

  Future getImageFarmer() async {
    var image = await ImagePicker.platform
        .pickImage(source: ImageSource.camera, imageQuality: 50);
    setState(() {
      _imageFarmer = File(image!.path);
    });
  }

  void farmerEditFunction() {
    if (slctProof != "" && slctProof.length > 0) {
      if (IdProofphoto != "" && IdProofphoto.length > 0) {
        saveFarmerEditData();
      } else {
        errordialog(context, info, infoIdpho);
      }
    } else {
      saveFarmerEditData();
    }
  }

  saveFarmerEditData() async {
    Random rnd = new Random();
    int recNo = 100000 + rnd.nextInt(999999 - 100000);
    String revNo = recNo.toString();

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
            servicePointId! +
            '\',\' ' +
            revNo +
            '\')';
    print('txnHeader ' + insqry);
    int succ = await db.RawInsert(insqry);
    print(succ);

    AppDatas datas = new AppDatas();
    int custTransaction = await db.saveCustTransaction(
        txntime, datas.farmer_edit, revNo, '', '', '');
    print('custTransaction : ' + custTransaction.toString());

    String date = Date;
    String season = seasoncode!;
    String village = val_Village;
    String farmerMobile = MobileNumberController.text;
    String farmerId = farmerIdEdit;

    String longitude = Lng;
    String latitude = Lat;
    String isSynched = '1';

    String farmphoto = "";
    String farmProduction = "";
    String fingerPrint = "";
    String idProof = val_Proof;
    String idProofOthr = "";
    String idstatus = "";
    String frPhoto = "";
    String farmTotalProd = "";
    String pltStatus = "";
    String geoStatus = "";
    String trader = "";
    String idProofVal = proofnoController.text;
    // int SaveSensitizing = await db.SaveEditFarmer(
    //     isSynched,
    //     revNo,
    //     farmerId,
    //     Lat,
    //     Lng,
    //     txntime,
    //     farmerPhotoPath,
    //     farmerMobile,
    //     Lat,
    //     Lng,
    //     txntime,
    //     farmphoto,
    //     farmId,
    //     season,
    //     farmProduction,
    //     fingerPrint,
    //     idProof,
    //     idProofOthr,
    //     idProofVal,
    //     Lat,
    //     Lng,
    //     txntime,
    //     idPhotoPath,
    //     idstatus,
    //     frPhoto,
    //     farmTotalProd,
    //     pltStatus,
    //     geoStatus,
    //     trader);

    String mobNo = MobileNumberController.text;
    if (mobNo.isNotEmpty) {
      mobNo = "+256" + MobileNumberController.text;
    } else {
      mobNo = "";
    }

    int SaveSensitizingV = await db.editFarmerDetail(
        isSynched: isSynched,
        recNo: revNo,
        farmerId: farmerId,
        latitude: Lat,
        longitude: Lng,
        farmerTimeStamp: txntime,
        gender: val_Gender,
        dob: dateofbirthFormatedDate.isEmpty ? dob.text : dateofbirth,
        age: agev.text,
        address: address.text,
        phoneNumber: mobNo,
        nameOwner: nameOwner.text,
        otherName: otherNameController.text,
        firstName: FarmerNameController.text,
        addressOwner: addressOwner.text,
        idType: "nin",
        nationalId: nationalId.text,
        district: val_State,
        division: val_District,
        parish: val_Taluk,
        village: val_Village,
        country: '002',
        memOrgCode: stringlistavl,
        memOrgName: stringNameListVal,
        memOrg: val_memOrganization);

    if (bankDetailList.length > 0) {
      for (int i = 0; i < bankDetailList.length; i++) {
        String bankACNumber = bankDetailList[i].bankName;
        String bankName = bankDetailList[i].accNumber;
        String bankBranch = "";
        String IFSCcode = "";
        String SWIFTcode = "";
        String accountType = "";
        String otherAccountType = "";

        if (bankACNumber.isNotEmpty) {
          int saveBankDetails = await db.saveBankDetails(
              revNo,
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
    }

    int issync = await db.UpdateTableValue(
        'edit_farmer', 'isSynched', '0', 'recId', revNo);
    print(issync);
    //toast(farmreditsuc);

    Alert(
      context: context,
      type: AlertType.info,
      title: TranslateFun.langList['txnSuccCls'],
      desc: "Farmer Edit Successful",
      buttons: [
        DialogButton(
          child: Text(
            TranslateFun.langList['okCls'],
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () {
            Navigator.pop(context);
            Navigator.pop(context);
            Navigator.pop(context);
          },
          width: 120,
        ),
      ],
    ).show();
  }

  Widget buildGridView() {
    return GridView.count(
      crossAxisCount: 3,
      children: List.generate(images.length, (index) {
        Asset asset = images[index];
        return AssetThumb(
          asset: asset,
          width: 300,
          height: 300,
        );
      }),
    );
  }

  void ondelete() {
    if (_imageID != null) {
      setState(() {
        _imageID = null;
      });
    }
  }

  void ondeleteFarmer() {
    if (_imageFarmer != null) {
      setState(() {
        _imageFarmer = null;
      });
    }
  }

  Future<File> getImageFileFromAssets(Asset asset) async {
    final byteData = await asset.getByteData();

    final tempFile =
        File("${(await getTemporaryDirectory()).path}/${asset.name}");
    final file = await tempFile.writeAsBytes(
      byteData.buffer
          .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes),
    );

    return file;
  }
}

class BankDetail {
  String accHolderName, bankName, accNumber, ifscCode, bankCode;

  BankDetail(
      {required this.accHolderName,
      required this.bankName,
      required this.accNumber,
      required this.ifscCode,
      required this.bankCode});
}
