import 'package:dartz/dartz.dart';
import 'package:swa/core/error/exceptions.dart';
import 'package:swa/core/error/failures.dart';
import 'package:swa/core/network/network_info.dart';
import 'package:swa/core/usecases/usecase.dart';
import 'package:swa/features/sign_in/data/data_sources/login_local_data_source.dart';
import 'package:swa/features/sign_in/data/data_sources/login_remote_data_source.dart';
import 'package:swa/features/sign_in/domain/entities/user_response.dart';
import 'package:swa/features/sign_in/domain/repositories/login_repository.dart';
import 'package:swa/features/sign_in/domain/use_cases/login.dart';

class LoginRepositoryImpl implements LoginRepository {
  final NetworkInfo networkInfo;
  final LoginLocalDataSource loginLocalDataSource;
  final LoginRemoteDataSource loginRemoteDataSource;

  LoginRepositoryImpl({required this.networkInfo, required this.loginLocalDataSource, required this.loginRemoteDataSource});

  @override
  Future<Either<Failure, UserResponse>> userLogin(UserLoginParams params) async {
    //In case there's connection
    try {
      final userLogin = await loginRemoteDataSource.userLogin(params);
      //Cache applicant data so that in case there's no network connection we get last cached data
      loginLocalDataSource.cacheUserData(userLogin);
      return Right(userLogin);
    } on ServerException catch(error){
      return Left(ServerFailure(error.toString()));
    }
  }

  @override
  Future<Either<Failure, UserResponse>> getUserData(NoParams params) async {
    try{
      final applicantData = await loginLocalDataSource.getLastUserLoginData();
      return Right(applicantData);
    }on CacheException catch(error){
      return Left(CacheFailure(error.toString()));
    }
  }

}