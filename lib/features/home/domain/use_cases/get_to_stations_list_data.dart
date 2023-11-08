import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:swa/core/error/failures.dart';
import 'package:swa/core/usecases/usecase.dart';
import 'package:swa/features/home/domain/entities/from_station.dart';
import 'package:swa/features/home/domain/repositories/home_repository.dart';

class GetToStationsListDataUseCase implements UseCase<List<FromStations>, ToStationsParams>{
  final HomeRepository homeRepository;
  GetToStationsListDataUseCase({required this.homeRepository});

  @override
  Future<Either<Failure, List<FromStations>>> call(ToStationsParams params) {
    return homeRepository.getToStationsData(params);
  }
}

class ToStationsParams extends Equatable{
  final String stationId;
  const ToStationsParams({required this.stationId});

  @override
  List<Object?> get props => [stationId];
}