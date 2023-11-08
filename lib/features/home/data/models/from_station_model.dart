import 'package:swa/features/home/data/models/station_list_model.dart';
import 'package:swa/features/home/domain/entities/from_station.dart';
import 'package:swa/features/home/domain/entities/station_list.dart';

class FromStationsModel extends FromStations {
  const FromStationsModel({
    required int cityID,
    required String cityName,
    required List<StationList> stationList,
  }) : super(cityID: cityID, cityName: cityName, stationList: stationList);

  factory FromStationsModel.fromJson(Map<String, dynamic> json) => FromStationsModel(
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