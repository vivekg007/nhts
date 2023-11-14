import 'dart:async';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import '../../../main.dart';
import '../Model/GeoPloattingModel.dart';
import '../Model/Geoareascalculate.dart';

class geoploatting extends StatefulWidget {
  @override
  geoploattingScreen createState() => geoploattingScreen();
}

class geoploattingScreen extends State<geoploatting> {
  @override
  void initState() {
    super.initState();
    print('Test sample print');
    toast('geoplotting');
  }

  @override
  void dispose() {
    super.dispose();
  }

  String? Hectare;

  // @override
  // Widget build(BuildContext context) {
  //   return Container();
  // }

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
                style: TextStyle(color: Colors.green, fontSize: 20),
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
                style: TextStyle(color: Colors.redAccent, fontSize: 20),
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
      onWillPop: _onBackPressed,
      child: DefaultTabController(
        length: 2,
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
              'Area Calculation',
              style: new TextStyle(
                  color: Colors.white,
                  fontSize: 18.0,
                  fontWeight: FontWeight.w700),
            ),
            iconTheme: IconThemeData(color: Colors.white),
            backgroundColor: Colors.green,
            brightness: Brightness.light,
            bottom: TabBar(
              tabs: [
//              Tab(icon: Icon(Icons.directions_car), text: "Car",),
                Tab(
                  text: "Manual Mode GPS",
                ),
                Tab(
                  text: "Map Mode GPS",
                ),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              Manualmodegps(),
            ],
          ),
        ),
      ),
    ));
  }
}

class Manualmodegps extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ManualmodegpsTabBar(),
      ),
    );
  }
}

class ManualmodegpsTabBar extends StatefulWidget {
  @override
  _ManualmodegpsTabBarState createState() => _ManualmodegpsTabBarState();
}

