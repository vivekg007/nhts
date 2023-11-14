import 'dart:convert';
import 'dart:io';

import 'dart:math';

import '../Database/Databasehelper.dart';
import '../Database/Model/FarmerMaster.dart';
import '../Model/Geoareascalculate.dart';
import '../Model/Treelistmodel.dart';
import '../Model/UIModel.dart';
import '../Model/dynamicfields.dart';
import '../Plugins/TxnExecutor.dart';
import '../Utils/MandatoryDatas.dart';
import 'geoploattingProposedLand.dart';
import 'geoplottingaddfarm.dart';
import 'navigation.dart';

import 'package:flutter/material.dart';

import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../main.dart';
import 'navigation.dart';

class WeatherInformationScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _WeatherInformationScreen();
  }
}

class _WeatherInformationScreen extends State<WeatherInformationScreen> {
  List<UImodel> VillageListUIModel = [];
  List<UImodel> GroupListUIModel = [];

  List<DropdownMenuItem> villageList = [];
  List<DropdownMenuItem> groupList = [];
  List<FarmerMaster> farmermaster=[];
  List<Asset> images = [];
  List<Map> agents=[];
  String seasoncode='';
  String servicePointId='';
  String agentDistributionBal = '';

  String slctVillage="";
  String val_Village="";
  String slctGroup="";
  String val_Group="";
  String Date = '';
  File? _imagefile;
  File? _imagefile2;

  var db = DatabaseHelper();

  String Lat = '';
  String Lng = '';

  TextEditingController NoOfAttendeesController = new TextEditingController();
  TextEditingController RemarksController = new TextEditingController();

  @override
  void initState() {
    super.initState();

    initdata();
    getClientData();
    getLocation();
  }

  getClientData() async {
    agents = await db.RawQuery('SELECT * FROM agentMaster');
    seasoncode = agents[0]['currentSeasonCode'];
    servicePointId = agents[0]['servicePointId'];
    agentDistributionBal = agents[0]['agentDistributionBal'];
  }

