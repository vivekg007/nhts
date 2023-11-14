import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:ucda/Database/Model/FarmerMaster.dart';

//import '../Model/CostofcultivaionModel.dart';
import '../Model/Catelog.dart';
import '../Model/DistributionProductDetail.dart';
import '../Model/User.dart';
import '../Model/cropHarDetModel.dart';
import '../Model/cropHarvestModel.dart';
import '../Model/inputReturnModel.dart';
import '../commonlang/translateLang.dart';
import 'Model/AnimalCatalogModel.dart';
import 'Model/CostofcultivaionModel.dart';
import 'Model/CropListmodel.dart';
import 'Model/DistributionInsertvalue.dart';
import 'Model/PlannermaterialInsert.dart';
import 'Model/PlannermethodInsert.dart';
import 'Model/PlannerobservationInsert.dart';
import 'Model/PlannertrainingInsert.dart';
import 'Model/PlannerweekInsert.dart';
import 'Model/TrainingInsert.dart';
import 'Model/TrainingsubtopicesInsert.dart';
import 'Model/TrainingtopicesInsert.dart';
import 'Model/inpRetDetModel.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = new DatabaseHelper.internal();

  factory DatabaseHelper() => _instance;
  static Database? _db;

  Future<Database> get db async {
    if (_db != null) return _db!;
    _db = await openDB();
    return _db!;
  }

  DatabaseHelper.internal();

  // initDb() async {
  //   Directory documentsDirectory = await getApplicationDocumentsDirectory();
  //   String path = join(documentsDirectory.path, "bdagro.db");
  //   var theDb = await openDatabase(path, version: 3);
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   prefs.setString("DBVERSION", "3");
  //   return theDb;
  // }

  /*Future openDB() async {
    print("initDB executed");
    var theDb;
    print("CHECK_COPY_DATABASE 01");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? DBVERSION = prefs.getString("DBVERSION");
    int dbversion = int.parse(DBVERSION!);
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    var path = join(documentsDirectory.path, "dbagro" + DBVERSION + ".db");
    var file = new File(path);
    if (!await file.exists()) {
      try {
        await deleteDatabase(path);
        print("CHECK_COPY_DATABASE 02");
        ByteData data =
            await rootBundle.load(join("assets", "dbagro" + DBVERSION + ".db"));
        List<int> bytes =
            data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
        await new File(path).writeAsBytes(bytes);
        theDb = await openDatabase(path, readOnly: false, version: dbversion);
        print("CHECK_COPY_DATABASE 03");
      } catch (e) {
        print("CHECK_COPY_DATABASE err" + e.toString());
      }
    }
    try {
      print("CHECK_COPY_DATABASE 04");

      theDb = await openDatabase(path, readOnly: false, version: dbversion);
      TranslateFun.translate();
    } catch (e) {
      print("CHECK_COPY_DATABASE 05:" + e.toString());
      TranslateFun.translate();
    }
    print("CHECK_COPY_DATABASE 06");
    return theDb;
  }*/

  Future closeDB() async {
    if (_db != null) {
      await _db!.close();
      _db = null;
    }
  }

  Future openDB() async {
    print("initDB executed");
    var theDb;
    print("CHECK_COPY_DATABASE 01");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? DBVERSION = prefs.getString("DBVERSION");

    print('DB Version: $DBVERSION');

    int dbversion = int.parse(DBVERSION!);
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    var path = join(documentsDirectory.path, "dbagro" + DBVERSION + ".db");
    var file = new File(path);
    if (!await file.exists()) {
      try {
        await deleteDatabase(path);
        print("CHECK_COPY_DATABASE 02");
        ByteData data =
            await rootBundle.load(join("assets", "dbagro" + DBVERSION + ".db"));
        List<int> bytes =
            data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
        await new File(path).writeAsBytes(bytes);
        theDb = await openDatabase(path, readOnly: false, version: dbversion);
        print("CHECK_COPY_DATABASE 03");
      } catch (e) {
        print("CHECK_COPY_DATABASE err" + e.toString());
      }
    }
    try {
      print("CHECK_COPY_DATABASE 04");

      theDb = await openDatabase(path, readOnly: false, version: dbversion);
      TranslateFun.translate();
    } catch (e) {
      print("CHECK_COPY_DATABASE 05:" + e.toString());
      TranslateFun.translate();
    }
    print("CHECK_COPY_DATABASE 06");
    return theDb;
  }

  Future<List<Map>> getCatelog() async {
    var dbClient = await db;
    List<Map> list = await dbClient.rawQuery('SELECT * FROM catalog');
    for (int i = 0; i < list.length; i++) {
      var user = new Catelog(list[i]["IN_USE"], list[i]["DISP_SEQ"],
          list[i]["_ID"], list[i]["catalog_code"], list[i]["property_value"]);
      print('CHECKSAVEDATA   ' +
          list[i]["_ID"].toString() +
          " " +
          list[i]["catalog_code"].toString() +
          " " +
          list[i]["property_value"].toString());
    }
    return list;
  }

  Future<List<FarmerMaster>> GetFarmerdata() async {
    var dbClient = await db;
    List<Map> list1 = await dbClient
        .rawQuery('SELECT * FROM farmer_master where blockId = "2" ');
    List<Map> stateCode =
        await dbClient.rawQuery('select cityCode from agentMaster');
    String sCode = stateCode[0]['cityCode'];

    // split village code
    List districtCodeList = [];
    List districtCodeQList = [];
    List<String> stateCodeL = sCode.split(',');
    print("stateCodeV:" + stateCodeL.toString());

    for (int s = 0; s < stateCodeL.length; s++) {
      String sName = stateCodeL[s].toString();
      print("SName:" + sName.toString());
      districtCodeQList.add("'$sName'");
      districtCodeList.add(sName);
    }

    String sCodeQ = districtCodeQList.join(',');
    print("SCodeValue:" + sCodeQ); //and frmr.districtCode IN ($sCodeQ)

    List<Map> list = await dbClient.rawQuery(
        'SELECT * FROM farmer_master frmr,villageList vill where frmr.villageId=vill.villCode and frmr.blockId = "0" and frmr.districtCode IN ($sCodeQ)');
    print("farmerlist:" +
        list.toString() +
        'SELECT * FROM farmer_master frmr,villageList vill where frmr.villageId=vill.villCode and frmr.blockId = "0"');
    List<FarmerMaster> farmers = [];
    for (int i = 0; i < list.length; i++) {
      var farmerdata = new FarmerMaster(
          list[i]["farmerId"].toString(),
          list[i]["farmerCode"].toString(),
          list[i]["fName"].toString(),
          list[i]["lName"].toString(),
          list[i]["samithiCode"].toString(),
          list[i]["villageId"].toString(),
          list[i]["villName"].toString(),
          list[i]["blockId"].toString(),
          list[i]["blockName"].toString(),
          list[i]["procurementBalance"].toString(),
          list[i]["distributionBalance"].toString(),
          list[i]["farmCount"].toString(),
          list[i]["cliName"].toString(),
          list[i]["proName"].toString(),
          list[i]["fCertType"].toString(),
          list[i]["certCategory"].toString(),
          list[i]["certStandard"].toString(),
          list[i]["inspecType"].toString(),
          list[i]["ICSstatus"].toString(),
          list[i]["certCatName"].toString(),
          list[i]["certStandName"].toString(),
          list[i]["insTypeName"].toString(),
          list[i]["ICSstatusName"].toString(),
          list[i]["principleAmount"].toString(),
          list[i]["interestAmtAccumulated"].toString(),
          list[i]["rateOfInterest"].toString(),
          list[i]["lastInterestCalDate"].toString(),
          list[i]["proPrincipleAmount"].toString(),
          list[i]["proInterestAmtAccumulate"].toString(),
          list[i]["proLastInterestCalDate"].toString(),
          list[i]["proRateOfInterest"].toString(),
          list[i]["traceId"].toString(),
          list[i]["fatherName"].toString(),
          list[i]["certifiedFarmer"].toString(),
          list[i]["surName"].toString(),
          list[i]["utzStatus"].toString(),
          list[i]["cooperative"].toString(),
          list[i]["farmerStatus"].toString(),
          list[i]["icsCode"].toString(),
          list[i]["icsCodeName"].toString(),
          list[i]["stateCode"].toString(),
          list[i]["districtCode"].toString(),
          list[i]["cityCode"].toString(),
          list[i]["panCode"].toString(),
          list[i]["mobileNo"].toString(),
          list[i]["frPhoto"].toString(),
          list[i]["idstatus"].toString(),
          list[i]["pltStatus"].toString(),
          list[i]["geoStatus"].toString(),
          list[i]["phoneNo"].toString(),
          list[i]["ctName"].toString(),
          list[i]["maritalStatus"].toString(),
          list[i]["farmerCertStatus_sym"].toString(),
          list[i]["dead"].toString(),
          list[i]["Inspection"].toString(),
          list[i]["trader"].toString(),
          list[i]["address"].toString(),
          list[i]["farmerIndicator"].toString());

      farmers.add(farmerdata);
    }

    return farmers;
  }

  Future<List<FarmerMaster>> GetFarmerdatabyVillage(String villagecode) async {
    var dbClient = await db;

    String? slctqry =
        'SELECT * FROM farmer_master as frmr  inner join farm as fm on frmr.farmerId=fm.farmerId where villageId=\'' +
            villagecode +
            '\'';
    print(slctqry);
    List<Map> list = await dbClient.rawQuery(slctqry);

    print('farmer_master ' + list.toString());
    print('farmer_master ' + villagecode);
    List<FarmerMaster> farmers = [];
    for (int i = 0; i < list.length; i++) {
      var farmerdata = new FarmerMaster(
          list[i]["farmerId"].toString(),
          list[i]["farmerCode"].toString(),
          list[i]["fName"].toString(),
          list[i]["lName"].toString(),
          list[i]["samithiCode"].toString(),
          list[i]["villageId"].toString(),
          list[i]["villageName"].toString(),
          list[i]["blockId"].toString(),
          list[i]["blockName"].toString(),
          list[i]["procurementBalance"].toString(),
          list[i]["distributionBalance"].toString(),
          list[i]["farmCount"].toString(),
          list[i]["cliName"].toString(),
          list[i]["proName"].toString(),
          list[i]["fCertType"].toString(),
          list[i]["certCategory"].toString(),
          list[i]["certStandard"].toString(),
          list[i]["inspecType"].toString(),
          list[i]["ICSstatus"].toString(),
          list[i]["certCatName"].toString(),
          list[i]["certStandName"].toString(),
          list[i]["insTypeName"].toString(),
          list[i]["ICSstatusName"].toString(),
          list[i]["principleAmount"].toString(),
          list[i]["interestAmtAccumulated"].toString(),
          list[i]["rateOfInterest"].toString(),
          list[i]["lastInterestCalDate"].toString(),
          list[i]["proPrincipleAmount"].toString(),
          list[i]["proInterestAmtAccumulate"].toString(),
          list[i]["proLastInterestCalDate"].toString(),
          list[i]["proRateOfInterest"].toString(),
          list[i]["traceId"].toString(),
          list[i]["fatherName"].toString(),
          list[i]["certifiedFarmer"].toString(),
          list[i]["surName"].toString(),
          list[i]["utzStatus"].toString(),
          list[i]["cooperative"].toString(),
          list[i]["farmerStatus"].toString(),
          list[i]["icsCode"].toString(),
          list[i]["icsCodeName"].toString(),
          list[i]["stateCode"].toString(),
          list[i]["districtCode"].toString(),
          list[i]["cityCode"].toString(),
          list[i]["panCode"].toString(),
          list[i]["mobileNo"].toString(),
          list[i]["frPhoto"].toString(),
          list[i]["idstatus"].toString(),
          list[i]["pltStatus"].toString(),
          list[i]["geoStatus"].toString(),
          list[i]["phoneNo"].toString(),
          list[i]["ctName"].toString(),
          list[i]["maritalStatus"].toString(),
          list[i]["farmerCertStatus_sym"].toString(),
          list[i]["dead"].toString(),
          list[i]["Inspection"].toString(),
          list[i]["trader"].toString(),
          list[i]["address"].toString(),
          list[i]["farmerIndicator"].toString());

      farmers.add(farmerdata);
    }

    return farmers;
  }

  Future<List<AnimalCatalog>> GetCatalog() async {
    var dbClient = await db;
    List<Map> list = await dbClient.rawQuery('SELECT * FROM animalCatalog');

    List<AnimalCatalog> catalog = [];
    for (int i = 0; i < list.length; i++) {
      var animalcatalog = new AnimalCatalog(
          list[i]["catalog_code"].toString(),
          list[i]["property_value"].toString(),
          list[i]["DISP_SEQ "].toString(),
          list[i]["_ID"].toString(),
          list[i]["parentID "].toString(),
          list[i]["catStatus"].toString());

      catalog.add(animalcatalog);
    }

    return catalog;
  }

  Future<int> saveFarmerDB(FarmerMaster farmer) async {
    var dbClient = await db;
    int res = 0;
    try {
      print('saveFarmer');
      res = await dbClient.insert("farmer_master", farmer.toMap());
    } catch (e) {
      print('saveFarmer' + e.toString());
    }

    return res;
  }

  Future<int> saveCroplistvalues(CropListmodel cropListmodel) async {
    var dbClient = await db;
    int res = await dbClient.insert("farmCropExists", cropListmodel.toMap());
    return res;
  }

  Future<int> saveCatalog(AnimalCatalog catalog) async {
    var dbClient = await db;
    int res = await dbClient.insert("animalCatalog", catalog.toMap());
    return res;
  }

  Future<int> saveVariety(
    String? prodId,
    String? vCode,
    String? vName,
    String? days,
  ) async {
    var dbClient = await db;
    int res = await dbClient.rawInsert(
        'INSERT INTO "main"."varietyList" ( "prodId", "vCode", "vName", "days") VALUES (?,?,?,?)',
        [prodId, vCode, vName, days]);
    return res;
  }

  Future<int> SaveProcurement1(
      String? recNo, //revNo
      String? procId, //revNo
      String? procType, //'0'
      String? farmerId, //val_farmer
      String? farmerName, //slctFarmer
      String? totalAmt, //totalPriceController
      String? isSynched, //'0'
      String? procDate, //procurementdate
      String village, //val_Village
      String pmtAmt, //paymentAmountController
      String season, //seasoncode
      String year, //quantityPluckedController
      String driverName, //transactionAmountController
      String vehicleNo, //val_Trough
      String chartNo, //val_Product
      String pDate, //val_Variety
      String city, //val_Grade
      String poNo, //unitController
      String samCode, //samcode
      String isReg, //'0'
      String mobileNo, //""
      String supplierType, //'99'
      String currentSeason, //seasonCode
      String roadMap, //""
      String vehicle, //unitpricecontroller
      String farmId, //val_farm
      String substituteFarmer, //maleLabourInvolvedController
      String farmerAttend, //femaleLabourInvolvedController
      String farmCode, //val_MobileUser
      String farmerCode, //slctFarmer
      String longitude, //Lng
      String latitude, //Lat
      String supplierTypeTxt, //val_FLC
      String labourCost, //totalLabourInvolvedController
      String transportCost, //totalWagesPaidController
      String farmFFC, //maleWagesPaidController
      String cropTypeProc, //femaleWagesPaidController
      String invoiceNo, //""
      String buyerProc, //val_Factory
      String modeTrans //""
      ) async {
    var dbClient = await db;
    int res = await dbClient
        .rawInsert('INSERT INTO "main"."procurement" ("recNo") VALUES (?)', [
      recNo,
      procId,
      procType,
      farmerId,
      farmerName,
      totalAmt,
      isSynched,
      procDate,
      village,
      pmtAmt,
      season,
      year,
      driverName,
      vehicleNo,
      chartNo,
      pDate,
      city,
      poNo,
      samCode,
      isReg,
      mobileNo,
      supplierType,
      currentSeason,
      roadMap,
      vehicle,
      farmId,
      substituteFarmer,
      farmerAttend,
      farmCode,
      farmerCode,
      longitude,
      latitude,
      supplierTypeTxt,
      labourCost,
      transportCost,
      farmFFC,
      cropTypeProc,
      invoiceNo,
      buyerProc,
      modeTrans,
    ]);
    return res;
  }

  Future<int> SaveProcurement(
      {required String? recNo, //revNo
      required String? procId, //revNo
      required String? procType, //'0'
      required String? farmerId, //val_farmer
      required String? farmerName, //slctFarmer
      required String? totalAmt, //totalPriceController
      required String? isSynched, //'0'
      required String? procDate, //procurementdate
      required String village, //val_Village
      required String pmtAmt, //paymentAmountController
      required String season, //seasoncode
      required String year, //quantityPluckedController
      required String driverName, //transactionAmountController
      required String vehicleNo, //val_Trough
      required String chartNo, //val_Product
      required String pDate, //val_Variety
      required String city, //val_Grade
      required String poNo, //unitController
      required String samCode, //samcode
      required String isReg, //'0'
      required String mobileNo, //""
      required String supplierType, //'99'
      required String currentSeason, //seasonCode
      required String roadMap, //""
      required String vehicle, //unitpricecontroller
      required String farmId, //val_farm
      required String substituteFarmer, //maleLabourInvolvedController
      required String farmerAttend, //femaleLabourInvolvedController
      required String farmCode, //val_MobileUser
      required String farmerCode, //slctFarmer
      required String longitude, //Lng
      required String latitude, //Lat
      required String supplierTypeTxt, //val_FLC
      required String labourCost, //totalLabourInvolvedController
      required String transportCost, //totalWagesPaidController
      required String farmFFC, //maleWagesPaidController
      required String cropTypeProc, //femaleWagesPaidController
      required String invoiceNo, //""
      required String buyerProc, //val_Factory
      required String modeTrans //""
      }) async {
    var dbClient = await db;
    int res = await dbClient.rawInsert(
        'INSERT INTO "main"."procurement" ("recNo","procId","procType","farmerId","farmerName","totalAmt","isSynched","procDate","village","pmtAmt","season","year","driverName","vehicleNo","chartNo","pDate","city","poNo","samCode","isReg","mobileNo","supplierType","currentSeason","roadMap","vehicle","farmId","substituteFarmer","farmerAttend","farmCode","farmerCode","longitude","latitude","supplierTypeTxt","labourCost","transportCost","farmFFC","cropTypeProc","invoiceNo","buyerProc","modeTrans") VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)',
        [
          recNo,
          procId,
          procType,
          farmerId,
          farmerName,
          totalAmt,
          isSynched,
          procDate,
          village,
          pmtAmt,
          season,
          year,
          driverName,
          vehicleNo,
          chartNo,
          pDate,
          city,
          poNo,
          samCode,
          isReg,
          mobileNo,
          supplierType,
          currentSeason,
          roadMap,
          vehicle,
          farmId,
          substituteFarmer,
          farmerAttend,
          farmCode,
          farmerCode,
          longitude,
          latitude,
          supplierTypeTxt,
          labourCost,
          transportCost,
          farmFFC,
          cropTypeProc,
          invoiceNo,
          buyerProc,
          modeTrans,
        ]);
    return res;
  }

  Future<int> SaveProcurementGrade(
    String ppCode,
    String gradeCode,
    String prodId,
    String area,
    String grade,
    String price,
    String vCode,
  ) async {
    var dbClient = await db;
    int res = await dbClient.rawInsert(
        'INSERT INTO "main"."procurementGrade" ("ppCode", "gradeCode", "prodId", "area", "grade", "price", "vCode") VALUES (?,?,?,?,?,?,?)',
        [ppCode, gradeCode, prodId, area, grade, price, vCode]);
    return res;
  }

  Future<int> SaveGrade(
      String ppCode, String gradeCode, String prodId, String area) async {
    var dbClient = await db;
    int res = await dbClient.rawInsert(
        'INSERT INTO "main"."cropYieldList" ("fCrpCode", "yield", "fCode", "idPoll") VALUES (?,?,?,?)',
        [ppCode, gradeCode, prodId, area]);
    return res;
  }

  Future<int> SaveCalendarCrop(String cropSeason, String activeMethod,
      String activeType, String vCode, String noOfDays, String name) async {
    var dbClient = await db;
    int res = await dbClient.rawInsert(
        'INSERT INTO "main"."calendarCrop" ("cropSeason", "activeMethod", "activeType", "vCode", "noOfDays", "name") VALUES (?,?,?,?,?,?)',
        [cropSeason, activeMethod, activeType, vCode, noOfDays, name]);
    return res;
  }

  // Future<int> SaveFarm(
  //     String farmIDT,
  //     String farmId,
  //     String farmName,
  //     String farmerId,
  //     String currentConversion,
  //     String chemicalAppLastDate,
  //     String longitude,
  //     String latitude,
  //     String verifyStatus,
  //     String farmdeleteStatus,
  //     String pltStatus,
  //     String geoStatus,
  //     String insDate,
  //     String inspName,
  //     String insType,
  //     String totLand,
  //     String prodLand,
  //     String inspDetList,
  //     String dynfield,
  //     String landProd) async {
  //   var dbClient = await db;
  //   int res = await dbClient.rawInsert(
  //       'INSERT INTO "main"."farm" ("farmIDT", "farmId", "farmName", "farmerId", "currentConversion", "chemicalAppLastDate", "longitude", "latitude","verifyStatus","farmdeleteStatus","pltStatus","geoStatus","insDate","inspName","insType","totLand","prodLand","inspDetList","dynfield","landProd") VALUES (?, ?,?, ?, ?,?,?,?,?, ?,?, ?, ?,?,?,?,?, ?,?, ?, ?,?)',
  //       [
  //         farmIDT,
  //         farmId,
  //         farmName,
  //         farmerId,
  //         currentConversion,
  //         chemicalAppLastDate,
  //         longitude,
  //         latitude,
  //         "1",
  //         "0",
  //         verifyStatus,
  //         farmdeleteStatus,
  //         pltStatus,
  //         geoStatus,
  //         insDate,
  //         inspName,
  //         insType,
  //         totLand,
  //         prodLand,
  //         inspDetList,
  //         dynfield,
  //         landProd
  //       ]);
  //   return res;
  // }
  Future<int> SaveFarm(
      String farmIDT,
      String farmId,
      String farmName,
      String farmerId,
      String currentConversion,
      String chemicalAppLastDate,
      String longitude,
      String latitude,
      String verifyStatus,
      String farmdeleteStatus,
      String pltStatus,
      String geoStatus,
      String insDate,
      String inspName,
      String insType,
      String totLand,
      String prodLand,
      String inspDetList,
      String dynfield,
      String landProd,
      String totTrees) async {
    var dbClient = await db;
    int res = await dbClient.rawInsert(
        'INSERT INTO "main"."farm" ( "farmIDT", "farmId", "farmName", "farmerId", "currentConversion", "chemicalAppLastDate", "longitude", "latitude","isSynched","farmStatus","verifyStatus","farmdeleteStatus","pltStatus","geoStatus","insDate","inspName","insType","totLand","prodLand","inspDetList","dynfield","landProd","totTrees") VALUES (?, ?,?, ?, ?,?,?,?,?, ?,?, ?, ?,?,?,?,?, ?,?, ?, ?,?,?)',
        [
          farmIDT,
          farmId,
          farmName,
          farmerId,
          currentConversion,
          chemicalAppLastDate,
          longitude,
          latitude,
          "1",
          "0",
          verifyStatus,
          farmdeleteStatus,
          pltStatus,
          geoStatus,
          insDate,
          inspName,
          insType,
          totLand,
          prodLand,
          inspDetList,
          dynfield,
          landProd,
          totTrees
        ]);
    return res;
  }

  Future<int> SaveFarm1(
      String farmIDT,
      String farmId,
      String farmName,
      String farmerId,
      String currentConversion,
      String chemicalAppLastDate,
      String longitude,
      String latitude,
      String isSynched,
      String farmStatus,
      String verifyStatus,
      String farmdeleteStatus,
      String pltStatus,
      String geoStatus,
      String insDate,
      String inspName,
      String insType,
      String totLand,
      String prodLand,
      String inspDetList,
      String dynfield,
      String landProd,
      String recNo) async {
    var dbClient = await db;
    int res = await dbClient.rawInsert(
        'INSERT INTO "main"."farm" ( "farmIDT", "farmId", "farmName", "farmerId", "currentConversion", "chemicalAppLastDate", "longitude", "latitude","isSynched","farmStatus","verifyStatus","farmdeleteStatus","pltStatus","geoStatus","insDate","inspName","insType","totLand","prodLand","inspDetList","dynfield","landProd","recptId") VALUES (?, ?,?, ?, ?,?,?,?,?, ?,?, ?, ?,?,?,?,?, ?,?, ?, ?,?,?)',
        [
          farmIDT,
          farmId,
          farmName,
          farmerId,
          currentConversion,
          chemicalAppLastDate,
          longitude,
          latitude,
          isSynched,
          farmStatus, //"0"
          verifyStatus,
          farmdeleteStatus,
          pltStatus,
          geoStatus,
          insDate,
          inspName,
          insType,
          totLand,
          prodLand,
          inspDetList,
          dynfield,
          landProd,
          recNo
        ]);
    return res;
  }

  Future<int> SaveAggregator(
    String enrollmentPlace,
    String enrollmentDate,
    String enrollingPerson,
    String aggregatorname,
    String fatherName,
    String gfatherName,
    String gender,
    String dob,
    String aggregatorType,
    String agretrotherspecfy,
    String mainAggregator,
    String aggregatorPhoto,
    String education,
    String mobNumber,
    String email,
    String country,
    String zone,
    String woreda,
    String kebele,
    String groupAppartenance,
    String groupType,
    String otherspecfy,
    String groupName,
    String groupPosition,
    String accountNumber,
    String bankName,
    String branchName,
    String bankPhoto,
    String licensed,
    String licensePhoto,
    String taxInvoice,
    String isSynched,
    String recNo,
    String latitude,
    String longitude,
    String loanTaken,
    String amount,
    String year,
  ) async {
    var dbClient = await db;
    int res = await dbClient.rawInsert(
        'INSERT INTO "main"."aggregator" ( "enrollmentPlace", "enrollmentDate", "enrollingPerson", "aggregatorname", "fatherName", "gfatherName","gender", "dob",  "aggregatorType","aggregatorTypeOthr","mainAggregator","aggregatorPhoto","education","mobNumber","email","country","zone","woreda","kebele","groupAppartenance","groupType","groupNameOthr","groupName","groupPosition","accountNumber","bankName","branchName","bankPhoto","licensed","licensePhoto","taxInvoice","isSynched","recNo","latitude","longitude","loan","loanAmount","loanYear") VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)',
        [
          enrollmentPlace,
          enrollmentDate,
          enrollingPerson,
          aggregatorname,
          fatherName,
          gfatherName,
          gender,
          dob,
          aggregatorType,
          agretrotherspecfy,
          mainAggregator,
          aggregatorPhoto,
          education,
          mobNumber,
          email,
          country,
          zone,
          woreda,
          kebele,
          groupAppartenance,
          groupType,
          otherspecfy,
          groupName,
          groupPosition,
          accountNumber,
          bankName,
          branchName,
          bankPhoto,
          licensed,
          licensePhoto,
          taxInvoice,
          isSynched,
          recNo,
          latitude,
          longitude,
          loanTaken,
          amount,
          year,
        ]);
    return res;
  }

  Future<int> saveProcurementDetails({
    required String prodCode,
    required String price,
    required String procId,
    required String subTotal,
    required String samcode,
    required String quality,
    required String bags,
    required String wghtbags,
    required String grossWt,
    required String tareWt,
    required String netWt,
    required String procure_batchNo,
    required String procure_UOM,
    required String nofrutbgs,
    required String farmerId,
    required String villageId,
    required String edibleNuts,
    required String inedibleNuts,
    required String toteditnuts,
    required String inspectDamage,
    required String moldyNuts,
    required String immatureNuts,
    required String colouredNuts,
    required String moistureContent,
    required String goodNuts,
    required String varietyid,
  }) async {
    var dbClient = await db;
    int res = await dbClient.rawInsert(
        'INSERT INTO "main"."procurementDetails" ( "prodCode","price","procId","subTotal","samcode","quality","bags","grossWt","tareWt","wghtbags","netWt","procure_batchNo","procure_UOM","nofrutbgs","farmerId","villageId","edibleNuts","inedibleNuts","toteditnuts","inspectDamage","moldyNuts","immatureNuts","colouredNuts","moistureContent","goodNuts","varietyid") VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)',
        [
          prodCode,
          price,
          procId,
          subTotal,
          samcode,
          quality,
          bags,
          grossWt,
          tareWt,
          wghtbags,
          netWt,
          procure_batchNo,
          procure_UOM,
          nofrutbgs,
          farmerId,
          villageId,
          edibleNuts,
          inedibleNuts,
          toteditnuts,
          inspectDamage,
          moldyNuts,
          immatureNuts,
          colouredNuts,
          moistureContent,
          goodNuts,
          varietyid
        ]);
    return res;
  }

  Future<int> saveRawSeedCleaning(
    String variety,
    String generation,
    String warehouseName,
    String dateOfDepature,
    String siv,
    String grossWeight,
    String tareWeight,
    String netWeight,
    String noOfbags,
    String destination,
    String representative,
    String phone,
    String transactionService,
    String driverName,
    String driverPhone,
    String plate,
    String getTicket,
    String gatePass,
    String cleaningName,
    String Daterecp,
    String grn,
    String representativeGrn,
    String grossWeightGrn,
    String tareWeightGrn,
    String netWeightGrn,
    String noOfbagsGrn,
    String weightPhoto,
    String grnPhoto,
    String isSynched,
    String recNo,
    String lat,
    String lng,
    String stackId,
    String lotSpecification,
  ) async {
    var dbClient = await db;

    int res = await dbClient.rawInsert(
        'INSERT INTO "main"."rawseedclean" ("variety", "generation", "warehouseName", "dateOfDepar", "siv", "grossWeight","tareWeight","netWeight", "noOfBags", "destination", "representative", "phone", "transactionSer","driverName","driverPhone", "plate", "getTicket", "gatePass", "cleaningName", "dateRecp","grn", "representativeGRN", "grossWeightGRN", "tareWeightGRN","netWeightGRN","noOfBagsGRN", "weightPhoto", "grnPhoto", "isSynched", "recNo", "latitude","longitude","stackId","lotSpec") VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)',
        [
          variety,
          generation,
          warehouseName,
          dateOfDepature,
          siv,
          grossWeight,
          tareWeight,
          netWeight,
          noOfbags,
          destination,
          representative,
          phone,
          transactionService,
          driverName,
          driverPhone,
          plate,
          getTicket,
          gatePass,
          cleaningName,
          Daterecp,
          grn,
          representativeGrn,
          grossWeightGrn,
          tareWeightGrn,
          netWeightGrn,
          noOfbagsGrn,
          weightPhoto,
          grnPhoto,
          isSynched,
          recNo,
          lat,
          lng,
          stackId,
          lotSpecification
        ]);
    return res;
  }

  Future<int> saveRawSeedRecep(
    String cleaningName,
    String siv,
    String Daterecp,
    String grn,
    String representativeGrn,
    String grossWeightGrn,
    String tareWeightGrn,
    String netWeightGrn,
    String noOfbagsGrn,
    String weightPhoto,
    String grnPhoto,
    String isSynched,
    String recNo,
    String seasonCode,
    String lat,
    String lng,
    String stackId,
    String lotSpecification,
  ) async {
    var dbClient = await db;

    int res = await dbClient.rawInsert(
        'INSERT INTO "main"."rawseedcleanReception" ("cleaningName","siv", "dateRecp","grn", "representativeGRN", "grossWeightGRN", "tareWeightGRN","netWeightGRN","noOfBagsGRN", "weightPhoto", "grnPhoto", "isSynched", "recNo", "seasonCode", "latitude","longitude","stackId","lotSpec") VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)',
        [
          cleaningName,
          siv,
          Daterecp,
          grn,
          representativeGrn,
          grossWeightGrn,
          tareWeightGrn,
          netWeightGrn,
          noOfbagsGrn,
          weightPhoto,
          grnPhoto,
          isSynched,
          recNo,
          seasonCode,
          lat,
          lng,
          stackId,
          lotSpecification,
        ]);
    return res;
  }

  Future<int> SaveRawpurchase(
      String? recNo,
      String? isSynched,
      String longitude,
      String latitude,
      String txnType,
      String txnDate,
      String season,
      String teantId,
      String Typemultp,
      String agctrcode,
      String datedelivery,
      String? warehusedelivery,
      String? truckticket,
      String plateN,
      String sampleby,
      String samplereference,
      String Qualitycheckby,
      String Qualityancticket,
      String Approvdby,
      String unstackedby,
      String Moisture,
      String? screening,
      String? screenbtwn,
      String Underseive,
      String Brokengrain,
      String Inertmatr,
      String otherseed,
      String dusotherforgmtr,
      String totaladmixture,
      String Wildoat,
      String DiseasgrainmldFsm,
      String Infestdgrain,
      String Sproutedgrain,
      String greengrain,
      String? Total,
      String? Varirtyname,
      String Varietypurity,
      String matbarlygrad,
      String Comments,
      String Vehiclegrosswght,
      String Vehicletarewght,
      String Netwght,
      String NumofBags,
      String OtherDection,
      String Netwghtpaid,
      String? Wghtbdsliphoto,
      String Photogetpass,
      String stackId) async {
    var dbClient = await db;
    int res = await dbClient.rawInsert(
        'INSERT INTO "main"."rawPurchase" ("recNo","isSynched","longitude","latitude","txnType","txnDate","season","teantId","typeMultp","agctrcode","datedelivery","warehusedelivery","truckticket","plateN","sampleby","samplereference","qualitycheckby","qualityancticket","approvdby","unstackedby","moisture","screening","screenbtwn","underseive","brokengrain","Inertmatr","otherseed","dusotherforgmtr","totaladmixture","wildoat","diseasgrainmldFsm","infestdgrain","sproutedgrain","greengrain","total","varirtyname","varietypurity","matbarlygrad","comments","vehiclegrosswght","vehicletarewght","netwght","numofBags","otherDection","netwghtpaid","wghtbdsliphoto","photogetpass","stackId") VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)',
        [
          recNo,
          isSynched,
          longitude,
          latitude,
          txnType,
          txnDate,
          season,
          teantId,
          Typemultp,
          agctrcode,
          datedelivery,
          warehusedelivery,
          truckticket,
          plateN,
          sampleby,
          samplereference,
          Qualitycheckby,
          Qualityancticket,
          Approvdby,
          unstackedby,
          Moisture,
          screening,
          screenbtwn,
          Underseive,
          Brokengrain,
          Inertmatr,
          otherseed,
          dusotherforgmtr,
          totaladmixture,
          Wildoat,
          DiseasgrainmldFsm,
          Infestdgrain,
          Sproutedgrain,
          greengrain,
          Total,
          Varirtyname,
          Varietypurity,
          matbarlygrad,
          Comments,
          Vehiclegrosswght,
          Vehicletarewght,
          Netwght,
          NumofBags,
          OtherDection,
          Netwghtpaid,
          Wghtbdsliphoto,
          Photogetpass,
          stackId,
        ]);
    return res;
  }
  // Future<int> saveExistsFarmer(
  //     String isSynched,
  //     String recId,
  //     String farmerId,
  //     String farmerlatitude,
  //     String farmerlongitude,
  //     String farmertimeStamp,
  //     String farmerphoto,
  //     String farmlatitude,
  //     String farmlongitude,
  //     String farmtimeStamp,
  //     String farmphoto,
  //     String farmArea,
  //     String prodLand,
  //     String notProdLand,
  //     String farmId,
  //     String voice,
  //     String currentSeason,
  //     String cropLifeInsurance,
  //     String crophealthInsurance,
  //     String cropInsuranceCrop,
  //     String cropBank,
  //     String cropMoneyVendor,
  //     String pltStatus,
  //     String geoStatus) async {
  //   var dbClient = await db;
  //
  //   int res = await dbClient.rawInsert(
  //       'INSERT INTO "main"."exists_farmer" ("isSynched","recId","farmerId","farmerlatitude","farmerlongitude","farmertimeStamp","farmerphoto","farmlatitude","farmlongitude","farmtimeStamp","farmphoto","farmArea","prodLand","notProdLand","farmId","voice","currentSeason","cropLifeInsurance","cropInsuranceCrop","cropBank","cropMoneyVendor","crophealthInsurance","pltStatus","geoStatus") VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)',
  //       [
  //         isSynched,
  //         recId,
  //         farmerId,
  //         farmerlatitude,
  //         farmerlongitude,
  //         farmertimeStamp,
  //         farmerphoto,
  //         farmlatitude,
  //         farmlongitude,
  //         farmtimeStamp,
  //         farmphoto,
  //         farmArea,
  //         prodLand,
  //         notProdLand,
  //         farmId,
  //         voice,
  //         currentSeason,
  //         cropLifeInsurance,
  //         cropInsuranceCrop,
  //         cropBank,
  //         cropMoneyVendor,
  //         crophealthInsurance,
  //         pltStatus,
  //         geoStatus
  //       ]);
  //   return res;
  // }
  //
  // Future<int> saveFarmGPSLocationExists(
  //   String latitude,
  //   String longitude,
  //   String farmerId,
  //   String farmId,
  //   String OrderOFGPS,
  //   String reciptId,
  // ) async {
  //   var dbClient = await db;
  //   int res = await dbClient.rawInsert(
  //       'INSERT INTO "main"."farm_GPSLocation_Exists" ("latitude","longitude","farmerId","farmId","OrderOFGPS","reciptId") VALUES (?,?,?,?,?,?)',
  //       [
  //         latitude,
  //         longitude,
  //         farmerId,
  //         farmId,
  //         OrderOFGPS,
  //         reciptId,
  //       ]);
  //
  //   return res;
  // }
  //
  // Future<int> savefarmCropGPSLocationExists(
  //   String latitude,
  //   String longitude,
  //   String farmerId,
  //   String farmId,
  //   String OrderOFGPS,
  //   String cropId,
  //   String varietyId,
  //   String reciptId,
  // ) async {
  //   var dbClient = await db;
  //   int res = await dbClient.rawInsert(
  //       'INSERT INTO "main"."farmCrop_GPSLocation_Exists" ("latitude","longitude","farmerId","farmId","OrderOFGPS","cropId","varietyId","reciptId") VALUES (?,?,?,?,?,?,?,?)',
  //       [
  //         latitude,
  //         longitude,
  //         farmerId,
  //         farmId,
  //         OrderOFGPS,
  //         cropId,
  //         varietyId,
  //         reciptId,
  //       ]);
  //
  //   return res;
  // }
  //
  // Future<int> saveFarmCropExists(
  //   String farmCodeRef,
  //   String farmerId,
  //   String cropArea,
  //   String cropCode,
  //   String production,
  //   String cropCategory,
  //   String cropSeason,
  //   String cropVariety,
  //   String seedSource,
  //   String reciptId,
  //   String stableLengthMain,
  //   String seedusedMain,
  //   String seedcostMain,
  //   String cropType,
  //   String dateOfSown,
  //   String yearofplant,
  //   String estHarvestDt,
  //   String seedTreatment,
  //   String otherSeedTreatment,
  //   String riskAssesment,
  //   String riskBufferZone,
  //   String cultivationType,
  //   String culAreaCrop,
  //   String othercropType,
  //   String interCropType,
  //   String interCropAcr,
  //   String interCropHarvest,
  //   String interCropGrossIncome,
  //   String noOftrees,
  //   String prodctOftrees,
  //   String affectedTrees,
  //   String cropEditStatus,
  // ) async {
  //   var dbClient = await db;
  //
  //   int res = await dbClient.rawInsert(
  //       'INSERT INTO "main"."farmCropExists" ("farmCodeRef","farmerId","cropArea","cropCode","production","cropCategory","cropSeason","cropVariety","seedSource","reciptId","stableLengthMain","seedusedMain","seedcostMain","cropType","dateOfSown","yearofplant","estHarvestDt","seedTreatment","otherSeedTreatment","riskAssesment","riskBufferZone","cultivationType","culAreaCrop","othercropType","interCropType","interCropAcr","interCropHarvest","interCropGrossIncome","noOftrees","prodctOftrees","affectedTrees","cropEditStatus") VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)',
  //       [
  //         farmCodeRef,
  //         farmerId,
  //         cropArea,
  //         cropCode,
  //         production,
  //         cropCategory,
  //         cropSeason,
  //         cropVariety,
  //         seedSource,
  //         reciptId,
  //         stableLengthMain,
  //         seedusedMain,
  //         seedcostMain,
  //         cropType,
  //         dateOfSown,
  //         yearofplant,
  //         estHarvestDt,
  //         seedTreatment,
  //         otherSeedTreatment,
  //         riskAssesment,
  //         riskBufferZone,
  //         cultivationType,
  //         culAreaCrop,
  //         othercropType,
  //         interCropType,
  //         interCropAcr,
  //         interCropHarvest,
  //         interCropGrossIncome,
  //         noOftrees,
  //         prodctOftrees,
  //         affectedTrees,
  //         cropEditStatus
  //       ]);
  //   return res;
  // }

  Future<int> saveExistsFarmer(
      String isSynched,
      String recId,
      String farmerId,
      String farmerlatitude,
      String farmerlongitude,
      String farmertimeStamp,
      String farmerphoto,
      String farmlatitude,
      String farmlongitude,
      String farmtimeStamp,
      String farmphoto,
      String farmArea,
      String prodLand,
      String notProdLand,
      String farmId,
      String voice,
      String currentSeason,
      String cropLifeInsurance,
      String crophealthInsurance,
      String cropInsuranceCrop,
      String cropBank,
      String cropMoneyVendor,
      String pltStatus,
      String geoStatus,
      String villageCode) async {
    var dbClient = await db;

    int res = await dbClient.rawInsert(
        'INSERT INTO "main"."exists_farmer" ("isSynched","recId","farmerId","farmerlatitude","farmerlongitude","farmertimeStamp","farmerphoto","farmlatitude","farmlongitude","farmtimeStamp","farmphoto","farmArea","prodLand","notProdLand","farmId","voice","currentSeason","cropLifeInsurance","cropInsuranceCrop","cropBank","cropMoneyVendor","crophealthInsurance","pltStatus","geoStatus","village") VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)',
        [
          isSynched,
          recId,
          farmerId,
          farmerlatitude,
          farmerlongitude,
          farmertimeStamp,
          farmerphoto,
          farmlatitude,
          farmlongitude,
          farmtimeStamp,
          farmphoto,
          farmArea,
          prodLand,
          notProdLand,
          farmId,
          voice,
          currentSeason,
          cropLifeInsurance,
          cropInsuranceCrop,
          cropBank,
          cropMoneyVendor,
          crophealthInsurance,
          pltStatus,
          geoStatus,
          villageCode
        ]);
    return res;
  }

  Future<int> saveFarmGPSLocationExists(
      String latitude,
      String longitude,
      String farmerId,
      String farmId,
      String OrderOFGPS,
      String reciptId,
      String partialGps) async {
    var dbClient = await db;
    int res = await dbClient.rawInsert(
        'INSERT INTO "main"."farm_GPSLocation_Exists" ("latitude","longitude","farmerId","farmId","OrderOFGPS","reciptId","partialGps") VALUES (?,?,?,?,?,?,?)',
        [
          latitude,
          longitude,
          farmerId,
          farmId,
          OrderOFGPS,
          reciptId,
          partialGps
        ]);

    return res;
  }

  Future<int> savefarmCropGPSLocationExists(
    String latitude,
    String longitude,
    String farmerId,
    String farmId,
    String OrderOFGPS,
    String cropId,
    String varietyId,
    String reciptId,
  ) async {
    var dbClient = await db;
    int res = await dbClient.rawInsert(
        'INSERT INTO "main"."farmCrop_GPSLocation_Exists" ("latitude","longitude","farmerId","farmId","OrderOFGPS","cropId","varietyId","reciptId") VALUES (?,?,?,?,?,?,?,?)',
        [
          latitude,
          longitude,
          farmerId,
          farmId,
          OrderOFGPS,
          cropId,
          varietyId,
          reciptId,
        ]);

    return res;
  }

  Future<int> saveFarmCropExists(
    String farmCodeRef,
    String farmerId,
    String cropArea,
    String cropCode,
    String production,
    String cropCategory,
    String cropSeason,
    String cropVariety,
    String seedSource,
    String reciptId,
    String stableLengthMain,
    String seedusedMain,
    String seedcostMain,
    String cropType,
    String dateOfSown,
    String yearofplant,
    String estHarvestDt,
    String seedTreatment,
    String otherSeedTreatment,
    String riskAssesment,
    String riskBufferZone,
    String cultivationType,
    String culAreaCrop,
    String othercropType,
    String interCropType,
    String interCropAcr,
    String interCropHarvest,
    String interCropGrossIncome,
    String noOftrees,
    String prodctOftrees,
    String affectedTrees,
    String cropEditStatus,
  ) async {
    var dbClient = await db;

    int res = await dbClient.rawInsert(
        'INSERT INTO "main"."farmCropExists" ("farmCodeRef","farmerId","cropArea","cropCode","production","cropCategory","cropSeason","cropVariety","seedSource","reciptId","stableLengthMain","seedusedMain","seedcostMain","cropType","dateOfSown","yearofplant","estHarvestDt","seedTreatment","otherSeedTreatment","riskAssesment","riskBufferZone","cultivationType","culAreaCrop","othercropType","interCropType","interCropAcr","interCropHarvest","interCropGrossIncome","noOftrees","prodctOftrees","affectedTrees","cropEditStatus") VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)',
        [
          farmCodeRef,
          farmerId,
          cropArea,
          cropCode,
          production,
          cropCategory,
          cropSeason,
          cropVariety,
          seedSource,
          reciptId,
          stableLengthMain,
          seedusedMain,
          seedcostMain,
          cropType,
          dateOfSown,
          yearofplant,
          estHarvestDt,
          seedTreatment,
          otherSeedTreatment,
          riskAssesment,
          riskBufferZone,
          cultivationType,
          culAreaCrop,
          othercropType,
          interCropType,
          interCropAcr,
          interCropHarvest,
          interCropGrossIncome,
          noOftrees,
          prodctOftrees,
          affectedTrees,
          cropEditStatus
        ]);
    return res;
  }

  Future<List<Map>> GetVariety() async {
    var dbClient = await db;
    List<Map> list = await dbClient.rawQuery('SELECT * FROM varietyList');

    return list;
  }

  Future<int> saveUser(User user) async {
    int? res;
    var dbClient = await db;

    List<User> agentlist = await getUser();
    if (agentlist.length > 0) {
      print("CHECKDATABASE_A");
      deleteUsers(user);
    } else {
      print("CHECKDATABASE_B");
      res = await dbClient.insert("agentMaster", user.toMap());
    }
    return res!;
  }

  Future<int> deleteUsers(User user) async {
    int res;
    var dbClient = await db;
    res = await dbClient
        .rawDelete('DELETE FROM agentMaster WHERE agentId = ?', [user.agentId]);
    res = await dbClient.insert("agentMaster", user.toMap());
    return res;
  }

  Future<int> SaveSeedlingReception(
      String recNo,
      String respDate,
      String isSynched,
      String longitude,
      String latitude,
      String respBatNo,
      String noOfseed,
      String recVariety,
      String nursey,
      String areaCode,
      String recBatchNo,
      String cSeasonCode) async {
    var dbClient = await db;
    int res = await dbClient.rawInsert(
        'INSERT INTO "main"."seedlingReception" ("recNo", "respDate", "isSynched", "longitude", "latitude", "respBatNo", "noOfseed", "recVariety", "nursey", "areaCode", "recBatchNo", "cSeasonCode") VALUES (?, ?,?, ?, ?,?,?,?,?,?,?,?)',
        [
          recNo,
          respDate,
          isSynched,
          longitude,
          latitude,
          respBatNo,
          noOfseed,
          recVariety,
          nursey,
          areaCode,
          recBatchNo,
          cSeasonCode
        ]);
    return res;
  }

  Future<int> saveTxnHeader(
      String isPrinted,
      String txnTime,
      String mode,
      String operType,
      String resentCount,
      String agentId,
      String agentToken,
      String msgNo,
      String servPointId,
      String txnRefId) async {
    var dbClient = await db;
    int res = await dbClient.rawInsert(
        'INSERT INTO "main"."txnHeader" ("isPrinted", "txnTime", "mode", "operType", "resentCount", "agentId", "agentToken", "msgNo", "servPointId", "txnRefId") VALUES (?, ?,?, ?, ?,?,?,?,?,?)',
        [
          isPrinted,
          txnTime,
          mode,
          operType,
          resentCount,
          agentId,
          agentToken,
          msgNo,
          servPointId,
          txnRefId
        ]);
    return res;
  }

  Future<int> saveCustTransaction(String txnDate, String txnConfigId,
      String txnRefId, String entity, String dynTxnid, String txnName) async {
    var dbClient = await db;
    int res = await dbClient.rawInsert(
        'INSERT INTO "main"."custTransactions" ("txnDate", "txnConfigId", "txnRefId", "entity", "dynTxnid", "txnName") VALUES (?, ?,?, ?, ?,?)',
        [txnDate, txnConfigId, txnRefId, entity, dynTxnid, txnName]);
    return res;
  }

  Future<int> saveFieldstaffTransaction(
      String pDate,
      String villageId,
      String startLocation,
      String destination,
      String fieldActivity,
      String startKM,
      String endKM,
      String model,
      String cc,
      String recNo,
      String mileage,
      String actNumber,
      String isSynched,
      String actHours,
      String timeStamps,
      String longitude,
      String latitude) async {
    var dbClient = await db;
    int res = await dbClient.rawInsert(
        'INSERT INTO "main"."fieldActivity" ("pDate","villageId", "startLocation", "destination", "fieldActivity", "startKM", "endKM", "model", "cc", "recNo", "mileage","actNumber","isSynched","actHours","timeStamps","longitude","latitude") VALUES (?,?, ?,?, ?, ?,?, ?,?, ?, ?,?, ?,?, ?, ?,?)',
        [
          pDate,
          villageId,
          startLocation,
          destination,
          fieldActivity,
          startKM,
          endKM,
          model,
          cc,
          recNo,
          mileage,
          actNumber,
          isSynched,
          actHours,
          timeStamps,
          longitude,
          latitude
        ]);
    return res;
  }

  Future<List<Map>> GetTableValues(String tableName) async {
    var dbClient = await db;
    List<Map> list = await dbClient.rawQuery('SELECT * FROM ' + tableName);

    return list;
  }

  Future<List<Map>> GetCropdataValues(String tableName) async {
    var dbClient = await db;
    List<Map> list = await dbClient.rawQuery('SELECT * FROM ' + tableName);
    return list;
  }

  Future<List<Map>> GetUnSyncTableValues(String tableName) async {
    var dbClient = await db;
    List<Map> list = await dbClient
        .rawQuery('SELECT * FROM ' + tableName + ' Where isSynched = 0');

    return list;
  }

  Future<List<User>> getUser() async {
    var dbClient = await db;
    List<Map> list = await dbClient.rawQuery('SELECT * FROM agentMaster');
    List<User> agents = [];
    for (int i = 0; i < list.length; i++) {
      print("ID " + list[i]["ID"]);
      var user = new User(
        list[i]["clientProjectRev"],
        list[i]["agentDistributionBal"],
        //list[i]["agentProcurementBal"],
        list[i]["currentSeasonCode"],
        list[i]["pricePatternRev"],
        list[i]["agentType"],
        list[i]["tareWeight"],
        //list[i]["curIdSeqS"],
        //list[i]["resIdSeqS"],
        //list[i]["curIdLimitS"],
        //list[i]["curIdLimitF"],
        //list[i]["resIdSeqF"],
        //list[i]["curIdSeqF"],
        list[i]["agentAccBal"],
        list[i]["farmerRev"],
        list[i]["shopRev"],
        list[i]["agentId"],
        list[i]["agentName"],
        list[i]["cityCode"],
        list[i]["servPointName"],
        list[i]["agentPassword"],
        list[i]["servicePointId"],
        list[i]["locationRev"],
        list[i]["trainingRev"],
        list[i]["plannerRev"],
        list[i]["farmerOutStandBalRev"],
        list[i]["productDwRev"],
        list[i]["farmCrpDwRev"],
        list[i]["procurementProdDwRev"],
        list[i]["villageWareHouseDwRev"],
        list[i]["gradeDwRev"],
        list[i]["wareHouseStockDwRev"],
        list[i]["coOperativeDwRev"],
        list[i]["trainingCatRev"],
        list[i]["seasonDwRev"],
        list[i]["fieldStaffRev"],
        list[i]["areaCaptureMode"],
        list[i]["interestRateApplicable"],
        list[i]["rateOfInterest"],
        list[i]["effectiveFrom"],
        list[i]["isApplicableForExisting"],
        list[i]["previousInterestRate"],
        list[i]["qrScan"],
        list[i]["geoFenceFlag"],
        list[i]["geoFenceRadius"],
        list[i]["buyerDwRev"],
        list[i]["catalogDwRev"],
        list[i]["parentID"],
        list[i]["branchID"],
        list[i]["isGeneric"],
        list[i]["supplierDwRev"],
        list[i]["researchStationDwRev"],
        list[i]["displayDtFmt"],
        list[i]["batchAvailable"],
        list[i]["isGrampnchayat"],
        list[i]["areaUnitType"],
        list[i]["currency"],
        list[i]["farmerfarmRev"],
        list[i]["farmerfarmcropRev"],
        list[i]["warehouseId"],
        list[i]["farmerStockBalRev"],
        list[i]["latestSeasonRevNo"],
        list[i]["latestCatalogRevNo"],
        list[i]["latestLocationRevNo"],
        list[i]["latestCooperativeRevNo"],
        list[i]["latestProcproductRevNo"],
        list[i]["latestFarmerRevNo"],
        list[i]["latestFarmRevNo"],
        list[i]["latestFarmCropRevNo"],
        list[i]["dynamicDwRev"],
        list[i]["isBuyer"],
        list[i]["distributionPhoto"],
        //list[i]["latestwsRevNo"],
        list[i]["digitalSign"],
        list[i]["cropCalandar"],
        list[i]["eventDwRev"],
        list[i]["seasonProdFlag"],
        list[i]["followUpRevNo"],
        list[i]["agntPrefxCod"],
        list[i]["procBatchNo"],
        list[i]["curIdSeqAgg"],
        list[i]["resIdSeqAgg"],
        list[i]["curIdLimitAgg"],
      );
      agents.add(user);
    }
    return agents;
  }

  Future<int> UpdateTableValue(String TableName, String ColumnName,
      String SetValue, String WhereColumn, String Wherevalue) async {
    var dbClient = await db;
    int count = await dbClient.rawUpdate(
        'UPDATE ' +
            TableName +
            ' SET ' +
            ColumnName +
            ' = ? Where ' +
            WhereColumn +
            ' = ? ',
        [SetValue, Wherevalue]);
    return count;
  }

  Future<int> UpdateTableRecord(String TableName, String columnsqry,
      String WhereColumn, String Wherevalue) async {
    var dbClient = await db;
    int count = await dbClient.rawUpdate(
        'UPDATE ' +
            TableName +
            ' SET ' +
            columnsqry +
            'Where ' +
            WhereColumn +
            ' = ? ',
        [Wherevalue]);
    return count;
  }

  Future<int> DeleteTableRecord(
      String TableName, String WhereColumn, String Wherevalue) async {
    var dbClient = await db;
    int count = await dbClient.rawUpdate(
        'DELETE FROM ' + TableName + ' Where ' + WhereColumn + ' = ? ',
        [Wherevalue]);
    return count;
  }

  Future<int> RawUpdate(String Query) async {
    var dbClient = await db;
    int count = await dbClient.rawUpdate(Query);
    return count;
  }

  Future<List<Map>> RawQuery(String Query) async {
    var dbClient = await db;
    List<Map> list = await dbClient.rawQuery(Query);
    return list;
  }

  Future<int> RawInsert(String Query) async {
    var dbClient = await db;
    int count = await dbClient.rawInsert(Query);
    return count;
  }

  Future<int> DeleteTable(String TableName) async {
    var dbClient = await db;
    int count = await dbClient.rawDelete('DELETE FROM ' + TableName);
    return count;
  }

  Future<int> SaveSamitee(String samCode) async {
    var dbClient = await db;
    int res = await dbClient.rawInsert(
        'INSERT INTO "main"."agentSamiteeList" ("samCode") VALUES (?)',
        [samCode]);
    return res;
  }

  Future<int> SaveCountry(String countryCode, String countryName) async {
    var dbClient = await db;
    int res = await dbClient.rawInsert(
        'INSERT INTO "main"."countryList" ("countryCode", "countryName") VALUES (?, ?)',
        [countryCode, countryName]);
    return res;
  }

  Future<int> SaveState(
      String stateCode, String stateName, String countryCode) async {
    var dbClient = await db;
    int res = await dbClient.rawInsert(
        'INSERT INTO "main"."stateList" ("stateCode", "stateName", "countryCode") VALUES (?, ?, ?)',
        [stateCode, stateName, countryCode]);
    return res;
  }

  Future<int> SaveDistrict(
      String districtCode, String districtName, String stateCode) async {
    var dbClient = await db;
    int res = await dbClient.rawInsert(
        'INSERT INTO "main"."districtList" ("districtCode", "districtName", "stateCode") VALUES (?, ?, ?)',
        [districtCode, districtName, stateCode]);
    return res;
  }

  Future<int> SaveCity(
      String cityCode, String cityName, String districtCode) async {
    var dbClient = await db;
    int res = await dbClient.rawInsert(
        'INSERT INTO "main"."cityList" ("cityCode", "cityName", "districtCode") VALUES (?, ?, ?)',
        [cityCode, cityName, districtCode]);
    return res;
  }

  Future<int> SaveVillage(
      String villCode, String villName, String gpCode) async {
    var dbClient = await db;
    int res = await dbClient.rawInsert(
        'INSERT INTO "main"."villageList" ("villCode", "villName", "gpCode") VALUES (?, ?, ?)',
        [villCode, villName, gpCode]);
    return res;
  }

  Future<int> SaveSeason(
      String seasonId, String seasonName, String year) async {
    var dbClient = await db;
    int res = await dbClient.rawInsert(
        'INSERT INTO "main"."seasonYear" ("seasonId", "seasonName", "year") VALUES (?, ?, ?)',
        [seasonId, seasonName, year]);
    return res;
  }

  Future<int> SavegramPanchayat(
      String gpCode, String gpName, String cityCode) async {
    var dbClient = await db;
    int res = await dbClient.rawInsert(
        'INSERT INTO "main"."gramPanchayat" ("gpCode", "gpName", "cityCode") VALUES (?, ?, ?)',
        [gpCode, gpName, cityCode]);
    return res;
  }

  Future<int> SaveSamiteeList(
      String samCode, String samName, String utzStatus) async {
    var dbClient = await db;
    int res = await dbClient.rawInsert(
        'INSERT INTO "main"."samitee" ("samCode", "samName", "utzStatus") VALUES (?, ?, ?)',
        [samCode, samName, utzStatus]);
    return res;
  }

  Future<int> SavecoOperatives(String coCode, String coName, String copTyp,
      String copInchge, String address1) async {
    var dbClient = await db;
    int res = await dbClient.rawInsert(
        'INSERT INTO "main"."coOperative" ( "coCode", "coName", "coType","copInchge","address1") VALUES (?,?,?,?,?)',
        [coCode, coName, copTyp, copInchge, address1]);
    return res;
  }

  // Future<int> SavewareHouseStocks(TrainingtopicesInsert trTopic) async {
  //   var dbClient = await db;
  //   int res = await dbClient.insert("plannerTopic", trTopic.toMap());
  //   return res;
  // }

  Future<int> SavewareHouseStocks(
      String categoryCode,
      String productCode,
      String stock,
      String batchNo,
      String saeson,
      String wareHouseName,
      String wareHouseCode,
      String subCategoryCode) async {
    var dbClient = await db;

    int res = await dbClient.rawInsert(
        'INSERT INTO "main"."wareHouseStocks" ("wareHouseName", "wareHouseCode", "categoryCode", "subCategoryCode", "productCode", "stock", "bactNo", "season") VALUES ( ?, ?, ?, ?, ?, ?, ?, ?)',
        [
          wareHouseName,
          wareHouseCode,
          categoryCode,
          subCategoryCode,
          productCode,
          stock,
          batchNo,
          saeson
        ]);
    return res;
  }

  Future<int> SaveProducts(
      String unit,
      String productCode,
      String subCategoryName,
      String subCategoryCode,
      String categoryCode,
      String categoryName,
      String productName,
      String price) async {
    var dbClient = await db;

    int res = await dbClient.rawInsert(
        'INSERT INTO "main"."products" ("unit", "productCode", "subCategoryName", "subCategoryCode", "categoryCode", "categoryName", "productName", "price") VALUES ( ?, ?, ?, ?, ?, ?, ?, ?)',
        [
          unit,
          productCode,
          subCategoryName,
          subCategoryCode,
          categoryCode,
          categoryName,
          productName,
          price
        ]);
    return res;
  }

  Future<int> SaveProcurementProducts(String code, String name, String type,
      String unit, String msp, String mspPercent) async {
    var dbClient = await db;

    int res = await dbClient.rawInsert(
        'INSERT INTO "main"."procurementProducts" ("code", "name", "type", "unit", "msp", "mspPercent") VALUES (?,?,?,?,?,?)',
        [code, name, type, unit, msp, mspPercent]);
    return res;
  }

  // Future<int> saveSowingData(SowinginsertModel sowinginsertModel) async {
  //   int res;
  //   var dbClient = await db;
  //
  //   res = await dbClient.insert("farmCrop", sowinginsertModel.toMap());
  //   return res;
  // }
  // Future<List<SowinginsertModel>> getSowing(String custTxnsRefId) async {
  //   var dbClient = await db;
  //   List<Map> list = await dbClient.rawQuery('SELECT * FROM farmCrop');
  //   List<SowinginsertModel> sowingList = new [];
  //   for (int i = 0; i < list.length; i++) {
  //
  //     var sowingmodel = new SowinginsertModel(
  //         list[i]["cropCategory"],
  //         list[i]["cropSeason"],
  //         list[i]["farmcrpIDT"],
  //         list[i]["cropCode"],
  //         list[i]["farmerId"],
  //         list[i]["farmcodeRef"],
  //         list[i]["cropArea"],
  //         list[i]["production"],
  //         list[i]["cropVariety"],
  //         list[i]["seedSource"],
  //         list[i]["_ID"],
  //         list[i]["stableLengthMain"],
  //         list[i]["seedusedMain"],
  //         list[i]["seedcostMain"],
  //         list[i]["interCropType"],
  //         list[i]["interCropAcr"],
  //         list[i]["interCropHarvest"],
  //         list[i]["interCropGrossIncome"],
  //         list[i]["cropType"],
  //         list[i]["seedCost"],
  //         list[i]["seedTreatment"],
  //         list[i]["otherSeedTreatment"],
  //         list[i]["dateOfSown"],
  //         list[i]["riskBufferZone"],
  //         list[i]["riskAssesment"],
  //         list[i]["estHarvestDt"],
  //         list[i]["cultivationType"],
  //         list[i]["cultivationArea"],
  //         list[i]["cropStatus"],
  //         list[i]["cropEditStatus"]);
  //     sowingList.add(sowingmodel);
  //   }
  //   return sowingList;
  // }

  Future<int> saveFarmCrop(
    String cropCategory,
    String cropSeason,
    String farmcrpIDT,
    String cropCode,
    String farmerId,
    String farmcodeRef,
    String cropArea,
    String production,
    String cropVariety,
    String seedSource,
    String stableLengthMain,
    String seedusedMain,
    String seedcostMain,
    String interCropType,
    String interCropAcr,
    String interCropHarvest,
    String interCropGrossIncome,
    String cropType,
    String seedCost,
    String seedTreatment,
    String otherSeedTreatment,
    String dateOfSown,
    String riskBufferZone,
    String riskAssesment,
    String estHarvestDt,
    String cultivationType,
    String cultivationArea,
    String cropStatus,
    String cropEditStatus,
  ) async {
    var dbClient = await db;
    int res = await dbClient.rawInsert(
        'INSERT INTO "main"."farmCrop" ("cropCategory", "cropSeason", "farmcrpIDT", "cropCode", "farmerId","farmcodeRef", "cropArea", "production", "cropVariety", "seedSource",'
        '"stableLengthMain","seedusedMain","seedcostMain","interCropType","interCropAcr","interCropHarvest","interCropGrossIncome",'
        '"cropType","seedCost","seedTreatment","otherSeedTreatment","dateOfSown","riskBufferZone","riskAssesment","estHarvestDt",'
        '"cultivationType","cultivationArea","cropStatus","cropEditStatus") VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)',
        [
          cropCategory,
          cropSeason,
          farmcrpIDT,
          cropCode,
          farmerId,
          farmcodeRef,
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
          cultivationArea,
          cropStatus,
          cropEditStatus,
        ]);
    return res;
  }

  Future<int> saveSowing(
    String cropCategory,
    String cropSeason,
    String farmcrpIDT,
    String cropCode,
    String farmerId,
    String farmcodeRef,
    String cropArea,
    String production,
    String cropVariety,
    String seedSource,
    String stableLengthMain,
    String seedusedMain,
    String seedcostMain,
    String interCropType,
    String interCropAcr,
    String interCropHarvest,
    String interCropGrossIncome,
    String cropType,
    String seedCost,
    String seedTreatment,
    String otherSeedTreatment,
    String dateOfSown,
    String riskBufferZone,
    String riskAssesment,
    String estHarvestDt,
    String cultivationType,
    String cultivationArea,
    String cropStatus,
    String cropEditStatus,
  ) async {
    var dbClient = await db;
    int res = await dbClient.rawInsert(
        'INSERT INTO "main"."farmCrop" ("cropCategory", "cropSeason", "farmcrpIDT", "cropCode", "farmerId","farmcodeRef", "cropArea", "production", "cropVariety", "seedSource",'
        '"stableLengthMain","seedusedMain","seedcostMain","interCropType","interCropAcr","interCropHarvest","interCropGrossIncome",'
        '"cropType","seedCost","seedTreatment","otherSeedTreatment","dateOfSown","riskBufferZone","riskAssesment","estHarvestDt",'
        '"cultivationType","cultivationArea","cropStatus","cropEditStatus") VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)',
        [
          cropCategory,
          cropSeason,
          farmcrpIDT,
          cropCode,
          farmerId,
          farmcodeRef,
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
          cultivationArea,
          cropStatus,
          cropEditStatus,
        ]);
    return res;
  }

  SaveInspection(
      String inspectionType,
      String inspectionDate,
      String landId,
      String purpose,
      String ddBankName,
      String ddNum,
      String ddDate,
      String ddAmt,
      String remarks,
      String voice,
      String timeOfInspection,
      String survival,
      String averageHeight,
      String averageGirth,
      String currStatusOfGrowth,
      String activitiesCarriedOut,
      String noOfPlantsReplanted,
      String dateOfGapPlanting,
      String interPloughingWith,
      String cropProtect,
      String typeOfManure,
      String otherTypeOfManure,
      String manureQtyApplied,
      String typeOfFertilizer,
      String otherTypeOfFertilizer,
      String fertilizerQtyApplied,
      String pestProbNoticed,
      String nameOfPest,
      String otherNameOfPest,
      String pestSymptom,
      String otherPestSymptom,
      String pestInfestationAboveETL,
      String nameOfPestRecomended,
      String recomendPestQtyApplied,
      String otherTypeOfPestRecc,
      String dateOfPestApplication,
      String pestProblemSolved,
      String diseaseProbNoticed,
      String nameOfDisease,
      String otherNameOfDisease,
      String diseaseSymptom,
      String otherDiseaseSymptom,
      String diseaseInfestationAboveETL,
      String fungicideRecomended,
      String fungicideQtyApplied,
      String otherTypeOfFungRecc,
      String dateOfFungicideApplication,
      String diseaseProbSolved,
      String openionAbtService,
      String isIntercrop,
      String nameOfCrop,
      String yieldObtained,
      String expenditureIncured,
      String incomeGenerated,
      String netProfitLoss,
      String FSCFMStandard,
      String FCCCOCStandard,
      String FSCGroupStandard,
      String mannure,
      String bioFertilizer,
      String bioPest,
      String mannureQty,
      String bioFertilizerQty,
      String bioPestQty,
      String cropRot,
      String temperature,
      String humidity,
      String windSpeed,
      String rain,
      String season,
      String landPrepareComp,
      String noChemicalSpray,
      String noMono,
      String singleSpray,
      String noRepetition,
      String noNitrogen,
      String lastYear,
      String currentYear,
      String weeding,
      String picking,
      String trainingAttended,
      String anyAccidentFMU,
      String recpId,
      String age,
      String chemicalName,
      String monOfFertApplied,
      String noOfRootTrainer,
      String questMain,
      String questSub,
      String isSold,
      String longitude,
      String latitude,
      String isSynched,
      String cropID) async {
    var dbClient = await db;

    int res = await dbClient.rawInsert(
        'INSERT INTO "main"."periodicInspection" ("inspectionType","inspectionDate","landId","purpose","ddBankName","ddNum","ddDate","ddAmt","remarks","voice","timeOfInspection","survival","averageHeight","averageGirth","currStatusOfGrowth","activitiesCarriedOut","noOfPlantsReplanted","dateOfGapPlanting","interPloughingWith","cropProtect","typeOfManure","otherTypeOfManure","manureQtyApplied","typeOfFertilizer","otherTypeOfFertilizer","fertilizerQtyApplied","pestProbNoticed","nameOfPest","otherNameOfPest","pestSymptom","otherPestSymptom","pestInfestationAboveETL","nameOfPestRecomended","recomendPestQtyApplied","otherTypeOfPestRecc","dateOfPestApplication","pestProblemSolved","diseaseProbNoticed","nameOfDisease","otherNameOfDisease","diseaseSymptom","otherDiseaseSymptom","diseaseInfestationAboveETL","fungicideRecomended","fungicideQtyApplied","otherTypeOfFungRecc","dateOfFungicideApplication","diseaseProbSolved","openionAbtService","isIntercrop","nameOfCrop","yieldObtained","expenditureIncured","incomeGenerated","netProfitLoss","FSCFMStandard","FCCCOCStandard","FSCGroupStandard","mannure","bioFertilizer","bioPest","mannureQty","bioFertilizerQty","bioPestQty","cropRot","temperature","humidity","windSpeed","rain","season","landPrepareComp","noChemicalSpray","noMono","singleSpray","noRepetition","noNitrogen","lastYear","currentYear","weeding","picking","trainingAttended","anyAccidentFMU","recpId","age","chemicalName","monOfFertApplied","noOfRootTrainer","questMain","questSub","isSold","longitude","latitude","isSynched","cropID") VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)',
        [
          inspectionType,
          inspectionDate,
          landId,
          purpose,
          ddBankName,
          ddNum,
          ddDate,
          ddAmt,
          remarks,
          voice,
          timeOfInspection,
          survival,
          averageHeight,
          averageGirth,
          currStatusOfGrowth,
          activitiesCarriedOut,
          noOfPlantsReplanted,
          dateOfGapPlanting,
          interPloughingWith,
          cropProtect,
          typeOfManure,
          otherTypeOfManure,
          manureQtyApplied,
          typeOfFertilizer,
          otherTypeOfFertilizer,
          fertilizerQtyApplied,
          pestProbNoticed,
          nameOfPest,
          otherNameOfPest,
          pestSymptom,
          otherPestSymptom,
          pestInfestationAboveETL,
          nameOfPestRecomended,
          recomendPestQtyApplied,
          otherTypeOfPestRecc,
          dateOfPestApplication,
          pestProblemSolved,
          diseaseProbNoticed,
          nameOfDisease,
          otherNameOfDisease,
          diseaseSymptom,
          otherDiseaseSymptom,
          diseaseInfestationAboveETL,
          fungicideRecomended,
          fungicideQtyApplied,
          otherTypeOfFungRecc,
          dateOfFungicideApplication,
          diseaseProbSolved,
          openionAbtService,
          isIntercrop,
          nameOfCrop,
          yieldObtained,
          expenditureIncured,
          incomeGenerated,
          netProfitLoss,
          FSCFMStandard,
          FCCCOCStandard,
          FSCGroupStandard,
          mannure,
          bioFertilizer,
          bioPest,
          mannureQty,
          bioFertilizerQty,
          bioPestQty,
          cropRot,
          temperature,
          humidity,
          windSpeed,
          rain,
          season,
          landPrepareComp,
          noChemicalSpray,
          noMono,
          singleSpray,
          noRepetition,
          noNitrogen,
          lastYear,
          currentYear,
          weeding,
          picking,
          trainingAttended,
          anyAccidentFMU,
          recpId,
          age,
          chemicalName,
          monOfFertApplied,
          noOfRootTrainer,
          questMain,
          questSub,
          isSold,
          longitude,
          latitude,
          isSynched,
          cropID
        ]);
  }

  Future<int> SaveFarmInspection(
    String farmInspectionDateValue,
    String farmerNameId,
    String farmNameId,
    String cropNameId,
    String audio,
    String farmerOpinion,
    String remarks,
    String isIPMFollowedId,
    String pestNoticedId,
    String pestNameId,
    String pestIsInfAbvETLId,
    String diseaseNoticedId,
    String diseaseNameId,
    String diseaseIsInfAbvETLId,
    String cropStageId,
    String statusOfGrowthId,
    String actCarriedAfterPrevVisitId,
    String chemicalNameId,
    String actvIngrdtId,
    String chemicalAppDate,
    String waitingPeriodId,
    String selfHarvDate,
    String numberOfPlntsReplanted,
    String dateOfGapPlntng,
    String interPloughingId,
    String interCultActIfAnyId,
    String cropRotationId,
    String weatherConditionId,
    String temperature,
    String rain,
    String humidity,
    String windSpeed,
    String bioFertilizerTypeId,
    String orgManureId,
    String lattitude,
    String longitude,
    String isSynched,
    String recpId,
    String timeOfInspection,
  ) async {
    var dbClient = await db;

    int res = await dbClient.rawInsert(
        'INSERT INTO "main"."periodicInspection" ("inspectionDate","inspectionType","landId","nameOfCrop","voice","openionAbtService","remarks","purpose","pestProbNoticed","nameOfPest","pestInfestationAboveETL","diseaseProbNoticed","nameOfDisease","diseaseInfestationAboveETL", "cropID","currStatusOfGrowth","activitiesCarriedOut","chemicalName","fungicideRecomended","dateOfFungicideApplication","yieldObtained","ddDate","noOfPlantsReplanted","dateOfGapPlanting","interPloughingWith","isIntercrop","cropRot","season","temperature","rain","humidity","windSpeed","bioFertilizer","mannure","latitude","longitude","isSynched","recpId","timeOfInspection","ddBankName","ddNum","ddAmt","survival","averageHeight","averageGirth","cropProtect","typeOfManure","otherTypeOfManure","manureQtyApplied","typeOfFertilizer","otherTypeOfFertilizer","fertilizerQtyApplied","otherNameOfPest","pestSymptom","otherPestSymptom","nameOfPestRecomended","recomendPestQtyApplied","otherTypeOfPestRecc","dateOfPestApplication","pestProblemSolved","nameOfDisease","otherNameOfDisease","diseaseSymptom","fungicideQtyApplied","otherTypeOfFungRecc","diseaseProbSolved","expenditureIncured","incomeGenerated","netProfitLoss","FSCFMStandard","FCCCOCStandard","FSCGroupStandard","bioPest","mannureQty","bioFertilizerQty","bioPestQty","landPrepareComp","noChemicalSpray","noMono","singleSpray","noRepetition","noNitrogen","lastYear","currentYear","weeding","picking","trainingAttended","anyAccidentFMU","age","monOfFertApplied","noOfRootTrainer","questMain","questSub","isSold") VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)',
        [
          farmInspectionDateValue,
          farmerNameId,
          farmNameId,
          cropNameId,
          audio,
          farmerOpinion,
          remarks,
          isIPMFollowedId,
          pestNoticedId,
          pestNameId,
          pestIsInfAbvETLId,
          diseaseNoticedId,
          diseaseNameId,
          diseaseIsInfAbvETLId,
          cropStageId,
          statusOfGrowthId,
          actCarriedAfterPrevVisitId,
          chemicalNameId,
          actvIngrdtId,
          chemicalAppDate,
          waitingPeriodId,
          selfHarvDate,
          numberOfPlntsReplanted,
          dateOfGapPlntng,
          interPloughingId,
          interCultActIfAnyId,
          cropRotationId,
          weatherConditionId,
          temperature,
          rain,
          humidity,
          windSpeed,
          bioFertilizerTypeId,
          orgManureId,
          lattitude,
          longitude,
          isSynched,
          recpId,
          timeOfInspection
        ]);
    return res;
  }

  Future<int> saveInputReturn(inputReturnsModel inputReturns) async {
    int res;
    var dbClient = await db;
    res = await dbClient.rawInsert(
        'INSERT INTO "main"."productReturn" ("season","farmerId", "isSynched", "returnDate", "returnId","village", "samCode", "photo1", "photo2") VALUES ('
                '\'' +
            inputReturns.season +
            '\',' +
            '\'' +
            inputReturns.farmerId +
            '\',' +
            '\'' +
            "0" +
            '\',' +
            '\'' +
            inputReturns.returnDate +
            '\',' +
            '\'' +
            inputReturns.returnId +
            '\',' +
            '\'' +
            inputReturns.village +
            '\',' +
            '\'' +
            inputReturns.samCode +
            '\',' +
            '\'' +
            inputReturns.photo1 +
            '\',' +
            /*'\''+inputReturns.products + '\','+
    '\''+inputReturns.productCode + '\','+
    '\''+inputReturns.quantity + '\','+
    '\''+inputReturns.pricePerUnit + '\','+
    '\''+inputReturns.batchNo + '\','+
    '\''+inputReturns.subTotal + '\','+*/
            '\'' +
            inputReturns.photo2 +
            '\''
                ')');

    return res;
  }

  Future<List<inpRetDetModel>> getinpRetDet() async {
    var dbClient = await db;
    List<Map> list = await dbClient.rawQuery('SELECT * FROM productRetDetail');
    print(list.toString());
    List<inpRetDetModel> getinpRetDet = [];
    for (int i = 0; i < list.length; i++) {
//print("ID "+ list[i]["ID"]);
      var getinpdet = new inpRetDetModel(
        list[i]["productCode"],
        list[i]["quantity"],
        list[i]["pricePerUnit"],
        list[i]["subTotal"],
        list[i]["batchNo"],
      );
      getinpRetDet.add(getinpdet);
    }
    return getinpRetDet;
  }

  Future<int> saveInpRetDet(inpRetDetModel inpRetDet) async {
    int res;
    var dbClient = await db;
    res = await dbClient.rawInsert(
        'INSERT INTO "main"."cropHarvestDetails" ("productCode", "quantity", "pricePerUnit", "subTotal", "batchNo") VALUES ('
                '\'' +
            inpRetDet.productCode +
            '\',' +
            '\'' +
            inpRetDet.quantity +
            '\',' +
            '\'' +
            inpRetDet.pricePerUnit +
            '\',' +
            '\'' +
            inpRetDet.subTotal +
            '\',' +
            '\'' +
            inpRetDet.batchNo +
            '\',' +
            ')');
    return res;
  }

  Future<List<inputReturnsModel>> getinputReturns() async {
    var dbClient = await db;
    List<Map> list = await dbClient.rawQuery('SELECT * FROM productReturn');
    print(list.toString());
    List<inputReturnsModel> getInputlist = [];
    for (int i = 0; i < list.length; i++) {
//print("ID "+ list[i]["ID"]);
      var getinputval = new inputReturnsModel(
        list[i]["season"],
        list[i]["farmerId"],
        list[i]["isSynched"],
        list[i]["returnDate"],
        list[i]["returnId"],
        list[i]["village"],
        list[i]["samCode"],
        list[i]["photo1"],
        list[i]["photo2"],
      );
      getInputlist.add(getinputval);
    }
    return getInputlist;
  }

  Future<int> SaveProductTransfer(
      String recNo,
      String mtntId,
      String totBags,
      String totGrossWeight,
      String totTareWeight,
      String totNetWeight,
      String isSynched,
      String mtntDate,
      String wareHouseCode,
      String ptDate,
      String truckId,
      String driverId,
      String dvrMob,
      String coCode,
      String season,
      String longitude,
      String latitude,
      String labourCost,
      String transportCost,
      String receiverType,
      String totalAmount,
      String invoiceNo,
      String mtntTxnNo) async {
    var dbClient = await db;
    int res = await dbClient.rawInsert(
        'INSERT INTO "main"."mtnt" ("recNo","mtntId","totBags","totGrossWeight","totTareWeight","totNetWeight","isSynched","mtntDate","wareHouseCode","truckId","driverId","coCode","season","longitude","latitude","labourCost","transportCost","receiverType","totalAmount","invoiceNo","mtntTxnNo","ptDate","dvrMob") VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)',
        [
          recNo,
          mtntId,
          totBags,
          totGrossWeight,
          totTareWeight,
          totNetWeight,
          isSynched,
          mtntDate,
          wareHouseCode,
          truckId,
          driverId,
          coCode,
          season,
          longitude,
          latitude,
          labourCost,
          transportCost,
          receiverType,
          totalAmount,
          invoiceNo,
          mtntTxnNo,
          ptDate,
          dvrMob,
        ]);
    return res;
  }

  Future<int> SaveProductTransferDetail(
    String productCode,
    String mtntId,
    String noOfBags,
    String grossWeight,
    String mode,
    String villageCode,
    String tareWeight,
    String netWeight,
    String gCode,
    String unitSelCost,
    String UOM,
    String totSelCost,
    String batchNo,
    String farmerId,
  ) async {
    var dbClient = await db;
    int res = await dbClient.rawInsert(
        'INSERT INTO "main"."mtntDetails" ("productCode","mtntId","noOfBags","grossWeight","mode","villageCode","tareWeight","netWeight","gCode","unitSelCost","UOM","totSelCost","batchNo","farmerId") VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?)',
        [
          productCode,
          mtntId,
          noOfBags,
          grossWeight,
          mode,
          villageCode,
          tareWeight,
          netWeight,
          gCode,
          unitSelCost,
          UOM,
          totSelCost,
          batchNo,
          farmerId,
        ]);
    return res;
  }

  Future<int> SavePayment(
    String recNo,
    String cityCode,
    String villageCode,
    String farmerId,
    String seasonCode,
    String pageNo,
    String payDate,
    String pType,
    String pAmount,
    String remarks,
    String longitude,
    String latitude,
    String isSynched,
  ) async {
    var dbClient = await db;
    int res = await dbClient.rawInsert(
        'INSERT INTO "main"."paymentDetails" ("recNo","cityCode","villageCode","farmerId","seasonCode","pageNo","payDate","pType","pAmount","remarks","longitude","latitude","isSynched") VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?)',
        [
          recNo,
          cityCode,
          villageCode,
          farmerId,
          seasonCode,
          pageNo,
          payDate,
          pType,
          pAmount,
          remarks,
          longitude,
          latitude,
          isSynched,
        ]);
    return res;
  }

  Future<int> saveDistributionData(
      DistributionInsertvalue distributionInsertvalue) async {
    int res;
    var dbClient = await db;

    res = await dbClient.insert(
        "productDistribution", distributionInsertvalue.toMap());
    return res;
  }

  Future<int> saveDistributionproductData(
      DistributionProductDetail distributionProductDetail) async {
    int res;
    var dbClient = await db;

    res = await dbClient.insert(
        "productDistDetail", distributionProductDetail.toMap());
    return res;
  }

  Future<List<DistributionProductDetail>> getDistribitionproduct(
      String custTxnsRefId) async {
    var dbClient = await db;
    List<Map> list = await dbClient.rawQuery(
        'SELECT * FROM productDistDetail where distributionId =\'' +
            custTxnsRefId +
            '\'');
    List<DistributionProductDetail> distributionproductList = [];
    for (int i = 0; i < list.length; i++) {
      var distribitionProductModel = new DistributionProductDetail(
        list[i]["price"],
        list[i]["subtotal"],
        list[i]["quantity"],
        list[i]["productid"],
        list[i]["distributionId"],
        list[i]["sellPrice"],
        list[i]["bactNo"],
      );
      distributionproductList.add(distribitionProductModel);
    }
    return distributionproductList;
  }

  Future<List<DistributionInsertvalue>> getDistribition(
      String custTxnsRefId) async {
    var dbClient = await db;
    List<Map> list = await dbClient.rawQuery(
        'SELECT * FROM productDistribution where recpNo=\'' +
            custTxnsRefId +
            '\'');
    List<DistributionInsertvalue> DistributionList = [];
    for (int i = 0; i < list.length; i++) {
      var distribitionModel = new DistributionInsertvalue(
          list[i]["pmtAmt"],
          list[i]["samCode"],
          list[i]["season"],
          list[i]["city"],
          list[i]["wareHouseCode"],
          list[i]["distributionId"],
          list[i]["recpNo"],
          list[i]["farmerId"],
          list[i]["village"],
          list[i]["farmerName"],
          list[i]["distributionDate"],
          list[i]["isSynched"],
          list[i]["isReg"],
          list[i]["mobileNo"],
          list[i]["freeDistribution"],
          list[i]["tax"],
          list[i]["paymentMode"],
          list[i]["farmerCode"],
          list[i]["latitude"],
          list[i]["longitude"],
          list[i]["photo1"],
          list[i]["photo2"]);
      DistributionList.add(distribitionModel);
    }
    return DistributionList;
  }

  // Future<int> saveCropHarvest(cropHarvestModel cropHarvest) async {
  //   int res;
  //   var dbClient = await db;
  //   res = await dbClient.rawInsert(
  //       'INSERT INTO "main"."cropHarvest" ("season", "recNo", "harvestDate", "farmerId", "farmId", "total", "isSynched", "packOther", "storOther", "storage", "packed", "latitude", "longitude") VALUES ('
  //           '\'' + cropHarvest.season + '\',' +
  //           '\'' + cropHarvest.recNo + '\',' +
  //           '\'' + cropHarvest.harvestDate + '\',' +
  //           '\'' + cropHarvest.farmerId + '\',' +
  //           '\'' + cropHarvest.farmId + '\',' +
  //           '\'' + cropHarvest.total + '\',' +
  //           '\'' + "0" + '\',' +
  //           '\'' + cropHarvest.packOther + '\',' +
  //           '\''+cropHarvest.storOther + '\','+
  //           '\''+cropHarvest.storage + '\','+
  //           '\''+cropHarvest.packed + '\','+
  //           '\''+cropHarvest.latitude + '\','+
  //           '\''+cropHarvest.longitude + '\''+
  //           ')');
  //   return res;
  // }
  // Future<int> saveCropHardet(cropHarDetModel cropHardet) async {
  //   int res;
  //   var dbClient = await db;
  //   res = await dbClient.rawInsert(
  //       'INSERT INTO "main"."cropHarvestDetails" ("cropType", "cropId", "cropVariety", "cropGrade", "quantity", "price", "subTotal") VALUES ('
  //           '\'' + cropHardet.cropType + '\',' +
  //           '\'' + cropHardet.cropId + '\',' +
  //           '\'' + cropHardet.cropVariety + '\',' +
  //           '\'' + cropHardet.cropGrade + '\',' +
  //           '\'' + cropHardet.quantity + '\',' +
  //           '\'' + cropHardet.price + '\',' +
  //           '\'' + cropHardet.subTotal + '\'' +
  //           ')');
  //   return res;
  // }
  // Future<List<cropHarvestModel>> getcropHarvest() async {
  //   var dbClient = await db;
  //   List<Map> list = await dbClient.rawQuery('SELECT * FROM cropHarvest');
  //   print(list.toString());
  //   List<cropHarvestModel> getCroplist = new [];
  //   for (int i = 0; i < list.length; i++) {
  //
  //
  //     var getcropval = new cropHarvestModel(
  //       list[i]["season"],
  //       list[i]["recNo"],
  //       list[i]["harvestDate"],
  //       list[i]["farmerId"],
  //       list[i]["farmId"],
  //       list[i]["total"],
  //       list[i]["packOther"],
  //       list[i]["storOther"],
  //       list[i]["storage"],
  //       list[i]["packed"],
  //       list[i]["latitude"],
  //       list[i]["longitude"],
  //       list[i]["isSynched"],
  //     );
  //     getCroplist.add(getcropval);
  //   }
  //   return getCroplist;
  // }
