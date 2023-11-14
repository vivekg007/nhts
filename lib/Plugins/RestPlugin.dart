import 'dart:collection';
import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:dart_ipify/dart_ipify.dart';
import 'package:device_info/device_info.dart';
import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:jaguar_jwt/jaguar_jwt.dart';
import 'package:package_info/package_info.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Database/Databasehelper.dart';
import '../Utils/MandatoryDatas.dart';

class restplugin {
  AppDatas appDatas = new AppDatas();
  var db = DatabaseHelper();
  Future<String> loginApi(String username, String Password) async {
    String userPsw = username.trim() + Password.trim();
    final key = 'STRACE@12345SAKTHIATHISOURCETRACE';

    String token = JwtHS256(userPsw, key);

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("agentId", username.trim());
    prefs.setString("agentToken", token);
    String? serialnumber = prefs.getString("serialnumber");
    String _modelNumber = await getModelNumber();
    final now = new DateTime.now();
    String formatter = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
    String msgNo = DateFormat('yyyyMMddHHmmss').format(now);
    print("agentToken :" + token);
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String version = packageInfo.version;
    List<String> versionlist = version
        .split(
            '.') // split the text into an array/ put the text inside a widget
        .toList();
    String? DBVERSION = prefs.getString("DBVERSION");

    FirebaseMessaging.instance.deleteToken();

    String? fcmToken = "";
    await FirebaseMessaging.instance.getToken().then((fcmtoken) {
      print('fcmtoken' + fcmtoken!);
      fcmToken = fcmtoken!;
      prefs.setString("old_Token", fcmtoken!);
    });

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

    var data2 = jsonEncode({
      "body": {
        "ppRevNo": "0",
        "lRevNo":
            "20200124132911|20200124132922|20200406172204|20200421154022|20200409125435|20200409125720",
        "fsRevNo": "20200818124419",
        "fobRevNo": "20200812114239",
        "prodRevNo": "20200812124646",
        "seasonRevNo": "20200812133221",
        "fcmRevNo": "0",
        "procProdRevNo": "20200727132633|20200702110358|20200702110404",
        "vwsRevNo": "0",
        "gRevNo": "0",
        "wsRevNo": "0",
        "coRevNo": "20200505153353|20200708143042",
        "byrRevNo": "20200409131303",
        "supRevNo": "0",
        "eventRevNo": "0",
        "catRevNo": "0",
        "resStatRevNo": "0",
        "cSeasonCode": "HS00004",
        "agroVersion": "1",
        "plannerRevNo": "0",
        "stRevNo": "0",
        "dynLatestRevNo": "10",
        "followUpRevNo": "0",
        "androidVersion": "8.1.0",
        "mobileModel": _modelNumber,
        "fcmToken": fcmToken
      },
      "head": {
        "agentId": username.trim(),
        "agentToken": token,
        "txnType": "301",
        "txnTime": formatter,
        "operType": "01",
        "mode": "01",
        "msgNo": msgNo,
        "resentCount": "0",
        "serialNo": serialnumber,
        "servPointId": "",
        "branchId": "",
        "versionNo": versionlist[0] + "|" + DBVERSION!,
        "fsTrackerSts": "1|1",
        "tenantId": appDatas.tenent,
        "lat": latitude,
        "lon": longitude,
      }
    });
    printWrapped("LoginRequest " + data2.toString());
    printWrapped("appDatas.TXN_URL " + appDatas.TXN_URL);
    Response response = await Dio().post(appDatas.TXN_URL, data: data2);
    print('loginApi ' + response.toString());
    return response.toString();
  }

  Future<String> OnlineFormerDownload() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? agentid = prefs.getString("agentId");
    String? agentToken = prefs.getString("agentToken");
    String? serialnumber = prefs.getString("serialnumber");
    String? _modelNumber = await getModelNumber();
    final now = new DateTime.now();
    String formatter = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
    String msgNo = DateFormat('yyyyMMddHHmmss').format(now);

    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String version = packageInfo.version;
    List<String> versionlist = version
        .split(
            '.') // split the text into an array/ put the text inside a widget
        .toList();
    String? DBVERSION = prefs.getString("DBVERSION");

