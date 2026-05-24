import 'package:swa/features/payment/select_payment/domain/entities/payment_message.dart';

class PaymentMessageModel extends PaymentMessage {
  const PaymentMessageModel({
    required super.type,
    required super.referenceNumber,
    required super.merchantRefNumber,
    required super.orderStatus,
    required super.statusCode,
    required super.statusDescription,
    required super.nextAction,
  });

  factory PaymentMessageModel.fromJson(Map<String, dynamic> json) =>
      PaymentMessageModel(
        type: json["type"],
        referenceNumber: json["ReferenceNumber"],
        merchantRefNumber: json["MerchantRefNumber"],
        orderStatus: json["OrderStatus"],
        statusCode: json["statusCode"],
        statusDescription: json["statusDescription"],
        nextAction: json["nextAction"],
      );

  Map<String, dynamic> toJson() => {
        "type": type,
        "ReferenceNumber": referenceNumber,
        "MerchantRefNumber": merchantRefNumber,
        "OrderStatus": orderStatus,
        "statusCode": statusCode,
        "statusDescription": statusDescription,
        "nextAction": nextAction,
      };
}
