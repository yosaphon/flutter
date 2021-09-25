// To parse this JSON data, do
//
//     final sumaryData = sumaryDataFromJson(jsonString);

import 'dart:convert';

SumaryData sumaryDataFromJson(String str) => SumaryData.fromJson(json.decode(str));

String sumaryDataToJson(SumaryData data) => json.encode(data.toJson());

class SumaryData {
    SumaryData({
        this.date,
        this.won,
        this.pay,
        this.amount,
        this.wonNumber,
        this.loseNumber,
        this.wonAmount,
    });

    DateTime date;
    String won;
    String pay;
    int amount;
    List<WonNumber> wonNumber;
    List<String> loseNumber;
    int wonAmount;

    factory SumaryData.fromJson(Map<String, dynamic> json) => SumaryData(
        date: json["date"] == null ? null : DateTime.parse(json["date"]),
        won: json["won"] == null ? null : json["won"],
        pay: json["pay"] == null ? null : json["pay"],
        amount: json["amount"] == null ? null : json["amount"],
        wonNumber: json["wonNumber"] == null ? null : List<WonNumber>.from(json["wonNumber"].map((x) => WonNumber.fromJson(x))),
        loseNumber: json["loseNumber"] == null ? null : List<String>.from(json["loseNumber"].map((x) => x)),
        wonAmount: json["wonAmount"] == null ? null : json["wonAmount"],
    );

    Map<String, dynamic> toJson() => {
        "date": date == null ? null : "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
        "won": won == null ? null : won,
        "pay": pay == null ? null : pay,
        "amount": amount == null ? null : amount,
        "wonNumber": wonNumber == null ? null : List<dynamic>.from(wonNumber.map((x) => x.toJson())),
        "loseNumber": loseNumber == null ? null : List<dynamic>.from(loseNumber.map((x) => x)),
        "wonAmount": wonAmount == null ? null : wonAmount,
    };
}

class WonNumber {
    WonNumber({
        this.name,
        this.number,
    });

    String name;
    List<String> number;

    factory WonNumber.fromJson(Map<String, dynamic> json) => WonNumber(
        name: json["name"] == null ? null : json["name"],
        number: json["number"] == null ? null : List<String>.from(json["number"].map((x) => x)),
    );

    Map<String, dynamic> toJson() => {
        "name": name == null ? null : name,
        "number": number == null ? null : List<dynamic>.from(number.map((x) => x)),
    };
}
