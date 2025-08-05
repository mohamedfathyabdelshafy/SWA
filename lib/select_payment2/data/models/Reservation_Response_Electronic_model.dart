class ReservationResponseElectronicModel {
  ReservationResponseElectronicModel({
    this.status,
    this.message,
    this.errormessage,
    this.balance,
    this.object,
    this.obj,
    this.data,
    this.text,
    this.isAuthorized,
  });

  ReservationResponseElectronicModel.fromJson(dynamic json) {
    status = json['status'];

    if (status == 'success') {
      message = Message.fromJson(json['message']);
    } else {
      errormessage = json['message'];
    }

    balance = json['balance'];
    object = json['Object'];
    obj = json['Obj'];
    text = json['Text'] ?? '';

    data = json['data'];
    isAuthorized = json['isAuthorized'];
  }
  String? status;
  Message? message;
  String? errormessage;
  dynamic balance;
  dynamic object;
  dynamic obj;
  dynamic text;

  dynamic data;
  bool? isAuthorized;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    if (message != null) {
      map['message'] = message?.toJson();
    }
    map['balance'] = balance;
    map['Object'] = object;
    map['Obj'] = obj;
    map['Text'] = text;

    map['data'] = data;
    map['isAuthorized'] = isAuthorized;
    map['Obj'] = obj;

    return map;
  }
}

class Message {
  Message({
    this.type,
    this.referenceNumber,
    this.merchantRefNumber,
    this.orderStatus,
    this.statusCode,
    this.statusDescription,
    this.nextAction,
  });

  Message.fromJson(dynamic json) {
    type = json['type'];
    referenceNumber = json['ReferenceNumber'];
    merchantRefNumber = json['MerchantRefNumber'];
    orderStatus = json['OrderStatus'];
    statusCode = json['statusCode'];
    statusDescription = json['statusDescription'];
    nextAction = json['nextAction'];
  }
  String? type;
  String? referenceNumber;
  String? merchantRefNumber;
  String? orderStatus;
  int? statusCode;
  String? statusDescription;
  dynamic nextAction;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['type'] = type;
    map['ReferenceNumber'] = referenceNumber;
    map['MerchantRefNumber'] = merchantRefNumber;
    map['OrderStatus'] = orderStatus;
    map['statusCode'] = statusCode;
    map['statusDescription'] = statusDescription;
    map['nextAction'] = nextAction;
    return map;
  }
}
