import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:swa/core/error/failures.dart';
import 'package:swa/core/usecases/usecase.dart';
import 'package:swa/features/forgot_password/domain/entities/message_response.dart';
import 'package:swa/features/forgot_password/domain/repositories/forgot_password_repository.dart';

import '../repositories/submit_password_repository.dart';

class SubmitPassword implements UseCase<MessageResponse, SubmitPasswordParams> {
  final SubmitPasswordRepository submitPasswordRepository;
  SubmitPassword({required this.submitPasswordRepository});

  @override
  Future<Either<Failure, MessageResponse>> call(SubmitPasswordParams params) {
    return submitPasswordRepository.submitPassword(params);
  }
}

class SubmitPasswordParams extends Equatable {
  final String newPassword;
  final String code;
  final String userId;
  const SubmitPasswordParams(
      {required this.userId, required this.code, required this.newPassword});

  @override
  List<Object?> get props => [
        userId,
        code,
        newPassword,
      ];
}
