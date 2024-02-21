part of 'get_available_countries_cubit.dart';

abstract class GetAvailableCountriesCubitState {}

class GetAvailableCountriesInitialState
    extends GetAvailableCountriesCubitState {}

class GetAvailableCountriesLoadingState
    extends GetAvailableCountriesCubitState {}

class GetAvailableCountriesLoadedState extends GetAvailableCountriesCubitState {
  final List<Country> countries;

  GetAvailableCountriesLoadedState({required this.countries});
  List<Object> get props => [countries];
}

class GetAvailableCountriesErrorState extends GetAvailableCountriesCubitState {
  final String error;
  GetAvailableCountriesErrorState({required this.error});
  Object get props => error;
}
