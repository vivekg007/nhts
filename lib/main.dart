import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:app_installer/app_installer.dart';
import 'package:archive/archive.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:connectivity/connectivity.dart';
import 'package:device_info/device_info.dart';
import 'package:dio/dio.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';
import 'package:package_info/package_info.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Database/Databasehelper.dart';
import 'Plugins/RestPlugin.dart';
import 'Utils/MandatoryDatas.dart';
import 'login.dart';

const EVENTS_KEY = "fetch_events";
AppDatas appDatas = new AppDatas();

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();
  String? title = message.notification!.title;
  String? body = message.notification!.body;
  String clickAction = message.data['page'].toString();
  print("click action value:" + clickAction);
  AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: message.notification!.hashCode,
        channelKey: 'call_channel',
        color: Colors.white,
        title: title,
        body: body,
        category: NotificationCategory.Recommendation,
        wakeUpScreen: true,
        fullScreenIntent: true,
        autoDismissible: true,
        backgroundColor: Colors.orange,
        notificationLayout: NotificationLayout.Default,
      ),
      actionButtons: [
        NotificationActionButton(key: clickAction, label: 'View'),
        NotificationActionButton(
            key: 'DISMISS',
            label: 'Dismiss',
            buttonType: ActionButtonType.DisabledAction,
            //actionType: ActionType.DismissAction,
            isDangerousOption: true),
      ]);
  print('Handling a background message ${message.notification}');
}

Future<void> main() async {
  //await dotenv.load(fileName: ".env");

  WidgetsFlutterBinding.ensureInitialized();

  /*notification implementation*/

  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  /*awesome notification implementation*/
  AwesomeNotifications().initialize(null, [
    NotificationChannel(
        channelKey: "call_channel",
        channelName: "Call Channel",
        channelDescription: "Channel of calling",
        defaultColor: Colors.redAccent,
        ledColor: Colors.white,
        importance: NotificationImportance.Max,
        channelShowBadge: true,
        locked: true)
  ]);

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  /*end of notification implementation*/

  runApp(MyApp());
  configLoading();
// Register to receive BackgroundFetch events after app is terminated.
// Requires {stopOnTerminate: false, enableHeadless: true}
// BackgroundFetch.registerHeadlessTask(backgroundFetchHeadlessTask);
}

void configLoading() {
  EasyLoading.instance..userInteractions = false;
}

