import 'package:swa/features/payment/select_payment/data/models/payment_message_model.dart';
import 'package:swa/features/payment/select_payment/domain/entities/payment_message.dart';
import 'package:swa/features/payment/select_payment/domain/entities/payment_message_response.dart';

class PaymentMessageResponseModel extends PaymentMessageResponse {
  const PaymentMessageResponseModel({
    required String? message,
    required String? status,
    required PaymentMessage? paymentMessage,
    required dynamic balance,
    required dynamic object,
    required dynamic obj,
    required dynamic text,
  }) : super(
            status: status,
            message: message,
            paymentMessage: paymentMessage,
            balance: balance,
            object: object,
            obj: obj,
            text: text);

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
