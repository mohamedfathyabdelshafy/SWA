import 'package:flutter/material.dart';
import 'package:swa/features/app_info/domain/entities/country.dart';

class CountryModel extends Country {
  int countryId;
  String countryName;
  String Code;
  String Flag;
  String curruncy;

  CountryModel(
      {required this.countryId,
      required this.countryName,
      required this.Code,
      required this.Flag,
      required this.curruncy})
      : super(
            countryId: countryId,
            countryName: countryName,
            Flag: Flag,
            Code: Code,
            curruncy: curruncy);

  factory CountryModel.fromJson(Map<String, dynamic> json) => CountryModel(
      countryId: json["CountryID"],
      countryName: json["CountryName"],
      Code: json["Code"],
      curruncy: json["Currency"],
      Flag: json["Flag"]);

  Map<String, dynamic> toJson() => {
        "CountryID": countryId,
        "CountryName": countryName,
      };
}