//   Future<List<cropHarDetModel>> getcropHardet() async {
//     var dbClient = await db;
//     List<Map> list = await dbClient.rawQuery('SELECT * FROM cropHarvestDetails');
//     print(list.toString());
//     List<cropHarDetModel> getcropHardet = new [];
//     for (int i = 0; i < list.length; i++) {
//
// //print("ID "+ list[i]["ID"]);
//       var getcropdet = new cropHarDetModel(
//         list[i]["cropType"],
//         list[i]["cropId"],
//         list[i]["cropVariety"],
//         list[i]["cropGrade"],
//         list[i]["quantity"],
//         list[i]["price"],
//         list[i]["subTotal"],
//       );
//       getcropHardet.add(getcropdet);
//     }
//     return getcropHardet;
//   }

  Future<int> SaveSensitizing(
    String recNo,
    String date,
    String season,
    String village,
    String learnGroup,
    String noofFarmers,
    String remarks,
    String longitude,
    String latitude,
    String isSynched,
  ) async {
    var dbClient = await db;
    int res = await dbClient.rawInsert(
        'INSERT INTO "main"."sensitizing" ("recNo","date","season","village","learnGroup","noofFarmers","remarks","longitude","latitude","isSynched") VALUES (?,?,?,?,?,?,?,?,?,?)',
        [
          recNo,
          date,
          season,
          village,
          learnGroup,
          noofFarmers,
          remarks,
          longitude,
          latitude,
          isSynched,
        ]);
    return res;
  }

  Future<int> SaveSensitizingImage(
    String image,
    String refId,
    String time,
    String latitude,
    String longitude,
  ) async {
    var dbClient = await db;
    int res = await dbClient.rawInsert(
        'INSERT INTO "main"."image_Sensit_List" ("image","refId","time","latitude","longitude") VALUES (?,?,?,?,?)',
        [
          image,
          refId,
          time,
          latitude,
          longitude,
        ]);
    return res;
  }

  Future<int> SaveTrainingImage(
    String image,
    String refId,
    String time,
    String latitude,
    String longitude,
  ) async {
    var dbClient = await db;
    int res = await dbClient.rawInsert(
        'INSERT INTO "main"."image_Training_List" ("image","refId","time","latitude","longitude") VALUES (?,?,?,?,?)',
        [
          image,
          refId,
          time,
          latitude,
          longitude,
        ]);
    return res;
  }

  Future<int> saveCostcultivation(
      CostofcultivationModel costofcultivation) async {
    var dbClient = await db;
    int res =
        await dbClient.insert("costOfCultivation", costofcultivation.toMap());
    return res;
  }

  Future<List<CostofcultivationModel>> getcostOfCultivation(String id) async {
    var dbClient = await db;
    List<Map> list = await dbClient.rawQuery('SELECT * FROM costOfCultivation');
    List<CostofcultivationModel> costoflist = [];
    for (int i = 0; i < list.length; i++) {
      var costOfCultivation = new CostofcultivationModel(
          list[i]["isSynched"],
          list[i]["farmerId"],
          list[i]["farmId"],
          list[i]["recpNo"],
          list[i]["cocDate"],
          list[i]["cocCategory"],
          list[i]["incomeFromAgriCOC"],
          list[i]["incomeFromInterCOC"],
          list[i]["incomeFromOtherCOC"],
          list[i]["landPreTotal"],
          list[i]["sowingTotal"],
          list[i]["gapfillTotal"],
          list[i]["WeedingTotal"],
          list[i]["cultureTotal"],
          list[i]["irrigationTotal"],
          list[i]["fertilizerTotal"],
          list[i]["pesticideTotal"],
          list[i]["harvestTotal"],
          list[i]["tototrExp"],
          list[i]["totalExpenses"],
          list[i]["currentSeason"],
          list[i]["manureTotal"],
          list[i]["longitude"],
          list[i]["latitude"],
          list[i]["cropId"],
          list[i]["soilPrepare"],
          list[i]["labourHire"],
          list[i]["manureUse"],
          list[i]["fertUse"],
          list[i]["soilPrepareLabour"],
          list[i]["seedBuyCostLabour"],
          list[i]["gapFillingLabour"],
          list[i]["WeedingCostsLabour"],
          list[i]["IrrigationCostsLabour"],
          list[i]["InputCostsLabour"],
          list[i]["HarvestCostLabour"],
          list[i]["totManureCostLabour"],
          list[i]["bioFertCostLabour"],
          list[i]["bioPestCostLabour"],
          list[i]["OtherCostsGin"],
          list[i]["OtherCostsFuel"],
          list[i]["pestUse"]);
      costoflist.add(costOfCultivation);
    }
    return costoflist;
  }

  Future<int> saveCropHarvest(cropHarvestModel cropHarvest) async {
    int res;
    var dbClient = await db;
    res = await dbClient.rawInsert(
        'INSERT INTO "main"."cropHarvest" ("season", "recNo", "harvestDate", "farmerId", "farmId", "total", "isSynched", "packOther", "storOther", "storage", "packed", "latitude", "longitude") VALUES ('
                '\'' +
            cropHarvest.season +
            '\',' +
            '\'' +
            cropHarvest.recNo +
            '\',' +
            '\'' +
            cropHarvest.harvestDate +
            '\',' +
            '\'' +
            cropHarvest.farmerId +
            '\',' +
            '\'' +
            cropHarvest.farmId +
            '\',' +
            '\'' +
            cropHarvest.total +
            '\',' +
            '\'' +
            "0" +
            '\',' +
            '\'' +
            cropHarvest.packOther +
            '\',' +
            '\'' +
            cropHarvest.storOther +
            '\',' +
            '\'' +
            cropHarvest.storage +
            '\',' +
            '\'' +
            cropHarvest.packed +
            '\',' +
            '\'' +
            cropHarvest.latitude +
            '\',' +
            '\'' +
            cropHarvest.longitude +
            '\'' +
            ')');
    return res;
  }

  Future<int> saveCropHardet(cropHarDetModel cropHardet) async {
    int res;
    var dbClient = await db;
    res = await dbClient.rawInsert(
        'INSERT INTO "main"."cropHarvestDetails" ("recNo","cropType", "cropId", "cropVariety", "cropGrade", "quantity", "price", "subTotal") VALUES ('
                '\'' +
            cropHardet.recNo! +
            '\',' +
            '\'' +
            cropHardet.cropType! +
            '\',' +
            '\'' +
            cropHardet.cropId! +
            '\',' +
            '\'' +
            cropHardet.cropVariety! +
            '\',' +
            '\'' +
            cropHardet.cropGrade! +
            '\',' +
            '\'' +
            cropHardet.quantity! +
            '\',' +
            '\'' +
            cropHardet.price! +
            '\',' +
            '\'' +
            cropHardet.subTotal! +
            '\'' +
            ')');
    return res;
  }

  Future<List<cropHarvestModel>> getcropHarvest() async {
    var dbClient = await db;
    List<Map> list = await dbClient.rawQuery('SELECT * FROM cropHarvest');
    print(list.toString());
    List<cropHarvestModel> getCroplist = [];
    for (int i = 0; i < list.length; i++) {
      var getcropval = new cropHarvestModel(
        list[i]["season"],
        list[i]["recNo"],
        list[i]["harvestDate"],
        list[i]["farmerId"],
        list[i]["farmId"],
        list[i]["total"],
        list[i]["packOther"],
        list[i]["storOther"],
        list[i]["storage"],
        list[i]["packed"],
        list[i]["latitude"],
        list[i]["longitude"],
        list[i]["isSynched"],
      );
      getCroplist.add(getcropval);
    }
    return getCroplist;
  }

  Future<List<cropHarDetModel>> getcropHardet() async {
    var dbClient = await db;
    List<Map> list =
        await dbClient.rawQuery('SELECT * FROM cropHarvestDetails');
    print(list.toString());
    List<cropHarDetModel> getcropHardet = [];
    for (int i = 0; i < list.length; i++) {
//print("ID "+ list[i]["ID"]);
      var getcropdet = new cropHarDetModel(
        list[i]["recNo"],
        list[i]["cropType"],
        list[i]["cropId"],
        list[i]["cropVariety"],
        list[i]["cropGrade"],
        list[i]["quantity"],
        list[i]["price"],
        list[i]["subTotal"],
      );
      getcropHardet.add(getcropdet);
    }
    return getcropHardet;
  }

  Future<int> saveTrainingTopices(TrainingtopicesInsert trTopic) async {
    var dbClient = await db;
    int res = await dbClient.insert("plannerTopic", trTopic.toMap());
    return res;
  }

  Future<int> saveSubTopices(TrainingsubtopicesInsert trSubTopic) async {
    var dbClient = await db;
    int res = await dbClient.insert("plannerSubTopic", trSubTopic.toMap());
    return res;
  }

  Future<int> saveplannerTraining(PlannertrainingInsert plannerTraining) async {
    var dbClient = await db;
    int res = await dbClient.insert("plannerTraining", plannerTraining.toMap());
    return res;
  }

  Future<int> saveplannerMaterial(PlannermaterialInsert plannerMaterial) async {
    var dbClient = await db;
    int res = await dbClient.insert("plannerMaterial", plannerMaterial.toMap());
    return res;
  }

  Future<int> saveplannerMethod(PlannermethodInsert plannerMethod) async {
    var dbClient = await db;
    int res = await dbClient.insert("plannerMethod", plannerMethod.toMap());
    return res;
  }

  Future<int> saveplannerObsevation(
      PlannerobservationInsert plannerObservation) async {
    var dbClient = await db;
    int res =
        await dbClient.insert("plannerObservation", plannerObservation.toMap());
    return res;
  }

  Future<int> saveplannerWeek(PlannerweekInsert plannerweek) async {
    var dbClient = await db;
    int res = await dbClient.insert("plannerWeek", plannerweek.toMap());
    return res;
  }

  Future<int> saveTraining(TrainingInsert training) async {
    var dbClient = await db;
    int res = await dbClient.insert("training", training.toMap());
    return res;
  }

  Future<List<TrainingInsert>> getTraining(String custTxnsRefId) async {
    var dbClient = await db;
    List<Map> list = await dbClient.rawQuery('SELECT * FROM training');
    List<TrainingInsert> TrainingList = [];
    for (int i = 0; i < list.length; i++) {
      var TrainingnModel = new TrainingInsert(
          list[i]["recNo"],
          list[i]["date"],
          list[i]["season"],
          list[i]["village"],
          list[i]["learnGroup"],
          list[i]["FarmersIds"],
          list[i]["remarks"],
          list[i]["isSynched"],
          list[i]["latitude"],
          list[i]["longitude"],
          list[i]["Farmerscount"],
          list[i]["trainingDetail"],
          list[i]["trainingTopic"],
          list[i]["trainingSubTopic"],
          list[i]["trainingMaterial"],
          list[i]["trainingMethod"],
          list[i]["trainingObservation"],
          list[i]["trainingAssistent"],
          list[i]["trainingTime"]);
      TrainingList.add(TrainingnModel);
    }
    return TrainingList;
  }

  Future<List<PlannerweekInsert>> getplannerWeek() async {
    var dbClient = await db;
    List<Map> planlist = await dbClient.rawQuery('SELECT * FROM plannerWeek');
    List<PlannerweekInsert> PlanningList = [];
    for (int i = 0; i < planlist.length; i++) {
      var PlanModel = new PlannerweekInsert(
          planlist[i]["Year"],
          planlist[i]["Week"],
          planlist[i]["Month"],
          planlist[i]["TrainingCode"]);
      PlanningList.add(PlanModel);
    }
    return PlanningList;
  }

  Future<List<PlannertrainingInsert>> getplannerTraining() async {
    var dbClient = await db;
    List<Map> trainlist =
        await dbClient.rawQuery('SELECT * FROM plannerTraining');
    List<PlannertrainingInsert> TrainingList = [];
    for (int i = 0; i < trainlist.length; i++) {
      var TrainModel = new PlannertrainingInsert(
        trainlist[i]["trainingCode"],
        trainlist[i]["trainingName"],
      );
      TrainingList.add(TrainModel);
    }
    return TrainingList;
  }

  Future<int> saveDynamicMenu(
      String menuId,
      String menuName,
      String iconClass,
      String menuOrder,
      String txnTypeIdMenu,
      String entity,
      String menucommonClass,
      String seasonFlag,
      String agentType,
      String isActivityMenu,
      String milestone,
      String isSurvey) async {
    var dbClient = await db;

    int res = await dbClient.rawInsert(
        'INSERT INTO "main"."dynamiccomponentMenu" ("menuId","menuName","iconClass","menuOrder","txnTypeIdMenu","entity","menucommonClass","seasonFlag","agentType","isActivityMenu","milestone","is_survey") VALUES (?,?,?,?,?,?,?,?,?,?,?,?)',
        [
          menuId,
          menuName,
          iconClass,
          menuOrder,
          txnTypeIdMenu,
          entity,
          menucommonClass,
          seasonFlag,
          agentType,
          isActivityMenu,
          milestone,
          isSurvey
        ]);
    return res;
  }

  Future<int> SaveDynamicCompenent(String listId, String listName,
      String blockId, String txnTypeId, String sectionId) async {
    var dbClient = await db;

    int res = await dbClient.rawInsert(
        'INSERT INTO "main"."dynamiccomponentList" ("listId","listName","blockId","txnTypeId","sectionId") VALUES (?,?,?,?,?)',
        [
          listId,
          listName,
          blockId,
          txnTypeId,
          sectionId,
        ]);
    return res;
  }

  Future<int> SaveDynamicCompenentFields(
      String componentType,
      String componentID,
      String componentLabel,
      String textType,
      String beinsert,
      String aftinsert,
      String dateboxType,
      String isMandatory,
      String validationType,
      String maxLength,
      String minLength,
      String decimalLength,
      String isDependency,
      String dependencyField,
      String catalogValueId,
      String parentDependency,
      String txnTypeId,
      String blockId,
      String fieldOrder,
      String ifListNo,
      String sectionId,
      String listMethodName,
      String formulaDependency,
      String parentField,
      String catDepKey,
      String isOther,
      String referenceId,
      String valueDependency,
      String alreadyAns,
      String district,
      String month,
      String actionPlan) async {
    var dbClient = await db;

    int res = await dbClient.rawInsert(
        'INSERT INTO "main"."dynamiccomponentFields" ("componentType","componentID","componentLabel","textType","beinsert","aftinsert","dateboxType","isMandatory","validationType","maxLength","minLength","decimalLength","isDependency","dependencyField","catalogValueId","parentDependency","txnTypeId","blockId","fieldOrder","ifListNo","sectionId","listMethodName","formulaDependency","parentField","catDepKey","isOther","referenceId","valueDependency","alreadyAns","district","month","actionPlan") VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)',
        [
          componentType,
          componentID,
          componentLabel,
          textType,
          beinsert,
          aftinsert,
          dateboxType,
          isMandatory,
          validationType,
          maxLength,
          minLength,
          decimalLength,
          isDependency,
          dependencyField,
          catalogValueId,
          parentDependency,
          txnTypeId,
          blockId,
          fieldOrder,
          ifListNo,
          sectionId,
          listMethodName,
          formulaDependency,
          parentField,
          catDepKey,
          isOther,
          referenceId,
          valueDependency,
          alreadyAns,
          district,
          month,
          actionPlan
        ]);
    return res;
  }

  Future<int> SaveDynamicCompenentLanguage(
      String langCode, String langValue, String componentID) async {
    var dbClient = await db;
    int res = await dbClient.rawInsert(
        'INSERT INTO "main"."dynamiccomponentLanguage" ("langCode","langValue","componentID") VALUES (?,?,?)',
        [
          langCode,
          langValue,
          componentID,
        ]);
    return res;
  }

  Future<int> SavemultiTenantParent(
    String recNo,
    String farmerId,
    String farmId,
    String isSynched,
    String season,
    String longitude,
    String latitude,
    String txnType,
    String txnUniqueId,
    String txnDate,
    String txnTypeIdMaster,
    String inspectionStatus,
    String converStatus,
    String corActPln,
    String entity,
    String dynseasonCode,
    String inspectionDate,
    String scopeOpr,
    String inspectionType,
    String nameofInspect,
    String inspectorMblNo,
    String certTotalLnd,
    String certlandOrganic,
    String certTotalsite,
    String activityId,
    String startTime,
    String activityStatus,
    String reason,
    String lotcode,
    String villageId,
    String vcaCat,
    String vcaRegStat,
  ) async {
    var dbClient = await db;

    int res = await dbClient.rawInsert(
        'INSERT INTO "main"."multiTenantParent"("recNo","farmerId","farmId","isSynched","season","longitude","latitude","txnType","txnUniqueId","txnDate","txnTypeIdMaster","inspectionStatus","converStatus","corActPln","entity","dynseasonCode","inspectionDate","scopeOpr","inspectionType","nameofInspect","inspectorMblNo","certTotalLnd","certlandOrganic","certTotalsite","activityId","startTime","activityStatus","reason","lotcode","villageId","vcaCategory","vcaRegStatus") VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)',
        [
          recNo,
          farmerId,
          farmId,
          isSynched,
          season,
          longitude,
          latitude,
          txnType,
          txnUniqueId,
          txnDate,
          txnTypeIdMaster,
          inspectionStatus,
          converStatus,
          corActPln,
          entity,
          dynseasonCode,
          inspectionDate,
          scopeOpr,
          inspectionType,
          nameofInspect,
          inspectorMblNo,
          certTotalLnd,
          certlandOrganic,
          certTotalsite,
          activityId,
          startTime,
          activityStatus,
          reason,
          lotcode,
          villageId,
          vcaCat,
          vcaRegStat
        ]);
    return res;
  }

  Future<int> SavedynamiccomponentImage(
      String FieldId,
      String imageTime,
      String imageURL,
      String imageLatitude,
      String imageLongitude,
      String videoName,
      String listItration,
      String listId,
      String sectionId,
      String blockId,
      String txnTypeId,
      String audioURL,
      String recNu) async {
    var dbClient = await db;

    int res = await dbClient.rawInsert(
        'INSERT INTO "main"."dynamiccomponentImage" ("Glo_popupId","imageTime","imageURL","imageLatitude","imageLongitude","videoName","listItration","listId","sectionId","blockId","txnTypeId","audioURL","recNu") VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?)',
        [
          FieldId,
          imageTime,
          imageURL,
          imageLatitude,
          imageLongitude,
          videoName,
          listItration,
          listId,
          sectionId,
          blockId,
          txnTypeId,
          audioURL,
          recNu
        ]);
    return res;
  }

  Future<int> SavedynamiccomponentFieldValues(
      String FieldId,
      String FieldVal,
      String ComponentType,
      String recNu,
      String txnTypeId,
      String remarks) async {
    var dbClient = await db;

    int res = await dbClient.rawInsert(
        'INSERT INTO "main"."dynamiccomponentFieldValues" ("FieldId","FieldVal","ComponentType","recNu","txnTypeId","remarks") VALUES (?,?,?,?,?,?)',
        [FieldId, FieldVal, ComponentType, recNu, txnTypeId, remarks]);
    return res;
  }

  Future<int> SavedynamicRemarks(
      String componentID, String remarks, String revNo) async {
    var dbClient = await db;

    int res = await dbClient.rawInsert(
        'INSERT INTO "main"."dynamiccomponentRemarks" ("componentID","remarks","recNo") VALUES (?,?,?)',
        [componentID, remarks, revNo]);
    return res;
  }

  Future<int> SaveWareHouseList(
      String wareHouseCode, String wareHouseName, String wareHouseCity) async {
    var dbClient = await db;

    int res = await dbClient.rawInsert(
        'INSERT INTO "main"."wareHouseList" ("wareHouseCode","wareHouseName","wareHouseCity") VALUES (?,?,?)',
        [wareHouseCode, wareHouseName, wareHouseCity]);
    return res;
  }

  Future<int> SaveDynamicCompenentList(String listId, String listName,
      String blockId, String txnTypeId, String sectionId) async {
    var dbClient = await db;

    int res = await dbClient.rawInsert(
        'INSERT INTO "main"."dynamiccomponentList" ("listId","listName","blockId","txnTypeId","sectionId") VALUES (?,?,?,?,?)',
        [
          listId,
          listName,
          blockId,
          txnTypeId,
          sectionId,
        ]);
    return res;
  }

  Future<int> SaveDynamicCompenentSection(
      String txnTypeId,
      String blockId,
      String sectionId,
      String secName,
      String beinsert,
      String afterins,
      String secOrder,
      String txnTypeIdMaster,
      String fluptxnId,
      String isfollowup,
      String district,
      String month) async {
    var dbClient = await db;

    int res = await dbClient.rawInsert(
        'INSERT INTO "main"."dynamiccomponentSections" ("txnTypeId","blockId","sectionId","secName","beinsert","afterins","secOrder","txnTypeIdMaster","fluptxnId","isfollowup","district","month") VALUES (?,?,?,?,?,?,?,?,?,?,?,?)',
        [
          txnTypeId,
          blockId,
          sectionId,
          secName,
          beinsert,
          afterins,
          secOrder,
          txnTypeIdMaster,
          fluptxnId,
          isfollowup,
          district,
          month
        ]);
    return res;
  }

  Future<int> deleteComponentFields(String listID, String recNu,
      String listItration, String sectionId) async {
    int res;
    var dbClient = await db;
    res = await dbClient.rawDelete(
        'DELETE FROM dynamicListValues WHERE listID = ? and recNu= ? and listItration = ? and sectionId=?',
        [listID, recNu, listItration, sectionId]);
    return res;
  }

  Future<int> deletePartialFields(
      String listID, String listItration, String sectionId) async {
    int res;
    var dbClient = await db;
    res = await dbClient.rawDelete(
        'DELETE FROM listPartial WHERE listID = ? and iteration = ? and section=?',
        [listID, listItration, sectionId]);
    return res;
  }

  Future<int> SaveDynamicListValue(
      String FieldId,
      String FieldVal,
      String fieldLabel,
      String ArrayName,
      String listID,
      String blockId,
      String listHeading,
      String listItration,
      String sectionId,
      String componentType,
      String recNu,
      String txnTypeId,
      String componentValueText,
      String isSynched) async {
    var dbClient = await db;

    int res = await dbClient.rawInsert(
        'INSERT INTO "main"."dynamicListValues" ("fieldId","fieldValue","fieldLabel","ArrayName","listID","blockId","listHeading","listItration","sectionId","componentType","recNu","txnTypeId","componentValueText","isSynched") VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?)',
        [
          FieldId,
          FieldVal,
          fieldLabel,
          ArrayName,
          listID,
          blockId,
          listHeading,
          listItration,
          sectionId,
          componentType,
          recNu,
          txnTypeId,
          componentValueText,
          isSynched,
        ]);
    return res;
  }

  Future<int> SavebuyerList(
    String buyrId,
    String buyrName,
  ) async {
    var dbClient = await db;

    int res = await dbClient.rawInsert(
        'INSERT INTO "main"."buyerList" ("buyrId","buyrName") VALUES (?,?)',
        [buyrId, buyrName]);
    return res;
  }

  Future<int> SavefarmerCrpList(
      String farmercode,
      String farmername,
      String osbal,
      String osBalProcurement,
      String rateOfInterest,
      String principleAmount,
      String interestAmountAccumulated,
      String proRateOfInterest,
      String proPrincipleAmount,
      String proInterestAmtAccumulatee) async {
    var dbClient = await db;
    int res = await dbClient.rawInsert(
        'INSERT INTO "main"."farmerCrList" ("farmerCode", "farmerName", "osBal", "osBalProcurement", "rateOfInterest", "principleAmount","interestAmountAccumulated","proRateOfInterest","proPrincipleAmount","proInterestAmtAccumulate") VALUES (?,?,?,?,?,?,?,?,?,?)',
        [
          farmercode,
          farmername,
          osbal,
          osBalProcurement,
          rateOfInterest,
          principleAmount,
          interestAmountAccumulated,
          proRateOfInterest,
          proPrincipleAmount,
          proInterestAmtAccumulatee
        ]);
    return res;
  }

  Future<int> SaveEditFarmer(
    String isSynched,
    String recId,
    String farmerId,
    String farmerlatitude,
    String farmerlongitude,
    String farmertimeStamp,
    String farmerphoto,
    String farmerMobile,
    String farmlatitude,
    String farmlongitude,
    String farmtimeStamp,
    String farmphoto,
    String farmId,
    String currentSeason,
    String farmProduction,
    String fingerPrint,
    String idProof,
    String idProofOthr,
    String idProofVal,
    String IdProofLatitude,
    String IdProofLongitude,
    String IdProofTimeStamp,
    String IdProofphoto,
    String idstatus,
    String frPhoto,
    String farmTotalProd,
    String pltStatus,
    String geoStatus,
    String trader,
  ) async {
    var dbClient = await db;
    int res = await dbClient.rawInsert(
        'INSERT INTO "main"."edit_farmer" ("isSynched","recId","farmerId","farmerlatitude","farmerlongitude","farmertimeStamp","farmerphoto","farmerMobile","farmlatitude","farmlongitude","farmtimeStamp","farmphoto","farmId","currentSeason","farmProduction","fingerPrint","idProof","idProofOthr","idProofVal","IdProofLatitude","IdProofLongitude","IdProofTimeStamp","IdProofphoto","idstatus","frPhoto","farmTotalProd","pltStatus","geoStatus","trader") VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)',
        [
          isSynched,
          recId,
          farmerId,
          farmerlatitude,
          farmerlongitude,
          farmertimeStamp,
          farmerphoto,
          farmerMobile,
          farmlatitude,
          farmlongitude,
          farmtimeStamp,
          farmphoto,
          farmId,
          currentSeason,
          farmProduction,
          fingerPrint,
          idProof,
          idProofOthr,
          idProofVal,
          IdProofLatitude,
          IdProofLongitude,
          IdProofTimeStamp,
          IdProofphoto,
          idstatus,
          frPhoto,
          farmTotalProd,
          pltStatus,
          geoStatus,
          trader
        ]);
    return res;
  }

  Future<int> SaveVillageWareHouse(
      {required String purRecieptNo,
      required String farmerName,
      required String farmerCode,
      required String farmName,
      required String farmCode,
      required String coffeeType,
      required String coffeeVariety,
      required String coffeeGrade,
      required String noofbags,
      required String grossWeight,
      required String netWt,
      required String trnsDate,
      required String transferRecptNo,
      required String bagsTransferred,
      required String weightTransferred,
      required String stockType,
      required String vehicleNumber,
      required String driverName,
      required String receptionNo,
      required String bagsRecieved,
      required String trnsCompleted,
      required String weightRecieved,
      required String purBag,
      required String bagsTransfer,
      required String weightTransfer,
      required String buyingCenter,
      required String processType,
      required String processBatchNo,
      required String recieverName,
      required String recieverId,
      required String isTransferred}) async {
    var dbClient = await db;

    int res = await dbClient.rawInsert(
        'INSERT INTO "main"."villageWarehouse" ("purRecieptNo", "farmerName", "farmerCode", "farmName","farmCode", "coffeeType", "coffeeVariety", "coffeeGrade", "noofbags",'
        '"grossWeight","netWt","trnsdate","transferRecptNo","bagsTransferred","weightTransferred","stockType","vehicleNumber","driverName","receptionNo","bagsRecieved","trnsCompleted","weightRecieved","purBag","bagTransfer","weightTransfer","buyingCenter","processType","processBatchNo","recieverName","recieverId","isTransferCompleted") VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)',
        [
          purRecieptNo,
          farmerName,
          farmerCode,
          farmName,
          farmCode,
          coffeeType,
          coffeeVariety,
          coffeeGrade,
          noofbags,
          grossWeight,
          netWt,
          trnsDate,
          transferRecptNo,
          bagsTransferred,
          weightTransferred,
          stockType,
          vehicleNumber,
          driverName,
          receptionNo,
          bagsRecieved,
          trnsCompleted,
          weightRecieved,
          purBag,
          bagsTransfer,
          weightTransfer,
          buyingCenter,
          processType,
          processBatchNo,
          recieverName,
          recieverId,
          isTransferred
        ]);
    return res;
  }

  Future<int> Savefarm_GPSLocation_Exists(
    String longitude,
    String latitude,
    String farmerId,
    String farmId,
    String reciptId,
    String OrderOFGPS,
  ) async {
    var dbClient = await db;

    int res = await dbClient.rawInsert(
        'INSERT INTO "main"."farm_GPSLocation_Exists" ("longitude", "latitude", "farmerId", "farmId", "reciptId", "OrderOFGPS") VALUES (?,?,?,?,?,?)',
        [longitude, latitude, farmerId, farmId, reciptId, OrderOFGPS]);
    return res;
  }

  Future<int> saveTripTransaction(
      String vehnum,
      String tripdte,
      String driver1,
      String driver2,
      String depplace,
      String fieldActivity,
      String deptime,
      String Odmtrstrt,
      String emptycrates,
      String desplace,
      String destime,
      String OdmtrEnd,
      String actvtynum,
      String actvthrs,
      String revNo,
      String isSynched,
      String timeStamps,
      String longitude,
      String latitude,
      String villageId) async {
    var dbClient = await db;
    int res = await dbClient.rawInsert(
        'INSERT INTO "main"."fieldActivity" ("pDate", "startLocation", "destination", "fieldActivity", "startKM", "endKM", "model", "cc", "recNo", "mileage","actNumber", "isSynched", "actHours", "timeStamps", "longitude", "latitude", villageId, "driver1", "driver2", "vehicleNo") VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)',
        [
          vehnum,
          tripdte,
          driver1,
          driver2,
          depplace,
          fieldActivity,
          deptime,
          Odmtrstrt,
          emptycrates,
          desplace,
          destime,
          OdmtrEnd,
          actvtynum,
          actvthrs,
          revNo,
          isSynched,
          timeStamps,
          longitude,
          latitude,
          villageId
        ]);
    return res;
  }

  Future<int> seedBookingReqList(
    String recNo,
    String seedVarietyId,
    String seedGenerationId,
    String quantityResisted,
  ) async {
    var dbClient = await db;

    int res = await dbClient.rawInsert(
        'INSERT INTO "main"."seedBookingrequ" ("varitetyReq", "generationReq", "quantity", "recNo") VALUES (?,?,?,?)',
        [seedVarietyId, seedGenerationId, quantityResisted, recNo]);
    return res;
  }

  Future<int> seedBookingRenList(
    String recNo,
    String seedVarietyId,
    String seedGenerationId,
    String quantityResisted,
  ) async {
    var dbClient = await db;

    int res = await dbClient.rawInsert(
        'INSERT INTO "main"."seedBookingrene" ("varitetyReq", "generationReq", "quantity", "recNo") VALUES (?,?,?,?)',
        [seedVarietyId, seedGenerationId, quantityResisted, recNo]);
    return res;
  }

  Future<int> saveSeedBooking(
    String aggregateCode,
    String loading,
    String loadingDate,
    String approval,
    String certified,
    String amount,
    String certifiedPhoto,
    String slipPhoto,
    String contract,
    String bookingId,
    String isSynched,
    String recNo,
    String latitude,
    String longitude,
  ) async {
    var dbClient = await db;

    int res = await dbClient.rawInsert(
        'INSERT INTO "main"."seedBooking" ("aggregateCode", "loading", "loadingDate", "approval", "certified", "amount","certifiedPhoto","slipPhoto", "contract", "bookingId", "isSynched", "recNo", "latitude","longitude") VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?)',
        [
          aggregateCode,
          loading,
          loadingDate,
          approval,
          certified,
          amount,
          certifiedPhoto,
          slipPhoto,
          contract,
          bookingId,
          isSynched,
          recNo,
          latitude,
          longitude
        ]);
    return res;
  }

  Future<int> SaveFarmer(
      String? recNo,
      String? isSynched,
      String longitude,
      String latitude,
      String teantId,
      String season,
      String enrollmentPlace,
      String enrollmentDate,
      String farmerCode,
      String Enrollperson,
      String farmerName,
      String fatherName,
      String gramdfathrName,
      String gender,
      String dob,
      String frPhoto,
      String education,
      String mobileNo,
      String country,
      String zone,
      String kebele,
      String city,
      String appatanegroup,
      String typgroup,
      String namegroup,
      String positiongroup,
      String loantakeyr,
      String loanAmount,
      String loanPurpose,
      String accountnumbr,
      String bankname,
      String brankname,
      String bankphoto,
      String mappedto) async {
    var dbClient = await db;
    int res = await dbClient.rawInsert(
        'INSERT INTO "main"."farmer" ("farmerId","isSynched","longitude","latitude","tenant","currentSeason","enrollmentPlace","enrollmentDate","farmerCode","otherEnrollPlace","fName","fatherName","lName","gender","dob","frPhoto","education","mobileNo","country","state","district","city","isBeneficiary","placeAssmnt","assemnt","irpValue","farmerLoanapply","loanAmount","loanPurpose","insTenure","workDiffOth","comDiffOth","photo","trader") VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)',
        [
          recNo,
          isSynched,
          longitude,
          latitude,
          teantId,
          season,
          enrollmentPlace,
          enrollmentDate,
          farmerCode,
          Enrollperson,
          farmerName,
          fatherName,
          gramdfathrName,
          gender,
          dob,
          frPhoto,
          education,
          mobileNo,
          country,
          zone,
          kebele,
          city,
          appatanegroup,
          typgroup,
          namegroup,
          positiongroup,
          loantakeyr,
          loanAmount,
          loanPurpose,
          accountnumbr,
          bankname,
          brankname,
          bankphoto,
          mappedto,
        ]);
    return res;
  }

  Future<int> SaveSeedmdcoll(
      String? recNo,
      String? isSynched,
      String longitude,
      String latitude,
      String txnType,
      String txnDate,
      String season,
      String teantId,
      String Typepuchse,
      String agctrcode) async {
    var dbClient = await db;
    int res = await dbClient.rawInsert(
        'INSERT INTO "main"."seedDemandcoll" ("recNo","isSynched","longitude","latitude","txnType","txnDate","season","teantId","typepurchse","agctrcode") VALUES (?,?,?,?,?,?,?,?,?,?)',
        [
          recNo,
          isSynched,
          longitude,
          latitude,
          txnType,
          txnDate,
          season,
          teantId,
          Typepuchse,
          agctrcode,
        ]);
    return res;
  }

  Future<int> SaveSeedtoWarehouse(
    String managerName,
    String lotReference,
    String warehouseDestination,
    String centreName,
    String receptionDate,
    String sivN,
    String representativeName,
    String vehicleGross,
    String vehicleTare,
    String netWeight,
    String bagsDeparture,
    String theoWeight,
    String slipPhoto,
    String returnNote,
    String transferOut,
    String issuedBy,
    String varietyPurital,
    String mm,
    String admixture,
    String kernelWeight,
    String qtycheckedBy,
    String warehouseReception,
    String transferN,
    String bagsReception,
    String stackID,
    String isSynched,
    String recNo,
    String latitude,
    String longitude,
  ) async {
    var dbClient = await db;
    int res = await dbClient.rawInsert(
        'INSERT INTO "main"."seedTowarehouse" ( "managerName", "lotReference", "warehouseDestination", "centreName", "receptionDate", "sivN","representativeName", "vehicleGross",  "vehicleTare","netWeight","bagsDeparture","theoWeight","slipPhoto","returnNote","transferOut","issuedBy","varietyPurital","2mm","admixture","kernelWeight","qtycheckedBy","warehouseReception","transferN","bagsReception","stackID","isSynched","recNo","latitude","longitude") VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)',
        [
          managerName,
          lotReference,
          warehouseDestination,
          centreName,
          receptionDate,
          sivN,
          representativeName,
          vehicleGross,
          vehicleTare,
          netWeight,
          bagsDeparture,
          theoWeight,
          slipPhoto,
          returnNote,
          transferOut,
          issuedBy,
          varietyPurital,
          mm,
          admixture,
          kernelWeight,
          qtycheckedBy,
          warehouseReception,
          transferN,
          bagsReception,
          stackID,
          isSynched,
          recNo,
          latitude,
          longitude,
        ]);
    return res;
  }

  Future<int> SaveFarmsflt(
    String farmIDT,
    String date,
    String zone,
    String woreda,
    String kebele,
    String farmType,
    String farmName,
    String totLand,
    String hectareOwned,
    String hectareRented,
    String doubleCropping,
    String numberOfcrops,
    String cropCultivated,
    String soilPrep,
    String harvestMechanization,
    String isSynched,
    String recNo,
    String latitude,
    String longitude,
    String farmerId,
  ) async {
    var dbClient = await db;
    int res = await dbClient.rawInsert(
        'INSERT INTO "main"."farmSoufflet" ("farmIDT","date", "zone", "woreda", "kebele", "farmType", "farmName","totLand", "hectareOwned","hectareRented","doubleCropping","numberOfcrops","cropCultivated","soilPrep","harvestMechanization","isSynched","recNo","latitude","longitude","farmerId") VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)',
        [
          farmIDT,
          date,
          zone,
          woreda,
          kebele,
          farmType,
          farmName,
          totLand,
          hectareOwned,
          hectareRented,
          doubleCropping,
          numberOfcrops,
          cropCultivated,
          soilPrep,
          harvestMechanization,
          isSynched,
          recNo,
          latitude,
          longitude,
          farmerId
        ]);
    return res;
  }

  Future<int> SaveFarmsflt1(
      {required String farmerId,
      required String farmIDT,
      required String farmName,
      required String frPhoto,
      required String type,
      required String varieties,
      required String spacingTree,
      required String yieldTree,
      required String totCoffeeAcr,
      required String propCoffeeAr,
      required String avgTree,
      required String numTree,
      required String typTree,
      required String numPrTrees,
      required String numUnPrTrees,
      required String goodAgri,
      required String certProgram,
      required String landOwner,
      required String landTopo,
      required String landGr,
      required String accRoad,
      required String altitude,
      required String plDate,
      required String otCrop,
      required String prDate,
      required String soilTyp,
      required String fertStatus,
      required String irriSource,
      required String metIrr,
      required String watHarMethod,
      required String isSynched,
      required String recNo,
      required String latitude,
      required String longitude,
      required String villageId,
      required String liveStock,
      required String auditedArea,
      required String altitudeValue,
      required String landTitleDoc}) async {
    var dbClient = await db;
    int res = await dbClient.rawInsert(
        'INSERT INTO "main"."farmSoufflet" ("farmerId","farmIDT","farmName","frPhoto","type","varieties","spacingTree","yieldTree","totCoffeeAcr","propCoffeeAr","avgTree","numTree","typTree","numPrTrees","numUnPrTrees","goodAgri","certProgram","landOwner","landTopo","landGr","accRoad","altitude","plDate","otCrop","prDate","soilTyp","fertStatus","irriSource","metIrr","watHarMethod","isSynched","recNo","latitude","longitude","villageId","liveStock","auditedArea","altitudeValue","landTitleDoc") VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)',
        [
          farmerId,
          farmIDT,
          farmName,
          frPhoto,
          type,
          varieties,
          spacingTree,
          yieldTree,
          totCoffeeAcr,
          propCoffeeAr,
          avgTree,
          numTree,
          typTree,
          numPrTrees,
          numUnPrTrees,
          goodAgri,
          certProgram,
          landOwner,
          landTopo,
          landGr,
          accRoad,
          altitude,
          plDate,
          otCrop,
          prDate,
          soilTyp,
          fertStatus,
          irriSource,
          metIrr,
          watHarMethod,
          isSynched,
          recNo,
          latitude,
          longitude,
          villageId,
          liveStock,
          auditedArea,
          altitudeValue,
          landTitleDoc
        ]);
    return res;
  }

  Future<int> SaveEntityFarm(
      {required String farmerId,
      required String farmIDT,
      required String farmName,
      required String frPhoto,
      required String type,
      required String varieties,
      required String spacingTree,
      required String yieldTree,
      required String totCoffeeAcr,
      required String propCoffeeAr,
      required String avgTree,
      required String numTree,
      required String typTree,
      required String numPrTrees,
      required String numUnPrTrees,
      required String goodAgri,
      required String certProgram,
      required String landOwner,
      required String landTopo,
      required String landGr,
      required String accRoad,
      required String altitude,
      required String plDate,
      required String otCrop,
      required String prDate,
      required String soilTyp,
      required String fertStatus,
      required String irriSource,
      required String metIrr,
      required String watHarMethod,
      required String isSynched,
      required String recNo,
      required String latitude,
      required String longitude,
      required String villageId,
      required String liveStock,
      required String auditedArea,
      required String altitudeValue,
      required String landTitleDoc,
      required String entityType,
      required String entityName}) async {
    var dbClient = await db;
    int res = await dbClient.rawInsert(
        'INSERT INTO "main"."entityFarm" ("farmerId","farmIDT","farmName","frPhoto","type","varieties","spacingTree","yieldTree","totCoffeeAcr","propCoffeeAr","avgTree","numTree","typTree","numPrTrees","numUnPrTrees","goodAgri","certProgram","landOwner","landTopo","landGr","accRoad","altitude","plDate","otCrop","prDate","soilTyp","fertStatus","irriSource","metIrr","watHarMethod","isSynched","recNo","latitude","longitude","villageId","liveStock","auditedArea","altitudeValue","landTitleDoc","entityType","entityName") VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)',
        [
          farmerId,
          farmIDT,
          farmName,
          frPhoto,
          type,
          varieties,
          spacingTree,
          yieldTree,
          totCoffeeAcr,
          propCoffeeAr,
          avgTree,
          numTree,
          typTree,
          numPrTrees,
          numUnPrTrees,
          goodAgri,
          certProgram,
          landOwner,
          landTopo,
          landGr,
          accRoad,
          altitude,
          plDate,
          otCrop,
          prDate,
          soilTyp,
          fertStatus,
          irriSource,
          metIrr,
          watHarMethod,
          isSynched,
          recNo,
          latitude,
          longitude,
          villageId,
          liveStock,
          auditedArea,
          altitudeValue,
          landTitleDoc,
          entityType,
          entityName
        ]);
    return res;
  }

  Future<int> SaveAgronomist(
      String block,
      String agronomist,
      String date,
      String latitude,
      String longitude,
      String recNo,
      String isSynched,
      String timeStamps) async {
    var dbClient = await db;
    int res = await dbClient.rawInsert(
        'INSERT INTO "main"."agronomist" ("block","agronomist", "dateAgro", "recNo", "isSynched","timeStamps","longitude","latitude") VALUES (?,?, ?,?, ?, ?,?, ?)',
        [
          block,
          agronomist,
          date,
          recNo,
          isSynched,
          timeStamps,
          longitude,
          latitude
        ]);
    return res;
  }

  Future<int> SaveAggregatorDB(
    String aggregatorcode,
    String fatherName,
    String country,
    String groupName,
    String gfatherName,
    String gender,
    String amtRec,
    String kebele,
    String zone,
    String aggregatorname,
    String woreda,
  ) async {
    var dbClient = await db;
    int res = await dbClient.rawInsert(
        'INSERT INTO "main"."aggregatorMaster" ( "aggregatorType", "aggregatorId", "aggregatorName", "country", "zone", "woreda","kebele", "groupType", "groupName","groupCode","fatherName","gfatherName","gender","amt") VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?)',
        [
          '',
          aggregatorcode,
          aggregatorname,
          country,
          zone,
          woreda,
          kebele,
          '',
          groupName,
          groupName,
          fatherName,
          gfatherName,
          gender,
          amtRec,
        ]);
    return res;
  }

  Future<int> saveFarmerData(
      String DateRegistration,
      String farmerId,
      String farmerCode,
      String fName,
      String oName,
      String frPhoto,
      String gender,
      String dob,
      String age,
      String memberCoffeeOrg,
      String martialStatus,
      String idPhoto,
      String state,
      String district,
      String city,
      String village,
      String nameOwner,
      String addressOwner,
      String mobileNo,
      String nationalID,
      String address,
      String nin,
      String email,
      String phoneNo,
      String mobMonNo,
      String isFarmerCertified,
      String scheme,
      String headFamily,
      String totNumOfHouseHold,
      String totAdultFamily,
      String totNumChildren,
      String coffeeFarmEquipments,
      String postHarvest,
      String landTenure,
      String coffeeType,
      String levelEducation,
      String totLandOwned,
      String totNumFarms,
      String healthIns,
      String nameCompany,
      String timeStamp,
      String longitude,
      String latitude,
      String amount,
      String period,
      String farmEnterpriseIns,
      String isSynched,
      String recNo,
      String amount1,
      String nameCrop,
      String country) async {
    var dbClient = await db;

    int res = await dbClient.rawInsert(
        'INSERT INTO "main"."farmer" ("enrollmentDate","farmerId","farmerCode","fName","lName",' //5
        '"photo","gender","dob","Age","cookFuel",' //5
        '"maritalStatus","IdProofphoto","country","state","city",' //5
        '"district","village","totalIncome","mobileNo",' //4
        '"enrollmentPlace","address","police_station","email","phoneNo",' //5
        '"zipCode","certifiedFarmer","icsName","icsCode",' //4
        '"totalMale","totalFemale","schoolChild","drinkWaterSource","electricHouse",' //5
        '"comDiff","workDiff","objective","healthIssue","healthIssueDes",' //5
        '"placeAssmnt","irpValue","timeStamp","longitude","latitude",' //5
        '"noOfMembers","adultCntSite","inspecType","isSynched","traceId",' //5
        '"fatherName","category","status") VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)',
        [
          DateRegistration,
          farmerId,
          farmerCode,
          fName,
          oName,
          //
          frPhoto,
          gender,
          dob,
          age,
          memberCoffeeOrg,
          //5
          martialStatus,
          idPhoto,
          country,
          state,
          district,
          //5
          city,
          village,
          nameOwner,
          mobileNo,
          //4
          nationalID,
          address,
          nin,
          email,
          phoneNo,
          //5
          mobMonNo,
          isFarmerCertified,
          scheme,
          headFamily,
          //4
          totNumOfHouseHold,
          totAdultFamily,
          totNumChildren,
          coffeeFarmEquipments,
          postHarvest,
          //5
          landTenure,
          coffeeType,
          levelEducation,
          totLandOwned,
          totNumFarms,
          //5
          healthIns,
          nameCompany,
          timeStamp,
          longitude,
          latitude,
          //5
          amount,
          period,
          farmEnterpriseIns,
          isSynched,
          recNo,
          //5
          addressOwner,
          amount1,
          nameCrop,
          //3
        ]);

    return res;
  }

  Future<int> saveBankDetails(
      String farmerId,
      String bankACNumber,
      String bankName,
      String bankBranch,
      String IFSCcode,
      String SWIFTcode,
      String accountType,
      String otherAccountType) async {
    var dbClient = await db;
    int res = await dbClient.rawInsert(
        'INSERT INTO "main"."bankList" ( "farmerId", "bankACNumber", "bankName","bankBranch","IFSCcode","SWIFTcode","accountType","otherAccountType") VALUES (?,?,?,?,?,?,?,?)',
        [
          farmerId,
          bankACNumber,
          bankName,
          bankBranch,
          IFSCcode,
          SWIFTcode,
          accountType,
          otherAccountType
        ]);
    return res;
  }

  Future<int> saveFarmData({
    required String village,
    required String farmerId,
    required String farmId,
    required String farmName,
    required String fPhoto,
    required String type,
    required String varieties,
    required String spacingTree,
    required String yieldEst,
    required String totCoffeeAcerage,
    required String propCoffee,
    required String avgTree,
    required String numShadeTree,
    required String typShadeTree,
    required String numProdTree,
    required String numUnProdTree,
    required String goodAgriPractices,
    required String certProgram,
    required String landOwner,
    required String landTopo,
    required String landGrad,
    required String accRoad,
    required String altitude,
    required String plDate,
    required String othCrop,
    required String prDate,
    required String soilType,
    required String fertStatus,
    required String irrSource,
    required String methIrrigation,
    required String watHarvestMethod,
    required String timeStamp,
    required String longitude,
    required String latitude,
    required String isSynched,
    required String recNo,
  }) async {
    var dbClient = await db;

    int res = await dbClient.rawInsert(
        'INSERT INTO "main"."farm" ('
        '"farmVillage",'
        '"farmerId",'
        '"farmIDT",'
        '"farmName",'
        '"frPhoto",'
        '"insType",'
        '"farmVariety",'
        '"treeName",'
        '"numCofTrees",'
        '"convenYield",'
        '"prodLand",'
        '"year",'
        '"qtyApply",'
        '"hiredLabour",'
        '"ownLand",'
        '"leaseLand",'
        '"presenceBanana",'
        '"farmCertType",'
        '"landOwner",'
        '"landTopography",'
        '"landGradient",'
        '"approachRoad",'
        '"pltStatus",'
        '"docIdNo","organicUnit","riskCategory","soilTest","areaIrrigation","irrigationMth","irrigationRes","labourDetails","latitude","timeStamp","longitude","latitude","isSynched","recptId") VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)',
        [
          village,
          farmerId,
          farmId,
          farmName,
          fPhoto,
          type,
          varieties,
          spacingTree,
          yieldEst,
          totCoffeeAcerage,
          propCoffee,
          avgTree,
          numShadeTree,
          typShadeTree,
          numProdTree,
          numUnProdTree,
          goodAgriPractices,
          certProgram,
          landOwner,
          landTopo,
          landGrad,
          accRoad,
          altitude,
          plDate,
          othCrop,
          prDate,
          soilType,
          fertStatus,
          irrSource,
          methIrrigation,
          watHarvestMethod,
          timeStamp,
          longitude,
          latitude,
          isSynched,
          recNo,
        ]);

    return res;
  }

  Future<int> saveCTC(
      String recNo,
      String isSynched,
      String witheringBatch,
      String date,
      String time,
      String availableStockStr,
      String rvInput,
      String rcv,
      String ctc1,
      String ctc2,
      String ctc3,
      String rvoutput,
      String ctcBatchNo,
      String latitude,
      String longitude) async {
    var dbClient = await db;
    int res = await dbClient.rawInsert(
        'INSERT INTO "main"."ctc" ("recNo","isSynched","witheringBatch","date","time","avStock","rvInput","rcv","ctc1","ctc2","ctc3","rvoutput","ctcBatchNo","latitude","longitude") VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)',
        [
          recNo,
          isSynched,
          witheringBatch,
          date,
          time,
          availableStockStr,
          rvInput,
          rcv,
          ctc1,
          ctc2,
          ctc3,
          rvoutput,
          ctcBatchNo,
          latitude,
          longitude
        ]);

    return res;
  }

  Future<int> saveCFM(
      String recNo,
      String isSynched,
      String cfmDate,
      String cfmTime,
      String cfm1,
      String cfm2,
      String cfm3,
      String cfm4,
      String cfm5,
      String cfm6,
      String cfm7,
      String dropping,
      String fermentingTime,
      String cfm1percent,
      String cfm2percent,
      String cfm3percent,
      String cfm4percent,
      String cfm5percent,
      String cfm6percent,
      String cfm7percent,
      String latitude,
      String longitude,
      String ctcBatchNo) async {
    var dbClient = await db;
    int res = await dbClient.rawInsert(
        'INSERT INTO "main"."cfm" ("recNo","isSynched","cfmDate","cfmTime","cfm1","cfm2","cfm3","cfm4","cfm5","cfm6","cfm7","dropping","fermentingTime","cfm1percent","cfm2percent","cfm3percent","cfm4percent","cfm5percent","cfm6percent","cfm7percent","latitude","longitude","ctcbatchNo") VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)',
        [
          recNo,
          isSynched,
          cfmDate,
          cfmTime,
          cfm1,
          cfm2,
          cfm3,
          cfm4,
          cfm5,
          cfm6,
          cfm7,
          dropping,
          fermentingTime,
          cfm1percent,
          cfm2percent,
          cfm3percent,
          cfm4percent,
          cfm5percent,
          cfm6percent,
          cfm7percent,
          latitude,
          longitude,
          ctcBatchNo
        ]);

    return res;
  }

  Future<int> saveWitheringInput(
      String recNo,
      String wDate,
      String wTime,
      String troughNo,
      String batchNo,
      String avlStock,
      String capacityTrough,
      String thicknessLeaf,
      String inputQty,
      String outputQty,
      String timeOutput,
      String wBatchNo,
      String latitude,
      String longitude,
      String isSynched,
      String factory) async {
    var dbClient = await db;
    int res = await dbClient.rawInsert(
        //1     //2     //3      //4
        'INSERT INTO "main"."witheringInput" ("recNo","wDate","wTime","troughNo","batchNo","avlStock","capacityTrough","thicknessLeaf","inputQty","outputQty","timeOutput","wBatchNo","latitude","longitude","isSynched","factory") VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)',
        [
          recNo,
          wDate,
          wTime,
          troughNo,
          batchNo,
          avlStock,
          capacityTrough,
          thicknessLeaf,
          inputQty,
          outputQty,
          timeOutput,
          wBatchNo,
          latitude,
          longitude,
          isSynched,
          factory
        ]);

    return res;
  }

  Future<int> saveWitheringOutput(
      String recNo,
      String wDate,
      String wTimeInput,
      String capTrough,
      String thickLeaf,
      String inputQty,
      String outputQty,
      String wTimeOutput,
      String isSynched,
      String latitude,
      String longitude) async {
    var dbClient = await db;
    int res = await dbClient.rawInsert(
        'INSERT INTO "main"."witheringOutput" ("recNo","wDate","wTimeInput","capTrough","thickLeaf","inputQty","outputQty","wTimeOutput","isSynched","latitude","longitude") VALUES (?,?,?,?,?,?,?,?,?,?,?)',
        [
          recNo,
          wDate,
          wTimeInput,
          capTrough,
          thickLeaf,
          inputQty,
          outputQty,
          wTimeOutput,
          isSynched,
          latitude,
          longitude
        ]);

    return res;
  }

  Future<int> saveDryer(
    String recNo,
    String isSynched,
    String dryerDate,
    String dryerTime,
    String dt,
    String t1,
    String t2,
    String t3,
    String t4,
    String dm,
    String density,
    String greenDensity,
    String dryerDensity,
    String teaDensity,
    String output,
    String latitude,
    String longitude,
  ) async {
    var dbClient = await db;
    int res = await dbClient.rawInsert(
        'INSERT INTO "main"."dryer" ("recNo","isSynched","dryerDate","dryerTime","dt","t1","t2","t3","t4","dm","density","greenDensity","dryerDensity","teaDensity","output","latitude","longitude") VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)',
        [
          recNo,
          isSynched,
          dryerDate,
          dryerTime,
          dt,
          t1,
          t2,
          t3,
          t4,
          dm,
          density,
          greenDensity,
          dryerDensity,
          teaDensity,
          output,
          latitude,
          longitude
        ]);

    return res;
  }

  Future<int> saveMrlInspection(
      String inspDate,
      String val_village,
      String val_farmer,
      String val_farm,
      String sprayingDate,
      String valPest,
      String valCategory,
      String valChemical,
      String harvestInterval,
      String longitude,
      String latitude,
      String isSynched,
      String msgNo,
      String recNo) async {
    var dbClient = await db;
    int res = await dbClient.rawInsert(
        'INSERT INTO "main"."mrlInspection" ("recNo","isSynched","msgNo","inspDate","village","farmerId","farmId","sprayingDate","pest","category","chemical","harvestInterval","latitude","longitude") VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?)',
        [
          recNo,
          isSynched,
          msgNo,
          inspDate,
          val_village,
          val_farmer,
          val_farm,
          sprayingDate,
          valPest,
          valCategory,
          valChemical,
          harvestInterval,
          latitude,
          longitude
        ]);

    return res;
  }

  Future<int> saveFarmerData1(
      String landOwned,
      String enrollementPlace,
      String farmerId,
      String farmerCode,
      String fName,
      String lName,
      String frPhoto,
      String gender,
      String dob,
      String age,
      String annualIncome,
      String martialStatus,
      String idPhoto,
      String state,
      String district,
      String city,
      String village,
      String fpoFgGroup,
      String mobileNo,
      String zipcode,
      String address,
      String vendorType,
      String licenseNo,
      String totFamMembers,
      String son,
      String daughter,
      String grandChildren,
      String medicalFacilities,
      String educationFacilities,
      String otherBusPotential,
      String communication,
      String educationLevel,
      String abilityCommunicate,
      String foliarApp,
      String pestManagement,
      String priningTipping,
      String plucking,
      String spraying,
      String indigenTechKnowledge,
      String samCode,
      String timeStamp,
      String longitude,
      String latitude,
      String email,
      String gpCode,
      String coCode,
      String isSynched,
      String recNo,
      String tenant,
      String fatherName,
      String farmerSurname,
      String country,
      String group1,
      String signature) async {
    var dbClient = await db;

    int res = await dbClient.rawInsert(
        'INSERT INTO "main"."farmerkettle" ("landOwned","enrollementPlace","farmerId","farmerCode","fName","lName","frPhoto","gender","dob","age","annualIncome","maritalStatus","idPhoto","state","district","city","village","fpoFgGroup","mobileNo","zipcode","address","vendorType","licenseNo","totFamMembers","son","daughter","grandChildren","medicalFacilities","educationFacilities","otherBusPotential","communication","educationLevel","abilityCommunicate","foliarApp","pestManagement","priningTipping","plucking","spraying","indigenTechknowledge","samCode","timeStamp","longitude","latitude","email","gpCode","coCode","isSynched","recNo","tenant","fatherName","farmerSurname"," country","group1","signature") VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)',
        [
          landOwned,
          enrollementPlace,
          farmerId,
          farmerCode,
          fName,
          lName,
          frPhoto,
          gender,
          dob,
          age,
          annualIncome,
          martialStatus,
          idPhoto,
          state,
          district,
          city,
          village,
          fpoFgGroup,
          mobileNo,
          zipcode,
          address,
          vendorType,
          licenseNo,
          totFamMembers,
          son,
          daughter,
          grandChildren,
          medicalFacilities,
          educationFacilities,
          otherBusPotential,
          communication,
          educationLevel,
          abilityCommunicate,
          foliarApp,
          pestManagement,
          priningTipping,
          plucking,
          spraying,
          indigenTechKnowledge,
          samCode,
          timeStamp,
          longitude,
          latitude,
          email,
          gpCode,
          coCode,
          isSynched,
          recNo,
          tenant,
          fatherName,
          farmerSurname,
          country,
          group1,
          signature
        ]);

    return res;
  }

  Future<int> SaveCoffeePurchase(
      {required String purDate,
      required String season,
      required String batchNo,
      required String buyingCenter,
      required String farmerName,
      required String farmerId,
      required String farmerCode,
      required String farmName,
      required String farmId,
      required String coffeeType,
      required String coffeeVariety,
      required String coffeeGrade,
      required String noofBags,
      required String quantity,
      required String priceKilogram,
      required String totAmt,
      required String amtPaid,
      required String latitude,
      required String longitude,
      required String recNo,
      required String isSynched,
      required String premium}) async {
    var dbClient = await db;
    int res = await dbClient.rawInsert(
        'INSERT INTO "main"."coffeePurchase" ("purDate","season","batchNo","buyingCenter","farmerName","farmerId","farmerCode","farmName","farmId","coffeeType","coffeeVariety","coffeeGrade","noofBags","quantity","priceKilogram","totAmt","amtPaid","latitude","longitude","recNo","isSynched","premium") VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)',
        [
          purDate,
          season,
          batchNo,
          buyingCenter,
          farmerName,
          farmerId,
          farmerCode,
          farmName,
          farmId,
          coffeeType,
          coffeeVariety,
          coffeeGrade,
          noofBags,
          quantity,
          priceKilogram,
          totAmt,
          amtPaid,
          latitude,
          longitude,
          recNo,
          isSynched,
          premium
        ]);
    return res;
  }

  Future<int> savebatch(
    String recNo,
    String datebatch,
    String receiptno,
    String lotno,
    String isSynched,
    String latitude,
    String longitude,
  ) async {
    var dbClient = await db;

    int res = await dbClient.rawInsert(
        'INSERT INTO "main"."batchcreation" ("recNo", "datebatch", "receiptno", "lotno", "isSynched", "latitude","longitude") VALUES (?,?,?,?,?,?,?)',
        [recNo, datebatch, receiptno, lotno, isSynched, latitude, longitude]);
    return res;
  }

  Future<int> savetransferprmyprocss(
      {required String sender,
      required String reciver,
      required String datetransfer,
      required String vehiclenumber,
      required String drivername,
      required String isSynched,
      required String recNo,
      required String latitude,
      required String longitude,
      required String purRecieptNo,
      required String trRecieptNo,
      required String seasonCode}) async {
    var dbClient = await db;

    int res = await dbClient.rawInsert(
        'INSERT INTO "main"."transferPrimary" ("sender", "reciver", "datetransfer", "vehiclenumber", "drivername", "isSynched", "recNo", "latitude","longitude","purRecieptNo","trRecieptNo","seasonCode") VALUES (?,?,?,?,?,?,?,?,?,?,?,?)',
        [
          sender,
          reciver,
          datetransfer,
          vehiclenumber,
          drivername,
          isSynched,
          recNo,
          latitude,
          longitude,
          purRecieptNo,
          trRecieptNo,
          seasonCode
        ]);
    return res;
  }

  Future<int> transferprocessList(
      {required String recNo,
      required String batchnumbr,
      required String totalwght,
      required String numofbags,
      required String trRecieptNo,
      required String farmerName,
      required String farmerCode,
      required String farmName,
      required String coffeeType,
      required String coffeeVariety,
      required String coffeeGrade,
      required String tDate,
      required String vName,
      required String dName,
      required String TseasonCode,
      required String farmCode,
      required String buyingCenter,
      required String totBagTransfer,
      required String totWeightTransfer}) async {
    var dbClient = await db;

    int res = await dbClient.rawInsert(
        'INSERT INTO "main"."transferList" ("recNo", "batchnumbr", "totalwght", "numofbags","trRecieptNo","farmerName","farmerCode","farmName","coffeeType","coffeeVariety","coffeeGrade","tDate","vName","dName","exstStock","farmCode","buyingCenter","totalBagTransfer","totalWeightTransfer") VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)',
        [
          recNo,
          batchnumbr,
          totalwght,
          numofbags,
          trRecieptNo,
          farmerName,
          farmerCode,
          farmName,
          coffeeType,
          coffeeVariety,
          coffeeGrade,
          tDate,
          vName,
          dName,
          TseasonCode,
          farmCode,
          buyingCenter,
          totBagTransfer,
          totWeightTransfer
        ]);
    return res;
  }

  Future<int> saveInputDemand(
      String isSynched,
      String revNo,
      String msgNo,
      String date,
      String farmer,
      String inputType,
      String country,
      String district,
      String subcountry,
      String parish,
      String latitude,
      String longitude,
      String transType) async {
    var dbClient = await db;
    int res = await dbClient.rawInsert(
        'INSERT INTO "main"."inputDemand" ("recNo","isSynched","season","date","farmerOrg","inputType","country","district","subcountry","parish","latitude","longitude","transType") VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?)',
        [
          revNo,
          isSynched,
          msgNo,
          date,
          farmer,
          inputType,
          country,
          district,
          subcountry,
          parish,
          latitude,
          longitude,
          transType
        ]);

    return res;
  }

  Future<int> saveInputDemandDetail(
      String villageCode,
      String farmer,
      String gender,
      String age,
      String nin,
      String mobNo,
      String productCode,
      String demand,
      String recNo,
      String date,
      String inputType,
      String warehouseId,
      String farmId,
      String tottrees,
      String nooftrees) async {
    var dbClient = await db;
    int res = await dbClient.rawInsert(
        'INSERT INTO "main"."inputDemandDetail" ("village","farmer","gender","age","nin","mobNo","productCode","demand","recNo","date","inputType","warehouseId","farmId","tottrees","nooftrees") VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)',
        [
          villageCode,
          farmer,
          gender,
          age,
          nin,
          mobNo,
          productCode,
          demand,
          recNo,
          date,
          inputType,
          warehouseId,
          farmId,
          tottrees,
          nooftrees
        ]);

    return res;
  }

  Future<int> saveInputDistribution(
      String isSynched,
      String revNo,
      String msgNo,
      String date,
      String farmer,
      String inputType,
      String country,
      String district,
      String subcountry,
      String parish,
      String latitude,
      String longitude,
      String seasonCode,
      String transType) async {
    var dbClient = await db;
    int res = await dbClient.rawInsert(
        'INSERT INTO "main"."inputDistribution" ("recNo","isSynched","season","date","farmerOrg","inputType","country","district","subcountry","parish","latitude","longitude","seasonCode","transType") VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?)',
        [
          revNo,
          isSynched,
          msgNo,
          date,
          farmer,
          inputType,
          country,
          district,
          subcountry,
          parish,
          latitude,
          longitude,
          seasonCode,
          transType
        ]);

    return res;
  }

  Future<int> saveInputDistributionDetail(
      {required String villageCode,
      required String farmer,
      required String gender,
      required String age,
      required String nin,
      required String mobNo,
      required String productCode,
      required String demand,
      required String distribution,
      required String recNo,
      required String demBatchNo,
      required String demRecNo}) async {
    var dbClient = await db;
    int res = await dbClient.rawInsert(
        'INSERT INTO "main"."inputDistributionDetail" ("village","farmer","gender","age","nin","mobNo","productCode","demand","distributeQty","recNo","demBatchNo","demRecNo") VALUES (?,?,?,?,?,?,?,?,?,?,?,?)',
        [
          villageCode,
          farmer,
          gender,
          age,
          nin,
          mobNo,
          productCode,
          demand,
          distribution,
          recNo,
          demBatchNo,
          demRecNo
        ]);

    return res;
  }

  Future<int> saveReception(
      String isSynched,
      String revNo,
      String msgNo,
      String receiver,
      String receptiondate,
      String val_rcptNo,
      String tranferredDate,
      String vehicleNumber,
      String driverName,
      String latitude,
      String longitude,
      String seasoncode) async {
    var dbClient = await db;
    int res = await dbClient.rawInsert(
        'INSERT INTO "main"."reception" ("recNo","isSynched","msgNo","receiver","date","transferReceiptNo","transferDate","vehicleNo","driverName","latitude","longitude","seasonCode") VALUES (?,?,?,?,?,?,?,?,?,?,?,?)',
        [
          revNo,
          isSynched,
          msgNo,
          receiver,
          receptiondate,
          val_rcptNo,
          tranferredDate,
          vehicleNumber,
          driverName,
          latitude,
          longitude,
          seasoncode
        ]);

    return res;
  }

  Future<int> saveReceptionDetail(
      String purchaseReceiptNo,
      String farmerCode,
      String farm,
      String coffeeType,
      String coffeeVariety,
      String grade,
      String bagsTransferred,
      String weightTransferred,
      String bagsReceived,
      String weightReceived,
      String recNo,
      String receptiondate,
      String transferReceipt,
      String farmCode,
      String buyingCenter,
      String farmerName) async {
    var dbClient = await db;
    int res = await dbClient.rawInsert(
        'INSERT INTO "main"."receptionDetail" ("purchaseReceiptNo","farmerCode","farm","coffeeType","coffeeVariety","grade","bagsTransferred","weightTransferred","bagsReceived","weightReceived","recNo","tDate","trRecptNo","farmCode","buyingCenter","farmerName") VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)',
        [
          purchaseReceiptNo,
          farmerCode,
          farm,
          coffeeType,
          coffeeVariety,
          grade,
          bagsTransferred,
          weightTransferred,
          bagsReceived,
          weightReceived,
          recNo,
          receptiondate,
          transferReceipt,
          farmCode,
          buyingCenter,
          farmerName
        ]);

    return res;
  }

  Future<List<FarmerMaster>> GetFarmerdatavillage(farmerid) async {
    var dbClient = await db;
    List<Map> list1 = await dbClient.rawQuery('SELECT * FROM farmer_master ');
    List<Map> list = await dbClient.rawQuery(
        'SELECT * FROM farmer_master frmr inner join villageList vill on frmr.villageId=vill.villCode where  frmr.farmerId=\'' +
            farmerid +
            '\'');

    List<FarmerMaster> farmers = [];
    for (int i = 0; i < list.length; i++) {
      var farmerdata = new FarmerMaster(
          list[i]["farmerId"].toString(),
          list[i]["farmerCode"].toString(),
          list[i]["fName"].toString(),
          list[i]["lName"].toString(),
          list[i]["samithiCode"].toString(),
          list[i]["villageId"].toString(),
          list[i]["villageName"].toString(),
          list[i]["blockId"].toString(),
          list[i]["blockName"].toString(),
          list[i]["procurementBalance"].toString(),
          list[i]["distributionBalance"].toString(),
          list[i]["farmCount"].toString(),
          list[i]["cliName"].toString(),
          list[i]["proName"].toString(),
          list[i]["fCertType"].toString(),
          list[i]["certCategory"].toString(),
          list[i]["certStandard"].toString(),
          list[i]["inspecType"].toString(),
          list[i]["ICSstatus"].toString(),
          list[i]["certCatName"].toString(),
          list[i]["certStandName"].toString(),
          list[i]["insTypeName"].toString(),
          list[i]["ICSstatusName"].toString(),
          list[i]["principleAmount"].toString(),
          list[i]["interestAmtAccumulated"].toString(),
          list[i]["rateOfInterest"].toString(),
          list[i]["lastInterestCalDate"].toString(),
          list[i]["proPrincipleAmount"].toString(),
          list[i]["proInterestAmtAccumulate"].toString(),
          list[i]["proLastInterestCalDate"].toString(),
          list[i]["proRateOfInterest"].toString(),
          list[i]["traceId"].toString(),
          list[i]["fatherName"].toString(),
          list[i]["certifiedFarmer"].toString(),
          list[i]["surName"].toString(),
          list[i]["utzStatus"].toString(),
          list[i]["cooperative"].toString(),
          list[i]["farmerStatus"].toString(),
          list[i]["icsCode"].toString(),
          list[i]["icsCodeName"].toString(),
          list[i]["stateCode"].toString(),
          list[i]["districtCode"].toString(),
          list[i]["cityCode"].toString(),
          list[i]["panCode"].toString(),
          list[i]["mobileNo"].toString(),
          list[i]["frPhoto"].toString(),
          list[i]["idstatus"].toString(),
          list[i]["pltStatus"].toString(),
          list[i]["geoStatus"].toString(),
          list[i]["phoneNo"].toString(),
          list[i]["ctName"].toString(),
          list[i]["maritalStatus"].toString(),
          list[i]["farmerCertStatus_sym"].toString(),
          list[i]["dead"].toString(),
          list[i]["Inspection"].toString(),
          list[i]["trader"].toString(),
          list[i]["address"].toString(),
          list[i]["farmerIndicator"].toString());

      farmers.add(farmerdata);
    }

    return farmers;
  }

  Future<List<FarmerMaster>> GetFarmervilldata(villagecode) async {
    var dbClient = await db;
    List<Map> list1 = await dbClient.rawQuery('SELECT * FROM farmer_master ');
    List<Map> list = await dbClient.rawQuery(
        'SELECT * FROM farmer_master frmr inner join villageList vill on frmr.villageId=vill.villCode where  frmr.villageId=\'' +
            villagecode +
            '\' and frmr.blockId = "0"');

    List<FarmerMaster> farmers = [];
    for (int i = 0; i < list.length; i++) {
      var farmerdata = new FarmerMaster(
          list[i]["farmerId"].toString(),
          list[i]["farmerCode"].toString(),
          list[i]["fName"].toString(),
          list[i]["lName"].toString(),
          list[i]["samithiCode"].toString(),
          list[i]["villageId"].toString(),
          list[i]["villName"].toString(),
          list[i]["blockId"].toString(),
          list[i]["blockName"].toString(),
          list[i]["procurementBalance"].toString(),
          list[i]["distributionBalance"].toString(),
          list[i]["farmCount"].toString(),
          list[i]["cliName"].toString(),
          list[i]["proName"].toString(),
          list[i]["fCertType"].toString(),
          list[i]["certCategory"].toString(),
          list[i]["certStandard"].toString(),
          list[i]["inspecType"].toString(),
          list[i]["ICSstatus"].toString(),
          list[i]["certCatName"].toString(),
          list[i]["certStandName"].toString(),
          list[i]["insTypeName"].toString(),
          list[i]["ICSstatusName"].toString(),
          list[i]["principleAmount"].toString(),
          list[i]["interestAmtAccumulated"].toString(),
          list[i]["rateOfInterest"].toString(),
          list[i]["lastInterestCalDate"].toString(),
          list[i]["proPrincipleAmount"].toString(),
          list[i]["proInterestAmtAccumulate"].toString(),
          list[i]["proLastInterestCalDate"].toString(),
          list[i]["proRateOfInterest"].toString(),
          list[i]["traceId"].toString(),
          list[i]["fatherName"].toString(),
          list[i]["certifiedFarmer"].toString(),
          list[i]["surName"].toString(),
          list[i]["utzStatus"].toString(),
          list[i]["cooperative"].toString(),
          list[i]["farmerStatus"].toString(),
          list[i]["icsCode"].toString(),
          list[i]["icsCodeName"].toString(),
          list[i]["stateCode"].toString(),
          list[i]["districtCode"].toString(),
          list[i]["cityCode"].toString(),
          list[i]["panCode"].toString(),
          list[i]["mobileNo"].toString(),
          list[i]["frPhoto"].toString(),
          list[i]["idstatus"].toString(),
          list[i]["pltStatus"].toString(),
          list[i]["geoStatus"].toString(),
          list[i]["phoneNo"].toString(),
          list[i]["ctName"].toString(),
          list[i]["maritalStatus"].toString(),
          list[i]["farmerCertStatus_sym"].toString(),
          list[i]["dead"].toString(),
          list[i]["Inspection"].toString(),
          list[i]["trader"].toString(),
          list[i]["address"].toString(),
          list[i]["farmerIndicator"].toString());

      farmers.add(farmerdata);
    }

    return farmers;
  }

  Future<int> InputTypeDetail(
      {required String categoryCode,
      required String categoryName,
      required String productCode,
      required String productName}) async {
    var dbClient = await db;
    int res = await dbClient.rawInsert(
        'INSERT INTO "main"."inputType" ("categoryCode","categoryName","productCode","productName") VALUES (?,?,?,?)',
        [categoryCode, categoryName, productCode, productName]);

    return res;
  }

  Future<int> InputDemandDetail(
      {required String batchNo,
      required String village,
      required String farmerId,
      required String gender,
      required String age,
      required String nin,
      required String mobNo,
      required String product,
      required String inputType,
      required String demandQty,
      required String distQty,
      required String date,
      required String warehouseId,
      required String districtCode}) async {
    var dbClient = await db;
    int res = await dbClient.rawInsert(
        'INSERT INTO "main"."inputDemandList" ("batchNo","village","farmerId","gender","age","nin","mobNo","product","inputType","demandQty","distQty","date","warehouseId","districtCode") VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?)',
        [
          batchNo,
          village,
          farmerId,
          gender,
          age,
          nin,
          mobNo,
          product,
          inputType,
          demandQty,
          distQty,
          date,
          warehouseId,
          districtCode
        ]);

    return res;
  }

  Future<int> vCaRegListData(
      {required String vId,
      required String certNo,
      required String villName,
      required String villCode,
      required String applicationType,
      required String stockType,
      required String actCat,
      required String applicantName,
      required String regNo,
      required String phoneNo,
      required String email,
      required String address}) async {
    var dbClient = await db;
    int res = await dbClient.rawInsert(
        'INSERT INTO "main"."vcaRegListData" ("vId","certNo","villName","vilCode","applicationType","stockType","actCat","applicantName","applicantId","phoneNo","email","address") VALUES (?,?,?,?,?,?,?,?,?,?,?,?)',
        [
          vId,
          certNo,
          villName,
          villCode,
          applicationType,
          stockType,
          actCat,
          applicantName,
          regNo,
          phoneNo,
          email,
          address
        ]);

    return res;
  }

  Future<int> vcaData(
      {required String vid,
      required String regNo,
      required String mobNo,
      required String cerNo,
      required String applicantType,
      required String stockType,
      required String vilName,
      required String vilCode,
      required String applicantName,
      required String vcaCat}) async {
    var dbClient = await db;
    int res = await dbClient.rawInsert(
        'INSERT INTO "main"."vcaData" ("vid","regNo","cerNo","applicantType","stockType","vilName","vilCode","applicantName","vcaCat","mobNo") VALUES (?,?,?,?,?,?,?,?,?,?)',
        [
          vid,
          regNo,
          cerNo,
          applicantType,
          stockType,
          vilName,
          vilCode,
          applicantName,
          vcaCat,
          mobNo,
        ]);

    return res;
  }

  Future<int> nurserySeedGarden(
      {required String date,
      required String certificateNum,
      required String coffeeSeNuName,
      required String plottingMaterial,
      required String blackSoil,
      required String lakeSand,
      required String sawDust,
      required String soil,
      required String rootHormone,
      required String perforatedPots,
      required String relWaterSrc,
      required String floFacility,
      required String pulper,
      required String dryShed,
      required String stoFacility,
      required String photo,
      required String recommendations,
      required String suitableStatus,
      required String wellDrained,
      required String rootingCage,
      required String hardShed,
      required String demonPlot,
      required String sanitaryFac,
      required String offRecords,
      required String garDisposal,
      required String nurProShed,
      required String labIndiCoff,
      required String vegPhase,
      required String recCoffVar,
      required String recNo,
      required String isSynched,
      required String latitude,
      required String longitude,
      required String seasonCode,
      required String inspReqId,
      required String type,
      required String name,
      required String plotImp,
      required String blackImp,
      required String lakeImp,
      required String sawImp,
      required String soilImp,
      required String rootImp,
      required String perforatedImp,
      required String waterImp,
      required String floFacImp,
      required String pulperImp,
      required String dryShedImp,
      required String stoFacImp,
      required String wellDrainedImp,
      required String rootCageImp,
      required String hardShedImp,
      required String demPlotImp,
      required String sanFacImp,
      required String offRecImp,
      required String garDisImp,
      required String nurProImp,
      required String labelIndiImp,
      required String vegPhaseImp,
      required String recCoffImp,
      required String suitableStatusImp,
      required String villageId,
      required String pest,
      required String appl,
      required String pestImp,
      required String appImp,
      required String capacity,
      required String seedProcure}) async {
    var dbClient = await db;
    int res = await dbClient.rawInsert(
        'INSERT INTO "main"."coffeeSeedNursery" ("Date","certificateNum","coffeeSeNuName",'
        '"plottingMaterial","blackSoil","lakeSand","sawDust","soil","rootHormone",'
        '"perforatedPots","relWaterSrc","floFacility","pulper","dryShed","stoFacility",'
        '"photo","recommendation","suitableStatus","wellDrained","rootingCage","hardShed",'
        '"demonPlot","sanitaryFac","offRecords","garDisposal","nurProShed","labIndiCoff",'
        '"vegPhase","recCoffVar","recNo","isSynched","latitude","longitude","seasonCode","inspReqId",'
        '"type","name","plotImp","blackImp","lakeImp","sawImp","soilImp","rootImp","perforatedImp",'
        '"waterImp","floFacImp","pulperImp","dryShedImp","stoFacImp","wellDrainedImp","rootCageImp",'
        '"hardShedImp","demPlotImp","sanFacImp","offRecImp","garDisImp","nurProImp","labelIndiImp","vegPhaseImp","recCoffImp","villageId","suitableSts", "pest", "appl", "pestImp", "appImp","capacity","seedProcure") VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)',
        [
          date,
          certificateNum,
          coffeeSeNuName,
          plottingMaterial,
          blackSoil,
          lakeSand,
          sawDust,
          soil,
          rootHormone,
          perforatedPots,
          relWaterSrc,
          floFacility,
          pulper,
          dryShed,
          stoFacility,
          photo,
          recommendations,
          suitableStatus,
          wellDrained,
          rootingCage,
          hardShed,
          demonPlot,
          sanitaryFac,
          offRecords,
          garDisposal,
          nurProShed,
          labIndiCoff,
          vegPhase,
          recCoffVar,
          recNo,
          isSynched,
          latitude,
          longitude,
          seasonCode,
          inspReqId,
          type,
          name,
          plotImp,
          blackImp,
          lakeImp,
          sawImp,
          soilImp,
          rootImp,
          perforatedImp,
          waterImp,
          floFacImp,
          pulperImp,
          dryShedImp,
          stoFacImp,
          wellDrainedImp,
          rootCageImp,
          hardShedImp,
          demPlotImp,
          sanFacImp,
          offRecImp,
          garDisImp,
          nurProImp,
          labelIndiImp,
          vegPhaseImp,
          recCoffImp,
          villageId,
          suitableStatusImp,
          pest,
          appl,
          pestImp,
          appImp,
          capacity,
          seedProcure
        ]);

    return res;
  }

  Future<int> inspReqData(
      {required String insVill,
      required String insId,
      required String insParish,
      required String insName,
      required String stockType,
      required String insCerNo,
      required String insType,
      required String insSubCnt,
      required String insDist,
      required String insAppName,
      required String insUniqueId}) async {
    var dbClient = await db;
    int res = await dbClient.rawInsert(
        'INSERT INTO "main"."inspReqData" ("insVill","insId","insParish","insName","stockType","insCerNo","insType","insSubCnt","insDist","insAppName","insUniqueId") VALUES (?,?,?,?,?,?,?,?,?,?,?)',
        [
          insVill,
          insId,
          insParish,
          insName,
          stockType,
          insCerNo,
          insType,
          insSubCnt,
          insDist,
          insAppName,
          insUniqueId
        ]);

    return res;
  }

  /*primary processing*/

  Future<int> primaryProcessing(
      {required String recNo,
      required String latitude,
      required String longitude,
      required String isSynched,
      required String date,
      required String batchNo,
      required String customer,
      required String dateStarted,
      required String timeStarted,
      required String dateFinished,
      required String timeFinished,
      required String preClean,
      required String stones,
      required String wasteGrade,
      required String totalWBags,
      required String reject1899,
      required String reject1599,
      required String reject1299,
      required String reject1199,
      required String totalGBags,
      required String processType,
      required String seasonCode,
      required String skuType,
      required String wnoBag,
      required String gnoBag}) async {
    var dbClient = await db;
    int res = await dbClient.rawInsert(
        'INSERT INTO "main"."primaryProcessing" ("recNo","latitude","longitude","isSynched","date","batchNo","customer","dateStarted","timeStarted","dateFinished","timeFinished","preClean","stones","wasteGrade","totalWBags","reject1899","reject1599","reject1299","reject1199","totalGBags","processType","seasonCode","skuType","wnoBag","gnoBag") VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)',
        [
          recNo,
          latitude,
          longitude,
          isSynched,
          date,
          batchNo,
          customer,
          dateStarted,
          timeStarted,
          dateFinished,
          timeFinished,
          preClean,
          stones,
          wasteGrade,
          totalWBags,
          reject1899,
          reject1599,
          reject1299,
          reject1199,
          totalGBags,
          processType,
          seasonCode,
          skuType,
          wnoBag,
          gnoBag
        ]);

    return res;
  }

  Future<int> primaryProcessingDetail(
      {required String grade,
      required String avlBags,
      required String avlKgs,
      required String inputBags,
      required String inputKgs,
      required String inputTotal,
      required String outputBags,
      required String outputKgs,
      required String outputTotal,
      required String recNo,
      required String processBatchNo,
      required String outputTotalBag,
      required String outputTotalKg,
      required String exporterName,
      required String exporterId,
      required String processType}) async {
    var dbClient = await db;
    int res = await dbClient.rawInsert(
        'INSERT INTO "main"."primaryProcessingDetail" ("grade","avlBags","avlKgs","inputBags","inputKgs","inputTotal","outputBags","outputKgs","outputTotal","recNo","processBatchNo","outputTotalBag","outputTotalKg","exporterName","exporterId","processType") VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)',
        [
          grade,
          avlBags,
          avlKgs,
          inputBags,
          inputKgs,
          inputTotal,
          outputBags,
          outputKgs,
          outputTotal,
          recNo,
          processBatchNo,
          outputTotalBag,
          outputTotalKg,
          exporterName,
          exporterId,
          processType
        ]);

    return res;
  }

  Future<int> batchCreationList(
      {required String noOfBags,
      required String batchNo,
      required String stockType,
      required String grade,
      required String weight,
      required String driName,
      required String vehNo,
      required String primRecNo,
      required String expPurRecNo,
      required String expRecNo,
      required String noBagTransferred,
      required String totWtTransferred,
      required String noBagRecieved,
      required String totWtRecieved,
      required String inputBag,
      required String inputKg,
      required String outputBag,
      required String outputKg,
      required String totalBag,
      required String totalKg,
      required String avlBag,
      required String avlKg,
      required String isDelete}) async {
    var dbClient = await db;
    int res = await dbClient.rawInsert(
        'INSERT INTO "main"."batchCreationList" ("noOfBag","batchNo","stockType","grade","weight","driName","vehNo","primRecNo","expPurRecNo","expRecNo","noBagTransferred","totWtTransferred","noBagRecieved","totWtRecieved","inputBag","inputKg","outputBag","outputKg","totalBag","totalKg","avlBag","avlKg","isDelete") VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)',
        [
          noOfBags,
          batchNo,
          stockType,
          grade,
          weight,
          driName,
          vehNo,
          primRecNo,
          expPurRecNo,
          expRecNo,
          noBagTransferred,
          totWtTransferred,
          noBagTransferred,
          totWtTransferred,
          inputBag,
          inputKg,
          outputBag,
          outputKg,
          totalBag,
          totalKg,
          avlBag,
          avlKg,
          isDelete
        ]);

    return res;
  }

  Future<int> exporterPurchase(
      {required String purDate,
      required String exporter,
      required String batchNo,
      required String coffGrade,
      required String exstBag,
      required String exstStk,
      required String noBag,
      required String totWt,
      required String trRecNo,
      required String vehNo,
      required String driNo,
      required String recNo,
      required String isSynched,
      required String latitude,
      required String longitude,
      required String seasonCode}) async {
    var dbClient = await db;
    int res = await dbClient.rawInsert(
        'INSERT INTO "main"."exporterPurchase" ("purDate","exporter","batchNo","coffGrade","exstBag","exstStk","noBag","totWt","trRecNo","vehNo","driNo","recNo","isSynched","latitude","longitude","seasonCode") VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)',
        [
          purDate,
          exporter,
          batchNo,
          coffGrade,
          exstBag,
          exstStk,
          noBag,
          totWt,
          trRecNo,
          vehNo,
          driNo,
          recNo,
          isSynched,
          latitude,
          longitude,
          seasonCode
        ]);

    return res;
  }

  Future<int> exporterPurchaseDetail(
      {required String batchNo,
      required String coffGrade,
      required String exstBag,
      required String exstStk,
      required String noBag,
      required String totWt,
      required String trRecNo,
      required String recNo,
      required String stockType,
      required String trDate,
      required String vName,
      required String dName,
      required String exporterName,
      required String exporterId}) async {
    var dbClient = await db;
    int res = await dbClient.rawInsert(
        'INSERT INTO "main"."exporterPurchaseDetail" ("batchNo","coffGrade","exstBag","exstStk","noBag","totWt","trRecNo","recNo","stockType","trDate","vName","dName","exporterName","exporterId") VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?)',
        [
          batchNo,
          coffGrade,
          exstBag,
          exstStk,
          noBag,
          totWt,
          trRecNo,
          recNo,
          stockType,
          trDate,
          vName,
          dName,
          exporterName,
          exporterId
        ]);

    return res;
  }

  Future<int> exporterReception(
      {required String reciever,
      required String date,
      required String trRecNo,
      required String trDate,
      required String vehNo,
      required String driNo,
      required String batchNo,
      required String recNo,
      required String isSynched,
      required String latitude,
      required String longitude,
      required String seasonCode}) async {
    var dbClient = await db;
    int res = await dbClient.rawInsert(
        'INSERT INTO "main"."exporterReception" ("reciever","date","trRecNo","trDate","vehNo","driNo","batchNo","recNo","isSynched","latitude","longitude","seasonCode") VALUES (?,?,?,?,?,?,?,?,?,?,?,?)',
        [
          reciever,
          date,
          trRecNo,
          trDate,
          vehNo,
          driNo,
          batchNo,
          recNo,
          isSynched,
          latitude,
          longitude,
          seasonCode
        ]);

    return res;
  }

  Future<int> exporterReceptionDetail(
      {required String batchNo,
      required String grade,
      required String noBag,
      required String totWt,
      required String noBagRec,
      required String totWtRec,
      required String recNo,
      required String stockType}) async {
    var dbClient = await db;
    int res = await dbClient.rawInsert(
        'INSERT INTO "main"."exporterReceptionDetail" ("batchNo","grade","noBag","totWt","noBagRec","totWtRec","recNo","stockType") VALUES (?,?,?,?,?,?,?,?)',
        [batchNo, grade, noBag, totWt, noBagRec, totWtRec, recNo, stockType]);

    return res;
  }

  Future<int> editFarmerDetail(
      {required String isSynched,
      required String recNo,
      required String farmerId,
      required String latitude,
      required String longitude,
      required String farmerTimeStamp,
      required String gender,
      required String dob,
      required String age,
      required String address,
      required String phoneNumber,
      required String firstName,
      required String otherName,
      required String nameOwner,
      required String addressOwner,
      required String idType,
      required String nationalId,
      required String district,
      required String division,
      required String parish,
      required String village,
      required String country,
      required String memOrgCode,
      required String memOrgName,
      required String memOrg}) async {
    var dbClient = await db;
    int res = await dbClient.rawInsert(
        'INSERT INTO "main"."edit_farmer" ("isSynched","recId","farmerId","farmerlatitude","farmerlongitude","farmertimeStamp","fingerPrint","idProofVal","idProof","pltStatus","farmerMobile","firstName","othName","nameOwner","addOwner","idType","idNumber","district","subcounty","parish","village","country","memOrgCode","memOrgName","memOrg") VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)',
        [
          isSynched,
          recNo,
          farmerId,
          latitude,
          longitude,
          farmerTimeStamp,
          gender,
          dob,
          age,
          address,
          phoneNumber,
          firstName,
          otherName,
          nameOwner,
          addressOwner,
          idType,
          nationalId,
          district,
          division,
          parish,
          village,
          country,
          memOrgCode,
          memOrgName,
          memOrg
        ]);

    return res;
  }

  Future<int> editFarm(
      {required String isSynched,
      required String recNo,
      required String latitude,
      required String longitude,
      required String farmTimeStamp,
      required String spacingTree,
      required String totCoffAcr,
      required String decCoffArea,
      required String avgAgeTree,
      required String numShadeTree,
      required String typShadeTree,
      required String numProdTree,
      required String numUnProdTree,
      required String yeildEstTree,
      required String farmId,
      required String farmName,
      required String village,
      required String totNumTrees}) async {
    var dbClient = await db;
    int res = await dbClient.rawInsert(
        'INSERT INTO "main"."edit_farmer" ("isSynched","recId","farmerlatitude","farmerlongitude","farmertimeStamp","spacingTree","totCoffAcr","decCoffArea","avgAgeTree","numShadeTree","typShadeTree","numProdTree","numUnProdTree","yeildEstTree","farmId","farmProduction","village","idProofLatitude") VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)',
        [
          isSynched,
          recNo,
          latitude,
          longitude,
          farmTimeStamp,
          spacingTree,
          totCoffAcr,
          decCoffArea,
          avgAgeTree,
          numShadeTree,
          typShadeTree,
          numProdTree,
          numUnProdTree,
          yeildEstTree,
          farmId,
          farmName,
          village,
          totNumTrees
        ]);

    return res;
  }

  Future<int> nurseryReg(
      {required String nurId,
      required String mobileNum,
      required String address,
      required String mail,
      required String city,
      required String opName,
      required String district,
      required String fullName,
      required String state,
      required String village,
      required String appliType}) async {
    var dbClient = await db;
    int res = await dbClient.rawInsert(
        'INSERT INTO "main"."nurseryReg" ("nurId","mobileNum","address","mail","city","opName","district","fullName","state","village","appliType") VALUES (?,?,?,?,?,?,?,?,?,?,?)',
        [
          nurId,
          mobileNum,
          address,
          mail,
          city,
          opName,
          district,
          fullName,
          state,
          village,
          appliType
        ]);

    return res;
  }

  Future<int> saveLocation(
      {required String latitude,
      required String longitude,
      required String txntime,
      required String orderId,
      required String recNo,
      required String status,
      required String isSynched}) async {
    var dbClient = await db;
    int res = await dbClient.rawInsert(
        'INSERT INTO "main"."location" ("latitude","longitude","timeStamp","orderId","recNo","status","isSynched") VALUES (?,?,?,?,?,?,?)',
        [latitude, longitude, txntime, orderId, recNo, status, isSynched]);

    return res;
  }

  Future<int> saveDraftTable(
      {required String recNu,
      required String village,
      required String farmerId,
      required String componentId,
      required String compVal,
      required String menuId,
      required String compType,
      required String txnId,
      required String sectionId,
      required String isMandatory,
      required String componentLabel,
      required String parentField,
      required String dependencyField,
      required String parentDependency,
      required String ifListFld,
      required String selectedValue,
      required String districtCode,
      required String districtName,
      required String subCountyCode,
      required String subCountyName,
      required String parishCode,
      required String parishName,
      required String villageName,
      required String farmerName,
      required String date}) async {
    var dbClient = await db;

    int res = await dbClient.rawInsert(
        'INSERT INTO "main"."trainingDraftTable" ("RecNo","village","farmerId","componentId","compVal","menuId","compType","txnId","sectionId","isMandatory","componentLabel","parentField","dependencyField","parentDependency","ifListFld","selectedValue","districtCode","districtName","subCountyCode","subCountyName","parishCode","parishName","villageName","farmerName","date") VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)',
        [
          recNu,
          village,
          farmerId,
          componentId,
          compVal,
          menuId,
          compType,
          txnId,
          sectionId,
          isMandatory,
          componentLabel,
          parentField,
          dependencyField,
          parentDependency,
          ifListFld,
          selectedValue,
          districtCode,
          districtName,
          subCountyCode,
          subCountyName,
          parishCode,
          parishName,
          villageName,
          farmerName,
          date
        ]);
    return res;
  }

  Future<int> saveTrainingImageDraft(
      {required String imageTime,
      required String imageUrl,
      required String imageLat,
      required String imageLon,
      required String sectionId,
      required String gloPopupId,
      required String listIteration,
      required String txnTypeId,
      required String recNo,
      required String cameraExist}) async {
    var dbClient = await db;

    int res = await dbClient.rawInsert(
        'INSERT INTO "main"."trainingImageDraft" ("imageTime","imageUrl","imageLat","imageLon","sectionId","glo_popupId","listIteration","txnTypeId","recNo","cameraExist") VALUES (?,?,?,?,?,?,?,?,?,?)',
        [
          imageTime,
          imageUrl,
          imageLat,
          imageLon,
          sectionId,
          gloPopupId,
          listIteration,
          txnTypeId,
          recNo,
          cameraExist
        ]);
    return res;
  }

  Future<int> saveListPartialDraft({
    required String recNo,
    required String listId,
    required String iteration,
    required String section,
    required String label,
    required String textControllerValue,
    required String date,
    required String other,
  }) async {
    var dbClient = await db;

    int res = await dbClient.rawInsert(
        'INSERT INTO "main"."listPartial" ("recNo","listId","iteration","section","label","textControllerValue","date","other") VALUES (?,?,?,?,?,?,?,?)',
        [
          recNo,
          listId,
          iteration,
          section,
          label,
          textControllerValue,
          date,
          other
        ]);
    return res;
  }

  Future<int> saveActivity(
      {required String activityVal,
      required String activityDes,
      required String date,
      required String recNo,
      required String isSynched,
      required String latitude,
      required String longitude,
      required String txnTime,
      required String timeStarted,
      required String timeFinished}) async {
    var dbClient = await db;

    int res = await dbClient.rawInsert(
        'INSERT INTO "main"."activityMenu" ("activityVal","activityDes","date","recNo","isSynched","latitude","longitude","txnTime","timeStarted","timeFinished") VALUES (?,?,?,?,?,?,?,?,?,?)',
        [
          activityVal,
          activityDes,
          date,
          recNo,
          isSynched,
          latitude,
          longitude,
          txnTime,
          timeStarted,
          timeFinished
        ]);
    return res;
  }

  Future<int> saveNameData({
    required String districtName,
    required String subCountyName,
    required String parishName,
    required String villageName,
    required String coffeeFarmEquipments,
    required String postHarvestFacilities,
    required String date,
    required String other,
  }) async {
    var dbClient = await db;

    int res = await dbClient.rawInsert(
        'INSERT INTO "main"."harvestData" ("farmCrop","harvestedQty","harvestedDate","buyerName","harvestedAmt","cropPhoto","farmId","farmerId") VALUES (?,?,?,?,?,?,?,?)',
        [
          districtName,
          subCountyName,
          parishName,
          villageName,
          coffeeFarmEquipments,
          postHarvestFacilities,
          date,
          other
        ]);
    return res;
  }

  Future<int> saveCatData(
      {required String type,
      required String varieties,
      required String typShTree,
      required String goodAgri,
      required String liveStock,
      required String landTopo,
      required String landGr,
      required String accRoad,
      required String certProgram,
      required String othCrop,
      required String soilType,
      required String fertStatus,
      required String irrSource,
      required String methIrri,
      required String watHarvest,
      required String plDate,
      required String prDate}) async {
    var dbClient = await db;

    int res = await dbClient.rawInsert(
        'INSERT INTO "main"."catName" ("type","varieties","typShTrees","goodAgri","liveStock","landTopo","landGr","accRoad","certProgram","othCrop","soilType","fertStatus","irrSource","methIrri","watHarvest","plDate","prDate") VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)',
        [
          type,
          varieties,
          typShTree,
          goodAgri,
          liveStock,
          landTopo,
          landGr,
          accRoad,
          certProgram,
          othCrop,
          soilType,
          fertStatus,
          irrSource,
          methIrri,
          watHarvest,
          plDate,
          prDate
        ]);
    return res;
  }

  Future<int> saveCountry(
      {required String wareHouseCode,
      required String wareHouseName,
      required String wareHouseCity}) async {
    var dbClient = await db;

    int res = await dbClient.rawInsert(
        'INSERT INTO "main"."wareHouseList" ("wareHouseCode","wareHouseName","wareHouseCity") VALUES (?,?,?)',
        [wareHouseCode, wareHouseName, wareHouseCity]);
    return res;
  }
}
