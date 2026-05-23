class InstitutionsModel {
  InstitutionsModel({
    this.status,
    this.message,
    this.balance,
    this.errormessage,
    this.object,
    this.text,
    this.obj,
    this.isAutherized,
  });

  String? status;
  List<Message>? message;

  String? errormessage;

  dynamic balance;
  dynamic object;
  dynamic text;
  dynamic obj;
  bool? isAutherized;

  InstitutionsModel.fromJson(Map<String, dynamic> json) {
    status = json["status"];
    if (status == 'success') {
      message = json["message"] == null ? [] : List<Message>.from(json["message"]!.map((x) => Message.fromJson(x)));
    } else {
      errormessage = json["message"];
    }
    balance = json["balance"];
    object = json["Object"];
    text = json["Text"];
    obj = json["Obj"];
    isAutherized = json["IsAutherized"];
  }
}

class Message {
  Message({
    this.name,
    this.id,
  });

  final String? name;
  final int? id;

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      name: json["Name"],
      id: json["Id"],
    );
  }
}
