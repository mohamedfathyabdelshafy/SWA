import 'package:dartz/dartz.dart';
import 'package:swa/core/error/exceptions.dart';
import 'package:swa/core/error/failures.dart';
import 'package:swa/features/app_info/data/data_sources/app_info_remote_data_source.dart';
import 'package:swa/features/app_info/domain/entities/city.dart';
import 'package:swa/features/app_info/domain/entities/country.dart';
import 'package:swa/features/app_info/domain/repositories/app_info_repository.dart';

class AppInfoRepoImpl implements AppInfoRepository {
  final AppInfoRemoteDataSource remoteDataSource;
  AppInfoRepoImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<Country>>> getAvailableCountries() async {
    try {
      final countries = await remoteDataSource.getAvailableCountries();
      return Right(countries);
    } on ServerException catch (error) {
      return Left(ServerFailure(error.toString()));
    }
  }

  @override
  Future<Either<Failure, List<City>>> getAvailableCountryCities(
      int countryId) async {
    try {
      final countries =
          await remoteDataSource.getAvailableCountryCities(countryId);
      return Right(countries);
    } on ServerException catch (error) {
      return Left(ServerFailure(error.toString()));
    }
  }
}
