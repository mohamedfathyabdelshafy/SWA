import 'package:dartz/dartz.dart';
import 'package:swa/core/error/failures.dart';
import 'package:swa/core/usecases/usecase.dart';
import 'package:swa/features/home/domain/entities/home_message_response.dart';
import 'package:swa/features/home/domain/repositories/home_repository.dart';

class GetFromStationsListDataUseCase implements UseCase<HomeMessageResponse, NoParams>{
  final HomeRepository homeRepository;
  GetFromStationsListDataUseCase({required this.homeRepository});

  @override
  Future<Either<Failure, HomeMessageResponse>> call(NoParams params) {
    return homeRepository.getFromStationsData(params);
  }
}