import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:swa/features/bus_reservation_layout/data/repo/bus_reservation_repo.dart';

import '../../../../main.dart';
import '../../data/models/BusSeatsModel.dart';
import 'bus_layout_reservation_states.dart';

class ReservationCubit extends Cubit<ReservationState> {
  ReservationCubit() :super(ReservationInitial());
  BusLayoutRepo busLayoutRepo = BusLayoutRepo(apiConsumer: sl());
  BusSeatsModel? busSeatsModel;

  void getBusSeats(
      {required int tripId,
        SeatDetails? seat}) async {
    emit(BusSeatsLoadingState());
    await busLayoutRepo.getBusSeatsData().then((value) {
      busSeatsModel = value;
      if (seat != null) {
        busSeatsModel?.busSeatDetails?.busDetails?.rowList =
            value.busSeatDetails?.busDetails?.rowList?.map<RowList>((element) {
              element.seats.map<SeatDetails?>((element) {
                if (element.seatBusID == seat.seatBusID) {
                  element = seat;
                  element.seatState = element.getSeatState;
                  print("asdvasv ${element.seatBusID} ${element.seatState}");
                }
                return element;
              }).toList();
              return element;
            }).toList();
        value.busSeatDetails?.busDetails?.rowList?.forEach((element) {
          element.seats.forEach((element) {
            print("asdasdasd ${element.seatState}");
          });
        });
      }
      // print("asdsd ${busSeatsModel?.busSeatsDetails?.totalReservedSeats}");
    }).catchError((error) {
      print("from cubit  Error ${error.toString()}");
      emit(ReservationErrorState(message: error.toString()));
    });
    emit(ReservationInitial());
  }
}
