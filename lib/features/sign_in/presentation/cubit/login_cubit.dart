import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:swa/core/error/failures.dart';
import 'package:swa/features/sign_in/domain/entities/user_response.dart';
import 'package:swa/features/sign_in/domain/use_cases/login.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final UserLogin userLoginUseCase;

  LoginCubit({required this.userLoginUseCase}) : super(LoginInitial());

  Future<void> userLogin(UserLoginParams params) async {
    emit(LoginLoadingState());
    Either<Failure, UserResponse> response = await userLoginUseCase(params);
    emit(
      response.fold(
        (failure) => LoginErrorState(error: failure),
        (userResponse) => UserLoginLoadedState(userResponse: userResponse)
      )
    );
  }

  // Future<void> clearApplicantData() async {
  //   Either<Failure, void> response = await clearApplicantDataUseCase(NoParams());
  //   emit(
  //     response.fold(
  //       (failure) => LoginErrorState(error: failure),
  //       (_) => ClearApplicantDataLoadedState()
  //     )
  //   );
  // }
  //
  // Future<void> cacheNewApplicantData(EditApplicantDataParams params) async {
  //   Either<Failure, void> response = await cacheNewApplicantUseCase(params);
  //   emit(
  //     response.fold(
  //       (failure) => LoginErrorState(error: failure),
  //       (_) => EditApplicantDataLoadedState()
  //     )
  //   );
  // }

}
