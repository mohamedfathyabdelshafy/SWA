// To parse this JSON data, do
//
//     final policyticketmodel = policyticketmodelFromJson(jsonString);

import 'dart:convert';

Policyticketmodel policyticketmodelFromJson(String str) =>
    Policyticketmodel.fromJson(json.decode(str));

class Policyticketmodel {
  String? status;
  List<String>? message;
  dynamic balance;
  dynamic object;
  dynamic obj;

  Policyticketmodel({
    this.status,
    this.message,
    this.balance,
    this.object,
    this.obj,
  });

  factory Policyticketmodel.fromJson(Map<String, dynamic> json) =>
      Policyticketmodel(
        status: json["status"],
        message: List<String>.from(json["message"].map((x) => x)),
        balance: json["balance"],
        object: json["Object"],
        obj: json["Obj"],
      );
}
