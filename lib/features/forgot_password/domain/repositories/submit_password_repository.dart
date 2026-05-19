import 'package:dartz/dartz.dart';
import 'package:swa/core/error/failures.dart';
import 'package:swa/features/forgot_password/domain/entities/message_response.dart';
import 'package:swa/features/forgot_password/domain/use_cases/submit_password.dart';

abstract class SubmitPasswordRepository {
  Future<Either<Failure, MessageResponse>> submitPassword(
      SubmitPasswordParams params);
}
