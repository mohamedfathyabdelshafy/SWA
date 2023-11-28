import 'package:swa/features/sign_up/domain/entities/message_response.dart';

class MessageResponseModel extends MessageResponse {
  const MessageResponseModel({
    required var massage,
    required String? status,
    required dynamic balance,
    required dynamic object,
    required dynamic obj,
  }) : super(
            status: status,
            massage: massage,
            balance: balance,
            object: object,
            obj: obj);

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
