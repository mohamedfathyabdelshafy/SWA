import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:swa/core/error/failures.dart';
import 'package:swa/features/sign_up/domain/entities/message_response.dart';
import 'package:swa/features/sign_up/domain/use_cases/register.dart';

part 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  final RegisterUser registerUserUseCase;

  RegisterCubit({required this.registerUserUseCase}) : super(RegisterInitial());

  Future<void> registerUser(UserRegisterParams params) async {
    emit(RegisterLoadingState());
    Either<Failure, MessageResponse> response = await registerUserUseCase(params);
    emit(
      response.fold(
        (failure) => RegisterErrorState(error: failure),
        (messageResponse) => UserRegisterLoadedState(messageResponse: messageResponse)
      )
    );
  }

}
