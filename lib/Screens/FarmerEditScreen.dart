import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../main.dart';
import '../Database/Databasehelper.dart';
import '../Database/Model/FarmerMaster.dart';
import '../Model/UIModel.dart';
import '../Model/dynamicfields.dart';
import '../Utils/MandatoryDatas.dart';
import 'FarmEditScrreen.dart';

class FarmerEditScreen extends StatefulWidget {
  String farmerId;
  FarmerEditScreen(this.farmerId);
  @override
  State<StatefulWidget> createState() {
    return _FarmerEditScreen();
  }
}

class _FarmerEditScreen extends State<FarmerEditScreen> {
  List<UImodel> idProofUIModel = [];
  List<UImodel> GroupListUIModel = [];

  List<DropdownMenuItem> villageList = [];
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
  List<String> farmLatList = [];
  List<String> farmLngList = [];
  List<String> farmnameList = [];
  List<String> farmernameList = [];

  String slctProof = "";
  String val_Proof = "";
  String val_Village = "";
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
  String landType = "";

  TextEditingController FarmerNameController = new TextEditingController();
  TextEditingController FarmerCodeController = new TextEditingController();
  TextEditingController nameOrganization = new TextEditingController();
  TextEditingController nameOwner = new TextEditingController();
  TextEditingController addressOwner = new TextEditingController();
  TextEditingController gender = new TextEditingController();
  TextEditingController dob = new TextEditingController();
  TextEditingController age = new TextEditingController();
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
  bool _isMapLoading = true;
  final Completer<GoogleMapController> _mapController = Completer();

  String val_memOrg = "";

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
    print(widget.farmerId);
    farmerIdEdit = widget.farmerId;
    print("farmerIdEdit $farmerIdEdit");
    //List farmerDetails =[];
    farmerDetails = await db.RawQuery(
        'select frmr.farmerCode,frmr.fName,frmr.lName,frmr.villageId,frmr.procurementBalance,vill.villName,frmr.mobileNo,fm.farmIDT,fm.farmName,fm.latitude,fm.longitude,frmr.dead,frmr.ctName,frmr.trader,frmr.Inspection,frmr.proName,frmr.fCertType,frmr.address,frmr.maritalStatus,frmr.districtCode,frmr.certCategory,frmr.farmerCertStatus_sym from farmer_master frmr,villageList vill,farm fm where vill.villCode = frmr.villageId and fm.farmerId = frmr.farmerId and frmr.farmerId =\'' +
            widget.farmerId +
            '\'');
    print("farmerDetails:" + farmerDetails.toString());

    String farmIDT = '';
    String farmName = '';
    String farmLat = '';
    String farmLng = '';
    String farmerName = '';

    for (int i = 0; i < farmerDetails.length; i++) {
      farmIDT = farmerDetails[i]['farmIDT'];
      farmName = farmerDetails[i]['farmName'];
      farmLat = farmerDetails[i]['latitude'];
      farmLng = farmerDetails[i]['longitude'];
      farmerName = farmerDetails[0]['fName'];
      print('details--' + farmIDT + farmName + farmLat + farmLng);
      farmLatList.add(farmLat);
      farmLngList.add(farmLng);
      farmnameList.add(farmName);
      farmernameList.add(farmerName);
    }

