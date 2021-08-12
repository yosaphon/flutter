import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class ShowuserGooglemap extends StatefulWidget { 
  @override
  _ShowuserGooglemapState createState() => _ShowuserGooglemapState();
}

class _ShowuserGooglemapState extends State<ShowuserGooglemap> {
  GoogleMapController mapController;
  Position userLocation;
  List<Marker> myMarker = [];
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
        title: Text('Flutter Google Maps'),
      ),
      body: FutureBuilder(
        future: _getLocation(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return GoogleMap(
              markers: Set.from(myMarker),
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

          // print(location); // positionontap เป็นค่าตำแหน่ง
          Navigator.pop(context,location);
        },
        label: Text("บันทึกตำแหน่ง"),
        icon: Icon(Icons.pin_drop),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
