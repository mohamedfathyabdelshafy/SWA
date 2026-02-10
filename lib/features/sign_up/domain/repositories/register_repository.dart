import 'package:dartz/dartz.dart';
import 'package:swa/core/error/failures.dart';
import 'package:swa/features/sign_up/domain/entities/message_response.dart';
import 'package:swa/features/sign_up/domain/use_cases/register.dart';

abstract class RegisterRepository {
  Future<Either<Failure, MessageResponse>> registerUser(
      UserRegisterParams params);
}
