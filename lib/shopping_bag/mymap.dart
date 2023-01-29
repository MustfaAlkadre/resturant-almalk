import 'dart:async';
import 'dart:html';

import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:restaurant_almalk_app/shopping_bag/locationservice.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:google_api_headers/google_api_headers.dart';
import 'package:restaurant_almalk_app/shopping_bag/polylineSeervice.dart';

class mymap extends StatefulWidget {
  const mymap({Key? key}) : super(key: key);

  @override
  _mymapState createState() => _mymapState();
}

class _mymapState extends State<mymap> {
  Completer<GoogleMapController> controller = Completer();

  static final CameraPosition _initialCameraPosition =
      CameraPosition(target: LatLng(37.5455, 36.45228), zoom: 15);

  LatLng currentlocation = _initialCameraPosition.target;
  Set<Marker> marker = {};
  Set<Polyline> polyline = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(onPressed: showSearchDialog, icon: Icon(Icons.search))
        ],
      ),
      body: Stack(
        children: [
          GoogleMap(
            polylines: polyline,
            markers: marker,
            initialCameraPosition: _initialCameraPosition,
            mapType: MapType.normal,
            onMapCreated: (GoogleMapController c) {
              controller.complete(c);
            },
            onCameraMove: (CameraPosition newpos) {
              setState(() {
                currentlocation = newpos.target;
              });
            },
          ),
          SizedBox(
            height: 25,
            width: 25,
            child: Icon(Icons.location_on),
          )
        ],
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () =>
                drawbolyline(LatLng(37.5156, 37.5195), currentlocation),
            child: Icon(Icons.timeline_sharp),
          ),
          marker.isEmpty
              ? FloatingActionButton(
                  onPressed: () => setMarker(currentlocation),
                  child: Icon(Icons.location_on),
                )
              : FloatingActionButton(
                  onPressed: () => Navigator.of(context).pop([
                    marker.first.position.latitude,
                    marker.first.position.longitude
                  ]),
                  child: Icon(Icons.check),
                ),
          FloatingActionButton(
            onPressed: getMyLocation,
            child: Icon(Icons.gps_fixed),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        height: 20,
        alignment: Alignment.center,
        child: Text(
            "lat:${currentlocation.latitude},long:${currentlocation.longitude}"),
      ),
    );
  }

  Future<void> drawbolyline(LatLng p1, LatLng p2) async {
    Polyline pl = await polylineSeervice().drawPolyline(p1, p2);
    polyline.add(pl);
    setMarker(p1);
    setMarker(p2);
    setState(() {});
  }

  Future<void> setMarker(LatLng location) async {
    Marker newmarker = Marker(
        markerId: MarkerId(location.toString()),
        icon: BitmapDescriptor.defaultMarker,
        position: location,
        onTap: () {
          marker.removeWhere(
              (element) => element.position.latitude == location.latitude);
          setState(() {});
        },
        infoWindow: InfoWindow(
            title: "title",
            snippet: "${location.latitude},${location.longitude}"));
    marker.add(newmarker);
    setState(() {});
  }

  Future<void> getMyLocation() async {
    LocationData _mylocation = await locationservice().getlocation();
    animateCamera(_mylocation);
  }

  Future<void> animateCamera(LocationData _location) async {
    final GoogleMapController c = await controller.future;
    CameraPosition cp = CameraPosition(
      target: LatLng(_location.latitude!, _location.longitude!),
      zoom: 15,
    );
    c.animateCamera(CameraUpdate.newCameraPosition(cp));
  }

  Future<void> showSearchDialog() async {
    var p = await PlacesAutocomplete.show(
        context: context,
        apiKey: "AIzaSyDeMCvSKIBRscy7eXDwwNTPJgM5zoXGhvw",
        offset: 0,
        mode: Mode.fullscreen,
        language: "ar",
        region: "ar",
        hint: "type here ...",
        radius: 1000,
        types: [],
        strictbounds: false,
        components: [new Component(Component.locality, "ar")]);
    getLocationFromPlaceId(p!.placeId!);
  }

  Future<void> getLocationFromPlaceId(String pid) async {
    GoogleMapsPlaces place =new GoogleMapsPlaces(
        apiKey: "AIzaSyDeMCvSKIBRscy7eXDwwNTPJgM5zoXGhvw",
        apiHeaders: await GoogleApiHeaders().getHeaders());

    PlacesDetailsResponse detail =await place.getDetailsByPlaceId(pid);

    animateCamera2(LatLng(detail.result.geometry!.location.lat,
        detail.result.geometry!.location.lng));
  }


  Future<void> animateCamera2(LatLng _location) async {
    final GoogleMapController c = await controller.future;
    CameraPosition cp = CameraPosition(
      target: LatLng(_location.latitude, _location.longitude),
      zoom: 15,
    );
    c.animateCamera(CameraUpdate.newCameraPosition(cp));
  }
}
