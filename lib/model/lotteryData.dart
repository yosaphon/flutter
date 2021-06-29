// To parse this JSON data, do
//
//     final lotteryData = lotteryDataFromJson(jsonString);

import 'package:cloud_firestore/cloud_firestore.dart';

class LotteryData {
  LotteryData({
    this.date,
    this.endpoint,
    this.prizes,
    this.runningNumbers,
  });

  String date;
  String endpoint;
  List<Prize> prizes;
  List<Prize> runningNumbers;


  LotteryData.fromMap(Map<String, dynamic> data) {
    date = data["date"];
    endpoint = data["endpoint"];
    prizes = List<Prize>.from(data["prizes"].map((x) => Prize.fromMap(x)));
    runningNumbers =
        List<Prize>.from(data["runningNumbers"].map((x) => Prize.fromMap(x)));
  }

  Map<String, dynamic> toMap() => {
        "date": date,
        "endpoint": endpoint,
        "prizes": List<dynamic>.from(prizes.map((x) => x.toMap())),
        "runningNumbers":
            List<dynamic>.from(runningNumbers.map((x) => x.toMap())),
      };
}

class Prize {
  Prize({
    this.id,
    this.name,
    this.reward,
    this.amount,
    this.number,
  });

  String id;
  String name;
  String reward;
  int amount;
  List<String> number;

  factory Prize.fromMap(Map<String, dynamic> data) => Prize(
        id: data["id"],
        name: data["name"],
        reward: data["reward"],
        amount: data["amount"],
        number: List<String>.from(data["number"].map((x) => x)),
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
        "reward": reward,
        "amount": amount,
        "number": List<dynamic>.from(number.map((x) => x)),
      };
}
