import 'package:dartz/dartz.dart';
import 'package:swa/core/error/failures.dart';
import 'package:swa/core/usecases/usecase.dart';
import 'package:swa/features/sign_in/domain/entities/user_response.dart';
import 'package:swa/features/sign_in/domain/use_cases/login.dart';

abstract class LoginRepository {
  //Any of these methods can return either failure or data
  Future<Either<Failure, UserResponse>> userLogin(UserLoginParams params);
  Future<Either<Failure, UserResponse>> getUserData(NoParams params);
}