/// This "Headless Task" is run when app is terminated.

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: appDatas.tenent,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        builder: EasyLoading.init(),
        home: MyHomePage(title: appDatas.tenent));
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  double process = 0;

  bool DBdownload = false;

  String timestamp = '';
  String apkVersion = '';

  String _connectionStatus = 'Unknown';
  String databaseversion_server = '';
  bool _internetconnection = false;
  final Connectivity _connectivity = Connectivity();

  bool latest = false;

  @override
  void initState() {
    super.initState();
    print('main init');
    // WidgetsFlutterBinding.ensureInitialized();
    FlutterDownloader.initialize(debug: true);

    checkpermission();
    initConnectivity();
    initdata();
  }

  void GetDatas(bool apk, String dbVersion, String appVersion) async {
    try {
      // checking transaction count before update
      var db = DatabaseHelper();
      List<Map> custTransactions = await db.GetTableValues('custTransactions');
      print('custTransactions ' + custTransactions.toString());
      if (custTransactions.length == 0) {
        if (apk) {
          var permissions1 = await Permission.requestInstallPackages.status;
          if (permissions1.isGranted) {
            DownloadAPK2(appVersion);
          } else {
            confirmationPopup(context, appVersion);
          }
        } else {
          setState(() {
            DBdownload = false;
          });
          if (appDatas.playstore) {
            CheckDBupdate();
          } else {
            DownloadDB(dbVersion);
          }
          // DownloadDB(dbVersion);
        }
      } else {}
    } catch (e) {
      // for first time
      if (!apk) {
        DownloadDB(dbVersion);
      } else {
        GetLatestVersion();
      }
    }
  }

  checkpermission() async {
    DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
    var sdk = await deviceInfoPlugin.androidInfo;
    print("SDK Version ==>  ${sdk.version.sdkInt}");

    if (sdk.version.sdkInt <= 32) {
      Map<Permission, PermissionStatus> statuses = await [
        Permission.location,
        Permission.storage,
        Permission.microphone,
      ].request();
      if (statuses[Permission.storage]!.isGranted) {
        //DBdownloadedstatus();
        print('checkpermission 2');
        GetLatestVersion();
      } else {
        // GetLatestVersion();
        Navigator.pop(context);
        toast('Storage Permission is denied');
        print('checkpermission 2');
      }
    } else {
      Map<Permission, PermissionStatus> statuses = await [
        Permission.location,
        Permission.notification,
        Permission.storage,
      ].request();
      GetLatestVersion();
    }
  }

  checkAppPermission(String apkVersion) async {
// You can request multiple permissions at once.
    Map<Permission, PermissionStatus> statuses =
        await [Permission.requestInstallPackages].request();
    if (statuses[Permission.requestInstallPackages]!.isGranted) {
      DownloadAPK2(apkVersion);
    } else {
      Navigator.pop(context);
    }
  }

  Future<void> initConnectivity() async {
    ConnectivityResult result = await _connectivity.checkConnectivity();
// Platform messages may fail, so we use a try/catch PlatformException.
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      print(e.toString());
    }
    if (!mounted) {
      return Future.value('');
    }

    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
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

  Future<void> GetLatestVersion() async {
    bool dbDownloadIssue = false;
    try {
      print('checking');
      int count = -1;
      try {
        print("Db downloaded");
        List<Map> custTransactions =
            await db.GetTableValues('custTransactions');
        print('custTransactions $custTransactions');
        count = custTransactions.length;
      } catch (e) {
        dbDownloadIssue = true;
        print("DbException" + e.toString());

        count = 0;
      }
      print('checking ' +
          count.toString() +
          " " +
          _internetconnection.toString());
      if (count == 0 && _internetconnection) {
        restplugin rest = restplugin();
        final String response = await rest.GetLatestVersion();
        print('latestversion $response');
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
        databaseversion_server = serverversionlist[1];

        SharedPreferences prefs = await SharedPreferences.getInstance();
        String? DBVERSION = prefs.getString("DBVERSION");

        if (DBVERSION == null) {
          print('latestversion db: first');
          DBVERSION = '-1';
        }

        print('latestversion app: $serverappversion <> app:$appversion');

        // if (DBVERSION == databaseversion_server) {
        //   print("DownloadDB matched");
        //   setState(() {
        //     DBdownload = true;
        //   });
        // } else {
        //   print("DownloadDB mismatch");
        //
        //   //  GetDatas(false, databaseversion_server);
        //   //
        // }
        if (appversion == serverappversion) {
          print('main latest');
          print("downloaddddd" + dbDownloadIssue.toString());
          latest = true;
          setState(() {});
          /*if (DBdownload) {
            Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (BuildContext context) => LoginStateful()));
          }*/

          if (dbDownloadIssue == true) {
            print("issue in db");
            GetDatas(false, databaseversion_server, serverappversion);
          } else if (DBVERSION == databaseversion_server) {
            Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (BuildContext context) => LoginStateful()));
          } else {
            GetDatas(false, databaseversion_server, serverappversion);
          }
        } else {
          print('main update');
          setState(() {
            latest = false;
          });
          GetDatas(true, databaseversion_server, serverappversion);
        }
      } else {
        print('offline ');
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (BuildContext context) => LoginStateful()));
        latest = true;
        setState(() {});
      }
    } catch (Exception) {
      print('main latest failed $Exception');
      latest = true;
    }
  }

  Future<void> initdata() async {
    String _serialNumber = '';
    restplugin rest = restplugin();
    _serialNumber = await rest.getSerialnumber();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("serialnumber", _serialNumber);
    // prefs.setString("serialnumber", "499ee46858391a2caf9e567589d1db8f");
    print("serialnumber->" + _serialNumber);
    //  toast(_serialNumber);
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString("langCode", "en");
    } catch (e) {
      print('set lang 0');
    }
