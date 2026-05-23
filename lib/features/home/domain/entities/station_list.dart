import 'package:equatable/equatable.dart';

class StationList extends Equatable {
  final int stationId;
  final String stationName;

  const StationList({
    required this.stationId,
    required this.stationName,
  });

  @override
  List<Object?> get props => [
    stationId,
    stationName
  ];
}