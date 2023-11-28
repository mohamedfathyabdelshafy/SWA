import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:swa/core/error/failures.dart';
import 'package:swa/core/usecases/usecase.dart';
import 'package:swa/features/forgot_password/domain/entities/message_response.dart';
import 'package:swa/features/change_password/domain/repositories/new_password_repository.dart';

class NewPassword implements UseCase<MessageResponse, NewPasswordParams>{
  final NewPasswordRepository newPasswordRepository;
  NewPassword({required this.newPasswordRepository});

  @override
  Future<Either<Failure, MessageResponse>> call(NewPasswordParams params) {
    return newPasswordRepository.newPasswordFunction(params);
  }
}

class NewPasswordParams extends Equatable{
  final String newPass;
  final String oldPass;
  final String userId;
  const NewPasswordParams({required this.oldPass, required this.newPass, required this.userId});

  @override
  List<Object?> get props => [oldPass, newPass, userId];
}