import 'package:dartz/dartz.dart';
import 'package:swa/core/error/exceptions.dart';
import 'package:swa/core/error/failures.dart';
import 'package:swa/core/network/network_info.dart';
import 'package:swa/features/forgot_password/data/data_sources/forgot_password_remote_data_source.dart';
import 'package:swa/features/forgot_password/domain/entities/message_response.dart';
import 'package:swa/features/forgot_password/domain/repositories/forgot_password_repository.dart';
import 'package:swa/features/forgot_password/domain/use_cases/forgot_password.dart';


class ForgotPasswordRepositoryImpl implements ForgotPasswordRepository {
  final NetworkInfo networkInfo;
  final ForgotPasswordRemoteDataSource forgotPasswordRemoteDataSource;

  ForgotPasswordRepositoryImpl({required this.networkInfo, required this.forgotPasswordRemoteDataSource});

  @override
  Future<Either<Failure, MessageResponse>> forgotPassword(ForgotPasswordParams params) async {
    //In case there's connection
    try {
      final forgotPassword = await forgotPasswordRemoteDataSource.forgotPassword(params);
      return Right(forgotPassword);
    } on ServerException catch(error){
      return Left(ServerFailure(error.toString()));
    }
  }


}