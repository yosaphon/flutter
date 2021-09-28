// import 'dart:ffi';

// import 'package:flutter/material.dart';
// import 'displaylogin.dart';

// class MenuUnknowDrawer extends StatelessWidget {

//   @override
//   Widget build(BuildContext context) {
//     return Drawer(
//       child: Column(
//         children: [
//           Container(
//             width: double.infinity,
//             padding: EdgeInsets.all(20),
//             color: Theme.of(context).primaryColor,
//             child: Center(
//               child: Column(
//                 children: [
//                   Container(
//                     width: 100,
//                     height: 100,
//                     margin: EdgeInsets.only(bottom: 10, top: 30),
//                     // รูปโปรไฟล์
//                     decoration: BoxDecoration(
//                       shape: BoxShape.circle,
//                       image: DecorationImage(
//                         image: ExactAssetImage(""),
//                         fit: BoxFit.fill,
//                       ),
//                     ),
//                   ),
//                   // ชื่อผู้ใช้
//                   Text(
//                     "",
//                     style: TextStyle(
//                       fontSize: 22,
//                       color: Colors.white,
//                     ),
//                   ),
//                   // Email
//                   Text(
//                     "",
//                     style: TextStyle(
//                       color: Colors.white,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           ListTile(
//             leading: Icon(Icons.person_rounded),
//             title: Text(
//               "Profile",
//               style: TextStyle(
//                 fontSize: 18,
//               ),
//             ),
//             onTap: null,
//           ),
//           ListTile(
//             leading: Icon(Icons.logout),
//             title: Text(
//               "Log in",
//               style: TextStyle(
//                 fontSize: 18,
//               ),
//             ),
//             onTap: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (context) => SignUpLoginWidget()),
//               );
//             },
//           ),
//         ],
//       ),
//     );
//   }
// }
