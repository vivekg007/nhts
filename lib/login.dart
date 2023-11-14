import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'dart:math' as math;

import 'package:connectivity/connectivity.dart';
import 'package:crypto/crypto.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:jaguar_jwt/jaguar_jwt.dart';
import 'package:package_info/package_info.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Database/Databasehelper.dart';
import 'Model/User.dart';
import 'Model/dynamicfields.dart';
import 'Plugins/RestPlugin.dart';
import 'ResponseModel/LoginResponseModel.dart';
import 'Screens/navigation.dart';
import 'commonlang/translateLang.dart';

const CURVE_HEIGHT = 160.0;
const AVATAR_RADIUS = CURVE_HEIGHT * 0.28;
const AVATAR_DIAMETER = AVATAR_RADIUS * 2;
var db = DatabaseHelper();

class LoginStateful extends StatefulWidget {
  @override
  LoginScreen createState() => LoginScreen();
}

class LoginScreen extends State<LoginStateful> {
  TextEditingController usernamecontroller = TextEditingController();
  TextEditingController passwordcontroller = TextEditingController();
  SharedPreferences? sharedPrefs;
  bool isObscure = true;

  String type = "1";
  String _connectionStatus = 'Unknown';
  bool _internetconnection = false;
  bool synced = false;
  String transactioncount = '0';
  final Connectivity _connectivity = Connectivity();
  StreamSubscription<ConnectivityResult>? _connectivitySubscription;
  bool isremembered = false;
  bool dbissue = false;
  String stateCode = "";

  bool updateAvl = false;
  String availupd = 'Update Available';
  String appavl = 'An Application update available Please logout';
  String page = "";

  /*11062023 changes*/
  bool isNotificationRecieved = false;
  bool notificationClickedLogin = false;
  String clickAct = "";

  @override
  void initState() {
    super.initState();
    initConnectivity();
    GetDatas();
    checkpermission();
    checkremberme();

    /*11062023-changes*/
    /* FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification notification = message.notification!;
      AndroidNotification android = message.notification!.android!;

      String clickAction = message.data['page'].toString();
      clickAct = clickAction;
      print("click action value at login:" + clickAction);

      if (clickAction.isNotEmpty) {
        notificationClickedLogin = true;
      }
    });*/

    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);

