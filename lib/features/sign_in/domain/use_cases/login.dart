import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:swa/core/error/failures.dart';
import 'package:swa/core/usecases/usecase.dart';
import 'package:swa/features/sign_in/domain/entities/user_response.dart';
import 'package:swa/features/sign_in/domain/repositories/login_repository.dart';

class UserLogin implements UseCase<UserResponse, UserLoginParams>{
  final LoginRepository userRepository;
  UserLogin({required this.userRepository});

  @override
  Future<Either<Failure, UserResponse>> call(UserLoginParams params) {
    return userRepository.userLogin(params);
  }
}

class UserLoginParams extends Equatable{
  final String username;
  final String password;
  const UserLoginParams({required this.username, required this.password});

  @override
  List<Object?> get props => [username, password];
}