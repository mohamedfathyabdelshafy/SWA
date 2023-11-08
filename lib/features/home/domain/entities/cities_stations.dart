import 'package:equatable/equatable.dart';
import 'package:swa/features/home/domain/entities/station_list.dart';
import 'package:swa/features/sign_in/domain/entities/user.dart';

class CitiesStations extends Equatable {
  final int cityID;
  final String cityName;
  final List<StationList> stationList;

  const CitiesStations({
    required this.cityID,
    required this.cityName,
    required this.stationList
  });

  @override
  List<Object?> get props => [
    cityID,
    cityName,
    stationList
  ];
}