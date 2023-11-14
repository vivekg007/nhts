import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:connectivity/connectivity.dart';
import 'package:dio/dio.dart' as p;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:package_info/package_info.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:share_extend/share_extend.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ucda/Screens/activitymenu.dart';
import 'package:ucda/Screens/coffeePurchase.dart';
import 'package:ucda/Screens/dynamicScreengetdata.dart';
import 'package:ucda/Screens/exporterPurchase.dart';
import 'package:ucda/Screens/exporterReception.dart';
import 'package:ucda/Screens/farmerkettlle.dart';
import 'package:ucda/Screens/farmkettle.dart';
import 'package:ucda/Screens/nurserySeedGarden.dart';
import 'package:ucda/Screens/processingShiftOperations.dart';
import 'package:ucda/Screens/recp.dart';
import 'package:ucda/Screens/secondaryProcessing.dart';
import 'package:ucda/Screens/surveyMenu.dart';
import 'package:ucda/Screens/transactionsummary.dart';

import '../../../login.dart';
import '../Database/Databasehelper.dart';
import '../Database/Model/AnimalCatalogModel.dart';
import '../Database/Model/CropListmodel.dart';
import '../Database/Model/FarmerMaster.dart';
import '../Plugins/RestPlugin.dart';
import '../Plugins/TxnExecutor.dart';
import '../ResponseModel/Croplistvalues.dart';
import '../ResponseModel/Download322Model.dart';
import '../ResponseModel/FarmResponseModel.dart';
//import '../ResponseModel/LoginResponseModel/ResponseModel/farmerlistresponse.dart';
import '../ResponseModel/LoginResponseModel.dart';
import '../ResponseModel/farmerlistresponse.dart';
import '../main.dart';
import 'ChangePassword.dart';
import 'Transfertoprimaryprocss.dart';
import 'entityFarm.dart';
import 'farmerlist.dart';
import 'inputDemand.dart';

bool timeStarted = false;

class DashBoard extends StatefulWidget {
  String name, agentid;

  DashBoard(
    this.name,
    this.agentid,
  );

  @override
  _DashBoardAppState createState() => _DashBoardAppState();
}

class _DashBoardAppState extends State<DashBoard> with WidgetsBindingObserver {
  var db = DatabaseHelper();
  farmerlistresponsemodel? farmers;
  CroplistValues? croplistvalues;
  bool _internetconnection = false;
  List<String> _events = [];
  String _connectionStatus = 'Unknown';
  final Connectivity _connectivity = Connectivity();
  int _status = 0;

  bool datadownload = false;
  String transactioncount = '0';
  bool synced = false;
  StreamSubscription<ConnectivityResult>? _connectivitySubscription;
  bool updateAvl = false;

  String ok = 'Ok';
  String availupd = 'Update Available';
  String appavl = 'An Application update available Please logout';
  String farmerIdMsg =
      'Enrollment reached the Maximum Limit. Please relogin in online mode to continue the Enrollment';
  String info = 'Information';
  String goodmorning = 'Good Morning..';
  String goodevening = 'Good Evening..';
  String goodafternoon = 'Good Afternoon..';
  String logout = 'Logout';
  String rusurelogout = "Are you sure want to Logout?";
  String farmerenrollment = 'Farmer Enrollment';
  String addfarm = 'Add Farm';
  String inputdistribution = 'Input Distribution';
  String procurement = 'Procurement';
  String producttransfer = 'Product Transfer';
  String tripMenu = 'Trip';
  String transactionhistory = 'Transaction History';
  String farmerlist = 'Farmer List';
  String transactionsummary = 'Transaction Summary';
  String fieldstaffactivity = 'Field Staff Activity';
  String nointernet = 'No internet connection';
  String failedconnection = 'Failed to get connectivity.';
  String downloadingdata = 'Downloading data';
  String downloadingfarmdata = 'Downloading Farm data';
  String yes = 'Yes';
  String no = 'No';
  String cancel = 'Exit';
  String rusurecancel = 'Are you sure want to Exit the App?';
  String PendingTransaction = 'Pending Transaction';
  String sync = 'Sync';
  String nostock =
      'No stock available for distribution. Please add stock for the product.';
  String samplemenu = 'Sample Menu';
  String farminspection = 'Farm inspection';
  String training = 'Training';
  String organicaudit = 'Organic Audit';
  String fieldsurvey = 'Field Survey - For Auditor';
  String loadingstring = 'Loading';
  String chpassword = 'Change Password';
  String settings = 'Settings';
  String streamLat = "", streamLng = "";
  String timeStamp = "";

  int farmerId = 0;

  String versionName = "";
  String menuID = "";
  List<Menus> menus = [];

  List<Map>? dynamiccomponentMenus = [];
  List<InspectionModel> inspectionModel = [];

  String agentType = "0";
  List<Menus> menu1 = [];

  bool isNotificationRecieved = false;
  List<LatLng> streamLocation = [];

  String Lat = '0', Lng = '0';
  int i = 1;

  String timeS = "";