//
  }

  Future DownloadDB(String newVersion) async {
    try {
      Directory documentsDirectory = await getApplicationDocumentsDirectory();
      String savePath =
          documentsDirectory.path + '/dbagro' + newVersion + '.zip';
      Response response = await Dio().get(
        appDatas.DBdownloadurl,
        onReceiveProgress: showDownloadProgress,

        //Received data with List<int>
        options: Options(
            responseType: ResponseType.bytes,
            followRedirects: false,
            validateStatus: (status) {
              return status! < 500;
            }),
      );
      print(response.headers);
      File file = File(savePath);
      var raf = file.openSync(mode: FileMode.write);
      // response.data is List<int> type
      raf.writeFromSync(response.data);
      await raf.close();

      List<int> bytes = file.readAsBytesSync();
      Archive archive = ZipDecoder().decodeBytes(bytes);
      for (ArchiveFile file in archive) {
        String decodePath =
            documentsDirectory.path + '/dbagro' + newVersion + '.db';
        if (file.isFile) {
          List<int> data = file.content;
          File(decodePath)
            ..createSync(recursive: true)
            ..writeAsBytesSync(data);

          var db = DatabaseHelper();
          List<Map> custTransactions =
              await db.GetTableValues('custTransactions');
          print(
              'txnexecutor custTransactions length  ${custTransactions.length}');
        } else {
          Directory(decodePath)..create(recursive: true);
        }
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> showDownloadProgress(received, total) async {
    if (total != -1) {
      print('DownloadDB ' + (received / total * 100).toStringAsFixed(0) + "%");
      if ((received / total * 100).toStringAsFixed(0) == "100") {
        await db.closeDB();

        EasyLoading.dismiss();
        DBdownload = true;
        if (latest) {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString("DBVERSION", databaseversion_server);

          Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (BuildContext context) => LoginStateful()));
        }
      }
    }
  }

  Future<void> showAPKDownloadProgress(received, total) async {
    if (total != -1) {
      print('DownloadDB ' + (received / total * 100).toStringAsFixed(0) + "%");
      if ((received / total * 100).toStringAsFixed(0) == "100") {
        EasyLoading.dismiss();
      }
    }
  }

  void DownloadAPK2(String Version) async {
    toast('Downloading APK');
    var now = DateTime.now();
    var Timestamp = DateFormat('ddMMyyHHmmss');
    String timestamp = Timestamp.format(now);
    EasyLoading.show(status: 'Downloading APK');
    try {
      Directory? documentsDirectory = await getExternalStorageDirectory();
      String savePath = "${documentsDirectory!.path}/" +
          "ucda_" +
          Version +
          "_" +
          timestamp +
          ".apk";
      Response response = await Dio().get(
        appDatas.apkdownloadurl,
        onReceiveProgress: showAPKDownloadProgress,
        options: Options(
            responseType: ResponseType.bytes,
            followRedirects: false,
            validateStatus: (status) {
              return status! < 500;
            }),
      );
      print('apkDownloadApk ' + response.headers.toString());
      File file = File(savePath);
      var raf = file.openSync(mode: FileMode.write);
      // response.data is List<int> type
      raf.writeFromSync(response.data);
      await raf.close();
      onClickInstallApk(Version, timestamp);
    } catch (e) {
      print('apkErr ' + e.toString());
    }
  }

  void onClickInstallApk(String Version, String timestamp) async {
    // String _apkFilePath = appDatas.apkname;
    String _apkFilePath = "ucda_" + Version + "_" + timestamp + ".apk";
    toast('Installing APK');
    print('Installing APK onClickInstallApk');
    if (_apkFilePath.isEmpty) {
      print('make sure the apk file is set');
      return;
    }
    // var permissions = await Permission.storage.status;
    // if (permissions.isGranted) {
    var storageDir = await getExternalStorageDirectory();
    final dirPath = storageDir?.path ?? '/';

    final resultPath = '$dirPath' + '/' + '$_apkFilePath';

    var file = File(resultPath);
    var isExists = await file.exists();
    print('onClickInstallApk _apkFilePath $resultPath exists $isExists');
    Directory? documentsDirectory = await getExternalStorageDirectory();
    String savePath = documentsDirectory!.path +
        "/ucda_" +
        Version +
        "_" +
        timestamp +
        ".apk";
    AppInstaller.installApk(savePath);
    // } else {
    //   toast('Permission request fail!');
    // }
  }

  @override
  void dispose() {
    IsolateNameServer.removePortNameMapping('downloader_send_port');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.green, // navigation bar color
      statusBarColor: Colors.transparent,
    ));
