import 'package:equatable/equatable.dart';

class PaymentMessage extends Equatable {
  final String type;
  final dynamic referenceNumber;
  final dynamic merchantRefNumber;
  final dynamic orderStatus;
  final int statusCode;
  final String statusDescription;
  final dynamic nextAction;

  const PaymentMessage({
    required this.type,
    required this.referenceNumber,
    required this.merchantRefNumber,
    required this.orderStatus,
    required this.statusCode,
    required this.statusDescription,
    this.nextAction,
  });


  @override
  List<Object?> get props => [
    type,
    referenceNumber,
    merchantRefNumber,
    orderStatus,
    statusCode,
    statusDescription,
    nextAction,
  ];
}