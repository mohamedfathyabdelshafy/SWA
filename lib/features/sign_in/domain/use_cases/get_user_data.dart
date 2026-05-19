import 'package:dartz/dartz.dart';
import 'package:swa/core/error/failures.dart';
import 'package:swa/core/usecases/usecase.dart';
import 'package:swa/features/sign_in/domain/entities/user_response.dart';
import 'package:swa/features/sign_in/domain/repositories/login_repository.dart';

class GetUserDataUseCase implements UseCase<UserResponse, NoParams>{
  final LoginRepository userRepository;
  GetUserDataUseCase({required this.userRepository});

  @override
  Future<Either<Failure, UserResponse>> call(NoParams params) {
    return userRepository.getUserData(params);
  }
}