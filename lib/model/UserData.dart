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
        this.token,
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
    String token;

    factory UserData.fromJson(Map<String, dynamic> json) => UserData(
        username: json["username"] == null ? null : json["username"],
        number: json["number"] == null ? null : json["number"],
        amount: json["amount"] == null ? null : json["amount"],
        lotteryprice: json["lotteryprice"] == null ? null : json["lotteryprice"],
        imageurl: json["imageurl"] == null ? null : json["imageurl"],
        date: json["date"] == null ? null : json["date"],
        latlng: json["latlng"] == null ? null : json["latlng"],
        userid: json["userid"] == null ? null : json["userid"],
        state: json["state"] == null ? null : json["state"],
        won: json["won"] == null ? null : List<Won>.from(json["won"].map((x) => Won.fromJson(x))),
        token: json["token"] == null ? null : json["token"],
    );

    Map<String, dynamic> toJson() => {
        "username": username == null ? null : username,
        "number": number == null ? null : number,
        "amount": amount == null ? null : amount,
        "lotteryprice": lotteryprice == null ? null : lotteryprice,
        "imageurl": imageurl == null ? null : imageurl,
        "date": date == null ? null : date,
        "latlng": latlng == null ? null : latlng,
        "userid": userid == null ? null : userid,
        "state": state == null ? null : state,
        "won": won == null ? null : List<dynamic>.from(won.map((x) => x.toJson())),
        "token": token == null ? null : token,
    };
}

class Won {
    Won({
        this.name,
        this.reward,
        this.wonNum,
    });

    String name;
    double reward;
    String wonNum;

    factory Won.fromJson(Map<String, dynamic> json) => Won(
        name: json["name"] == null ? null : json["name"],
        reward: json["reward"] == null ? null : json["reward"].toDouble(),
        wonNum: json["wonNum"] == null ? null : json["wonNum"],
    );

    Map<String, dynamic> toJson() => {
        "name": name == null ? null : name,
        "reward": reward == null ? null : reward,
        "wonNum": wonNum == null ? null : wonNum,
    };
}
