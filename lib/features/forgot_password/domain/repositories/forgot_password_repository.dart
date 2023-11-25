import 'package:dartz/dartz.dart';
import 'package:swa/core/error/failures.dart';
import 'package:swa/features/forgot_password/domain/entities/message_response.dart';
import 'package:swa/features/forgot_password/domain/use_cases/forgot_password.dart';

abstract class ForgotPasswordRepository {
  Future<Either<Failure, MessageResponse>> forgotPassword(ForgotPasswordParams params);
}