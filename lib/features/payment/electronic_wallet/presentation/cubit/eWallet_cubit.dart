import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:swa/core/error/failures.dart';
import 'package:swa/features/payment/electronic_wallet/domain/use_cases/ewallet_use_case.dart';
import 'package:swa/features/payment/select_payment/domain/entities/payment_message_response.dart';

part 'eWallet_state.dart';

class EWalletCubit extends Cubit<EWalletState> {
  final EWalletUseCase eWalletUseCase;

  EWalletCubit({required this.eWalletUseCase}) : super(EWalletInitial());

  Future<void> eWalletPaymentFunction(EWalletParams params) async {
    emit(EWalletLoadingState());
    Either<Failure, PaymentMessageResponse> response = await eWalletUseCase(params);
    emit(
      response.fold(
        (failure) => EWalletErrorState(error: failure),
        (paymentMessageResponse) => EWalletLoadedState(paymentMessageResponse: paymentMessageResponse)
      )
    );
  }

}
