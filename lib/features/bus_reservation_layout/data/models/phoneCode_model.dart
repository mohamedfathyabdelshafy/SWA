class PhonecountrycodeModel {
  PhonecountrycodeModel({
    this.status,
    this.codelist,
    this.balance,
    this.object,
    this.text,
    this.errormessage,
    this.obj,
  });

  String? status;
  String? errormessage;

  List<Codelist>? codelist;
  dynamic balance;
  dynamic object;
  dynamic text;
  dynamic obj;

  PhonecountrycodeModel.fromJson(Map<String, dynamic> json) {
    status = json["status"];

    if (json['status'] == 'success') {
      codelist = json["message"] == null
          ? []
          : List<Codelist>.from(
              json["message"]!.map((x) => Codelist.fromJson(x)));
    } else {
      errormessage = json["message"];
    }

    balance = json["balance"];
    object = json["Object"];
    text = json["Text"];
    obj = json["Obj"];
  }
}

class Codelist {
  Codelist({
    this.name,
    this.code,
  });

  String? name;
  String? code;

  factory Codelist.fromJson(Map<String, dynamic> json) {
    return Codelist(
      name: json["Name"],
      code: json["Code"],
    );
  }
}
