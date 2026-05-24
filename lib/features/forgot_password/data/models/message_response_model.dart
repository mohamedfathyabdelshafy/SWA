import 'package:swa/features/forgot_password/domain/entities/message_response.dart';

class MessageResponseModel extends MessageResponse {
  const MessageResponseModel({
    required String? massage,
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
        status: json['status'] ?? json['Status'],
        massage: json['message'] ?? json['Message'] ?? json['data']?.toString(),
        balance: json['balance'] ?? json['Balance'],
        object: json['Object'] ?? json['object'],
        obj: json['Obj'] ?? json['obj'],
      );

  Map<String, dynamic> toJson() => {
        'message': massage,
        'status': status,
        'balance': balance,
        'Object': object,
        'Obj': obj,
      };
}
