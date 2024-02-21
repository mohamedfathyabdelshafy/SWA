part of 'get_available_country_cities_cubit.dart';

abstract class GetAvailableCountryCitiesCubitState {}

class GetAvailableCountryCitiesInitialState
    extends GetAvailableCountryCitiesCubitState {}

class GetAvailableCountryCitiesLoadingState
    extends GetAvailableCountryCitiesCubitState {}

class GetAvailableCountryCitiesLoadedState
    extends GetAvailableCountryCitiesCubitState {
  final List<City> countryCities;

  GetAvailableCountryCitiesLoadedState({required this.countryCities});
  List<Object> get props => [countryCities];
}

class GetAvailableCountryCitiesErrorState
    extends GetAvailableCountryCitiesCubitState {
  final String error;
  GetAvailableCountryCitiesErrorState({required this.error});
  Object get props => error;
}
