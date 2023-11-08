import 'package:equatable/equatable.dart';
import 'package:swa/features/home/domain/entities/cities_stations.dart';

class HomeMessageResponse extends Equatable {
  final String? message;
  final String? status;
  final List<CitiesStations>? citiesStations;
  final dynamic balance;
  final dynamic object;
  final dynamic obj;

  const HomeMessageResponse({
    this.message,
    this.status,
    this.citiesStations,
    this.balance,
    this.object,
    this.obj,
  });


  @override
  List<Object?> get props => [
    message,
    status,
    balance,
    object,
    obj,
  ];
}