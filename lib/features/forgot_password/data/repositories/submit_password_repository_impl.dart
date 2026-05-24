import 'package:dartz/dartz.dart';
import 'package:swa/core/error/exceptions.dart';
import 'package:swa/core/error/failures.dart';
import 'package:swa/core/network/network_info.dart';
import 'package:swa/features/forgot_password/data/data_sources/forgot_password_remote_data_source.dart';
import 'package:swa/features/forgot_password/domain/entities/message_response.dart';
import 'package:swa/features/forgot_password/domain/repositories/forgot_password_repository.dart';
import 'package:swa/features/forgot_password/domain/use_cases/forgot_password.dart';
import 'package:swa/features/forgot_password/domain/use_cases/submit_password.dart';

import '../../domain/repositories/submit_password_repository.dart';

class SubmitPasswordRepositoryImpl implements SubmitPasswordRepository {
  final NetworkInfo networkInfo;
  final ForgotPasswordRemoteDataSource forgotPasswordRemoteDataSource;

  SubmitPasswordRepositoryImpl(
      {required this.networkInfo,
      required this.forgotPasswordRemoteDataSource});

  @override
  Future<Either<Failure, MessageResponse>> submitPassword(
      SubmitPasswordParams params) async {
    try {
      final submitPassword =
          await forgotPasswordRemoteDataSource.submitPassword(params);
      return Right(submitPassword);
    } on ServerException catch (error) {
      return Left(ServerFailure(error.toString()));
    } catch (error) {
      return Left(ServerFailure(error.toString()));
    }
  }
}
