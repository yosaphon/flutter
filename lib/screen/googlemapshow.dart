import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class showuserGooglemap extends StatelessWidget {
  GoogleMapController mapController;
  Position userlocation;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        centerTitle: true,
        title: Text(
          "google map",
          style: TextStyle(color: Colors.black),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
        ),
        // backgroundColor: Colors.transparent,
        backgroundColor: Colors.black.withOpacity(0.1),
        elevation: 0,
      ),
      body: FutureBuilder(
        future: _getuserlocation(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return Stack(
              children: [
                GoogleMap(
                  mapType: MapType.normal,
                  initialCameraPosition: CameraPosition(
                    target:
                        LatLng(userlocation.latitude, userlocation.longitude),
                    zoom: 15,
                  ),
                  onMapCreated: _onMapCreated,
                  myLocationEnabled: true,
                  compassEnabled: true,
                ),
              ],
            );
          } else {
            return _buildGoogleMap(context);
          }
        },
      ),
    ));
  }

  Widget _buildGoogleMap(BuildContext context) {
    return Stack(
      children: [
        GoogleMap(
          mapType: MapType.normal,
          initialCameraPosition: CameraPosition(
            target: LatLng(13.7535, 100.5237),
            zoom: 15,
          ),
          onMapCreated: _onMapCreated,
          myLocationEnabled: true,
          compassEnabled: true,
        ),
        // Positioned(
        //   bottom: 50,
        //   right: 10,
        //   child: IconButton(
        //     icon: Icon(Icons.pin_drop),
        //     color: Colors.blue,
        //     onPressed: () {
        //       _addmarker();
        //     },
        //   ),
        // )
      ],
    );
  }

  void _onMapCreated(GoogleMapController controller) {
    // setState(() {
    mapController = controller;
    // });
  }

  Future<Position> _getuserlocation() async {
    try {
      userlocation = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.best);
    } catch (e) {
      userlocation = null;
    }
    return userlocation;
  }

  _addmarker() {
    var marker = Marker(
        markerId: const MarkerId('location'),
        infoWindow: const InfoWindow(title: 'location'));
  }
}
