// To parse this JSON data, do
//
//     final prizeData = prizeDataFromJson(jsonString);

import 'dart:convert';

PrizeData prizeDataFromJson(String str) => PrizeData.fromJson(json.decode(str));

String prizeDataToJson(PrizeData data) => json.encode(data.toJson());

class PrizeData {
    PrizeData({
        this.youtubeUrl,
        this.pdfUrl,
        this.date,
        this.period,
        this.remark,
        this.status,
        this.sheetId,
        this.data,
    });

    String youtubeUrl;
    String pdfUrl;
    String date;
    List<int> period;
    dynamic remark;
    int status;
    String sheetId;
    Map<String, Datum> data;

    factory PrizeData.fromJson(Map<String, dynamic> json) => PrizeData(
        youtubeUrl: json["youtube_url"] == null ? null : json["youtube_url"],
        pdfUrl: json["pdf_url"] == null ? null : json["pdf_url"],
        date: json["date"] == null ? null : json["date"],
        period: json["period"] == null ? null : List<int>.from(json["period"].map((x) => x)),
        remark: json["remark"],
        status: json["status"] == null ? null : json["status"],
        sheetId: json["sheetId"] == null ? null : json["sheetId"],
        data: json["data"] == null ? null : Map.from(json["data"]).map((k, v) => MapEntry<String, Datum>(k, Datum.fromJson(v))),
    );

    Map<String, dynamic> toJson() => {
        "youtube_url": youtubeUrl == null ? null : youtubeUrl,
        "pdf_url": pdfUrl == null ? null : pdfUrl,
        "date": date == null ? null : date,
        "period": period == null ? null : List<dynamic>.from(period.map((x) => x)),
        "remark": remark,
        "status": status == null ? null : status,
        "sheetId": sheetId == null ? null : sheetId,
        "data": data == null ? null : Map.from(data).map((k, v) => MapEntry<String, dynamic>(k, v.toJson())),
    };
}

class Datum {
    Datum({
        this.price,
        this.number,
    });

    String price;
    List<Number> number;

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        price: json["price"] == null ? null : json["price"],
        number: json["number"] == null ? null : List<Number>.from(json["number"].map((x) => Number.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "price": price == null ? null : price,
        "number": number == null ? null : List<dynamic>.from(number.map((x) => x.toJson())),
    };
}

class Number {
    Number({
        this.round,
        this.value,
    });

    int round;
    String value;

    factory Number.fromJson(Map<String, dynamic> json) => Number(
        round: json["round"] == null ? null : json["round"],
        value: json["value"] == null ? null : json["value"],
    );

    Map<String, dynamic> toJson() => {
        "round": round == null ? null : round,
        "value": value == null ? null : value,
    };
}
