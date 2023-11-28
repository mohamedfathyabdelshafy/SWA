import 'package:dartz/dartz.dart';
import 'package:swa/core/error/exceptions.dart';
import 'package:swa/core/error/failures.dart';
import 'package:swa/core/network/network_info.dart';
import 'package:swa/features/sign_up/data/data_sources/register_remote_data_source.dart';
import 'package:swa/features/sign_up/domain/entities/message_response.dart';
import 'package:swa/features/sign_up/domain/repositories/register_repository.dart';
import 'package:swa/features/sign_up/domain/use_cases/register.dart';

class RegisterRepositoryImpl implements RegisterRepository {
  final NetworkInfo networkInfo;
  final RegisterRemoteDataSource registerRemoteDataSource;

  RegisterRepositoryImpl({required this.networkInfo, required this.registerRemoteDataSource});

  @override
  Future<Either<Failure, MessageResponse>> registerUser(UserRegisterParams params) async {
    //In case there's connection
    try {
      final registerUser = await registerRemoteDataSource.registerUser(params);
      return Right(registerUser);
    } on ServerException catch(error){
      return Left(ServerFailure(error.toString()));
    }
  }

}