    String dCode = "";
    String villId = "";
    if (farmerDetails.isEmpty) {
      setState(() {
        farmExist = false;
      });
      //   print("QueryRow:" + farmExist.toString());
      farmerDetails = await db.RawQuery(
          'select frmr.farmerCode,frmr.fName,frmr.lName,frmr.villageId,frmr.procurementBalance,vill.villName,frmr.mobileNo,frmr.dead,frmr.ctName,frmr.trader,frmr.Inspection,frmr.proName,frmr.fCertType,frmr.address,frmr.maritalStatus,frmr.districtCode,frmr.certCategory,frmr.farmerCertStatus_sym from farmer_master frmr,villageList vill where vill.villCode = frmr.villageId and frmr.farmerId =\'' +
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
      } else {
        gender.text = "Male";
      }
      landType = farmerDetails[0]['certCategory'];

      FarmerNameController.text =
          farmerDetails[0]['fName'] + " " + farmerDetails[0]['lName'];
      if (farmerDetails[0]['farmerCode'].toString().isEmpty) {
        FarmerCodeController.text = '';
      } else {
        FarmerCodeController.text = farmerDetails[0]['farmerCode'];
      }
      VillageController.text = farmerDetails[0]['villName'];
      MobileNumberController.text = farmerDetails[0]['mobileNo'];
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
      age.text = farmerDetails[0]['trader'].toString();
      nameOwner.text = farmerDetails[0]['fCertType'].toString();
      addressOwner.text = farmerDetails[0]['proName'].toString();
      address.text = farmerDetails[0]['address'].toString();
      dob.text = farmerDetails[0]['maritalStatus'].toString();
      country.text = "Uganda";
      val_memOrg = farmerDetails[0]['farmerCertStatus_sym'].toString();
      dCode = farmerDetails[0]['districtCode'].toString();
      villId = farmerDetails[0]['villageId'].toString();
    });
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
    List divisionList = await db.RawQuery(
        'select d.districtName,d.districtCode from cityList c,districtList d where c.cityCode =  \'' +
            cityCode +
            '\' and c.districtCode=d.districtCode ');
    setState(() {
      district.text = disCodeList[0]['stateName'].toString();
      parish.text = parishList[0]['cityName'].toString();
      division.text = divisionList[0]['districtName'].toString();
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
              "Farmer Details",
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
        farmerName, Colors.black, 14.0, true, Icons.account_box));
    listings.add(cardlable_dynamic(FarmerNameController.text));
    listings.add(txt_label_icon(
        farmercode, Colors.black, 14.0, true, Icons.account_box));
    listings.add(cardlable_dynamic(FarmerCodeController.text));
    /* listings.add(
        txt_label_icon(village, Colors.black, 14.0, true, Icons.location_on));
    listings.add(cardlable_dynamic(VillageController.text));*/
    if (val_memOrg == "1") {
      listings.add(txt_label_icon("Name of Organization / Cooperative",
          Colors.black, 14.0, true, Icons.location_on));
      listings.add(cardlable_dynamic(nameOrganization.text));
    }

    if (landType == "1") {
      listings.add(txt_label_icon("Name of Owner of the land", Colors.black,
          14.0, true, Icons.location_on));
      listings.add(cardlable_dynamic(nameOwner.text));

      listings.add(txt_label_icon("Address of Owner of the land", Colors.black,
          14.0, true, Icons.location_on));
      listings.add(cardlable_dynamic(addressOwner.text));
    }

    listings.add(
        txt_label_icon("Gender", Colors.black, 14.0, true, Icons.location_on));
    listings.add(cardlable_dynamic(gender.text));
    listings.add(
        txt_label_icon("DOB", Colors.black, 14.0, true, Icons.location_on));
    listings.add(cardlable_dynamic(dob.text));
    listings.add(
        txt_label_icon("Age", Colors.black, 14.0, true, Icons.location_on));
    listings.add(cardlable_dynamic(age.text));
    listings.add(txt_label_icon("National ID Number (NIN)", Colors.black, 14.0,
        true, Icons.location_on));
    listings.add(cardlable_dynamic(nationalId.text));
    // listings.add(
    //     txt_label_icon("Address", Colors.black, 14.0, true, Icons.location_on));
    // listings.add(cardlable_dynamic(address.text));

    listings.add(
      Container(
        child: Row(
          children: [
            Expanded(
                child: txt_label_icon(
                    "District", Colors.black, 14.0, true, Icons.location_on)),
            Expanded(
                child: txt_label_icon(
                    "Region", Colors.black, 14.0, true, Icons.location_on)),
          ],
        ),
      ),
    );
    listings.add(
      Container(
        child: Row(
          children: [
            Expanded(child: cardlable_dynamic(district.text)),
            Expanded(child: cardlable_dynamic(region)),
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
    listings.add(cardlable_dynamic(VillageController.text));
    // listings.add(txt_label_icon(
    //     "Phone Number", Colors.black, 14.0, true, Icons.location_on));
    // listings.add(cardlable_dynamic(MobileNumberController.text));

    // if (farmExist) {
    //   listings.add(txt_label_icon(
    //       "Map View", Colors.black, 14.0, true, Icons.location_on));
    //   listings.add(Container(
    //     height: 100,
    //     child: Stack(
    //       children: <Widget>[
    //         Opacity(
    //           opacity: _isMapLoading ? 0 : 1,
    //           child: GoogleMap(
    //             mapToolbarEnabled: true,
    //             zoomGesturesEnabled: true,
    //             myLocationButtonEnabled: true,
    //             myLocationEnabled: true,
    //             zoomControlsEnabled: true,
    //             initialCameraPosition: CameraPosition(
    //               target: LatLng(41.143029, -8.611274),
    //               zoom: 15,
    //             ),
    //             onMapCreated: (controller) => _onMapCreated(controller),
    //             onTap: (Latlng) {
    //               print('Latlng');
    //               Navigator.of(context).push(MaterialPageRoute(
    //                   builder: (BuildContext context) => MapPage(farmLatList,
    //                       farmLngList, farmnameList, farmernameList)));
    //             },
    //           ),
    //         ),
    //         Opacity(
    //           opacity: _isMapLoading ? 1 : 0,
    //           child: Center(child: CircularProgressIndicator()),
    //         ),
    //         Center(
    //           child: Container(
    //             padding: EdgeInsets.all(3),
    //             child: RaisedButton(
    //               child: Text(
    //                 'View',
    //                 style: new TextStyle(color: Colors.white, fontSize: 18),
    //               ),
    //               onPressed: () {
    //                 print('Latlng');
    //                 Navigator.of(context).push(MaterialPageRoute(
    //                     builder: (BuildContext context) => MapPage(farmLatList,
    //                         farmLngList, farmnameList, farmernameList)));
    //               },
    //               color: Colors.green,
    //             ),
    //           ),
    //         ),
    //       ],
    //     ),
    //   ));
    // }

    // listings.add(
    //     txtfield_digitswithoutdecimal(mobno, MobileNumberController, true));
    /*listings.add(
        txt_label_icon("Farm Name", Colors.black, 14.0, true, Icons.location_on));

    listings.add(
        Row(
          children: [
            Expanded(child:  cardlable_dynamic(FarmNameController.text),flex: 9,),
            Expanded(child:  InkWell(
                onTap: (){
                  if(FarmNameController.text.isEmpty){
                    errordialog(context, "Information","Can't Edit Farm without Farm ID");
                  }else{
                  Navigator.of(context)
                      .push(
                      MaterialPageRoute(
                          builder: (BuildContext
                          context) =>
                              FarmEditScreen(FarmerNameController.text,farmId,FarmNameController.text)));
                  }
                },
                child: Icon(Icons.edit,color: Colors.green,)),flex: 1,)
          ],
        )

       );*/
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

    // listings.add(Container(
    //   child: Row(
    //     children: [
    //       Expanded(
    //         flex: 1,
    //         child: Container(
    //           padding: EdgeInsets.all(3),
    //           child: RaisedButton(
    //             child: Text(
    //               save,
    //               style: new TextStyle(color: Colors.white, fontSize: 18),
    //             ),
    //             onPressed: () {
    //               if (_imageID != null) {
    //                 List<int> imageBytes2 = _imageID!.readAsBytesSync();
    //                 IdProofphoto = base64Encode(imageBytes2);
    //               }
    //               if (_imageFarmer != null) {
    //                 List<int> imageBytes2 = _imageFarmer!.readAsBytesSync();
    //                 farmerPhoto = base64Encode(imageBytes2);
    //               }
    //               farmerEditFunction();
    //             },
    //             color: Colors.green,
    //           ),
    //         ),
    //       ),
    //       Expanded(
    //         flex: 1,
    //         child: Container(
    //           padding: EdgeInsets.all(3),
    //           child: RaisedButton(
    //             child: Text(
    //               Cancel,
    //               style: new TextStyle(color: Colors.white, fontSize: 18),
    //             ),
    //             onPressed: () {
    //               _onBackPressed();
    //             },
    //             color: Colors.redAccent,
    //           ),
    //         ),
    //       ),
    //     ],
    //   ),
    // ));

    return listings;
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

    String farmerPhotoPath = "";
    if (_imageFarmer != null) {
      farmerPhotoPath = _imageFarmer!.path;
    }
    String idPhotoPath = "";
    if (_imageID != null) {
      idPhotoPath = _imageID!.path;
    }
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
    int SaveSensitizing = await db.SaveEditFarmer(
        isSynched,
        revNo,
        farmerId,
        Lat,
        Lng,
        txntime,
        farmerPhotoPath,
        farmerMobile,
        Lat,
        Lng,
        txntime,
        farmphoto,
        farmId,
        season,
        farmProduction,
        fingerPrint,
        idProof,
        idProofOthr,
        idProofVal,
        Lat,
        Lng,
        txntime,
        idPhotoPath,
        idstatus,
        frPhoto,
        farmTotalProd,
        pltStatus,
        geoStatus,
        trader);

    int issync = await db.UpdateTableValue(
        'edit_farmer', 'isSynched', '0', 'recId', revNo);
    print(issync);
    toast(farmreditsuc);
    Navigator.pop(context);
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

  void _onMapCreated(GoogleMapController controller) {
    _mapController.complete(controller);

    setState(() {
      _isMapLoading = false;
    });
  }
}
