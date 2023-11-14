import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dart_ipify/dart_ipify.dart';
import 'package:dio/dio.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:package_info/package_info.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ucda/Database/Databasehelper.dart';
import 'package:ucda/Utils/MandatoryDatas.dart';

import '../main.dart';

class TxnExecutor {
  void CheckCustTrasactionTable() async {
    bool isOnline = await hasNetwork();

    try {
      var db = DatabaseHelper();
      var now = new DateTime.now();
      var Timestamp = new DateFormat('dd-MM-yyyy HH:mm:ss');
      String timestamp = Timestamp.format(now);
      // print("timestamp_timestamppp" + timestamp.toString());
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? serialnumber = prefs.getString("serialnumber");
      String? threadid = prefs.getString("threadid");
      SharedPreferences preference = await SharedPreferences.getInstance();
      int differenceInseconds = 0;
      if (threadid != null) {
        DateTime oldTransactionDate = Timestamp.parse(threadid.trim());

        differenceInseconds = now.difference(oldTransactionDate).inSeconds;
        print('differenceInseconds ' +
            differenceInseconds.toString() +
            " " +
            threadid!);
        String? isrunning = preference.getString("isRunning");
        print('isRunning ' + isrunning!);
        // runningValue = preference.getString("isRunning");
        if (differenceInseconds > 300) {
          preference.setString("isRunning", "0");
        }
      } else {
        differenceInseconds = 30;
      }

      BaseOptions options = new BaseOptions(
        baseUrl: appDatas.TXN_URL,
        connectTimeout: 9000,
        receiveTimeout: 9000,
      );

      Dio dio = new Dio(options);

      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      String version = packageInfo.version;
      List<String> versionlist = version
          .split(
              '.') // split the text into an array/ put the text inside a widget
          .toList();
      String? DBVERSION = prefs.getString("DBVERSION");

      String? runningValue;
      try {
        runningValue = preference.getString("isRunning");
      } catch (e) {
        runningValue = "";
      }

      List<Map> custTransactions = await db.GetTableValues('custTransactions');
      List<Map> agentMaster = await db.GetTableValues('agentMaster');
      String agentId = "";

      if (custTransactions.length == 0) {
        preference.setString("isRunning", "0");
        runningValue = preference.getString("isRunning");
      } else if (runningValue == null || runningValue.length == 0) {
        preference.setString("isRunning", "0");
        runningValue = preference.getString("isRunning");
      }

      // if (threadid == timestamp || differenceInseconds < 5) {
      //print('threadid duplicate' + timestamp);
      //} else {
      prefs.setString("threadid", timestamp);
      runningValue = preference.getString("isRunning");
      if (custTransactions.length > 0) {
        try {
          print('isOnline' + isOnline.toString());
          print('runningValue ' + runningValue.toString());
          if (isOnline && runningValue == "0") {
            preference.setString("isRunning", '1');
            for (int i = 0; i < custTransactions.length; i++) {
              print('custTransactionslengthValue' +
                  custTransactions.length.toString());
              agentId = agentMaster[0]['agentType'].toString();
              print("agentType:" + agentId.toString());
              var now = new DateTime.now();
              var Timestamp = new DateFormat('dd-MM-yyyy HH:mm:ss');
              String timestamp = Timestamp.format(now);
              print("forLoopTimeStamp" + timestamp.toString());
              String txnConfigId =
                  custTransactions[i]["txnConfigId"].toString();
              print("txnConfigId_forloop" + txnConfigId.toString());
              AppDatas datas = new AppDatas();

              //farmer
              if (txnConfigId == datas.txnFarmerEnrollment) {
                //toast("farmer enrollement called");
                try {
                  String ipAddressValue = '';
                  try {
                    final ipv4 = await Ipify.ipv4();
                    ipAddressValue = ipv4.toString();
                  } catch (e) {
                    ipAddressValue = '';
                  }

                  String latitude = '', longitude = '';
                  try {
                    Position position = await Geolocator.getCurrentPosition(
                        desiredAccuracy: LocationAccuracy.high);
                    latitude = position.latitude.toString();
                    longitude = position.longitude.toString();
                  } catch (e) {
                    latitude = '';
                    longitude = '';
                  }

                  String custTxnsRefId =
                      custTransactions[i]["txnRefId"].toString();
                  print("custTxnsRefId" + custTxnsRefId);

                  String headerqry =
                      "select * from txnHeader where txnRefId like '%" +
                          custTxnsRefId +
                          "%';";

                  List<Map> headerList = await db.RawQuery(headerqry);

                  print("headerList:" + headerList.toString());

                  List<Map> farmers =
                      await db.RawQuery("SELECT * FROM farmerkettle where "
                              "isSynched = 0 and farmerId = '" +
                          custTxnsRefId +
                          "';");

                  print('txnexecutor headerList ' + headerqry);
                  var headdata = jsonEncode({
                    "agentId": headerList[0]['agentId'],
                    "agentToken": headerList[0]['agentToken'],
                    "txnType": "308",
                    "txnTime": headerList[0]['txnTime'],
                    "operType": "01",
                    "mode": "02",
                    "msgNo": headerList[0]['msgNo'],
                    "resentCount": "0",
                    "serialNo": serialnumber,
                    "servPointId": headerList[0]['servPointId'],
                    "branchId": appDatas.tenent,
                    "versionNo": versionlist[0] + "|" + DBVERSION!,
                    "fsTrackerSts": "2|1",
                    "tenantId": appDatas.tenent,
                    "lat": latitude,
                    "lon": longitude,
                  });

                  print("head data:" + headdata);

                  print('resentCount' +
                      headerList[0]['resentCount'] +
                      '->' +
                      custTxnsRefId);
                  int resentCount = int.parse(headerList[0]['resentCount']);

                  resentCount = resentCount + 1;
                  print('resentCount' + resentCount.toString());

                  String updateqry = 'UPDATE txnHeader SET resentCount =\'' +
                      resentCount.toString() +
                      '\' WHERE txnRefId LIKE "%' +
                      custTxnsRefId +
                      '%"';
                  int succ = await db.RawUpdate(updateqry);
                  print('succ' + succ.toString());

                  for (int i = 0; i < farmers.length; i++) {
                    String registrationDate = farmers[i]['enrollementPlace'];
                    String landOwned = farmers[i]['landOwned'];
                    String farmerId = farmers[i]['farmerId'];
                    String firstName = farmers[i]['fName'];
                    String farmerCode = farmers[i]['farmerCode'];
                    String oName = farmers[i]['lName'];
                    String memberOrg = farmers[i]['annualIncome'];
                    String nameOwner = farmers[i]['idPhoto'];
                    String addressOwner = farmers[i]['fpoFgGroup'];
                    String dob = farmers[i]['dob'];
                    String age = farmers[i]['age'];
                    String gender = farmers[i]['gender'];
                    String nationalID = "nin";
                    String nin = farmers[i]['mobileNo'];
                    String farmerPhoto = farmers[i]['frPhoto'];
                    String address = farmers[i]['address'];
                    String state = farmers[i]['state'];
                    String district = farmers[i]['district'];
                    String city = farmers[i]['city'];
                    String village = farmers[i]['village'];
                    String email = farmers[i]['email'];
                    String phoneNo = farmers[i]['vendorType'];
                    String mobileNo = farmers[i]['licenseNo'];
                    String martialStatus = farmers[i]['maritalStatus'];
                    String isFarmerCertified = farmers[i]['totFamMembers'];
                    String scheme = farmers[i]['son'];
                    String headFamily = farmers[i]['daughter'];
                    String totHouseHoldMembers = farmers[i]['grandChildren'];
                    String totAdultFamily = farmers[i]['medicalFacilities'];
                    String totNoOfChild = farmers[i]['educationFacilities'];
                    String coffeeFarm = farmers[i]['otherBusPotential'];
                    String postHarvest = farmers[i]['communication'];
                    String landTenure = farmers[i]['educationLevel'];
                    String coffeeType = farmers[i]['abilityCommunicate'];
                    String levelEducation = farmers[i]['foliarApp'];
                    String totLandOwned = farmers[i]['pestManagement'];
                    String totNoFarms = farmers[i]['priningTipping'];
                    String healthIns = farmers[i]['plucking'];
                    String nameCompany = farmers[i]['spraying'];
                    String timeStamp = farmers[i]['timeStamp'];
                    longitude = farmers[i]['longitude'];
                    latitude = farmers[i]['latitude'];
                    String amount = farmers[i]['indigenTechKnowledge'];
                    String period = farmers[i]['samCode'];
                    String farmEnterIns = farmers[i]['gpCode'];
                    String nameCrop = farmers[i]['coCode'];
                    String amount1 = farmers[i]['farmerSurname'];
                    String country = farmers[i][' country'];
                    String enterNameHead = farmers[i]['fatherName'];
                    String signature = farmers[i]['signature'];
                    String disability = farmers[i]['tenant'];
                    print("signature path:" + signature);
                    //String groupOrg = farmers[i]['group1'];

                    if (farmerPhoto != "") {
                      File _farmerimage = File(farmers[i]['frPhoto']);
                      List<int> imageBytes = _farmerimage.readAsBytesSync();
                      farmerPhoto = base64Encode(imageBytes);
                    } else {
                      farmerPhoto = "";
                    }

                    if (signature != "") {
                      File _signImage = File(farmers[i]['signature']);

                      List<int> imageBytes = _signImage.readAsBytesSync();
                      signature = base64Encode(imageBytes);
                    } else {
                      signature = "";
                    }

                    List<Map> banklist = await db.RawQuery(
                        "SELECT * from bankList WHERE farmerId = '" +
                            farmerId +
                            "';");
                    print("banklistQry" + banklist.toString());

                    List<String> bankJsonList = [];
                    //String groupOrg = "";
                    for (int j = 0; j < banklist.length; j++) {
                      //groupOrg = banklist[j]["bankName"];
                      var reqbank = jsonEncode({
                        "nameOrg": banklist[j]["bankName"],
                        "addOrg": banklist[j]["bankACNumber"],
                      });
                      bankJsonList.add(reqbank);
                    }

                    var reqdata = jsonEncode({
                      // "Request": {
                      "body": {
                        "dateReg": registrationDate,
                        "landType": landOwned,
                        "farmerId": farmerId,
                        "farmerCode": farmerCode,
                        "fName": firstName,
                        "oName": oName,

                        //"group": groupOrg,
                        "namOwner": nameOwner,
                        "addOwner": addressOwner,
                        "dob": dob,
                        "age": age,
                        "gender": gender,
                        "nationalID": nationalID,
                        "nin": nin,
                        "frPhoto": farmerPhoto,
                        "address": address,
                        "country": country,
                        "district": state,
                        "subCountry": district,
                        "parish": city,
                        "village": village,
                        "email": email,
                        "phoneNo": phoneNo,
                        "mobMonNo": mobileNo,
                        "marSts": martialStatus,
                        "isFarmerCertified": isFarmerCertified,
                        "scheme": scheme,
                        "headFamily": headFamily,
                        "headName": enterNameHead,
                        "totNoHouseHold": totHouseHoldMembers,
                        "totAdultFamily": totAdultFamily,
                        "totNoChildren": totNoOfChild,
                        "coffeeFarm": coffeeFarm,
                        "postHarvest": postHarvest,
                        "landTenure": landTenure,
                        "coffeeType": coffeeType,
                        "levelEdu": levelEducation,
                        "totLandOwn": totLandOwned,
                        "totNoFarm": totNoFarms,
                        "healthIns": healthIns,
                        "nameCompany": nameCompany,
                        "amount": amount,
                        "period": period,
                        "farmEnterIns": farmEnterIns,
                        "nameCrop": nameCrop,
                        "amount1": amount1,
                        "latitude": farmers[i]['latitude'],
                        "longitude": farmers[i]['longitude'],
                        "memOrg": memberOrg,
                        "fpPhoto": signature,
                        "disabilityStatus": disability,
                        "memberOrg": jsonDecode(bankJsonList.toString())
                      },
                      "head": jsonDecode(headdata),
                      // }
                    });
                    printWrapped('Farmerenrollmentreqdata308 ' + reqdata);

                    Response response =
                        await dio.post(appDatas.TXN_URL, data: reqdata);
                    print(" farmerenrollmnet308Response" + response.toString());

                    final responsebody = json.decode(response.toString());
                    final jsonresponse = responsebody['Response'];
                    final statusobjectr = jsonresponse['status'];
                    final code = statusobjectr['code'];
                    final message = statusobjectr['message'];

                    if (code.toString() == '00') {
                      db.UpdateTableValue('farmerkettle', 'isSynched', '1',
                          'farmerId', custTxnsRefId);
                      db.DeleteTableRecord(
                          'custTransactions', 'txnRefId', custTxnsRefId);
                      // toast('synced successfull');
                    } else {}
                  }
                } catch (Exception) {
                  print("txnexecutor err " + Exception.toString());
                }
              }

              //dynamic
              else if (txnConfigId == datas.txn_dynamic) {
                try {
                  String ipAddressValue = '';
                  try {
                    final ipv4 = await Ipify.ipv4();
                    ipAddressValue = ipv4.toString();
                  } catch (e) {
                    ipAddressValue = '';
                  }

                  String latitude = '', longitude = '';
                  try {
                    Position position = await Geolocator.getCurrentPosition(
                        desiredAccuracy: LocationAccuracy.high);
                    latitude = position.latitude.toString();
                    longitude = position.longitude.toString();
                  } catch (e) {
                    latitude = '';
                    longitude = '';
                  }

                  String custTxnsRefId =
                      custTransactions[i]["txnRefId"].toString();
                  print("custTxnsRefId " + custTxnsRefId);
                  List<Map> mntnparent = await db.RawQuery(
                      "SELECT recNo,farmerId,farmId,season,villageId,longitude as lon,latitude as lat,txnUniqueId,txnDate,txnType as dynamicTxnId,inspectionStatus as inspStatus,converStatus as convStatus,corActPln as corActPlan,entity,dynseasonCode as season,"
                              "inspectionDate as insDt,scopeOpr,inspectionType,nameofInspect as inspNme,inspectorMblNo as mobileNo,certTotalLnd as totLaAra,certlandOrganic,"
                              "certTotalsite,activityId,startTime,activityStatus,reason,lotcode as lotCode,vcaCategory,vcaRegStatus FROM multiTenantParent where recNo = '" +
                          custTxnsRefId +
                          "' and isSynched = 0;");
                  print("mntnparentlist " + mntnparent.toString());
                  String headerqry =
                      "select * from txnHeader where txnRefId like '%" +
                          custTxnsRefId +
                          "%';";
                  List<Map> headerList = await db.RawQuery(headerqry);
                  print('txnexecutor headerList ' + headerList.toString());
                  print('txnexecutor headerList ' + headerqry);
                  List<Map> dynamicFields = await db.RawQuery(
                      "select FieldId,FieldVal,remarks,ComponentType as compoType, txnTypeId from dynamiccomponentFieldValues WHERE recNu  ='" +
                          custTxnsRefId +
                          "';");
                  // List<Map> remarksFields = await db.RawQuery(
                  //     "select componentID,remarks from dynamiccomponentRemarks WHERE recNo  ='" +
                  //         custTxnsRefId +
                  //         "';");

                  print("dynamicFieldsaaaaaaaa" + dynamicFields.toString());

                  List<Map> dynamicFieldList = await db.RawQuery(
                      "select FieldId,fieldValue as FieldVal,listID,componentType as compoType,listItration,txnTypeId from dynamicListValues WHERE recNu ='" +
                          custTxnsRefId +
                          "';");
                  print("dynamicFieldListaaaaaa" + dynamicFieldList.toString());

                  List<Map> dynamicImage = await db.RawQuery(
                      "select Glo_popupId as FieldId,imageTime as pcTime,imageURL as fPhoto,imageLatitude as lat,imageLongitude as lon,listItration,listId as listID,sectionId,blockId,txnTypeId from dynamiccomponentImage WHERE recNu ='" +
                          custTxnsRefId +
                          "';");
                  print("dynamicImage_dynamicImage" +
                      dynamicImage.length.toString());
                  print("dynamicImage_dynamicImageqry" + custTxnsRefId);

                  var headdata = jsonEncode({
                    "agentId": headerList[0]['agentId'],
                    "agentToken":
                        headerList[0]['agentToken'].replaceAll(' ', ''),
                    "txnType": datas.txn_dynamic,
                    "txnTime": headerList[0]['txnTime'],
                    "operType": "01",
                    "mode": headerList[0]['mode'],
                    "msgNo": headerList[0]['msgNo'].replaceAll(' ', ''),
                    "resentCount":
                        headerList[0]['resentCount'].replaceAll(' ', ''),
                    "serialNo": serialnumber,
                    "servPointId":
                        headerList[0]['servPointId'].replaceAll(' ', ''),
                    "branchId": appDatas.tenent,
                    "versionNo": versionlist[0] + "|" + DBVERSION!,
                    "fsTrackerSts": "2|1",
                    "tenantId": appDatas.tenent,
                    "lat": latitude,
                    "lon": longitude,
                  });

                  print('resentCount' +
                      headerList[0]['resentCount'] +
                      '->' +
                      custTxnsRefId);
                  int resentCount = int.parse(headerList[0]['resentCount']);

                  resentCount = resentCount + 1;
                  print('resentCount' + resentCount.toString());

                  String updateqry = 'UPDATE txnHeader SET resentCount =\'' +
                      resentCount.toString() +
                      '\' WHERE txnRefId LIKE "%' +
                      custTxnsRefId +
                      '%"';
                  int succ = await db.RawUpdate(updateqry);
                  print('succ' + succ.toString());

                  print('txnexecutor headerList ' + headdata.toString());

                  List<String> ListDynamicFieldList = [];
                  for (int i = 0; i < dynamicFieldList.length; i++) {
                    var reqDynamicList = jsonEncode({
                      "fieldId": dynamicFieldList[i]['fieldId'] ?? "",
                      "fieldVal": dynamicFieldList[i]['FieldVal'] ?? "",
                      "listID": dynamicFieldList[i]['listID'] ?? "",
                      "compoType": dynamicFieldList[i]['compoType'] ?? "",
                      "listItration": dynamicFieldList[i]['listItration'] ?? "",
                      "txnTypeId": dynamicFieldList[i]['txnTypeId'] ?? "",
                    });
                    ListDynamicFieldList.add(reqDynamicList);
                  }

                  String fieldID = '';
                  String remarksStr = 'Remarks';

                  List<String> ListDynamicField = [];
                  for (int j = 0; j < dynamicFields.length; j++) {
                    fieldID =
                        dynamicFields[j]['FieldId'].toString().trim() ?? "";

                    var reqDynamicfield = jsonEncode({
                      "fieldId": dynamicFields[j]['FieldId'] ?? "",
                      "fieldVal": dynamicFields[j]['FieldVal'] ?? "",
                      "txnTypeId": dynamicFields[j]['txnTypeId'] ?? "",
                      "compoType": dynamicFields[j]['compoType'] ?? "",
                      "$fieldID$remarksStr": dynamicFields[j]['remarks'] ?? "",
                    });
                    ListDynamicField.add(reqDynamicfield);
                  }

                  List<String> DynamicImage = [];
                  for (int k = 0; k < dynamicImage.length; k++) {
                    String dynamicPhoto = '';
                    if (dynamicImage[k]["fPhoto"] != null &&
                        dynamicImage[k]["fPhoto"] != "") {
                      File _beneficiaryimage = File(dynamicImage[k]["fPhoto"]);
                      List<int> imageBytes =
                          _beneficiaryimage.readAsBytesSync();
                      dynamicPhoto = base64Encode(imageBytes);
                    }
                    var reqDynamicImage = jsonEncode({
                      "fieldId": dynamicImage[k]['FieldId'] ?? "",
                      "compoType": "12",
                      "pcTime": dynamicImage[k]['pcTime'],
                      "fileExtension": "jpg",
                      "fPhoto": dynamicPhoto ?? "",
                      "videoName": "",
                      "lat": dynamicImage[k]['lat'] ?? "",
                      "lon": dynamicImage[k]['lon'] ?? "",
                      "listItration": dynamicImage[k]['listItration'] ?? "",
                      "listID": "",
                      "sectionId": dynamicImage[k]['sectionId'] ?? "",
                      "blockId": dynamicImage[k]['blockId'] ?? "",
                      "txnTypeId": dynamicImage[k]['txnTypeId'] ?? "",
                      "audioURL": "",
                    });
                    DynamicImage.add(reqDynamicImage);
                  }

                  // List<String> dynamicLocationJsonList = [];
                  // List<Map> dynamicLocationList = await db.RawQuery(
                  //     "select longitude,latitude,OrderOFGPS from farm_GPSLocation WHERE farmerId='" +
                  //         mntnparent[i]["farmerId"] +
                  //         "' AND farmId ='" +
                  //         mntnparent[i]["farmId"] +
                  //         "' and reciptId='" +
                  //         custTxnsRefId +
                  //         "' order by OrderOFGPS;");
                  //
                  // for (int j = 0; j < dynamicLocationList.length; j++) {
                  //   var reqdynamicLocation = jsonEncode({
                  //     "laLon": dynamicLocationList[j]["longitude"],
                  //     "laLat": dynamicLocationList[j]["latitude"],
                  //     "orderNo": dynamicLocationList[j]["OrderOFGPS"],
                  //   });
                  //   dynamicLocationJsonList.add(reqdynamicLocation);
                  // }
                  for (int i = 0; i < mntnparent.length; i++) {
                    var reqdata = jsonEncode({
                      "body": {
                        "recNo": mntnparent[i]['recNo'] ?? "",
                        "farmerId": mntnparent[i]['farmerId'] ?? "",
                        /*"farmId": mntnparent[i]['farmId'] ?? "",*/
                        "season": mntnparent[i]['season'] ?? "",
                        "longitude": mntnparent[i]['lon'] ?? "",
                        "latitude": mntnparent[i]['lat'] ?? "",
                        "txnUniqueId": mntnparent[i]['txnUniqueId'] ?? "",
                        "txnDate": mntnparent[i]['txnDate'] ?? "",
                        "dynamicTxnId": mntnparent[i]['dynamicTxnId'] ?? "",
                        /* "inspStatus": mntnparent[i]['inspStatus'] ?? "",
                            "convStatus": mntnparent[i]['convStatus'] ?? "",
                            "corActPlan": mntnparent[i]['corActPlan'] ?? "",*/
                        "entity": mntnparent[i]['entity'] ?? "",
                        "vcaCategory": mntnparent[i]['vcaCategory'] ?? "",
                        "vcaRegStatus": mntnparent[i]['vcaRegStatus'] ?? "",
                        "season": mntnparent[i]['season'] ?? "",
                        "date": mntnparent[i]['insDt'] ?? "",
                        "blockId": mntnparent[i]['scopeOpr'] ?? "",
                        "agronomist": mntnparent[i]['activityId'] ?? "",
                        // "multiplication": mntnparent[i]['inspNme'] ?? "",
                        "multiplication": "",
                        "demonstrationId": mntnparent[i]['lotCode'] ?? "",
                        /* "inspectionType": mntnparent[i]['inspectionType'] ?? "",
                    "inspNme": mntnparent[i]['inspNme'] ?? "",
                    "mobileNo": mntnparent[i]['mobileNo'] ?? "",
                    "totLaAra": mntnparent[i]['totLaAra'] ?? "",
                    "certlandOrganic": mntnparent[i]['certlandOrganic'] ?? "",
                    "certTotalsite": mntnparent[i]['certTotalsite'] ?? "",

                    "startTime": mntnparent[i]['startTime'] ?? "",
                    "component": mntnparent[i]['component'] ?? "",
                    "activityStatus": "0",
                    "reason": mntnparent[i]['reason'] ?? "",
                    "lotCode": mntnparent[i]['lotCode'] ?? "",
                    "district": mntnparent[i]['district'] ?? "",
                    "upazila": mntnparent[i]['upazila'] ?? "",
                    "union": mntnparent[i]['uniondyn'] ?? "",
                    "ward": mntnparent[i]['ward'] ?? "",*/
                        "kebele": mntnparent[i]['villageId'] ?? "",
                        /*"group": mntnparent[i]['groupdyn'] ?? "",
                    "typAct": mntnparent[i]['activity'] ?? "",*/
                        "dyFields": jsonDecode(ListDynamicField.toString()),
                        "dyFieldsLst":
                            jsonDecode(ListDynamicFieldList.toString()),
                        "dynImageLst": jsonDecode(DynamicImage.toString()),
                      },
                      "head": jsonDecode(headdata)
                    });
                    printWrapped('reqdata500 ' + reqdata.toString());
                    Response response =
                        await Dio().post(appDatas.TXN_URL, data: reqdata);
                    printWrapped('response500 ' + response.toString());
                    final responsebody = json.decode(response.toString());
                    final jsonresponse = responsebody['Response'];
                    final statusobjectr = jsonresponse['status'];
                    final code = statusobjectr['code'];
                    final message = statusobjectr['message'];

                    if (code.toString() == '00') {
                      db.UpdateTableValue('multiTenantParent', 'isSynched', '1',
                          'recNo', custTxnsRefId);
                      db.UpdateTableValue('dynamicListValues', 'isSynched', '1',
                          'recNu', custTxnsRefId);
                      db.DeleteTableRecord(
                          'custTransactions', 'txnRefId', custTxnsRefId);
                      db.DeleteTableRecord(
                          'dynamiccomponentImage', 'recNu', custTxnsRefId);
                    } else {}
                  }
                } catch (e) {
                  print(e);
                }
              }

              //farm
              else if (txnConfigId == datas.txn_farmSoufflet) {
                try {
                  String ipAddressValue = '';
                  try {
                    final ipv4 = await Ipify.ipv4();
                    ipAddressValue = ipv4.toString();
                  } catch (e) {
                    ipAddressValue = '';
                  }

                  String latitude = '', longitude = '';
                  try {
                    Position position = await Geolocator.getCurrentPosition(
                        desiredAccuracy: LocationAccuracy.high);
                    latitude = position.latitude.toString();
                    longitude = position.longitude.toString();
                  } catch (e) {
                    latitude = '';
                    longitude = '';
                  }

                  String custTxnsRefId =
                      custTransactions[i]["txnRefId"].toString();
                  print("custom transaction id:" + custTxnsRefId);

                  String headerqry =
                      "select * from txnHeader where txnRefId like '%" +
                          custTxnsRefId +
                          "%';";

                  List<Map> headerList = await db.RawQuery(headerqry);
                  var headdata = jsonEncode({
                    "agentId": headerList[0]['agentId'],
                    "agentToken": headerList[0]['agentToken'],
                    "txnType": datas.txn_farmSoufflet,
                    "txnTime": headerList[0]['txnTime'],
                    "operType": "01",
                    "mode": "02",
                    "msgNo": headerList[0]['msgNo'],
                    "resentCount": "0",
                    "serialNo": serialnumber,
                    "servPointId": headerList[0]['servPointId'],
                    "branchId": appDatas.tenent,
                    "versionNo": versionlist[0] + "|" + DBVERSION!,
                    "fsTrackerSts": "2|1",
                    "tenantId": appDatas.tenent,
                    "lat": latitude,
                    "lon": longitude,
                  });

                  print('resentCount' +
                      headerList[0]['resentCount'] +
                      '->' +
                      custTxnsRefId);
                  int resentCount = int.parse(headerList[0]['resentCount']);

                  resentCount = resentCount + 1;
                  print('resentCount' + resentCount.toString());

                  String updateqry = 'UPDATE txnHeader SET resentCount =\'' +
                      resentCount.toString() +
                      '\' WHERE txnRefId LIKE "%' +
                      custTxnsRefId +
                      '%"';
                  int succ = await db.RawUpdate(updateqry);
                  print('succ' + succ.toString());

                  List<Map> farmSouflt = await db.RawQuery(
                      "SELECT * FROM farmSoufflet where isSynched = 0 and recNo = '" +
                          custTxnsRefId +
                          "';");

                  printWrapped("farmUCDA:" + farmSouflt.toString());
                  List<String> farmSoufltDetailList = [];

                  for (int i = 0; i < farmSouflt.length; i++) {
                    String farmerId = farmSouflt[i]['farmerId'];
                    String farmId = farmSouflt[i]['farmIDT'];
                    String recId = custTxnsRefId;
                    String farmPhoto = farmSouflt[i]['frPhoto'];
                    String landDoc = farmSouflt[i]['landTitleDoc'];

                    if (farmPhoto != "") {
                      File _farmerimage = File(farmSouflt[i]['frPhoto']);
                      List<int> imageBytes = _farmerimage.readAsBytesSync();
                      farmPhoto = base64Encode(imageBytes);
                    }

                    if (landDoc != "") {
                      File _landimage = File(farmSouflt[i]['landTitleDoc']);
                      List<int> imageBytes = _landimage.readAsBytesSync();
                      landDoc = base64Encode(imageBytes);
                    }

                    List<String> farmLocationJsonList = [];
                    List<Map> farmLocationList = await db.RawQuery(
                        "select longitude,latitude,OrderOFGPS from farm_GPSLocation_Exists WHERE farmerId='" +
                            farmerId +
                            "' AND farmId ='" +
                            farmId +
                            "' and reciptId='" +
                            recId +
                            "' order by OrderOFGPS;");

                    for (int j = 0; j < farmLocationList.length; j++) {
                      var reqfarmLocation = jsonEncode({
                        "laLon": farmLocationList[j]["longitude"],
                        "laLat": farmLocationList[j]["latitude"],
                        "orderNo": farmLocationList[j]["OrderOFGPS"].toString(),
                      });
                      farmLocationJsonList.add(reqfarmLocation);
                    }

                    var reqdata = jsonEncode({
                      "body": {
                        "farmerId": farmSouflt[i]['farmerId'],
                        "farmName": farmSouflt[i]['farmName'],
                        "farmCode": farmSouflt[i]['farmIDT'],
                        "farmPhoto": farmPhoto,
                        "type": farmSouflt[i]['type'],
                        "varieties": farmSouflt[i]['varieties'],
                        "spacingTree": farmSouflt[i]['spacingTree'],
                        "yldEstTree": farmSouflt[i]['yieldTree'],
                        "totCoffeeAcr": farmSouflt[i]['totCoffeeAcr'],
                        "propCoffeePlAr": farmSouflt[i]['propCoffeeAr'],
                        "auditedArea": farmSouflt[i]['auditedArea'],
                        "avgAgeTree": farmSouflt[i]['avgTree'],
                        "numShadeTree": farmSouflt[i]['numTree'],
                        "typShadeTree": farmSouflt[i]['typTree'],
                        "numProdTree": farmSouflt[i]['numPrTrees'],
                        "numUnProdTree": farmSouflt[i]['numUnPrTrees'],
                        "goodAgriPrac": farmSouflt[i]['goodAgri'],
                        "liveStock": farmSouflt[i]['liveStock'],
                        "totalNoTrees": farmSouflt[i]['landOwner'],
                        "landTopo": farmSouflt[i]['landTopo'],
                        "landGradient": farmSouflt[i]['landGr'],
                        "accRoad": farmSouflt[i]['accRoad'],
                        "altitude": farmSouflt[i]['altitude'],
                        "certProgram": farmSouflt[i]['certProgram'],
                        "plDate": farmSouflt[i]['plDate'],
                        "othCrop": farmSouflt[i]['otCrop'],
                        "prDate": farmSouflt[i]['prDate'],
                        "soilTyp": farmSouflt[i]['soilTyp'],
                        "fertStatus": farmSouflt[i]['fertStatus'],
                        // "irrSource": farmSouflt[i]['irriSource'],
                        "irrigate": farmSouflt[i]['irriSource'],
                        "metIrr": farmSouflt[i]['metIrr'],
                        "watHrMthd": farmSouflt[i]['watHarMethod'],
                        "latitude": farmSouflt[i]["latitude"],
                        "longitude": farmSouflt[i]["longitude"],
                        "village": farmSouflt[i]['altitudeValue'],
                        "landDoc": landDoc,
                        "lAgps": jsonDecode(farmLocationJsonList.toString())
                      },
                      "head": jsonDecode(headdata)
                    });
                    printWrapped("LandPreparationReq" + reqdata);

                    Response response =
                        await Dio().post(appDatas.TXN_URL, data: reqdata);

                    print("response farm:" + response.toString());

                    final responsebody = json.decode(response.toString());
                    final jsonresponse = responsebody['Response'];
                    final statusobjectr = jsonresponse['status'];
                    final code = statusobjectr['code'];
                    final message = statusobjectr['message'];
                    if (code.toString() == '00') {
                      db.UpdateTableValue('farmSoufflet', 'isSynched', '1',
                          'recNo', custTxnsRefId);
                      db.DeleteTableRecord(
                          'custTransactions', 'txnRefId', custTxnsRefId);
                    } else {}
                  }
                } catch (Exception) {
                  print("txnexecutor err " + Exception.toString());
                }
              }
              //entityFarm
              else if (txnConfigId == datas.entityFarm) {
                try {
                  String ipAddressValue = '';
                  try {
                    final ipv4 = await Ipify.ipv4();
                    ipAddressValue = ipv4.toString();
                  } catch (e) {
                    ipAddressValue = '';
                  }

                  String latitude = '', longitude = '';
                  try {
                    Position position = await Geolocator.getCurrentPosition(
                        desiredAccuracy: LocationAccuracy.high);
                    latitude = position.latitude.toString();
                    longitude = position.longitude.toString();
                  } catch (e) {
                    latitude = '';
                    longitude = '';
                  }

                  String custTxnsRefId =
                      custTransactions[i]["txnRefId"].toString();
                  print("custom transaction id:" + custTxnsRefId);

                  String headerqry =
                      "select * from txnHeader where txnRefId like '%" +
                          custTxnsRefId +
                          "%';";

                  List<Map> headerList = await db.RawQuery(headerqry);
                  var headdata = jsonEncode({
                    "agentId": headerList[0]['agentId'],
                    "agentToken": headerList[0]['agentToken'],
                    "txnType": datas.entityFarm,
                    "txnTime": headerList[0]['txnTime'],
                    "operType": "01",
                    "mode": "02",
                    "msgNo": headerList[0]['msgNo'],
                    "resentCount": "0",
                    "serialNo": serialnumber,
                    "servPointId": headerList[0]['servPointId'],
                    "branchId": appDatas.tenent,
                    "versionNo": versionlist[0] + "|" + DBVERSION!,
                    "fsTrackerSts": "2|1",
                    "tenantId": appDatas.tenent,
                    "lat": latitude,
                    "lon": longitude,
                  });

                  print('resentCount' +
                      headerList[0]['resentCount'] +
                      '->' +
                      custTxnsRefId);
                  int resentCount = int.parse(headerList[0]['resentCount']);

                  resentCount = resentCount + 1;
                  print('resentCount' + resentCount.toString());

                  String updateqry = 'UPDATE txnHeader SET resentCount =\'' +
                      resentCount.toString() +
                      '\' WHERE txnRefId LIKE "%' +
                      custTxnsRefId +
                      '%"';
                  int succ = await db.RawUpdate(updateqry);
                  print('succ' + succ.toString());

                  List<Map> farmSouflt = await db.RawQuery(
                      "SELECT * FROM entityFarm where isSynched = 0 and recNo = '" +
                          custTxnsRefId +
                          "';");

                  printWrapped("farmUCDA:" + farmSouflt.toString());
                  List<String> farmSoufltDetailList = [];

                  for (int i = 0; i < farmSouflt.length; i++) {
                    String farmerId = farmSouflt[i]['farmerId'];
                    String farmId = farmSouflt[i]['farmIDT'];
                    String recId = custTxnsRefId;
                    String farmPhoto = farmSouflt[i]['frPhoto'];
                    String landDoc = farmSouflt[i]['landTitleDoc'];

                    if (farmPhoto != "") {
                      File _farmerimage = File(farmSouflt[i]['frPhoto']);
                      List<int> imageBytes = _farmerimage.readAsBytesSync();
                      farmPhoto = base64Encode(imageBytes);
                    }

                    if (landDoc != "") {
                      File _landimage = File(farmSouflt[i]['landTitleDoc']);
                      List<int> imageBytes = _landimage.readAsBytesSync();
                      landDoc = base64Encode(imageBytes);
                    }

                    List<String> farmLocationJsonList = [];
                    List<Map> farmLocationList = await db.RawQuery(
                        "select longitude,latitude,OrderOFGPS from farm_GPSLocation_Exists WHERE farmerId='" +
                            farmerId +
                            "' AND farmId ='" +
                            farmId +
                            "' and reciptId='" +
                            recId +
                            "' order by OrderOFGPS;");

                    for (int j = 0; j < farmLocationList.length; j++) {
                      var reqfarmLocation = jsonEncode({
                        "laLon": farmLocationList[j]["longitude"],
                        "laLat": farmLocationList[j]["latitude"],
                        "orderNo": farmLocationList[j]["OrderOFGPS"].toString(),
                      });
                      farmLocationJsonList.add(reqfarmLocation);
                    }

                    var reqdata = jsonEncode({
                      "body": {
                        "farmerId": farmSouflt[i]['farmerId'],
                        "farmName": farmSouflt[i]['farmName'],
                        "farmCode": farmSouflt[i]['farmIDT'],
                        "farmPhoto": farmPhoto,
                        "type": farmSouflt[i]['type'],
                        "varieties": farmSouflt[i]['varieties'],
                        "spacingTree": farmSouflt[i]['spacingTree'],
                        "yldEstTree": farmSouflt[i]['yieldTree'],
                        "totCoffeeAcr": farmSouflt[i]['totCoffeeAcr'],
                        "propCoffeePlAr": farmSouflt[i]['propCoffeeAr'],
                        "auditedArea": farmSouflt[i]['auditedArea'],
                        "avgAgeTree": farmSouflt[i]['avgTree'],
                        "numShadeTree": farmSouflt[i]['numTree'],
                        "typShadeTree": farmSouflt[i]['typTree'],
                        "numProdTree": farmSouflt[i]['numPrTrees'],
                        "numUnProdTree": farmSouflt[i]['numUnPrTrees'],
                        "goodAgriPrac": farmSouflt[i]['goodAgri'],
                        "liveStock": farmSouflt[i]['liveStock'],
                        "totalNoTrees": farmSouflt[i]['landOwner'],
                        "landTopo": farmSouflt[i]['landTopo'],
                        "landGradient": farmSouflt[i]['landGr'],
                        "accRoad": farmSouflt[i]['accRoad'],
                        "altitude": farmSouflt[i]['altitude'],
                        "certProgram": farmSouflt[i]['certProgram'],
                        "plDate": farmSouflt[i]['plDate'],
                        "othCrop": farmSouflt[i]['otCrop'],
                        "prDate": farmSouflt[i]['prDate'],
                        "soilTyp": farmSouflt[i]['soilTyp'],
                        "fertStatus": farmSouflt[i]['fertStatus'],
                        // "irrSource": farmSouflt[i]['irriSource'],
                        "irrigate": farmSouflt[i]['irriSource'],
                        "metIrr": farmSouflt[i]['metIrr'],
                        "watHrMthd": farmSouflt[i]['watHarMethod'],
                        "latitude": farmSouflt[i]["latitude"],
                        "longitude": farmSouflt[i]["longitude"],
                        "village": farmSouflt[i]['altitudeValue'],
                        "landDoc": landDoc,
                        "entityType": farmSouflt[i]['entityType'],
                        "entityName": farmSouflt[i]['entityName'],
                        "lAgps": jsonDecode(farmLocationJsonList.toString())
                      },
                      "head": jsonDecode(headdata)
                    });
                    printWrapped("LandPreparationReq" + reqdata);

                    Response response =
                        await Dio().post(appDatas.TXN_URL, data: reqdata);

                    print("response farm:" + response.toString());

                    final responsebody = json.decode(response.toString());
                    final jsonresponse = responsebody['Response'];
                    final statusobjectr = jsonresponse['status'];
                    final code = statusobjectr['code'];
                    final message = statusobjectr['message'];
                    if (code.toString() == '00') {
                      db.UpdateTableValue('entityFarm', 'isSynched', '1',
                          'recNo', custTxnsRefId);
                      db.DeleteTableRecord(
                          'custTransactions', 'txnRefId', custTxnsRefId);
                    } else {}
                  }
                } catch (Exception) {
                  print("txnexecutor err " + Exception.toString());
                }
              }
              //coffee purchase

              else if (txnConfigId == datas.coffeePurchase) {
                try {
                  String ipAddressValue = '';
                  try {
                    final ipv4 = await Ipify.ipv4();
                    ipAddressValue = ipv4.toString();
                  } catch (e) {
                    ipAddressValue = '';
                  }

                  String latitude = '', longitude = '';
                  try {
                    Position position = await Geolocator.getCurrentPosition(
                        desiredAccuracy: LocationAccuracy.high);
                    latitude = position.latitude.toString();
                    longitude = position.longitude.toString();
                  } catch (e) {
                    latitude = '';
                    longitude = '';
                  }

                  String custTxnsRefId =
                      custTransactions[i]["txnRefId"].toString();
                  print("custom transaction id:" + custTxnsRefId);

                  String headerqry =
                      "select * from txnHeader where txnRefId like '%" +
                          custTxnsRefId +
                          "%';";

                  List<Map> headerList = await db.RawQuery(headerqry);
                  var headdata = jsonEncode({
                    "agentId": headerList[0]['agentId'],
                    "agentToken": headerList[0]['agentToken'],
                    "txnType": datas.coffeePurchase,
                    "txnTime": headerList[0]['txnTime'],
                    "operType": "01",
                    "mode": "02",
                    "msgNo": headerList[0]['msgNo'],
                    "resentCount": "0",
                    "serialNo": serialnumber,
                    "servPointId": headerList[0]['servPointId'],
                    "branchId": appDatas.tenent,
                    "versionNo": versionlist[0] + "|" + DBVERSION!,
                    "fsTrackerSts": "2|1",
                    "tenantId": appDatas.tenent,
                    "lat": latitude,
                    "lon": longitude,
                  });

                  print('resentCount' +
                      headerList[0]['resentCount'] +
                      '->' +
                      custTxnsRefId);
                  int resentCount = int.parse(headerList[0]['resentCount']);

                  resentCount = resentCount + 1;
                  print('resentCount' + resentCount.toString());

                  String updateqry = 'UPDATE txnHeader SET resentCount =\'' +
                      resentCount.toString() +
                      '\' WHERE txnRefId LIKE "%' +
                      custTxnsRefId +
                      '%"';
                  int succ = await db.RawUpdate(updateqry);
                  print('succ' + succ.toString());

                  List<Map> coffeeData = await db.RawQuery(
                      "SELECT * FROM coffeePurchase where isSynched = 0 and recNo = '" +
                          custTxnsRefId +
                          "';");

                  for (int i = 0; i < coffeeData.length; i++) {
                    String purDate = coffeeData[i]['purDate'];
                    String season = coffeeData[i]['season'];
                    String batchNo = coffeeData[i]['batchNo'];
                    String buyingCenter = coffeeData[i]['buyingCenter'];
                    String farmerId = coffeeData[i]['farmerId'];
                    String farmerCode = coffeeData[i]['farmerCode'];
                    String farmId = coffeeData[i]['farmId'];
                    String coffeeType = coffeeData[i]['coffeeType'];
                    String coffeeVariety = coffeeData[i]['coffeeVariety'];
                    String coffeeGrade = coffeeData[i]['coffeeGrade'];
                    String noofBags = coffeeData[i]['noofBags'];
                    String quantity = coffeeData[i]['quantity'];
                    String priceKilogram = coffeeData[i]['priceKilogram'];
                    String totAmt = coffeeData[i]['totAmt'];
                    String amtPaid = coffeeData[i]['amtPaid'];
                    String recNo = coffeeData[i]['recNo'];
                    String premium = coffeeData[i]['premium'];

                    var reqdata = jsonEncode({
                      "body": {
                        "purDate": purDate,
                        "season": season,
                        "batchNo": batchNo,
                        "buyingCenter": buyingCenter,
                        "farmerId": farmerId,
                        "farmerCode": farmerCode,
                        "farmId": farmId,
                        "coffeeType": coffeeType,
                        "skuType": coffeeVariety,
                        "coffeeGrade": coffeeGrade,
                        "noBags": noofBags,
                        "quantity": quantity,
                        "price": priceKilogram,
                        "totAmt": totAmt,
                        "amtPaid": amtPaid,
                        "coffRecNo": recNo,
                        "premium": premium,
                        "latitude": coffeeData[i]['latitude'],
                        "longitude": coffeeData[i]['longitude'],
                      },
                      "head": jsonDecode(headdata)
                    });

                    printWrapped("coffeeData:" + reqdata);

                    Response response =
                        await Dio().post(appDatas.TXN_URL, data: reqdata);

                    print("response:" + response.toString());

                    final responsebody = json.decode(response.toString());
                    final jsonresponse = responsebody['Response'];
                    final statusobjectr = jsonresponse['status'];
                    final code = statusobjectr['code'];
                    final message = statusobjectr['message'];
                    if (code.toString() == '00') {
                      db.UpdateTableValue('coffeePurchase', 'isSynched', '1',
                          'recNo', custTxnsRefId);
                      db.DeleteTableRecord(
                          'custTransactions', 'txnRefId', custTxnsRefId);
                    } else {}
                  }
                } catch (Exception) {
                  print("txnexecutor err" + Exception.toString());
                }
              }

              //transfer
              if (txnConfigId == datas.txn_Txnprimaryprocess &&
                  agentId == "06") {
                try {
                  String ipAddressValue = '';
                  try {
                    final ipv4 = await Ipify.ipv4();
                    ipAddressValue = ipv4.toString();
                  } catch (e) {
                    ipAddressValue = '';
                  }

                  String latitude = '', longitude = '';
                  try {
                    Position position = await Geolocator.getCurrentPosition(
                        desiredAccuracy: LocationAccuracy.high);
                    latitude = position.latitude.toString();
                    longitude = position.longitude.toString();
                  } catch (e) {
                    latitude = '';
                    longitude = '';
                  }

                  String custTxnsRefId =
                      custTransactions[i]["txnRefId"].toString();
                  var db = DatabaseHelper();
                  String headerqry =
                      "select * from txnHeader where txnRefId  like '%" +
                          custTxnsRefId +
                          "%';";
                  List<Map> headerList = await db.RawQuery(headerqry);

                  print('txnexecutor headerList ' + headerList.toString());
                  print('txnexecutor headerList ' + headerqry);

                  var headdata = jsonEncode({
                    "agentId": headerList[0]['agentId'].replaceAll(' ', ''),
                    "agentToken":
                        headerList[0]['agentToken'].replaceAll(' ', ''),
                    "txnType": datas.txn_Txnprimaryprocess,
                    "txnTime": headerList[0]['txnTime'],
                    "operType": "01",
                    "mode": "02",
                    "msgNo": headerList[0]['msgNo'].replaceAll(' ', ''),
                    "resentCount":
                        headerList[0]['resentCount'].replaceAll(' ', ''),
                    "serialNo": serialnumber,
                    "servPointId":
                        headerList[0]['servPointId'].replaceAll(' ', ''),
                    "branchId": appDatas.tenent,
                    "versionNo": versionlist[0] + "|" + DBVERSION!,
                    "fsTrackerSts": "2|1",
                    "tenantId": appDatas.tenent,
                    "lat": latitude,
                    "lon": longitude,
                  });
                  int resentCount = int.parse(headerList[0]['resentCount']);
                  resentCount = resentCount + 1;
                  print('resentCount: ' + resentCount.toString());
                  String updateqry = 'UPDATE txnHeader SET resentCount =\'' +
                      resentCount.toString() +
                      '\' WHERE txnRefId LIKE "%' +
                      custTxnsRefId +
                      '%"';
                  int succ = await db.RawUpdate(updateqry);
                  print('succ:' + succ.toString());

                  List<Map> transferprimaryList = await db.RawQuery(
                      'select * from transferPrimary where isSynched = 0 and recNo=\'' +
                          custTxnsRefId +
                          '\'');
                  List<String> transferprimaryReqDetailList = [];
                  List<Map> transferprimaryReqList = await db.RawQuery(
                      "select * from transferList WHERE trRecieptNo='" +
                          custTxnsRefId +
                          "';");
                  print("transferprimaryReqList" +
                      transferprimaryReqList.toString());
                  for (int j = 0; j < transferprimaryReqList.length; j++) {
                    var reqtransferprimaryDet = jsonEncode({
                      // "trRecptNo": transferprimaryReqList[j]["trRecieptNo"],
                      "purchaseRecNo": transferprimaryReqList[j]["batchnumbr"]
                          .replaceAll(' ', ''),
                      // "fName": transferprimaryReqList[j]["farmerName"],
                      // "fCode": transferprimaryReqList[j]["farmerCode"],
                      // "frmName": transferprimaryReqList[j]["farmName"],
                      // "frmCode": transferprimaryReqList[i]['farmCode'],
                      // "coffType": transferprimaryReqList[j]["coffeeType"],
                      //"coffVariety": transferprimaryReqList[j]["coffeeVariety"],
                      // "coffGrade": transferprimaryReqList[j]["coffeeGrade"],
                      // "exstStk": transferprimaryReqList[j]["exstStock"],
                      // "totWtTransfd": transferprimaryReqList[j]["totalwght"]
                      //     .replaceAll(' ', ''),
                      // "noBags": transferprimaryReqList[j]["numofbags"]
                      //     .replaceAll(' ', ''),
                      "totalBag": transferprimaryReqList[j]['numofbags'],
                      "totalWht": transferprimaryReqList[j]['totalwght'],
                      "avaBag": transferprimaryReqList[j]['totalwght'],
                      "avaWht": transferprimaryReqList[j]['totalwght'],
                    });
                    transferprimaryReqDetailList.add(reqtransferprimaryDet);
                  }

                  for (int i = 0; i < transferprimaryList.length; i++) {
                    String? sender = transferprimaryList[i]["sender"];
                    String? reciver = transferprimaryList[i]["reciver"];
                    String? datetransfer =
                        transferprimaryList[i]["datetransfer"];
                    String? vehiclenumber =
                        transferprimaryList[i]["vehiclenumber"];
                    String? drivername = transferprimaryList[i]["drivername"];
                    String? isSynched =
                        transferprimaryList[i]["isSynched"].toString();
                    String? recNo = transferprimaryList[i]["recNo"];
                    /* String? latitude = transferprimaryList[i]["latitude"];
                    String? longitude = transferprimaryList[i]["longitude"];*/
                    String? TseasonCode = transferprimaryList[i]["seasonCode"];

                    String purRecNo = "";
                    String noBag = "";
                    String existBag = "";
                    String existKg = "";
                    String totWt = "";
                    for (int k = 0; k < transferprimaryReqList.length; k++) {
                      purRecNo = transferprimaryReqList[k]['batchnumbr'];
                      noBag = transferprimaryReqList[k]['numofbags'];
                      totWt = transferprimaryReqList[k]['totalwght'];
                      String exStock = transferprimaryReqList[k]['exstStock'];
                      List<String> existStock = exStock.split('/');
                      print('existstockval:' + existStock.toString());
                      existBag = existStock[1].toString();
                      existKg = existStock[0].toString();
                    }

                    var reqdata = jsonEncode({
                      "body": {
                        "sender": sender,
                        "reciever": reciver,
                        "datetransfer": datetransfer,
                        "vehiclenumber": vehiclenumber,
                        "drivername": drivername,
                        //"purchaseRecNo": purRecNo,
                        "totalBag": noBag,
                        "totalWht": totWt,
                        "avaBag": existBag,
                        "avaWht": existKg,
                        "seasonCode": TseasonCode,
                        "transRecNo": recNo,

                        // "trRecptNo": recNo,
                        "latitude": transferprimaryList[i]["latitude"],
                        "longitude": transferprimaryList[i]["longitude"],
                        "processType": "1",
                        "transferprimryReq":
                            jsonDecode(transferprimaryReqDetailList.toString()),
                        //"sBookinRenego": jsonDecode(seedBookingRenDetailList.toString()),
                      },
                      "head": jsonDecode(headdata)
                    });

                    printWrapped('transferprimaryreq ' + reqdata);

                    Response response =
                        await Dio().post(appDatas.TXN_URL, data: reqdata);

                    final responsebody = json.decode(response.toString());
                    final jsonresponse = responsebody['Response'];
                    final statusobjectr = jsonresponse['status'];
                    final code = statusobjectr['code'];
                    final message = statusobjectr['message'];

                    if (code.toString() == '00') {
                      db.UpdateTableValue('transferPrimary', 'isSynched', '1',
                          'recNo', custTxnsRefId);
                      db.DeleteTableRecord(
                          'custTransactions', 'txnRefId', custTxnsRefId);
                      // toast('synced successfull');
                    } else {}
                  }
                } catch (Exception) {
                  print("txnexecutor err " + Exception.toString());
                }
              }
              //input demand
              else if (txnConfigId == datas.txn_inputDemand) {
                try {
                  String ipAddressValue = '';
                  try {
                    final ipv4 = await Ipify.ipv4();
                    ipAddressValue = ipv4.toString();
                  } catch (e) {
                    ipAddressValue = '';
                  }

                  String latitude = '', longitude = '';
                  try {
                    Position position = await Geolocator.getCurrentPosition(
                        desiredAccuracy: LocationAccuracy.high);
                    latitude = position.latitude.toString();
                    longitude = position.longitude.toString();
                  } catch (e) {
                    latitude = '';
                    longitude = '';
                  }

                  String custTxnsRefId =
                      custTransactions[i]["txnRefId"].toString();
                  print("custTxnsRefId" + custTxnsRefId);

                  String headerqry =
                      "select * from txnHeader where txnRefId like '%" +
                          custTxnsRefId +
                          "%';";

                  List<Map> headerList = await db.RawQuery(headerqry);

                  print("headerList:" + headerList.toString());

                  print('txnexecutor headerList ' + headerqry);
                  var headdata = jsonEncode({
                    "agentId": headerList[0]['agentId'],
                    "agentToken": headerList[0]['agentToken'],
                    "txnType": datas.txn_inputDemand,
                    "txnTime": headerList[0]['txnTime'],
                    "operType": "01",
                    "mode": "02",
                    "msgNo": headerList[0]['msgNo'],
                    "resentCount": "0",
                    "serialNo": serialnumber,
                    "servPointId": headerList[0]['servPointId'],
                    "branchId": appDatas.tenent,
                    "versionNo": versionlist[0] + "|" + DBVERSION!,
                    "fsTrackerSts": "2|1",
                    "tenantId": appDatas.tenent,
                    "lat": latitude,
                    "lon": longitude,
                  });

                  print("head data:" + headdata);

                  print('resentCount' +
                      headerList[0]['resentCount'] +
                      '->' +
                      custTxnsRefId);
                  int resentCount = int.parse(headerList[0]['resentCount']);

                  resentCount = resentCount + 1;
                  print('resentCount' + resentCount.toString());

                  String updateqry = 'UPDATE txnHeader SET resentCount =\'' +
                      resentCount.toString() +
                      '\' WHERE txnRefId LIKE "%' +
                      custTxnsRefId +
                      '%"';
                  int succ = await db.RawUpdate(updateqry);
                  print('success' + succ.toString());

                  List<Map> inputDemand = await db.RawQuery(
                      "SELECT * FROM inputDemand where isSynched = 0 and recNo = '" +
                          custTxnsRefId +
                          "';");

                  for (int i = 0; i < inputDemand.length; i++) {
                    String registrationDate = inputDemand[i]['date'];
                    String farmerOrg = inputDemand[i]['farmerOrg'];
                    String inputType = inputDemand[i]['inputType'];
                    String country = inputDemand[i]['country'];
                    String district = inputDemand[i]['district'];
                    String subcountry = inputDemand[i]['subcountry'];
                    String parish = inputDemand[i]['parish'];
                    /*String latitude = inputDemand[i]['latitude'];
                    String longitude = inputDemand[i]['longitude'];*/
                    String seasonCode = inputDemand[i]['season'];
                    String transType = inputDemand[i]['transType'];

                    List<Map> inputDemandlist = await db.RawQuery(
                        "SELECT * from inputDemandDetail where recNo = '" +
                            custTxnsRefId +
                            "';");
                    print("inputDemandDetail" + inputDemandlist.toString());

                    List<String> inputJsonList = [];
                    for (int j = 0; j < inputDemandlist.length; j++) {
                      var reqInpDem = jsonEncode({
                        "village": inputDemandlist[j]["village"],
                        "farmer": inputDemandlist[j]["farmer"],
                        "farmId": inputDemandlist[j]["farmId"],
                        "tottrees": inputDemandlist[j]["tottrees"],
                        "nooftrees": inputDemandlist[j]["nooftrees"],
                        "gender": inputDemandlist[j]["gender"],
                        "age": inputDemandlist[j]["age"],
                        "nin": inputDemandlist[j]["nin"],
                        "mobile": inputDemandlist[j]["mobNo"],
                        "inputType": inputDemandlist[j]["inputType"],
                        "productCode": inputDemandlist[j]["productCode"],
                        "demandQty": inputDemandlist[j]["demand"],
                        "distQty": "0"
                      });
                      inputJsonList.add(reqInpDem);
                    }

                    var reqdata = jsonEncode({
                      // "Request": {
                      "body": {
                        "trnsType": transType,
                        "date": registrationDate,
                        "cooperative": farmerOrg,
                        "country": country,
                        "district": district,
                        "subcountry": subcountry,
                        "parish": parish,
                        //"inputType": inputType,
                        "latitude": inputDemand[i]['latitude'],
                        "longitude": inputDemand[i]['longitude'],
                        "seCode": seasonCode,
                        "recNo": custTxnsRefId,
                        "productList": jsonDecode(inputJsonList.toString())
                      },
                      "head": jsonDecode(headdata),
                      // }
                    });
                    printWrapped('InputDemandReqpacket ' + reqdata);

                    Response response =
                        await Dio().post(appDatas.TXN_URL, data: reqdata);
                    print(" InputDemandResponse" + response.toString());

                    final responsebody = json.decode(response.toString());
                    final jsonresponse = responsebody['Response'];
                    final statusobjectr = jsonresponse['status'];
                    final code = statusobjectr['code'];
                    final message = statusobjectr['message'];

                    if (code.toString() == '00') {
                      db.UpdateTableValue('inputDemand', 'isSynched', '1',
                          'recNo', custTxnsRefId);
                      db.DeleteTableRecord(
                          'custTransactions', 'txnRefId', custTxnsRefId);
                      // toast('synced successfull');
                    } else {}
                  }
                } catch (Exception) {
                  print("txnexecutor err " + Exception.toString());
                }
              }

              //input distribution

              else if (txnConfigId == datas.txn_inputDistribution) {
                try {
                  String ipAddressValue = '';
                  try {
                    final ipv4 = await Ipify.ipv4();
                    ipAddressValue = ipv4.toString();
                  } catch (e) {
                    ipAddressValue = '';
                  }

                  String latitude = '', longitude = '';
                  try {
                    Position position = await Geolocator.getCurrentPosition(
                        desiredAccuracy: LocationAccuracy.high);
                    latitude = position.latitude.toString();
                    longitude = position.longitude.toString();
                  } catch (e) {
                    latitude = '';
                    longitude = '';
                  }

                  String custTxnsRefId =
                      custTransactions[i]["txnRefId"].toString();
                  print("custTxnsRefId" + custTxnsRefId);

                  String headerqry =
                      "select * from txnHeader where txnRefId like '%" +
                          custTxnsRefId +
                          "%';";

                  List<Map> headerList = await db.RawQuery(headerqry);

                  print("headerList:" + headerList.toString());

                  print('txnexecutor headerList ' + headerqry);
                  var headdata = jsonEncode({
                    "agentId": headerList[0]['agentId'],
                    "agentToken": headerList[0]['agentToken'],
                    "txnType": datas.txn_inputDemand,
                    "txnTime": headerList[0]['txnTime'],
                    "operType": "01",
                    "mode": "02",
                    "msgNo": headerList[0]['msgNo'],
                    "resentCount": "0",
                    "serialNo": serialnumber,
                    "servPointId": headerList[0]['servPointId'],
                    "branchId": appDatas.tenent,
                    "versionNo": versionlist[0] + "|" + DBVERSION!,
                    "fsTrackerSts": "2|1",
                    "tenantId": appDatas.tenent,
                    "lat": latitude,
                    "lon": longitude,
                  });

                  print("head data:" + headdata);

                  print('resentCount' +
                      headerList[0]['resentCount'] +
                      '->' +
                      custTxnsRefId);
                  int resentCount = int.parse(headerList[0]['resentCount']);

                  resentCount = resentCount + 1;
                  print('resentCount' + resentCount.toString());

                  String updateqry = 'UPDATE txnHeader SET resentCount =\'' +
                      resentCount.toString() +
                      '\' WHERE txnRefId LIKE "%' +
                      custTxnsRefId +
                      '%"';
                  int succ = await db.RawUpdate(updateqry);
                  print('success' + succ.toString());

                  List<Map> inputDemand = await db.RawQuery(
                      "SELECT * FROM inputDistribution where isSynched = 0 and recNo = '" +
                          custTxnsRefId +
                          "';");

                  print("inputdistributionvalue:" + inputDemand.toString());

                  for (int i = 0; i < inputDemand.length; i++) {
                    String registrationDate = inputDemand[i]['date'];
                    String farmerOrg = inputDemand[i]['farmerOrg'];
                    String inputType = inputDemand[i]['inputType'];
                    String country = inputDemand[i]['country'];
                    String district = inputDemand[i]['district'];
                    String subcountry = inputDemand[i]['subcountry'];
                    String parish = inputDemand[i]['parish'];
                    /* String latitude = inputDemand[i]['latitude'];
                    String longitude = inputDemand[i]['longitude'];*/
                    String seasonCode = inputDemand[i]['seasonCode'];
                    String transType = inputDemand[i]['transType'];

                    List<Map> inputDemandlist = await db.RawQuery(
                        "SELECT * from inputDistributionDetail where recNo = '" +
                            custTxnsRefId +
                            "';");
                    print("inputDemandDetail" + inputDemandlist.toString());

                    List<String> inputJsonList = [];
                    for (int j = 0; j < inputDemandlist.length; j++) {
                      var reqInpDem = jsonEncode({
                        "village": inputDemandlist[j]["village"],
                        "farmer": inputDemandlist[j]["farmer"],
                        "gender": inputDemandlist[j]["gender"],
                        "age": inputDemandlist[j]["age"],
                        "nin": inputDemandlist[j]["nin"],
                        "mobile": inputDemandlist[j]["mobNo"],
                        "productCode": inputDemandlist[j]["productCode"],
                        "demandQty": inputDemandlist[j]["demand"],
                        "distQty": inputDemandlist[j]["distributeQty"],
                        "dId": inputDemandlist[j]["demBatchNo"]
                      });
                      inputJsonList.add(reqInpDem);
                    }

                    var reqdata = jsonEncode({
                      // "Request": {
                      "body": {
                        "trnsType": transType,
                        "recNo": custTxnsRefId,
                        "date": registrationDate,
                        "cooperative": farmerOrg,
                        "inputType": inputType,
                        "country": country,
                        "district": district,
                        "subcountry": subcountry,
                        "parish": parish,
                        "latitude": inputDemand[i]['latitude'],
                        "longitude": inputDemand[i]['longitude'],
                        "seCode": seasonCode,
                        "productList": jsonDecode(inputJsonList.toString())
                      },
                      "head": jsonDecode(headdata),
                      // }
                    });
                    printWrapped('inputdistributionreq ' + reqdata);

                    Response response =
                        await Dio().post(appDatas.TXN_URL, data: reqdata);
                    print(" inputdistributionresponse" + response.toString());

                    final responsebody = json.decode(response.toString());
                    final jsonresponse = responsebody['Response'];
                    final statusobjectr = jsonresponse['status'];
                    final code = statusobjectr['code'];
                    final message = statusobjectr['message'];

                    if (code.toString() == '00') {
                      db.UpdateTableValue('inputDistribution', 'isSynched', '1',
                          'recNo', custTxnsRefId);
                      db.DeleteTableRecord(
                          'custTransactions', 'txnRefId', custTxnsRefId);
                      // toast('synced successfull');
                    } else {}
                  }
                } catch (Exception) {
                  print("txnexecutor err " + Exception.toString());
                }
              }
              //reception

              else if (txnConfigId == datas.txn_reception && agentId == "05") {
                try {
                  String ipAddressValue = '';
                  try {
                    final ipv4 = await Ipify.ipv4();
                    ipAddressValue = ipv4.toString();
                  } catch (e) {
                    ipAddressValue = '';
                  }

                  String latitude = '', longitude = '';
                  try {
                    Position position = await Geolocator.getCurrentPosition(
                        desiredAccuracy: LocationAccuracy.high);
                    latitude = position.latitude.toString();
                    longitude = position.longitude.toString();
                  } catch (e) {
                    latitude = '';
                    longitude = '';
                  }

                  String custTxnsRefId =
                      custTransactions[i]["txnRefId"].toString();
                  print("custTxnsRefId" + custTxnsRefId);

                  String headerqry =
                      "select * from txnHeader where txnRefId like '%" +
                          custTxnsRefId +
                          "%';";

                  List<Map> headerList = await db.RawQuery(headerqry);

                  print("headerList:" + headerList.toString());

                  print('txnexecutor headerList ' + headerqry);
                  var headdata = jsonEncode({
                    "agentId": headerList[0]['agentId'],
                    "agentToken": headerList[0]['agentToken'],
                    "txnType": datas.txn_reception,
                    "txnTime": headerList[0]['txnTime'],
                    "operType": "01",
                    "mode": "02",
                    "msgNo": headerList[0]['msgNo'],
                    "resentCount": "0",
                    "serialNo": serialnumber,
                    "servPointId": headerList[0]['servPointId'],
                    "branchId": appDatas.tenent,
                    "versionNo": versionlist[0] + "|" + DBVERSION!,
                    "fsTrackerSts": "2|1",
                    "tenantId": appDatas.tenent,
                    "lat": latitude,
                    "lon": longitude,
                  });

                  print("head data:" + headdata);

                  print('resentCount' +
                      headerList[0]['resentCount'] +
                      '->' +
                      custTxnsRefId);
                  int resentCount = int.parse(headerList[0]['resentCount']);

                  resentCount = resentCount + 1;
                  print('resentCount' + resentCount.toString());

                  String updateqry = 'UPDATE txnHeader SET resentCount =\'' +
                      resentCount.toString() +
                      '\' WHERE txnRefId LIKE "%' +
                      custTxnsRefId +
                      '%"';
                  int succ = await db.RawUpdate(updateqry);
                  print('succ' + succ.toString());

                  List<Map> reception = await db.RawQuery(
                      "SELECT * FROM reception where isSynched = 0 and recNo = '" +
                          custTxnsRefId +
                          "';");

                  for (int i = 0; i < reception.length; i++) {
                    String recNo = reception[i]['recNo'];
                    String isSynched = reception[i]['isSynched'].toString();
                    //String msgNo = reception[i]['msgNo'];
                    String receiver = reception[i]['receiver'];
                    String date = reception[i]['msgNo'];
                    String transferReceiptNo =
                        reception[i]['transferReceiptNo'];
                    String transferDate = reception[i]['transferDate'];
                    String vehicleNo = reception[i]['vehicleNo'];
                    String driverName = reception[i]['driverName'];
                    /*String latitude = reception[i]['latitude'];
                    String longitude = reception[i]['longitude'];*/
                    String seasonCode = reception[i]['seasonCode'];

                    List<Map> receptlist = await db.RawQuery(
                        "SELECT * from receptionDetail where recNo = '" +
                            custTxnsRefId +
                            "';");
                    print("receptionDetailDetail" + receptlist.toString());

                    List<String> inputJsonList = [];
                    for (int j = 0; j < receptlist.length; j++) {
                      var reqInpDem = jsonEncode({
                        "purchaseReceiptNo": receptlist[j]["purchaseReceiptNo"],
                        "farmerCode": receptlist[j]["farmerCode"],
                        "farmer": receptlist[j]["farmerName"],
                        "farm": receptlist[j]["farm"],
                        "frmCode": receptlist[j]["farmCode"],
                        "coffeeType": receptlist[j]["coffeeType"],
                        //"coffeeVariety": receptlist[j]["coffeeVariety"],
                        "grade": receptlist[j]["grade"],
                        "bagsTransferred": receptlist[j]["bagsTransferred"],
                        "weightTransferred": receptlist[j]["weightTransferred"],
                        "bagsReceived": receptlist[j]["bagsReceived"],
                        "weightReceived": receptlist[j]["weightReceived"],
                      });
                      inputJsonList.add(reqInpDem);
                    }

                    var reqdata = jsonEncode({
                      // "Request": {x
                      "body": {
                        "receiver": receiver,
                        "date": date,
                        "transferReceiptNo": transferReceiptNo,
                        "transferDate": transferDate,
                        "vehicleNo": vehicleNo,
                        "driverName": driverName,
                        "seasonCode": seasonCode,
                        "latitude": reception[i]['latitude'],
                        "longitude": reception[i]['longitude'],
                        "processType": "1",
                        "productList": jsonDecode(inputJsonList.toString())
                      },
                      "head": jsonDecode(headdata),
                      // }
                    });
                    printWrapped('receptionReqpacket ' + reqdata);

                    Response response =
                        await Dio().post(appDatas.TXN_URL, data: reqdata);
                    print(" Response" + response.toString());

                    final responsebody = json.decode(response.toString());
                    final jsonresponse = responsebody['Response'];
                    final statusobjectr = jsonresponse['status'];
                    final code = statusobjectr['code'];
                    final message = statusobjectr['message'];

                    if (code.toString() == '00') {
                      db.UpdateTableValue('reception', 'isSynched', '1',
                          'recNo', custTxnsRefId);
                      db.DeleteTableRecord(
                          'custTransactions', 'txnRefId', custTxnsRefId);
                      // toast('synced successfull');
                    } else {}
                  }
                } catch (Exception) {
                  print("txnexecutor err " + Exception.toString());
                }
              }
              //planting

              //nurseryseedgardeninspection
              else if (txnConfigId == datas.nurserySeedGardenInspection) {
                try {
                  String ipAddressValue = '';
                  try {
                    final ipv4 = await Ipify.ipv4();
                    ipAddressValue = ipv4.toString();
                  } catch (e) {
                    ipAddressValue = '';
                  }

                  String latitude = '', longitude = '';
                  try {
                    Position position = await Geolocator.getCurrentPosition(
                        desiredAccuracy: LocationAccuracy.high);
                    latitude = position.latitude.toString();
                    longitude = position.longitude.toString();
                  } catch (e) {
                    latitude = '';
                    longitude = '';
                  }

                  String custTxnsRefId =
                      custTransactions[i]["txnRefId"].toString();
                  print("custom transaction id:" + custTxnsRefId);

                  String headerqry =
                      "select * from txnHeader where txnRefId like '%" +
                          custTxnsRefId +
                          "%';";

                  List<Map> headerList = await db.RawQuery(headerqry);
                  var headdata = jsonEncode({
                    "agentId": headerList[0]['agentId'],
                    "agentToken": headerList[0]['agentToken'],
                    "txnType": datas.nurserySeedGardenInspection,
                    "txnTime": headerList[0]['txnTime'],
                    "operType": "01",
                    "mode": "02",
                    "msgNo": headerList[0]['msgNo'],
                    "resentCount": "0",
                    "serialNo": serialnumber,
                    "servPointId": headerList[0]['servPointId'],
                    "branchId": appDatas.tenent,
                    "versionNo": versionlist[0] + "|" + DBVERSION!,
                    "fsTrackerSts": "2|1",
                    "tenantId": appDatas.tenent,
                    "lat": latitude,
                    "lon": longitude,
                  });

                  print('resentCount' +
                      headerList[0]['resentCount'] +
                      '->' +
                      custTxnsRefId);
                  int resentCount = int.parse(headerList[0]['resentCount']);

                  resentCount = resentCount + 1;
                  print('resentCount' + resentCount.toString());

                  String updateqry = 'UPDATE txnHeader SET resentCount =\'' +
                      resentCount.toString() +
                      '\' WHERE txnRefId LIKE "%' +
                      custTxnsRefId +
                      '%"';
                  int succ = await db.RawUpdate(updateqry);
                  print('succ' + succ.toString());

                  List<Map> coffeeData = await db.RawQuery(
                      "SELECT * FROM coffeeSeedNursery where isSynched = 0 and recNo = '" +
                          custTxnsRefId +
                          "';");

                  for (int i = 0; i < coffeeData.length; i++) {
                    String date = coffeeData[i]['Date'];
                    String certificateNum = coffeeData[i]['certificateNum'];
                    String coffeeSeedNuName = coffeeData[i]['coffeeSeNuName'];
                    String plottingMaterial = coffeeData[i]['plottingMaterial'];
                    String blackSoil = coffeeData[i]['blackSoil'];
                    String lakeSand = coffeeData[i]['lakeSand'];
                    String sawDust = coffeeData[i]['sawDust'];
                    String soil = coffeeData[i]['soil'];
                    String rootHormone = coffeeData[i]['rootHormone'];
                    String perforatedPots = coffeeData[i]['perforatedPots'];
                    String reliableWater = coffeeData[i]['relWaterSrc'];
                    String floatingFacility = coffeeData[i]['floFacility'];
                    String pulper = coffeeData[i]['pulper'];
                    String dryShed = coffeeData[i]['dryShed'];
                    String stoFacility = coffeeData[i]['stoFacility'];
                    String photo = coffeeData[i]['photo'];
                    String recommendation = coffeeData[i]['recommendation'];
                    String suitableStatus = coffeeData[i]['suitableStatus'];
                    String wellDrained = coffeeData[i]['wellDrained'];
                    String rootingCage = coffeeData[i]['rootingCage'];
                    String hardShed = coffeeData[i]['hardShed'];
                    String demonPlot = coffeeData[i]['demonPlot'];
                    String sanitaryFac = coffeeData[i]['sanitaryFac'];
                    String offRecords = coffeeData[i]['offRecords'];
                    String garDisposal = coffeeData[i]['garDisposal'];
                    String nurseryPropagation = coffeeData[i]['nurProShed'];
                    String labelIndicatingCoffee = coffeeData[i]['labIndiCoff'];
                    String vegetativePhase = coffeeData[i]['vegPhase'];
                    String recCoffVar = coffeeData[i]['recCoffVar'];
                    String recNo = coffeeData[i]['recNo'];
                    /*String latitude = coffeeData[i]['latitude'];
                    String longitude = coffeeData[i]['longitude'];*/
                    String seasonCode = coffeeData[i]['seasonCode'];
                    String inspReqId = coffeeData[i]['inspReqId'];
                    String type = coffeeData[i]['name'];
                    String name = coffeeData[i]['type'];
                    String plotImp = coffeeData[i]['plotImp'];
                    String blackImp = coffeeData[i]['blackImp'];
                    String lakeImp = coffeeData[i]['lakeImp'];
                    String sawImp = coffeeData[i]['sawImp'];
                    String soilImp = coffeeData[i]['soilImp'];
                    String rootImp = coffeeData[i]['rootImp'];
                    String perforatedImp = coffeeData[i]['perforatedImp'];
                    String waterImp = coffeeData[i]['waterImp'];
                    String floatingImp = coffeeData[i]['floFacImp'];
                    String pulperImp = coffeeData[i]['pulperImp'];
                    String dryShedImp = coffeeData[i]['dryShedImp'];
                    String stoFacImp = coffeeData[i]['stoFacImp'];
                    String wellDrainedImp = coffeeData[i]['wellDrainedImp'];
                    String rootCageImp = coffeeData[i]['rootCageImp'];
                    String hardShedImp = coffeeData[i]['hardShedImp'];
                    String demonPlotImp = coffeeData[i]['demPlotImp'];
                    String sanFacImp = coffeeData[i]['sanFacImp'];
                    String offRecImp = coffeeData[i]['offRecImp'];
                    String garDisImp = coffeeData[i]['garDisImp'];
                    String nurProImp = coffeeData[i]['nurProImp'];
                    String labelIndiImp = coffeeData[i]['labelIndiImp'];
                    String vegPhaseImp = coffeeData[i]['vegPhaseImp'];
                    String recCoffImp = coffeeData[i]['recCoffImp'];
                    String villageId = coffeeData[i]['villageId'];
                    String suitableStsImp = coffeeData[i]['suitableSts'];
                    String pest = coffeeData[i]['pest'];
                    String appl = coffeeData[i]['appl'];
                    String pestImp = coffeeData[i]['pestImp'];
                    String appImp = coffeeData[i]['appImp'];
                    String capacity = coffeeData[i]['capacity'];
                    String seedProcure = coffeeData[i]['seedProcure'];
                    String inspPhoto = "";
                    if (photo != "") {
                      File _inspImg = File(photo);
                      List<int> imageBytes = _inspImg.readAsBytesSync();
                      inspPhoto = base64Encode(imageBytes);
                    }

                    var reqdata = jsonEncode({
                      "body": {
                        "date": date,
                        "certNum": certificateNum,
                        "cffName": coffeeSeedNuName,
                        "plotMat": plottingMaterial,
                        "plotMatImp": plotImp,
                        "blSoil": blackSoil,
                        "blSoilImp": blackImp,
                        "lkSand": lakeSand,
                        "lkSandImp": lakeImp,
                        "swDst": sawDust,
                        "swDstImp": sawImp,
                        "soil": soil,
                        "soilImp": soilImp,
                        "rootHor": rootHormone,
                        "rootHorImp": rootImp,
                        "blPot": perforatedPots,
                        "blPotImp": perforatedImp,
                        "rekWtSource": reliableWater,
                        "rekWtSourceImp": waterImp,
                        "flotFac": floatingFacility,
                        "flotFacImp": floatingImp,
                        "pulper": pulper,
                        "pulperImp": pulperImp,
                        "drySh": dryShed,
                        "dryShImp": dryShedImp,
                        "storageFac": stoFacility,
                        "storageFacImp": stoFacImp,
                        "photo": inspPhoto,
                        "recom": recommendation,
                        "suiStatus": suitableStatus,
                        "suiStatusImp": suitableStsImp,
                        "srhm": rootHormone,
                        "srhmImp": rootImp,
                        "welFreeLand": wellDrained,
                        "welFreeLandImp": wellDrainedImp,
                        "rootCage": rootingCage,
                        "rootCageImp": rootCageImp,
                        "hardShed": hardShed,
                        "hardShedImp": hardShedImp,
                        "demoPlot": demonPlot,
                        "demoPlotImp": demonPlotImp,
                        "sanFaci": sanitaryFac,
                        "sanFaciImp": sanFacImp,
                        "ofcWithRec": offRecords,
                        "ofcWithRecImp": offRecImp,
                        "garbDisp": garDisposal,
                        "garbDispImp": garDisImp,
                        "nurProgShed": nurseryPropagation,
                        "nurProgShedImp": nurProImp,
                        "labCffVar": labelIndicatingCoffee,
                        "labCffVarImp": labelIndiImp,
                        "vegPhase": vegetativePhase,
                        "vegPhaseImp": vegPhaseImp,
                        "recomCoffVar": recCoffVar,
                        "recomCoffVarImp": recCoffImp,
                        "recNo": recNo,
                        "cSeasonCode": seasonCode,
                        //value changes done /*important*/
                        "inspReqId": name,
                        "inspReqData": type,
                        "village": villageId,
                        "latitude": coffeeData[i]['latitude'],
                        "longitude": coffeeData[i]['longitude'],
                        "opname": inspReqId,
                        "pstSts": pest,
                        "appGpa": appl,
                        "pstStsImp": pestImp,
                        "appGpaImp": appImp,
                        "capacity": capacity,
                        "amtSeedPro": seedProcure
                      },
                      "head": jsonDecode(headdata)
                    });

                    printWrapped("coffeeSeedNursery:" + reqdata);

                    Response response =
                        await Dio().post(appDatas.TXN_URL, data: reqdata);

                    print("response:" + response.toString());

                    final responsebody = json.decode(response.toString());
                    final jsonresponse = responsebody['Response'];
                    final statusobjectr = jsonresponse['status'];
                    final code = statusobjectr['code'];
                    final message = statusobjectr['message'];
                    if (code.toString() == '00') {
                      db.UpdateTableValue('coffeeSeedNursery', 'isSynched', '1',
                          'recNo', custTxnsRefId);
                      db.DeleteTableRecord(
                          'custTransactions', 'txnRefId', custTxnsRefId);
                    } else {}
                  }
                } catch (Exception) {
                  print("txnexecutor err" + Exception.toString());
                }
              }

              /*Peimary Processing*/
              else if (txnConfigId == datas.txnPrimaryProcessing &&
                  agentId == "05") {
                try {
                  String ipAddressValue = '';
                  try {
                    final ipv4 = await Ipify.ipv4();
                    ipAddressValue = ipv4.toString();
                  } catch (e) {
                    ipAddressValue = '';
                  }

                  String latitude = '', longitude = '';
                  try {
                    Position position = await Geolocator.getCurrentPosition(
                        desiredAccuracy: LocationAccuracy.high);
                    latitude = position.latitude.toString();
                    longitude = position.longitude.toString();
                  } catch (e) {
                    latitude = '';
                    longitude = '';
                  }

                  String custTxnsRefId =
                      custTransactions[i]["txnRefId"].toString();
                  print("custTxnsRefId" + custTxnsRefId);

                  String headerqry =
                      "select * from txnHeader where txnRefId like '%" +
                          custTxnsRefId +
                          "%';";

                  List<Map> headerList = await db.RawQuery(headerqry);

                  print("headerList:" + headerList.toString());

                  print('txnexecutor headerList ' + headerqry);
                  var headdata = jsonEncode({
                    "agentId": headerList[0]['agentId'],
                    "agentToken": headerList[0]['agentToken'],
                    "txnType": datas.txnPrimaryProcessing,
                    "txnTime": headerList[0]['txnTime'],
                    "operType": "01",
                    "mode": "02",
                    "msgNo": headerList[0]['msgNo'],
                    "resentCount": "0",
                    "serialNo": serialnumber,
                    "servPointId": headerList[0]['servPointId'],
                    "branchId": appDatas.tenent,
                    "versionNo": versionlist[0] + "|" + DBVERSION!,
                    "fsTrackerSts": "2|1",
                    "tenantId": appDatas.tenent,
                    "lat": latitude,
                    "lon": longitude,
                  });

                  print("head data:" + headdata);

                  print('resentCount' +
                      headerList[0]['resentCount'] +
                      '->' +
                      custTxnsRefId);
                  int resentCount = int.parse(headerList[0]['resentCount']);

                  resentCount = resentCount + 1;
                  print('resentCount' + resentCount.toString());

                  String updateqry = 'UPDATE txnHeader SET resentCount =\'' +
                      resentCount.toString() +
                      '\' WHERE txnRefId LIKE "%' +
                      custTxnsRefId +
                      '%"';
                  int succ = await db.RawUpdate(updateqry);
                  print('succ' + succ.toString());

                  List<Map> primaryProcessing = await db.RawQuery(
                      "SELECT * FROM primaryProcessing where isSynched = 0 and recNo = '" +
                          custTxnsRefId +
                          "';");

                  for (int i = 0; i < primaryProcessing.length; i++) {
                    List<Map> primaryProcessingList = await db.RawQuery(
                        "SELECT * from primaryProcessingDetail where recNo = '" +
                            custTxnsRefId +
                            "';");
                    print("primaryProcessingList" +
                        primaryProcessingList.toString());

                    List<String> inputJsonList = [];
                    for (int j = 0; j < primaryProcessingList.length; j++) {
                      var reqInpDem = jsonEncode({
                        "grade": primaryProcessingList[j]['grade'],
                        "avaBg": primaryProcessingList[j]['avlBags'],
                        "avaWt": primaryProcessingList[j]['avlKgs'],
                        "ioBag": primaryProcessingList[j]['inputBags'],
                        "ioKg": primaryProcessingList[j]['inputKgs'],
                        "opBag": primaryProcessingList[j]['outputBags'],
                        "opKg": primaryProcessingList[j]['outputKgs'],
                        "ioTotal": primaryProcessingList[j]['inputTotal'],
                        "opTotal": primaryProcessingList[j]['outputTotal']
                      });
                      inputJsonList.add(reqInpDem);
                    }

                    var reqdata = jsonEncode({
                      // "Request": {
                      "body": {
                        "date": primaryProcessing[i]['date'],
                        "batchNo": primaryProcessing[i]['batchNo'],
                        "customer": primaryProcessing[i]['customer'],
                        "startDate": primaryProcessing[i]['dateStarted'],
                        "startTime": primaryProcessing[i]['timeStarted'],
                        "endDate": primaryProcessing[i]['dateFinished'],
                        "endTime": primaryProcessing[i]['timeFinished'],
                        "skuType": primaryProcessing[i]['skuType'],
                        "preCln": primaryProcessing[i]['preClean'],
                        "stones": primaryProcessing[i]['stones'],
                        "wasteGrade": primaryProcessing[i]['wasteGrade'],
                        "wnoBag": primaryProcessing[i]['totalWBags'],
                        "wastTotal": primaryProcessing[i]['wnoBag'],
                        "rej1": primaryProcessing[i]['reject1899'],
                        "rej2": primaryProcessing[i]['reject1599'],
                        "rej3": primaryProcessing[i]['reject1299'],
                        "rej4": primaryProcessing[i]['reject1199'],
                        "grnoBag": primaryProcessing[i]['totalGBags'],
                        "rejTotal": primaryProcessing[i]['gnoBag'],
                        "receiptNo": primaryProcessing[i]['recNo'],
                        "latitude": primaryProcessing[i]['latitude'],
                        "longitude": primaryProcessing[i]['longitude'],
                        "seasonCode": primaryProcessing[i]['seasonCode'],
                        "processType": "3",
                        "gradeList": jsonDecode(inputJsonList.toString())
                      },
                      "head": jsonDecode(headdata),
                      // }
                    });
                    printWrapped('primaryProcessingReq ' + reqdata);

                    Response response =
                        await Dio().post(appDatas.TXN_URL, data: reqdata);
                    print(" primaryProcessingResponse" + response.toString());

                    final responsebody = json.decode(response.toString());
                    final jsonresponse = responsebody['Response'];
                    final statusobjectr = jsonresponse['status'];
                    final code = statusobjectr['code'];
                    final message = statusobjectr['message'];

                    if (code.toString() == '00') {
                      db.UpdateTableValue('primaryProcessing', 'isSynched', '1',
                          'recNo', custTxnsRefId);
                      db.DeleteTableRecord(
                          'custTransactions', 'txnRefId', custTxnsRefId);
                      // toast('synced successfull');
                    } else {}
                  }
                } catch (Exception) {
                  print("txnexecutor err " + Exception.toString());
                }
              }

              //exporter purchase
              else if (txnConfigId == datas.exporterPurchase &&
                  agentId == "05") {
                try {
                  String ipAddressValue = '';
                  try {
                    final ipv4 = await Ipify.ipv4();
                    ipAddressValue = ipv4.toString();
                  } catch (e) {
                    ipAddressValue = '';
                  }

                  String latitude = '', longitude = '';
                  try {
                    Position position = await Geolocator.getCurrentPosition(
                        desiredAccuracy: LocationAccuracy.high);
                    latitude = position.latitude.toString();
                    longitude = position.longitude.toString();
                  } catch (e) {
                    latitude = '';
                    longitude = '';
                  }

                  String custTxnsRefId =
                      custTransactions[i]["txnRefId"].toString();
                  var db = DatabaseHelper();
                  String headerqry =
                      "select * from txnHeader where txnRefId  like '%" +
                          custTxnsRefId +
                          "%';";
                  List<Map> headerList = await db.RawQuery(headerqry);

                  print('txnexecutor headerList ' + headerList.toString());
                  print('txnexecutor headerList ' + headerqry);

                  var headdata = jsonEncode({
                    "agentId": headerList[0]['agentId'].replaceAll(' ', ''),
                    "agentToken":
                        headerList[0]['agentToken'].replaceAll(' ', ''),
                    "txnType": "376",
                    "txnTime": headerList[0]['txnTime'],
                    "operType": "01",
                    "mode": "02",
                    "msgNo": headerList[0]['msgNo'].replaceAll(' ', ''),
                    "resentCount":
                        headerList[0]['resentCount'].replaceAll(' ', ''),
                    "serialNo": serialnumber,
                    "servPointId":
                        headerList[0]['servPointId'].replaceAll(' ', ''),
                    "branchId": appDatas.tenent,
                    "versionNo": versionlist[0] + "|" + DBVERSION!,
                    "fsTrackerSts": "2|1",
                    "tenantId": appDatas.tenent,
                    "lat": latitude,
                    "lon": longitude,
                  });
                  int resentCount = int.parse(headerList[0]['resentCount']);
                  resentCount = resentCount + 1;
                  print('resentCount: ' + resentCount.toString());
                  String updateqry = 'UPDATE txnHeader SET resentCount =\'' +
                      resentCount.toString() +
                      '\' WHERE txnRefId LIKE "%' +
                      custTxnsRefId +
                      '%"';
                  int succ = await db.RawUpdate(updateqry);
                  print('succ:' + succ.toString());

                  List<Map> transferprimaryList = await db.RawQuery(
                      'select * from exporterPurchase where isSynched = 0 and recNo=\'' +
                          custTxnsRefId +
                          '\'');
                  List<String> transferprimaryReqDetailList = [];
                  List<Map> transferprimaryReqList = await db.RawQuery(
                      "select * from exporterPurchaseDetail WHERE recNo='" +
                          custTxnsRefId +
                          "';");
                  print("transferprimaryReqListAdded" +
                      transferprimaryReqList.toString());
                  for (int j = 0; j < transferprimaryReqList.length; j++) {
                    var reqtransferprimaryDet = jsonEncode({
                      "recptNo": transferprimaryReqList[j]
                          ['batchNo'], //Batch No
                      "coffGrade": transferprimaryReqList[j]['coffGrade'],
                      "exstStk": transferprimaryReqList[j]['exstStk'] +
                          "&" +
                          transferprimaryReqList[j]['exstBag'],
                      "totWtTransfd": transferprimaryReqList[j]['totWt'],
                      "noBags": transferprimaryReqList[j]['noBag']
                    });
                    transferprimaryReqDetailList.add(reqtransferprimaryDet);
                  }

                  for (int i = 0; i < transferprimaryList.length; i++) {
                    var reqdata = jsonEncode({
                      "body": {
                        "reciever": transferprimaryList[i]
                            ['exporter'], // exporter
                        "datetransfer": transferprimaryList[i]['purDate'],
                        "vehiclenumber": transferprimaryList[i]['vehNo'],
                        "drivername": transferprimaryList[i]['driNo'],
                        "seasonCode": transferprimaryList[i]['seasonCode'],
                        "transRecNo": "EP" + transferprimaryList[i]['recNo'],
                        "processType": "2",

                        "latitude": transferprimaryList[i]['latitude'],
                        "longitude": transferprimaryList[i]['longitude'],
                        "transferprimryReq":
                            jsonDecode(transferprimaryReqDetailList.toString()),
                        //"sBookinRenego": jsonDecode(seedBookingRenDetailList.toString()),
                      },
                      "head": jsonDecode(headdata)
                    });

                    printWrapped('exporterReq ' + reqdata);

                    Response response =
                        await Dio().post(appDatas.TXN_URL, data: reqdata);
                    printWrapped('exporterRes ' + response.toString());

                    final responsebody = json.decode(response.toString());
                    final jsonresponse = responsebody['Response'];
                    final statusobjectr = jsonresponse['status'];
                    final code = statusobjectr['code'];
                    final message = statusobjectr['message'];

                    if (code.toString() == '00') {
                      db.UpdateTableValue('exporterPurchase', 'isSynched', '1',
                          'recNo', custTxnsRefId);
                      db.DeleteTableRecord(
                          'custTransactions', 'txnRefId', custTxnsRefId);
                      // toast('synced successfull');
                    } else {}
                  }
                } catch (Exception) {
                  print("txnexecutor err " + Exception.toString());
                }
              }

              //exporter reception

              else if (txnConfigId == datas.exporterReception &&
                  agentId == "08") {
                try {
                  String ipAddressValue = '';
                  try {
                    final ipv4 = await Ipify.ipv4();
                    ipAddressValue = ipv4.toString();
                  } catch (e) {
                    ipAddressValue = '';
                  }

                  String latitude = '', longitude = '';
                  try {
                    Position position = await Geolocator.getCurrentPosition(
                        desiredAccuracy: LocationAccuracy.high);
                    latitude = position.latitude.toString();
                    longitude = position.longitude.toString();
                  } catch (e) {
                    latitude = '';
                    longitude = '';
                  }

                  String custTxnsRefId =
                      custTransactions[i]["txnRefId"].toString();
                  print("custTxnsRefId" + custTxnsRefId);

                  String headerqry =
                      "select * from txnHeader where txnRefId like '%" +
                          custTxnsRefId +
                          "%';";

                  List<Map> headerList = await db.RawQuery(headerqry);

                  print("headerList:" + headerList.toString());

                  print('txnexecutor headerList ' + headerqry);
                  var headdata = jsonEncode({
                    "agentId": headerList[0]['agentId'],
                    "agentToken": headerList[0]['agentToken'],
                    "txnType": datas.exporterReception,
                    "txnTime": headerList[0]['txnTime'],
                    "operType": "01",
                    "mode": "02",
                    "msgNo": headerList[0]['msgNo'],
                    "resentCount": "0",
                    "serialNo": serialnumber,
                    "servPointId": headerList[0]['servPointId'],
                    "branchId": appDatas.tenent,
                    "versionNo": versionlist[0] + "|" + DBVERSION!,
                    "fsTrackerSts": "2|1",
                    "tenantId": appDatas.tenent,
                    "lat": latitude,
                    "lon": longitude,
                  });

                  print("head data:" + headdata);

                  print('resentCount' +
                      headerList[0]['resentCount'] +
                      '->' +
                      custTxnsRefId);
                  int resentCount = int.parse(headerList[0]['resentCount']);

                  resentCount = resentCount + 1;
                  print('resentCount' + resentCount.toString());

                  String updateqry = 'UPDATE txnHeader SET resentCount =\'' +
                      resentCount.toString() +
                      '\' WHERE txnRefId LIKE "%' +
                      custTxnsRefId +
                      '%"';
                  int succ = await db.RawUpdate(updateqry);
                  print('succ' + succ.toString());

                  List<Map> reception = await db.RawQuery(
                      "SELECT * FROM exporterReception where isSynched = 0 and recNo = '" +
                          custTxnsRefId +
                          "';");

                  for (int i = 0; i < reception.length; i++) {
                    List<Map> receptlist = await db.RawQuery(
                        "SELECT * from exporterReceptionDetail where recNo = '" +
                            custTxnsRefId +
                            "';");
                    print("receptionDetailDetail" + receptlist.toString());

                    List<String> inputJsonList = [];
                    for (int j = 0; j < receptlist.length; j++) {
                      var reqInpDem = jsonEncode({
                        "purchaseReceiptNo": receptlist[j]
                            ['batchNo'], // Batch N0
                        "grade": receptlist[j]['grade'],
                        "bagsTransferred": receptlist[j]['noBag'],
                        "weightTransferred": receptlist[j]['totWt'],
                        "bagsReceived": receptlist[j]['noBagRec'],
                        "weightReceived": receptlist[j]['totWtRec']
                      });
                      inputJsonList.add(reqInpDem);
                    }

                    var reqdata = jsonEncode({
                      // "Request": {
                      "body": {
                        "receiver": reception[i]['reciever'],
                        "date": reception[i]['date'],
                        "transferReceiptNo": reception[i]['trRecNo'],
                        "transferDate": reception[i]['trDate'],
                        "vehicleNo": reception[i]['vehNo'],
                        "driverName": reception[i]['driNo'],
                        "seasonCode": reception[i]['seasonCode'],
                        "latitude": reception[i]['latitude'],
                        "longitude": reception[i]['longitude'],
                        "processType": "2",
                        "productList": jsonDecode(inputJsonList.toString())
                      },
                      "head": jsonDecode(headdata),
                      // }
                    });
                    printWrapped('receptionReqpacket ' + reqdata);

                    Response response =
                        await Dio().post(appDatas.TXN_URL, data: reqdata);
                    print(" Response" + response.toString());

                    final responsebody = json.decode(response.toString());
                    final jsonresponse = responsebody['Response'];
                    final statusobjectr = jsonresponse['status'];
                    final code = statusobjectr['code'];
                    final message = statusobjectr['message'];

                    if (code.toString() == '00') {
                      db.UpdateTableValue('exporterReception', 'isSynched', '1',
                          'recNo', custTxnsRefId);
                      db.DeleteTableRecord(
                          'custTransactions', 'txnRefId', custTxnsRefId);
                      // toast('synced successfull');
                    } else {}
                  }
                } catch (Exception) {
                  print("txnexecutor err " + Exception.toString());
                }
              }

              //secondary procesing

              else if (txnConfigId == datas.txnSecondaryProcessing &&
                  agentId == "08") {
                try {
                  String ipAddressValue = '';
                  try {
                    final ipv4 = await Ipify.ipv4();
                    ipAddressValue = ipv4.toString();
                  } catch (e) {
                    ipAddressValue = '';
                  }

                  String latitude = '', longitude = '';
                  try {
                    Position position = await Geolocator.getCurrentPosition(
                        desiredAccuracy: LocationAccuracy.high);
                    latitude = position.latitude.toString();
                    longitude = position.longitude.toString();
                  } catch (e) {
                    latitude = '';
                    longitude = '';
                  }

                  String custTxnsRefId =
                      custTransactions[i]["txnRefId"].toString();
                  print("custTxnsRefId" + custTxnsRefId);

                  String headerqry =
                      "select * from txnHeader where txnRefId like '%" +
                          custTxnsRefId +
                          "%';";

                  List<Map> headerList = await db.RawQuery(headerqry);

                  print("headerList:" + headerList.toString());

                  print('txnexecutor headerList ' + headerqry);
                  var headdata = jsonEncode({
                    "agentId": headerList[0]['agentId'],
                    "agentToken": headerList[0]['agentToken'],
                    "txnType": datas.txnPrimaryProcessing,
                    "txnTime": headerList[0]['txnTime'],
                    "operType": "01",
                    "mode": "02",
                    "msgNo": headerList[0]['msgNo'],
                    "resentCount": "0",
                    "serialNo": serialnumber,
                    "servPointId": headerList[0]['servPointId'],
                    "branchId": appDatas.tenent,
                    "versionNo": versionlist[0] + "|" + DBVERSION!,
                    "fsTrackerSts": "2|1",
                    "tenantId": appDatas.tenent,
                    "lat": latitude,
                    "lon": longitude,
                  });

                  print("head data:" + headdata);

                  print('resentCount' +
                      headerList[0]['resentCount'] +
                      '->' +
                      custTxnsRefId);
                  int resentCount = int.parse(headerList[0]['resentCount']);

                  resentCount = resentCount + 1;
                  print('resentCount' + resentCount.toString());

                  String updateqry = 'UPDATE txnHeader SET resentCount =\'' +
                      resentCount.toString() +
                      '\' WHERE txnRefId LIKE "%' +
                      custTxnsRefId +
                      '%"';
                  int succ = await db.RawUpdate(updateqry);
                  print('succ' + succ.toString());

                  List<Map> primaryProcessing = await db.RawQuery(
                      "SELECT * FROM primaryProcessing where isSynched = 0 and recNo = '" +
                          custTxnsRefId +
                          "';");

                  for (int i = 0; i < primaryProcessing.length; i++) {
                    List<Map> primaryProcessingList = await db.RawQuery(
                        "SELECT * from primaryProcessingDetail where recNo = '" +
                            custTxnsRefId +
                            "';");
                    print("primaryProcessingList" +
                        primaryProcessingList.toString());

                    List<String> inputJsonList = [];
                    for (int j = 0; j < primaryProcessingList.length; j++) {
                      var reqInpDem = jsonEncode({
                        "grade": primaryProcessingList[j]['grade'],
                        "avaBg": primaryProcessingList[j]['avlBags'],
                        "avaWt": primaryProcessingList[j]['avlKgs'],
                        "ioBag": primaryProcessingList[j]['inputBags'],
                        "ioKg": primaryProcessingList[j]['inputKgs'],
                        "opBag": primaryProcessingList[j]['outputBags'],
                        "opKg": primaryProcessingList[j]['outputKgs'],
                        "ioTotal": primaryProcessingList[j]['inputTotal'],
                        "opTotal": primaryProcessingList[j]['outputTotal']
                      });
                      inputJsonList.add(reqInpDem);
                    }

                    var reqdata = jsonEncode({
                      // "Request": {
                      "body": {
                        "date": primaryProcessing[i]['date'],
                        "batchNo": primaryProcessing[i]['batchNo'],
                        "customer": primaryProcessing[i]['customer'],
                        "startDate": primaryProcessing[i]['dateStarted'],
                        "startTime": primaryProcessing[i]['timeStarted'],
                        "endDate": primaryProcessing[i]['dateFinished'],
                        "endTime": primaryProcessing[i]['timeFinished'],
                        "preCln": primaryProcessing[i]['preClean'],
                        "stones": primaryProcessing[i]['stones'],
                        "wasteGrade": primaryProcessing[i]['wasteGrade'],
                        "wastTotal": primaryProcessing[i]['wnoBag'],
                        "wnoBag": primaryProcessing[i]['totalWBags'],
                        "skuType": primaryProcessing[i]['skuType'],
                        "rej1": primaryProcessing[i]['reject1899'],
                        "rej2": primaryProcessing[i]['reject1599'],
                        "rej3": primaryProcessing[i]['reject1299'],
                        "rej4": primaryProcessing[i]['reject1199'],
                        "grnoBag": primaryProcessing[i]['totalGBags'],
                        "rejTotal": primaryProcessing[i]['gnoBag'],
                        "receiptNo": primaryProcessing[i]['recNo'],
                        "latitude": primaryProcessing[i]['latitude'],
                        "longitude": primaryProcessing[i]['longitude'],
                        "seasonCode": primaryProcessing[i]['seasonCode'],
                        "processType": "4",
                        "gradeList": jsonDecode(inputJsonList.toString())
                      },
                      "head": jsonDecode(headdata),
                      // }
                    });
                    printWrapped('secProcessingReq ' + reqdata);

                    Response response =
                        await Dio().post(appDatas.TXN_URL, data: reqdata);
                    print(" secProcessingResponse" + response.toString());

                    final responsebody = json.decode(response.toString());
                    final jsonresponse = responsebody['Response'];
                    final statusobjectr = jsonresponse['status'];
                    final code = statusobjectr['code'];
                    final message = statusobjectr['message'];

                    if (code.toString() == '00') {
                      db.UpdateTableValue('primaryProcessing', 'isSynched', '1',
                          'recNo', custTxnsRefId);
                      db.DeleteTableRecord(
                          'custTransactions', 'txnRefId', custTxnsRefId);
                      // toast('synced successfull');
                    } else {}
                  }
                } catch (Exception) {
                  print("txnexecutor err " + Exception.toString());
                }
              }

              //activity menu

              else if (txnConfigId == datas.activityTxn) {
                try {
                  String ipAddressValue = '';
                  try {
                    final ipv4 = await Ipify.ipv4();
                    ipAddressValue = ipv4.toString();
                  } catch (e) {
                    ipAddressValue = '';
                  }

                  String latitude = '', longitude = '';
                  try {
                    Position position = await Geolocator.getCurrentPosition(
                        desiredAccuracy: LocationAccuracy.high);
                    latitude = position.latitude.toString();
                    longitude = position.longitude.toString();
                  } catch (e) {
                    latitude = '';
                    longitude = '';
                  }

                  String custTxnsRefId =
                      custTransactions[i]["txnRefId"].toString();
                  print("custTxnsRefId" + custTxnsRefId);

                  String headerqry =
                      "select * from txnHeader where txnRefId like '%" +
                          custTxnsRefId +
                          "%';";

                  List<Map> headerList = await db.RawQuery(headerqry);

                  print("headerList:" + headerList.toString());

                  print('txnexecutor headerList ' + headerqry);
                  var headdata = jsonEncode({
                    "agentId": headerList[0]['agentId'],
                    "agentToken": headerList[0]['agentToken'],
                    "txnType": datas.activityTxn,
                    "txnTime": headerList[0]['txnTime'],
                    "operType": "01",
                    "mode": "02",
                    "msgNo": headerList[0]['msgNo'],
                    "resentCount": "0",
                    "serialNo": serialnumber,
                    "servPointId": headerList[0]['servPointId'],
                    "branchId": appDatas.tenent,
                    "versionNo": versionlist[0] + "|" + DBVERSION!,
                    "fsTrackerSts": "2|1",
                    "tenantId": appDatas.tenent,
                    "lat": latitude,
                    "lon": longitude,
                  });

                  print("head data:" + headdata);

                  print('resentCount' +
                      headerList[0]['resentCount'] +
                      '->' +
                      custTxnsRefId);
                  int resentCount = int.parse(headerList[0]['resentCount']);

                  resentCount = resentCount + 1;
                  print('resentCount' + resentCount.toString());

                  String updateqry = 'UPDATE txnHeader SET resentCount =\'' +
                      resentCount.toString() +
                      '\' WHERE txnRefId LIKE "%' +
                      custTxnsRefId +
                      '%"';
                  int succ = await db.RawUpdate(updateqry);
                  print('succ' + succ.toString());

                  List<Map> primaryProcessing = await db.RawQuery(
                      "SELECT * FROM activityMenu where isSynched = 0 and recNo = '" +
                          custTxnsRefId +
                          "';");

                  for (int i = 0; i < primaryProcessing.length; i++) {
                    String activityPhoto = primaryProcessing[i]['txnTime'];

                    if (activityPhoto != "") {
                      File _farmerimage = File(activityPhoto);
                      List<int> imageBytes = _farmerimage.readAsBytesSync();
                      activityPhoto = base64Encode(imageBytes);
                    } else {
                      activityPhoto = "";
                    }
                    var reqdata = jsonEncode({
                      // "Request": {
                      "body": {
                        "activity": primaryProcessing[i]['activityVal'],
                        "desc": primaryProcessing[i]['activityDes'],
                        "date": primaryProcessing[i]['date'],
                        "checkin": primaryProcessing[i]['timeStarted'],
                        "checkout": primaryProcessing[i]['timeFinished'],
                        "recpNo": primaryProcessing[i]['recNo'],
                        "activityPhoto": activityPhoto,
                        "latitude": primaryProcessing[i]['latitude'],
                        "longitude": primaryProcessing[i]['longitude']
                      },
                      "head": jsonDecode(headdata),
                      // }
                    });
                    printWrapped('secProcessingReq ' + reqdata);

                    Response response =
                        await Dio().post(appDatas.TXN_URL, data: reqdata);
                    print(" secProcessingResponse" + response.toString());

                    final responsebody = json.decode(response.toString());
                    final jsonresponse = responsebody['Response'];
                    final statusobjectr = jsonresponse['status'];
                    final code = statusobjectr['code'];
                    final message = statusobjectr['message'];

                    if (code.toString() == '00') {
                      db.UpdateTableValue('activityMenu', 'isSynched', '1',
                          'recNo', custTxnsRefId);
                      db.DeleteTableRecord(
                          'custTransactions', 'txnRefId', custTxnsRefId);
                      // toast('synced successfull');
                    } else {}
                  }
                } catch (Exception) {
                  print("txnexecutor err " + Exception.toString());
                }
              }

              //change password
              else if (txnConfigId == datas.txn_changePassword) {
                try {
                  String ipAddressValue = '';
                  try {
                    final ipv4 = await Ipify.ipv4();
                    ipAddressValue = ipv4.toString();
                  } catch (e) {
                    ipAddressValue = '';
                  }

                  String latitude = '', longitude = '';
                  try {
                    Position position = await Geolocator.getCurrentPosition(
                        desiredAccuracy: LocationAccuracy.high);
                    latitude = position.latitude.toString();
                    longitude = position.longitude.toString();
                  } catch (e) {
                    latitude = '';
                    longitude = '';
                  }

                  String custTxnsRefId =
                      custTransactions[i]["txnRefId"].toString();
                  print("custTxnsRefId " + custTxnsRefId);
                  List<Map> passwordDatalist = await db.RawQuery(
                      "SELECT * from passwordSynch where isSynched = 0");
                  print("passwordDatalist " + passwordDatalist.toString());
                  String headerqry =
                      "select * from txnHeader where txnRefId  like '%" +
                          custTxnsRefId +
                          "%';";
                  List<Map> headerList = await db.RawQuery(headerqry);
                  print('txnexecutor headerList ' + headerList.toString());
                  print('txnexecutor headerList ' + headerqry);
                  var headdata = jsonEncode({
                    "agentId": headerList[0]['agentId'],
                    "agentToken": headerList[0]['agentToken'],
                    "txnType": datas.txn_changePassword,
                    "txnTime": headerList[0]['txnTime'],
                    "operType": "01",
                    "mode": "02",
                    "msgNo": headerList[0]['msgNo'],
                    "resentCount": "0",
                    "serialNo": serialnumber,
                    "servPointId": headerList[0]['servPointId'],
                    "branchId": appDatas.tenent,
                    "versionNo": versionlist[0] + "|" + DBVERSION!,
                    "fsTrackerSts": "2|1",
                    "tenantId": appDatas.tenent,
                    "lat": latitude,
                    "lon": longitude,
                  });

                  var reqdata = jsonEncode({
                    "body": {
                      "nPwd": passwordDatalist[0]["passwordValue"],
                      "nPwdCDt": passwordDatalist[0]["passwordDate"],
                      "latitude": latitude,
                      "longitude": longitude,
                    },
                    "head": jsonDecode(headdata)
                  });

                  printWrapped('reqdata358 ' + reqdata.toString());
                  Response response =
                      await Dio().post(appDatas.TXN_URL, data: reqdata);

                  final responsebody = json.decode(response.toString());
                  final jsonresponse = responsebody['Response'];
                  final statusobjectr = jsonresponse['status'];
                  final code = statusobjectr['code'];
                  final message = statusobjectr['message'];

                  if (code.toString() == '00') {
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    prefs.setString(
                        "password", passwordDatalist[0]["passwordString"]);
                    prefs.setString(
                        "agentToken", passwordDatalist[0]["passwordValue"]);
                    db.UpdateTableValue('passwordSynch', 'isSynched', '1',
                        'recId', custTxnsRefId);
                    db.DeleteTableRecord(
                        'custTransactions', 'txnRefId', custTxnsRefId);
                  } else {}
                } catch (Exception) {
                  print("txn_changePassword " + Exception.toString());
                }
              }

              //locationTracking

              //farmer edit

              else if (txnConfigId == datas.farmer_edit) {
                try {
                  String ipAddressValue = '';
                  try {
                    final ipv4 = await Ipify.ipv4();
                    ipAddressValue = ipv4.toString();
                  } catch (e) {
                    ipAddressValue = '';
                  }

                  String latitude = '', longitude = '';
                  try {
                    Position position = await Geolocator.getCurrentPosition(
                        desiredAccuracy: LocationAccuracy.high);
                    latitude = position.latitude.toString();
                    longitude = position.longitude.toString();
                  } catch (e) {
                    latitude = '';
                    longitude = '';
                  }

                  String custTxnsRefId =
                      custTransactions[i]["txnRefId"].toString();
                  print("custTxnsRefId" + custTxnsRefId);

                  String headerqry =
                      "select * from txnHeader where txnRefId like '%" +
                          custTxnsRefId +
                          "%';";

                  List<Map> headerList = await db.RawQuery(headerqry);

                  print("headerList:" + headerList.toString());

                  print('txnexecutor headerList ' + headerqry);
                  var headdata = jsonEncode({
                    "agentId": headerList[0]['agentId'],
                    "agentToken": headerList[0]['agentToken'],
                    "txnType": datas.farmer_edit,
                    "txnTime": headerList[0]['txnTime'],
                    "operType": "01",
                    "mode": "02",
                    "msgNo": headerList[0]['msgNo'],
                    "resentCount": "0",
                    "serialNo": serialnumber,
                    "servPointId": headerList[0]['servPointId'],
                    "branchId": appDatas.tenent,
                    "versionNo": versionlist[0] + "|" + DBVERSION!,
                    "fsTrackerSts": "2|1",
                    "tenantId": appDatas.tenent,
                    "lat": latitude,
                    "lon": longitude,
                  });

                  print("head data:" + headdata);

                  print('resentCount' +
                      headerList[0]['resentCount'] +
                      '->' +
                      custTxnsRefId);
                  int resentCount = int.parse(headerList[0]['resentCount']);

                  resentCount = resentCount + 1;
                  print('resentCount' + resentCount.toString());

                  String updateqry = 'UPDATE txnHeader SET resentCount =\'' +
                      resentCount.toString() +
                      '\' WHERE txnRefId LIKE "%' +
                      custTxnsRefId +
                      '%"';
                  int succ = await db.RawUpdate(updateqry);
                  print('succ' + succ.toString());

                  List<Map> primaryProcessing = await db.RawQuery(
                      "SELECT * FROM primaryProcessing where isSynched = 0 and recNo = '" +
                          custTxnsRefId +
                          "';");

                  List<Map> FarmerDataList = await db.RawQuery(
                      "select farmerId,farmerlatitude,farmerlongitude,farmertimeStamp,fingerPrint,idProofVal,idProof,pltStatus,farmerMobile,spacingTree,totCoffAcr,decCoffArea,avgAgeTree,numShadeTree,typShadeTree,numProdTree,numUnProdTree,yeildEstTree,farmId,farmProduction,firstName,othName,nameOwner,addOwner,idType,idNumber,country,district,subcounty,parish,village,memOrg,idProofLatitude FROM edit_farmer where recId = '" +
                          custTxnsRefId +
                          "' and isSynched = 0;");
                  print("passwordDatalist " + FarmerDataList.toString());

                  for (int i = 0; i < FarmerDataList.length; i++) {
                    List<Map> banklist = await db.RawQuery(
                        "SELECT bankName from bankList WHERE farmerId = '" +
                            custTxnsRefId +
                            "';");
                    print("banklistQry" + banklist.toString());

                    List<String> bankJsonList = [];
                    //String groupOrg = "";
                    if (banklist.isNotEmpty) {
                      for (int j = 0; j < banklist.length; j++) {
                        //groupOrg = banklist[j]["bankName"];
                        var reqbank = jsonEncode({
                          "nameOrg": banklist[j]["bankName"] == null
                              ? ""
                              : banklist[j]["bankName"],
                          //"addOrg": banklist[j]["bankACNumber"],
                        });
                        bankJsonList.add(reqbank);
                      }
                    }

                    var reqdata = jsonEncode({
                      // "Request": {
                      "body": {
                        "farmerId": FarmerDataList[i]["farmerId"] == null
                            ? ""
                            : FarmerDataList[i]["farmerId"],
                        "latitude": FarmerDataList[i]["farmerlatitude"] == null
                            ? ""
                            : FarmerDataList[i]["farmerlatitude"],
                        "longitude":
                            FarmerDataList[i]["farmerlongitude"] == null
                                ? ""
                                : FarmerDataList[i]["farmerlongitude"],
                        "fName": FarmerDataList[i]["firstName"] == null
                            ? ""
                            : FarmerDataList[i]["firstName"],
                        "oName": FarmerDataList[i]["othName"] == null
                            ? ""
                            : FarmerDataList[i]["othName"],
                        "namOwner": FarmerDataList[i]["nameOwner"] == null
                            ? ""
                            : FarmerDataList[i]["nameOwner"],
                        "addOwner": FarmerDataList[i]["addOwner"] == null
                            ? ""
                            : FarmerDataList[i]["addOwner"],
                        "nationalID": FarmerDataList[i]["idType"] == null
                            ? ""
                            : FarmerDataList[i]["idType"],
                        "nin": FarmerDataList[i]["idNumber"] == null
                            ? ""
                            : FarmerDataList[i]["idNumber"],
                        "country": FarmerDataList[i]["country"] == null
                            ? ""
                            : FarmerDataList[i]["country"],
                        "district": FarmerDataList[i]["district"] == null
                            ? ""
                            : FarmerDataList[i]["district"],
                        "subCountry": FarmerDataList[i]["subcounty"] == null
                            ? ""
                            : FarmerDataList[i]["subcounty"],
                        "parish": FarmerDataList[i]["parish"] == null
                            ? ""
                            : FarmerDataList[i]["parish"],
                        "village": FarmerDataList[i]["village"] == null
                            ? ""
                            : FarmerDataList[i]["village"],
                        "dob": FarmerDataList[i]["idProofVal"] == null
                            ? ""
                            : FarmerDataList[i]["idProofVal"],
                        "age": FarmerDataList[i]["idProof"] == null
                            ? ""
                            : FarmerDataList[i]["idProof"],
                        "gender": FarmerDataList[i]["fingerPrint"] == null
                            ? ""
                            : FarmerDataList[i]["fingerPrint"],
                        "address": FarmerDataList[i]["pltStatus"] == null
                            ? ""
                            : FarmerDataList[i]["pltStatus"],
                        "phoneNo": FarmerDataList[i]["farmerMobile"] == null
                            ? ""
                            : FarmerDataList[i]["farmerMobile"],
                        "memOrg": FarmerDataList[i]["memOrg"] == null
                            ? ""
                            : FarmerDataList[i]["memOrg"],
                        "memberOrg": jsonDecode(bankJsonList.toString()),
                        "farmName": FarmerDataList[i]["farmProduction"] == null
                            ? ""
                            : FarmerDataList[i]["farmProduction"],
                        "farmCode": FarmerDataList[i]["farmId"] == null
                            ? ""
                            : FarmerDataList[i]["farmId"],
                        "spacingTree": FarmerDataList[i]["spacingTree"] == null
                            ? ""
                            : FarmerDataList[i]["spacingTree"],
                        "totCoffeeAcr": FarmerDataList[i]["totCoffAcr"] == null
                            ? ""
                            : FarmerDataList[i]["totCoffAcr"],
                        "propCoffeePlAr":
                            FarmerDataList[i]["decCoffArea"] == null
                                ? ""
                                : FarmerDataList[i]["decCoffArea"],
                        "avgAgeTree": FarmerDataList[i]["avgAgeTree"] == null
                            ? ""
                            : FarmerDataList[i]["avgAgeTree"],
                        "numShadeTree":
                            FarmerDataList[i]["numShadeTree"] == null
                                ? ""
                                : FarmerDataList[i]["numShadeTree"],
                        "typShadeTree":
                            FarmerDataList[i]["typShadeTree"] == null
                                ? ""
                                : FarmerDataList[i]["typShadeTree"],
                        "totalNoTrees":
                            FarmerDataList[i]["IdProofLatitude"] == null
                                ? ""
                                : FarmerDataList[i]["IdProofLatitude"],
                        "numProdTree": FarmerDataList[i]["numProdTree"] == null
                            ? ""
                            : FarmerDataList[i]["numProdTree"],
                        "numUnProdTree":
                            FarmerDataList[i]["numUnProdTree"] == null
                                ? ""
                                : FarmerDataList[i]["numUnProdTree"],
                        "yldEstTree": FarmerDataList[i]["yeildEstTree"] == null
                            ? ""
                            : FarmerDataList[i]["yeildEstTree"],
                      },
                      "head": jsonDecode(headdata),
                      // }
                    });
                    printWrapped('375req ' + reqdata);

                    Response response =
                        await Dio().post(appDatas.TXN_URL, data: reqdata);
                    print(" 375res" + response.toString());

                    final responsebody = json.decode(response.toString());
                    final jsonresponse = responsebody['Response'];
                    final statusobjectr = jsonresponse['status'];
                    final code = statusobjectr['code'];
                    final message = statusobjectr['message'];

                    if (code.toString() == '00') {
                      db.UpdateTableValue('edit_farmer', 'isSynched', '1',
                          'recId', custTxnsRefId);
                      db.DeleteTableRecord(
                          'custTransactions', 'txnRefId', custTxnsRefId);
                    } else {}
                  }
                } catch (Exception) {
                  print("txnexecutor err " + Exception.toString());
                }
              } else {
                preference.setString("isRunning", "0");
                runningValue = preference.getString("isRunning");
                print("running Else condition" + runningValue.toString());
              }
              if (i + 1 == custTransactions.length) {
                preference.setString("isRunning", "0");
              }

              // runningValue = preference.getString("isRunning");
              // print("forLooPIsRunninglast" + runningValue.toString());
            }
          } else {
            runningValue = preference.getString("isRunning");
            print('Offline or is running' + runningValue.toString());
          }
        } catch (e) {
          print(e);
          runningValue = preference.getString("isRunning");
          print('Catch' + runningValue.toString());
        }
      } else {
        preference.setString("isRunning", "0");
        runningValue = preference.getString("isRunning");
      }
      //}
    } catch (Exception) {
      print("txnexecutor err 316" + Exception.toString());
      // toast('Executor Error ' + Exception.toString());
    }
  }

  Future<bool> hasNetwork() async {
    try {
      final result = await InternetAddress.lookup('example.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      return false;
    }
  }

  void printWrapped(String text) {
    final pattern = RegExp('.{1,800}'); // 800 is the size of each chunk
    pattern.allMatches(text).forEach((match) => print(match.group(0)));
  }
}
