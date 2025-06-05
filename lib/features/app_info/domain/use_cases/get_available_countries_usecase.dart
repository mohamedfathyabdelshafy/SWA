import 'package:dartz/dartz.dart';
import 'package:swa/core/error/failures.dart';
import 'package:swa/core/usecases/usecase.dart';
import 'package:swa/features/app_info/domain/entities/country.dart';
import 'package:swa/features/app_info/domain/repositories/app_info_repository.dart';

class GetAvailableCountriesUseCase implements UseCase<List<Country>, NoParams> {
  final AppInfoRepository repository;
  GetAvailableCountriesUseCase({required this.repository});

  @override
  Future<Either<Failure, List<Country>>> call(NoParams params) {
    return repository.getAvailableCountries();
  }
}
