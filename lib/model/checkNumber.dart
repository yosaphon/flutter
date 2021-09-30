import 'package:flutter/cupertino.dart';
import 'package:lotto/model/PrizeData.dart';
import 'package:lotto/notifier/prize_notifier.dart';

class CheckNumber {
  final List<String> userNum;
  final PrizeNotifier prizeNotifier;
  final String date;
  List<CheckResult> _listCheckResult = [];
  //List<List<CheckResult>> _allNumlistCheckResult = [];
  CheckResult checkResult;
  int _length = 0;
  int peroid; //งวดสำหรับแสกน
  List<String> _first = [],
      _second = [],
      _third = [],
      _fourth = [],
      _fifth = [],
      _near1st = [],
      _last2 = [],
      _last3f = [],
      _last3b = [];
  PrizeData getSelectedData;
  int getLength() => this._length;

  CheckNumber(
      {@required this.userNum, this.peroid, this.prizeNotifier, this.date}) {
    //ตรวจแบบกรอกเลข
    if (peroid == null && date == null) {
      print("ตรวจแบบกรอกเลข");
      getSelectedData = prizeNotifier.selectedPrize;
      getDataForCheck(getSelectedData);
      print(prizeNotifier.selectedPrize.date);
      print("_first  = $_first   ");
      print("_second = $_second   ");
      print("_third  = $_third   ");
      print("_fourth = $_fourth   ");
      print("_fifth  = $_fifth   ");
      print("_near1st= $_near1st   ");
      print("_last2  = $_last2   ");
      print("_last3f = $_last3f   ");
      print("_last3b = $_last3b   ");
      print("_usernumber = $userNum");
      checkPrize();

      print(_listCheckResult);
      _listCheckResult.forEach((element) {
        print(element);
        print(element.name);
        print(element.reword);
        print(element.status);
        print(element.date);
        print(element.number);
      });
    } else if (peroid != null && date == null) {
      print("ตรวจแบบใช้งวด // แสกน");
      print(peroid);
      var x = prizeNotifier.prizeList.values.where((element) {
        return element.period.contains(peroid);
      });

      print("วันที่ได้ ${x.first.date}");
      getSelectedData = x.first;
      getDataForCheck(getSelectedData);
      checkPrize();
    }
    //ตรวจแบบแสกน
    else {
      print("ตรวจแบบใช้วันที่");
      //print("scan  $peroid $userNum");
      var x = prizeNotifier.prizeList.values.where((element) {
        return element.date == date;
      });
      getSelectedData = x.first;
      getDataForCheck(getSelectedData);
      checkPrize();
    }
  }

  List<CheckResult> getCheckedData() {
    print("เข้า checkingNumber");
    //checkPrize();
    return _listCheckResult;
  }

  getDataForCheck(PrizeData prizeData) {
    prizeData.data.forEach((key, eachPrize) {
      eachPrize.number.forEach((eachNum) {
        switch (key) {
          case "first":
            _first.add(eachNum.value);
            break;
          case "second":
            _second.add(eachNum.value);
            break;
          case "third":
            _third.add(eachNum.value);
            break;
          case "fourth":
            _fourth.add(eachNum.value);
            break;
          case "fifth":
            _fifth.add(eachNum.value);
            break;
          case "near1":
            _near1st.add(eachNum.value);
            break;
          case "last2":
            _last2.add(eachNum.value);
            break;
          case "last3f":
            _last3f.add(eachNum.value);
            break;
          case "last3b":
            _last3b.add(eachNum.value);
            break;
          default:
            print("ผิดพลาด");
        }
      });
    });
  }

  bool status = false;
  checkPrize() {
    userNum.forEach((usernumber) {
      status = false;
      //_listCheckResult = [];
      checkNormal(usernumber); //ตรวจรางวัลปกติ
      checkFirst3(usernumber); //ตรวจรางวัล 3 ตัวหน้า
      checkLast3(usernumber); //ตรวจรางวัล 3 ตัวท้าย
      checkLast2(usernumber); //ตรวจรางวัล 2 ตัวท้าย

      //ถ้าไม่มีข้อมูลที่ถูกเลย
      if (status != true) {
        _listCheckResult.add(new CheckResult(
            date: getSelectedData.date,
            usernumber: usernumber,
            name: '',
            number: '',
            reword: '',
            status: false));
        _length++;
      }
      //_allNumlistCheckResult.add(_listCheckResult);
      //_length++;
    });
  }

