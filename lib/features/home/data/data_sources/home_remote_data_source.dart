import 'dart:convert';
import 'dart:developer';
import 'package:swa/core/api/api_consumer.dart';
import 'package:swa/core/api/end_points.dart';
import 'package:swa/core/local_cache_helper.dart';
import 'package:swa/core/usecases/usecase.dart';
import 'package:swa/features/home/data/models/home_message_response_model.dart';
import 'package:swa/features/home/domain/use_cases/get_to_stations_list_data.dart';

abstract class HomeRemoteDataSource {
  Future<HomeMessageResponseModel> getFromStations(NoParams params);
  Future<HomeMessageResponseModel> getToStations(ToStationsParams params);
}

class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  final ApiConsumer apiConsumer;
  HomeRemoteDataSourceImpl({required this.apiConsumer});

  @override
  Future<HomeMessageResponseModel> getFromStations(NoParams params) async {
    var countryid = CacheHelper.getDataToSharedPref(
      key: 'countryid',
    ) ?? 3;
    print("Tik Tik Country id: $countryid");
    final response = await apiConsumer.get(
      '${EndPoints.getFromStationsList}?countryID=${countryid}',
    );

    log("Tik Tik getFromStationsList country id: ${countryid.toString()}");

    print(await response.request);
    print(
        "Tik Tik getFromStationsList Response: ${await response.body.toString()}");
    return HomeMessageResponseModel.fromJson(
        json.decode(response.body.toString()));
  }

  @override
  Future<HomeMessageResponseModel> getToStations(
      ToStationsParams params) async {
    var countryid = CacheHelper.getDataToSharedPref(
      key: 'countryid',
    ) ?? 3;
    final response = await apiConsumer.get(
        '${EndPoints.getToStationsList}?stationId=${params.stationId}&countryID=${countryid}');
    return HomeMessageResponseModel.fromJson(
        json.decode(response.body.toString()));
  }
}
