import 'package:flutter/material.dart';

import 'displaylogin.dart';
import 'menu_drawer.dart';

class UserprofileLottery extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        title: Text("ผู้ใช้"),
      ),
      drawer: MenuDrawer(),
      body: Container(
        padding: EdgeInsets.all(30),
        child: Column(
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  primary: Colors.white,
                  onPrimary: Colors.black,
                  minimumSize: Size(double.infinity, 50)),
              child: Text("เพิ่มข้อมูลสลาก"),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SignUpLoginWidget()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
