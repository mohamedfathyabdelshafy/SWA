import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:swa/core/error/failures.dart';
import 'package:swa/features/sign_up/data/data_sources/register_remote_data_source.dart';
import 'package:swa/features/sign_up/domain/entities/message_response.dart';
import 'package:swa/features/sign_up/domain/use_cases/register.dart';
import 'package:swa/main.dart';

import '../../../home/presentation/screens/tabs/ticket_tap/data/repo/ticket_repo.dart';

part 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  final RegisterUser registerUserUseCase;
  TicketRepo ticketRepo = TicketRepo(sl());

  RegisterCubit({required this.registerUserUseCase}) : super(RegisterInitial());

  Future<void> registerUser(UserRegisterParams params) async {
    emit(RegisterLoadingState());
    Either<Failure, MessageResponse> response =
        await registerUserUseCase(params);
    emit(
      response.fold(
        (failure) => RegisterErrorState(error: failure.toString()),
        (messageResponse) {
          if (messageResponse.status == 'failed') {
            return RegisterErrorState(error: messageResponse.massage);
          } else {
            return UserRegisterLoadedState(messageResponse: messageResponse);
          }
        },
      ),
    );
  }

  Future<void> Sendcodeemail({required String email}) async {
    emit(RegisterLoadingState());

    final res = await ticketRepo.Sendconfirmationcode(email: email);

    if (res.status == "success") {
      emit(EmailsendState(message: res.status));
    } else {
      emit(RegisterErrorState(error: res.message ?? ""));
    }
  }

  Future<void> confirmemail({required String otp}) async {
    emit(RegisterLoadingState());

    final res = await ticketRepo.confirmemail(otp: otp);

    if (res.status == "success") {
      emit(EmailsendState(message: "success"));
    } else {
      emit(RegisterErrorState(error: res.message ?? ""));
    }
  }
}
// emit(
// response.fold(
// (failure) => RegisterErrorState(error: failure),
// (messageResponse) => UserRegisterLoadedState(messageResponse: messageResponse)
// )
// );