import 'package:swa/features/home/data/models/station_list_model.dart';
import 'package:swa/features/home/domain/entities/cities_stations.dart';
import 'package:swa/features/home/domain/entities/station_list.dart';

class CitiesStationsModel extends CitiesStations {
  const CitiesStationsModel({
    required int cityID,
    required String cityName,
    required List<StationList> stationList,
  }) : super(cityID: cityID, cityName: cityName, stationList: stationList);

  factory CitiesStationsModel.fromJson(Map<String, dynamic> json) => CitiesStationsModel(
    cityID : json['CityID'],
    cityName: json['CityName'],
    stationList : (json['StationList'] as List).map((dynamic e) => StationsListModel.fromJson(e as Map<String,dynamic>)).toList()
  );

  Map<String, dynamic> toJson() => {
    'CityID' : cityID,
    'CityName' : cityName,
    'StationList' : stationList.map((e) => StationsListModel(stationId: e.stationId, stationName: e.stationName,).toJson()).toList(),
  };

}