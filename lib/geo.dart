import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import '../Database/Databasehelper.dart';
import '../Model/GeoAreacalculateFarm.dart';
import '../main.dart';

List<LatLng> streamLocation = [];

class GeoPlottingNew extends StatefulWidget {
  const GeoPlottingNew({Key? key}) : super(key: key);

  @override
  State<GeoPlottingNew> createState() => _GeoPlottingNewState();
}

class _GeoPlottingNewState extends State<GeoPlottingNew> {
  List<GeoPloattingModel> geoPlottingFarmList = [];
  int statePoint = 1;
  String start = "Start", intermediate = "Intermediate", end = "End";

  getStreamLocation() {
    print('positionStream started');
    const LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.best,
      distanceFilter: 1,
    );
    StreamSubscription<Position> positionStream =
        Geolocator.getPositionStream(locationSettings: locationSettings)
            .listen((Position? position) {
      streamLocation.add(LatLng(position!.latitude, position.longitude));
    });
  }

  void calculateAreaUsingCoordinates() {
    var latit = geoPlottingFarmList[0].latitude;
    var longit = geoPlottingFarmList[0].longitude;

    var intText = "";

    for (var j = geoPlottingFarmList.length - 2; j >= 1; j--) {
      print("decrementlistvalue");
      latit = geoPlottingFarmList[j].latitude;
      longit = geoPlottingFarmList[j].longitude;
      intText = "$intText $latit,$longit";
    }
    //$("#interLoc").text("Intermediate:"+intText);

    latit = geoPlottingFarmList[geoPlottingFarmList.length - 1].latitude;
    longit = geoPlottingFarmList[geoPlottingFarmList.length - 1].longitude;

    var radius = 6378137;
    var diameter = radius * 2;

    var circumference = diameter * pi;

    List<double> listY = [];
    List<double> listX = [];
    List<double> listArea = [];

    var latitudeRef = geoPlottingFarmList[0].latitude;
    var longitudeRef = geoPlottingFarmList[0].longitude;

    for (var i = 1; i < geoPlottingFarmList.length; i++) {
      var latitude = geoPlottingFarmList[i].latitude;
      var longitude = geoPlottingFarmList[i].longitude;

      var value = (double.parse(latitude) - double.parse(latitudeRef)) *
          circumference /
          360.0;

      var vY = value;

      listY.add(vY);

      var valuevX = (double.parse(longitude) - double.parse(longitudeRef)) *
          circumference *
          cos(0.017453292519943295769236907684886 * (double.parse(latitude))) /
          360.0;

      var vX = valuevX;
      listX.add(vX);
    }
    for (var j = 1; j < listX.length; j++) {
      var x1 = listX[j - 1];
      var y1 = listY[j - 1];

      var x2 = listX[j];
      var y2 = listY[j];

      var areavalue = ((y1 * x2) - (x1 * y2)) / 2;

      var area = areavalue;

      listArea.add(area);
    }
    // sum areas of all triangle segments
    var areasSum = 0.0;
    for (var i = 0; i < listArea.length; i++) {
      var areaCal = listArea[i];
      areasSum = areasSum + areaCal;
    }
    var msqr = areasSum;
    areasSum = (msqr * 0.000247104393);

    areasSum = areasSum.abs();

    var sqftArea = (areasSum / 0.00024711);
    var hectAcre = areasSum / 2.4711;

    var detHect = changeDecimalTwo(areasSum.toString());

    var areaFarmCalc = areasSum;
    var sqftAreaCalc = sqftArea;
    var hectareVal = hectAcre;
    var sqftdetHectCalc = detHect;

    addAreaItems(sqftdetHectCalc.toString(), hectareVal.toString(),
        sqftAreaCalc.toString());
  }

  bool visibilityareaTag = false;
  List<GeoareascalculateFarm> geoareascalculatefarm = [];
  GeoareascalculateFarm? farmdata;

  Future<String?> addAreaItems(
      String Acrea, String Hectare, String Squaremeter) async {
    setState(() {
      visibilityareaTag = true;
      geoareascalculatefarm.clear();
      farmdata = GeoareascalculateFarm(Acrea, Hectare, Squaremeter);
      geoareascalculatefarm.add(farmdata!);
    });
  }

  void getLocation(String state, int orderOfGps) async {
    LatLng? position1 = streamLocation.last;
    print("postionlatitude:" + position1.toString());
    String lat = position1.latitude.toString();
    String lng = position1.longitude.toString();
    addListItems(lat, lng, state, orderOfGps);
    setState(() {});
    //} else {}
  }

  GeoPloattingModel? data;

  addListItems(String lat, String lng, String state, int orderOfGps) async {
    data = GeoPloattingModel(lat, lng, state, orderOfGps);
    // polygonLatLngs.add(LatLng(double.parse(Lat), double.parse(Lng)));

    geoPlottingFarmList.add(data!);

    setState(() {});
  }

  reset() {
    geoPlottingFarmList.clear();
    farmdata = null;
    /* polygonLatLngs.clear();
    data=null;*/
    statePoint = 1;
    setState(() {});
  }

  latLanDelete(int index) async {
    Navigator.pop(context);
    geoPlottingFarmList.removeAt(index);
    setState(() {});
  }

  latLanEdit(int index, String state, int order) async {
    if (geoPlottingFarmList[index].state != start) {
      LatLng? position = streamLocation.last;
      geoPlottingFarmList.removeAt(index);
      //  getLocation("Intermediate ${index+1}", index+1);
      //  addListItems(Lat, Lng, State, OrderofGps);
      geoPlottingFarmList.insert(
          index,
          GeoPloattingModel(position.latitude.toString(),
              position.longitude.toString(), state, order));
      setState(() {});
    } else {
      reset();
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getStreamLocation();
  }

  Future<bool> onBackPressed(
    BuildContext context,
  ) async {
    return (await Alert(
          context: context,
          type: AlertType.warning,
          title: "Cancel",
          desc: "Are you sure want to cancel?",
          buttons: [
            DialogButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              width: 120,
              child: const Text(
                "Yes",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
            DialogButton(
              onPressed: () {
                Navigator.pop(context);
              },
              width: 120,
              child: const Text(
                "No",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            )
          ],
        ).show()) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return SafeArea(
      child: WillPopScope(
        onWillPop: () => onBackPressed(context),
        child: Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.green,
              title: const Text("Area Calculation"),
              actions: [
                geoPlottingFarmList.isNotEmpty
                    ? Center(
                        child: GestureDetector(
                            onTap: () {
                              confirmationPopUp(context,
                                  title: "Confirmation ",
                                  desc:
                                      "Previously captured location(s) will be removed .Do you want to process ?",
                                  yesOnPressed: () {
                                Navigator.pop(context);
                                reset();
                              }, noOnPressed: () {
                                Navigator.pop(context);
                              });
                              // reset();
                            },
                            child: const Text("Reset")))
                    : Container(),
                const SizedBox(
                  width: 15,
                )
              ],
            ),
            floatingActionButton: farmdata == null
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      geoPlottingFarmList.isEmpty
                          ? floatingButtonCustom(
                              onPressed: () => getLocation(start, 1),
                              label: start)
                          : geoPlottingFarmList.last.state == end
                              ? floatingButtonCustom(
                                  onPressed: calculateAreaUsingCoordinates,
                                  label: "Calculate Area")
                              : Row(
                                  children: [
                                    floatingButtonCustom(
                                        onPressed: () {
                                          /*getLocation("Intermediate $statePoint",
                                              statePoint + 1);*/
                                          getLocation(
                                              intermediate, statePoint + 1);
                                          statePoint++;
                                        },
                                        label: intermediate),
                                    const SizedBox(
                                      width: 50,
                                    ),
                                    geoPlottingFarmList.length > 2
                                        ? floatingButtonCustom(
                                            onPressed: () =>
                                                getLocation(end, 1),
                                            label: end,
                                            buttonColor: Colors.red)
                                        : Container(
                                            height: 0,
                                          )
                                  ],
                                ),
                    ],
                  )
                : floatingButtonCustom(
                    onPressed: () {
                      GeoCalculatedValues data;
                      data = GeoCalculatedValues(
                          farmData: farmdata!, listData: geoPlottingFarmList);
                      Navigator.pop(context, data);
                      deleteGeoPlottingFromDB();
                    },
                    label: "Ok",
                  ),
            body: SizedBox(
              height: size.height,
              width: size.width,
              child: geoPlottingFarmList.isNotEmpty
                  ? Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Column(
                        children: [
                          farmdata != null
                              ? Card(
                                  shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(15))),
                                  elevation: 5,
                                  child: SizedBox(
                                    height: size.height * 0.12,
                                    width: double.infinity,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        customColumn(
                                            label: "Acre",
                                            value: farmdata?.Acre ?? "--"),
                                        customColumn(
                                            label: "Hectares",
                                            value: farmdata?.Hectare ?? "--"),
                                        customColumn(
                                            label: "Square meters",
                                            value:
                                                farmdata?.Squaremeters ?? "--"),
                                      ],
                                    ),
                                  ),
                                )
                              : Container(),
                          SizedBox(
                            height: farmdata == null
                                ? size.height * 0.89
                                : size.height * 0.76,
                            child: ListView.builder(
                                shrinkWrap: true,
                                primary: false,
                                physics: const BouncingScrollPhysics(),
                                itemCount: geoPlottingFarmList.length,
                                itemBuilder: (context, index) {
                                  var data = geoPlottingFarmList.reversed
                                      .toList()[index];
                                  var selectedIndex =
                                      geoPlottingFarmList.indexOf(data);
                                  return Theme(
                                    data: ThemeData(
                                        splashColor: Colors.green.shade300),
                                    child: Card(
                                      shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(15))),
                                      elevation: 4,
                                      child: ListTile(
                                        shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(15))),
                                        hoverColor: Colors.green,
                                        onTap: () {
                                          farmdata == null
                                              ? bottomSheet(context,
                                                  firstButtonLabel:
                                                      data.state == start
                                                          ? "Yes"
                                                          : "Delete",
                                                  secondButtonLabel:
                                                      data.state == start
                                                          ? "Cancel"
                                                          : "Edit",
                                                  title: geoPlottingFarmList[
                                                                  selectedIndex]
                                                              .state ==
                                                          start
                                                      ? "Edit "
                                                      : "Delete or Edit",
                                                  index: selectedIndex,
                                                  desc: data.state == start
                                                      ? "Do you want to Edit the Starting Point ?"
                                                      : data.state == end
                                                          ? "Please choose the Delete or Edit action for the ${data.state} Point ?"
                                                          : "Please choose the Delete or Edit action for the ${data.state} $selectedIndex ?",
                                                  firstButtonOnPressed:
                                                      () async {
                                                  if (data.state == start) {
                                                    Navigator.pop(context);

                                                    confirmationPopUp(context,
                                                        title: "Confirmation ",
                                                        desc:
                                                            "Previously captured location(s) will be removed .Do you want to process ?",
                                                        yesOnPressed: () {
                                                      Navigator.pop(context);
                                                      reset();
                                                    }, noOnPressed: () {
                                                      Navigator.pop(context);
                                                    });
                                                  } else {
                                                    // Navigator.pop(context);
                                                    var ind =
                                                        geoPlottingFarmList
                                                            .indexOf(data);
                                                    await latLanDelete(
                                                        ind.toInt());
                                                  }
                                                }, seconButtonOnPressed:
                                                      () async {
                                                  if (data.state == start) {
                                                    Navigator.pop(context);
                                                  } else {
                                                    Navigator.pop(context);
                                                    /* confirmationPopUp(context,
                                                        title: "Confirmation",
                                                        yesOnPressed: () async {
                                                      latLanEdit(
                                                          selectedIndex,
                                                          data.state,
                                                          data.orderOfGps);
                                                      Navigator.pop(context);
                                                      toast(data.state != end
                                                          ? "${data.state} $selectedIndex Edited Successfully"
                                                          : "${data.state} Point Edited Successfully");
                                                    }, noOnPressed: () {
                                                      Navigator.pop(context);
                                                    },
                                                        desc: data.state != end
                                                            ? "Do you want to Edit the ${data.state} $selectedIndex ? "
                                                            : "Do you want to Edit the End Point ?");*/
                                                    latLanEdit(
                                                        selectedIndex,
                                                        data.state,
                                                        data.orderOfGps);
                                                    // Navigator.pop(context);
                                                    toast(data.state != end
                                                        ? "${data.state} $selectedIndex Edited Successfully"
                                                        : "${data.state} Point Edited Successfully");
                                                  }
                                                })
                                              : null;
                                        },
                                        title: Text(
                                          data.state != start &&
                                                  data.state != end
                                              ? "${data.state} $selectedIndex"
                                              : data.state,
                                          style: TextStyle(
                                              color: data.state == start
                                                  ? Colors.green
                                                  : data.state == end
                                                      ? Colors.red
                                                      : null,
                                              fontWeight: data.state == start ||
                                                      data.state == end
                                                  ? FontWeight.bold
                                                  : null,
                                              fontSize: data.state == start ||
                                                      data.state == end
                                                  ? 18
                                                  : null),
                                        ),
                                        subtitle: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            const Text("Latitude "),
                                            Text(data.latitude),
                                            const Text(
                                              " | ",
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            const Text("Longitude "),
                                            Text(data.longitude)
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                }),
                          ),
                        ],
                      ),
                    )
                  : Center(
                      child: /*Text(
                      "Please Click the Start button to continue the Geo Plotting...",
                      textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16),
                    )*/
                          RichText(
                      textAlign: TextAlign.center,
                      text: const TextSpan(
                          text: "Please Click the ",
                          style: TextStyle(color: Colors.grey, fontSize: 16),
                          children: [
                            TextSpan(
                                text: "Start ",
                                style: TextStyle(
                                    color: Colors.black, fontSize: 22)),
                            TextSpan(
                                text: "button to continue the Geo Plotting...")
                          ]),
                    )),
            )),
      ),
    );
  }

  Widget floatingButtonCustom(
      {required void Function()? onPressed,
      required String label,
      Color? buttonColor}) {
    var size = MediaQuery.of(context).size;
    return SizedBox(
      height: size.height * 0.05,
      child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
              primary: buttonColor ?? Colors.green,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30))),
          child: Text(
            label,
            style: const TextStyle(fontSize: 16),
          )),
    );
  }

  Widget customColumn({required String label, required String value}) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(7.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  color: Colors.green,
                  fontSize: 17,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(value)
          ],
        ),
      ),
    );
  }
}

