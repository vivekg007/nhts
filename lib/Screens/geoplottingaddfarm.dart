import 'dart:async';
import 'dart:collection';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../main.dart';
import '../Model/GeoAreacalculateFarm.dart';
import '../Model/GeoPloattingModel.dart';
import '../Model/dynamicfields.dart';
import '../login.dart';

List<GeoPloattingModel> Geoploattingaddfarmlist = [];
List<GeoPloattingModel> GeoploattingsddProposedlist = [];
List<GeoareascalculateFarm> Geoareascalculateaddfarm = [];
List<GeoareascalculateFarm> GeoareascalculateaddProposed = [];
GeoareascalculateFarm? addFarmdata;
GeoareascalculateFarm? Proposeddata;
bool intermediateonlick = false;
bool endonclick = false;
bool startClick = false;
bool calculatearea = false;

bool intialend = false;

bool editlatlng = false;
bool deletelatlng = false;
bool areacalculatesuccess = false;
bool isTranslation = false;
String Lat = '0', Lng = '0';
String hectareAre = "";
List<LatLng> polygonLatLngs = [];
List<LatLng> streamLocation = [];

Set<Polygon> _polygons = HashSet<Polygon>();

class geoploattingaddFarm extends StatefulWidget {
  int type;

  geoploattingaddFarm(this.type);
  @override
  geoploattingaddScreen createState() => geoploattingaddScreen();
}

class geoploattingaddScreen extends State<geoploattingaddFarm>
    with SingleTickerProviderStateMixin {
  List<GeoPloattingModel> geoploattingfarmlist = [];
  TabController? _controller;
  int _currentIndex = 0;
  int orderofGps = 0;
  int onpressCount = 0;
  bool visibilityTag = false;
  String? cnfor = 'Confirmation';
  String? resetGps = 'Do you want to reset the GPS details';
  String? cancel = 'Cancel';
  String? ok = 'OK';
  String? prevLoc =
      "Previously captured location(s) will be removed. Do you want to proceed?";
  String? sureCancel = 'Are you sure want to cancel?';
  String? yes = 'Yes';
  String? no = 'No';
  String? areaCalc = 'Area Calculation';

  @override
  void initState() {
    super.initState();
    translate();
    Lat = '0';
    hectareAre = "0";
    intermediateonlick = false;
    endonclick = false;
    startClick = false;
    calculatearea = false;
    areacalculatesuccess = false;
  }

  void getLocation(String State, int OrderofGps) async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    print("latitude_A:" +
        position.latitude.toString() +
        " longitude_B" +
        position.longitude.toString());
    setState(() {
      Lat = position.latitude.toString();
      Lng = position.longitude.toString();
      addListItems(Lat, Lng, State, OrderofGps);
    });
  }

  Future<String?> addListItems(
      String Lat, String Lng, String State, int OrderofGps) async {
    setState(() {
      GeoPloattingModel data;
      data = new GeoPloattingModel(Lat, Lng, State, OrderofGps);
      polygonLatLngs.add(LatLng(double.parse(Lat), double.parse(Lng)));
      geoploattingfarmlist.add(data);
      print("objlocateListCHECK " + geoploattingfarmlist.length.toString());
    });
  }

  confirmationReset(dialogContext) {
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
        context: dialogContext,
        style: alertStyle,
        title: cnfor,
        desc: resetGps,
        buttons: [
          DialogButton(
            child: Text(
              cancel!,
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            //onPressed:btncancel ,
            onPressed: () {
              setState(() {
                Lat = "0";
                _controller!.animateTo(0);
                Navigator.pop(context);
                Navigator.pop(context);
              });
            },
            color: Colors.deepOrange,
          ),
          DialogButton(
            child: Text(
              ok!,
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            onPressed: () {
              setState(() {
                Lat = "0";
                _controller!.animateTo(1);
                Navigator.pop(context);
                Navigator.pop(context);
              });
            },
            color: Colors.green,
          )
        ]).show();
  }

  clearLocationAlertmap(dialogContext) {
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
        context: dialogContext,
        style: alertStyle,
        title: cnfor,
        desc: prevLoc,
        buttons: [
          DialogButton(
            child: Text(
              ok!,
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            //onPressed:btncancel ,
            onPressed: () {
              setState(() {
                hectareAre = "0";
                _controller!.animateTo(0);
                Navigator.pop(context);
                Navigator.pop(context);
              });
            },
            color: Colors.deepOrange,
          ),
          DialogButton(
            child: Text(
              cancel!,
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            //onPressed:btncancel ,
            onPressed: () {
              setState(() {
                hectareAre = "0";
                _controller!.animateTo(1);
                Navigator.pop(context);
                Navigator.pop(context);
              });
            },
            color: Colors.deepOrange,
          ),
        ]).show();
  }

  @override
  void dispose() {
    _controller?.dispose();
    Lat = '0';
    hectareAre = '0';
    super.dispose();
  }

  String? Hectare;
  String? areas;

  Future<bool> onBackPressed() async {
    return (await Alert(
          context: context,
          type: AlertType.warning,
          title: cancel!,
          desc: sureCancel!,
          buttons: [
            DialogButton(
              child: Text(
                yes!,
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
                no!,
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
    // TODO: implement build
    return SafeArea(
        child: WillPopScope(
      onWillPop: onBackPressed,
      child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            centerTitle: true,
            leading: IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () {
                  setState(() {
                    onBackPressed();
                  });
                }),
            title: Text(
              areaCalc!,
              style: new TextStyle(
                  color: Colors.white,
                  fontSize: 18.0,
                  fontWeight: FontWeight.w700),
            ),
            iconTheme: IconThemeData(color: Colors.white),
            backgroundColor: Colors.green,
            brightness: Brightness.light,
          ),
          body: Container(child: Manualmodegps(widget.type))),
    ));
  }

  void translate() async {
    String? Lang = '';
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      Lang = prefs.getString("langCode");
      print("addfarm_Lang: " + Lang!);
    } catch (e) {
      Lang = 'en';
    }

    String qry =
        'select className,labelName from labelNamechange where tenantID =  \'coopbank\' and lang = \'' +
            Lang +
            '\'';
    List transList = await db.RawQuery(qry);
    print('addfarmlist :' + transList.toString());

    for (int i = 0; i < transList.length; i++) {
      String? classname = transList[i]['className'];
      String? labelName = transList[i]['labelName'];

      switch (classname) {
        case "prevLoc":
          setState(() {
            prevLoc = labelName!;
          });
          break;
        case "cnfor":
          setState(() {
            cnfor = labelName!;
          });
          break;
        case "resetGps":
          setState(() {
            resetGps = labelName!;
          });
          break;
        case "cancel":
          setState(() {
            cancel = labelName!;
          });
          break;
        case "ok":
          setState(() {
            ok = labelName!;
          });
          break;
        case "sureCancel":
          setState(() {
            sureCancel = labelName!;
          });
          break;
        case "yes":
          setState(() {
            yes = labelName!;
          });
          break;
        case "no":
          setState(() {
            no = labelName!;
          });
          break;
        case "areaCalc":
          setState(() {
            areaCalc = labelName!;
          });
          break;
      }
    }

    setState(() {
      isTranslation = true;
    });
  }
}

class Manualmodegps extends StatelessWidget {
  int type;

  Manualmodegps(this.type);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ManualmodegpsTabBar(type),
      ),
    );
  }
}

