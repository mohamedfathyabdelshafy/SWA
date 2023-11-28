import 'package:swa/features/home/domain/entities/cities_stations.dart';
import 'package:swa/features/home/domain/entities/station_list.dart';
import 'package:swa/features/sign_in/data/models/user_model.dart';

class StationsListModel extends StationList {
  const StationsListModel({
    required int stationId,
    required String stationName,
  }) : super(stationId: stationId, stationName: stationName);

  factory StationsListModel.fromJson(Map<String, dynamic> json) => StationsListModel(
    stationId : json['StationId'],
    stationName: json['StationName']
  );

  Map<String, dynamic> toJson() => {
    'StationId': stationId,
    'StationName': stationName,
  };

}