// TODO: implement build
    return Scaffold(
      body: Builder(
// Create an inner BuildContext so that the onPressed methods
// can refer to the Scaffold with Scaffold.of().
        builder: (BuildContext context) {
          return Stack(
            children: [
              Center(
                child: Container(
                    color: Colors.white,
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Expanded(
                            flex: 4,
                            child: ShaderMask(
                              shaderCallback: (rect) {
                                return LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [Colors.black, Colors.transparent],
                                ).createShader(Rect.fromLTRB(
                                    0, 0, rect.width, rect.height));
                              },
                              blendMode: BlendMode.dstIn,
                              child: Image.asset(
                                'images/agrobg.jpg',
                                fit: BoxFit.cover,
                                height: double.infinity,
                                width: double.infinity,
                                alignment: Alignment.center,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 8,
                            child: Column(
                              children: <Widget>[
                                Container(
                                  alignment: Alignment.topCenter,
                                  child: SizedBox(
                                    width: MediaQuery.of(context).size.width,
                                    child: TextLiquidFill(
                                      text: appDatas.appname,
                                      waveColor: Colors.green,
                                      boxBackgroundColor: Colors.white,
                                      textStyle: TextStyle(
                                        fontSize: 60.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      boxHeight: 200.0,
                                    ),
                                  ),
                                ),
                                Container(
                                  alignment: Alignment.centerRight,
                                  child: SizedBox(
                                      width: 250.0,
                                      child: AnimatedTextKit(
                                        animatedTexts: [
                                          TypewriterAnimatedText(
                                            'Powered by SourceTrace',
                                            textStyle: const TextStyle(
                                              fontSize: 32.0,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            speed: const Duration(
                                                milliseconds: 2000),
                                          ),
                                        ],
                                        totalRepeatCount: 4,
                                        pause:
                                            const Duration(milliseconds: 1000),
                                        displayFullTextOnTap: true,
                                        stopPauseOnTap: true,
                                      )),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                              flex: 1,
                              child: DBdownload
                                  ? Container() //true
                                  : Container(
                                      //false
                                      child: LiquidLinearProgressIndicator(
                                        value: process,
// Defaults to 0.5.
                                        valueColor: AlwaysStoppedAnimation(
                                            Colors.green),
// Defaults to the current Theme's accentColor.
                                        backgroundColor: Colors.white,
// Defaults to the current Theme's backgroundColor.
                                        borderColor: Colors.green,
                                        borderWidth: 5.0,
                                        direction: Axis.horizontal,
// The direction the liquid moves (Axis.vertical = bottom to top, Axis.horizontal = left to right). Defaults to Axis.vertical.
                                        center: Text("Downloading Database..."),
                                      ),
                                    ))
                        ])),
              ),
              // Positioned(
              //   child: _progressHUD,
              // ),
            ],
          );
        },
      ),
    );
  }

  confirmationPopup(dialogContext, String apkVersion) {
    var alertStyle = AlertStyle(
      animationType: AnimationType.shrink,
      overlayColor: Colors.black87,
      isCloseButton: false,
      isOverlayTapDismiss: false,
      titleStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
      descStyle: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
      animationDuration: Duration(milliseconds: 400),
    );

    Alert(
        context: dialogContext,
        style: alertStyle,
        title: "Update ",
        desc: "New update is available ! Please update the application",
        buttons: [
          DialogButton(
            child: Text(
              "UPDATE NOW",
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            //onPressed:btnok,
            onPressed: () async {
              Navigator.pop(dialogContext);
              checkAppPermission(apkVersion);
            },
            color: Colors.green,
          )
        ]).show();
  }

  CheckDBupdate() async {
    // if(appDatas.playstore_release){
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String version = packageInfo.version;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? olderAPKversion = prefs.getString("olderAPKversion");
    if (olderAPKversion == null) {
      olderAPKversion = '0';
    }
    List<String> versionlist = version
        .split(
            '.') // split the text into an array/ put the text inside a widget
        .toList();
    String APKversion = versionlist[0];
    print('DB UPDATE : ' + APKversion.toString());
    if (APKversion != olderAPKversion) {
      for (int i = int.parse(olderAPKversion);
          i <= int.parse(APKversion);
          i++) {
        if (i == 4) {
        } else if (i == 6) {
        } else if (i == 7) {}
      }
    }
    prefs = await SharedPreferences.getInstance();
    prefs.setString("olderAPKversion", APKversion);

    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (BuildContext context) => LoginStateful()));

    // }
  }
}

void toast(String message) {
  Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.TOP,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.grey,
      textColor: Colors.white,
      fontSize: 12.0);
}

String ChangeDecimalTwo(String value) {
  final formatter = new NumberFormat("0.0000");
  String values = formatter.format(double.parse(value));
  return values;
}
