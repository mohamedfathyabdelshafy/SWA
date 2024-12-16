part of 'umra_bloc.dart';

abstract class UmraEvent extends Equatable {
  const UmraEvent();

  @override
  List<Object> get props => [];
}

class TripUmraTypeEvent extends UmraEvent {}

class GetcityEvent extends UmraEvent {}

class GetcampainEvent extends UmraEvent {}

class GetcampaginsListEvent extends UmraEvent {
  String date, city, campain;
  GetcampaginsListEvent(
      {required this.campain, required this.city, required this.date});
}
