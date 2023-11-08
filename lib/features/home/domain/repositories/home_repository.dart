import 'package:dartz/dartz.dart';
import 'package:swa/core/error/failures.dart';
import 'package:swa/core/usecases/usecase.dart';
import 'package:swa/features/forgot_password/domain/entities/message_response.dart';
import 'package:swa/features/home/domain/entities/from_station.dart';
import 'package:swa/features/home/domain/use_cases/get_to_stations_list_data.dart';

abstract class HomeRepository {
  Future<Either<Failure, MessageResponse>> getFromStationsData(NoParams params); //List<FromStations>
  Future<Either<Failure, List<FromStations>>> getToStationsData(ToStationsParams params);
}