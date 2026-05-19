import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:swa/core/error/failures.dart';
import 'package:swa/core/utils/language.dart';
import 'package:swa/features/payment/electronic_wallet/domain/use_cases/ewallet_use_case.dart';
import 'package:swa/features/payment/select_payment/domain/entities/payment_message_response.dart';

part 'eWallet_state.dart';

class EWalletCubit extends Cubit<EWalletState> {
  final EWalletUseCase eWalletUseCase;

  EWalletCubit({required this.eWalletUseCase}) : super(EWalletInitial());

  Future<void> eWalletPaymentFunction(EWalletParams params) async {
    emit(EWalletLoadingState());
    Either<Failure, PaymentMessageResponse> response =
        await eWalletUseCase(params);

    response.fold(
      (failure) {
        emit(EWalletErrorState(error: failure));
      },
      (paymentMessageResponse) {
        switch (paymentMessageResponse.status) {
          case "success":
            emit(EWalletLoadedState(
                paymentMessageResponse: paymentMessageResponse));
            break;
          case "failed":
            // Assuming 'message' contains the error description for failed status
            final errorMessage = LanguageClass.isEnglish
                ? "${jsonDecode(paymentMessageResponse.message!)['statusDescription']}"
                : "${jsonDecode(paymentMessageResponse.message!)['statusDescription']}";
            emit(EWalletErrorState(error: ServerFailure(errorMessage)));
            break;
          case "confirmation":
            // Assuming 'message' contains the confirmation text
            emit(EWalletConfirmationState(
                message: paymentMessageResponse.message!));
            break;
          case "warning":
            // Assuming 'message' contains the warning text
            emit(EWalletWarningState(message: paymentMessageResponse.message!));
            break;
          case "image":
            // Assuming 'message' contains the image URL or base64 data
            emit(EWalletImageState(message: paymentMessageResponse.message!));
            break;
          case "imagewithgift":
            // Assuming 'message' contains the image URL or base64 data
            emit(EWalletImageWithGiftState(
                message: paymentMessageResponse.message!));
            break;
          default:
            // Default error handling for unknown status or if message is null
            final defaultError = LanguageClass.isEnglish
                ? "Unknown status or message not available."
                : "حالة غير معروفة أو الرسالة غير متوفرة.";
            emit(EWalletErrorState(
                error: ServerFailure(
                    paymentMessageResponse.message ?? defaultError)));
        }
      },
    );
  }
}
