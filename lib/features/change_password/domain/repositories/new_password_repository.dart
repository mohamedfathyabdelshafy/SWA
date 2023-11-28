import 'package:dartz/dartz.dart';
import 'package:swa/core/error/failures.dart';
import 'package:swa/features/forgot_password/domain/entities/message_response.dart';
import 'package:swa/features/change_password/domain/use_cases/new_password.dart';

abstract class NewPasswordRepository {
  Future<Either<Failure, MessageResponse>> newPasswordFunction(NewPasswordParams params);
}