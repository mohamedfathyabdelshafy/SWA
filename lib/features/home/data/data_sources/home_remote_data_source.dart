import 'dart:convert';
import 'package:swa/core/api/api_consumer.dart';
import 'package:swa/core/api/end_points.dart';
import 'package:swa/core/usecases/usecase.dart';
import 'package:swa/features/forgot_password/data/models/message_response_model.dart';
import 'package:swa/features/home/data/models/from_station_model.dart';
import 'package:swa/features/home/domain/use_cases/get_to_stations_list_data.dart';

abstract class HomeRemoteDataSource{
  Future<MessageResponseModel> getFromStations(NoParams params);
  Future<List<FromStationsModel>> getToStations(ToStationsParams params);
}

class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  final ApiConsumer apiConsumer;
  HomeRemoteDataSourceImpl({required this.apiConsumer});

  // @override
  // Future<List<FromStationsModel>> getFromStations(NoParams params) async{
  //   final response = await apiConsumer.get(
  //     EndPoints.getFromStationsList
  //   );
  //   return json.decode(response.body).map<FromStationsModel>((json) => FromStationsModel.fromJson(json)).toList(growable: false);
  // }

  @override
  Future<MessageResponseModel> getFromStations(NoParams params) async{
    final response = await apiConsumer.get(
        EndPoints.getFromStationsList
    );
    return MessageResponseModel.fromJson(json.decode(response.body.toString()));
  }

  @override
  Future<List<FromStationsModel>> getToStations(ToStationsParams params) async{
    final response = await apiConsumer.get(
      '${EndPoints.getToStationsList}?stationId=${params.stationId}'
    );
    return json.decode(response.body).map<FromStationsModel>((json) => FromStationsModel.fromJson(json)).toList(growable: false);
  }

}