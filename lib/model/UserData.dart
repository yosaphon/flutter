// To parse this JSON data, do
//
//     final userData = userDataFromJson(jsonString);

import 'dart:convert';

UserData userDataFromJson(String str) => UserData.fromJson(json.decode(str));

String userDataToJson(UserData data) => json.encode(data.toJson());

class UserData {
    UserData({
        this.username,
        this.number,
        this.amount,
        this.lotteryprice,
        this.imageurl,
        this.date,
        this.latlng,
        this.userid,
        this.state,
        this.won,
    });

    String username;
    String number;
    String amount;
    String lotteryprice;
    String imageurl;
    String date;
    String latlng;
    String userid;
    bool state;
    List<Won> won;

    factory UserData.fromJson(Map<String, dynamic> json) => UserData(
        username: json["username"],
        number: json["number"],
        amount: json["amount"],
        lotteryprice: json["lotteryprice"],
        imageurl: json["imageurl"],
        date: json["date"],
        latlng: json["latlng"],
        userid: json["userid"],
        state: json["state"],
        won: List<Won>.from(json["won"].map((x) => Won.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "username": username,
        "number": number,
        "amount": amount,
        "lotteryprice": lotteryprice,
        "imageurl": imageurl,
        "date": date,
        "latlng": latlng,
        "userid": userid,
        "state": state,
        "won": List<dynamic>.from(won.map((x) => x.toJson())),
    };
}

class Won {
    Won({
        this.name,
        this.wonNum,
        this.reward,
    });

    String name;
    String wonNum;
    double reward;

    factory Won.fromJson(Map<String, dynamic> json) => Won(
        name: json["name"],
        wonNum: json["wonNum"],
        reward: json["reward"].toDouble(),
    );

    Map<String, dynamic> toJson() => {
        "name": name,
        "wonNum": wonNum,
        "reward": reward,
    };
}
