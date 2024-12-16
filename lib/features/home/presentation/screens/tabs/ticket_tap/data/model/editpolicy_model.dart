// To parse this JSON data, do
//
//     final editpolicymodel = editpolicymodelFromJson(jsonString);

import 'dart:convert';

Editpolicymodel editpolicymodelFromJson(String str) =>
    Editpolicymodel.fromJson(json.decode(str));

class Editpolicymodel {
  String? status;
  List<String>? message;
  String? errormessage;
  dynamic balance;
  dynamic object;
  dynamic obj;

  Editpolicymodel({
    this.status,
    this.message,
    this.errormessage,
    this.balance,
    this.object,
    this.obj,
  });

  Editpolicymodel.fromJson(dynamic json) {
    status = json["status"];
    if (json["status"] == 'success') {
      message = List<String>.from(json["message"].map((x) => x));
    } else {
      errormessage = json["message"];
    }
    balance = json['balance'];
    object = json['Object'];
    obj = json['Obj'];
  }
}
