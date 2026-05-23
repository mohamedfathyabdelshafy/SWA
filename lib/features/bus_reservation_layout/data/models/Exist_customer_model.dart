class CustomerExistmodel {
  CustomerExistmodel({
    required this.status,
    required this.message,
    required this.balance,
    required this.object,
    required this.text,
    required this.obj,
    required this.isAutherized,
  });

  String? status;
  Message? message;
  String? error;

  dynamic balance;
  dynamic object;
  dynamic text;
  dynamic obj;
  bool? isAutherized;

  CustomerExistmodel.fromJson(Map<String, dynamic> json) {
    status = json["status"];

    if (json['status'] == 'success') {
      message = json["message"] == null ? null : Message.fromJson(json["message"]);
    } else {
      error = json['message'];
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
    required this.isCustomer,
    required this.tempCustomerId,
    required this.nationalityId,
    required this.fullName,
    required this.mobile,
    required this.isRegistered,
    required this.isAuthorized,
  });

  final bool? isCustomer;
  final dynamic tempCustomerId;
  final dynamic nationalityId;
  final String? fullName;
  final String? mobile;
  final bool? isRegistered;
  final bool? isAuthorized;

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      isCustomer: json["IsCustomer"],
      tempCustomerId: json["TempCustomerID"],
      nationalityId: json["NationalityID"],
      fullName: json["FullName"],
      mobile: json["Mobile"],
      isRegistered: json["IsRegistered"],
      isAuthorized: json["isAuthorized"],
    );
  }
}
