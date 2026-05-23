import 'package:dartz/dartz.dart';
import 'package:swa/core/error/failures.dart';
import 'package:swa/features/payment/fawry/domain/use_cases/fawry_use_case.dart';
import 'package:swa/features/payment/select_payment/domain/entities/payment_message_response.dart';

abstract class FawryPaymentRepository {
  Future<Either<Failure, PaymentMessageResponse>> fawryPayment(FawryParams params);
}