class Idtextfieldmodel {
  Idtextfieldmodel({
    this.status,
    this.message,
    this.balance,
    this.object,
    this.errormessage,
    this.text,
    this.obj,
  });

  String? status;
  Message? message;
  dynamic balance;
  dynamic object;
  dynamic text;
  String? errormessage;

  dynamic obj;

  Idtextfieldmodel.fromJson(Map<String, dynamic> json) {
    status = json["status"];
    if (json['status'] == 'success') {
      message =
          json["message"] == null ? null : Message.fromJson(json["message"]);
    } else {
      errormessage = json['message'];
    }

    balance = json["balance"];
    object = json["Object"];
    text = json["Text"];
    obj = json["Obj"];
  }
}

class Message {
  Message({
    required this.title,
    required this.length,
    required this.validationMesage,
  });

  String? title;
  int? length;
  String? validationMesage;

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      title: json["Title"],
      length: json["Length"],
      validationMesage: json["ValidationMesage"],
    );
  }
}
