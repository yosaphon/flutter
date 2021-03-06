// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:lotto/provider/google_sign_in.dart';
// import 'package:provider/provider.dart';

// import '../main.dart';

// class MenuDrawer extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     final user = FirebaseAuth.instance.currentUser;
//     return Drawer(
//       child: Column(
//         children: [
//             Container(
//               width: double.infinity,
//               padding: EdgeInsets.all(20),
//               color: Theme.of(context).primaryColor,
//               child: Center(
//                 child: Column(
//                   children: [
//                     Container(
//                       width: 100,
//                       height: 100,
//                       margin: EdgeInsets.only(bottom: 10, top: 30),
//                       // รูปโปรไฟล์
//                       decoration: BoxDecoration(
//                         shape: BoxShape.circle,
//                         image: DecorationImage(
//                           image: NetworkImage(user.photoURL),
//                           fit: BoxFit.fill,
//                         ),
//                       ),
//                     ),
//                     // ชื่อผู้ใช้
//                     Text(
//                       user.displayName,
//                       style: TextStyle(
//                         fontSize: 22,
//                         color: Colors.white,
//                       ),
//                     ),
//                     // Email
//                     Text(
//                       user.email,
//                       style: TextStyle(
//                         color: Colors.white,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
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
//               "Log Out",
//               style: TextStyle(
//                 fontSize: 18,
//               ),
//             ),
//             onTap: () {
//               final provider =
//                   Provider.of<GoogleSignInProvider>(context, listen: false);
//               provider.logout();
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (context) => MyHomePage()),
//               );
//             },
//           ),
//         ],
//       ),
//     );
//   }
// }
