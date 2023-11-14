import 'dart:io';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Database/Databasehelper.dart';
import '../Model/dynamicfields.dart';
import '../Utils/MandatoryDatas.dart';
import '../commonlang/translateLang.dart';
import '../main.dart';

class ActivityMenu extends StatefulWidget {
  const ActivityMenu({Key? key}) : super(key: key);

  @override
  State<ActivityMenu> createState() => _ActivityMenuState();
}

class _ActivityMenuState extends State<ActivityMenu> {
  List<Map> agents = [];
  String? seasoncode;
  String? servicePointId;

  String Lat = '';
  String Lng = '';

  var db = DatabaseHelper();

  String? agentId;

  String activityDate = '';
  String activityDateVal = '';

  List<DropdownModel> activityItems = [];
  DropdownModel? slctActivity;
  String slct_Activity = "";
  String val_Activity = "";

  TextEditingController acitvityDescriptionController =
      new TextEditingController();

  String? selectStartTime = "HH:MM";
  String? selectFinishTime = "HH:MM";
  String slctSTime = "";
  String slctFTime = "";

  String checkInTime = "";
  String checkOutTime = "";

  String labelFinshedTime = "";
  String finishedTime = "";

  TimeOfDay selectedTimeFinish = TimeOfDay.now();
  TimeOfDay selecteddesTimeFinish = TimeOfDay.now();

  TimeOfDay selectedTimeStart = TimeOfDay.now();
  TimeOfDay selecteddesTimeStart = TimeOfDay.now();

  String labelTime = "";
  String startTime = "Select start time";

  TextEditingController slctStartTime = new TextEditingController();
  TextEditingController slctEndTime = new TextEditingController();
  TextEditingController activity = new TextEditingController();

  File? activityImageFile;
  String activityImage = "";

  @override
  void initState() {
    super.initState();
    initdata();
    getLocation();
    getClientData();
  }

