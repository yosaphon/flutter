import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class ShowuserGooglemap extends StatefulWidget {
  String locamark;
  ShowuserGooglemap({this.locamark});
  @override
  _ShowuserGooglemapState createState() => _ShowuserGooglemapState(locamark);
}

class _ShowuserGooglemapState extends State<ShowuserGooglemap> {
  final locamark;

  _ShowuserGooglemapState(this.locamark);

  GoogleMapController mapController;
  Position userLocation;
  Set<Marker> usermark() {
    return <Marker>[localMarker()].toSet();
  }

  Marker localMarker() {
    return Marker(
        markerId: MarkerId('userbuy'),
        position: LatLng(double.parse(locamark.substring(1, 18)),
            double.parse(locamark.substring(20, locamark.length - 1))));
  }

  List<Marker> myMarker = [];
  int count = 0;
  String positionontap;
  // Marker _marker;

  Future<Position> _getLocation() async {
    try {
      userLocation = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.best);
    } catch (e) {
      userLocation = null;
    }
    return userLocation;
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  _addMarker(LatLng tappedPoint) {
    setState(() {
      myMarker = [];
      count += 1;
      myMarker.add(Marker(
          markerId: MarkerId(
            tappedPoint.toString(),
          ),
          draggable: true,
          position: tappedPoint));
      return positionontap = tappedPoint.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          title: Text(
            "เพิ่มตำแหน่ง",
            style: TextStyle(color: Colors.black87),
          ),
          shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
        ),
          backgroundColor: Colors.indigo,
          elevation: 0,
        ),
        
      body: FutureBuilder(
        future: _getLocation(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return GoogleMap(
              markers: locamark != null && count < 1
                  ? usermark()
                  : Set.from(myMarker),
              mapType: MapType.normal,
              onTap: _addMarker,
              onMapCreated: _onMapCreated,
              myLocationEnabled: true,
              initialCameraPosition: CameraPosition(
                  target: LatLng(userLocation.latitude, userLocation.longitude),
                  zoom: 15),
            );
          } else {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  CircularProgressIndicator(),
                ],
              ),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          String location = positionontap.replaceAll('LatLng', "");

          
          Navigator.pop(context, location);
        },
        label: Text("บันทึกตำแหน่ง"),
        icon: Icon(Icons.pin_drop),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
