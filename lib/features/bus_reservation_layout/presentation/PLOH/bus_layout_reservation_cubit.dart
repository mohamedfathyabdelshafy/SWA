import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:swa/features/bus_reservation_layout/data/models/BusSeatsEditModel.dart';
import 'package:swa/features/bus_reservation_layout/data/models/Reservation_Response_fawry_model.dart';
import 'package:swa/features/bus_reservation_layout/data/repo/bus_reservation_repo.dart';
import '../../../../main.dart';
import '../../data/models/BusSeatsModel.dart';
import 'bus_layout_reservation_states.dart';

class BusLayoutCubit extends Cubit<ReservationState> {
  BusLayoutCubit() : super(ReservationInitial());
  BusLayoutRepo busLayoutRepo = BusLayoutRepo(apiConsumer: sl());
  BusSeatsModel? busSeatsModel;

  BusSeatsEditModel? busSeatsEditModel;
  void getBusSeats({required int tripId, SeatDetails? seat}) async {
    emit(BusSeatsLoadingState());
    await busLayoutRepo.getBusSeatsData(tripId: tripId).then((value) {
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

  void getBusSeatsedit({required int reservationID, SeatDetails? seat}) async {
    emit(BusSeatsLoadingState());
    await busLayoutRepo
        .getReservationSeatsData(reservationID: reservationID)
        .then((value) {
      busSeatsEditModel = value;
      if (seat != null) {
        busSeatsEditModel?.message.busDetailsVm.rowList =
            value.message.busDetailsVm.rowList.map<RowLists>((element) {
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
        value.message.busDetailsVm.rowList.forEach((element) {
          element.seats.forEach((element) {
            print("asdasdasd ${element.seatState}");
          });
        });
      }
    }).catchError((error) {
      print("from cubit  Error ${error.toString()}");
      emit(ReservationErrorState(message: error.toString()));
    });
    emit(ReservationInitial());
  }

  void SaveticketEdit(
      {required int reservationID,
      required List<num> Seatsnumbers,
      double? price}) async {
    emit(BusSeatsLoadingState());
    try {
      final res = await busLayoutRepo.saveticketedit(
          reservationID: reservationID,
          Seatsnumbers: Seatsnumbers,
          price: price!);
      if (res.status == 'success') {
        emit(GetAdReservationLoadedState(reservationResponse: res.massage));
      } else {
        log('ahmed 33');
        emit(ReservationErrorState(message: res.massage!));
      }
    } catch (e) {
      emit(ReservationErrorState(message: e.toString()));
    }
  }

  void seathold({
    required int seatid,
    required int tripid,
  }) async {
    try {
      final res =
          await busLayoutRepo.Seatholdfunction(setid: seatid, tripid: tripid);
      if (res.status == 'success') {
      } else {
        log('ahmed 33');
        emit(ReservationErrorState(message: res.massage!));
      }
    } catch (e) {
      emit(ReservationErrorState(message: e.toString()));
    }
  }

  void Removehold({
    required int tripid,
    required List<num> Seatsnumbers,
  }) async {
    emit(BusSeatsLoadingState());
    try {
      final res = await busLayoutRepo.Removeholdfun(
          tripid: tripid, Seatsnumbers: Seatsnumbers);
      if (res.status == 'success') {
        emit(Setholdstat(reservationResponse: res.massage));
      } else {
        log('ahmed 33');
        emit(ReservationErrorState(message: res.massage!));
      }
    } catch (e) {
      emit(ReservationErrorState(message: e.toString()));
    }
  }
  // Future<ReservationResponseModel?>addReservation({
  //   required List<num> seatIdsOneTrip,
  //   List<int>? seatIdsRoundTrip,
  //   required int custId,
  //   required String oneTripID,
  //   String? roundTripID,
  //   required int paymentMethodID,
  //   required int paymentTypeID,
  //   double? amount,
  //   String? cardNumber,
  //   String? cardExpiryYear,
  //   String? cardExpiryMonth,
  //   String? cvv,
  //   String? mobile,
  // })async {
  //   try{
  //     emit(GetAdReservationLoadingState());
  //     final res = await busLayoutRepo.addReservation(
  //        custId: custId,
  //       oneTripID: oneTripID,
  //       paymentMethodID: paymentMethodID,
  //       paymentTypeID: paymentTypeID,
  //       seatIdsOneTrip: seatIdsOneTrip,
  //       amount: amount,
  //       mobile: mobile,
  //       cvv: cvv,
  //       cardNumber: cardNumber,
  //       cardExpiryYear: cardExpiryYear,
  //       cardExpiryMonth: cardExpiryMonth,
  //       roundTripID: roundTripID,
  //       seatIdsRoundTrip: seatIdsRoundTrip
  //     );
  //     if(res.message != null){
  //       emit(GetAdReservationLoadedState(reservationResponse: res.message));
  //     }else{
  //       emit(GetAdReservationErrorState(mas: res.message.toString()));
  //     }
  //   }catch (e){
  //     emit(GetAdReservationErrorState(mas: e.toString()));
  //   }
  // }
}
