import 'package:dartz/dartz.dart';
import 'package:swa/core/error/exceptions.dart';
import 'package:swa/core/error/failures.dart';
import 'package:swa/core/network/network_info.dart';
import 'package:swa/core/usecases/usecase.dart';
import 'package:swa/features/forgot_password/domain/entities/message_response.dart';
import 'package:swa/features/home/data/data_sources/home_remote_data_source.dart';
import 'package:swa/features/home/domain/entities/from_station.dart';
import 'package:swa/features/home/domain/repositories/home_repository.dart';
import 'package:swa/features/home/domain/use_cases/get_to_stations_list_data.dart';


class HomeRepositoryImpl implements HomeRepository {
  final NetworkInfo networkInfo;
  final HomeRemoteDataSource homeRemoteDataSource;

  HomeRepositoryImpl({required this.networkInfo, required this.homeRemoteDataSource});

  @override
  Future<Either<Failure, MessageResponse>> getFromStationsData(NoParams params) async { //List<FromStations>>
    //In case there's connection
    try {
      final getFromStations = await homeRemoteDataSource.getFromStations(params);
      return Right(getFromStations);
    } on ServerException catch(error){
      return Left(ServerFailure(error.toString()));
    }
  }

  @override
  Future<Either<Failure, List<FromStations>>> getToStationsData(ToStationsParams params) async {
    //In case there's connection
    try {
      final getStations = await homeRemoteDataSource.getToStations(params);
      return Right(getStations);
    } on ServerException catch(error){
      return Left(ServerFailure(error.toString()));
    }
  }


}