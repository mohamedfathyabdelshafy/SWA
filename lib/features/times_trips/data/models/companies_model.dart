class CompaiesModel {
  CompaiesModel(
      {this.data,
      this.status,
      this.message,
      this.balance,
      this.Object,
      this.Text,
      this.isAuthorized,
      this.Obj,
      this.failureMessage});
  dynamic? data;
  String? status;
  List<Message>? message;
  late final dynamic balance;
  late final dynamic Object;
  late final dynamic Text;
  bool? isAuthorized;
  String? failureMessage;
  late final dynamic Obj;

  CompaiesModel.fromJson(Map<String, dynamic> json) {
    data = null;
    status = json['status'];
    // message =
    //     List.from(json['message']).map((e) => Message.fromJson(e)).toList();
    if (status == "success") {
      message =
          List.from(json['message']).map((e) => Message.fromJson(e)).toList();
    } else {
      failureMessage = json["message"];
    }
    balance = null;
    Object = null;
    Text = null;
    isAuthorized = json['isAuthorized'];
    Obj = null;
  }
}

class Message {
  Message({
    required this.Name,
    required this.CompanyID,
  });
  late final String Name;
  late final int CompanyID;

  Message.fromJson(Map<String, dynamic> json) {
    Name = json['Name'];
    CompanyID = json['CompanyID'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['Name'] = Name;
    _data['CompanyID'] = CompanyID;
    return _data;
  }
}
