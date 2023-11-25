import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:swa/core/error/failures.dart';
import 'package:swa/core/usecases/usecase.dart';
import 'package:swa/features/sign_up/domain/entities/message_response.dart';
import 'package:swa/features/sign_up/domain/repositories/register_repository.dart';

class RegisterUser implements UseCase<MessageResponse, UserRegisterParams>{
  final RegisterRepository registerRepository;
  RegisterUser({required this.registerRepository});

  @override
  Future<Either<Failure, MessageResponse>> call(UserRegisterParams params) {
    return registerRepository.registerUser(params);
  }
}

class UserRegisterParams extends Equatable{
  final String name;
  final String mobile;
  final String email;
  final String password;
  final String userType;
  const UserRegisterParams({required this.name, required this.mobile, required this.email, required this.password, required this.userType});

  @override
  List<Object?> get props => [name, mobile, email, password, userType];
}