  checkNormal(usernumber) {
    //check first
    _first.forEach((eachNum) {
      //print(usernumber+":"+item);
      if (usernumber == eachNum) {
        _listCheckResult.add(new CheckResult(
            date: getSelectedData.date,
            usernumber: usernumber,
            name: "รางวัลที่ 1",
            number: eachNum,
            reword: getSelectedData.data['first'].price,
            status: true));
        _length++;
        status = true;
      }
    });

    //check second
    _second.forEach((eachNum) {
      //print(usernumber+":"+item);
      if (usernumber == eachNum) {
        _listCheckResult.add(new CheckResult(
            date: getSelectedData.date,
            usernumber: usernumber,
            name: "รางวัลที่ 2",
            number: eachNum,
            reword: getSelectedData.data["second"].price,
            status: true));
        _length++;
        status = true;
      }
    });

    //check third
    _third.forEach((eachNum) {
      //print(usernumber+":"+item);
      if (usernumber == eachNum) {
        _listCheckResult.add(new CheckResult(
            date: getSelectedData.date,
            usernumber: usernumber,
            name: "รางวัลที่ 3",
            number: eachNum,
            reword: getSelectedData.data["third"].price,
            status: true));
        _length++;
        status = true;
      }
    });

    //check fourth
    _fourth.forEach((eachNum) {
      //print(usernumber+":"+item);
      if (usernumber == eachNum) {
        _listCheckResult.add(new CheckResult(
            date: getSelectedData.date,
            usernumber: usernumber,
            name: "รางวัลที่ 4",
            number: eachNum,
            reword: getSelectedData.data["fourth"].price,
            status: true));
        _length++;
        status = true;
      }
    });

    //check fifth
    _fifth.forEach((eachNum) {
      //print(usernumber+":"+item);
      if (usernumber == eachNum) {
        _listCheckResult.add(new CheckResult(
            date: getSelectedData.date,
            usernumber: usernumber,
            name: "รางวัลที่ 5",
            number: eachNum,
            reword: getSelectedData.data["fifth"].price,
            status: true));
        _length++;
        status = true;
      }
    });
  }

  checkFirst3(usernumber) {
    String f3Num = usernumber.substring(0, 3); //ตัดเอาเลข 3 ตัวหน้า
    for (final item in _last3f) {
      if (f3Num == item) {
        _listCheckResult.add(new CheckResult(
            date: getSelectedData.date,
            usernumber: usernumber,
            name: "รางวัลเลข 3 ตัวหน้า",
            number: item,
            reword: getSelectedData.data["last3f"].price,
            status: true));
        _length++;
        status = true;

        //print(checkResult);
      }
    }
  }

  checkLast3(usernumber) {
    String last3b = usernumber.substring(3, 6); //ตัดเอาเลข 3 ตัวหลัง
    for (final item in _last3b) {
      if (last3b == item) {
        _listCheckResult.add(new CheckResult(
            date: getSelectedData.date,
            usernumber: usernumber,
            name: "รางวัลเลข 3 ตัวท้าย",
            number: item,
            reword: getSelectedData.data["last3b"].price,
            status: true));
        _length++;
        status = true;
      }
    }
  }

  checkLast2(usernumber) {
    String last2 = usernumber.substring(4, 6); //ตัดเอาเลข 3 ตัวหลัง
    for (final item in _last2) {
      if (last2 == item) {
        _listCheckResult.add(new CheckResult(
            date: getSelectedData.date,
            usernumber: usernumber,
            name: "รางวัลเลข 2 ตัวท้าย",
            number: item,
            reword: getSelectedData.data["last2"].price,
            status: true));
        _length++;
        status = true;
      }
    }
  }
}

class CheckResult {
  CheckResult({
    this.date,
    this.usernumber,
    this.name,
    this.number,
    this.reword,
    this.status,
  });

  String date;
  String usernumber;
  String name;
  String number;
  String reword;
  bool status;
}
