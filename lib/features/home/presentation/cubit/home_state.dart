part of 'home_cubit.dart';

abstract class HomeState {}

class HomeInitial extends HomeState {}

class GetFromStationsListLoadingState extends HomeState {}
class GetToStationsListLoadingState extends HomeState {}
//ForgotPassword States
class GetFromStationsListLoadedState extends HomeState {
  final HomeMessageResponse homeMessageResponse;
  GetFromStationsListLoadedState({required this.homeMessageResponse});
  List<Object> get props => [homeMessageResponse];
}
class GetToStationsListLoadedState extends HomeState {
  final HomeMessageResponse homeMessageResponse;
  GetToStationsListLoadedState({required this.homeMessageResponse});
  List<Object> get props => [homeMessageResponse];
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