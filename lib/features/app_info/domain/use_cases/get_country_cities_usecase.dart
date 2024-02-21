import 'package:dartz/dartz.dart';
import 'package:swa/core/error/failures.dart';
import 'package:swa/core/usecases/usecase.dart';
import 'package:swa/features/app_info/domain/entities/city.dart';
import 'package:swa/features/app_info/domain/repositories/app_info_repository.dart';

class GetAvailableCountryCitiesUseCase implements UseCase<List<City>, int> {
  final AppInfoRepository repository;
  GetAvailableCountryCitiesUseCase({required this.repository});

  @override
  Future<Either<Failure, List<City>>> call(int params) {
    return repository.getAvailableCountryCities(params);
  }
}