    SharedPreferences.getInstance().then((prefs) {
      setState(() => sharedPrefs = prefs);
    });
  }

  void checkLatestVersion() {
    Timer.periodic(const Duration(seconds: 5), (timer) async {
      var db = DatabaseHelper();
      List<Map> custTransactions = await db.GetTableValues('custTransactions');
      if (!updateAvl && custTransactions.isEmpty) {
        restplugin rest = restplugin();
        final String response = await rest.GetLatestVersion();
        PackageInfo packageInfo = await PackageInfo.fromPlatform();

        String appName = packageInfo.appName;
        String packageName = packageInfo.packageName;
        String version = packageInfo.version;
        String buildNumber = packageInfo.buildNumber;

        List<String> versionlist = version
            .split(
                '.') // split the text into an array/ put the text inside a widget
            .toList();

        List<String> serverversionlist = response
            .split(
                ',') // split the text into an array/ put the text inside a widget
            .toList();
        String appversion = versionlist[0];

        String serverappversion = serverversionlist[0];
        String databaseversion_server = serverversionlist[1];

        SharedPreferences prefs = await SharedPreferences.getInstance();
        String? DBVERSION = prefs.getString("DBVERSION");

        if (DBVERSION == databaseversion_server) {
        } else {
          print("DownloadDB mismatch");
          updateAvl = true;
        }
        if (appversion == serverappversion) {
        } else {
          print('apk update available');
          updateAvl = true;
        }

        if (updateAvl) {
          Alert(
            context: context,
            type: AlertType.warning,
            title: availupd,
            desc: appavl,
            buttons: [
              DialogButton(
                onPressed: () {
                  prefs.setString("FreshDB", "0");
                  SystemNavigator.pop();
                },
                width: 120,
                child: Text(
                  "ok",
                  style: const TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
            ],
          ).show();
        }
      }
    });
  }

  Future<void> checkremberme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String? rememberme = prefs.getString("rememberme");
    if (rememberme == null) {
      rememberme = '';
    }

    if (rememberme != '' && rememberme.isNotEmpty && rememberme == "true") {
      String? Username = prefs.getString("username");
      String? Password = prefs.getString("password");
      if (Username != '' &&
          Username!.isNotEmpty &&
          Password != '' &&
          Password!.isNotEmpty) {
        usernamecontroller.text = Username;
        passwordcontroller.text = Password;
      }
      isremembered = true;
    } else {
      isremembered = false;
    }
  }

  Future<void> initConnectivity() async {
    ConnectivityResult? result;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      print(e.toString());
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) {
      return Future.value('');
    }

    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(ConnectivityResult? result) async {
    switch (result) {
      case ConnectivityResult.wifi:
        setState(() {
          _internetconnection = true;
        });
        break;
      case ConnectivityResult.mobile:
        setState(() {
          _internetconnection = true;
        });
        break;
      case ConnectivityResult.none:
        setState(() {
          _internetconnection = false;
          _connectionStatus = 'No internet connection';
        });
        break;
      default:
        setState(() {
          _internetconnection = false;
          _connectionStatus = 'Failed to get connectivity.';
        });
        break;
    }
  }

  Future<void> checkpermission() async {
    if (await Permission.contacts.request().isGranted) {
      // Either the permission was already granted before or the user just granted it.
    }
    // You can request multiple permissions at once.
    Map<Permission, PermissionStatus> statuses = await [
      Permission.location,
      Permission.storage,
    ].request();
    print(statuses[Permission.location]);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return SafeArea(
      child: Scaffold(
        body: Builder(
          // Create an inner BuildContext so that the onPressed methods
          // can refer to the Scaffold with Scaffold.of().
          builder: (BuildContext context) {
            return Container(
              color: Colors.white,
              child: Stack(children: <Widget>[
                Positioned(
                  right: 10,
                  top: 10,
                  child: Container(
                    width: 30,
                    height: 30,
                    alignment: Alignment.center,
                    decoration: synced && _internetconnection
                        ? const BoxDecoration(
                            shape: BoxShape.circle, color: Colors.green)
                        : const BoxDecoration(
                            shape: BoxShape.circle, color: Colors.red),
                    child: Text(
                      transactioncount,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                Positioned(
                  top: 0.0,
                  child: Column(
                    children: <Widget>[
                      Align(
                        child: Container(
                          height: 150,
                          width: 150,
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                              image: ExactAssetImage('images/bg1.png'),
                              fit: BoxFit.fitHeight,
                            ),
                            color: Colors.green,
                            //border: Border.all(color: Colors.black, width: 0.0),
                            borderRadius: BorderRadius.only(
                                bottomRight: Radius.circular(150)),
                          ),
                          child: const Text('     '),
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        margin: const EdgeInsets.only(left: 20, right: 20),
                        child: Align(
                          alignment: Alignment.center,
                          child: Column(
                            children: <Widget>[
                              Container(
                                width: 180,
                                padding: const EdgeInsets.all(5.0),
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 25.0),
                                    child: Row(
                                      children: <Widget>[
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 5.0),
                                          child: LogoAsset(),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width,
                                padding: const EdgeInsets.all(5.0),
                                child: Align(
                                    alignment: Alignment.center,
                                    child: Text(
                                      TranslateFun.langList['loginCls'] ?? '',
                                      style: const TextStyle(
                                          color: Colors.green,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    )),
                              ),
                              Card(
                                elevation: 5,
                                color: Colors.green,
                                shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                  Radius.circular(5.0),
                                )),
                                child: Container(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Column(
                                    children: <Widget>[
                                      Row(
                                        mainAxisSize: MainAxisSize.max,
                                        children: <Widget>[
                                          Expanded(
                                            child: Container(
                                              padding:
                                                  const EdgeInsets.all(5.0),
                                              margin: const EdgeInsets.all(5.0),
                                              child: TextFormField(
                                                style: const TextStyle(
                                                    color: Colors.white),
                                                controller: usernamecontroller,
                                                decoration: InputDecoration(
                                                    enabledBorder:
                                                        const UnderlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: Colors.white),
                                                    ),
                                                    focusedBorder:
                                                        const UnderlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: Colors.white),
                                                    ),
                                                    icon: const Icon(
                                                        Icons.person,
                                                        color: Colors.white),
                                                    labelText:
                                                        TranslateFun.langList[
                                                                'userCls'] ??
                                                            '',
                                                    labelStyle: const TextStyle(
                                                      color: Colors.white,
                                                    ),
                                                    hintStyle: const TextStyle(
                                                      color: Colors.grey,
                                                    ),
                                                    fillColor:
                                                        Colors.transparent,
                                                    filled: true),
                                                onSaved: (String? value) {
                                                  // This optional block of code can be used to run
                                                  // code when the user saves the form.
                                                },
                                                validator: (String? value) {
                                                  return value!.contains('@')
                                                      ? 'Do not use the @ char.'
                                                      : '';
                                                },
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Container(
                                        child: Row(
                                          children: <Widget>[
                                            Expanded(
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.all(5.0),
                                                margin:
                                                    const EdgeInsets.all(5.0),
                                                child: TextFormField(
                                                  style: const TextStyle(
                                                      color: Colors.white),
                                                  controller:
                                                      passwordcontroller,
                                                  obscureText: isObscure,
                                                  decoration: InputDecoration(
                                                      enabledBorder:
                                                          const UnderlineInputBorder(
                                                        borderSide: BorderSide(
                                                            color:
                                                                Colors.white),
                                                      ),
                                                      focusedBorder:
                                                          const UnderlineInputBorder(
                                                        borderSide: BorderSide(
                                                            color:
                                                                Colors.white),
                                                      ),
                                                      /*icon: const Icon(
                                                          Icons.lock,
                                                          color: Colors.white),*/
                                                      icon: InkWell(
                                                        child: Icon(
                                                          isObscure
                                                              ? Icons.visibility
                                                              : Icons
                                                                  .visibility_off,
                                                          color: Colors.white,
                                                        ),
                                                        onTap: () {
                                                          setState(() {
                                                            isObscure =
                                                                !isObscure;
                                                          });
                                                        },
                                                      ),
                                                      labelText:
                                                          TranslateFun.langList[
                                                                  'passCls'] ??
                                                              '',
                                                      labelStyle:
                                                          const TextStyle(
                                                        color: Colors.white,
                                                      ),
                                                      hintStyle:
                                                          const TextStyle(
                                                        color: Colors.grey,
                                                      ),
                                                      fillColor:
                                                          Colors.transparent,
                                                      filled: true),
                                                  onSaved: (String? value) {
                                                    // This optional block of code can be used to run
                                                    // code when the user saves the form.
                                                  },
                                                  validator: (String? value) {
                                                    return value!.contains('@')
                                                        ? 'Do not use the @ char.'
                                                        : '';
                                                  },
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Container(
                                  alignment: Alignment.centerLeft,
                                  margin: const EdgeInsets.only(top: 15),
                                  child: chkbox_dynamic(
                                    label:
                                        TranslateFun.langList['remCls'] ?? '',
                                    checked: isremembered,
                                    onChange: (value) => setState(() {
                                      isremembered = value!;
                                    }),
                                  )),
                              Container(
                                  width: 150,
                                  margin: const EdgeInsets.only(top: 5),
                                  child: MaterialButton(
                                    onPressed: () {
                                      if (usernamecontroller.text == '') {
                                        AlertPopup(TranslateFun
                                                .langList['valUserCls'] ??
                                            '');
                                      } else if (passwordcontroller.text ==
                                          '') {
                                        AlertPopup(TranslateFun
                                                .langList['valPwdCls'] ??
                                            '');
                                      } else if (_internetconnection &&
                                          synced) {
                                        LoginCheckGreenPath(
                                            context,
                                            usernamecontroller.text,
                                            passwordcontroller.text);
                                      } else if (_internetconnection &&
                                          dbissue) {
                                        var alertStyle = const AlertStyle(
                                          animationType: AnimationType.shrink,
                                          overlayColor: Colors.black87,
                                          isCloseButton: false,
                                          isOverlayTapDismiss: false,
                                          titleStyle: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18),
                                          descStyle: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 16),
                                          animationDuration:
                                              Duration(milliseconds: 400),
                                        );

                                        Alert(
                                            context: context,
                                            style: alertStyle,
                                            title: "Login ",
                                            desc:
                                                "Database is not downloaded properly. Please Reinstall the application",
                                            buttons: [
                                              DialogButton(
                                                child: const Text(
                                                  "OK",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 20),
                                                ),
                                                //onPressed:btnok,
                                                onPressed: () async {
                                                  SharedPreferences prefs =
                                                      await SharedPreferences
                                                          .getInstance();
                                                  prefs.setString(
                                                      "DBVERSION", "-1");
                                                  // Navigator.pop(context);
                                                  Navigator.pop(context);
                                                },
                                                color: Colors.green,
                                              )
                                            ]).show();
                                      } else {
                                        if (_internetconnection) {
                                          var alertStyle = const AlertStyle(
                                            animationType: AnimationType.shrink,
                                            overlayColor: Colors.black87,
                                            isCloseButton: false,
                                            isOverlayTapDismiss: false,
                                            titleStyle: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18),
                                            descStyle: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 16),
                                            animationDuration:
                                                Duration(milliseconds: 400),
                                          );
                                          Alert(
                                              context: context,
                                              style: alertStyle,
                                              title: TranslateFun
                                                      .langList['loginCls'] ??
                                                  '',
                                              desc: TranslateFun.langList[
                                                      'valpendingavlCls'] ??
                                                  '',
                                              buttons: [
                                                DialogButton(
                                                  onPressed: () async {
                                                    Navigator.pop(context);

                                                    offlineLogin(
                                                        usernamecontroller.text,
                                                        passwordcontroller
                                                            .text);
                                                  },
                                                  color: Colors.green,
                                                  child: const Text(
                                                    "OK",
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 18),
                                                  ),
                                                )
                                              ]).show();
                                        } else {
                                          offlineLogin(usernamecontroller.text,
                                              passwordcontroller.text);
                                        }
                                      }
                                    },
                                    color: Colors.green,
                                    child: Text(
                                      TranslateFun.langList['siginCls'] ?? '',
                                      style: const TextStyle(
                                          color: Colors.white, fontSize: 18),
                                    ),
                                  )),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  bottom: 0.0,
                  child: Column(
                    children: const <Widget>[
                      // Container(
                      //   width: MediaQuery.of(context).size.width,
                      //   alignment: Alignment.center,
                      //   child: const Text(
                      //     'Powered by SourceTrace',
                      //     style: const TextStyle(
                      //       fontSize: 16,
                      //       color: Colors.green,
                      //     ),
                      //   ),
                      // )
                    ],
                  ),
                ),
              ]),
            );
          },
        ),
      ),
    );
  }

  void AlertPopup(String message) {
    Alert(
      context: context,
      type: AlertType.none,
      title: TranslateFun.langList['alertCls'] ?? '',
      desc: message,
      buttons: [
        DialogButton(
          onPressed: () {
            Navigator.pop(context);
          },
          width: 120,
          child: const Text(
            "OK",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
        ),
      ],
    ).show();
  }

  Future<void> offlineLogin(String username, String password) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? Username = prefs.getString("username");
    String? Password = prefs.getString("password");
    if (username == Username && password == Password) {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (BuildContext context) => DashBoard(
                '',
                '',
              )));
    } else {
      confirmationPopup(context, "Incorrect Username or Password");
    }
  }

  confirmationPopup(BuildContext dialogContext, String message) {
    var alertStyle = const AlertStyle(
      animationType: AnimationType.grow,
      overlayColor: Colors.black87,
      isCloseButton: true,
      isOverlayTapDismiss: true,
      titleStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
      descStyle: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
      animationDuration: Duration(milliseconds: 400),
    );
    print("CHECKMESSAGE " + message);
    Alert(
        context: dialogContext,
        style: alertStyle,
        title: TranslateFun.langList['loginFailedCls'] ?? '',
        desc: message,
        buttons: [
          DialogButton(
            onPressed: () {
              Navigator.pop(context);
            },
            color: Colors.green,
            child: const Text(
              "OK",
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          )
        ]).show();
  }

  void GetDatas() async {
    try {
      // checking transaction count before update
      var db = DatabaseHelper();
      List<Map> headerdata = await db.GetTableValues('txnHeader');
      print('headerdata ' + headerdata.toString());
      List<Map> custTransactions = await db.GetTableValues('custTransactions');
      print('custTransactions ' + custTransactions.toString());
      if (custTransactions.isEmpty) {
        setState(() {
          synced = true;
        });
      } else {
        setState(() {
          transactioncount = custTransactions.length.toString();
          synced = false;
        });
      }
    } catch (e) {
      print('pendingtransaction' + e.toString());
    }
  }

  Future<void> LoginCheckGreenPath(
      BuildContext context, String username, String Password) async {
    //try {
    EasyLoading.show(status: 'loading...');
    restplugin rest = restplugin();

    final String response = await rest.loginApi(username, Password);
    print('loginApi ' + response);
    Map<String, dynamic> json = jsonDecode(response);

    String code = json['Response']['status']['code'];
    if (code == '00') {
      LoginResponseModel logindata = LoginResponseModel.fromJson(json);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? agentToken = prefs.getString("agentToken");

      print("logindata_logindata" + logindata.toString());

      final snackBar =
          SnackBar(content: Text(logindata.response!.status!.message!));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);

      if (logindata.response!.status!.code! == '00') {
        print("login 00");
        /*   final clientProjectRev =
            logindata.response!.body!.agentLogin!.clientRevNo;*/
        const clientProjectRev = "";
        final agentDistributionBal = logindata.response!.body!.agentLogin!.bal;
        print("login 00");
        /*final agentProcurementBal =
              logindata.response!.body!.agentLogin!.distImgAvil;*/
        final currentSeasonCode =
            logindata.response!.body!.agentLogin!.currentSeasonCode;
        const pricePatternRev = "0";
        final agentType = logindata.response!.body!.agentLogin!.agentType;

        final tareWeight = logindata.response!.body!.agentLogin!.tare;

        final wareHouseCode = logindata.response!.body!.agentLogin!.wCode;
        /* String aggregatorIdSeqF =
            logindata.response!.body!.agentLogin!.aggreIdSeq!;*/

        // final samittee = logindata.response!.body!.agentLogin!.samithis;
        //
        // for (int i = 0; i < samittee!.length; i++) {
        //   var db = DatabaseHelper();
        //   String samCode = samittee[i].samCode.toString();
        //   print("samcode:" + samCode);
        //   int agntsamit = await db.DeleteTable("agentSamiteeList");
        //   print(agntsamit);
        //   db.SaveSamitee(samCode);
        // }

        String aggregatorIdSeqF = "";
        String clientIdSeqF =
            logindata.response!.body!.agentLogin!.clientIdSeq!;
        List<String> aggregatorSeqFs = clientIdSeqF.split('|');
        print('aggregatorIdSeqF' + aggregatorSeqFs.toString());
        final curIdSeqAgg = aggregatorSeqFs[0];
        final resIdSeqAgg = aggregatorSeqFs[1];
        final curIdLimitAgg = aggregatorSeqFs[2];

        //String clientIdSeqS = logindata.response!.body!.agentLogin!.spIdSeq!;

        /*List<String> clientIdSeqss = clientIdSeqS.split('|');
          final curIdSeqS = clientIdSeqss[0];
          final resIdSeqS = clientIdSeqss[1];
          final curIdLimitS = clientIdSeqss[2];
          String clientIdSeqF =
              logindata.response!.body!.agentLogin!.clientIdSeq!;
          List<String> clientIdSeqFs = clientIdSeqF.split('|');
          print('clientIdSeqF' + clientIdSeqF);
          final curIdSeqF = clientIdSeqFs[0];
          final resIdSeqF = clientIdSeqFs[1];
          final curIdLimitF = clientIdSeqFs[2];*/
        const agentAccBal = "";
        final farmerRev = logindata.response!.body!.agentLogin!.farmerRevNo!;
        const shopRev = "0";
        final agentId = username;
        final agentName = logindata.response!.body!.agentLogin!.agentName!;
        final cityCode = logindata.response!.body!.agentLogin!.stateCode;
        print("cityCodeValue:" + cityCode.toString());
        stateCode = cityCode.toString();
        final servPointName =
            logindata.response!.body!.agentLogin!.servPointName!;
        final agentPassword = agentToken;
        final servicePointId =
            logindata.response!.body!.agentLogin!.servPointId!;
        const locationRev = "0";
        const trainingRev = "0";
        const plannerRev = 0;
        const farmerOutStandBalRev = 0;
        const productDwRev = 0;
        const farmCrpDwRev = 0;
        const procurementProdDwRev = "";
        const villageWareHouseDwRev = 0;
        const gradeDwRev = 0;
        const wareHouseStockDwRev = 0;
        const coOperativeDwRev = 0;
        const trainingCatRev = 0;
        const seasonDwRev = 0;
        const fieldStaffRev = 0;
        const areaCaptureMode = '0';
        print("CHECKlogintxn " + areaCaptureMode);
        const interestRateApplicable = "";
        const rateOfInterest = "";
        // final effectiveFrom = logindata.response!.body!.agentLogin!.eFrom;
        const effectiveFrom = "";
        const isApplicableForExisting = "";
        const previousInterestRate = "";
        const qrScan = "";
        // final geoFenceFlag = logindata.response!.body!.agentLogin!.gFReq;
        const geoFenceFlag = "";
        // final geoFenceRadius = logindata.response!.body!.agentLogin!.gRad;
        const geoFenceRadius = "";
        const buyerDwRev = "";
        const catalogDwRev = "0";
        final parentID = logindata.response!.body!.agentLogin!.parentId;
        final branchID = logindata.response!.body!.agentLogin!.branchId;
        // final isGeneric = logindata.response!.body!.agentLogin!.isGeneric;
        const isGeneric = "";
        const supplierDwRev = "0";
        const researchStationDwRev = "0";
        final displayDtFmt = logindata.response!.body!.agentLogin!.dispDtFormat;
        // final batchAvailable = logindata.response!.body!.agentLogin!.isBatchAvail;
        const batchAvailable = "";
        final isGrampnchayat =
            logindata.response!.body!.agentLogin!.isGrampnchayat;
        final areaUnitType = logindata.response!.body!.agentLogin!.areaType;
        final currency = logindata.response!.body!.agentLogin!.currency;
        const farmerfarmRev = "0";
        const farmerfarmcropRev = "0";
        // final warehouseId = logindata.response!.body!.agentLogin!.warehouseId;
        const warehouseId = "";
        const farmerStockBalRev = "0";
        const latestSeasonRevNo = "";
        const latestCatalogRevNo = "";
        const latestLocationRevNo = "";
        const latestCooperativeRevNo = "";
        const latestProcproductRevNo = "";
        const latestFarmerRevNo = "0";
        const latestFarmRevNo = null;
        const latestFarmCropRevNo = null;
        const dynamicDwRev = 0;
        const isBuyer = null;
        const distributionPhoto = null;
        // final latestwsRevNo = logindata.response!.body!.agentLogin!.dynLatestRevNo;
        const digitalSign = null;
        final cropCalandar = logindata.response!.body!.agentLogin!.cropCalandar;
        const eventDwRev = "0";
        const seasonProdFlag = null;
        const followUpRevNo = "0";
        // final samithis = logindata.response!.body!.agentLogin!.samithis!;
        // print("samitiee:"+logindata.response!.body!.agentLogin!.samithis![1].samCode.toString());
        var db = DatabaseHelper();
        db.DeleteTable('samitee');
        //
        // for (int i = 0;
        //     i < logindata.response!.body!.agentLogin!.samithis!.length;
        //     i++) {
        //   String samCode = logindata
        //       .response!.body!.agentLogin!.samithis![i].samCode
        //       .toString();
        //   String samName = logindata
        //       .response!.body!.agentLogin!.samithis![i].samName
        //       .toString();
        //   print("samName:" + samName);
        //   print("samCode:" + samCode);
        //   var db = DatabaseHelper();
        //
        //   int samitee = await db.SaveSamiteeList(samCode, samName, "");
        //
        //   print("samittteelist:" + samitee.toString());
        // }
        db.DeleteTable('wareHouseList');

        // print("factory length:" +
        //     logindata.response!.body!.agentLogin!.factory!.length.toString());
        //
        // for (int f = 0;
        //     f < logindata.response!.body!.agentLogin!.factory!.length;
        //     f++) {
        //   String factoryName =
        //       logindata.response!.body!.agentLogin!.factory![f].samName!;
        //   String factoryCode =
        //       logindata.response!.body!.agentLogin!.factory![f].samCode!;
        //   db.SaveWareHouseList(factoryCode, factoryName, "");
        // }

        /*for (int i = 0; i < samithis.length; i++) {
            final samcode =
                logindata.response!.body!.agentLogin!.samithis![i].samCode;
          }*/
        //GreenpathLoginResponseModel
        // var db = DatabaseHelper();
        int deltsucc = await db.DeleteTable("agentMaster");
        print(deltsucc);
        db.saveUser(User(
          clientProjectRev.toString(),
          agentDistributionBal.toString(),
          //agentProcurementBal.toString(),
          currentSeasonCode.toString(),
          pricePatternRev.toString(),
          agentType.toString(),
          tareWeight.toString(),
          //curIdSeqS.toString(),
          //resIdSeqS.toString(),
          //curIdLimitS.toString(),
          //curIdLimitF.toString(),
          //resIdSeqF.toString(),
          //curIdSeqF.toString(),
          agentAccBal.toString(),
          farmerRev.toString(),
          shopRev.toString(),
          agentId.toString(),
          agentName.toString(),
          cityCode.toString(),
          servPointName.toString(),
          agentPassword.toString(),
          servicePointId.toString(),
          locationRev.toString(),
          trainingRev.toString(),
          plannerRev.toString(),
          farmerOutStandBalRev.toString(),
          productDwRev.toString(),
          farmCrpDwRev.toString(),
          procurementProdDwRev.toString(),
          villageWareHouseDwRev.toString(),
          gradeDwRev.toString(),
          wareHouseStockDwRev.toString(),
          coOperativeDwRev.toString(),
          trainingCatRev.toString(),
          seasonDwRev.toString(),
          fieldStaffRev.toString(),
          areaCaptureMode.toString(),
          interestRateApplicable.toString(),
          rateOfInterest.toString(),
          effectiveFrom.toString(),
          isApplicableForExisting.toString(),
          previousInterestRate.toString(),
          qrScan.toString(),
          geoFenceFlag.toString(),
          geoFenceRadius.toString(),
          buyerDwRev.toString(),
          catalogDwRev.toString(),
          parentID.toString(),
          branchID.toString(),
          isGeneric.toString(),
          supplierDwRev.toString(),
          researchStationDwRev.toString(),
          displayDtFmt.toString(),
          batchAvailable.toString(),
          isGrampnchayat.toString(),
          areaUnitType.toString(),
          currency.toString(),
          farmerfarmRev.toString(),
          farmerfarmcropRev.toString(),
          warehouseId.toString(),
          farmerStockBalRev.toString(),
          latestSeasonRevNo.toString(),
          latestCatalogRevNo.toString(),
          latestLocationRevNo.toString(),
          latestCooperativeRevNo.toString(),
          latestProcproductRevNo.toString(),
          latestFarmerRevNo.toString(),
          latestFarmRevNo.toString(),
          '',
          dynamicDwRev.toString(),
          isBuyer.toString(),
          '',
          //latestwsRevNo.toString(),
          digitalSign.toString(),
          '',
          '',
          '',
          followUpRevNo.toString(),
          '',
          wareHouseCode.toString(),
          curIdSeqAgg.toString(),
          resIdSeqAgg.toString(),
          curIdLimitAgg.toString(),
        ));

        print("login download:" + logindata.response!.body!.data14!.toString());
        if (logindata.response!.body!.data14!.menulist!.isNotEmpty) {
          try {
            for (int i = 0;
                i < logindata.response!.body!.data14!.menulist!.length;
                i++) {
              String menuId =
                  logindata.response!.body!.data14!.menulist![i].menuId!;
              String? menuName =
                  logindata.response!.body!.data14!.menulist![i].menuLabel;
              String? iconClass =
                  logindata.response!.body!.data14!.menulist![i].iconClass;
              print("iconClass121212" + iconClass!);
              String? menuOrder =
                  logindata.response!.body!.data14!.menulist![i].menuOrder;
              String? txnTypeIdMenu =
                  logindata.response!.body!.data14!.menulist![i].txnTypeId;
              String? entity =
                  logindata.response!.body!.data14!.menulist![i].entity;
              String menucommonClass = "menuClick";
              String? seasonFlag =
                  logindata.response!.body!.data14!.menulist![i].seasonFlag;
              String? agentType =
                  logindata.response!.body!.data14!.menulist![i].agentType;
              String? isSurvey =
                  logindata.response!.body!.data14!.menulist![i].is_survey;

              print("surveyissurvey:" + isSurvey!);

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
                  statusState,
                  isSurvey!);
              print("saveMenu " + saveMenu.toString());

              for (int j = 0;
                  j <
                      logindata.response!.body!.data14!.menulist![i].sections!
                          .length;
                  j++) {
                String? txnTypeId = logindata.response!.body!.data14!
                    .menulist![i].sections![j].txnTypeId;
                String? blockId = logindata
                    .response!.body!.data14?.menulist![i].sections![j].blockId;
                String? sectionId = logindata
                    .response!.body!.data14!.menulist![i].sections![j].secId;
                String? secName = logindata
                    .response!.body!.data14!.menulist![i].sections![j].secName;
                String? district = logindata
                    .response!.body!.data14!.menulist![i].sections![j].district;
                String? month = logindata
                    .response!.body!.data14!.menulist![i].sections![j].month;
                String? beinsert = logindata.response!.body!.data14!
                    .menulist![i].sections![j].beforeInsert;
                String? afterins = logindata.response!.body!.data14!
                    .menulist![i].sections![j].afterInsert;

                int delSec = await db.RawUpdate(
                    'DELETE FROM dynamiccomponentSections where sectionId = \'' +
                        sectionId! +
                        '\'');
                print('delSec: $delSec');

                db.SaveDynamicCompenentSection(
                    txnTypeId!,
                    blockId!,
                    sectionId,
                    secName!,
                    beinsert!,
                    afterins!,
                    "",
                    "",
                    fluptxnId,
                    isfollowup,
                    district!,
                    month!);
                for (int k = 0;
                    k <
                        logindata.response!.body!.data14!.menulist![i]
                            .sections![j].lists!.length;
                    k++) {
                  String? listId = logindata.response!.body!.data14!
                      .menulist![i].sections![j].lists![k].listId;
                  String? listName = logindata.response!.body!.data14!
                      .menulist![i].sections![j].lists![k].listName;

                  int delLis = await db.RawUpdate(
                      'DELETE FROM dynamiccomponentList where listId = \'' +
                          listId! +
                          '\'');
                  print('del_List: $delLis');

                  int compententsave = await db.SaveDynamicCompenentList(
                      listId, listName!, blockId, txnTypeId, sectionId);
                  print("compententsave " + compententsave.toString());
                }

                for (int k = 0;
                    k <
                        logindata.response!.body!.data14!.menulist![i]
                            .sections![j].fieldList!.length;
                    k++) {
                  String? componentType = logindata.response!.body!.data14!
                      .menulist![i].sections![j].fieldList![k].compoType;
                  String? district = logindata.response!.body!.data14!
                      .menulist![i].sections![j].fieldList![k].district;
                  String? month = logindata.response!.body!.data14!.menulist![i]
                      .sections![j].fieldList![k].month;
                  String? componentID = logindata.response!.body!.data14!
                      .menulist![i].sections![j].fieldList![k].compoId;
                  String? componentLabel = logindata.response!.body!.data14!
                      .menulist![i].sections![j].fieldList![k].compoLabel;
                  String? isMandatory = logindata.response!.body!.data14!
                      .menulist![i].sections![j].fieldList![k].isRequired;
                  String? validationType = logindata.response!.body!.data14!
                      .menulist![i].sections![j].fieldList![k].validType;
                  String? maxLength = logindata.response!.body!.data14!
                      .menulist![i].sections![j].fieldList![k].maxLength;
                  String? minLength = logindata.response!.body!.data14!
                      .menulist![i].sections![j].fieldList![k].minLength;
                  String? dependentField = logindata.response!.body!.data14!
                      .menulist![i].sections![j].fieldList![k].dependentField;
                  String? cattype = logindata.response!.body!.data14!
                      .menulist![i].sections![j].fieldList![k].catType;
                  String? parentDepend = logindata.response!.body!.data14!
                      .menulist![i].sections![j].fieldList![k].parentDepend;
                  String? listMethodName = logindata.response!.body!.data14!
                      .menulist![i].sections![j].fieldList![k].listMethodName;
                  String? formulaDependency = logindata
                      .response!
                      .body!
                      .data14!
                      .menulist![i]
                      .sections![j]
                      .fieldList![k]
                      .formulaDependency;
                  String? parentField = logindata.response!.body!.data14!
                      .menulist![i].sections![j].fieldList![k].parentField;
                  String? catDepKey = logindata.response!.body!.data14!
                      .menulist![i].sections![j].fieldList![k].catDepKey;
                  String? isOther = logindata.response!.body!.data14!
                      .menulist![i].sections![j].fieldList![k].isOther;
                  String? secId = logindata.response!.body!.data14!.menulist![i]
                      .sections![j].fieldList![k].secId;
                  String? listId = logindata.response!.body!.data14!
                      .menulist![i].sections![j].fieldList![k].listId;
                  String? ifListNo = 'N';
                  if (listId!.isNotEmpty) {
                    ifListNo = 'Y';
                  } else {
                    ifListNo = 'N';
                  }

                  String textType = "";
                  String dateboxType = "";
                  String decimalLength = "";
                  String isDependency = "";
                  String? fieldOrder = logindata.response!.body!.data14!
                      .menulist![i].sections![j].fieldList![k].order;
                  String referenceId = "";
                  int? valueDependency = logindata.response!.body!.data14!
                      .menulist![i].sections![j].fieldList![k].valueDependency;
                  String actionPlan = logindata.response!.body!.data14!
                      .menulist![i].sections![j].fieldList![k].staticDepen!;
                  String deadline = "";
                  String answer = "";

                  print("actionplan:" + actionPlan);

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

                  // db.DeleteTable("dynamiccomponentFields");

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
                      fieldOrder!,
                      ifListNo,
                      secId!,
                      listMethodName!,
                      formulaDependency!,
                      parentField!,
                      catDepKey!,
                      isOther!,
                      referenceId,
                      valueDependency!.toString(),
                      "",
                      district!,
                      month!,
                      actionPlan);
                  print("compententsave " + compententsave.toString());
                  print("valueDependency " + valueDependency.toString());
                }
              }
            }
          } catch (e) {}
        }

        if (agentType == "03" || agentType == "05") {
          FCM_TOPIC_Subscribe();
        }

        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString("username", username);
        prefs.setString("password", Password);
        prefs.setString("agentType", agentType!);

        if (isremembered) {
          prefs.setString("rememberme", "true");
        } else {
          prefs.setString("rememberme", "false");
        }

        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (BuildContext context) => DashBoard(
                  '',
                  agentType!,
                )));
      }
    } else if (code == '21002') {
      confirmationPopup(context, " Invalid Device! Need to Register ");
    } else if (code == '11017') {
      confirmationPopup(context, " UNAUTHORIZED AGENT ");
    } else if (code == '51003') {
      confirmationPopup(context, " INVALID CREDENTIAL ");
    } else if (code == '11010') {
      confirmationPopup(context, " AGENT DEVICE MAPPING UNAVAILABLE ");
    }

    EasyLoading.dismiss();
    /*} catch (e) {
      EasyLoading.dismiss();
      print(e.toString());
      confirmationPopup(
          context, "Login Failed! Contact admin for registration");
    }*/
  }

  Future<void> FCM_TOPIC_Subscribe() async {
    print("stateCodeName:" + stateCode);
    List<String> stateCodeL = stateCode.split(',').toList();
    print("stateCodeL:" + stateCodeL.length.toString());
    String stateCodeValue = "";

    for (int s = 0; s < stateCodeL.length; s++) {
      stateCodeValue = stateCodeL[s].toString();
      print("stateCodeValue:" + stateCodeValue);
      await FirebaseMessaging.instance.subscribeToTopic(stateCodeValue);
    }
  }

  Future<void> InsertLanguage(List lang, String menuId) async {
    print("menuId Lang " + menuId);
    for (int k = 0; k < lang.length; k++) {
      String langCode = lang[k]!.langCode!;
      String langValue = lang[k]!.langValue!;
      //db.RawUpdate('DELETE FROM dynamiccomponentLanguage WHERE componentID =  \'' +menuId+'\' and langCode = \''+langCode);
      db.RawUpdate(
          'DELETE FROM dynamiccomponentLanguage WHERE componentID =  \'' +
              menuId +
              '\' and langCode = \'' +
              langCode +
              '\'');
      int compententsave =
          await db.SaveDynamicCompenentLanguage(langCode, langValue, menuId);
      print("compententsave Lang " + compententsave.toString());
    }
  }

  String JwtHS256(String subdata, String hmacKey) {
    final hmac = Hmac(sha256, hmacKey.codeUnits);

    //json.decode({"numberPhone":"+22565786589", "country":"CI"});
    // Use SplayTreeMap to ensure ordering in JSON: i.e. alg before typ.
    // Ordering is not required for JWT: it is deterministic and neater.
    final header =
        SplayTreeMap<String, String>.from(<String, String>{'alg': 'HS256'});
    final claim =
        SplayTreeMap<String, String>.from(<String, String>{'sub': subdata});

    final String encHdr = B64urlEncRfc7515.encodeUtf8(json.encode(header));
    final String encPld = B64urlEncRfc7515.encodeUtf8(json.encode(claim));
    final String data = '${encHdr}.${encPld}';
    final String encSig =
        B64urlEncRfc7515.encode(hmac.convert(data.codeUnits).bytes);
    return data + '.' + encSig;
  }
}

ChangeLoginStatus(bool login) async {
  if (login) {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("LOGIN", "1");
  } else {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("LOGIN", "0");
  }
}

class CurvedShape extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 500,
      child: CustomPaint(
        painter: MyPainter(),
      ),
    );
  }
}

class MyPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()..color = Colors.green;
    canvas.drawArc(
      Rect.fromCenter(
        center: Offset(size.height / 2, size.width / 2),
        height: size.height,
        width: size.width,
      ),
      math.pi,
      math.pi,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class CustomHalfCircleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final Path path = new Path();
    path.lineTo(size.width, size.height / 2);
    path.lineTo(0.0, size.height / 2);
    path.lineTo(size.width, 0);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}

class LogoAsset extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    AssetImage assetimage = const AssetImage('images/UCDA.png');
    Image image = Image(
      image: assetimage,
      width: 135.0,
      height: 80.0,
    );
    return Container(
      //padding: EdgeInsets.only(left: 20.0),
      child: image,
    );
  }
}
