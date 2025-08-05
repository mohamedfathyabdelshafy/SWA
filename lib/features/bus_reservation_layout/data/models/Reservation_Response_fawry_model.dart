class ReservationResponseModel {
  ReservationResponseModel({
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
  String? message;
  dynamic balance;
  dynamic object;
  dynamic text;
  bool? isAuthorized;
  dynamic obj;

  factory ReservationResponseModel.fromJson(Map<String, dynamic> json) {
    return ReservationResponseModel(
      data: json["data"],
      status: json["status"],
      message: json["message"],
      balance: json["balance"],
      object: json["Object"],
      text: json["Text"],
      isAuthorized: json["isAuthorized"],
      obj: json["Obj"],
    );
  }
}
