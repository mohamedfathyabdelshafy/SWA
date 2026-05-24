import 'package:swa/features/payment/select_payment/data/models/payment_message_model.dart';
import 'package:swa/features/payment/select_payment/domain/entities/payment_message.dart';
import 'package:swa/features/payment/select_payment/domain/entities/payment_message_response.dart';

class PaymentMessageResponseModel extends PaymentMessageResponse {
  const PaymentMessageResponseModel({
    required super.message,
    required super.status,
    required super.paymentMessage,
    required super.balance,
    required super.object,
    required super.obj,
    required super.text,
  });

  factory PaymentMessageResponseModel.fromJson(Map<String, dynamic> json) =>
      PaymentMessageResponseModel(
          status: json['status'],
          message: (json['status'] == 'failed') ? json['message'] : null,
          paymentMessage:
              (json['message'] != null && json['status'] != 'failed')
                  ? PaymentMessageModel.fromJson(json['message'])
                  : null,
          balance: json['balance'],
          object: json['Object'],
          obj: json['Obj'],
          text: json['Text']);

  Map<String, dynamic> toJson() => {
        'status': status,
        'balance': balance,
        'Object': object,
        'Obj': obj,
        'Text': text
      };
}
