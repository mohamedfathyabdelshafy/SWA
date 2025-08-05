part of 'statistics_bloc.dart';

abstract class StatisticsEvent extends Equatable {
  const StatisticsEvent();

  @override
  List<Object> get props => [];
}

class GetmainstatisticsEvent extends StatisticsEvent {}

class GetAllStatisticsEvent extends StatisticsEvent {}

class getReservationdetailsEvent extends StatisticsEvent {
  int id;
  Reservation reservation;

  getReservationdetailsEvent({required this.id, required this.reservation});
}
