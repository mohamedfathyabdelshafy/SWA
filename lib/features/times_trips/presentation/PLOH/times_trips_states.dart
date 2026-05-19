import 'package:equatable/equatable.dart';
import 'package:swa/features/times_trips/data/models/TimesTripsResponsedart.dart';
import 'package:swa/features/times_trips/data/models/companies_model.dart';

abstract class TimesTripsStates extends Equatable {
  get timesTripsResponse => null;
  get companiesList => null;
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

// abstract class CompaniesListStates extends Equatable {
//   get companiesList  => null;
// }

class LoadingCompaniesList extends TimesTripsStates {
  @override
  List<Object?> get props => [];
}

class LoadedCompaniesList extends TimesTripsStates {
  CompaiesModel compaiesModel;
  LoadedCompaniesList({required this.compaiesModel});
  @override
  List<Object?> get props => [];
}

class ErrorCompaniesList extends TimesTripsStates {
  String msg;
  ErrorCompaniesList({required this.msg});
  @override
  List<Object?> get props => [];
}
