import 'package:dartz/dartz.dart';
import 'package:swa/core/error/exceptions.dart';
import 'package:swa/core/error/failures.dart';
import 'package:swa/core/network/network_info.dart';
import 'package:swa/features/forgot_password/domain/entities/message_response.dart';
import 'package:swa/features/change_password/data/data_sources/new_password_remote_data_source.dart';
import 'package:swa/features/change_password/domain/repositories/new_password_repository.dart';
import 'package:swa/features/change_password/domain/use_cases/new_password.dart';


class NewPasswordRepositoryImpl implements NewPasswordRepository {
  final NetworkInfo networkInfo;
  final NewPasswordRemoteDataSource newPasswordRemoteDataSource;

  NewPasswordRepositoryImpl({required this.networkInfo, required this.newPasswordRemoteDataSource});

  @override
  Future<Either<Failure, MessageResponse>> newPasswordFunction(NewPasswordParams params) async {
    //In case there's connection
    try {
      final newPassword = await newPasswordRemoteDataSource.newPassword(params);
      return Right(newPassword);
    } on ServerException catch(error){
      return Left(ServerFailure(error.toString()));
    }
  }


}