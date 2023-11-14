import 'package:fluster/fluster.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import '../../commonlang/translateLang.dart';

/// [Fluster] can only handle markers that conform to the [Clusterable] abstract class.
///
/// You can customize this class by adding more parameters that might be needed for
/// your use case. For instance, you can pass an onTap callback or add an
/// [InfoWindow] to your marker here, then you can use the [toMarker] method to convert
/// this to a proper [Marker] that the [GoogleMap] can read.
class MapMarker extends Clusterable {
  final String id;
  final List farm;
  final List farmer;
   BuildContext context;
  final LatLng position;
  BitmapDescriptor? icon;

  MapMarker({
    required this.id,
    required this.farm,
    required this.farmer,
    required this.position,
    this.icon,
    isCluster = false,
    clusterId,
    pointsSize,
    childMarkerId, required  this.context,
  }) : super(
    markerId: id,
    latitude: position.latitude,
    longitude: position.longitude,
    isCluster: isCluster,
    clusterId: clusterId,
    pointsSize: pointsSize,
    childMarkerId: childMarkerId,
  );

  Marker toMarker() => Marker(
    markerId: MarkerId(isCluster! ? 'cl_$id' : id),
    position: LatLng(
      position.latitude,
      position.longitude,
    ),
    icon: icon!,
    onTap: (){


      Alert(
        context: context,
        type: AlertType.info,
        title: 'Latitude:' + position.latitude.toString() +',' + 'Longitude:' + position.longitude.toString() ,
        desc: 'Farm name:' + farm[int.parse(id)],
        buttons: [
          DialogButton(
            child: Text(
              TranslateFun.langList['okCls'],
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
            width: 120,
          ),
        ],
      ).show();

      print('lat==' + position.latitude.toString() +'lon==' +
          position.longitude.toString() + 'id--'+id + farm[int.parse(id)] + farmer[0]);
    }

  );
}