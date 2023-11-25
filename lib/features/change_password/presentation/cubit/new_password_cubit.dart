import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:swa/core/error/failures.dart';
import 'package:swa/features/forgot_password/domain/entities/message_response.dart';
import 'package:swa/features/change_password/domain/use_cases/new_password.dart';

part 'new_password_state.dart';

class NewPasswordCubit extends Cubit<NewPasswordState> {
  final NewPassword newPasswordUseCase;

  NewPasswordCubit({required this.newPasswordUseCase}) : super(NewPasswordInitial());

  Future<void> newPassword(NewPasswordParams params) async {
    emit(NewPasswordLoadingState());
    Either<Failure, MessageResponse> response = await newPasswordUseCase(params);
    emit(
      response.fold(
        (failure) => NewPasswordErrorState(error: failure),
        (messageResponse) => NewPasswordLoadedState(messageResponse: messageResponse)
      )
    );
  }

}