  @override
  void initState() {
    super.initState();

    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
    initConnectivity();
    GetDatas();
    GetAppversion();
    backgroundfetch();

    WidgetsBinding.instance.addObserver(this);
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.white, // navigation bar color
      statusBarColor: Colors.green, // status bar color
    ));

    final now = DateTime.now();
    currentdate = DateFormat('dd MMM, yyyy').format(now);
    currenttime = DateFormat('hh:mm:a').format(now);
    var CURRENTTIME = currenttime.split(':');
    if (CURRENTTIME[2] == 'AM') {
      timetype = goodmorning;
    } else {
      int hour = int.parse(CURRENTTIME[0]);
      if (hour > 4) {
        timetype = goodevening;
      } else {
        timetype = goodafternoon;
      }
    }

    translate();
    checkpendingtransaction();
    checkLatestVersion();
    backgroundfetch();
    getVersionData();
    getStartTime();

    drawerlist.add(DrawerListModel(
        name: "Change Password", iconData: Icons.phonelink_lock));
    drawerlist.add(
        DrawerListModel(name: "Export Data", iconData: Icons.import_export));
    drawerlist.add(DrawerListModel(name: logout, iconData: Icons.lock_outline));
    drawerlist.add(DrawerListModel(name: "Start Time", iconData: Icons.start));
    drawerlist.add(DrawerListModel(
        name: "End Time", iconData: Icons.file_download_done_sharp));
    menuConfiguration();

    //firebase notification configuration

    firebaseNotification();
  }

  firebaseNotification() {
    // if (agentType == "03" || agentType == "05") {
    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage? message) {
      if (message != null) {
        print("message value:" + message.data.toString());
      }
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification notification = message.notification!;
      AndroidNotification android = message.notification!.android!;

      String clickAction = message.data['page'].toString();
      print("click action value:" + clickAction);

      String page = message.data['click_action'].toString();
      print("page value:" + page);

      if (notification != null &&
          android != null &&
          agentType == "03" &&
          clickAction == "1") {
        print("notification called");
        isNotificationRecieved = true;
        print("notification recievedv :" + isNotificationRecieved.toString());
        notificationRecievedSync();
        inspectionSync();
        String? title = message.notification!.title;
        String? body = message.notification!.body;
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
                  isDangerousOption: true)
            ]);
      } else if (notification != null &&
          android != null &&
          agentType == "03" &&
          clickAction == "0") {
        print("notification called");

        isNotificationRecieved = true;
        print("notification recieved :" + isNotificationRecieved.toString());
        notificationRecievedSync();
        inspectionSync();
        String? title = message.notification!.title;
        String? body = message.notification!.body;
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
                  isDangerousOption: true)
            ]);
      }
      AwesomeNotifications().actionStream.listen((event) {
        if (event.buttonKeyPressed == '0') {
          Future.delayed(Duration(seconds: 3), () {
            inspectionSync();
            Navigator.of(context).push(MaterialPageRoute(
                builder: (BuildContext context) => InputDemand1()));
          });
        } else if (event.buttonKeyPressed == '1') {
          print("nursery seed garden called");
          inspectionSync();
          Future.delayed(Duration(seconds: 3), () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (BuildContext context) => nurserySeedGarden()));
          });
        } else {
          print("Clicked on notification");
        }
      });
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('A new onMessageOpenedApp nursery event was published!' +
          message.data.toString());
    });
  }
  // }

  notificationRecievedSync() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String agentType = prefs.getString('agentType').toString();

    if (isNotificationRecieved &&
        _internetconnection &&
        (agentType == "03" || agentType == "05")) {
      inspectionSync();
    }
  }

  void inspectionSync() async {
    print("checksyncfunction");
    try {
      var db = DatabaseHelper();
      List<Map> custTransactions = await db.GetTableValues('custTransactions');
      if (custTransactions.isEmpty) {
        // EasyLoading.show(status: 'downloading data...');
        print("Download322date_sync");

        restplugin rest = restplugin();
        String response = await rest.Download322();
        printWrapped("Download322 " + response);
        Map<String, dynamic> json = jsonDecode(response);

        Download322 clientmodel = Download322.fromJson(json);

        db.DeleteTable('inspReqData');
        print("clientmodel.response!.body!.data10!.inspReqData!.length" +
            clientmodel.response!.body!.data10!.inspReqData!.length.toString());
        for (int r = 0;
            r < clientmodel.response!.body!.data10!.inspReqData!.length;
            r++) {
          String insVill =
              clientmodel.response!.body!.data10!.inspReqData![r].insVill!;
          String insId =
              clientmodel.response!.body!.data10!.inspReqData![r].insId!;
          String insParish =
              clientmodel.response!.body!.data10!.inspReqData![r].insParish!;
          String insName =
              clientmodel.response!.body!.data10!.inspReqData![r].insName!;
          String stockType =
              clientmodel.response!.body!.data10!.inspReqData![r].capacity! ??
                  "";
          String insCerNo =
              clientmodel.response!.body!.data10!.inspReqData![r].insCerNo!;
          String insType =
              clientmodel.response!.body!.data10!.inspReqData![r].insType!;
          String insTypeValue = "";
          if (insType == "0") {
            insTypeValue = "Seed Garden";
          } else {
            insTypeValue = "Nursery";
          }
          String insSubCnt =
              clientmodel.response!.body!.data10!.inspReqData![r].insSubCnt!;
          String insDist =
              clientmodel.response!.body!.data10!.inspReqData![r].insDist!;
          String insAppName =
              clientmodel.response!.body!.data10!.inspReqData![r].insAppName!;
          String insUniqueId =
              clientmodel.response!.body!.data10!.inspReqData![r].insUniqueId!;

          inspectionModel.clear();

          var inspection = InspectionModel(
              applicantName: insAppName,
              applicantType: insTypeValue,
              appCertNo: insUniqueId);
          inspectionModel.add(inspection);
          db.inspReqData(
              insVill: insVill,
              insId: insId,
              insParish: insParish,
              insName: insName,
              stockType: stockType,
              insCerNo: insCerNo,
              insType: insType,
              insSubCnt: insSubCnt,
              insDist: insDist,
              insAppName: insAppName,
              insUniqueId: insUniqueId);
        }
        db.DeleteTable('inputDemandList');

        if (clientmodel.response!.body!.data10!.inputDemandList!.length > 0) {
          for (int d = 0;
              d < clientmodel.response!.body!.data10!.inputDemandList!.length;
              d++) {
            String? date =
                clientmodel.response!.body!.data10!.inputDemandList![d].date! ??
                    "";
            print("date value:" + date);
            String? gender = clientmodel
                    .response!.body!.data10!.inputDemandList![d].gender! ??
                "";
            String? farmerCode = clientmodel
                    .response!.body!.data10!.inputDemandList![d].fr_code! ??
                "";
            String? warehouse = clientmodel
                    .response!.body!.data10!.inputDemandList![d].wareHouse! ??
                "";
            String? nin =
                clientmodel.response!.body!.data10!.inputDemandList![d].nin! ??
                    "";
            String? productCode = clientmodel
                    .response!.body!.data10!.inputDemandList![d].productCode! ??
                "";
            String? inputType = clientmodel
                    .response!.body!.data10!.inputDemandList![d].input_Type! ??
                "";
            double dem = double.parse(clientmodel
                .response!.body!.data10!.inputDemandList![d].demandQty!);
            String? demandQty = dem.toStringAsFixed(3);

            String? receiptNo = clientmodel
                    .response!.body!.data10!.inputDemandList![d].receiptNo! ??
                "";
            String? contactNumber = clientmodel.response!.body!.data10!
                    .inputDemandList![d].contactNumber! ??
                "";
            String? village = clientmodel
                    .response!.body!.data10!.inputDemandList![d].village! ??
                "";
            String? age =
                clientmodel.response!.body!.data10!.inputDemandList![d].age! ??
                    "";
            String? did =
                clientmodel.response!.body!.data10!.inputDemandList![d].dId! ??
                    "";
            String? districtCode = clientmodel!.response!.body!.data10!
                    .inputDemandList![d].districtCode! ??
                "";

            String? distQty = "";

            db.InputDemandDetail(
                batchNo: receiptNo,
                village: village,
                farmerId: farmerCode,
                gender: gender,
                age: age,
                nin: nin,
                mobNo: contactNumber,
                product: productCode,
                inputType: inputType,
                demandQty: demandQty,
                distQty: did,
                date: date,
                warehouseId: warehouse,
                districtCode: districtCode);
          }
        }
      } else {}
    } catch (e) {
      // EasyLoading.dismiss();
      print("checksynccatch");
    }
  }

  translate() async {
    try {
      String? Lang = '';
      try {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        Lang = prefs.getString("langCode") ?? "en";
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
          case 'availupd':
            setState(() {
              availupd = labelName;
            });
            break;
          case 'appavl':
            setState(() {
              appavl = labelName;
            });
            break;
          case 'farmerIdMsg':
            setState(() {
              farmerIdMsg = labelName;
            });
            break;
          case 'goodmorning':
            setState(() {
              goodmorning = labelName;
            });
            break;
          case 'goodevening':
            setState(() {
              goodevening = labelName;
            });
            break;
          case 'goodafternoon':
            setState(() {
              goodafternoon = labelName;
            });
            break;
          case 'logout':
            setState(() {
              logout = labelName;
            });
            break;
          case 'rusurelogout':
            setState(() {
              rusurelogout = labelName;
            });
            break;
          case 'inputdistribution':
            setState(() {
              inputdistribution = labelName;
            });
            break;
          case 'procurement':
            setState(() {
              procurement = labelName;
            });
            break;
          case 'producttransfer':
            setState(() {
              producttransfer = labelName;
            });
            break;
          case 'trip':
            setState(() {
              tripMenu = labelName;
            });
            break;
          case 'transactionhistory':
            setState(() {
              transactionhistory = labelName;
            });
            break;
          case 'farmerlist':
            setState(() {
              farmerlist = labelName;
            });
            break;
          case 'transactionsummary':
            setState(() {
              transactionsummary = labelName;
            });
            break;
          case 'fieldstaffactivity':
            setState(() {
              fieldstaffactivity = labelName;
            });
            break;
          case 'nointernet':
            setState(() {
              nointernet = labelName;
            });
            break;
          case 'failedconnection':
            setState(() {
              failedconnection = labelName;
            });
            break;
          case 'ok':
            setState(() {
              ok = labelName;
            });
            break;
          case 'farmerenrollment':
            setState(() {
              farmerenrollment = labelName;
            });
            break;
          case 'addfarm':
            setState(() {
              addfarm = labelName;
            });
            break;
          case 'downloadingdata':
            setState(() {
              downloadingdata = labelName;
            });
            break;
          case 'downloadingfarmdata':
            setState(() {
              downloadingfarmdata = labelName;
            });
            break;
          case 'yes':
            setState(() {
              yes = labelName;
            });
            break;
          case 'no':
            setState(() {
              no = labelName;
            });
            break;
          case 'cancel':
            setState(() {
              cancel = labelName;
            });
            break;
          case 'rusurecancel':
            setState(() {
              rusurecancel = labelName;
            });
            break;
          case 'PendingTransaction':
            setState(() {
              PendingTransaction = labelName;
            });
            break;
          case 'sync':
            setState(() {
              sync = labelName;
            });
            break;
          case 'nostock':
            setState(() {
              nostock = labelName;
            });
            break;
          case 'samplemenu':
            setState(() {
              samplemenu = labelName;
            });
            break;
          case 'farminspection':
            setState(() {
              farminspection = labelName;
            });
            break;
          case 'training':
            setState(() {
              training = labelName;
            });
            break;
          case 'organicaudit':
            setState(() {
              organicaudit = labelName;
            });
            break;
          case 'fieldsurvey':
            setState(() {
              fieldsurvey = labelName;
            });
            break;
          case 'chpassword':
            setState(() {
              chpassword = labelName;
            });
            break;
          case 'settings':
            setState(() {
              settings = labelName;
            });
            break;
        }
      }

      drawerlist.clear();
      drawerlist.add(
        DrawerListModel(
            name: 'Change Password', iconData: Icons.phonelink_lock),
      );
      drawerlist.add(
        DrawerListModel(name: logout, iconData: Icons.lock_outline),
      );
      drawerlist.add(
          DrawerListModel(name: "Export Data", iconData: Icons.import_export));

      drawerlist
          .add(DrawerListModel(name: "Start Time", iconData: Icons.start));

      drawerlist
          .add(DrawerListModel(name: "End Time", iconData: Icons.e_mobiledata));
      loadDynamicmenus();
    } catch (e) {
      loadDynamicmenus();
      print('translation err' + e.toString());
    }
  }

  Future<void> getVersionData() async {
    restplugin rest = restplugin();
    final String response = await rest.GetLatestVersion();
    print('latestversion ' + response);
    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    versionName = "Version: " + packageInfo.version;
    print('versionName ' + versionName);
  }

  getStartTime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    timeS = prefs.getString("Start").toString();

    if (timeS == "null") {
      setState(() {
        timeS = "0";
      });
    }
  }

  Future<void> menuConfiguration() async {
    print("timestartedtimestarted:" + timeS);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    agentType = prefs.getString("agentType")!;
    print('agentType' + agentType);

    //dynamic menu

    String? Lang = 'en';
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      Lang = prefs.getString("langCode") ?? "en";
    } catch (e) {
      Lang = 'en';
    }
    print("Lang code menu " + Lang!);
    dynamiccomponentMenus = [];
    menus = [];

    String qrymenulist =
        'select dc.menuId,IFNULL(dl.langValue,dc.menuName) as menuName,dc.iconClass,dc.menuOrder,dc.txnTypeIdMenu,dc.menucommonClass,' +
            ' dc.entity,dc.seasonFlag,dc.agentType from dynamiccomponentMenu as dc left join dynamiccomponentLanguage ' +
            'as dl on dc.menuId=dl.componentID and dl.langCode= \'' +
            Lang +
            '\' and dc.agentType= \'' +
            agentType +
            '\'';
    dynamiccomponentMenus = await db.RawQuery(qrymenulist);

    print("dynamiccomponentMenus!.length Lang menu " +
        dynamiccomponentMenus!.length.toString());
    print("dynamiccomponentMenus " + dynamiccomponentMenus!.toString());

    try {
      menu1.clear();
      setState(() async {
        String buyingCenter = agentType;
        List dyMenu = await db.RawQuery(
            'select  * from dynamiccomponentMenu where agentType LIKE "%$buyingCenter%" and is_survey ="0" ');
        print("dymenu:" + dyMenu.length.toString());
        switch (agentType) {
          case "02": //pcda
            menu1.add(Menus(
                menuName: "Coffee Farmer",
                menuImage: 'images/farmer.png',
                menutxnId: "308"));

            menu1.add(Menus(
                menuName: "Coffee Farm",
                menuImage: 'images/diredleaves.png',
                menutxnId: "359"));

            menu1.add(Menus(
                menuName: "Survey Menu",
                menuImage: 'images/report.png',
                menutxnId: "SM"));

            menu1.add(Menus(
                menuName: "Other Activities",
                menuImage: 'images/farmer.png',
                menutxnId: "400"));

            menu1.add(Menus(
                menuName: farmerlist,
                menuImage: 'images/report.png',
                menutxnId: "FA"));

            menu1.add(Menus(
                menuName: transactionsummary,
                menuImage: 'images/report.png',
                menutxnId: "TS"));
            break;
          case "03": //ceo

            menu1.add(Menus(
                menuName: "Coffee Farmer",
                menuImage: 'images/farmer.png',
                menutxnId: "308"));

            menu1.add(Menus(
                menuName: "Coffee Farm",
                menuImage: 'images/diredleaves.png',
                menutxnId: "359"));

            menu1.add(Menus(
                menuName: "Input Demand / Distribution",
                menuImage: 'images/inspection.png',
                menutxnId:
                    "501")); // _IDe to differentiate txn with same txnType

            menu1.add(Menus(
                menuName: "Seed Garden / Nursery Inspection",
                menuImage: 'images/stocks.png',
                menutxnId: "317"));

            for (int i = 0; i < dyMenu.length; i++) {
              menu1.add(Menus(
                  menuName: dyMenu[i]['menuName'],
                  menuImage: ceoImage[i].toString(),
                  menutxnId: dyMenu[i]['txnTypeIdMenu']));
            }
            menu1.add(Menus(
                menuName: "Survey Menu",
                menuImage: 'images/report.png',
                menutxnId: "SM"));

            menu1.add(Menus(
                menuName: "Other Activities",
                menuImage: 'images/farmer.png',
                menutxnId: "400"));

            menu1.add(Menus(
                menuName: "Entity Farm Registration",
                menuImage: 'images/diredleaves.png',
                menutxnId: "300"));

            menu1.add(Menus(
                menuName: farmerlist,
                menuImage: 'images/report.png',
                menutxnId: "FA"));
            menu1.add(Menus(
                menuName: transactionsummary,
                menuImage: 'images/report.png',
                menutxnId: "TS"));
            break;
          case "04": //cto

            for (int i = 0; i < dyMenu.length; i++) {
              menu1.add(Menus(
                  menuName: dyMenu[i]['menuName'],
                  menuImage: ctoImage[i].toString(),
                  menutxnId: dyMenu[i]['txnTypeIdMenu']));

              // menu1.add(Menus(
              //     menuName: "Survey Menu",
              //     menuImage: 'images/report.png',
              //     menutxnId: "SM"));

            }
            menu1.add(Menus(
                menuName: "Survey Menu",
                menuImage: 'images/report.png',
                menutxnId: "SM"));
            menu1.add(Menus(
                menuName: "Other Activities",
                menuImage: 'images/farmer.png',
                menutxnId: "400"));
            menu1.add(Menus(
                menuName: transactionsummary,
                menuImage: 'images/report.png',
                menutxnId: "TS"));
            break;
          case "05": //vca
            menu1.add(Menus(
                menuName: "Reception",
                menuImage: 'images/stocks.png',
                menutxnId: "377"));

            menu1.add(Menus(
                menuName: "Primary Processing",
                menuImage: 'images/procurement.png',
                menutxnId: "360"));

            menu1.add(Menus(
                menuName: "Exporter Purchase",
                menuImage: 'images/sensitizing.png',
                menutxnId: "376"));

            menu1.add(Menus(
                menuName: transactionsummary,
                menuImage: 'images/report.png',
                menutxnId: "TS"));
            break;

          case "06": //coop
            menu1.add(Menus(
                menuName: "Coffee Purchase",
                menuImage: 'images/sensitizing.png',
                menutxnId: "316"));

            menu1.add(Menus(
                menuName: transactionsummary,
                menuImage: 'images/report.png',
                menutxnId: "TS"));
            break;

          case "08": //vca

            menu1.add(Menus(
                menuName: "Exporter Reception",
                menuImage: 'images/stocks.png',
                menutxnId: "377"));

            menu1.add(Menus(
                menuName: "Secondary Processing",
                menuImage: 'images/stocks.png',
                menutxnId: "360"));

            menu1.add(Menus(
                menuName: transactionsummary,
                menuImage: 'images/report.png',
                menutxnId: "TS"));
            break;
        }
      });
    } catch (e) {
      //  toast(e.toString());
    }
  }

  Future<int> farmerIdGeneration() async {
    List<Map> agents = await db.RawQuery('SELECT * FROM agentMaster');
    String temp = agents[0]['curIdSeqF'];
    int curId = int.parse(agents[0]['curIdSeqF']);
    int resId = int.parse(agents[0]['resIdSeqF']);
    int curIdLim = int.parse(agents[0]['curIdLimitF']);
    int newIdGen = 0;
    int incGenId = curId + 1;
    int curIdLimited = 0;
    int MAX_Limit = 0;
    if (incGenId <= curIdLim) {
      newIdGen = incGenId;
      farmerId = newIdGen;
      print("if farmerId:" + farmerId.toString());
    } else {
      if (resId != 0) {
        newIdGen = resId + 1;
        curId = newIdGen;
        curIdLimited = resId + MAX_Limit;
        resId = 0;
        farmerId = newIdGen;
        print("else farmerId:" + farmerId.toString());
      } else {
        farmerId = newIdGen;
        print("else farmerId:" + farmerId.toString());
      }
    }
    return farmerId;
  }

  Future<void> GetAppversion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      appversion = packageInfo.version;
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
                  ok,
                  style: const TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
            ],
          ).show();
        }
      }
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print('state ' + state.toString());
    switch (state) {
      case AppLifecycleState.resumed:
        print('lifecycle resume');

        getstreamLocation();

        break;
      case AppLifecycleState.inactive:
        print('lifecycle inactive');
        getstreamLocation();
        break;
      case AppLifecycleState.paused:
        print('lifecycle paused');
        getstreamLocation();
        break;
      case AppLifecycleState.detached:
        print('lifecycle detached');

        getstreamLocation();

        break;
    }
  }

  TabController? tabController;
  static const PrimaryColor = Colors.green;
  String currentdate = "  ";
  String currenttime = "  ";
  String appversion = "-";
  String timetype = " ";
  Map<String, double> dataMap = Map();
  List<Color> colorList = [];
  List list = [];
  String pendingTransaction = '0';

  List<String> ctoImage = [
    "images/training.png",
    "images/inspection.png",
    "images/stocks.png",
    "images/training.png",
    "images/stocks.png",
    "images/stocks.png",
    "images/survey.png",
    "images/survey.png",
    "images/survey.png",
    "images/survey.png",
    "images/survey.png",
    "images/survey.png",
    "images/survey.png",
  ];
  List<String> ceoImage = [
    "images/inspection.png",
    "images/costassessment.png",
    "images/training.png",
    "images/stocks.png",
    "images/training.png",
    "images/stocks.png",
    "images/stocks.png",
    "images/survey.png",
    "images/survey.png",
    "images/survey.png",
    "images/survey.png",
    "images/survey.png",
    "images/survey.png",
    "images/survey.png",
  ];
  // List<String> menus = [
  //"Farmer Enrollment", //completed
  //"Add Farm", //completed
  //"Sowing", //completed
  //"Input Distribution", //completed
  //"Input Return", // --pavithra completed
  //"Cost of Cultivation", //--kirubha
  // "Farm Inspection", // --gokul
  //"Crop Harvest", //completed
  // "Crop Sale", // -- hari completed
  //"Procurement", //completed
  //"Product Transfer", //completed
  //"Payment", //completed
  //"Certification", // --- not started
  // "Training Topics",
  //"Sensitizing", //completed
  //"Crop Calendar Activity", // --pavithra
  //"Crop Calendar", //completed
  //"Show Nearby Farms", // --- not started
  //"Weather Information",
  //"Transaction History",
  //"Stock Report", // --- not started
  //"Cost Assessment", // --kirubha
  //"Farmer List",
  //"Transaction Summary",
  //"Field Staff Activity",
  //];
  List<String> menuimage = [
    "images/survey.png",
    "images/survey.png",
    "images/survey.png",
    "images/survey.png",
    "images/inspection.png",
    "images/costassessment.png",
    "images/training.png",
    "images/inspection.png",
    "images/stocks.png",
    "images/training.png",
    "images/stocks.png",
    "images/stocks.png",
    "images/sensitizing.png",
    "images/invoice.png",
    "images/harvest.png",
    "images/cropsale.png",
    "images/procurement.png",
    "images/truck.png",
    "images/payment.png",
    "images/certificate.png",
    "images/sensitizing.png",
    "images/calendar.png",
    "images/calendar.png",
    "images/nearfarms.png",
    "images/weather.png",
    "images/moneytransfer.png",
    "images/report.png",
    "images/costassessment.png",
    "images/farmer.png",
    "images/report.png",
  ];
  List drawerlist = [];

  GlobalKey<ScaffoldState> _globalKey = GlobalKey();

  void fetchData() async {
    var db = DatabaseHelper();
    list = await db.getCatelog();
    print('CHECKLISST ' + (list.toString()));
  }

  Future<void> loadDynamicmenus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? Lang = 'en';
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      Lang = prefs.getString("langCode") ?? "en";
    } catch (e) {
      Lang = 'en';
    }
    print("Lang code menu " + Lang!);
    dynamiccomponentMenus = [];
    menus = [];

    String qrymenulist =
        'select dc.menuId,IFNULL(dl.langValue,dc.menuName) as menuName,dc.iconClass,dc.menuOrder,dc.txnTypeIdMenu,dc.menucommonClass,' +
            ' dc.entity,dc.seasonFlag,dc.agentType from dynamiccomponentMenu as dc left join dynamiccomponentLanguage ' +
            'as dl on dc.menuId=dl.componentID and dl.langCode= \'' +
            Lang +
            '\' and dc.agentType= \'' +
            Lang +
            '\'';
    dynamiccomponentMenus = await db.RawQuery(qrymenulist);

    print("dynamiccomponentMenus!.length Lang " +
        dynamiccomponentMenus!.length.toString());
    print("dynamiccomponentMenus " + dynamiccomponentMenus!.toString());

    //menus.add("Coffee Farmer");
    // menus.add("Coffee Farm");
    // menus.add(inputdistribution);
    // menus.add("Planting");
    // menus.add("MRL Inspection");
    // menus.add("Procurement");
    // menus.add("Withering");
    // menus.add("CTC");
    // menus.add("CFM");
    // menus.add("Dryer");
    // menus.add("Raw Purchase");
    // menus.add("Raw Seed Transfer");
    // menus.add("Raw Seed Reception");
    // menus.add("Cleaned seed Warehouse");
    // menus.add("Seed Demand");
    // menus.add("Seed Booking");
    // menus.add("Sr.Agronomist agro card");

    //menus.add("Coffee Purchase");
    //menus.add("Transfer to Primary Processing");
    //menus.add("Reception");
    // menus.add("Stock Report");

    // menus.add("Batch Creation");
    //menus.add("Input Demand");
    //menus.add("Input Distribution");

    for (int i = 0; i < dynamiccomponentMenus!.length; i++) {
      String menuName = dynamiccomponentMenus![i]["menuName"].toString();
      String iconClass = dynamiccomponentMenus![i]["iconClass"].toString();
      String txnTypeIdMenu =
          dynamiccomponentMenus![i]["txnTypeIdMenu"].toString();
      menuID = dynamiccomponentMenus![i]['menuId'];
      //menus.add(menuName);
      menus.add(Menus(
          menuName: menuName,
          menuImage: menuimage[i].toString(),
          menutxnId: txnTypeIdMenu));
      menuimage.add(iconClass);
    }

    menus.add(Menus(
        menuName: transactionsummary,
        menuImage: 'images/report.png',
        menutxnId: "TS"));
  }

  // void configurebeckgroundfetch() {
  //   // Configure BackgroundFetch.
  //   BackgroundFetch.configure(
  //           BackgroundFetchConfig(
  //             minimumFetchInterval: 15,
  //             forceAlarmManager: false,
  //             stopOnTerminate: false,
  //             startOnBoot: false,
  //             enableHeadless: false,
  //             requiresBatteryNotLow: false,
  //             requiresCharging: false,
  //             requiresStorageNotLow: false,
  //             requiresDeviceIdle: false,
  //             requiredNetworkType: NetworkType.ANY,
  //           ),
  //           _onBackgroundFetch)
  //       .then((int status) {
  //     print('[BackgroundFetch] configure success: $status');
  //     setState(() {
  //       _status = status;
  //     });
  //   }).catchError((e) {
  //     print('[BackgroundFetch] configure ERROR: $e');
  //     setState(() {
  //       _status = e;
  //     });
  //   });
  // }

  void backgroundfetch() {
    Timer.periodic(Duration(seconds: 90), (timer) {
      try {
        if (_internetconnection) {
          print("CHECKSERVICE " + "CHECKSERVICESS");
          TxnExecutor txnExecutor = new TxnExecutor();
          txnExecutor.CheckCustTrasactionTable();
          /*Future.delayed(Duration(seconds: 10), () {
            locationTransaction();
          });*/

        }
      } catch (e) {
        print(e);
      }
      //  translate();
    });
  }

  Future<void> initConnectivity() async {
    ConnectivityResult result;
// Platform messages may fail, so we use a try/catch PlatformException.
    result = await _connectivity.checkConnectivity();

// If the widget was removed from the tree while the asynchronous platform
// message was in flight, we want to discard the reply rather than calling
// setState to update our non-existent appearance.
    if (!mounted) {
      return Future.value('');
    }

    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    try {
      switch (result) {
        case ConnectivityResult.wifi:
          setState(() async {
            _internetconnection = true;
            print('internetconnection wifi');
            var db = DatabaseHelper();
            List<Map> custTransactions =
                await db.GetTableValues('custTransactions');

            if (custTransactions.isEmpty) {
              print('Download322');
              Future.delayed(Duration(seconds: 5), () {
                locationTransaction();
              });
              //locationTransaction();
              FarmerDownload();
              // Download322Datas();
            } else {
              locationTransaction();
              TxnExecutor txnExecutor = TxnExecutor();
              txnExecutor.CheckCustTrasactionTable();
            }
          });
          break;

        case ConnectivityResult.mobile:
          print('internetconnection mobile');
          setState(() async {
            _internetconnection = true;
            var db = DatabaseHelper();
            List<Map> custTransactions =
                await db.GetTableValues('custTransactions');

            if (custTransactions.length == 0) {
              Future.delayed(Duration(seconds: 5), () {
                locationTransaction();
              });
              // locationTransaction();
              FarmerDownload();
              print('Download322Datas2');
            } else {
              locationTransaction();
              TxnExecutor txnExecutor = new TxnExecutor();
              txnExecutor.CheckCustTrasactionTable();
            }
          });
          break;

        case ConnectivityResult.none:
          setState(() {
            print('internetconnection none');
            _internetconnection = false;
            _connectionStatus = nointernet;
          });
          break;

        default:
          setState(() {
            print('internetconnection defualt');
            _internetconnection = false;
            _connectionStatus = failedconnection;
          });
          break;
      }
    } catch (e) {
      print("Internet exception : " + e.toString());
    }

    // if (synced && _internetconnection) {
    //   TxnExecutor txnExecutor = new TxnExecutor();
    //   txnExecutor.loadfcmToken();
    // }
  }

  void checkpendingtransaction() {
    try {
      Timer.periodic(const Duration(seconds: 2), (timer) async {
        setState(() {
          final now = DateTime.now();
          currentdate = DateFormat('dd MMM, yyyy').format(now);
          currenttime = DateFormat('hh:mm:a').format(now);
          var CURRENTTIME = currenttime.split(':');
          if (CURRENTTIME[2] == 'AM') {
            timetype = goodmorning;
          } else {
            int hour = int.parse(CURRENTTIME[0]);
            if (hour > 4) {
              timetype = goodevening;
            } else {
              timetype = goodafternoon;
            }
          }
        });
        GetDatas();
      });
    } catch (e) {
      print("CHECK_EXCEPTION: " + e.toString());
    }
  }

  void GetFarmerdataDB() async {
    var db = DatabaseHelper();
    List<FarmerMaster> farmermaster = await db.GetFarmerdata();

    for (int i = 0; i < farmermaster.length; i++) {
      print('FarmerDBName ' + (farmermaster[i].fName!));
    }
  }

  void getVarietyDB() async {
    var db = DatabaseHelper();
    List<Map> vareity = await db.GetVariety();
    print('VarietyDB ' + vareity.toString());
  }

  Future<void> Download322Datas() async {
    try {
      restplugin rest = restplugin();
      String response = await rest.Download322();
      printWrapped("Download322 " + response);
      Map<String, dynamic> json = jsonDecode(response);

      Download322 clientmodel = Download322.fromJson(json);

      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? agentid = prefs.getString("agentId");

      //agentLogin
      String? farmerrevno = "";
      // clientmodel!.response!.body!.agentLogin!.farmerRevNo!.toString()
      String? farmRevNo = "";
      //clientmodel.response!.body!.agentLogin!.farmRevNo!.toString()
      String? fCropRevNo =
          ""; // clientmodel.response!.body!.agentLogin!.fCropRevNo!.toString()
      LoginResponseModel logindata = LoginResponseModel.fromJson(json);
      String? currentSeasonCode =
          logindata.response!.body!.agentLogin!.currentSeasonCode!;
      //clientmodel.response!.body!.agentLogin!.currentSeasonCode!
      // List? samCode = clientmodel.response!.body!.agentLogin!.samithis!;
      // print("samecode:"+samCode!.toString());
      // String? samCode = clientmodel.response!.body!.agentLogin!.samithis!.toString();
      // for(int i=0;i<clientmodel.response!.body!.agentLogin!.samithis!.length;i++){
      // String samCode = clientmodel.response!.body!.agentLogin!.samithis![i].samCode!;
      // db.SaveSamitee(samCode);
      // }
      // String clientIdSeqF =
      // AgentLogin;
      // List<String> clientIdSeqFs = clientIdSeqF.split('|');
      // print('clientIdSeqF' + clientIdSeqF);222022
      // final curIdSeqF = clientIdSeqFs[0];0505
      // final resIdSeqF = clientIdSeqFs[1];202222
      // final curIdLimitF = clientIdSeqFs[2];

      List<Map> agentSamiteeList = await db.GetTableValues('samitee');
      print('agentSamiteeList ' + agentSamiteeList.toString());
      // if(farmerrevno=='0'){
      //   db.DeleteTableRecord('agentMaster', 'agentId', agentid);
      // }

      db.UpdateTableRecord(
          'agentMaster',
          'latestFarmerRevNo =\'' +
              farmerrevno +
              "\'," +
              'latestFarmRevNo =\'' +
              farmRevNo +
              "\'," +
              'latestFarmCropRevNo =\'' +
              fCropRevNo +
              "\'," +
              'curIdSeqS =\'' +
              currentSeasonCode +
              "\'",
          'agentId',
          agentid!);

      print("data 11 download" +
          clientmodel.response!.body!.data11!.products!.length.toString());

      db.DeleteTable('inputType');

      if (clientmodel.response!.body!.data11!.products!.length > 0) {
        for (int p = 0;
            p < clientmodel.response!.body!.data11!.products!.length;
            p++) {
          String inputTypeName =
              clientmodel.response!.body!.data11!.products![p].categoryName!;
          String inputTypeCode =
              clientmodel.response!.body!.data11!.products![p].categoryCode!;
          String productName =
              clientmodel.response!.body!.data11!.products![p].productName!;
          String productCode =
              clientmodel.response!.body!.data11!.products![p].productCode!;

          db.InputTypeDetail(
              categoryCode: inputTypeCode,
              categoryName: inputTypeName,
              productCode: productCode,
              productName: productName);
        }
      }

      db.DeleteTable('inputDemandList');

      print("data10inputdemandlist:" +
          clientmodel.response!.body!.data10!.inputDemandList!.length
              .toString());

      if (clientmodel.response!.body!.data10!.inputDemandList!.length > 0) {
        for (int d = 0;
            d < clientmodel.response!.body!.data10!.inputDemandList!.length;
            d++) {
          String? date =
              clientmodel.response!.body!.data10!.inputDemandList![d].date!;
          print("date value value1:" + date);
          String? districtCode = clientmodel!
              .response!.body!.data10!.inputDemandList![d].districtCode!;
          print("date value value2:" + districtCode);
          String? gender =
              clientmodel.response!.body!.data10!.inputDemandList![d].gender!;
          print("date value value3:" + gender);

          String? farmerCode =
              clientmodel.response!.body!.data10!.inputDemandList![d].fr_code!;
          print("date value value4:" + farmerCode);

          String? warehouse = "";

          print("date value value5:" + warehouse);

          String? nin =
              clientmodel.response!.body!.data10!.inputDemandList![d].nin!;
          print("date value value6:" + nin);

          String? productCode = clientmodel
              .response!.body!.data10!.inputDemandList![d].productCode!;
          print("date value value7:" + productCode);
          String? inputType = clientmodel
              .response!.body!.data10!.inputDemandList![d].input_Type!;
          print("date value value8:" + inputType);
          double dem = double.parse(clientmodel
              .response!.body!.data10!.inputDemandList![d].demandQty!);
          String? demandQty = dem.toStringAsFixed(3);
          print("date value value9:" + demandQty);

          String? receiptNo = clientmodel
              .response!.body!.data10!.inputDemandList![d].receiptNo!;
          String? contactNumber = clientmodel
              .response!.body!.data10!.inputDemandList![d].contactNumber!;
          String? village =
              clientmodel.response!.body!.data10!.inputDemandList![d].village!;
          String? age =
              clientmodel.response!.body!.data10!.inputDemandList![d].age!;
          String? did =
              clientmodel.response!.body!.data10!.inputDemandList![d].dId!;

          String? distQty = "";

          db.InputDemandDetail(
              batchNo: receiptNo,
              village: village,
              farmerId: farmerCode,
              gender: gender,
              age: age,
              nin: nin,
              mobNo: contactNumber,
              product: productCode,
              inputType: inputType,
              demandQty: demandQty,
              distQty: did,
              date: date,
              warehouseId: warehouse,
              districtCode: districtCode);
        }
      }

      /*PROCESSING DOWNLOAD INTEGRATION*/

      db.DeleteTable('batchCreationList');

      if (clientmodel.response!.body!.data10!.batchCreationList!.length > 0) {
        for (int b = 0;
            b < clientmodel.response!.body!.data10!.batchCreationList!.length;
            b++) {
          String noOfBags = clientmodel
              .response!.body!.data10!.batchCreationList![b].noOfBag!;
          String batchNo = clientmodel
              .response!.body!.data10!.batchCreationList![b].batchNo!;
          String stockType = clientmodel
              .response!.body!.data10!.batchCreationList![b].stockType!;
          String grade =
              clientmodel.response!.body!.data10!.batchCreationList![b].grade!;
          String weight =
              clientmodel.response!.body!.data10!.batchCreationList![b].weight!;
          String isDelete = clientmodel
              .response!.body!.data10!.batchCreationList![b].isDelete!;

          db.batchCreationList(
              noOfBags: noOfBags,
              batchNo: batchNo,
              stockType: stockType,
              grade: grade,
              weight: weight,
              driName: '',
              totWtRecieved: '',
              primRecNo: '',
              noBagTransferred: '',
              vehNo: '',
              noBagRecieved: '',
              expRecNo: '',
              expPurRecNo: '',
              totWtTransferred: '',
              inputKg: '',
              outputBag: '',
              inputBag: '',
              totalKg: '',
              totalBag: '',
              avlBag: '',
              avlKg: '',
              outputKg: '',
              isDelete: isDelete);
        }
      }

      // key 1 seasons
      String seasonRevNo = ""; //clientmodel.response!.body!.data1!.seasonRevNo!
      db.UpdateTableValue(
          'agentMaster', 'seasonDwRev', seasonRevNo, 'agentId', agentid);

      if (clientmodel.response!.body!.data1!.seasons!.length > 0) {
        for (int i = 0;
            i < clientmodel.response!.body!.data1!.seasons!.length;
            i++) {
          String sCode = clientmodel.response!.body!.data1!.seasons![i].sCode!;
          String sName = clientmodel.response!.body!.data1!.seasons![i].sName!;
          String year = '';

          db.RawUpdate('DELETE FROM seasonYear Where seasonId = \'' +
              sCode +
              '\' AND year = \'' +
              year +
              '\'');
          db.SaveSeason(sCode, sName, year);
        }
      }

      db.RawUpdate('DELETE FROM wareHouseStocks');
      // key 6 procurementproducts
      db.DeleteTable('procurementProducts');
      db.DeleteTable('varietyList');
      db.DeleteTable('procurementGrade');
      db.DeleteTable('calendarCrop');
      db.DeleteTable('cropYieldList');

      if (clientmodel.response!.body!.data6!.products!.length > 0) {
        print("crop download:" +
            clientmodel.response!.body!.data6!.products!.length.toString());

        for (int i = 0;
            i < clientmodel.response!.body!.data6!.products!.length;
            i++) {
          String? ppCode =
              clientmodel.response!.body!.data6!.products![i].ppCode!;
          String? ppName =
              clientmodel.response!.body!.data6!.products![i].ppName!;
          String? crpType = "";
          // clientmodel.response!.body!.data6!.products![i].crpType!;
          // String? msp = clientmodel.response!.body!.data6!.products![i].msp!;
          String? pmsp =
              ""; //= clientmodel.response!.body!.data6!.products![i].pmsp!;
          String? unit =
              clientmodel.response!.body!.data6!.products![i].ppUnit!;

          db.SaveProcurementProducts(ppCode, ppName, crpType, unit, "", pmsp);

          print("VarietyLengthh:" +
              clientmodel.response!.body!.data6!.products![i].vrtLst!.length
                  .toString());

          for (int j = 0;
              j <
                  clientmodel
                      .response!.body!.data6!.products![i].vrtLst!.length;
              j++) {
            String ppVarName = clientmodel
                .response!.body!.data6!.products![i].vrtLst![j].ppVarName!;
            print("VarietyList:" + ppVarName);
            String ppVarCode = clientmodel
                .response!.body!.data6!.products![i].vrtLst![j].ppVarCode!;
            String? estDays =
                ""; // = clientmodel.response!.body!.data6!.products![i].vrtLst![j].estDays!;
            int saved =
                await db.saveVariety(ppCode, ppVarCode, ppVarName, estDays);
            debugPrint("saveVariety " + saved.toString());
            if (clientmodel
                    .response!.body!.data6!.products![i].vrtLst![j].subvarLst !=
                null) {
              for (int k = 0;
                  k <
                      clientmodel.response!.body!.data6!.products![i].vrtLst![j]
                          .subvarLst!.length;
                  k++) {
                String ppGraCode = clientmodel.response!.body!.data6!
                    .products![i].vrtLst![j].subvarLst![k].ppSubVarCode!;
                String ppGraName = clientmodel.response!.body!.data6!
                    .products![i].vrtLst![j].subvarLst![k].ppSubVarName!;
                String ppGraPrice = clientmodel.response!.body!.data6!
                    .products![i].vrtLst![j].subvarLst![k].ppSubVarPrice!;
                db.SaveProcurementGrade('', ppGraCode, ppCode, '', ppGraName,
                    ppGraPrice, ppVarCode);
              }
            }

            if (clientmodel
                    .response!.body!.data6!.products![i].vrtLst![j].grdLst !=
                null) {
              for (int l = 0;
                  l <
                      clientmodel.response!.body!.data6!.products![i].vrtLst![j]
                          .grdLst!.length;
                  l++) {
                String ppGraCode = clientmodel.response!.body!.data6!
                    .products![i].vrtLst![j].grdLst![l].ppGraCode!;
                String ppGraName = clientmodel.response!.body!.data6!
                    .products![i].vrtLst![j].grdLst![l].ppGraName!;
                String ppGraPrice = clientmodel.response!.body!.data6!
                    .products![i].vrtLst![j].grdLst![l].ppGraPrice!;
                db.SaveGrade(ppGraCode, ppGraName, ppGraPrice, ppVarCode);
              }
            }
          }
        }
      }

      List<Map> procurementProducts =
          await db.GetTableValues('procurementProducts');
      debugPrint(
          'procurementProducts :' + procurementProducts.length.toString());
      List<Map> varietyList = await db.GetTableValues('varietyList');
      debugPrint('varietyList :' + varietyList.length.toString());
      List<Map> procurementGrade = await db.GetTableValues('procurementGrade');
      debugPrint('procurementGrade :' + procurementGrade.length.toString());
      // key 8 catalogdownload
      String catRevNo = clientmodel.response!.body!.data8!.catRevNo!;
      db.UpdateTableValue(
          'agentMaster', 'latestCatalogRevNo', catRevNo, 'agentId', agentid);
      db.DeleteTable('animalCatalog');

      if (clientmodel.response!.body!.data8!.catList!.length > 0) {
        print("animalCatlogValueCatId:" +
            clientmodel.response!.body!.data8!.catList![1].catId.toString());
        print("animalCatlogValueCatName:" +
            clientmodel.response!.body!.data8!.catList![1].catName.toString());
        print("animalCatlogValueSeqNo:" +
            clientmodel.response!.body!.data8!.catList![1].seqNo.toString());
        print("animalCatlogValueCatType:" +
            clientmodel.response!.body!.data8!.catList![1].catType.toString());
        print("animalCatlogValueCatHarvest:" +
            clientmodel.response!.body!.data8!.catList![1].catHarvestInterval
                .toString());
        print("animalCatlogPCatID:" +
            clientmodel.response!.body!.data8!.catList![1].pCatId.toString());

        for (int k = 0;
            k < clientmodel.response!.body!.data8!.catList!.length;
            k++) {
          String catalogId =
              clientmodel.response!.body!.data8!.catList![k].catId!;
          String catalogName =
              clientmodel.response!.body!.data8!.catList![k].catName!;
          String catalogType =
              clientmodel.response!.body!.data8!.catList![k].catType.toString();
          String parentcatID =
              clientmodel.response!.body!.data8!.catList![k].pCatId.toString();
          String catHarvestInterval = clientmodel
              .response!.body!.data8!.catList![k].catHarvestInterval
              .toString();
          //int id = i + 1;
          int? id = clientmodel.response!.body!.data8!.catList![k].seqNo;
          print('inserting catalog ' + catalogId);
          var catalog = AnimalCatalog(catalogType, catalogName, catalogId,
              id.toString(), parentcatID, catHarvestInterval);
          AddCatalogDB(catalog);
        }
      }

      //key 10 - stock download
      db.DeleteTable('villageWarehouse');

      /*if (clientmodel.response!.body!.data10!.purchaseList!.length > 0) {
      print("purchase stock:" +
          clientmodel.response!.body!.data10!.purchaseList!.length.toString());

      for (int w = 0;
          w < clientmodel.response!.body!.data10!.purchaseList!.length;
          w++) {
        String batchNo =
            clientmodel.response!.body!.data10!.purchaseList![w].batchNo!;

        String quantity =
            clientmodel.response!.body!.data10!.purchaseList![w].weight!;

        String noBags =
            clientmodel.response!.body!.data10!.purchaseList![w].noOfBag!;

        String buyingCenter =
            clientmodel.response!.body!.data10!.purchaseList![w].buyingCenter!;
        String status =
            clientmodel.response!.body!.data10!.purchaseList![w].status!;

        db.SaveVillageWareHouse(
            purRecieptNo: batchNo,
            farmerName: "",
            farmerCode: "",
            farmName: "",
            coffeeType: "",
            coffeeVariety: "",
            coffeeGrade: "",
            noofbags: noBags,
            grossWeight: quantity,
            netWt: quantity,
            trnsDate: "",
            transferRecptNo: "",
            bagsTransferred: "",
            weightTransferred: "",
            stockType: "",
            vehicleNumber: "",
            driverName: "",
            receptionNo: "",
            bagsRecieved: "",
            trnsCompleted: "",
            weightRecieved: "",
            purBag: "",
            bagsTransfer: "",
            weightTransfer: "",
            buyingCenter: buyingCenter,
            processType: '',
            processBatchNo: '',
            recieverName: '',
            recieverId: '',
            isTransferred: status,
            farmCode: "");
      }
    }*/

      if (clientmodel.response!.body!.data10!.transferList!.length > 0) {
        for (int w = 0;
            w < clientmodel.response!.body!.data10!.transferList!.length;
            w++) {
          String driverName = "";
          String seasonCode =
              clientmodel.response!.body!.data10!.transferList![w].seasonCode!;
          String farmCode =
              clientmodel.response!.body!.data10!.transferList![w].frmName! ??
                  "";
          String stockType =
              clientmodel.response!.body!.data10!.transferList![w].stockType!;
          String coffeeVariety =
              clientmodel.response!.body!.data10!.transferList![w].coffVariety!;
          String totWeightTransferred = clientmodel
              .response!.body!.data10!.transferList![w].totWtTransfd!;
          String coffeeGrade =
              clientmodel.response!.body!.data10!.transferList![w].coffGrade!;
          String fCode =
              clientmodel.response!.body!.data10!.transferList![w].fCode!;
          String vehicleNumber = "";
          String recptNo =
              clientmodel.response!.body!.data10!.transferList![w].recptNo!;
          String dateTransfer = clientmodel
              .response!.body!.data10!.transferList![w].datetransfer!;
          String processType =
              clientmodel.response!.body!.data10!.transferList![w].processType!;

          var dateFormat = DateTime.parse(dateTransfer);

          String dayValue = "";
          String monthValue = "";
          var formatDate = "";
          setState(() {
            if (dateFormat.day.toString().length == 1) {
              dayValue = "0" + dateFormat.day.toString();
            } else {
              dayValue = dateFormat.day.toString();
            }
            if (dateFormat.month.toString().length == 1) {
              monthValue = "0" + dateFormat.month.toString();
            } else {
              monthValue = dateFormat.month.toString();
            }
            formatDate = "${dayValue}-${monthValue}-${dateFormat.year}";
          });

          String noBags =
              clientmodel.response!.body!.data10!.transferList![w].noBags!;
          String coffeeType =
              clientmodel.response!.body!.data10!.transferList![w].coffType!;
          String trRecptNo =
              clientmodel.response!.body!.data10!.transferList![w].trRecptNo!;
          String receiverId =
              clientmodel.response!.body!.data10!.transferList![w].receiverId!;
          String reieverName = clientmodel
              .response!.body!.data10!.transferList![w].receiverName!;
          String isTransferred = clientmodel
              .response!.body!.data10!.transferList![w].isTransfered!;

          String farmerName =
              clientmodel.response!.body!.data10!.transferList![w].farmerName!;
          String farmName =
              clientmodel.response!.body!.data10!.transferList![w].farmName!;

          db.SaveVillageWareHouse(
              purRecieptNo: recptNo,
              farmerName: farmerName,
              farmerCode: fCode,
              farmName: farmName,
              coffeeType: coffeeType,
              coffeeVariety: coffeeVariety,
              coffeeGrade: coffeeGrade,
              noofbags: "",
              grossWeight: "",
              netWt: "",
              trnsDate: formatDate,
              transferRecptNo: trRecptNo,
              bagsTransferred: noBags,
              weightTransferred: totWeightTransferred,
              stockType: stockType,
              vehicleNumber: vehicleNumber,
              driverName: driverName,
              receptionNo: "",
              bagsRecieved: "",
              trnsCompleted: "",
              weightRecieved: "",
              purBag: "",
              bagsTransfer: "",
              weightTransfer: "",
              buyingCenter: receiverId,
              processType: processType,
              processBatchNo: '',
              recieverId: receiverId,
              recieverName: reieverName,
              isTransferred: isTransferred,
              farmCode: farmCode);
        }
      }

      /*if (clientmodel.response!.body!.data10!.receptionList!.length > 0) {
      for (int r = 0;
          r < clientmodel.response!.body!.data10!.receptionList!.length;
          r++) {
        String bagTransferred = clientmodel
            .response!.body!.data10!.receptionList![r].bagsTransferred!;
        String seasonCode =
            clientmodel.response!.body!.data10!.receptionList![r].seasonCode!;
        String stockType =
            clientmodel.response!.body!.data10!.receptionList![r].stockType!;
        String weightTransferred = clientmodel
            .response!.body!.data10!.receptionList![r].weightTransferred!;
        String transferDate =
            clientmodel.response!.body!.data10!.receptionList![r].transferDate!;
        String purchaseRecieptNo = clientmodel
            .response!.body!.data10!.receptionList![r].purchaseReceiptNo!;
        String farmerCode =
            clientmodel.response!.body!.data10!.receptionList![r].farmerCode!;
        String weightRecieved = clientmodel
            .response!.body!.data10!.receptionList![r].weightReceived!;
        String vehicleNo =
            clientmodel.response!.body!.data10!.receptionList![r].vehicleNo!;
        String coffType =
            clientmodel.response!.body!.data10!.receptionList![r].coffeeType!;
        String bagRecieved =
            clientmodel.response!.body!.data10!.receptionList![r].bagsReceived!;
        String grade =
            clientmodel.response!.body!.data10!.receptionList![r].grade!;
        String farm =
            clientmodel.response!.body!.data10!.receptionList![r].farm!;
        String driverName =
            clientmodel.response!.body!.data10!.receptionList![r].driverName!;
        String processType =
            clientmodel.response!.body!.data10!.receptionList![r].processType!;
        String coffVariety = clientmodel
            .response!.body!.data10!.receptionList![r].coffeeVariety!;
        String transferRecieptNo = clientmodel
            .response!.body!.data10!.receptionList![r].transferReceiptNo!;
        String farmerName =
            clientmodel.response!.body!.data10!.receptionList![r].farmerName!;
        String farmName =
            clientmodel.response!.body!.data10!.receptionList![r].farmName!;

        db.SaveVillageWareHouse(
            purRecieptNo: purchaseRecieptNo,
            farmerName: farmerName,
            farmerCode: farmerCode,
            farmName: farmName,
            coffeeType: coffType,
            coffeeVariety: coffVariety,
            coffeeGrade: grade,
            noofbags: "",
            grossWeight: "",
            netWt: "",
            trnsDate: transferDate,
            transferRecptNo: transferRecieptNo,
            bagsTransferred: bagTransferred,
            weightTransferred: weightTransferred,
            stockType: stockType,
            vehicleNumber: vehicleNo,
            driverName: driverName,
            receptionNo: "",
            bagsRecieved: bagRecieved,
            trnsCompleted: "",
            weightRecieved: weightRecieved,
            purBag: "",
            bagsTransfer: bagTransferred,
            weightTransfer: weightTransferred,
            buyingCenter: "",
            processType: processType,
            processBatchNo: "",
            recieverName: '',
            recieverId: '',
            isTransferred: '',
            farmCode: farm);
      }
    }*/

      db.DeleteTable('vcaRegListData');
      print("vcadata:" +
          clientmodel.response!.body!.data10!.vcaRegListData!.length
              .toString());

      for (int v = 0;
          v < clientmodel.response!.body!.data10!.vcaRegListData!.length;
          v++) {
        String vId =
            clientmodel.response!.body!.data10!.vcaRegListData![v].vId ?? "";
        String certNo =
            clientmodel.response!.body!.data10!.vcaRegListData![v].cerNo ?? "";
        String villName =
            clientmodel.response!.body!.data10!.vcaRegListData![v].villName ??
                "";
        String villCode =
            clientmodel.response!.body!.data10!.vcaRegListData![v].villCode ??
                "";
        String applicationType = clientmodel
                .response!.body!.data10!.vcaRegListData![v].applicantType ??
            "";
        String stockType =
            clientmodel.response!.body!.data10!.vcaRegListData![v].stockType ??
                "";
        String actCat =
            clientmodel.response!.body!.data10!.vcaRegListData![v].vcaCat ?? "";
        String applicantName = clientmodel
                .response!.body!.data10!.vcaRegListData![v].applicantName ??
            "";
        String regNo =
            clientmodel.response!.body!.data10!.vcaRegListData![v].regNo ?? "";
        String phoneNo =
            clientmodel.response!.body!.data10!.vcaRegListData![v].telePho!;
        String email =
            clientmodel.response!.body!.data10!.vcaRegListData![v].email!;
        String address =
            clientmodel.response!.body!.data10!.vcaRegListData![v].address!;
        print("registration data:" + regNo);

        db.vCaRegListData(
            vId: vId,
            certNo: certNo,
            villName: villName,
            villCode: villCode,
            applicationType: applicationType,
            stockType: stockType,
            actCat: actCat,
            applicantName: applicantName,
            regNo: regNo,
            phoneNo: phoneNo,
            email: email,
            address: address);
      }

      /*vca data download*/
      db.DeleteTable('vcaData');
      for (int i = 0;
          i < clientmodel.response!.body!.data10!.vcaData!.length;
          i++) {
        String vid = clientmodel.response!.body!.data10!.vcaData![i].vId!;
        String regNo = clientmodel.response!.body!.data10!.vcaData![i].regNo!;
        String mobNo = clientmodel.response!.body!.data10!.vcaData![i].mobNo!;
        String cerNo = clientmodel.response!.body!.data10!.vcaData![i].certNo!;
        String applicantType =
            clientmodel.response!.body!.data10!.vcaData![i].applicantType!;
        String stockType = "";
        String vilName =
            clientmodel.response!.body!.data10!.vcaData![i].vilName!;
        String vilCode =
            clientmodel.response!.body!.data10!.vcaData![i].vilCode!;
        String applicantName =
            clientmodel.response!.body!.data10!.vcaData![i].applicantName!;
        String vcaCat = clientmodel.response!.body!.data10!.vcaData![i].actCat!;

        db.vcaData(
          vid: vid,
          regNo: regNo,
          cerNo: cerNo,
          applicantType: applicantType,
          stockType: stockType,
          vilName: vilName,
          vilCode: vilCode,
          applicantName: applicantName,
          vcaCat: vcaCat,
          mobNo: mobNo,
        );
      }

      /*nursery/seed garden download*/
      db.DeleteTable('inspReqData');
      print("clientmodel.response!.body!.data10!.inspReqData!.length" +
          clientmodel.response!.body!.data10!.inspReqData!.length.toString());
      for (int r = 0;
          r < clientmodel.response!.body!.data10!.inspReqData!.length;
          r++) {
        String insVill =
            clientmodel.response!.body!.data10!.inspReqData![r].insVill!;
        String insId =
            clientmodel.response!.body!.data10!.inspReqData![r].insId!;
        String insParish =
            clientmodel.response!.body!.data10!.inspReqData![r].insParish!;
        String insName =
            clientmodel.response!.body!.data10!.inspReqData![r].insName!;
        String stockType =
            clientmodel.response!.body!.data10!.inspReqData![r].capacity! ?? "";
        String insCerNo =
            clientmodel.response!.body!.data10!.inspReqData![r].insCerNo!;
        String insType =
            clientmodel.response!.body!.data10!.inspReqData![r].insType!;
        String insTypeValue = "";
        if (insType == "0") {
          insTypeValue = "Seed Garden";
        } else {
          insTypeValue = "Nursery";
        }
        String insSubCnt =
            clientmodel.response!.body!.data10!.inspReqData![r].insSubCnt!;
        String insDist =
            clientmodel.response!.body!.data10!.inspReqData![r].insDist!;
        String insAppName =
            clientmodel.response!.body!.data10!.inspReqData![r].insAppName!;
        String insUniqueId =
            clientmodel.response!.body!.data10!.inspReqData![r].insUniqueId!;

        inspectionModel.clear();

        var inspection = InspectionModel(
            applicantName: insAppName,
            applicantType: insTypeValue,
            appCertNo: insUniqueId);
        inspectionModel.add(inspection);
        db.inspReqData(
            insVill: insVill,
            insId: insId,
            insParish: insParish,
            insName: insName,
            stockType: stockType,
            insCerNo: insCerNo,
            insType: insType,
            insSubCnt: insSubCnt,
            insDist: insDist,
            insAppName: insAppName,
            insUniqueId: insUniqueId);
      }

      db.DeleteTable('nurseryReg');

      if (clientmodel.response!.body!.data10!.NurseryReg!.length > 0) {
        for (int n = 0;
            n < clientmodel.response!.body!.data10!.NurseryReg!.length;
            n++) {
          String nurId =
              clientmodel.response!.body!.data10!.NurseryReg![n].nurId!;
          String mobileNum =
              clientmodel.response!.body!.data10!.NurseryReg![n].mobileNum!;
          String address =
              clientmodel.response!.body!.data10!.NurseryReg![n].address!;
          String mail =
              clientmodel.response!.body!.data10!.NurseryReg![n].mail!;
          String city =
              clientmodel.response!.body!.data10!.NurseryReg![n].city!;
          String opName =
              clientmodel.response!.body!.data10!.NurseryReg![n].opName!;
          String district =
              clientmodel.response!.body!.data10!.NurseryReg![n].district!;
          String fullName =
              clientmodel.response!.body!.data10!.NurseryReg![n].fullName!;
          String state =
              clientmodel.response!.body!.data10!.NurseryReg![n].state!;
          String village =
              clientmodel.response!.body!.data10!.NurseryReg![n].village!;
          String appliType =
              clientmodel.response!.body!.data10!.NurseryReg![n].appliType!;

          db.nurseryReg(
              nurId: nurId,
              mobileNum: mobileNum,
              address: address,
              mail: mail,
              city: city,
              opName: opName,
              district: district,
              fullName: fullName,
              state: state,
              village: village,
              appliType: appliType);
        }
      }

      //key 3 village warehouse stock
      // String vwsRevNo = clientmodel.response!.body!.data3!.vwsRevNo!;
      // db.DeleteTable('villageWarehouse');
      // debugPrint('stocks loading' +
      //     clientmodel.response!.body!.data3!.stocks!.toString());
      //
      // for (int i = 0;
      // i < clientmodel.response!.body!.data3!.stocks!.length;
      // i++) {
      //   String villageCode =
      //   clientmodel.response!.body!.data3!.stocks![i].villageCode!;
      //   String pCode = clientmodel.response!.body!.data3!.stocks![i].pCode!;
      //   String bags = clientmodel.response!.body!.data3!.stocks![i].bags!;
      //   String grossWt = clientmodel.response!.body!.data3!.stocks![i].grossWt!;
      //   String gCode = clientmodel.response!.body!.data3!.stocks![i].gCode!;
      //   String seasonCode =
      //   clientmodel.response!.body!.data3!.stocks![i].seasonCode!;
      //   String batchNO = clientmodel.response!.body!.data3!.stocks![i].batchNo!;
      //   String samcode =
      //   clientmodel.response!.body!.data3!.stocks![i].vCode!;
      //   String warehouseDelivery =
      //   clientmodel.response!.body!.data3!.stocks![i].warehusedelivery!;
      //   String tareWt = clientmodel.response!.body!.data3!.stocks![i].tareWt!;
      //   String netWt = clientmodel.response!.body!.data3!.stocks![i].netWt!;
      //   //String stockType = "1";
      //   String stockType = clientmodel.response!.body!.data3!.stocks![i].type!;
      //   String siv = clientmodel.response!.body!.data3!.stocks![i].siv!;
      //   //db.SaveVillageWareHouse(gCode, villageCode, "0", pCode, bags, grossWt, batchNO, farmerId);
      //   db.SaveVillageWareHouse(gCode, villageCode, warehouseDelivery, pCode, bags, grossWt,
      //       batchNO, seasonCode, samcode, tareWt, netWt,stockType,siv);
      // }

      // key 9 samitee
      String coRevNo = clientmodel.response!.body!.data9!.coRevNo!;
      db.UpdateTableValue(
          'agentMaster', 'latestCooperativeRevNo', coRevNo, 'agentId', agentid);
      //db.DeleteTable('samitee');
      db.DeleteTable('coOperative');
      debugPrint('samiteelist loading');

      // for (int i = 0;
      //     i < clientmodel.response!.body!.data9!.samithis!.length;
      //     i++) {
      //   String samCode =
      //       clientmodel.response!.body!.data9!.samithis![i].samCode!;
      //   String samName =
      //       clientmodel.response!.body!.data9!.samithis![i].samName!;
      //   String utzStatus =
      //       clientmodel.response!.body!.data9!.samithis![i].samCode.toString();
      //   db.SaveSamiteeList(samCode, samName, utzStatus);
      // }

      //Co Operative Loading
      for (int i = 0;
          i < clientmodel.response!.body!.data9!.coOperatives!.length;
          i++) {
        String coCode =
            clientmodel.response!.body!.data9!.coOperatives![i].coCode!;
        String coName =
            clientmodel.response!.body!.data9!.coOperatives![i].coName!;

        String copTyp =
            clientmodel.response!.body!.data9!.coOperatives![i].samTyp!;
        print("copTyp  " + copTyp.toString());

        String copInchge =
            ""; //clientmodel.response!.body!.data9!.coOperatives![i].copInchge!
        String address1 =
            clientmodel.response!.body!.data9!.coOperatives![i].address1!;
        int succ = await db.SavecoOperatives(
            coCode, coName, copTyp.toString(), copInchge, address1);
        print(succ);
      }
      List<Map> samiteelist = await db.GetTableValues('samitee');
      debugPrint('samiteelist :' + samiteelist.toString());

      //int trlists = clientmodel.response!.body!.data12!.trLists!.length;
      // key 2 locations

      // if (locationrevNo == '0') {
      db.DeleteTable('countryList');
      db.DeleteTable('stateList');
      db.DeleteTable('districtList');
      db.DeleteTable('cityList');
      db.DeleteTable('gramPanchayat');
      db.DeleteTable('villageList');

      //trough no
      // db.DeleteTable("wareHouseStocks");
      // db.SavewareHouseStocks("", "PR0001", "150", "T0001", "", "", "", "");
      // db.SavewareHouseStocks("", "PR0002", "200", "T0002", "", "", "", "");
      // db.SavewareHouseStocks("", "PR0003", "300", "T0003", "", "", "", "");

      // }

      // for (int c = 0;
      //     c < clientmodel.response!.body!.data2!.countryList!.length;
      //     c++) {
      //   String countryCode =
      //       clientmodel.response!.body!.data2!.countryList![c].countryCode!;
      //   String countryName =
      //       clientmodel.response!.body!.data2!.countryList![c].countryName!;
      //   print('countryName ' + countryName);
      //   int countrysave = await db.SaveCountry(countryCode, countryName);
      //   print('countrysave' + countrysave.toString());
      // }
      //
      // for (int s = 0;
      //     s < clientmodel.response!.body!.data2!.stateList!.length;
      //     s++) {
      //   String stateCode =
      //       clientmodel.response!.body!.data2!.stateList![s].stateCode!;
      //   String stateName =
      //       clientmodel.response!.body!.data2!.stateList![s].stateName!;
      //   String countryCode =
      //       clientmodel.response!.body!.data2!.stateList![s].countryCode!;
      //   db.SaveState(stateCode, stateName, countryCode);
      // }
      //
      // for (int d = 0;
      //     d < clientmodel.response!.body!.data2!.districtList!.length;
      //     d++) {
      //   String districtCode =
      //       clientmodel.response!.body!.data2!.districtList![d].districtCode!;
      //   String districtName =
      //       clientmodel.response!.body!.data2!.districtList![d].districtName!;
      //   String stateCode =
      //       clientmodel.response!.body!.data2!.districtList![d].stateCode!;
      //
      //   db.SaveDistrict(districtCode, districtName, stateCode);
      // }
      // for (int w = 0;
      //     w < clientmodel.response!.body!.data2!.cityList!.length;
      //     w++) {
      //   String cityCode =
      //       clientmodel.response!.body!.data2!.cityList![w].cityCode!;
      //   String cityName =
      //       clientmodel.response!.body!.data2!.cityList![w].cityName!;
      //   String districtCode =
      //       clientmodel.response!.body!.data2!.cityList![w].districtCode!;
      //   db.SaveCity(cityCode, cityName, districtCode);
      // }
      //
      // for (int v = 0;
      //     v < clientmodel.response!.body!.data2!.villageList!.length;
      //     v++) {
      //   String villageCode =
      //       clientmodel.response!.body!.data2!.villageList![v].villageCode!;
      //   String villageName =
      //       clientmodel.response!.body!.data2!.villageList![v].villageName!;
      //   String cityCode =
      //       clientmodel.response!.body!.data2!.villageList![v].cityCode!;
      //   db.SaveVillage(villageCode, villageName, cityCode);
      // }

      if (clientmodel.response!.body!.data2!.countryList != null) {
        for (int i = 0;
            i < clientmodel.response!.body!.data2!.countryList!.length;
            i++) {
          String countryCode =
              clientmodel.response!.body!.data2!.countryList![i].countryCode!;
          String countryName =
              clientmodel.response!.body!.data2!.countryList![i].countryName!;
          print('countryName ' + countryName);
          int countrysave = await db.SaveCountry(countryCode, countryName);
          print('countrysave' + countrysave.toString());
          if (clientmodel.response!.body!.data2!.countryList![i].stateList !=
              null) {
            for (int k = 0;
                k <
                    clientmodel.response!.body!.data2!.countryList![i]
                        .stateList!.length;
                k++) {
              String stateCode = clientmodel.response!.body!.data2!
                  .countryList![i].stateList![k].stateCode!;
              String stateName = clientmodel.response!.body!.data2!
                  .countryList![i].stateList![k].stateName!;
              db.SaveState(stateCode, stateName, countryCode);

              if (clientmodel.response!.body!.data2!.countryList![i]
                      .stateList![k].districtList !=
                  null) {
                for (int v = 0;
                    v <
                        clientmodel.response!.body!.data2!.countryList![i]
                            .stateList![k].districtList!.length;
                    v++) {
                  String districtCode = clientmodel
                      .response!
                      .body!
                      .data2!
                      .countryList![i]
                      .stateList![k]
                      .districtList![v]
                      .districtCode!;
                  String districtName = clientmodel
                      .response!
                      .body!
                      .data2!
                      .countryList![i]
                      .stateList![k]
                      .districtList![v]
                      .districtName!;
                  db.SaveDistrict(districtCode, districtName, stateCode);
                  if (clientmodel.response!.body!.data2!.countryList![i]
                          .stateList![k].districtList![v].cityList !=
                      null) {
                    for (int c = 0;
                        c <
                            clientmodel
                                .response!
                                .body!
                                .data2!
                                .countryList![i]
                                .stateList![k]
                                .districtList![v]
                                .cityList!
                                .length;
                        c++) {
                      String cityCode = clientmodel
                          .response!
                          .body!
                          .data2!
                          .countryList![i]
                          .stateList![k]
                          .districtList![v]
                          .cityList![c]
                          .cityCode!;
                      String cityName = clientmodel
                          .response!
                          .body!
                          .data2!
                          .countryList![i]
                          .stateList![k]
                          .districtList![v]
                          .cityList![c]
                          .cityName!;
                      db.SaveCity(cityCode, cityName, districtCode);
                      if (clientmodel
                              .response!
                              .body!
                              .data2!
                              .countryList![i]
                              .stateList![k]
                              .districtList![v]
                              .cityList![c]
                              .villageList !=
                          null) {
                        for (int n = 0;
                            n <
                                clientmodel
                                    .response!
                                    .body!
                                    .data2!
                                    .countryList![i]
                                    .stateList![k]
                                    .districtList![v]
                                    .cityList![c]
                                    .villageList!
                                    .length;
                            n++) {
                          String villageCode = clientmodel
                              .response!
                              .body!
                              .data2!
                              .countryList![i]
                              .stateList![k]
                              .districtList![v]
                              .cityList![c]
                              .villageList![n]
                              .villageCode!;
                          String villageName = clientmodel
                              .response!
                              .body!
                              .data2!
                              .countryList![i]
                              .stateList![k]
                              .districtList![v]
                              .cityList![c]
                              .villageList![n]
                              .villageName!;
                          print('villageCode ' + villageCode);
                          int succc = await db.SaveVillage(
                              villageCode, villageName, cityCode);
                          if (succc != 0) {
                            print(succc);
                          }
                        }
                      } else {
                        print('panchayatList ' '');
                      }
                    }
                  } else {
                    print('city ' '');
                  }
                }
              } else {
                print('districtList ' '');
              }
            }
          } else {
            print('countryName ' '');
          }
        }
      }
      EasyLoading.dismiss();
    } catch (e) {
      EasyLoading.dismiss();
      print("Download322Datas err " + e.toString());
    }
  }

  Future<void> FarmerDownload() async {
    try {
      Future.delayed(Duration(seconds: 1), () {
        setState(() {
          loadingstring = downloadingdata;
        });
      });
      EasyLoading.show(status: 'loading...');

      restplugin rest = restplugin();
      String response = await rest.FarmerDownload();
      print('farmerlist ' + response);
      Map<String, dynamic> json = jsonDecode(response);
      String qry = 'DELETE FROM farmer_master';
      db.RawUpdate(qry);
      farmers = farmerlistresponsemodel.fromJson(json);
      print('farmerlistcount ' +
          farmers!.response!.body!.farmerList!.length.toString());

      db.DeleteTable('farmer_master');

      for (int i = 0; i < farmers!.response!.body!.farmerList!.length; i++) {
        String otName = farmers!.response!.body!.farmerList![i].otName!;
        String faddress = farmers!.response!.body!.farmerList![i].faddress!;
        String firstName = farmers!.response!.body!.farmerList![i].firstname!;
        String districtCode =
            farmers!.response!.body!.farmerList![i].districtCode!;
        String idType = farmers!.response!.body!.farmerList![i].idType!;
        String gender = farmers!.response!.body!.farmerList![i].gender!;
        String fMobNo = farmers!.response!.body!.farmerList![i].fMobNo!;
        String approval = farmers!.response!.body!.farmerList![i].approval!;
        String memOfOrg = farmers!.response!.body!.farmerList![i].memOfOrg!;
        String nationalId = farmers!.response!.body!.farmerList![i].NationalId!;
        List sameNameList = [];
        List samCodeList = [];
        String samNameValue = "";
        String samCodeValue = "";
        if (memOfOrg == "1") {
          print("samitee length:" +
              farmers!.response!.body!.farmerList![i].samithis!.length
                  .toString());

          for (int j = 0;
              j < farmers!.response!.body!.farmerList![i].samithis!.length;
              j++) {
            String samNameVal =
                farmers!.response!.body!.farmerList![i].samithis![j].samName!;
            String samCodeVal =
                farmers!.response!.body!.farmerList![i].samithis![j].samCode!;
            sameNameList.add(samNameVal);
            samCodeList.add(samCodeVal);
          }
          samNameValue = sameNameList.join(',');
          samCodeValue = samCodeList.join(',');
        } else {
          samNameValue = "";
          samCodeValue = "";
        }

        String farmerCode = farmers!.response!.body!.farmerList![i].farmerCode!;
        String landOwnAdd = farmers!.response!.body!.farmerList![i].landOwnAdd!;
        String farmerId = farmers!.response!.body!.farmerList![i].farmerId!;
        String dob = farmers!.response!.body!.farmerList![i].dob!;
        String landOwnName =
            farmers!.response!.body!.farmerList![i].landOwnName!;
        String village = farmers!.response!.body!.farmerList![i].village!;
        String age = farmers!.response!.body!.farmerList![i].age!;
        String email = farmers!.response!.body!.farmerList![i].email!;
        String status = farmers!.response!.body!.farmerList![i].status!;
        String landType = farmers!.response!.body!.farmerList![i].landType!;
        String farmCode = farmers!.response!.body!.farmerList![i].farmCode!;

        var farmermaster = FarmerMaster(
            farmerId,
            farmerCode,
            firstName,
            otName,
            idType,
            village,
            "",
            //villagename
            approval,
            memOfOrg,
            '',
            '',
            '0',
            '',
            landOwnAdd,
            landOwnName,
            landType,
            '',
            '',
            '',
            '',
            '',
            '',
            '',
            '',
            '',
            '',
            '',
            '',
            '',
            '',
            '',
            '',
            '',
            '',
            '',
            '',
            '',
            status,
            farmCode,
            '',
            '',
            districtCode,
            '',
            '',
            fMobNo,
            '',
            '',
            '0',
            '',
            samCodeValue,
            samNameValue,
            dob,
            memOfOrg,
            nationalId,
            gender,
            age,
            faddress,
            email);
        addFarmerDB(farmermaster);

        print('Farmer Added ' + farmerId + ' ' + firstName);
        print('Farmer Added ' + farmerId + ' ' + firstName);
        print('initstart FarmDownload' + farmermaster.toString());
      }
      FarmDownload();
    } catch (e) {
      FarmDownload();
      print("farmerlists err " + e.toString());
    }
  }

  Future<void> FarmDownload() async {
    try {
      setState(() {
        loadingstring = downloadingfarmdata;
      });
      restplugin rest = restplugin();
      String response = await rest.FarmDownload();
      db.DeleteTable('farm');
      Map<String, dynamic> json = jsonDecode(response);
      print('farm res ' + json.toString());
      FarmResponseModel farms = FarmResponseModel.fromJson(json);

      String? fLon = "", fLat = "";
      String? farmerId, farmCode, farmName, farmStatus;

      for (int i = 0; i < farms.response!.body!.farmList!.length; i++) {
        farmName = farms.response!.body!.farmList![i].farmName;
        String? typTreeShade = farms.response!.body!.farmList![i].typTreeShade;
        String? unProdTree = farms.response!.body!.farmList![i].unProdTree;
        String? dca = farms.response!.body!.farmList![i].dca;
        String approval = farms.response!.body!.farmList![i].approval!;
        String avTreeAge = farms.response!.body!.farmList![i].avTreeAge!;
        String prodTree = farms.response!.body!.farmList![i].prodTree!;
        fLon = farms.response!.body!.farmList![i].fLon;
        String coffeeType = farms.response!.body!.farmList![i].coffeeType!;
        farmerId = farms.response!.body!.farmList![i].farmerId;
        String spacing = farms.response!.body!.farmList![i].spacing!;
        String tca = farms.response!.body!.farmList![i].tca!;
        String yeildEstTree = farms.response!.body!.farmList![i].yeildEstTree!;
        fLat = farms.response!.body!.farmList![i].fLat;
        String treeShade = farms.response!.body!.farmList![i].treeShade!;
        farmStatus = farms.response!.body!.farmList![i].farmStatus.toString();
        String coffeeVariety =
            farms.response!.body!.farmList![i].coffeeVariety!;
        String auditArea = farms.response!.body!.farmList![i].auditArea!;
        farmCode = farms.response!.body!.farmList![i].farmCode;
        String totTrees = farms.response!.body!.farmList![i].totNoTrees!;
        db.SaveFarm(
            farmCode!,
            "",
            farmName!,
            farmerId!,
            typTreeShade!,
            unProdTree!,
            fLon!,
            fLat!,
            approval,
            farmStatus,
            dca!,
            avTreeAge,
            prodTree,
            coffeeVariety,
            coffeeType,
            spacing,
            tca,
            yeildEstTree,
            treeShade,
            auditArea,
            totTrees);
      }
      List<Map> farm = await db.GetTableValues('farm');
      print('farmdata ' + farm.toString());

      print('initstart Fetching data');
      setState(() {
        datadownload = true;
      });
      Download322Datas();
      //fetchCropdata();
    } catch (e) {
      Download322Datas();
      //fetchCropdata();
      print('farm err' + e.toString());
    }
  }

  void checkSYNC() async {
    print("checksyncfunction");
    try {
      var db = DatabaseHelper();
      List<Map> custTransactions = await db.GetTableValues('custTransactions');
      if (custTransactions.isEmpty) {
        print("Download322date_sync");
        FarmerDownload();
      } else {}
    } catch (e) {
      print("checksynccatch");
    }
  }

  void GetDatas() async {
    try {
      var db = DatabaseHelper();
      List<Map> custTransactions = await db.GetTableValues('custTransactions');
      setState(() {
        pendingTransaction = custTransactions.length.toString();
      });
      if (custTransactions.isEmpty) {
        setState(() {
          transactioncount = custTransactions.length.toString();
          synced = true;
        });
      } else {
        setState(() {
          transactioncount = custTransactions.length.toString();
          synced = false;
        });
      }
    } catch (e) {
      print('pendingtransaction packhouse' + e.toString());
    }
  }

  getstreamLocation() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? agentid = prefs.getString("agentId");
    String? serialnumber = prefs.getString("serialnumber");
    setState(() {
      final LocationSettings locationSettings = LocationSettings(
        accuracy: LocationAccuracy.best,
        distanceFilter: 1,
      );
      StreamSubscription<Position> positionStream =
          Geolocator.getPositionStream(locationSettings: locationSettings)
              .listen((Position? position) {
        print("location called in offline" + position.toString());
        //toast("location called in offline" + position.toString());
        streamLat = position!.latitude.toString();
        streamLng = position!.longitude.toString();
        String txTime = position!.timestamp.toString();
        //final now = DateTime.now();
        DateTime time = DateTime.parse(txTime);
        String txntime = DateFormat('yyyy-MM-dd HH:mm:ss').format(time);
        timeStamp = txntime;
      });
    });
  }

  startLocationTimer(bool isTimeStarted) async {
    print("location called:");
    Timer? timer;
    if (isTimeStarted) {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      setState(() {
        timer = Timer.periodic(const Duration(seconds: 20), (timer) async {
          print("ivalue:${i}");
          getstreamLocation();
          print("streamlatitude:$streamLat");
          print("streamLongitude:$streamLng");
          print("timestamp:$timeStamp");

          final now = DateTime.now();
          //DateTime time = DateTime.parse(now);
          String txntime = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);

          if (timeS == "1") {
            if (streamLat.isNotEmpty && streamLng.isNotEmpty) {
              db.saveLocation(
                  latitude: streamLat,
                  longitude: streamLng,
                  txntime: txntime,
                  orderId: i.toString(),
                  recNo: "",
                  status: "0",
                  isSynched: "");
            }
          }

          i++;

          if (_internetconnection) {
            locationTransaction();
          }
        });
      });
    } else {
      setState(() {
        print("time ended ended");
        timer!.cancel();
      });
    }

    // }
  }

  locationTransaction() async {
    try {
      print("transaction called");
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? agentid = prefs.getString("agentId");
      String? serialnumber = prefs.getString("serialnumber");

      List<Map> locationList = await db.RawQuery("SELECT * FROM location");

      for (int i = 0; i < locationList.length; i++) {
        String latitude = locationList[i]['latitude'].toString();
        String longitude = locationList[i]['longitude'].toString();
        String timeStamp = locationList[i]['timeStamp'].toString();
        //toast("latitude,longitude:" + latitude + " " + longitude);
        //http://qa2.sourcetrace.com:9005/ucdaTxn/rsl/locationTracking
        //http://pro8.sourcetrace.com:9002/ucdaTxn/rsl/locationTracking
        var postUrl = appDatas.LocationTracking +
            "/" +
            timeStamp +
            "/" +
            serialnumber! +
            "/" +
            agentid! +
            "/" +
            latitude +
            "/" +
            longitude +
            "/" +
            "0";

        print("posturlforlocation:" + postUrl);
        print("current time:" + DateTime.now().second.toString());

        Timer(Duration(seconds: 2), () {
          // <-- Delay here
          setState(() async {
            p.Response response = await p.Dio().post(postUrl);

            print("locationresponse:" +
                response.toString() +
                " " +
                DateTime.now().second.toString());
          });
        });

        p.Response response = await p.Dio().post(postUrl);

        print("locationresponse:" +
            response.toString() +
            " " +
            DateTime.now().second.toString());

        final responsebody = json.decode(response.toString());
        final jsonresponse = responsebody['Response'];
        final statusobjectr = jsonresponse['status'];
        final code = statusobjectr['code'];

        final message = statusobjectr['message'];

        final body = jsonresponse['body'];
        final msg = body['msg'];
        final date = body['date'];
        final statusCode = body['statusCode'];
        final order = body['order'];

        if (code.toString() == '00') {
          //toast("location transaction successful");
          db.DeleteTableRecord('location', 'timeStamp', date);
        } else {}
      }
    } catch (Exception) {
      print("txn_locationtransaction " + Exception.toString());
    }
  }

  Future addFarmerDB(FarmerMaster farmerMaster) async {
    var db = DatabaseHelper();
    await db.saveFarmerDB(farmerMaster);
  }

  Future AddCatalogDB(AnimalCatalog catalog) async {
    var db = DatabaseHelper();
    await db.saveCatalog(catalog);
  }

  farmerIdGeneationAlert() {
    Alert(
      context: context,
      type: AlertType.warning,
      title: info,
      desc: farmerIdMsg,
      buttons: [
        DialogButton(
          width: 120,
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text(
            ok,
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
        ),
      ],
    ).show();
  }

  on_Logout() {
    Alert(
      context: context,
      type: AlertType.warning,
      title: logout,
      desc: rusurelogout,
      buttons: [
        DialogButton(
          onPressed: () {
            Navigator.pop(context);
            Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (BuildContext context) => LoginStateful()));
            setState(() async {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              if (timeStarted) {
                prefs.setString("Start", "1");
              } else {
                prefs.setString("Start", "0");
              }
            });
          },
          width: 120,
          child: Text(
            yes,
            style: const TextStyle(color: Colors.white, fontSize: 20),
          ),
        ),
        DialogButton(
          onPressed: () {
            Navigator.pop(context);
          },
          width: 120,
          child: Text(
            no,
            style: const TextStyle(color: Colors.white, fontSize: 20),
          ),
        )
      ],
    ).show();
  }

  Future<bool> _onBackPressed() async {
    return (await Alert(
          context: context,
          type: AlertType.warning,
          title: "Exit",
          desc: "Are you sure want to  Exit the App?",
          buttons: [
            DialogButton(
              onPressed: () async {
                // Navigator.pop(context);
                // Navigator.of(context).pushReplacement(MaterialPageRoute(
                //     builder: (BuildContext context) => LoginStateful()));
                //
                // Navigator.of(context).pushAndRemoveUntil(
                //     MaterialPageRoute(
                //         builder: (BuildContext context) => LoginStateful()),
                //     (Route<dynamic> route) => false);
                Navigator.pop(context);

                if (_internetconnection) {
                  restplugin rest = restplugin();
                  await rest.logout(txnType: appDatas.logOutTxn);

                  SystemNavigator.pop();
                } else {
                  SystemNavigator.pop();
                }
              },
              width: 120,
              child: Text(
                yes,
                style: const TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
            DialogButton(
              onPressed: () {
                Navigator.pop(context);
              },
              width: 120,
              child: Text(
                no,
                style: const TextStyle(color: Colors.white, fontSize: 20),
              ),
            )
          ],
        ).show()) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    // print("build version name: " + versionName);
    return SafeArea(
        child: WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: Stack(
            children: <Widget>[
              NestedScrollView(
                headerSliverBuilder:
                    (BuildContext context, bool innerBoxIsScrolled) {
                  return <Widget>[
                    SliverAppBar(
                      backgroundColor: PrimaryColor,
                      centerTitle: true,
                      title: Text(appDatas.appname,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 19.0,
                              fontWeight: FontWeight.w800)),
                      floating: false,
                      pinned: true,
                      actions: <Widget>[
                        Row(
                          children: [
                            (timeS == "0" || timeS == "null" || timeS == "")
                                ? Container(
                                    child: Text('Journey Ended'),
                                  )
                                : Container(
                                    child: Row(
                                      children: [
                                        Text('Journey Started'),
                                        SizedBox(
                                          child: LoadingIndicator(
                                              indicatorType:
                                                  Indicator.ballClipRotatePulse,

                                              /// Required, The loading type of the widget
                                              colors: const [Colors.white],

                                              /// Optional, The color collections
                                              strokeWidth: 2,

                                              /// Optional, The stroke of the line, only applicable to widget which contains line
                                              backgroundColor: Colors.green,

                                              /// Optional, Background of the widget
                                              pathBackgroundColor: Colors.green

                                              /// Optional, the stroke backgroundColor
                                              ),
                                          height: 30,
                                          width: 30,
                                        ),
                                      ],
                                    ),
                                  ),
                            SizedBox(
                              width: 5,
                            ),
                            Container(
                              margin: const EdgeInsets.only(right: 10.0),
                              width: 30,
                              height: 30,
                              alignment: Alignment.center,
                              decoration: synced && _internetconnection
                                  ? const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.white)
                                  : const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.red),
                              child: Text(
                                transactioncount,
                                style: const TextStyle(
                                  color: Colors.green,
                                  fontSize: 17.0,
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ];
                },
                body: Stack(
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Expanded(
                          flex: 4,
                          child: Card(
                            shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                              Radius.circular(5.0),
                            )),
                            margin: const EdgeInsets.only(
                                top: 10, left: 10, right: 10),
                            elevation: 5,
                            color: Colors.green,
                            child: Container(
                              alignment: Alignment.center,
                              decoration: const BoxDecoration(
                                gradient: LinearGradient(
                                  begin: FractionalOffset(0.0, 0.0),
                                  end: FractionalOffset(0.5, 0.0),
                                  colors: [Colors.green, Colors.blue],
                                ),
                              ),
                              child: Container(
                                alignment: Alignment.topLeft,
                                margin: const EdgeInsets.all(5),
                                child: Column(
                                  children: <Widget>[
                                    Column(
                                      children: <Widget>[
                                        Row(
                                          children: <Widget>[
                                            Expanded(
                                              flex: 2,
                                              child: Row(
                                                children: <Widget>[
                                                  Image.asset(
                                                    'images/morning.png',
                                                    fit: BoxFit.cover,
                                                    width: 20,
                                                    height: 20,
                                                    alignment: Alignment.center,
                                                  ),
                                                  Text(
                                                    timetype,
                                                    style: const TextStyle(
                                                      fontSize: 18,
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Expanded(
                                              flex: 1,
                                              child: Row(
                                                children: <Widget>[
                                                  Text(
                                                    currentdate,
                                                    style: const TextStyle(
                                                      fontSize: 14,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                        Container(
                                          alignment: Alignment.centerLeft,
                                          margin:
                                              const EdgeInsets.only(left: 20),
                                          child: Text(
                                            currenttime,
                                            style: const TextStyle(
                                              fontSize: 14,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                        Container(
                                          margin: const EdgeInsets.all(5),
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                                color: Colors.white,
                                                width: 1.0),
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(5)),
                                          ),
                                          child: Container(
                                            margin: const EdgeInsets.all(1),
                                            child: Column(
                                              children: <Widget>[
                                                Row(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  children: <Widget>[
                                                    Expanded(
                                                      flex: 2,
                                                      child: Column(
                                                        children: <Widget>[
                                                          Text(
                                                            pendingTransaction +
                                                                ' ' +
                                                                PendingTransaction,
                                                            style:
                                                                const TextStyle(
                                                              fontSize: 12,
                                                              color:
                                                                  Colors.white,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .normal,
                                                            ),
                                                          ),
                                                          Row(
                                                            children: [
                                                              Expanded(
                                                                child: Card(
                                                                  shape:
                                                                      const RoundedRectangleBorder(
                                                                          borderRadius:
                                                                              BorderRadius.all(
                                                                    Radius
                                                                        .circular(
                                                                            3.0),
                                                                  )),
                                                                  elevation: 2,
                                                                  color: Colors
                                                                      .white,
                                                                  child:
                                                                      InkWell(
                                                                    onTap: () {
                                                                      checkSYNC();
                                                                    },
                                                                    child:
                                                                        Container(
                                                                      height:
                                                                          30,
                                                                      alignment:
                                                                          Alignment
                                                                              .center,
                                                                      child:
                                                                          Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.center,
                                                                        children: <
                                                                            Widget>[
                                                                          Text(
                                                                            sync,
                                                                            style:
                                                                                const TextStyle(
                                                                              fontSize: 14,
                                                                              color: Colors.green,
                                                                            ),
                                                                          ),
                                                                          Container(
                                                                            margin:
                                                                                const EdgeInsets.only(left: 10),
                                                                            child:
                                                                                const Icon(
                                                                              Icons.sync,
                                                                              size: 16,
                                                                              color: Colors.green,
                                                                            ),
                                                                          )
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                              /*Expanded(
                                                                child:
                                                                    ElevatedButton(
                                                                  onPressed:
                                                                      () {
                                                                    getstreamLocation();
                                                                    startLocationTimer();
                                                                  },
                                                                  child: Text(
                                                                    "Start Location",
                                                                    style:
                                                                        TextStyle(
                                                                      color: Colors
                                                                          .green,
                                                                    ),
                                                                  ),
                                                                  style:
                                                                      ButtonStyle(
                                                                    backgroundColor:
                                                                        MaterialStateProperty.all(
                                                                            Colors.white),
                                                                  ),
                                                                ),
                                                              )*/
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                    // inspectionModel.length > 0
                                    //     ? Card(
                                    //         shape: const RoundedRectangleBorder(
                                    //             borderRadius: BorderRadius.all(
                                    //           Radius.circular(3.0),
                                    //         )),
                                    //         elevation: 1,
                                    //         color: Colors.white,
                                    //         child: InkWell(
                                    //           onTap: () {
                                    //             showApprovedInspectionData();
                                    //           },
                                    //           child: Container(
                                    //             height: 30,
                                    //             width: 190,
                                    //             alignment: Alignment.center,
                                    //             child: Row(
                                    //               mainAxisAlignment:
                                    //                   MainAxisAlignment.center,
                                    //               children: <Widget>[
                                    //                 Text(
                                    //                   "Show Approved Inspection",
                                    //                   style: const TextStyle(
                                    //                     fontSize: 14,
                                    //                     color: Colors.green,
                                    //                   ),
                                    //                 ),
                                    //               ],
                                    //             ),
                                    //           ),
                                    //         ),
                                    //       )
                                    //     : Container(),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 15,
                          child: Container(
                            padding: const EdgeInsets.only(left: 5, right: 5),
                            child: GridView.builder(
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 3),
                              itemBuilder: (_, index) => InkWell(
                                onTap: () async {
                                  String menutxnId = menu1[index].menutxnId!;
                                  String menuName = menu1[index].menuName!;
                                  if (agentType == "02") {
                                    //pcda
                                    switch (menutxnId) {
                                      case "308":
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (BuildContext
                                                        context) =>
                                                    FarmerEnrollments())); //AddFarm
                                        break;

                                      case "359":
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder:
                                                    (BuildContext context) =>
                                                        farm1()));
                                        break;

                                      case "SM":
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder:
                                                    (BuildContext context) =>
                                                        SurveyMenu()));
                                        break;

                                      case "400":
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder:
                                                    (BuildContext context) =>
                                                        const ActivityMenu()));
                                        break;

                                      case "FA":
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder:
                                                    (BuildContext context) =>
                                                        FarmerListNew()));
                                        break;

                                      case "TS":
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder:
                                                    (BuildContext context) =>
                                                        TransactionSummary()));
                                        break;
                                    }
                                  } //pcda
                                  else if (agentType == "03") {
                                    //ceo
                                    switch (menutxnId) {
                                      case "308":
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (BuildContext
                                                        context) =>
                                                    FarmerEnrollments())); //AddFarm
                                        break;

                                      case "359":
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder:
                                                    (BuildContext context) =>
                                                        farm1()));
                                        break;

                                      case "501":
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder:
                                                    (BuildContext context) =>
                                                        InputDemand1()));
                                        break;

                                      case "317":
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (BuildContext
                                                        context) =>
                                                    const nurserySeedGarden()));
                                        break;

                                      case "300":
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder:
                                                    (BuildContext context) =>
                                                        entityFarm()));
                                        break;

                                      case "FA":
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder:
                                                    (BuildContext context) =>
                                                        FarmerListNew()));
                                        break;

                                      case "SM":
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder:
                                                    (BuildContext context) =>
                                                        SurveyMenu()));
                                        break;

                                      case "400":
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder:
                                                    (BuildContext context) =>
                                                        const ActivityMenu()));
                                        break;

                                      case "TS":
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder:
                                                    (BuildContext context) =>
                                                        TransactionSummary()));
                                        break;

                                      default:
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder:
                                                    (BuildContext context) =>
                                                        dynamicScreengetdata(
                                                            menuName,
                                                            menutxnId)));
                                        break;
                                    }
                                  } //ceo
                                  else if (agentType == "04") {
                                    //cto
                                    switch (menutxnId) {
                                      case "308":
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (BuildContext
                                                        context) =>
                                                    FarmerEnrollments())); //AddFarm
                                        break;

                                      case "359":
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder:
                                                    (BuildContext context) =>
                                                        farm1()));
                                        break;

                                      case "316":
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (BuildContext
                                                        context) =>
                                                    const CoffeePurchase()));
                                        break;

                                      case "376":
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (BuildContext
                                                        context) =>
                                                    const Transferprocess()));
                                        break;

                                      case "377":
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder:
                                                    (BuildContext context) =>
                                                        const Reception1()));
                                        break;

                                      case "501":
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder:
                                                    (BuildContext context) =>
                                                        InputDemand1()));
                                        break;

                                      case "317":
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (BuildContext
                                                        context) =>
                                                    const nurserySeedGarden()));
                                        break;

                                      case "FA":
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder:
                                                    (BuildContext context) =>
                                                        FarmerListNew()));
                                        break;

                                      case "TS":
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder:
                                                    (BuildContext context) =>
                                                        TransactionSummary()));
                                        break;

                                      case "SM":
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder:
                                                    (BuildContext context) =>
                                                        SurveyMenu()));
                                        break;

                                      case "400":
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder:
                                                    (BuildContext context) =>
                                                        const ActivityMenu()));
                                        break;

                                      default:
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder:
                                                    (BuildContext context) =>
                                                        dynamicScreengetdata(
                                                            menuName,
                                                            menutxnId)));
                                        break;
                                    }
                                  } //cto
                                  else if (agentType == "05") {
                                    switch (menutxnId) {
                                      case "377":
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder:
                                                    (BuildContext context) =>
                                                        const Reception1()));
                                        break;

                                      case "360":
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (BuildContext
                                                        context) =>
                                                    const ProcessingShiftOperations()));
                                        break;

                                      case "376":
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (BuildContext
                                                        context) =>
                                                    const ExporterPurchase()));
                                        break;

                                      case "TS":
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder:
                                                    (BuildContext context) =>
                                                        TransactionSummary()));
                                        break;
                                    }
                                  } //vca
                                  else if (agentType == "06") {
                                    switch (menutxnId) {
                                      //coop
                                      case "316":
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (BuildContext
                                                        context) =>
                                                    const CoffeePurchase()));
                                        break;

                                      /* case "376":
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (BuildContext
                                                        context) =>
                                                    const Transferprocess()));
                                        break;*/

                                      case "TS":
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder:
                                                    (BuildContext context) =>
                                                        TransactionSummary()));
                                        break;
                                    }
                                  } //coop
                                  else if (agentType == "08") {
                                    switch (menutxnId) {
                                      case "377":
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (BuildContext
                                                        context) =>
                                                    const exporterReception()));
                                        break;

                                      case "360":
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (BuildContext
                                                        context) =>
                                                    const secondaryProcessing()));
                                        break;

                                      case "TS":
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder:
                                                    (BuildContext context) =>
                                                        TransactionSummary()));
                                        break;
                                    }
                                  } //exp
                                },
                                child: Card(
                                  shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                    Radius.circular(15.0),
                                  )),
                                  elevation: 3,
                                  color: Colors.white,
                                  child: Container(
                                    alignment: Alignment.center,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        Image.asset(
                                          menu1[index].menuImage!,
                                          fit: BoxFit.cover,
                                          width: 50,
                                          height: 50,
                                          alignment: Alignment.center,
                                        ),
                                        Container(
                                          margin: const EdgeInsets.all(5),
                                          child: Text(
                                            menu1[index].menuName!,
                                            style: const TextStyle(
                                              fontSize: 16,
                                              color: Colors.black54,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              itemCount: menu1.length,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          drawer: Theme(
            data: Theme.of(context).copyWith(
              // Set the transparency here
              canvasColor: Colors
                  .white, //or any other color you want. e.g Colors.blue.withOpacity(0.5)
            ),
            child: Drawer(
              child: Column(
                children: <Widget>[
                  Expanded(
                    flex: 2,
                    child: Container(
                      alignment: Alignment.center,
                      color: const Color(0xffd3f5d4),
                      child: Column(
                        children: <Widget>[
                          Expanded(
                            flex: 2,
                            child: Container(
                              alignment: Alignment.bottomCenter,
                              width: 150,
                              child: Image.asset(
                                'images/UCDA.png',
                                alignment: Alignment.center,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Text(
                              versionName,
                              style: const TextStyle(
                                  fontSize: 14.0,
                                  color: Colors.green,
                                  fontWeight: FontWeight.w300),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 9,
                    child: ListView.builder(
                        itemCount: drawerlist.length,
                        itemBuilder: (context, postion) {
                          return GestureDetector(
                            onTap: () async {
                              switch (postion) {
                                case 0:
                                  Navigator.pop(context);
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          ChangePassword()));
                                  break;
                                case 1:
                                  on_Logout();
                                  break;

                                case 2:
                                  Navigator.pop(context);
                                  Directory documentsDirectory =
                                      await getApplicationDocumentsDirectory();
                                  SharedPreferences prefs =
                                      await SharedPreferences.getInstance();
                                  String? DBVERSION =
                                      prefs.getString("DBVERSION");
                                  String savePath = documentsDirectory.path +
                                      '/dbagro' +
                                      DBVERSION! +
                                      '.db';

                                  ShareExtend.share(savePath, "Export Data");

                                  break;

                                case 3:
                                  // if (!timer!.isActive) {
                                  Alert(
                                    context: context,
                                    type: AlertType.warning,
                                    title: "Information",
                                    desc:
                                        "Would you like to start location tracking ?",
                                    buttons: [
                                      DialogButton(
                                        onPressed: () {
                                          getstreamLocation();
                                          startLocationTimer(true);
                                          timeStarted = true;
                                          timeS = "1";
                                          Navigator.pop(context);
                                          confirmationPopup(
                                              context, "Journey Started");
                                        },
                                        width: 120,
                                        child: Text(
                                          yes,
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 20),
                                        ),
                                      ),
                                      DialogButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        width: 120,
                                        child: Text(
                                          no,
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 20),
                                        ),
                                      )
                                    ],
                                  ).show();
                                  //   }

                                  break;

                                case 4:
                                  if (timeS == "1") {
                                    Alert(
                                      context: context,
                                      type: AlertType.warning,
                                      title: "Information",
                                      desc:
                                          "Would you like to End location tracking ?",
                                      buttons: [
                                        DialogButton(
                                          onPressed: () {
                                            setState(() {
                                              // timer!.cancel();

                                              timeStarted = false;
                                              startLocationTimer(false);
                                              timeS = "0";
                                              Navigator.pop(context);
                                              confirmationPopup(
                                                  context, "Journey Ended");
                                            });
                                          },
                                          width: 120,
                                          child: Text(
                                            yes,
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 20),
                                          ),
                                        ),
                                        DialogButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          width: 120,
                                          child: Text(
                                            no,
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 20),
                                          ),
                                        )
                                      ],
                                    ).show();
                                  }

                                  break;

                                /* case "Home":
                                  Navigator.pop(context);
                                  // Navigator.of(context).push(
                                  //     MaterialPageRoute(
                                  //         builder: (BuildContext context) =>
                                  //             QrScanner()));
                                  break;
                                case "Profile":
                                  Navigator.pop(context);
                                  // Navigator.of(context).push(
                                  //     MaterialPageRoute(
                                  //         builder: (BuildContext context) =>
                                  //             QrReader()));
                                  break;*/
                                /* case "Change Password":
                                  Navigator.pop(context);
                                  Navigator.of(context).push(
                                      MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              ChangePassword()));
                                  break;

                                case 0:
                                  Navigator.pop(context);
                                  Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              Translate()));
                                  break;*/
                              }
                            },
                            child: Container(
                              margin: const EdgeInsets.only(top: 15.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Flexible(
                                    flex: 1,
                                    child: Icon(
                                      drawerlist[postion].iconData,
                                      color: Colors.green,
                                    ),
                                  ),
                                  Expanded(
                                    flex: 3,
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 8.0),
                                      child: Text(
                                        drawerlist[postion].name,
                                        style: const TextStyle(
                                            color: Colors.green,
                                            fontSize: 15.0,
                                            fontWeight: FontWeight.normal),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),
                  ),
                ],
              ),
            ),
          )),
    ));
  }

  @override
  void dispose() {
    super.dispose();
    print('dispose');
    WidgetsBinding.instance.removeObserver(this);
    tabController!.dispose();
  }

  /*Future<void> fetchCropdata() async {
    try {
      restplugin rest = restplugin();
      String response = await rest.CroplistDownload();

      printWrapped("CroplistDownload" + response.toString());
      Map<String, dynamic> json = jsonDecode(response);

      croplistvalues = CroplistValues.fromJson(json);

      for (int i = 0;
          i < croplistvalues!.response!.body!.cropList!.length;
          i++) {
        print("forloopforcrop" +
            croplistvalues!.response!.body!.cropList![i].cropId!);
        String cropCode = croplistvalues!.response!.body!.cropList![i].cropId!;
        String cropArea =
            croplistvalues!.response!.body!.cropList![i].cultArea!;
        String production = croplistvalues!.response!.body!.cropList![i].pYear!;
        String cropStatus =
            croplistvalues!.response!.body!.cropList![i].cropStatus.toString();
        String cropSeason =
            croplistvalues!.response!.body!.cropList![i].cs.toString();
        String cropCategory =
            croplistvalues!.response!.body!.cropList![i].cc.toString();
        String farmCodeRef =
            croplistvalues!.response!.body!.cropList![i].farmCodeRef!;
        String reciptId = "";
        String seedSource = "";
        String cropVariety =
            croplistvalues!.response!.body!.cropList![i].fcode!;
        String farmerId =
            croplistvalues!.response!.body!.cropList![i].farmerId!;
        String stableLengthMain =
            croplistvalues!.response!.body!.cropList![i].staLen!;

        String seedusedMain =
            croplistvalues!.response!.body!.cropList![i].sdUsd.toString();
        String seedcostMain =
            croplistvalues!.response!.body!.cropList![i].sdCost.toString();
        String cropType = croplistvalues!.response!.body!.cropList![i].type!;
        String estHarvestDt =
            croplistvalues!.response!.body!.cropList![i].estHarvDt!;
        String dateOfSown = croplistvalues!.response!.body!.cropList![i].sowDt!;
        String seedTreatment =
            croplistvalues!.response!.body!.cropList![i].seedTreat!;
        String otherSeedTreatment =
            croplistvalues!.response!.body!.cropList![i].othSeedTreat!;
        String riskBufferZone =
            croplistvalues!.response!.body!.cropList![i].riskBuf!;
        String riskAssesment =
            croplistvalues!.response!.body!.cropList![i].riskAsses!;
        String cultivationType =
            croplistvalues!.response!.body!.cropList![i].cultTyp!;
        String culAreaCrop =
            croplistvalues!.response!.body!.cropList![i].cultArea!;
        String interCropType = "";
        String interCropAcr =
            croplistvalues!.response!.body!.cropList![i].interAcres!;
        String interCropHarvest =
            croplistvalues!.response!.body!.cropList![i].interCropharvest!;
        String interCropGrossIncome =
            croplistvalues!.response!.body!.cropList![i].interGrossIncm!;
        String noOftrees = "";
        String affectedTrees = "";
        String prodctOftrees = "";
        String yearofplant =
            croplistvalues!.response!.body!.cropList![i].pYear!;
        String cropEditStatus =
            croplistvalues!.response!.body!.cropList![i].crpEdtSt.toString();

        String seedCost = "";

        String fcropId =
            croplistvalues!.response!.body!.cropList![i].fcropId.toString();

        String farmId =
            croplistvalues!.response!.body!.cropList![i].farmId.toString();

        db.saveFarmCrop(
            cropCategory,
            cropSeason,
            farmId,
            cropCode,
            farmerId,
            farmCodeRef,
            cropArea,
            production,
            cropVariety,
            seedSource,
            stableLengthMain,
            seedusedMain,
            seedcostMain,
            interCropType,
            interCropAcr,
            interCropHarvest,
            interCropGrossIncome,
            cropType,
            seedCost,
            seedTreatment,
            otherSeedTreatment,
            dateOfSown,
            riskBufferZone,
            riskAssesment,
            estHarvestDt,
            cultivationType,
            cropArea,
            cropStatus,
            cropEditStatus);
      }
      Download322Datas();
    } catch (e) {
      Download322Datas();
      print('farmcrop_master_exception' + e.toString());
    }
  }*/

// RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(40), side: BorderSide.none),
  showApprovedInspectionData() {
    showDialog(
        context: context,
        builder: (context) {
          return Container(
            width: 50,
            child: Dialog(
              insetPadding: EdgeInsets.all(50),
              elevation: 14,
              child: Container(
                height: 250,
                width: 10,
                decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    border: Border.all(color: Colors.green)),
                child: ListView(
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    Center(
                      child: Text(
                        'Approved Inspection',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    for (int i = 0; i < inspectionModel.length; i++)
                      _buildRow(
                          inspectionModel[i].applicantName.toString(),
                          inspectionModel[i].applicantType.toString(),
                          inspectionModel[i].appCertNo.toString()),
                  ],
                ),
              ),
            ),
          );
        });
  }

  Widget _buildRow(String appName, String appType, String appCerNo) {
    return Container(
      width: 50,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          children: <Widget>[
            SizedBox(height: 12),
            Container(height: 2, color: Colors.redAccent),
            SizedBox(height: 12),
            SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Row(
                children: <Widget>[
                  Text(appName),
                  SizedBox(
                    width: 20,
                  ),
                  Text(appType),
                  SizedBox(
                    width: 20,
                  ),
                  Text(appCerNo),
                ],
              ),
            ),
          ],
        ),
      ),
    );
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
        title: "Information",
        desc: message,
        buttons: [
          DialogButton(
            onPressed: () {
              setState(() {
                Navigator.pop(context);
              });
            },
            color: Colors.green,
            child: const Text(
              "OK",
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          )
        ]).show();
  }

  Future addCroplist(CropListmodel cropList) async {
    var db = DatabaseHelper();
    await db.saveCroplistvalues(cropList);
  }

  void printWrapped(String text) {
    final pattern = RegExp('.{1,800}'); // 800 is the size of each chunk
    pattern.allMatches(text).forEach((match) => print(match.group(0)));
  }
}

Logout(BuildContext context) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString("LOGIN", "0");
}

class DrawerListModel {
  String? name;
  IconData? iconData;

  DrawerListModel({this.name, this.iconData});
}

class Menus {
  String? menuName;
  String? menuImage;
  String? menutxnId;

  Menus({this.menuName, this.menuImage, this.menutxnId});
}

class InspectionModel {
  String? applicantName;
  String? applicantType;
  String? appCertNo;
  InspectionModel(
      {required this.applicantName,
      required this.applicantType,
      required this.appCertNo});
}
