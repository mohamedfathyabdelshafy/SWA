import 'package:equatable/equatable.dart';

abstract class ReservationState extends Equatable {
  const ReservationState();
}
class ReservationInitial extends ReservationState {
  @override
  List<Object> get props => [];
}
class GetReservationLoadingState extends ReservationState {
  @override
  List<Object?> get props => [];
}


class ReservationErrorState extends ReservationState {
  final String message;
  const ReservationErrorState({required this.message,});

  @override
  List<Object?> get props => [message];
}

class BusSeatsLoadingState extends ReservationState {
  @override
  List<Object?> get props => [];
}

