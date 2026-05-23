import 'package:dartz/dartz.dart';
import 'package:swa/core/error/failures.dart';
import 'package:swa/core/usecases/usecase.dart';
import 'package:swa/features/home/domain/entities/home_message_response.dart';
import 'package:swa/features/home/domain/use_cases/get_to_stations_list_data.dart';

abstract class HomeRepository {
  Future<Either<Failure, HomeMessageResponse>> getFromStationsData(NoParams params);
  Future<Either<Failure, HomeMessageResponse>> getToStationsData(ToStationsParams params);
}