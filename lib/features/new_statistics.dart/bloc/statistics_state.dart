part of 'statistics_bloc.dart';

abstract class StatisticsState extends Equatable {
  const StatisticsState();

  @override
  List<Object> get props => [];
}

class Loading extends StatisticsState {}

class StatisticsInitial extends StatisticsState {}

class MainstatisticsState extends StatisticsState {
  final MainStaticsModel? mainStaticsModel;
  MainstatisticsState({this.mainStaticsModel});
}

class AllstatisticsState extends StatisticsState {
  final AllStaticsModel? allStaticsModel;
  AllstatisticsState({this.allStaticsModel});
}

class ReservationdetailsState extends StatisticsState {
  final ReservationDetailsModel? reservationdetailsModel;
  Reservation? reservation;
  ReservationdetailsState({this.reservationdetailsModel, this.reservation});
}
