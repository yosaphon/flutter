// To parse this JSON data, do
//
//     final predictData = predictDataFromJson(jsonString);

import 'dart:convert';

PredictData predictDataFromJson(String str) => PredictData.fromJson(json.decode(str));

String predictDataToJson(PredictData data) => json.encode(data.toJson());

class PredictData {
    PredictData({
        this.date,
        this.name,
        this.number,
        this.url,
    });

    String date;
    String name;
    String number;
    String url;

    factory PredictData.fromJson(Map<String, dynamic> json) => PredictData(
        date: json["date"] == null ? null : json["date"],
        name: json["name"] == null ? null : json["name"],
        number: json["number"] == null ? null : json["number"],
        url: json["url"] == null ? null : json["url"],
    );

    Map<String, dynamic> toJson() => {
        "date": date == null ? null : date,
        "name": name == null ? null : name,
        "number": number == null ? null : number,
        "url": url == null ? null : url,
    };
}