  Future<void> initdata() async {
    Random rnd = new Random();

    List satisficatoryList = await db.RawQuery(
        'select * from animalCatalog where catalog_code = \'' + "348" + '\'');
    print(' shadeTreeList' + satisficatoryList.toString());

    for (int i = 0; i < satisficatoryList.length; i++) {
      String typurchseName = satisficatoryList[i]["property_value"].toString();
      String typurchseCode = satisficatoryList[i]["DISP_SEQ"].toString();

      setState(() {
        activityItems.add(DropdownModel(
          typurchseName,
          typurchseCode,
        ));
      });
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

  getClientData() async {
    agents = await db.RawQuery('SELECT * FROM agentMaster');
    seasoncode = agents[0]['currentSeasonCode'];
    servicePointId = agents[0]['servicePointId'];
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
              "Other Activities",
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
        ),
      ),
    );
  }

  List<Widget> _getListings(BuildContext context) {
    List<Widget> listings = [];

    listings
        .add(txt_label_mandatory("Activity Date", Colors.black, 14.0, false));
    listings.add(selectDate(
      context1: context,
      slctdate: activityDate,
      onConfirm: (date) => setState(() {
        //HH:mm:ss
        activityDateVal = DateFormat('dd-MM-yyyy').format(date!);
        activityDate = DateFormat('dd-MM-yyyy').format(date);
        //print('CHECKJOIINGDFATE:2 '+icsjoiningDate);
      }),
    ));

    listings.add(txt_label_mandatory("Activity", Colors.black, 14.0, false));
    listings.add(txtfield_dynamic("Activity", activity, true, 1024));

    listings
        .add(txt_label_mandatory("Check-in Time", Colors.black, 14.0, false));
    listings.add(
      MaterialButton(
        color: Colors.green,
        onPressed: () {
          setState(() {
            displayTimeDialog();
            print("time:" +
                selecteddesTimeStart.hour.toString() +
                ":" +
                selecteddesTimeStart.minute.toString());
            startTime =
                "${selecteddesTimeStart.hour}:${selecteddesTimeStart.minute}";
          });
        },
        child: Text("${selectStartTime}"),
      ),
    );

    listings
        .add(txt_label_mandatory("Check-out Time", Colors.black, 14.0, false));
    listings.add(
      MaterialButton(
        color: Colors.green,
        onPressed: () {
          displayTimeEndDialog();
          // print("timeFinished:" +
          //     selecteddesTimeFinish.hour.toString() +
          //     ":" +
          //     selecteddesTimeFinish.minute.toString()+finishedTime);
          //
          // finishedTime = selecteddesTimeFinish.hour.toString() +
          //     ":" +
          //     selecteddesTimeFinish.minute.toString();
        },
        child: Text("${selectFinishTime}"),
      ),
    );

    listings.add(txt_label("Activity Description", Colors.black, 14.0, false));
    listings.add(txtFieldLargeDynamic(
        "Activity Description", acitvityDescriptionController, true));

    listings.add(txt_label("Activity Photo", Colors.black, 14.0, false));

    listings.add(img_picker(
        label: "Activity Photo \*",
        onPressed: () {
          imageDialog("Activity");
        },
        filename: activityImageFile,
        ondelete: () {
          ondelete("Activity");
        }));

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
                  TranslateFun.langList['subCls'],
                  style: new TextStyle(color: Colors.white, fontSize: 18),
                ),
                onPressed: () {
                  _btnSubmit();
                },
                color: Colors.green,
              ),
            ),
          ),
        ],
      ),
    ));

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
      if (photo == "Activity") {
        activityImageFile = File(image!.path);
      }
    });
  }

  Future getImageFromGallery(String photo) async {
    var image = await ImagePicker.platform
        .pickImage(source: ImageSource.gallery, imageQuality: 30);
    setState(() {
      if (photo == "Activity") {
        activityImageFile = File(image!.path);
      }
    });
  }

  void ondelete(String photo) {
    setState(() {
      if (photo == "Activity") {
        setState(() {
          activityImageFile = null;
        });
      }
    });
  }

  Future<void> displayTimeDialog() async {
    final TimeOfDay? time =
        await showTimePicker(context: context, initialTime: TimeOfDay.now());
    if (time != null) {
      setState(() {
        selectStartTime = time.format(context);
        print("selectStartTimeselectStartTime:" + time.toString());
        slctStartTime.text = selectStartTime.toString();
        slctSTime = selectStartTime.toString();
      });
    }
  }

  destnatTime(BuildContext context) async {
    final TimeOfDay? timeOfDay = await showTimePicker(
      context: context,
      initialTime: selecteddesTimeStart,
      initialEntryMode: TimePickerEntryMode.dial,
    );
    if (timeOfDay != null && timeOfDay != selecteddesTimeStart) {
      setState(() {
        selecteddesTimeStart = timeOfDay;
      });
    }
  }

  Future<void> displayTimeEndDialog() async {
    final TimeOfDay? time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
        initialEntryMode: TimePickerEntryMode.dial);
    if (time != null) {
      setState(() {
        selectFinishTime = time.format(context);

        slctEndTime.text = selectFinishTime.toString();
        slctFTime = selectFinishTime.toString();
      });
    }
  }

  destnatTime1(BuildContext context) async {
    final TimeOfDay? timeOfDay = await showTimePicker(
      context: context,
      initialTime: selecteddesTimeFinish,
      initialEntryMode: TimePickerEntryMode.dial,
    );
    if (timeOfDay != null && timeOfDay != selecteddesTimeFinish) {
      setState(() {
        selecteddesTimeFinish = timeOfDay;
      });
    }
  }

  void btncancel() {
    _onBackPressed();
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

  saveActivityMenu() async {
    try {
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
          'INSERT INTO "main"."txnHeader" ("isPrinted", "txnTime", "mode", "operType", "resentCount", "agentId", "agentToken", "msgNo", "servPointId", "txnRefId") VALUES (0, \'$txntime\', \'02\', \'01\', \'0\', \'${agentid!}\',\' ${agentToken!}\',\' $msgNo\',\' ${servicePointId!}\',\' $revNo\')';
      print('txnHeader $Lng $Lat' + insqry);
      int succ = await db.RawInsert(insqry);
      print(succ);

      AppDatas datas = new AppDatas();
      int custTransaction = await db.saveCustTransaction(
          txntime, datas.activityTxn, revNo, '', '', '');
      print('custTransaction : ' + custTransaction.toString());
      String isSynched = "0";

      /*db save functionality*/

      int activitySave = await db.saveActivity(
          activityVal: activity.text,
          activityDes: acitvityDescriptionController.text,
          date: activityDate,
          recNo: revNo,
          isSynched: isSynched,
          latitude: Lat,
          longitude: Lng,
          txnTime: activityImage,
          timeFinished: selectFinishTime.toString(),
          timeStarted: selectStartTime.toString());

      int issync = await db.UpdateTableValue(
          'activityMenu', 'isSynched', '0', 'recNo', revNo);

      Alert(
        context: context,
        type: AlertType.info,
        title: "Transaction Successful",
        desc: "Activity done successfully",
        buttons: [
          DialogButton(
            child: Text(
              "OK",
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

    } catch (e) {
      print("invalid" + e.toString());
      toast(e.toString());
    }
  }

  void _btnSubmit() async {
    checkInTime = selectStartTime!;
    checkOutTime = selectFinishTime!;

    if (activityImageFile != null) {
      activityImage = activityImageFile!.path;
    }

    /*String checkIn = checkInTime.split(' ')[0].split(":")[0].toString();
    String checkInmin = checkInTime.split(' ')[0].split(":")[1].toString();

    String checkOut = checkOutTime.split(' ')[0].split(":")[0].toString();
    String checkOutMin = checkInTime.split(' ')[0].split(":")[1].toString();

    int cInHour = int.parse(checkIn);
    int cInMinutes = int.parse(checkInmin);

    // DateTime ftime = DateFormat("HH:mm:ss").parse(checkInTime);

    DateTime parsedTime = DateFormat('h:mma').parse('6:45PM');
    String formattedTime = DateFormat('HH:mm').format(parsedTime);
    print("formatted date:" + formattedTime);

    int cOHour = int.parse(checkOut);
    int cOMin = int.parse(checkOutMin);

    final currentTime = DateTime.now();
    final startTime = DateTime(currentTime.year, currentTime.month,
        currentTime.day, cInHour, cInMinutes);
    print("start time value:" + startTime.toString());
    final endTime = DateTime(
        currentTime.year, currentTime.month, currentTime.day, cOHour, cOMin);

    TimeOfDay now = TimeOfDay.now();
    TimeOfDay releaseTime = TimeOfDay(hour: cOHour, minute: cOMin);

    if (DateTime.parse(startTime.toString())
        .isAfter(DateTime.parse(endTime.toString()))) {
      print("true time");
    } else {
      print("False time");
    }*/

    /**/

    if (activityDate.isEmpty) {
      errordialog(context, "Information", "Activity date should not be empty");
    } else if (activity.text.isEmpty) {
      errordialog(context, "Information", "Activity should not be empty");
    } else if (slctSTime!.isEmpty) {
      errordialog(context, "Information", "Check-in time should not be empty");
    } else if (slctFTime!.isEmpty) {
      errordialog(context, "Information", "Check-out time should not be empty");
    } else {
      confirmation();
    }
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
        title: "Confirmation",
        desc: "Do you want to Proceed?",
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
              Navigator.pop(context);
              // Navigator.pop(context);
              saveActivityMenu();
            },
            color: Colors.green,
          )
        ]).show();
  }
}
