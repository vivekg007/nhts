import 'dart:ui';

class AppDatas {
  String apkname = "ucda.apk";
  String appname = "UCDA";
  String tenent = "ucda";
  bool playstore = false;

  //QA
  String TXN_URL =
      'http://qa2.sourcetrace.com:9005/ucdaTxn/api/processTxnRequest'; //QA
  String apkdownloadurl =
      'http://pro4.sourcetrace.com:10088/Datagreen/public/apps/ucdaqa/ucda.apk'; //QA
  String DBdownloadurl =
      'http://pro4.sourcetrace.com:10088/Datagreen/public/apps/ucdaqa/dbagro.zip'; //QA
  String LatestVersionURL =
      "http://pro4.sourcetrace.com:10088/Datagreen/public/apps/ucdaqa/LatestVersion.php"; //QA
  String LocationTracking =
      "http://qa2.sourcetrace.com:9005/ucdaTxn/rsl/locationTracking";
  //preproduction
/*  String TXN_URL =
      'http://pro8.sourcetrace.com:9002/ucdaTxn/api/processTxnRequest'; //preproduction
  String apkdownloadurl =
      'http://pro4.sourcetrace.com:10088/Datagreen/public/apps/ucdapp/ucda.apk'; //preproduction
  String DBdownloadurl =
      'http://pro4.sourcetrace.com:10088/Datagreen/public/apps/ucdapp/dbagro.zip'; //preproduction
  String LatestVersionURL =
      "http://pro4.sourcetrace.com:10088/Datagreen/public/apps/ucdapp/LatestVersion.php";
  String LocationTracking =
      "http://pro8.sourcetrace.com:9002/ucdaTxn/rsl/locationTracking";*/
  //http://pro8.sourcetrace.com:9002/ucdaTxn/rsl/locationTracking//preproduction

  //uat
  //http://10.255.6.244:9001/ucdaTxn/
/*  String TXN_URL =
      'https://training.ugandacoffee.go.ug/ucdaTxn/api/processTxnRequest'; //client
  String apkdownloadurl =
      'http://154.72.200.110:10088/Datagreen/public/apps/ucdauat/ucda.apk'; //client
  String DBdownloadurl =
      'http://154.72.200.110:10088/Datagreen/public/apps/ucdauat/dbagro.zip'; //client
  String LatestVersionURL =
      "http://154.72.200.110:10088/Datagreen/public/apps/ucdauat/LatestVersion.php"; //client
  String LocationTracking =
      "https://training.ugandacoffee.go.ug/ucdaTxn/rsl/locationTracking";*/

  //production
  /* String TXN_URL =
      'https://services.ugandacoffee.go.ug/ucdaTxn/api/processTxnRequest'; //client
  String apkdownloadurl =
      'http://154.72.200.109:10088/Datagreen/public/apps/ucdaprod/ucda.apk'; //client
  String DBdownloadurl =
      'http://154.72.200.109:10088/Datagreen/public/apps/ucdaprod/dbagro.zip'; //client
  String LatestVersionURL =
      "http://154.72.200.109:10088/Datagreen/public/apps/ucdaprod/LatestVersion.php"; //client
  String LocationTracking =
      "https://services.ugandacoffee.go.ug/ucdaTxn/rsl/locationTracking";*/
  String txn_farmInspection = '3606';
  String txnInputReturn = '344';
  String txnDistribution = '314';
  String txnProductTransfer = '318';
  String txn_productSale = '364';
  String txn_payment = '334';
  String txnCropHarvest = '363';
  String txn_sensitizing = '374';

  String txnCostofCultivation = '366';
  String txn_trainingTopic = '351';
  String txn_cropCalendar = '398';

  //ucda txn
  String txnFarmerEnrollment = '308';
  String txn_farmSoufflet = '359';
  String coffeePurchase = '316';
  String txn_Txnprimaryprocess = '376';
  String txn_reception = '377';
  String txn_inputDemand = '501';
  String txn_inputDistribution = '5011';
  String nurserySeedGardenInspection = '317';
  String logOutTxn = "320";
  String txnPrimaryProcessing = "360";
  String txnSecondaryProcessing = "360";
  String exporterPurchase = "376";
  String exporterReception = "377";
  String farmInspection = "7129";
  String costOfCultivation = "2001";
  String farmerTraining = "2026";
  String vcaTraining = "2027";
  String vcaInspection = "2005";
  String stockExporter = "2006";
  String stockProcessor = "5001";
  String stockFarmer = "1000";
  String txn_dynamic = '500';
  String txn_changePassword = '358';
  String locationTracking = "890";

  String farmer_edit = '375';

  String activityTxn = '400';
  String entityFarm = '300';

  Color primaryColor = Color(0xffb9d2c4);
  Color textColor = Color(0xff808a93);
  Color textBoxColor = Color(0xffedf6fd);
  Color buttonColor = Color(0xff8083BF);
  Color appcolor = Color(0xff00adef);
}
