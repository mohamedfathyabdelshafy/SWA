import 'package:swa/features/forgot_password/domain/entities/message_response.dart';

class HomeMessageResponseModel extends MessageResponse {
  const HomeMessageResponseModel({
     required String? massage,
     required String? status,
     required dynamic balance,
     required dynamic object,
     required dynamic obj,
  }) : super(status: status, massage: massage, balance: balance, object: object, obj: obj);

  factory HomeMessageResponseModel.fromJson(Map<String, dynamic> json) => HomeMessageResponseModel(
    status : json['status'],
    massage : json['message'],
    balance : json['balance'],
    object : json['Object'],
    obj : json['Obj'],
  );

  Map<String, dynamic> toJson() => {
    'message' : massage,
    'status' : status,
    'balance' : balance,
    'Object' : object,
    'Obj' : obj,
  };

}