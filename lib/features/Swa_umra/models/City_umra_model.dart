// To parse this JSON data, do
//
//     final cityUmramodel = cityUmramodelFromJson(jsonString);

import 'dart:convert';

CityUmramodel cityUmramodelFromJson(String str) =>
    CityUmramodel.fromJson(json.decode(str));

class CityUmramodel {
  String? status;
  List<City>? message;
  dynamic balance;
  dynamic object;
  dynamic text;
  dynamic obj;

  CityUmramodel({
    this.status,
    this.message,
    this.balance,
    this.object,
    this.text,
    this.obj,
  });

  factory CityUmramodel.fromJson(Map<String, dynamic> json) => CityUmramodel(
        status: json["status"],
        message: List<City>.from(json["message"].map((x) => City.fromJson(x))),
        balance: json["balance"],
        object: json["Object"],
        text: json["Text"],
        obj: json["Obj"],
      );
}

class City {
  int? cityId;
  String? cityName;

  City({
    this.cityId,
    this.cityName,
  });

  factory City.fromJson(Map<String, dynamic> json) => City(
        cityId: json["CityID"],
        cityName: json["CityName"],
      );

  Map<String, dynamic> toJson() => {
        "CityID": cityId,
        "CityName": cityName,
      };
}
