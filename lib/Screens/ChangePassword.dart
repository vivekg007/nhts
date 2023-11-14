import 'dart:math';

import '../Database/Databasehelper.dart';
import '../Database/Model/FarmerMaster.dart';
import '../Model/Geoareascalculate.dart';
import '../Model/Treelistmodel.dart';
import '../Model/UIModel.dart';
import '../Model/dynamicfields.dart';
import '../Plugins/RestPlugin.dart';
import '../Plugins/TxnExecutor.dart';
import '../Utils/MandatoryDatas.dart';
import '../main.dart';
import 'geoploattingProposedLand.dart';
import 'geoplottingaddfarm.dart';
import 'navigation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'navigation.dart';

class ChangePassword extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ChangePassword();
  }
}

class _ChangePassword extends State<ChangePassword> {
  TextEditingController CurrentPasswordController = new TextEditingController();
  TextEditingController NewPasswordController = new TextEditingController();
  TextEditingController ConfirmNewPasswordController =
      new TextEditingController();
  List<Map> agents=[];
  String seasoncode='';
  String servicePointId='';
  String? cnfor = 'Confirmation';
  String? doProced = 'Do you want to Proceed?',
      suces = 'Success',
      delete = 'Delete';
  String? no = 'No', sureCancel = 'Are you sure want to Cancel?',cancel = 'Cancel', yes = 'Yes';

  var db = DatabaseHelper();

  String Lat = '';
  String Lng = '';
  RegExp regex =
  RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{6,}$');
  String? userID ='';
  String? userPwd ='';
  List usList =[];


  @override
  void initState() {
    super.initState();
    getClientData();
  }

  getClientData() async {
    agents = await db.RawQuery('SELECT * FROM agentMaster');

    seasoncode = agents[0]['currentSeasonCode'];
    servicePointId = agents[0]['servicePointId'];
    List<Map> passwordSynch = await db.RawQuery('SELECT * FROM passwordSynch');
    print("passwordSynch " + passwordSynch.toString());

    SharedPreferences prefs = await SharedPreferences.getInstance();
    userID = prefs.getString("agentId")!.trim();
    userPwd = prefs.getString("password")!.trim();
    print("userPwd " + userPwd.toString());

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
              'Change Password',
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
              children: ChangePasswordUI(
                  context), // <<<<< Note this change for the return type
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> ChangePasswordUI(BuildContext context) {
    List<Widget> listings = [];

    listings.add(txt_label_icon(
        "Current Password", Colors.black, 14.0, true, Icons.lock));
    listings.add(
        txtfield_digitCharacter("Current Password", CurrentPasswordController, true,6));
    listings.add(txt_label_icon(
        "New Password", Colors.black, 14.0, true, Icons.lock_outline));
    listings.add(txtfield_digitCharacter("New Password", NewPasswordController, true,6));
    listings.add(txt_label_icon(
        "Confirm New Password", Colors.black, 14.0, true, Icons.lock_outline));
    listings.add(txtfield_digitCharacter(
        "Confirm New Password", ConfirmNewPasswordController, true,6));

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
                  'Save',
                  style: new TextStyle(color: Colors.white, fontSize: 18),
                ),
                onPressed: () {
                  if (CurrentPasswordController.value.text.length == 0) {
                    errordialog(context, "Information",
                        "Please enter current password");
                  }  else if (CurrentPasswordController.text.trim() != userPwd!.trim()) {
                    errordialog(
                        context, "Information", "Please check your current password");
                  }
                  else if (NewPasswordController.value.text.length == 0 ) {
                    errordialog(
                        context, "Information", "Please enter new password");
                  }   else if (NewPasswordController.value.text.length < 6) {
                    errordialog(
                        context, "Information", "New password should minimum of 6 characters length");
                  }else if (NewPasswordController.value.text == CurrentPasswordController.value.text ) {
                    errordialog(
                        context, "Information", "Current password and New password should not be same");
                  }
                  else if (ConfirmNewPasswordController.value.text.length == 0 ) {
                    errordialog(
                        context, "Information", "Please enter confirm password");
                  } else if (ConfirmNewPasswordController.value.text.length < 6) {
                    errordialog(
                        context, "Information", "Confirm password should minimum of 6 characters length");
                  }

                  /*else if( !regex.hasMatch(ConfirmNewPasswordController.text)){
                    errordialog(
                        context, "Information", "Passwords must contain one or more special characters, numeric values ,uppercase and lower case characters");
                  }*/
                  else if (ConfirmNewPasswordController.text.contains(userID!)) {
                    errordialog(
                        context, "Information", "Password should not contain user name");
                  }
                  else if (NewPasswordController.text != ConfirmNewPasswordController.text) {
                    errordialog(
                        context, "Information", "Password doesn't matched");
                  }


                  else{
                    confirmation();
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

  saveChangePasswordData() async {
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
        txntime, datas.txn_changePassword, revNo, '', '', '');
    print('custTransaction : ' + custTransaction.toString());


    db.DeleteTable("passwordSynch");

    String userPsw = ConfirmNewPasswordController.text;

    print("userPsw " + userPsw.toString());

    final key = 'STRACE@12345SAKTHIATHISOURCETRACE';
    restplugin rstPlugin = new restplugin();
    String token = rstPlugin.JwtHS256(userPsw, key);
    String pwd = ConfirmNewPasswordController.text;
    print("avtoken " + token.toString());
    String passwordSynch =
        'INSERT INTO "main"."passwordSynch" ("passwordValue", "passwordDate", "isSynched", "recId", "passwordString") VALUES ('
                ' \'' +
            token +
            '\', ' +
            '\'' +
            txntime +
            '\', ' +
            '\'1\', ' +
            '\'' +
            revNo +
            '\', ' +
            '\'' +
            pwd +
            '\')';
    int passwordsucc = await db.RawInsert(passwordSynch);
    print("pwd" + passwordsucc.toString());
    int issync = await db.UpdateTableValue(
        'passwordSynch', 'isSynched', '0', 'recId', revNo);
    Alert(
      context: context,
      type: AlertType.info,
      title: 'Transaction Successful',
      desc: "Password Changed Successfully",
      buttons: [
        DialogButton(
          child: Text(
            'Ok',
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () {

            prefs.setString("password", ConfirmNewPasswordController.text);
            prefs.setString("rememberme", "false");
            Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (BuildContext context) => DashBoard("", "")));
          },
          width: 120,
        ),
      ],
    ).show();  }

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
        title: cnfor!,
        desc: doProced!,
        buttons: [
          DialogButton(
            child: Text(
              no!,
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
              yes!,
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            //onPressed:btnok,
            onPressed: () {
              saveChangePasswordData();
              Navigator.pop(context);
            },
            color: appDatas.appcolor,
          )
        ]).show();
  }}