    var data = jsonEncode({
      "Request": {
        "body": {
          "data": [
            {"key": "farmerRevNo", "value": "0"}
          ]
        },
        "head": {
          "agentId": agentid,
          "agentToken": agentToken,
          "txnType": "315",
          "operType": "01",
          "txnTime": formatter,
          "mode": "01",
          "msgNo": msgNo,
          "resentCount": "0",
          "serialNo": serialnumber,
          "versionNo": versionlist[0] + "|" + DBVERSION!,
          "fsTrackerSts": "0|1",
          "tenantId": appDatas.tenent,
          "mobileModel": _modelNumber
        }
      }
    });
    print("reqdata315 : " + data.toString());
    Response response = await Dio().post(appDatas.TXN_URL, data: data);
    return response.toString();
  }

 /* Future<String> CroplistDownload() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? agentid = prefs.getString("agentId");
    String? agentToken = prefs.getString("agentToken");
    String? serialnumber = prefs.getString("serialnumber");
    String? _modelNumber = await getModelNumber();
    final now = new DateTime.now();
    String formatter = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
    String msgNo = DateFormat('yyyyMMddHHmmss').format(now);
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String version = packageInfo.version;
    List<String> versionlist = version
        .split(
            '.') // split the text into an array/ put the text inside a widget
        .toList();
    String? DBVERSION = prefs.getString("DBVERSION");
    var datareq = jsonEncode({
      // "Request": {
      "body": {"fCropRevNo": "0"},
      "head": {
        "agentId": agentid,
        "agentToken": agentToken,
        "txnType": "386",
        "txnTime": formatter,
        "operType": "01",
        "mode": "01",
        "msgNo": msgNo,
        "resentCount": "0",
        "serialNo": serialnumber,
        "servPointId": "SP001",
        "branchId": "123",
        "versionNo": versionlist[0] + "|" + DBVERSION!,
        "fsTrackerSts": "1|1",
        "tenantId": appDatas.tenent,
      }
      // }
    });

    printWrapped("CropRequest386" + datareq);

    Response response = await Dio().post(appDatas.TXN_URL, data: datareq);

    printWrapped("CropResponse386" + response.toString());
    return response.toString();
  }*/

  Future<String> Download322() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? agentid = prefs.getString("agentId");
    String? agentToken = prefs.getString("agentToken");
    String? serialnumber = prefs.getString("serialnumber");
    String? _modelNumber = await getModelNumber();
    final now = new DateTime.now();
    String formatter = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
    String msgNo = DateFormat('yyyyMMddHHmmss').format(now);
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String version = packageInfo.version;
    List<String> versionlist = version
        .split(
            '.') // split the text into an array/ put the text inside a widget
        .toList();
    String? DBVERSION = prefs.getString("DBVERSION");
    List<Map> agents = await db.RawQuery('SELECT * FROM agentMaster');
    var data = jsonEncode({
      //"Request":{
      "body": {
        "ppRevNo": "0",
        "lRevNo": "0",
        "fsRevNo": "0",
        //"fsRevNo": agents[0]['fsRevNo'],
        "fobRevNo": "0",
        "prodRevNo": "0",
        "seasonRevNo": "0",
        "fcmRevNo": "0",
        "procProdRevNo": "0",
        "vwsRevNo": "0",
        "gRevNo": "0",
        "wsRevNo": "0",
        "coRevNo": "0",
        "byrRevNo": "0",
        "supRevNo": "0",
        "eventRevNo": "0",
        "catRevNo": "0",
        "resStatRevNo": "0",
        "cSeasonCode": agents[0]['currentSeasonCode'],
        "agroVersion": "1",
        "plannerRevNo": "0",
        "stRevNo": "0",
        "dynLatestRevNo": "0",
        "followUpRevNo": "0",
        "androidVersion": "8.1.0",
        "mobileModel": _modelNumber
      },
      "head": {
        "agentId": agentid,
        "agentToken": agentToken,
        "txnType": "322",
        "operType": "01",
        "txnTime": formatter,
        "mode": "01",
        "msgNo": msgNo,
        "resentCount": "0",
        "serialNo": serialnumber,
        "versionNo": versionlist[0] + "|" + DBVERSION!,
        "fsTrackerSts": "0|1",
        "tenantId": appDatas.tenent,
        "mobileModel": _modelNumber
      }
      //}
    });
    print("reqdata : " + data.toString());
    Response response = await Dio().post(appDatas.TXN_URL, data: data);
    print("resdata" + response.toString());

    return response.toString();
  }

  Future<String> FarmerDownload() async {
    List<Map> agents = await db.RawQuery('SELECT * FROM agentMaster');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? agentid = prefs.getString("agentId");
    String? agentToken = prefs.getString("agentToken");
    String? serialnumber = prefs.getString("serialnumber");
    String? _modelNumber = await getModelNumber();
    final now = new DateTime.now();
    String formatter = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
    String msgNo = DateFormat('yyyyMMddHHmmss').format(now);
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String version = packageInfo.version;
    List<String> versionlist = version
        .split(
            '.') // split the text into an array/ put the text inside a widget
        .toList();
    String? DBVERSION = prefs.getString("DBVERSION");
    var data = jsonEncode({
      // "Request": {
      "body": {"farmerRevNo": "0"},
      "head": {
        "agentId": agentid,
        "agentToken": agentToken,
        "txnType": "315",
        "txnTime": formatter,
        "operType": "01",
        "mode": "01",
        "msgNo": msgNo,
        "resentCount": "0",
        "serialNo": serialnumber,
        "servPointId": agents[0]['servicePointId'],
        "branchId": "agro",
        "versionNo": versionlist[0] + "|" + DBVERSION!,
        "fsTrackerSts": "1|1",
        "tenantId": appDatas.tenent
      }
      // }
    });
    print("reqdata 315: " + data.toString());
    Response response = await Dio().post(appDatas.TXN_URL, data: data);
    print("reqdata 315: " + response.toString());

    return response.toString();
  }

  Future<String> FarmDownload() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? agentid = prefs.getString("agentId");
    String? agentToken = prefs.getString("agentToken");
    String? serialnumber = prefs.getString("serialnumber");
    String? _modelNumber = await getModelNumber();
    final now = new DateTime.now();
    String formatter = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
    String msgNo = DateFormat('yyyyMMddHHmmss').format(now);
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String version = packageInfo.version;
    List<String> versionlist = version
        .split(
            '.') // split the text into an array/ put the text inside a widget
        .toList();
    String? DBVERSION = prefs.getString("DBVERSION");
    var data = jsonEncode({
      // "Request": {
      "body": {"farmRevNo": "0"},
      "head": {
        "agentId": agentid,
        "agentToken": agentToken,
        "txnType": "385",
        "txnTime": formatter,
        "operType": "01",
        "mode": "01",
        "msgNo": msgNo,
        "resentCount": "0",
        "serialNo": serialnumber,
        "servPointId": "SP001",
        "branchId": "123",
        "versionNo": versionlist[0] + "|" + DBVERSION!,
        "fsTrackerSts": "1|1",
        "tenantId": appDatas.tenent
        // }
      }
    });
    print("reqdata 385: " + data.toString());
    Response response = await Dio().post(appDatas.TXN_URL, data: data);
    return response.toString();
  }

  Future<String> ClientProjectDownload() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? agentid = prefs.getString("agentId");
    String? agentToken = prefs.getString("agentToken");
    String? serialnumber = prefs.getString("serialnumber");
    String? _modelNumber = await getModelNumber();
    final now = new DateTime.now();
    String formatter = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
    String msgNo = DateFormat('yyyyMMddHHmmss').format(now);
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String version = packageInfo.version;
    List<String> versionlist = version
        .split(
            '.') // split the text into an array/ put the text inside a widget
        .toList();
    String? DBVERSION = prefs.getString("DBVERSION");

    var data = jsonEncode({
      "Request": {
        "body": {
          "data": [
            {"key": "revNo", "value": "0"}
          ]
        },
        "head": {
          "agentId": agentid,
          "agentToken":
              "eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJraXJ1YmhhMTIzNDU2In0.fP6fFULQow6Y73Q9hmjU7kawUxyT6CXU7i5pz1galfk",
          "txnType": "356",
          "txnTime": formatter,
          "operType": "01",
          "mode": "01",
          "msgNo": msgNo,
          "resentCount": "0",
          "serialNo": "499ee46858391a2caf9e567589d1db8f",
          "servPointId": "SP001",
          "branchId": "123",
          "versionNo": versionlist[0] + "|" + DBVERSION!,
          "fsTrackerSts": "1|1",
          "tenantId": "agro"
        }
      }
    });
    print("reqdata : " + data.toString());
    Response response = await Dio().post(appDatas.TXN_URL, data: data);
    return response.toString();
  }

  Future<String> TransactionHistoryDownload(String FarmerId) async {
    try {
      List<Map> agents = await db.RawQuery('SELECT * FROM agentMaster');
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? agentid = prefs.getString("agentId");
      String? agentToken = prefs.getString("agentToken");
      String? serialnumber = prefs.getString("serialnumber");
      String? _modelNumber = await getModelNumber();
      final now = new DateTime.now();
      String formatter = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
      String msgNo = DateFormat('yyyyMMddHHmmss').format(now);
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      String version = packageInfo.version;
      List<String> versionlist = version
          .split(
              '.') // split the text into an array/ put the text inside a widget
          .toList();
      String? DBVERSION = prefs.getString("DBVERSION");
      var data = jsonEncode({
        "Request": {
          "body": {"farmerId": FarmerId},
          "head": {
            "agentId": agentid,
            "agentToken": agentToken,
            "txnType": "331",
            "txnTime": formatter,
            "operType": "01",
            "mode": "01",
            "msgNo": msgNo,
            "resentCount": "0",
            "serialNo": serialnumber,
            "servPointId": agents[0]['servicePointId'],
            "branchId": "agro",
            "versionNo": versionlist[0] + "|" + DBVERSION!,
            "fsTrackerSts": "1|1",
            "lat": "11.22143272",
            "lon": "77.09592583",
            "tenantId": appDatas.tenent
          }
        }
      });
      print("reqdata 331: " + data.toString());
      Response response = await Dio().post(appDatas.TXN_URL, data: data);
      print("reqdata 331: " + response.toString());
      return response.toString();
    } catch (e) {
      return "Error";
    }
  }

  Future<String> GetLatestVersion() async {
    Response response = await Dio().get(appDatas.LatestVersionURL);
    return response.toString();
  }

  Future<String> SeedlingReceptionTxn(
    String respdate,
    String RecNo,
    String Longitude,
    String Latitude,
    String RespBatNo,
    String noOfseed,
    String recVariety,
    String nursery,
    String areaCode,
    String cSeasonCode,
    String BatchNo,
  ) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? agentid = prefs.getString("agentId");
    String? agentToken = prefs.getString("agentToken");
    String? serialnumber = prefs.getString("serialnumber");
    String? _modelNumber = await getModelNumber();
    final now = new DateTime.now();
    String formatter = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
    String msgNo = DateFormat('yyyyMMddHHmmss').format(now);
    var data = jsonEncode({
      "Request": {
        "body": {
          "data": [
            {"key": "respDate", "value": respdate},
            {"key": "recNo", "value": RecNo},
            {"key": "longitude", "value": Longitude},
            {"key": "latitude", "value": Latitude},
            {"key": "respBatNo", "value": RespBatNo},
            {"key": "noOfseed", "value": noOfseed},
            {"key": "recVariety", "value": recVariety},
            {"key": "nursery", "value": nursery},
            {"key": "areaCode", "value": areaCode},
            {"key": "cSeasonCode", "value": cSeasonCode}
          ]
        },
        "head": {
          "agentId": agentid,
          "agentToken": agentToken,
          "txnType": "608",
          "txnTime": formatter,
          "operType": "01",
          "mode": "01",
          "msgNo": msgNo,
          "resentCount": "0",
          "serialNo": serialnumber,
          "servPointId": "",
          "branchId": BatchNo,
          "versionNo": "20000|3",
          "tenantId": appDatas.tenent,
          "mobileModel": _modelNumber
        }
      }
    });

    print("reqdata : " + data.toString());
    Response response = await Dio().post(appDatas.TXN_URL, data: data);
    return response.toString();
  }

  Future<String> InputReturn(String reqdat) async {
    Response response = await Dio().post(
        "http://62.138.16.229:9001/agrotxnFlutter/rs/processTxnJson",
        data: reqdat);
    return response.toString();
  }

  String JwtHS256(String subdata, String hmacKey) {
    final hmac = Hmac(sha256, hmacKey.codeUnits);

//    json.decode({"numberPhone":"+22565786589", "country":"CI"});
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

  String generateMd5(String input) {
    return md5.convert(utf8.encode(input)).toString();
  }

  Future<String> getSerialnumber() async {
    String serial_number = '';
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    var sdkint = androidInfo.version.sdkInt;
    print("serial_numberrelease " + sdkint.toString());

    var androidDeviceInfo = await deviceInfo.androidInfo;
    serial_number = androidDeviceInfo.androidId;
    serial_number = generateMd5(serial_number);
    print("serial_number " + serial_number); // unique ID on Android

    return serial_number;
  }

  Future<String> getModelNumber() async {
    String Modelnumber = "";
    if (Platform.isIOS) {
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      Modelnumber = iosInfo.utsname.machine;
    } else if (Platform.isAndroid) {
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      Modelnumber = androidInfo.model;
    }
    return Modelnumber;
  }

  void printWrapped(String text) {
    final pattern = RegExp('.{1,800}'); // 800 is the size of each chunk
    pattern.allMatches(text).forEach((match) => print(match.group(0)));
  }

  Future<String> getIPAddress() async {
    String ipAddressValue = '';
    try {
      final ipv4 = await Ipify.ipv4();
      ipAddressValue = ipv4.toString();
    } catch (e) {
      ipAddressValue = '';
    }
    return ipAddressValue;
  }

  logout({required String txnType}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? serialnumber = prefs.getString("serialnumber");
    String? userName = prefs.getString("agentId");
    String? token = prefs.getString("agentToken");
    final now = DateTime.now();
    String formatter = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
    String msgNo = DateFormat('yyyyMMddHHmmss').format(now);
    print("agentToken :$token");
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String version = packageInfo.version;
    String ipAddress = await getIPAddress();
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

    List<String> versionlist = version
        .split(
            '.') // split the text into an array/ put the text inside a widget
        .toList();
    String? DBVERSION = prefs.getString("DBVERSION");
    String servicePointId = '';
    List agents = await db.RawQuery('SELECT * FROM agentMaster');

    if (agents.isEmpty) {
      servicePointId = "";
    } else {
      servicePointId = agents[0]['servicePointId'].toString();
    }

    var logOut = jsonEncode({
      /*"body": {
        "ppRevNo": pricePatternRev,
        "lRevNo": locationRev,
        "fsRevNo": fieldStaffRev,
        "fobRevNo": farmerOutStandBalRev,
        "prodRevNo": productDwRev,
        "seasonRevNo": seasonDwRev,
        "fcmRevNo": farmCrpDwRev,
        "procProdRevNo": procurementProdDwRev,
        "vwsRevNo": villageWareHouseDwRev,
        "gRevNo": gradeDwRev,
        "wsRevNo": wareHouseStockDwRev,
        "coRevNo": coOperativeDwRev,
        "byrRevNo": buyerDwRev,
        "supRevNo": supplierDwRev,
        "eventRevNo": eventDwRev,
        "catRevNo": catalogDwRev,
        "resStatRevNo": researchStationDwRev,
        "cSeasonCode": seasoncode,
        "agroVersion": "1",
        "plannerRevNo": plannerRev,
        "stRevNo": farmerStockBalRev,
        "dynLatestRevNo": dynamicDwRev,
        "followUpRevNo": followUpRevNo,
        "androidVersion": androidVersion,
        "mobileModel": modelNumber
      },*/
      "head": {
        "agentId": userName,
        "agentToken": token,
        "txnType": txnType,
        // "txnType": "301",
        "txnTime": formatter,
        "operType": "01",
        "mode": "01",
        "msgNo": msgNo,
        "resentCount": "0",
        "serialNo": serialnumber,
        "servPointId": servicePointId,
        "branchId": "",
        "versionNo": "${versionlist[0]}|${DBVERSION!}",
        "fsTrackerSts": "1|1",
        "tenantId": appDatas.tenent,
        "ipAddress": ipAddress,
        "lat": latitude,
        "lon": longitude,
      }
    });

    printWrapped("LogOut Request $logOut");

    Response response = await Dio().post(appDatas.TXN_URL, data: logOut);
    print('logOut Api $response');
    // return response.toString();
  }
}
