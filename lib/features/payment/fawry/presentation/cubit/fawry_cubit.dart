import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:swa/core/error/failures.dart';
import 'package:swa/features/payment/fawry/domain/use_cases/fawry_use_case.dart';
import 'package:swa/features/payment/select_payment/domain/entities/payment_message_response.dart';

part 'fawry_state.dart';

class FawryCubit extends Cubit<FawryState> {
  final FawryUseCase fawryUseCase;

  FawryCubit({required this.fawryUseCase}) : super(FawryInitial());

  Future<void> fawryPaymentFunction(FawryParams params) async {
    emit(FawryLoadingState());
    Either<Failure, PaymentMessageResponse> response =
        await fawryUseCase(params);
    emit(response.fold(
        (failure) => FawryErrorState(error: failure),
        (paymentMessageResponse) =>
            FawryLoadedState(paymentMessageResponse: paymentMessageResponse)));
  }
}