class ManualmodegpsTabBar extends StatefulWidget {
  int type;

  ManualmodegpsTabBar(this.type);
  @override
  _ManualmodegpsTabBarState createState() => _ManualmodegpsTabBarState(type);
}

class _ManualmodegpsTabBarState extends State<ManualmodegpsTabBar> {
  void initState() {
    super.initState();
    translate();
    GetStreamLocation();
  }

  List<GeoPloattingModel> geoploattingfarmlist = [];
  List<GeoareascalculateFarm?> geoareascalculatefarm = [];
  GeoareascalculateFarm? addfarmdata;
  bool visibilityTag = false;
  bool visibilityareaTag = false;
  int orderofGps = 0;
  int onpressCount = 0;
  int intermediatelistcount = 0;
  String manGps = 'Manual Mode GPS';
  String resetGps = 'Do you want to reset the GPS details';
  String prevLoc =
      "Previously captured location(s) will be removed. Do you want to proceed?";
  String calArea = 'Calculated Area';
  String calculateArea = 'Calculate Area';
  String start = 'Start';
  String intrmed = 'Intermediate';
  String plsInit =
      'Please Initiate Using Start button and then Proceed for Intermediate points';
  String end = 'End';
  String plsinitIntrmed =
      'Please Initiate Using intermediate button and then Proceed for End points';
  String prcdAreacal =
      'Do you want to end and proceed to the Area calculation?';
  String areaCalsucc = 'Area Calculated Successfully';
  String hectare = 'Hectare(s)';
  String cnfmCalarea = 'Do you want to confirm the calculated Area ?';
  String areaZero = "Calculated Area should not be Empty or Zero";
  String plsMark =
      'Please mark the Coordinates for all the Stages (Start, Intermediate, End)';
  String ruDel = 'Are you sure want to Delete ?';
  String acre = 'Acre';
  String sqm = 'Square Meters';
  String info = 'Information';
  String submit = 'Submit';
  String cancel = 'Cancel';
  String cnfor = 'Confirmation';
  String sureCancel = 'Are you sure want to cancel?';
  String yes = 'Yes';
  String no = 'No';
  String ok = 'OK';
  String state = 'State';
  String lat = "Latitude";
  String lan = "Longitude";
  String edit = "Edit";
  String Delete = "Delete";
  String ruEdit = 'Are you sure want to edit the GPS value?';
  int type;