  void getLocation() async {
    bool isLocationEnabled = await Geolocator.isLocationServiceEnabled();
    if(isLocationEnabled){
      Position position = await Geolocator
          .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

      print("latitude :" +
          position.latitude.toString() +
          " longitude: " +
          position.longitude.toString());
      setState(() {
        Lat = position.latitude.toString();
        Lng = position.longitude.toString();
      });
    }else{
      Alert(
          context: context,

          title: "Information",
          desc: "GPS Location not enabled",
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

  Future<void> initdata() async {
    List villagelist = await db.RawQuery('select * from villageList ');
    print('villagelist ' + villagelist.toString());
    VillageListUIModel = [];

    villageList.clear();

    for (int i = 0; i < villagelist.length; i++) {
      String villCode = villagelist[i]["villCode"].toString();
      String villName = villagelist[i]["villName"].toString();

      var uimodel = new UImodel(villName, villCode);
      VillageListUIModel.add(uimodel);

      setState(() {
        villageList.add(DropdownMenuItem(
          child: Text(villName),
          value: villName,
        ));
      });
    }


    List grouplist = await db.RawQuery(
        "select sam.samCode as samCode,sam.samName as samName,sam.utzStatus from samitee as sam inner join agentSamiteeList as vsam on sam.samCode = vsam.samCode order by sam.samName asc;");
    print('grouplist ' + grouplist.toString());
    GroupListUIModel = [];

    groupList.clear();

    for (int i = 0; i < grouplist.length; i++) {
      String samCode = grouplist[i]["samCode"].toString();
      String samName = grouplist[i]["samName"].toString();

      var uimodel = new UImodel(samName, samCode);
      GroupListUIModel.add(uimodel);

      setState(() {
        groupList.add(DropdownMenuItem(
          child: Text(samName),
          value: samName,
        ));
      });
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
      desc: 'Are you sure want to cancel',
      buttons: [
        DialogButton(
          child: Text(
            'Yes',
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
            'No',
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
              'Sensitizing',
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
              children: SensitizingUI(
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

  List<Widget> SensitizingUI(BuildContext context) {
    List<Widget> listings = [];

    listings.add(
        txt_label_icon("Date", Colors.black, 14.0, true, Icons.date_range));
    listings.add(selectDate(
      context1: context,
      slctdate: Date,
      onConfirm: (date) => setState(() {
        Date = DateFormat('yyyy-MM-dd').format(date!);
        //print('CHECKJOIINGDFATE:2 '+icsjoiningDate);
      }),
    ));

    listings.add(
      Container(
        padding: EdgeInsets.only(top: 5),
        child: Divider(
          color: Colors.grey,
          height: 1,
        ),
      ),
    );
    listings.add(
        txt_label_icon("Village", Colors.black, 14.0, true, Icons.location_on));
    listings.add(singlesearchDropdown(
        itemlist: villageList,
        selecteditem: slctVillage,
        hint: "Search the Village",
        onChanged: (value) {
          setState(() {
            slctVillage = value!;
            for (int i = 0; i < VillageListUIModel.length; i++) {
              if (VillageListUIModel[i].name == slctVillage) {
                val_Village = VillageListUIModel[i].value;
                // changeFarmerListReg(val_Village);
              }
            }
          });
        }));
    listings.add(
      Container(
        padding: EdgeInsets.only(top: 5),
        child: Divider(
          color: Colors.grey,
          height: 1,
        ),
      ),
    );
    listings
        .add(txt_label_icon("Group", Colors.black, 14.0, true, Icons.group));
    listings.add(singlesearchDropdown(
        itemlist: groupList,
        selecteditem: slctGroup,
        hint: "Search the Group",
        onChanged: (value) {
          setState(() {
            slctGroup = value!;
            for (int i = 0; i < GroupListUIModel.length; i++) {
              if (GroupListUIModel[i].name == slctGroup) {
                val_Group = GroupListUIModel[i].value;
                // changeFarmerListReg(val_Village);
              }
            }
          });
        }));

    listings.add(txt_label_icon(
        "No of Attendees", Colors.black, 14.0, true, Icons.attach_money));
    listings.add(
        txtfield_digitswithoutdecimal("No of Attendees", NoOfAttendeesController, true));
    listings.add(
      Container(
        padding: EdgeInsets.only(top: 5),
        child: Divider(
          color: Colors.grey,
          height: 1,
        ),
      ),
    );

    // listings.add( buildGridView(),);

    listings
        .add(txt_label_icon("Remarks", Colors.black, 14.0, false, Icons.note));
    listings.add(txtfield_dynamic("Remarks", RemarksController, true));
    listings.add(txt_label_mandatory("Photo 1", Colors.black, 14.0, false));
    listings.add(img_picker(
        label: "Farmer Photo \*", onPressed: getImage, filename: _imagefile));
    listings.add(txt_label_mandatory("Photo 2", Colors.black, 14.0, false));
    listings.add(img_picker(
        label: "Farmer Photo \*", onPressed: getImage2, filename: _imagefile2));

    listings.add(Container(
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Container(
              padding: EdgeInsets.all(3),
              child: RaisedButton(
                child: Text(
                  'Save',
                  style: new TextStyle(color: Colors.white, fontSize: 18),
                ),
                onPressed: () {
                  if (Date == "") {
                    errordialog(
                        context, "Information", "Date should not be empty");
                  }else if (val_Village == "") {
                    errordialog(
                        context, "Information", "Village should not be empty ");
                  }
                  else if (val_Group == "") {
                    errordialog(
                        context, "Information", "Group should not be empty ");
                  }
                  else if (NoOfAttendeesController.value.text.length == 0) {
                    errordialog(
                        context, "Information", "No of Attendees should not be empty ");
                  }
                  else if (_imagefile == '') {
                    errordialog(
                        context, "Information", "Photo 1 should not be empty ");
                  }
                  else if (_imagefile2 == '') {
                    errordialog(
                        context, "Information", "Photo 2 should not be empty ");
                  }
                  else {
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
                            saveSensitizingData();
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
  Future getImage() async {
    var image =
    await ImagePicker.platform.pickImage(source: ImageSource.camera);
    setState(() {
      _imagefile = File(image!.path);
    });
  }

  Future getImage2() async {
    var image =
    await ImagePicker.platform.pickImage(source: ImageSource.camera);
    setState(() {
      _imagefile2 = File(image!.path);
    });
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

  saveSensitizingData() async {
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
            servicePointId +
            '\',\' ' +
            revNo +
            '\')';
    print('txnHeader ' + insqry);
    int succ = await db.RawInsert(insqry);
    print(succ);

    AppDatas datas = new AppDatas();
    int custTransaction = await db.saveCustTransaction(
        txntime, datas.txn_sensitizing, revNo, '', '', '');
    print('custTransaction : ' + custTransaction.toString());

    String date = Date;
    String season = seasoncode;
    String village = val_Village;
    String learnGroup = val_Group;
    String noofFarmers = NoOfAttendeesController.text;
    String remarks = RemarksController.text;
    String longitude = Lng;
    String latitude = Lat;
    String isSynched = '1';
    int SaveSensitizing = await db.SaveSensitizing(revNo, date, season, village,
        learnGroup, noofFarmers, remarks, longitude, latitude, isSynched);
    print(SaveSensitizing);




    List<int> imageBytes = _imagefile!.readAsBytesSync();
    String imageB64 = base64Encode(imageBytes);
    int saveImage = await db.SaveSensitizingImage(
        imageB64, revNo, txntime, latitude, longitude);
    print(saveImage);
    List<int> imageBytes2 = _imagefile2!.readAsBytesSync();
    String imageB642 = base64Encode(imageBytes2);
    int saveImage2 = await db.SaveSensitizingImage(
        imageB642, revNo, txntime, latitude, longitude);
    print(saveImage2);



    toast('Sensitizing Submitted Successfully');

    int issync = await db.UpdateTableValue(
        'sensitizing', 'isSynched', '0', 'recNo', revNo);
    print(issync);
    Navigator.pop(context);
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
