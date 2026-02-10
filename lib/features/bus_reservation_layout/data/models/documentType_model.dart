class IdentificationTypeModel {
  IdentificationTypeModel({
    this.status,
    this.message,
    this.balance,
    this.errormessage,
    this.object,
    this.text,
    this.obj,
  });

  String? status;
  String? errormessage;

  Map<String, int>? message;
  dynamic balance;
  Object? object;
  dynamic text;
  dynamic obj;

  IdentificationTypeModel.fromJson(Map<String, dynamic> json) {
    status = json["status"];
    if (json['status'] == 'success') {
      message =
          Map.from(json["message"]).map((k, v) => MapEntry<String, int>(k, v));
    } else {
      errormessage = json['message'];
    }

    balance = json["balance"];
    object = json["Object"] == null ? null : Object.fromJson(json["Object"]);
    text = json["Text"];
    obj = json["Obj"];
  }
}

class Object {
  Object({
    this.display,
    this.isRequired,
    this.title,
  });

  bool? display;
  bool? isRequired;
  String? title;

  factory Object.fromJson(Map<String, dynamic> json) {
    return Object(
      display: json["Display"],
      isRequired: json["IsRequired"],
      title: json["Title"],
    );
  }
}

class documentdetails {
  final int? typeid;
  final String? value;

  documentdetails(this.typeid, this.value);
}
