class RecommendedModel {
  RecommendedModel({
    this.data,
    this.status,
    this.message,
    this.balance,
    this.object,
    this.text,
    this.isAuthorized,
    this.obj,
    this.failureMessage,
  });

  final dynamic data;
  final String? status;
  final List<Message>? message;
  final dynamic balance;
  final dynamic object;
  final dynamic text;
  final bool? isAuthorized;
  String? failureMessage;

  final dynamic obj;

  factory RecommendedModel.fromJson(Map<String, dynamic> json) {
    return RecommendedModel(
      data: json["data"],
      status: json["status"],
      message: json["message"] == null
          ? []
          : List<Message>.from(
              json["message"]!.map((x) => Message.fromJson(x))),
      balance: json["balance"],
      object: json["Object"],
      text: json["Text"],
      isAuthorized: json["isAuthorized"],
      obj: json["Obj"],
    );
  }

  Map<String, dynamic> toJson() => {
        "data": data,
        "status": status,
        "message": message!.map((x) => x?.toJson()).toList(),
        "balance": balance,
        "Object": object,
        "Text": text,
        "isAuthorized": isAuthorized,
        "Obj": obj,
      };
}

class Message {
  Message({
    required this.id,
    required this.textAr,
    required this.textEn,
  });

  final int? id;
  final String? textAr;
  final String? textEn;

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json["ID"],
      textAr: json["TextAr"],
      textEn: json["TextEn"],
    );
  }

  Map<String, dynamic> toJson() => {
        "ID": id,
        "TextAr": textAr,
        "TextEn": textEn,
      };
}