class _ManualmodegpsTabBarState extends State<ManualmodegpsTabBar> {
  String Lat = '0', Lng = '0';
  List<GeoPloattingModel> objlocateList = [];
  //List<Geoareascalculate> objarealist = List<Geoareascalculate>();
  bool visibilityTag = false;
  bool visibilityareaTag = false;
  Geoareascalculate? data;
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
          showTable(),
        ],
      ),
    ));
  }

  Widget showLabelwidget() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10.0, 30.0, 0.0, 0.0),
      child: new Text(
        "Calculate Area",
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
            child: new Text('Start',
                style: new TextStyle(fontSize: 18.0, color: Colors.white)),
            onPressed: () async {
              if (objlocateList.length > 0) {
                for (int i = 0; i < objlocateList.length; i++) {
                  String State = objlocateList[i].state;
                  if (State == "Start") {
                    showAlertDialog(context, State);
                  } else {
                    visibilityTag = true;
                    getLocation("Start");
                  }
                }
              } else {
                visibilityTag = true;
                getLocation("Start");
              }
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
            child: new Text('Intermediate',
                style: new TextStyle(fontSize: 18.0, color: Colors.white)),
            onPressed: () async {
              visibilityTag = true;
              getLocation("Intermediate");
            },
          ),
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
            child: new Text('End',
                style: new TextStyle(fontSize: 18.0, color: Colors.white)),
            onPressed: () async {
              if (objlocateList.length > 0) {
                for (int i = 0; i < objlocateList.length; i++) {
                  String State = objlocateList[i].state;
                  if (State == "End") {
                    showAlertDialog(context, State);
                  } else {
                    visibilityTag = true;
                    getLocation("End");
                  }
                }
              } else {
                visibilityTag = true;
                getLocation("End");
              }
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
            child: new Text('Calculate Area',
                style: new TextStyle(fontSize: 18.0, color: Colors.white)),
            onPressed: () async {
              calculateAreaUsingCoordinates();
            },
          ),
        ));
  }

  Widget showanotherLabelwidget() {
    return Padding(
        padding: const EdgeInsets.fromLTRB(10.0, 30.0, 0.0, 0.0),
        child: new Text(
          "Calculate Area:",
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
              child: new Text("ADD"),
              onPressed: () {
                /* Navigator.of(context).push(CupertinoPageRoute(
                  fullscreenDialog: true,
                  builder: (BuildContext context) {
                    return AddFarm('',objarealist);
                  },
                ));*/
                print("CHECK_RESULT: 2" + data.toString());
                Navigator.pop(context, data);
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
              color: Colors.green,
              textColor: Colors.white,
              child: new Text("CANCEL"),
              onPressed: () => {
                clearList(),
              },
              splashColor: Colors.redAccent,
            ),
          ),
        ],
      ),
    );
  }

  void getLocation(String State) async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    print("latitude_A:" +
        position.latitude.toString() +
        " longitude_B" +
        position.longitude.toString());
    setState(() {
      Lat = position.latitude.toString();
      Lng = position.longitude.toString();
      addListItems(Lat, Lng, State);
    });
  }

  showAlertDialog(BuildContext context, String text) {
    // set up the buttons
    Widget cancelButton = FlatButton(
      child: Text("Cancel"),
      onPressed: () {
        Navigator.pop(context, false);
      },
    );
    Widget continueButton = FlatButton(
      child: Text("Ok"),
      onPressed: () {
        Navigator.pop(context, false);
        objlocateList.removeWhere((item) => item.state == text);
        visibilityTag = true;
        getLocation(text);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Geo Ploat"),
      content: Text("Would you like to reset $text yes or no"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Widget showTable() {
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
                                "State",
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
                              "Latitude",
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
                              "Longitude",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                          ),
                          flex: 2,
                        ),
                        new Expanded(
                          child: Container(
                            // margin: const EdgeInsets.only(left: 15.0, right: 0.0, top: 10.0,),
                            child: Text(
                              "",
                              style: TextStyle(fontSize: 0),
                            ),
                          ),
                          flex: -1,
                        ),
                      ],
                    ),
                  ),
                  Flexible(
                    // ignore: missing_required_param
                    child: ListView.separated(
                      primary: false,
                      shrinkWrap: true,
                      itemCount: objlocateList.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Dismissible(
                            key: ObjectKey(objlocateList[index]),
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
                              var item = objlocateList.elementAt(index);
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
                                new Expanded(
                                  child: Container(
                                    margin: const EdgeInsets.only(
                                      left: 15.0,
                                      right: 0.0,
                                      top: 10.0,
                                    ),
                                    child: Text(
                                      objlocateList[index].state,
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
                                      objlocateList[index].latitude,
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
                                      objlocateList[index].longitude,
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
                                      "0",
                                      style: TextStyle(fontSize: 18),
                                    ),
                                  ),
                                  flex: 1,
                                )
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

  addListItems(String Lat, String Lng, String State) async {
    setState(() {
      GeoPloattingModel data;
      // data = new GeoPloattingModel(Lat, Lng, State);
      // objlocateList.add(data);
      print("objlocateListCHECK " + objlocateList.length.toString());
    });
  }

  clearList() {
    setState(() {
      objlocateList.clear();
      visibilityTag = false;
      //objarealist.clear();
      visibilityareaTag = false;
    });
  }

  void undoDeletion(int index, GeoPloattingModel item) {
    setState(() {
      objlocateList.insert(index, item);
      visibilityTag = false;
      //_isVisible = false;
      if (objlocateList.length > 0) {
        visibilityTag = true;
        //   _isVisible = true;
      }
    });
  }

  void deleteItem(int index) {
    setState(() {
      objlocateList.removeAt(index);
      visibilityTag = false;
      // _isVisible = false;
      if (objlocateList.length > 0) {
        visibilityTag = true;
        //  _isVisible = true;
      }
    });
  }

  void calculateAreaUsingCoordinates() {
    var latit = objlocateList[0].latitude;
    var longit = objlocateList[0].longitude;
    print("objlocateList.length " +
        latit.toString() +
        "" +
        longit +
        " " +
        objlocateList.length.toString());

    var intText = "";
    //$("#startLoc").text("Start:"+latit+","+longit);
    for (var j = objlocateList.length - 2; j >= 1; j--) {
      latit = objlocateList[j].latitude;
      longit = objlocateList[j].longitude;
      intText = intText + " " + latit + "," + longit;
    }
    //$("#interLoc").text("Intermediate:"+intText);

    latit = objlocateList[objlocateList.length - 1].latitude;
    longit = objlocateList[objlocateList.length - 1].longitude;
    //$("#endLoc").text("End:"+latit+","+longit);
    var radius = 6378137;
    var diameter = radius * 2;
    //alert("Diameter:" + diameter);
    var circumference = diameter * pi;
    //alert("circumference:" + circumference);
    List<double> listY = [];
    List<double> listX = [];
    List<double> listArea = [];
    /* var listY = new Array();
    var listX = new Array();
    var listArea = new Array();*/
    var latitudeRef = objlocateList[0].latitude;
    var longitudeRef = objlocateList[0].longitude;

    for (var i = 1; i < objlocateList.length; i++) {
      var latitude = objlocateList[i].latitude;
      var longitude = objlocateList[i].longitude;
      var vY = calculateYSegment(latitudeRef, latitude, circumference);

      /* listY.push({
        'vY' : vY
      });*/

      /*var listYMap = {
        'vY': vY,
      };
      listY.add(listYMap);*/
      listY.add(vY);

      var vX =
          calculateXSegment(longitudeRef, longitude, latitude, circumference);

      /*listX.push({
        'vX' : vX
      });
    }*/
      /* var listXMap = {
        'vX': vX,
      };
      listX.add(listXMap);*/
      listX.add(vX);

      for (var j = 1; j < listX.length; j++) {
        var x1 = listX[j - 1];
        var y1 = listY[j - 1];

        var x2 = listX[j];
        var y2 = listY[j];

        var area = calculateAreaInSquareMeters(x1, x2, y1, y2);
        print("CHECKVALUE_Area" + area.toString());

        /* listArea.push({
        'area' : area
      });*/
        /* var listareaMap = {
          'area': area,
        };
        listArea.add(listareaMap);*/
        listArea.add(area);
      }

      // sum areas of all triangle segments
      var areasSum = 0.0;
      for (var i = 0; i < listArea.length; i++) {
        var areaCal = listArea[i];
        areasSum = areasSum + areaCal;
        print("CHECKVALUE_A" + areasSum.toString());
      }
      var msqr = areasSum;
      areasSum = (msqr * 0.000247104393);
      print("CHECKVALUE_B" + areasSum.toString());

      areasSum = areasSum.abs();
      print("CHECKVALUE_C" + areasSum.toString());

      var sqftArea = (areasSum / 0.00024711);
      var hectAcre = areasSum / 2.4711;
      var detHect = areasSum.toStringAsFixed(2);

      var areaFarmCalc = areasSum;
      var sqftAreaCalc = sqftArea;
      var hectareVal = hectAcre;
      var sqftdetHectCalc = detHect;
      // objarealist.clear();
      addAreaItems(sqftAreaCalc.toString(), sqftdetHectCalc.toString(),
          hectareVal.toString());
    }
  }

  calculateYSegment(latitudeRef, latitude, circumference) {
    var value = double.parse(latitude) -
        double.parse(latitudeRef) * circumference / 360.0;
    return value;
  }

  calculateXSegment(longitudeRef, longitude, latitude, circumference) {
    return double.parse(longitude) -
        double.parse(longitudeRef) *
            circumference *
            cos(0.017453292519943295769236907684886 *
                (double.parse(latitude))) /
            360.0;
  }

  calculateAreaInSquareMeters(x1, x2, y1, y2) {
    return ((y1 * x2) - (x1 * y2)) / 2;
  }

  addAreaItems(String Acrea, String Hectare, String Squaremeter) async {
    setState(() {
      visibilityareaTag = true;
      data = new Geoareascalculate(Acrea, Hectare, Squaremeter);
      //objarealist.clear();
      //objarealist.add(data);
    });
  }

  Widget showareaTable() {
    return visibilityareaTag
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
                                "Acre",
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
                              "Hectare(s)",
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
                              "Square Meters",
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
                                      data!.Acre,
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
                                      data!.Hectare,
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
                                      data!.Squaremeters,
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
