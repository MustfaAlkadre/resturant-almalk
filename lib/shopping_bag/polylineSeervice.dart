import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class polylineSeervice{
  Future<Polyline> drawPolyline(LatLng p1,LatLng p2)async{
    List<LatLng> polylinecoordinates=[];
    PolylinePoints polylinePoints=PolylinePoints();
    PolylineResult result=await polylinePoints.getRouteBetweenCoordinates(
      "",
      PointLatLng(p1.latitude, p2.longitude),
      PointLatLng(p1.latitude, p2.longitude));
    
    result.points.forEach((element) { 
      polylinecoordinates.add(LatLng(element.latitude, element.longitude));
    });
    calcDistance(polylinecoordinates);
    return Polyline(
    polylineId: PolylineId("Polyline_Id ${result.points.length}"),
      points: polylinecoordinates,
      color: Colors.blue
    );
  }

  void calcDistance(List<LatLng> listp){
    double totalDistance=0.0;
    for(int i=0;i<listp.length-1;i++){
      totalDistance+=coordinateDistance(
        listp[i].latitude,listp[i].longitude,
        listp[i+1].latitude,listp[i+1].longitude,
      );
    }
  }

  double coordinateDistance(lat1,long1,lat2,long2){
    var p=0.017453251994295;
    var c=cos;
    var a=0.5-c((lat2-lat1)*p)/2-c(lat1*p)*c(lat2*p)*(1-c(long2-long1)*p)/2;
    return 12742*asin(sqrt(a));
  }
}