  _ManualmodegpsTabBarState(this.type);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          _showForm(),
        ],
      ),
    );
  }

  void translate() async {
    String? Lang = '';
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      Lang = prefs.getString("langCode");
      print("addfarm_Lang: " + Lang!);
    } catch (e) {
      Lang = 'en';
    }

    String qry =
        'select className,labelName from labelNamechange where tenantID =  \'coopbank\' and lang = \'' +
            Lang +
            '\'';
    List transList = await db.RawQuery(qry);
    print('addfarmlist :' + transList.toString());

    for (int i = 0; i < transList.length; i++) {
      String? classname = transList[i]['className'];
      String? labelName = transList[i]['labelName'];

      switch (classname) {
        case "prevLoc":
          setState(() {
            prevLoc = labelName!;
          });
          break;
        case "calArea":
          setState(() {
            calArea = labelName!;
          });
          break;
        case "calculateArea":
          setState(() {
            calculateArea = labelName!;
          });
          break;
        case "start":
          setState(() {
            start = labelName!;
          });
          break;
        case "intrmed":
          setState(() {
            intrmed = labelName!;
          });
          break;
        case "plsInit":
          setState(() {
            plsInit = labelName!;
          });
          break;
        case "end":
          setState(() {
            end = labelName!;
          });
          break;
        case "areaCalsucc":
          setState(() {
            areaCalsucc = labelName!;
          });
          break;
        case "hectare":
          setState(() {
            hectare = labelName!;
          });
          break;
        case "cnfmCalarea":
          setState(() {
            cnfmCalarea = labelName!;
          });
          break;
        case "areaZero":
          setState(() {
            areaZero = labelName!;
          });
          break;
        case "plsMark":
          setState(() {
            plsMark = labelName!;
          });
          break;
        case "ruDel":
          setState(() {
            ruDel = labelName!;
          });
          break;
        case "acre":
          setState(() {
            acre = labelName!;
          });
          break;
        case "sqm":
          setState(() {
            sqm = labelName!;
          });
          break;
        case "info":
          setState(() {
            info = labelName!;
          });
          break;
        case "submit":
          setState(() {
            submit = labelName!;
          });
          break;
        case "cancel":
          setState(() {
            cancel = labelName!;
          });
          break;
        case "cnfor":
          setState(() {
            cnfor = labelName!;
          });
          break;
        case "sureCancel":
          setState(() {
            sureCancel = labelName!;
          });
          break;
        case "yes":
          setState(() {
            yes = labelName!;
          });
          break;
        case "no":
          setState(() {
            no = labelName!;
          });
          break;
        case "ok":
          setState(() {
            ok = labelName!;
          });
          break;
        case "state":
          setState(() {
            state = labelName!;
          });
          break;
        case "lat":
          setState(() {
            lat = labelName!;
          });
          break;
        case "lan":
          setState(() {
            lan = labelName!;
          });
          break;
        case "edit":
          setState(() {
            edit = labelName!;
          });
          break;
        case "Delete":
          setState(() {
            Delete = labelName!;
          });
          break;
        case "ruEdit":
          setState(() {
            ruEdit = labelName!;
          });
          break;
      }
    }

    setState(() {
      isTranslation = true;
    });
  }

  Widget _showForm() {
    return new Container(
        child: new Form(
      child: new ListView(
        shrinkWrap: true,
        physics: const AlwaysScrollableScrollPhysics(),
        children: <Widget>[
          showLabelwidget(),
          showStartButton(),
          showIntermediateButton(),
          showEndButton(),
          showCalulateareaButton(),
          showanotherLabelwidget(),
          showareaTable(),
          showButtons(context),
          showTable(geoploattingfarmlist),
        ],
      ),
    ));
  }

  Widget showLabelwidget() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10.0, 30.0, 0.0, 0.0),
      child: new Text(
        calculateArea,
        style: new TextStyle(
            color: Colors.black54, fontSize: 20.0, fontWeight: FontWeight.w700),
      ),
    );
  }

  Widget showStartButton() {
    return new Padding(
        padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0.0),
        child: SizedBox(
          height: 40.0,
          child: new RaisedButton(
            elevation: 5.0,
            shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(10.0)),
            color: Colors.blue,
            child: new Text(start,
                style: new TextStyle(fontSize: 18.0, color: Colors.white)),
            onPressed: () async {
              setState(() {
                if (endonclick || startClick) {
                  print("iflat");
                  //showAlertDialog(context, State);
                  if (Lat != "0") {
                    print("lating");
                    clearLocationAlert(context);
                  }
                } else {
                  print("elflat");
                  int orderofgps = orderofGps + 1;
                  orderofGps = orderofgps;
                  visibilityTag = true;

                  getLocation("Start", orderofGps);
                  startClick = true;
                }
              });
            },
          ),
        ));
  }

  Widget showIntermediateButton() {
    return new Padding(
        padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0.0),
        child: SizedBox(
          height: 40.0,
          child: new RaisedButton(
              elevation: 5.0,
              shape: new RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(10.0)),
              color: Colors.blue,
              child: new Text(intrmed,
                  style: new TextStyle(fontSize: 18.0, color: Colors.white)),
              onPressed: () async {
                setState(() {
                  int intermediatelist = 0;
                  intermediateonlick = true;
                  if (!endonclick) {
                    if (!intermediateonlick) {
                      int orderofgps = orderofGps + 1;
                      orderofGps = orderofgps;

                      intermediateonlick = true;
                    } else {
                      int ordergps = orderofGps + 1;
                      orderofGps = ordergps;
                    }

                    if (startClick) {
                      print("inter7");
                      visibilityTag = true;

                      getLocation("Intermediate", orderofGps);
                    } else {
                      errordialog(context, info, plsInit);
                    }
                  }

                  if (endonclick) {
                    errordialog(context, info, plsInit);
                  }
                });
              }),
        ));
  }

  Widget showEndButton() {
    return new Padding(
        padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0.0),
        child: SizedBox(
          height: 40.0,
          child: new RaisedButton(
            elevation: 5.0,
            shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(10.0)),
            color: Colors.blue,
            child: new Text(end,
                style: new TextStyle(fontSize: 18.0, color: Colors.white)),
            onPressed: () async {
              setState(() {
                if (startClick == true && intermediateonlick == true) {
                  int incrementonpresscount = onpressCount + 1;
                  onpressCount++;
                  if (incrementonpresscount == 1) {
                    Endcalculation(context);
                  } else if (incrementonpresscount > 1) {
                    visibilityTag = true;
                  }
                } else {
                  errordialog(context, info, plsinitIntrmed);
                }
              });

              print("endonclickpressed");
            },
          ),
        ));
  }

  Widget showCalulateareaButton() {
    return new Padding(
        padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0.0),
        child: SizedBox(
          height: 40.0,
          child: new RaisedButton(
            elevation: 5.0,
            shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(10.0)),
            color: Colors.blue,
            child: new Text(calculateArea,
                style: new TextStyle(fontSize: 18.0, color: Colors.white)),
            onPressed: () async {
              print("Calulate area clicked");
              calculatearea = true;

              setState(() {
                if (startClick == true &&
                    intermediateonlick == true &&
                    endonclick == true) {
                  confirmcalculateareapopup(context);

                  print("truepart");
                } else {
                  print("falsepart");
                  start_endpopup(context);
                }
              });
            },
          ),
        ));
  }

  Widget showanotherLabelwidget() {
    return Padding(
        padding: const EdgeInsets.fromLTRB(10.0, 30.0, 0.0, 0.0),
        child: new Text(
          calArea,
          style: new TextStyle(
            color: Colors.black54,
            fontSize: 18.0,
          ),
        ));
  }

  Widget showButtons(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10.0),
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.end,
        mainAxisSize: MainAxisSize.max,
        // this will take space as minimum as posible(to center)
        children: <Widget>[
          Container(
            margin: const EdgeInsets.only(right: 10.0),
            child: new MaterialButton(
              height: 40.0,
              minWidth: 70.0,
              elevation: 5.0,
              shape: new RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(10.0)),
              color: Colors.blue,
              textColor: Colors.white,
              child: new Text(submit),
              onPressed: () async {
                if (calculatearea == false) {
                  print("calculatearea1");
                  calculateareapopup(context);
                } else if (calculatearea == true &&
                    startClick == true &&
                    endonclick == true &&
                    intermediateonlick == true) {
                  confirmcalculatearea(context);
                  print("calculatearea2");
                }
              },
              splashColor: Colors.black,
            ),
          ),
          Container(
            margin: const EdgeInsets.only(right: 10.0),
            child: new MaterialButton(
              height: 40.0,
              minWidth: 100.0,
              elevation: 5.0,
              shape: new RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(10.0)),
              color: Colors.red,
              textColor: Colors.white,
              child: new Text(cancel),
              onPressed: () {
                confirmationPopup(context);
              },
              splashColor: Colors.redAccent,
            ),
          ),
        ],
      ),
    );
  }

  confirmationPopup(dialogContext) {
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
        context: dialogContext,
        style: alertStyle,
        title: cnfor,
        desc: sureCancel,
        buttons: [
          DialogButton(
            child: Text(
              yes,
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            onPressed: () {
              setState(() {
                Navigator.pop(dialogContext);
                Navigator.pop(dialogContext);
              });
            },
            color: Colors.green,
          ),
          DialogButton(
            child: Text(
              no,
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            onPressed: () {
              setState(() {
                Navigator.pop(dialogContext);
              });
            },
            color: Colors.red,
          )
        ]).show();
  }

  clearLocationAlert(dialogContext) {
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
        context: dialogContext,
        style: alertStyle,
        title: cnfor,
        desc: prevLoc,
        buttons: [
          DialogButton(
            child: Text(
              ok,
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            //onPressed:btncancel ,
            onPressed: () {
              setState(() {
                geoploattingfarmlist.clear();
                intermediateonlick = false;
                endonclick = false;
                orderofGps = 0;
                onpressCount = 0;

                Navigator.pop(dialogContext);
                getLocation("Start", orderofGps);
              });
            },
            color: Colors.deepOrange,
          ),
          DialogButton(
            child: Text(
              cancel,
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            //onPressed:btncancel ,
            onPressed: () {
              setState(() {
                Navigator.pop(dialogContext);
              });
            },
            color: Colors.deepOrange,
          ),
        ]).show();
  } // start

  GetStreamLocation() {
    print('positionStream started');
    final LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.best,
      distanceFilter: 1,
    );
    StreamSubscription<Position> positionStream =
        Geolocator.getPositionStream(locationSettings: locationSettings)
            .listen((Position? position) {
      streamLocation.add(LatLng(position!.latitude, position.longitude));
      print('positionStream ' + position.toString() == null
          ? 'Unknown'
          : '${position.latitude.toString()}, ${position.longitude.toString()}');
    });
  }

  void getLocation(String State, int OrderofGps) async {
    // Position position = await Geolocator.getCurrentPosition(
    //     desiredAccuracy: LocationAccuracy.best,forceAndroidLocationManager: true,);
    // print("accuracy : "+position.accuracy.toString());
    // toast("accuracy : "+position.accuracy.toString());
    LatLng? position1 = streamLocation!.last!;
    // if (position.accuracy > 95) {
    print("latitude_A:" +
        position1!.latitude.toString() +
        " longitude_B" +
        position1.longitude.toString());
    setState(() {
      Lat = position1.latitude.toString();
      Lng = position1.longitude.toString();
      addListItems(Lat, Lng, State, OrderofGps);
    });
    //} else {}
  } //intermediate

  Endcalculation(dialogContext) {
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
        context: dialogContext,
        style: alertStyle,
        title: cnfor,
        desc: prcdAreacal,
        buttons: [
          DialogButton(
            child: Text(
              ok,
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            //onPressed:btncancel ,
            onPressed: () {
              setState(() {
                Navigator.pop(dialogContext);
                int orderofgps = orderofGps + 1;
                orderofGps = orderofgps;
                getLocation(end, orderofGps);
                setState(() {
                  endonclick = true;
                });
                calculateAreaUsingCoordinates();
              });
            },
            color: Colors.green,
          ),
          DialogButton(
            child: Text(
              cancel,
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            //onPressed:btncancel ,
            onPressed: () {
              setState(() {
                onpressCount = 0;
                Navigator.pop(dialogContext);
              });
            },
            color: Colors.deepOrange,
          ),
        ]).show();
  } // end

  confirmcalculateareapopup(dialogContext) {
    var alertStyle = AlertStyle(
      animationType: AnimationType.grow,
      overlayColor: Colors.black87,
      isCloseButton: true,
      isOverlayTapDismiss: true,
      titleStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
      descStyle: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
      animationDuration: Duration(milliseconds: 400),
    );

    print(" addfarmdata.Hectare_" + addfarmdata!.Hectare);
    Alert(
        context: dialogContext,
        style: alertStyle,
        title: areaCalsucc,
        desc: '$calArea : ' + addfarmdata!.Hectare + hectare,
        buttons: [
          DialogButton(
            child: Text(
              ok,
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            //onPressed:btncancel ,
            onPressed: () {
              setState(() {
                Navigator.pop(dialogContext);
                areacalculatesuccess = true;
              });
            },
            color: Colors.deepOrange,
          ),
        ]).show();
  } // calculate area

  confirmcalculatearea(dialogContext) {
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
        context: dialogContext,
        style: alertStyle,
        title: cnfmCalarea,
        buttons: [
          DialogButton(
            child: Text(
              yes,
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            onPressed: () async {
              Navigator.pop(context);
              Navigator.pop(context, true);
              /*bool returnedMap = await Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (BuildContext context) =>
                          MapScreen(polygonLatLngs)));*/
              //if (returnedMap) {
              switch (type) {
                case 1:
                  Geoploattingaddfarmlist = geoploattingfarmlist;
                  addFarmdata = addfarmdata;
                  break;
                case 2:
                  GeoploattingsddProposedlist = geoploattingfarmlist;
                  Proposeddata = addfarmdata;
                  break;
              }
              //Navigator.pop(context, returnedMap);
              //}
            },
            color: Colors.green,
          ),
          DialogButton(
            child: Text(
              no,
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            onPressed: () {
              setState(() {
                Navigator.pop(dialogContext);
              });
            },
            color: Colors.deepOrange,
          ),
        ]).show();
  }

  doyouwantConfirmarea(dialogContext) {
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
        context: dialogContext,
        style: alertStyle,
        title: cnfor,
        desc: cnfmCalarea,
        buttons: [
          DialogButton(
            child: Text(
              yes,
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            //onPressed:btncancel ,
            onPressed: () {
              setState(() {
                Navigator.pop(dialogContext);
              });
            },
            color: Colors.green,
          ),
          DialogButton(
            child: Text(
              no,
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            onPressed: () {
              setState(() {
                Navigator.pop(dialogContext);
              });
            },
            color: Colors.deepOrange,
          ),
        ]).show();
  }

  calculateareapopup(dialogContext) {
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
        context: dialogContext,
        style: alertStyle,
        title: cnfor,
        desc: areaZero,
        buttons: [
          DialogButton(
            child: Text(
              ok,
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            //onPressed:btncancel ,
            onPressed: () {
              setState(() {
                Navigator.pop(dialogContext);
              });
            },
            color: Colors.deepOrange,
          ),
        ]).show();
  }

  start_endpopup(dialogContext) {
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
        context: dialogContext,
        style: alertStyle,
        title: cnfor,
        desc: plsMark,
        buttons: [
          DialogButton(
            child: Text(
              ok,
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            onPressed: () {
              setState(() {
                Navigator.pop(dialogContext);
              });
            },
            color: Colors.deepOrange,
          ),
        ]).show();
  }

  Widget showTable(List<GeoPloattingModel> geoploattingfarmlist) {
    return visibilityTag
        ? SizedBox(
            child: Container(
                child: Padding(
            padding: const EdgeInsets.fromLTRB(10.0, 30.0, 0.0, 0.0),
            child: new SizedBox(
                height: 300,
                child: new Column(children: <Widget>[
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      // this will take space as minimum as posible(to center)
                      children: <Widget>[
                        new Expanded(
                          child: Container(
                              //padding: EdgeInsets.all(4.0),
                              margin: const EdgeInsets.only(
                                left: 15.0,
                                right: 0.0,
                                top: 10.0,
                              ),
                              //width: 100.0,
                              child: Text(
                                state,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 18),
                              )),
                          flex: 1,
                        ),
                        new Expanded(
                          child: Container(
                            margin: const EdgeInsets.only(
                              left: 15.0,
                              right: 0.0,
                              top: 10.0,
                            ),
                            child: Text(
                              lat,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                          ),
                          flex: 1,
                        ),
                        new Expanded(
                          child: Container(
                            margin: const EdgeInsets.only(
                              left: 15.0,
                              right: 0.0,
                              top: 10.0,
                            ),
                            child: Text(
                              lan,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                          ),
                          flex: 1,
                        ),
                        new Expanded(
                          child: Container(
                            margin: const EdgeInsets.only(
                              left: 15.0,
                              right: 0.0,
                              top: 10.0,
                            ),
                            child: Text(
                              edit + "/" + Delete,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                          ),
                          flex: 1,
                        ),
                      ],
                    ),
                  ),
                  Flexible(
                    child: ListView.separated(
                      primary: false,
                      shrinkWrap: true,
                      itemCount: geoploattingfarmlist.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Dismissible(
                            key: ObjectKey(geoploattingfarmlist[index]),
                            background: Container(
                              color: Colors.amber[700],
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              alignment: AlignmentDirectional.centerStart,
                              child: Icon(
                                Icons.delete,
                                color: Colors.white,
                              ),
                            ),
                            secondaryBackground: Container(
                              color: Colors.amber[700],
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              alignment: AlignmentDirectional.centerEnd,
                              child: Icon(
                                Icons.delete,
                                color: Colors.white,
                              ),
                            ),
                            onDismissed: (direction) {
                              var item = geoploattingfarmlist.elementAt(index);
                              //To delete
                              deleteItem(index);
                              Scaffold.of(context).showSnackBar(SnackBar(
                                  content: Text("Item deleted"),
                                  action: SnackBarAction(
                                      label: "UNDO",
                                      onPressed: () {
                                        //To undo deletion
                                        undoDeletion(index, item);
                                      })));
                            },
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              // this will take space as minimum as posible(to center)
                              children: <Widget>[
                                geoploattingfarmlist[index].state ==
                                        "Intermediate"
                                    ? new Expanded(
                                        child: Container(
                                          margin: const EdgeInsets.only(
                                            left: 15.0,
                                            right: 0.0,
                                            top: 10.0,
                                          ),
                                          child: Text(
                                            geoploattingfarmlist[index].state +
                                                index.toString(),
                                            style: TextStyle(fontSize: 18),
                                          ),
                                        ),
                                        flex: 2,
                                      )
                                    : new Expanded(
                                        child: Container(
                                          margin: const EdgeInsets.only(
                                            left: 15.0,
                                            right: 0.0,
                                            top: 10.0,
                                          ),
                                          child: Text(
                                            geoploattingfarmlist[index].state,
                                            style: TextStyle(fontSize: 18),
                                          ),
                                        ),
                                        flex: 2,
                                      ),
                                new Expanded(
                                  child: Container(
                                    margin: const EdgeInsets.only(
                                      left: 15.0,
                                      right: 0.0,
                                      top: 10.0,
                                    ),
                                    child: Text(
                                      geoploattingfarmlist[index].latitude,
                                      style: TextStyle(fontSize: 18),
                                    ),
                                  ),
                                  flex: 2,
                                ),
                                new Expanded(
                                  child: Container(
                                    margin: const EdgeInsets.only(
                                      left: 15.0,
                                      right: 0.0,
                                      top: 10.0,
                                    ),
                                    child: Text(
                                      geoploattingfarmlist[index].longitude,
                                      style: TextStyle(fontSize: 18),
                                    ),
                                  ),
                                  flex: 2,
                                ),
                                Expanded(
                                  child: Container(
                                    child: IconButton(
                                      icon: Icon(Icons.border_color,
                                          color: Colors.black26),
                                      onPressed: () {
                                        setState(() {
                                          editlatlngpopup(context, index);
                                        });
                                      },
                                    ),
                                    alignment: Alignment.center,
                                  ),
                                  flex: 1,
                                ),
                                geoploattingfarmlist[index].state != "Start" &&
                                        geoploattingfarmlist[index].state !=
                                            "End"
                                    ? Expanded(
                                        child: Container(
                                          child: IconButton(
                                            icon: Icon(Icons.delete,
                                                color: Colors.black26),
                                            onPressed: () {
                                              latlngdelete(context, index);
                                            },
                                          ),
                                          alignment: Alignment.center,
                                        ),
                                        flex: 1,
                                      )
                                    : Expanded(
                                        child: Container(),
                                        flex: 1,
                                      ),
                              ],
                            ));
                      },
                      separatorBuilder: (context, index) {
                        return Divider();
                      },
                    ),
                  ),
                ])),
          )))
        : new Container();
  }

  intermediateAlert(dialogContext) {
    var alertStyle = AlertStyle(
      animationType: AnimationType.grow,
      overlayColor: Colors.black87,
      isCloseButton: true,
      isOverlayTapDismiss: true,
      titleStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
      descStyle: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
      animationDuration: Duration(milliseconds: 400),
    );

    Alert(context: dialogContext, style: alertStyle, title: plsInit, buttons: [
      DialogButton(
        child: Text(
          ok,
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
        onPressed: () {
          Navigator.pop(context);
        },
        color: Colors.deepOrange,
      ),
    ]).show();
  }

  Endalert(dialogContext) {
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
        context: dialogContext,
        style: alertStyle,
        title: plsinitIntrmed,
        buttons: [
          DialogButton(
            child: Text(
              ok,
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
            color: Colors.deepOrange,
          ),
        ]).show();
  }

  editlatlngpopup(dialogContext, int index) {
    var alertStyle = AlertStyle(
      animationType: AnimationType.grow,
      overlayColor: Colors.black87,
      isCloseButton: true,
      isOverlayTapDismiss: true,
      titleStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
      descStyle: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
      animationDuration: Duration(milliseconds: 400),
    );

    Alert(context: dialogContext, style: alertStyle, title: ruEdit, buttons: [
      DialogButton(
        child: Text(
          ok,
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
        onPressed: () {
          setState(() {
            Navigator.pop(dialogContext);
            if (geoploattingfarmlist[index].state == "Start") {
              geoploattingfarmlist.removeWhere((item) => item.state == "Start");
              visibilityTag = true;
              getLocation("Start", orderofGps);
            } else if (geoploattingfarmlist[index].state == "Intermediate") {
              geoploattingfarmlist.removeAt(index);
              visibilityTag = true;
              getLocation("Intermediate", orderofGps);
            } else if (geoploattingfarmlist[index].state == "End") {
              geoploattingfarmlist.removeWhere((item) => item.state == "End");
              visibilityTag = true;
              getLocation("End", orderofGps);
            }
          });
        },
        color: Colors.deepOrange,
      ),
      DialogButton(
        child: Text(
          cancel,
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
        onPressed: () {
          setState(() {
            Navigator.pop(dialogContext);
          });
        },
        color: Colors.deepOrange,
      ),
    ]).show();
  }

  latlngdelete(dialogContext, int index) {
    var alertStyle = AlertStyle(
      animationType: AnimationType.grow,
      overlayColor: Colors.black87,
      isCloseButton: true,
      isOverlayTapDismiss: true,
      titleStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
      descStyle: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
      animationDuration: Duration(milliseconds: 400),
    );

    Alert(context: dialogContext, style: alertStyle, title: ruDel, buttons: [
      DialogButton(
        child: Text(
          ok,
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
        onPressed: () {
          setState(() {
            //deletelatlng = true;
            Navigator.pop(dialogContext);
            geoploattingfarmlist.removeAt(index);
          });
        },
        color: Colors.deepOrange,
      ),
      DialogButton(
        child: Text(
          cancel,
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
        onPressed: () {
          setState(() {
            Navigator.pop(dialogContext);
          });
        },
        color: Colors.deepOrange,
      ),
    ]).show();
  }

  Future<String?> addListItems(
      String Lat, String Lng, String State, int OrderofGps) async {
    setState(() {
      GeoPloattingModel data;
      data = new GeoPloattingModel(Lat, Lng, State, OrderofGps);
      polygonLatLngs.add(LatLng(double.parse(Lat), double.parse(Lng)));
      geoploattingfarmlist.add(data);
      print("objlocateListCHECK " + geoploattingfarmlist.length.toString());
    });
  }

  clearList() {
    setState(() {
      geoploattingfarmlist.clear();
      visibilityTag = false;
      visibilityareaTag = false;
    });
  }

  void undoDeletion(int index, GeoPloattingModel item) {
    setState(() {
      geoploattingfarmlist.insert(index, item);
      visibilityTag = false;
      //_isVisible = false;
      if (geoploattingfarmlist.length > 0) {
        visibilityTag = true;
        //   _isVisible = true;
      }
    });
  }

  void deleteItem(int index) {
    setState(() {
      geoploattingfarmlist.removeAt(index);
      visibilityTag = false;
      // _isVisible = false;
      if (geoploattingfarmlist.length > 0) {
        visibilityTag = true;
        //  _isVisible = true;
      }
    });
  }

  void calculateAreaUsingCoordinates() {
    var latit = geoploattingfarmlist[0].latitude;
    var longit = geoploattingfarmlist[0].longitude;

    var intText = "";

    for (var j = geoploattingfarmlist.length - 2; j >= 1; j--) {
      print("decrementlistvalue");
      latit = geoploattingfarmlist[j].latitude;
      longit = geoploattingfarmlist[j].longitude;
      intText = intText + " " + latit + "," + longit;
    }
    //$("#interLoc").text("Intermediate:"+intText);

    latit = geoploattingfarmlist[geoploattingfarmlist.length - 1].latitude;
    longit = geoploattingfarmlist[geoploattingfarmlist.length - 1].longitude;

    print("latit_latit" + latit.toString());
    print("longit_longit" + longit.toString());

    var radius = 6378137;
    var diameter = radius * 2;

    var circumference = diameter * pi;
    print("circumference12" + circumference.toString());
    List<double> listY = [];
    List<double> listX = [];
    List<double> listArea = [];

    var latitudeRef = geoploattingfarmlist[0].latitude;
    var longitudeRef = geoploattingfarmlist[0].longitude;

    print("longitudeRef12" + longitudeRef);
    print("latitudeRef12" + latitudeRef);

    for (var i = 1; i < geoploattingfarmlist.length; i++) {
      print("geoploattingfarmlist_location");
      var latitude = geoploattingfarmlist[i].latitude;
      var longitude = geoploattingfarmlist[i].longitude;

      print("latitude_list" + latitude);
      print("longitude_list" + latitude);

      var value = (double.parse(latitude) - double.parse(latitudeRef)) *
          circumference /
          360.0;
      print("geoploattingfarmlist_lat_value" + value.toString());
      var vY = value;
      print("vY_vY_value" + vY.toString());

      listY.add(vY);

      print("double.parse(longitude)" + longitude);
      print("double.parse(longitude)" + longitudeRef);

      var valuevX = (double.parse(longitude) - double.parse(longitudeRef)) *
          circumference *
          cos(0.017453292519943295769236907684886 * (double.parse(latitude))) /
          360.0;
      print("valuevX_valuevX" + valuevX.toString());

      var vX = valuevX;
      listX.add(vX);
    }
    for (var j = 1; j < listX.length; j++) {
      print("Xlistvalue");
      var x1 = listX[j - 1];
      var y1 = listY[j - 1];

      var x2 = listX[j];
      var y2 = listY[j];

      var areavalue = ((y1 * x2) - (x1 * y2)) / 2;
      print("areavalue_areavalue" + areavalue.toString());
      var area = areavalue;
      print("area_area" + area.toString());
      listArea.add(area);
    }
    // sum areas of all triangle segments
    var areasSum = 0.0;
    for (var i = 0; i < listArea.length; i++) {
      print("areasumcalculation");
      var areaCal = listArea[i];
      areasSum = areasSum + areaCal;
      print("CHECKVALUE_areasSum" + areasSum.toString());
    }
    var msqr = areasSum;
    areasSum = (msqr * 0.000247104393);
    print("CHECKVALUE_areasSum_msqr" + areasSum.toString());

    areasSum = areasSum.abs();
    print("CHECKVALUE_areasSum_abs" + areasSum.toString());

    var sqftArea = (areasSum / 0.00024711);
    var hectAcre = areasSum / 2.4711;

    var detHect = ChangeDecimalTwo(areasSum.toString());

    var areaFarmCalc = areasSum;
    var sqftAreaCalc = sqftArea.toStringAsFixed(4);
    var hectareVal = hectAcre.toStringAsFixed(4);
    var sqftdetHectCalc = detHect;

    print("sqftAreaCalc_sqftAreaCalc" + sqftAreaCalc.toString());
    print("hectareVal_hectareVal" + hectareVal.toString());
    print("sqftdetHectCalc_sqftdetHectCalc" + sqftdetHectCalc.toString());

    addAreaItems(sqftdetHectCalc.toString(), hectareVal.toString(),
        sqftAreaCalc.toString());
  }

  Future<String?> addAreaItems(
      String Acrea, String Hectare, String Squaremeter) async {
    setState(() {
      visibilityareaTag = true;
      geoareascalculatefarm.clear();
      addfarmdata = new GeoareascalculateFarm(Acrea, Hectare, Squaremeter);
      geoareascalculatefarm.add(addfarmdata);
    });
  }

  Widget showareaTable() {
    return areacalculatesuccess
        ? SizedBox(
            child: Container(
                child: Padding(
            padding: const EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
            child: new SizedBox(
                height: 100,
                child: new Column(children: <Widget>[
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      // this will take space as minimum as posible(to center)
                      children: <Widget>[
                        new Expanded(
                          child: Container(
                              //padding: EdgeInsets.all(4.0),
                              margin: const EdgeInsets.only(
                                left: 15.0,
                                right: 0.0,
                                top: 10.0,
                              ),
                              //width: 100.0,
                              child: Text(
                                acre,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 18),
                              )),
                          flex: 1,
                        ),
                        new Expanded(
                          child: Container(
                            margin: const EdgeInsets.only(
                              left: 0.0,
                              right: 0.0,
                              top: 10.0,
                            ),
                            child: Text(
                              hectare,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          flex: 1,
                        ),
                        new Expanded(
                          child: Container(
                            margin: const EdgeInsets.only(
                              left: 15.0,
                              right: 0.0,
                              top: 10.0,
                            ),
                            child: Text(
                              sqm,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18),
                              textAlign: TextAlign.start,
                            ),
                          ),
                          flex: 1,
                        ),
                      ],
                    ),
                  ),
                  Flexible(
                    // ignore: missing_required_param
                    child: ListView.separated(
                      primary: false,
                      shrinkWrap: true,
                      itemCount: 1,
                      itemBuilder: (BuildContext context, int index) {
                        return Dismissible(
                            key: ObjectKey("1"),
                            background: Container(
                              color: Colors.amber[700],
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              alignment: AlignmentDirectional.centerStart,
                              child: Icon(
                                Icons.delete,
                                color: Colors.white,
                              ),
                            ),
                            secondaryBackground: Container(
                              color: Colors.amber[700],
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              alignment: AlignmentDirectional.centerEnd,
                              child: Icon(
                                Icons.delete,
                                color: Colors.white,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              // this will take space as minimum as posible(to center)
                              children: <Widget>[
                                new Expanded(
                                  child: Container(
                                    margin: const EdgeInsets.only(
                                      left: 15.0,
                                      right: 0.0,
                                      top: 10.0,
                                    ),
                                    child: Text(
                                      addfarmdata!.Acre,
                                      style: TextStyle(fontSize: 18),
                                    ),
                                  ),
                                  flex: 1,
                                ),
                                new Expanded(
                                  child: Container(
                                    margin: const EdgeInsets.only(
                                      left: 15.0,
                                      right: 0.0,
                                      top: 10.0,
                                    ),
                                    child: Text(
                                      addfarmdata!.Hectare,
                                      style: TextStyle(fontSize: 18),
                                    ),
                                  ),
                                  flex: 1,
                                ),
                                new Expanded(
                                  child: Container(
                                    margin: const EdgeInsets.only(
                                      left: 15.0,
                                      right: 0.0,
                                      top: 10.0,
                                    ),
                                    child: Text(
                                      addfarmdata!.Squaremeters,
                                      style: TextStyle(fontSize: 18),
                                    ),
                                  ),
                                  flex: 1,
                                ),
                              ],
                            ));
                      },
                      separatorBuilder: (context, index) {
                        return Divider();
                      },
                    ),
                  ),
                ])),
          )))
        : new Container();
  }
}
