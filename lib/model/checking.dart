import 'package:cloud_firestore/cloud_firestore.dart';

class Checking {
  final String date;
  final String userNum;
  String name, number, reward;


  String get prize_name { 
      return name; 
   } 
    
  set prize_name(String name) { 
      this.name = name; 
   }   
  set prize_number(String number) { 
      this.number = number; 
   } 
    String get prize_number { 
      return number; 
   } 


  Map<String, String> result = {'name': null, 'number': null, 'reward': null};

  Checking(this.date, this.userNum) {
    CheckingNumber();
  }

  CheckingNumber() async {
    DocumentSnapshot snapshot =
        await FirebaseFirestore.instance.collection('lottery').doc(date).get();

    snapshot['prizes'].forEach((index) {
      index['number'].forEach((a) {
        if (a == userNum) {
          prize_name = index['name'];
          prize_number = a;
          //reward = index['reward'];
        }
      });
    });
  }
}
