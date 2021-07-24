import 'package:cloud_firestore/cloud_firestore.dart';

class CheckNumber {
  final String date;
  final List<String> userNum;
  Map<int, Map<String, dynamic>> checked = {};
  Map<String, dynamic> result = {};
  int key = 0;

  CheckNumber(this.date, this.userNum);

  Future<Null> getSnapshot() async {
    DocumentSnapshot snapshot =
        await FirebaseFirestore.instance.collection('lottery').doc(date).get();
    checkPrize(snapshot);
    print(checked);
    //DialogHelper.exit(context);
  }

  checkPrize(snapshot) async {
    userNum.forEach((usernumber) {
      int keyNow = key;
      checkNormal(snapshot, usernumber); //ตรวจรางวัลปกติ
      checkFirst3(snapshot, usernumber); //ตรวจรางวัล 3 ตัวหน้า
      checkLast3(snapshot, usernumber); //ตรวจรางวัล 3 ตัวท้าย
      checkLast2(snapshot, usernumber); //ตรวจรางวัล 2 ตัวท้าย
      if (keyNow == key) {
        //ถ้าไม่มีข้อมูลที่ถูกเลย
        result = {
          'date': snapshot['drawdate'],
          'usernumber': usernumber,
          'name': '',
          'number': '',
          'reword': '',
          'status': 'false'
        };
        checked[key] = result;
        key++;
      }
    });
  }

  checkNormal(snapshot, usernumber) {
    snapshot['result'].forEach((index) {
      try {
        //รางวัลอื่นๆ
        for (final item in index['number']) {
          //print(usernumber+":"+item);
          if (usernumber == item) {
            result = {
              'date': snapshot['drawdate'],
              'usernumber': usernumber,
              'name': index['name'],
              'number': item,
              'reword': index['reword'],
              'status': 'true'
            };
            checked[key] = result;
            key++;
          }
        }
      } catch (e) {
        //รางวัลที่ 1
        if (usernumber == index['number']) {
          result = {
            'date': snapshot['drawdate'],
            'usernumber': usernumber,
            'name': index['name'],
            'number': index['number'],
            'reword': index['reword'],
            'status': 'true'
          };
          checked[key] = result;
          key++;
        }
      }
    });
  }

  checkFirst3(snapshot, usernumber) {
    String f3Num = usernumber.substring(0, 3); //ตัดเอาเลข 3 ตัวหน้า
    for (final item in snapshot['result'][1]['number']) {
      if (f3Num == item) {
        result = {
          'date': snapshot['drawdate'],
          'usernumber': usernumber,
          'name': snapshot['result'][1]['name'],
          'number': item,
          'reword': snapshot['result'][1]['reword'],
          'status': 'true'
        };
        checked[key] = result;
        key++;
        //print(result);
      }
    }
  }

  checkLast3(snapshot, usernumber) {
    String text = usernumber.substring(3, 6); //ตัดเอาเลข 3 ตัวหลัง
    for (final item in snapshot['result'][2]['number']) {
      if (text == item) {
        result = {
          'date': snapshot['drawdate'],
          'usernumber': usernumber,
          'name': snapshot['result'][2]['name'],
          'number': item,
          'reword': snapshot['result'][2]['reword'],
          'status': 'true'
        };
        checked[key] = result;
        key++;
      }
    }
  }

  checkLast2(snapshot, usernumber) {
    String text = usernumber.substring(4, 6); //ตัดเอาเลข 3 ตัวหลัง
    String number = snapshot['result'][3]['number'];
    if (text == number) {
      result = {
        'date': snapshot['drawdate'],
        'usernumber': usernumber,
        'name': snapshot['result'][3]['name'],
        'number': number,
        'reword': snapshot['result'][3]['reword'],
        'status': 'true'
      };
      checked[key] = result;
      key++;
    }
  }
}
