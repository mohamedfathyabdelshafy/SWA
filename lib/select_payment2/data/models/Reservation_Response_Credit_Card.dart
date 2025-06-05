class ReservationResponseCreditCard {
  ReservationResponseCreditCard({
    this.status,
    this.message,
    this.balance,
    this.errormessage,
    this.object,
    this.obj,
  });

  ReservationResponseCreditCard.fromJson(dynamic json) {
    status = json['status'];

    if (status == 'success') {
      message =
          json['message'] != null ? Message.fromJson(json['message']) : null;
    } else {
      errormessage = json['message'];
    }
    balance = json['balance'];
    object = json['Object'];
    obj = json['Obj'];
  }
  String? status;
  Message? message;
  String? errormessage;
  dynamic balance;
  dynamic object;
  dynamic obj;
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
    nextAction = json['nextAction'] != null
        ? NextAction.fromJson(json['nextAction'])
        : null;
  }
  String? type;
  dynamic referenceNumber;
  dynamic merchantRefNumber;
  dynamic orderStatus;
  int? statusCode;
  String? statusDescription;
  NextAction? nextAction;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['type'] = type;
    map['ReferenceNumber'] = referenceNumber;
    map['MerchantRefNumber'] = merchantRefNumber;
    map['OrderStatus'] = orderStatus;
    map['statusCode'] = statusCode;
    map['statusDescription'] = statusDescription;
    if (nextAction != null) {
      map['nextAction'] = nextAction?.toJson();
    }
    return map;
  }
}

class NextAction {
  NextAction({
    this.type,
    this.redirectUrl,
  });

  NextAction.fromJson(dynamic json) {
    type = json['type'];
    redirectUrl = json['redirectUrl'];
  }
  String? type;
  String? redirectUrl;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['type'] = type;
    map['redirectUrl'] = redirectUrl;
    return map;
  }
}
