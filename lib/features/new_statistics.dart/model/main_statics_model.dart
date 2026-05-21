class MainStaticsModel {
  MainStaticsModel({
    this.data,
    this.status,
    this.message,
    this.balance,
    this.object,
    this.text,
    this.isAuthorized,
    this.obj,
  });

  dynamic data;
  String? status;
  Message? message;
  dynamic balance;
  dynamic object;
  dynamic text;
  bool? isAuthorized;
  dynamic obj;

  factory MainStaticsModel.fromJson(Map<String, dynamic> json) {
    return MainStaticsModel(
      data: json["data"],
      status: json["status"],
      message:
          json["message"] == null ? null : Message.fromJson(json["message"]),
      balance: json["balance"],
      object: json["Object"],
      text: json["Text"],
      isAuthorized: json["isAuthorized"],
      obj: json["Obj"],
    );
  }
}

class Message {
  Message({
    this.walletBalance,
    this.totalReservationCount,
    this.totalReservationAmount,
    this.totalLoyalty,
  });

  dynamic walletBalance;
  dynamic totalReservationCount;
  dynamic totalReservationAmount;
  dynamic totalLoyalty;

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      walletBalance: json["WalletBalance"],
      totalReservationCount: json["TotalReservationCount"],
      totalReservationAmount: json["TotalReservationAmount"],
      totalLoyalty: json["TotalLoyalty"],
    );
  }
}
