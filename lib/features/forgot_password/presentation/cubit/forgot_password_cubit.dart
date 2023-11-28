import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:swa/core/error/failures.dart';
import 'package:swa/features/forgot_password/domain/entities/message_response.dart';
import 'package:swa/features/forgot_password/domain/use_cases/forgot_password.dart';

part 'forgot_password_state.dart';

class ForgotPasswordCubit extends Cubit<ForgotPasswordState> {
  final ForgotPassword forgotPasswordUseCase;

  ForgotPasswordCubit({required this.forgotPasswordUseCase}) : super(ForgotPasswordInitial());

  Future<void> forgotPassword(ForgotPasswordParams params) async {
    emit(ForgotPasswordLoadingState());
    Either<Failure, MessageResponse> response = await forgotPasswordUseCase(params);
    emit(
      response.fold(
        (failure) => ForgotPasswordErrorState(error: failure),
        (messageResponse) => ForgotPasswordLoadedState(messageResponse: messageResponse)
      )
    );
  }

}
