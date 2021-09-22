// To parse this JSON data, do
//
//     final userData = userDataFromJson(jsonString);

import 'dart:convert';

UserData userDataFromJson(String str) => UserData.fromJson(json.decode(str));

String userDataToJson(UserData data) => json.encode(data.toJson());

class UserData {
    UserData({
        this.amount,
        this.date,
        this.imageurl,
        this.latlng,
        this.lotteryprice,
        this.number,
        this.reward,
        this.state,
        this.userid,
        this.username,
    });

    String amount;
    String date;
    String imageurl;
    String latlng;
    String lotteryprice;
    String number;
    String reward;
    bool state;
    String userid;
    String username;

    factory UserData.fromJson(Map<String, dynamic> json) => UserData(
        amount: json["amount"] == null ? null : json["amount"],
        date: json["date"] == null ? null : json["date"],
        imageurl: json["imageurl"] == null ? null : json["imageurl"],
        latlng: json["latlng"] == null ? null : json["latlng"],
        lotteryprice: json["lotteryprice"] == null ? null : json["lotteryprice"],
        number: json["number"] == null ? null : json["number"],
        reward: json["reward"] == null ? null : json["reward"],
        state: json["state"] == null ? null : json["state"],
        userid: json["userid"] == null ? null : json["userid"],
        username: json["username"] == null ? null : json["username"],
    );

    Map<String, dynamic> toJson() => {
        "amount": amount == null ? null : amount,
        "date": date == null ? null : date,
        "imageurl": imageurl == null ? null : imageurl,
        "latlng": latlng == null ? null : latlng,
        "lotteryprice": lotteryprice == null ? null : lotteryprice,
        "number": number == null ? null : number,
        "reward": reward == null ? null : reward,
        "state": state == null ? null : state,
        "userid": userid == null ? null : userid,
        "username": username == null ? null : username,
    };
}
