import 'package:lotto/notifier/prize_notifier.dart';

class CheckNumber {
  final List<String> userNum;
  final PrizeNotifier prizeNotifier;
  List<CheckResult> _listCheckResult = [];
  Map<String, List<CheckResult>> _allNumlistCheckResult = {};
  CheckResult checkResult;
  int key = 0;
  int index; //งวดสำหรับแสกน
  List<String> _first = [],
      _second = [],
      _third = [],
      _fourth = [],
      _fifth = [],
      _near1st = [],
      _last2 = [],
      _last3f = [],
      _last3b = [];

   CheckNumber({this.userNum, this.index, this.prizeNotifier}) {
    prizeNotifier.selectedPrize.data.forEach((key, eachPrize) {
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

    print(_allNumlistCheckResult);
    _allNumlistCheckResult.forEach((key, element) {
      print(key);
      print(element[0].name);
      print(element[0].reword);
      print(element[0].status);
      print(element[0].date);
      print(element[0].number);
    
    });
  }

  Map<String, List<CheckResult>> getCheckedData() {
    print("เข้า checkingNumber");
    //checkPrize();
    return _allNumlistCheckResult;
  }

  checkPrize() {
    userNum.forEach((usernumber) {
      _listCheckResult = [];
      checkNormal(usernumber); //ตรวจรางวัลปกติ
      checkFirst3(usernumber); //ตรวจรางวัล 3 ตัวหน้า
      checkLast3(usernumber); //ตรวจรางวัล 3 ตัวท้าย
      checkLast2(usernumber); //ตรวจรางวัล 2 ตัวท้าย

      //ถ้าไม่มีข้อมูลที่ถูกเลย
      if (_listCheckResult.length < 1) {
        _listCheckResult.add(new CheckResult(
            date: prizeNotifier.selectedPrize.date,
            usernumber: usernumber,
            name: '',
            number: '',
            reword: '',
            status: false));
      }
      _allNumlistCheckResult[usernumber] = _listCheckResult;
    });
  }

  checkNormal(usernumber) {
    //check first
    _first.forEach((eachNum) {
      //print(usernumber+":"+item);
      if (usernumber == eachNum) {
        _listCheckResult.add(new CheckResult(
            date: prizeNotifier.selectedPrize.date,
            usernumber: usernumber,
            name: "รางวัลที่ 1",
            number: eachNum,
            reword: prizeNotifier.selectedPrize.data['first'].price,
            status: true));
      }
    });

    //check second
    _second.forEach((eachNum) {
      //print(usernumber+":"+item);
      if (usernumber == eachNum) {
        _listCheckResult.add(new CheckResult(
            date: prizeNotifier.selectedPrize.date,
            usernumber: usernumber,
            name: "รางวัลที่ 2",
            number: eachNum,
            reword: prizeNotifier.selectedPrize.data["second"].price,
            status: true));
      }
    });

    //check third
    _third.forEach((eachNum) {
      //print(usernumber+":"+item);
      if (usernumber == eachNum) {
        _listCheckResult.add(new CheckResult(
            date: prizeNotifier.selectedPrize.date,
            usernumber: usernumber,
            name: "รางวัลที่ 3",
            number: eachNum,
            reword: prizeNotifier.selectedPrize.data["third"].price,
            status: true));
      }
    });

    //check fourth
    _fourth.forEach((eachNum) {
      //print(usernumber+":"+item);
      if (usernumber == eachNum) {
        _listCheckResult.add(new CheckResult(
            date: prizeNotifier.selectedPrize.date,
            usernumber: usernumber,
            name: "รางวัลที่ 4",
            number: eachNum,
            reword: prizeNotifier.selectedPrize.data["fourth"].price,
            status: true));
      }
    });

    //check fifth
    _fifth.forEach((eachNum) {
      //print(usernumber+":"+item);
      if (usernumber == eachNum) {
        _listCheckResult.add(new CheckResult(
            date: prizeNotifier.selectedPrize.date,
            usernumber: usernumber,
            name: "รางวัลที่ 5",
            number: eachNum,
            reword: prizeNotifier.selectedPrize.data["fifth"].price,
            status: true));
      }
    });
  }

  checkFirst3(usernumber) {
    String f3Num = usernumber.substring(0, 3); //ตัดเอาเลข 3 ตัวหน้า
    for (final item in _last3f) {
      if (f3Num == item) {
        _listCheckResult.add(new CheckResult(
            date: prizeNotifier.selectedPrize.date,
            usernumber: usernumber,
            name: "รางวัลเลข 3 ตัวหน้า",
            number: item,
            reword: prizeNotifier.selectedPrize.data["last3f"].price,
            status: true));

        //print(checkResult);
      }
    }
  }

  checkLast3(usernumber) {
    String last3b = usernumber.substring(3, 6); //ตัดเอาเลข 3 ตัวหลัง
    for (final item in _last3b) {
      if (last3b == item) {
        _listCheckResult.add(new CheckResult(
            date: prizeNotifier.selectedPrize.date,
            usernumber: usernumber,
            name: "รางวัลเลข 3 ตัวท้าย",
            number: item,
            reword: prizeNotifier.selectedPrize.data["last3b"].price,
            status: true));
      }
    }
  }

  checkLast2(usernumber) {
    String last2 = usernumber.substring(4, 6); //ตัดเอาเลข 3 ตัวหลัง
    for (final item in _last2) {
      if (last2 == item) {
        _listCheckResult.add(new CheckResult(
            date: prizeNotifier.selectedPrize.date,
            usernumber: usernumber,
            name: "รางวัลเลข 2 ตัวท้าย",
            number: item,
            reword: prizeNotifier.selectedPrize.data["last2"].price,
            status: true));
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
