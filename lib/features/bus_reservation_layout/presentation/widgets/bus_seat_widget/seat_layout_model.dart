import 'package:equatable/equatable.dart';

import '../../../data/models/BusSeatsModel.dart';

class SeatLayoutStateModel extends Equatable {
  final int rows;
  final int cols;
  final List<List<SeatDetails>> currentSeats;
  final int seatSvgSize;
  final String pathSelectedSeat;
  final String pathUnSelectedSeat;
  final String pathSoldSeat;
  final String pathDisabledSeat;

  const SeatLayoutStateModel({
    required this.rows,
    required this.cols,
    required this.currentSeats,
    this.seatSvgSize = 50,
    required this.pathSelectedSeat,
    required this.pathDisabledSeat,
    required this.pathSoldSeat,
    required this.pathUnSelectedSeat,
  });

  @override
  List<Object?> get props => [
    rows,
    cols,
    seatSvgSize,
    currentSeats,
    pathUnSelectedSeat,
    pathSelectedSeat,
    pathSoldSeat,
    pathDisabledSeat,
  ];
}
/// current state of a seat
enum SeatState {
  /// current user selected this seat
  selected,

  /// current user has not selected this seat yet,
  /// but it is available to be booked
  available,

  /// this seat is already sold to other user
  sold,

  /// empty area e.g. aisle, staircase etc
  empty,
}