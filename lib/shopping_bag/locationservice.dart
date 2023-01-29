import 'dart:html';

import 'package:flutter/cupertino.dart';
import 'package:location/location.dart';

class locationservice{
  Future<LocationData> getlocation()async{
    Location location =new Location();
    bool _serviceEnabled=false;
    PermissionStatus _permissiongeneral;
    LocationData _locationData;

    _serviceEnabled=await location.serviceEnabled();
    if(!_serviceEnabled){
      _serviceEnabled=await location.requestService();
      if(!_serviceEnabled)
        throw Exception();
    }

    _permissiongeneral=await location.hasPermission();
    if(_permissiongeneral==PermissionStatus.denied){
      _permissiongeneral=await location.requestPermission();
      if(_permissiongeneral!=PermissionStatus.granted)
        throw Exception();
    }

    _locationData=await location.getLocation();
    return _locationData;
  }

}