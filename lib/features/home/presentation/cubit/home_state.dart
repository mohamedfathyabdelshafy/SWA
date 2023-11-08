part of 'home_cubit.dart';

abstract class HomeState {}

class HomeInitial extends HomeState {}

class GetFromStationsListLoadingState extends HomeState {}
class GetToStationsListLoadingState extends HomeState {}
//ForgotPassword States
class GetFromStationsListLoadedState extends HomeState {
  final MessageResponse messageResponse;
  GetFromStationsListLoadedState({required this.messageResponse});
  List<Object> get props => [messageResponse];
}
class GetToStationsListLoadedState extends HomeState {
  final List<FromStations> toStations;
  GetToStationsListLoadedState({required this.toStations});
  List<Object> get props => [toStations];
}
//Error States
class GetFromStationsListErrorState extends HomeState {
  final Object error;
  GetFromStationsListErrorState({required this.error});
  Object get props => error;
}
class GetToStationsListErrorState extends HomeState {
  final Object error;
  GetToStationsListErrorState({required this.error});
  Object get props => error;
}