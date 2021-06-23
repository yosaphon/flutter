// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);

import 'dart:convert';

Welcome welcomeFromJson(String str) => Welcome.fromJson(json.decode(str));

String welcomeToJson(Welcome data) => json.encode(data.toJson());

class Welcome {
    Welcome({
        this.date,
        this.endpoint,
        this.prizes,
        this.runningNumbers,
    });

    String date;
    String endpoint;
    List<Prize> prizes;
    List<Prize> runningNumbers;

    factory Welcome.fromJson(Map<String, dynamic> json) => Welcome(
        date: json["date"],
        endpoint: json["endpoint"],
        prizes: List<Prize>.from(json["prizes"].map((x) => Prize.fromJson(x))),
        runningNumbers: List<Prize>.from(json["runningNumbers"].map((x) => Prize.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "date": date,
        "endpoint": endpoint,
        "prizes": List<dynamic>.from(prizes.map((x) => x.toJson())),
        "runningNumbers": List<dynamic>.from(runningNumbers.map((x) => x.toJson())),
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

    factory Prize.fromJson(Map<String, dynamic> json) => Prize(
        id: json["id"],
        name: json["name"],
        reward: json["reward"],
        amount: json["amount"],
        number: List<String>.from(json["number"].map((x) => x)),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "reward": reward,
        "amount": amount,
        "number": List<dynamic>.from(number.map((x) => x)),
    };
}
