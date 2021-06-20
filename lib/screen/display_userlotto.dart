import 'package:flutter/material.dart';
import 'package:lotto/screen/check_menu.dart';
import 'formshowlotto.dart';
class UserprofileLottery extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        title: Text("ผู้ใช้"),
      ),
      drawer: CheckLogInMenu(),
      body: Container(
        padding: EdgeInsets.all(30),
        child: Column(
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  primary: Colors.white,
                  onPrimary: Colors.black,
                  minimumSize: Size(double.infinity, 50)),
              child: Text("ทดสอบlogin"),
              onPressed: () {
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  primary: Colors.white,
                  onPrimary: Colors.black,
                  minimumSize: Size(double.infinity, 50)),
              child: Text("เพิ่มสลาาก"),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Formshowlotto()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
