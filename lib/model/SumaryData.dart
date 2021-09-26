// To parse this JSON data, do
//
//     final sumaryData = sumaryDataFromJson(jsonString);

import 'dart:convert';

SumaryData sumaryDataFromJson(String str) => SumaryData.fromJson(json.decode(str));

String sumaryDataToJson(SumaryData data) => json.encode(data.toJson());

class SumaryData {
    SumaryData({
        this.date,
        this.sumReward,
        this.sumPay,
        this.amount,
        this.number,
        this.checked,
        this.won,
    });

    String date;
    double sumReward;
    double sumPay;
    int amount;
    String number;
    bool checked;
    List<Won> won;

    factory SumaryData.fromJson(Map<String, dynamic> json) => SumaryData(
        date: json["date"] == null ? null : json["date"],
        sumReward: json["sumReward"] == null ? null : json["sumReward"].toDouble(),
        sumPay: json["sumPay"] == null ? null : json["sumPay"].toDouble(),
        amount: json["amount"] == null ? null : json["amount"],
        number: json["number"] == null ? null : json["number"],
        checked: json["checked"] == null ? null : json["checked"],
        won: json["won"] == null ? null : List<Won>.from(json["won"].map((x) => Won.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "date": date == null ? null : date,
        "sumReward": sumReward == null ? null : sumReward,
        "sumPay": sumPay == null ? null : sumPay,
        "amount": amount == null ? null : amount,
        "number": number == null ? null : number,
        "checked": checked == null ? null : checked,
        "won": won == null ? null : List<dynamic>.from(won.map((x) => x.toJson())),
    };
}

class Won {
    Won({
        this.name,
        this.wonNumber,
    });

    String name;
    String wonNumber;

    factory Won.fromJson(Map<String, dynamic> json) => Won(
        name: json["name"] == null ? null : json["name"],
        wonNumber: json["wonNumber"] == null ? null : json["wonNumber"],
    );

    Map<String, dynamic> toJson() => {
        "name": name == null ? null : name,
        "wonNumber": wonNumber == null ? null : wonNumber,
    };
}
