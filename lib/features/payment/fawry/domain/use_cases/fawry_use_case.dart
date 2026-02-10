import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:swa/core/error/failures.dart';
import 'package:swa/core/usecases/usecase.dart';
import 'package:swa/features/payment/fawry/domain/repositories/fawry_repository.dart';
import 'package:swa/features/payment/select_payment/domain/entities/payment_message_response.dart';

class FawryUseCase implements UseCase<PaymentMessageResponse, FawryParams>{
  final FawryPaymentRepository fawryPaymentRepository;
  FawryUseCase({required this.fawryPaymentRepository});

  @override
  Future<Either<Failure, PaymentMessageResponse>> call(FawryParams params) {
    return fawryPaymentRepository.fawryPayment(params);
  }
}

class FawryParams extends Equatable{
  final String customerId;
  final String amount;
  const FawryParams({required this.customerId, required this.amount});

  @override
  List<Object?> get props => [customerId, amount];
}