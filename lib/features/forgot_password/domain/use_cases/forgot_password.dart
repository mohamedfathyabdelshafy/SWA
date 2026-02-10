import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:swa/core/error/failures.dart';
import 'package:swa/core/usecases/usecase.dart';
import 'package:swa/features/forgot_password/domain/entities/message_response.dart';
import 'package:swa/features/forgot_password/domain/repositories/forgot_password_repository.dart';

class ForgotPassword implements UseCase<MessageResponse, ForgotPasswordParams>{
  final ForgotPasswordRepository forgotPasswordRepository;
  ForgotPassword({required this.forgotPasswordRepository});

  @override
  Future<Either<Failure, MessageResponse>> call(ForgotPasswordParams params) {
    return forgotPasswordRepository.forgotPassword(params);
  }
}

class ForgotPasswordParams extends Equatable{
  final String email;
  const ForgotPasswordParams({required this.email});

  @override
  List<Object?> get props => [email];
}