deleteGeoPlottingFromDB() async {
  var db = DatabaseHelper();
  await db.RawQuery(
      "Delete from farm_GPSLocation_Exists where partialGps = '2'");
}

bottomSheet(BuildContext context,
    {required String desc,
    required String title,
    required String firstButtonLabel,
    required String secondButtonLabel,
    void Function()? firstButtonOnPressed,
    void Function()? seconButtonOnPressed,
    int? index}) async {
  var size = MediaQuery.of(context).size;
  return showModalBottomSheet(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
      context: context,
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: size.width * 0.01,
            ),
            Container(
              height: size.height * 0.01,
              width: size.width * 0.3,
              decoration: BoxDecoration(
                  color: Colors.grey, borderRadius: BorderRadius.circular(30)),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontSize: 20, color: Colors.red, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Text(
                desc,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 18,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                children: [
                  /*index != 0
                      ?*/
                  Expanded(
                    child: ElevatedButton(
                      onPressed: firstButtonOnPressed,
                      style: ElevatedButton.styleFrom(
                          primary: Colors.red,
                          shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(30)))),
                      child: Text(firstButtonLabel,
                          style: const TextStyle(fontSize: 20)),
                    ),
                  ),
                  // : Container(),
                  /*index != 0
                      ? */
                  const SizedBox(
                    width: 30,
                  )
                  /* : Container(),*/
                  ,
                  Expanded(
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              primary: Colors.green,
                              shape: const RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(30)))),
                          onPressed: seconButtonOnPressed,
                          child: Text(
                            secondButtonLabel,
                            style: const TextStyle(fontSize: 20),
                          ))),
                ],
              ),
            ),
          ],
        );
      });
}

