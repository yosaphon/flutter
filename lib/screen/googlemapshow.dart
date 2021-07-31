import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class showuserGooglemap extends StatefulWidget {
  @override
  _showuserGooglemapState createState() => _showuserGooglemapState();
}

class _showuserGooglemapState extends State<showuserGooglemap> {
  GoogleMapController mapController;
  Position userLocation;
  List<Marker> myMarker = [];
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
      myMarker.add(
        Marker(
            markerId: MarkerId(
              tappedPoint.toString(),
            ),
            position: tappedPoint),
      );
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
        },
        label: Text("ปักหมุด"),
        icon: Icon(Icons.pin_drop),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
