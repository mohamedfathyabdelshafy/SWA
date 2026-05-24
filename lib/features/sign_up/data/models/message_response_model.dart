
import 'package:swa/features/sign_up/domain/entities/message_response.dart';

class MessageResponseModel extends MessageResponse {
  const MessageResponseModel({
    required super.massage,
    required super.status,
    required super.balance,
    required super.object,
    required super.obj,
  });

  factory MessageResponseModel.fromJson(Map<String, dynamic> json) =>
      MessageResponseModel(
        status: json['status'],
        massage: json['message'],
        balance: json['balance'],
        object: json['Object'],
        obj: json['Obj'],
      );

  Map<String, dynamic> toJson() => {
        'message': massage,
        'status': status,
        'balance': balance,
        'Object': object,
        'Obj': obj,
      };
}
