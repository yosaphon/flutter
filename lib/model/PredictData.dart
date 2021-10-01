// To parse this JSON data, do
//
//     final predictData = predictDataFromJson(jsonString);

import 'dart:convert';

PredictData predictDataFromJson(String str) => PredictData.fromJson(json.decode(str));

String predictDataToJson(PredictData data) => json.encode(data.toJson());

class PredictData {
    PredictData({
        this.date,
        this.data,
    });

    String date;
    List<Datum> data;

    factory PredictData.fromJson(Map<String, dynamic> json) => PredictData(
        date: json["date"] == null ? null : json["date"],
        data: json["data"] == null ? null : List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "date": date == null ? null : date,
        "data": data == null ? null : List<dynamic>.from(data.map((x) => x.toJson())),
    };
}

class Datum {
    Datum({
        this.title,
        this.numbers,
    });

    String title;
    List<String> numbers;

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        title: json["title"] == null ? null : json["title"],
        numbers: json["numbers"] == null ? null : List<String>.from(json["numbers"].map((x) => x)),
    );

    Map<String, dynamic> toJson() => {
        "title": title == null ? null : title,
        "numbers": numbers == null ? null : List<dynamic>.from(numbers.map((x) => x)),
    };
}