confirmationPopUp(BuildContext context,
    {required String title,
    required void Function()? yesOnPressed,
    required void Function()? noOnPressed,
    required String desc}) {
  var alertStyle = const AlertStyle(
    animationType: AnimationType.grow,
    overlayColor: Colors.black87,
    isCloseButton: true,
    isOverlayTapDismiss: true,
    titleStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
    descStyle: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
    animationDuration: Duration(milliseconds: 400),
  );

  Alert(
      desc: desc,
      context: context,
      style: alertStyle,
      title: title,
      buttons: [
        DialogButton(
          onPressed: yesOnPressed,
          color: Colors.green,
          child: const Text(
            "Yes",
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
        ),
        DialogButton(
          onPressed: noOnPressed,
          color: Colors.deepOrange,
          child: const Text(
            "No",
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
        ),
      ]).show();
}

class GeoCalculatedValues {
  GeoareascalculateFarm farmData;
  List<GeoPloattingModel> listData;

  GeoCalculatedValues({required this.farmData, required this.listData});
}

class GeoPloattingModel {
  String latitude;
  String longitude;
  String state;
  int orderOfGps;

  GeoPloattingModel(this.latitude, this.longitude, this.state, this.orderOfGps);

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map["Latitude"] = latitude;
    map["Longitude"] = longitude;
    map["State"] = state;
    map["orderOfGps"] = orderOfGps.toString();
    return map;
  }
}

String changeDecimalTwo(String value) {
  final formatter = NumberFormat("0.00");
  String values = formatter.format(double.parse(value));
  return values;
}
