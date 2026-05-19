import 'package:dartz/dartz.dart';
import 'package:swa/core/error/failures.dart';
import 'package:swa/features/app_info/domain/entities/city.dart';
import 'package:swa/features/app_info/domain/entities/country.dart';

abstract class AppInfoRepository {
  Future<Either<Failure, List<Country>>> getAvailableCountries();
  Future<Either<Failure, List<City>>> getAvailableCountryCities(int countryId);
}
