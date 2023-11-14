import 'dart:async';

import 'package:fluster/fluster.dart';
import 'package:flutter/material.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import '../helpers/map_helper.dart';
import '../helpers/map_marker.dart';

class MapPage extends StatefulWidget {

  final List<String>? farmLatList;
  final List<String>? farmLngList;
  final List<String>? farmnameList;
  final List<String>? farmernameList;

  MapPage(this.farmLatList, this.farmLngList , this.farmnameList, this.farmernameList);



  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final Completer<GoogleMapController> _mapController = Completer();

  /// Set of displayed markers and cluster markers on the map
  final Set<Marker> _markers = Set();

  /// Minimum zoom at which the markers will cluster
  final int _minClusterZoom = 0;

  /// Maximum zoom at which the markers will cluster
  final int _maxClusterZoom = 19;

  /// [Fluster] instance used to manage the clusters
  Fluster<MapMarker>? _clusterManager;

  /// Current map zoom. Initial zoom will be 15, street level
  double _currentZoom = 5;

  /// Map loading flag
  bool _isMapLoading = true;

  /// Markers loading flag
  bool _areMarkersLoading = true;

  /// Url image used on normal markers
  final String _markerImageUrl =
      'https://img.icons8.com/office/80/000000/marker.png';

  /// Color of the cluster circle
  final Color _clusterColor = Colors.green;

  /// Color of the cluster text
  final Color _clusterTextColor = Colors.white;

  /// Example marker coordinates
  final List<LatLng> _markerLocations = [];
  String? sureCancel = 'Are you sure want to cancel?';
  String? yes = 'Yes';
  String? no = 'No';
  String? cancel = 'Cancel';
  String? ok = 'OK';
  List? lat=[];
  List? lng=[];
  List? farmname=[];
  List? farmername=[];
  static Map<String,dynamic> farmList = {};
  static Map<String,dynamic> farmerList = {};


  /// Called when the Google Map widget is created. Updates the map loading state
  /// and inits the markers.
  void _onMapCreated(GoogleMapController controller) {
    _mapController.complete(controller);

    setState(() {
      _isMapLoading = false;
    });

    _initMarkers();
  }

  /// Inits [Fluster] and all the markers with network images and updates the loading state.
  void _initMarkers() async {
    final List<MapMarker> markers = [];

    for (LatLng markerLocation in _markerLocations) {

      print('index' +  _markerLocations.indexOf(markerLocation).toString());

      markers.add(
        MapMarker(
          id: _markerLocations.indexOf(markerLocation).toString(),
          position:markerLocation,
         icon:   BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
          farm: farmList['farm'],
          farmer: farmerList['farmer'],
          context : context
        ),

      );
    }

    _clusterManager = await MapHelper.initClusterManager(
      context,
      markers,
      _minClusterZoom,
      _maxClusterZoom,
    );

    await _updateMarkers();
  }

  /// Gets the markers and clusters to be displayed on the map for the current zoom level and
  /// updates state.
  Future<void> _updateMarkers([double? updatedZoom]) async {
    if (_clusterManager == null || updatedZoom == _currentZoom) return;

    if (updatedZoom != null) {
      _currentZoom = updatedZoom;
    }

    setState(() {
      _areMarkersLoading = true;
    });

    final updatedMarkers = await MapHelper.getClusterMarkers(
      _clusterManager,
      _currentZoom,
      _clusterColor,
      _clusterTextColor,
      80,
    );

    _markers
      ..clear()
      ..addAll(updatedMarkers);

    setState(() {
      _areMarkersLoading = false;
    });
  }



  @override
  void initState() {
    // TODO: implement initState
    getValues();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
              'Farm Map View',
              style: new TextStyle(
                  color: Colors.white,
                  fontSize: 18.0,
                  fontWeight: FontWeight.w700),
            ),
            iconTheme: IconThemeData(color: Colors.white),
            backgroundColor: Colors.green,
            brightness: Brightness.light,
          ),
          body: Stack(
            children: <Widget>[
              // Google Map widget
              Opacity(
                opacity: _isMapLoading ? 0 : 1,
                child: GoogleMap(
                  zoomGesturesEnabled: true,
                  myLocationButtonEnabled: true,
                  myLocationEnabled: true,
                  zoomControlsEnabled: true,
                  initialCameraPosition: CameraPosition(
                    target: LatLng(double.parse(lat![0]), double.parse(lng![0])),
                    zoom: _currentZoom,
                  ),
                  markers: _markers,
                  onMapCreated: (controller) => _onMapCreated(controller),
                  onCameraMove: (position) => _updateMarkers(position.zoom),

                ),
              ),

              // Map loading indicator
              Opacity(
                opacity: _isMapLoading ? 1 : 0,
                child: Center(child: CircularProgressIndicator()),
              ),

              // Map markers loading indicator
              if (_areMarkersLoading)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: Card(
                      elevation: 2,
                      color: Colors.grey.withOpacity(0.9),
                      child: Padding(
                        padding: const EdgeInsets.all(4),
                        child: Text(
                          'Loading',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

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

  void getValues() {
     lat = widget.farmLatList;
     lng = widget.farmLngList;
     farmname = widget.farmnameList;
     farmername = widget.farmernameList;


    for(int i = 0;i<lng!.length ;i++){
      print('latu' +lat![i] );
      print('lng' +lng![i] );

      _markerLocations.add(LatLng(double.parse(lat![i]), double.parse(lng![i])));
      farmList.addAll({'farm' : farmname});
      farmerList.addAll({'farmer' : farmername});

      print('_markerLocations'+_markerLocations.toString());
      print('farmList--'+farmList.toString());

    }

  }
}
