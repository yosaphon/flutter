import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class showGooglemap extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(
              title: Text('Maps Sample App'),
              backgroundColor: Colors.green[700],
            ),
            body: Container(
              height: 100,
              width: double.infinity,
              margin: EdgeInsets.only(left: 30, right: 30),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                border: Border.all(
                  style: BorderStyle.solid,
                ),
              ),
                child: GoogleMap(
                  mapType: MapType.normal,
                  initialCameraPosition: CameraPosition(
                    target: LatLng(24.142, -110.321),
                    zoom: 15,
                  ),
                ),
              ),
            ));
  }
}
