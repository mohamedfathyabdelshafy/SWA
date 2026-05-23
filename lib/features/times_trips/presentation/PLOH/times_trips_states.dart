import 'package:equatable/equatable.dart';
import 'package:swa/features/times_trips/data/models/TimesTripsResponsedart.dart';

abstract class TimesTripsStates extends Equatable {
  get timesTripsResponse => null;
}

class InitialTimesTrips extends TimesTripsStates {
  @override
  List<Object?> get props => [];
}

class LoadingTimesTrips extends TimesTripsStates {
  @override
  List<Object?> get props => [];
}

class LoadedTimesTrips extends TimesTripsStates {
  TimesTripsResponse timesTripsResponse;
  LoadedTimesTrips({required this.timesTripsResponse});
  @override
  List<Object?> get props => [];
}

class ErrorTimesTrips extends TimesTripsStates {
  String msg;
  ErrorTimesTrips({required this.msg});
  @override
  List<Object?> get props => [];
}
