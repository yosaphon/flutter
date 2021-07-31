import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class showuserGooglemap extends StatelessWidget {
  GoogleMapController mapController;
  Position userLocation;

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
          mapController.animateCamera(CameraUpdate.newLatLngZoom(
              LatLng(userLocation.latitude, userLocation.longitude), 18));
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                content: Text(
                    'Your location has been send !\nlat: ${userLocation.latitude} long: ${userLocation.longitude} '),
              );
            },
          );
        },
        
        label: Text("Send Location"),
        icon: Icon(Icons.near_me),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniCenterDocked,
    );
  }
}
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//         home: Scaffold(
//       appBar: AppBar(
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back, color: Colors.black),
//           onPressed: () => Navigator.of(context).pop(),
//         ),
//         centerTitle: true,
//         title: Text(
//           "google map",
//           style: TextStyle(color: Colors.black),
//         ),
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
//         ),
//         // backgroundColor: Colors.transparent,
//         backgroundColor: Colors.black.withOpacity(0.1),
//         elevation: 0,
//       ),
//       body: FutureBuilder(
//         future: _getuserlocation(),
//         builder: (BuildContext context, AsyncSnapshot snapshot) {
//           if (snapshot.hasData) {
//             return Stack(
//               children: [
//                 GoogleMap(
//                   mapType: MapType.normal,
//                   initialCameraPosition: CameraPosition(
//                     target:
//                         LatLng(userlocation.latitude, userlocation.longitude),
//                     zoom: 15,
//                   ),
//                   onMapCreated: _onMapCreated,
//                   myLocationEnabled: true,
//                   compassEnabled: true,
//                 ),
//               ],
//             );
//           } else {
//             return _buildGoogleMap(context);
//           }
//         },
//       ),
//       floatingActionButton: FloatingActionButton.extended(
//         onPressed: () {
//           mapController.animateCamera(CameraUpdate.newLatLngZoom(
//               LatLng(userLocation.latitude, userLocation.longitude), 18));
//           showDialog(
//             context: context,
//             builder: (context) {
//               return AlertDialog(
//                 content: Text(
//                     'Your location has been send !\nlat: ${userLocation.latitude} long: ${userLocation.longitude} '),
//               );
//             },
//           );
//         },
//         label: Text("Send Location"),
//         icon: Icon(Icons.near_me),
//       ),
//     );
//     ));
//   }

//   Widget _buildGoogleMap(BuildContext context) {
//     return Stack(
//       children: [
//         GoogleMap(
//           mapType: MapType.normal,
//           initialCameraPosition: CameraPosition(
//             target: LatLng(13.7535, 100.5237),
//             zoom: 15,
//           ),
//           onMapCreated: _onMapCreated,
//           myLocationEnabled: true,
//           compassEnabled: true,
//         ),
//       ],
//     );
    
//   }

//   void _onMapCreated(GoogleMapController controller) {
//     // setState(() {
//     mapController = controller;
//     // });
//   }

//   Future<Position> _getuserlocation() async {
//     try {
//       userlocation = await Geolocator.getCurrentPosition(
//           desiredAccuracy: LocationAccuracy.best);
//     } catch (e) {
//       userlocation = null;
//     }
//     return userlocation;
//   }

//   _addmarker() {
//     var marker = Marker(
//         markerId: const MarkerId('location'),
//         infoWindow: const InfoWindow(title: 'location'),
//         );

//         mapController.add
//   }
// }
