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
  const ReservationErrorState({
    required this.message,
  });

  @override
  List<Object?> get props => [message];
}

class BusSeatsLoadingState extends ReservationState {
  @override
  List<Object?> get props => [];
}

class GetAdReservationLoadingState extends ReservationState {
  @override
  List<Object?> get props => [];
}

class GetAdReservationLoadedState extends ReservationState {
  String? reservationResponse;
  GetAdReservationLoadedState({required this.reservationResponse});
  @override
  List<Object?> get props => [];
}

class Setholdstat extends ReservationState {
  String? reservationResponse;
  Setholdstat({required this.reservationResponse});
  @override
  List<Object?> get props => [];
}

class GetAdReservationErrorState extends ReservationState {
  String? mas;
  GetAdReservationErrorState({required this.mas});
  @override
  List<Object?> get props => [];
}
