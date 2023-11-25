import 'dart:convert';
import 'package:swa/core/api/api_consumer.dart';
import 'package:swa/core/api/end_points.dart';
import 'package:swa/core/usecases/usecase.dart';
import 'package:swa/features/home/data/models/home_message_response_model.dart';
import 'package:swa/features/home/domain/use_cases/get_to_stations_list_data.dart';

abstract class HomeRemoteDataSource{
  Future<HomeMessageResponseModel> getFromStations(NoParams params);
  Future<HomeMessageResponseModel> getToStations(ToStationsParams params);
}

class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  final ApiConsumer apiConsumer;
  HomeRemoteDataSourceImpl({required this.apiConsumer});

  @override
  Future<HomeMessageResponseModel> getFromStations(NoParams params) async{
    final response = await apiConsumer.get(
        EndPoints.getFromStationsList
    );
    return HomeMessageResponseModel.fromJson(json.decode(response.body.toString()));
  }

  @override
  Future<HomeMessageResponseModel> getToStations(ToStationsParams params) async{
    final response = await apiConsumer.get(
      '${EndPoints.getToStationsList}?stationId=${params.stationId}'
    );
    return HomeMessageResponseModel.fromJson(json.decode(response.body.toString()));
  }

}